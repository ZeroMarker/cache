Class web.DHCENS.STBLL.DICTNew.METHOD.CTPayMode Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：支付方式字典信息
/// Table：CT_PayMode
/// Input： 
/// Return：支付方式字典信息
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPayMode).GetCTPayMode("1")
ClassMethod GetCTPayMode(Input As %String) As %GlobalCharacterStream
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
		set OutputStream=..GetCTPayModeByID(pList)
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
/// Description：支付方式字典信息
/// Table：CT_PayMode
/// Input： 
/// Return：支付方式信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPayMode).SendCTPayMode("")
ClassMethod SendCTPayMode(Input As %String = "") As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CT("CTPM",rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1	
	if plist.Count()>0{
		set Instream=..GetCTPayModeByID(plist)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		do tSC.OutputToDevice()
		set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_PayMode",tSC)
	}
	
	Quit "1"
Exception
	Quit -1_$ze
}

/// Creator：wangyaru
/// CreatDate：2019-09-17
/// Description：支付方式字典信息
/// Table：CT_PayMode
/// Input： 
/// Return：支付方式信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPayMode).GetCTPayModeByID("")
ClassMethod GetCTPayModeByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set rowid=pList.GetAt(i)
		set payModeInfo=$g(^CT("CTPM",rowid))
		set payModeObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTPayMode).%New()
		set payModeObj.businessrowid=rowid
		set payModeObj.CTPMCode=$p(payModeInfo,"^",1)
		set payModeObj.CTPMDesc=$p(payModeInfo,"^",2)
		set payModeObj.CTPMCodesystemCode="CT_PayMode"
		set payModeObj.CTPMRemarks="无"
		if $p(payModeInfo,"^",3)="Y"{
			set payModeObj.CTPMStatus="0"
		}else{
			set payModeObj.CTPMStatus="1"
		}
		set startDate=$p(payModeInfo,"^",5)
		;w startDate,!
		if startDate'=""{
			;set payModeObj.CTPMStartDate=$zd(startDate,3)
			set payModeObj.CTPMStartDate=startDate
			;w payModeObj.CTPMStartDate,!
		}
		set endDate=$p(payModeInfo,"^",6)
		if endDate'=""{
			;set payModeObj.CTPMEndDate=$zd(endDate,3)
			set payModeObj.CTPMEndDate=endDate
		}
		set payModeObj.CTPMUpdateUserCode="无"
		d ListInfo.CTPayMode.Insert(payModeObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTPayMode",.Jsonobj)
	
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	//w JsonString,!
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	//set JsonString=$tr(JsonString,$c(13),"")
	//set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_PayMode",JsonString)
	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

}
