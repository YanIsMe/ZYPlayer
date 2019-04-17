
Pod::Spec.new do |s|

  s.name         = "ZYIPlayer"
  s.version      = "1.0.1"
  s.summary      = "一个播放器架子，完全解耦，任何一部分都可以单独拿来用."
  s.description  = <<-DESC
		   一个播放器架子，完全解耦，任何一部分都可以单独拿来用
                   DESC

  s.homepage     = "https://github.com/YanIsMe/ZYPlayer"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  s.author       = { "、岩" => "761609909@qq.com" }

  s.platform     = :ios, "9.0"


  s.source       = { :git => "https://github.com/YanIsMe/ZYPlayer.git", :tag => s.version }
 s.requires_arc = true

  s.source_files  = "ZYPlayer/ZYPlayerView/**"
  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  s.frameworks = 'UIKit', 'AVFoundation'
  s.ios.vendored_frameworks = 'ZYPlayer/ZYPlayerView/Resources_Lib/IJKMediaFramework.framework'
  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
