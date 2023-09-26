Class web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexecstatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 执行状态 
Property oeoesadminstatuscode As %Library.String(MAXLEN = 100, XMLNAME = "oeoesadminstatuscode");

/// 修改原因 
Property oeoesreasoncode As %Library.String(MAXLEN = 100, XMLNAME = "oeoesreasoncode");

/// 最后更新人编码 
Property oeoesupdateusercode As %Library.String(MAXLEN = 100, XMLNAME = "oeoesupdateusercode");

/// 最后更新日期 
Property oeoesupdatedate As %Library.String(MAXLEN = 100, XMLNAME = "oeoesupdatedate");

/// 最后更新时间 
Property oeoesupdatetime As %Library.String(MAXLEN = 100, XMLNAME = "oeoesupdatetime");

/// 时间戳 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 业务域 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 业务域_院内医嘱执行记录id 
Property oeorerelexecid As %Library.String(MAXLEN = 100, XMLNAME = "oeorerelexecid");

/// 业务域_院内患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 院内执行记录状态变更id 
Property oeoeshosexecstatusid As %Library.String(MAXLEN = 100, XMLNAME = "oeoeshosexecstatusid");

/// 全局执行记录状态变更id 
Property oeoesrelexecstatusid As %Library.String(MAXLEN = 100, XMLNAME = "oeoesrelexecstatusid");

}
