Class web.DHCENS.STBLL.DICTNew.METHOD.CTDischMeans Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：离院方式字典信息
/// Table：CT_DischMeans
/// Input： 
/// Return：离院方式字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischMeans).GetCTDischMeans("1")
ClassMethod GetCTDischMeans(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTDischMeansByID(pList)
	}
	w OutputStream.Read()
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：离院方式字典信息
/// Table：CT_DischMeans
/// Input： 
/// Return：离院方式信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischMeans).SendCTDischMeans("")
ClassMethod SendCTDischMeans(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PACDEPARTUREMEANS(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTDischMeansByID(plist)
		do Instream.Rewind()
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_DischMeans",tSC)		
		Quit tSC.Read()
	}
	q "1"
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：离院方式字典信息
/// Table：CT_DischMeans
/// Input： 
/// Return：离院方式信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischMeans).GetCTDischMeansByID("")
ClassMethod GetCTDischMeansByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set dischMeansInfo=$g(^PACDEPARTUREMEANS(rowid))
		set dischMeansObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTDischMeans).%New()
		set dischMeansObj.businessrowid=rowid
		set dischMeansObj.CTDMCode=$p(dischMeansInfo,"^",1)
		set dischMeansObj.CTDMDesc=$p(dischMeansInfo,"^",2)
		set dischMeansObj.CTDMCodesystemCode="CT_DischMeans"
		set dischMeansObj.CTDMRemarks="无"
		set dischMeansObj.CTDMStatus="1"
		set dischMeansObj.CTDMStartDate=$p(dischMeansInfo,"^",3)
		set dischMeansObj.CTDMEndDate=""
		set dischMeansObj.CTDMUpdateUserCode="无"
		d ListInfo.CTDischMeans.Insert(dischMeansObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTDischMeans",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;w JsonString,!
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	//set JsonString=$tr(JsonString,$c(13),"")
	//set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_DischMeans",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
