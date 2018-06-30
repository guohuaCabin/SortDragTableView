//
//  SortDragCell.m
//  SortDragTableView
//
//  Created by 秦国华 on 2018/6/30.
//  Copyright © 2018年 秦国华. All rights reserved.
//

#import "SortDragCell.h"
#import "UIView+CreateUtils.h"
@interface SortDragCell()

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) UILabel *stockNameLab;

@property (nonatomic,strong) UIButton *topBtn;

@property (nonatomic,strong) UIImageView *dragImgView;

@property (nonatomic,copy) NSString *text;

@end

@implementation SortDragCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellH = [SortDragCell cellHeight];
    CGFloat btnH = 40;
    CGFloat btnY = (cellH - btnH)*0.5;
    
    _selectBtn = [self btnF:CGRectMake(10, btnY, btnH, btnH) title:@"" fsize:0];
    
    [_selectBtn setImage:[UIImage imageNamed:@"invalidName"] forState:UIControlStateNormal];
    [self addSubview:_selectBtn];
    
    CGFloat stockLabX = _selectBtn.frame.size.width+_selectBtn.frame.origin.x;
    _stockNameLab = [self labF:CGRectMake(stockLabX, 7, 100, 16) text:@"--" fsize:16];
    _stockNameLab.textColor = [UIColor blackColor];
    [self addSubview:_stockNameLab];
    
    
    CGFloat topImgViewX = 230;
    _topBtn = [self btnF:CGRectMake(topImgViewX, btnY, btnH, btnH) title:@"" fsize:0];
    [_topBtn setImage:[UIImage imageNamed:@"StickTop"] forState:UIControlStateNormal];
    [self addSubview:_topBtn];
    
    
    CGFloat imgViewH = 20;
    CGFloat imgViewY = (cellH - imgViewH)*0.5;
    CGFloat dragImgViewX = screenW - 37-imgViewH;
    _dragImgView = [self imgF:CGRectMake(dragImgViewX, imgViewY, imgViewH, imgViewH) imgName:@"dragIcon"];
    _dragImgView.userInteractionEnabled = YES;
    [self addSubview:_dragImgView];
    
    CGFloat lineViewX = stockLabX;
    CGFloat lineViewW = screenW - lineViewX*2;
    UIView *lineView = [self lineF:CGRectMake(lineViewX, cellH-0.5, lineViewW, 0.5)];
    [self addSubview:lineView];
    
    //添加手势
    [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topBtn addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dragTapClicked:)];
    [_dragImgView addGestureRecognizer:longPress];
    
    [self addGestureRecognizer:longPress];
}

-(void)updateCellWithText:(NSString *)text isSelect:(BOOL)isSelect
{
    _text = text;
    _stockNameLab.text = text;
    
    
    NSString *imageStr = isSelect?@"selectIcon":@"noSelectIcon";
    [_selectBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}

-(void)selectBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    NSString *imageStr = sender.isSelected?@"selectIcon":@"noSelectIcon";
    [_selectBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectSortDragCellWithSelectText:isSelect:)]) {
        [self.delegate selectSortDragCellWithSelectText:_text isSelect:sender.isSelected];
    }
}

-(void)topBtnClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickTopCellWithTopText:)]) {
        [self.delegate stickTopCellWithTopText:_text];
    }
}

-(void)dragTapClicked:(UILongPressGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellWithTap:)]) {
        [self.delegate dragCellWithTap:tap];
    }
}

+(CGFloat)cellHeight
{
    return 45;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
