Class web.INSULISReportResultSen Extends %Persistent
{

Property AntibioCode As %String(CONTENT = "抗生素代码");

Property AntibioName As %String(CONTENT = "抗生素名称");

Property SenResult As %String(CONTENT = "抑菌浓度");

Property mmResult As %String(CONTENT = "纸片含药量");

Property MicResult As %String(CONTENT = "抑菌环直径");

Storage Default
{
<Data name="INSULISReportResultSenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntibioCode</Value>
</Value>
<Value name="3">
<Value>AntibioName</Value>
</Value>
<Value name="4">
<Value>SenResult</Value>
</Value>
<Value name="5">
<Value>mmResult</Value>
</Value>
<Value name="6">
<Value>MicResult</Value>
</Value>
</Data>
<DataLocation>^web.INSULISReportResultSenD</DataLocation>
<DefaultData>INSULISReportResultSenDefaultData</DefaultData>
<IdLocation>^web.INSULISReportResultSenD</IdLocation>
<IndexLocation>^web.INSULISReportResultSenI</IndexLocation>
<StreamLocation>^web.INSULISReportResultSenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
