Class web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "PA_Adm";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 就诊号码
Property PAADMVisitNumber As %Library.Integer(XMLNAME = "PAADMVisitNumber");

/// 就诊次数
Property PAADMVisitTimes As %Library.Integer(XMLNAME = "PAADMVisitTimes");

/// 就诊类别代码
Property PAADMTypeCode As %Library.String(MAXLEN = 20, XMLNAME = "PAADMTypeCode");

/// 就诊类别描述
Property PAADMTypeDesc As %Library.String(MAXLEN = 20, XMLNAME = "PAADMTypeDesc");

/// 就诊状态代码
Property PAAdmStatusCode As %Library.String(MAXLEN = 20, XMLNAME = "PAAdmStatusCode");

/// 就诊状态描述
Property PAAdmStatusDesc As %Library.String(MAXLEN = 20, XMLNAME = "PAAdmStatusDesc");

/// 就诊医生
Property PAADMDocCode As %Library.String(MAXLEN = 10, XMLNAME = "PAADMDocCode");

/// 就诊医生
Property PAADMDocDesc As %Library.String(MAXLEN = 10, XMLNAME = "PAADMDocDesc");

/// 入院日期
Property PAADMStartDate As %Library.String(MAXLEN = 20, XMLNAME = "PAADMStartDate");

/// 入院时间
Property PAADMStartTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADMStartTime");

/// 入院科室代码
Property PAADMDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMDeptCode");

/// 入院科室描述
Property PAADMDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMDeptDesc");

/// 入院病区代码
Property PAADMAdmWardCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmWardCode");

/// 入院病区描述
Property PAADMAdmWardDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmWardDesc");

/// 当前床号
Property PAADMCurBedNo As %Library.String(MAXLEN = 20, XMLNAME = "PAADMCurBedNo");

/// 当前科室代码
Property PAADMCurDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMCurDeptCode");

/// 当前科室描述
Property PAADMCurDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMCurDeptDesc");

/// 患者支付类型代码
Property PAADMFeeTypeCode As %Library.String(MAXLEN = 20, XMLNAME = "PAADMFeeTypeCode");

/// 患者支付类型描述
Property PAADMFeeTypeDesc As %Library.String(MAXLEN = 20, XMLNAME = "PAADMFeeTypeDesc");

/// 医院编码
Property PAADMHosCode As %Library.String(MAXLEN = 30, XMLNAME = "PAADMHosCode");

/// 医院名称
Property PAADMHosDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMHosDesc");

/// 收费员 2019-10-02
Property Charger As %Library.String(MAXLEN = 20, XMLNAME = "Charger");

/// 收费时间  2019-10-02
Property ChargeDate As %Library.String(MAXLEN = 20, XMLNAME = "ChargeDate");

/// 入院病房代码 2023-04-02
Property PAADMAdmRoomCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmRoomCode");

/// 入院病房描述 2023-04-02
Property PAADMAdmRoomDesc As %Library.String(MAXLEN = 100, XMLNAME = "PAADMAdmRoomDesc");

}
