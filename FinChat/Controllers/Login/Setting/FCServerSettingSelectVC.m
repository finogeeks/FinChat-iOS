//
//  FCServerSettingUrlListVC.m
//  FinChat
//
//  Created by xujiaqiang on 2018/11/20.
//  Copyright © 2018年 finogeeks. All rights reserved.
//

#import "FCServerSettingSelectVC.h"
#import "FCServerSettingAddVC.h"
#import "FCService.h"
#import "FCHUD.h"
#import "UIColor+Fino.h"
#import "FCUIHelper.h"

#import <Masonry.h>
#import <FinChatSDK/FinoChat.h>

@interface FINServerUrlSelectedCell : UITableViewCell
@property (nonatomic,strong) UILabel *tLabel;
@property (nonatomic,strong) UIButton *selectButton;
@end

@implementation FINServerUrlSelectedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.selectButton.userInteractionEnabled = NO;
    self.selectButton = [[UIButton alloc] init];
    [self.contentView addSubview:self.selectButton];
    
    UIImage *selectedImg = [FCUIHelper fin_imageWithTintColor:FINThemeNormalColor image:[UIImage imageNamed:@"sdk_login_seletced"]];
    [self.selectButton setImage:selectedImg forState:UIControlStateSelected];
    
    self.selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    self.tLabel = [[UILabel alloc] init];
    self.tLabel.textColor = [UIColor fin_colorWithHexString:@"333333"];
    self.tLabel.font = [UIFont systemFontOfSize:17];
    self.tLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.tLabel];
    [self.tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.height.centerY.equalTo(self.contentView);
        make.right.equalTo(self.selectButton.mas_left).offset(-10);
    }];
}
@end

@interface FCServerSettingSelectVC () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *serverUrlArray;
@property (nonatomic,strong) NSMutableArray *customUrlArray;
@end

@implementation FCServerSettingSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_initNavigationBar];
    [self getData];
    [self setupTableView];
}

- (void)p_initNavigationBar
{
    self.title = @"选择服务器";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sdk_login_setting_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addServerUrlBtnAction:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadLocalDataAndReloadTableView];
    self.navigationController.navigationBarHidden = NO;
    
    [UIApplication sharedApplication].statusBarStyle = FINStatusBarStyle;
    self.navigationController.navigationBar.barTintColor = FINNavBackgroundColor;
    self.navigationController.navigationBar.tintColor = FINNavBarItemNormalColor;
    // 设置navBar选中时字体颜色添加到主题色池中
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = FINNavTitleColor;
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)getData {
    NSString *urlstr=@"https://api.finogeeks.club/api/v1/platform/server";
    NSURL*url=[NSURL URLWithString:urlstr];
    //初始化一个可变请求
    NSMutableURLRequest*requset=[NSMutableURLRequest requestWithURL:url];
    //设置超时时间
    requset.timeoutInterval = 5;
    [requset setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    requset.HTTPMethod=@"GET";
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error==nil) {
            //获取相应信息
            NSString *content=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            @try {
                //解析json
                NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSArray *array = dic[@"data"];
                if (array && [array isKindOfClass:[NSArray class]]) {
                    self.serverUrlArray = [[NSMutableArray alloc] initWithArray:array];
                }
            } @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [FCHUD showTipsWithMessage:@"服务器地址数组解析错误请重新尝试"];
                });
            } @finally {
                
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [FCHUD showTipsWithMessage:@"服务器地址加载失败请重新尝试"];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadLocalDataAndReloadTableView];
        });
    }];
    [dataTask resume];
}

-(void) reloadLocalDataAndReloadTableView {
    self.customUrlArray = [FCServerSettingAddVC getArchiveObjectWithName:kFinchatCustomServerUrlArray];
    if (self.dataSource == nil) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    [self.dataSource removeAllObjects];
    if (self.serverUrlArray.count > 0) {
        [self.dataSource addObjectsFromArray:self.serverUrlArray];
    }
    if (self.customUrlArray.count > 0) {
        [self.dataSource addObjectsFromArray:self.customUrlArray];
    }
    [self.tableView reloadData];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FINServerUrlSelectedCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor fin_colorWithHexString:@"#f6f6f6"];
    [self.tableView setSeparatorColor:[UIColor fin_colorWithHexString:@"#EDEDEC"]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(void)addServerUrlBtnAction:(UIButton *)sender {
    FCServerSettingAddVC *vc = [[FCServerSettingAddVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FINServerUrlSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *dict = [self.dataSource objectAtIndex:indexPath.row];
    NSString *title = [dict objectForKey:@"server_name"];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* apiurl = [userDefaults stringForKey:@"finochat_apiurl"];
    NSString *server_address = [dict objectForKey:@"server_address"];
    cell.selectButton.selected = [apiurl isEqualToString:server_address];
    cell.tLabel.text = [NSString stringWithFormat:@"%@ (%@)",title,server_address];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSource objectAtIndex:indexPath.row];
    NSString *server_address = [dict objectForKey:@"server_address"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *apiurl = [userDefaults stringForKey:@"finochat_apiurl"];
    
    // 正在使用的服务器不可编辑删除
    if ([apiurl isEqualToString:server_address]) {
        return NO;
    }
    
    // 接口返回的服务器地址不可编辑和删除
    for (NSDictionary *serverDict in self.serverUrlArray) {
        NSString *serverInfoUrl = [serverDict objectForKey:@"server_address"];
        if ([serverInfoUrl isEqualToString:server_address]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    NSDictionary *dict = [self.dataSource objectAtIndex:indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self.customUrlArray removeObject:dict];
        [FCServerSettingAddVC saveArchiveObject:self.customUrlArray name:kFinchatCustomServerUrlArray];
        [self reloadLocalDataAndReloadTableView];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    deleteAction.title = @"删除";
    [actions addObject:deleteAction];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        FCServerSettingAddVC *vc = [[FCServerSettingAddVC alloc] init];
        vc.serverInfoDict = dict;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    editAction.backgroundColor = [UIColor orangeColor];
    [actions addObject:editAction];
    
    return actions;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [self.dataSource objectAtIndex:indexPath.row];
    NSString *server_address = [dict objectForKey:@"server_address"];
    //保存地址
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:server_address forKey:@"finochat_apiurl"];
    [userDefaults synchronize];
    // 更新session
//    [[FCService sharedInstance] initSession:nil onProgress:nil failure:nil];
    [[FCService sharedInstance] initSDK:nil];
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
