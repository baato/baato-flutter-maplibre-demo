# baato-flutter-demo

This is a public demo of the Baato App for Flutter. This app shows the way to integrate [Baato](http://baato.io/) map style in flutter using [Maplibre](https://maplibre.org/).

### Running locally

#### 1. Setting the Baato access token
This demo app requires a Baato account and a Baato access token. Obtain your access token on the [Baato account page](http://baato.io/). Paste your access token in the line below in `main.dart` file .

```
 static const String BAATO_ACCESS_TOKEN = "your-baato-access-token";
```
### Note!
1. This example app use flutter-maplibre-gl 
 Follow this readme for guide and setup: https://github.com/m0nac0/flutter-maplibre-gl/blob/main/README.md

2. Some iOS version also require location settings in default, for that goto your `Info.plist file` and set `NSLocationWhenInUseUsageDescription` to:

   > Shows your location on the map and helps improve OpenStreetMap.

3. If you are getting issue with building in simulator, related to arm64 architecture, add the following lines into your `ios>Podfile` installer code block:
### Your podfile look like this

```ruby
source 'https://cdn.cocoapods.org/'
source 'https://github.com/m0nac0/flutter-maplibre-podspecs.git'

# Uncomment this line to define a global platform for your project
platform :ios, '11.0'

pod 'MapLibre'
pod 'MapLibreAnnotationExtension'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
  installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end


4. If you are getting issue with building with error
Failure [INSTALL_PARSE_FAILED_MANIFEST_MALFORMED: Failed   
parse during installPackageLI: Targeting S+ (version 31and above) requires that an explicit value for android:exported be defined when intent filters are present:

Add android:exported="true" in AndroidManifest.xml file which looks as follow:

<application
//some code
>
   <activity
    //other code
     android:exported="true"  //add this line 
    >
    </activity>
    
</application>
```
