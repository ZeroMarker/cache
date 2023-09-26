Class CHSSWeb.PersonInfectionSta Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod Infecstatistics(code, date)
{
	s count=0
    Set json = ##class(Code.JsonObj).%New()
    s result = ##class(%Library.ResultSet).%New()
    s datenum =$zdh(date,3)
	s sqlStr ="select count(*) as  num ,InfectionRowIdParref as name from chss.PersonInfectionCard where CommunityCode="_code_" and DateOfRegister<="_datenum_" group by InfectionRowIdParref " 
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s count=count+1
		s num=result.Data("num")
		s name=result.Data("name")
		
		s tmp=num_"^"_name
		d json.InsertRowData(tmp)
    }
   	d result.Close()
	s resultString = json.getJsonData("num^name",count)
    k json
	q resultString
}

Storage Default
{
<Data name="PersonInfectionStaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonInfectionStaD</DataLocation>
<DefaultData>PersonInfectionStaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonInfectionStaD</IdLocation>
<IndexLocation>^CHSSWeb.PersonInfectionStaI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonInfectionStaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
