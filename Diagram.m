//
//  Diagram.m
//  Quartz2D
//
//  Created by iLeo-OC on 16/8/11.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "Diagram.h"
#import "TWRChart.h"
#import "NSString+YBSize.h"
#import "UIColor+indexColor.h"
//边距
#define edge 25
//行数
#define row 10
//字体大小
#define textFontSize 10
/**
 *   正常高度的Y轴组数
 */
//#define normalYNumber 6
@interface Diagram()

@property (nonatomic, strong) UIBezierPath *myPath;

@property (nonatomic, assign) CGFloat axisW;
@property (nonatomic, assign) CGFloat axisH;
//获得坐标轴的宽高
@property (nonatomic, assign) CGFloat viewW;
@property (nonatomic, assign) CGFloat viewH;
//显示量程
@property (nonatomic, assign) CGFloat rangeY;
//多重数据数组
@property (nonatomic, strong) NSMutableArray *mutableData;
//一组数据中的最小
//列数
@property (nonatomic, assign) NSInteger col;
/**
 *   正常高度的Y轴组数
 */
@property (nonatomic, assign) CGFloat abNormalYNumber;
@end

@implementation Diagram

- (void)setCompressYAxis:(BOOL)compressYAxis
{
    _compressYAxis = compressYAxis;
    if (compressYAxis == YES) {
        _abNormalYNumber = 4;
    }else{
        _abNormalYNumber = 0;
    }
}

- (void)setLabelX:(NSArray *)labelX
{
    _labelX = labelX;
    _col = _labelX.count;
}

- (NSMutableArray *)mutableData
{
    if (_mutableData == nil) {
        _mutableData = [NSMutableArray array];
    }
    return _mutableData;
}
- (void)addDataOfY:(NSArray *)dataY
{
    [self.mutableData addObject:dataY];
    //按升序排列数组中的数
    NSArray *sortedArr = [self getAscendingArrWithArr:dataY];
    //从数组中得到最大最小值
    CGFloat MaxY = [sortedArr[sortedArr.count-1] floatValue];
//    CGFloat MinY = [sortedArr[0] floatValue];
    if (_rangeY < [self getYIntervalWithMaxY:MaxY]*row) {
        _rangeY = [self getYIntervalWithMaxY:MaxY]*row;
    }
    
}
- (CGFloat)getYIntervalWithMaxY:(CGFloat)MaxY
{
    CGFloat yInterval = (MaxY - _zeroY)/row;
    if (yInterval <= 1) {
        return 1;
    }else if (yInterval <= 2){
        return 2;
    }else if (yInterval <= 5){
        return 5;
    }else if (yInterval <= 10){
        return 10;
    }else if (yInterval <= 15){
        return 15;
    }else if (yInterval <= 20){
        return 20;
    }else{
        return yInterval;
    }
    
}
- (NSArray *) getAscendingArrWithArr:(NSArray *)dataY
{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([obj1 floatValue] == [obj2 floatValue])
        {
            return (NSComparisonResult)NSOrderedSame;
        }else{
            return (NSComparisonResult)NSOrderedAscending;
        }
    };
    return [dataY sortedArrayUsingComparator:cmptr];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void) startDrawing
{
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect
{
    //获取view的宽高
    _viewW = self.bounds.size.width;
    _viewH = self.bounds.size.height;
    //获得坐标轴的宽高
    _axisW = _viewW - edge;
    _axisH = _viewH - edge;
    //贝塞尔曲线
    //两条坐标轴
    UIBezierPath *aPath = [self drawALineWithPoint:CGPointMake(edge*0.5, _viewH - edge) toPoint:CGPointMake(_viewW - edge*0.5, _viewH - edge) forLineWidth:2 color:[UIColor colorWithWhite:0.500 alpha:0.602] isDash:NO];
    UIBezierPath *twoPath = [self drawALineWithPoint:CGPointMake(edge, 0.5*edge) toPoint:CGPointMake(edge, _viewH - edge*0.5) forLineWidth:2 color:[UIColor colorWithWhite:0.500 alpha:0.602] isDash:NO];
    //画出中间网线
    
    //行分组数及纵向间距
    CGFloat rowH = _axisH/(row + 1);
    for (int i = 1; i < row+1; i++) {
        CGFloat y = _viewH - (edge + rowH*i);
        //写字
        if (i <= row - _abNormalYNumber) {
            NSString *mystr = [NSString stringWithFormat:@"%1.0f",_rangeY/row*i];
            CGSize textSize = [mystr sizeWithSystemFontOfSize:textFontSize];
            [mystr drawInRect:CGRectMake(edge - textSize.width - 5, y - textSize.height*0.5, textSize.width, textSize.height) withAttributes:[NSString myAttributeWithSize:textFontSize]];
        }else{
            NSString *mystr2 = [NSString stringWithFormat:@"%1.0f",_rangeY/row*(2*i - row + _abNormalYNumber)];
            CGSize textSize = [mystr2 sizeWithSystemFontOfSize:11];
            [mystr2 drawInRect:CGRectMake(edge - textSize.width - 5, y - textSize.height*0.5, textSize.width, textSize.height) withAttributes:[NSString myAttributeWithSize:11]];
        }
        
        CGPoint point1 = CGPointMake(edge, y);
        CGPoint point2 = CGPointMake(_viewW - edge*0.5, y);
        [self drawALineWithPoint:point1 toPoint:point2 forLineWidth:1 color:[UIColor colorWithWhite:0.500 alpha:0.252] isDash:NO];
        //
        if (i > row - _abNormalYNumber) {
            CGFloat y1 = _viewH - (edge + rowH*(i - 0.5));
            CGPoint point3 = CGPointMake(edge, y1);
            CGPoint point4 = CGPointMake(_viewW - edge*0.5, y1);
            [self drawALineWithPoint:point3 toPoint:point4 forLineWidth:1 color:[UIColor colorWithWhite:0.500 alpha:0.206] isDash:YES];
        }
    }
    //列分组数及纵向间距
    
    CGFloat colW = _axisW/_col;
    for (int i = 0; i < _col; i++) {
        CGFloat x = edge + colW*i;
        CGSize textSize = [_labelX[i] sizeWithSystemFontOfSize:textFontSize];
        //写字
        [[UIColor redColor] set];
        NSString *mystr = _labelX[i];
        if (i==0) {
//            [mystr drawInRect:CGRectMake(x + 5, _viewH - edge, textSize.width, textSize.height) withAttributes:[NSString myAttributeWithSize:textFontSize]];
        }else{
            [mystr drawInRect:CGRectMake(x - textSize.width*0.5, _viewH - edge, textSize.width, textSize.height) withAttributes:[NSString myAttributeWithSize:textFontSize]];
        }
        CGPoint point1 = CGPointMake(x, 0.5*edge);
        CGPoint point2 = CGPointMake(x, _viewH - edge);
        
        [self drawALineWithPoint:point1 toPoint:point2 forLineWidth:1 color:[UIColor colorWithWhite:0.500 alpha:0.179]isDash:NO];
    }
    //画线
    for (int j = 0; j < _mutableData.count; j++) {
        NSArray *myArr = [self RyArrWithYArr:_mutableData[j] withRowNum:row] ;
        UIColor * lineColor = [UIColor colorWithIndex:j];
        for (int i = 0; i < _col; i++) {
            CGFloat x = edge + colW*i;
            //画点
            NSNumber *RyNum = myArr[i];
            CGFloat Ry = [RyNum floatValue];
            CGPoint point = CGPointMake(x, Ry);
            if (i==0) {
                _myPath = [self drawALineWithPoint:point toPoint:CGPointZero forLineWidth:2 color:lineColor isDash:NO];
            }
            [_myPath addLineToPoint:point];
        }
        [_myPath stroke];
        
    }

    
}
- (NSArray *)RyArrWithYArr:(NSArray *)YArr withRowNum:(int)myRow
{
    NSMutableArray *pointRyArr = [NSMutableArray array];
    for (NSNumber *number in YArr) {
        //外界传值
        CGFloat Y = [number floatValue];
        //转换为内部坐标系上对应点
        if (Y >= (row - _abNormalYNumber)*_rangeY/row) {
            Y = (Y - (row - _abNormalYNumber)*_rangeY/row)*0.5+(row - _abNormalYNumber)*_rangeY/row;
        }
        CGFloat rowH = _axisH/(myRow + 1);
        CGFloat Ry0 = (Y * myRow * rowH)/_rangeY;
        CGFloat Ry = _viewH - Ry0 - edge;
        NSNumber *RyNum = [NSNumber numberWithFloat:Ry];
        [pointRyArr addObject:RyNum];
    }
    return pointRyArr;
}

- (UIBezierPath *)drawALineWithPoint:(CGPoint )point1 toPoint:(CGPoint)point2 forLineWidth:(CGFloat)lineW color:(UIColor *)color isDash:(BOOL)isDash
{
    //创建一个贝塞尔路径对象
    [color set];
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = lineW;
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineJoinRound;
    // Set the starting point of the shape.
    [aPath moveToPoint:point1];
    // Draw the lines
    if (!CGPointEqualToPoint(point2, CGPointZero)) {
        [aPath addLineToPoint:point2];
        if (isDash) {
            CGFloat pattern[] = {2, 2};
            [aPath setLineDash:pattern count:2 phase:5];
        }
        [aPath stroke]; //Draws line 根据坐标点连线
    }
    return aPath;
}
@end
