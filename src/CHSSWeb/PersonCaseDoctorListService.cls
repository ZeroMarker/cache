Class CHSSWeb.PersonCaseDoctorListService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(start, limit)
{
	Set start=$G(start)
    Set limit=$G(limit)
    Set count=0
    Set end = start+limit
    Set json = ##class(Code.JsonObj).%New()
      
      
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DoctorList from CHSS.PersonCaseDoctorList"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s count=count+1
		s DoctorList = result.Data("DoctorList")
		s PersonCaseDoctorList = ##class(CHSS.PersonCaseDoctorList).%OpenId(DoctorList)
		s DeptId=PersonCaseDoctorList.DeptId
		s DoctorId=PersonCaseDoctorList.DoctorId
		s cRemark=PersonCaseDoctorList.cRemark
		s tmp=DoctorList_"^"_DeptId_"^"_DoctorId_"^"_cRemark
		If (count>start)&(count<=end) d
        .d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("DoctorList^DeptId^DoctorId^cRemark",count)
    k json
	q resultString
}

ClassMethod insert(CaseHisRowId, DeptId, DoctorId, cRemark)
{
	 s PersonCaseDoctorList=""
     s PersonCaseDoctorList=##class(CHSS.PersonCaseDoctorList).%New()
     q:(PersonCaseDoctorList="") 0
   
   
      i CaseHisRowId '= "" d
        .s CaseHisRowIdobj=##class(CHSS.PersonCaseHis).%OpenId(CaseHisRowId)
        .s PersonCarePlan.CaseHisRowId=CaseHisRowIdobj
        
        
     s PersonCaseDoctorList.DeptId=DeptId
	 s PersonCaseDoctorList.DoctorId=DoctorId
	 s PersonCaseDoctorList.cRemark=cRemark
	
	 s result=""
     s result=PersonCaseDoctorList.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCaseDoctorList.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod edit(DoctorList, DeptId, DoctorId, cRemark)
{
     s PersonCaseDoctorList=""
     s PersonCaseDoctorList=##class(CHSS.PersonCaseDoctorList).%OpenId(DoctorList)
     q:(PersonCaseDoctorList="") 0
      s PersonCaseDoctorList.DeptId=DeptId
	 s PersonCaseDoctorList.DoctorId=DoctorId
	 s PersonCaseDoctorList.cRemark=cRemark
	
	 s result=""
     s result=PersonCaseDoctorList.%Save()
     Set resultString = ""
   
     i result = "1" d
     .s resultString = "{""success"":""true"",""info"":"_PersonCaseDoctorList.%Id()_"}"
     e  d
     .s resultString = "{""success"":""failed"",""info"":""error""}"
     q resultString
}

ClassMethod delete(DoctorList)
{
	s PersonCaseDoctorList=""
    s PersonCaseDoctorList=##class(CHSS.PersonCaseDoctorList).%OpenId(DoctorList)
    q:(PersonCaseDoctorList="") 0
	s result=PersonCaseDoctorList.%DeleteId(DoctorList)
	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

Storage Default
{
<Data name="PersonCaseDoctorListServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonCaseDoACBD</DataLocation>
<DefaultData>PersonCaseDoctorListServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.PersonCaseDoACBD</IdLocation>
<IndexLocation>^CHSSWeb.PersonCaseDoACBI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonCaseDoACBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
