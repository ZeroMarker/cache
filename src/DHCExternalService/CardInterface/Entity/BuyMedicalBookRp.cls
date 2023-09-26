Class DHCExternalService.CardInterface.Entity.BuyMedicalBookRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

/// 结果标志(1–成功,-1–失败)
Property ResultCode As %String(TRUNCATE = 1);

/// 错误信息(当ResultCode=-1时有值)
Property ErrorMsg As %String(TRUNCATE = 1);

}
