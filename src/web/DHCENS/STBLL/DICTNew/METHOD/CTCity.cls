Class web.DHCENS.STBLL.DICTNew.METHOD.CTCity Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：市内字典信息
/// Table：CT_City
/// Input： 
/// Return：性别字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCity).GetCTCity("")
ClassMethod GetCTCity(Input As %String) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
		}
	if pList.Count()>0{
		set OutputStream=..GetCTCityByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// MDM初始化批量导入字典
/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：市内字典信息
/// Table：CT_City
/// Input： 
/// Return：市内字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCity).SendCTCity("")
ClassMethod SendCTCity(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("CIT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>20 d
	..set Instream=..GetCTCityByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_City",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCityByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_City",tSC)	
	q "0" ;
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-01
/// Description：市内字典信息
/// Table：CT_City
/// Input： 
/// Return：市内字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCity).GetCTCityByID("")
ClassMethod GetCTCityByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCity).%New()
		set Obj.businessrowid=rowid
		set Str=$g(^CT("CIT",rowid))
		set Obj.CTCCode=$p(Str,"^",1)
		set Obj.CTCDesc=$p(Str,"^",2)
		set provDr=$p(Str,"^",4)
		set provCode=""
		if provDr'="" d
		.set provInfo=$g(^CT("PROV",provDr)) 
		.set Obj.CTCPCode=provDr
		set Obj.CTCCodesystemCode="CT_City"
		set Obj.CTCStatus="1"
		set Obj.CTCStartDate=$p(Str,"^",5)
		set:Obj.CTCStartDate="" Obj.CTCStartDate="2008-01-01"
		set Obj.CTCEndDate=$p(Str,"^",6)
		set Obj.CTCUpdateUserCode="无"
		do ListInfo.CTCity.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCity",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_City",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
