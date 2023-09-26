Class CHSSWeb.PersonDeformityTrainingService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-07-
/// Description: 训练登记
/// Table：PersonDeformityTraining
/// Input: PersonDeformityTraining
/// Output：
/// Return：
/// Others：	
ClassMethod List(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
	
    Set communityCode=$G(communityCode)
	
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select pdt.TrainRowId, person.PersonRowId, person.PersonName, person.SexDR, person.Birth, person.Address, person.FamilyRowId from CHSS.PersonHealthRecordMain person, CHSS.PersonDeformityTraining pdt where person.PersonRowId = pdt.PersonRowId and person.CommunityCode = '"_communityCode_"' "_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
			
	s PersonRowId = result.Data("PersonRowId")
	s PersonName = result.Data("PersonName")
		
	set SexDR = result.Data("SexDR")
	set SexName = ""
	i SexDR '= "" d
	.s sexobj=##class(User.CTSex).%OpenId(SexDR)
	.s SexName=sexobj.CTSEXDesc
		
    s Birth = result.Data("Birth")
	i (Birth'="") d
	.s Birth = $zd(Birth,3)
	
	s Address = ""
	s FamilyRowId = result.Data("FamilyRowId")
	i FamilyRowId '= "" d
    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
    .i tempFamily '= "" d
    ..i tempFamily.ProvinceDR '= "" d
    ...s Address = Address_tempFamily.ProvinceDR.Description
    ..i tempFamily.CityDR '= "" d
    ...s Address = Address_tempFamily.CityDR.Description
    ..i tempFamily.SectionDR '= "" d
    ...s Address = Address_tempFamily.SectionDR.Description
    ..i tempFamily.StreetDR '= "" d
    ...s Address = Address_tempFamily.StreetDR.Description
    ..i tempFamily.VillageDR '= "" d
    ...;s Address = Address_tempFamily.VillageDR
    ...;s Address = Address_tempFamily.VillageDR.Description
    ..i tempFamily.DoorPlate '= "" d
    ...s Address = Address_tempFamily.DoorPlate
    

    s TrainRowId = result.Data("TrainRowId")	
    s tempPersonDeformityTraining=##class(CHSS.PersonDeformityTraining).%OpenId(TrainRowId)
    
    set RecoverTypeName = ""
    set RecoverType = ""
    i tempPersonDeformityTraining.RecoverType '= "" d
    .s RecoverType = tempPersonDeformityTraining.RecoverType.%Id()
    .s RecoverTypeName = tempPersonDeformityTraining.RecoverType.Description
    
    s bOtherDisease = tempPersonDeformityTraining.bOtherDisease
      
    s DateOfDisease = tempPersonDeformityTraining.DateOfDisease
    i DateOfDisease '= "" d
    .s DateOfDisease = $zd(DateOfDisease,3)
    
    s ReasonOfDisease = tempPersonDeformityTraining.ReasonOfDisease
    s RecoverHistory = tempPersonDeformityTraining.RecoverHistory
    
    set RecoverEffectName = ""
    set RecoverEffect = ""
    i tempPersonDeformityTraining.RecoverEffect '= "" d
    .s RecoverEffect = tempPersonDeformityTraining.RecoverEffect.%Id()
    .s RecoverEffectName = tempPersonDeformityTraining.RecoverEffect.Description
    
    s DiagnoseHospital = tempPersonDeformityTraining.DiagnoseHospital
    s DiagnoseEffect = tempPersonDeformityTraining.DiagnoseEffect
    s MainHandicap = tempPersonDeformityTraining.MainHandicap
    s MainHandicapOther = tempPersonDeformityTraining.MainHandicapOther
    s Operator = tempPersonDeformityTraining.Operator
    
    s DateOfRegister = tempPersonDeformityTraining.DateOfRegister
    i DateOfRegister '= "" d
    .s DateOfRegister = $zd(DateOfRegister,3)
    
    
    s Guardian = tempPersonDeformityTraining.Guardian
    
    set GuardianKinName = ""
    set GuardianKin = ""
    i tempPersonDeformityTraining.GuardianKin '= "" d
    .s GuardianKin = tempPersonDeformityTraining.GuardianKin.%Id()
    .s GuardianKinName = tempPersonDeformityTraining.GuardianKin.Description
   
	
	s tmp=TrainRowId_"^"_PersonRowId_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_Address_"^"_RecoverType_"^"_RecoverTypeName_"^"_bOtherDisease_"^"_DateOfDisease_"^"_ReasonOfDisease_"^"_RecoverHistory_"^"_RecoverEffect_"^"_RecoverEffectName_"^"_DiagnoseHospital_"^"_DiagnoseEffect_"^"_MainHandicap_"^"_MainHandicapOther_"^"_Operator_"^"_DateOfRegister_"^"_Guardian_"^"_GuardianKin_"^"_GuardianKinName

	
	
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("TrainRowId^PersonRowId^PersonName^SexDR^SexName^Birth^Address^RecoverType^RecoverTypeName^bOtherDisease^DateOfDisease^ReasonOfDisease^RecoverHistory^RecoverEffect^RecoverEffectName^DiagnoseHospital^DiagnoseEffect^MainHandicap^MainHandicapOther^Operator^DateOfRegister^Guardian^GuardianKin^GuardianKinName",count)
	
	k json
	d result.Close()
	q resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:添加训练登记表
/// Table：PersonDeformityTraining
/// Input: PersonDeformityTraining
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowId As %Integer, RecoverType As %Integer, bOtherDisease As %String, DateOfDisease As %Date, ReasonOfDisease As %String, RecoverHistory As %String, RecoverEffect As %Integer, DiagnoseHospital As %String, DiagnoseEffect As %String, MainHandicap As %String, MainHandicapOther As %String, Operator As %String, DateOfRegister As %Date, Guardian As %String, GuardianKin As %Integer) As %String
{
      s tempPersonDeformityTraining=""
      s tempPersonDeformityTraining=##class(CHSS.PersonDeformityTraining).%New()
      q:(tempPersonDeformityTraining="") 0
                 
	  
      i PersonRowId '= "" d
      .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
      .s tempPersonDeformityTraining.PersonRowId=PersonRowIdobj

            
      i RecoverType '= "" d
      .s RecoverTypeobj=##class(CHSS.DictRecoverType).%OpenId(RecoverType)
      .s tempPersonDeformityTraining.RecoverType=RecoverTypeobj
      
      s tempPersonDeformityTraining.bOtherDisease = bOtherDisease
      
      
      i DateOfDisease '= "" d
      .s DateOfDisease=$zdh(DateOfDisease ,3)
      s tempPersonDeformityTraining.DateOfDisease=DateOfDisease
      
      s tempPersonDeformityTraining.ReasonOfDisease = ReasonOfDisease
      s tempPersonDeformityTraining.RecoverHistory = RecoverHistory
      
      i RecoverEffect '= "" d
      .s RecoverEffectobj=##class(CHSS.DictRecoverEffect).%OpenId(RecoverEffect)
      .s tempPersonDeformityTraining.RecoverEffect=RecoverEffectobj
           
      s tempPersonDeformityTraining.DiagnoseHospital = DiagnoseHospital
      s tempPersonDeformityTraining.DiagnoseEffect = DiagnoseEffect
      s tempPersonDeformityTraining.MainHandicap = MainHandicap
      s tempPersonDeformityTraining.MainHandicapOther = MainHandicapOther
      s tempPersonDeformityTraining.Operator = Operator
      
      i DateOfRegister '= "" d
      .s DateOfRegister=$zdh(DateOfRegister ,3)
      s tempPersonDeformityTraining.DateOfRegister=DateOfRegister
     
      s tempPersonDeformityTraining.Guardian = Guardian
      
      i GuardianKin '= "" d
      .s GuardianKinobj=##class(CHSS.DictKin).%OpenId(GuardianKin)
      .s tempPersonDeformityTraining.GuardianKin=GuardianKinobj
      
              
      s result=""
      s result=tempPersonDeformityTraining.%Save()
      
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempPersonDeformityTraining.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempPersonDeformityTraining.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:更新训练登记表
/// Table：PersonDeformityTraining
/// Input: PersonDeformityTraining
/// Output：
/// Return：
/// Others：
ClassMethod Update(TrainRowId As %Integer, PersonRowId As %Integer, RecoverType As %Integer, bOtherDisease As %String, DateOfDisease As %Date, ReasonOfDisease As %String, RecoverHistory As %String, RecoverEffect As %Integer, DiagnoseHospital As %String, DiagnoseEffect As %String, MainHandicap As %String, MainHandicapOther As %String, Operator As %String, DateOfRegister As %Date, Guardian As %String, GuardianKin As %Integer) As %String
{
  
      q:($d(TrainRowId)=0)||(TrainRowId="")
      
      s tempPersonDeformityTraining="",result=""
      s tempPersonDeformityTraining=##class(CHSS.PersonDeformityTraining).%OpenId(TrainRowId)
      q:(tempPersonDeformityTraining="") 0
       
       
      i PersonRowId '= "" d
      .s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
      .s tempPersonDeformityTraining.PersonRowId=PersonRowIdobj
 

	  i RecoverType '= "" d
      .s RecoverTypeobj=##class(CHSS.DictRecoverType).%OpenId(RecoverType)
      .s tempPersonDeformityTraining.RecoverType=RecoverTypeobj
      
      s tempPersonDeformityTraining.bOtherDisease = bOtherDisease
      
      
      i DateOfDisease '= "" d
      .s DateOfDisease=$zdh(DateOfDisease ,3)
      s tempPersonDeformityTraining.DateOfDisease=DateOfDisease
      
      s tempPersonDeformityTraining.ReasonOfDisease = ReasonOfDisease
      s tempPersonDeformityTraining.RecoverHistory = RecoverHistory
      
      i RecoverEffect '= "" d
      .s RecoverEffectobj=##class(CHSS.DictRecoverEffect).%OpenId(RecoverEffect)
      .s tempPersonDeformityTraining.RecoverEffect=RecoverEffectobj
           
      s tempPersonDeformityTraining.DiagnoseHospital = DiagnoseHospital
      s tempPersonDeformityTraining.DiagnoseEffect = DiagnoseEffect
      s tempPersonDeformityTraining.MainHandicap = MainHandicap
      s tempPersonDeformityTraining.MainHandicapOther = MainHandicapOther
      s tempPersonDeformityTraining.Operator = Operator
      
      i DateOfRegister '= "" d
      .s DateOfRegister=$zdh(DateOfRegister ,3)
      s tempPersonDeformityTraining.DateOfRegister=DateOfRegister
     
      s tempPersonDeformityTraining.Guardian = Guardian
      
      i GuardianKin '= "" d
      .s GuardianKinobj=##class(CHSS.DictKin).%OpenId(GuardianKin)
      .s tempPersonDeformityTraining.GuardianKin=GuardianKinobj
      
             
      s result=""
      s result=tempPersonDeformityTraining.%Save()
           
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_TrainRowId_"}"
      .///w "{""success"":""true"",""info"":"_TrainRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-07-
/// Description:删除训练登记表
/// Table：PersonDeformityTraining
/// Input: TrainRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(TrainRowId As %String) As %String
{
                
      &sql(delete from CHSS.PersonDeformityTraining where %ID=:TrainRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_TrainRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="PersonDeformityTrainingServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonDeformC37D</DataLocation>
<DefaultData>PersonDeformityTrainingServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonDeformC37D</IdLocation>
<IndexLocation>^CHSSWeb.PersonDeformC37I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonDeformC37S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
