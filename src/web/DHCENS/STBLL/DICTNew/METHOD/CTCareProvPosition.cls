Class web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvPosition Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：医护人员职务字典信息
/// Table：ct_empjob表
/// Input： 
/// Return：医护人员职务信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvPosition).CTCareProvPosition("")
ClassMethod GetCTCareProvPosition(Input As %String = "") As %String
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
		set OutputStream=..GetCTCareProvPositionByID(pList)
	}
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod GetCTCareProvPositionByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvPosition).%New()
		set insObj.businessrowid=rowid
		set insObj.CTCPPCode=$p($g(^CT("EMJ",rowid)),"^",1)
		set insObj.CTCPPDesc=$p($g(^CT("EMJ",rowid)),"^",2)
		set insObj.CTCPPCodesystemCode="CT_CareProvPosition"
		set hospId=$o(^CT("HOSP","0")),hospCode=""
		set:hospId'="" hospCode=$p($g(^CT("HOSP",hospId)),"^",1)	
		set insObj.CTCPPHosCode=hospCode
		set insObj.CTCPPStatus="1"
		d ListInfo.CTCareProvPosition.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCareProvPosition",.Jsonobj)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProvPosition",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：luofanyu
/// CreatDate：2018-11-13
/// Description：医护人员职务信息
/// Table：CT_EmpJob
/// Input： 
/// Return：医护人员职务信息
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvPosition).SendCTCareProvPosition("")
ClassMethod SendCTCareProvPosition(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("EMJ",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	.if count>50 d
	..set Instream=..GetCTCareProvPositionByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProvPosition",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCareProvPositionByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProvPosition",tSC)
	
	q "0" ;sc
#;	set Instream=..GetCTCareProvPositionByID(plist)
#;	set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
#;	Quit tSC.Read()
Exception
	Quit -1_$ze
}

}
