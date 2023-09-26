Class web.INMInsertData Extends %RegisteredObject
{

ClassMethod InsertLang1(parId As %String = "") As %String
{
    s obj=##class(CT.DHCINM.Set.MgLang).%New()
    s obj.LangMenuType="M"
    s obj.LangMenuCode="WorkPlatform"
    s obj.LangType="M"
    s obj.LangCode="MenuDesc"
    d obj.LangSubTypeSetObjectId("22||1")
    s obj.LangDesc="工作台"
    s obj.Creator=0
    d obj.%Save()
    s obj=##class(CT.DHCINM.Set.MgLang).%New()
    s obj.LangMenuType="M"
    s obj.LangMenuCode="WorkPlatform"
    s obj.LangType="M"
    s obj.LangCode="MenuDesc"
    d obj.LangSubTypeSetObjectId("22||2")
    s obj.LangDesc="WorkPlatform"
    s obj.Creator=0
    d obj.%Save()
	
	s id="" f  s id=$o(^CT.DHCINM.Set.MgModuleD(id)) q:id=""  d
	.s glo=^CT.DHCINM.Set.MgModuleD(id)
	.q:glo=""
	.s code=$lg(glo,3)
	.s langDesc=$lg(glo,2)
	.s obj=##class(CT.DHCINM.Set.MgLang).%New()
    .s obj.LangMenuType="D"
    .s obj.LangMenuCode=code
    .s obj.LangType="M"
    .s obj.LangCode="MenuDesc"
    .d obj.LangSubTypeSetObjectId("22||1")
    .s obj.LangDesc=langDesc
    .s obj.Creator=0
    .d obj.%Save()
    .s obj=##class(CT.DHCINM.Set.MgLang).%New()
    .s obj.LangMenuType="D"
    .s obj.LangMenuCode=code
    .s obj.LangType="M"
    .s obj.LangCode="MenuDesc"
    .d obj.LangSubTypeSetObjectId("22||2")
    .s obj.LangDesc=$e(code,1,10)
    .s obj.Creator=0
    .d obj.%Save()
    
    s id="" f  s id=$o(^CT.DHCINM.Set.MgMenuD(id)) q:id=""  d
	.s glo=^CT.DHCINM.Set.MgMenuD(id)
	.q:glo=""
	.s code=$lg(glo,2)
	.s langDesc=$lg(glo,3)
	.s obj=##class(CT.DHCINM.Set.MgLang).%New()
    .s obj.LangMenuType="M"
    .s obj.LangMenuCode=code
    .s obj.LangType="M"
    .s obj.LangCode="MenuDesc"
    .d obj.LangSubTypeSetObjectId("22||1")
    .s obj.LangDesc=langDesc
    .s obj.Creator=0
    .d obj.%Save()
    .s obj=##class(CT.DHCINM.Set.MgLang).%New()
    .s obj.LangMenuType="M"
    .s obj.LangMenuCode=code
    .s obj.LangType="M"
    .s obj.LangCode="MenuDesc"
    .d obj.LangSubTypeSetObjectId("22||2")
    .s obj.LangDesc=code
    .s obj.Creator=0
    .d obj.%Save()
	
	q 1
}

/// w ##class(web.INMInsertData).ReadJson()
ClassMethod ReadJson(parId As %String = "") As %String
{
	
    s zhFile="d:/zh-CN.json"
	s zhStream=##class(%FileCharacterStream).%New()
	d zhStream.TranslateTableSet("UTF8")
	s sc=zhStream.LinkToFile(zhFile)
	if 'sc { w "Error on linking file "_zhFile,!   q }
	try {
		s zh=##class(%DynamicAbstractObject).%FromJSON(zhStream)
	} catch ex {
		w "Error. Unable to parse file "_zhFile,!
	    w "Error type   "_ex.Name,!
	    w "Error code   "_ex.Code,!
	    w "Error location "_ex.Location,!
	    s zh=""
	}
	
	s enFile="d:/en.json"
	s enStream=##class(%FileCharacterStream).%New()
	d enStream.TranslateTableSet("UTF8")
	s sc2=enStream.LinkToFile(enFile)
	if 'sc2 { w "Error on linking file "_enFile,!   q }
	try {
		s en=##class(%DynamicAbstractObject).%FromJSON(enStream)
	} catch ex {
		w "Error. Unable to parse file "_enFile,!
	    w "Error type   "_ex.Name,!
	    w "Error code   "_ex.Code,!
	    w "Error location "_ex.Location,!
	    s en=""
	}
	
	s flag=0
	s iter=zh.menu.%GetIterator()
    while iter.%GetNext(.key,.value) {
	    s iter2=value.%GetIterator()
	    while iter2.%GetNext(.key2,.value2) {
		    i en.menu.%Get(key).%Get(key2)="" d
		    .w key_"."_key2_":"_value2,!
		    .s flag=1
		}
	}
#;	k key,key2,value,value2
#;	s iter=zh.common.%GetIterator()
#;    while iter.%GetNext(.key,.value) {
#;	    s iter2=value.%GetIterator()
#;	    while iter2.%GetNext(.key2,.value2) {
#;		    i en.common.%Get(key).%Get(key2)="" d
#;		    .w key_"."_key2_":"_value2,!
#;		    .s flag=1
#;		}
#;	}
	if flag=1 {
		w "JSON数据不一致",!
		q
	}
	k key,key2,value,value2
	s iter=zh.menu.%GetIterator()
	while iter.%GetNext(.key,.value) {
	    s iter2=value.%GetIterator()
	    while iter2.%GetNext(.key2,.value2) {
		    s obj=##class(CT.DHCINM.Set.MgLang).%New()
		    s obj.LangMenuType="M"
		    s obj.LangMenuCode=key
		    s obj.LangType="L"
		    s obj.LangCode=key2
		    d obj.LangSubTypeSetObjectId(parId_"||1")
		    s obj.LangDesc=value2
		    s obj.Creator=0
		    d obj.%Save()
		    
		    s obj=##class(CT.DHCINM.Set.MgLang).%New()
		    s obj.LangMenuType="M"
		    s obj.LangMenuCode=key
		    s obj.LangType="L"
		    s obj.LangCode=key2
		    d obj.LangSubTypeSetObjectId(parId_"||2")
		    s obj.LangDesc=en.menu.%Get(key).%Get(key2)
		    s obj.Creator=0
		    d obj.%Save()
		}
	}
#;	k key,key2,value,value2
#;	s iter=zh.common.%GetIterator()
#;	while iter.%GetNext(.key,.value) {
#;	    s iter2=value.%GetIterator()
#;	    while iter2.%GetNext(.key2,.value2) {
#;		    s obj=##class(CT.DHCINM.Set.MgLang).%New()
#;		    s obj.LangMenuType=""
#;		    s obj.LangMenuCode=""
#;		    s obj.LangType="L"
#;		    s obj.LangCode=key2
#;		    d obj.LangSubTypeSetObjectId(parId_"||1")
#;		    s obj.LangDesc=value2
#;		    s obj.Creator=0
#;		    d obj.%Save()
#;		    
#;		    s obj=##class(CT.DHCINM.Set.MgLang).%New()
#;		    s obj.LangMenuType=""
#;		    s obj.LangMenuCode=""
#;		    s obj.LangType="L"
#;		    s obj.LangCode=key2
#;		    d obj.LangSubTypeSetObjectId(parId_"||2")
#;		    s obj.LangDesc=en.common.%Get(key).%Get(key2)
#;		    s obj.Creator=0
#;		    d obj.%Save()
#;		}
#;	}
	
	q ""
}

/// w ##class(web.INMInsertData).InsertLang()
ClassMethod InsertLang() As %String
{
    s parId=$o(^CT.DHCINM.Set.MgSysParamI("Code",$zu(28,"LangSet",7),""))
	q:parId="" "系统参数未设置"
    //d ..InsertLang1(parId)
    d ..ReadJson(parId)
	
	q 1
}

}
