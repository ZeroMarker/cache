/// 诊断信息列表
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Diagnose Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 诊断流水号
Property diagid As %String(TRUNCATE = 1, XMLNAME = "diag_id");

/// 诊断时间 yyyy-mm-dd hh24:mi:ss
Property diagdate As %String(TRUNCATE = 1, XMLNAME = "diag_date");

/// 诊断名称
Property diagname As %String(TRUNCATE = 1, XMLNAME = "diag_name");

/// 诊断编码
Property diagcode As %String(TRUNCATE = 1, XMLNAME = "diag_code");

/// 诊断状态 (0:正常,1:作废	只能填入"1|0")
Property diagstatus As %String(TRUNCATE = 1, XMLNAME = "diag_status");

/// 诊断医生姓名
Property diagdocname As %String(TRUNCATE = 1, XMLNAME = "diag_doc_name");

/// 诊断类别 (主要诊断/次要诊断)
Property diagcategory As %String(TRUNCATE = 1, XMLNAME = "diag_category");

/// 诊断类型 (入院诊断/出院诊断/门诊诊断/修正诊断等)
Property diagtype As %String(TRUNCATE = 1, XMLNAME = "diag_type");

/// 诊断编码类型 (1:西医诊断ICD-10编码,2:中医诊断编码 只能填入"1|2")
Property diagcodetype As %String(TRUNCATE = 1, XMLNAME = "diag_code_type");

}
