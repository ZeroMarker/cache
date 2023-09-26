Class web.DHCEkgOrdItem Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "DHCEkgOrdItem";

/// 检查号
Property ExamId As %String;

/// 门诊号
Property RegNo As %String;

/// 住院号
Property InPatCode As %String;

/// 患者姓名
Property PatName As %String;

/// 医嘱名称
Property ArcimDesc As %String;

/// 医嘱号
Property OeordId As %String;

/// 医嘱状态
Property OrdStatDesc As %String;

Property OrcatDesc As %String;

Property ExecDateTime As %String;

Property ExecCtcpDesc As %String;

/// 医嘱医生
Property CtcpDesc As %String;

/// 医嘱接收科室
Property RecLocDesc As %String;

/// 医嘱时间
Property OrdDateTime As %String;

/// 就诊科室
Property AdmDep As %String;

Property notes As %String;

Property OrdUnitCost As %String;

Property OrdQty As %String;

/// 医嘱费用
Property OrdCost As %String;

Property OrdBilled As %String;

/// 病人类型
Property admType As %String;

/// 就诊号
Property admId As %String;

Property Medicare As %String;

/// 性别
Property Sex As %String;

/// 出生日期
Property DobDate As %String;

/// 地址
Property Address As %String;

/// 床号
Property BedCode As %String;

/// 年龄
Property Age As %String;

/// 医生
Property Doctor As %String;

Property FeeState As %String;

/// 报告状态
Property RptState As %String;

}
