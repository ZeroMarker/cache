/// 5.	检验项目CT_TestCode 实体类
/// 　基础数据平台组　孙凤超
Class web.Entity.CT.CTTestCode Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTTestCode";

/// RowId号
Property CTTCRowId As %String;

/// 代码
Property CTTCCode As %String;

/// 描述
Property CTTCDesc As %String;

/// 英文缩写
Property CTTCSynonym As %String;

/// 单位
Property CTTCUnits As %String;

/// 结果格式
Property CTTCResultFormat As %String;

/// 结果长度
Property CTTCResultLength As %String;

/// 检测方法
Property CTTCTestMethodDR As %String;

/// 精确值
Property CTTCShowInCummulative As %String;

}
