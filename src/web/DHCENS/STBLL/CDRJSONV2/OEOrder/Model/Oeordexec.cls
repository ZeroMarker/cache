Class web.DHCENS.STBLL.CDRJSONV2.OEOrder.Model.Oeordexec Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 执行开始日期 
Property oeoreexecstdate As %Library.String(MAXLEN = 100, XMLNAME = "oeoreexecstdate");

/// 执行开始时间 
Property oeoreexecsttime As %Library.String(MAXLEN = 100, XMLNAME = "oeoreexecsttime");

/// 剂量 
Property oeoredoseqty As %Library.String(MAXLEN = 100, XMLNAME = "oeoredoseqty");

/// 剂量单位 
Property oeoredoseunitcode As %Library.String(MAXLEN = 100, XMLNAME = "oeoredoseunitcode");

/// 计费数量 
Property oeoreqtyadmin As %Library.String(MAXLEN = 100, XMLNAME = "oeoreqtyadmin");

/// 简短描述 
Property oeoredesc As %Library.String(MAXLEN = 100, XMLNAME = "oeoredesc");

/// 撤销执行日期 
Property oeorexdate As %Library.String(MAXLEN = 100, XMLNAME = "oeorexdate");

/// 撤销执行时间 
Property oeorextime As %Library.String(MAXLEN = 100, XMLNAME = "oeorextime");

/// 执行人代码 
Property oeoreexecusercode As %Library.String(MAXLEN = 100, XMLNAME = "oeoreexecusercode");

/// 执行日期 
Property oeoredateexecuted As %Library.String(MAXLEN = 100, XMLNAME = "oeoredateexecuted");

/// 执行时间 
Property oeoretimeexecuted As %Library.String(MAXLEN = 100, XMLNAME = "oeoretimeexecuted");

/// 医嘱执行记录状态 
Property oeoreadminstatuscode As %Library.String(MAXLEN = 100, XMLNAME = "oeoreadminstatuscode");

/// 要求执行日期 
Property oeorerequireexecdate As %Library.String(MAXLEN = 100, XMLNAME = "oeorerequireexecdate");

/// 要求执行时间 
Property oeorerequireexectime As %Library.String(MAXLEN = 100, XMLNAME = "oeorerequireexectime");

/// 执行结束日期 
Property oeoreexecfinishdate As %Library.String(MAXLEN = 100, XMLNAME = "oeoreexecfinishdate");

/// 执行结束时间 
Property oeoreexecfinishtime As %Library.String(MAXLEN = 100, XMLNAME = "oeoreexecfinishtime");

/// 时间戳 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 院内执行记录id 
Property oeorehosexecid As %Library.String(MAXLEN = 100, XMLNAME = "oeorehosexecid");

/// 业务域 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 业务域_院内执行记录id 
Property oeorerelexecid As %Library.String(MAXLEN = 100, XMLNAME = "oeorerelexecid");

/// 全局医嘱明细id 
Property oeorirelorderitemid As %Library.String(MAXLEN = 100, XMLNAME = "oeorirelorderitemid");

/// 业务域_院内患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

}
