Class web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：ZhangXinying
/// CreatDate：2018—11-06
/// Description：医嘱执行状态变化原因
/// Table：OEC_AdminStatusChReason
/// Input： 
/// Return：医嘱执行状态变化原因信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason).GetCTOrdStatusChReason("1").Read()
ClassMethod GetCTOrdStatusChReason(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOrdStatusChReasonByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-06
/// Description：医嘱执行状态变化原因
/// Table：OEC_AdminStatusChReason
/// Input： 
/// Return：医嘱执行状态变化原因集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason).SendCTOrdStatusChReason("")
ClassMethod SendCTOrdStatusChReason(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^OEC("ASCR",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOrdStatusChReasonByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OrdStatusChReason",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-06
/// Description：医嘱执行状态变化原因
/// Table：OEC_AdminStatusChReason
/// Input： 
/// Return：医嘱状态信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason).GetCTOrdStatusChReasonByID("")
ClassMethod GetCTOrdStatusChReasonByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set OrdStatusChReasonInfo=$g(^OEC("ASCR",rowid))
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOrdStatusChReason).%New()
		set OrdStatusChReasonObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOrdStatusChReason).%New()
		set Obj.businessrowid=rowid
		set Obj.CTOSCRCode=$p(OrdStatusChReasonInfo,"^",1)
		set Obj.CTOSCRDesc=$p(OrdStatusChReasonInfo,"^",2)
		set Obj.CTOSCRCodesystemCode="CT_OrdStatusChReason"
		set Obj.CTOSCRRemarks=""
		set Obj.CTOSCRStatus="1"
		set Obj.CTOSCRUpdateUserCode="无"	
		d ListInfo.CTOrdStatusChReason.Insert(Obj)
		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOrdStatusChReason",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OrdStatusChReason",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
