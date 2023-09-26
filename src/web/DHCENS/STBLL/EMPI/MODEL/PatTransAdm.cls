Class web.DHCENS.STBLL.EMPI.MODEL.PatTransAdm Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "AdmTransactionRt";

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// /就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 转出日期
Property PAADMTStartDate As %Library.String(MAXLEN = 20, XMLNAME = "PAADMTStartDate");

/// 转出时间
Property PAADMTStartTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADMTStartTime");

/// 转出医生代码
Property PAADMTOrigDocCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTOrigDocCode");

/// 转出科室代码
Property PAADMTOrigDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTOrigDeptCode");

/// 转出病区代码
Property PAADMTOrigWardCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTOrigWardCode");

/// 转出病区名称
Property PAADMTOrigWardDesc As %Library.String(MAXLEN = 100, XMLNAME = "PAADMTOrigWardDesc");

/// 转出房间代码
Property PAADMTOrigRoomCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTOrigRoomCode");

/// 转出床位代码
Property PAADMTOrigBedCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTOrigBedCode");

/// 转入日期
Property PAADMTEndDate As %Library.String(MAXLEN = 20, XMLNAME = "PAADMTEndDate");

/// 转入时间
Property PAADMTEndTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADMTEndTime");

/// 转入医生代码
Property PAADMTTargDocCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTTargDocCode");

/// 转入科室代码
Property PAADMTTargDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTTargDeptCode");

/// 转入病区代码
Property PAADMTTargWardCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTTargWardCode");

/// 转入病区名称
Property PAADMTTargWardDesc As %Library.String(MAXLEN = 100, XMLNAME = "PAADMTTargWardDesc");

/// 转入房间代码
Property PAADMTTargRoomCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTTargRoomCode");

/// 转入床位代码
Property PAADMTTargBedCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMTTargBedCode");

/// 状态
Property PAADMTState As %Library.String(MAXLEN = 20, XMLNAME = "PAADMTState");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "UpdateTime");

/// 主管医生代码
Property PAADMDocCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMDocCode");

/// 管床护士代码
Property PAADMNurseCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMNurseCode");

}
