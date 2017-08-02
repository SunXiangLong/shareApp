 //
//  HKClipperVeiw.m
//  HKBaseDemo
//
//  Created by hukaiyin on 16/8/9.
//  Copyright © 2016年 hukaiyin. All rights reserved.
//

#import "HKClipperVeiw.h"


static const CGFloat minWidth = 60;
@interface HKClipperVeiw()
@property (nonatomic, strong) UIImageView *clipperView;
@property (nonatomic, strong) UIImageView *baseImgView;

@end

@implementation HKClipperVeiw {
    CGPoint panTouch;
    CGFloat scaleDistance; //缩放距离
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.type =  ClipperTypeImgMove;
        [self loadSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadSubViews];
}

- (void)loadSubViews {
    //    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.contentsGravity = kCAGravityResizeAspect;
}

#pragma mark - Public
- (UIImage *)clipImg {
    
    CGFloat scale = [UIScreen mainScreen].scale * self.baseImgView.image.size.width/self.baseImgView.frame.size.width;
    
    CGRect rect = [self convertRect:self.clipperView.frame toView:self.baseImgView];
    CGRect rect2 = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, scale *rect.size.width, scale * rect.size.height);
    
    CGImageRef cgImg = CGImageCreateWithImageInRect(self.baseImgView.image.CGImage, rect2);
    
    UIImage *clippedImg = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
    
    return clippedImg;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    switch ([allTouches count]) {
        case 1:{
            panTouch = [[allTouches anyObject] locationInView:self];
            break;
        }
        case 2:{
            
            break;
        }
            
        default:
            break;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self willChangeValueForKey:@"crop"];
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count])
    {
        case 1: {
            CGPoint touchCurrent = [[allTouches anyObject] locationInView:self];
            CGFloat x = touchCurrent.x - panTouch.x;
            CGFloat y = touchCurrent.y - panTouch.y;
            
            switch (self.type) {
                case ClipperTypeImgMove: {
                    self.baseImgView.center = CGPointMake(self.baseImgView.center.x + x, self.baseImgView.center.y + y);
                    break;
                }
                case ClipperTypeImgStay: {
                    self.clipperView.center = CGPointMake(self.clipperView.center.x + x, self.clipperView.center.y + y);
                    break;
                }
            }
            panTouch = touchCurrent;
            
        } break;
        case 2: {
            switch (self.type) {
                case ClipperTypeImgMove: {
                     [self scaleView:self.baseImgView touches:[allTouches allObjects]];
                    break;
                }
                case ClipperTypeImgStay: {
                    [self scaleView:self.clipperView touches:[allTouches allObjects]];
                    break;
                }
            }
        } break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    switch (self.type) {
        case ClipperTypeImgMove: {
            [self correctBackImgView];
            break;
        }
        case ClipperTypeImgStay: {
            [self correctClipperView];
            break;
        }
    }
}

- (void)correctBackImgView {
    CGFloat x = self.baseImgView.frame.origin.x;
    CGFloat y = self.baseImgView.frame.origin.y;
    CGFloat height = self.baseImgView.frame.size.height;
    CGFloat width = self.baseImgView.frame.size.width;
    
    if (width < self.clipperView.frame.size.width) {
        width = self.clipperView.frame.size.width;
        height = width / self.baseImgView.frame.size.width * height;
    }
    
    if (height < self.clipperView.frame.size.height) {
        height = self.clipperView.frame.size.height;
        width = height / self.baseImgView.frame.size.height * width;
    }
    
    if(x > self.clipperView.frame.origin.x) {
        x = self.clipperView.frame.origin.x;
    } else if (x <(self.clipperView.frame.origin.x + self.clipperView.frame.size.width - width)) {
        x = self.clipperView.frame.origin.x + self.clipperView.frame.size.width - width;
    }
    
    if (y > self.clipperView.frame.origin.y) {
        y = self.clipperView.frame.origin.y;
    } else if (y < (self.clipperView.frame.origin.y + self.clipperView.frame.size.height - height)) {
        y = self.clipperView.frame.origin.y + self.clipperView.frame.size.height - height;
    }
    
    self.baseImgView.frame = CGRectMake(x, y, width, height);
}

- (void)correctClipperView {
    CGFloat width = self.clipperView.frame.size.width;
    CGFloat height;
    if (width < minWidth) {
        width = minWidth;
    }
    if (width > [UIScreen mainScreen].bounds.size.width) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    height = width/self.resultImgSize.width * self.resultImgSize.height;
    
    CGFloat x = self.clipperView.frame.origin.x;
    CGFloat y = self.clipperView.frame.origin.y;
    if (x < 0) {
        x = 0;
    }
    if(x  > [UIScreen mainScreen].bounds.size.width - width){
        x = [UIScreen mainScreen].bounds.size.width - width;
    }
    if (y < 0) {
        y = 0;
    }
    if(y > [UIScreen mainScreen].bounds.size.height - height - 64){
        y =[UIScreen mainScreen].bounds.size.height - height - 64;
    }
    
    self.clipperView.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Utilities
//根据两点缩放View
- (void)scaleView:(UIView *)view touches:(NSArray *)touches {
    CGPoint touch1 = [[touches objectAtIndex:0] locationInView:self];
    CGPoint touch2 = [[touches objectAtIndex:1] locationInView:self];
    
    CGFloat distance = [self distanceBetweenTwoPoints:touch1 toPoint:touch2];
    if (scaleDistance>0) {
        CGRect imgFrame=view.frame;
        
        if (distance>scaleDistance+2) {
            imgFrame.size.width+=10;
            scaleDistance=distance;
        }
        if (distance<scaleDistance-2) {
            imgFrame.size.width -= 10;
            scaleDistance=distance;
        }
        
        imgFrame.size.height=CGRectGetHeight(view.frame)*imgFrame.size.width/CGRectGetWidth(view.frame);
        float addwidth=imgFrame.size.width-view.frame.size.width;
        float addheight=imgFrame.size.height-view.frame.size.height;
        
        if (imgFrame.size.width != 0 && imgFrame.size.height != 0) {
            view.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
        }
        
    }else {
        scaleDistance = distance;
    }
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    CGFloat x = toPoint.x - fromPoint.x;
    CGFloat y = toPoint.y - fromPoint.y;
    
    return sqrtf(x * x + y * y);
}
-(UIImage*)scaledToSize:(CGSize)newSize withScale:(BOOL)withScale scaleImage:(UIImage *)image{
    
    CGFloat scale = 1;
    if (withScale) {
        scale = [UIScreen mainScreen].scale;
    }
    newSize = (CGSize){newSize.width * scale, newSize.height * scale};
    // Create a graphics image context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    //    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:(CGRect){CGPointZero, newSize}];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
#pragma mark - Getters & Setters
- (void)setBaseImg:(UIImage *)baseImg {
    _baseImg = baseImg;
    
    //调整背景图片大小
    CGFloat width = _baseImg.size.width;
    CGFloat height = _baseImg.size.height;
    if (width != self.frame.size.width) {
        width = self.frame.size.width;
    }
    height = _baseImg.size.height / _baseImg.size.width * width;
    
    if (height < self.clipperView.frame.size.height) {
        height = self.clipperView.frame.size.height;
    }
    
    width = _baseImg.size.width / _baseImg.size.height * height;
    
    UIImage *img = [self scaledToSize:CGSizeMake(width, height) withScale:NO scaleImage:_baseImg];
    
    self.baseImgView.image = img;
    self.baseImgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    [self correctBackImgView];
}

- (UIImageView *)baseImgView {
    if (!_baseImgView) {
        _baseImgView = [[UIImageView alloc]init];
        [self addSubview:_baseImgView];
        [self sendSubviewToBack:_baseImgView];
    }
    return _baseImgView;
}

- (void)setResultImgSize:(CGSize)resultImgSize {
    _resultImgSize = resultImgSize;
    [self clipperView];
}
+ (BOOL)bankCardluhmCheck:(NSString *)idCard{
    if (!(idCard&&idCard.length > 1)) {
        
        return false;
    }
    NSString * lastNum = [[idCard substringFromIndex:(idCard.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[idCard substringToIndex:(idCard.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}
- (UIImageView *)clipperView {
    if (!_clipperView) {
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
//        if (self.resultImgSize.width > self.resultImgSize.height) {
//            height = [UIScreen mainScreen].bounds.size.width / self.resultImgSize.width * self.resultImgSize.height;
//        } else {
//            width = [UIScreen mainScreen].bounds.size.height / self.resultImgSize.height * self.resultImgSize.width;
//        }
        
//        CGFloat y = (self.frame.size.height - height) / 2;
//        CGFloat x = (self.frame.size.width - width) / 2;
        _clipperView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _resultImgSize.width, _resultImgSize.height)];
        
        _clipperView.center = self.center;
        
        _clipperView.image = [UIImage imageNamed:@"caijian_bg"];
        [self addSubview:_clipperView];
    }
    return _clipperView ;
}

@end
