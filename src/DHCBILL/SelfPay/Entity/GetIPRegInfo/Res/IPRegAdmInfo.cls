Class DHCBILL.SelfPay.Entity.GetIPRegInfo.Res.IPRegAdmInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 就诊号 	
Property AdmID As %String(TRUNCATE = 1);

/// 就诊记录	
Property AdmSearch As %String(TRUNCATE = 1);

/// 在院状态 	
Property AdmVisit As %String(TRUNCATE = 1);

/// 科室 	
Property AdmDepDesc As %String(TRUNCATE = 1);

/// 病区	
Property AdmWardDesc As %String(TRUNCATE = 1);

/// 床位	
Property BedDesc As %String(TRUNCATE = 1);

/// 病房	
Property RoomDesc As %String(TRUNCATE = 1);

/// 入院医生	
Property AdmDoc As %String(TRUNCATE = 1);

/// 费别	
Property AdmReason As %String(TRUNCATE = 1);

/// 就诊子类	
Property AdmEpis As %String(TRUNCATE = 1);

/// 就诊日期 	
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊时间 	
Property AdmTime As %String(TRUNCATE = 1);

/// 操作员 	
Property UserName As %String(TRUNCATE = 1);

/// 入院情况 	
Property AdmRYQK As %String(TRUNCATE = 1);

/// 诊断	
Property Diagnos As %String(TRUNCATE = 1);

/// 诊断类型	
Property Digtype As %String(TRUNCATE = 1);

/// 诊断描述	
Property DiagnosDesc As %String(TRUNCATE = 1);

/// 医保诊断编码	
Property InsuDig As %String(TRUNCATE = 1);

/// 推荐医生	
Property RefDocList As %String(TRUNCATE = 1);

}
