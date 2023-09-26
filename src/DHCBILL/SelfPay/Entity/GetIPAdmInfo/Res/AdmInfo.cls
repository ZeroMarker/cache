Class DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.AdmInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// AdmID 住院就诊号
Property AdmID As %String(TRUNCATE = 1);

/// AdmDate 就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// AdmDept 就诊科室
Property AdmDept As %String(TRUNCATE = 1);

/// BillNo 账单号
Property BillNo As %String(TRUNCATE = 1);

/// AdmReason 就诊费别
Property AdmReason As %String(TRUNCATE = 1);

/// NationalCode 医保患者标志
Property NationalCode As %String(TRUNCATE = 1);

/// TotalAmount 总费用
Property TotalAmount As %String(TRUNCATE = 1);

/// DepositAmount 押金总额
Property DepositAmount As %String(TRUNCATE = 1);

/// DepositBalance 押金余额
Property DepositBalance As %String(TRUNCATE = 1);

}
