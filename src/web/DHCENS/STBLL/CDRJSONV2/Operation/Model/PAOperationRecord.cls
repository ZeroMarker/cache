Class web.DHCENS.STBLL.CDRJSONV2.Operation.Model.PAOperationRecord Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 院内手术id 
Property paorhosoperationid As %Library.String(MAXLEN = 100, XMLNAME = "paorhosoperationid");

/// 业务域 
Property businessfieldcode As %Library.String(MAXLEN = 100, XMLNAME = "businessfieldcode");

/// 手术开始日期 
Property paoroperstartdate As %Library.String(MAXLEN = 100, XMLNAME = "paoroperstartdate");

/// 手术开始时间 
Property paoroperstarttime As %Library.String(MAXLEN = 100, XMLNAME = "paoroperstarttime");

/// 手术结束日期 
Property paoroperenddate As %Library.String(MAXLEN = 100, XMLNAME = "paoroperenddate");

/// 手术结束时间 
Property paoroperendtime As %Library.String(MAXLEN = 100, XMLNAME = "paoroperendtime");

/// 手术代码 
Property paoroperationcode As %Library.String(MAXLEN = 100, XMLNAME = "paoroperationcode");

/// 手术名称 
Property paoroperationdesc As %Library.String(MAXLEN = 100, XMLNAME = "paoroperationdesc");

/// 术者工号 
Property paoroperdoccode As %Library.String(MAXLEN = 100, XMLNAME = "paoroperdoccode");

/// 手术状态代码 
Property paoroperstatuscode As %Library.String(MAXLEN = 100, XMLNAME = "paoroperstatuscode");

/// 手术级别 
Property paoroperationlevel As %Library.String(MAXLEN = 100, XMLNAME = "paoroperationlevel");

/// 手术部位 
Property paoroperationposition As %Library.String(MAXLEN = 100, XMLNAME = "paoroperationposition");

/// 手术体位 
Property paoroperationposture As %Library.String(MAXLEN = 100, XMLNAME = "paoroperationposture");

/// 一助工号 
Property paoroperfirassicode As %Library.String(MAXLEN = 100, XMLNAME = "paoroperfirassicode");

/// 二助工号 
Property paoropersecassicode As %Library.String(MAXLEN = 100, XMLNAME = "paoropersecassicode");

/// 三助工号 
Property paoroperthirassicode As %Library.String(MAXLEN = 100, XMLNAME = "paoroperthirassicode");

/// 器械护士工号 
Property paorscrubnurcode As %Library.String(MAXLEN = 100, XMLNAME = "paorscrubnurcode");

/// 巡回护士工号 
Property paorcirculnurcode As %Library.String(MAXLEN = 100, XMLNAME = "paorcirculnurcode");

/// 时间戳日期 
Property updatedate As %Library.String(MAXLEN = 100, XMLNAME = "updatedate");

/// 时间戳时间 
Property updatetime As %Library.String(MAXLEN = 100, XMLNAME = "updatetime");

/// 业务域_院内手术id 
Property paorreloperationid As %Library.String(MAXLEN = 100, XMLNAME = "paorreloperationid");

/// 业务域_院内申请id 
Property paoareloperappid As %Library.String(MAXLEN = 100, XMLNAME = "paoareloperappid");

/// 业务域_院内患者id 
Property papatrelpatientid As %Library.String(MAXLEN = 100, XMLNAME = "papatrelpatientid");

/// 业务域_院内就诊号 
Property paadmrelvisitnumber As %Library.String(MAXLEN = 100, XMLNAME = "paadmrelvisitnumber");

/// 术者姓名 
Property paoroperdocname As %Library.String(MAXLEN = 100, XMLNAME = "paoroperdocname");

/// 手术状态描述 
Property paoroperstatusdesc As %Library.String(MAXLEN = 100, XMLNAME = "paoroperstatusdesc");

/// 一助姓名 
Property paoroperfirassiname As %Library.String(MAXLEN = 100, XMLNAME = "paoroperfirassiname");

/// 二助姓名 
Property paoropersecassiname As %Library.String(MAXLEN = 100, XMLNAME = "paoropersecassiname");

/// 三助姓名 
Property paoroperthirassiname As %Library.String(MAXLEN = 100, XMLNAME = "paoroperthirassiname");

/// 器械护士姓名 
Property paorscrubnurname As %Library.String(MAXLEN = 100, XMLNAME = "paorscrubnurname");

/// 巡回护士姓名 
Property paorcirculnurname As %Library.String(MAXLEN = 100, XMLNAME = "paorcirculnurname");

}
