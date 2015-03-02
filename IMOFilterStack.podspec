Pod::Spec.new do |s|
  s.name             = "IMOFilterStack"
  s.version          = "0.1.0"
  s.summary          = "A simple way to create, manage and use CIFilter chains"
  s.description      = <<-DESC
                       IMOFilterStack provides a simple way of asynchronously processing multiple images using a shared CIFilter chain.
                       DESC
  s.homepage         = "https://github.com/ivanmoskalev/IMOFilterStack"
  s.license          = 'MIT'
  s.author           = { "Ivan Moskalev" => "moskalev-ivan@yandex.ru" }
  s.source           = { :git => "https://github.com/ivanmoskalev/IMOFilterStack.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ivanmoskalev'

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit', 'CoreImage'
end
