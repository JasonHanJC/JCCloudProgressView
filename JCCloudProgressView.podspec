Pod::Spec.new do |s|
  s.name             = 'JCCloudProgressView'
  s.version          = '0.1.1'
  s.summary          = 'A progress indicator with cloud shape and waves.'


  s.description      = <<-DESC
A progress indicator with cloud shape and waves. It is a beautiful progress indicator for showing the data uploading to your server.
                       DESC

  s.homepage         = 'https://github.com/JasonHan1990/JCCloudProgressView'
  s.screenshots      = 'https://raw.githubusercontent.com/JasonHan1990/JCCloudProgressView/master/ExampleImages/JCCloudProgressView.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JasonHan1990' => 'namrie1990@gmail.com' }
  s.source           = { :git => 'https://github.com/JasonHan1990/JCCloudProgressView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JCCloudProgressView/Classes/**/*'

  s.frameworks = 'UIKit'
end
