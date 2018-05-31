Pod::Spec.new do |s|
s.name = 'XHSegmentedView'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'a simple and anmited segmentedView'
s.homepage = 'https://github.com/iOSXH/XHSegmentedView'
s.authors = { 'iOSXH' => '1032670387@qq.com' }
s.source = { :git => "https://github.com/iOSXH/XHSegmentedView.git", :tag => "1.0.0"}
s.requires_arc = true
s.ios.deployment_target = '6.0'
s.source_files = "XHSegmentedView", "*.{h,m}"
end