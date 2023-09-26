/// Desc:       系统参数操作日志
/// Creator:    yejian
/// CreateDate: 2018-6-13
Class EMRservice.entity.ESysOptionLog Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 修改前描述
Property OldDescription As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 修改前是否可用
Property OldIsVisible As %String(TRUNCATE = 1);

/// 修改插件是否加载
Property OldIsEditor As %String(TRUNCATE = 1);

/// 修改前名称
Property OldName As %String(TRUNCATE = 1);

/// 修改前值
Property OldOptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 修改前描述
Property NewDescription As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 修改前是否可用
Property NewIsVisible As %String(TRUNCATE = 1);

/// 修改插件是否加载
Property NewIsEditor As %String(TRUNCATE = 1);

/// 修改前名称
Property NewName As %String(TRUNCATE = 1);

/// 修改前值
Property NewOptionValue As %String(MAXLEN = 10000, TRUNCATE = 1);

/// 状态
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作者ID
Property OperateUserID As %String(TRUNCATE = 1);

/// 操作者
Property OperateUserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property OperateMachineIP As %String(TRUNCATE = 1);

}
