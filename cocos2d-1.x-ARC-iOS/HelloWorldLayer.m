//
//  HelloWorldLayer.m
//  War
//
//  Created by mq on 13-1-4.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import<math.h>

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize pomelo;
@synthesize username;
@synthesize password;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
// on "init" you need to initialize your instance
-(id) init
{
    
        
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
               
        playerResource=[[Resources alloc] init];
        [playerResource initialazation];
        CGSize size = [[CCDirector sharedDirector] winSize];
        tagSprites=[[NSMutableArray alloc] init];   
       buildingSprites=[[NSMutableArray alloc] init];
        
		// create and initialize a Label
		//CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
        CCSprite *BackGround=[CCSprite spriteWithFile:@"background.png" rect:CGRectMake(0, 0, 1024, 768)];
        BackGround.anchorPoint=ccp(0, 0);
        [self addChild:BackGround z:1   tag:0];
        
        CCSpriteBatchNode *tags=[CCSpriteBatchNode batchNodeWithFile:@"tags.png" capacity:24];
        
        [self addChild:tags z:2 tag:100];
        for (int y=0; y<4; y++)
            for (int x=0; x<6; x++)
            {
                CCSprite *s=[CCSprite spriteWithBatchNode:tags rect:CGRectMake(0, 0, 64, 64)];
              s.tag=y*6+x+1;
            [s setOpacity:255];
            [tags addChild:s ];
            [s setPosition:ccp(size.width*(2+x)/12, size.height*(3+y)/10)];
                [tagSprites addObject:s ];
        
            }
        
        
        
        
        //pomelo
        username = @"chenyl107";
        password = @"junshi";
        
        
        if ([self initPomelo]) {
            [self connectToPomelo];
        }else{
            NSLog(@"pomelo初始化失败");
        }
        
        
        label=[CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(100, 100) alignment: UIViewAnimationCurveEaseIn fontName:@"Arial" fontSize:16];
        [label setString:[NSString stringWithFormat:@"石油：%i\n粮食：%i\n钢铁：%i\n锡矿：%i",playerResource.Fuel,playerResource.Crop,playerResource.Steel,playerResource.Xi]];
        label.position=ccp(120, 670);
        [self addChild:label z:2 tag:101];
        
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:40  ];
        CCMenuItemFont *militaryArea=[CCMenuItemFont itemFromString:@"资源区" target:self selector:@selector(sceneTransition:) ];
    
        CCMenu *changeScene=[CCMenu menuWithItems:militaryArea, nil];
        [changeScene alignItemsHorizontally];
        [changeScene setPosition:ccp(800, 670)];
        [self addChild:changeScene z:2 tag:102];
         [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        //[self schedule:@selector(addup) interval:1];
        //[self schedule:@selector(labelOfNum) interval:1.5];
        

	}
	return self;
 
}
-(BOOL) initPomelo
{
    //初始化pomelo
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    pomelo = myDelegate.pomelo;
    if (pomelo != nil) {
        return TRUE;
    }else{
        return  FALSE;
    }
}
-(void)connectToPomelo
{
    //连接gate服务器得到分配的connect服务器
    
    [pomelo connectToHost:@"127.0.0.1" onPort:3014 withCallback:^(Pomelo *p){
        NSDictionary *params = [NSDictionary dictionaryWithObject:@"chenyl107" forKey:@"uid"];//uid用于分配connector服务器
        [pomelo requestWithRoute:@"gate.gateHandler.queryEntry" andParams:params andCallback:^(NSDictionary *result){
            
            [pomelo disconnectWithCallback:^(Pomelo *p){
                host = [result objectForKey:@"host"];
                port = [[result objectForKey:@"port"] intValue];
                
                //连接得到的connection服务器
                [pomelo connectToHost:host onPort:port withCallback:^(Pomelo *p){
                    
                    
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            username, @"username",
                                            password, @"password",
                                            nil];
                    [p requestWithRoute:@"connector.entryHandler.enter" andParams:params andCallback:^(NSDictionary *result){
                            NSDictionary *params2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"military", @"category",
                                                     nil];
                            [p requestWithRoute:@"connector.entryHandler.getArchitecture" andParams:params2 andCallback:^(NSDictionary* responseData){
                               
                                
                                resources = [responseData objectForKey:@"Resources"];
                                
                                int count = [resources count];
                                NSLog(@"count:%d",count);
                                for (int i=0; i<count; i++) {
                                    
                                    NSLog(@"chenyl1");
                                    NSDictionary *resource =[resources objectAtIndex:i];
                                    NSNumber *xx = [resource objectForKey:@"pointx"];
                                    NSNumber *yy = [resource objectForKey:@"pointy"];
                                    NSString *pngg = [resource objectForKey:@"png"];
                                    NSString *resid = [resource objectForKey:@"id"];
                                    NSNumber *alevel = [resource objectForKey:@"alevel"];
                                    CGPoint thep = CGPointMake( [xx floatValue],  [yy floatValue]);
                                    
                                    for (CCSprite *sprite in tagSprites)
                                    {
//                                        if(fabs([sprite position].x - thep.x)<1.0)
//                                        {
                                        if( ([sprite position].x == thep.x) &&([sprite position].y == thep.y))
                                        {
                                           
                                            
                                            self.isTouchEnabled=YES;
                                            
                                            CCSprite *Build=[CCSprite spriteWithFile:pngg];
                                            
                                            
                                            //TODO
                                            //美术（毛）把每个建筑做一张带等级的图：1-9级，第10级图像另作
                                            //开发:（孟）根据alevel字段的值判断渲染那张png。比如alebel=1,渲染building1.
                                            //也可不用这样，直接在png中保存当前等级的图，直接渲染，alevel字段暂时搁置，用于判断升级建筑的时候用
                                           
                                            
                                            Build.position=thep;
                                            Build.tag = [resid intValue];
                                           [buildingSprites addObject:Build];
                                            NSLog(@"bullid tag : %d",Build.tag);
                                            
                                            
                                           [self addChild:Build z:3];
                                            
                                            
                                            if ([resid intValue] >maxid) {
                                                maxid = [resid intValue];
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                    
                                }
                                
                                
                                
                                
                            }];
                            
                            
                        
                        
                    }];
                    
                    
                }];
            }];
        }];
    }];
    
    

}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    
    
    CGPoint point;
    point=[self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:point];
    
    return TRUE;

}
-(void)selectSpriteForTouch:(CGPoint) point
{
    for (CCSprite *sprite in buildingSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, point)) {
            NSLog(@"invoke");
            selSprite=sprite;
            [self updateBuilding];
            return;
        }
    }
    for (CCSprite *sprite in tagSprites)
    {
        if (CGRectContainsPoint(sprite.boundingBox, point))
        {
            selSprite=sprite;
            [self ChoicePanel];
            return;
        }
    }
}
-(void)updateBuilding
{
    //self.isTouchEnabled=NO;
    [CCMenuItemFont setFontName:@"Marker Felt"];
    [CCMenuItemFont setFontSize:30];
    CCMenuItemFont  *Delete=[CCMenuItemFont itemFromString:@"拆除" target:self selector:@selector(delete:)];
    CCMenuItemFont *upGrade=[CCMenuItemFont itemFromString:@"升级" target:self selector:@selector(upgrade:)];
    CCMenu *menu=[CCMenu menuWithItems:Delete,upGrade,nil];
    [menu setPosition:ccp(selSprite.position.x+50, selSprite.position.y-50)];
    [menu alignItemsHorizontally];
    [self addChild:menu z:3 tag:103];
}
-(void) ChoicePanel
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *Panel=[CCSprite spriteWithFile:@"panel.png"];
    Panel.position=ccp(size.width/2, size.height/2);
    [self addChild:Panel z:3 tag:3];
    CCSprite *Menu1=[CCSprite spriteWithFile:@"menu1.png"];
    CCSprite *Menu2=[CCSprite spriteWithFile:@"menu2.png"];
    CCMenuItemSprite *menu1=[CCMenuItemSprite itemFromNormalSprite:Menu1 selectedSprite:nil target:self selector:@selector(Choicemenu1:) ];
    CCMenuItemSprite *menu2=[CCMenuItemSprite itemFromNormalSprite:Menu2 selectedSprite:nil target:self selector:@selector(Choicemenu2:)];
    //CCMenuItemSprite *menu3=[CCMenuItemSprite i]
    CCMenu *menu=[CCMenu menuWithItems:menu1,menu2, nil];
    [menu alignItemsVerticallyWithPadding:0];
    [menu setPosition:ccp(size.width/2, size.height/2)];
    [self addChild:menu z:4 tag:4];
}
//选择建筑1
-(void)Choicemenu1:sender
{
    [self removeChildByTag:4 cleanup:YES];
    [self removeChildByTag:3 cleanup:YES];
    self.isTouchEnabled=YES;
    CCSprite *Build=[CCSprite spriteWithFile:@"building1.png"];
    [buildingSprites addObject:Build];
    Build.position=selSprite.position;
    //把最大的maxid+1之后赋值给这个建筑，为了和数据库同步。
    Build.tag = ++maxid;
    
    
    [self addChild:Build z:3];
    
    CGPoint myp = Build.position;
    [self saveToServer:&myp withPng:@"building1.png"];
    
    
}
-(void)Choicemenu2:sender
{
    [self removeChildByTag:4 cleanup:YES];
    [self removeChildByTag:3 cleanup:YES];
    self.isTouchEnabled=YES;
    CCSprite *Build=[CCSprite spriteWithFile:@"building2.png"];
    [buildingSprites addObject:Build];
    Build.position=selSprite.position;
    Build.tag = ++maxid;
    [self addChild:Build z:3];
    
    CGPoint myp = Build.position;
    [self saveToServer:&myp withPng:@"building2.png"];
    
}
-(void)saveToServer:(CGPoint *)point withPng:(NSString *)png
{
    NSLog(@"invoke");
    
   NSNumber *myx = [NSNumber numberWithFloat:point->x];
    NSNumber *myy = [NSNumber numberWithFloat:point->y];
    
    

    
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                username, @"username",
                                password, @"password",
                                myx, @"pointx",
                                myy, @"pointy",
                                png,@"png",
                                @"military",@"category",
                                @"1",@"alevel",
                                nil];
        [pomelo requestWithRoute:@"connector.entryHandler.addArchitecture" andParams:params andCallback:^(NSDictionary *result){
            NSArray *userList = [result objectForKey:@"users"];
            for (NSString *name2 in userList) {
                NSLog(@"%@",name2);
                
                
            }
            
        }];


    
    
}
-(void) labelOfNum
{
   
    [label setString:[NSString stringWithFormat:@"石油：%i\n粮食：%i\n钢铁：%i\n锡矿：%i",playerResource.Fuel,playerResource.Crop,playerResource.Steel,playerResource.Xi]];
}
//删除一个建筑
-(void)delete:(id)sender
{
    NSLog(@"1.%@ tag:%d",selSprite,selSprite.tag);
    
    [self removeChildByTag:103 cleanup:YES];
    
    [selSprite removeFromParentAndCleanup:YES];
    
    
    NSLog(@"3.%@",[self getChildByTag:selSprite.tag]);
    
    [buildingSprites removeObject:selSprite];
    NSNumber *thetag = [NSNumber numberWithInt: selSprite.tag];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            thetag, @"id",
                            nil];
    [pomelo requestWithRoute:@"connector.entryHandler.deleteArchitecture" andParams:params andCallback:^(NSDictionary *result){
       
            NSLog(@"删除成功");
            
            
        
        
    }];

    
    NSLog(@"delete succ");
    
}
-(void)upgrade:(id)sender
{
    [self removeChildByTag:103 cleanup:YES];
    //[self removeChild:selSprite cleanup:YES];
    NSNumber *archID =   [NSNumber numberWithInt:selSprite.tag];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                             archID,@"id",
                             nil];
    
    [pomelo requestWithRoute:@"connector.entryHandler.increaseArchitectureLevel" andParams:params andCallback:^(NSDictionary *result){
        
        NSLog(@"等级提升成功");
        //TODO
        //修改精灵的png文件，文件名+1
        
        
        
    }];
}
-(void)sceneTransition:(id)sender
{
    CCTransitionFade *tran=[CCTransitionFade transitionWithDuration:2 scene:[ResourceScene scene] withColor:ccWHITE];
    [[CCDirector sharedDirector] replaceScene:tran];
}

-(void)addup:(id)sender
{
    [playerResource setCrop:50];
    [playerResource setFuel:50];
    [playerResource setSteel:50];
    [playerResource setXi:50];
}
// on "dealloc" you need to release all your retained objects







@end
