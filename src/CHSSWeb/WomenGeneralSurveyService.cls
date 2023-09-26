Class CHSSWeb.WomenGeneralSurveyService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-09-
/// Description:妇女普查记录
/// Table：WomenGeneralSurvey
/// Input: WomenGeneralSurvey
/// Output：
/// Return：
/// Others：
ClassMethod List(PersonRowId, start, limit, sort) As %String
{
      
      Set start=$G(start)
      Set limit=$G(limit)
      Set sort=$G(sort)
      Set count=0
      Set resultString = ""
      Set end = start+limit
      Set json = ##class(Code.JsonObj).%New()
      
      Set tmp = ""
      
      s result = ##class(%Library.ResultSet).%New()
	  s sqlStr = "select SurveyRowId from CHSS.WomenGeneralSurvey where PersonRowId="_PersonRowId
      
      d result.Prepare(sqlStr)
	  d result.Execute()
      
      
      While(result.Next())
	  {
      
      s SurveyRowId = result.Data("SurveyRowId")     
                 
      s tempWomenGeneralSurvey=##class(CHSS.WomenGeneralSurvey).%OpenId(SurveyRowId)
      
      ;s PersonRowId = tempWomenGeneralSurvey.PersonRowId
            
            
      s DateOfCheck = tempWomenGeneralSurvey.DateOfCheck
      i DateOfCheck '= "" d
      .s DateOfCheck = $zd(DateOfCheck,3)
            
      s Age = tempWomenGeneralSurvey.Age
      s Checker = tempWomenGeneralSurvey.Checker
      s AgeOfMenarche = tempWomenGeneralSurvey.AgeOfMenarche
      s AgeOfMarriage = tempWomenGeneralSurvey.AgeOfMarriage
      s AgeOfPrimiparity = tempWomenGeneralSurvey.AgeOfPrimiparity
      s AgeOfMenopause = tempWomenGeneralSurvey.AgeOfMenopause
      s TypeOfBirthControl = tempWomenGeneralSurvey.TypeOfBirthControl
      s bPregnancy = tempWomenGeneralSurvey.bPregnancy
      s GrapeMoleHis = tempWomenGeneralSurvey.GrapeMoleHis
      s DystociaHis = tempWomenGeneralSurvey.DystociaHis
      
      s LMP = tempWomenGeneralSurvey.LMP
      i LMP '= "" d
      .s LMP = $zd(LMP,3)
      
      s Pudendum = tempWomenGeneralSurvey.Pudendum
      s Secretion = tempWomenGeneralSurvey.Secretion
      s Vagina = tempWomenGeneralSurvey.Vagina
      s Cervices = tempWomenGeneralSurvey.Cervices
      s Uterus = tempWomenGeneralSurvey.Uterus
      s Accessories = tempWomenGeneralSurvey.Accessories
      s Galactophore = tempWomenGeneralSurvey.Galactophore
      s BUltrasonic = tempWomenGeneralSurvey.BUltrasonic
      s ClinicalDiagnosis = tempWomenGeneralSurvey.ClinicalDiagnosis
      s GynecologicalDis = tempWomenGeneralSurvey.GynecologicalDis
      
      s GynecologicalDisease = ""
      
      s result1 = ##class(%Library.ResultSet).%New()
	  s sqlStr1 = "select Description from CHSS.DictGynecologicalDisease where RowId in ("_GynecologicalDis_")"
      
      d result1.Prepare(sqlStr1)
	  d result1.Execute()
	  
	  set startStr = ""
	  
	  While(result1.Next())
	  {
	  s Description=result1.Data("Description")		
      Set GynecologicalDisease = GynecologicalDisease_startStr_Description
      set startStr = ","
	  }
	  
	  d result1.Close()
      
      Set tmp = SurveyRowId_"^"_DateOfCheck_"^"_Age_"^"_Checker_"^"_AgeOfMenarche_"^"_AgeOfMarriage_"^"_AgeOfPrimiparity_"^"_AgeOfMenopause_"^"_TypeOfBirthControl_"^"_bPregnancy_"^"_GrapeMoleHis_"^"_DystociaHis_"^"_LMP_"^"_Pudendum_"^"_Secretion_"^"_Vagina_"^"_Cervices_"^"_Uterus_"^"_Accessories_"^"_Galactophore_"^"_BUltrasonic_"^"_ClinicalDiagnosis_"^"_GynecologicalDis_"^"_GynecologicalDisease


      Set count=count+1
      If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
      
	  }
	  
	  d result.Close()
      
      Set resultString = json.getJsonData("SurveyRowId^DateOfCheck^Age^Checker^AgeOfMenarche^AgeOfMarriage^AgeOfPrimiparity^AgeOfMenopause^TypeOfBirthControl^bPregnancy^GrapeMoleHis^DystociaHis^LMP^Pudendum^Secretion^Vagina^Cervices^Uterus^Accessories^Galactophore^BUltrasonic^ClinicalDiagnosis^GynecologicalDis^GynecologicalDisease",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-09-
/// Description:添加妇女普查记录
/// Table：WomenGeneralSurvey
/// Input: WomenGeneralSurvey
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowId, DateOfCheck, Age, Checker, AgeOfMenarche, AgeOfMarriage, AgeOfPrimiparity, AgeOfMenopause, TypeOfBirthControl, bPregnancy, GrapeMoleHis, DystociaHis, LMP, Pudendum, Secretion, Vagina, Cervices, Uterus, Accessories, Galactophore, BUltrasonic, ClinicalDiagnosis, GynecologicalDis) As %String
{
      s tempWomenGeneralSurvey=""
      s tempWomenGeneralSurvey=##class(CHSS.WomenGeneralSurvey).%New()
      q:(tempWomenGeneralSurvey="") 0
      
      
      s PersonRowIdobj=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
      s tempWomenGeneralSurvey.PersonRowId=PersonRowIdobj
      
          
     
      i DateOfCheck '= "" d
      .s DateOfCheck=$zdh(DateOfCheck ,3)
      s tempWomenGeneralSurvey.DateOfCheck=DateOfCheck
      
      s tempWomenGeneralSurvey.Age = Age
      s tempWomenGeneralSurvey.Checker = Checker
      s tempWomenGeneralSurvey.AgeOfMenarche = AgeOfMenarche
      s tempWomenGeneralSurvey.AgeOfMarriage = AgeOfMarriage
      s tempWomenGeneralSurvey.AgeOfPrimiparity = AgeOfPrimiparity
      s tempWomenGeneralSurvey.AgeOfMenopause = AgeOfMenopause
      s tempWomenGeneralSurvey.TypeOfBirthControl = TypeOfBirthControl
      s tempWomenGeneralSurvey.bPregnancy = bPregnancy
      s tempWomenGeneralSurvey.GrapeMoleHis = GrapeMoleHis
      s tempWomenGeneralSurvey.DystociaHis = DystociaHis
      
      i LMP '= "" d
      .s LMP=$zdh(LMP ,3)
      s tempWomenGeneralSurvey.LMP=LMP
      
      s tempWomenGeneralSurvey.Pudendum = Pudendum
      s tempWomenGeneralSurvey.Secretion = Secretion
      s tempWomenGeneralSurvey.Vagina = Vagina
      s tempWomenGeneralSurvey.Cervices = Cervices
      s tempWomenGeneralSurvey.Uterus = Uterus
      s tempWomenGeneralSurvey.Accessories = Accessories
      s tempWomenGeneralSurvey.Galactophore = Galactophore
      s tempWomenGeneralSurvey.BUltrasonic = BUltrasonic
      s tempWomenGeneralSurvey.ClinicalDiagnosis = ClinicalDiagnosis
      s tempWomenGeneralSurvey.GynecologicalDis = GynecologicalDis


	  &sql(select count(*) into :count from CHSS.WomenGeneralSurvey where PersonRowId= :PersonRowId and DateOfCheck> :DateOfCheck)
	  i count = 0 d
	  .&sql(delete from CHSS.PersonHealthDiagnose where ItemdCode= 29 and PersonRowIdParref= :PersonRowId)
	  .s result1 = ##class(%Library.ResultSet).%New()
	  .s sqlStr1 = "insert into CHSS.PersonHealthDiagnose (ItemdCode, ItemAssortName, PersonRowIdParref) select 29, Description, "_PersonRowId_" from CHSS.DictGynecologicalDisease where RowId in ("_GynecologicalDis_")"
      
      .d result1.Prepare(sqlStr1)
	  .d result1.Execute()
	  .d result1.Close()
	  
	  
      s result=""
      s result=tempWomenGeneralSurvey.%Save()
      Set resultString = ""
      
           
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWomenGeneralSurvey.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWomenGeneralSurvey.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-09-
/// Description:更新妇女普查记录
/// Table：WomenGeneralSurvey
/// Input: WomenGeneralSurvey
/// Output：
/// Return：
/// Others：
ClassMethod Update(SurveyRowId, DateOfCheck, Age, Checker, AgeOfMenarche, AgeOfMarriage, AgeOfPrimiparity, AgeOfMenopause, TypeOfBirthControl, bPregnancy, GrapeMoleHis, DystociaHis, LMP, Pudendum, Secretion, Vagina, Cervices, Uterus, Accessories, Galactophore, BUltrasonic, ClinicalDiagnosis, GynecologicalDis) As %String
{
  
      q:($d(SurveyRowId)=0)||(SurveyRowId="")
      
      s tempWomenGeneralSurvey="",result=""
      s tempWomenGeneralSurvey=##class(CHSS.WomenGeneralSurvey).%OpenId(SurveyRowId)
      q:(tempWomenGeneralSurvey="") 0
       
            
      i DateOfCheck '= "" d
      .s DateOfCheck=$zdh(DateOfCheck ,3)
      s tempWomenGeneralSurvey.DateOfCheck=DateOfCheck
      
      s tempWomenGeneralSurvey.Age = Age
      s tempWomenGeneralSurvey.Checker = Checker
      s tempWomenGeneralSurvey.AgeOfMenarche = AgeOfMenarche
      s tempWomenGeneralSurvey.AgeOfMarriage = AgeOfMarriage
      s tempWomenGeneralSurvey.AgeOfPrimiparity = AgeOfPrimiparity
      s tempWomenGeneralSurvey.AgeOfMenopause = AgeOfMenopause
      s tempWomenGeneralSurvey.TypeOfBirthControl = TypeOfBirthControl
      s tempWomenGeneralSurvey.bPregnancy = bPregnancy
      s tempWomenGeneralSurvey.GrapeMoleHis = GrapeMoleHis
      s tempWomenGeneralSurvey.DystociaHis = DystociaHis
      
      i LMP '= "" d
      .s LMP=$zdh(LMP ,3)
      s tempWomenGeneralSurvey.LMP=LMP
      
      s tempWomenGeneralSurvey.Pudendum = Pudendum
      s tempWomenGeneralSurvey.Secretion = Secretion
      s tempWomenGeneralSurvey.Vagina = Vagina
      s tempWomenGeneralSurvey.Cervices = Cervices
      s tempWomenGeneralSurvey.Uterus = Uterus
      s tempWomenGeneralSurvey.Accessories = Accessories
      s tempWomenGeneralSurvey.Galactophore = Galactophore
      s tempWomenGeneralSurvey.BUltrasonic = BUltrasonic
      s tempWomenGeneralSurvey.ClinicalDiagnosis = ClinicalDiagnosis
      s tempWomenGeneralSurvey.GynecologicalDis = GynecologicalDis
      
      s PersonRowId = tempWomenGeneralSurvey.PersonRowId.%Id()
      
      &sql(select count(*) into :count from CHSS.WomenGeneralSurvey where PersonRowId= :PersonRowId and DateOfCheck> :DateOfCheck)
	  i count = 0 d
	  .&sql(delete from CHSS.PersonHealthDiagnose where ItemdCode= 29 and PersonRowIdParref= :PersonRowId)
	  .s result1 = ##class(%Library.ResultSet).%New()
	  .s sqlStr1 = "insert into CHSS.PersonHealthDiagnose (ItemdCode, ItemAssortName, PersonRowIdParref) select 29, Description, "_PersonRowId_" from CHSS.DictGynecologicalDisease where RowId in ("_GynecologicalDis_")"
      
      .d result1.Prepare(sqlStr1)
	  .d result1.Execute()
	  .d result1.Close()
        
      s result=""
      s result=tempWomenGeneralSurvey.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_SurveyRowId_"}"
      .///w "{""success"":""true"",""info"":"_SurveyRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-09-
/// Description:删除妇女普查记录
/// Table：WomenGeneralSurvey
/// Input: SurveyRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(SurveyRowId) As %String
{
                
      &sql(delete from CHSS.WomenGeneralSurvey where %ID=:SurveyRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_SurveyRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

Storage Default
{
<Data name="WomenGeneralSurveyServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WomenGeneralA23D</DataLocation>
<DefaultData>WomenGeneralSurveyServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WomenGeneralA23D</IdLocation>
<IndexLocation>^CHSSWeb.WomenGeneralA23I</IndexLocation>
<StreamLocation>^CHSSWeb.WomenGeneralA23S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
