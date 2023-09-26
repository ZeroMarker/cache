Class web.DHCENS.STBLL.PIS.MODEL.PISAPPMainInfo Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "AddRisAppBillRt";

/// 院区代码
Property HospitalCode As %String(MAXLEN = "");

/// 院区名称
Property HospitalDesc As %String(MAXLEN = "");

/// 登记号
Property RegNo As %String(MAXLEN = "");

/// 病人姓名
Property Name As %String(MAXLEN = "");

/// 性别代码
Property SexCode As %String(MAXLEN = "");

/// 性别名称
Property SexDesc As %String(MAXLEN = "");

/// 年龄
Property Age As %String(MAXLEN = "");

/// 病人科室代码
Property PatDeptCode As %String(MAXLEN = "");

/// 病人科室名称
Property PatDeptDesc As %String(MAXLEN = "");

/// 病区代码
Property PatWardCode As %String(MAXLEN = "");

/// 病区名称
Property PatWardDesc As %String(MAXLEN = "");

/// 床号
Property PatBedNO As %String(MAXLEN = "");

/// 联系电话
Property Telephone As %String(MAXLEN = "");

/// 出生日期
Property BirthDay As %String(MAXLEN = "");

/// 患者证件号码
Property PATIdentityNum As %String(MAXLEN = "");

/// 患者证件类别代码
Property identyTypeCode As %String(MAXLEN = "");

/// 患者证件类别描述
Property identyTypeDesc As %String(MAXLEN = "");

/// 地址
Property Address As %String(MAXLEN = "");

/// 申请科室代码
Property OrdDeptCode As %String(MAXLEN = "");

/// 申请科室名称
Property OrdDeptDesc As %String(MAXLEN = "");

/// 费别
Property FeeType As %String(MAXLEN = "");

/// 病案号
Property DocumentID As %String(MAXLEN = "");

/// 申请单代码
Property AppCode As %String(MAXLEN = "");

/// 申请单名称
Property AppName As %String(MAXLEN = "");

/// 申请人ID
Property OrdDoctorCode As %String(MAXLEN = "");

/// 申请人姓名
Property OrdDoctorName As %String(MAXLEN = "");

/// 申请日期
Property OrdDate As %String(MAXLEN = "");

/// 申请时间
Property OrdTime As %String(MAXLEN = "");

/// 就诊ID
Property AdmRowID As %String(MAXLEN = "");

/// 送检医院
Property OrdHospital As %String(MAXLEN = "");

/// 就诊类型代码
Property PAADMTypeCode As %String(MAXLEN = "");

/// 就诊类型描述
Property PAADMTypeDesc As %String(MAXLEN = "");

Property OrdListInfo As web.DHCENS.STBLL.PIS.MODEL.PISOrdInfo(XMLNAME = "PISOrdListInfo", XMLPROJECTION = "ELEMENT");

}
