Class CHSSWeb.PersonCarePlanService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(start, limit)
{
	Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set end = start+limit
    Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select PlanRowId from CHSS.PersonCarePlan"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s count=count+1
		s PlanRowId = result.Data("PlanRowId")
		s PersonCarePlan = ##class(CHSS.PersonCarePlan).%OpenId(PlanRowId)
		s PlanName=PersonCarePlan.PlanName
		s PlanContent=PersonCarePlan.PlanContent
		s tmp=PlanRowId_"^"_PlanName_"^"_PlanContent
		If (count>start)&(count<=end) d
        .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("PlanRowId^PlanName^PlanContent",count)
    k json
	q resultString
}

ClassMethod insert(CaseHisRowId, PlanName, PlanContent)
{
	 s PersonCarePlan=""
     s PersonCarePlan=##class(CHSS.PersonCarePlan).%New()
     q:(PersonCarePlan="") 0
   
     s PersonCarePlan.PlanName=PlanName
	 s PersonCarePlan.PlanContent=PlanContent
	 
	 
	  i CaseHisRowId '= "" d
        .s CaseHisRowIdobj=##class(CHSS.PersonCaseHis).%OpenId(CaseHisRowId)
        .s PersonCarePlan.CaseHisRowId=CaseHisRowIdobj
	 
	
	 s result=""
     s result=PersonCarePlan.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCarePlan.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod edit(PlanRowId, PlanName, PlanContent)
{
     s PersonCarePlan=""
     s PersonCarePlan=##class(CHSS.PersonCarePlan).%OpenId(PlanRowId)
     q:(PersonCarePlan="") 0
     s PersonCarePlan.PlanName=PlanName
	 s PersonCarePlan.PlanContent=PlanContent
	
	 s result=""
     s result=PersonCarePlan.%Save()
     Set resultString = ""
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCarePlan.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod delete(PlanRowId)
{
	s PersonCarePlan=""
    s PersonCarePlan=##class(CHSS.PersonCarePlan).%OpenId(PlanRowId)
    q:(PersonCarePlan="") 0
	s result=PersonCarePlan.%DeleteId(PlanRowId)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

ClassMethod insertTest()
{
 s PlanName="1"
 s PlanContent="2"
 d ..insert(PlanName,PlanContent)
 w "OK"
}

ClassMethod editTest()
{
 s ItemRowId=1
  s PlanName="11"
 s PlanContent="22"
 d ..edit(ItemRowId,PlanName,PlanContent)
}

Storage Default
{
<Data name="PersonCarePlanServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonCarePlanServiceD</DataLocation>
<DefaultData>PersonCarePlanServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.PersonCarePlanServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonCarePlanServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonCarePlanServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
