Class CHSSWeb.ChildBirthCertificateServices Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(communityCode As %String, start As %Integer, limit As %Integer, whereStr As %String) As %String
{
	     
		Set communityCode=$G(communityCode)

		Set start=$G(start)
		Set limit=$G(limit) 
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		
		s request = ##class(%Library.ResultSet).%New()
 
		s sqlStr = " SELECT p.BirthRowId,p.PersonRowIdParref,p.BirthCode,p.CardCode, "
		s sqlStr =sqlStr_" p.FamilyCode,p.Name,p.Sex,p.Sex->CTSEX_Desc,p.Birth,p.Province,p.City,p.District, p.TownShip,"
		s sqlStr =sqlStr_" p.Province->Description AS ProvinceName,p.City->Description AS CityName,p.District->Description AS DistrictName, p.TownShip->Description AS TownShipName,"
		s sqlStr =sqlStr_" p.GestationWeek,p.HealthStatus,p.HealthStatus->Description as HealthStatusName, "
		s sqlStr =sqlStr_" p.Weight,p.Height,p.MotherName,p.MotherAge,p.MotherCountry,p.MotherCountry->CTCOU_Desc as MotherCountryName, "
		s sqlStr =sqlStr_" p.MotherNation,p.MotherNation->CTNAT_Desc As MotherNationName,p.MohterId,p.MotherMt, "
		s sqlStr =sqlStr_" p.MotherEmail,p.FatherName,p.FatherAge,p.FatherCountry,p.FatherCountry->CTCOU_Desc as FatherCountryName, "
		s sqlStr =sqlStr_" p.FatherNation,p.FatherNation->CTNAT_Desc as FatherNationName,p.FatherId,p.FatherMt, "
		s sqlStr =sqlStr_" p.FatherEmail,p.Address,p.Tele,p.TypePlace,p.TypePlace->Description as TypePlaceName, "
		s sqlStr =sqlStr_" p.OtherTypePlaceName,p.ConstractName,p.OtherHospital,p.BirthInLocal,p.Accouche, "
		s sqlStr =sqlStr_" p.Discard,p.PrintTimes,p.HospitalCode,p.CommunityCode,p.CheckDate,p.CommitDate, "
		s sqlStr =sqlStr_" p.CommitOp,p.CommitFlag FROM CHSS.ChildBirthCertificate p,chss.PersonHealthRecordMain m  where p.PersonRowIdParref=m.personrowid and m.CommunityCode = '"_communityCode_"' "_whereStr 
		;w sqlStr
		d request.Prepare(sqlStr)
		d request.Execute() 
		While(request.Next())
		{
		
		s BirthRowId=request.Data("BirthRowId")
	   	s PersonRowIdParref=request.Data("PersonRowIdParref")
	   	s BirthCode=request.Data("BirthCode")
	   	s CardCode=request.Data("CardCode")
	   	s FamilyCode=request.Data("FamilyCode")
	   	s Name=request.Data("Name")
        S Sex=request.Data("Sex") 
	    S SexName = request.Data("CTSEX_Desc")
	   	s Birth=request.Data("Birth")
	   	i Birth '= "" d
		.s Birth = $zd(Birth,3)
		
	   	s Province=request.Data("Province")
	   	s City=request.Data("City")
	   	s District=request.Data("District")
	   	s TownShip=request.Data("TownShip")
	  
	    s ProvinceName=request.Data("ProvinceName")
	   	s CityName=request.Data("CityName")
	   	s DistrictName=request.Data("DistrictName")
	   	s TownShipName=request.Data("TownShipName")
	   	 	
	   	s GestationWeek=request.Data("GestationWeek")
	   	s HealthStatus=request.Data("HealthStatus")
	  	s HealthStatusName=request.Data("HealthStatusName")
	   	s Weight=request.Data("Weight")
	   	s Height=request.Data("Height")
	   	s MotherName=request.Data("MotherName")
	   	s MotherAge=request.Data("MotherAge")
	   	s MotherCountry=request.Data("MotherCountry")
	   	s MotherCountryName=request.Data("MotherCountryName")
	   	s MotherNation=request.Data("MotherNation")
	    s MotherNationName=request.Data("MotherNationName")
	   	s MohterId=request.Data("MohterId")
	   	s MotherMt=request.Data("MotherMt")
	   	s MotherEmail=request.Data("MotherEmail")
	   	s FatherName=request.Data("FatherName")
	   	s FatherAge=request.Data("FatherAge")
	   	s FatherCountry=request.Data("FatherCountry")
	   	s FatherCountryName=request.Data("FatherCountryName")
	   	s FatherNation=request.Data("FatherNation")
	   	s FatherNationName=request.Data("FatherNationName")
	   	s FatherId=request.Data("FatherId")
	   	s FatherMt=request.Data("FatherMt")
	   	s FatherEmail=request.Data("FatherEmail")
	   	s Address=request.Data("Address")
	   	s Tele=request.Data("Tele")
	   	s TypePlace=request.Data("TypePlace")
	   	s TypePlaceName=request.Data("TypePlaceName")
	   	s OtherTypePlaceName=request.Data("OtherTypePlaceName")
	   	s ConstractName=request.Data("ConstractName")
	   	s OtherHospital=request.Data("OtherHospital")
	   	s BirthInLocal=request.Data("BirthInLocal")
	   	s BirthInLocalName="否"
	   	i BirthInLocal="true" d
	   	 .s BirthInLocalName="是"
	   	s Accouche=request.Data("Accouche")
	   	s Discard=request.Data("Discard")
	  	s DiscardName="否"
	   	i Discard="true" d
	   	 .s DiscardName="是"
	   	s PrintTimes=request.Data("PrintTimes")
	   	s HospitalCode=request.Data("HospitalCode")
	   	s CommunityCode=request.Data("CommunityCode")
	   	s CheckDate=request.Data("CheckDate")
	   	s CommitDate=request.Data("CommitDate")
	   	s CommitOp=request.Data("CommitOp")
	   	s CommitFlag=request.Data("CommitFlag")
   	
   	
		 
	    Set tmp = BirthRowId_"^"_PersonRowIdParref_"^"_BirthCode_"^"_CardCode_"^"_FamilyCode_"^"_Name_"^"_Sex_"^"_SexName_"^"_Birth_"^"_Province_"^"_City_"^"_District_"^"_TownShip_"^"_ProvinceName_"^"_CityName_"^"_DistrictName_"^"_TownShipName_"^"_GestationWeek_"^"_HealthStatus_"^"_HealthStatusName_"^"_Weight_"^"_Height_"^"_MotherName_"^"_MotherAge_"^"_MotherCountry_"^"_MotherCountryName_"^"_MotherNation_"^"_MotherNationName_"^"_MohterId_"^"_MotherMt_"^"_MotherEmail_"^"_FatherName_"^"_FatherAge_"^"_FatherCountry_"^"_FatherCountryName_"^"_FatherNation_"^"_FatherNationName_"^"_FatherId_"^"_FatherMt_"^"_FatherEmail_"^"_Address_"^"_Tele_"^"_TypePlace_"^"_TypePlaceName_"^"_OtherTypePlaceName_"^"_ConstractName_"^"_OtherHospital_"^"_BirthInLocal_"^"_BirthInLocalName_"^"_Accouche_"^"_Discard_"^"_DiscardName_"^"_PrintTimes_"^"_HospitalCode_"^"_CommunityCode_"^"_CheckDate_"^"_CommitDate_"^"_CommitOp_"^"_CommitFlag
       
        ;w tmp
         
	    Set count=count+1
	    
		If (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		}
		
	    Set resultString = json.getJsonData("BirthRowId^PersonRowId^BirthCode^CardCode^FamilyCode^Name^Sex^SexName^Birth^Province^City^District^TownShip^ProvinceName^CityName^DistrictName^TownShipName^GestationWeek^HealthStatus^HealthStatusName^Weight^Height^MotherName^MotherAge^MotherCountry^MotherCountryName^MotherNation^MotherNationName^MohterId^MotherMt^MotherEmail^FatherName^FatherAge^FatherCountry^FatherCountryName^FatherNation^FatherNationName^FatherId^FatherMt^FatherEmail^Address^Tele^TypePlace^TypePlaceName^OtherTypePlaceName^ConstractName^OtherHospital^BirthInLocal^BirthInLocalName^Accouche^Discard^DiscardName^PrintTimes^HospitalCode^CommunityCode^CheckDate^CommitDate^CommitOp^CommitFlag",count)
	 	k json
	 	
		Quit resultString
}

ClassMethod existColumn(tableName As %String, ColumnName As %String, ColumnStr As %String, RecordType As %String, RowId As %Integer) As %String
{
	q:(ColumnStr = "") "0"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * from "_tableName_" where "_ColumnName_" = '"_ColumnStr_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = 1
	s tempRowId = ""
	
	s json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
		s tempRowId = result.Data("BirthRowId")
		s count = count+1
	}
	d result.Close()
	q:(count = 0) "0"
	if (RecordType = "add")
	{
		q:(count > 0) "1"
	}
	elseif (RecordType = "edit")
	{
		if (tempRowId '= RowId)
		{
			q "1"
		}
		else{
				q "0"
			}
		
	}
}

ClassMethod InsertOrUpdate(Action As %String, BirthRowId As %String, PersonRowIdParref As %String, BirthCode As %String, CardCode As %String, FamilyCode As %String, Name As %String, Sex As %String, Birth As %String, Province As %String, City As %String, District As %String, TownShip As %String, GestationWeek As %String, HealthStatus As %String, Weight As %String, Height As %String, MotherName As %String, MotherAge As %String, MotherCountry As %String, MotherNation As %String, MohterId As %String, MotherMt As %String, MotherEmail As %String, FatherName As %String, FatherAge As %String, FatherCountry As %String, FatherNation As %String, FatherId As %String, FatherMt As %String, FatherEmail As %String, Address As %String, Tele As %String, TypePlace As %String, OtherTypePlaceName As %String, ConstractName As %String, OtherHospital As %String, BirthInLocal As %String, Accouche As %String, Discard As %String, PrintTimes As %String, HospitalCode As %String, CommunityCode As %String, CheckDate As %String, CommitDate As %String, CommitOp As %String, CommitFlag As %String) As %String
{
   
  Set tempCheck=""
  i Action="add" d
  .Set tempCheck = ##class(CHSS.ChildBirthCertificate).%New()
    e  d   
   .Set tempCheck = ##class(CHSS.ChildBirthCertificate).%OpenId(BirthRowId)

	s tempCheck.PersonRowIdParref=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowIdParref)
	
	//判断出生证是否重复
	i Action="add" d
	.s ReturnCode= ..existColumn("CHSS.ChildBirthCertificate","BirthCode",BirthCode,Action,"")
	e  d
	.s ReturnCode= ..existColumn("CHSS.ChildBirthCertificate","BirthCode",BirthCode,Action,BirthRowId)
	i (ReturnCode'="0") d
	.w "{""success"":""false"",""info"":""出生证号码: "_BirthCode_" 已存在! 请重新输入!""}"
	q:(ReturnCode = "1") ""
	
	s tempCheck.BirthCode=BirthCode
  	s tempCheck.CardCode=CardCode
	s tempCheck.FamilyCode=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyCode)
	s tempCheck.Name=Name
	s tempCheck.Sex =##class(User.CTSex).%OpenId(Sex)	
	i Birth '= "" do
    .Set tempCheck.Birth = $zdh(Birth,3)
 
	s tempCheck.Province=##class(CHSS.DictProvince).%OpenId(Province)
	s tempCheck.City=##class(CHSS.DictCity).%OpenId(City)
	s tempCheck.District=##class(CHSS.DictSection).%OpenId(District)
	s tempCheck.TownShip=##class(CHSS.DictStreet).%OpenId(TownShip)
	
	
	s tempCheck.GestationWeek=GestationWeek
	s tempCheck.HealthStatus=##class(CHSS.DictHealthStatus).%OpenId(HealthStatus)	
	s tempCheck.Weight=Weight
	s tempCheck.Height=Height
	s tempCheck.MotherName=MotherName
	s tempCheck.MotherAge=MotherAge
	s tempCheck.MotherCountry =##class(User.CTCountry).%OpenId(MotherCountry)	
	s tempCheck.MotherNation =##class(User.CTNation).%OpenId(MotherNation)	
	s tempCheck.MohterId=MohterId
	s tempCheck.MotherMt=MotherMt
	s tempCheck.MotherEmail=MotherEmail
	s tempCheck.FatherName=FatherName
	s tempCheck.FatherAge=FatherAge
	s tempCheck.FatherCountry =##class(User.CTCountry).%OpenId(FatherCountry)	
	s tempCheck.FatherNation =##class(User.CTNation).%OpenId(FatherNation)	
	s tempCheck.FatherId=FatherId
	s tempCheck.FatherMt=FatherMt
	s tempCheck.FatherEmail=FatherEmail
	s tempCheck.Address=Address
	s tempCheck.Tele=Tele
	s tempCheck.TypePlace=##class(CHSS.DictBirthPlace).%OpenId(TypePlace)
	s tempCheck.OtherTypePlaceName=OtherTypePlaceName
	s tempCheck.ConstractName=ConstractName
	s tempCheck.OtherHospital=OtherHospital
	s tempCheck.BirthInLocal=BirthInLocal
	 s tempCheck.Accouche=Accouche
	s tempCheck.Discard=Discard
	s tempCheck.PrintTimes=PrintTimes
	s tempCheck.HospitalCode=HospitalCode
	s tempCheck.CommunityCode=CommunityCode
	s tempCheck.CheckDate=CheckDate
     i CommitDate '= "" do
    .Set tempCheck.CommitDate = $zdh(CommitDate,3) 
 	i CheckDate '= "" do
    .Set tempCheck.CheckDate = $zdh(CheckDate,3)
	s tempCheck.CommitOp=CommitOp
	s tempCheck.CommitFlag=CommitFlag  
	
	s result=""
    s result=tempCheck.%Save()
     
    i result = "1" d
    .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    
    q ""
}

ClassMethod Delete(BirthRowId As %String) As %String
{
	&sql(delete from CHSS.ChildBirthCertificate where BirthRowId= :BirthRowId)

  i SQLCODE = "0" d
    .w "{""success"":""true"",""info"":""数据删除成功！""}"
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    q ""
}

//用于默认状态下的全部检索

ClassMethod PersonList(communityCode As %String, start As %Integer, limit As %Integer) As %String
{
	 
		Set communityCode=$G(communityCode)
        
		Set start=$G(start)
		Set limit=$G(limit) 
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s rowcount = 0
		&SQL(select count(*) into rowcount from  CHSS.PersonHealthRecordMain where CommunityCode = :communityCode and isnull(PersonStatus,0) != 3 and PersonRowId not in (select PersonRowIdParref from chss.ChildBirthCertificate ) )
		Set CommunityCodeIndex = " "_communityCode
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex",CommunityCodeIndex,PersonRowId)) q:(PersonRowId="")!(count>end)  d
		.i ($d(^CHSS.ChildBirthCertificateI("PersonRowIdParrefIndex",PersonRowId))'="10")  d     
		..s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		..set PersonName = tempPerson.PersonName
		..set CommunityCode = tempPerson.CommunityCode
		..set SexDR = ""
		..set SexName = ""
		..i tempPerson.SexDR '= "" d
		...set SexDR = tempPerson.SexDR.%Id()
		...set SexName = tempPerson.SexDR.CTSEXDesc
		..set Birth = tempPerson.Birth
		..i Birth '= "" d
		...s Birth = $zd(Birth,3)
		 
		..set CardNumber = tempPerson.CardNumber
		..set LinkManPhone = tempPerson.LinkManPhone
		 
		..s FamilyCode = ""
		..s FamilyRowId = ""
		..i tempPerson.FamilyRowId '= "" d
		...s FamilyRowId = tempPerson.FamilyRowId.%Id()
		...s FamilyCode = tempPerson.FamilyRowId.FamilyCode
		 
		..;家庭地址
		..s FamilyAddress = ""
		..set ProvinceName = ""
		..set ProvinceDR = ""
		..set CityName=""
		..set CityDR=""
		..set SectionName=""
		..set SectionDR="" 
		..set StreetName=""
		..set StreetDR=""
		..set VillageName =""
		..set VillageDR =""
		 
		..i FamilyRowId '= "" d
		...s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		...i tempFamily.ProvinceDR '="" d
		.... s ProvinceDR = tempFamily.ProvinceDR.%Id()
		.... s ProvinceName = tempFamily.ProvinceDR.Description 
	    ....s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    
		...i tempFamily.CityDR '="" d
		.... s CityDR = tempFamily.CityDR.%Id()
		.... s CityName = tempFamily.CityDR.Description
		....s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
		 
		...i tempFamily.SectionDR '="" d
		.... s SectionDR = tempFamily.SectionDR.%Id()
		.... s SectionName = tempFamily.SectionDR.Description
		....s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
		
				 
		...i tempFamily.StreetDR '="" d
		.... s StreetDR=tempFamily.StreetDR.%Id()
		.... s StreetName = tempFamily.StreetDR.Description 
		....s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		 
		 
		...i tempFamily.VillageDR '="" d
		.... s VillageDR = tempFamily.VillageDR.%Id()
		.... s VillageName = tempFamily.VillageDR.Description
	    ....s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description		 
	    ...e  d
	    ....i tempFamily.DoorPlate '= "" d
	    .....s FamilyAddress = FamilyAddress_tempFamily.DoorPlate     
		 
		..s PersonOtherRowId = 0
		..s FatherName = ""
		..s MotherName =""
		..s Height =""
		..s Weight = ""
		..s PersonOtherRowId = $O(^CHSS.PersonHealthRecordOtherI("PersonRowIdParrefIndex",PersonRowId,PersonOtherRowId))
		..i PersonOtherRowId'="" d
		...s tempOtherInfo = ##class(CHSS.PersonHealthRecordOther).%OpenId(PersonOtherRowId)
 		...s FatherName = tempOtherInfo.FatherName
		...s MotherName = tempOtherInfo.MotherName
		...s Height = tempOtherInfo.Height
		...s Weight = tempOtherInfo.Weight
		 
		..Set tmp= PersonRowId_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_CardNumber_"^"_LinkManPhone_"^"_FamilyCode_"^"_FamilyRowId_"^"_FamilyAddress_"^"_ProvinceName_"^"_ProvinceDR_"^"_CityName_"^"_CityDR_"^"_SectionName_"^"_SectionDR_"^"_StreetName_"^"_StreetDR_"^"_VillageName_"^"_VillageDR_"^"_FatherName_"^"_MotherName_"^"_Height_"^"_Weight_"^"_CommunityCode
		 
		..s count=count+1
		..i (count>start)&(count<=end) d
		...d json.InsertRowData(tmp)
	    Set resultString = json.getJsonData("PersonRowId^PersonName^SexDR^SexName^Birth^CardNumber^LinkManPhone^FamilyCode^FamilyRowId^FamilyAddress^ProvinceName^ProvinceDR^CityName^CityDR^SectionName^SectionDR^StreetName^StreetDR^VillageName^VillageDR^FatherName^MotherName^Height^Weight^CommunityCode",count)
	 	k json
		Quit resultString
}

//根据检索条件进行检索 

ClassMethod PersonSearchBySql(communityCode As %String, start As %Integer, limit As %Integer, whereStr As %String) As %String
{
	 
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where CommunityCode = '"_communityCode_"' and isnull(PersonStatus,0) != 3  and PersonRowId not in (select PersonRowIdParref from chss.ChildBirthCertificate ) "_whereStr
		;w sqlStr
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
		set PersonRowId = result.Get("PersonRowId")
		s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		;个人编码
		set PersonCode = tempPerson.PersonCode
		;姓名
		set PersonName = tempPerson.PersonName
		;性别
		set SexDR = ""
		set SexName = ""
		i tempPerson.SexDR '= "" d
		.set SexDR = tempPerson.SexDR.%Id()
		.set SexName = tempPerson.SexDR.CTSEXDesc
		;出生日期
		set Birth = tempPerson.Birth
		i Birth '= "" d
		.s Birth = $zd(Birth,3)
		set CardNumber = tempPerson.CardNumber
		set LinkManPhone = tempPerson.LinkManPhone
		 
		s FamilyCode = ""
		s FamilyRowId = ""
		i tempPerson.FamilyRowId '= "" d
		.s FamilyRowId = tempPerson.FamilyRowId.%Id()
		.s FamilyCode = tempPerson.FamilyRowId.FamilyCode
		 
		;家庭地址
		s FamilyAddress = ""
		set ProvinceName = ""
		set ProvinceDR = ""
		set CityName=""
		set CityDR=""
		set SectionName=""
		set SectionDR="" 
		set StreetName=""
		set StreetDR=""
		set VillageName =""
		set VillageDR =""
		 
		i FamilyRowId '= "" d
			.s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
			.i tempFamily.ProvinceDR '="" d
			..s ProvinceDR = tempFamily.ProvinceDR.%Id()
			..s ProvinceName = tempFamily.ProvinceDR.Description 
		        ..s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
		    
			.i tempFamily.CityDR '="" d
			..s CityDR = tempFamily.CityDR.%Id()
			..s CityName = tempFamily.CityDR.Description
			..s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
			 
			.i tempFamily.SectionDR '="" d
			..s SectionDR = tempFamily.SectionDR.%Id()
			..s SectionName = tempFamily.SectionDR.Description
			..s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
			
					 
			.i tempFamily.StreetDR '="" d
			..s StreetDR=tempFamily.StreetDR.%Id()
			..s StreetName = tempFamily.StreetDR.Description 
			..s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
			 
			 
			.i tempFamily.VillageDR '="" d
			..s VillageDR = tempFamily.VillageDR.%Id()
			..s VillageName = tempFamily.VillageDR.Description
		    ..s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description		 
		    .e  d
		    ..i tempFamily.DoorPlate '= "" d
		    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate     
		 
		s PersonOtherRowId = 0
		s FatherName = ""
		s MotherName =""
		s Height =""
		s Weight = ""
		s PersonOtherRowId = $O(^CHSS.PersonHealthRecordOtherI("PersonRowIdParrefIndex",PersonRowId,PersonOtherRowId))
		i PersonOtherRowId'="" d
		.s tempOtherInfo = ##class(CHSS.PersonHealthRecordOther).%OpenId(PersonOtherRowId)
 		.s FatherName = tempOtherInfo.FatherName
		.s MotherName = tempOtherInfo.MotherName
		.s Height = tempOtherInfo.Height
		.s Weight = tempOtherInfo.Weight
		 
		set tmp= PersonRowId_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_CardNumber_"^"_LinkManPhone_"^"_FamilyCode_"^"_FamilyRowId_"^"_FamilyAddress_"^"_ProvinceName_"^"_ProvinceDR_"^"_CityName_"^"_CityDR_"^"_SectionName_"^"_SectionDR_"^"_StreetName_"^"_StreetDR_"^"_VillageName_"^"_VillageDR_"^"_FatherName_"^"_MotherName_"^"_Height_"^"_Weight
        s count=count+1
		 
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
		} 
       Set resultString = json.getJsonData("PersonRowId^PersonName^SexDR^SexName^Birth^CardNumber^LinkManPhone^FamilyCode^FamilyRowId^FamilyAddress^ProvinceName^ProvinceDR^CityName^CityDR^SectionName^SectionDR^StreetName^StreetDR^VillageName^VillageDR^FatherName^MotherName^Height^Weight",count)
	 	k json
	 	
		Quit resultString
}

Storage Default
{
<Data name="ChildBirthCertificateServicesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildBirthCeB84D</DataLocation>
<DefaultData>ChildBirthCertificateServicesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildBirthCeB84D</IdLocation>
<IndexLocation>^CHSSWeb.ChildBirthCeB84I</IndexLocation>
<StreamLocation>^CHSSWeb.ChildBirthCeB84S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
