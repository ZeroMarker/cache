Class CHSSWeb.HISInterface.PersonInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2010—02-21
/// Description:个人档案接口--检索身份证号返回个人档案信息(HIS调用)
/// Table：PersonInfo
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod GetPersonInfoData(IDCard As %String)
{
		n (IDCard)
		set returnData = ""
		Set IDCard=$G(IDCard)
		Set reportReportData = ##class(CHSSWeb.HISInterface.PersonInfoData).%New()
		s IDCard=" "_IDCard
		Set start=0
		Set limit=1
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s reportData = ""
		
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("IDCardIndex",IDCard,PersonRowId)) q:PersonRowId=""  d
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		.s reportData = ##class(CHSSWeb.HISInterface.PersonInfo).%New()
		.;初始化
		.;读取数据
		.s reportData.PersonRowId = PersonRowId
		.s reportData.PersonCode = tempPerson.PersonCode
		.s reportData.PersonName = tempPerson.PersonName
		.
		.s SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set reportData.SexName = tempPerson.SexDR.CTSEXDesc
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s reportData.Birth = $zd(Birth,3)
		..; Birth
		..;w reportData.Birth
		.
		.
		.
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
	    .s FamilyAddress = ""
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    .i FamilyAddress '= "" d
	    ..s reportData.FamilyAddress = FamilyAddress
	    .i tempPerson.LinkManPhone '= "" d
		..s reportData.LinkManPhone = tempPerson.LinkManPhone
		.
		.i tempPerson.PoliceRowIdDR '= "" d
		..set reportData.PoliceRowIdDRName = tempPerson.PoliceRowIdDR.Description
		.
		.
		.set reportData.SpellCode = tempPerson.SpellCode
		.set reportData.CardNumber = tempPerson.CardNumber
		.set reportData.IDCard = tempPerson.IDCard
		.set reportData.WorkPlace = tempPerson.WorkPlace
		.set reportData.BirthPlace = tempPerson.BirthPlace
		.
		.s DateOfWork = tempPerson.DateOfWork
		.i DateOfWork '= "" d
	    ..s reportData.DateOfWork=$zd(DateOfWork,3)
	    .
	    .s DateOFRetire = tempPerson.DateOFRetire
	    .i DateOFRetire '= "" d
		..s reportData.DateOFRetire=$zd(DateOFRetire,3)
		..
		.s DateRegister = tempPerson.DateRegister
	    .i DateRegister '= "" d
		..s reportData.DateRegister=$zd(DateRegister,3)
		..
		.s DateInput = tempPerson.DateInput
	    .i DateInput '= "" d
		..s reportData.DateInput=$zd(DateInput,3)
		.
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set reportData.RelationHourseHoldDRName = tempPerson.RelationHourseHoldDR.Description
		..
		.i tempPerson.DoctorRegister '= "" d
		..s reportData.DoctorRegister = tempPerson.DoctorRegister
		..
		.i tempPerson.NurseRegister '= "" d
		..s reportData.NurseRegister = tempPerson.NurseRegister
		..
		.
		.i tempPerson.OperatorInput '= "" d
		..s reportData.OperatorInputName = tempPerson.OperatorInput.SSUSRName
		..
		.
		.s NationalityDRName = ""
		.i tempPerson.NationalityDR '= "" d
		..s reportData.NationalityDRName = tempPerson.NationalityDR.CTCOUDesc
		.
		.
		.i tempPerson.HouseHoldTypeDR '= "" d
		..s reportData.HouseHoldTypeDRName = tempPerson.HouseHoldTypeDR.Description
		..
		.
		.i tempPerson.DocimialTypeDR '= "" d
		..s reportData.DocimialTypeDRName = tempPerson.DocimialTypeDR.Description
		..
		.
		.i tempPerson.PointHospitalRowIdDR '= "" d
		..s reportData.PointHospitalRowIdDRName = tempPerson.PointHospitalRowIdDR.Description
		..
		.
		.i tempPerson.CommitteeDR '= "" d
		..s reportData.CommitteeDRName = tempPerson.CommitteeDR.Description
		..
		.i tempPerson.StreetRowIdDR '= "" d
		..s reportData.StreetRowIdDRName = tempPerson.StreetRowIdDR.Description
		.
		.
		.i tempPerson.DeformityType '= "" d
		..s reportData.DeformityTypeName = tempPerson.DeformityType.Description
		.
		.
		.i tempPerson.NationDR '= "" d
		..s reportData.NationDRName = tempPerson.NationDR.CTNATDesc
		..
		..
		.i tempPerson.BloodTypeDR '= "" d
		..s reportData.BloodTypeDRName = tempPerson.BloodTypeDR.BLDTDesc
		..
		..
		.i tempPerson.MarriageDR '= "" d
		..s reportData.MarriageDRName = tempPerson.MarriageDR.CTMARDesc
		..
		..
		.i tempPerson.EducationDR '= "" d
		..s reportData.EducationDRName = tempPerson.EducationDR.EDUDesc
		..
		.i tempPerson.ProfessionDR '= "" d
		..s reportData.ProfessionDRName = tempPerson.ProfessionDR.CTOCCDesc
		..
		.
		.i tempPerson.IDCardTypeDR '= "" d
		..s reportData.IDCardTypeDRName = tempPerson.IDCardTypeDR.CARDDesc
		..
		.s DateOfIDStart = tempPerson.DateOfIDStart
		.i DateOfIDStart '= "" d
	    ..s reportData.DateOfIDStart=$zd(DateOfIDStart,3)
	    ..
	    .s DateOfIDEnd = tempPerson.DateOfIDEnd
		.i DateOfIDEnd '= "" d
	    ..s reportData.DateOfIDEnd=$zd(DateOfIDEnd,3)
	    ..
	    .s reportData.IDCardProvider = tempPerson.IDCardProvider
	    .
	    .s FamilyAddress = ""
	    .
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s reportData.FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    
	    .s reportData.MedicalInsuranceID = tempPerson.MedicalInsuranceID
	    .
	    .s reportData.Address = tempPerson.Address
	    .
		.i tempPerson.AddressTypeDR '= "" d
		..s reportData.AddressTypeDRName = tempPerson.AddressTypeDR.Description
		.s reportData.LinkManName = tempPerson.LinkManName
		.s reportData.LinkManPhone = tempPerson.LinkManPhone
		.
		.i tempPerson.MedicalInsuranceTypeDR '= "" d
		..s reportData.MedicalInsuranceTypeDRName = tempPerson.MedicalInsuranceTypeDR.Description
		.
		.s PersonEmail = tempPerson.PersonEmail
		.
		.; add by wangbo 2010-04-22
		.
		.s reportData.Allergen = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"3")
		.;s ^tempPerson = Allergen
		.s reportData.ExposureHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"4")
		.s reportData.DiseaseHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"5") 
		.s reportData.DiseaseHis = reportData.DiseaseHis_"  "_##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"22")
		.;s ^tempPerson = reportData.DiseaseHis
		.s reportData.OPSHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"6")
		.s reportData.TraumaHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"52")
		.s reportData.TransfusionHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"7")
		.s reportData.FamilyHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"8")
		.s reportData.GeneticDiseaseHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"12")
		.s reportData.Deformity = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"14")
		.
		.s DeformityCard = ""
		.;##class(CHSSWeb.PersonHealthDiagnoseService).ShwoInfo(0,10,PersonRowId,"3")
		.s CommunityName = ""
		.;##class(CHSSWeb.PersonHealthDiagnoseService).ShwoInfo(0,10,PersonRowId,"3")
		.
		.
		.
		.
		.
		.;第二种方法：手工拼写
	    .Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonInfo")
 		.s returnData = "<PersonInfo>"
		. // get list of properties
		.;Write "---Properties---",!
		.Set count = cdef.Properties.Count()
		.For i = 1:1:count d
    	..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		.s returnData = returnData_"</PersonInfo>"
 		.
 		.
		;.;第一种方法：使用XMLExport()自动转换成XML
		;.;如果返回的是LIST，则使用[Collection = list]方式返回列表
		;.d reportReportData.PersonInfo.Insert(reportData)
		;第一种方法：使用XMLExport()自动转换成XML
		;如果是LIST，则返回reportReportData
		;if (reportData '= "")
		;{
			;Set status = reportData.XMLExport()
	    ;}    
	    
		
	  	Quit returnData
}

/// Creator: wangbo
/// CreatDate：2010—02-21
/// Description:个人档案接口--根据社区编码检索个人档案列表
/// Table：PersonInfo
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod GetPersonListWithCommunityCode(CommunityCode As %String)
{
		n (CommunityCode)
		set returnData = ""
		Set CommunityCode=$G(CommunityCode)
		Set reportReportData = ##class(CHSSWeb.HISInterface.PersonInfoData).%New()
		s CommunityCode=" "_CommunityCode
		Set start=0
		Set limit=20
		Set sort=""
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s reportData = ""
		s returnData = ""
		
		q:PersonRowId="" ""
		s returnData = returnData_"<PersonList>"
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex",CommunityCode,PersonRowId)) q:PersonRowId=""  d
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		.s reportData = ##class(CHSSWeb.HISInterface.PersonInfo).%New()
		.;初始化
		.;读取数据
		.s reportData.PersonRowId = PersonRowId
		.s reportData.PersonCode = tempPerson.PersonCode
		.s reportData.PersonName = tempPerson.PersonName
		.
		.s SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set reportData.SexName = tempPerson.SexDR.CTSEXDesc
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s reportData.Birth = $zd(Birth,3)
		..; Birth
		..;w reportData.Birth
		.
		.
		.
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
	    .s FamilyAddress = ""
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    .i FamilyAddress '= "" d
	    ..s reportData.FamilyAddress = FamilyAddress
	    .i tempPerson.LinkManPhone '= "" d
		..s reportData.LinkManPhone = tempPerson.LinkManPhone
		.
		.i tempPerson.PoliceRowIdDR '= "" d
		..set reportData.PoliceRowIdDRName = tempPerson.PoliceRowIdDR.Description
		.
		.
		.set reportData.SpellCode = tempPerson.SpellCode
		.set reportData.CardNumber = tempPerson.CardNumber
		.set reportData.IDCard = tempPerson.IDCard
		.set reportData.WorkPlace = tempPerson.WorkPlace
		.set reportData.BirthPlace = tempPerson.BirthPlace
		.
		.s DateOfWork = tempPerson.DateOfWork
		.i DateOfWork '= "" d
	    ..s reportData.DateOfWork=$zd(DateOfWork,3)
	    .
	    .s DateOFRetire = tempPerson.DateOFRetire
	    .i DateOFRetire '= "" d
		..s reportData.DateOFRetire=$zd(DateOFRetire,3)
		..
		.s DateRegister = tempPerson.DateRegister
	    .i DateRegister '= "" d
		..s reportData.DateRegister=$zd(DateRegister,3)
		..
		.s DateInput = tempPerson.DateInput
	    .i DateInput '= "" d
		..s reportData.DateInput=$zd(DateInput,3)
		.
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set reportData.RelationHourseHoldDRName = tempPerson.RelationHourseHoldDR.Description
		..
		.i tempPerson.DoctorRegister '= "" d
		..s reportData.DoctorRegister = tempPerson.DoctorRegister
		..
		.i tempPerson.NurseRegister '= "" d
		..s reportData.NurseRegister = tempPerson.NurseRegister
		..
		.
		.i tempPerson.OperatorInput '= "" d
		..s reportData.OperatorInputName = tempPerson.OperatorInput.SSUSRName
		..
		.
		.s NationalityDRName = ""
		.i tempPerson.NationalityDR '= "" d
		..s reportData.NationalityDRName = tempPerson.NationalityDR.CTCOUDesc
		.
		.
		.i tempPerson.HouseHoldTypeDR '= "" d
		..s reportData.HouseHoldTypeDRName = tempPerson.HouseHoldTypeDR.Description
		..
		.
		.i tempPerson.DocimialTypeDR '= "" d
		..s reportData.DocimialTypeDRName = tempPerson.DocimialTypeDR.Description
		..
		.
		.i tempPerson.PointHospitalRowIdDR '= "" d
		..s reportData.PointHospitalRowIdDRName = tempPerson.PointHospitalRowIdDR.Description
		..
		.
		.i tempPerson.CommitteeDR '= "" d
		..s reportData.CommitteeDRName = tempPerson.CommitteeDR.Description
		..
		.i tempPerson.StreetRowIdDR '= "" d
		..s reportData.StreetRowIdDRName = tempPerson.StreetRowIdDR.Description
		.
		.
		.i tempPerson.DeformityType '= "" d
		..s reportData.DeformityTypeName = tempPerson.DeformityType.Description
		.
		.
		.i tempPerson.NationDR '= "" d
		..s reportData.NationDRName = tempPerson.NationDR.CTNATDesc
		..
		..
		.i tempPerson.BloodTypeDR '= "" d
		..s reportData.BloodTypeDRName = tempPerson.BloodTypeDR.BLDTDesc
		..
		..
		.i tempPerson.MarriageDR '= "" d
		..s reportData.MarriageDRName = tempPerson.MarriageDR.CTMARDesc
		..
		..
		.i tempPerson.EducationDR '= "" d
		..s reportData.EducationDRName = tempPerson.EducationDR.EDUDesc
		..
		.i tempPerson.ProfessionDR '= "" d
		..s reportData.ProfessionDRName = tempPerson.ProfessionDR.CTOCCDesc
		..
		.
		.i tempPerson.IDCardTypeDR '= "" d
		..s reportData.IDCardTypeDRName = tempPerson.IDCardTypeDR.CARDDesc
		..
		.s DateOfIDStart = tempPerson.DateOfIDStart
		.i DateOfIDStart '= "" d
	    ..s reportData.DateOfIDStart=$zd(DateOfIDStart,3)
	    ..
	    .s DateOfIDEnd = tempPerson.DateOfIDEnd
		.i DateOfIDEnd '= "" d
	    ..s reportData.DateOfIDEnd=$zd(DateOfIDEnd,3)
	    ..
	    .s reportData.IDCardProvider = tempPerson.IDCardProvider
	    .
	    .s FamilyAddress = ""
	    .
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s reportData.FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    
	    .s reportData.MedicalInsuranceID = tempPerson.MedicalInsuranceID
	    .
	    .s reportData.Address = tempPerson.Address
	    .
		.i tempPerson.AddressTypeDR '= "" d
		..s reportData.AddressTypeDRName = tempPerson.AddressTypeDR.Description
		.s reportData.LinkManName = tempPerson.LinkManName
		.s reportData.LinkManPhone = tempPerson.LinkManPhone
		.
		.i tempPerson.MedicalInsuranceTypeDR '= "" d
		..s reportData.MedicalInsuranceTypeDRName = tempPerson.MedicalInsuranceTypeDR.Description
		.
		.s PersonEmail = tempPerson.PersonEmail
		.
		.; add by wangbo 2010-04-22
		.
		.s reportData.Allergen = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"3")
		.;s ^tempPerson = Allergen
		.s reportData.ExposureHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"4")
		.s reportData.DiseaseHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"5") 
		.s reportData.DiseaseHis = reportData.DiseaseHis_"  "_##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"22")
		.;s ^tempPerson = reportData.DiseaseHis
		.s reportData.OPSHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"6")
		.s reportData.TraumaHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"52")
		.s reportData.TransfusionHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"7")
		.s reportData.FamilyHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"8")
		.s reportData.GeneticDiseaseHis = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"12")
		.s reportData.Deformity = ##class(CHSSWeb.PersonHealthDiagnoseService).ShowInfoForReport(0,10,PersonRowId,"14")
		.
		.s DeformityCard = ""
		.;##class(CHSSWeb.PersonHealthDiagnoseService).ShwoInfo(0,10,PersonRowId,"3")
		.s CommunityName = ""
		.;##class(CHSSWeb.PersonHealthDiagnoseService).ShwoInfo(0,10,PersonRowId,"3")
		.
		.s count=count+1 
		.If (count>start)&(count<=end) d
		..;w "count:"_count,! 
		..;w "start:"_start,!
		..;w "end:"_end,!
		..;第二种方法：手工拼写
	    ..Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonInfo")
 		..s returnData = returnData_"<PersonInfo>"
		.. // get list of properties
		..;Write "---Properties---",!
		..Set propertiescount = cdef.Properties.Count()
		..For i = 1:1:propertiescount d
    	...s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		..s returnData = returnData_"</PersonInfo>"
 		.
 		.   
	    s returnData = returnData_"</PersonList>"
		
	  	Quit returnData
}

ClassMethod GenPersonReportData(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, searchField As %String, searchValue As %String) As CHSSWeb.Report.PersonHealthRecordReportData
{
		n (communityCode, start, limit, sort)
		
		Set communityCode=$G(communityCode)
		Set reportReportData = ##class(CHSSWeb.Report.PersonHealthRecordReportData).%New()
		s communityCode=" "_communityCode
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex",communityCode,PersonRowId)) q:PersonRowId=""  d
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		.s reportData = ##class(CHSSWeb.Report.PersonHealthRecordReportObj).%New()
		.;初始化
		.s reportData.PersonRowId = " "
		.s reportData.PersonCode = " "
		.s reportData.PersonName = " "
		.s reportData.SexName = " "
		.s reportData.Birth = " "
		.s reportData.RelationHourseHoldName = " "
		.s reportData.FamilyAddress = " "
		.s reportData.LinkManPhone = " "
		.;读取数据
		.s reportData.PersonRowId = PersonRowId
		.s reportData.PersonCode = tempPerson.PersonCode
		.s reportData.PersonName = tempPerson.PersonName
		.
		.s SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set reportData.SexName = tempPerson.SexDR.CTSEXDesc
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s reportData.Birth = $zd(Birth,3)
		.
		.s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		.
		.set RelationHourseHoldDR = ""
		.set RelationHourseHoldName = ""
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		..set reportData.RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		.e  d
		..s reportData.RelationHourseHoldName = " "
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
	    .s FamilyAddress = ""
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    .i FamilyAddress '= "" d
	    ..s reportData.FamilyAddress = FamilyAddress
	    .i tempPerson.LinkManPhone '= "" d
		..s reportData.LinkManPhone = tempPerson.LinkManPhone
		.d reportReportData.PersonReportList.Insert(reportData)
		.
	 	
		Quit reportReportData
}

/// Creator: wangbo
/// CreatDate：2010—02-21
/// Description:个人档案接口--检索个人档案编码返回个人档案信息(HIS调用)
/// Table：PersonInfo
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod GetPersonInfoWithPersonCode(PersonCode As %String)
{
		n (IDCard)
		set returnData = ""
		Set PersonCode=$G(PersonCode)
		Set reportReportData = ##class(CHSSWeb.HISInterface.PersonInfoData).%New()
		s PersonCode=" "_PersonCode
		Set start=0
		Set limit=1
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		s reportData = ""
		
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("PersonCodeIndex",IDCard,PersonCode)) q:PersonCode=""  d
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		.s reportData = ##class(CHSSWeb.HISInterface.PersonInfo).%New()
		.;初始化
		.;读取数据
		.s reportData.PersonRowId = PersonRowId
		.s reportData.PersonCode = tempPerson.PersonCode
		.s reportData.PersonName = tempPerson.PersonName
		.
		.s SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set reportData.SexName = tempPerson.SexDR.CTSEXDesc
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s reportData.Birth = $zd(Birth,3)
		..; Birth
		..;w reportData.Birth
		.
		.
		.
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
	    .s FamilyAddress = ""
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    .i FamilyAddress '= "" d
	    ..s reportData.FamilyAddress = FamilyAddress
	    .i tempPerson.LinkManPhone '= "" d
		..s reportData.LinkManPhone = tempPerson.LinkManPhone
		.
		.i tempPerson.PoliceRowIdDR '= "" d
		..set reportData.PoliceRowIdDRName = tempPerson.PoliceRowIdDR.Description
		.
		.
		.set reportData.SpellCode = tempPerson.SpellCode
		.set reportData.CardNumber = tempPerson.CardNumber
		.set reportData.IDCard = tempPerson.IDCard
		.set reportData.WorkPlace = tempPerson.WorkPlace
		.set reportData.BirthPlace = tempPerson.BirthPlace
		.
		.s DateOfWork = tempPerson.DateOfWork
		.i DateOfWork '= "" d
	    ..s reportData.DateOfWork=$zd(DateOfWork,3)
	    .
	    .s DateOFRetire = tempPerson.DateOFRetire
	    .i DateOFRetire '= "" d
		..s reportData.DateOFRetire=$zd(DateOFRetire,3)
		..
		.s DateRegister = tempPerson.DateRegister
	    .i DateRegister '= "" d
		..s reportData.DateRegister=$zd(DateRegister,3)
		..
		.s DateInput = tempPerson.DateInput
	    .i DateInput '= "" d
		..s reportData.DateInput=$zd(DateInput,3)
		.
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set reportData.RelationHourseHoldDRName = tempPerson.RelationHourseHoldDR.Description
		..
		.i tempPerson.DoctorRegister '= "" d
		..s reportData.DoctorRegister = tempPerson.DoctorRegister
		..
		.i tempPerson.NurseRegister '= "" d
		..s reportData.NurseRegister = tempPerson.NurseRegister
		..
		.
		.i tempPerson.OperatorInput '= "" d
		..s reportData.OperatorInputName = tempPerson.OperatorInput.SSUSRName
		..
		.
		.s NationalityDRName = ""
		.i tempPerson.NationalityDR '= "" d
		..s reportData.NationalityDRName = tempPerson.NationalityDR.CTCOUDesc
		.
		.
		.i tempPerson.HouseHoldTypeDR '= "" d
		..s reportData.HouseHoldTypeDRName = tempPerson.HouseHoldTypeDR.Description
		..
		.
		.i tempPerson.DocimialTypeDR '= "" d
		..s reportData.DocimialTypeDRName = tempPerson.DocimialTypeDR.Description
		..
		.
		.i tempPerson.PointHospitalRowIdDR '= "" d
		..s reportData.PointHospitalRowIdDRName = tempPerson.PointHospitalRowIdDR.Description
		..
		.
		.i tempPerson.CommitteeDR '= "" d
		..s reportData.CommitteeDRName = tempPerson.CommitteeDR.Description
		..
		.i tempPerson.StreetRowIdDR '= "" d
		..s reportData.StreetRowIdDRName = tempPerson.StreetRowIdDR.Description
		.
		.
		.i tempPerson.DeformityType '= "" d
		..s reportData.DeformityTypeName = tempPerson.DeformityType.Description
		.
		.
		.i tempPerson.NationDR '= "" d
		..s reportData.NationDRName = tempPerson.NationDR.CTNATDesc
		..
		..
		.i tempPerson.BloodTypeDR '= "" d
		..s reportData.BloodTypeDRName = tempPerson.BloodTypeDR.BLDTDesc
		..
		..
		.i tempPerson.MarriageDR '= "" d
		..s reportData.MarriageDRName = tempPerson.MarriageDR.CTMARDesc
		..
		..
		.i tempPerson.EducationDR '= "" d
		..s reportData.EducationDRName = tempPerson.EducationDR.EDUDesc
		..
		.i tempPerson.ProfessionDR '= "" d
		..s reportData.ProfessionDRName = tempPerson.ProfessionDR.CTOCCDesc
		..
		.
		.i tempPerson.IDCardTypeDR '= "" d
		..s reportData.IDCardTypeDRName = tempPerson.IDCardTypeDR.CARDDesc
		..
		.s DateOfIDStart = tempPerson.DateOfIDStart
		.i DateOfIDStart '= "" d
	    ..s reportData.DateOfIDStart=$zd(DateOfIDStart,3)
	    ..
	    .s DateOfIDEnd = tempPerson.DateOfIDEnd
		.i DateOfIDEnd '= "" d
	    ..s reportData.DateOfIDEnd=$zd(DateOfIDEnd,3)
	    ..
	    .s reportData.IDCardProvider = tempPerson.IDCardProvider
	    .
	    .s FamilyAddress = ""
	    .
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s reportData.FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    
	    .s reportData.MedicalInsuranceID = tempPerson.MedicalInsuranceID
	    .
	    .s reportData.Address = tempPerson.Address
	    .
		.i tempPerson.AddressTypeDR '= "" d
		..s reportData.AddressTypeDRName = tempPerson.AddressTypeDR.Description
		.s reportData.LinkManName = tempPerson.LinkManName
		.s reportData.LinkManPhone = tempPerson.LinkManPhone
		.
		.i tempPerson.MedicalInsuranceTypeDR '= "" d
		..s reportData.MedicalInsuranceTypeDRName = tempPerson.MedicalInsuranceTypeDR.Description
		.
		.s PersonEmail = tempPerson.PersonEmail
		.
		.
		.
		.
		.
		.;第二种方法：手工拼写
	    .Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonInfo")
 		.s returnData = "<PersonInfo>"
		. // get list of properties
		.;Write "---Properties---",!
		.Set count = cdef.Properties.Count()
		.For i = 1:1:count d
    	..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		.s returnData = returnData_"</PersonInfo>"
 		.
 		.
		;.;第一种方法：使用XMLExport()自动转换成XML
		;.;如果返回的是LIST，则使用[Collection = list]方式返回列表
		;.d reportReportData.PersonInfo.Insert(reportData)
		;第一种方法：使用XMLExport()自动转换成XML
		;如果是LIST，则返回reportReportData
		;if (reportData '= "")
		;{
			;Set status = reportData.XMLExport()
	    ;}    
	    
		
	  	Quit returnData
}

Storage Default
{
<Data name="PersonInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonInterf608D</DataLocation>
<DefaultData>PersonInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonInterf608D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonInterf608I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonInterf608S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
