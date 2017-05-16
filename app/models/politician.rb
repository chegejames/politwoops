# encoding: utf-8
require "open-uri"
require 'gender_detector'

class Politician < ActiveRecord::Base
  CollectingAndShowing = 1
  CollectingNotShowing = 2
  NotCollectingOrShowing = 3
  NotCollectingButShowing = 4

  STATES =
    {
      "AK": "Alaska",
      "AL": "Ala.",
      "AR": "Ark.",
      "AS": "American Samoa",
      "AZ": "Ariz.",
      "CA": "Calif.",
      "CO": "Colo.",
      "CT": "Conn.",
      "DC": "D.C.",
      "DE": "Del.",
      "FL": "Fla.",
      "GA": "Ga.",
      "GU": "Guam",
      "HI": "Hawaii",
      "IA": "Iowa",
      "ID": "Idaho",
      "IL": "Ill.",
      "IN": "Ind.",
      "KS": "Kan.",
      "KY": "Ky.",
      "LA": "La.",
      "MA": "Mass.",
      "MD": "Md.",
      "ME": "Maine",
      "MI": "Mich.",
      "MN": "Minn.",
      "MO": "Mo.",
      "MP": "Northern Marina Islands",
      "MS": "Miss.",
      "MT": "Mont.",
      "NC": "N.C.",
      "ND": "N.D.",
      "NE": "Neb.",
      "NH": "N.H.",
      "NJ": "N.J.",
      "NM": "N.M.",
      "NV": "Nev.",
      "NY": "N.Y.",
      "OH": "Ohio",
      "OK": "Okla.",
      "OR": "Ore.",
      "PA": "Pa.",
      "PR": "Puerto Rico",
      "RI": "R.I.",
      "SC": "S.C.",
      "SD": "S.D.",
      "TN": "Tenn.",
      "TX": "Texas",
      "UT": "Utah",
      "VA": "Va.",
      "VI": "Virgin Islands",
      "VT": "Vt.",
      "WA": "Wash.",
      "WI": "Wis.",
      "WV": "W.Va.",
      "WY": "Wyo."
    }

  def display_state
    STATES[state.to_sym]
  end

  has_attached_file :avatar

  belongs_to :party

  belongs_to :office

  belongs_to :account_type

  has_many :tweets
  has_many :deleted_tweets

  has_many :account_links
  has_many :links, :through => :account_links

  #default_scope :order => 'user_name'

  scope :active, -> { where status: [1, 4]}
  scope :collecting, -> { where status: [CollectingAndShowing, CollectingNotShowing] }
  scope :showing, -> { where status: [CollectingAndShowing, NotCollectingButShowing] }

  validates_uniqueness_of :user_name, :case_sensitive => false
  do_not_validate_attachment_file_type :avatar

  comma do
    user_name              'user_name'
    twitter_id             'twitter_id'
    party :display_name => 'party_name'
    state                  'state'
    office :title       => 'office_title'
    account_type :name  => 'account_type'
    first_name             'first_name'
    middle_name            'middle_name'
    last_name              'last_name'
    suffix                 'suffix'
    status                 'status'
    collecting?            'collecting'
    showing?               'showing'
    bioguide_id            'bioguide_id'
    opencivicdata_id       'opencivicdata_id'
  end

  def collecting?
    [CollectingAndShowing, CollectingNotShowing].include?(status)
  end

  def showing?
    [CollectingAndShowing, NotCollectingButShowing].include?(status)
  end

  def self.guess_gender(name)
    # Each SexMachine::Detector instance loads it's own copy of the data file.
    # Let's avoid going memory crazy.
    @_sexmachine__detector ||= GenderDetector.new
    @_sexmachine__detector.get_gender(name)
  end

  def guess_gender!
    gender_value = Politician.guess_gender(first_name)
    gender_map = { :male => 'M', :female => 'F' }
    gender_value = gender_map[gender_value]
    if gender_value
      self.gender = gender_value
      save!
    end
  end

  def male?
    gender == 'M'
  end

  def female?
    gender == 'F'
  end

  def ungendered?
    !(male? || female?)
  end

  def self.ungendered
    where(:gender => 'U')
  end

  def twitter_user_url
    "https://www.twitter.com/#{user_name}/"
  end

  def display_name
    return [first_name, middle_name, last_name, suffix].join(' ').strip
  end

  def full_name
    return [office && office.abbreviation, first_name, last_name, suffix].join(' ').strip
  end

  def add_related_politicians(other_names)
    other_names.each do |other_name|
      if not other_name.empty? && other_name != self.user_name
        other_pol = Politician.find_by_user_name(other_name)
        self.links << other_pol
        self.save!
      end
    end
  end

  def remove_related_politicians(other_names)
    other_names.each do |other_name|
      if not other_name.empty? && other_name != self.user_name
        other_pol = Politician.find_by_user_name(other_name)
        AccountLink.where(politician_id: self.id, link_id: other_pol.id).destroy_all
        AccountLink.where(link_id: self.id, politician_id: other_pol.id).destroy_all
      end
    end
  end

  def get_related_politicians
    links = AccountLink.where("politician_id = ? or link_id = ?", self.id, self.id)

    politician_ids = links.flat_map{ |l| [l.politician_id, l.link_id] }
                          .reject{ |pol_id| pol_id == self.id }
    Politician.where(id: politician_ids)
  end

  def twoops
    deleted_tweets.where(approved: true)
  end

  def reset_avatar(options = {})
    begin
      twitter_user = $twitter.user(user_name)
      image_url = twitter_user.profile_image_url(:bigger)

      force_reset = options.fetch(:force, false)

      if profile_image_url.nil? || (image_url != profile_image_url) || (profile_image_url != avatar.url) || force_reset
        uri = URI::parse(image_url)
        extension = File.extname(uri.path)

        uri.open do |remote_file|
          Tempfile.open(["#{self.twitter_id}_", extension]) do |tmpfile|
            tmpfile.write remote_file.read().force_encoding('UTF-8')
            tmpfile.rewind
            self.avatar = tmpfile
            self.profile_image_url = image_url
            self.save!
          end
        end
      end
      return [true, nil]
    rescue Twitter::Error::Forbidden => e
      return [false, e.to_s]
    rescue Twitter::Error::NotFound
      return [false, "No such user name: #{user_name}"]
    end
  end
end
