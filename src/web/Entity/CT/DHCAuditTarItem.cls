/// Function: 收费项 审批使用的实体类 
/// CreateDate: 2023-04-23
/// Creator：sunfengchao 
Class web.Entity.CT.DHCAuditTarItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCAuditTarItem";

/// RowId
Property TARIRowId As %String;

/// 收费项代码
Property TARICode As %String;

/// 收费项名称
Property TARIDesc As %String;

/// 收费项别名 
Property TARIAlias As %String;

/// 单位
Property TARIUOM As %String;

/// 收费项目子类
Property TARISubCate As %String;

///  会计费用子类
Property TARIAcctCate As %String;

/// 门诊费用子类
Property TARIOutpatCate As %String;

///  经济核算子类
Property TARIEMCCate As %String;

///  病案首页子类
Property TARIMRCate As %String;

/// 有效标志
Property TARIActiveFlag As %String;

///  开始日期
Property TARIStartDate As %String;

///  结束日期
Property TARIEndDate As %String;

/// 收费项价格
Property TARIPrice As %String;

/// 住院费用子类
Property TARIInpatCate As %String;

///  新病案首页子类
Property TARIMCNew As %String;

/// 国家医保编码  
Property TARIInsuCode As %String;

/// 国家医保名称
Property TARIInsuName As %String;

/// 进口标志  
Property TARIManufactorType As %String;

/// 患者费别
Property TPPatInsType As %String;

/// 价格
Property TPPrice As %String;

/// 规格
Property TARISpec As %String;

/// 数量
Property OLTQty As %String;

/// 审批表ID
Property AuditID As %String;

/// 任务ID
Property TaskId As %String;

/// 审批意见
Property AuditComment As %String;

}
