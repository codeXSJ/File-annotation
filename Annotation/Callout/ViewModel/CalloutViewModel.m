//
//  CalloutViewModel.m
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "CalloutViewModel.h"
#import "UIImage+Util.h"

@implementation CalloutViewModel

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        CFURLRef ref = (__bridge CFURLRef)url;
        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL(ref);
        
        CFRelease(ref);

        self.pageSum = (int)CGPDFDocumentGetNumberOfPages(pdfDocument);
        self.ima_ARR = [[NSMutableArray alloc]init];
        for (int p = 1; p <= self.pageSum; ++p) {
            CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, p);
            [self.ima_ARR addObject:[Methods getUIImageFromPDFPage:page]];
            if (p == 1) {
                if (ScreenWidth <= [Methods getUIImageFromPDFPage:page].size.width) {
                    self.cellHeight = (ScreenWidth*1.0/[Methods getUIImageFromPDFPage:page].size.width*[Methods getUIImageFromPDFPage:page].size.height);
                }
                else {
                    self.cellHeight = [Methods getUIImageFromPDFPage:page].size.height;
                }
            }
        }
    }
    return self;
}

- (void)getCellProperty:(UITableView *)tableView {
    CGFloat offSetY =  CGRectGetHeight(tableView.frame) / 2;
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:CGPointMake(0, offSetY)];
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0  inSection:0];
    self.cellMiddle = [tableView cellForRowAtIndexPath:indexPath];
       
    self.cellMiddleSection = indexPath.section;
        
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];

    self.cellRect = [tableView convertRect:rectInTableView toView:[tableView superview]];
}

- (void)tableViewScroll:(UIScrollView *)scrollView tableView:(UITableView *)tableView; {
    /*
         获取处于屏幕中心的cell
         系统方法返回处于tableView某坐标处的cell的indexPath
        */
        
        //scrollView的Y轴偏移量+tableView高度的一半为整个scrollView内容高度的一半
    CGFloat offSetY = scrollView.contentOffset.y + CGRectGetHeight(tableView.frame) / 2;
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:CGPointMake(0, offSetY)];
    self.cellMiddle = [tableView cellForRowAtIndexPath:indexPath];
    self.cellMiddleSection = (long)indexPath.section;
        
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];

    self.cellRect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    NSLog(@"section: %ld - row: %ld - cellName = %@",(long)indexPath.section, (long)indexPath.row, NSStringFromCGRect(self.cellRect));
}

//获取当前签名图片所在 cell 在屏幕上的位置坐标
-(CGRect)getCellCGRect:(long)Section tableView:(UITableView *)tableView{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:Section];
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect Rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
    return Rect;
}

- (CGRect)PanGuestre:(NSInteger)count
         sourcePoint:(CGPoint)sourcePoint
       textViewFrame:(CGRect)textViewFrame
   cellMiddleSection:(NSInteger)cellMiddleSection
           tableView:(UITableView *)tableView
          recognizer:(UIPanGestureRecognizer *)recognizer {
    self.count = count;
    CGPoint p;
    p=[recognizer locationInView:recognizer.view.superview];
    if (self.count == 0) {
        ++self.count;
        self.sourcePoint=p;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        ++self.count;
        self.sourcePoint=p;
    } else {
        CGRect r = textViewFrame;
        CGRect cellRect = [self getCellCGRect:cellMiddleSection tableView:tableView];
        float x = 0.0;
        if (r.origin.x+(p.x-self.sourcePoint.x) <= 0) {
            x = 0;
            self.count = 0;
        } else if ( r.origin.x+(p.x-self.sourcePoint.x) + r.size.width >= ScreenWidth){
            x = ScreenWidth - r.size.width;
            self.count = 0;
        } else {
            x = r.origin.x+(p.x-self.sourcePoint.x);
        }
        float y = r.origin.y+(p.y-self.sourcePoint.y);
        if (cellRect.origin.y <= NaviHeight && y+cellRect.origin.y-NaviHeight<= 0) {
            //当 cell 顶部有部分被导航栏遮挡的情况下(图片向上滑动)
            y = NaviHeight-cellRect.origin.y;
            self.count = 0;
               
        } else if (cellRect.origin.y > NaviHeight && y <= 0) {
            //当 cell 顶部没有被导航栏遮挡的情况下(图片向上滑动)
            y = 0;
            self.count = 0;
               
        } else if (y+r.size.height >= cellRect.size.height) {
            //当 cell 底部没有被工具栏遮挡的情况下(图片向下滑动)
            y = cellRect.size.height-r.size.height;
            self.count = 0;
        } else if (cellRect.origin.y+y+r.size.height >= ScreenHeight-44-40 && cellRect.origin.y+cellRect.size.height >= ScreenHeight-44-40) {
            //当 cell 底部有部分被工具栏遮挡的情况下(图片向下滑动)
            y = ScreenHeight-44-40-cellRect.origin.y-r.size.height;
            self.count = 0;
                
        } else {
            y = r.origin.y+(p.y-self.sourcePoint.y);
        }
        self.sourcePoint=p;
        return CGRectMake(x, y, r.size.width, r.size.height);
    }
    return textViewFrame;
}

- (CGRect)ZoomPanGuestre:(CGPoint)sourcePoint
           textViewFrame:(CGRect)textViewFrame
               viewFrame:(CGRect)viewFrame
       initialImageWidth:(CGFloat)initialImageWidth
      initialImageHeight:(CGFloat)initialImageHeight
       cellMiddleSection:(NSInteger)cellMiddleSection
               tableView:(UITableView *)tableView
              recognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint p;
    p=[recognizer locationInView:recognizer.view.superview];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.sourcePoint=p;
    } else {
        CGRect r = viewFrame;
        CGRect cellRect = [self getCellCGRect:cellMiddleSection tableView:tableView];
        float x = r.origin.x+(p.x-sourcePoint.x);
        float y = r.origin.y+(p.y-sourcePoint.y);
        if (x <= CGRectGetMinX(textViewFrame)+ 30) {
            x = CGRectGetMinX(textViewFrame)+ 30;
        }
        if (y <= CGRectGetMinY(textViewFrame)+ 30) {
            y = CGRectGetMinY(textViewFrame)+ 30;
        }
        if ( x + r.size.width >= ScreenWidth ){
            x = ScreenWidth - r.size.width;
        }
        if (y+r.size.height >= cellRect.size.height) {
            //当 cell 底部没有被工具栏遮挡的情况下(图片向下滑动)
            y = cellRect.size.height-r.size.height;
        }
       
        self.sourcePoint=p;
        return CGRectMake(x, y, r.size.width, r.size.height);
    }
    return viewFrame;
}

//view转image
-(UIImage *)imageForView:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }else{
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
