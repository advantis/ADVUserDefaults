Pod::Spec.new do |s|

  s.name         = "ADVUserDefaults"
  s.version      = "1.0.0"
  s.summary      = "Easy access to the User Defaults System"
  s.description  = <<-DESC
    `ADVUserDefaults` is a wrapper that simplifies and formalizes usage of the User Defaults System in your app. 
    Subclass it and any declared dynamic properties will be automatically  saved into `NSUserDefaults`.
  DESC

  s.homepage     = "https://github.com/advantis/ADVUserDefaults"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Yuri Kotov" => "yuri.kotov@advantis.pro" }
  s.social_media_url   = "https://twitter.com/advantiss"

  s.ios.deployment_target = "4.3"
  s.osx.deployment_target = "10.7"
  s.requires_arc = false

  s.source       = { :git => "https://github.com/advantis/ADVUserDefaults.git", :tag => "1.0.0" }
  s.source_files = "ADVUserDefaults"

end
