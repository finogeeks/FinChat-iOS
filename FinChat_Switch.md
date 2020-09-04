1.开关设置字段说明
```
{
    appKey: appToken，获取方式请咨询商务
    appId: appId 获取方式请咨询商务
    finochatApiURL: 服务器地址
    finochatApiPrefix: 服务器地址版本前缀
    pusherAppIdProd: APNS生产环境的推送appId 即BundleId,
    pusherAppIdDev:  APNS开发环境的推送appId 即BundleId
    appType: app类型 STAFF/RETAIL
    pushGatewayURL: APNS推送服务地址
    reverseRules: {服务器路由规则
        proxy: 代理服务器地址
    },
    settings: {  //app功能的相关配置
        appConfigType:应用配置类型，默认 "default"
        isShowApplet: 是否显示下拉小程序
        diableURLPreview:是否关闭URL预览
        appGroupIdentifier: app共享沙盒id,
        isShowGlobalFeedback: 是否支持截屏反馈
        apmUploadInterval: apm统计的数据的上报时长间隔
        isCloseApm: 是否关闭apm统计功能
        urlSchemaPrefix: urlschema
        hideWXShare: 是否支持分享到微信
        hideNoShareChannelWXAppletShare:隐藏非共享频道微信二维码入口
        hideToDo: 隐藏待办
        hideNotice: 隐藏通知
        hideTask: 是否隐藏任务
        natureOfIndustry: 企业的模板 证券/银行,
        encryptedPassword: 是否开启登录加密功能
        mine: { //个人信息功能的相关配置
            disableEditName: 是否允许编辑昵称
        },
        addressBook: { //通讯录功能的相关配置
            hideLabel: 是否隐藏标签菜单
            hideMyFriend: 是否隐藏我的好友菜单
            hideNewChat: 是否隐藏新的会话菜单
            disableOranaizationSort: 组织架构是否排序
            autoAddFriend: 是否开启自动添加好友功能
            deleteFriend: 是否开启删除好友功能
            hideScanningAndFriends: 是否隐藏扫码加好友
            hideSearchCommunity: 是否隐藏社区搜索菜单
            hideSearchKnowledge: 是否隐藏知识库搜索菜单
            hideSearchMessage: 是否隐藏消息搜索菜单
            hideSearchAddressBook: 是否隐藏通讯录搜索菜单
            hideSearchApplet: 是否隐藏小程序搜索菜单
            hideSearchFile: 是否隐藏文件搜索菜单
            forwardToWX: 是否开启转发到微信功能
            hideSearchChannel: 是否隐藏搜索频道菜单
            hideSearchConversation:是否隐藏搜索会话菜单
            strangerRemark: 是否支持给陌生人设置标签
            labelGroup: 是否给联系人设置标签
            hideVisitorCard:隐藏个人详情页的访客画像
            forwardToOutside:是否开启转发到外部功能
        },
        conversation: { //会话列表功能的相关配置
            isHideFederateChannelType: 是否隐藏公开频道
            isShowDirectChat: 是否显示直聊房间
            isShowAddChannel:是否显示增加频道
            isHideInviteRoom: 是否隐藏邀请房间
            isCreateChannelPrivateOnly :是否只能创建私有频道
            isHideSearchBar: 是否隐藏搜索框
            isHideUnreadNum: 是否隐藏消息的未读数量
            isShowGroupChat: 是否显示创建群聊
            isShowScan: 是否显示扫一扫
            isHideMenuItem: 是否右上角隐藏菜单按钮
            isShowImmediateBtn: 是否显示立即咨询按钮
            isShowChannelWeixinAppletQR: 是否显示频道微信二维码
            isHideEmptyDispatchRoom: 是否隐藏空的派单房间
        },
        swan: {//金易联功能的相关配置
            hideSwanRoomRed: 是否隐藏红包
            hideVideoIntroduction: 是否显示视频介绍
            serverName: 咨询房间的提示消息,
            chatRecordCombine: 是否合并聊天记录（针对三级账号）
            hideLoginSetting: 是否显示登录设置
            hidePracticeNmber: 是否隐藏执业编号
            hideShare: 是否隐藏分享
            hideChangePassword: 是否隐藏修改密码
            hideSwanRoomStock: 是否隐藏股票
            hideMywallet: 是否隐藏我的钱包
            isSwanCloud: 是否是公有云版本
            hideSwanRoomCall: 是否显示拨打电话
            hideVisitorList: 是否显示访客列表
            loginType: 登录类型 PWD/SMS,
            hideDepartment: 是否隐藏网点
            hideSwanRoomSetting: 是否隐藏房间设置
            dispatchMode: 派单模式 A/B 详情请咨询商务合作
            hideSwanRoomTransfer:是否 隐藏转账
            showThemeSetting: 是否开启主题设置
            swanRoomMemberAvatarClickEnable: 房间内的头像是否可以点击
            hideKnowledge: 是否隐藏知识库
            hideActivityManagement:是否隐藏活动管理
            hideDistributionTrace: 是否显示分发跟踪
            hideMySpace: 是否隐藏文件盘
            hideViewManagement: 是否显示观点管理
            hideProductManagement: 是否隐藏产品管理
            hideFissionRadar: 是否隐藏裂变雷达
            hideMarketingPoster: 是否隐藏裂变海报
            hideNotice: 是否隐藏通知,
            hideBrowsingHistory: 是否隐藏浏览历史
        },
        chat: { //聊天室功能的相关配置
            convoUIHyperTextLines: CovoUI显示的文本的行数 ，默认是 0 不限制
            hideAddKnowledge: 是否隐藏添加知识库
            hideCustomerCard: 是否隐藏客户名片
            hideForwardMenue: 是否显示转发
            hideConvertText: 是否隐藏语音转文字的菜单
            hideMultiSelectMenue: 是否显示多选
            hideSecurityNetdisk: 是否隐藏保密盘
            isVideoChat: 是否开启视频聊天
            identificationStockCode: 是否支持股票代码识别
            hideRoomSetting: 是否隐藏房间设置
            memberAvatarClickEnable: 房间内成员头像是都
            hideAllSelectMenue: 是否支持选择全部文字
            hideInviteOpenAccount: 是否开启邀请开户
            hideStaffCard: 是否隐藏投顾名片
            isScreenTaken: 是否显示截屏提示消息
            isShowWaterMark: 是否显示水印
            hideProductRecommend: 是否开启产品推荐
            isShowPersonCard: 是否开启个人名片
            showLeaveMessageKeyBoardItem: 是否显示留言
            showReactLimit: 撤回菜单显示的时长控制，单位秒：不配置时，显示180秒；配置为0，一直显示；配置为其他数字，则按数字时长控制。
            hideFavoriteMenue: 是否隐藏收藏
            isVideoConference: 是否支持视频会议
            hideMoreFile:是否聊天室+更多下面的文件
            hideMoreCall:是否聊天室+更多下面的电话
            hideMoreHotline:是否聊天室+更多下面的座机
            hideMoreApplet:是否聊天室+更多下面的小程序
        }
    },
}
```

2.开关配置示例（json）
```
{
    "appKey": "0mZqNWUP7E0gRd18iLNfRtw\/X5Ya2nAn4sawLogCJ7lF6TELMSPCBWPYaU7tlULGRekxCzEjwgVj2GlO7ZVCxv\/ePp3mvTypr7w4V6qA5bpg",
    "finochatApiURL": "https:\/\/api.finolabs.club",
    "finochatApiPrefix": "\/api\/v1",
    "appId": "3",
    "pusherAppIdProd": "com.finogeeks.swan.emp",
    "appType": "STAFF",
    "pushGatewayURL": "http:\/\/push-service.platform:5000\/_matrix\/push\/v1\/notify",
    "pusherAppIdDev": "com.finogeeks.swan.emp"
    "reverseRules": {
        "proxy": "https:\/\/app.finogeeks.club"
    },
    "settings": {
        "isShowApplet": true,
        "diableURLPreview": false,
        "appGroupIdentifier": "group.com.finogeeks.finchat.oa",
        "isShowGlobalFeedback": true,
        "apmUploadInterval": 300,
        "isCloseApm": false,
        "urlSchemaPrefix": "jfbemp",
        "hideWXShare": false,
        "hideChannelWXAppletShare":false,
        "hideTask":true
        "natureOfIndustry": "kIndustrySecurities",
        "encryptedPassword": true,
        "mine": {
            "disableEditName": true
        },
        "addressBook": {
            "hideLabel": false,
            "hideScanningAndFriends": false,
            "hideSearchCommunity": true,
            "hideSearchKnowledge": true,
            "hideSearchMessage": false,
            "disableOranaizationSort": false,
            "hideNewChat": false,
            "hideSearchAddressBook": false,
            "autoAddFriend": false,
            "hideSearchApplet": false,
            "deleteFriend": true,
            "hideSearchFile": true,
            "forwardToWX": false,
            "hideSearchChannel": false,
            "hideSearchConversation": false,
            "strangerRemark": true,
            "labelGroup": true,
            "hideMyFriend": false,
            "hideVisitorCard":true,
        },
        "conversation": {
            "isHideFederateChannelType": false,
            "isShowDirectChat": false,
            "isShowAddChannel": true,
            "isHideInviteRoom": true,
            "isCreateChannelPrivateOnly": true,
            "isHideSearchBar": false,
            "isHideUnreadNum": "",
            "isShowGroupChat": true,
            "isShowScan": true,
            "isHideMenuItem": false,
            "isShowImmediateBtn": false,
            "isShowChannelWeixinAppletQR": true,
            "isHideEmptyDispatchRoom": false
        },
        "swan": {
            "hideProductManagement": false,
            "hideFissionRadar": false,
            "hideMarketingPoster": false,
            "hideSwanRoomRed": true,
            "hideVideoIntroduction": false,
            "serverName": "凡泰金易联在线随时为您服务",
            "chatRecordCombine": true,
            "hideLoginSetting": false,
            "hidePracticeNmber": false,
            "hideShare": false,
            "hideActivityManagement": false,
            "hideChangePassword": true,
            "hideSwanRoomStock": true,
            "hideMywallet": false,
            "isSwanCloud": false,
            "hideMySpace": false,
            "hideDistributionTrace": false,
            "hideSwanRoomCall": true,
            "hideViewManagement": false,
            "hideVisitorList": false,
            "loginType": "PWD",
            "hideDepartment": false,
            "hideKnowledge": false,
            "hideSwanRoomSetting": false,
            "dispatchMode": "B",
            "hideSwanRoomTransfer": true,
            "showThemeSetting": true,
            "swanRoomMemberAvatarClickEnable": false,
            "hideNotice": false,
            "hideBrowsingHistory": false
        },
        "chat": {
            "convoUIHyperTextLines": 0,
            "hideAddKnowledge": false,
            "hideCustomerCard": false,
            "hideForwardMenue": false,
            "hideMultiSelectMenue": true,
            "hideSecurityNetdisk": true,
            "isVideoChat": false,
            "identificationStockCode": true,
            "hideRoomSetting": false,
            "memberAvatarClickEnable": true,
            "hideAllSelectMenue": false,
            "hideInviteOpenAccount": true,
            "hideStaffCard": false,
            "isScreenTaken": true,
            "isShowWaterMark": false,
            "hideProductRecommend": true,
            "isShowPersonCard": true,
            "showLeaveMessageKeyBoardItem": true,
            "hideFavoriteMenue": false,
            "isVideoConference": false,
            "hideMoreFile": true,
            "hideMoreCall": true,
            "hideMoreHotline": false,
        }
    },
}

```