Class web.DHCENS.STBLL.DICTNew.METHOD.CTRBCAppointMethod Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：预约方式字典信息
/// Table：RBC_AppointMethod
/// Input： 
/// Return：预约方式信息集合
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRBCAppointMethod).GetCTRBCAppointMethod("1").Read()
ClassMethod GetCTRBCAppointMethod(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTRBCAppointMethodByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：预约方式字典信息
/// Table：RBC_AppointMethod
/// Input： 
/// Return：预约方式信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRBCAppointMethod).SendCTRBCAppointMethod("")
ClassMethod SendCTRBCAppointMethod(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set Count=1
	set rowid="0"  for  set rowid=$o(^RBC("APTM",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,Count)
	.set Count=Count+1
	if plist.Count()>0{
		set Instream=..GetCTRBCAppointMethodByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_RBCAppointMethod",tSC)
		d tSC.OutputToDevice()
	}
	Quit 1
Exception
	Quit -1_$ze
}

/// Creator：ZhangXinying
/// CreatDate：2018-11-01
/// Description：预约方式信息
/// Table：RBC_AppointMethod
/// Input： 
/// Return：预约方式信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRBCAppointMethod).GetCTRBCAppointMethodByID("")
ClassMethod GetCTRBCAppointMethodByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set Count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set RBCMInfo=$g(^RBC("APTM",rowid))
		set RBCAMObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTRBCAppointMethod).%New()
		set RBCAMObj.businessrowid=rowid
		set RBCAMObj.CTRBCAMCode=$p(RBCMInfo,"^",1)
		set CTRBCAMDesc=$p(RBCMInfo,"^",2)
		set RBCAMObj.CTRBCAMDesc=$p(RBCMInfo,"^",2)
		set RBCAMObj.CTRBCAMCodesystemCode="CT_RBCAppointMethod"
		set RBCAMObj.CTRBCAMRemarks="无"
		set RBCAMObj.CTRBCAMStatus="1"
		set RBCAMObj.CTRBCAMUpdateUserCode="无"
		d ListInfo.CTRBCAppointMethod.Insert(RBCAMObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTRBCAppointMethod",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_RBCAppointMethod",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
