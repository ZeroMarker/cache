Class web.DHCENS.STBLL.EMPI.METHOD.Patient Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：Duanhaihua
/// CreatDate：2016—05-31
/// Description：根据患者登记号获取患者基本信息
/// Table：
/// Input：patRowId：患者登记号
/// Output：
/// Return：患者基本信息消息流
/// w ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPATINFO","6413230")
/// Others：s st= ##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatient("1")
ClassMethod PAPatient(patRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$H)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatient).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	if (patRowId="")||($d(^PAPER(patRowId))=0) {
		do body.paPatients.Insert(Obj)
		set request.body=body
		do request.XMLExportToStream(.stream)
		quit stream
	}
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set Obj.PATName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if sexRowID'="" {
		set sexCode=$p($g(^CT("SEX",sexRowID)),"^",1)
		set sexDesc=$p($g(^CT("SEX",sexRowID)),"^",2)
		set Obj.PATSexCode=sexCode
		set Obj.PATSexDesc=sexDesc
	}
	set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set:birthDay="" birthDay=1846
	set:birthDay'="" Obj.PATDob=$zd(birthDay,3)		
	set PAPATTelephone=$P($g(^PAPER(patRowId,"PER",1)),"^",11)
	set Obj.PATTelephone=$e(PAPATTelephone,1,11)
	set occupationRowID="",OccupationDesc="",OccupationCode=""
	set occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
	if occupationRowID'="" {
		set OccupationCode=$p($g(^CT("OCC",occupationRowID)),"^",1)
		set OccupationDesc=$p($g(^CT("OCC",occupationRowID)),"^",2)
		set Obj.PATOccupationCode=OccupationCode
		set Obj.PATOccupationDesc=OccupationDesc
	}
	set Obj.PATDocumentNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	set:Obj.PATDocumentNo="" Obj.PATDocumentNo=$p($g(^PAPER(patRowId,"PAT",1)),"^",22) 
	set marryRowID="",marryCode="",marryDesc=""
	set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	if marryRowID'="" {
		set marryCode=$p($g(^CT("MAR",marryRowID)),"^",1)
		set marryDesc=$p($g(^CT("MAR",marryRowID)),"^",2)
		set Obj.PATMaritalStatusCode=marryCode
		set Obj.PATMaritalStatusDesc=marryDesc
	}
	set countryRowID="",countryCode="",countryDesc=""
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	if countryRowID'="" {
		set countryCode=$p($g(^CT("COU",countryRowID)),"^",1)
		set countryDesc=$p($g(^CT("COU",countryRowID)),"^",2)
		set Obj.PATCountryCode=countryCode
		set Obj.PATCountryDesc=countryDesc
	}
	set nationRowID="",nationCode="",nationDesc=""
	set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	if nationRowID'="" {
		set nationCode=$p($g(^CT("NAT",nationRowID)),"^",1)
		set nationDesc=$p($g(^CT("NAT",nationRowID)),"^",2)
		set Obj.PATNationCode=nationCode
		set Obj.PATNationDesc=nationDesc
	}
	set Obj.PATHealthCardID=""
	set PATMotherID=$p($g(^PAPER(patRowId,"PER",4)),"^",13)
	set:PATMotherID'="" Obj.PATMotherID=$p($g(^PAPER(PATMotherID,"PAT",1)),"^",1)
	set Obj.PATWorkPlaceName=$p($g(^PAPER(patRowId,"PER",4)),"^",18)
	set Obj.PATWorkPlaceTelNum=$p($g(^PAPER(patRowId,"PER",1)),"^",9)
	set Obj.PATRemarks=""
	set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)
	
	if UpdateUserDr'="" {
		set Obj.UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
		set Obj.UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	else {
		set Obj.UpdateUserCode="-"
		set Obj.UpdateUserDesc="-"
	}
	set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	set:UpdateDate'="" Obj.UpdateDate=$zd(UpdateDate,3)
	set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)
	set:UpdateTime'="" Obj.UpdateTime=$zt(UpdateTime,1)
	
	set deathDate=$p($g(^PAPER(patRowId,"ALL")),"^",13)
	set:deathDate'="" Obj.PATDeceasedDate=$zd(deathDate,3)
	set deathTime=$p($g(^PAPER(patRowId,"ALL")),"^",8)
	set:deathTime'="" Obj.PATDeceasedTime=$zt(deathTime)
	//患者地址信息
	set DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",patRowId,""))
	set paAddressObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAddress).%New()
	set paAddressObj.PATAddressType="06" //出生地址
	s BirthProvinceRowID="",BirthProvinceDesc=""
	s:DHCPersonID'="" BirthProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",13)  
	s:BirthProvinceRowID'="" paAddressObj.PATProvinceCode=$p($g(^CT("PROV",BirthProvinceRowID)),"^",1)
	s:BirthProvinceRowID'="" BirthProvinceDesc=$p($g(^CT("PROV",BirthProvinceRowID)),"^",2)
	s paAddressObj.PATProvinceDesc=BirthProvinceDesc
	s:BirthProvinceDesc["-" paAddressObj.PATProvinceDesc=$p($g(BirthProvinceDesc),"-",2)
	s BirthCityRowID="",BirthCityDesc=""
	s:DHCPersonID'="" BirthCityRowID=$P(^DHCPERSON(DHCPersonID),"^",14) 
	s:BirthCityRowID'="" paAddressObj.PATCityCode=$p($g(^CT("CIT",BirthCityRowID)),"^",1)
	s:BirthCityRowID'="" BirthCityDesc=$p($g(^CT("CIT",BirthCityRowID)),"^",2)
	s paAddressObj.PATCityDesc=BirthCityDesc
	s:BirthCityDesc["-" paAddressObj.PATCityDesc=$p($g(BirthCityDesc),"-",2)
	s CountyRowID=""
	set:DHCPersonID'="" CountyRowID=$P(^DHCPERSON(DHCPersonID),"^",15)
	if CountyRowID'=""  d
	.set paAddressObj.PATCountyCode=$p($g(^CT("CITAREA",CountyRowID)),"^",1)
	.set paAddressObj.PATCountyDesc=$p($g(^CT("CITAREA",CountyRowID)),"^",2)
	.set:paAddressObj.PATCountyDesc["-" paAddressObj.PATCountyDesc=$p($g(paAddressObj.PATCountyDesc),"-",2)
	
	set paAddressObj.PATCountryside=""
	set paAddressObj.PATVillage=""
	set paAddressObj.PATHouseNum=""
	set paAddressObj.PATPostalCode=""
	set:DHCPersonID'="" paAddressObj.PATAddressDesc=$P(^DHCPERSON(DHCPersonID),"^",16)
	if ((BirthProvinceRowID'="")||(BirthCityRowID'="")){
		do Obj.PAAddress.Insert(paAddressObj)
	} 
	
	set nowAddrObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAddress).%New()
	set nowAddrObj.PATAddressType="09" //现住址
	s ProvinceRowID="",ProvinceDesc="",ProvinceCode=""
	s ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	s:ProvinceRowID'="" nowAddrObj.PATProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	s:ProvinceRowID'="" ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set nowAddrObj.PATProvinceDesc=ProvinceDesc
	s:ProvinceDesc["-" nowAddrObj.PATProvinceDesc=$p($g(ProvinceDesc),"-",2)
	s CityCodeRowID="",CityCodeCode="",CityCodeDesc=""
	s CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	s:CityCodeRowID'="" nowAddrObj.PATCityCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	s:CityCodeRowID'="" CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	s nowAddrObj.PATCityDesc=CityCodeDesc
	s:ProvinceDesc["-" nowAddrObj.PATCityDesc=$p($g(CityCodeDesc),"-",2)
	s CityAreaRowID="",CityAreaCode="",CityAreaDesc=""
	s CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	s:CityAreaRowID'="" nowAddrObj.PATCountyCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	s:CityAreaRowID'="" CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	s nowAddrObj.PATCountyDesc=CityAreaDesc
	s:CityAreaDesc["-" nowAddrObj.PATCountyDesc=$p($g(CityAreaDesc),"-",2)
	set nowAddrObj.PATCountryside=""
	set nowAddrObj.PATVillage=""
	set nowAddrObj.PATHouseNum=""
	set nowAddrObj.PATPostalCode=""
	set nowAddrObj.PATAddressDesc=$g(^PAPER(patRowId,"PER","ADD",1))
	if (nowAddrObj.PATAddressDesc'=""){
		do Obj.PAAddress.Insert(nowAddrObj)
	}
	set hkAddrObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAddress).%New()
	set hkAddrObj.PATAddressType="01" //户口地址
	if DHCPersonID'=""{
		s ProvinceRowID="",ProvinceDesc="",ProvinceCode=""
		s ProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",17) 
		s:ProvinceRowID'="" hkAddrObj.PATProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
		s:ProvinceRowID'="" ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
		set hkAddrObj.PATProvinceDesc=ProvinceDesc
		s:ProvinceDesc["-" hkAddrObj.PATProvinceDesc=$p($g(ProvinceDesc),"-",2)
		s CityCodeRowID="",CityCodeCode="",CityCodeDesc=""
		s CityCodeRowID=$P(^DHCPERSON(DHCPersonID),"^",18) 
		s:CityCodeRowID'="" hkAddrObj.PATCityCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
		s:CityCodeRowID'="" CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
		s hkAddrObj.PATCityDesc=CityCodeDesc
		s:ProvinceDesc["-" hkAddrObj.PATCityDesc=$p($g(CityCodeDesc),"-",2)
		s CityAreaRowID="",CityAreaCode="",CityAreaDesc=""
		s CityAreaRowID=$P(^DHCPERSON(DHCPersonID),"^",19) 
		s:CityAreaRowID'="" hkAddrObj.PATCountyCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
		s:CityAreaRowID'="" CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
		s hkAddrObj.PATCountyDesc=CityAreaDesc
		s:CityAreaDesc["-" hkAddrObj.PATCountyDesc=$p($g(CityAreaDesc),"-",2)
		set hkAddrObj.PATAddressDesc=$P(^DHCPERSON(DHCPersonID),"^",20)
		set hkAddrObj.PATPostalCode=$p($g(^DHCPERSON(DHCPersonID)),"^",8)
	} 	
	set hkAddrObj.PATCountryside=""
	set hkAddrObj.PATVillage=""
	set hkAddrObj.PATHouseNum=""
	if ((ProvinceRowID'="")||(CityCodeRowID'="")||(CityAreaRowID'="")){
		do Obj.PAAddress.Insert(hkAddrObj)
		
	}
	set jgAddrObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAddress).%New()
	set jgAddrObj.PATAddressType="99" //籍贯地址
	set jgProvinceId="",jgProvinceCode="",jgProvinceDesc=""
	set jgProvinceId=$P($g(^PAPER(patRowId,"PER",2)),"^",11)
	s:jgProvinceId'="" jgAddrObj.PATProvinceCode=$p($g(^CT("PROV",jgProvinceId)),"^",1)
	s:jgProvinceId'="" jgProvinceDesc=$p($g(^CT("PROV",jgProvinceId)),"^",2)
	set jgAddrObj.PATProvinceDesc=jgProvinceDesc
	s:jgProvinceDesc["-" jgAddrObj.PATProvinceDesc=$p($g(jgProvinceDesc),"-",2)

	set jgCityId="",jgCityCode="",jgCityDesc=""
	s jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18) 
	s:jgCityId'="" jgAddrObj.PATCityCode=$p($g(^CT("CIT",jgCityId)),"^",1)
	s:jgCityId'="" jgCityDesc=$p($g(^CT("CIT",jgCityId)),"^",2)
	s jgAddrObj.PATCityDesc=jgCityDesc
	s:jgCityDesc["-" jgAddrObj.PATCityDesc=$p($g(jgCityDesc),"-",2)
	set jgAddrObj.PATAddressDesc=""
	set jgAddrObj.PATPostalCode=""
	set jgAddrObj.PATCountyCode=""
	set jgAddrObj.PATCountyDesc=""
	set jgAddrObj.PATCountryside=""
	set jgAddrObj.PATVillage=""
	set jgAddrObj.PATHouseNum=""
	if ((jgProvinceId'="")||(jgCityId'="")){
		do Obj.PAAddress.Insert(jgAddrObj)
	}
	
	//患者证件信息
	set identifier=##class(web.DHCENS.STBLL.EMPI.MODEL.PAIdentifier).%New()
	set CredentialTypeRowID="",identyTypeCode="",identyTypeDesc=""
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7) 
	set identifier.PATIdentityNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if identifier.PATIdentityNum'="" {
		set:CredentialTypeRowID="" CredentialTypeRowID=1
		if CredentialTypeRowID'="" {
			set identyTypeCode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
			set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
			set identifier.PATIdTypeCode=identyTypeCode
			set identifier.PATIdTypeDesc=identyTypeDesc
		}
		do Obj.PAIdentifiers.Insert(identifier)
	}
	//患者联系人信息	
	set relation=##class(web.DHCENS.STBLL.EMPI.MODEL.PARelation).%New()
	set LinkManRelationDR="",relationCode="",relationDesc=""
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	if LinkManRelationDR'="" {
		set relationCode=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
		set relationDesc=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
		set relation.PATRelationCode=relationCode
		set relation.PATRelationDesc=relationDesc
	}
	set relation.PATRelationName=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set relation.PATRelationPhone=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	
	set relAddrObj=##class(web.DHCENS.STBLL.EMPI.MODEL.RelationAddress).%New()
	set relAddrObj.PATAddressDesc=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	set relAddrObj.PATCountyCode=""
	set relAddrObj.PATCountyDesc=""
	set relAddrObj.PATCountryside=""
	set relAddrObj.PATVillage=""
	set relAddrObj.PATHouseNum=""
	set relAddrObj.PATPostalCode=""
	set relAddrObj.PATProvinceCode=""
	set relAddrObj.PATProvinceDesc=""
	set relAddrObj.PATCityCode=""
	set relAddrObj.PATCityDesc=""
	do relation.PAAddress.Insert(relAddrObj)	
	do Obj.PARelation.Insert(relation)	
	if ##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCBL.CARD.UCardPaPatMasInfo||GetPatEncryptLevel")
	{
		set secretLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patRowId)
		set Obj.PATSecretLevelCode=$p(secretLevelInfo,"^",3)
		set Obj.PATSecretLevelDesc=$p(secretLevelInfo,"^",4)
	}
	do body.paPatients.Insert(Obj)
	set request.body=body
	do request.XMLExportToStream(.stream)	
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	Quit stream
}

/// Creator：Zhanglinyun
/// CreatDate：2019—06-21
/// Description：根据患者ID获取患者基本信息
/// Table：PA_PatMas
/// Input：patRowId：患者ID
/// Output：
/// Return：患者基本信息model
/// w ##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPATINFO","6413230")
/// Others：s st= ##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByPatId("1")
/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByPatId("16595")
ClassMethod PAPatientByPatId(patRowId As %String) As web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew
{
	set $zt="Exception"
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew).%New()
	if (patRowId="")||($d(^PAPER(patRowId))=0) {
		quit Obj
	}
	set AdmType=$o(^PAPERdr(patRowId,"ADM",""))
	q:AdmType="" Obj
	set AdmNo=$o(^PAPERdr(patRowId,"ADM",AdmType,""))
	q:AdmNo="" Obj
	set LocDr=$p($g(^PAADM(AdmNo)),"^",4)
	set HospDr=$p($g(^CTLOC(LocDr)),"^",22)
	set Obj.HospitalCode=$p($g(^CT("HOSP",HospDr)),"^",1)
	set Obj.HospitalDesc=$p($g(^CT("HOSP",HospDr)),"^",2)
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set Obj.PATName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if sexRowID'="" {
		set sexCode=$p($g(^CT("SEX",sexRowID)),"^",1)
		set sexDesc=$p($g(^CT("SEX",sexRowID)),"^",2)
		set Obj.PATSexCode=sexCode
		set Obj.PATSexDesc=sexDesc
	}
	set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set:birthDay="" birthDay=1846
	set:birthDay'="" Obj.PATDob=$zd(birthDay,3)
	set Obj.PATAge=##class(web.DHCBillInterface).GetPapmiAge(patRowId,"",HospDr) 
	set PAPATTelephone=$P($g(^PAPER(patRowId,"PER",1)),"^",11)
	set Obj.PATTelephone=$e(PAPATTelephone,1,11)
	set occupationRowID="",OccupationDesc="",OccupationCode=""
	set occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
	if occupationRowID'="" {
		set OccupationCode=$p($g(^CT("OCC",occupationRowID)),"^",1)
		set OccupationDesc=$p($g(^CT("OCC",occupationRowID)),"^",2)
		set Obj.PATOccupationCode=OccupationCode
		set Obj.PATOccupationDesc=OccupationDesc
	}
	set Obj.PATDocumentNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"","",.ErrMsg)
	set:Obj.PATDocumentNo="" Obj.PATDocumentNo=$p($g(^PAPER(patRowId,"PAT",1)),"^",22) 
	set marryRowID="",marryCode="",marryDesc=""
	set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	if marryRowID'="" {
		set marryCode=$p($g(^CT("MAR",marryRowID)),"^",1)
		set marryDesc=$p($g(^CT("MAR",marryRowID)),"^",2)
		set Obj.PATMaritalStatusCode=marryCode
		set Obj.PATMaritalStatusDesc=marryDesc
	}
	set countryRowID="",countryCode="",countryDesc=""
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	if countryRowID'="" {
		set countryCode=$p($g(^CT("COU",countryRowID)),"^",1)
		set countryDesc=$p($g(^CT("COU",countryRowID)),"^",2)
		set Obj.PATCountryCode=countryCode
		set Obj.PATCountryDesc=countryDesc
	}
	set nationRowID="",nationCode="",nationDesc=""
	set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	if nationRowID'="" {
		set nationCode=$p($g(^CT("NAT",nationRowID)),"^",1)
		set nationDesc=$p($g(^CT("NAT",nationRowID)),"^",2)
		set Obj.PATNationCode=nationCode
		set Obj.PATNationDesc=nationDesc
	}
	set Obj.PATHealthCardID=""
	set PATMotherID=$p($g(^PAPER(patRowId,"PER",4)),"^",13)
	set:PATMotherID'="" Obj.PATMotherID=$p($g(^PAPER(PATMotherID,"PAT",1)),"^",1)
	set Obj.PATWorkPlaceName=$p($g(^PAPER(patRowId,"PER",4)),"^",18)
	set Obj.PATWorkPlaceTelNum=$p($g(^PAPER(patRowId,"PER",1)),"^",9)
	set Obj.PATRemarks=""
	
	//患者证件信息
	set CredentialTypeRowID="",identyTypeCode="",identyTypeDesc=""
	set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7) 
	set Obj.PATIdentityNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	if Obj.PATIdentityNum'="" {
		set:CredentialTypeRowID="" CredentialTypeRowID=1
		if CredentialTypeRowID'="" {
			set identyTypeCode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
			set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
			set Obj.PATIdTypeCode=identyTypeCode
			set Obj.PATIdTypeDesc=identyTypeDesc
		}
	}
	set Obj.PATRelationName=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	set Obj.PATRelationPhone=$P($G(^PAPER(patRowId,"ALL")),"^",4) 
	set CFRowid=""
	set CFRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",patRowId,CFRowid),-1)	;按医院要求取最近一次卡信息 2019-10-17
	if CFRowid'=""
	{
		set Obj.PATRemarks=$p(^DHCCARD("CF",CFRowid),"^",2)	;郫都区医技科室要刷卡登记,需要传卡号给第三方 2019-09-29
	}
	Quit Obj
Exception
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew).%New()
	Quit Obj
}

/// Others：s st= ##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByRegNo("0006560965")
ClassMethod PAPatientByRegNo(RegNo As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set patRowId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))

	set stream=##class(%GlobalCharacterStream).%New()
	set stream=..PAPatient(patRowId)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

}
