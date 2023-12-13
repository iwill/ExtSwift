Pod::Spec.new do |s|
    
    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name          = "ExtSwift"
    s.version       = "2.0.0-dev"
    s.summary       = "Extensions for Swift"
    # s.description   = "Extensions for Swift."
    s.homepage      = "https://github.com/iwill/ExtSwift"
    
    # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.license       = "MIT"
    s.author        = { "Mr. Míng" => "i+ExtSwift@iwill.im" }
    s.social_media_url = "https://iwill.im/about/"
    
    # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.deployment_target = "12.0"
    s.tvos.deployment_target = "12.0"
    s.osx.deployment_target = "10.14"
    s.watchos.deployment_target = "5.0"
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
        ss.source_files  = "Sources/**/ExtSwift.swift"
        ss.dependency "ExtSwift/boolValue"
        ss.dependency "ExtSwift/KVO"
        ss.dependency "ExtSwift/Mutable"
        ss.dependency "ExtSwift/NameSpace"
        ss.dependency "ExtSwift/nonEmpty"
        ss.dependency "ExtSwift/Operators"
        ss.dependency "ExtSwift/SemanticVersion"
        ss.dependency "ExtSwift/String+intIndex"
        ss.dependency "ExtSwift/tryIndex"
        ss.dependency "ExtSwift/Types"
        ss.dependency "ExtSwift/WeakArray"
        ss.dependency "ExtSwift/UIKit"
    end
    
    s.subspec "Common" do |ss|
        # ss.source_files  = "Sources/**/ExtSwift.swift"
        ss.dependency "ExtSwift/boolValue"
        # ss.dependency "ExtSwift/KVO"
        ss.dependency "ExtSwift/Mutable"
        # ss.dependency "ExtSwift/NameSpace"
        ss.dependency "ExtSwift/nonEmpty"
        ss.dependency "ExtSwift/Operators"
        # ss.dependency "ExtSwift/SemanticVersion"
        ss.dependency "ExtSwift/String+intIndex"
        ss.dependency "ExtSwift/tryIndex"
        ss.dependency "ExtSwift/Types"
        # ss.dependency "ExtSwift/WeakArray"
        ss.dependency "ExtSwift/UIKit"
        # ss.dependency "ExtSwift/ESDiffableDataSource"
    end
    
    s.subspec "Unstable" do |ss|
        ss.source_files  = "Sources/ExtSwift/unstable/*.swift"
        ss.dependency "ExtSwift/ExtSwift"
    end
    
    s.subspec "boolValue" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/boolValue.swift"
    end
    
    s.subspec "KVO" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/KVO.swift"
        ss.dependency "ExtSwift/WeakArray"
    end
    
    s.subspec "Mutable" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/Mutable.swift"
    end
    
    s.subspec "NameSpace" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/NameSpace.swift"
    end
    
    s.subspec "nonEmpty" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/nonEmpty.swift"
    end
    
    s.subspec "Operators" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/Operators.swift"
        ss.dependency "ExtSwift/boolValue"
    end
    
    s.subspec "SemanticVersion" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/SemanticVersion.swift"
    end
    
    s.subspec "String+intIndex" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/String+intIndex.swift"
    end
    
    s.subspec "tryIndex" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/tryIndex.swift"
    end
    
    s.subspec "Types" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/Types.swift"
    end
    
    s.subspec "WeakArray" do |ss|
        ss.source_files  = "Sources/ExtSwift/**/WeakArray.swift"
    end
    
    s.subspec "UIKit" do |ss|
        ss.source_files  = "Sources/ExtSwift/UIKit/*.swift"
        ss.dependency "ExtSwift/Mutable"
        ss.dependency "ExtSwift/NameSpace"
        ss.dependency "ExtSwift/tryIndex"
    end
    
    s.subspec "ESDiffableDataSource" do |ss|
        ss.source_files  = "Sources/ExtSwift/UIKit/ESDiffableDataSource/*.swift"
        ss.dependency "ExtSwift/tryIndex"
    end
    
end
