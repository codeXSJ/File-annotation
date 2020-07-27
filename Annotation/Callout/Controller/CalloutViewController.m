//
//  CalloutViewController.m
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "CalloutViewController.h"
#import "CarriedOutViewCell.h"
#import "CalloutViewModel.h"
#import "CalloutBottomView.h"
#import "FontSizeView.h"
#import "TypefaceView.h"
#import "FontColorView.h"
#import "BackgroundColorView.h"
#import "UITextView+UIScreenDisplaying.h"
@interface CalloutViewController ()<UITableViewDataSource,UITableViewDelegate,CalloutBottomViewDelegate,FontSizeViewDelegate,TypefaceViewDelegate,FontColorViewDelegate,BackgroundColorViewDelegate>{
    NSInteger     CurrentTextTag;    //当前光标所在的UITextView的tag
    NSString     *CurrentTypeface;   //当前字体
    NSInteger     CurrentFontSize;   //当前字号
    UIColor      *CurrentFontColor;  //当前字体颜色
    UIColor      *CurrentbackColor;  //当前背景颜色
}
@property (nonatomic, strong) CalloutBottomView              *calloutBottomView; //初始底部栏
@property (nonatomic, strong) FontSizeView                   *fontSizeView;//字号底部栏
@property (nonatomic, strong) TypefaceView                   *typefaceView;//字体底部栏
@property (nonatomic, strong) FontColorView                  *fontColorView;//字体颜色底部栏
@property (nonatomic, strong) BackgroundColorView            *backgroundColorView;//背景颜色底部栏
@property (nonatomic, strong) UITableView                    *tableView;
@property (nonatomic, strong) CalloutViewModel               *viewModel;
@property (nonatomic, strong) UITableViewCell                *cellMiddle;//居中的cell(随着滑动而变化)
@property (nonatomic, assign) NSInteger                       cellMiddleSection;//居中的cell的section
@property (nonatomic, assign) CGRect                          cellRect;//居中的cell相对屏幕的位置
@property (nonatomic, strong) UILabel                        *sectionLabel;//标记当前页
@property (nonatomic, strong) UIButton                       *delButton;
@property (nonatomic, strong) UITextView                     *textView;
@property (nonatomic, strong) UIView                         *dragView;
@property (nonatomic, assign) CGFloat                         InitialWidth;
@property (nonatomic, assign) CGFloat                         InitialHeight;
@property (nonatomic, assign) NSInteger                       count;
@property (nonatomic, strong) NSMutableArray                 *array;//存所有控件tag和所在cell的section
@property (nonatomic, assign) CGPoint                         sourcePoint;
@end

@implementation CalloutViewController

- (void)viewEvents {
    [self.view endEditing:YES];
    self.view.transform = CGAffineTransformIdentity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEvents)]];
    [self addNavBackBtn];
    self.title = @"文字标注、文字签名";
    CurrentTextTag = -1;
    self.view.backgroundColor = ColorFromRGB(0xE1E1E6);
    self.array = [[NSMutableArray alloc]init];
    self.InitialWidth = 120;
    self.InitialHeight = 80;
    [self initViewModel];
    [self initBottomView];
    [self.view addSubview:self.tableView];
    
    self.sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-30, ScreenHeight/2-20/2-50, 30, 20)];
    self.sectionLabel.font = [UIFont fontWithName:@"PingFang SC" size: 12];
    self.sectionLabel.textAlignment = NSTextAlignmentCenter;//靠左
    self.sectionLabel.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1].CGColor;//颜色
    self.sectionLabel.layer.borderWidth = 2.0f;//设置边框粗细
    self.sectionLabel.textColor = [UIColor blackColor];
    self.sectionLabel.text = @"1";
    [self.view addSubview:self.sectionLabel];
    // Do any additional setup after loading the view.
}


- (void)initViewModel {
    WeakSelf(self);
    self.viewModel = [[CalloutViewModel alloc]initWithURL:_fileUrl];
    self.viewModel.popControllerBlock = ^(NSString * _Nonnull fileName) {
        StrongSelf(self);
        self.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
        self.navigationController.tabBarController.selectedIndex=1;
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:fileName,@"key1", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CarriedOutView" object:nil userInfo:dict];
    };
}

- (void)initBottomView {
    self.calloutBottomView = [[CalloutBottomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-66, ScreenWidth, 66)];
    self.calloutBottomView.delegete = self;
    self.calloutBottomView.hidden = NO;
    [self.view addSubview:self.calloutBottomView];
    
    self.fontSizeView = [[FontSizeView alloc]initWithFrame:CGRectMake(0, ScreenHeight-66, ScreenWidth, 66)];
    self.fontSizeView.delegete = self;
    self.fontSizeView.hidden = YES;
    [self.view addSubview:self.fontSizeView];
    
    self.typefaceView = [[TypefaceView alloc]initWithFrame:CGRectMake(0, ScreenHeight-66, ScreenWidth, 66)];
    self.typefaceView.delegete = self;
    self.typefaceView.hidden = YES;
    [self.view addSubview:self.typefaceView];
    
    self.fontColorView = [[FontColorView alloc]initWithFrame:CGRectMake(0, ScreenHeight-66, ScreenWidth, 66)];
    self.fontColorView.delegete = self;
    self.fontColorView.hidden = YES;
    [self.view addSubview:self.fontColorView];
    
    self.backgroundColorView = [[BackgroundColorView alloc]initWithFrame:CGRectMake(0, ScreenHeight-66, ScreenWidth, 66)];
    self.backgroundColorView.delegete = self;
    self.backgroundColorView.hidden = YES;
    [self.view addSubview:self.backgroundColorView];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-66) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ColorFromRGB(0xEFEFF4);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.ima_ARR.count;
}

#pragma mark 设置cell每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
   view.backgroundColor = [UIColor clearColor];
   return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CarriedOutViewCell *cell=[[CarriedOutViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.cellHeight = self.viewModel.cellHeight;
    cell.image = self.viewModel.ima_ARR[indexPath.section];
    
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        if ([arr[5] integerValue] == indexPath.section) {
            [cell.contentView addSubview:arr[0]];
            [cell.contentView addSubview:arr[1]];
            [cell.contentView addSubview:arr[2]];
        }
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断tableView首次加载完成
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        dispatch_async(dispatch_get_main_queue(),^{
            [self initcellMiddle];
        });
    }
}

- (void)initcellMiddle {
    [self.viewModel getCellProperty:_tableView];
    self.cellMiddle = self.viewModel.cellMiddle;
    self.cellMiddleSection = self.viewModel.cellMiddleSection;
    self.cellRect = self.viewModel.cellRect;
}

//tableView自动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self tableViewScroll:scrollView];
}

/**
 手指拖动滑行
 @param decelerate 滑动明确位移返回NO，自动滑行一段位移返回YES
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate)
        [self tableViewScroll:scrollView];
}
- (void)tableViewScroll:(UIScrollView *)scrollView{
    [self.viewModel tableViewScroll:scrollView tableView:_tableView];
    self.cellMiddle = self.viewModel.cellMiddle;
    self.cellMiddleSection = self.viewModel.cellMiddleSection;
    self.cellRect = self.viewModel.cellRect;
    self.sectionLabel.text = [NSString stringWithFormat:@"%ld",self.cellMiddleSection+1];
}

#pragma mark - CalloutBottomViewDelegate
//添加标注
- (void)A_CalloutBottomViewBtnClick:(UITextView *)textView delButton:(UIButton *)delButton dragView:(UIView *)dragView countTag:(NSInteger)countTag typeface:(NSString *)typeface fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor backColor:(UIColor *)backColor {
    CurrentTextTag = Text_Tag + countTag;
    self.count = 0;
    self.textView = textView;
    self.delButton = delButton;
    self.dragView = dragView;
    [self.cellMiddle.contentView addSubview:self.textView];
    [self.cellMiddle.contentView addSubview:self.delButton];
    [self.cellMiddle.contentView addSubview:self.dragView];
    NSArray *arr = @[textView,dragView,delButton,[NSNumber numberWithInteger:countTag],[NSNumber numberWithInteger:self.count],[NSNumber numberWithInteger:self.cellMiddleSection],typeface,[NSNumber numberWithInteger:fontSize],fontColor,backColor];
    [self.array addObject:arr];
    [self CalloutBottomViewNotNot];
    if (CGRectGetMaxY(self.cellRect)<=(ScreenHeight-66)) {
        self.textView.frame = CGRectMake(80, self.viewModel.cellHeight-120, self.InitialWidth, self.InitialHeight);
    } else {
        float moreHeight = CGRectGetMaxY(self.cellRect)-(ScreenHeight-66);
        self.textView.frame = CGRectMake(80, moreHeight+120, self.InitialWidth, self.InitialHeight);
    }
    
    self.dragView.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)-view_X, CGRectGetMaxY(self.textView.frame)-self.InitialHeight/self.InitialWidth*view_X, moveViewSize, moveViewSize);
    self.delButton.frame = CGRectMake(CGRectGetMinX(self.textView.frame) - delBtnSize+5, CGRectGetMinY(self.textView.frame) - delBtnSize+5, delBtnSize, delBtnSize);
}
//移动标注
- (void)textViewPanGuestre:(UIPanGestureRecognizer *)recognizer {
    CurrentTextTag = recognizer.view.tag;
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        if ([arr[3] integerValue] == recognizer.view.tag - Text_Tag) {
            self.textView = (UITextView *)[self.view viewWithTag:recognizer.view.tag];
            self.dragView = (UIView *)[self.view viewWithTag:recognizer.view.tag - Text_Tag + DragView_Tag];
            self.delButton = (UIButton *)[self.view viewWithTag:recognizer.view.tag - Text_Tag + DelButton_Tag];
            self.textView.frame = [self.viewModel PanGuestre:[arr[4] integerValue] sourcePoint:self.sourcePoint textViewFrame:self.textView.frame cellMiddleSection:[arr[5] integerValue] tableView:self.tableView recognizer:recognizer];
            self.dragView.frame = CGRectMake(CGRectGetMaxX(self.textView.frame)-view_X, CGRectGetMaxY(self.textView.frame)-self.InitialHeight/self.InitialWidth*view_X, moveViewSize, moveViewSize);
            self.delButton.frame = CGRectMake(CGRectGetMinX(self.textView.frame) - delBtnSize+5, CGRectGetMinY(self.textView.frame) - delBtnSize+5, delBtnSize, delBtnSize);
            self.count = self.viewModel.count;
            self.sourcePoint = self.viewModel.sourcePoint;
            NSArray *arrA = @[self.textView,self.dragView,self.delButton,arr[3],[NSNumber numberWithInteger:self.count],[NSNumber numberWithInteger:self.cellMiddleSection],arr[6],arr[7],arr[8],arr[9]];
            [self.array replaceObjectAtIndex:i withObject:arrA];
            break;
        }
    }
}
//删除标注
- (void)deleteEvents:(UIButton *)button {
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        if ([arr[3] integerValue] == button.tag - DelButton_Tag) {
            self.textView = (UITextView *)[self.view viewWithTag:button.tag - DelButton_Tag + Text_Tag];
            self.dragView = (UIView *)[self.view viewWithTag:button.tag - DelButton_Tag + DragView_Tag];
            self.delButton = (UIButton *)[self.view viewWithTag:button.tag];
            [self.textView removeFromSuperview];
            [self.dragView removeFromSuperview];
            [self.delButton removeFromSuperview];
            [self.array removeObjectAtIndex:i];
            [self CalloutBottomViewNotNot];
            break;
        }
    }
}
//输入框形状改变
- (void)viewZoomPanGuestre:(UIPanGestureRecognizer *)recognizer {
    CurrentTextTag = recognizer.view.tag - DragView_Tag + Text_Tag;
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        if ([arr[3] integerValue] == recognizer.view.tag - DragView_Tag) {
            self.textView = (UITextView *)[self.view viewWithTag:recognizer.view.tag - DragView_Tag + Text_Tag];
            self.dragView = (UIView *)[self.view viewWithTag:recognizer.view.tag];
            self.dragView.frame = [self.viewModel ZoomPanGuestre:self.sourcePoint textViewFrame:self.textView.frame viewFrame:self.dragView.frame initialImageWidth:self.InitialWidth initialImageHeight:self.InitialHeight cellMiddleSection:[arr[5] integerValue] tableView:self.tableView recognizer:recognizer];
            self.textView.frame = CGRectMake(CGRectGetMinX(self.textView.frame), CGRectGetMinY(self.textView.frame), CGRectGetMinX(self.dragView.frame)-CGRectGetMinX(self.textView.frame)+view_X, CGRectGetMinY(self.dragView.frame)-CGRectGetMinY(self.textView.frame)+self.InitialHeight/self.InitialWidth*view_X);
//            self.delButton.frame = CGRectMake(CGRectGetMinX(self.textView.frame) - delBtnSize+5, CGRectGetMinY(self.textView.frame) - delBtnSize+5, delBtnSize, delBtnSize);
            self.sourcePoint = self.viewModel.sourcePoint;
            NSArray *arrA = @[self.textView,self.dragView,arr[2],arr[3],arr[4],arr[5],arr[6],arr[7],arr[8],arr[9]];
            [self.array replaceObjectAtIndex:i withObject:arrA];
            break;
        }
    }
}

- (void)monitorEvents:(UITextView *)textView {
    CurrentTextTag = textView.tag;
}

- (void)textViewBeginEdit:(UITextView *)textView {
    CurrentTextTag = textView.tag;
}


- (void)B_CalloutBottomViewBtnClick {
    self.calloutBottomView.hidden = YES;
    self.fontSizeView.hidden = NO;
}

- (void)C_CalloutBottomViewBtnClick {
   self.calloutBottomView.hidden = YES;
   self.fontColorView.hidden = NO;
}

- (void)D_CalloutBottomViewBtnClick {
    self.calloutBottomView.hidden = YES;
    self.typefaceView.hidden = NO;
}

- (void)E_CalloutBottomViewBtnClick {
    self.calloutBottomView.hidden = YES;
    self.backgroundColorView.hidden = NO;
}

#pragma mark - FontSizeViewDelegate

- (void)FontSizeViewBtnClick {
   self.calloutBottomView.hidden = NO;
   self.fontSizeView.hidden = YES;
}
//选择字号
- (void)FontSizeClick:(NSInteger)fontSize {
    CurrentFontSize = fontSize;
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        self.textView = (UITextView *)[self.view viewWithTag:CurrentTextTag];
        if ([arr[3] integerValue] == CurrentTextTag - Text_Tag && [self.textView isShowingOnKeyWindow]) {
            self.textView.font = [UIFont fontWithName:arr[6] size: fontSize];
            NSArray *arrA = @[self.textView,arr[1],arr[2],arr[3],arr[4],arr[5],arr[6],[NSNumber numberWithInteger:fontSize],arr[8],arr[9]];
            [self.array replaceObjectAtIndex:i withObject:arrA];
            break;
        }
    }
}

#pragma mark - TypefaceViewDelegate

- (void)TypefaceViewBtnClick {
   self.calloutBottomView.hidden = NO;
   self.typefaceView.hidden = YES;
}
//选择字体
- (void)TypefaceClick:(NSString *)colorStr {
    CurrentTypeface = colorStr;
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        self.textView = (UITextView *)[self.view viewWithTag:CurrentTextTag];
        if ([arr[3] integerValue] == CurrentTextTag - Text_Tag && [self.textView isShowingOnKeyWindow]) {
            self.textView.font = [UIFont fontWithName:colorStr size:[arr[7] integerValue]];
            NSArray *arrA = @[self.textView,arr[1],arr[2],arr[3],arr[4],arr[5],colorStr,arr[7],arr[8],arr[9]];
            [self.array replaceObjectAtIndex:i withObject:arrA];
            break;
        }
    }
}

#pragma mark - FontColorViewDelegate

- (void)FontColorViewBtnClick {
   self.calloutBottomView.hidden = NO;
   self.fontColorView.hidden = YES;
}
//选择文字颜色
- (void)FontColorClick:(UIButton *)btn {
    CurrentFontColor = btn.backgroundColor;
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        self.textView = (UITextView *)[self.view viewWithTag:CurrentTextTag];
        if ([arr[3] integerValue] == CurrentTextTag - Text_Tag && [self.textView isShowingOnKeyWindow]) {
            self.textView.textColor = btn.backgroundColor;
            NSArray *arrA = @[self.textView,arr[1],arr[2],arr[3],arr[4],arr[5],arr[6],arr[7],btn.backgroundColor,arr[9]];
            [self.array replaceObjectAtIndex:i withObject:arrA];
            break;
        }
    }
}

#pragma mark - BackgroundColorViewDelegate

- (void)BackgroundColorViewBtnClick {
   self.calloutBottomView.hidden = NO;
   self.backgroundColorView.hidden = YES;
}
//选择背景颜色
- (void)BackgroundColorClick:(UIButton *)btn {
    CurrentbackColor = btn.backgroundColor;
    for (int i = 0; i < self.array.count; ++i) {
        NSArray *arr = self.array[i];
        self.textView = (UITextView *)[self.view viewWithTag:CurrentTextTag];
        if ([arr[3] integerValue] == CurrentTextTag - Text_Tag && [self.textView isShowingOnKeyWindow]) {
            self.textView.backgroundColor = btn.backgroundColor;
            NSArray *arrA = @[self.textView,arr[1],arr[2],arr[3],arr[4],arr[5],arr[6],arr[7],arr[8],btn.backgroundColor];
            [self.array replaceObjectAtIndex:i withObject:arrA];
            break;
        }
    }
}

#pragma mark - 通知

- (void)CalloutBottomViewNotNot {
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)self.array.count];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:str,@"key1", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalloutBottomView" object:nil userInfo:dict];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
