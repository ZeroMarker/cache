Class DHCExternalService.CardInterface.Entity.AliPayRecord Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLNAME = "Record";

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 病人姓名
Property PatientName As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 联系方式
Property Mobile As %String(TRUNCATE = 1);

/// 医保卡号
Property InsurCardNo As %String(TRUNCATE = 1);

}
