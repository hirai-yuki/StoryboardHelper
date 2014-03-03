# StoryboardHelper
StoryboardHelper is a open source plug-in for **Xcode 5**.  
It lets you search/manage storyboard identifier without opening the .storyboard files.
Using StoryboardHelper's almost the same as [Lin-Xcode5](https://github.com/questbeat/Lin-Xcode5).

## Acknowledgment

StoryboardHelper is inspired by [Lin-Xcode5](https://github.com/questbeat/Lin-Xcode5).

If StoryboardHelper were not for [Lin-Xcode5](https://github.com/questbeat/Lin-Xcode5), would not exist.

I have great respect for the [Katsuma Tanaka@questbeat](https://github.com/questbeat) that created the [Lin-Xcode5](https://github.com/questbeat/Lin-Xcode5).

I am grateful to [Lin-Xcode5](https://github.com/questbeat/Lin-Xcode5) and [Katsuma Tanaka@questbeat](https://github.com/questbeat)!


## Features
When you are focusing on following methods and codes, StoryboardHelper shows the list of storyboard identifier that contains the inputted key string.

### - (id)instantiateViewControllerWithIdentifier:@"<Suggest!>"

![01.png](http://d2wwfe3odivqm9.cloudfront.net/wp-content/uploads/2014/03/storyboardidentifier-vc-1.png)

### - (void)performSegueWithIdentifier:@"<Suggest!>" sender:(id)sender

![02.png](http://d2wwfe3odivqm9.cloudfront.net/wp-content/uploads/2014/03/storyboardidentifier-segue-1.png)

### [segue.identifier isEqualToString:@"<Suggest!>"]

![03.png](http://d2wwfe3odivqm9.cloudfront.net/wp-content/uploads/2014/03/storyboardidentifier-segue-2.png)


## Installation
Download the project and build it, then relaunch Xcode.  
StoryboardHelper's will be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins` automatically.

If you want to uninstall StoryboardHelper's, remove StoryboardHelper's.xcplugin in `Plug-ins` directory.


## Settings
You can enable/disable StoryboardHelper's or show window manually by opening the StoryboardHelper's menu in the Editor menu in Xcode.

![06.png](http://d2wwfe3odivqm9.cloudfront.net/wp-content/uploads/2014/03/storyboardidentifier-1-2.png)


## License
*StoryboardHelper* is released under the **MIT License**, see *LICENSE.txt*.

