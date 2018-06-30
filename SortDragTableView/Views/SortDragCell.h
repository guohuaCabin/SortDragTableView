//
//  SortDragCell.h
//  SortDragTableView
//
//  Created by 秦国华 on 2018/6/30.
//  Copyright © 2018年 秦国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortDragCellDelegate<NSObject>

/**
 选择

 @param selectText 选择的内容（是确定你选择的东西，具体是什么根据自己需求设置，用作多选）
 @param isSelect 是否选中
 */
-(void)selectSortDragCellWithSelectText:(NSString *)selectText isSelect:(BOOL)isSelect;

/**
 置顶

 @param topText  置顶的内容
 */
-(void)stickTopCellWithTopText:(NSString *)topText;

/**
 拖拽

 @param tap 拖拽的手势
 */
-(void)dragCellWithTap:(UILongPressGestureRecognizer *)tap ;

@end

@interface SortDragCell : UITableViewCell

//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

//是否不可移动
@property (nonatomic, assign) BOOL isFixed;

@property (nonatomic,weak) id<SortDragCellDelegate> delegate;

//更新cell
-(void)updateCellWithText:(NSString *)text isSelect:(BOOL)isSelect;

//cell的高度
+(CGFloat)cellHeight;

@end
