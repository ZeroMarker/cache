Class web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "PatientRegistryRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 院区代码
Property HospitalCode As %Library.String(MAXLEN = 30, XMLNAME = "HospitalCode");

/// 院区名称
Property HospitalDesc As %Library.String(MAXLEN = 50, XMLNAME = "HospitalDesc");

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 患者姓名
Property PATName As %Library.String(MAXLEN = 50, XMLNAME = "PATName");

/// 出生日期
Property PATDob As %Library.String(MAXLEN = 20, XMLNAME = "PATDob");

/// 年龄
Property PATAge As %Library.String(MAXLEN = 20, XMLNAME = "PATAge");

/// 性别代码
Property PATSexCode As %Library.String(MAXLEN = 1, XMLNAME = "PATSexCode");

/// 性别描述
Property PATSexDesc As %Library.String(MAXLEN = 20, XMLNAME = "PATSexDesc");

/// 婚姻状况代码
Property PATMaritalStatusCode As %Library.String(MAXLEN = 2, XMLNAME = "PATMaritalStatusCode");

/// 婚姻状况描述
Property PATMaritalStatusDesc As %Library.String(MAXLEN = 20, XMLNAME = "PATMaritalStatusDesc");

/// 病案号
Property PATDocumentNo As %Library.String(MAXLEN = 20, XMLNAME = "PATDocumentNo");

/// 民族代码
Property PATNationCode As %Library.String(MAXLEN = 2, XMLNAME = "PATNationCode");

/// 民族描述
Property PATNationDesc As %Library.String(MAXLEN = 20, XMLNAME = "PATNationDesc");

/// 国籍代码
Property PATCountryCode As %Library.String(MAXLEN = 3, XMLNAME = "PATCountryCode");

/// 国籍描述
Property PATCountryDesc As %Library.String(MAXLEN = 100, XMLNAME = "PATCountryDesc");

/// 死亡日期
Property PATDeceasedDate As %Library.String(MAXLEN = 20, XMLNAME = "PATDeceasedDate");

/// 死亡时间
Property PATDeceasedTime As %Library.String(MAXLEN = 20, XMLNAME = "PATDeceasedTime");

/// 健康卡号
Property PATHealthCardID As %Library.String(MAXLEN = 18, XMLNAME = "PATHealthCardID");

/// 母亲ID
Property PATMotherID As %Library.String(MAXLEN = 30, XMLNAME = "PATMotherID");

/// 患者职业代码
Property PATOccupationCode As %Library.String(MAXLEN = 20, XMLNAME = "PATOccupationCode");

/// 患者职业描述
Property PATOccupationDesc As %Library.String(MAXLEN = 20, XMLNAME = "PATOccupationDesc");

/// 患者工作单位名称
Property PATWorkPlaceName As %Library.String(MAXLEN = 70, XMLNAME = "PATWorkPlaceName");

/// 患者工作单位电话号码
Property PATWorkPlaceTelNum As %Library.String(MAXLEN = 20, XMLNAME = "PATWorkPlaceTelNum");

/// 患者证件号码
Property PATIdentityNum As %Library.String(MAXLEN = 18, XMLNAME = "PATIdentityNum");

/// 患者证件类别代码
Property PATIdTypeCode As %Library.String(MAXLEN = 2, XMLNAME = "PATIdTypeCode");

/// 患者证件类别描述
Property PATIdTypeDesc As %Library.String(MAXLEN = 20, XMLNAME = "PATIdTypeDesc");

/// 患者联系人姓名
Property PATRelationName As %Library.String(MAXLEN = 50, XMLNAME = "PATRelationName");

/// 患者联系人电话
Property PATRelationPhone As %Library.String(MAXLEN = 20, XMLNAME = "PATRelationPhone");

/// 患者联系电话
Property PATTelephone As %Library.String(MAXLEN = 20, XMLNAME = "PATTelephone");

/// 备注
Property PATRemarks As %Library.String(MAXLEN = 200, XMLNAME = "PATRemarks");

}
