Class EPRservice.TestAndTools.EPRTest Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(EPRservice.TemplatePriv.TestUnit).TestResultSet("134","90")
ClassMethod TestResultSet(parAdmId As %String, parQueryString As %String)
{
		
	Set rset = ##class(%ResultSet).%New(parQueryString)
	Set columns = rset.GetColumnCount()
	
	Set sc = rset.Execute(parAdmId)
	
	While (rset.Next()) {
	Write "------------------------",!
	For col = 1:1:columns {
	Write rset.GetColumnName(col),": "
	Write rset.GetData(col),!
	}
	Write "------------------------",!
	}
	Do rset.Close()
}

/// w ##class(EPRservice.TestAndTools.EPRTest).MyTest()
ClassMethod MyTest()
{
	Set file=##class(%File).%New("c:/file.txt")
	Do file.Open("WSN") //打开一份文件，若它已存在，则覆盖
	Do file.Write("This is a line of text !!!")
	do file.Close()
}

/// w ##class(EPRservice.TestAndTools.EPRTest).MyTest2()
ClassMethod MyTest2()
{
	b "s"
	s codeCol=""
	&sql(select DicCodeCol into :codeCol from EPRmeta.StdDictionary where TableName = ' SQLUSdddddddddddER.PAC_WARD')
    q codeCol
}

Storage Default
{
<Data name="EPRTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservi.EPRTestD</DataLocation>
<DefaultData>EPRTestDefaultData</DefaultData>
<IdLocation>^EPRservi.EPRTestD</IdLocation>
<IndexLocation>^EPRservi.EPRTestI</IndexLocation>
<StreamLocation>^EPRservi.EPRTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
