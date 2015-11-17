//
//  AXPopoverBubbleView.m
//  AXPopoverView
//
//  Created by ai on 15/11/16.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "AXPopoverView.h"

@interface AXPopoverView()
{
    UIView   *_contentView;
    UIWindow *_showWindow;
    UIView   *_backgroundView;
    CGFloat   _arrowPosition;
    CGRect    _targetRect;
    UIColor  *_backgroundDrawingColor;
}
@property(weak, nonatomic) UIWindow *previousKeyWindow;
@end

NSString *const AXPopoverPriorityHorizontal = @"AXPopoverPriorityHorizontal";
NSString *const AXPopoverPriorityVertical = @"AXPopoverPriorityVertical";

@implementation AXPopoverView
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializer];
}

- (void)initializer {
    _cornerRadius = 10;
    _arrowCornerRadius = 10;
    _arrowAngle = 90;
    _arrowConstant = 10;
    _offsets = CGPointMake(20, 20);
    _arrowDirection = AXPopoverArrowDirectionBottom;
    _arrowPosition = .5;
    _priority = AXPopoverPriorityVertical;
    _dimBackground = NO;
    self.backgroundColor = [UIColor clearColor];
    _backgroundDrawingColor = [UIColor lightGrayColor];
    [self addSubview:self.contentView];
    [self setUpWindow];
}
#pragma mark - Override
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // bubble Drawing
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cxt, _backgroundDrawingColor.CGColor);
    CGContextSetLineWidth(cxt, 3.0);
    // top line drawing
    
    CGFloat topOffsets = 0.;
    CGFloat leftOffsets = 0.;
    CGFloat bottomOffsets = 0.;
    CGFloat rightOffsets = 0.;
    switch (_arrowDirection) {
        case AXPopoverArrowDirectionTop:
            topOffsets = _arrowConstant;
            break;
        case AXPopoverArrowDirectionLeft:
            leftOffsets = _arrowConstant;
            break;
        case AXPopoverArrowDirectionBottom:
            bottomOffsets = _arrowConstant;
            break;
        case AXPopoverArrowDirectionRight:
            rightOffsets = _arrowConstant;
            break;
        default:
            break;
    }
    // the origin point
    CGContextMoveToPoint(cxt, CGRectGetMinX(rect) + _cornerRadius + leftOffsets, CGRectGetMinY(rect) + topOffsets);
    if (_arrowDirection == AXPopoverArrowDirectionTop) [self addTopArrowPointWithContext:cxt arrowAngle:_arrowAngle arrowHeight:_arrowConstant arrowPositionX:CGRectGetWidth(rect)*_arrowPosition];
    CGContextAddLineToPoint(cxt, CGRectGetMaxX(rect) - _cornerRadius - rightOffsets, CGRectGetMinY(rect) + topOffsets);
    // top right arc drawing
    CGContextAddArcToPoint(cxt, CGRectGetMaxX(rect) - rightOffsets, CGRectGetMinY(rect) + topOffsets, CGRectGetMaxX(rect) - rightOffsets, CGRectGetMinY(rect) + _cornerRadius + topOffsets, _cornerRadius);
    if (_arrowDirection == AXPopoverArrowDirectionRight) [self addRightArrowPointWithContext:cxt arrowAngle:_arrowAngle arrowWidth:_arrowConstant arrowPositionY:CGRectGetHeight(rect)*_arrowPosition];
    // right line drawing
    CGContextAddLineToPoint(cxt, CGRectGetMaxX(rect) - rightOffsets, CGRectGetMaxY(rect) - _cornerRadius - bottomOffsets);
    // bottom right arc drawing
    CGContextAddArcToPoint(cxt, CGRectGetMaxX(rect) - rightOffsets, CGRectGetMaxY(rect) - bottomOffsets, CGRectGetMaxX(rect) - _cornerRadius - rightOffsets, CGRectGetMaxY(rect) - bottomOffsets, _cornerRadius);
    // bottom line drawing
    if (_arrowDirection == AXPopoverArrowDirectionBottom) [self addBottomArrowPointWithContext:cxt arrowAngle:_arrowAngle arrowHeight:_arrowConstant arrowPositionX:CGRectGetWidth(rect)*_arrowPosition];
    CGContextAddLineToPoint(cxt, CGRectGetMinX(rect) + _cornerRadius + leftOffsets, CGRectGetMaxY(rect) - bottomOffsets);
    // bottom left arc drawing
    CGContextAddArcToPoint(cxt, CGRectGetMinX(rect) + leftOffsets, CGRectGetMaxY(rect) - bottomOffsets, CGRectGetMinX(rect) + leftOffsets, CGRectGetMaxY(rect) - _cornerRadius - bottomOffsets, _cornerRadius);
    if (_arrowDirection == AXPopoverArrowDirectionLeft) [self addLeftArrowPointWithContext:cxt arrowAngle:_arrowAngle arrowWidth:_arrowConstant arrowPositionY:CGRectGetHeight(rect)*_arrowPosition];
    // left line drawing
    CGContextAddLineToPoint(cxt, CGRectGetMinX(rect) + leftOffsets, CGRectGetMinY(rect) + _cornerRadius + topOffsets);
    // top left arc drawing
    CGContextAddArcToPoint(cxt, CGRectGetMinX(rect) + leftOffsets, CGRectGetMinY(rect) + topOffsets, CGRectGetMinX(rect) + _cornerRadius + leftOffsets, CGRectGetMinY(rect) + topOffsets, _cornerRadius);
    CGContextFillPath(cxt);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.contentViewInsets;
    CGRect rect = _contentView.frame;
    rect.origin.x = contentInsets.left;
    rect.origin.y = contentInsets.top;
    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - (contentInsets.left + contentInsets.right), CGRectGetHeight(self.bounds) - (contentInsets.top + contentInsets.bottom));
    _contentView.frame = rect;
}

#pragma mark - Getters
- (UIView *)contentView {
    if (_contentView) return _contentView;
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _contentView;
}

- (UIEdgeInsets)contentViewInsets {
    UIEdgeInsets insets = UIEdgeInsetsMake(_cornerRadius, _cornerRadius, _cornerRadius, _cornerRadius);
    CGFloat topOffsets = 0.;
    CGFloat leftOffsets = 0.;
    CGFloat bottomOffsets = 0.;
    CGFloat rightOffsets = 0.;
    switch (_arrowDirection) {
        case AXPopoverArrowDirectionTop:
            topOffsets = _arrowConstant;
            break;
        case AXPopoverArrowDirectionLeft:
            leftOffsets = _arrowConstant;
            break;
        case AXPopoverArrowDirectionBottom:
            bottomOffsets = _arrowConstant;
            break;
        case AXPopoverArrowDirectionRight:
            rightOffsets = _arrowConstant;
            break;
        default:
            break;
    }
    insets.top += topOffsets;
    insets.left += leftOffsets;
    insets.bottom += bottomOffsets;
    insets.right += rightOffsets;
    return insets;
}

#pragma mark - Setters
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setArrowAngle:(CGFloat)arrowAngle {
    _arrowAngle = arrowAngle;
    [self setNeedsDisplay];
}

- (void)setArrowConstant:(CGFloat)arrowConstant {
    _arrowConstant = arrowConstant;
    [self setNeedsDisplay];
}

- (void)setArrowCornerRadius:(CGFloat)arrowCornerRadius {
    _arrowCornerRadius = arrowCornerRadius;
    [self setNeedsDisplay];
}

- (void)setArrowDirection:(AXPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
    [self setNeedsDisplay];
}

- (void)setPriority:(NSString *)priority {
    _priority = [priority copy];
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    _backgroundDrawingColor = backgroundColor;
    [self setNeedsDisplay];
}

#pragma mark - Shows&Hides
- (void)showInRect:(CGRect)rect animated:(BOOL)animated completion:(dispatch_block_t)completion
{
    _targetRect = rect;
    _previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    [_showWindow makeKeyAndVisible];
    [_showWindow addSubview:self];
    [self updateFrameWithRect:rect];
    CGRect frame = self.frame;
    self.frame = rect;
    _backgroundView.alpha = 0.0;
    NSTimeInterval animationDutation = animated?0.5:0.0;
    [UIView animateWithDuration:animationDutation delay:0.05 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:7 animations:^{
        self.hidden = NO;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished && completion) completion();
    }];
    // animated to dim background
    if (_dimBackground) {
        [UIView animateWithDuration:0.05 animations:^{
            _backgroundView.hidden = NO;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:7 animations:^{
                    _backgroundView.alpha = 1.0;
                } completion:nil];
            }
        }];
    }
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay completion:(dispatch_block_t)completion
{
    NSTimeInterval animationDuration = animated?0.25:0.0;
    [UIView animateWithDuration:animationDuration animations:^{
        _backgroundView.alpha = 0.0;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_previousKeyWindow makeKeyAndVisible];
            self.alpha = 1.0;
            self.hidden = YES;
            _backgroundView.hidden = YES;
            if (completion) completion();
        }
    }];
}

- (void)showInRect:(CGRect)rect animated:(BOOL)animated duration:(NSTimeInterval)duration {
    [self showInRect:rect animated:animated completion:^{
        [self hideAnimated:YES afterDelay:duration completion:nil];
    }];
}

- (void)showFromView:(UIView *)view animated:(BOOL)animated completion:(dispatch_block_t)completion {
    [self showInRect:view.frame animated:animated completion:completion];
}

#pragma mark - Actions
- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    [self hideAnimated:YES afterDelay:0.f completion:nil];
}

#pragma mark - Helper

- (void)setUpWindow {
    _showWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _showWindow.userInteractionEnabled = YES;
    _backgroundView = [[UIView alloc] initWithFrame:_showWindow.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    _backgroundView.userInteractionEnabled = NO;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_showWindow addSubview:_backgroundView];
    _backgroundView.hidden = YES;
    _backgroundView.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_showWindow addGestureRecognizer:tap];
}

- (AXPopoverArrowDirection)directionWithRect:(CGRect)rect {
    CGRect currentRect = [_showWindow convertRect:rect fromWindow:[UIApplication sharedApplication].keyWindow];
    UIEdgeInsets margins = UIEdgeInsetsMake(currentRect.origin.y, currentRect.origin.x, _showWindow.bounds.size.height - CGRectGetMaxY(currentRect), _showWindow.bounds.size.width - CGRectGetMaxX(currentRect));
    if ([_priority isEqualToString:AXPopoverPriorityHorizontal]) {
        if (margins.left > CGRectGetWidth(self.bounds) && (margins.top - _offsets.y > _cornerRadius || margins.bottom > _cornerRadius)) {// 左边显示
            return AXPopoverArrowDirectionRight;
        } else if (margins.right > CGRectGetWidth(self.bounds) && (margins.top - _offsets.y > _cornerRadius || margins.bottom > _cornerRadius)) {// 右边显示
            return AXPopoverArrowDirectionLeft;
        } else if (margins.top > CGRectGetHeight(self.bounds) && (margins.left - _offsets.x > _cornerRadius || margins.right > _cornerRadius)) {// 优先在上方显示
            return AXPopoverArrowDirectionBottom;
        } else if (margins.bottom > CGRectGetHeight(self.bounds) && (margins.left - _offsets.x > _cornerRadius || margins.right > _cornerRadius)) {// 下方显示
            return AXPopoverArrowDirectionTop;
        }
    } else {
        if (margins.top > CGRectGetHeight(self.bounds) && (margins.left - _offsets.x > _cornerRadius || margins.right > _cornerRadius)) {// 优先在上方显示
            return AXPopoverArrowDirectionBottom;
        } else if (margins.bottom > CGRectGetHeight(self.bounds) && (margins.left - _offsets.x > _cornerRadius || margins.right > _cornerRadius)) {// 下方显示
            return AXPopoverArrowDirectionTop;
        } else if (margins.left > CGRectGetWidth(self.bounds) && (margins.top - _offsets.y > _cornerRadius || margins.bottom > _cornerRadius)) {// 左边显示
            return AXPopoverArrowDirectionRight;
        } else if (margins.right > CGRectGetWidth(self.bounds) && (margins.top - _offsets.y > _cornerRadius || margins.bottom > _cornerRadius)) {// 右边显示
            return AXPopoverArrowDirectionLeft;
        }
    }
    return AXPopoverArrowDirectionTop;
}

- (void)updateFrameWithRect:(CGRect)rct {
    CGRect rect = self.frame;
    AXPopoverArrowDirection direction = [self directionWithRect:rct];
    _arrowDirection = direction;
    if (direction == AXPopoverArrowDirectionBottom || direction == AXPopoverArrowDirectionTop) {
        if (direction == AXPopoverArrowDirectionBottom) {
            rect.origin.y = CGRectGetMinY(rct) - CGRectGetHeight(rect);
        } else {
            rect.origin.y = CGRectGetMaxY(rct);
        }
        if (CGRectGetMidX(rct) >= CGRectGetWidth(rect)/2 + _offsets.x && CGRectGetWidth(_showWindow.bounds) - CGRectGetMidX(rct) >= CGRectGetWidth(rect)/2 + _offsets.x) {
            // arrow in the middle
            _arrowPosition = .5;
            rect.origin.x = (CGRectGetWidth(rct) - CGRectGetWidth(rect))/2 + rct.origin.x;
            [self setNeedsDisplay];
            [self setNeedsLayout];
        } else if (CGRectGetMidX(rct) < CGRectGetWidth(rect)/2 + _offsets.x) {
            // arrow in the middle left
            rect.origin.x = _offsets.x;
            _arrowPosition = (CGRectGetMidX(rct) - _offsets.x)/CGRectGetWidth(rect);
            [self setNeedsDisplay];
            [self setNeedsLayout];
        } else if (CGRectGetWidth(_showWindow.bounds) - CGRectGetMidX(rct) < CGRectGetWidth(rect)/2 + _offsets.x) {
            // arrow in the middle right
            rect.origin.x = CGRectGetWidth(_showWindow.bounds) - (CGRectGetWidth(rect) + _offsets.x);
            _arrowPosition = (CGRectGetWidth(rect) - (CGRectGetWidth(_showWindow.bounds) - CGRectGetMidX(rct) - _offsets.x))/CGRectGetWidth(rect);
            [self setNeedsDisplay];
            [self setNeedsLayout];
        }
    } else if (direction == AXPopoverArrowDirectionLeft | direction == AXPopoverArrowDirectionRight) {
        if (direction == AXPopoverArrowDirectionRight) {
            rect.origin.x = CGRectGetMinX(rct) - CGRectGetWidth(rect);
        } else {
            rect.origin.x = CGRectGetMaxX(rct);
        }
        if (CGRectGetMidY(rct) >= CGRectGetHeight(rect)/2 + _offsets.y && CGRectGetHeight(_showWindow.bounds) - CGRectGetMidY(rct) >= CGRectGetHeight(rect)/2 + _offsets.y) {
            // arrow in the middle
            _arrowPosition = .5;
            rect.origin.y = (CGRectGetHeight(rct) - CGRectGetHeight(rect))/2 + rct.origin.y;
            [self setNeedsDisplay];
            [self setNeedsLayout];
        } else if (CGRectGetMidY(rct) < CGRectGetWidth(rect)/2 + _offsets.y) {
            // arrow in the middle top
            rect.origin.y = _offsets.y;
            _arrowPosition = (CGRectGetMidY(rct) - _offsets.y)/CGRectGetHeight(rect);
            [self setNeedsDisplay];
            [self setNeedsLayout];
        } else if (CGRectGetHeight(_showWindow.bounds) - CGRectGetMidY(rct) < CGRectGetHeight(rect)/2 + _offsets.y) {
            // arrow in the middle bottom
            rect.origin.y = CGRectGetHeight(_showWindow.bounds) - (CGRectGetHeight(rect) + _offsets.y);
            _arrowPosition = (CGRectGetHeight(rect) - (CGRectGetHeight(_showWindow.bounds) - CGRectGetMidY(rct) - _offsets.y))/CGRectGetHeight(rect);
            [self setNeedsDisplay];
            [self setNeedsLayout];
        }
    }
    self.frame = rect;
}

- (BOOL)validOfArrowFrame:(CGRect)arrowFrame __deprecated {
    if (arrowFrame.origin.x == 0 || arrowFrame.origin.y == 0 || CGRectGetMaxX(arrowFrame) == self.bounds.size.width || CGRectGetMaxY(arrowFrame) == self.bounds.size.height) {
        return YES;
    }
    return NO;
}

- (void)addTopArrowPointWithContext:(CGContextRef)cxt arrowAngle:(CGFloat)angle arrowHeight:(CGFloat)height arrowPositionX:(CGFloat)x
{
    CGFloat arrowWidth_2 = height * tan(angle*M_PI/360);
    CGFloat constant = _arrowCornerRadius * tan((45-(angle/4))*M_PI/180);
    CGFloat constantX = constant*sin(angle*M_PI/360);
    CGFloat constantY = constant*cos(angle*M_PI/360);
    CGFloat xConstant = x - arrowWidth_2;
    if (xConstant - constant < _cornerRadius) {
        CGContextAddLineToPoint(cxt, MAX(xConstant, _cornerRadius), CGRectGetMinY(self.bounds) + height);
    } else {
        CGContextAddLineToPoint(cxt, xConstant - constant, CGRectGetMinY(self.bounds) + height);
        CGContextAddArcToPoint(cxt, xConstant, CGRectGetMinY(self.bounds) + height, xConstant + constantX, CGRectGetMinY(self.bounds) + height - constantY, _arrowCornerRadius);
    }
    CGContextAddLineToPoint(cxt, x, CGRectGetMinY(self.bounds));
    xConstant = x + arrowWidth_2;
    if (xConstant + constant > CGRectGetWidth(self.bounds) - _cornerRadius) {
        CGContextAddLineToPoint(cxt, MIN(xConstant, CGRectGetWidth(self.bounds) - _cornerRadius), CGRectGetMinY(self.bounds) + height);
    } else {
        CGContextAddLineToPoint(cxt, xConstant - constantX, CGRectGetMinY(self.bounds) + height - constantY);
        CGContextAddArcToPoint(cxt, xConstant, CGRectGetMinY(self.bounds) + height, xConstant + constant, CGRectGetMinY(self.bounds) + height, _arrowCornerRadius);
    }
}

- (void)addBottomArrowPointWithContext:(CGContextRef)cxt arrowAngle:(CGFloat)angle arrowHeight:(CGFloat)height arrowPositionX:(CGFloat)x
{
    CGFloat arrowWidth_2 = height * tan(angle*M_PI/360);
    CGFloat constant = _arrowCornerRadius * tan((45-(angle/4))*M_PI/180);
    CGFloat constantX = constant*sin(angle*M_PI/360);
    CGFloat constantY = constant*cos(angle*M_PI/360);
    CGFloat xConstant = x + arrowWidth_2;
    if (xConstant + constant > CGRectGetWidth(self.bounds) - _cornerRadius) {
        CGContextAddLineToPoint(cxt, MIN(xConstant, CGRectGetWidth(self.bounds) - _cornerRadius), CGRectGetMaxY(self.bounds) - height);
    } else {
        CGContextAddLineToPoint(cxt, xConstant + constant, CGRectGetMaxY(self.bounds) - height);
        CGContextAddArcToPoint(cxt, xConstant, CGRectGetMaxY(self.bounds) - height, xConstant - constantX, CGRectGetMaxY(self.bounds) - height + constantY, _arrowCornerRadius);
    }
    CGContextAddLineToPoint(cxt, x, CGRectGetMaxY(self.bounds));
    xConstant = x - arrowWidth_2;
    if (xConstant - constant < _cornerRadius) {
        CGContextAddLineToPoint(cxt, MAX(xConstant, _cornerRadius), CGRectGetMaxY(self.bounds) - height);
    } else {
        CGContextAddLineToPoint(cxt, xConstant + constantX, CGRectGetMaxY(self.bounds) - height + constantY);
        CGContextAddArcToPoint(cxt, xConstant, CGRectGetMaxY(self.bounds) - height, xConstant - constant, CGRectGetMaxY(self.bounds) - height, _arrowCornerRadius);
    }
}

- (void)addLeftArrowPointWithContext:(CGContextRef)cxt arrowAngle:(CGFloat)angle arrowWidth:(CGFloat)width arrowPositionY:(CGFloat)y
{
    CGFloat arrowHtight_2 = width * tan(angle*M_PI/360);
    CGFloat constant = _arrowCornerRadius * tan((45-(angle/4))*M_PI/180);
    CGFloat constantY = constant*sin(angle*M_PI/360);
    CGFloat constantX = constant*cos(angle*M_PI/360);
    CGFloat Yconstant = y + arrowHtight_2;
    if (Yconstant + constant > CGRectGetHeight(self.bounds) - _cornerRadius) {
        CGContextAddLineToPoint(cxt, CGRectGetMinX(self.bounds) + width, MIN(Yconstant, CGRectGetHeight(self.bounds) - _cornerRadius));
    } else {
        CGContextAddLineToPoint(cxt, CGRectGetMinX(self.bounds) + width, Yconstant + constant);
        CGContextAddArcToPoint(cxt, CGRectGetMinX(self.bounds) + width, Yconstant, CGRectGetMinX(self.bounds) + width - constantX, Yconstant - constantY, _arrowCornerRadius);
    }
    CGContextAddLineToPoint(cxt, CGRectGetMinX(self.bounds), y);
    Yconstant = y - arrowHtight_2;
    if (Yconstant - constant < _cornerRadius) {
        CGContextAddLineToPoint(cxt, CGRectGetMinX(self.bounds) + width, MAX(Yconstant, _cornerRadius));
    } else {
        CGContextAddLineToPoint(cxt, CGRectGetMinX(self.bounds) + width - constantX, y - arrowHtight_2 + constantY);
        CGContextAddArcToPoint(cxt, CGRectGetMinX(self.bounds) + width, Yconstant, CGRectGetMinX(self.bounds) + width, Yconstant - constant, _arrowCornerRadius);
    }
}

- (void)addRightArrowPointWithContext:(CGContextRef)cxt arrowAngle:(CGFloat)angle arrowWidth:(CGFloat)width arrowPositionY:(CGFloat)y
{
    CGFloat arrowHtight_2 = width * tan(angle*M_PI/360);
    CGFloat constant = _arrowCornerRadius * tan((45-(angle/4))*M_PI/180);
    CGFloat constantY = constant*sin(angle*M_PI/360);
    CGFloat constantX = constant*cos(angle*M_PI/360);
    CGFloat Yconstant = y - arrowHtight_2;
    if (Yconstant - constant < _cornerRadius) {
        CGContextAddLineToPoint(cxt, CGRectGetMaxX(self.bounds) - width, MAX(Yconstant, _cornerRadius));
    } else {
        CGContextAddLineToPoint(cxt, CGRectGetMaxX(self.bounds) - width, Yconstant - constant);
        CGContextAddArcToPoint(cxt, CGRectGetMaxX(self.bounds) - width, Yconstant, CGRectGetMaxX(self.bounds) - width + constantX, Yconstant + constantY, _arrowCornerRadius);
    }
    CGContextAddLineToPoint(cxt, CGRectGetMaxX(self.bounds), y);
    Yconstant = y + arrowHtight_2;
    if (Yconstant + constant > CGRectGetHeight(self.bounds) - _cornerRadius) {
        CGContextAddLineToPoint(cxt, CGRectGetMaxX(self.bounds) - width, MIN(Yconstant, CGRectGetHeight(self.bounds) - _cornerRadius));
    } else {
        CGContextAddLineToPoint(cxt, CGRectGetMaxX(self.bounds) - width + constantX, Yconstant - constantY);
        CGContextAddArcToPoint(cxt, CGRectGetMaxX(self.bounds) - width, Yconstant, CGRectGetMaxX(self.bounds) - width, Yconstant + constant, _arrowCornerRadius);
    }
}
@end