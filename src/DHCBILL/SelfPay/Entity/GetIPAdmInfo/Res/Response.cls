Class DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// PatientID 登记号
Property PatientID As %String(TRUNCATE = 1);

/// PatientName 患者姓名
Property PatientName As %String(TRUNCATE = 1);

/// Sex 性别
Property Sex As %String(TRUNCATE = 1);

/// DOB 出生日期
Property DOB As %String(TRUNCATE = 1);

/// Medical 病案号
Property Medical As %String(TRUNCATE = 1);

/// CredType 证件类型
Property CredType As %String(TRUNCATE = 1);

/// CredNo 证件号
Property CredNo As %String(TRUNCATE = 1);

/// AdmInfoList	就诊信息列表
Property AdmInfoList As list Of DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.AdmInfo(XMLITEMNAME = "AdmInfo", XMLPROJECTION = "COLLECTION");

}
