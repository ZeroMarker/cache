Class web.DHCENS.STBLL.DICT.METHOD.CTCareProv Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2012-11-26
/// Description：查询HIS中医护人员字典信息
/// Table：SS_USER
/// Input： 
/// Return：医护人员字典
/// Others： w ##class(web.DHCENS.STBLL.DICT.METHOD.CTCareProv).CTCareProv("")
ClassMethod CTCareProv(input As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.DICT.MODEL.Request).%New()
	set body=##class(web.DHCENS.STBLL.DICT.MODEL.Body).%New()
	set soapObj=##class(web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap).%New()
	set success="0"
	set RowId="0" f  set RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""  d
	.Quit:((RowId'=input)&&(input'=""))
	.set insObj=##class(web.DHCENS.STBLL.DICT.MODEL.CTCareProv).%New()
	.set insObj.CTCPCode=$p($g(^SSU("SSUSR",RowId)),"^",1)
	.set insObj.CTCPDesc=$p($g(^SSU("SSUSR",RowId)),"^",2)
	.set insObj.CTCPName=$p($g(^SSU("SSUSR",RowId)),"^",2)
	.set logctlocDr=$P($G(^SSU("SSUSR",RowId)),"^",4)
	.if logctlocDr'="" d
	..set logctlocCode=$p($g(^CTLOC(+logctlocDr)),"^",1)
	..set insObj.CTCPDeptCode=logctlocCode	
	..set hospId=$p($g(^CTLOC(logctlocDr)),"^",22)
	..set:hospId="" hospId=$o(^CT("HOSP","0"))
	..set hospCode=$p(^CT("HOSP",hospId),"^",1)
	..set insObj.CTCPHosCode=hospCode
	.else  d
	..set hospId=$o(^CT("HOSP","0"))
	..set hospCode=$p(^CT("HOSP",hospId),"^",1)
	..set insObj.CTCPHosCode=hospCode
	.set ctpcpDr=$P($G(^SSU("SSUSR",RowId)),"^",14)
	.if ctpcpDr'="" d
	..set ctptpDr=$P($G(^CTPCP(ctpcpDr,1)),"^",4)
	..if ctptpDr'=""  d     //ct_carprvtp
	...set CTCPStaffType=$P($G(^CT("CPT",ctptpDr)),"^",4)
	...set:CTCPStaffType="DOCTOR" insObj.CTCPStaffType="医生"
	...set:CTCPStaffType="NURSE" insObj.CTCPStaffType="护士"
	...set:CTCPStaffType="Technician" insObj.CTCPStaffType="技术人员"
	...set:CTCPStaffType="Pharmacist" insObj.CTCPStaffType="药剂师"	
	...set JobCode=$P($G(^CT("CPT",ctptpDr)),"^",2)
	...set insObj.CTCPJobCode=JobCode
	.set insObj.CTCPJobCode=""
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
	...set insObj.CTCPExtranetURL="http://117.158.201.75:8081/alipay/image/doctors/"_insObj.CTCPCode_".jpg"
	...set insObj.CTCPIntranetURL="http://172.19.91.36:8081/alipay/image/doctors/"_insObj.CTCPCode_".jpg"
	.d body.careProvs.Insert(insObj)
	.Quit:input'=""
	.s count=body.careProvs.Count()
	.if count>200 d
	..set soapObj.Timeout="60"
	..set request.body=body
	..d request.XMLExportToStream(.stream)
	..set tSC=soapObj.SaveManagerDataInfo("CT_CareProv",stream)
	..set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
	..if resultCode'=0 d
	...s success=-1
	..d body.careProvs.Clear()
	
	if input'="" {
		set request.body=body
		d request.XMLExportToStream(.stream)
		Quit stream
	}
	if (count>0){
		set request.body=body
		d request.XMLExportToStream(.stream)
		set soapObj.Timeout="60"
	    set tSC=soapObj.SaveManagerDataInfo("CT_CareProv",stream)
		set resultCode=##class(web.DHCENS.STBLL.UTIL.Common).GetResultCode(tSC)
		if resultCode'=0 d
		.s success=-1
	}
	Quit success
Exception
	b ;$ze
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod SaveCTCareProv(Input As %GlobalCharacterStream) As %String
{
	
	s $zt="Exception"
	k ^LiyTemp("SaveCTCareProv")
	s RetState=1,RetString="<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	if $$$ISERR(tSC) {
		Quit "-1^格式错误："_tSC
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons","count(Person)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			for i=1:1:hsCount {	
				set (code,desc,locCode,locDr)=""
				s TargetObj=##class(User.CTCareProv).%New()
				// 人员姓名
				set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons/Person["_i_"]/CTSName","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set code=$tr(fieldValue,$c(0),"")
					s TargetObj.CTPCPDesc=$tr(fieldValue,$c(0),"")
				}
				// 人员代码
				set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons/Person["_i_"]/CTSJobNumber","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTPCPCode=$tr(fieldValue,$c(0),"")
				}
				// 人员所属科室Dr
				set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons/Person["_i_"]/CTSCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set locCode=$tr(fieldValue,$c(0),"")
					i locCode'="" s locDr=$o(^CTLOC(0,"Code",locCode,""))
					i +locDr'=0 d TargetObj.CTPCPCTLOCDRSetObjectId(locDr)
				}
				// 状态
				set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons/Person["_i_"]/CTSStatusCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTPCPActiveFlag=$tr(fieldValue,$c(0),"")
				}
				// 启用日期
				set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons/Person["_i_"]/CTSStartDate","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTPCPDateActiveFrom=$tr(fieldValue,$c(0),"")
				}
				// 停用日期
				set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons/Person["_i_"]/CTSEndDate","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					;set desc=$tr(fieldValue,$c(0),"")
					s TargetObj.CTPCPDateActiveTo=$tr(fieldValue,$c(0),"")
				}
				// 职称
				set tSC=tDocument.EvaluateExpression("/Request/Body/PersonRegisterRt/Persons/Person["_i_"]/Tp","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set desc=$tr(fieldValue,$c(0),"")
					i desc'="" s careProvTpDr=$o(^CT("CPT",0,"Desc",desc,""))
					i +careProvTpDr'=0 d TargetObj.CTPCPCarPrvTpDRSetObjectId(careProvTpDr)
				}
				s RetState=TargetObj.%Save()
				;d $system.Status.DisplayError(RetState)
				b ;beforeSave
				i RetState'=1 s ^LiyTemp("SaveCTCareProv",code)=RetState
			}
		}
	i RetState'=1 s RetString="<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败</ResultContent></Body></Response>"
	s ReturnStream=##class(%GlobalCharacterStream).%New()
	d ReturnStream.Write(RetString)
	q ReturnStream
Exception
	s RetString="<Response><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>"
	s ReturnStream=##class(%GlobalCharacterStream).%New()
	d ReturnStream.Write(RetString)
	q ReturnStream
		
	}
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

/// w ##class(web.DHCENS.STBLL.DICT.METHOD.CTCareProv).Test()
ClassMethod Test() As %String
{
	s aa=##class(%GlobalCharacterStream).%New()
	d aa.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><PersonRegisterRt><Persons><Person><CTSName>李岩测试2</CTSName><CTSJobNumber>A002</CTSJobNumber><CTSCode>1</CTSCode><CTSStatusCode></CTSStatusCode><CTSStartDate>63456</CTSStartDate><CTSEndDate></CTSEndDate><CTPCPCarPrvTp>副主任医师</CTPCPCarPrvTp></Person></Persons></PersonRegisterRt></Body></Request>")
	q ..SaveCTCareProv(aa)
}

}
