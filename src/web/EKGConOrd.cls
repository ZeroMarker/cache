Class web.EKGConOrd Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "ConOrdList";

// "登记号"

Property RegNo As %String;

// "姓名"

Property PatName As %String;

// "性别"

Property Sex As %String;

// "年龄"

Property Age As %String;

// 病人来源

Property admType As %String;

/// 床号
Property BedCode As %String;

/// 病区
Property Ward As %String;

// "医嘱名称"

Property ArcimDesc As %String;

// 开单时间

Property OrdDateTime As %String;

// "医嘱状态"

Property OrdStatDesc As %String;

// "费用状态代码"

Property FeeStateCode As %String;

// "费用状态"

Property FeeState As %String;

// 检查状态

Property ExamState As %String;

// 报告状态

Property RptState As %String;

// 申请医生

Property CtcpDesc As %String;

// 医嘱ID

Property OeordId As %String;

Property OrcatDesc As %String;

Property ExecDateTime As %String;

Property ExecCtcpDesc As %String;

Property RecLocDesc As %String;

Property AdmDep As %String;

Property notes As %String;

Property OrdUnitCost As %String;

Property OrdQty As %String;

Property OrdCost As %String;

Property OrdBilled As %String;

Property admId As %String;

Property Medicare As %String;

Property DobDate As %String;

// 登记时间

Property RegisterTime As %String;

// 登记人ID(心电库ID)

Property RegisterUserId As %String;

// 登记者姓名

Property RegisterUserName As %String;

// "是否加急"

Property IsUrgent As %String;

Property CliDig As %String;

}
