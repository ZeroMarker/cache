Class web.DHCENS.STBLL.LIS.METHOD.ReportResult Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod documentHeader(labno As %String) As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader
{
	set documentHeader=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set documentHeader.title="检验报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.author).%New()
	set RARRowid=""
	set ordRowId=$O(^OEORD(0,"EpisNo",labno,""))
    set AdmNo = $P($g(^OEORD(ordRowId)),"^",1)
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	set subId=$O(^OEORD(0,"EpisNo",labno,ordRowId,""))
	set ordstr1 = $g(^OEORD(ordRowId,"I",subId,1))
    set DocRowID = $P(ordstr1,"^",11) //"下医嘱医生"
	set author.id=$p($g(^CTPCP(DocRowID,1)),"^",1)
	set author.content=$p($g(^CTPCP(DocRowID,1)),"^",2) 
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.name).%New()
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
	set addr=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.addr).%New()
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
	set ethnicGroup=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.addr).%New()
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

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.ReportResult).LISReportResult("164||A020||1")
ClassMethod LISReportResult(reportId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set LabNo=+reportId
	if LabNo'=""  d
	.set clinicalDocument=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.clinicalDocument).%New()
	.set documentHeader=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader).%New()
	.set documentHeader=..documentHeader(LabNo)
	.set clinicalDocument.documentHeader=documentHeader
	.set ordRowId=$O(^OEORD(0,"EpisNo",LabNo,""))
    .set AdmNo = $P($g(^OEORD(ordRowId)),"^",1)
	.set patRowId=$p($g(^PAADM(AdmNo)),"^",1)
	.set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	.set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	.set structuredBody=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.structuredBody).%New()
	.set E0004desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0004desc.desc="姓名"
	.set E0004desc.content=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	.set structuredBody.E0004=E0004desc	
	.set E0002desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0002desc.desc="住院号"
	.set E0002desc.content=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg) 
	.set structuredBody.E0002=E0002desc
	.set E0000desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0000desc.desc="门诊号"
	.set E0000desc.content=$p($g(^PAPER(patRowId,"PAT",1)),"^",2)
	.set structuredBody.E0000=E0000desc	
	.set E0148desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set AdmTypeCode=$p($g(^PAADM(AdmNo)),"^",2)
	.set E0148desc.content=AdmTypeCode
	.set E0148desc.desc="病人类型代码"
	.set structuredBody.E0148=E0148desc	
	.set E0149desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0149desc.content=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿")
	.set E0149desc.desc="病人类型名称"
	.set structuredBody.E0149=E0149desc

	.if SexId'="" d
	..set E0005desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E0005desc.desc="性别代码"
	..set E0005desc.content=$p($g(^CT("SEX",SexId)),"^",1)
	..set structuredBody.E0005=E0005desc	
	..set E0006desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E0006desc.desc="性别描述"
	..set E0006desc.content=$p($g(^CT("SEX",SexId)),"^",2)
	..set structuredBody.E0006=E0006desc
	.set CurrentDetpRowID=$P($g(^PAADM(AdmNo)),"^",4)
	.set E0077desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set:CurrentDetpRowID'="" E0077desc.content=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	.set E0077desc.desc="科室"
	.set structuredBody.E0077=E0077desc	
	.set E0008desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set:BirthYear'="" E0008desc.content=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	.set E0008desc.desc="年龄"
	.set structuredBody.E0008=E0008desc
	.set E0075desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set CurrentBedNo=""
	.if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)  d
	..set BedWordRowID = $p(CurrentBedRowID,"||",1)
	..set BedChildSub = $p(CurrentBedRowID,"||",2)
	..if $d(^PAWARD(BedWordRowID,"BED"))=10  d
	...set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
	.set E0075desc.desc="病床"
	.set E0075desc.content=CurrentBedNo
	.set structuredBody.E0075=E0075desc
	
	.set E0150desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0150desc.content=""
	.set E0150desc.desc="费别代码"
	.set structuredBody.E0150=E0150desc
	.set E0151desc=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E0151desc.content=""
	.set E0151desc.desc="费别名称"
	.set structuredBody.E0151=E0151desc	
	.//取诊断信息
	.set AllDiagnoses=..GetDiagnoses(AdmNo)
	.set AllDiagnosesLen=$l(AllDiagnoses,"!")
	.for i=1:1:AllDiagnosesLen d
	..set AllDiagnose=$p($g(AllDiagnoses),"!",i)
	..if AllDiagnose'="" d
	...set S0048section=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0048).%New()
	...set S0048section.code="S0048"
	...set S0048section.desc="诊断"
	...set E07descDig=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E07descDig.desc="医生填写的诊断"
	...set E07descDig.content=$p($g(AllDiagnose),"^",2)
	...set S0048section.E07=E07descDig
	...set E01descDig=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E01descDig.content=$p($g(AllDiagnose),"^",5) 
	...set E01descDig.desc="诊断名称"
	...set S0048section.E01=E01descDig
	...set E02descDig=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	...set E02descDig.content=$p($g(AllDiagnose),"^",4)
	...set E02descDig.desc="诊断代码"
	...set S0048section.E02=E02descDig
	...d structuredBody.S0048.Insert(S0048section)
	.set S0061=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0061).%New()
	.set S0061.code="S0061"
	.set S0061.desc="检验记录"
	.set ReportDeptCode="",ReportDeptDesc="",labSpecCode="",labSpecName="",arcimCode=""
	.set arcimDesc="",veriTime="",veriDate="",OEORIEnterDocCode="",OEORIEnterDocDesc=""
	.set OEORDRowId=""  f  set OEORDRowId=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId)) q:OEORDRowId=""  d
	..set OEORIChildsub="" f  set OEORIChildsub=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...// 报告Id
	...set labRelatId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",35)
	...// 医嘱日期
	...set veriDate=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
	...set:veriDate'="" veriDate=$zd(veriDate,3)
	...// 医嘱ID
	...set OrdRowId=OEORDRowId_"||"_OEORIChildsub
	.../// 医嘱项Id  
	...set arcimRowId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...if arcimRowId'=""  d
	....set arcSub=+arcimRowId
	....set arcVer=$p(arcimRowId,"||",2)
	....set:arcimCode'="" arcimCode=arcimCode_","_$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	....set:arcimCode="" arcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	....set:arcimDesc'="" arcimDesc=arcimDesc_","_$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	....set:arcimDesc="" arcimDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	...set ReportDeptID=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...if ReportDeptID'=""  d
	....set ReportDeptCode=$p($g(^CTLOC(ReportDeptID)),"^",1)
	....set ReportDeptDesc=$p($g(^CTLOC(ReportDeptID)),"^",2)
	.../// 外部代码
    ...set arcExCode=..GetExCode(arcimRowId)
    .../// 检验标本代码、标本名称
	...set labSpecCode="",labSpecName=""		
	...if $d(^OEORD(OEORDRowId,"I",OEORIChildsub,"SPEC",1))'=0 d
	....set labSpecInfo=$g(^OEORD(OEORDRowId,"I",OEORIChildsub,"SPEC",1))
	....set labSpecCode=$p(labSpecInfo,"^",1)
	....set:labSpecCode'="" labSpecName=$p($g(^TTAB("SPEC",labSpecCode)),"\",1)
	...set docRowID = $P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",11)
	...if docRowID'="" d
	....set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
	....if userId'="" d
	.....set OEORIEnterDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	.....set OEORIEnterDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	
	.set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E01.desc="检验项目代码"
	.set E01.content=arcimCode
	.set S0061.E01=E01
	.set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E02.desc="检验项目名称"
	.set E02.content=arcimDesc
	.set S0061.E02=E02
	.set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E03.desc="送检日期"
	.set E03.content=veriDate
	.set S0061.E03=E03
	.set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E04.desc="送检时间"
	.set E04.content=veriTime
	.set S0061.E04=E04
	.set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E05.desc="标本类型代码"
	.set E05.content=labSpecCode
	.set S0061.E05=E05
	.set E06=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E06.desc="标本类型名称"
	.set E06.content=labSpecName
	.set S0061.E06=E06
	.set E07=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E07.desc="标本号"
	.set E07.content=LabNo
	.set S0061.E07=E07
	.set E08=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E08.desc="检验备注"
	.set E08.content=""
	.set S0061.E08=E08
	.set E09=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E09.desc="送检医生代码"
	.set E09.content=OEORIEnterDocCode
	.set S0061.E09=E09
	.set E10=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E10.desc="送检医生姓名"
	.set E10.content=OEORIEnterDocDesc
	.set S0061.E10=E10
	.set labRelatId=$tr(labRelatId,$c(0),"")
	.set labTSCode=$p(labRelatId,"||",2)
    .set labTSId=$p(labRelatId,"||",3)
	./// 采集日期、采集时间
	.set CollectDate="",CollectTime=""
	.Quit:$P(labRelatId,"||",1)=""
	.set TSData=$g(^TEPI($P(labRelatId,"||",1),1,labTSCode,labTSId))
	.Quit:TSData=""
	.set CollectDate=$P(TSData,"\",44)
	.set CollectTime=$P(TSData,"\",45)     
	.set:(CollectDate'="") CollectDate=$ZD(CollectDate,3) 
	.set:(CollectTime'="") CollectTime=$ZT(CollectTime,1)		
	./// 接收日期、接收时间  
	.Set ReceiveDate=$Piece(TSData,"\",21)  
	.Set:ReceiveDate'="" ReceiveDate=$ZD(ReceiveDate,3) 
	.Set ReceiveTime=$Piece(TSData,"\",22)  
	.Set:ReceiveTime'="" ReceiveTime=$ZT(ReceiveTime,1)  
	./// 接收者代码、接收者名称
	.set ReceiveUserName=""
	.Set ReceiveUserCode=$Piece(TSData,"\",36) 
 	.If $Length(ReceiveUserCode) d
 	..set ReceiveRowID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ReceiveUserCode),""))
 	..Set:ReceiveRowID'="" ReceiveUserName=$Piece($g(^SSU("SSUSR",ReceiveRowID)),"^",2) 
	./// 检验者代码、检验者名称 
  	.set authorUserCode=$p(TSData,"\",3)
  	.set authorUserName=""
 	.if (authorUserCode'="") d
 	..set authorRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(authorUserCode),""))
 	..Set:authorRowId'="" authorUserName=$Piece($g(^SSU("SSUSR",authorRowId)),"^",2) 	
    ./// 检验日期、检验时间  
	.set authorDate=$zd($p(TSData,"\",1),3)
	.set authorTime=$zt($p(TSData,"\",2)*60)	
	.set E11=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E11.desc="检验日期"
	.set E11.content=authorDate
	.set S0061.E11=E11
	.set E12=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E12.desc="检验时间"
	.set E12.content=authorTime
	.set S0061.E12=E12
	.set E13=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E13.desc="检验者代码"
	.set E13.content=authorUserCode
	.set S0061.E13=E13
	.set E14=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E14.desc="检验者姓名"
	.set E14.content=authorUserName
	.set S0061.E14=E14	
	./// 审核日期、审核时间  
	.Set CheckDate=$Piece(TSData,"\",4)  
	.Set:$Length(CheckDate) CheckDate=$ZD(CheckDate,3) 
	.Set CheckTime=$Piece(TSData,"\",5)  
	.Set:$Length(CheckTime) CheckTime=$ZT(CheckTime,1)  
	./// 审核者代码、审核者名称
	.Set CheckUserCode=$Piece(TSData,"\",6)
	.Set CheckUserName=""
	.If $Length(CheckUserCode) d
 	..set CheckRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CheckUserCode),""))
	..Set:CheckRowId'="" CheckUserName=$Piece($g(^SSU("SSUSR",CheckRowId)),"^",2) 
	.set E17=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E17.desc="审核报告日期"
	.set E17.content=CheckDate
	.set S0061.E17=E17
	.set E18=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E18.desc="审核报告时间"
	.set E18.content=CheckTime
	.set S0061.E18=E18
	.set E19=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E19.desc="审核者代码"
	.set E19.content=CheckUserCode
	.set S0061.E19=E19
	.set E20=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E20.desc="审核者姓名"
	.set E20.content=CheckUserName
	.set S0061.E20=E20
	./// 报告发布日期 
	.set reportDate=$P(TSData,"\",4)
	.set:reportDate'="" reportDate=$ZD(reportDate,3)
	./// 报告发布时间
	.set reportTime=$P(TSData,"\",5)
	.set:reportTime'="" reportTime=$ZT(reportTime)	
	./// 报告医生
	.set reportUserCode=$P(TSData,"\",6)
	.set reportUserName=""
	.if (reportUserCode'="") d
 	..set reportUserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(reportUserCode),""))
	..set:reportUserRowId'="" reportUserName=$p($g(^SSU("SSUSR",reportUserRowId)),"^",2)
	.set E15=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E15.desc="报告日期"
	.set E15.content=reportDate
	.set S0061.E15=E15
	.set E16=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E16.desc="报告时间"
	.set E16.content=reportTime
	.set S0061.E16=E16		
	.// 仪器代码、仪器名称 
	.Set MachineCode=$Piece(^TEPI(LabNo,1,labTSCode,labTSId),"\",27)  
	.set MachineName=""
	.If $Length(MachineCode) Set MachineName=$Piece($g(^TMIF(MachineCode)),"\",1)  
    ./// 打印标记
	.set printflag=$p(TSData,"\",28) 
	.set E21=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E21.desc="报告备注"
	.set E21.content=""
	.set S0061.E21=E21
	.set E22=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E22.desc="检验目的"
	.set E22.content=""
	.set S0061.E22=E22
	.set E23=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E23.desc="检验结果"
	.set E23.content=""
	.set S0061.E23=E23
	.set E24=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E24.desc="报告号"
	.set E24.content=reportId
	.set S0061.E24=E24
	.set E25=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E25.desc="医嘱号"
	.set E25.content=""
	.set S0061.E25=E25
	.if reportDate'=""  d
	..set tSC=..LISItemResult(reportId,.S0061)
	..if tSC=1 d
	...set structuredBody.S0061=S0061
	.set clinicalDocument.structuredBody=structuredBody
	.d clinicalDocument.XMLExportToStream(.stream)
	set file=##class(%FileCharacterStream).%New()
	set file.TranslateTable="UTF8"
	set file.Filename="D:\aa.xml"
	d file.CopyFrom(stream)
	set sc=file.%Save()
	b ;5
	Quit stream
Exception
	Quit "-1^"_$ze
}

ClassMethod GetExCode(ArcimRowid As %String) As %String
{
	set arcsub=$p(ArcimRowid,"||",2)
	Quit:arcsub="" ""
	set ExCode=""
	set chl="" for  set chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
	.set tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
	.set fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
	.Quit:(fromd'="")&(fromd>+$h)
	.Quit:(tod'="")&(tod<+$h)
	.set ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",4)
	Quit ExCode
}

ClassMethod LISItemResult(reportId As %String, Output S0061 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0061) As %String
{
	set $zt="Exception"		
	set labNo=+reportId
	set labTSCode=$p(reportId,"||",2)
	set labTSId=$p(reportId,"||",3)
	set itemCode="" for  set itemCode=$O(^TEPI(labNo,"1",labTSCode,labTSId,"DATA",itemCode)) q:itemCode=""  d
	.set resultStr=$G(^TEPI(labNo,"1",labTSCode,labTSId,"DATA",itemCode))
	.// 序号
	.set serialNo=$P(resultStr,"\",9)
	.// 结果	
	.set resultValue=$P(resultStr,"\",1)
	.set result=""
  	./// 检验方法名称
  	.set TestMethodDesc=""
  	.set TestMethodDr=$p(^TTAB("TC",itemCode),"\",11)
  	.set:TestMethodDr'="" TestMethodDesc=$p(^TTAB("METHOD",TestMethodDr),"\",1)  	
	.//判断是否有药敏结果
	.set AntResFlag=0
	.if $d(^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"ANT")) set AntResFlag=1		

	.set receiveDate=$P($G(^TEPI(labNo,1,labTSCode,labTSId)),"\",21)
	.set resultStr=##Class(web.DHCLabTestCode).GetTestCodeResult(labNo,itemCode,resultValue,receiveDate)
	.Quit:resultStr=""
 	./// 检验结果项目描述
 	.set itemDesc=$P(resultStr,$C(2),2)
 	./// 缩写
 	.set abbreviation=$P(resultStr,$C(2),7)
 	./// 结果值
 	.set resultValue=$P(resultStr,$C(2),3)
 	./// 单位
 	.set unit=$P(resultStr,$C(2),4)
 	./// 高低标识
 	.set flagUpDown=$P(resultStr,$C(2),5)
 	./// 正常范围
 	.set naturalRange=$P(resultStr,$C(2),6)
 	.set warnFlag=$P(resultStr,$C(2),8) 		
 	.if $d(^TTAB("TC",itemCode,1,labTSCode)) d
 	..set itemOrder=$p($g(^TTAB("TC",itemCode,1,labTSCode)),"\",1)
 	..Quit:itemOrder=""
 	..set layOrder=$p($g(^TTAB("TC",itemCode,1,labTSCode)),"\",2)
 	..Quit:layOrder=""
  	..Quit:$G(^TTAB("TS",labTSCode,layOrder,itemOrder))=""  	
  	../// 检验结果项目序号
 	..set serialNo=$p(^TTAB("TS",labTSCode,layOrder,itemOrder),"\",15) 
	.if AntResFlag=1 d
	..set S0063=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0063).%New()
	..set S0063.code="S0063"
	..set S0063.desc="微生物培养生成细菌信息"
	..set S0063.text=""
	..set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E01.desc="细菌代码"
	..set E01.content=itemCode
	..set S0063.E01=E01
	..set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E02.desc="细菌名称"
	..set E02.content=resultValue
	..set S0063.E02=E02
	..set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E03.desc="细菌计数"
	..set E03.content=""
	..set S0063.E03=E03
	..set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E04.desc="专家规则"
	..set E04.content=""
	..set S0063.E04=E04
	..set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E05.desc="备注"
	..set E05.content=""
	..set S0063.E05=E05
	..set tSC=..LISItemSenResult(reportId,itemCode,.S0063)
	..if tSC=1 d
	...d S0061.S0063.Insert(S0063)
	.else  d
	..set S0062=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0062).%New()
	..set S0062.code="S0062"
	..set S0062.desc="检验子项结果"
	..set S0062.text=""
	..set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E01.desc="检验子项代码"
	..set E01.content=itemCode
	..set S0062.E01=E01
	..set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E02.desc="检验子项名称"
	..set E02.content=itemDesc
	..set S0062.E02=E02
	..set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E03.desc="检验子项结果（定量）"
	..set E03.content=""
	..set S0062.E03=E03
	..set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E04.desc="检验子项结果单位"
	..set E04.content=unit
	..set S0062.E04=E04
	..set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E05.desc="检验子项结果（定性，阴/阳）"
	..set E05.content=resultValue
	..set S0062.E05=E05
	..set E06=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E06.desc="检验子项参考值范围"
	..set E06.content=naturalRange
	..set S0062.E06=E06
	..set E07=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	..set E07.desc="检验子项异常标志"
	..set E07.content=flagUpDown
	..set S0062.E07=E07
	..d S0061.S0062.Insert(S0062)
	Quit 1
Exception
	Quit "-1^"_$ze
}

ClassMethod LISItemSenResult(reportId As %String, itemCode As %String, Output S0063 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0063) As %String
{
	set $zt="Exception"	
	set labNo=+reportId
	set labTSCode=$p(reportId,"||",2)
	set labTSId=$p(reportId,"||",3)
	set ant="" f  s ant=$o(^TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"ANT",ant)) q:ant=""  d
	.s temstr=^(ant)
	.// 抗生素名称
	.if $d(^TTAB("ANT",ant)) set antname=$p(^TTAB("ANT",ant),"\",1)
	.set antEname=""
	.// 英文名称
	.if $d(^DHCANTIBIOTICS(ant)) set antEname=$p(^DHCANTIBIOTICS(ant),"\",1)
	.if $l(antEname) s antname=antname_"("_antEname_")"
	.set AntClass=""
	.if $d(^DHCPharmicCategoryi("ANT",ant)) d
	..set AntClass=$o(^DHCPharmicCategoryi("ANT",ant,AntClass))
  	.if AntClass'="" d
  	..set AntClssName=$p(^DHCPharmicCategory(AntClass),"\",1)
  	..set ClsSeq=$p(^DHCPharmicCategory(AntClass),"\",3)
  	.else  d
  	..set AntClass="ZOTHERS"
  	..set AntClssName="其它"
  	.// 结果
	.set temresCode=$p(temstr,"\",1) 
	.// 激活标志
	.set temreport=$p(temstr,"\",2)  
	.// mic结果
	.set temmic=$p(temstr,"\",3)   
	.if $e(temmic,1)="." set temmic="0"_temmic
	.// mm结果等同于KB
	.set temmm=$p(temstr,"\",4)  
	.if $e(temmm,1)="." set temmm="0"_temmm
	.set temresDesc=""
	.if temresCode="R" set temresDesc="耐药" 
	.if temresCode="S" set temresDesc="敏感" 
	.if temresCode="I" set temresDesc="中介"   
	.set S0064=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0064).%New()
	.set S0064.code="S0064"
	.set S0064.desc="细菌的药敏信息"
	.set S0064.text=""
	.set E01=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E01.desc="抗生素代码"
	.set E01.content=ant
	.set S0064.E01=E01
	.set E02=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E02.desc="抗生素名称"
	.set E02.content=antname
	.set S0064.E02=E02
	.set E03=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E03.desc="最低抑菌浓度"
	.set E03.content=""
	.set S0064.E03=E03
	.set E04=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E04.desc="药敏结果代码"
	.set E04.content=temresCode
	.set S0064.E04=E04
	.set E05=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E05.desc="药敏结果描述"
	.set E05.content=temresDesc
	.set S0064.E05=E05
	.set E06=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E06.desc="建议"
	.set E06.content=""
	.set S0064.E06=E06
	.set E07=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E07.desc="药敏结果标志"
	.set E07.content=""
	.set S0064.E07=E07
	.set E08=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E08.desc="I折点范围"
	.set E08.content=""
	.set S0064.E08=E08
	.set E09=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E09.desc="S折点范围"
	.set E09.content=""
	.set S0064.E09=E09
	.set E10=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E10.desc="R折点范围"
	.set E10.content=""
	.set S0064.E10=E10
	.set E11=##class(web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc).%New()
	.set E11.desc="试验方法"
	.set E11.content=""
	.set S0064.E11=E11
	.d S0063.S0064.Insert(S0064)	
	Quit 1
Exception
	Quit "-1^"_$ze
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
