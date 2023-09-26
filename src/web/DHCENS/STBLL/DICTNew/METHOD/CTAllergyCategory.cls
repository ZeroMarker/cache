Class web.DHCENS.STBLL.DICTNew.METHOD.CTAllergyCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：获取过敏类型字典信息
/// Table：MRC_AllType
/// Input： 
/// Return：过敏类型字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergyCategory).GetCTAllergyCategory("1").Read()
ClassMethod GetCTAllergyCategory(Input As %String = "") As %GlobalCharacterStream
{
	set $zt="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTAllergyCategoryByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：推送过敏类型字典信息
/// Table：MRC_AllType
/// Input： 
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergyCategory).SendCTAllergyCategory("")
ClassMethod SendCTAllergyCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^MRC("AT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 do
	..set Instream=..GetCTAllergyCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AllergyCategory",tSC)
	..do tSC.OutputToDevice()
	..do Instream.Clear()
	..set count=1
	..do plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTAllergyCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)	
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AllergyCategory",tSC)
	.do tSC.OutputToDevice()
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

ClassMethod GetCTAllergyCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTAllergyCategory).%New()
		set str=$g(^MRC("AT",rowid))
		q:str=""
		set Obj.businessrowid=rowid
		set Obj.CTACCode=$P(^MRC("AT",rowid),"^",1)
		set Obj.CTACCodesystemCode="CT_AllergyCategory"
		set Obj.CTACDesc=$P(^MRC("AT",rowid),"^",2)
		set Obj.CTACRemarks=""
		set Obj.CTACStatus="1"
		set Obj.CTACUpdateUserCode="无"
		d ListInfo.CTAllergyCategory.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTAllergyCategory",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_AllergyCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
