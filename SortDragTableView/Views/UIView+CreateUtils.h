//
//  UIView+CreateUtils.h
//  Canary
//
//  Created by Brain on 2017/7/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CreateUtils)

-(UIButton *)btnF:(CGRect)frame title:(NSString *)title fsize:(CGFloat)fsize;

-(UILabel *)labF:(CGRect)frame text:(NSString *)text fsize:(CGFloat)fsize;

-(UIImageView *)imgF:(CGRect)frame imgName:(NSString *)name;

-(UIView *)lineF:(CGRect)frame;
@end
