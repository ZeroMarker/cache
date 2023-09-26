Class web.DHCENS.STBLL.DICTNew.METHOD.CTCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCategory).SendCTCategory("")
ClassMethod SendCTCategory(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^OEC("ORCAT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 do
	..set Instream=..GetCTCategoryByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Category",tSC)
	..do tSC.OutputToDevice()
	..do Instream.Clear()
	..set count=1
	..do plist.Clear()
	;set stream=..GetHospitalByID(plist)
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCategoryByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Category",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

ClassMethod GetCTCategoryByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCategory).%New()
		set Str=$g(^OEC("ORCAT",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTCCode=$p(Str,"^",1)
		set Obj.CTCDesc=$p(Str,"^",2)
		set Obj.CTCCodesystemCode="CT_Category"
		set Obj.CTCRemarks=""
		set Obj.CTCStatus="1"
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		set Obj.CTCHosCode=hospCode
		set Obj.CTCUpdateUserCode="无"
		d ListInfo.CTCategory.Insert(Obj)
		set count=ListInfo.CTCategory.Count()
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCategory",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Category",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：医嘱大类项字典信息
/// Table：oec_ordercategory
/// Input： 
/// Return：收费项字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCategory).GetCTCategory("1").Read()
ClassMethod GetCTCategory(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTCategoryByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
