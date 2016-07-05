//
//  CJCarouselView.h
//  图片轮播
//
//  Created by chenjun on 16/7/5.
//  Copyright © 2016年 cloudssky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol imgeClickDelegate <NSObject>

@required
- (void)clickImage:(int)index;

@end

@interface CJCarouselView : UIView

typedef enum{
    DirecRight,
    DirecLeft
} Direction;

@property (nonatomic ,strong) NSArray *dataSourceArray;//图片数组
@property (nonatomic ,assign) Direction direction;//图片滚动方向
@property (nonatomic ,assign) BOOL isHidePage;//是否隐藏分页按钮
@property (nonatomic ,strong) UIColor *currentPageColor;//当前选中点的颜色
@property (nonatomic ,strong) UIColor *otherPageColor;//未选中点的颜色
@property (nonatomic ,weak) id<imgeClickDelegate>delegate;

@end
