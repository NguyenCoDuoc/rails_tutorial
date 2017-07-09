class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_by, ->{order created_at: :desc}
  scope :feed_by_user, -> following_ids, id do
    where "user_id IN (:following_ids) OR user_id = :user_id",
      following_ids: following_ids, user_id: id
  end

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
