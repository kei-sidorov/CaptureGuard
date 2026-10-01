Pod::Spec.new do |s|
  s.name         = 'CaptureGuardUIKit'
  s.version      = '2.0.0'
  s.summary      = 'UIView subclasses for CaptureGuard. Uses private API.'

  s.description  = <<~DESC
    HiddenOnCaptureView and VisibleOnlyOnCaptureView, usable from code or a storyboard.
    Kept as a separate pod because VisibleOnlyOnCaptureView resolves the private CAFilter
    class by name, which the author flagged as an App Store rejection risk. Apps that do
    not need it should depend on CaptureGuard alone, so the private symbols never reach
    their binary.
  DESC

  s.homepage     = 'https://github.com/kei-sidorov/CaptureGuard'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Kirill Sidorov' => 'https://sidorov.tech' }
  s.source       = { :git => 'https://github.com/kei-sidorov/CaptureGuard.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9']

  s.source_files = 'Sources/CaptureGuardUIKit/**/*.swift'
  s.dependency 'CaptureGuard', '~> 2.0'

  s.frameworks = 'UIKit', 'QuartzCore'
end
