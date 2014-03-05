//
//  SBHStoryboardCollection.m
//  StoryboardHelper
//
//  Created by hirai.yuki on 2014/02/25.
//  Copyright (c) 2014年 hirai.yuki. All rights reserved.
//
//  This plug-in was created in reference to Lin-Xcode5.
//
//  Lin-Xcode5 is:
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//  (https://github.com/questbeat/Lin-Xcode5)
//

#import "SBHStoryboardCollection.h"

// Models
#import "SBHViewControllerElement.h"
#import "SBHSegueElement.h"

// View Controller Tag Names
static NSString * const SBHStoryboardCollectionViewControllerTagName = @"viewController";
static NSString * const SBHStoryboardCollectionTableViewControllerTagName = @"tableViewController";
static NSString * const SBHStoryboardCollectionNavigationControllerTagName = @"navigationController";
static NSString * const SBHStoryboardCollectionTabBarControllerTagName = @"tabBarController";
static NSString * const SBHStoryboardCollectionCollectionViewControllerTagName = @"collectionViewController";
static NSString * const SBHStoryboardCollectionPageViewControllerTagName = @"pageViewController";
static NSString * const SBHStoryboardCollectionGLKViewControllerTagName = @"glkViewController";

// View Controller Attribute Names
static NSString * const SBHStoryboardCollectionStoryboardIdentifierAttributeName = @"storyboardIdentifier";
static NSString * const SBHStoryboardCollectionViewControllerCustomClassAttributeName = @"customClass";
static NSString * const SBHStoryboardCollectionViewControllerIdAttributeName = @"id";

// Segue Tag Names
static NSString * const SBHStoryboardCollectionSegueTagName = @"segue";

// Segue Attribute Names
static NSString * const SBHStoryboardCollectionSegueIdentifierAttributeName = @"identifier";
static NSString * const SBHStoryboardCollectionSegueKindAttributeName = @"kind";
static NSString * const SBHStoryboardCollectionSegueAnimatesAttributeName = @"animates";
static NSString * const SBHStoryboardCollectionSegueModalTransitionStyleAttributeName = @"modalTransitionStyle";
static NSString * const SBHStoryboardCollectionSegueCustomClassAttributeName = @"customClass";
static NSString * const SBHStoryboardCollectionSegueIdAttributeName = @"id";

// Segue Kind Values
static NSString * const SBHStoryboardCollectionSegueKindPush = @"push";
static NSString * const SBHStoryboardCollectionSegueKindModal = @"modal";
static NSString * const SBHStoryboardCollectionSegueKindCustom = @"custom";
static NSString * const SBHStoryboardCollectionSegueKindUnwind = @"unwind";


@interface SBHStoryboardCollection () <NSXMLParserDelegate>

@property (nonatomic, copy, readwrite) NSString *filePath;
@property (nonatomic, copy, readwrite) NSString *languageDesignation;

@property (nonatomic, strong, readwrite) NSMutableSet *viewControllerElements;
@property (nonatomic, strong, readwrite) NSMutableSet *segueElements;

@property (nonatomic, strong, readwrite) SBHViewControllerElement *currentViewControllerElement;

@end

@implementation SBHStoryboardCollection

+ (instancetype)storyboardCollectionWithContentsOfFile:(NSString *)filePath
{
    return [[self alloc] initWithContentsOfFile:filePath];
}

- (instancetype)initWithContentsOfFile:(NSString *)filePath
{
    self = [super init];
    
    if (self) {
        self.filePath = filePath;
        
        // Extract language designation
        NSArray *pathComponents = [filePath pathComponents];
        self.languageDesignation = [[pathComponents objectAtIndex:pathComponents.count - 2] stringByDeletingPathExtension];
        
        // Update
        [self reloadViewControllerElements];
    }
    
    return self;
}

- (NSArray *)viewControllerTags
{
    static NSArray *_viewControllerTags = nil;
    if (!_viewControllerTags) {
        _viewControllerTags = @[
                                SBHStoryboardCollectionViewControllerTagName,
                                SBHStoryboardCollectionTableViewControllerTagName,
                                SBHStoryboardCollectionNavigationControllerTagName,
                                SBHStoryboardCollectionTabBarControllerTagName,
                                SBHStoryboardCollectionCollectionViewControllerTagName,
                                SBHStoryboardCollectionPageViewControllerTagName,
                                SBHStoryboardCollectionGLKViewControllerTagName,
                                ];
    }
    
    return _viewControllerTags;
}

- (NSArray *)segueKinds
{
    static NSArray *_segueKinds = nil;
    if (!_segueKinds) {
        _segueKinds = @[
                        SBHStoryboardCollectionSegueKindPush,
                        SBHStoryboardCollectionSegueKindModal,
                        SBHStoryboardCollectionSegueKindCustom,
                        SBHStoryboardCollectionSegueKindUnwind,
                        ];
    }
    
    return _segueKinds;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p; filePath = %@; languageDesignation = %@; viewControllerElements = %@; segueElements = %@>",
            NSStringFromClass([self class]),
            self,
            self.filePath,
            self.languageDesignation,
            self.viewControllerElements,
            self.segueElements
            ];
}


#pragma mark - Accessors

- (NSString *)fileName
{
    return [self.filePath lastPathComponent];
}


#pragma mark - Managing StoryboardIdentifiers

- (void)reloadViewControllerElements
{
    self.viewControllerElements = [NSMutableSet set];
    self.segueElements = [NSMutableSet set];
    
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    parser.delegate = self;
    [parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([[self viewControllerTags] containsObject:elementName]) {
        self.currentViewControllerElement = [self parseViewControllerElementWithName:elementName
                                                                          attributes:attributeDict];
        [self.viewControllerElements addObject:self.currentViewControllerElement];
    } else {
        NSString *kindValue = attributeDict[SBHStoryboardCollectionSegueKindAttributeName];

        if ([[self segueKinds] containsObject:kindValue]) {
            SBHSegueElement *segueElement = [self parseSegueElementWithName:elementName
                                                                 attributes:attributeDict];
            [self.segueElements addObject:segueElement];
        }
    }
}

- (SBHViewControllerElement *)parseViewControllerElementWithName:(NSString *)elementName
                                                      attributes:(NSDictionary *)attributeDict
{
    NSString *storyboardIdentifier = attributeDict[SBHStoryboardCollectionStoryboardIdentifierAttributeName];
    NSString *customClass = attributeDict[SBHStoryboardCollectionViewControllerCustomClassAttributeName];
    NSString *identifier = attributeDict[SBHStoryboardCollectionViewControllerIdAttributeName];
    
    SBHViewControllerElementType type;
    if ([elementName isEqualToString:SBHStoryboardCollectionViewControllerTagName]) {
        type = SBHViewControllerElementTypeViewController;
    } else if ([elementName isEqualToString:SBHStoryboardCollectionTableViewControllerTagName]) {
        type = SBHViewControllerElementTypeTableViewController;
    } else if ([elementName isEqualToString:SBHStoryboardCollectionNavigationControllerTagName]) {
        type = SBHViewControllerElementTypeNavigationController;
    } else if ([elementName isEqualToString:SBHStoryboardCollectionTabBarControllerTagName]) {
        type = SBHViewControllerElementTypeTabBarController;
    } else if ([elementName isEqualToString:SBHStoryboardCollectionCollectionViewControllerTagName]) {
        type = SBHViewControllerElementTypeCollectionViewController;
    } else if ([elementName isEqualToString:SBHStoryboardCollectionPageViewControllerTagName]) {
        type = SBHViewControllerElementTypePageViewController;
    } else if ([elementName isEqualToString:SBHStoryboardCollectionGLKViewControllerTagName]) {
        type = SBHViewControllerElementTypeGLKViewController;
    } else {
        type = SBHViewControllerElementTypeUnknown;
    }
    
    return [SBHViewControllerElement viewControllerElementWithStoryboardIdentifier:storyboardIdentifier
                                                                              type:type
                                                                       customClass:customClass
                                                                        identifier:identifier
                                                                        collection:self];
}

- (SBHSegueElement *)parseSegueElementWithName:(NSString *)elementName
                                    attributes:(NSDictionary *)attributeDict
{
    NSString *segueIdentifier = attributeDict[SBHStoryboardCollectionSegueIdentifierAttributeName];
    NSNumber *animates = @(![attributeDict[SBHStoryboardCollectionSegueAnimatesAttributeName] isEqualToString:@"NO"]);
    NSString *modalTransitionStyle = attributeDict[SBHStoryboardCollectionSegueModalTransitionStyleAttributeName];
    NSString *customClass = attributeDict[SBHStoryboardCollectionSegueCustomClassAttributeName];
    NSString *identifier = attributeDict[SBHStoryboardCollectionSegueIdAttributeName];
    
    SBHSegueElementKind kind;
    NSString *kindValue = attributeDict[SBHStoryboardCollectionSegueKindAttributeName];
    if ([kindValue isEqualToString:SBHStoryboardCollectionSegueKindPush]) {
        kind = SBHSegueElementKindPush;
    } else if ([kindValue isEqualToString:SBHStoryboardCollectionSegueKindModal]) {
        kind = SBHSegueElementKindModal;
    } else if ([kindValue isEqualToString:SBHStoryboardCollectionSegueKindCustom]) {
        kind = SBHSegueElementKindCustom;
    } else if ([kindValue isEqualToString:SBHStoryboardCollectionSegueKindUnwind]) {
        kind = SBHSegueElementKindUnwind;
    } else {
        kind = SBHSegueElementKindUnknown;
    }
    
    return [SBHSegueElement segueElementWithSegueIdentifier:segueIdentifier
                                                       kind:kind
                                                   animates:animates
                                       modalTransitionStyle:modalTransitionStyle
                                                customClass:customClass
                                                 identifier:identifier
                                      viewControllerElement:self.currentViewControllerElement
                                                 collection:self];
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    result = prime * result + [self.filePath hash];
    result = prime * result + [self.languageDesignation hash];
    result = prime * result + [self.viewControllerElements hash];
    
    return result;
}

@end
