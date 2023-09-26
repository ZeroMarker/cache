Class CHSSWeb.WhRecheckResultService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-5-
/// Description:孕产妇产前检查结论
/// Table：WhRecheckResult
/// Input: WhRecheckResult
/// Output：
/// Return：
/// Others：
ClassMethod List(WomanRowId As %Integer, RecheckRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
	  s sqlStr = "select RowId from CHSS.WhRecheckResult where WomanRowId="_WomanRowId_" and RecheckRowId="_RecheckRowId
      
      d result.Prepare(sqlStr)
	  d result.Execute()
      
      
      While(result.Next())
	  {
      
      s RowId = result.Data("RowId")     
                 
      s tempWhRecheckResult=##class(CHSS.WhRecheckResult).%OpenId(RowId)
      
      s CheckResultName = ""
      s CheckResult = ""
      i tempWhRecheckResult.CheckResult '= "" d
      .s CheckResult = tempWhRecheckResult.CheckResult.%Id()
      .s CheckResultName = tempWhRecheckResult.CheckResult.Description


      s HighRiskInfo = tempWhRecheckResult.HighRiskInfo
      s Suggestion1 = tempWhRecheckResult.Suggestion1
  
      s NutritionAppraise = tempWhRecheckResult.NutritionAppraise
      s NutritionSuggestion = tempWhRecheckResult.NutritionSuggestion
      
      
      Set tmp = RowId_"^"_CheckResult_"^"_CheckResultName_"^"_HighRiskInfo_"^"_Suggestion1_"^"_NutritionAppraise_"^"_NutritionSuggestion



      Set count=count+1
      If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
      
	  }
      
      Set resultString = json.getJsonData("RowId^CheckResult^CheckResultName^HighRiskInfo^Suggestion1^NutritionAppraise^NutritionSuggestion",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-5-
/// Description:添加孕产妇产前检查结论
/// Table：WhRecheckResult
/// Input: WhRecheckResult
/// Output：
/// Return：
/// Others：
ClassMethod Insert(WomanRowId As %Integer, RecheckRowId As %Integer, CheckResult As %Integer, HighRiskInfo As %String, Suggestion1 As %String, NutritionAppraise As %String, NutritionSuggestion As %String) As %String
{
      s tempWhRecheckResult=""
      s tempWhRecheckResult=##class(CHSS.WhRecheckResult).%New()
      q:(tempWhRecheckResult="") 0
      
	  
      s WomanRowIdobj=##class(CHSS.WomenBaseInfo).%OpenId(WomanRowId)
      s tempWhRecheckResult.WomanRowId=WomanRowIdobj
      
      s RecheckRowIdobj=##class(CHSS.WhAntepartumRecheck).%OpenId(RecheckRowId)
      s tempWhRecheckResult.RecheckRowId=RecheckRowIdobj
      
      i CheckResult '= "" d
      .s CheckResultobj = ##class(CHSS.DictWomenCheckResult).%OpenId(CheckResult)
      .s tempWhRecheckResult.CheckResult = CheckResultobj
      
      
      s tempWhRecheckResult.HighRiskInfo = HighRiskInfo
      s tempWhRecheckResult.Suggestion1 = Suggestion1
      s tempWhRecheckResult.NutritionAppraise = NutritionAppraise
      s tempWhRecheckResult.NutritionSuggestion = NutritionSuggestion

 
      s result=""
      s result=tempWhRecheckResult.%Save()
      Set resultString = ""
      
           
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempWhRecheckResult.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempWhRecheckResult.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-5-
/// Description:更新孕产妇产前检查结论
/// Table：WhRecheckResult
/// Input: WhRecheckResult
/// Output：
/// Return：
/// Others：
ClassMethod Update(RowId As %Integer, CheckResult As %Integer, HighRiskInfo As %String, Suggestion1 As %String, NutritionAppraise As %String, NutritionSuggestion As %String) As %String
{
  
      q:($d(RowId)=0)||(RowId="")
      
      s tempWhRecheckResult="",result=""
      s tempWhRecheckResult=##class(CHSS.WhRecheckResult).%OpenId(RowId)
      q:(tempWhRecheckResult="") 0
       
      
      i CheckResult '= "" d
      .s CheckResultobj = ##class(CHSS.DictWomenCheckResult).%OpenId(CheckResult)
      .s tempWhRecheckResult.CheckResult = CheckResultobj
      
      
      s tempWhRecheckResult.HighRiskInfo = HighRiskInfo
      s tempWhRecheckResult.Suggestion1 = Suggestion1
      s tempWhRecheckResult.NutritionAppraise = NutritionAppraise
      s tempWhRecheckResult.NutritionSuggestion = NutritionSuggestion

        
      s result=""
      s result=tempWhRecheckResult.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_RowId_"}"
      .///w "{""success"":""true"",""info"":"_RowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

Storage Default
{
<Data name="WhRecheckResultServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WhRecheckRes8C4D</DataLocation>
<DefaultData>WhRecheckResultServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WhRecheckRes8C4D</IdLocation>
<IndexLocation>^CHSSWeb.WhRecheckRes8C4I</IndexLocation>
<StreamLocation>^CHSSWeb.WhRecheckRes8C4S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
