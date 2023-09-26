Class web.DHCENS.STBLL.RIS.METHOD.ReportResult Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod documentHeader(StudyNo As %String) As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader
{
	set documentHeader=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set documentHeader.title="检查报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.author).%New()
	set RARRowid=""
	set RARRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,""))
	set AdmNo=$p(^DHCPACRegInfo(RARRowid),"^",10) //"就诊号"
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set RAROEORIDR=$p(^DHCPACRegInfo(RARRowid),"^",11)
	set ordstr1 = $g(^OEORD($p(RAROEORIDR,"||",1),"I",$p(RAROEORIDR,"||",2),1))
    set DocRowID = $P(ordstr1,"^",11) //"下医嘱医生"
	set author.id=$p($g(^CTPCP(DocRowID,1)),"^",1)
	set author.content=$p($g(^CTPCP(DocRowID,1)),"^",2) 
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.name).%New()
	set PatRowID=$P($g(^PAADM(AdmNo)),"^",1)
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7)
	set CredentialNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if ((CredentialTypeRowID'="")&&(CredentialNum'="")) {
		set certificatename.code=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
		set certificatename.content=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2) 
		set certificate.value=CredentialNum
	}
	else {
		set certificatename.code=""
		set certificatename.content=""
		set certificate.value=CredentialNum
	}
	set certificate.name=certificatename
	set patient.certificate=certificate
	set addr=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr).%New()
	set addr.text=$g(^PAPER(patRowId,"PER","ADD",1))
	set addr.desc="现住址"
	set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	set ProvinceDesc=""
	if ProvinceRowID'="" d
	.set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	.set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	if CityCodeRowID'="" d
	.set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	.set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	if CityAreaRowID'="" d
	.set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	.set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	set addr.houseNumber=""
	set addr.streetName=""
	set addr.township=""
	set addr.county=CityAreaDesc
	set addr.city=CityCodeDesc
	set addr.state=ProvinceDesc
	set WorkPostCodeDR=$o(^DHCPERSON(0,"PAPERSON",patRowId,""))
	set:WorkPostCodeDR'="" addr.postalCode=$p($g(^DHCPERSON(WorkPostCodeDR)),"^",8)
	set patient.addr=addr
	set patient.name=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set patient.telecom=$p($g(^PAPER(patRowId,"PER",4)),"^",21)
	set ethnicGroup=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr).%New()
	set participantAddr.desc="联系人地址"
	set participantAddr.text=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	set participantAddr.houseNumber=""
	set participantAddr.streetName=""
	set participantAddr.township=""
	set participantAddr.county=""
	set participantAddr.city=""
	set participantAddr.state=""
	set participantAddr.postalCode=""
	set participant.addr=participantAddr
	set documentHeader.participant=participant
	Quit documentHeader
}

/// Creator：WuXianPu
/// CreatDate：2016-10-31
/// Description：获取HIS系统检查报告信息
/// Table：DHCRB_Report
/// Input： 检查号
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.RIS.METHOD.ReportResult).GetReportInfo("US20160622001")
ClassMethod GetReportInfo(StudyNo As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set clinicalDocument=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.clinicalDocument).%New()
	set documentHeader=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader=..documentHeader(StudyNo)
	set clinicalDocument.documentHeader=documentHeader
	set RARRowid=""
	set RARRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RARRowid))
	set AdmNo=$p(^DHCPACRegInfo(RARRowid),"^",10) //"就诊号"
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set structuredBody=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.structuredBody).%New()
	set E0004desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0004desc.desc="姓名"
	set E0004desc.content=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set structuredBody.E0004=E0004desc
	if SexId'="" {
		set E0005desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
		set E0005desc.desc="性别代码"
		set E0005desc.content=$p($g(^CT("SEX",SexId)),"^",1)
		set structuredBody.E0005=E0005desc	
		set E0006desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
		set E0006desc.desc="性别描述"
		set E0006desc.content=$p($g(^CT("SEX",SexId)),"^",2)
		set structuredBody.E0006=E0006desc	
	}
	set E0008desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set:BirthYear'="" E0008desc.content=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set E0008desc.desc="年龄"
	set structuredBody.E0008=E0008desc	
	set E0148desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set AdmTypeCode=$p($g(^PAADM(AdmNo)),"^",2)
	set E0148desc.content=AdmTypeCode
	set E0148desc.desc="病人类型代码"
	set structuredBody.E0148=E0148desc	
	set E0149desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0149desc.content=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿")
	set E0149desc.desc="病人类型名称"
	set structuredBody.E0149=E0149desc
	set E0156desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentDetpRowID=$P($g(^PAADM(AdmNo)),"^",4)
	set:CurrentDetpRowID'="" E0156desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	set E0156desc.desc="科室id"
	set structuredBody.E0156=E0156desc
	set E0077desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set:CurrentDetpRowID'="" E0077desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	set E0077desc.desc="科室"
	set structuredBody.E0077=E0077desc
	set E0002desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0002desc.desc="住院号"
	set E0002desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg) 
	set structuredBody.E0002=E0002desc
	set E0000desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E0000desc.desc="门诊号"
	set E0000desc.content=$p($g(^PAPER(patRowId,"PAT",1)),"^",2)
	set structuredBody.E0000=E0000desc
	set E0154desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedRowID=$P($g(^PAADM(AdmNo)),"^",73)
	set E0154desc.content=CurrentBedRowID
	set E0154desc.desc="病床id"
	set structuredBody.E0154=E0154desc	
	set E0075desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set CurrentBedNo=""
	if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)  d
	.set BedWordRowID = $p(CurrentBedRowID,"||",1)
	.set BedChildSub = $p(CurrentBedRowID,"||",2)
	.if $d(^PAWARD(BedWordRowID,"BED"))=10  d
	..set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
	set E0075desc.desc="病床"
	set E0075desc.content=CurrentBedNo
	set structuredBody.E0075=E0075desc
	//取诊断信息
	set AllDiagnoses=..GetDiagnoses(AdmNo)
	set AllDiagnosesLen=$l(AllDiagnoses,"!")
	for i=1:1:AllDiagnosesLen {
		set AllDiagnose=$p($g(AllDiagnoses),"!",i)
		if AllDiagnose'="" {
			set S0048section=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0048).%New()
			set S0048section.code="S0048"
			set S0048section.desc="诊断"
			set E07descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E07descDig.desc="医生填写的诊断"
			set E07descDig.content=$p($g(AllDiagnose),"^",2)
			set S0048section.E07=E07descDig
			set E01descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E01descDig.content=$p($g(AllDiagnose),"^",5) 
			set E01descDig.desc="诊断名称"
			set S0048section.E01=E01descDig
			set E02descDig=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
			set E02descDig.content=$p($g(AllDiagnose),"^",4)
			set E02descDig.desc="诊断代码"
			set S0048section.E02=E02descDig
			d structuredBody.S0048.Insert(S0048section)
		}
	}
	set S0076section=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0076).%New()
	set S0076section.code="S0076"
	set S0076section.desc="检查记录" 
	set E01desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E01desc.desc="检查号"
	set E01desc.content=StudyNo
	set S0076section.E01=E01desc
	set E02desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E02desc.desc="检查设备编码"
	set S0076section.E02=E02desc
	set E03desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E03desc.desc="检查设备名称"
	set S0076section.E03=E03desc
	set E04desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set regId=""
	set regId=$o(^DHCPACRegInfoi("StudyNo",StudyNo,regId))
	
	set RISRPositionCode="",RISRPositionDesc=""
	set childId="" for  set childId=$o(^DHCPACRegInfoBD("BODYPARTS",0,regId,childId)) q:childId=""  d
	.// User.DHCAppPart 检查部位字典表
	.set bodyPartInfo=$g(^DHCPACRegInfoBD("BODYPARTS",0,regId,childId))
	.set:RISRPositionCode'="" RISRPositionCode=RISRPositionCode_","_$p(bodyPartInfo,"^",2)
	.set:RISRPositionCode="" RISRPositionCode=$p(bodyPartInfo,"^",2)
	.set:RISRPositionDesc'="" RISRPositionDesc=RISRPositionDesc_","_$p(bodyPartInfo,"^",3)
	.set:RISRPositionDesc="" RISRPositionDesc=$p(bodyPartInfo,"^",3)
	set E04desc.desc="检查部位代码"
	set E04desc.content=RISRPositionCode
	set S0076section.E04=E04desc
	set E05desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E05desc.desc="检查部位名称"
	set E05desc.content=RISRPositionDesc
	set S0076section.E05=E05desc
	set E06desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E06desc.desc="检查部位医生手写"
	set S0076section.E06=E06desc
	set E07desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E07desc.desc="检查部位"
	set E07desc.content=RISRPositionDesc
	set S0076section.E07=E07desc
	set E08desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set DRPTRowID=0 
	set DRPTRowID=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,DRPTRowID))
	set E08desc.desc="检查所见"
	set E08desc.content=^DHCRBStudy("Report",DRPTRowID,"ExamDescEx")
	set S0076section.E08=E08desc
	set E09desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E09desc.desc="检查结果"
	set E09desc.content=^DHCRBStudy("Report",DRPTRowID,"ResultDescEx")
	set S0076section.E09=E09desc
	set E10desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportDocDR=$p(^DHCRBStudy("Report",DRPTRowID),"^",8)
	set (ReportDocCode,ReportDocName)=""
	If $Length(ReportDocDR) d
 	.set ReportDocCode=$Piece($g(^SSU("SSUSR",ReportDocDR)),"^",1) 
	.Set ReportDocName=$Piece($g(^SSU("SSUSR",ReportDocDR)),"^",2)
	set E10desc.desc="检查医师代码"
	set E10desc.content=ReportDocCode
	set S0076section.E10=E10desc
	set E11desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E11desc.content=ReportDocName
	set E11desc.desc="检查医师姓名"
	set S0076section.E11=E11desc
	set E12desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set VerifyDocDR=$p(^DHCRBStudy("Report",DRPTRowID),"^",11)
	set (VerifyDocCode,VerifyDocName)=""
	If $Length(VerifyDocDR) d
 	.set VerifyDocCode=$Piece($g(^SSU("SSUSR",VerifyDocDR)),"^",1) 
	.Set VerifyDocName=$Piece($g(^SSU("SSUSR",VerifyDocDR)),"^",2)
	set E12desc.desc="审核医师代码"
	set E12desc.content=VerifyDocCode
	set S0076section.E12=E12desc
	set E13desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E13desc.content=VerifyDocName
	set E13desc.desc="审核医师姓名"
	set S0076section.E13=E13desc
	set E14desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
 	set WriteDocDR=$p(^DHCRBStudy("Report",DRPTRowID),"^",26)
	set (WriteDocCode,WriteDocName)=""
	If $Length(WriteDocDR) d
 	.set WriteDocCode=$Piece($g(^SSU("SSUSR",VerifyDocDR)),"^",1) 
	.Set WriteDocName=$Piece($g(^SSU("SSUSR",VerifyDocDR)),"^",2)
	set E14desc.content=WriteDocCode
	set E14desc.desc="记录者代码"
	set S0076section.E14=E14desc
	set E15desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E15desc.desc="记录者姓名"
	set E15desc.content=WriteDocName
	set S0076section.E15=E15desc
	set E16desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportDate=$p(^DHCRBStudy("Report",DRPTRowID),"^",9)
	set:ReportDate'="" ReportDate= $ZD(ReportDate,3)
	set E16desc.desc="检查日期"
	set E16desc.content=ReportDate
	set S0076section.E16=E16desc
	set E17desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set ReportTime=$p(^DHCRBStudy("Report",DRPTRowID),"^",10)
	set:ReportTime'="" ReportTime= $ZT(ReportTime,1)	
	set E17desc.desc="检查时间"	
	set E17desc.content=ReportTime
	set S0076section.E17=E17desc
	set E18desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E18desc.content=$p(^DHCRBStudy("Report",DRPTRowID),"^",1)
	set E18desc.desc="报告号"
	set S0076section.E18=E18desc
	set E19desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set VerifyDate=$p(^DHCRBStudy("Report",DRPTRowID),"^",12)
	set:VerifyDate'="" VerifyDate= $ZD(VerifyDate,3)
	set E19desc.content=VerifyDate
	set E19desc.desc="审核日期"
	set S0076section.E19=E19desc
	set E20desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set VerifyTime=$p(^DHCRBStudy("Report",DRPTRowID),"^",13)
	set:VerifyTime'="" VerifyTime= $ZT(VerifyTime,1)
	set E20desc.desc="审核时间"
	set E20desc.content=VerifyTime
	set S0076section.E20=E20desc
	set E21desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set OeordItmDR = $p(^DHCRBStudy("Report",DRPTRowID),"^",15)
    set OeordRowid = $p(OeordItmDR,"||",1)
    set OeordSub = $p(OeordItmDR,"||",2)
    set OEORIItmMastDR = $p(^OEORD(OeordRowid,"I",OeordSub,1),"^",2)
	set E21desc.desc="检查项目描述"
	set E21desc.content=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2) 
	set S0076section.E21=E21desc
	set E22desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E22desc.content=$p(^DHCRBStudy("Report",DRPTRowID),"^",24)
	set E22desc.desc="检查方法描述"
	set S0076section.E22=E22desc
	set E23desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E23desc.desc="报告日期"
	set E23desc.content=ReportDate
	set S0076section.E23=E23desc
	set E24desc=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc).%New()
	set E24desc.desc="报告时间"
	set E24desc.content=ReportTime
	set S0076section.E24=E24desc
	set structuredBody.S0076=S0076section
	set clinicalDocument.structuredBody=structuredBody
	d clinicalDocument.XMLExportToStream(.stream)
	
	set file=##class(%FileCharacterStream).%New()
	set file.TranslateTable="UTF8"
	set file.Filename="D:\aa.xml"
	d file.CopyFrom(stream)
	set sc=file.%Save()
	Quit stream
Exception
	b ;6
	set clinicalDocument=##class(web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.clinicalDocument).%New()
	d clinicalDocument.XMLExportToStream(.stream)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.RIS.METHOD.ReportResult).GetDiagnoses("394")
/// Desc:	所有诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述!诊断类型代码^诊断类型描述^RowId^诊断代码^诊断描述
ClassMethod GetDiagnoses(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s DiagnoseStatusDr="",DiagnoseStatus=""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		if (mrdiachildsub'=0) {
		    s admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
		    q:admDiagTypeId=""
	        s admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	        s admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
		    s themrdiachildsub = mrdiachildsub
		    s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
	        if (mricdid="") {
		        set mricdCode=""
		        set mricdDesc=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
		        //liyan 20150616
		        s DiagnoseStatusDr=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",9)
		        i DiagnoseStatusDr'="" s DiagnoseStatus=$p($g(^MRC("DSTAT",DiagnoseStatusDr)),"^",2)

		    }
		    else{
		        s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
		        s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
		        //liyan 20150616
		        s DiagnoseStatusDr=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",9)
		        i DiagnoseStatusDr'="" s DiagnoseStatus=$p($g(^MRC("DSTAT",DiagnoseStatusDr)),"^",2)
		    }
		    if (retValue = "") {	
		    	set retValue = admDiagTypeCode_"^"_admDiagTypeDesc_"^"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_DiagnoseStatus
		    }
		    else {	
		    	s retValue = admDiagTypeCode_"^"_admDiagTypeDesc_"^"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_DiagnoseStatus_"!"_retValue
		    }
		}
	}
	q retValue
}

}
