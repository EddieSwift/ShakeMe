# ShakeMe

> This app helps users to find answers by shaking their iPhones. 
> And also users can add their custom answers. Each time the color of the answer changes.
> Amount of shake actions saving to KeyChain

## Conventions
- You should use  MVVM architecture
- All images should be stored inside `Assets\Images` inappropriate subfolder (note: when creating a new folder in assets you must check "Provide namespace" in order to make it appear correctly in SwiftGen's generated class)
- All strings must be localized and added to `Localizable` file
- All colors should be stored inside `Assets\Colors` (note: colors naming obtained with Sip color picker tool; in order to prevent colors duplications it should be used by all teammates)
- The files structure on the disk should correspond to the file structure in Xcode (do not forget to order your files alphabetically once created)
- You should use SnapKit for `Autolayout`
- Now the layout is from the code and you have to define a layout for your views in the code too
- You should use model-service-facade/data provider or model-facade/data provider flow to "talk" with database and server
- All somehow complicated code should have appropriate explanatory comments

### Requirements
- Xcode 11.1 or later
- CocoaPods 1.8.3 or later

### Setup
- Download the source code or clone the repository.
- Instal pods using Terminal
