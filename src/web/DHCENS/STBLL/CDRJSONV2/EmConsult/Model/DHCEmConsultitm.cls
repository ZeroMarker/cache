Class web.DHCENS.STBLL.CDRJSONV2.EmConsult.Model.DHCEmConsultitm Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 会诊科室 
Property eccloccode As %Library.String(MAXLEN = 100, XMLNAME = "eccloccode");

/// 要求会诊医生 
Property ecndoccode As %Library.String(MAXLEN = 100, XMLNAME = "ecndoccode");

/// 实际会诊医生 
Property eccdoccode As %Library.String(MAXLEN = 100, XMLNAME = "eccdoccode");

/// 会诊意见 
Property ecopinion As %Library.String(MAXLEN = 100, XMLNAME = "ecopinion");

/// 单位名称 
Property ecunit As %Library.String(MAXLEN = 100, XMLNAME = "ecunit");

/// 执行状态 
Property ecexestatus As %Library.String(MAXLEN = 100, XMLNAME = "ecexestatus");

/// 会诊日期 
Property eccdate As %Library.String(MAXLEN = 100, XMLNAME = "eccdate");

/// 会诊时间 
Property ecctime As %Library.String(MAXLEN = 100, XMLNAME = "ecctime");

/// 申请医嘱描述 
Property ecroeoridesc As %Library.String(MAXLEN = 100, XMLNAME = "ecroeoridesc");

/// 会诊医嘱描述 
Property eccoeoridesc As %Library.String(MAXLEN = 100, XMLNAME = "eccoeoridesc");

/// 会诊医生职称 
Property ecprvtpcode As %Library.String(MAXLEN = 100, XMLNAME = "ecprvtpcode");

/// 会诊小组 
Property ecgrpcode As %Library.String(MAXLEN = 100, XMLNAME = "ecgrpcode");

/// 亚专业 
Property ecsubmarcode As %Library.String(MAXLEN = 100, XMLNAME = "ecsubmarcode");

/// 评价标志 
Property ecevaflag As %Library.String(MAXLEN = 100, XMLNAME = "ecevaflag");

/// 评价内容 
Property ecevadesc As %Library.String(MAXLEN = 100, XMLNAME = "ecevadesc");

/// 院内会诊申请明细id 
Property echositemrowid As %Library.String(MAXLEN = 100, XMLNAME = "echositemrowid");

/// 业务域代码 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 时间戳日期 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳时间 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 业务域_院内会诊申请明细id 
Property ecrelecconsitmid As %Library.String(MAXLEN = 100, XMLNAME = "ecrelecconsitmid");

/// 业务域_院内患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 业务域_院内会诊申请id 
Property ecrelemconsultid As %Library.String(MAXLEN = 100, XMLNAME = "ecrelemconsultid");

}
