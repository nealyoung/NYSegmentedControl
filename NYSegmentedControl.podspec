#
#  Be sure to run `pod spec lint NYSegmentedControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "NYSegmentedControl"
  s.version      = "1.0.0"
  s.summary      = "Animated, customizable replacement for UISegmentedControl"

  s.description  = <<-DESC
                   A longer description of NYSegmentedControl in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  s.frameworks   = 'QuartzCore'
  s.homepage     = "https://github.com/nealyoung/NYSegmentedControl"
  s.screenshots  = "https://github.com/nealyoung/NYSegmentedControl/raw/master/screenshot-dark.png", "https://github.com/nealyoung/NYSegmentedControl/raw/master/screenshot-light.png"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Neal Young" => "hi@nealyoung.me" }
  s.social_media_url   = "http://twitter.com/nealyoung"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/nealyoung/NYSegmentedControl.git", :commit => "338c2e9c4c1d7766df66f0ce1803145eb027c9a0" }
  s.source_files  = "NYSegmentedControl", "NYSegmentedControl/**/*.{h,m}"
  s.requires_arc = true
end
