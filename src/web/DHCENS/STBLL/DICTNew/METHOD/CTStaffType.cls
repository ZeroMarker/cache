Class web.DHCENS.STBLL.DICTNew.METHOD.CTStaffType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2018—09-10
/// Description：人员类型字典信息
/// Table：ct_staff表
/// Input： 
/// Return：人员类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStaffType).CTStaffType("")
ClassMethod CTStaffType(input As %String = "") As %String
{
	set $zt="Exception"
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set RowId="0"  for  set RowId=$o(^CT("STAFF",RowId)) q:RowId=""  d
	.set CTSInfo=$g(^CT("STAFF",RowId))
	.set CTSObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTStaffType).%New()
	.set CTSObj.CTSTCode=$P(CTSInfo,"^",1)
	.set CTSObj.CTSTDesc=$P(CTSInfo,"^",2)
	.set CTSFromDate=$P(CTSInfo,"^",3)	
	.set CTSToDate=$P(CTSInfo,"^",4)
	.set:CTSFromDate'="" CTSObj.CTSTStartDate=CTSFromDate
	.set:CTSToDate'="" CTSObj.CTSTEndDate=CTSToDate	
	.set CTSObj.CTSTCodesystemCode="CT_StaffType"
	.set CTSObj.CTSTUpdateUserCode="无"
	.set CTSObj.CTSTStatus="1"
	.set hospId=$o(^CT("HOSP","0"))
	.set hospCode=$p(^CT("HOSP",hospId),"^",1)	
	.d ListInfo.CTStaffType.Insert(CTSObj)
	.set count=ListInfo.CTStaffType.Count()
	.if count>100 d
	..d ListInfo.XMLExportToString(.String)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTStaffType",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_StaffType",JsonString)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..d ListInfo.CTStaffType.Clear()
	..set count=0
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode=0 d
	...set success=0
	..else  d
	...set success=-1
	if count>0 {
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTStaffType",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_StaffType",JsonString)
		set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode=0 d
		.set success=0
		else  d
		.set success=-1
	}
	quit success

Exception
	Quit "-1^"_$ze
}

/// Description：人员类型字典信息
/// Table：ct_staff表
/// Input： 
/// Return：人员类型信息集合
/// Others: w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStaffType).GetCTStaffType("1").Read()
ClassMethod GetCTStaffType(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTStaffTypeByID(pList)
	}
	Quit OutputStream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回人员类型字典密文流
/// Table：ct_staff
/// Input： Array集合
/// Return：人员类型字典密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStaffType).GetCTStaffTypeByID()
ClassMethod GetCTStaffTypeByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		set rowid=plist.GetAt(i)
		set CTSInfo=$g(^CT("STAFF",rowid))
		set CTSObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTStaffType).%New()
		set CTSObj.CTSTCode=$P(CTSInfo,"^",1)
		set CTSObj.CTSTDesc=$P(CTSInfo,"^",2)
		set CTSFromDate=$P(CTSInfo,"^",3)	
		set CTSToDate=$P(CTSInfo,"^",4)
		set:CTSFromDate'="" CTSObj.CTSTStartDate=CTSFromDate
		set:CTSToDate'="" CTSObj.CTSTEndDate=CTSToDate	
		set CTSObj.CTSTCodesystemCode="CT_StaffType"
		set CTSObj.CTSTUpdateUserCode="无"
		set CTSObj.CTSTStatus="1"
		set hospId=$o(^CT("HOSP","0"))
		set hospCode=$p(^CT("HOSP",hospId),"^",1)	
		d ListInfo.CTStaffType.Insert(CTSObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTStaffType",.Jsonobj)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	s RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_StaffType",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：推送人员类型字典
/// Table：
/// Input： 
/// Return：人员类型字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStaffType).SendCTStaffType("")
ClassMethod SendCTStaffType(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^CT("STAFF",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>20 d
	..set Instream=..GetCTStaffTypeByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_StaffType",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..d plist.Clear()
	..s count=1
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTStaffTypeByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_StaffType",tSC)
	
	q "0" ;sc
Err
	q "-1^"_$ze
}

}
