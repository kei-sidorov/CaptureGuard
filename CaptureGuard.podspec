Pod::Spec.new do |s|
  s.name         = 'CaptureGuard'
  s.version      = '2.0.0'
  s.summary      = 'Hide parts of your UI from screenshots, screen recordings and iPhone Mirroring.'

  s.description  = <<~DESC
    Hides views from screenshots by borrowing the capture exclusion iOS grants a secure
    UITextField and using public KVC to work with its layer. This depends on the text
    field's undocumented internal canvas view. Screen recordings, AirPlay and iPhone
    Mirroring are handled by observing capture state. Works with SwiftUI and UIKit.
  DESC

  s.homepage     = 'https://github.com/kei-sidorov/CaptureGuard'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Kirill Sidorov' => 'https://sidorov.tech' }
  s.source       = { :git => 'https://github.com/kei-sidorov/CaptureGuard.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9']

  # CNotify is a separate SwiftPM target; here it compiles into this one and its header
  # reaches Swift through the generated umbrella header.
  s.source_files        = 'Sources/CNotify/**/*.{c,h}', 'Sources/CaptureGuard/**/*.swift'
  s.public_header_files = 'Sources/CNotify/include/*.h'

  s.frameworks = 'UIKit', 'SwiftUI', 'Combine', 'QuartzCore', 'GameController'
end
