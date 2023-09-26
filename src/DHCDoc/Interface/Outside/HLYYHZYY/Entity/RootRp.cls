Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.RootRp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 基础标签
Property base As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Base(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// 调用结果标签
Property invokeresult As DHCDoc.Interface.Outside.HLYYHZYY.Entity.InvokeResult(XMLNAME = "invoke_result", XMLPROJECTION = "ELEMENT");

/// 审核药师工号
Property checkpharmid As %String(TRUNCATE = 1, XMLNAME = "check_pharm_id");

/// 审核药师名称
Property checkpharmname As %String(TRUNCATE = 1, XMLNAME = "check_pharm_name");

/// 入院病区id
Property inwardid As %String(TRUNCATE = 1, XMLNAME = "in_ward_id");

/// 入院病区名称
Property inwardname As %String(TRUNCATE = 1, XMLNAME = "in_ward_name");

/// 入院病床号
Property inwardbedno As %String(TRUNCATE = 1, XMLNAME = "in_ward_bed_no");

/// 返回信息标签
Property message As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.Message(XMLNAME = "message", XMLPROJECTION = "ELEMENT");

}
