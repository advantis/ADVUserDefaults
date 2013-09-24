`ADVUserDefaults` is a `NSUserDetaults` wrapper that simplifies and formalizes usage of the defaults system in your app. Please see DemoApp project for more details.

##Features

- supports both manual reference counting and ARC
- supports all data types supported by `NSUserDefaults`
- you can specify custom key names for your properties

##Usage

1. Add `ADVUserDefaults` to your project
2. Create an `ADVUserDefaults` subclass and declare the properties you need to store in the defaults system as @dynamic
3. Viola! There's no "step 3". You can now use your subclass to store/retrieve user defaults data.

##Subclassing notes

If you override `+[NSObject initialize]` method in your subclass (for example, to provide an initial dataset for registration domain), please be sure that you call `[super initialize]` because `ADVUserDefaults` must perform its initial setup in context of your subclass.

##Min OS requirements

iOS 4.3 or Mac OS X 10.7 (iOS 2.0 or Mac OS X 10.5 in version tagged as 'legacy')

##License

`ADVUserDefaults` is available under the MIT license. See the LICENSE file for more info.