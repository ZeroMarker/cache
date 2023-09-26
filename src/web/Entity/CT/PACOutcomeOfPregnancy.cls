/// 名称: 妊娠结果
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-29
Class web.Entity.CT.PACOutcomeOfPregnancy Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACOutcomeOfPregnancy";

/// RowId
Property OPREGRowId As %String;

/// 代码
Property OPREGCode As %String;

/// 描述
Property OPREGDesc As %String;

/// NationalCode
Property OPREGNationalCode As %String;

/// UseForPara Y/N
Property OPREGUseForPara As %String;

/// 分娩结果类型
Property OPREGOutcomeType As %String;

/// 自动注册患者信息 Y/N
Property OPREGAutoRegister As %String;

/// 自动入院登记 Y/N
Property OPREGAutoAdmit As %String;

}
