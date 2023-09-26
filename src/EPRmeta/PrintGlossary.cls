/// 术语集与打印模板关联表
Class EPRmeta.PrintGlossary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index Idx On TermID [ Unique ];

Property TermID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property TermName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property PrintDocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="PrintGlossaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrintDocID</Value>
</Value>
<Value name="3">
<Value>TermID</Value>
</Value>
<Value name="4">
<Value>TermName</Value>
</Value>
</Data>
<DataLocation>^EPRmeta.PrintGlossaryD</DataLocation>
<DefaultData>PrintGlossaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.PrintGlossaryD</IdLocation>
<IndexLocation>^EPRmeta.PrintGlossaryI</IndexLocation>
<StreamLocation>^EPRmeta.PrintGlossaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
