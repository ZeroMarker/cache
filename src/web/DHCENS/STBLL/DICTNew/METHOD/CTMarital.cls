Class web.DHCENS.STBLL.DICTNew.METHOD.CTMarital Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—11-06
/// Description：婚姻类型字典信息
/// Table：CT_Marital
/// Input： 
/// Return：婚姻类型信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMarital).GetCTMarital("")
ClassMethod GetCTMarital(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTMaritalByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-06
/// Description：婚姻类型字典信息
/// Table：CT_Marital
/// Input： 
/// Return：婚姻类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMarital).SendCTMarital("")
ClassMethod SendCTMarital(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("MAR",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTMaritalByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_Marital",tSC)
	.do tSC.Rewind()
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：luofanyu
/// CreatDate：2018-11-06
/// Description：婚姻类型字典信息
/// Table：CT_Marital
/// Input： 
/// Return：婚姻类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMarital).GetCTMaritalByID("")
ClassMethod GetCTMaritalByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set maritalInfo=$g(^CT("MAR",rowid))
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMarital).%New()
		set maritalObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMarital).%New()
		set maritalObj.businessrowid=rowid
		set maritalObj.businessrowid=rowid
		set maritalObj.CTMCode=$p(maritalInfo,"^",1)
		set maritalObj.CTMDesc=$p(maritalInfo,"^",2)
		set maritalObj.CTMCodesystemCode="CT_Marital"
		set maritalObj.CTMRemarks="无"
		set maritalObj.CTMStatus="1"
		set maritalObj.CTMStartDate=$p(maritalInfo,"^",4)
		set maritalObj.CTMUpdateUserCode="无"
		set FromDate=$p(maritalInfo,"^",4)
		set:FromDate'="" maritalObj.CTMStartDate=$zd(FromDate,3)
		d ListInfo.CTMarital.Insert(maritalObj)
		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTMarital",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Marital",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou
/// CreatDate：2018-06-04
/// Description：婚姻类型字典信息
/// Table：CT_Marital
/// Input： 
/// Return：婚姻类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMarital).CTMarital("")
ClassMethod CTMarital(input As %String) As %String
{
	set $zt="MsgErr"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set maritalId="0"  for  set maritalId=$o(^CT("MAR",maritalId)) q:maritalId=""  d
	.Quit:((maritalId'=input)&&(input'=""))
	.set maritalInfo=$g(^CT("MAR",maritalId))
	.set maritalObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTMarital).%New()
	.set maritalObj.CTMCode=$p(maritalInfo,"^",1)
	.set maritalObj.CTMDesc=$p(maritalInfo,"^",2)
	.set maritalObj.CTMCodesystemCode="CT_Marital"
	.set maritalObj.CTMRemarks="无"
	.set maritalObj.CTMStatus="1"
	.set maritalObj.CTMStartDate=$p(maritalInfo,"^",4)
	.set maritalObj.CTMUpdateUserCode="无"
	.d ListInfo.CTMarital.Insert(maritalObj)
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTMarital",.Jsonobj)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_Marital",JsonString)
	set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	if resultCode=0 d
	.set success=0
	else  d
	.set success=-1
	quit success
	
	
	
MsgErr
	quit "-1"_$ze
}

}
