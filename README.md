# Fragments

Fragments is a mobile application that allows students to document and share different aspects of their high school career such as, but not limited to, community service hours, academic achievements, clubs/organizations, etc.

# Sources (Copyright compliance)

## Repositiories: 

### 1. Flutter 
### 2. Firebase
### 5. Facebook iOS SDK 

## Sources: 

1. Facebook SDK - [https://developers.facebook.com/docs/](https://developers.facebook.com/docs/)
2. Apple Documentation - [https://developer.apple.com/documentation/](https://developer.apple.com/documentation/)
3. Undraw - [https://undraw.co/illustrations](https://undraw.co/illustrations)

# Run

1. `cd ios && pod install`
2. `flutter run` or `flutter run --release`

# Help

# Format Dart Code

- `dart format . -l 120`

# Build When Error

1. `rm -rf "$HOME/Library/Developer/Xcode/DerivedData/*"`
2. `rm -rf "$HOME/Library/Caches/CocoaPods"`
3. `rm -rf Pods`  
4. `arch -x86_64 pod update`
