//
//  UIView+CreateUtils.m
//  Canary
//
//  Created by Brain on 2017/7/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIView+CreateUtils.h"

@implementation UIView (CreateUtils)

#define tcolor LTTitleColor
-(UIButton *)btnF:(CGRect)frame title:(NSString *)title fsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}

-(UILabel *)labF:(CGRect)frame text:(NSString *)text fsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentLeft;
    label.numberOfLines=0;
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}

-(UIImageView *)imgF:(CGRect)frame imgName:(NSString *)name{
    UIImageView *imgv=[[UIImageView alloc]init];
    if (name.length > 0) {
        imgv.image=[UIImage imageNamed:name];
    }
    imgv.frame=frame;
    return imgv;
}

-(UIView *)lineF:(CGRect)frame{
    UIView *line=[[UIView alloc]init];
    line.frame=frame;
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return line;
}


@end
