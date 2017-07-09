class Micropost < ApplicationRecord
  belongs_to :user

  scope :feed_by_user, -> id{where("user_id = #{id}").order created_at: :desc}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.models.microposts.size_post}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.models.microposts.size_bit.megabytes
      errors.add :picture, t(".should_be_less_than_5mb")
    end
  end
end
