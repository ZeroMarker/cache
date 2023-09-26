Class web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：ZhangXinying
/// CreatDate：2018—11-06
/// Description：医嘱状态字典信息
/// Table：OEC_OrderAdminStatus
/// Input： 
/// Return：医嘱状态信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus).GetCTOrderAdminStatus("1").Read()
ClassMethod GetCTOrderAdminStatus(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTOrderAdminStatusByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-06
/// Description：医嘱执行记录状态字典信息
/// Table：OEC_OrderAdminStatus
/// Input： 
/// Return：医嘱执行记录状态信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus).SendCTOrderAdminStatus("")
ClassMethod SendCTOrderAdminStatus(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^OEC("STAT",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTOrderAdminStatusByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_OrderAdminStatus",tSC)
	
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-06
/// Description：医嘱执行记录状态字典信息
/// Table：OEC_OrderAdminStatus
/// Input： 
/// Return：医嘱执行记录状态信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus).GetCTOrderAdminStatusByID("")
ClassMethod GetCTOrderAdminStatusByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set OrderAdminStatusInfo=$g(^OEC("STAT",rowid))
		set Obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOrderAdminStatus).%New()
		set OrderAdminStatusObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTOrderAdminStatus).%New()
		set Obj.businessrowid=rowid
		set Obj.CTOASCode=$p(OrderAdminStatusInfo,"^",1)
		set Obj.CTOASDesc=$p(OrderAdminStatusInfo,"^",2)
		set Obj.CTOASCodesystemCode="CT_OrderAdminStatus"
		set Obj.CTOASRemarks=""
		set Obj.CTOASStatus="1"
		set Obj.CTOASUpdateUserCode="无"	
		d ListInfo.CTOrderAdminStatus.Insert(Obj)
		
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTOrderAdminStatus",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_OrderAdminStatus",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
