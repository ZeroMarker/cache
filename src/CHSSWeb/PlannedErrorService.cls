Class CHSSWeb.PlannedErrorService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod addOrUpdate(ResponseRowId, ImmuCardRowId, RowIdDR, ProduceCodeAndPatch, UnitName, ReactionDate, Reaction, Diagnose, Remark, cOperator, dOperator)
{
	s temp=""
	i ResponseRowId="" d
	.s temp =##class(CHSS.BacterinAbnormalResponse).%New()
	.i ImmuCardRowId'="" d
	..s temp.ImmuCardRowId=##class(CHSS.ChildPlanedImmuCard).%OpenId(ImmuCardRowId)
	
	e  d 
	.s temp=##class(CHSS.BacterinAbnormalResponse).%OpenId(ResponseRowId)
	i RowIdDR'="" d
    .s temp.RowIdDR=##class(CHSS.DictBacterin).%OpenId(RowIdDR)
  

	s temp.ProduceCodeAndPatch=ProduceCodeAndPatch
	s temp.UnitName=UnitName
	
	i ReactionDate'="" d
	.s ReactionDate=$zdh(ReactionDate,3)
	.s temp.ReactionDate=ReactionDate
	
	
	s temp.Reaction=Reaction
	
	s temp.Diagnose=Diagnose
	
	s temp.Remark=Remark
	
	s temp.cOperator=cOperator
	
	i dOperator'="" d
	.s dOperator=$zdh(dOperator,3)
	.s temp.dOperator=dOperator
	s result=""
    s result=temp.%Save()
    Set resultString = ""
   
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_temp.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod List(CommunityCode, Start, Limit)
{
	Set CommunityCode=$G(CommunityCode)

	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	 s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ResponseRowId,ImmuCardRowId from CHSS.BacterinAbnormalResponse a where a.ImmuCardRowId->CommunityCode="_CommunityCode_""

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
   
	s ResponseRowId=result.Data("ResponseRowId")
	S ImmuCardRowId=result.Data("ImmuCardRowId")
	s tempChild = ##class(CHSS.BacterinAbnormalResponse).%OpenId(ResponseRowId)
	s tempImmuCard=##class(CHSS.ChildPlanedImmuCard).%OpenId(ImmuCardRowId)
    
    s VaccinateHandbookCode=tempImmuCard.VaccinateHandbookCode
    s ChildName=tempImmuCard.ChildName
    
    s ChildSex=""
    s ChildSexName=""
    i tempImmuCard.ChildSex'="" d 
    .s ChildSex=tempImmuCard.ChildSex.%Id()
    .s ChildSexName=tempImmuCard.ChildSex.CTSEXDesc
    
    
	s ChildBirth=tempImmuCard.ChildBirth
	i ChildBirth'="" d
	.s ChildBirth = $zd(ChildBirth,3)
    
    s RowIdDR=""
    s BacterinNames=""
    i tempChild.RowIdDR'="" d
    .s RowIdDR= tempChild.RowIdDR.%Id()
    .s BacterinNames=tempChild.RowIdDR.Description
    
    
    s ProduceCodeAndPatch=tempChild.ProduceCodeAndPatch
    s UnitName=tempChild.UnitName
   
    
    
    
    
	s ReactionDate=tempChild.ReactionDate
	i ReactionDate'="" d
	.s ReactionDate = $zd(ReactionDate,3)
	
	s Reaction=tempChild.Reaction
	s Diagnose=tempChild.Diagnose
	
	s Remark=tempChild.Remark
	s cOperator=tempChild.cOperator

	
	
	s dOperator=tempChild.dOperator
	i dOperator'="" d
	.s dOperator = $zd(dOperator,3)
	
	s tmp=""
	
	
	s tmp=ChildSex_"^"_ChildSexName_"^"_ChildBirth_"^"_VaccinateHandbookCode_"^"_ChildName_"^"_ResponseRowId_"^"_ImmuCardRowId_"^"_RowIdDR_"^"_BacterinNames_"^"_ProduceCodeAndPatch_"^"_UnitName_"^"_ReactionDate_"^"_Reaction_"^"_Diagnose_"^"_Remark_"^"_cOperator_"^"_dOperator
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("ChildSex^ChildSexName^ChildBirth^VaccinateHandbookCode^ChildName^ResponseRowId^ImmuCardRowId^RowIdDR^BacterinNames^ProduceCodeAndPatch^UnitName^ReactionDate^Reaction^Diagnose^Remark^cOperator^dOperator",count)
	k json	
	Quit resultString
}

ClassMethod search(searchText, CommunityCode, Start, Limit)
{
	 
	Set CommunityCode=$G(CommunityCode)
    Set searchText=$G(searchText)
    
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	 s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ResponseRowId,ImmuCardRowId from CHSS.BacterinAbnormalResponse a where a.ImmuCardRowId->CommunityCode="_CommunityCode_" and a.ImmuCardRowId->ChildName like '%"_searchText_"%'"

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
   
	s ResponseRowId=result.Data("ResponseRowId")
	S ImmuCardRowId=result.Data("ImmuCardRowId")
	s tempChild = ##class(CHSS.BacterinAbnormalResponse).%OpenId(ResponseRowId)
	s tempImmuCard=##class(CHSS.ChildPlanedImmuCard).%OpenId(ImmuCardRowId)
    
    s VaccinateHandbookCode=tempImmuCard.VaccinateHandbookCode
    s ChildName=tempImmuCard.ChildName
    
    s ChildSex=""
    s ChildSexName=""
    i tempImmuCard.ChildSex'="" d 
    .s ChildSex=tempImmuCard.ChildSex.%Id()
    .s ChildSexName=tempImmuCard.ChildSex.CTSEXDesc
    
    
	s ChildBirth=tempImmuCard.ChildBirth
	i ChildBirth'="" d
	.s ChildBirth = $zd(ChildBirth,3)
    
    s RowIdDR=""
    s BacterinNames=""
    i tempChild.RowIdDR'="" d
    .s RowIdDR= tempChild.RowIdDR.%Id()
    .s BacterinNames=tempChild.RowIdDR.Description
    
    
    s ProduceCodeAndPatch=tempChild.ProduceCodeAndPatch
    s UnitName=tempChild.UnitName
   
    
    
    
    
	s ReactionDate=tempChild.ReactionDate
	i ReactionDate'="" d
	.s ReactionDate = $zd(ReactionDate,3)
	
	s Reaction=tempChild.Reaction
	s Diagnose=tempChild.Diagnose
	
	s Remark=tempChild.Remark
	s cOperator=tempChild.cOperator

	
	
	s dOperator=tempChild.dOperator
	i dOperator'="" d
	.s dOperator = $zd(dOperator,3)
	
	s tmp=""
	
	
	s tmp=ChildSex_"^"_ChildSexName_"^"_ChildBirth_"^"_VaccinateHandbookCode_"^"_ChildName_"^"_ResponseRowId_"^"_ImmuCardRowId_"^"_RowIdDR_"^"_BacterinNames_"^"_ProduceCodeAndPatch_"^"_UnitName_"^"_ReactionDate_"^"_Reaction_"^"_Diagnose_"^"_Remark_"^"_cOperator_"^"_dOperator
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("ChildSex^ChildSexName^ChildBirth^VaccinateHandbookCode^ChildName^ResponseRowId^ImmuCardRowId^RowIdDR^BacterinNames^ProduceCodeAndPatch^UnitName^ReactionDate^Reaction^Diagnose^Remark^cOperator^dOperator",count)
	k json	
	Quit resultString
}

Storage Default
{
<Data name="PlannedErrorServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PlannedErrorServiceD</DataLocation>
<DefaultData>PlannedErrorServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PlannedErrorServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PlannedErrorServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PlannedErrorServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
