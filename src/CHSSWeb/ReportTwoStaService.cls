Class CHSSWeb.ReportTwoStaService Extends %Persistent
{

ClassMethod reportTwoSta(code, startdate, enddate)
{
	
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s HealthBroadNum=0
    s sqlStr = "select * from CHSS.CommunityPersonInfo where DateOfInput between "_sdate_" and "_enddate_" and communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	 s CommunityRowId=result.Data("CommunityRowId")
	 s temp= ##class(CHSS.CommunityPersonInfo).%OpenId(CommunityRowId)
	

	 s TotalPersonNum              =      temp.TotalPersonNum
	 s AuthorizedNum                =     temp.AuthorizedNum
	 s MedicalPersonnelNum           =    temp.MedicalPersonnelNum
	 s ClinicGeneralPar               =   temp.ClinicGeneralPar
	 s ClinicPrimaryLevel              =  temp.ClinicPrimaryLevel
	 s ClinicMedium             =         temp.ClinicMedium
	 s ClinicSenior              =        temp.ClinicSenior
	 s ClinicVocational           =       temp.ClinicVocational
	 s ClinicAssociateCollege      =      temp.ClinicAssociateCollege
	 s ClinicCollege                =     temp.ClinicCollege
	 s ClinicGraduateDiploma         =    temp.ClinicGraduateDiploma
	 s TMCGeneralPar                  =   temp.TMCGeneralPar
	 s TMCPrimaryLevel   =                temp.TMCPrimaryLevel
	 s TMCMedium          =               temp.TMCMedium
	 s TMCSenior           =              temp.TMCSenior
	 s TMCVocational        =             temp.TMCVocational
	 s TMCAssociateCollege   =            temp.TMCAssociateCollege
	 s TMCCollege             =           temp.TMCCollege
	 s TMCGraduateDiploma      =          temp.TMCGraduateDiploma
	 s NursePrimaryLevel        =         temp.NursePrimaryLevel
	 s NurseMedium               =        temp.NurseMedium
	 s NurseSenior                =       temp.NurseSenior
	 s NurseVocational             =      temp.NurseVocational
	 s NurseAssociateCollege        =     temp.NurseAssociateCollege
	 s NurseCollege                  =    temp.NurseCollege
	 s NurseGraduateDiploma         =     temp.NurseGraduateDiploma
	 s MedicalTechnicianNum          =    temp.MedicalTechnicianNum
	 s ApothecaryNum                =     temp.ApothecaryNum
	 s TrainDoctorNum               =     temp.TrainDoctorNum
	 s TrainNurseNum                  =   temp.TrainNurseNum
	 s PublicDoctorNum                 =  temp.PublicDoctorNum
	 s MonthDoctorNum                   = temp.MonthDoctorNum
	 s ClinicTotalNum= ClinicGeneralPar+ClinicPrimaryLevel+ClinicMedium+ClinicSenior+ClinicVocational+ClinicAssociateCollege+ClinicCollege+ClinicGraduateDiploma 
	 s TMCTotalNum=TMCGeneralPar+TMCPrimaryLevel+TMCMedium+TMCSenior+TMCVocational+TMCAssociateCollege+TMCCollege+TMCGraduateDiploma 
     s NurseTotalNum=NursePrimaryLevel+NurseMedium+NurseSenior+NurseVocational+NurseAssociateCollege+NurseCollege+NurseGraduateDiploma 
	}
	d result.Close()
	q TotalPersonNum_"^"_AuthorizedNum_"^"_MedicalPersonnelNum_"^"_ClinicGeneralPar_"^"_ClinicPrimaryLevel_"^"_ClinicMedium_"^"_ClinicSenior_"^"_ClinicVocational_"^"_ClinicAssociateCollege_"^"_ClinicCollege_"^"_ClinicGraduateDiploma_"^"_TMCGeneralPar_"^"_TMCPrimaryLevel_"^"_TMCMedium_"^"_TMCSenior_"^"_TMCVocational_"^"_TMCAssociateCollege_"^"_TMCCollege_"^"_TMCGraduateDiploma_"^"_NursePrimaryLevel_"^"_NurseMedium_"^"_NurseSenior_"^"_NurseVocational_"^"_NurseAssociateCollege_"^"_NurseCollege_"^"_NurseGraduateDiploma_"^"_MedicalTechnicianNum_"^"_ApothecaryNum_"^"_TrainDoctorNum_"^"_TrainNurseNum_"^"_PublicDoctorNum_"^"_MonthDoctorNum_"^"_ClinicTotalNum_"^"_TMCTotalNum_"^"_NurseTotalNum
}

Storage Default
{
<Data name="ReportTwoStaServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportTwoStaServiceD</DataLocation>
<DefaultData>ReportTwoStaServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportTwoStaServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ReportTwoStaServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportTwoStaServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
