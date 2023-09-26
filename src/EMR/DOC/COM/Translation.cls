/// 名称:	EMR.DOC.COM.Translation
/// 描述:	iMedical国际化改造
/// 编写者：yejian
/// 编写日期: 2021-7-27
/// 产品组：电子病历产品组 
Class EMR.DOC.COM.Translation Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-05-07
///  Desc:       获取实例表的翻译
///  Input:      AClassName:类名
///  		     AProperty：属性名
///  		     AValue：属性值
///  return:     result 翻译后的数据或原数据
///  Debug:      w ##Class(EMR.DOC.COM.Translation).GetTranByDesc("EMRmeta.KBNode","Name","消化内科")
ClassMethod GetTranByDesc(AClassName As %String, AProperty As %String, AValue As %String, ALangid As %String = "20") As %String
{
	s result = AValue
	q:(AClassName = "")||(AProperty = "")||(AValue = "")||(ALangid = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId(AClassName) = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId(AClassName_"||GetTranByDesc") = "0") result
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
