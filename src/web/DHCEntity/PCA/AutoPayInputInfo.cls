/// Creator:Lid
/// CreatDate:2011-11-17
/// Description:用于临时存储自助接接的入参
Class web.DHCEntity.PCA.AutoPayInputInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// CardNo
Property CardNo As %String(TRUNCATE = 1);

/// SecrityNo
Property SecrityNo As %String(TRUNCATE = 1);

/// Userid
Property Userid As %String(TRUNCATE = 1);

/// StartDate
Property StartDate As %String(TRUNCATE = 1);

/// EndDate
Property EndDate As %String(TRUNCATE = 1);

/// PatAmt
Property PatAmt As %String(TRUNCATE = 1);

/// BankTradeInfo
Property BankTradeInfo As %String(TRUNCATE = 1);

/// AdmInfo
Property AdmInfo As %String(TRUNCATE = 1);

/// ExpStr
Property ExpStr As %String(TRUNCATE = 1);

/// <Request><CardNo>9999990100000138</CardNo><SecrityNo></SecrityNo><Userid></Userid><StartDate>2011-03-30</StartDate><EndDate>2011-03-30</EndDate><AdmInfo></AdmInfo><PatAmt></PatAmt><BankTradeInfo></BankTradeInfo><ExpStr></ExpStr></Request>

}
