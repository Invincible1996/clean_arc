  /// author : kevin
  /// date : 2024-6-16 23:9:34
  /// description : api url
  class ApiUrl {
    // Add your api url here
        /// description: 列表
    static const String appProclamationPagelist = "/app/proclamation/pagelist";

        /// description: 聊天外显详情
    static const String chatShowInfo = "/chat/showInfo";

        /// description: 创建社区
    static const String communityAdd = "/community/add";

        /// description: 关注-反向操作
    static const String communityAttention = "/community/attention";

        /// description: 待审核数量
    static const String communityAttentionAuditCount = "/community/attention/audit/count";

        /// description: 审核关注列表
    static const String communityAttentionList = "/community/attention/list";

        /// description: 审核关注
    static const String communityAuditAttention = "/community/auditAttention";

        /// description: 取消管理员
    static const String communityCancelAsAdmin = "/community/cancelAsAdmin";

        /// description: 删除社区
    static const String communityDelete = "/community/delete";

        /// description: 详情
    static const String communityInfo = "/community/info";

        /// description: 列表
    static const String communityList = "/community/list";

        /// description: 修改社区
    static const String communityModify = "/community/modify";

        /// description: 删除关注
    static const String communityRemoveAttention = "/community/removeAttention";

        /// description: 设置成管理员
    static const String communitySetAsAdmin = "/community/setAsAdmin";

        /// description: 变更手机号码
    static const String custChangePhone = "/cust/changePhone";

        /// description: 变更密码-初次不需要传oldPwd
    static const String custChangePwd = "/cust/changePwd";

        /// description: 生成临时用户
    static const String custCreateTempUser = "/cust/createTempUser";

        /// description: 生成 临时 UserSig 
    static const String custCreateTmpUserSig = "/cust/createTmpUserSig";

        /// description: 生成 UserSig -只保持三天的时间
    static const String custCreateUserSig = "/cust/createUserSig";

        /// description: 删除临时用户
    static const String custDeleteTempUsers = "/cust/deleteTempUsers";

        /// description: 详情
    static const String custInfo = "/cust/info";

        /// description: 查询所有临时用户
    static const String custListTempUser = "/cust/listTempUser";

        /// description: 更新当前位置
    static const String custLocation = "/cust/location";

        /// description: 共同的群组和社区
    static const String custSameGroupAndCommunity = "/cust/sameGroupAndCommunity";

        /// description: 图文新增
    static const String discoverArticleAdd = "/discover/article/add";

        /// description: 图文删除
    static const String discoverArticleDel = "/discover/article/del";

        /// description: 图文列表-倒序-customerId如果没传，取当前会话
    static const String discoverArticleList = "/discover/article/list";

        /// description: 图文修改
    static const String discoverArticleModify = "/discover/article/modify";

        /// description: 评论
    static const String discoverCommentAdd = "/discover/comment/add";

        /// description: 删除评论
    static const String discoverCommentDel = "/discover/comment/del";

        /// description: 详情-customerId如果没传，取当前会话
    static const String discoverInfo = "/discover/info";

        /// description: 更新
    static const String discoverModify = "/discover/modify";

        /// description: 点赞
    static const String discoverStarAdd = "/discover/star/add";

        /// description: 取消点赞
    static const String discoverStarDel = "/discover/star/del";

        /// description: 测试1
    static const String health = "/health";

        /// description: 发布任务
    static const String missionAdd = "/mission/add";

        /// description: 投诉任务
    static const String missionComplain = "/mission/complain";

        /// description: 删除任务
    static const String missionDelete = "/mission/delete";

        /// description: 大厅
    static const String missionHall = "/mission/hall";

        /// description: 修改任务
    static const String missionModify = "/mission/modify";

        /// description: 列表
    static const String nearbyList = "/nearby/list";

        /// description: 增加笔记
    static const String noteAdd = "/note/add";

        /// description: 收藏
    static const String noteCollect = "/note/collect";

        /// description: 删除笔记
    static const String noteDelete = "/note/delete";

        /// description: 笔记详情
    static const String noteInfo = "/note/info";

        /// description: 笔记列表
    static const String noteList = "/note/list";

        /// description: 修改笔记
    static const String noteModify = "/note/modify";

        /// description: 测试1
    static const String notify = "/notify/";

        /// description: app版本信息
    static const String openApplicationUpdate = "/open/applicationUpdate";

        /// description: 文件上传接口
    static const String openFile = "/open/file";

        /// description: 忘记密码-通过手机号码验证
    static const String openForgetPwd = "/open/forgetPwd";

        /// description: 密码登录
    static const String openLogin = "/open/login";

        /// description: 登录、注册
    static const String openLoginOrRegister = "/open/loginOrRegister";

        /// description: 图片上传接口
    static const String openPict = "/open/pict";

        /// description: 发送短信验证码
    static const String openSendCode = "/open/sendCode";

        /// description: GET获取
    static const String openTokesOss = "/open/tokes/oss";

        /// description: 预下单 返回微信单号
    static const String orderPrepay = "/order/prepay";

        /// description: 查询
    static const String orderQuery = "/order/query";

        /// description: 微信订单支付通知
    static const String paynotifyWx = "/paynotify/wx";

        /// description: 列表
    static const String productList = "/product/list";

        /// description: 测试1
    static const String test1 = "/test/1";

        /// description: 模拟app
    static const String testApplogin = "/test/applogin";

        /// description: check
    static const String testCheck = "/test/check";

        /// description: cleanTemplateUser
    static const String testCleanTemplateUser = "/test/cleanTemplateUser";

        /// description: getGroupInfo
    static const String testGetGroupInfo = "/test/getGroupInfo";

        /// description: modifyGroupInfo
    static const String testModifyGroupInfo = "/test/modifyGroupInfo";

        /// description: testimport
    static const String testPayQuery = "/test/pay/query";

        /// description: testSnowFlakeConfig
    static const String testTestSnowFlakeConfig = "/test/testSnowFlakeConfig";

        /// description: testdelete
    static const String testTestdelete = "/test/testdelete";

        /// description: testimport
    static const String testTestimport = "/test/testimport";

        /// description: 查询是否有权限
    static const String vipGetVipPermission = "/vip/getVipPermission";

        /// description: 增加
    static const String webAppAdd = "/web/app/add";

        /// description: 删除
    static const String webAppDelete = "/web/app/delete";

        /// description: 修改
    static const String webAppModify = "/web/app/modify";

        /// description: 列表
    static const String webAppPagelist = "/web/app/pagelist";

        /// description: 审核
    static const String webCommunityAudit = "/web/community/audit";

        /// description: 列表
    static const String webCommunityPagelist = "/web/community/pagelist";

        /// description: 激活用户
    static const String webCustActive = "/web/cust/active";

        /// description: 取消会员
    static const String webCustCancelVip = "/web/cust/cancelVip";

        /// description: 创建靓号
    static const String webCustCreateCustomer = "/web/cust/createCustomer";

        /// description: 禁用用户
    static const String webCustDiscard = "/web/cust/discard";

        /// description: 详情
    static const String webCustInfo = "/web/cust/info";

        /// description: 列表
    static const String webCustPagelist = "/web/cust/pagelist";

        /// description: 重置密码
    static const String webCustResetPwd = "/web/cust/resetPwd";

        /// description: 设置成会员
    static const String webCustSetVip = "/web/cust/setVip";

        /// description: 处理投诉
    static const String webMissionComplainDeal = "/web/mission/complain/deal";

        /// description: 投诉详情
    static const String webMissionComplainInfo = "/web/mission/complain/info";

        /// description: 任务投诉列表
    static const String webMissionComplainPagelist = "/web/mission/complain/pagelist";

        /// description: 清理任务
    static const String webMissionDelete = "/web/mission/delete";

        /// description: 任务详情
    static const String webMissionInfo = "/web/mission/info";

        /// description: 任务列表
    static const String webMissionPagelist = "/web/mission/pagelist";

        /// description: 删除笔记
    static const String webNoteDelete = "/web/note/delete";

        /// description: 笔记详情
    static const String webNoteInfo = "/web/note/info";

        /// description: 笔记列表
    static const String webNoteList = "/web/note/list";

        /// description: 列表
    static const String webOrderPagelist = "/web/order/pagelist";

        /// description: 新增
    static const String webProclamationAdd = "/web/proclamation/add";

        /// description: 变更状态-逆向操作
    static const String webProclamationChangeStatus = "/web/proclamation/changeStatus";

        /// description: 删除
    static const String webProclamationDelete = "/web/proclamation/delete";

        /// description: 修改
    static const String webProclamationModify = "/web/proclamation/modify";

        /// description: 列表
    static const String webProclamationPagelist = "/web/proclamation/pagelist";

        /// description: 新增
    static const String webProductAdd = "/web/product/add";

        /// description: 删除
    static const String webProductDelete = "/web/product/delete";

        /// description: 修改
    static const String webProductModify = "/web/product/modify";

        /// description: 列表
    static const String webProductPagelist = "/web/product/pagelist";

    
  }
  