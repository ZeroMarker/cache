Class web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitMeans Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：入院途径字典信息
/// Table：CT_AdmitMeans
/// Input： 
/// Return：入院途径字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitMeans).GetCTAdmitMeans("1")
ClassMethod GetCTAdmitMeans(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTAdmitMeansByID(pList)
	}
	;w OutputStream.Read()
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：入院途径字典信息
/// Table：CT_AdmitMeans
/// Input： 
/// Return：入院途径信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitMeans).SendCTAdmitMeans("")
ClassMethod SendCTAdmitMeans(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^PAC("TRANSM",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set Instream=..GetCTAdmitMeansByID(plist)
	do Instream.Rewind()
	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_AdmitMeans",tSC)
	d tSC.OutputToDevice()
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：入院途径字典信息
/// Table：CT_AdmitMeans
/// Input： 
/// Return：入院途径信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitMeans).GetCTAdmitMeansByID("")
ClassMethod GetCTAdmitMeansByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set admitMeansInfo=$g(^PAC("TRANSM",rowid))
		set admitMeansObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitMeans).%New()
		set admitMeansObj.businessrowid=rowid
		set admitMeansObj.CTAMCode=$p(admitMeansInfo,"^",1)
		set admitMeansObj.CTAMDesc=$p(admitMeansInfo,"^",2)
		set admitMeansObj.CTAMCodesystemCode="CT_AdmitMeans"
		set admitMeansObj.CTAMRemarks="无"
		set admitMeansObj.CTAMStatus="1"
		set admitMeansObj.CTAMStartDate=$p(admitMeansInfo,"^",5)
		set admitMeansObj.CTAMEndDate=$p(admitMeansInfo,"^",6)
		set admitMeansObj.CTAMUpdateUserCode="无"
		d ListInfo.CTAdmitMeans.Insert(admitMeansObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTAdmitMeans",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_AdmitMeans",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
