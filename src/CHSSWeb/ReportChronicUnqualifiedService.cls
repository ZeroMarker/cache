Class CHSSWeb.ReportChronicUnqualifiedService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//慢性病未达标统计

//6 高血压 CHSS.HBPCheckRecord (ItemdCode = '22' and ItemAssortName = '高血压')  DateCheck 、nHighPressure、PersonRowIdParref  血压高于140

//7 糖尿病 CHSS.DiabetesCheckRecord （ItemdCode = '22' and ItemAssortName = '糖尿病'）  PersonRowIdParref  DateCheck BloodSurgeLimosis 空腹血糖高于7.1

ClassMethod ReportList(CommunityCode, start, limit, BeginDate, EndDate, BirthDate, BirthBeginDate, BirthEndDate, ChronicDiseaseType, SexDRSearch)
{
    
	  
	    q:CommunityCode="" ""
		Set start=$G(start)
		Set limit=$G(limit) 
		Set end = start+limit
		set BeginDate = $zdh(BeginDate,3)
		set EndDate = $zdh(EndDate,3)
		set BirthBeginDate = $zdh(BirthBeginDate,3)
		set BirthEndDate = $zdh(BirthEndDate,3)		
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set resultString=""
		//先查询统计时间段内随访过的人
	 
		Set sqlStr1="select H.PersonRowIdParref  from  CHSS.HBPCheckRecord H where H.RowId in(select c.RowId from CHSS.HBPCheckRecord c where  c.DateCheck>="_BeginDate_" and c.DateCheck<="_EndDate_"  group by c.PersonRowIdParref) and  H.nHighPressure>140 "
		Set sqlStr2="select D.PersonRowIdParref  from  CHSS.DiabetesCheckRecord D  where D.RowId in(select c.RowId from CHSS.HBPCheckRecord c where  c.DateCheck>="_BeginDate_" and c.DateCheck<="_EndDate_"  group by c.PersonRowIdParref) and D.BloodSurgeLimosis>7.1 "
		if ChronicDiseaseType="1" {
		  Set sqlStr=sqlStr1
		}elseif  ChronicDiseaseType="2" {
		  Set sqlStr=sqlStr2
	    }else{
		  Set sqlStr=sqlStr1_" Union "_sqlStr2
			}
		 ; w sqlStr
		 s result = ##class(%Library.ResultSet).%New() 
	     d result.Prepare(sqlStr)
	     d result.Execute()
		  While(result.Next())
		{		 
		  set PersonRowId = result.Get("PersonRowIdParref")
		  ; w "<"_PersonRowId_">"
		  i $d(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex"," "_CommunityCode,PersonRowId))  d
		  .s tempPerson= ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		  .s BirthDateP=tempPerson.Birth 
		  .s Sex=tempPerson.SexDR.%Id()
          
		  .s BirthDateCheckOut=1
		  .s SexCheckOut=1
		  .i BirthDate="true" d //校验出生日期
		  ..i (BirthDateP<BirthBeginDate)||(BirthDateP>BirthEndDate) d
		  ...s BirthDateCheckOut=0
		  .i SexDRSearch'="" d
		  ..i SexDRSearch'=Sex  d   //校验性别
		  ...s SexCheckOut=0
		  .i ((BirthDateCheckOut=1)&&(SexCheckOut=1)) d
		..set PersonCode = tempPerson.PersonCode
		..set PersonName = tempPerson.PersonName
		..set SexDR = ""
		..set SexName = ""
		..i tempPerson.SexDR '= "" d
		...set SexDR = tempPerson.SexDR.%Id()
		...set SexName = tempPerson.SexDR.CTSEXDesc
		..set Birth = tempPerson.Birth
		..i Birth '= "" d
		...s Birth = $zd(Birth,3)

		..;个人档案状态
		..set PersonStatus = ""
		..set PersonStatusName = ""
		..i tempPerson.PersonStatus '= "" d
		...set PersonStatus = tempPerson.PersonStatus.%Id()
		...set PersonStatusName = tempPerson.PersonStatus.Description
		...
		..set SpellCode = tempPerson.SpellCode
		..set CardNumber = tempPerson.CardNumber
		..set IDCard = tempPerson.IDCard
		..;登记日期
		..s DateRegister = tempPerson.DateRegister
		..i DateRegister '= "" d
		...s DateRegister=$zd(DateRegister,3)
		..;录入日期
		..s DateInput = tempPerson.DateInput
		..i DateInput '= "" d
		...s DateInput=$zd(DateInput,3)
		..;与户主关系
		..s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		..
		..set RelationHourseHoldDR = ""
		..set RelationHourseHoldName = ""
		..i tempPerson.RelationHourseHoldDR '= "" d
		...set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		...set RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		..;责任医生
		..set DoctorName = ""
		..set DoctorRegister = ""
		..i tempPerson.DoctorRegister '= "" d
		...s DoctorRegister = tempPerson.DoctorRegister
		...s DoctorName = tempPerson.DoctorRegister
		..;操作人员
		..set OperatorInputName = ""
		..set OperatorInput = ""
		..i tempPerson.OperatorInput '= "" d
		...s OperatorInput = tempPerson.OperatorInput.%Id()
		...s OperatorInputName = tempPerson.OperatorInput.SSUSRName
		..
		..
		..s FamilyRowId = ""
		..s HouseHoldName = ""
		..i tempPerson.FamilyRowId '= "" d
		...s FamilyRowId = tempPerson.FamilyRowId.%Id()
		...s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		..
		..s HouseHoldDR = ""
		..S HouseHoldDRName = ""
		..i tempPerson.HouseHoldTypeDR '= "" d
		...s HouseHoldDR =tempPerson.HouseHoldTypeDR.%Id()
		...s HouseHoldDRName = tempPerson.HouseHoldTypeDR.Description
		..;家庭地址
		..s FamilyAddress = ""
		..
		..i FamilyRowId '= "" d
		...s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
		...i tempFamily.ProvinceDR '= "" d
		....s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
		...i tempFamily.CityDR '= "" d
		....s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
		...i tempFamily.SectionDR '= "" d
		....s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
		...i tempFamily.StreetDR '= "" d
		....s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		...i tempFamily.VillageDR '= "" d
		....s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
		...e  d
		....s FamilyAddress = FamilyAddress_tempFamily.VillageName
		...i tempFamily.DoorPlate '= "" d
		....s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
		..
		..s Address = tempPerson.Address
		..
		..s LinkManName = tempPerson.LinkManName
		..s LinkManPhone = tempPerson.LinkManPhone
		..s PersonEmail = tempPerson.PersonEmail
		..;Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_RelationHourseHoldDR_"^"_PoliceRowIdDR_"^"_PoliceName_"^"_PersonStatus_"^"_SpellCode_"^"_CardNumber_"^"_IDCard_"^"_WorkPlace_"^"_BirthPlace_"^"_DateOfWork_"^"_DateOFRetire_"^"_RelationHourseHoldDR_"^"_RelationHourseHoldName_"^"_DoctorRegister_"^"_DoctorName_"^"_NurseRegister_"^"_NurseName_"^"_OperatorInput_"^"_OperatorInputName_"^"_NationalityDR_"^"_NationalityDRName_"^"_FamilyRowId_"^"_HouseHoldDR_"^"_DocimialTypeDR_"^"_DocimialTypeDRName_"^"_PointHospitalRowIdDR_"^"_PointHospitalRowIdDRName_"^"_CommitteeDR_"^"_CommitteeDRName_"^"_StreetRowIdDR_"^"_StreetRowIdDRName_"^"_DeformityType_"^"_DeformityTypeName_"^"_StaffOfUpdate_"^"_StaffOfUpdateName_"^"_NationDR_"^"_NationDRName_"^"_BloodTypeDR_"^"_BloodTypeDRName_"^"_MarriageDR_"^"_MarriageDRName_"^"_EducationDR_"^"_EducationDRName_"^"_ProfessionDR_"^"_ProfessionDRName_"^"_DateRegister_"^"_DateInput_"^"_IDCardTypeDR_"^"_IDCardTypeName_"^"_DateOfIDStart_"^"_DateOfIDEnd_"^"_IDCardProvider_"^"_HouseHoldName_"^"_Address_"^"_MedicalInsuranceID_"^"_PersonStatusName_"^"_LinkManName_"^"_LinkManPhone_"^"_MedicalInsuranceTypeDR_"^"_MedicalInsuranceTypeDRName_"^"_HosDiagnoseId_"^"_PersonEmail_"^"_DeformityCode_"^"_HaveDeformityCertificate
		..
	 

		..Set tmp= PersonRowId_"^"_PersonCode_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth
		..set tmp=tmp_"^"_FamilyAddress_"^"_Address_"^"_LinkManPhone
		..set tmp=tmp_"^"_PersonStatusName_"^"_FamilyRowId_"^"_RelationHourseHoldName_"^"_IDCard
		..s count=count+1
		..i (count>start)&(count<=end) d
		...d json.InsertRowData(tmp)
		}
 
		Set resultString = json.getJsonData("PersonRowId^PersonCode^PersonName^SexDR^SexName^Birth^FamilyAddress^Address^LinkManPhone^PersonStatusName^FamilyRowId^RelationHourseHoldName^IDCard",count)
	  
	  k json
		 
		Quit resultString
}

Storage Default
{
<Data name="ReportChronicUnqualifiedServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportChroniC8AD</DataLocation>
<DefaultData>ReportChronicUnqualifiedServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportChroniC8AD</IdLocation>
<IndexLocation>^CHSSWeb.ReportChroniC8AI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportChroniC8AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
