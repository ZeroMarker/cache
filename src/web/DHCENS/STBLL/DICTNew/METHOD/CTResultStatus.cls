Class web.DHCENS.STBLL.DICTNew.METHOD.CTResultStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-11-12
/// Description：医嘱结果状态信息
/// Table：OEC_ResultStatus
/// Input： 
/// Return：医嘱结果状态信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTResultStatus).GetCTResultStatus("1").Read()
ClassMethod GetCTResultStatus(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTResultStatusByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：医嘱结果状态信息
/// Table：OEC_ResultStatus
/// Input： 
/// Return：医嘱结果状态集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTResultStatus).SendCTResultStatus("")
ClassMethod SendCTResultStatus(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^OEC("RESST",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	if plist.Count()>0{
		set Instream=..GetCTResultStatusByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_ResultStatus",tSC)
		d tSC.OutputToDevice()
	} 
	
	
	Quit 1
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：医嘱结果状态信息
/// Table：OEC_ResultStatus
/// Input： 
/// Return：医嘱结果状态集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTResultStatus).GetCTResultStatusByID("")
ClassMethod GetCTResultStatusByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTResultStatus).%New()
		set Str=$g(^OEC("RESST",rowid))
		set Obj.businessrowid=rowid
		set Obj.CTRSCode=$p(Str,"^",1)
		set Obj.CTRSDesc=$p(Str,"^",2)
		set Obj.CTRSCodesystemCode="CT_ResultStatus"
		set Obj.CTRSRemarks=""
		set Obj.CTRSStatus="1"
		set Obj.CTRSUpdateUserCode="无"
		d ListInfo.CTResultStatus.Insert(Obj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTResultStatus",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_ResultStatus",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
