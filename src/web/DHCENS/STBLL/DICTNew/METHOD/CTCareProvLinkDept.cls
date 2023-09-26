Class web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvLinkDept Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: ZhangXinying
/// Description：查询HIS人员科室关联字典信息
/// Table：his无相关表
/// Input： 人员科室关联字典
/// Return： 人员科室关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvLinkDept).CTCareProvLinkDept("")
ClassMethod CTCareProvLinkDept(input As %String = "") As %GlobalCharacterStream
{
	s SuccessFlag=0
	s $zt="Exception"	
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s rowid=0 f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.q:((rowid'=input)&&(input'=""))
	.s oprInfo=$g(^SSU("SSUSR",rowid))
	.s oprObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvLinkDept).%New()
	.s deptDr=$p(oprInfo,"^",4)
	.s oprObj.CTCPLDLinkId=rowid_"||"_deptDr
	.s:deptDr'="" oprObj.CTCPLDDeptCode=$p(^CTLOC(deptDr),"^",1)
	.s oprObj.CTCPLDStaffCode=$p(oprInfo,"^",1)
	.s oprObj.CTCPLDDesc=$p(oprInfo,"^",2)
	.s oprObj.CTCPLDCodesystemCode="CT_CTCareProvLinkDept"
	.s oprObj.CTCPLDRemarks="无"
	.s oprObj.CTCPLDStatus="1"
	.s oprObj.CTCPLDUpdateUserCode=$p(oprInfo,"^",75)
	.s hospId=$o(^CT("HOSP","0"))
	.s hospCode=$p(^CT("HOSP",hospId),"^",1)	
	.s oprObj.CTCPLDHosCode=hospCode
	.s date=$p(oprInfo,"^",76)
	.s time=$p(oprInfo,"^",77)
	.s date1=$p(oprInfo,"^",96)
	.s date2=$p(oprInfo,"^",97) 
	.s:date'="" oprObj.CTCPLDUpdateDate=$zd(date,3)
	.s:time'="" oprObj.CTCPLDUpdateTime=$zt(time)
	.s:date1'="" oprObj.CTCPLDStartDate=$zd(date,3)
	.s:date2'="" oprObj.CTCPLDEndDate=$zd(date2,3)
	.d ListInfo.CTCareProvLinkDept.Insert(oprObj)	
	.Quit:input'=""
	.set Count=ListInfo.CTCareProvLinkDept.Count()
	..if Count>100 d
	...d ListInfo.XMLExportToString(.String)
	...set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCareProvLinkDept",.Jsonobj)
	...set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	...set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProvLinkDept",JsonString)
	...set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	...set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	...if resultCode=0 d
	....set success=0
	...else  d
	....set success=-1
	if count>0
	{
		d ListInfo.XMLExportToString(.String)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCareProvLinkDept",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set Instream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProvLinkDept",JsonString)
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

/// Creator: ZhangXinying
/// Description：查询HIS人员科室关联字典信息
/// Table：his无相关表
/// Input： 人员科室关联字典
/// Return： 人员科室关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvLinkDept).GetCTCareProvLinkDept("1").Read()
ClassMethod GetCTCareProvLinkDept(Input As %String = "") As %GlobalCharacterStream
{
	s SuccessFlag=0
	s $zt="Exception"	
	set OutputStream=##class(%GlobalCharacterStream).%New()
	set length=$l(Input,"^")
	set pList=##class(%ArrayOfDataTypes).%New()
	for i=1:1:length{
		set rowid=$p(Input,"^",i)
		do pList.SetAt(rowid,i)
	}
	if pList.Count()>0{
		set OutputStream=..GetCTCareProvLinkDeptByID(pList)
	}
	Quit OutputStream
		Quit RtnStream
	
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：通过Array集合返回人员科室关联密文流
/// Table：
/// Input： Array集合
/// Return：人员科室关联密文流获取
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoom).GetCTCareProvLinkDeptByID()
ClassMethod GetCTCareProvLinkDeptByID(plist As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	s $zt="Err"
	s count=plist.Count()
	s ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	f i=1:1:count
	{
		s rowid=plist.GetAt(i)
		s oprInfo=$g(^SSU("SSUSR",rowid))
		s oprObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvLinkDept).%New()
		s deptDr=$p(oprInfo,"^",4)
		s oprObj.businessrowid=rowid_"||"_deptDr
		s oprObj.CTCPLDLinkId=rowid_"||"_deptDr
		//s:deptDr'="" oprObj.CTCPLDDeptCode=$p(^CTLOC(deptDr),"^",1)
		s:deptDr'="" oprObj.CTCPLDDeptCode=deptDr
		//s oprObj.CTCPLDStaffCode=$p(oprInfo,"^",1)
		s oprObj.CTCPLDStaffCode=rowid
		s oprObj.CTCPLDDesc=$p(oprInfo,"^",2)
		s oprObj.CTCPLDCodesystemCode="CT_CTCareProvLinkDept"
		s oprObj.CTCPLDRemarks="无"
		s oprObj.CTCPLDStatus="1"
		s oprObj.CTCPLDUpdateUserCode=$p(oprInfo,"^",75)
		s hospId=$o(^CT("HOSP","0"))
		s hospCode=$p(^CT("HOSP",hospId),"^",1)	
		s oprObj.CTCPLDHosCode=hospCode
		s date=$p(oprInfo,"^",76)
		s time=$p(oprInfo,"^",77)
		s date1=$p(oprInfo,"^",96)
		s date2=$p(oprInfo,"^",97) 
		s:date'="" oprObj.CTCPLDUpdateDate=$zd(date,3)
		s:time'="" oprObj.CTCPLDUpdateTime=$zt(time)
		s:date1'="" oprObj.CTCPLDStartDate=$zd(date,3)
		s:date2'="" oprObj.CTCPLDEndDate=$zd(date2,3)
		d ListInfo.CTCareProvLinkDept.Insert(oprObj)	
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCareProvLinkDept",.Jsonobj)
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set RtnStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProvLinkDept",JsonString)
	Quit RtnStream
Err
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator: ZhangXinying
/// Description：查询HIS人员科室关联字典信息
/// Table：
/// Input： 
/// Return：HIS人员科室关联字典
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvLinkDept).SendCTCareProvLinkDept("")
ClassMethod SendCTCareProvLinkDept(input As %String = "") As %String
{
	s $zt="Err"
	s plist=##class(%ArrayOfDataTypes).%New()
	s Instream=##class(%GlobalCharacterStream).%New()
	s tSC=##class(%GlobalCharacterStream).%New()
	s soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	s count=1
	s rowid=0 f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.d plist.SetAt(rowid,count)
	.s count=count+1
	.if count>50 d
	..set Instream=..GetCTCareProvLinkDeptByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProvLinkDept",tSC)
	..d tSC.OutputToDevice()
	..d Instream.Clear()
	..s count=1
	..d plist.Clear()
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCareProvLinkDeptByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.d tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProvLinkDept",tSC)
	q sc
Err
	q "-1^"_$ze
}

}
