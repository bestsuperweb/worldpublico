class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  mount_uploader :avatar, AvatarUploader
  # attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  # after_update :crop_avatar

  # def crop_avatar
  #   avatar.recreate_versions! if crop_x.present?
  # end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end


  # Include default devise modules. Others available are: :confirmable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,  :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :database_authenticatable, :validatable, password_length: 8..128

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email


      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.info.name,
          # username: auth.info.nickname || auth.uid,
          # avatar: auth.info.image,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
