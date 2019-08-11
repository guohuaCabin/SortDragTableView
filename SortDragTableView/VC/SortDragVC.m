//
//  SortDragVC.m
//  SortDragTableView
//
//  Created by 秦国华 on 2018/6/30.
//  Copyright © 2018年 秦国华. All rights reserved.
//

#import "SortDragVC.h"

#import "SortDragCell.h"
#import "UIView+CreateUtils.h"
@interface SortDragVC ()
<UITableViewDelegate,UITableViewDataSource,SortDragCellDelegate>

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIButton *selectAllBtn;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIButton *doBtn;

@property (nonatomic,strong) UIView *segmentView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *selectArray;

@property (nonatomic,strong) UITableView *tableView;
//正在拖拽的indexpath
@property (nonatomic,strong) NSIndexPath *dragingIndexPath;
//目标位置
@property (nonatomic,strong) NSIndexPath *targetIndexPath;

@end

#define ScreenBounds           [[UIScreen mainScreen] bounds].size
#define ScreenW                 ScreenBounds.width
#define ScreenH                 ScreenBounds.height

@implementation SortDragVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupViews];
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc]init];
    }
    return _selectArray;
}

-(void)initData
{
    for (NSInteger i = 0; i<30; i++) {
        
        NSString *obj = [NSString stringWithFormat:@"gh_%li",i];
        [self.dataArray addObject:obj];
        
    }
}

-(void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self createHeaderView];
    [self createSegmentView];
    [self createTableView];
}
-(void)createHeaderView
{
    CGFloat commonF = 16;
    CGFloat navbarH = 44;
    UIColor *commonColor = [UIColor blackColor];
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenW, navbarH)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    
    CGFloat commonBtnW = 35;
    //全选
    self.selectAllBtn = [self.view btnF:CGRectMake(20, 0, 61, 44) title:@"全选" fsize:commonF];
    [self.selectAllBtn setTitleColor:commonColor forState:UIControlStateNormal];
    [self.selectAllBtn setImage:[UIImage imageNamed:@"noSelectIcon"] forState:UIControlStateNormal];
    [self.selectAllBtn addTarget:self action:@selector(selectAllBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat interval = 3;
    self.selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-interval, 0,interval);
    self.selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, interval, 0, -interval);
    [self.headerView addSubview:self.selectAllBtn];
    
    //删除
    CGFloat deleteBtnX = self.selectAllBtn.frame.origin.x + _selectAllBtn.frame.size.width +50;
    self.deleteBtn = [self.view btnF:CGRectMake(deleteBtnX, 0, commonBtnW, navbarH) title:@"删除" fsize:commonF];
    [self.deleteBtn setTitleColor:commonColor forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.deleteBtn];
    
    //完成
    self.doBtn = [self.view btnF:CGRectMake(ScreenW-commonBtnW-15, 0, commonBtnW, navbarH) title:@"完成" fsize:commonF];
    [self.doBtn setTitleColor:commonColor forState:UIControlStateNormal];
    [self.doBtn addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.doBtn];
    
}

-(void)createSegmentView
{
    CGFloat segmentViewY = self.headerView.frame.origin.y + self.headerView.frame.size.height;
    self.segmentView = [[UIView alloc]initWithFrame:CGRectMake(0, segmentViewY, ScreenW, 50)];
    self.segmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentView];
    
    CGFloat labW = 30;
    CGFloat labY = 22;
    CGFloat labH = 12;
    CGFloat commonF = 12;
    UIColor *commonColor = [UIColor grayColor];
    UILabel *nameLab = [self.view labF:CGRectMake(60, labY, labW, labH) text:@"名称" fsize:commonF];
    nameLab.textColor = commonColor ;
    [self.segmentView addSubview:nameLab];
    
    UILabel *topLab = [self.view labF:CGRectMake(230, labY, labW, labH) text:@"置顶" fsize:commonF];
    topLab.textColor = commonColor;
    topLab.textAlignment = NSTextAlignmentRight;
    [self.segmentView addSubview:topLab];
    
    CGFloat dragLabX = ScreenW - 35 - labW;
    UILabel *dragLab = [self.view labF:CGRectMake(dragLabX, labY, labW, labH) text:@"拖动" fsize:commonF];
    dragLab.textAlignment = NSTextAlignmentRight;
    dragLab.textColor = commonColor ;
    [self.segmentView addSubview:dragLab];
    
}

-(void)createTableView
{
    
    CGFloat tableViewY = self.segmentView.frame.origin.y + self.segmentView.frame.size.height;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewY, ScreenW, ScreenH-tableViewY) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - ****************  Action
//全选
-(void)selectAllBtnClicked:(UIButton *)sender
{
    self.selectAllBtn.selected = !self.selectAllBtn.isSelected;
    NSString *selectAllImgStr = self.selectAllBtn.selected?@"selectIcon":@"noSelectIcon";
    [self.selectAllBtn setImage:[UIImage imageNamed:selectAllImgStr] forState:UIControlStateNormal];
    if (self.selectAllBtn.isSelected) {
        [self.selectArray removeAllObjects];
        [self.selectArray addObjectsFromArray:self.dataArray];
        [self.tableView reloadData];
    }else{
        [self.selectArray removeAllObjects];
        [self.tableView reloadData];
    }
}

//删除
-(void)deleteBtnClicked:(UIButton *)sender
{
    NSMutableArray<NSIndexPath *> *indexArr = [NSMutableArray array];
    for (int i = 0; i < self.selectArray.count; i++) {
        NSInteger index = [self.dataArray indexOfObject:self.selectArray[i]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexArr addObject:indexPath];
    }
    
    // 不能写在上面的for循环里面
    [self.selectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.dataArray containsObject:obj] ) {
            [self.dataArray removeObject:obj];
        }
    }];
    
    [self.selectArray removeAllObjects];
    __weak typeof(SortDragVC) *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView deleteRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];
    });
    
}
//完成
-(void)doBtnClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark LongPressMethod
//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point
{
    //通过点击的点来获得indexpath
    self.dragingIndexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!_dragingIndexPath)
    {
        return;
    }
    //触发长按手势的cell
    SortDragCell * cell = (SortDragCell*)[self.tableView cellForRowAtIndexPath:self.dragingIndexPath];
    cell.backgroundColor = [UIColor colorWithRed:53/255.f green:115/255.f blue:250/255.f alpha:0.3];
    cell.isMoving = YES;
    
}

//正在被拖拽ing
-(void)dragChanged:(CGPoint)startPoint
{
    if (!_dragingIndexPath )
    {
        return;
    }
    _targetIndexPath = [self.tableView indexPathForRowAtPoint:startPoint];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath &&(_dragingIndexPath.row != _targetIndexPath.row)) {
        //更新数据源
        [self updateSortDatas];
        //更新item位置
        [self.tableView moveRowAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

//拖拽结束
-(void)dragEnd{
    if (!_dragingIndexPath)
    {
        return;
    }
    SortDragCell *cell = (SortDragCell*)[self.tableView cellForRowAtIndexPath:self.dragingIndexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.isMoving = NO;
    [self.tableView reloadData];
    
}

#pragma mark 刷新方法
//拖拽排序后需要重新排序数据源
-(void)updateSortDatas
{
    NSString *text = self.dataArray[_dragingIndexPath.row];
    [self.dataArray removeObjectAtIndex:_dragingIndexPath.row];
    [self.dataArray insertObject:text atIndex:_targetIndexPath.row];
    
}

#pragma mark - *************** sortDragdelegate
-(void)selectSortDragCellWithSelectText:(NSString *)selectText isSelect:(BOOL)isSelect
{
    if (selectText == nil) {
        return;
    }
    if (isSelect) {
        if (![self.selectArray containsObject:selectText]) {
            [self.selectArray addObject:selectText];
        }
    }else{
        if ([self.selectArray containsObject:selectText]) {
            [self.selectArray removeObject:selectText];
        }
    }
    
    [self.tableView reloadData];
    
}

-(void)stickTopCellWithTopText:(NSString *)topText
{
    if (topText == nil) {
        return;
    }
    if ([self.dataArray containsObject:topText]) {
        [self.dataArray removeObject:topText];
        [self.dataArray insertObject:topText atIndex:0];
        [self.tableView reloadData];
    }
}

-(void)dragCellWithTap:(UILongPressGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.tableView];
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}

#pragma mark - **************** tableViewDelegate and dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierID = @"cell";
    SortDragCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (nil == cell) {
        cell = [[SortDragCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    NSString *text = self.dataArray[indexPath.row];
    BOOL isSelect = NO;
    if ([self.selectArray containsObject:text]) {
        isSelect = YES;
    }
    
    [cell updateCellWithText:text isSelect:isSelect];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowH = [SortDragCell cellHeight];
    return rowH;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
