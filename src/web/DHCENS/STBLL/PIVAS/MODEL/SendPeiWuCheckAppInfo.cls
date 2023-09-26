Class web.DHCENS.STBLL.PIVAS.MODEL.SendPeiWuCheckAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PeiWuCheckAppInfoRt";

/// 患者登记号
Property PATPatientID As %Library.String(MAXLEN = 300, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 300, XMLNAME = "PAADMVisitNumber");

/// 父医嘱ID
Property OEORIParentOrderID As %Library.String(MAXLEN = 300, XMLNAME = "OEORIParentOrderID");

/// 备注 申诉理由
Property PADRemarks As %Library.String(MAXLEN = 300, XMLNAME = "PADRemarks");

/// 更新人
Property UpdateUserCode As %Library.String(MAXLEN = 300, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 300, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 300, XMLNAME = "UpdateTime");

/// 医嘱执行科室代码
Property ReDeptCode As %Library.String(MAXLEN = 300, XMLNAME = "ReDeptCode");

}
