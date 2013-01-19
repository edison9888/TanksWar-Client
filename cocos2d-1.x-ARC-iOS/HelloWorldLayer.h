//
//  HelloWorldLayer.h
//  cocos2d-1.x-ARC-iOS
//
//  Created by Steffen Itterheim on 23.07.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Pomelo.h"
#import "AppDelegate.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer<PomeloDelegate>
{
    
    CGPoint Tpoint;
    CCSprite *selSprite;
    NSMutableArray *tagSprites;
    NSMutableArray *buildingSprites;
    
    NSString *host;//connection服务器的host
    NSInteger port;//connection服务器的port
    NSString *name;//当前用户的用户名
    NSString *channel;//频道
    
    NSArray *resources;
    
    
    
}


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@property (weak, nonatomic) Pomelo *pomelo;
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *channel;
@end