Class web.DHCENS.STBLL.RIS.MODEL.SendRisBookInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "RisBookRt";

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 检查号
Property RISRExamID As %Library.String(MAXLEN = 50, XMLNAME = "RISRExamID");

/// 医嘱集合
Property OEORIOrderItemIDList As list Of web.DHCENS.STBLL.RIS.MODEL.OrderItemID(XMLNAME = "OEORIOrderItemIDList", XMLPROJECTION = "ELEMENT");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新日期(取消预约日期)
Property UpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "UpdateDate");

/// 最后更新时间(取消预约时间)
Property UpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "UpdateTime");

/// 预约日期
Property OEORIBookDate As %Library.String(MAXLEN = 30, XMLNAME = "OEORIBookDate");

/// 预约时间
Property OEORIBookTime As %Library.String(MAXLEN = 50, XMLNAME = "OEORIBookTime");

/// 预约资源代码
Property RISResourceCode As %Library.String(MAXLEN = 50, XMLNAME = "RISResourceCode");

/// 预约资源名称
Property RISResourceDesc As %Library.String(MAXLEN = 50, XMLNAME = "RISResourceDesc");

/// 预约地址
Property RISResourceAddr As %Library.String(MAXLEN = 50, XMLNAME = "RISResourceAddr");

}
