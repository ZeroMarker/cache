Class web.DHCENS.STBLL.DICTNew.METHOD.CTBodyArea Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：获取检查部位字典信息
/// Table：CT_BodyArea
/// Input： 
/// Return：检查部位字典信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBodyArea).GetCTBodyArea("1").Read()
ClassMethod GetCTBodyArea(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTBodyAreaByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：推送检查部位字典信息
/// Table：CT_BodyArea
/// Input： 
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBodyArea).SendCTBodyArea("")
ClassMethod SendCTBodyArea(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^DHCAPPART(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 do
	..set Instream=..GetCTBodyAreaByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BodyArea",tSC)
	..do tSC.OutputToDevice()
	..do Instream.Clear()
	..set count=1
	..do plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTBodyAreaByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_BodyArea",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

ClassMethod GetCTBodyAreaByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTBodyArea).%New()
		set bodyAreaInfo=$g(^DHCAPPART(rowid))
		set Obj.businessrowid=rowid
		set Obj.CTBACode=$p(bodyAreaInfo,"^",1)
		set Obj.CTBADesc=$p(bodyAreaInfo,"^",1)
		set Obj.CTBACodesystemCode="CT_BodyArea"
		set Obj.CTBARemarks="无"
		set Obj.CTBAStatus="1"
		set Obj.CTBAUpdateDate=""
		d ListInfo.CTBodyArea.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTBodyArea",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_BodyArea",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
