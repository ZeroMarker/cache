Class web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationApplication Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 手术开始日期 
Property paoastartdate As %Library.String(MAXLEN = 100, XMLNAME = "paoastartdate");

/// 手术开始时间 
Property paoastarttime As %Library.String(MAXLEN = 100, XMLNAME = "paoastarttime");

/// 手术室 
Property paoaoperroom As %Library.String(MAXLEN = 100, XMLNAME = "paoaoperroom");

/// 手术类型 
Property paoaopertype As %Library.String(MAXLEN = 100, XMLNAME = "paoaopertype");

/// 是否重返手术 
Property paoaoperagainflag As %Library.String(MAXLEN = 100, XMLNAME = "paoaoperagainflag");

/// 预计时长 
Property paoaoperlasttime As %Library.String(MAXLEN = 100, XMLNAME = "paoaoperlasttime");

/// 拟施麻醉 
Property paoaanesmethod As %Library.String(MAXLEN = 100, XMLNAME = "paoaanesmethod");

/// 申请医生代码 
Property paoaappdoccode As %Library.String(MAXLEN = 100, XMLNAME = "paoaappdoccode");

/// 申请医生 
Property paoaappdocname As %Library.String(MAXLEN = 100, XMLNAME = "paoaappdocname");

/// 申请科室代码 
Property paoaappdeptcode As %Library.String(MAXLEN = 100, XMLNAME = "paoaappdeptcode");

/// 申请科室 
Property paoaappdeptdesc As %Library.String(MAXLEN = 100, XMLNAME = "paoaappdeptdesc");

/// 申请日期 
Property paoaappdate As %Library.String(MAXLEN = 100, XMLNAME = "paoaappdate");

/// 申请时间 
Property paoaapptime As %Library.String(MAXLEN = 100, XMLNAME = "paoaapptime");

/// 术前诊断代码 
Property paoaprediagcode As %Library.String(MAXLEN = 100, XMLNAME = "paoaprediagcode");

/// 术前诊断 
Property paoaprediagdesc As %Library.String(MAXLEN = 100, XMLNAME = "paoaprediagdesc");

/// 术前诊断备注 
Property paoaprediagremark As %Library.String(MAXLEN = 100, XMLNAME = "paoaprediagremark");

/// abo血型 
Property paoaabo As %Library.String(MAXLEN = 100, XMLNAME = "paoaabo");

/// rh血型 
Property paoarh As %Library.String(MAXLEN = 100, XMLNAME = "paoarh");

/// hbsag 
Property paoahbsag As %Library.String(MAXLEN = 100, XMLNAME = "paoahbsag");

/// hcvab 
Property paoahcvab As %Library.String(MAXLEN = 100, XMLNAME = "paoahcvab");

/// hivab 
Property paoahivab As %Library.String(MAXLEN = 100, XMLNAME = "paoahivab");

/// 梅毒 
Property paoasyphilis As %Library.String(MAXLEN = 100, XMLNAME = "paoasyphilis");

/// 院内手术申请id 
Property paoahosoperappid As %Library.String(MAXLEN = 100, XMLNAME = "paoahosoperappid");

/// 业务域 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 时间戳日期 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳时间 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 全局手术申请id 
Property paoareloperappid As %Library.String(MAXLEN = 100, XMLNAME = "paoareloperappid");

/// 全局患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 全局就诊id 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

}
