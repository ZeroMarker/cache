Class web.DHCENS.STBLL.CDRJSONV2.RIS.Model.Risorder Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 检查部位代码
Property risobacode As %Library.String(MAXLEN = 100, XMLNAME = "risobacode");

/// 时间戳
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 检查部位描述
Property risobadesc As %Library.String(MAXLEN = 100, XMLNAME = "risobadesc");

/// 院内检查号
Property risohosrisexamid As %Library.String(MAXLEN = 100, XMLNAME = "risohosrisexamid");

/// 业务域
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 业务域_院内患者id
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 全局检查号
Property risorelrisexamid As %Library.String(MAXLEN = 100, XMLNAME = "risorelrisexamid");

/// 全局医嘱明细id
Property oeorirelorderitemid As %Library.String(MAXLEN = 100, XMLNAME = "oeorirelorderitemid");

}
