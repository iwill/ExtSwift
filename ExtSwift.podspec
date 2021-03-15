Pod::Spec.new do |s|
    
    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name          = "ExtSwift"
    s.version       = "0.0.11"
    s.summary       = "Extensions for Swift"
    # s.description   = "Extensions for Swift."
    s.homepage      = "https://github.com/iwill/ExtSwift"
    
    # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.license       = "MIT"
    s.author        = { "Mr. Ming" => "i+ExtSwift@iwill.im" }
    s.social_media_url = "https://iwill.im/about/"
    
    # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.deployment_target = "9.0"
    s.tvos.deployment_target = "9.0"
    s.osx.deployment_target = "10.11"
    s.watchos.deployment_target = "2.0"
    s.swift_version = "5.0"
    
    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.source        = { :git => "https://github.com/iwill/ExtSwift.git", :tag => s.version.to_s }
    
    # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    # s.source_files  = "Sources", "Sources/**/*.{swift}"
    # s.exclude_files = "Sources/Exclude"
    # s.public_header_files = "Sources/**/*.h"
    
    # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    # s.resource      = "icon.png"
    # s.resources     = "Resources/*.png"
    # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
    
    # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.framework     = "Foundation"
    # s.frameworks    = "Foundation", "UIKit", "WebKit", "CoreGraphics"
    # s.library       = "iconv"
    # s.libraries     = "iconv", "xml2"
    
    # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    # s.xcconfig      = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
    # s.dependency "ExCodable", "~> 0.2.0"
    
    # ――― Subspecs ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    
    s.default_subspecs = ["ExtSwift"]
    
    s.subspec "ExtSwift" do |ss|
        ss.source_files  = "Sources/**/*.swift"
        ss.exclude_files = [
            "Sources/**/KVO.swift",
            "Sources/**/NameSpace.swift",
            "Sources/**/WeakArray.swift"
        ]
        ss.dependency "ExtSwift/KVO"
        ss.dependency "ExtSwift/NameSpace"
        ss.dependency "ExtSwift/WeakArray"
    end
    
    s.subspec "KVO" do |ss|
        ss.source_files  = "Sources/**/KVO.swift"
        ss.dependency "ExtSwift/WeakArray"
    end
    
    s.subspec "NameSpace" do |ss|
        ss.source_files  = "Sources/**/NameSpace.swift"
    end
    
    s.subspec "WeakArray" do |ss|
        ss.source_files  = "Sources/**/WeakArray.swift"
    end
    
end
