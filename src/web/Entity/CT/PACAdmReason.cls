/// 名称: 患者费别维护
/// 描述: 实体类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.Entity.CT.PACAdmReason Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACAdmReason";

/// RowId号
Property REARowId As %String;

/// 代码
Property REACode As %String;

/// 描述
Property READesc As %String;

/// 开始日期
Property READateFrom As %String;

/// 结束日期
Property READateTo As %String;

/// 门诊AdmSource   
Property REAAdmSource As %String;

/// 住院NationalCode  
Property REANationalCode As %String;

}
