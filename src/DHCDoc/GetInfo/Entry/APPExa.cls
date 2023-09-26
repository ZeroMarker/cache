Class DHCDoc.GetInfo.Entry.APPExa Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 申请单RowId
Property ARRowid As %String(TRUNCATE = 1);

/// 申请单号
Property ARNo As %String(TRUNCATE = 1);

/// 申请单创建日期
Property ARCreateDate As %String(TRUNCATE = 1);

/// 申请单创建时间
Property ARCreateTime As %String(TRUNCATE = 1);

/// 申请单创建医生ID
Property ARCreateDocDr As %String(TRUNCATE = 1);

/// 申请单创建医生代码
Property ARCreateDocCode As %String(TRUNCATE = 1);

/// 申请单创建医生描述
Property ARCreateDocDesc As %String(TRUNCATE = 1);

/// 申请单科室ID
Property ARExecLocDr As %String(TRUNCATE = 1);

/// 申请单科室代码
Property ARExecLocCode As %String(TRUNCATE = 1);

/// 申请单科室描述
Property ARExecLocDesc As %String(TRUNCATE = 1);

/// 申请单就诊ID
Property ARAdmDr As %String(TRUNCATE = 1);

Property ARCatDr As %String(TRUNCATE = 1);

Property ARCatCode As %String(TRUNCATE = 1);

Property ARCatDesc As %String(TRUNCATE = 1);

/// 申请单是否加急
Property AREmgFlag As %String(TRUNCATE = 1);

/// 申请单申请医生
Property ARAppointDoc As %String(TRUNCATE = 1);

/// 申请单申请医生代码
Property ARAppointDocCode As %String(TRUNCATE = 1);

/// 申请单申请医生描述
Property ARAppointDocDesc As %String(TRUNCATE = 1);

/// 申请单使用目的
Property ARPurpose As %String(TRUNCATE = 1);

/// 申请单是否发送
Property ARSendFlag As %String(TRUNCATE = 1);

/// 申请单关联诊断
Property ARPatDiags As %String(TRUNCATE = 1);

}
