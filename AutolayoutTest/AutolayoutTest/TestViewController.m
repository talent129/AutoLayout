//
//  TestViewController.m
//  AutolayoutTest
//
//  Created by xuzifu on 15/11/28.
//  Copyright © 2015年 cai. All rights reserved.
//

//http://blog.csdn.net/zhuzhihai1988/article/details/43926055
//http://www.bkjia.com/IOSjc/963524.html
//http://www.bkjia.com/Androidjc/935275.html

//学习AutoLayout之前，必须要完全抛弃传统的frame属性，先完成思想的扭转学习起来方能事半功倍

/**
 *
 * AutoLayout是苹果ios6出来的东西，与传统的Frame属性不同。每一个view对象都有一个frame属性，
 frame属于CGrect对象，通过苹果的Api可以得知，CGrect其实是一个结构体。
 struct CGRect {
    CGPoint origin;
    CGSize size;
 };
 typedef struct CGRect CGRect;一个是控制坐标的CGPoint，一个是控制大小的CGSize。
 而AutoLayout是通过约束来实现布局的。一个view一旦使用了AutoLayout约束，
 那么它的frame将永远都是0.
 *
 */

/**
 *  使用AutoLayout之前需要知道以下两点：
 
 1.必须设置 translatesAutoresizingMaskIntoConstraints为NO。
 
 2.如果是viewControl则AutoLayout适配写在[- updateViewConstraints]中；
 
 如果是view则AutoLayout适配写在[- updateConstraints]中。
 *
 */

/**
 *  在官方的api中，对约束有一个计算公式
    Create constraints explicitly.  Constraints are of the form "view1.attr1 = view2.attr2 * multiplier + constant"
 */

/**
 *  AutoLayout是从IOS 6开始苹果引入来取代autoresizing的新的布局技术，该技术有三种设置方式
 */

/**
 *  先简单的说一下autolayout能够设置哪些行为:
 1.视图的大小（即视图的绝对大小）。
 
 2.视图的位置（视图相对于父视图或者兄弟视图的位置）。
 
 3.视图的对齐方式（相对于父视图或者相对于兄弟视图）
 可以看到autolayout相比autoresizing技术来说要灵活的多，该技术有很多布局的约束设置。这次主要讲的用代码来设置AutoLayout，代码向我们需要添加autoLayout视图使用该方法
 *
 *  注：autoresizing只能相对于父视图来设置子视图的各种属性，而不能根据其兄弟视图来设置，这是autoresizing的鸡肋所在
 */

/**
 *  +(instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
 *
 *   该方法实际上就是满足一个数学关系:
        item1 =(>=,<=) multiplier * item2 + constant
 参数说明：
 
 view1：第一个视图即item1。
 
 attr1：是第一个视图选择的属性
 
 relation：即中间的关系（= , >= , <=）
 
 view2：第二个视图即item2。
 
 attr2：是第二个视图选择的属性
 
 c：就是常熟constant。
 */

/**
 *  我们所有可以控制的属性：
 
 NSLayoutAttributeLeft	视图的左边
 NSLayoutAttributeRight	视图的右边
 NSLayoutAttributeTop	视图的上边
 NSLayoutAttributeBottom	视图的下边
 NSLayoutAttributeLeading	视图的前边
 NSLayoutAttributeTrailing	视图的后边
 NSLayoutAttributeWidth	视图的宽度
 NSLayoutAttributeHeight	视图的高度
 NSLayoutAttributeCenterX	视图的中点的X值
 NSLayoutAttributeCenterY	视图中点的Y值
 NSLayoutAttributeBaseline	视图的基准线
 NSLayoutAttributeNotAnAttribute	无属性
 *
 解释一下前边NSLayoutAttributeLeading和后边NSLayoutAttributeTrailing，这里前边和后边并不是总是为左边和右边的，有些国家的前边是右边后边是左边所以这样设定是为了国际化考虑。还有视图基准线NSLayoutAttributeBaseline通常是指视图的底部放文字的地方。
 */

//分三部分解释 NSLayoutAttribute
/**
 *  第一部分：常用的
 
 NSLayoutAttributeLeft:  CGRectGetMinX(view.frame) ;
 
 NSLayoutAttributeRight:  CGRectGetMaxX(view.frame);
 
 NSLayoutAttributeTop:  CGRectGetMinY(view.frame);
 
 NSLayoutAttributeBottom:  CGRectGetMinY(view.frame);
 
 NSLayoutAttributeWidth:  CGRectGetWidth(view.frame) ;
 
 NSLayoutAttributeHeight: CGRectGetHeight(view.frame) ;
 
 NSLayoutAttribute CenterX : view.center.x ;
 
 NSLayoutAttribute CenterY :view.center.y  ;
 
 NSLayoutAttributeBaseline: 文本底标线，在大多数视图中等同于NSLayoutAttributeBottom； 在少数视图，如UILabel，是指字母的底部出现的位置 ;
 
 NSLayoutAttributeLastBaseline: 相当于NSLayoutAttributeBaseline ;
 
 NSLayoutAttributeFirstBaseline: 文本上标线 ;
 
 NSLayoutAttribute NotAnAttribute: None ;
 */

/**
 *  第二部分： 根据国家使用习惯不同表示的意思不同
 *  NSLayoutAttributeLeading: 在习惯由左向右看的地区，相当于NSLayoutAttributeLeft；在习惯从右至左看的地区，相当于NSLayoutAttributeRight ;
 
    NSLayoutAttribute Trailing: 在习惯由左向右看的地区，相当于NSLayoutAttributeRight；在习惯从右至左看的地区，相当于NSLayoutAttributeLeft ;
 */

/**
 *  第三部分：ios8新增属性，各种间距，具体用法下节介绍
 *NSLayoutAttributeLeftMargin，
 
 NSLayoutAttributeRightMargin，
 
 NSLayoutAttributeTopMargin，
 
 NSLayoutAttributeBottomMargin，
 
 NSLayoutAttributeLeadingMargin，
 
 NSLayoutAttributeTrailingMargin，
 
 NSLayoutAttributeCenterXWithinMargins，
 
 NSLayoutAttributeCenterYWithinMargins，
 */

//要讲解的方法
/**
 *  1、获取当前view中所有的  NSLayoutConstraint
 
    - (NSArray *)constraints NS_AVAILABLE_IOS(6_0);
 *
 */

/**
 *  2、旧版方法，将指定的NSLayoutConstraint添加到页面或者从页面中移除
 
 *  1 1 - (void)addConstraint:(NSLayoutConstraint *)constraint NS_AVAILABLE_IOS(6_0); // This method will be deprecated in a future release and should be avoided.  Instead, set NSLayoutConstraint's active property to YES.
 2 2 - (void)addConstraints:(NSArray *)constraints NS_AVAILABLE_IOS(6_0); // This method will be deprecated in a future release and should be avoided.  Instead use +[NSLayoutConstraint activateConstraints:].
 3 3 - (void)removeConstraint:(NSLayoutConstraint *)constraint NS_AVAILABLE_IOS(6_0); // This method will be deprecated in a future release and should be avoided.  Instead set NSLayoutConstraint's active property to NO.
 4 4 - (void)removeConstraints:(NSArray *)constraints NS_AVAILABLE_IOS(6_0); // This method will be deprecated in a future release and should be avoided.  Instead use +[NSLayoutConstraint deactivateConstraints:].
 */

    //3、ios8新加方法，激活或者停用指定约束
    /* The receiver may be activated or deactivated by manipulating this property.  Only active constraints affect the calculated layout.  Attempting to activate a constraint whose items have no common ancestor will cause an exception to be thrown.  Defaults to NO for newly created constraints. */
    //@property (getter=isActive) BOOL active NS_AVAILABLE(10_10, 8_0);

    /* Convenience method that activates each constraint in the contained array, in the same manner as setting active=YES. This is often more efficient than activating each constraint individually. */
    //+ (void)activateConstraints:(NSArray *)constraints NS_AVAILABLE(10_10, 8_0);

    /* Convenience method that deactivates each constraint in the contained array, in the same manner as setting active=NO. This is often more efficient than deactivating each constraint individually. */
    //+ (void)deactivateConstraints:(NSArray *)constraints NS_AVAILABLE(10_10, 8_0);

//三、Coding Time
/**
 *  a> 设置视图view1为 宽度=20的正方形
 *  两种写法
 */

/**
    第一种 宽度=20，高度=20
 *  1     [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
 2     [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
 */

/**
 *  第二种 宽度=20， 高度=宽度
 *  1     [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
 2     [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
 第二种方法的优势是，如果想修改view1的大小，只需要修改一处。
 */

/**
    b>设置视图view1.frame. origin.x = 视图view2.frame.origin.x
 
 *  NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]；
 
 //旧版方法
 //[self addConstraint:leftConstraint];
 
 //新版方法1
 [NSLayoutConstraint activateConstraints:@[leftConstraint]];
 //新版方法2
 leftConstraint.active = YES;
 */


#import "TestViewController.h"
#import "AnotherTestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"test";
    
    //Demo1
    [self createView];
    
    //Demo2
    [self createUI];
    
    //Demo3
    [self createViewRightTop];
    
    //button
    [self createButton];
    
}

//可视化语言的方式来出创建约束
/**
    利用到的函数：
 *  + (NSArray *)constraintsWithVisualFormat:(NSString *)format
 options:(NSLayoutFormatOptions)opts
 metrics:(NSDictionary *)metrics
 views:(NSDictionary *)views
 
 参数的的意义
 
 参数	意义
 format	NSString类型的可视语言描述
 opts	描述可视化语言中对象的layout方向
 metrics	描述可视化语言中String代表的常量值，字典类型，key为String，value为NSNumber类型
 views	描述可视化语言中String代表的对象，字典类型，key为String，value为layout约束的对象

 */
- (void)createButton
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:btn];
    
    //垂直方向上
    NSArray *c_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(==30)]"
                                                           options:0
                                                           metrics:nil
                                                             views:@{@"btn":btn}];
    //水平方向上
    NSArray *c_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(==100)]"
                                                           options:0
                                                           metrics:nil
                                                             views:@{@"btn":btn}];
    
    [self.view addConstraints:c_h];
    [self.view addConstraints:c_v];
    
    NSArray *l_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-hdistance-[btn]"
                                                           options:0
                                                           metrics:@{@"hdistance":@(500)}
                                                             views:@{@"btn":btn}];
    
    NSArray *l_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn]-vdistance-|"
                                                           options:0
                                                           metrics:@{@"vdistance":@(self.view.bounds.size.width/2 - 50)}
                                                             views:@{@"btn":btn}];
    [self.view addConstraints:l_v];
    [self.view addConstraints:l_h];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)btn
{
    AnotherTestViewController *anotherTestVC = [[AnotherTestViewController alloc] init];
    [self.navigationController pushViewController:anotherTestVC animated:YES];
}

//距离右上 均为30
- (void)createViewRightTop
{
    UIView *testView = [[UIView alloc] init];
    testView.backgroundColor = [UIColor yellowColor];
    
    testView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:testView];
    
    NSLayoutConstraint *testConstraintWidth = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60];
    
    NSLayoutConstraint *testConstraintHeight = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30];
    
    NSLayoutConstraint *viewConstraintTop = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:94];
    
    NSLayoutConstraint *viewConstraintRight = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-30];
    
    [testView addConstraints:@[testConstraintWidth, testConstraintHeight]];
    [self.view addConstraints:@[viewConstraintRight, viewConstraintTop]];
}

/**
 *  让两个视图Y方向居中，第一个视图距离左边缘20，第一个视图以第二个视图等大并且X方向距离为100。
 */
- (void)createUI
{
    UIView *view1 = [[UIView alloc] init];
    UIView *view2 = [[UIView alloc] init];
    
    view1.backgroundColor = [UIColor orangeColor];
    view2.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    //不提倡调用方法也用点语法，，，易混淆
    //设置view的 translatesAutoresizingMaskIntoConstraints 属性为NO，意思就是遵循autoLayout抛弃原有设置的高度宽度等，使用autolayout的视图必须要设置该属性
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    
    //设置view1的高度和宽度
    //设置view1的宽和高，大家可能已经发现item2为nil并且attrbute为attribute:NSLayoutAttributeNotAnAttribute，这样做我们带入公式就会明白  item1 = m * 0 + constant。也就是直接设置本视图的宽和高。
    [view1 addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    
    [view1 addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    
    //设置view2的高度和宽度
    //设置view2的宽高和view1相同，这里细心的同学可能会发现添加约束的对象并不是像上面设置宽高时的view1，而是它们共同的父视图self.view。因为在autolayout中有这样的规定，如果是一元约束，即只针对自己的约束，那么就直接添加在该视图上。如果是二元约束，那么就必须要添加在它们的共同最近的父视图上面
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    //set relationship between view1 and view2
    //设置view1和view2的关系，设置view1和view2具有相同的Y，并且view2在view1右边距离100的位置
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeRight multiplier:1 constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    //set relationship between topView and view1
    //设置了view1左边距离父视图左边20的距离，并且view1的Y等于父视图Y的中点值
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
    
    //或者如下方法
    /**
     注：
     *  但只能用NSLayoutAttributeLeading/NSLayoutAttributeTrailing
        或者NSLayoutAttributeLeft/NSLayoutAttributeRight
        （前/后）
     否则报错：
     reason: '*** +[NSLayoutConstraint constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:]: A constraint cannot be made between a leading/trailing attribute and a right/left attribute. Use leading/trailing for both or neither.'
     */
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    //运行结果：视图1在距左边20的位置，视图1视图2都Y方向居中并且相距100的距离
}

- (void)createView
{
    UIView *view1 = [[UIView alloc] init];
    //为了不和autoresizing冲突，将此设置为NO
    [view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    view1.backgroundColor = [UIColor redColor];
    //这个，必须先添加到父视图上，如果将view1、view2添加到父视图的代码像以前那样放在最后，会报错
    //此处报错原因：
    /*
     reason: 'Unable to parse constraint format:
     Unable to interpret '|' character, because the related view doesn't have a superview
     H:|-(>=50)-[view1(100)]
     ^'
     */
    [self.view addSubview:view1];

    UIView *view2 = [[UIView alloc] init];
    [view2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    view2.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:view2];
    
    //其实NSDictionaryOfVariableBindings宏  等效于 [NSDictionary dictionaryWithObjectsAndKeys:@"view1", view1, @"view2", view2, nil];
    NSDictionary *views = NSDictionaryOfVariableBindings(view1, view2);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=50)-[view1(100)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=100)-[view1(50)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view2(==view1)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view2(==view1)]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    //添加一个限制  等效于 view2.frame.origin.x  = (view1.frame.origin.x +view1.frame.size.width)  * 1  + 10,好像是这样的！个人觉得！
    //    它是一种依赖关系，view2依赖view1，这样就算view1变了，view2也会跟着变换。
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:view2
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view1
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:10]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:view2
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view1
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0]];
    /*
    constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:
     Create a constraint of the form "view1.attr1 <relation> view2.attr2 * multiplier + constant".
     属性
     
     最后的结果就是 “view1.attr1  <       >=    或者 ==   或者    <=       >  view2.attr2 * multiplier + constant”
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
