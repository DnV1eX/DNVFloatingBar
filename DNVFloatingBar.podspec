Pod::Spec.new do |s|

  s.name         = "DNVFloatingBar"
  s.version      = "0.4"
  s.summary      = "Floating rounded bar with buttons for iOS apps."

  s.description  = <<-DESC
DNVFloatingBar is a control that displays buttons in a rounded panel that floats above the keyboard.
                   DESC

  s.homepage     = "https://github.com/DnV1eX/DNVFloatingBar"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE.txt" }
  s.author       = { "Alexey Demin" => "dnv1ex@ya.ru" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DnV1eX/DNVFloatingBar.git", :tag => "#{s.version}" }
  s.source_files = "DNVFloatingBar"
  s.requires_arc = true
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "3.0" }

end
