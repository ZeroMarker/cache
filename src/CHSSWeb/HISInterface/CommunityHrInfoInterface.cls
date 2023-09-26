Class CHSSWeb.HISInterface.CommunityHrInfoInterface Extends %Persistent
{

ClassMethod getCommunityHrInfo(communitycode, startdate, enddate)
{
		s reportData = ""
		set returnData = ""
				
	    s reportData = ##class(CHSSWeb.HISInterface.CommunityHrInfo).%New()
        s result =##class(CHSSWeb.ReportTwoStaService).reportTwoSta(communitycode, startdate, enddate)
	    
	    s reportData.TotalPersonNum=$p(result,"^",1)
        s reportData.AuthorizedNum=$p(result,"^",2)
	    s reportData.MedicalPersonnelNum=$p(result,"^",3)
		s reportData.ClinicGeneralPar=$p(result,"^",4)
		s reportData.ClinicPrimaryLevel=$p(result,"^",5)
		s reportData.ClinicMedium=$p(result,"^",6)
		s reportData.ClinicSenior=$p(result,"^",7)
		s reportData.ClinicVocational=$p(result,"^",8)
		s reportData.ClinicAssociateCollege=$p(result,"^",9)
		s reportData.ClinicCollege=$p(result,"^",10)
		s reportData.ClinicGraduateDiploma=$p(result,"^",11)
		s reportData.TMCGeneralPar=$p(result,"^",12)
		s reportData.TMCPrimaryLevel=$p(result,"^",13)
		s reportData.TMCMedium=$p(result,"^",14)
		s reportData.TMCSenior=$p(result,"^",15)
		s reportData.TMCVocational=$p(result,"^",16)
		s reportData.TMCAssociateCollege=$p(result,"^",17)
		s reportData.TMCCollege=$p(result,"^",18)
		s reportData.TMCGraduateDiploma=$p(result,"^",19)
		s reportData.NursePrimaryLevel=$p(result,"^",20)
		s reportData.NurseMedium=$p(result,"^",21)
		s reportData.NurseSenior=$p(result,"^",22)
		s reportData.NurseVocational=$p(result,"^",23)
		s reportData.NurseAssociateCollege=$p(result,"^",24)
		s reportData.NurseCollege=$p(result,"^",25)
		s reportData.NurseGraduateDiploma=$p(result,"^",26)
		s reportData.MedicalTechnicianNum=$p(result,"^",27)
		s reportData.ApothecaryNum=$p(result,"^",28)
		s reportData.TrainDoctorNum=$p(result,"^",29)
		s reportData.TrainNurseNum=$p(result,"^",30)
		s reportData.PublicDoctorNum=$p(result,"^",31)
		s reportData.MonthDoctorNum=$p(result,"^",32)
		s reportData.ClinicTotalNum=$p(result,"^",33)
        s reportData.TMCTotalNum=$p(result,"^",34)
        s reportData.NurseTotalNum=$p(result,"^",35)

		Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.CommunityHrInfo")
 		s returnData = "<CommunityHrInfo>"
		 
		Set count = cdef.Properties.Count()
		For i = 1:1:count d
    	.s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 		s returnData = returnData_"</CommunityHrInfo>"
 		q returnData
}

Storage Default
{
<Data name="CommunityHrInfoInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.CommunityHrI99CD</DataLocation>
<DefaultData>CommunityHrInfoInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.CommunityHrI99CD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.CommunityHrI99CI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.CommunityHrI99CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
