Class CHSSWeb.RegionalMedicalInterface Extends %Persistent
{

/// Creator: wangbo
/// CreatDate：2010—07-30
/// Description:根据身份证判断是否存在个人档案  0：不存在；1:存在
/// Table：PersonHealthRecordMain
/// Input:IDCard
/// Output：
/// Return：
/// Others：
ClassMethod CheckPersonWithIDCard(IDCard As %String) As %String
{
		Set count=0
		Set resultString = "0"
		
		set PersonRowId = ""
		s sqlStr = ""
		s result = ##class(%Library.ResultSet).%New()
		s sqlStr = "SELECT PersonRowId FROM CHSS.PersonHealthRecordMain where IDCard = '"_IDCard_"'"
		
		d result.Prepare(sqlStr)
		d result.Execute()
		While(result.Next())
		{
			s PersonRowId = result.Get("PersonRowId")
		}
		i PersonRowId '= "" d
		.s resultString = "1"
		e  d
		.s resultString = "0"
	 	
		Quit resultString
}

Storage Default
{
<Data name="RegionalMedicalInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.RegionalMedi971D</DataLocation>
<DefaultData>RegionalMedicalInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.RegionalMedi971D</IdLocation>
<IndexLocation>^CHSSWeb.RegionalMedi971I</IndexLocation>
<StreamLocation>^CHSSWeb.RegionalMedi971S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
