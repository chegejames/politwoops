AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.fog_directory = 'cfa-politwoops-ke'
  config.fog_region = 'eu-west-1'

  # https://console.aws.amazon.com/iam/home?region=us-east-1#users/rails_asset_sync
  # User: rails_asset_sync
  config.aws_access_key_id = ENV['access_key_id']
  config.aws_secret_access_key = ENV['secret_access_key']

  # mimetype sometimes barfs on the things we gzip'd, so just explicitly set
  # content_type on everything we gzip (in lib/tasks/assets.rake)
  config.custom_headers = {
    '.js' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'application/javascript' },
    '.css' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'text/css' },
    '.html' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'text/html' },
    '.svg' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'image/svg+xml' },
    '.json' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'application/json' },
    '.ttf' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'application/x-font-truetype' },
    '.woff' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'application/font-woff' },
    '.eot' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'application/vnd.ms-fontobject' },
    '.txt' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'text/plain' },
    '.csv' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'text/plain' },
    '.rtf' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'text/richtext' },
    '.pdf' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'application/pdf' },
    '.png' => { cache_control: 'public, max-age=31536000', expires: nil, content_type: 'image/png' },
    '.*' => { cache_control: 'public, max-age=31536000', expires: nil },
  }

  # Don't delete files from the store
  config.existing_remote_files = 'keep'

  # Use .gz versions of files. (This uploads that in place of the non-gz version
  # and sets "Content-Encoding: gzip" header on everything. Basically no browser
  # should barf on this.)
  config.gzip_compression = true

  # Don't auto-run on "assets:precompile"
  # https://github.com/rumblelabs/asset_sync/blob/v1.1.0/lib/tasks/asset_sync.rake
  # what we're gonna do is do assets:precompile assets:gzip assets:sync
  # manually, so that we ensure that the compress happens before upload.
  # (otherwise order is compile-upload-compress)
  config.run_on_precompile = false
end
