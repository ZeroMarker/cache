Class DHCExternalService.RegInterface.Entity.SelfReg.List.PatList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PatentList";

/// 患者挂号编号
Property CallNo As %String(TRUNCATE = 1, XMLNAME = "call_no");

/// 患者姓名
Property PatName As %String(TRUNCATE = 1, XMLNAME = "pat_name");

/// 患者就诊类型
Property CallKind As %String(TRUNCATE = 1, XMLNAME = "call_kind");

}
