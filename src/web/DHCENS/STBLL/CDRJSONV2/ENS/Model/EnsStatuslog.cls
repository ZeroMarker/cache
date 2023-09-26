Class web.DHCENS.STBLL.CDRJSONV2.ENS.Model.EnsStatuslog Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 检查号/检验条码号/病理条码号 
Property esexamid As %Library.String(MAXLEN = 100, XMLNAME = "esexamid");

/// 检查部位描述 
Property esexampart As %Library.String(MAXLEN = 100, XMLNAME = "esexampart");

/// 操作员工号 
Property esoperatorid As %Library.String(MAXLEN = 100, XMLNAME = "esoperatorid");

/// 操作员描述 
Property esoperatorname As %Library.String(MAXLEN = 100, XMLNAME = "esoperatorname");

/// 操作日期 
Property esoperatedate As %Library.String(MAXLEN = 100, XMLNAME = "esoperatedate");

/// 操作时间 
Property esoperatetime As %Library.String(MAXLEN = 100, XMLNAME = "esoperatetime");

/// 操作代码 
Property esoperatecode As %Library.String(MAXLEN = 100, XMLNAME = "esoperatecode");

/// 操作描述 
Property esoperatedesc As %Library.String(MAXLEN = 100, XMLNAME = "esoperatedesc");

/// 系统代码 
Property essystemcode As %Library.String(MAXLEN = 100, XMLNAME = "essystemcode");

/// 变更后状态代码 
Property esstatuscode As %Library.String(MAXLEN = 100, XMLNAME = "esstatuscode");

/// 当前状态代码 
Property esprestatuscode As %Library.String(MAXLEN = 100, XMLNAME = "esprestatuscode");

/// 部位id 
Property esexampartid As %Library.String(MAXLEN = 100, XMLNAME = "esexampartid");

/// 备注 
Property esnote As %Library.String(MAXLEN = 100, XMLNAME = "esnote");

/// 业务域 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 业务域_院内患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 全局医嘱明细id 
Property oeorirelorderitemid As %Library.String(MAXLEN = 100, XMLNAME = "oeorirelorderitemid");

/// 自增 
Property eshosstatuslogid As %Library.String(MAXLEN = 100, XMLNAME = "eshosstatuslogid");

/// 时间戳日期 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳时间 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

Property oeorsupdatedate As %Library.String(MAXLEN = 100, XMLNAME = "oeorsupdatedate");

Property oeorsupdatetime As %Library.String(MAXLEN = 100, XMLNAME = "oeorsupdatetime");

}
