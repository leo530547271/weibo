//
//  Diagram.h
//  Quartz2D
//
//  Created by iLeo-OC on 16/8/11.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Diagram : UIView


/**
 *   X轴标签
 */
@property (nonatomic, strong) NSArray *labelX;
/**
 *   Y轴0点数值
 */
@property (nonatomic, assign) CGFloat zeroY;
/**
 *   Y轴数据(与X轴的数量一致)
 */
- (void) addDataOfY:(NSArray *)dataY;

/**
 *   开始绘图
 */
- (void) startDrawing;
/**
 *   是否压缩上部坐标系
 */
@property (nonatomic, assign, getter=isCompressYAxis) BOOL compressYAxis;
@end
