class Identity < ApplicationRecord
  belongs_to :user
  # validates_presence_of :uid, :provider, :url
  # validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    url = auth.info.urls.public_profile if auth.provider == 'linkedin'
    url = auth.extra.raw_info.profile if auth.provider == 'google'
    url = auth.info.urls.Twitter if auth.provider == 'twitter'
    url = "https://www.facebook.com/#{auth.info.name.gsub(/\s+/, "")}" if auth.provider == 'facebook'
    find_or_create_by(uid: auth.uid, provider: auth.provider, url: url)
  end
end
