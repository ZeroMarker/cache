Class web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv Extends (%RegisteredObject, %XML.Adaptor)
{

/// ODS根据ID导入字典
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：医护人员字典信息
/// Table：CT_CareProv
/// Input： 
/// Return：医护人员字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).GetCTCareProv("1").Read()
ClassMethod GetCTCareProv(Input As %String = "") As %GlobalCharacterStream
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
		set OutputStream=..GetCTCareProvByID(pList)
	}
	
	Quit OutputStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// 根据ID号列表取字典信息
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：医护人员字典信息
/// Table：CT_CareProv
/// Input： 
/// Return：医护人员字典信息集合
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).SendCTCareProv("")
ClassMethod SendCTCareProv(Input As %String) As %String
{
	set $Ztrap="Exception"
	set plist=##class(%ArrayOfDataTypes).%New()
	set Instream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%GlobalCharacterStream).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap).%New()
	set count=1
	set rowid="0"  for  set rowid=$o(^CTPCP(rowid)) Quit:rowid=""  d
	.do plist.SetAt(rowid,count)
	.set count=count+1
	
	.if count>0 do
	..set Instream=..GetCTCareProvByID(plist)
	..set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	..do tSC.OutputToDevice()
	..set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProv",tSC)
	..set count=1
	..do plist.Clear()
	
	set length=plist.Count()
	if length>0 d
	.set Instream=..GetCTCareProvByID(plist)
	.set tSC=soapObj.AcceptDicInfo("MES0001",Instream)
	.do tSC.OutputToDevice()
	.set sc=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ParseResponse("CT_CareProv",tSC)
	Quit tSC.Read()
Exception
	Quit -1_$ze
}

/// 根据ID号列表取字典信息
/// Creator：luofanyu
/// CreatDate：2018—10-30
/// Description：医护人员字典信息
/// Table：CT_CareProv
/// Input： 
/// Return：医护人员字典信息集合
ClassMethod GetCTCareProvByID(pList As %ArrayOfDataTypes) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set count=pList.Count()
	set ListInfo=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	for i=1:1:pList.Count()
	{
		set RowId=pList.GetAt(i)
		set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCareProv).%New()
		set insObj.businessrowid=RowId
		set insObj.CTCPCode=$p($g(^CTPCP(RowId,1)),"^",1)
		set insObj.CTCPJobNumber=insObj.CTCPCode
		set insObj.CTCPDesc=$p($g(^CTPCP(RowId,1)),"^",2)
		set insObj.CTCPName=$p($g(^CTPCP(RowId,1)),"^",2)
		set insObj.CTCPTitleOfTechCode=$p($g(^CTPCP(RowId,3)),"^",29)
		set insObj.CTCPCareProvTypeCode=$p($g(^CTPCP(RowId,1)),"^",4)
		set ctptpDr=$P($G(^CTPCP(RowId,1)),"^",4)
		if ctptpDr'=""  d  
		.set CTCPStaffType=$P($G(^CT("CPT",ctptpDr)),"^",4)
		.set:CTCPStaffType="DOCTOR" insObj.CTCPStaffType="医生"
		.set:CTCPStaffType="NURSE" insObj.CTCPStaffType="护士"
		.set:CTCPStaffType="Technician" insObj.CTCPStaffType="技术人员"
		.set:CTCPStaffType="Pharmacist" insObj.CTCPStaffType="药剂师"			

		set userRowId=$o(^SSU("SSUSR",0,"CTPCP",RowId,"")),userCode=""
		if userRowId'="" do
		.set insObj.CTCPStartDate=$p($g(^SSU("SSUSR",userRowId)),"^",96)
		
		.;set:startDate'="" insObj.CTCPStartDate=$zdt(startDate,3)
		.set insObj.CTCPEndDate=$p($g(^SSU("SSUSR",userRowId)),"^",97)
		.;set:endDate'="" insObj.CTCPEndDate=$zdt(endDate,3)	
		.set userCode=$P($G(^SSU("SSUSR",userRowId)),"^",1)
		.set freeText1=$P($G(^SSU("SSUSR",userRowId)),"^",122)
		.set insObj.CTCPIDCardNO=freeText1
		.set freeText2=$P($G(^SSU("SSUSR",userRowId)),"^",123)
		.set insObj.CTCPSexCode=freeText2
		.set logctlocDr=$P($G(^SSU("SSUSR",userRowId)),"^",4)
		.if logctlocDr'="" d
		..set logctlocCode=$p($g(^CTLOC(+logctlocDr)),"^",1)
		..set insObj.CTCPDeptCode=logctlocDr //logctlocCode	
		..;set insObj.CTCPDeptHierarchyCode=logctlocCode
		..set hospId=$p($g(^CTLOC(logctlocDr)),"^",22)
		..set:hospId="" hospId=$o(^CT("HOSP","0"))
		..set insObj.CTCPHosCode=hospId
		..set insObj.CTCPRemarks=logctlocCode
		.else  d
		..set hospId=$o(^CT("HOSP","0"))
		..set insObj.CTCPHosCode=hospId 
		else  do
		.set hospId=$o(^CT("HOSP","0"))
		.set insObj.CTCPHosCode=hospId
		
		set:insObj.CTCPStartDate="" insObj.CTCPStartDate=61360
		set insObj.CTCPCodesystemCode="CT_CareProv"
		set insObj.CTCPUpdateUserCode="无"
		set isActive=$p($g(^CTPCP(RowId,1)),"^",9)
		set:isActive="Y" insObj.CTCPStatus="1"
		set:isActive="N" insObj.CTCPStatus="0"
		set:insObj.CTCPEndDate'="" insObj.CTCPStatus="0"
		d ListInfo.CTCareProv.Insert(insObj)
	}
	d ListInfo.XMLExportToString(.String)
	set JsonStream=##class(%GlobalCharacterStream).%New()
	set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",String,"/ListInfo/CTCareProv",.Jsonobj)
		
	;set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.Common).ObjToJson(ListInfo,"")
	;do JsonStream.Write(JsonString)
	set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	set JsonString=$tr(JsonString,$c(13),"")
	set JsonString=$tr(JsonString,$c(10),"")
	set OutStream=##class(%GlobalCharacterStream).%New()
	set OutStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProv",JsonString)

	Quit OutStream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write($ze)
	Quit stream
}

/// Creator：zhengchenghou
/// CreatDate：2018-05-29
/// Description：查询HIS中医护人员字典信息
/// Table：CT_CareProv
/// Input： 
/// Return：医护人员字典
/// Others： w ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).CTCareProv("7060")
ClassMethod CTCareProv(input As %String) As %GlobalCharacterStream
{
	set $zt="MsgErr"
	set List=##class(web.DHCENS.STBLL.DICTNew.MODEL.ListInfo).%New()
	set RowId="0" f  set RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTCareProv).%New()
	.set insObj.CTCPCode=$p($g(^SSU("SSUSR",RowId)),"^",1)
	.set insObj.CTCPDesc=$p($g(^SSU("SSUSR",RowId)),"^",2)
	.set insObj.CTCPName=$p($g(^SSU("SSUSR",RowId)),"^",2)
	.set insObj.CTCPTitleOfTechCode=""
	.set logctlocDr=$P($G(^SSU("SSUSR",RowId)),"^",4)
	.if logctlocDr'="" d
	..set logctlocCode=$p($g(^CTLOC(+logctlocDr)),"^",1)
	..set insObj.CTCPDeptCode=logctlocCode	
	..set hospId=$p($g(^CTLOC(logctlocDr)),"^",22)
	..set:hospId="" hospId=$o(^CT("HOSP","0"))
	..set insObj.CTCPHosCode=hospId
	.else  d
	..set hospId=$o(^CT("HOSP","0"))
	..set insObj.CTCPHosCode=hospId
	.set ctpcpDr=$P($G(^SSU("SSUSR",RowId)),"^",14)
	.if ctpcpDr'="" d
	..set ctptpDr=$P($G(^CTPCP(ctpcpDr,1)),"^",4)
	..if ctptpDr'=""  d     //ct_carprvtp
	...set CTCPStaffType=$P($G(^CT("CPT",ctptpDr)),"^",4)
	...set:CTCPStaffType="DOCTOR" insObj.CTCPStaffType="医生"
	...set:CTCPStaffType="NURSE" insObj.CTCPStaffType="护士"
	...set:CTCPStaffType="Technician" insObj.CTCPStaffType="技术人员"
	...set:CTCPStaffType="Pharmacist" insObj.CTCPStaffType="药剂师"	
	...;set JobCode=$P($G(^CT("CPT",ctptpDr)),"^",2)
	...;set insObj.CTCPJobCode=JobCode
	.;set insObj.CTCPJobCode=""
	.set startDate=$p($g(^SSU("SSUSR",RowId)),"^",96)
	.set:startDate'="" insObj.CTCPStartDate=$zdt(startDate,3)
	.set endDate=$p($g(^SSU("SSUSR",RowId)),"^",97)
	.set:endDate'="" insObj.CTCPEndDate=$zdt(endDate,3)
	.set insObj.CTCPCodesystemCode="CT_CareProv"
	.set insObj.CTCPUpdateUserCode="无"
	.set insObj.CTCPStatus="1"
	.i ctpcpDr'=""  d
	..set insObj.CTCPRemarks=..GetDoctorDescription(ctpcpDr)
	..i insObj.CTCPRemarks'=""  d
	...;set insObj.CTCPExtranetURL="http://117.158.201.75:8081/alipay/image/doctors/"_insObj.CTCPCode_".jpg"
	...;set insObj.CTCPIntranetURL="http://172.19.91.36:8081/alipay/image/doctors/"_insObj.CTCPCode_".jpg"
	.;d List.CareProvList.Insert(insObj)
	.d List.CTCareProv.Insert(insObj)
	.;s count=List.CareProvList.Count()
	.s count=List.CTCareProv.Count()
	.if count>200 d
	..d List.XMLExportToString(.SS)
	..;set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",SS,"/ListInfo/CareProvList",.Jsonobj)
	..set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",SS,"/ListInfo/CTCareProv",.Jsonobj)
	..set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
	..set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProv",JsonString)
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	...d List.CTCareProv.Clear()
	..else  d
	...s success=0
	...d List.CTCareProv.Clear()
	if (count>0){
		d List.XMLExportToString(.SS)
		set JsonStream=##class(web.DHCENS.STBLL.UTIL.Common).XMLtoJSONPro("",SS,"/ListInfo/CTCareProv",.Jsonobj)
		set JsonString=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).JsonToBase64(JsonStream)
		set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).MainDataManager("CT_CareProv",JsonString)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.s success=-1
		else  d
		.set success=0
	}
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(success)
	Quit stream
MsgErr
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTCareProv).GetDoctorDescription(1653)
ClassMethod GetDoctorDescription(DoctorRowID As %String) As %String
{
	q:DoctorRowID="" ""
	s MHCDoctorRowID=$o(^MHC.Store.DoctorInfoI("doctorIdIndex"," "_DoctorRowID,""),-1)
	q:MHCDoctorRowID="" ""
	s DoctorDescription=$list($g(^MHC.Store.DoctorInfoD(MHCDoctorRowID)),7)
	s DoctorDescription=$replace(DoctorDescription,$c(31),"")
	q DoctorDescription
}

}
