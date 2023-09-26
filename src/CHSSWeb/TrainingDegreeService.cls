Class CHSSWeb.TrainingDegreeService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod listT(Start, Limit) As %String
{
	  s result= ##class(%Library.ResultSet).%New()
	  s sqlStr="select * from CHSS.DictTrainingItem"
	  d result.Prepare(sqlStr)
	  d result.Execute()
	  s count=0
	  s resultString=""
	  s end=Start+Limit
	  s json=##class(Code.JsonObj).%New()
	  
	  while(result.Next())
	  {
		  s RowId=result.Data("RowId")
		  s temp= ##class(CHSS.DictTrainingItem).%OpenId(RowId)
		  s Code=temp.Code
		  s Description=temp.Description
		  s StartDate=temp.StartDate
		  i StartDate'=""
		  s StartDate=$zd(StartDate,3)
		  s EndDate=temp.EndDate 
		  i EndDate'=""
		  s EndDate=$zd(EndDate,3)	
		  s Active=temp.Active
		  s Sort=temp.Sort
		  
		  s tmpStr=RowId_"^"_Code_"^"_Description_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort
		  s count=count+1
		  
	      i (count>Start)&(count<=end) d
	      .d json.InsertRowData(tmpStr)
		  
	  }
	  d result.Close()
	  s resultString=json.getJsonData("RowId^Code^Description^StartDate^EndDate^Active^Sort",count)
	  k json
	  q resultString
}

ClassMethod listTD(Start, Limit, ItemRowId) As %String
{
	  
	  s result= ##class(%Library.ResultSet).%New()
	  s sqlStr="select * from CHSS.DictTrainingItemVsDegree where ItemRowId="_ItemRowId
	  d result.Prepare(sqlStr)
	  d result.Execute()
	  s count=0
	  s resultString=""
	  s end=Start+Limit
	  s json=##class(Code.JsonObj).%New()
	  
	  while(result.Next())
	  {
		  s RowId=result.Data("RowId")
		  s temp= ##class(CHSS.DictTrainingItemVsDegree).%OpenId(RowId)
	      s ItemRowId=temp.ItemRowId.%Id()
		  s DegreeName=""
		  s DegreeCode=""
		  s DegreeId=temp.RowIdParref.%Id()
		  s DegreeName=temp.RowIdParref.Description
		  s DegreeCode=temp.RowIdParref.Code
		  s Score=""
		  i temp.Score'="" d
		  .s Score=temp.Score
		  
		  s tmpStr=RowId_"^"_ItemRowId_"^"_DegreeId_"^"_DegreeCode_"^"_DegreeName_"^"_Score
		  s count=count+1
		  
	      i (count>Start)&(count<=end) d
	      .d json.InsertRowData(tmpStr)
		  
	  }
	  d result.Close()
	  s resultString=json.getJsonData("RowId^ItemRowId^DegreeId^DegreeCode^DegreeName^Score",count)
	  k json
	  q resultString
}

ClassMethod listD(Start, Limit) As %String
{
      s result= ##class(%Library.ResultSet).%New()
	  s sqlStr="select * from CHSS.DictTrainDegree "
	  d result.Prepare(sqlStr)
	  d result.Execute()
	  s count=0
	  s resultString=""
	  s end=Start+Limit
	  s json=##class(Code.JsonObj).%New()
	  
	  while(result.Next())
	  {
		  s DegreeId=result.Data("RowId")
		  s temp= ##class(CHSS.DictTrainDegree).%OpenId(DegreeId)
		  s Code=temp.Code
		  s DegreeName=temp.Description
		  s StartDate=temp.StartDate
		  i StartDate'=""
		  s StartDate=$zd(StartDate,3)
		  s EndDate=temp.EndDate 
		  i EndDate'=""
		  s EndDate=$zd(EndDate,3)	
		  s Active=temp.Active
		  s Sort=temp.Sort
		  
		  s tmpStr=DegreeId_"^"_Code_"^"_DegreeName_"^"_StartDate_"^"_EndDate_"^"_Active_"^"_Sort
		  s count=count+1
		  
		  i (count>Start)&(count<end) d
		  .d json.InsertRowData(tmpStr)
		  
	  }
	  d result.Close()
	  s resultString=json.getJsonData("DegreeId^Code^DegreeName^StartDate^EndDate^Active^Sort",count)
	  k json
	  q resultString
}

ClassMethod deleteAll(ItemRowId)
{
	s ItemRowId=$G(ItemRowId)
	&sql(delete from CHSS.DictTrainingItemVsDegree where ItemRowId=:ItemRowId)
	q SQLCODE
}

ClassMethod insert(Limit, TVsDRowId, ItemRowId, RowIdParref)
{
 
    s Limit=$G(Limit)
	s TVsDRowId=$G(TVsDRowId)
	s ItemRowId=$G(ItemRowId)
	s RowIdParref=$G(RowIdParref)
	
	i Limit=0 d
	.s count=..deleteAll(ItemRowId)
	
	i TVsDRowId ="" d
	.s temp=##class(CHSS.DictTrainingItemVsDegree).%New()
	
	i ItemRowId '="" d
	.s temp.ItemRowId=##class(CHSS.DictTrainingItem).%OpenId(ItemRowId)
	
	i RowIdParref '="" d
	.s temp.RowIdParref=##class(CHSS.DictTrainDegree).%OpenId(RowIdParref)
	
	s result=""
	s result=temp.%Save()
	s resultString=""
	
	i result="1" d
	.s resultString="{""success"":""true"",""info"":""1""}"
	e  d
	.s resultString="{""success"":""false"",""info"":""数据保存出错！""}"
	q resultString
}

ClassMethod updateScore(TVsDRowId, fieldValue)
{
    i TVsDRowId '="" d
	d  &sql(update CHSS.DictTrainingItemVsDegree set Score=:fieldValue where RowId=:TVsDRowId)
	q SQLCODE
}

Storage Default
{
<Data name="TrainingDegreeServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.TrainingDegreeServiceD</DataLocation>
<DefaultData>TrainingDegreeServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.TrainingDegreeServiceD</IdLocation>
<IndexLocation>^CHSSWeb.TrainingDegreeServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.TrainingDegreeServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
