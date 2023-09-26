Class web.DHCENS.STBLL.CDRJSONV2.Blood.Model.PABloodTransApp Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 院内输血申请id 
Property pabtahosappid As %Library.String(MAXLEN = 100, XMLNAME = "pabtahosappid");

/// 申请类型 
Property pabtaapptypedesc As %Library.String(MAXLEN = 100, XMLNAME = "pabtaapptypedesc");

/// abo血型 
Property pabtaabo As %Library.String(MAXLEN = 100, XMLNAME = "pabtaabo");

/// rh血型 
Property pabtarh As %Library.String(MAXLEN = 100, XMLNAME = "pabtarh");

/// 申请科室代码 
Property pabtaappdeptcode As %Library.String(MAXLEN = 100, XMLNAME = "pabtaappdeptcode");

/// 申请科室描述 
Property pabtaappdeptdesc As %Library.String(MAXLEN = 100, XMLNAME = "pabtaappdeptdesc");

/// 抗体筛查 
Property pabtaantibodyscreening As %Library.String(MAXLEN = 100, XMLNAME = "pabtaantibodyscreening");

/// 品种 
Property pabtabloodvariety As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodvariety");

/// 用血模式 
Property pabtabloodmode As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodmode");

/// 申请医生工号 
Property pabtaappdoccode As %Library.String(MAXLEN = 100, XMLNAME = "pabtaappdoccode");

/// 申请医生姓名 
Property pabtaappdocname As %Library.String(MAXLEN = 100, XMLNAME = "pabtaappdocname");

/// 血量 
Property pabtabloodvolume As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodvolume");

/// 申请日期时间 
Property pabtaappdatetime As %Library.String(MAXLEN = 100, XMLNAME = "pabtaappdatetime");

/// 用血日期时间 
Property pabtabloodusedatetime As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodusedatetime");

/// 输血反应日期时间 
Property pabtabloodreactdatetime As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodreactdatetime");

/// 输血反应 
Property pabtabloodreaction As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodreaction");

/// 备注 
Property pabtabloodtransremarks As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodtransremarks");

/// 输血目的 
Property pabtabloodpurpose As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodpurpose");

/// 输血史 
Property pabtabloodtranshistory As %Library.String(MAXLEN = 100, XMLNAME = "pabtabloodtranshistory");

/// 妊娠史 
Property pabtapregnancyhistory As %Library.String(MAXLEN = 100, XMLNAME = "pabtapregnancyhistory");

/// 时间戳 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 全局输血申请id 
Property pabtarelappid As %Library.String(MAXLEN = 100, XMLNAME = "pabtarelappid");

/// 全局患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 全局就诊id 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 申请单状态描述 
Property pabtaappstatusdesc As %Library.String(MAXLEN = 100, XMLNAME = "pabtaappstatusdesc");

}
