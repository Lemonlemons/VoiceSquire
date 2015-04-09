class Quest < ActiveRecord::Base
  mount_uploader :picture1, PictureUploader
  mount_uploader :picture2, PictureUploader
  mount_uploader :picture3, PictureUploader
  mount_uploader :proof1, PictureUploader
  mount_uploader :proof2, PictureUploader
  mount_uploader :proof3, PictureUploader
end
