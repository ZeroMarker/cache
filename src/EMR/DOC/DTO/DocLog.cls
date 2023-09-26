/// 名称:	EMR.DOC.DTO.DocLog
/// 描述:	实例数据-病历操作日志和状态对象
/// 编写者：yejian
/// 编写日期: 2021-7-15
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.DocLog Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 就诊号
Property EpisodeID As %String;

/// 操作状态
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 最终操作状态
Property FinalStatus As %String(TRUNCATE = 1);

/// 初始状态
Property InitStatus As %String(TRUNCATE = 1);

/// 操作者ID
Property OperateUserID As %String(TRUNCATE = 1);

/// 操作IP
Property OperateMachineIP As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 操作用户
Property OperateUserName As %String(TRUNCATE = 1);

/// 登录用户ID
Property LoginUserID As %String(TRUNCATE = 1);

/// 登录科室
Property UserLoginLocID As %String(TRUNCATE = 1);

/// 登录用户名
Property LoginUserName As %String(TRUNCATE = 1);

/// 签名日志
Property EMRSignID As %String(TRUNCATE = 1);

/// 产品模块
Property ProductSource As %String(TRUNCATE = 1);

/// EMRSignLog
Property EMRSignLogID As %String(TRUNCATE = 1);

/// 语言ID
Property LangID As %String(TRUNCATE = 1);

}
