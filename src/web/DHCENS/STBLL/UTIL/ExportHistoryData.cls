Class web.DHCENS.STBLL.UTIL.ExportHistoryData Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.UTIL.ExportHistoryData).PAPatient("","")
ClassMethod PAPatient(startDate As %String, endDate As %String) As %String
{
	set $zt="Exception"
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	set ^ExportHistoryData("PAPatient")=$lb("病人登记号","病人姓名","性别代码","性别名称","出生日期","联系电话","职业代码","职业描述","病案号","婚姻状态编码","婚姻状态名称","国家代码","国家名称","民族代码","民族名称","健康卡号","父母ID指向","工作单位","工作单位联系电话","备注","死亡日期","死亡时间","更新人代码","更新人描述","更新时间","更新日期")
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
	..set PATSexCode=$p($g(^CT("SEX",sexRowID)),"^",1)
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
	..set OccupationCode=$p($g(^CT("OCC",occupationRowID)),"^",1)
	..set OccupationDesc=$p($g(^CT("OCC",occupationRowID)),"^",2)
	.set PATDocumentNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patRowId,"I","",.ErrMsg)
	.set (marryRowID,PATMaritalStatusCode,PATMaritalStatusDesc)=""
	.set marryRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",3)
	.if marryRowID'="" d
	..set PATMaritalStatusCode=$p($g(^CT("MAR",marryRowID)),"^",1)
	..set PATMaritalStatusDesc=$p($g(^CT("MAR",marryRowID)),"^",2)
	.set (countryRowID,countryCode,countryDesc)=""
	.set countryRowID=$p($g(^PAPER(patRowId,"PER",1)),"^",8)
	.if countryRowID'="" d
	..set countryCode=$p($g(^CT("COU",countryRowID)),"^",1)
	..set countryDesc=$p($g(^CT("COU",countryRowID)),"^",2)
	.set (nationRowID,nationCode,nationDesc)=""
	.set nationRowID=$p($g(^PAPER(patRowId,"PER",2)),"^",1)
	.if nationRowID'="" d
	..set nationCode=$p($g(^CT("NAT",nationRowID)),"^",1)
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
	.set ^ExportHistoryData("PAPatient",patRowId)=$lb(PATPatientID,PATName,PATSexCode,PATSexDesc,PATDob,PATTelephone,OccupationCode,OccupationDesc,PATDocumentNo,PATMaritalStatusCode,PATMaritalStatusDesc,countryCode,countryDesc,nationCode,nationDesc,PATHealthCardID,PATMotherID,PATWorkPlaceName,PATWorkPlaceTelNum,PATRemarks,deathDate,deathTime,UpdateUserCode,UpdateUserDesc,UpdateDate,UpdateTime)
	.set i=i+1

	.//患者地址信息
	.if DHCPersonID'=""  d
	..set PATAddressType="06" //出生地址
	..set (BirthProvinceRowID,BirthProvinceCode,BirthProvinceDesc)=""
	..set BirthProvinceRowID=$P(^DHCPERSON(DHCPersonID),"^",13) 
	..if BirthProvinceRowID'="" d
	...set BirthProvinceCode=$p($g(^CT("PROV",BirthProvinceRowID)),"^",1)
	...set BirthProvinceDesc=$p($g(^CT("PROV",BirthProvinceRowID)),"^",2)
	...set:BirthProvinceDesc["-" BirthProvinceDesc=$p($g(BirthProvinceDesc),"-",2)
	..set (BirthCityRowID,BirthCityCode,BirthCityDesc)=""
	..set BirthCityRowID=$P(^DHCPERSON(DHCPersonID),"^",14)
	..if BirthCityRowID'="" d
	...set BirthCityCode=$p($g(^CT("CIT",BirthCityRowID)),"^",1)
	...set BirthCityDesc=$p($g(^CT("CIT",BirthCityRowID)),"^",2)
	...set:BirthCityDesc["-" BirthCityDesc=$p($g(BirthCityDesc),"-",2)
	..set CountyRowID=$P(^DHCPERSON(DHCPersonID),"^",15)
	..if CountyRowID'=""  d
	...set PATCountyCode=$p($g(^CT("CITAREA",CountyRowID)),"^",1)
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
	..set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	..set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	..set:ProvinceDesc["-" ProvinceDesc=$p($g(ProvinceDesc),"-",2)
	..set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	.set CityCodeRowID=$P($g(^PAPER(patRowId,"PER",1)),"^",5) 
	.if CityCodeRowID'="" d
	..set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	..set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	..set:ProvinceDesc["-" CityCodeDesc=$p($g(CityCodeDesc),"-",2)
	.set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	.set CityAreaRowID=$P($g(^PAPER(patRowId,"PER",4)),"^",9) 
	.if CityAreaRowID'="" d
	..set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
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
	...set ProvinceCode=$p($g(^CT("PROV",ProvinceRowID)),"^",1)
	...set ProvinceDesc=$p($g(^CT("PROV",ProvinceRowID)),"^",2)
	...set:ProvinceDesc["-" ProvinceDesc=$p($g(ProvinceDesc),"-",2)
	...set (CityCodeRowID,CityCodeCode,CityCodeDesc)=""
	..set CityCodeRowID=$P(^DHCPERSON(DHCPersonID),"^",18) 
	..if CityCodeRowID'="" d
	...set CityCodeCode=$p($g(^CT("CIT",CityCodeRowID)),"^",1)
	...set CityCodeDesc=$p($g(^CT("CIT",CityCodeRowID)),"^",2)
	...set:CityCodeDesc["-" CityCodeDesc=$p($g(CityCodeDesc),"-",2)
	..set (CityAreaRowID,CityAreaCode,CityAreaDesc)=""
	..set CityAreaRowID=$P(^DHCPERSON(DHCPersonID),"^",19) 
	..if CityAreaRowID'="" d
	...set CityAreaCode=$p($g(^CT("CITAREA",CityAreaRowID)),"^",1)
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
	..set jgProvinceCode=$p($g(^CT("PROV",jgProvinceId)),"^",1)
	..set jgProvinceDesc=$p($g(^CT("PROV",jgProvinceId)),"^",2)
	..set:jgProvinceDesc["-" jgProvinceDesc=$p($g(jgProvinceDesc),"-",2)
	.set (jgCityId,jgCityCode,jgCityDesc)=""
	.set jgCityId=$P($g(^PAPER(patRowId,"ALL")),"^",18) 
	.if jgCityId'="" d
	..set jgCityCode=$p($g(^CT("CIT",jgCityId)),"^",1)
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
	..set identyTypeCode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
	..set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
	..set ^ExportHistoryData("PAPatientIdentity",patRowId,identyTypeCode)=$lb(PATPatientID,identyTypeCode,identyTypeDesc,PATIdentityNum)
	..set k=k+1
	.else  d
	..if PATIdentityNum'="" d
	...set:CredentialTypeRowID="" CredentialTypeRowID=1
	...set identyTypeCode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
	...set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
	...set ^ExportHistoryData("PAPatientIdentity",patRowId,identyTypeCode)=$lb(PATPatientID,identyTypeCode,identyTypeDesc,PATIdentityNum)
	...set k=k+1
	..if idNum'="" d
	...set CredentialTypeRowID=1
	...set identyTypeCode=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",1)
	...set identyTypeDesc=$p($g(^PAC("CARD",CredentialTypeRowID)),"^",2)
	...set ^ExportHistoryData("PAPatientIdentity",patRowId,identyTypeCode)=$lb(PATPatientID,identyTypeCode,identyTypeDesc,idNum)
	...set k=k+1
	
	.//患者联系人信息	
	.set (LinkManRelationDR,relationCode,relationDesc)=""
	.set LinkManRelationDR=$P($G(^PAPER(patRowId,"EMP")),"^",4)
	.if LinkManRelationDR'="" d
	..set relationCode=$p($g(^CT("RLT",LinkManRelationDR)),"^",1)
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

/// w ##class(web.DHCENS.STBLL.UTIL.ExportHistoryData).PAAdm("","")
ClassMethod PAAdm(startDate As %String, endDate As %String) As %String
{
	set $zt="Exception"
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	set ^ExportHistoryData("PAAdm")=$lb("患者登记号","就诊RowId","就诊类型代码","就诊类型描述","就诊状态代码","就诊状态描述","就诊医生代码","就诊医生描述","就诊日期","就诊时间","就诊科室代码","就诊科室描述","当前科室代码","就诊科室描述","就诊病区代码","就诊病区描述","就诊房间代码","就诊房间描述","就诊床号","出院日期","出院时间","出院情况代码","出院情况描述","更新日期","更新时间","更新人代码","更新人描述","住院次数","院区代码")
	set ^ExportHistoryData("PADDiagnose")=$lb("就诊RowId","诊断类型代码","诊断类型描述","诊断代码","诊断描述","诊断医生代码","诊断医生描述","诊断日期","诊断时间","诊断级别","备注")

	set i=0,k=0
	set:startDate'="" startDate=$zdh(startDate,3)
	set:startDate'="" startDate=startDate-1
	set:endDate'="" endDate=$zdh(endDate,3)
	
	
	for  set startDate=$o(^PAADMi("PAADM_DateTime",startDate)) q:startDate=""  d
	.Quit:((endDate'="")&&(startDate>endDate))
	.set admTime="" for  set admTime=$o(^PAADMi("PAADM_DateTime",startDate,admTime)) q:admTime=""  d
	..set admRowId="" for  set admRowId=$o(^PAADMi("PAADM_DateTime",startDate,admTime,admRowId)) q:admRowId=""  d
	...set PAADMVisitNumber=admRowId
	...set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	...set PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	...Quit:PATPatientID=""
	...// 就诊类型
	...set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)
	...set AdmTypeDesc=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿")
	...// 就诊状态
	...set AdmStatusCode=$p($g(^PAADM(admRowId)),"^",20)
	...set AdmStatusDesc=$case(AdmStatusCode,"A":"在就诊","C":"取消就诊","D":"出院","P":"预约")
	...//就诊医生
	...set (AdmDoctorRowID,PAADMAdmitDocCode,PAADMAdmitDocDesc)=""
	...set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	...if AdmDoctorRowID'="" d
	....set userId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoctorRowID,""))
	....set:userId'="" PAADMAdmitDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	....set:userId'="" PAADMAdmitDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	...//就诊时间
	...set AdmDate= $P($G(^PAADM(admRowId)),"^",6)
	...set AdmTime=$P($G(^PAADM(admRowId)),"^",7)
	...set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	...set:AdmTime'="" AdmTime=$zt(AdmTime)	
	...//就诊科室
	...set AdmDeptRowID="",AdmDeptCode="",AdmDeptDesc=""
	...set AdmWardCode="",AdmWardRowID="",AdmWardDesc=""
	...set HospitalCode="",Bed=""
	...set TRANSChildsub="" for  set TRANSChildsub=$o(^PAADM(admRowId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Bed'="")  d
	....set Bed=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",8)
	....set AdmDeptRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",6)
	....if AdmDeptRowID'=""  d
	.....Quit:AdmDeptCode'=""
	.....set AdmDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
	.....set AdmDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
	.....set:AdmDeptDesc["-" AdmDeptDesc=$p($g(AdmDeptDesc),"-",2)
	...// 当前科室、病区、房间、床号
	...set (CurrentWardRowID,CurrentWardCode,CurrentWardDesc)=""
	...set CurrentWardRowID=$P($g(^PAADM(admRowId)),"^",70)
	...if CurrentWardRowID'="" d 
	....set CurrentWardCode=$p($g(^PAWARD(CurrentWardRowID)),"^",1)
	....set CurrentWardDesc=$p($g(^PAWARD(CurrentWardRowID)),"^",2)
	....set:CurrentWardDesc["-" CurrentWardDesc=$p($g(CurrentWardDesc),"-",2)
	...set (CurrentDetpRowID,CurrentDetpDesc,CurrentDetpCode)=""
	...set CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	...if CurrentDetpRowID'="" d
	....set CurrentDetpCode=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	....set CurrentDetpDesc=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	....set:CurrentDetpDesc["-" CurrentDetpDesc=$p($g(CurrentDetpDesc),"-",2)	
	....set hopitalId=$p($g(^CTLOC(CurrentDetpRowID)),"^",22)
	....Quit:hopitalId=""
	....set HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	
	
	...if AdmTypeCode="O"  d
	....set AdmDeptCode=CurrentDetpCode
	....set AdmDeptDesc=CurrentDetpDesc
	...set (CurrentRoomRowID,CurrentRoomCode,CurrentRoomDesc)=""
	...set CurrentRoomRowID=$P($g(^PAADM(admRowId)),"^",69)
	...if CurrentRoomRowID'="" d
	....set CurrentRoomCode=$p($g(^PAROOM(CurrentRoomRowID)),"^",1)
	....set CurrentRoomDesc=$p($g(^PAROOM(CurrentRoomRowID)),"^",2)
	...set CurrentBedRowID=$P($g(^PAADM(admRowId)),"^",73)
	...set CurrentBedNo=""
	...if ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1) d
	....set BedWordRowID = $p(CurrentBedRowID,"||",1)
	....set BedChildSub = $p(CurrentBedRowID,"||",2)
	....if $d(^PAWARD(BedWordRowID,"BED"))=10 d
	.....set CurrentBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)	
	...//最后更新时间,更新人
	...set UpdateDate=$p($g(^PAADM(admRowId,1)),"^",42)
	...set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	...set UpdateTime=$p($g(^PAADM(admRowId,1)),"^",43)
	...set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	...set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	...if UpdateUserDr'="" d
	....set UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
	....set UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	...else  d
	....set UpdateUserCode="-"
	....set UpdateUserDesc="-"	
	...// 出院日期、出院时间
	...set DisDateMR= $P($G(^PAADM(admRowId)),"^",17)
	...set:DisDateMR'="" DisDateMR=$zd(DisDateMR,3)
	...set DisTimeMR=$P($G(^PAADM(admRowId)),"^",18)
	...set:DisTimeMR'="" DisTimeMR=$zt(DisTimeMR,1)
	...//出院情况代码
	...set DisChargCondRowID = $P($G(^PAADM(admRowId)),"^",49)
	...if DisChargCondRowID'="" d
	....set DisChargCondCode=$p($g(^PAC("DISCON",DisChargCondRowID)),"^",1)
	....set DisChargCondDesc=$p($g(^PAC("DISCON",DisChargCondRowID)),"^",2)
	...set PAADMVisitTimes=$P($G(^PAADM(admRowId)),"^",29)
	...set ^ExportHistoryData("PAAdm",admRowId)=$lb(PATPatientID,admRowId,AdmTypeCode,AdmTypeDesc,AdmStatusCode,AdmStatusDesc,PAADMAdmitDocCode,PAADMAdmitDocDesc,AdmDate,AdmTime,AdmDeptCode,AdmDeptDesc,CurrentDetpCode,CurrentDetpDesc,CurrentWardCode,CurrentWardDesc,CurrentRoomCode,CurrentRoomDesc,CurrentBedNo,DisDateMR,DisTimeMR,DisChargCondCode,DisChargCondDesc,UpdateDate,UpdateTime,UpdateUserCode,UpdateUserDesc,PAADMVisitTimes,HospitalCode)
	...set i=i+1

	...//诊断信息
	...set mainmradmdr = $p($g(^PAADM(admRowId)),"^",61)
	...if ((mainmradmdr'="")&&($d(^MR(mainmradmdr))'=0)) d
	....set themrdiachildsub = "",j=0
	....set mrdiachildsub = "0" for  set mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub)) Quit:(mrdiachildsub="")  d
	.....set admDiagTypeCode="",admDiagTypeDesc=""
	.....set admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
	.....set:admDiagTypeId'="" admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
	.....set:admDiagTypeId'="" admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
	.....set themrdiachildsub = mrdiachildsub
	.....set mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)	
	.....set (mricdCode,mricdDesc)=""
	.....if (mricdid'="") d
	......set mricdCode = $p($g(^MRC("ID",mricdid)),"^",1)
	......set mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)		
	.....set docId=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",12)
	.....set (PADDiagDocCode,PADDiagDocDesc)=""
	.....if docId'="" d
	......set PADDiagDocCode=$p($g(^SSU("SSUSR",docId)),"^",1)
	......set PADDiagDocDesc=$p($g(^SSU("SSUSR",docId)),"^",2)		
	.....set diagDate=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",7)
	.....set:diagDate'="" diagDate=$zd(diagDate,3)
	.....set diagTime=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",8)
	.....set:diagTime'="" diagTime=$zt(diagTime,1)
	.....set PADRemarks=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1)),"^")	
	.....set j=j+1
	.....if j=1 d
	......set PADDiagCategory="主要诊断"
	.....else  d
	......set PADDiagCategory="次要诊断"
	.....set ^ExportHistoryData("PADDiagnose",admRowId,mainmradmdr_"||"_mrdiachildsub)=$lb(admRowId,admDiagTypeCode,admDiagTypeDesc,mricdCode,mricdDesc,PADDiagDocCode,PADDiagDocDesc,diagDate,diagTime,PADDiagCategory,PADRemarks)
	.....set k=k+1
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	set ^ExportHistoryData("PAAdmResult")=i_","_k
	Quit i
Exception
	Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.UTIL.ExportHistoryData).OEOrdItem("","")
ClassMethod OEOrdItem(fromDate As %String, endDate As %String) As %String
{
	set $zt="Exception"
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	set i=0
	set ^ExportHistoryData("OEOrdItem")=$lb("就诊RowID","医嘱RowID","医嘱组号","医嘱项目代码","医嘱项目描述","医嘱类型代码","医嘱类型描述","医嘱状态代码","医嘱状态描述","医嘱大类代码","医嘱大类描述","处方号","剂型代码","剂型描述","单次剂量","剂量单位代码","剂量单位描述","频次代码","频次描述","用法代码","用法描述","疗程代码","疗程描述","医嘱数量","医嘱结果状态代码","医嘱结果状态描述","医嘱备注","医嘱录入人代码","医嘱录入人描述","医嘱下达日期","医嘱下达时间","医嘱录入科室代码","医嘱录入科室描述","医嘱执行科室代码","医嘱执行科室描述","医嘱开始日期","医嘱开始时间","停止日期","停止时间","停止医嘱人代码","停止医嘱人描述","皮试标识","加急标识","父医嘱ID","条码号","材料条码号","价钱","规格","标本代码","院区代码")

	set:fromDate'="" fromDate=$zdh(fromDate,3)
	set:fromDate'="" fromDate=fromDate-1
	set:endDate'="" endDate=$zdh(endDate,3)
	
	for  set fromDate=$o(^OEORDi(0,"ItemDate",fromDate)) q:fromDate=""  d
	.Quit:((endDate'="")&&(fromDate>endDate))
	.set ord = "0" for  set ord=$o(^OEORDi(0,"ItemDate",fromDate,ord)) q:ord=""  d		
	..set admRowId=$p($g(^OEORD(ord)),"^",1)
	..Quit:admRowId=""
	..set HospitalCode=""
	..set CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	..if CurrentDetpRowID'="" d	
	...set hopitalId=$p($g(^CTLOC(CurrentDetpRowID)),"^",22)
	...Quit:hopitalId=""
	...set HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
		
	..set sub = "0" for  set sub=$o(^OEORDi(0,"ItemDate",fromDate,ord,sub)) q:sub=""  d
	...set ordstr1 = $g(^OEORD(ord,"I",sub,1))
	...set ordstr2 = $g(^OEORD(ord,"I",sub,2))
	...set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	...set ordstr7 = $g(^OEORD(ord,"I",sub,7))
	...set ordstr9 = $g(^OEORD(ord,"I",sub,9))
    ...set arcimId = $P(ordstr1,"^",2)
    ...set arcSub = $P(arcimId,"||",1)
    ...set arcVer = $P(arcimId,"||",2)
	...set OEORIOrderItemID=ord_"||"_sub
	...set OEORIOEORIDR=""
	...set (OEORIARCItmMastCode,OEORIARCItmMastDesc,OrdSubCatRowID,pHCDFRowID)=""
	...if arcimId'=""  d
	....set OEORIARCItmMastCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	....set OEORIARCItmMastDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
    ....set OrdSubCatRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
	....set pHCDFRowID = $p($g(^ARCIM(arcSub,arcVer,1)),"^",12)
	...set ordTypeRowID = $P(ordstr1,"^",8)
	...set (OEORIPriorityCode,OEORIPriorityDesc)=""
	...if ordTypeRowID'="" d
	....set OEORIPriorityCode=$P($g(^OECPR(ordTypeRowID)),"^",1)
	....set OEORIPriorityDesc=$P($g(^OECPR(ordTypeRowID)),"^",2)
    ...set ordStatusRowID = $P(ordstr1,"^",13)   
    ...set (OEORIStatusCode,OEORIStatusDesc)=""
    ...if ordStatusRowID'="" d
	....set OEORIStatusCode=$p($g(^OEC("OSTAT",ordStatusRowID)),"^",1)
	....set OEORIStatusDesc=$p($g(^OEC("OSTAT",ordStatusRowID)),"^",2)
    ...if (OrdSubCatRowID '= "") d
    ....//医嘱大类信息
	....set OrdCatRowID = $p($g(^ARC("IC",OrdSubCatRowID)),"^",8)
	....set (OEORIClass,OEORIClassDesc)=""
    ....if (OrdCatRowID '= "")  d
    .....set OEORIClass = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",1)
	.....set OEORIClassDesc = $p($g(^OEC("ORCAT",OrdCatRowID)),"^",2)  
	...set OEORIPrescNo=$p(ordstr1,"^",14)	
	...set (OEORIDoseFormsCode,OEORIDoseFormsDesc)=""
	...if pHCDFRowID'="" d
	....set formId=$p($g(^PHCD(+pHCDFRowID,"DF",$p(pHCDFRowID,"||",2),1)),"^",1)
	....if formId'="" d
	.....set OEORIDoseFormsCode=$p($g(^PHCF(formId)),"^",1)
	.....set OEORIDoseFormsDesc=$p($g(^PHCF(formId)),"^",2)
    ...set OEORIDoseQty=$p(ordstr2,"^",1)
    ...set OEORIDoseQty=$tr(OEORIDoseQty,"/","")
	...set dosageUnitRowID = $P(ordstr2,"^",3)
	...set (OEORIDoseUnitCode,OEORIDoseUnitDesc)=""
	...if ((dosageUnitRowID'="")&&(dosageUnitRowID'=0)) d
	....set OEORIDoseUnitCode=$p($g(^CT("UOM",dosageUnitRowID)),"^",1)
	....set OEORIDoseUnitDesc=$p($g(^CT("UOM",dosageUnitRowID)),"^",2)
	...set freqRowID = $P(ordstr2,"^",4)
	...set (OEORIFreqCode,OEORIFreqDesc)=""
	...if freqRowID'="" d
	....set OEORIFreqCode=$P($g(^PHCFR(freqRowID)),"^",1)
	....set OEORIFreqDesc=$P($g(^PHCFR(freqRowID)),"^",4)
	...set (OEORIInstrCode,OEORIInstrDesc)=""
	...set instrID=$p(ordstr2,"^",7)
	...if ((instrID'="")&&(instrID'=0)) d
	....set OEORIInstrCode=$p($g(^PHCIN(instrID)),"^",1)
	....set OEORIInstrDesc=$p($g(^PHCIN(instrID)),"^",2)
	...set useDaysRowID = $P(ordstr2,"^",6)
	...set (OEORIDurationCode,OEORIDurationDesc)=""
	...if useDaysRowID'="" d
	....set OEORIDurationCode=$P($g(^PHCDU(useDaysRowID)),"^",1)
	....set OEORIDurationDesc=$P($g(^PHCDU(useDaysRowID)),"^",3)
	...set OEORIOrderQty=$p(ordstr9,"^",4)
	...if OEORIOrderQty="" d
	....set OEORIOrderQty=0
	
	...set OEORIResultStatus=$p(ordstr1,"^",5)
	...set (OEORIResultStatusCode,OEORIResultStatusDesc)=""
	...if OEORIResultStatus'="" d
	....set resultStatusRowId=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(OEORIResultStatus),""))
	....set OEORIResultStatusCode=OEORIResultStatus
	....set:resultStatusRowId'="" OEORIResultStatusDesc=$p($g(^OEC("RESST",resultStatusRowId)),"^",2)
	...set OEORIRemarks=$g(^OEORD(ord,"I",sub,"DEP",1))
	...set docRowID = $P(ordstr1,"^",11)
	...set (OEORIEnterDocCode,OEORIEnterDocDesc)=""
	...if docRowID'="" d
	....set userId=$o(^SSU("SSUSR",0,"CTPCP",docRowID,""))	
	....if userId'="" d
	.....set OEORIEnterDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	.....set OEORIEnterDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	
	...if OEORIEnterDocCode="" d
	....set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	....if AdmDoctorRowID'="" d
	.....set userId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoctorRowID,""))
	.....set:userId'="" OEORIEnterDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	.....set:userId'="" OEORIEnterDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	
	...set verifyDate = $P(ordstr3,"^",7)
	...set:verifyDate'="" verifyDate=$ZD(verifyDate,3)
	...set verifyTime = $P(ordstr1,"^",17)
	...set:verifyTime'="" verifyTime=$ZT(verifyTime)
	...set appDeptRowID = $P(ordstr7,"^",2)
	...set (OEORIEnterDeptCode,OEORIEnterDeptDesc)=""
	...if appDeptRowID'="" d
	....set OEORIEnterDeptCode=$p($g(^CTLOC(appDeptRowID)),"^",1)
	....set OEORIEnterDeptDesc=$p($g(^CTLOC(appDeptRowID)),"^",2)
	...else  d
	....set CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	....if CurrentDetpRowID'="" d
	.....set OEORIEnterDeptCode=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	.....set OEORIEnterDeptDesc=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	
	...set recDeptRowID = $P(ordstr3,"^",6)
	...set (OEORIExecDeptCode,OEORIExecDeptDesc)=""
	...if recDeptRowID'="" d
	....set OEORIExecDeptCode=$p($g(^CTLOC(recDeptRowID)),"^",1)
	....set OEORIExecDeptDesc=$p($g(^CTLOC(recDeptRowID)),"^",2)
	...set startDate = $P(ordstr1,"^",9)
	...set:startDate'="" startDate=$ZD(startDate,3)
    ...set startTime = $P(ordstr1,"^",10)
	...set:startTime'="" startTime=$ZT(startTime)
	...set stopDate=$p(ordstr3,"^",34)
	...set:stopDate'="" stopDate=$ZD(stopDate,3)
	...set stopTime=$p(ordstr2,"^",15)
	...set:stopTime'="" stopTime=$ZT(stopTime)
	...set stopDocId=$p($g(^OEORD(ord,"I",sub,3)),"^",29)
	...set (OEORIStopDocCode,OEORIStopDocDesc)=""
	...if stopDocId'="" d
	....set userId=$o(^SSU("SSUSR",0,"CTPCP",stopDocId,""))	
	....if userId'="" d
	.....set OEORIStopDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	.....set OEORIStopDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	...set OEORIIsSkinTest=$p($g(^OEORD(ord,"I",sub,5)),"^",2)
	...set OEORIISEmergency=$p($g(^OEORD(ord,"I",sub,11)),"^",55)
	...set OEORIParentOrderID=$p($g(^OEORD(ord,"I",sub,11)),"^",39)
	...set OEORISpecimenID=$p(ordstr3,"^",20)	
	.../// 高值耗材条码信息，目前不知如何获取
	...set MaterialBarcode=$p($g(^OEORD(ord,"I",sub,"DHC")),"^",14)  //add by lipan
	...set OEORIPrice=..GetPrice(OEORIOrderItemID)
	...set OEORISpecification=..GetSpec(arcimId)
	...set OEORISpecimenCode=..GetSpecName(OEORIOrderItemID)
	...set ^ExportHistoryData("OEOrdItem",OEORIOrderItemID)=$lb(admRowId,OEORIOrderItemID,OEORIOEORIDR,OEORIARCItmMastCode,OEORIARCItmMastDesc,OEORIPriorityCode,OEORIPriorityDesc,OEORIStatusCode,OEORIStatusDesc,OEORIClass,OEORIClassDesc,OEORIPrescNo,OEORIDoseFormsCode,OEORIDoseFormsDesc,OEORIDoseQty,OEORIDoseUnitCode,OEORIDoseUnitDesc,OEORIFreqCode,OEORIFreqDesc,OEORIInstrCode,OEORIInstrDesc,OEORIDurationCode,OEORIDurationDesc,OEORIOrderQty,OEORIResultStatusCode,OEORIResultStatusDesc,OEORIRemarks,OEORIEnterDocCode,OEORIEnterDocDesc,verifyDate,verifyTime,OEORIEnterDeptCode,OEORIEnterDeptDesc,OEORIExecDeptCode,OEORIExecDeptDesc,startDate,startTime,stopDate,stopTime,OEORIStopDocCode,OEORIStopDocDesc,OEORIIsSkinTest,OEORIISEmergency,OEORIParentOrderID,OEORISpecimenID,MaterialBarcode,OEORIPrice,OEORISpecification,OEORISpecimenCode,HospitalCode)
	...set i=i+1
	set ^ExportHistoryData("OEOrdItemResult")=i
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	Quit i
Exception
	Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).GetSpec("9325||1")
ClassMethod GetSpec(arcim As %String) As %String
{
	set $zt="Exception"
	set arcim=+arcim	q:arcim<1 ""
	set inci=$o(^INCI(0,"ARCIM_DR",arcim,""))
	q:inci="" ""
	set inci=+inci
	//***规格取法一
	set info=$O(^DHCITMINFO(0,"INCI",inci,"")) q:info="" ""
	set spec=$p($g(^DHCITMINFO(info)),"^",27)
	q spec
Exception
	Quit "获取规格信息有误"
}

/// 获取医嘱价格
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrder).GetPrice("1629||28")
ClassMethod GetPrice(rowid As %String) As %String
{
	set $zt="Exception"
    set EpissubtypeDR=""
    set tempRowid=##class(web.DHCENS.STBLL.UTIL.Common).ReplaceStr(rowid,"_","||")
    set tmpAdm=$p($g(^OEORD(+tempRowid)),"^",1)
    set EpissubtypeDR=$P($g(^PAADM(tmpAdm,1)),"^",6)
       
    // 取子医嘱中医嘱价格，当医嘱类型的子类是Price时，取医嘱表中OEORI_Price中价格，
    // 然后调用计费组方法set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
    set childIndex="",childOrdPrice=0
    set ord=+rowid
    set arcimId = $P($g(^OEORD(ord,"I",$p(rowid,"||",2),1)),"^",2)
    set arcSub = $P(arcimId,"||",1)
    set arcVer = $P(arcimId,"||",2)
    
    
    f  s childIndex=$o(^OEORDi(0,"OEORI",ord,tempRowid,childIndex))  q:childIndex=""  d
	.set childordstr1 = $g(^OEORD(ord,"I",childIndex,1))
	.set childordstr3 = $g(^OEORD(ord,"I",childIndex,3))
	.set childarcimId = $P(childordstr1,"^",2)
	.set ItmMastFirst=$p(childarcimId,"||",1)
	.set ItmMastLast=$p(childarcimId,"||",2)
	.set ItemCatRowID=$p($g(^ARCIM(ItmMastFirst,ItmMastLast,1)),"^",10)
	
    
	.set ItmCatType=$p($g(^ARC("IC",ItemCatRowID)),"^",7)
	.set tmpchild=0
	.i ItmCatType="P" d
	..set tmpchild=##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",childarcimId,$P(childordstr3,"^",7),"","","",$p(childordstr3,"^",25))
	.set childOrdPrice=+childOrdPrice++($P(tmpchild,"^",1))
	
	set OrdSubCatRowID=$p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
    //取父医嘱价格信息，方式同取子医嘱类方法相同
	set CatType=$p($g(^ARC("IC",OrdSubCatRowID)),"^",7)
	set tmpPrice=""
	set VerifyDate=$P($g(^OEORD(ord,"I",$p(rowid,"||",2),3)),"^",7)
	if (CatType="P") {
		s tmpPrice=$p(ordstr3,"^",25)
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","",+tmpPrice)
	}
	else {
    	set price = ##CLASS(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeDR,"",arcimId,VerifyDate,"","","","")
	}
    set TotalPrice=childOrdPrice+price
    Quit TotalPrice
Exception
	Quit "价格异常"
}

ClassMethod GetSpecName(oerowid) As %String
{
	s OrdId=$p(oerowid,"||",1)
	s SubId=$p(oerowid,"||",2)
	s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	s (SpecCode,SpecName)=""
	i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
	i $l(SpecCode), $d(^TTAB("SPEC",SpecCode)){
		s SpecName=$p($g(^TTAB("SPEC",SpecCode)),"\",1)
	}
	q SpecCode
}

/// w ##class(web.DHCENS.STBLL.UTIL.ExportHistoryData).PAAllergyInfo("","")
ClassMethod PAAllergyInfo(startDate As %String, endDate As %String) As %String
{
	set i=0
	set:startDate'="" startDate=$zdh(startDate,3)
	set:endDate'="" endDate=$zdh(endDate,3)
	set ^ExportHistoryData("PAAllergy")=$lb("过敏记录ID","病人登记号","就诊号码","过敏源描述","过敏类别代码","过敏类别描述","过敏反应描述","严重级别","发病日期","状态","最后更新日期","最后更新时间","最后更新人编码")
	set patRowId="0"  for  set patRowId=$o(^PAPER(patRowId))  q:patRowId=""  d
	.set UpdateDate=$p($g(^PAPER(patRowId,"PER",5)),"^",2)
	.Quit:((startDate'="")&&(startDate>UpdateDate))
	.Quit:((endDate'="")&&(endDate<UpdateDate))
	.set allId="0"  for  set allId=$o(^PAPER(patRowId,"ALG",allId))  q:allId=""  d
	..set allergyInfo=$g(^PAPER(patRowId,"ALG",allId))
	..set AllTypeDR=$p(allergyInfo,"^",29)
	..set PAALLCategoryCode="",PAALLCategoryDesc=""
	..if AllTypeDR'="" d
	...set AllTypeInfo=^MRC("AT",AllTypeDR)
	...set PAALLCategoryCode=$p(AllTypeInfo,"^",1)
	...set PAALLCategoryDesc=$p(AllTypeInfo,"^",2)
	..set PAALLAllergyID=patRowId_"||"_allId
	..set PAALLPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)	
	..set PAALLReactionDesc=$p(allergyInfo,"^",6)
	..set PAALLSeverityCode=""
	..set PHCGEDR=$p(allergyInfo,"^",4)
	..set sourceDesc=""
	..if PHCGEDR'="" d
	...set sourceDesc=$p($g(^PHCGE("GE",PHCGEDR)),"^",2)
	..set TypeDR=$p(allergyInfo,"^",9)
	..if TypeDR'="" d
	...set sourceDesc=$p($g(^PAC("ALG",TypeDR)),"^",2)
	..set PHCDMDR=$p(allergyInfo,"^",27)
	..if PHCDMDR'="" d
	...set sourceDesc=$p($g(^PHCD(PHCDMDR,1)),"^",2)
	..set PAALLSourceDesc=sourceDesc
	..set updateDate=$p(allergyInfo,"^",23)
	..set:updateDate'="" updateDate=$zd(updateDate,3)
	..set updateTime=$p(allergyInfo,"^",24)
	..set:updateTime'="" updateTime=$zt(updateDate,1)
	..set PAALLUpdateUserCode=$p($g(^SSU("SSUSR",$p(allergyInfo,"^",16))),"^",1)
	..set PAALLVisitNumber=""
	..set PAALLStatus=""
	..set PAALLDate=""
	..set ^ExportHistoryData("PAAllergy",PAALLAllergyID)=$lb(PAALLAllergyID,PAALLPatientID,PAALLVisitNumber,PAALLSourceDesc,PAALLCategoryCode,PAALLCategoryDesc,PAALLReactionDesc,PAALLSeverityCode,PAALLDate,PAALLStatus,updateDate,updateTime,PAALLUpdateUserCode)
	..set i=i+1
	set ^ExportHistoryData("PAAllergyResult")=i
	Quit i
Exception
	Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.UTIL.ExportHistoryData).LISReportResult("2016-10-01","2016-11-01")
ClassMethod LISReportResult(startDate As %String, endDate As %String) As %String
{
	set $zt="Exception"
	set i=0
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	set:startDate'="" startDate=$zdh(startDate,3)
	set:startDate'="" startDate=startDate-1
	set:endDate'="" endDate=$zdh(endDate,3)
	set ^ExportHistoryData("LISReportResult")=$lb("条码号","报告ID","医嘱号","标本代码","标本名称","采集日期","采集时间","接收日期","接收时间","接收者代码","接收者名称","检验人代码","检验者名称","检验日期","检验时间","审核日期","审核时间","审核者代码","审核者名称","报告日期","报告时间","报告人代码","报告人名称","打印标记","仪器代码","仪器名称","报告科室代码","报告科室名称","院区编码")
	set ^ExportHistoryData("LISItemResult")=$lb("检验项目代码","检验项目名称","结果","缩写","单位","范围","高低标识","警告标识","检测仪器","序号","药敏结果")
	set ^ExportHistoryData("LISItemSenResult")=$lb("抗生素代码","抗生素名称","耐药性代码","耐药性描述","激活标志","MIC值","MM值")

	set LabNo=""  f  set LabNo=$O(^OEORD(0,"EpisNo",LabNo)) q:LabNo=""  d
	.set OEORDRowId=""  f  set OEORDRowId=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId)) q:OEORDRowId=""  d		
	..set admRowId=$p($g(^OEORD(OEORDRowId)),"^",1)	
	..set HospitalCode=""
	..set CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	..if CurrentDetpRowID'="" d	
	...set hopitalId=$p($g(^CTLOC(CurrentDetpRowID)),"^",22)
	...Quit:hopitalId=""
	...set HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	
	..set OEORIChildsub="" f  set OEORIChildsub=$O(^OEORD(0,"EpisNo",LabNo,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...// 医嘱ID
	...set OrdRowId=OEORDRowId_"||"_OEORIChildsub
	...// 医嘱日期
	...set veriDate=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
	...Quit:((startDate'="")&&(startDate>veriDate))
	...Quit:((endDate'="")&&(veriDate>endDate))
	...// 报告Id
	...set labRelatId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",35)
	...set labRelatId=$tr(labRelatId,$c(0),"")
	...set labTSCode=$p(labRelatId,"||",2)
    ...set labTSId=$p(labRelatId,"||",3)
	.../// 医嘱项Id  
	...set arcimRowId=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...set ReportDeptID=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...set ReportDeptCode="",ReportDeptDesc=""
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
	.../// 采集日期、采集时间
	...set CollectDate="",CollectTime=""
	...Quit:$P(labRelatId,"||",1)=""
	...set TSData=$g(^TEPI($P(labRelatId,"||",1),1,labTSCode,labTSId))
	...Quit:TSData=""
	...set CollectDate=$P(TSData,"\",44)
	...set CollectTime=$P(TSData,"\",45)     
	...set:(CollectDate'="") CollectDate=$ZD(CollectDate,3) 
	...set:(CollectTime'="") CollectTime=$ZT(CollectTime,1)		
	.../// 接收日期、接收时间  
	...Set ReceiveDate=$Piece(TSData,"\",21)  
	...Set:ReceiveDate'="" ReceiveDate=$ZD(ReceiveDate,3) 
	...Set ReceiveTime=$Piece(TSData,"\",22)  
	...Set:ReceiveTime'="" ReceiveTime=$ZT(ReceiveTime,1)  
	.../// 接收者代码、接收者名称
	...set ReceiveUserName=""
	...Set ReceiveUserCode=$Piece(TSData,"\",36) 
 	...If $Length(ReceiveUserCode) d
 	....set ReceiveRowID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(ReceiveUserCode),""))
 	....Set:ReceiveRowID'="" ReceiveUserName=$Piece($g(^SSU("SSUSR",ReceiveRowID)),"^",2) 
	.../// 检验者代码、检验者名称 
  	...set authorUserCode=$p(TSData,"\",3)
  	...set authorUserName=""
 	...if (authorUserCode'="") d
 	....set authorRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(authorUserCode),""))
 	....Set:authorRowId'="" authorUserName=$Piece($g(^SSU("SSUSR",authorRowId)),"^",2) 	
    .../// 检验日期、检验时间  
	...set authorDate=$zd($p(TSData,"\",1),3)
	...set authorTime=$zt($p(TSData,"\",2)*60)
	.../// 审核日期、审核时间  
	...Set CheckDate=$Piece(TSData,"\",4)  
	...Set:$Length(CheckDate) CheckDate=$ZD(CheckDate,3) 
	...Set CheckTime=$Piece(TSData,"\",5)  
	...Set:$Length(CheckTime) CheckTime=$ZT(CheckTime,1)  
	.../// 审核者代码、审核者名称
	...Set CheckUserCode=$Piece(TSData,"\",6)
	...Set CheckUserName=""
	...If $Length(CheckUserCode) d
 	....set CheckRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CheckUserCode),""))
	....Set:CheckRowId'="" CheckUserName=$Piece($g(^SSU("SSUSR",CheckRowId)),"^",2) 
	.../// 报告发布日期 
	...set reportDate=$P(TSData,"\",4)
	...set:reportDate'="" reportDate=$ZD(reportDate,3)
	.../// 报告发布时间
	...set reportTime=$P(TSData,"\",5)
	...set:reportTime'="" reportTime=$ZT(reportTime)	
	.../// 报告医生
	...set reportUserCode=$P(TSData,"\",6)
	...set reportUserName=""
	...if (reportUserCode'="") d
 	....set reportUserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(reportUserCode),""))
	....set:reportUserRowId'="" reportUserName=$p($g(^SSU("SSUSR",reportUserRowId)),"^",2)	
	...// 仪器代码、仪器名称 
	...Set MachineCode=$Piece(^TEPI(LabNo,1,labTSCode,labTSId),"\",27)  
	...set MachineName=""
	...If $Length(MachineCode) Set MachineName=$Piece($g(^TMIF(MachineCode)),"\",1)  
    .../// 打印标记
	...set printflag=$p(TSData,"\",28) 
	...if reportDate'=""  d
	....set tSC=..LISItemResult(LabNo,labTSCode,labTSId)
	...set ^ExportHistoryData("LISReportResult",LabNo,OrdRowId)=$lb(LabNo,labRelatId,OrdRowId,labSpecCode,labSpecName,CollectDate,CollectTime,ReceiveDate,ReceiveTime,ReceiveUserCode,ReceiveUserName,authorUserCode,authorUserName,authorDate,authorTime,CheckDate,CheckTime,CheckUserCode,CheckUserName,reportDate,reportTime,reportUserCode,reportUserName,printflag,MachineCode,MachineName,ReportDeptCode,ReportDeptDesc,HospitalCode)
	...set i=i+1	
	
	set ^ExportHistoryData("LISReportResultResult")=i
	Quit i
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

ClassMethod LISItemResult(labNo As %String, labTSCode As %String, labTSId As %String) As %String
{
	set $zt="Exception"	
	
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
	.if (serialNo="") d		
 	..if $d(^TTAB("TC",itemCode,1,labTSCode)) d
 	...set itemOrder=$p($g(^TTAB("TC",itemCode,1,labTSCode)),"\",1)
 	...Quit:itemOrder=""
 	...set layOrder=$p($g(^TTAB("TC",itemCode,1,labTSCode)),"\",2)
 	...Quit:layOrder=""
  	...Quit:$G(^TTAB("TS",labTSCode,layOrder,itemOrder))=""  	
  	.../// 检验结果项目序号
 	...set serialNo=$p(^TTAB("TS",labTSCode,layOrder,itemOrder),"\",15) 
	.if AntResFlag=1 d
	..set tSC=..LISItemSenResult(labNo,labTSCode,labTSId,itemCode)
	.set ^ExportHistoryData("LISItemResult",labNo,labTSCode,labTSId,itemCode)=$lb(itemCode,itemDesc,resultValue,abbreviation,unit,naturalRange,flagUpDown,warnFlag,TestMethodDesc,serialNo,AntResFlag)
	Quit "0^成功"
Exception
	set ^ExportHistoryData("LISItemResult","Error",labNo,labTSCode,labTSId)="-1^"_$ze
	Quit "-1^"_$ze
}

ClassMethod LISItemSenResult(labNo As %String, labTSCode As %String, labTSId As %String, itemCode As %String) As %String
{
	set $zt="Exception"	
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
	.set ^ExportHistoryData("LISItemSenResult",labNo,labTSCode,labTSId,itemCode,ant)=$lb(ant,antname,temresCode,temresDesc,temreport,temmic,temmm)
	
	Quit "0^成功"
Exception
	set ^ExportHistoryData("LISItemSenResult","Error",labNo,labTSCode,labTSId,itemCode)="-1^"_$ze
	Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.UTIL.ExportHistoryData).RISReport("2016-01-01","2016-12-01")
ClassMethod RISReport(startDate As %String, endDate As %String) As %String
{
	set $zt="Exception"
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	set ^ExportHistoryData("RISReport")=$lb("检查号","报告号","报告状态代码","报告状态描述","报告医生代码","报告医生名称","报告日期","报告时间","审核医生代码","审核医生描述","审核日期","审核时间","检查方法","录入者","检查所见(镜下)","检查结果描述","备注","肉眼所见","院区代码")
	set ^ExportHistoryData("RISOrder")=$lb("检查号","医嘱号","检查部位代码","检查部位名称","院区代码")
	set i=0,j=0,k=0,m=0,n=0
	
	set:startDate'="" startDate=$zdh(startDate,3)
	set:endDate'="" endDate=$zdh(endDate,3)

	set StudyNo="" for  set StudyNo=$o(^DHCPACRegInfoi("StudyNo",StudyNo)) q:StudyNo=""  d
	.set regId="" for  set regId=$o(^DHCPACRegInfoi("StudyNo",StudyNo,regId)) q:regId=""  d
	..set OEORIDR=$p(^DHCPACRegInfo(regId),"^",11)
		
	..set admRowId=$p($g(^OEORD(+OEORIDR)),"^",1)	
	..set HospitalCode=""
	..set CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	..if CurrentDetpRowID'="" d	
	...set hopitalId=$p($g(^CTLOC(CurrentDetpRowID)),"^",22)
	...Quit:hopitalId=""
	...set HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	
	..set regDate=$p(^DHCPACRegInfo(regId),"^",8)
	..Quit:((startDate'="")&&(startDate>regDate))
	..Quit:((endDate'="")&&(regDate>endDate))
	..set bodyFlag=0
	..set childId="" for  set childId=$o(^DHCPACRegInfoBD("BODYPARTS",0,regId,childId)) q:childId=""  d
	...// User.DHCAppPart 检查部位字典表
	...set bodyPartInfo=$g(^DHCPACRegInfoBD("BODYPARTS",0,regId,childId))
	...set RISRPositionCode=$p(bodyPartInfo,"^",2)
	...Quit:RISRPositionCode=""
	...set RISRPositionDesc=$p(bodyPartInfo,"^",3)
	...set ^ExportHistoryData("RISOrder",StudyNo,OEORIDR,RISRPositionCode)=$lb(StudyNo,OEORIDR,RISRPositionCode,RISRPositionDesc,HospitalCode)
	...set bodyFlag=1
	..if bodyFlag=0  d
	...set ^ExportHistoryData("RISOrder",StudyNo,OEORIDR)=$lb(StudyNo,OEORIDR,,,HospitalCode)
	.Quit:$d(^ExportHistoryData("RISOrder",StudyNo))=0
	.set resInfo =""
	.set rowid=0 for  set rowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,rowid)) q:(rowid="")  d
	..// 报告号
	..set ReportID=$p(^DHCRBStudy("Report",rowid),"^",2)
	..// 报告状态
	..set statusDR=$p(^DHCRBStudy("Report",rowid),"^",4)
	..set statusCode="",statusDesc=""
	..if statusCode'="" d
	...set statusCode=$p(^DHCRBCStatus(statusDR),1)
	...set statusDesc=$p(^DHCRBCStatus(statusDR),2)
	..// 报告医生 
	..set ReportDocDR=$p(^DHCRBStudy("Report",rowid),"^",8)
	..set (ReportDocCode,ReportDocName)=""
	..If $Length(ReportDocDR) d
 	...set ReportDocCode=$Piece($g(^SSU("SSUSR",ReportDocDR)),"^",1) 
	...Set ReportDocName=$Piece($g(^SSU("SSUSR",ReportDocDR)),"^",2)
	..// 报告日期 报告时间
	..set ReportDate=$p(^DHCRBStudy("Report",rowid),"^",9)
	..set:ReportDate'="" ReportDate= $ZD(ReportDate,3)
	..set ReportTime=$p(^DHCRBStudy("Report",rowid),"^",10)
	..set:ReportTime'="" ReportTime= $ZT(ReportTime,1)	
	..// 审核医生   
	..set VerifyDocDR=$p(^DHCRBStudy("Report",rowid),"^",11)
	..set (VerifyDocCode,VerifyDocName)=""
	..If $Length(VerifyDocDR) d
 	...set VerifyDocCode=$Piece($g(^SSU("SSUSR",VerifyDocDR)),"^",1) 
	...Set VerifyDocName=$Piece($g(^SSU("SSUSR",VerifyDocDR)),"^",2) 
	..// 审核日期 
	..set VerifyDate=$p(^DHCRBStudy("Report",rowid),"^",12)
	..set:VerifyDate'="" VerifyDate= $ZD(VerifyDate,3)
	..set VerifyTime=$p(^DHCRBStudy("Report",rowid),"^",13)
	..set:VerifyTime'="" VerifyTime= $ZT(VerifyTime,1)	
	..// 检查方法 
	..set ExamMethod=$p(^DHCRBStudy("Report",rowid),"^",24)
	..// 录入者 20080610
	..set Typist = $p(^DHCRBStudy("Report",rowid),"^",26)
	 
	..set strExam="",strResult="",strRptMemo="",strSee=""
	..// 检查所见(镜下)
	..if $g(^DHCRBStudy("Report",rowid,"ExamDescEx"))'= "" d
	...set strExam=^DHCRBStudy("Report",rowid,"ExamDescEx")
	..// 检查结果描述
    ..if $g(^DHCRBStudy("Report",rowid,"ResultDescEx"))'= "" d
	...set strResult=^DHCRBStudy("Report",rowid,"ResultDescEx")
	..// 备注
	..if $g(^DHCRBStudy("Report",rowid,"MemoEx"))'= "" d
	...set strRptMemo=^DHCRBStudy("Report",rowid,"MemoEx")
	..// 肉眼所见
	..if $g(^DHCRBStudy("Report",rowid,"DRPT_SeeDesc"))'= "" d
	...set strSee=^DHCRBStudy("Report",rowid,"DRPT_SeeDesc")	
	..// 主诉
	..set strPatDepiction = $p(^DHCRBStudy("Report",rowid),"^",28)
	..// 术前用药
	..set strPerOPSLeechdom = $p(^DHCRBStudy("Report",rowid),"^",29)
	..// 活检部位
	..set strCheckBodyPart = $p(^DHCRBStudy("Report",rowid),"^",30)
	..// HP值
	..set strHP = $p(^DHCRBStudy("Report",rowid),"^",31)
	..// 建议
	..set strAdvice = $p(^DHCRBStudy("Report",rowid),"^",32)
	..// 病理诊断
	..set strAssay = $p(^DHCRBStudy("Report",rowid),"^",33)
	..set ^ExportHistoryData("RISReport",StudyNo)=$lb(StudyNo,rowid,statusCode,statusDesc,ReportDocCode,ReportDocName,ReportDate,ReportTime,VerifyDocCode,VerifyDocName,VerifyDate,VerifyTime,ExamMethod,Typist,strExam,strResult,strRptMemo,strSee,HospitalCode)
	.set i=i+1
	.set ^ExportHistoryData("RISReport")=i
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3),!
	
	Quit i
Exception
	Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.UTIL.ExportHistoryData).ExportDictInfo("")
ClassMethod ExportDictInfo()
{
	set sc1=##class(web.DHCENS.STBLL.DICT.METHOD.CTHospital).CTHospital("")
	set sc2=##class(web.DHCENS.STBLL.DICT.METHOD.CTAllergyCategory).CTAllergyCategory("")
	set sc3=##class(web.DHCENS.STBLL.DICT.METHOD.CTBedType).CTBedType()
	set sc4=##class(web.DHCENS.STBLL.DICT.METHOD.CTBodyArea).CTBodyArea("")
	set sc5=##class(web.DHCENS.STBLL.DICT.METHOD.CTCategory).CTCategory("")
	set sc6=##class(web.DHCENS.STBLL.DICT.METHOD.CTChildCategory).CTChildCategory("")
	set sc7=##class(web.DHCENS.STBLL.DICT.METHOD.CTProvince).CTProvince("")
	set sc8=##class(web.DHCENS.STBLL.DICT.METHOD.CTCity).CTCity("")
	set sc9=##class(web.DHCENS.STBLL.DICT.METHOD.CTCountry).CTCountry("")
	set sc10=##class(web.DHCENS.STBLL.DICT.METHOD.CTCounty).CTCounty("")
	set sc11=##class(web.DHCENS.STBLL.DICT.METHOD.CTDept).CTDept("")
	set sc12=##class(web.DHCENS.STBLL.DICT.METHOD.CTDiagnoseType).CTDiagnoseType("")
	set sc13=##class(web.DHCENS.STBLL.DICT.METHOD.CTDiagnose).CTDiagnose("")
	set sc14=##class(web.DHCENS.STBLL.DICT.METHOD.CTWard).CTWard()
	set sc15=##class(web.DHCENS.STBLL.DICT.METHOD.CTDischCondit).CTDischCondit("")
	set sc16=##class(web.DHCENS.STBLL.DICT.METHOD.CTDoseForms).CTDoseForms("")
	set sc17=##class(web.DHCENS.STBLL.DICT.METHOD.CTDoseUnit).CTDoseUnit("")
	set sc18=##class(web.DHCENS.STBLL.DICT.METHOD.CTDuration).CTDuration("")
	set sc19=##class(web.DHCENS.STBLL.DICT.METHOD.CTBed).CTBed("")
	set sc20=##class(web.DHCENS.STBLL.DICT.METHOD.CTFreq).CTFreq("")
	set sc21=##class(web.DHCENS.STBLL.DICT.METHOD.CTIdentifierType).CTIdentifierType("")
	set sc22=##class(web.DHCENS.STBLL.DICT.METHOD.CTInstr).CTInstr("")
	set sc23=##class(web.DHCENS.STBLL.DICT.METHOD.CTMarital).CTMarital("")
	set sc24=##class(web.DHCENS.STBLL.DICT.METHOD.CTNation).CTNation("")
	set sc25=##class(web.DHCENS.STBLL.DICT.METHOD.CTOccupation).CTOccupation("")
	set sc26=##class(web.DHCENS.STBLL.DICT.METHOD.CTOrderStatus).CTOrderStatus("")
	set sc27=##class(web.DHCENS.STBLL.DICT.METHOD.CTPriority).CTPriority("")
	set sc28=##class(web.DHCENS.STBLL.DICT.METHOD.CTRelation).CTRelation("")
	set sc29=##class(web.DHCENS.STBLL.DICT.METHOD.CTResultStatus).CTResultStatus("")
	set sc30=##class(web.DHCENS.STBLL.DICT.METHOD.CTRoom).CTCTRoom("")
	set sc31=##class(web.DHCENS.STBLL.DICT.METHOD.CTSex).CTSex("")
	set sc32=##class(web.DHCENS.STBLL.DICT.METHOD.CTSpecimen).CTSpecimen("")
	set sc33=##class(web.DHCENS.STBLL.DICT.METHOD.CTCareProv).CTCareProv("")
	set sc34=##class(web.DHCENS.STBLL.DICT.METHOD.CTARCItmMast).CTARCItmMast("")
	set sc45=##class(web.DHCENS.STBLL.DICT.METHOD.CTSpec).CTSpec("")
	set dictResult1=sc1_";"_sc2_";"_sc3_";"_sc4_";"_sc5
	set dictResult2=sc6_";"_sc7_";"_sc8_";"_sc9_";"_sc10
	set dictResult3=sc11_";"_sc12_";"_sc13_";"_sc14_";"_sc15
	set dictResult4=sc16_";"_sc17_";"_sc18_";"_sc19_";"_sc20
	set dictResult5=sc21_";"_sc22_";"_sc23_";"_sc24_";"_sc25
	set dictResult6=sc26_";"_sc27_";"_sc28_";"_sc29_";"_sc30
	set dictResult7=sc31_";"_sc32_";"_sc33_";"_sc34_";"_sc35
	set dictResult8=sc36_";"_sc37_";"_sc38_";"_sc39_";"_sc40
	set dictResult9=sc41_";"_sc42_";"_sc43_";"_sc44_";"_sc45
	set dictResult=dictResult1_";"_dictResult2_";"_dictResult3_";"_dictResult4_";"_dictResult5_";"_dictResult6_";"_dictResult7_";"_dictResult8_";"_dictResult9
	set ^ExportHistoryData("DictResult",$zd(+$h,3))=dictResult
}

}
