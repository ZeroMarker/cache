Class CHSSWeb.PersonTrainingEvaluationService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2010-08-
/// Description:评估记录
/// Table：PersonTrainingEvaluation
/// Input: PersonTrainingEvaluation
/// Output：
/// Return：
/// Others：
ClassMethod List(TrainRowId As %Integer, start As %Integer, limit As %Integer, sort As %String) As %String
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
	  s sqlStr = "select EvaluateRowId from CHSS.PersonTrainingEvaluation where TrainRowId="_TrainRowId
      
      d result.Prepare(sqlStr)
	  d result.Execute()
      
      
      While(result.Next())
	  {
      
      s EvaluateRowId = result.Data("EvaluateRowId")     
                 
      s tempPersonTrainingEvaluation=##class(CHSS.PersonTrainingEvaluation).%OpenId(EvaluateRowId)
      
                 
          
      s EvaluateScore = tempPersonTrainingEvaluation.EvaluateScore
      
      set TrainEffectName = ""
      set TrainEffect = ""
      i tempPersonTrainingEvaluation.TrainEffect '= "" d
      .s TrainEffect = tempPersonTrainingEvaluation.TrainEffect.%Id()
      .s TrainEffectName = tempPersonTrainingEvaluation.TrainEffect.Description
      
           
      s ExecuteInfo = tempPersonTrainingEvaluation.ExecuteInfo
      s Problem = tempPersonTrainingEvaluation.Problem
      s HealingSuggestion = tempPersonTrainingEvaluation.HealingSuggestion
      s Other = tempPersonTrainingEvaluation.Other
      s EvaluateMan = tempPersonTrainingEvaluation.EvaluateMan
      
      s DateOfEvaluate = tempPersonTrainingEvaluation.DateOfEvaluate
      i DateOfEvaluate '= "" d
      .s DateOfEvaluate = $zd(DateOfEvaluate,3)
      
      
      Set tmp = EvaluateRowId_"^"_EvaluateScore_"^"_TrainEffect_"^"_TrainEffectName_"^"_ExecuteInfo_"^"_Problem_"^"_HealingSuggestion_"^"_Other_"^"_EvaluateMan_"^"_DateOfEvaluate



      Set count=count+1
      If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
      
	  }
      
      Set resultString = json.getJsonData("EvaluateRowId^EvaluateScore^TrainEffect^TrainEffectName^ExecuteInfo^Problem^HealingSuggestion^Other^EvaluateMan^DateOfEvaluate",count)
      k json
      
      Quit resultString
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description:添加评估记录
/// Table：PersonTrainingEvaluation
/// Input: PersonTrainingEvaluation
/// Output：
/// Return：
/// Others：
ClassMethod Insert(TrainRowId As %Integer, EvaluateScore As %Float, TrainEffect As %Integer, ExecuteInfo As %String, Problem As %String, HealingSuggestion As %String, Other As %String, EvaluateMan As %String, DateOfEvaluate As %Date) As %String
{
      s tempPersonTrainingEvaluation=""
      s tempPersonTrainingEvaluation=##class(CHSS.PersonTrainingEvaluation).%New()
      q:(tempPersonTrainingEvaluation="") 0
      
      
      s TrainRowIdobj=##class(CHSS.PersonDeformityTraining).%OpenId(TrainRowId)
      s tempPersonTrainingEvaluation.TrainRowId=TrainRowIdobj
      
                  
      s tempPersonTrainingEvaluation.EvaluateScore = EvaluateScore
      
      i TrainEffect '= "" d
      .s TrainEffectobj=##class(CHSS.DictTrainEffect).%OpenId(TrainEffect)
      .s tempPersonTrainingEvaluation.TrainEffect=TrainEffectobj
      
           
      s tempPersonTrainingEvaluation.ExecuteInfo = ExecuteInfo
      s tempPersonTrainingEvaluation.Problem = Problem
      s tempPersonTrainingEvaluation.HealingSuggestion = HealingSuggestion
      s tempPersonTrainingEvaluation.Other = Other
      s tempPersonTrainingEvaluation.EvaluateMan = EvaluateMan
      
      i DateOfEvaluate '= "" d
      .s DateOfEvaluate=$zdh(DateOfEvaluate ,3)
      s tempPersonTrainingEvaluation.DateOfEvaluate=DateOfEvaluate

 
      s result=""
      s result=tempPersonTrainingEvaluation.%Save()
      Set resultString = ""
      
           
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_tempPersonTrainingEvaluation.%Id()_"}"
      .///w "{""success"":""true"",""info"":"_tempPersonTrainingEvaluation.%Id()_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      .
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description:更新评估记录
/// Table：PersonTrainingEvaluation
/// Input: PersonTrainingEvaluation
/// Output：
/// Return：
/// Others：
ClassMethod Update(EvaluateRowId As %Integer, EvaluateScore As %Float, TrainEffect As %Integer, ExecuteInfo As %String, Problem As %String, HealingSuggestion As %String, Other As %String, EvaluateMan As %String, DateOfEvaluate As %Date) As %String
{
  
      q:($d(EvaluateRowId)=0)||(EvaluateRowId="")
      
      s tempPersonTrainingEvaluation="",result=""
      s tempPersonTrainingEvaluation=##class(CHSS.PersonTrainingEvaluation).%OpenId(EvaluateRowId)
      q:(tempPersonTrainingEvaluation="") 0
       
                        
      s tempPersonTrainingEvaluation.EvaluateScore = EvaluateScore
      
      i TrainEffect '= "" d
      .s TrainEffectobj=##class(CHSS.DictTrainEffect).%OpenId(TrainEffect)
      .s tempPersonTrainingEvaluation.TrainEffect=TrainEffectobj
      
           
      s tempPersonTrainingEvaluation.ExecuteInfo = ExecuteInfo
      s tempPersonTrainingEvaluation.Problem = Problem
      s tempPersonTrainingEvaluation.HealingSuggestion = HealingSuggestion
      s tempPersonTrainingEvaluation.Other = Other
      s tempPersonTrainingEvaluation.EvaluateMan = EvaluateMan
      
      i DateOfEvaluate '= "" d
      .s DateOfEvaluate=$zdh(DateOfEvaluate ,3)
      s tempPersonTrainingEvaluation.DateOfEvaluate=DateOfEvaluate

        
      s result=""
      s result=tempPersonTrainingEvaluation.%Save()
      Set resultString = ""
      
      
      i result = "1" d
      .s resultString = "{""success"":""true"",""info"":"_EvaluateRowId_"}"
      .///w "{""success"":""true"",""info"":"_EvaluateRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      .///w "{""success"":""false"",""info"":""数据保存出错!""}"
      q resultString
}

/// Creator: lyy
/// CreatDate：2010-08-
/// Description:删除评估记录
/// Table：PersonTrainingEvaluation
/// Input: EvaluateRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(EvaluateRowId As %String) As %String
{
                
      &sql(delete from CHSS.PersonTrainingEvaluation where %ID=:EvaluateRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_EvaluateRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

ClassMethod ListItems(EvaluateRowId, start, limit, sort) As %String
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
      
      if EvaluateRowId '= "" d
	  .s sqlStr = "select ItemRowId, RowIdDR, RowIdDR->Description as ItemName, Score, DegreeDR, DegreeDR->RowIdParref->Description from CHSS.PersonTrainingItem where EvaluateRowId="_EvaluateRowId
      e  d
      .s sqlStr = "select '' as ItemRowId, RowId as RowIdDR, Description as ItemName, '' as Score, '' as DegreeDR, '' as Description from CHSS.DictTrainingItem"
      
      d result.Prepare(sqlStr)
	  d result.Execute()
      
      
      While(result.Next())
	  {
      
      s ItemRowId = result.Data("ItemRowId")     
      s RowIdDR = result.Data("RowIdDR")       
      s ItemName = result.Data("ItemName")
      s Score = result.Data("Score") 
      s DegreeDR = result.Data("DegreeDR") 
      s Description = result.Data("Description") 
      
           
      Set tmp = ItemRowId_"^"_RowIdDR_"^"_ItemName_"^"_Score_"^"_DegreeDR_"^"_Description



      Set count=count+1
      If (count>start)&(count<=end) d
      .d json.InsertRowData(tmp)
      
	  }
      
      Set resultString = json.getJsonData("ItemRowId^RowIdDR^ItemName^Score^DegreeDR^Description",count)
      k json
      
      Quit resultString
}

ClassMethod InsertItems(EvaluateRowId, RowIdDR, Score, DegreeDR) As %String
{
    &sql(insert into CHSS.PersonTrainingItem (EvaluateRowId, RowIdDR, Score, DegreeDR) values(:EvaluateRowId,:RowIdDR,:Score,:DegreeDR))
	
	s result=SQLCODE
    Set resultString = ""
      
    i result = "0" d
    .s resultString = "{""success"":""true"",""info"":"_SQLCODE_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      
    q resultString
}

ClassMethod UpdateItems(ItemRowId, Score, DegreeDR) As %String
{
	
	&sql(update CHSS.PersonTrainingItem set Score=:Score, DegreeDR=:DegreeDR where %ID=:ItemRowId)
	
	s result=SQLCODE
    Set resultString = ""
      
    i result = "0" d
    .s resultString = "{""success"":""true"",""info"":"_ItemRowId_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      
    q resultString
}

ClassMethod ListPage1(Start, Limit, ItemRowId) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,RowIdParref->Description,Score FROM CHSS.DictTrainingItemVsDegree where ItemRowId="_ItemRowId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s Description = result.Data("Description")
	s Score = result.Data("Score")
	
	s tmp=Rowid_"^"_Description_"^"_Score

	s count = count+1
	i (count>Start)&(count<=end) d
	.d json.InsertRowData(tmp)
	.
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description^Score",count)
	k json
	q resultString
}

Storage Default
{
<Data name="PersonTrainingEvaluationServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonTrainiC9CD</DataLocation>
<DefaultData>PersonTrainingEvaluationServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonTrainiC9CD</IdLocation>
<IndexLocation>^CHSSWeb.PersonTrainiC9CI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonTrainiC9CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
