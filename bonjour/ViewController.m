//
//  ViewController.m
//  bonjour
//
//  Created by yangrui on 2018/10/24.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSNetServiceDelegate,NSNetServiceBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSNetService *netService ;
@property (strong, nonatomic) NSNetServiceBrowser *netServiceBrowser;


@property (strong, nonatomic) NSMutableArray<NSNetService *> *services;
@end

@implementation ViewController

-(NSMutableArray<NSNetService *> *)services{
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}


- (IBAction)startBtnClick:(id)sender {
//[self setupService];
    
[self setupNetServiceBrowser];
}



#pragma mark- 客户端发布服务
-(void)setupService{
    
//    self.netService = [[NSNetService alloc]initWithDomain:@"local." type:@"_spider._tcp." name:@"" port:4567];
    self.netService = [[NSNetService alloc]initWithDomain:@"" type:@"_spider._tcp." name:@"local." port:4567];
    self.netService.delegate = self;
    [self.netService publish];
}

#pragma mark- 客户端浏览服务
-(void)setupNetServiceBrowser{
    self.netServiceBrowser = [[NSNetServiceBrowser alloc]init];
    self.netServiceBrowser.delegate = self;
//    [self.netServiceBrowser searchForServicesOfType:@"_spider._tcp." inDomain:@"local."];
 [self.netServiceBrowser searchForServicesOfType:@"_spider._tcp." inDomain:@""];
}



#pragma mark- 客户端发布服务代理 NSNetServiceDelegate
// 将要发布服务
- (void)netServiceWillPublish:(NSNetService *)sender{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceWillPublish:",self.textView.text];
}

// 已经发布服务
- (void)netServiceDidPublish:(NSNetService *)sender{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceDidPublish: ",self.textView.text];
}


- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netService:  didNotPublish: ",self.textView.text];
    
}

- (void)netServiceWillResolve:(NSNetService *)sender{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceWillResolve: ",self.textView.text];
    
}

// 在这个代理方法里面拿到 解析的名称/ 类型/域/ 主机名和IP地址等信息
- (void)netServiceDidResolveAddress:(NSNetService *)service{
     NSData *address = service.addresses.firstObject;
        self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceDidResolveAddress: ",self.textView.text];
 
//    //get service's hostName
//    NSString *host = sender.hostName;
//    //get address data
   
  //0a000026
}


//<1002091d 0a000026 00000000 00000000>
//struct sockaddr {
//    uint8_t    len;
//    uint8_t    family;
//    uint16_t   port;
//    uint32_t   ipAddress;
//    char[8]    sin_zero;
//};


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *, NSNumber *> *)errorDict{
        self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceDidPublish: ",self.textView.text];
    
}




// 网络服务停止
- (void)netServiceDidStop:(NSNetService *)sender{
        self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceDidStop: ",self.textView.text];
}

// 网络服务更新
- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netService:  didUpdateTXTRecordData: ",self.textView.text];
}

// 网络服务接收 输入流 输出流
- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netService:  didAcceptConnectionWithInputStream:  outputStream:",self.textView.text];
}



#pragma mark- 客户端浏览服务
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceDidPublish: ",self.textView.text];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceBrowserDidStopSearch:",self.textView.text];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceBrowser:  didNotSearch:",self.textView.text];
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceBrowser:  didFindDomain:  moreComing ",self.textView.text];
    
}
// 发现了服务, 在这个代理方法中来解析响应找到的服务
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing{
   
    self.netService = service;
    service.delegate = self;
    [service resolveWithTimeout:3];
    
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceBrowser:  didFindService:  moreComing ",self.textView.text];
    
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceBrowser:  didRemoveDomain:  moreComing:  ",self.textView.text];
    
}

// 服务被移除了
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing{
    self.textView.text = [NSString stringWithFormat:@"\n %@ \n netServiceBrowser:  didRemoveService: ",self.textView.text];
    
}


@end


/**
 cocoaChina http://www.cocoachina.com/ios/20150918/13434.html
 bonjour 原理
 
 零配置网络需要解决3个需求
 1. 寻址(分配IP地址给主机)
  .轮训的方式检查闲置的ip并分配
 
 2. 命令(使用名字而不是使用IP来代表主机, 名字保证唯一)
  .指定名字: 我想叫"张三"可以吗,不可以, 张三已经被占用了,你只能叫: "张三-1"
  .解析名字: 有没有叫 "张三-1", 你的IP和端口是哪个? 有, 我IP是 192.168.1.1 端口是 54321
 
 3. 服务搜索 (自动在网络搜索服务)
  . 设备在本地网络上发出请求说, 我需要 'xxx' 服务.
  例如: 我要"打印机服务", 本地网络所有"打印机服务" 回应自己的名字
 
 
 
 
 bonjour 减少功耗的原理
 
 我们在使用UDP 广播轮询本地网络其它主机信息时, 会产生大量的网络流量开销

 bonjour 采取了一些机制来降低零配置的开销, 包括缓存/ 禁止重复响应/ 指数回退和服务公告
 
 1. 缓存 
 2. 阻止重复响应
 
 
 */



