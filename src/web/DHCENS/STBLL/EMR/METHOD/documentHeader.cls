Class web.DHCENS.STBLL.EMR.METHOD.documentHeader Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.EMR.METHOD.documentHeader).documentHeader("1")
ClassMethod documentHeader(AdmNo As %String) As %GlobalCharacterStream
{
	set documentHeader=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.documentHeader).%New()
	set documentHeader.realmCode=""
	set documentHeader.typeId=""
	set documentHeader.template=""
	set documentHeader.id=""
	set documentHeader.title="检验报告"
	set effectiveTime=$tr($zd($h,3),"-","")_""_$tr($e($zt($p($h,",",2),1),1,8),":","")
	set documentHeader.effectiveTime=effectiveTime
	set confidentiality=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.confidentiality).%New()
	set confidentiality.content="级别名称"
	set confidentiality.code="级别代码"	
	set documentHeader.confidentiality=confidentiality
	set documentHeader.versionNumber=""
	set author=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.author).%New()
	set RARRowid=""
	set patRowId=$p($g(^PAADM(AdmNo)),"^",1)	
	
    	set DocRowID = $P($G(^PAADM(AdmNo)),"^",9) //"下医嘱医生"   
    
	if DocRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",DocRowID,""))
		set:userId'="" author.id=$p($g(^SSU("SSUSR",userId)),"^",1)
		set:userId'="" author.content=$p($g(^SSU("SSUSR",userId)),"^",2)
	}	
	set documentHeader.author=author
	set documentHeader.custodian=""
	set patient=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.patient).%New()
	set patient.medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set patient.admvisitNo=AdmNo
	set patient.medRecordNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set patient.healthCardNo="" 
	set certificate=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.certificate).%New()
	set certificatename=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.name).%New()
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
	set addr=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.addr).%New()
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
	set ethnicGroup=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.ethnicGroup).%New()
	set CountryRowID="",CountryDesc=""
	set CountryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	set:CountryRowID'="" CountryDesc=$p($g(^CT("COU",CountryRowID)),"^",2)
	set ethnicGroup.content=CountryDesc
	set:CountryRowID'="" ethnicGroup.code=$p($g(^CT("COU",CountryRowID)),"^",1)
	set patient.ethnicGroup=ethnicGroup
	set administrativeGender=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.administrativeGender).%New()
	set SexId=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if SexId'="" {
		set administrativeGender.code=$p($g(^CT("SEX",SexId)),"^",1)
		set administrativeGender.content=$p($g(^CT("SEX",SexId)),"^",2)	
		set patient.administrativeGender=administrativeGender
	}
	set maritalStatus=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.maritalStatus).%New()
	set MarryRowID=""
	set MarryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	set:MarryRowID'="" maritalStatus.content=$p($g(^CT("MAR",MarryRowID)),"^",2)
	set:MarryRowID'="" maritalStatus.code=$p($g(^CT("MAR",MarryRowID)),"^",1)
	set patient.maritalStatus=maritalStatus
	set age=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.age).%New()
	set BirthYear=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set age.unit="岁"
	set:BirthYear'="" age.value=$p($zd($p($h,",",1),3),"-",1)-$p($zd(BirthYear,3),"-",1)
	set patient.age=age
	set documentHeader.patient=patient
	set participant=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.participant).%New()
	set participant.name=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set participant.telecom=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	set code=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.code).%New()
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	set:LinkManRelationDR'="" code.code=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	set:LinkManRelationDR'="" code.content=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	set participant.code=code
	set participantAddr=##class(web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.addr).%New()
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
	d documentHeader.XMLExportToStream(.stream)
	Quit stream
}

}
