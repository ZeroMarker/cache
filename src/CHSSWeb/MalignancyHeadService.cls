Class CHSSWeb.MalignancyHeadService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(Start, Limit, id)
{
      Set PersonRowId=$G(id)
      Set start=$G(start)
      Set limit=$G(limit)
      Set count=0
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select MaligRowId from CHSS.MalignancyHeadPage where PersonRowId="_PersonRowId_""
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s count=count+1
		
		s MaligRowId = result.Data("MaligRowId")
		s MalignancyCheck = ##class(CHSS.MalignancyHeadPage).%OpenId(MaligRowId)
		
				
		s Intime=MalignancyCheck.Intime
	    i Intime '= "" d
        .s Intime = $zd(Intime,3)
        
        s StaffInput=""
        s StaffInputName=""
        i MalignancyCheck.StaffInput'="" d
        .s StaffInput =MalignancyCheck.StaffInput.%Id()
       
        .s StaffInputName =MalignancyCheck.StaffInput.SSUSRName
       
       	s Doctor = MalignancyCheck.Doctor
       	s Nurse= MalignancyCheck.Nurse
       	
       	
       	s DateOfInput=MalignancyCheck.DateOfInput
	    i DateOfInput '= "" d
        .s DateOfInput = $zd(DateOfInput,3)
        
        s DateOfUpdate=MalignancyCheck.DateOfUpdate
	    i DateOfUpdate '= "" d
        .s DateOfUpdate = $zd(DateOfUpdate,3)
        
        
        
        s DiagnoseUnit=MalignancyCheck.DiagnoseUnit
        s SmokeInfo=MalignancyCheck.SmokeInfo
        s DrinkInfo=MalignancyCheck.DrinkInfo
        s GymInfo=MalignancyCheck.GymInfo
        s DiseaseHistory=MalignancyCheck.DiseaseHistory
        s Weight=MalignancyCheck.Weight
        s High=  MalignancyCheck.High
        s BMI= MalignancyCheck.BMI
        s Checker=MalignancyCheck.Checker
        
        s DateOfCheck=MalignancyCheck.DateOfCheck
	    i DateOfCheck '= "" d
        .s DateOfCheck = $zd(DateOfCheck,3)
        
        s CheckOutWay= MalignancyCheck.CheckOutWay
        
        s TellPatient=""
        s TellPatientName=""
        i MalignancyCheck.TellPatient'="" d
        .s TellPatient =MalignancyCheck.TellPatient.%Id()
        .s TellPatientName =MalignancyCheck.TellPatient.Description
        
         s DateOfFirstFound=MalignancyCheck.DateOfFirstFound
	    i DateOfFirstFound '= "" d
        .s DateOfFirstFound = $zd(DateOfFirstFound,3)
        
        
       	  
         s DateOfDiagnose=MalignancyCheck.DateOfDiagnose
	    i DateOfDiagnose '= "" d
        .s DateOfDiagnose = $zd(DateOfDiagnose,3)
        
        
          
        s FirstDiagnoseInfo=  MalignancyCheck.FirstDiagnoseInfo
        s FirstOPSHospital=  MalignancyCheck.FirstOPSHospital
        s InHosCode=    MalignancyCheck.InHosCode
        s PathologyCode=MalignancyCheck.PathologyCode
        
        
        
          s DateOfFirstOPS=MalignancyCheck.DateOfFirstOPS
	    i DateOfFirstOPS '= "" d
        .s DateOfFirstOPS = $zd(DateOfFirstOPS,3)
        
        
       	   s FirstOPSProperty=""
        s FirstOPSPropertyName=""
        i MalignancyCheck.FirstOPSProperty'="" d
        .s FirstOPSProperty =MalignancyCheck.FirstOPSProperty.%Id()
        .s FirstOPSPropertyName =MalignancyCheck.FirstOPSProperty.Description
       	
       	s OPSHos=MalignancyCheck.OPSHos
       	s ChemotherapyHos=MalignancyCheck.ChemotherapyHos
       	s RadiotherapyHos=MalignancyCheck.RadiotherapyHos
       	s bTransfer=MalignancyCheck.bTransfer
       	s TransferPart= MalignancyCheck.TransferPart
       	s MalignancyFMH= MalignancyCheck.MalignancyFMH
       	s Relation =MalignancyCheck.Relation
       	s MalignancyType=MalignancyCheck.MalignancyType
      
      
       s CurrentSituation=""
        s CurrentSituationName=""
        i MalignancyCheck.CurrentSituation'="" d
        .s CurrentSituation =MalignancyCheck.CurrentSituation.%Id()
        .s CurrentSituationName =MalignancyCheck.CurrentSituation.Description
      
      
         s Guide=""
        s GuideName=""
        i MalignancyCheck.Guide'="" d 
        .s Guide=MalignancyCheck.Guide.%Id()
        .s GuideName=MalignancyCheck.Guide.Description
        
        s KPS=""
        s KPSName=""
        i MalignancyCheck.KPS'="" d
        .s KPS= MalignancyCheck.KPS.%Id()
        .s KPSName= MalignancyCheck.KPS.Description
       	
       	s FirstDoctor= MalignancyCheck.FirstDoctor
       	
       	
       	  s FirstDate=MalignancyCheck.FirstDate
	    i FirstDate '= "" d
        .s FirstDate = $zd(FirstDate,3)
        
        
          s UndoManageDate=MalignancyCheck.UndoManageDate
	    i UndoManageDate '= "" d
        .s UndoManageDate = $zd(UndoManageDate,3)
        
        s UndoManageReason=MalignancyCheck.UndoManageReason
        
          s DeathDate=MalignancyCheck.DeathDate
	    i DeathDate '= "" d
        .s DeathDate = $zd(DeathDate,3)
        
        s DeathReason=MalignancyCheck.DeathReason
        s DeathPlace=MalignancyCheck.DeathPlace
        
        s TTL=MalignancyCheck.TTL
	    i TTL '= "" d
        .s TTL = $zd(TTL,3)
        
      
        s tmp=MaligRowId_"^"_PersonRowId_"^"_Intime_"^"_Doctor_"^"
        s tmp=tmp_Nurse_"^"_StaffInput_"^"_StaffInputName_"^"_DateOfInput_"^"_DateOfUpdate_"^"_DiagnoseUnit_"^"
        s tmp=tmp_SmokeInfo_"^"_DrinkInfo_"^"_GymInfo_"^"_DiseaseHistory_"^"_Weight_"^"_High_"^"
        s tmp=tmp_BMI_"^"_Checker_"^"_DateOfCheck_"^"_CheckOutWay_"^"_TellPatient_"^"_TellPatientName_"^"
        s tmp=tmp_DateOfFirstFound_"^"_DateOfDiagnose_"^"_FirstDiagnoseInfo_"^"_FirstOPSHospital_"^"
        s tmp=tmp_InHosCode_"^"_PathologyCode_"^"_DateOfFirstOPS_"^"_FirstOPSProperty_"^"_FirstOPSPropertyName_"^"
        s tmp=tmp_OPSHos_"^"_ChemotherapyHos_"^"_RadiotherapyHos_"^"_bTransfer_"^"
        s tmp=tmp_TransferPart_"^"_MalignancyFMH_"^"_Relation_"^"_MalignancyType_"^"_CurrentSituation_"^"_CurrentSituationName_"^"
        s tmp=tmp_Guide_"^"_GuideName_"^"_KPS_"^"_KPSName_"^"_FirstDoctor_"^"_FirstDate_"^"_UndoManageDate_"^"_UndoManageReason_"^"
        s tmp=tmp_DeathDate_"^"_DeathReason_"^"_DeathPlace_"^"_TTL
        d json.InsertRowData(tmp)
        
	}
	
	d result.Close()
	s resultString = json.getJsonData("MaligRowId^PersonRowId^Intime^Doctor^Nurse^StaffInput^StaffInputName^DateOfInput^DateOfUpdate1^DiagnoseUnit^SmokeInfo^DrinkInfo^GymInfo^DiseaseHistory^Weight^High^BMI^Checker^DateOfCheck^CheckOutWay^TellPatient^TellPatientName^DateOfFirstFound^DateOfDiagnose^FirstDiagnoseInfo^FirstOPSHospital^InHosCode^PathologyCode^DateOfFirstOPS^FirstOPSProperty^FirstOPSPropertyName^OPSHos^ChemotherapyHos^RadiotherapyHos^bTransfer^TransferPart^MalignancyFMH^Relation^MalignancyType^CurrentSituation^CurrentSituationName^Guide^GuideName^KPS^KPSName^FirstDoctor^FirstDate^UndoManageDate^UndoManageReason^DeathDate^DeathReason^DeathPlace^TTL",count)
    k json
	q resultString
}

ClassMethod insert(PersonRowId, Intime, Doctor, Nurse, StaffInput, DateOfInput, DateOfUpdate, DiagnoseUnit, SmokeInfo, DrinkInfo, GymInfo, DiseaseHistory, Weight, High, BMI, Checker, DateOfCheck, CheckOutWay, TellPatient, DateOfFirstFound, DateOfDiagnose, FirstDiagnoseInfo, FirstOPSHospital, InHosCode, PathologyCode, DateOfFirstOPS, FirstOPSProperty, OPSHos, ChemotherapyHos, RadiotherapyHos, bTransfer, TransferPart, MalignancyFMH, Relation, MalignancyType, CurrentSituation, Guide, KPS, FirstDoctor, FirstDate, UndoManageDate, UndoManageReason, DeathDate, DeathReason, DeathPlace, TTL)
{
        s MalignancyHeadPage=""
         s MalignancyHeadPage=##class(CHSS.MalignancyHeadPage).%New()
         q:(MalignancyHeadPage="") 0
                 
	 
        i PersonRowId '= "" d
        .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
        .s MalignancyHeadPage.PersonRowId=PersonRowIdobj
        
        
          i Intime '= "" d
         .s Intime=$zdh(Intime ,3)
         s MalignancyHeadPage.Intime=Intime
       
         
         s MalignancyHeadPage.Doctor=Doctor
         

      s MalignancyHeadPage.Nurse=Nurse
      
      
      i StaffInput'="" d
      .s MalignancyHeadPage.StaffInput=##class(User.SSUser).%OpenId(StaffInput)
      
     i DateOfInput '= "" d
     .s DateOfInput=$zdh(DateOfInput ,3)
     s MalignancyHeadPage.DateOfInput=DateOfInput
         
      i DateOfUpdate '= "" d
     .s DateOfUpdate=$zdh(DateOfUpdate ,3)
     s MalignancyHeadPage.DateOfUpdate=DateOfUpdate

	 s MalignancyHeadPage.DiagnoseUnit=DiagnoseUnit
	 s MalignancyHeadPage.SmokeInfo=SmokeInfo
	 s MalignancyHeadPage.DrinkInfo=DrinkInfo
	 s MalignancyHeadPage.GymInfo=GymInfo
 	s MalignancyHeadPage.DiseaseHistory=DiseaseHistory
	s MalignancyHeadPage.Weight=Weight
	
	s MalignancyHeadPage.High=High
	s MalignancyHeadPage.BMI=BMI
	s MalignancyHeadPage.Checker=Checker

	i DateOfCheck '= "" d
         .s DateOfCheck=$zdh(DateOfCheck ,3) 
	s MalignancyHeadPage.DateOfCheck=DateOfCheck
	
	s MalignancyHeadPage.CheckOutWay=CheckOutWay
	
	i TellPatient'="" d
	.s MalignancyHeadPage.TellPatient=##class(CHSS.DictTellPatient).%OpenId(TellPatient)
	
	i DateOfFirstFound '= "" d
         .s DateOfFirstFound=$zdh(DateOfFirstFound ,3) 
	s MalignancyHeadPage.DateOfFirstFound=DateOfFirstFound
	
	i DateOfDiagnose '= "" d
         .s DateOfDiagnose=$zdh(DateOfDiagnose ,3) 
	s MalignancyHeadPage.DateOfDiagnose=DateOfDiagnose
	
	s MalignancyHeadPage.FirstDiagnoseInfo=FirstDiagnoseInfo
	s MalignancyHeadPage.FirstOPSHospital=FirstOPSHospital
	s MalignancyHeadPage.InHosCode=InHosCode
	s MalignancyHeadPage.PathologyCode=PathologyCode
	
	i DateOfFirstOPS'="" d
	.s MalignancyHeadPage.DateOfFirstOPS=$zdh(DateOfFirstOPS,3)
	
	i FirstOPSProperty'="" d
	.s MalignancyHeadPage.FirstOPSProperty=##class(CHSS.DictMalignancyOPSProperty).%OpenId(FirstOPSProperty)


	s MalignancyHeadPage.OPSHos=OPSHos
	s MalignancyHeadPage.ChemotherapyHos=ChemotherapyHos
	s MalignancyHeadPage.RadiotherapyHos=RadiotherapyHos
	s MalignancyHeadPage.bTransfer=bTransfer
	s MalignancyHeadPage.TransferPart=TransferPart
	s MalignancyHeadPage.MalignancyFMH=MalignancyFMH
	s MalignancyHeadPage.Relation=Relation
	s MalignancyHeadPage.MalignancyType=MalignancyType


	i CurrentSituation'="" d
	.s MalignancyHeadPage.CurrentSituation=##class(CHSS.DictCurrentSituation).%OpenId(CurrentSituation)

	i Guide'="" d
	.s MalignancyHeadPage.Guide=##class(CHSS.DictGuide).%OpenId(Guide)


	i KPS'="" d
    .s MalignancyHeadPage.KPS=##class(CHSS.DictKPS).%OpenId(KPS)
	s MalignancyHeadPage.FirstDoctor=FirstDoctor
	
	i FirstDate '= "" d
         .s FirstDate=$zdh(FirstDate ,3) 
	s MalignancyHeadPage.FirstDate=FirstDate
	
	
    i UndoManageDate '= "" d
    .s UndoManageDate=$zdh(UndoManageDate ,3) 
	s MalignancyHeadPage.UndoManageDate=UndoManageDate
	
	 
	s MalignancyHeadPage.UndoManageReason=UndoManageReason
	
	i DeathDate '= "" d
         .s DeathDate=$zdh(DeathDate ,3) 
	s MalignancyHeadPage.DeathDate=DeathDate
	s MalignancyHeadPage.DeathReason=DeathReason
	s MalignancyHeadPage.DeathPlace=DeathPlace
	
	i TTL '= "" d
         .s TTL=$zdh(TTL ,3) 
	s MalignancyHeadPage.TTL=TTL
	s result=""
    s result=MalignancyHeadPage.%Save()
  
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_MalignancyHeadPage.%Id()_"}"
    e  d
    .s resultString = "{""success"":""failed"",""info"":""error""}"
    q resultString
}

ClassMethod edit(MaligRowId, Intime, Doctor, Nurse, StaffInput, DateOfInput, DateOfUpdate, DiagnoseUnit, SmokeInfo, DrinkInfo, GymInfo, DiseaseHistory, Weight, High, BMI, Checker, DateOfCheck, CheckOutWay, TellPatient, DateOfFirstFound, DateOfDiagnose, FirstDiagnoseInfo, FirstOPSHospital, InHosCode, PathologyCode, DateOfFirstOPS, FirstOPSProperty, OPSHos, ChemotherapyHos, RadiotherapyHos, bTransfer, TransferPart, MalignancyFMH, Relation, MalignancyType, CurrentSituation, Guide, KPS, FirstDoctor, FirstDate, UndoManageDate, UndoManageReason, DeathDate, DeathReason, DeathPlace, TTL)
{
	 s MalignancyHeadPage=""
         s MalignancyHeadPage=##class(CHSS.MalignancyHeadPage).%OpenId(MaligRowId)
         q:(MalignancyHeadPage="") 0
         
       i Intime '= "" d
         .s Intime=$zdh(Intime ,3)
         s MalignancyHeadPage.Intime=Intime
       
         
         s MalignancyHeadPage.Doctor=Doctor
         

      s MalignancyHeadPage.Nurse=Nurse
      
      
      i StaffInput'="" d
      .s MalignancyHeadPage.StaffInput=##class(User.SSUser).%OpenId(StaffInput)
      
     i DateOfInput '= "" d
     .s DateOfInput=$zdh(DateOfInput ,3)
     s MalignancyHeadPage.DateOfInput=DateOfInput
         
      i DateOfUpdate '= "" d
     .s DateOfUpdate=$zdh(DateOfUpdate ,3)
     s MalignancyHeadPage.DateOfUpdate=DateOfUpdate

	 s MalignancyHeadPage.DiagnoseUnit=DiagnoseUnit
	 s MalignancyHeadPage.SmokeInfo=SmokeInfo
	 s MalignancyHeadPage.DrinkInfo=DrinkInfo
	 s MalignancyHeadPage.GymInfo=GymInfo
 	s MalignancyHeadPage.DiseaseHistory=DiseaseHistory
	s MalignancyHeadPage.Weight=Weight
	
	s MalignancyHeadPage.High=High
	s MalignancyHeadPage.BMI=BMI
	s MalignancyHeadPage.Checker=Checker

	i DateOfCheck '= "" d
         .s DateOfCheck=$zdh(DateOfCheck ,3) 
	s MalignancyHeadPage.DateOfCheck=DateOfCheck
	
	s MalignancyHeadPage.CheckOutWay=CheckOutWay
	
	i TellPatient'="" d
	.s MalignancyHeadPage.TellPatient=##class(CHSS.DictTellPatient).%OpenId(TellPatient)
	
	i DateOfFirstFound '= "" d
         .s DateOfFirstFound=$zdh(DateOfFirstFound ,3) 
	s MalignancyHeadPage.DateOfFirstFound=DateOfFirstFound
	
	i DateOfDiagnose '= "" d
         .s DateOfDiagnose=$zdh(DateOfDiagnose ,3) 
	s MalignancyHeadPage.DateOfDiagnose=DateOfDiagnose
	
	s MalignancyHeadPage.FirstDiagnoseInfo=FirstDiagnoseInfo
	s MalignancyHeadPage.FirstOPSHospital=FirstOPSHospital
	s MalignancyHeadPage.InHosCode=InHosCode
	s MalignancyHeadPage.PathologyCode=PathologyCode
	
	i DateOfFirstOPS'="" d
	.s MalignancyHeadPage.DateOfFirstOPS=$zdh(DateOfFirstOPS,3)
	
	i FirstOPSProperty'="" d
	.s MalignancyHeadPage.FirstOPSProperty=##class(CHSS.DictMalignancyOPSProperty).%OpenId(FirstOPSProperty)


	s MalignancyHeadPage.OPSHos=OPSHos
	s MalignancyHeadPage.ChemotherapyHos=ChemotherapyHos
	s MalignancyHeadPage.RadiotherapyHos=RadiotherapyHos
	s MalignancyHeadPage.bTransfer=bTransfer
	s MalignancyHeadPage.TransferPart=TransferPart
	s MalignancyHeadPage.MalignancyFMH=MalignancyFMH
	s MalignancyHeadPage.Relation=Relation
	s MalignancyHeadPage.MalignancyType=MalignancyType


	i CurrentSituation'="" d
	.s MalignancyHeadPage.CurrentSituation=##class(CHSS.DictCurrentSituation).%OpenId(CurrentSituation)

	i Guide'="" d
	.s MalignancyHeadPage.Guide=##class(CHSS.DictGuide).%OpenId(Guide)


	i KPS'="" d
    .s MalignancyHeadPage.KPS=##class(CHSS.DictKPS).%OpenId(KPS)
	s MalignancyHeadPage.FirstDoctor=FirstDoctor
	
	i FirstDate '= "" d
         .s FirstDate=$zdh(FirstDate ,3) 
	s MalignancyHeadPage.FirstDate=FirstDate
	
	
    i UndoManageDate '= "" d
    .s UndoManageDate=$zdh(UndoManageDate ,3) 
	s MalignancyHeadPage.UndoManageDate=UndoManageDate
	
	 
	s MalignancyHeadPage.UndoManageReason=UndoManageReason
	
	i DeathDate '= "" d
         .s DeathDate=$zdh(DeathDate ,3) 
	s MalignancyHeadPage.DeathDate=DeathDate
	s MalignancyHeadPage.DeathReason=DeathReason
	s MalignancyHeadPage.DeathPlace=DeathPlace
	
	i TTL '= "" d
         .s TTL=$zdh(TTL ,3) 
	s MalignancyHeadPage.TTL=TTL
	s result=""
    s result=MalignancyHeadPage.%Save()
  
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_MalignancyHeadPage.%Id()_"}"
    e  d
    .s resultString = "{""success"":""failed"",""info"":""error""}"
    q resultString
}

Storage Default
{
<Data name="MalignancyHeadServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.MalignancyHeadServiceD</DataLocation>
<DefaultData>MalignancyHeadServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.MalignancyHeadServiceD</IdLocation>
<IndexLocation>^CHSSWeb.MalignancyHeadServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.MalignancyHeadServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
