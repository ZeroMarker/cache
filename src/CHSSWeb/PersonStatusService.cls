Class CHSSWeb.PersonStatusService Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod Update(PersonRowId As %String, PersonStatus As %String) As %String
{
	 
  q:PersonRowId="" ""
  s tempCheck = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
    i PersonStatus '="" d
   	.s tempPersonStatus = ##class(CHSS.DictArchivesStatus).%OpenId(PersonStatus)
    .s tempCheck.PersonStatus=tempPersonStatus
  
	s result=tempCheck.%Save()
	 s RowId= tempCheck.%Id() //$g(%ROWID)
     i result = "1" d
     .w "{""success"":""true"",""info"":"_tempCheck.%Id()_"}"
     e  d
     .w "{""success"":""false"",""info"":""数据保存出错!""}"
    q ""
}

Storage Default
{
<Data name="PersonStatusServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonStatusServiceD</DataLocation>
<DefaultData>PersonStatusServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonStatusServiceD</IdLocation>
<IndexLocation>^CHSSWeb.PersonStatusServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonStatusServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
