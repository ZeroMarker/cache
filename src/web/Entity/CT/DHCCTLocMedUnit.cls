/// Function: 医疗单元实体类
/// Creator:  基础数据平台组 sunfengchao
/// CreateDate:2015-12-29
Class web.Entity.CT.DHCCTLocMedUnit Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCCTLocMedUnit";

/// 科室DR CT_Loc             
Property CTMUCTLOCParRef As %String;

Property CTLocDr As %String;

/// CTMU_Childsub
Property CTMUChildsub As %String;

/// RowId号
Property MURowId As %String;

/// 代码
Property CTMUCode As %String;

/// 描述
Property CTMUDesc As %String;

/// 激活标志
Property CTMUActiveFlag As %String;

/// 门诊出诊标志
Property CTMUOPFlag As %String;

/// 住院出诊标志
Property CTMUIPFlag As %String;

/// 开始日期
Property CTMUDateFrom As %String;

/// 截止日期
Property CTMUDateTo As %String;

}
