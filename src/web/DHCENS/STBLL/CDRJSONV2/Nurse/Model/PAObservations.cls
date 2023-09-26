Class web.DHCENS.STBLL.CDRJSONV2.Nurse.Model.PAObservations Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 测量项目代码 
Property paoobsercode As %Library.String(MAXLEN = 100, XMLNAME = "paoobsercode");

/// 测量日期 
Property paoobserupdatedate As %Library.String(MAXLEN = 100, XMLNAME = "paoobserupdatedate");

/// 测量时间 
Property paoobserupdatetime As %Library.String(MAXLEN = 100, XMLNAME = "paoobserupdatetime");

/// 测量人编码 
Property paoobserupdateusercode As %Library.String(MAXLEN = 100, XMLNAME = "paoobserupdateusercode");

/// 时间戳 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 测量项目数值 
Property paoobservalue As %Library.String(MAXLEN = 100, XMLNAME = "paoobservalue");

/// 医院内部生命体征id 
Property paohosobserid As %Library.String(MAXLEN = 100, XMLNAME = "paohosobserid");

/// 业务域 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 全局就诊id 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 全局患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 全局生命体征id 
Property paorelobserid As %Library.String(MAXLEN = 100, XMLNAME = "paorelobserid");

}
