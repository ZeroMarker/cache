Class web.DHCENS.STBLL.DICTNew.METHOD.CTObservationItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取生命体征字典信息
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTObservationItem).GetCTObservationItem("79").Read()
ClassMethod GetCTObservationItem(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTObservationItemByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：生命体征字典信息
/// Table：MRC_ObservationItem
/// Input： 
/// Return：生命体征信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTObservationItem).SendCTObservationItem("")
ClassMethod SendCTObservationItem(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^MRC("OBITM",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTObservationItemByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ObservationItem",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTObservationItemByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ObservationItem",tSC)
#;	set Instream=..GetCTObservationItemByID(plist)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	do tSC.OutputToDevice()
#;
#;	
	Quit tSC.Read()
Exception
	Quit "-1^"_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-12
/// Description：生命体征字典信息
/// Table：MRC_ObservationItem
/// Input： 
/// Return：生命体征信息集合
/// Others:w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTObservationItem).GetCTObservationItemByID("")
ClassMethod GetCTObservationItemByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTObservationItem).%New()
		set obsInfo=$g(^MRC("OBITM",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTOICode=$p(obsInfo,"^",1)
		set Obj.CTOIDesc=$p(obsInfo,"^",2)
		set Obj.CTOIInputType=$p(obsInfo,"^",3)
		set unitDr=$p(obsInfo,"^",4)
		set:unitDr'="" Obj.CTOIInputUnit=$p($g(^CT("UOM",unitDr)),"^",1)
		set Obj.CTOIStatus="1"
		set Obj.CTOICodesystemCode="CT_ObservationItem"
		d ListInfo.CTObservationItem.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTObservationItem",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ObservationItem",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
