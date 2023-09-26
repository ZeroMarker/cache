Class CHSSWeb.HISInterface.DictQuery Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-05-24
/// Description:根据RowId获取Description字段
ClassMethod GetDictQuery(temp As %String, TableName As %String) As %String
{
	s temp = $g(temp)
	s TableName = $g(TableName)
	s result = ##class(%Library.ResultSet).%New()
	s tempStr = ""
	s description = ""
	s count = $l(temp,",")
	s j=1
	for i=1:1:count 
	{
		s tempRowId = $p(temp,",",j,i)
		s j=j+1
		s sqlStr = "select Description from CHSS."_TableName_" where RowId="_tempRowId
		d result.Prepare(sqlStr)
		d result.Execute()
		
		while(result.Next())
		{
			s description = result.Data("Description")
		}
		
		if tempStr=""
		{
			s tempStr=description
		}
		else
		{
			s tempStr=tempStr_","_description
		}
		d result.Close()
	}
	q tempStr
}

Storage Default
{
<Data name="DictQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HISInterf6F2.DictQueryD</DataLocation>
<DefaultData>DictQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HISInterf6F2.DictQueryD</IdLocation>
<IndexLocation>^CHSSWeb.HISInterf6F2.DictQueryI</IndexLocation>
<StreamLocation>^CHSSWeb.HISInterf6F2.DictQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
