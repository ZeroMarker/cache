Class web.DHCENS.STBLL.DICTNew.Patient.Patient Extends %RegisteredObject
{

/// w ##class(web.DHCENS.STBLL.DICTNew.Patient.Patient).BatchOfPatientsWithRowId("","")
ClassMethod BatchOfPatientsWithRowId(startDate As %String, endDate As %String) As %String
{
	set $zt="Exception"
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	set ^ExportHistoryData("PAPatient")=$lb("病人登记号","病人姓名","性别代码","性别名称","出生日期","联系电话","职业代码","职业描述","病案号","婚姻状态编码","婚姻状态名称","国家代码","国家名称","民族代码","民族名称","健康卡号","父母ID指向","工作单位","工作单位联系电话","备注","死亡日期","死亡时间","更新人代码","更新人描述","更新日期","更新时间","患者密级代码","患者密级描述")
	set ^ExportHistoryData("PAPatientAddress")=$lb("病人登记号","省份代码","省份描述","城市代码","城市描述","区县代码","区县描述","地址-乡（镇、街道办事处）","地址-村（街、路、弄等）","地址-门牌号码","邮政编码","地址描述")
	set ^ExportHistoryData("PAPatientIdentity")=$lb("病人登记号","证件类型代码","证件类型描述","证件号码")
	set ^ExportHistoryData("PATRelation")=$lb("病人登记号","联系人关系代码","联系人关系描述","联系人名称","联系人电话")
	set ^ExportHistoryData("PAPatientRelationAddress")=$lb("病人登记号","地址描述")
	set i=0,j=0,k=0,m=0,n=0
	
	set:startDate'="" startDate=$zdh(startDate,3)
	set:endDate'="" endDate=$zdh(endDate,3)

	set patRowId="0"  for  set patRowId=$o(^PAPER(patRowId))  q:patRowId=""  d
	.set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	.Quit:((startDate'="")&&(startDate>UpdateDate))
	.Quit:((endDate'="")&&(endDate<UpdateDate))
	.set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	.set UpdateTime=$p($g(^PAPER(patRowId,"PER",5)),"^",3)
	.set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	
	.set PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	.set PATName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	.set (sexRowID,PATSexCode,PATSexDesc)=""
	.set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	.if sexRowID'="" d
	..set PATSexCode=sexRowID //$p($g(^CT("SEX",sexRowID)),"^",1)
	..set PATSexDesc=$p($g(^CT("SEX",sexRowID)),"^",2)
	.set (birthDay,PATDob)=""
	.set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	.set:birthDay="" birthDay=1846
	.set:birthDay'="" PATDob=$zd(birthDay,3)
	.set PAPATTelephone=$P($g(^PAPER(patRowId,"PER",1)),"^",11)	
	.set PATTelephone=$e(PAPATTelephone,1,11)	
	.set (occupationRowID,OccupationDesc,OccupationCode)=""
	.set occupationRowID=$P($G(^PAPER(patRowId,"PER",2)),"^",6)
	.if occupationRowID'="" d
	..set OccupationCode=occupationRowID //$p($g(^CT("OCC",occupationRowID)),"^",1)
	..set OccupationDesc=$p($g(^CT("OCC",occupationRowID)),"^",2)
	.set PATDocumentNo=$p($g(^PAPER(patRowId,"PAT",1)),"^",22)
	.set (marryRowID,PATMaritalStatusCode,PATMaritalStatusDesc)=""
	.set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	.if marryRowID'="" d
	..set PATMaritalStatusCode=marryRowID //$p($g(^CT("MAR",marryRowID)),"^",1)
	..set PATMaritalStatusDesc=$p($g(^CT("MAR",marryRowID)),"^",2)
	.set (countryRowID,countryCode,countryDesc)=""
	.set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	.if countryRowID'="" d
	..set countryCode=countryRowID //$p($g(^CT("COU",countryRowID)),"^",1)
	..set countryDesc=$p($g(^CT("COU",countryRowID)),"^",2)
	.set (nationRowID,nationCode,nationDesc)=""
	.set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	.if nationRowID'="" d
	..set nationCode=nationRowID //$p($g(^CT("NAT",nationRowID)),"^",1)
	..set nationDesc=$p($g(^CT("NAT",nationRowID)),"^",2)
	.set PATHealthCardID=""
	.set PATMotherID=$p($g(^PAPER(patRowId,"PER",4)),"^",13)
	.set PATWorkPlaceName=$p($g(^PAPER(patRowId,"PER",4)),"^",18)
	.set PATWorkPlaceTelNum=$p($g(^PAPER(patRowId,"PER",1)),"^",9)
	.set DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",patRowId,""))
	.set:DHCPersonID'="" WorkPostCode=$p($g(^DHCPERSON(DHCPersonID)),"^",7)
	.set PATRemarks=""
	.set UpdateUserDr=$p($g(^PAPER(patRowId,"PER",4)),"^",7)
	.if UpdateUserDr'="" d
	..set UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
	..set UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	.else  d
	..set UpdateUserCode="-"
	..set UpdateUserDesc="-"	
	.set deathDate=$p($g(^PAPER(patRowId,"ALL")),"^",13)
	.set:deathDate'="" deathDate=$zd(deathDate,3)
	.set deathTime=$p($g(^PAPER(patRowId,"ALL")),"^",8)
	.set:deathTime'="" deathTime=$zt(deathTime)	
	.if ##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCBL.CARD.UCardPaPatMasInfo||GetPatEncryptLevel")  d
	..set secretLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patRowId)
	..set PATSecretLevelCode=$p(secretLevelInfo,"^",3)
	.set PATSecretLevelDesc=$p(secretLevelInfo,"^",4)		
	.set ^ExportHistoryData("PAPatient",patRowId)=$lb(PATPatientID,PATName,PATSexCode,PATSexDesc,PATDob,PATTelephone,OccupationCode,OccupationDesc,PATDocumentNo,PATMaritalStatusCode,PATMaritalStatusDesc,countryCode,countryDesc,nationCode,nationDesc,PATHealthCardID,PATMotherID,PATWorkPlaceName,PATWorkPlaceTelNum,PATRemarks,deathDate,deathTime,UpdateUserCode,UpdateUserDesc,UpdateDate,UpdateTime)
	.set i=i+1

	.//患者地址信息
	.if DHCPersonID'=""  d
	..set PATAddressType="06" //出生地址
	..set (BirthProvinceRowID,BirthProvinceCode,BirthProvinceDesc)=""
	..set BirthProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",13) 
	..if BirthProvinceRowID'="" d
	...set BirthProvinceCode=BirthProvinceRowID //$p($g(^CT("PROV",BirthProvinceRowID)),"^",1)
	...set BirthProvinceDesc=$p($g(^CT("PROV",BirthProvinceRowID)),"^",2)
	...set:BirthProvinceDesc["-" BirthProvinceDesc=$p($g(BirthProvinceDesc),"-",2)
	..set (BirthCityRowID,BirthCityCode,BirthCityDesc)=""
	..set BirthCityRowID=$P(^DHCPERSON(DHCPersonID),"^",14)
	..if BirthCityRowID'="" d
	...set BirthCityCode=BirthCityRowID //$p($g(^CT("CIT",BirthCityRowID)),"^",1)
	...set BirthCityDesc=$p($g(^CT("CIT",BirthCityRowID)),"^",2)
	...set:BirthCityDesc["-" BirthCityDesc=$p($g(BirthCityDesc),"-",2)
	..set CountyRowID=$P(^DHCPERSON(DHCPersonID),"^",15)
	..if CountyRowID'=""  d
	...set PATCountyCode=CountyRowID //$p($g(^CT("CITAREA",CountyRowID)),"^",1)
	...set PATCountyDesc=$p($g(^CT("CITAREA",CountyRowID)),"^",2)
	...set:PATCountyDesc["-" PATCountyDesc=$p($g(PATCountyDesc),"-",2)
	..set PATCountryside=""
	..set PATVillage=""
	..set PATHouseNum=""
	..set PATPostalCode=""
	..set PATAddressDesc=$P(^DHCPERSON(DHCPersonID),"^",16)
	..if ((BirthProvinceRowID'="")||(BirthCityRowID'="")) d
	...set ^ExportHistoryData("PAPatientAddress",patRowId,PATAddressType)=$lb(PATPatientID,PATAddressType,BirthProvinceCode,BirthProvinceDesc,BirthCityCode,BirthCityDesc,PATCountyCode,PATCountyDesc,PATCountryside,PATVillage,PATHouseNum,PATPostalCode,PATAddressDesc)
	...set j=j+1
	
	.set PATAddressType="09" //现住址
	.set (ProvinceRowID,ProvinceDesc,ProvinceCode)=""
	.set ProvinceRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",2) 
	.if ProvinceRowID'="" d
	..set ProvinceCode=ProvinceRowID //$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	..set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	..set:ProvinceDesc["-" ProvinceDesc=$p($g(ProvinceDesc),"-",2)
	..set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	.set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	.if CityCodeRowID'="" d
	..set CityCodeCode=CityCodeRowID // $p($g(^CT("CIT",CityCodeRowID)),"^",1)
	..set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	..set:ProvinceDesc["-" CityCodeDesc=$p($g(CityCodeDesc),"-",2)
	.set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	.set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	.if CityAreaRowID'="" d
	..set CityAreaCode=CityAreaRowID //$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	..set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	..set:CityAreaDesc["-" CityAreaDesc=$p($g(CityAreaDesc),"-",2)
	.set PATCountryside=""
	.set PATVillage=""
	.set PATHouseNum=""
	.set:DHCPersonID'="" PATPostalCode=$p($g(^DHCPERSON(DHCPersonID)),"^",8)
	.set PATAddressDesc=$g(^PAPER(patRowId,"PER","ADD",1))	
	.if ((PATAddressDesc'="")||(ProvinceRowID'="")||(CityCodeRowID'="")) d
	..set ^ExportHistoryData("PAPatientAddress",patRowId,PATAddressType)=$lb(PATPatientID,PATAddressType,ProvinceCode,ProvinceDesc,CityCodeCode,CityCodeDesc,CityAreaCode,CityAreaDesc,PATCountryside,PATVillage,PATHouseNum,PATPostalCode,PATAddressDesc)
	..set j=j+1

	
	.set PATAddressType="01" //户口地址
	.if DHCPersonID'="" d
	..set (ProvinceRowID,ProvinceDesc,ProvinceCode)=""
	..set ProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",17) 
	..if ProvinceRowID'="" d
	...set ProvinceCode=ProvinceRowID //$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	...set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	...set:ProvinceDesc["-" ProvinceDesc=$p($g(ProvinceDesc),"-",2)
	...set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	..set CityCodeRowID=$P(^DHCPERSON(DHCPersonID),"^",18) 
	..if CityCodeRowID'="" d
	...set CityCodeCode=CityCodeRowID //$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	...set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	...set:CityCodeDesc["-" CityCodeDesc=$p($g(CityCodeDesc),"-",2)
	..set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	..set CityAreaRowID=$P(^DHCPERSON(DHCPersonID),"^",19) 
	..if CityAreaRowID'="" d
	...set CityAreaCode=CityAreaRowID //$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	...set CityAreaDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	...set:CityAreaDesc["-" CityAreaDesc=$p($g(CityAreaDesc),"-",2)
	..set PATCountryside=""
	..set PATVillage=""
	..set PATHouseNum=""
	..set PATPostalCode=$p($g(^DHCPERSON(DHCPersonID)),"^",9)
	..set PATAddressDesc=$P(^DHCPERSON(DHCPersonID),"^",20)
	..if ((ProvinceRowID'="")||(CityCodeRowID'="")||(PATAddressDesc'="")) d
	...set ^ExportHistoryData("PAPatientAddress",patRowId,PATAddressType)=$lb(PATPatientID,PATAddressType,ProvinceCode,ProvinceDesc,CityCodeCode,CityCodeDesc,CityAreaCode,CityAreaDesc,PATCountryside,PATVillage,PATHouseNum,PATPostalCode,PATAddressDesc)
	..set j=j+1

	.set PATAddressType="99" //籍贯地址
	.set (jgProvinceId,jgProvinceCode,jgProvinceDesc)=""
	.set jgProvinceId=$P($g(^PAPER(patRowId,"PER",2)),"^",11)
	.if jgProvinceId'="" d
	..set jgProvinceCode=jgProvinceId //$p($g(^CT("PROV",jgProvinceId)),"^",1)
	..set jgProvinceDesc=$p($g(^CT("PROV",jgProvinceId)),"^",2)
	..set:jgProvinceDesc["-" jgProvinceDesc=$p($g(jgProvinceDesc),"-",2)
	.set (jgCityId,jgCityCode,jgCityDesc)=""
	.set jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18) 
	.if jgCityId'="" d
	..set jgCityCode=jgCityId //$p($g(^CT("CIT",jgCityId)),"^",1)
	..set jgCityDesc=$p($g(^CT("CIT",jgCityId)),"^",2)
	..set:jgCityDesc["-" jgCityDesc=$p($g(jgCityDesc),"-",2)
	.set PATCountyCode=""
	.set PATCountyDesc=""
	.set PATCountryside=""
	.set PATVillage=""
	.set PATHouseNum=""
	.set PATAddressDesc=""
	.set PATPostalCode=""
	.if ((jgProvinceId'="")||(jgCityId'="")) d
	..set ^ExportHistoryData("PAPatientAddress",patRowId,PATAddressType)=$lb(PATPatientID,PATAddressType,jgProvinceCode,jgProvinceDesc,jgCityCode,jgCityDesc,PATCountyCode,PATCountyDesc,PATCountryside,PATVillage,PATHouseNum,PATPostalCode,PATAddressDesc)
	..set j=j+1

	.//患者证件信息
	.set (CredentialTypeRowID,identyTypeCode,identyTypeDesc)=""
	.set idNum=$P($g(^PAPER(patRowId,"ALL")),"^",9)  
	.set PATIdentityNum=$p($g(^PAPER(patRowId,"PAT",3)),"^",6)
	.set CredentialTypeRowID=$p($g(^PAPER(patRowId,"PAT",3)),"^",7)
	.if ((idNum'="")&&(PATIdentityNum'="")&&(idNum=PATIdentityNum))  d
	..set:CredentialTypeRowID="" CredentialTypeRowID=1
	..set identyTypeCode=CredentialTypeRowID //$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
	..set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
	..set ^ExportHistoryData("PAPatientIdentity",patRowId,identyTypeCode)=$lb(PATPatientID,identyTypeCode,identyTypeDesc,PATIdentityNum)
	..set k=k+1
	.else  d
	..if PATIdentityNum'="" d
	...set:CredentialTypeRowID="" CredentialTypeRowID=1
	...set identyTypeCode=CredentialTypeRowID //$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
	...set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
	...set ^ExportHistoryData("PAPatientIdentity",patRowId,identyTypeCode)=$lb(PATPatientID,identyTypeCode,identyTypeDesc,PATIdentityNum)
	...set k=k+1
	..if idNum'="" d
	...set CredentialTypeRowID=1
	...set identyTypeCode=CredentialTypeRowID //$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
	...set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
	...set ^ExportHistoryData("PAPatientIdentity",patRowId,identyTypeCode)=$lb(PATPatientID,identyTypeCode,identyTypeDesc,idNum)
	...set k=k+1
	
	.//患者联系人信息	
	.set (LinkManRelationDR,relationCode,relationDesc)=""
	.set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	.if LinkManRelationDR'="" d
	..set relationCode=LinkManRelationDR //$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
	..set relationDesc=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
	..set PATRelationName=$p($g(^PAPER(patRowId,"PER",2)),"^",13)
	..set PATRelationPhone=$P($G(^PAPER(patRowId,"ALL")),"^",4)
	..set ^ExportHistoryData("PATRelation",patRowId)=$lb(PATPatientID,relationCode,relationDesc,PATRelationName,PATRelationPhone)
	..set m=m+1
	..set PATAddressDesc=$P($G(^PAPER(patRowId,"PER",1)),"^",1)
	..set PATCountyCode=""
	..set PATCountyDesc=""
	..set PATCountryside=""
	..set PATVillage=""
	..set PATHouseNum=""
	..set PATPostalCode=""
	..set PATProvinceCode=""
	..set PATProvinceDesc=""
	..set PATCityCode=""
	..set PATCityDesc=""
	..if PATAddressDesc'="" d
	...set ^ExportHistoryData("PAPatientRelationAddress",patRowId)=$lb(PATPatientID,PATAddressDesc)
	...set n=n+1
	set ^ExportHistoryData("PAPatientResult")=i_","_j_","_k_","_m_","_n
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	Quit i
Exception
	Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.DICTNew.Patient.Patient).SingleOfPatientsWithRowId("1")
ClassMethod SingleOfPatientsWithRowId(patRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="03"
	set header.MessageID=$tr($h,",","")
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$H)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatient).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	set patid=""
	set patid=$o(^PAPERi("PAPMI_PatNo",patRowId,patid))
	i patid'="" set patRowId=patid
	if (patRowId="")||($d(^PAPER(patRowId))=0) {
		do body.paPatients.Insert(Obj)
		set request.body=body
		do request.XMLExportToStream(.stream)
		quit stream
	}

	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	
	/*set PAADMType="" 
	f  set PAADMType=$o(^PAPERdr(patid,"ADM",PAADMType),-1)  q:PAADMType=""  d
	.b ;oymj1
	.q:PAADMType="O"    ////过滤门诊患者
	.s PAADMRowID="" f  set PAADMRowID=$o(^PAPERdr(patid,"ADM",PAADMType,PAADMRowID),-1)
	.s PAADMBedDR=$P(^PAADM(PAADMRowID),73)
	.s PACWORDBED=$P(^PAWARD(+PAADMBedDR,"BED",$P(PAADMBedDR,"||",2)),"^",1)  ////床位代码
	.b ; oymj*/
	
	//同步his患者信息接口服务
	;set tSC=##class(web.DHCENS.STBLL.EMPI.METHOD.PatientInfo).PatientInfo(Obj.PATPatientID)
	set Obj.PATName=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	q:Obj.PATName="" stream
	//患者信息新增字段（VIP标识、卡号。卡类型、黑名单标识）
    ;set Obj.PATVIPFlag=$P($g(^PAPER(patRowId,"PAT",4)),"^",1)
    ;set Obj.PATCardnum=$P($g(^PAPER(patRowId,"PAT",3)),"^",6)
    ;set Obj.PATCardType=$P($g(^PAPER(patRowId,"PAT",3)),"^",7)
    ;set Obj.PATBlankFlag=$P($g(^PAPER(patRowId,"PAT",1)),"^",19)
    set Obj.HospitalCode=2 //"CQSZYY"
    set Obj.BusinessFieldCode="00001"
	set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if sexRowID'="" {
		set sexCode=$p($g(^CT("SEX",sexRowID)),"^",1)
		set sexDesc=$p($g(^CT("SEX",sexRowID)),"^",2)
		set Obj.PATSexCode=sexRowID //sexCode
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
		set Obj.PATOccupationCode=occupationRowID //OccupationCode
		set Obj.PATOccupationDesc=OccupationDesc
	}
	set marryRowID="",marryCode="",marryDesc=""
	set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	if marryRowID'="" {
		set marryCode=$p($g(^CT("MAR",marryRowID)),"^",1)
		set marryDesc=$p($g(^CT("MAR",marryRowID)),"^",2)
		set Obj.PATMaritalStatusCode=marryRowID //marryCode
		set Obj.PATMaritalStatusDesc=marryDesc
	}
	set countryRowID="",countryCode="",countryDesc=""
	set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	if countryRowID'="" {
		set countryCode=$p($g(^CT("COU",countryRowID)),"^",1)
		set countryDesc=$p($g(^CT("COU",countryRowID)),"^",2)
		set Obj.PATCountryCode=countryRowID //countryCode
		set Obj.PATCountryDesc=countryDesc
	}
	set nationRowID="",nationCode="",nationDesc=""
	set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	if nationRowID'="" {
		set nationCode=$p($g(^CT("NAT",nationRowID)),"^",1)
		set nationDesc=$p($g(^CT("NAT",nationRowID)),"^",2)
		set Obj.PATNationCode=nationRowID //nationCode
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
	set Obj.PATDocumentNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)  //2021.03.16 心电报错，赋值病案号
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
	s:BirthProvinceRowID'="" paAddressObj.PATProvinceCode=BirthProvinceRowID //$p($g(^CT("PROV",BirthProvinceRowID)),"^",1)
	s:BirthProvinceRowID'="" BirthProvinceDesc=$p($g(^CT("PROV",BirthProvinceRowID)),"^",2)
	s paAddressObj.PATProvinceDesc=BirthProvinceDesc
	s:BirthProvinceDesc["-" paAddressObj.PATProvinceDesc=$p($g(BirthProvinceDesc),"-",2)
	s BirthCityRowID="",BirthCityDesc=""
	s:DHCPersonID'="" BirthCityRowID=$P(^DHCPERSON(DHCPersonID),"^",14) 
	s:BirthCityRowID'="" paAddressObj.PATCityCode=BirthCityRowID //$p($g(^CT("CIT",BirthCityRowID)),"^",1)
	s:BirthCityRowID'="" BirthCityDesc=$p($g(^CT("CIT",BirthCityRowID)),"^",2)
	s paAddressObj.PATCityDesc=BirthCityDesc
	s:BirthCityDesc["-" paAddressObj.PATCityDesc=$p($g(BirthCityDesc),"-",2)
	s CityAreaRowID="",CityAreaCode="",CityAreaDesc=""
	s CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	s CountyRowID=""
	set:DHCPersonID'="" CountyRowID=$P(^DHCPERSON(DHCPersonID),"^",15)
	if ((CountyRowID'="")&&(CityAreaRowID'=""))  d
	.set paAddressObj.PATCountyCode=CityAreaRowID //$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
	.set paAddressObj.PATCountyDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	.set PATCountyDesc=$p($g(^CT("CITAREA",CityAreaRowID)),"^",2)
	.set:PATCountyDesc["-" paAddressObj.PATCountyDesc=$p($g(PATCountyDesc),"-",2)
	
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
	s:ProvinceRowID'="" nowAddrObj.PATProvinceCode=ProvinceRowID //$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	s:ProvinceRowID'="" ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	set nowAddrObj.PATProvinceDesc=ProvinceDesc
	s:ProvinceDesc["-" nowAddrObj.PATProvinceDesc=$p($g(ProvinceDesc),"-",2)
	s CityCodeRowID="",CityCodeCode="",CityCodeDesc=""
	s CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	s:CityCodeRowID'="" nowAddrObj.PATCityCode=CityCodeRowID //$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	s:CityCodeRowID'="" CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	s nowAddrObj.PATCityDesc=CityCodeDesc
	s:ProvinceDesc["-" nowAddrObj.PATCityDesc=$p($g(CityCodeDesc),"-",2)
	;s CityAreaRowID="",CityAreaCode="",CityAreaDesc=""
	;s CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	s:CityAreaRowID'="" nowAddrObj.PATCountyCode=CityAreaRowID //$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
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
	s CityAreaRowID="",CityAreaCode="",CityAreaDesc=""
	if DHCPersonID'=""{
		s ProvinceRowID="",ProvinceDesc="",ProvinceCode=""
		s ProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",17) 
		s:ProvinceRowID'="" hkAddrObj.PATProvinceCode=ProvinceRowID //$p($g(^CT("PROV",ProvinceRowID)),"^",1)
		s:ProvinceRowID'="" ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
		set hkAddrObj.PATProvinceDesc=ProvinceDesc
		s:ProvinceDesc["-" hkAddrObj.PATProvinceDesc=$p($g(ProvinceDesc),"-",2)
		s CityCodeRowID="",CityCodeCode="",CityCodeDesc=""
		s CityCodeRowID=$P(^DHCPERSON(DHCPersonID),"^",18) 
		s:CityCodeRowID'="" hkAddrObj.PATCityCode=CityCodeRowID //$p($g(^CT("CIT",CityCodeRowID)),"^",1)
		s:CityCodeRowID'="" CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
		s hkAddrObj.PATCityDesc=CityCodeDesc
		s:ProvinceDesc["-" hkAddrObj.PATCityDesc=$p($g(CityCodeDesc),"-",2)
		;s CityAreaRowID="",CityAreaCode="",CityAreaDesc=""
		s CityAreaRowID=$P(^DHCPERSON(DHCPersonID),"^",19) 
		s:CityAreaRowID'="" hkAddrObj.PATCountyCode=CityAreaRowID //$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
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
	s:jgProvinceId'="" jgAddrObj.PATProvinceCode=jgProvinceId //$p($g(^CT("PROV",jgProvinceId)),"^",1)
	s:jgProvinceId'="" jgProvinceDesc=$p($g(^CT("PROV",jgProvinceId)),"^",2)
	set jgAddrObj.PATProvinceDesc=jgProvinceDesc
	s:jgProvinceDesc["-" jgAddrObj.PATProvinceDesc=$p($g(jgProvinceDesc),"-",2)

	set jgCityId="",jgCityCode="",jgCityDesc=""
	s jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18) 
	s:jgCityId'="" jgAddrObj.PATCityCode=jgCityId //$p($g(^CT("CIT",jgCityId)),"^",1)
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
	//if identifier.PATIdentityNum'="" {
	set:CredentialTypeRowID="" CredentialTypeRowID=20
	if CredentialTypeRowID'="" {
		set identyTypeCode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
		set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
		set identifier.PATIdTypeCode=CredentialTypeRowID //identyTypeCode
		set identifier.PATIdTypeDesc=identyTypeDesc
	}
	do:identifier.PATIdentityNum'="" Obj.PAIdentifiers.Insert(identifier)
	//}
	//患者联系人信息	
	set relation=##class(web.DHCENS.STBLL.EMPI.MODEL.PARelation).%New()
	set LinkManRelationDR="",relationCode="",relationDesc=""
	set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	if LinkManRelationDR'="" {
		set relationCode=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
		set relationDesc=$p($g(^CT("RLT",LinkManRelationDR)),"^",2)
		set relation.PATRelationCode=LinkManRelationDR //relationCode
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
	do body.paPatients.Insert(Obj)
	set request.body=body
	do request.XMLExportToStream(.stream)
	Quit stream

Exception
	set stream=##class(%GlobalCharacterStream).%New()
	b ;3
	Quit stream
}

}
