//
//  CalloutViewModel.h
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalloutViewModel : NSObject
@property (nonatomic, assign) NSInteger                  pageSum;//PDF文件的总页数
@property (nonatomic, strong) NSMutableArray            *ima_ARR;//每页PDF子文件转为UIImage的总PDF图片集合
@property (nonatomic, assign) CGFloat                    cellHeight;//每页PDF的高度


@property (nonatomic, strong) UITableViewCell           *cellMiddle;//居中的cell(随着滑动而变化)
@property (nonatomic, assign) NSInteger                  cellMiddleSection;//居中的cell的section
@property (nonatomic, assign) CGRect                     cellRect;//居中的cell相对屏幕的位置

@property (nonatomic, assign) CGPoint                    sourcePoint;//前一刻的位置
@property (nonatomic, assign) NSInteger                  count;

@property (nonatomic, copy) void (^popControllerBlock)(NSString *fileName);

- (instancetype)initWithURL:(NSURL *)url;
- (void)getCellProperty:(UITableView *)tableView;
- (void)tableViewScroll:(UIScrollView *)scrollView tableView:(UITableView *)tableView;

- (CGRect)PanGuestre:(NSInteger)count
         sourcePoint:(CGPoint)sourcePoint
       textViewFrame:(CGRect)textViewFrame
   cellMiddleSection:(NSInteger)cellMiddleSection
           tableView:(UITableView *)tableView
          recognizer:(UIPanGestureRecognizer *)recognizer;

- (CGRect)ZoomPanGuestre:(CGPoint)sourcePoint
           textViewFrame:(CGRect)textViewFrame
               viewFrame:(CGRect)viewFrame
       initialImageWidth:(CGFloat)initialImageWidth
      initialImageHeight:(CGFloat)initialImageHeight
       cellMiddleSection:(NSInteger)cellMiddleSection
               tableView:(UITableView *)tableView
              recognizer:(UIPanGestureRecognizer *)recognizer;



@end

NS_ASSUME_NONNULL_END
