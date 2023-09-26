Class CSM.Dictionary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 字典表的表明
Property TableName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 字典表的描述
Property Description As %String(MAXLEN = 255, TRUNCATE = 1);

Storage Default
{
<Data name="DictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Descript</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CSM.DictionaryD</DataLocation>
<DefaultData>DictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.DictionaryD</IdLocation>
<IndexLocation>^CSM.DictionaryI</IndexLocation>
<StreamLocation>^CSM.DictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
