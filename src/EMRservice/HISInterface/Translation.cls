/// iMedical国际化改造
Class EMRservice.HISInterface.Translation Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-05-07
///  Desc:       获取实例表的翻译
///  Input:      AClassName:类名
///  		     AProperty：属性名
///  		     AValue：属性值
///  return:     result 翻译后的数据或原数据
///  Debug:      w ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.KBNode","Name","消化内科")
ClassMethod GetTranByDesc(AClassName As %String, AProperty As %String, AValue As %String, ALangid As %String = "") As %String
{
	s result = AValue
	q:(AClassName = "")||(AProperty = "")||(AValue = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId(AClassName) = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId(AClassName_"||GetTranByDesc") = "0") result
	Set:(ALangid="") ALangid=20
	if ($d(%session)){
		set ALangid=+$g(%session.Data("LOGON.LANGID"))
	}
	s execCode = "result=##class("_AClassName_").GetTranByDesc"_"("""_AProperty_""","""_AValue_""","""_ALangid_""")"
    s @execCode
    s result = @"result" 
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-05-26
///  Desc:       获取文字的翻译
///  Input:      APage:当前csp名字
///  		     AItem：要翻译的键
///  return:     result 翻译后的数据或原数据
///  Debug:      w ##Class(EMRservice.HISInterface.Translation).Get("EMRTrans","收藏夹")
ClassMethod Get(APage As %String, AItem As %String) As %String
{
	s result = AItem
	q:(APage = "")||(AItem = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId("websys.Translation") = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("websys.Translation||Get") = "0") result
	s execCode = "result=##class(websys.Translation).Get"_"("""_APage_""","""_AItem_""")"
    s @execCode
    s result = @"result" 
	q result
}

}
