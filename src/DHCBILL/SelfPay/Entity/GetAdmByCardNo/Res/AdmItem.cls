Class DHCBILL.SelfPay.Entity.GetAdmByCardNo.Res.AdmItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// Adm	就诊号
Property Adm As %String(TRUNCATE = 1);

/// AdmDate	就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// AdmTime	就诊时间
Property AdmTime As %String(TRUNCATE = 1);

/// AdmDept	就诊科室
Property AdmDept As %String(TRUNCATE = 1);

/// AdmDoctor	就诊医生
Property AdmDoctor As %String(TRUNCATE = 1);

/// AdmAmt	未缴费金额
Property AdmAmt As %String(TRUNCATE = 1);

}
