Class web.DHCENS.STBLL.BOOKREG.MODEL.RepGetPatInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PatientInfo";

/// 病人ID
Property PatientID As %Library.String;

/// 病人姓名
Property PatientName As %Library.String;

/// 性别代码
Property SexCode As %Library.String;

/// 性别
Property Sex As %Library.String;

/// 出生日期
Property DOB As %Library.String;

/// 病案号
Property DocumentID As %Library.String;

/// 家庭住址
Property Address As %Library.String;

/// 证件类型（代码）
Property IDTypeCode As %Library.String;

/// 证件类型（描述）
Property IDType As %Library.String;

/// 证件号
Property IDNo As %Library.String;

/// 医保标志（0：非医保，1：医保）
Property YBFlag As %Library.String;

/// 病人类型描述
Property PatType As %Library.String;

/// 移动电话
Property Mobile As %Library.String;

/// 医保卡号
Property InsureCardNo As %Library.String;

}
