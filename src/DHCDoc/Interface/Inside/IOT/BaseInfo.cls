Class DHCDoc.Interface.Inside.IOT.BaseInfo Extends %RegisteredObject
{

/// creator:tanjishan
/// date:2019-09-09
/// desc:互联互通共享文档【1.3基本信息相关表】
/// input：	SttDate&EndDate[YYYY-MM-DD]  患者修改基本信息的update时间范围，没有索引的项目会比较慢【^PAPERi("UpdDate",{PAPER_UpdateDate},{PAPER_RowId})】
/// 		HOSPCode暂时没有使用，查询的是所有院区的数据
Query QueryBaseInfo(SttDate As %String, EndDate As %String, HOSPCode As %String) As %Query(ROWSPEC = "PatID:%String:患者ID,SexCode:%String:性别代码,SexDesc:%String:性别描述,MartialCode:%String:婚姻状况,MartialDesc:%String:婚姻描述,NationCode:%String:民族,NationDesc:%String:民族描述,CountryCode:%String:国籍,CountryDesc:%String:国籍描述,Occupation:%String:职业类别,OccupationDesc:%String:职业类别描述,BloodTypeABO:%String:ABO血型代码,BloodTypeABODesc:%String:ABO血型描述,BloodTypeRH:%String:Rh血型代码,BloodTypeRHDesc:%String:Rh血型描述,RelationCode:%String:家庭关系代码,RelationDesc:%String:家庭关系描述,HealthDocumentID:%String:城乡居民健康档案编号,HealthCardID:%String:居民健康卡号,MedicalID:%String:病案号,HomeAddress:%String:现住址完整住址,HomeProvinceCode:%String:现住址省代码,HomeProvince:%String:现住址省,HomeCityCode:%String:现住址市代码,HomeCity:%String:现住址市,HomeCountyCode:%String:现住址县代码,HomeCounty:%String:现住址县,HomeTownShip:%String:现住址乡,HomeStreetName:%String:现住址村,HomeHouseNumber:%String:现住址门牌号码,HomePostalCode:%String:现住址邮政编码,HouseAddress:%String:户口完整地址,HouseProvinceCode:%String:户口住址省代码,HouseProvince:%String:户口住址省,HouseCityCode:%String:户口住址市代码,HouseCity:%String:户口住址市,HouseCountyCode:%String:户口住址县代码,HouseCounty:%String:户口住址县,HouseTownShip:%String:户口住址乡,HouseStreetName:%String:户口住址村,HouseHouseNumber:%String:户口住址门牌号码,HousePostalCode:%String:户口住址邮政编码,BornAddress:%String:出生地完整地址,BornProvinceCode:%String:出生地省代码,BornProvince:%String:出生地省,BornCityCode:%String:出生地市代码,BornCity:%String:出生地市,BornCountyCode:%String:出生地县代码,BornCounty:%String:出生地县,BornPostalCode:%String:出生地邮政编码,NativeProvinceCode:%String:籍贯省代码,NativeProvince:%String:籍贯省,NativeCityCode:%String:籍贯市代码,NativeCity:%String:籍贯市,PhoneNumber:%String:电话号码,IdentifyNumber:%String:身份证号,IdentifyCode:%String:身份证件代码,IdentifyDesc:%String:身份证件描述,Name:%String:姓名,BirthDate:%String:出生日期,age:%String:年龄,CompanyName:%String:工作单位,CompanyPhone:%String:工作单位电话,CompanyAddress:%String:工作单位完整地址,CompanyProvinceCode:%String:工作单位地址省代码,CompanyCityCode:%String:工作单位地址市代码,CompanyCountyCode:%String:工作单位地址县代码,CompanyProvince:%String:工作单位地址省,CompanyCity:%String:工作单位地址市,CompanyCounty:%String:工作单位地址县,CompanyTownShip:%String:工作单位地址乡,CompanyStreetName:%String:工作单位地址村,CompanyHouseNumber:%String:工作单位地址门牌号码,CompanyPostalCode:%String:工作单位地址邮政编码,RelationName:%String:联系人姓名,RelationPhone:%String:联系人电话,RelationAddress:%String:联系人完整地址,RelationProvinceCode:%String:联系人地址省代码,RelationCityCode:%String:联系人地址市代码,RelationCountyCode:%String:联系人地址县代码,RelationProvince:%String:联系人地址省,RelationCity:%String:联系人地址市,RelationCounty:%String:联系人地址县,RelationTownShip:%String:联系人地址乡,RelationStreetName:%String:联系人地址村,RelationHouseNumber:%String:联系人地址门牌号码,RelationPostalCode:%String:联系人地址邮政编码,LevelCode:%String:学历代码,LevelDesc:%String:学历描述,HDSD0009028:%String:患者电子邮件地址") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.BaseInfo","QueryBaseInfo","2019-05-01","2019-09-10","")
ClassMethod QueryBaseInfoExecute(ByRef qHandle As %Binary, SttDate As %String, EndDate As %String, HOSPCode As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 1
	set qHandle = $lb(0,repid,0)
	s SttDate=$ZDH(SttDate,3)
	s EndDate=$ZDH(EndDate,3)
	if $D(^PAPERi("UpdDate")){
		for UpdateDate=SttDate:1:EndDate{
			s PatientID=0
			for {
				s PatientID=$O(^PAPERi("UpdDate",UpdateDate,PatientID))
				q:(PatientID="")
				d GetBaseInfoData(PatientID)
				
			}
		}
	}else{
		//没有相关索引时，遍历所有数据，比较慢
		s PatientID=0
		for {
			s PatientID=$O(^PAPER(PatientID))
			q:(PatientID="")
			continue:'$D(^PAPER(PatientID,"ALL"))
			s UpdateDate=$P(^PAPER(PatientID,"PER",5),"^",2)
			continue:(UpdateDate<SttDate)
			continue:(UpdateDate>EndDate)
			d GetBaseInfoData(PatientID)
			
		}
	}
	q $$$OK
GetBaseInfoData(PatientID)
	if (PatientID=""){
		Q
	}
	d ReSetBaseInfo
	s PatMasObj=##class(User.PAPatMas).%OpenId(PatientID,0)
	if '$ISOBJECT(PatMasObj) {
		q
	}
	//患者ID
	s PatID=PatientID
	s PersonObj=##class(User.PAPerson).%OpenId(PatientID,0)
	if $ISOBJECT(PatMasObj.PAPMISexDR){
		s SexObj=##class(User.CTSex).%OpenId(PatMasObj.PAPMISexDR.%Id(),0)
		if $ISOBJECT(SexObj) {
			//性别代码
			s SexCode=SexObj.CTSEXCode
			//性别描述
			s SexDesc=SexObj.CTSEXDesc
			do SexObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPERMaritalDR){
		s MaritalObj=##class(User.CTMarital).%OpenId(PersonObj.PAPERMaritalDR.%Id(),0)
		if $ISOBJECT(MaritalObj) {
			//婚姻状况
			s MartialCode=MaritalObj.CTMARCode
			//婚姻描述
			s MartialDesc=MaritalObj.CTMARDesc
			do MaritalObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPERNationDR){
		s NationObj=##class(User.CTNation).%OpenId(PersonObj.PAPERNationDR.%Id(),0)
		if $ISOBJECT(NationObj) {
			//民族
			s NationCode=NationObj.CTNATCode
			//民族描述
			s NationDesc=NationObj.CTNATDesc
			do NationObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPERCountryDR){
		s CTCountryObj=##class(User.CTCountry).%OpenId(PersonObj.PAPERCountryDR.%Id(),0)
		if $ISOBJECT(CTCountryObj) {
			//国籍
			s CountryCode=CTCountryObj.CTCOUCode
			//国籍描述
			s CountryDesc=CTCountryObj.CTCOUDesc
			do CTCountryObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPEROccupationDR){
		s CTOccupationObj=##class(User.CTOccupation).%OpenId(PersonObj.PAPEROccupationDR.%Id(),0)
		if $ISOBJECT(CTOccupationObj) {
			//职业类别
			s Occupation=CTOccupationObj.CTOCCCode
			//职业类别描述
			s OccupationDesc=CTOccupationObj.CTOCCDesc
			do CTOccupationObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPERBloodTypeDR){
		s PACBloodTypeObj=##class(User.PACBloodType).%OpenId(PersonObj.PAPERBloodTypeDR.%Id(),0)
		if $ISOBJECT(PACBloodTypeObj) {
			s OutputObj.PAPERBloodTypeCode=PACBloodTypeObj.BLDTCode
			s OutputObj.PAPERBloodTypeDesc=PACBloodTypeObj.BLDTDesc
			do PACBloodTypeObj.%Close()
		}
	}
	//ABO血型代码
	s BloodTypeABO=""
	//ABO血型描述
	s BloodTypeABODesc=""
	//Rh血型代码
	s BloodTypeRH=""
	//Rh血型描述
	s BloodTypeRHDesc=""
	if $ISOBJECT(PersonObj.PAPERCTRLTDR){
		s CTRelationObj=##class(User.CTRelation).%OpenId(PersonObj.PAPERCTRLTDR.%Id(),0)
		if $ISOBJECT(CTRelationObj) {
			//家庭关系代码
			s RelationCode=CTRelationObj.CTRLTCode
			//家庭关系描述
			s RelationDesc=CTRelationObj.CTRLTDesc
			do CTRelationObj.%Close()
		}
	}
	//城乡居民健康档案编号
	s HealthDocumentID=""
	//居民健康卡号
	s HealthCardID=""
	//病案号
	s MedicalID=PatMasObj.PAPMIMedicare
	if (MedicalID = ""){
		s MedicalID = ##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"")
	}
	if (PersonObj.PAPERStName.Count()>0){
		//现住址完整住址
		s HomeAddress=PersonObj.PAPERStName.GetAt(PersonObj.PAPERStName.Count())
	}
	if $ISOBJECT(PersonObj.PAPERCTProvinceDR){
		s CTProviceObj=##class(User.CTProvince).%OpenId(PersonObj.PAPERCTProvinceDR.%Id(),0)
		if $ISOBJECT(CTProviceObj) {
			//现住址省代码
			s HomeProvinceCode=CTProviceObj.PROVCode
			//现住址省
			s HomeProvince=CTProviceObj.PROVDesc
			do CTProviceObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPERCityCodeDR){
		s CTCityObj=##class(User.CTCity).%OpenId(PersonObj.PAPERCityCodeDR.%Id(),0)
		if $ISOBJECT(CTCityObj) {
			//现住址市代码
			s HomeCityCode=CTCityObj.CTCITCode
			//现住址市
			s HomeCity=CTCityObj.CTCITDesc
			do CTCityObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPERCityAreaDR){
		s CTCityAreaObj=##class(User.CTCityArea).%OpenId(PersonObj.PAPERCityAreaDR.%Id(),0)
		if $ISOBJECT(CTCityAreaObj) {
			//现住址县代码
			s HomeCountyCode=CTCityAreaObj.CITAREACode
			//现住址县
			s HomeCounty=CTCityAreaObj.CITAREADesc
			do CTCityAreaObj.%Close()
		}
	}
	//现住址乡
	s HomeTownShip=""
	//现住址村
	s HomeStreetName=""
	//现住址门牌号码
	s HomeHouseNumber=""
	s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",PatientID,0))
	if (DHCPersonID'=""){
		s DHCPersonObj=##class(User.DHCPerson).%OpenId(DHCPersonID,0)
		if $ISOBJECT(DHCPersonObj) {
			//现住址邮政编码
			s HomePostalCode=DHCPersonObj.PAPERComment2
			if (DHCPersonObj.PAPERHouseProvinceDR'=""){
				s CTProviceObj=##class(User.CTProvince).%OpenId(DHCPersonObj.PAPERHouseProvinceDR,0)
				if $ISOBJECT(CTProviceObj) {
					//户口住址省代码
					s HouseProvinceCode=CTProviceObj.PROVCode
					//户口住址省
					s HouseProvince=CTProviceObj.PROVDesc
					do CTProviceObj.%Close()
				}
			}
			if (DHCPersonObj.PAPERHouseCityDR'=""){
				s CTCityObj=##class(User.CTCity).%OpenId(DHCPersonObj.PAPERHouseCityDR,0)
				if $ISOBJECT(CTCityObj) {
					//户口住址市代码
					s HouseCityCode=CTCityObj.CTCITCode
					//户口住址市
					s HouseCity=CTCityObj.CTCITDesc
					do CTCityObj.%Close()
				}
			}
			if (DHCPersonObj.PAPERHouseAreaDR'=""){
				s CTCityAreaObj=##class(User.CTCityArea).%OpenId(DHCPersonObj.PAPERHouseAreaDR,0)
				if $ISOBJECT(CTCityAreaObj) {
					//户口住址县代码
					s HouseCountyCode=CTCityAreaObj.CITAREACode
					//户口住址县
					s HouseCounty=CTCityAreaObj.CITAREADesc
					do CTCityAreaObj.%Close()
				}
			}
			s PAPERHouseAddress=DHCPersonObj.PAPERHouseAddress
			//户口完整地址
			s HouseAddress=HouseProvince_HouseCity_HouseCounty_PAPERHouseAddress
			//户口住址邮政编码
			s HousePostalCode=DHCPersonObj.PAPERComment3
			
			
			if (DHCPersonObj.PAPERBirthProvinceDR'=""){
				s CTProviceObj=##class(User.CTProvince).%OpenId(DHCPersonObj.PAPERBirthProvinceDR,0)
				if $ISOBJECT(CTProviceObj) {
					//出生地省代码
					s BornProvinceCode=CTProviceObj.PROVCode
					//出生地省
					s BornProvince=CTProviceObj.PROVDesc
					do CTProviceObj.%Close()
				}
			}
			if (DHCPersonObj.PAPERBirthCityDR'=""){
				s CTCityObj=##class(User.CTCity).%OpenId(DHCPersonObj.PAPERBirthCityDR,0)
				if $ISOBJECT(CTCityObj) {
					//出生地市代码
					s BornCityCode=CTCityObj.CTCITCode
					//出生地市
					s BornCity=CTCityObj.CTCITDesc
					do CTCityObj.%Close()
				}
			}
			if (DHCPersonObj.PAPERBirthAreadr'=""){
				s CTCityAreaObj=##class(User.CTCityArea).%OpenId(DHCPersonObj.PAPERBirthAreadr,0)
				if $ISOBJECT(CTCityAreaObj) {
					//出生地县代码
					s BornCountyCode=CTCityAreaObj.CITAREACode
					//出生地县
					s BornCounty=CTCityAreaObj.CITAREADesc
					do CTCityAreaObj.%Close()
				}
			}
			s BirthAddress=DHCPersonObj.PAPERBirthAddress
			//出生地完整地址
			s BornAddress=BornProvince_BornCity_BornCounty_BirthAddress
			
			
			
			do DHCPersonObj.%Close()
		}
	}
	
	//户口住址乡
	s HouseTownShip=""
	//户口住址村
	s HouseStreetName=""
	//户口住址门牌号码
	s HouseHouseNumber=""
	//出生地邮政编码
	s BornPostalCode=""
	
	if $ISOBJECT(PersonObj.PAPERProvinceBirthDR){
		s CTProviceObj=##class(User.CTProvince).%OpenId(PersonObj.PAPERProvinceBirthDR.%Id(),0)
		if $ISOBJECT(CTProviceObj) {
			//籍贯省代码
			s NativeProvinceCode=CTProviceObj.PROVCode
			//籍贯省
			s NativeProvince=CTProviceObj.PROVDesc
			do CTProviceObj.%Close()
		}
	}
	if $ISOBJECT(PersonObj.PAPERCityBirthDR){
		s CTCityObj=##class(User.CTCity).%OpenId(PersonObj.PAPERCityBirthDR.%Id(),0)
		if $ISOBJECT(CTCityObj) {
			//籍贯市代码
			s NativeCityCode=CTCityObj.CTCITCode
			//籍贯市
			s NativeCity=CTCityObj.CTCITDesc
			do CTCityObj.%Close()
		}
	}
	//电话号码
	s PhoneNumber=PersonObj.PAPERTelH
	if $ISOBJECT(PatMasObj.PAPMICardTypeDR){
		s CardTypeObj=##class(User.PACCardType).%OpenId(PatMasObj.PAPMICardTypeDR.%Id(),0)
		if $ISOBJECT(CardTypeObj) {
			//身份证件代码
			s IdentifyCode=CardTypeObj.CARDCode
			//身份证件描述
			s IdentifyDesc=CardTypeObj.CARDDesc
			do CardTypeObj.%Close()
		}
	}
	//身份证号
	s IdentifyNumber=PatMasObj.PAPMIID
	if (IdentifyNumber=""){
		s IdentifyNumber=PatMasObj.PAPMIDVAnumber
	}
	//姓名
	s Name=PatMasObj.PAPMIName
	//出生日期
	s BirthDate=PatMasObj.PAPMIDOB
	//年龄
	s age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID)
	//工作单位
	s CompanyName=PatMasObj.PAPMISecondPhone
	//工作单位电话
	s CompanyPhone=PersonObj.PAPERTelO
	//工作单位完整地址
	s CompanyAddress=""
	//工作单位地址省代码
	s CompanyProvinceCode=""
	//工作单位地址市代码
	s CompanyCityCode=""
	//工作单位地址县代码
	s CompanyCountyCode=""
	//工作单位地址省
	s CompanyProvince=""
	//工作单位地址市
	s CompanyCity=""
	//工作单位地址县
	s CompanyCounty=""
	//工作单位地址乡
	s CompanyTownShip=""
	//工作单位地址村
	s CompanyStreetName=""
	//工作单位地址门牌号码
	s CompanyHouseNumber=""
	//工作单位地址邮政编码
	s CompanyPostalCode=""
	//联系人姓名
	s RelationName=PersonObj.PAPERForeignId
	//联系人电话
	s RelationPhone=PersonObj.PAPERForeignPhone
	//联系人完整地址
	s RelationAddress=PersonObj.PAPERForeignAddress
	//联系人地址省代码
	s RelationProvinceCode=""
	//联系人地址市代码
	s RelationCityCode=""
	//联系人地址县代码
	s RelationCountyCode=""
	//联系人地址省
	s RelationProvince=""
	//联系人地址市
	s RelationCity=""
	//联系人地址县
	s RelationCounty=""
	//联系人地址乡
	s RelationTownShip=""
	//联系人地址村
	s RelationStreetName=""
	//联系人地址门牌号码
	s RelationHouseNumber=""
	//联系人地址邮政编码
	s RelationPostalCode=""
	//学历代码
	s LevelCode=""
	//学历描述
	s LevelDesc=""
	//患者电子邮件地址
	s HDSD0009028=PersonObj.PAPEREmail
	if (HDSD0009028=""){
		s HDSD0009028=PersonObj.PAPEREmail2
	}
	do PersonObj.%Close()
	do PatMasObj.%Close()
	d OutputRowBaseInfo
	q
OutputRowBaseInfo
	Set Data=$LB(PatID,SexCode,SexDesc,MartialCode,MartialDesc,NationCode,NationDesc,CountryCode,CountryDesc,Occupation,OccupationDesc,BloodTypeABO,BloodTypeABODesc,BloodTypeRH,BloodTypeRHDesc,RelationCode,RelationDesc,HealthDocumentID,HealthCardID,MedicalID,HomeAddress,HomeProvinceCode,HomeProvince,HomeCityCode,HomeCity,HomeCountyCode,HomeCounty,HomeTownShip,HomeStreetName,HomeHouseNumber,HomePostalCode,HouseAddress,HouseProvinceCode,HouseProvince,HouseCityCode,HouseCity,HouseCountyCode,HouseCounty,HouseTownShip,HouseStreetName,HouseHouseNumber,HousePostalCode,BornAddress,BornProvinceCode,BornProvince,BornCityCode,BornCity,BornCountyCode,BornCounty,BornPostalCode,NativeProvinceCode,NativeProvince,NativeCityCode,NativeCity,PhoneNumber,IdentifyNumber,IdentifyCode,IdentifyDesc,Name,BirthDate,age,CompanyName,CompanyPhone,CompanyAddress,CompanyProvinceCode,CompanyCityCode,CompanyCountyCode,CompanyProvince,CompanyCity,CompanyCounty,CompanyTownShip,CompanyStreetName,CompanyHouseNumber,CompanyPostalCode,RelationName,RelationPhone,RelationAddress,RelationProvinceCode,RelationCityCode,RelationCountyCode,RelationProvince,RelationCity,RelationCounty,RelationTownShip,RelationStreetName,RelationHouseNumber,RelationPostalCode,LevelCode,LevelDesc,HDSD0009028)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
ReSetBaseInfo
	s (PatID,SexCode,SexDesc,MartialCode,MartialDesc,NationCode,NationDesc,CountryCode,CountryDesc,Occupation,OccupationDesc,BloodTypeABO,BloodTypeABODesc,BloodTypeRH,BloodTypeRHDesc,RelationCode,RelationDesc,HealthDocumentID,HealthCardID,MedicalID,HomeAddress,HomeProvinceCode,HomeProvince,HomeCityCode,HomeCity,HomeCountyCode,HomeCounty,HomeTownShip,HomeStreetName,HomeHouseNumber,HomePostalCode,HouseAddress,HouseProvinceCode,HouseProvince,HouseCityCode,HouseCity,HouseCountyCode,HouseCounty,HouseTownShip,HouseStreetName,HouseHouseNumber,HousePostalCode,BornAddress,BornProvinceCode,BornProvince,BornCityCode,BornCity,BornCountyCode,BornCounty,BornPostalCode,NativeProvinceCode,NativeProvince,NativeCityCode,NativeCity,PhoneNumber,IdentifyNumber,IdentifyCode,IdentifyDesc,Name,BirthDate,age,CompanyName,CompanyPhone,CompanyAddress,CompanyProvinceCode,CompanyCityCode,CompanyCountyCode,CompanyProvince,CompanyCity,CompanyCounty,CompanyTownShip,CompanyStreetName,CompanyHouseNumber,CompanyPostalCode,RelationName,RelationPhone,RelationAddress,RelationProvinceCode,RelationCityCode,RelationCountyCode,RelationProvince,RelationCity,RelationCounty,RelationTownShip,RelationStreetName,RelationHouseNumber,RelationPostalCode,LevelCode,LevelDesc,HDSD0009028)=""
	Quit
}

ClassMethod QueryBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBaseInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBaseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
