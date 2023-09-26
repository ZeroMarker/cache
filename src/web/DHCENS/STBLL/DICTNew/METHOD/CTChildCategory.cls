Class web.DHCENS.STBLL.DICTNew.METHOD.CTChildCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：推送医嘱子类项字典信息
/// Table：Arc_itemcat
/// Input： 
/// Return：推送医嘱子类字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChildCategory).SendCTChildCategory("")
ClassMethod SendCTChildCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^ARC("IC",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 do
	..set Instream=..GetCTChildCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ChildCategory",tSC)
	..do tSC.OutputToDevice()
	..do Instream.Clear()
	..set count=1
	..do plist.Clear()
	;set stream=..GetHospitalByID(plist)
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTChildCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ChildCategory",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

ClassMethod GetCTChildCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTChildCategory).%New()
		s Str=$g(^ARC("IC",rowid))
		q:Str=""
		s Obj.businessrowid=rowid
		s Obj.CTCCCode=$p(Str,"^",1)
		s Obj.CTCCDesc=$p(Str,"^",2)
		s OrderCategoryDr=$p(Str,"^",8),StrOrderCategory=""
		s:OrderCategoryDr'="" StrOrderCategory=$g(^OEC("ORCAT",OrderCategoryDr))
		if OrderCategoryDr="" b ;
		s Obj.CTCCCategory=OrderCategoryDr //$p(StrOrderCategory,"^",1)
		set Obj.CTCCCodesystemCode="CT_ChildCategory"
		set Obj.CTCCStatus="1"
		set Obj.CTCCUpdateUserCode="无"
		set Obj.CTCCOrderType=$p(Str,"^",7)
		d ListInfo.CTChildCategory.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTChildCategory",.Jsonobj)
	;set JsonStream=##class(%GlobalCharacterStream).%New()
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ChildCategory",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：获取医嘱子类项字典信息
/// Table：arc_itemcat
/// Input： 
/// Return：医嘱子类字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChildCategory).GetCTChildCategory("1").Read()
ClassMethod GetCTChildCategory(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTChildCategoryByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
