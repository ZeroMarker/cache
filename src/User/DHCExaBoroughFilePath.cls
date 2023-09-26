Class User.DHCExaBoroughFilePath Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCExaBoroughFilePath ]
{

Index BordBorDrIndex On ExabDr;

Property ExabDr As DHCExaBorough;

Property ExabSubCallFilePath As %String(MAXLEN = 80, TRUNCATE = 1);

Property ExabSubWaitFilePath As %String(MAXLEN = 80, TRUNCATE = 1);

Property ExabSubMemo1 As %String(TRUNCATE = 1);

Property ExabSubMemo2 As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCExaBoroughFilePathDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExabCode</Value>
</Value>
<Value name="3">
<Value>ExabDepDr</Value>
</Value>
<Value name="4">
<Value>ExabMemo</Value>
</Value>
<Value name="5">
<Value>ExabName</Value>
</Value>
<Value name="6">
<Value>ExabTem</Value>
</Value>
<Value name="7">
<Value>ExabSubCallFilePath</Value>
</Value>
<Value name="8">
<Value>ExabSubMemo1</Value>
</Value>
<Value name="9">
<Value>ExabSubMemo2</Value>
</Value>
<Value name="10">
<Value>ExabSubWaitFilePath</Value>
</Value>
<Value name="11">
<Value>ExabDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCExaBoroughFilePathD</DataLocation>
<DefaultData>DHCExaBoroughFilePathDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCExaBoroughFilePathD</IdLocation>
<IndexLocation>^User.DHCExaBoroughFilePathI</IndexLocation>
<StreamLocation>^User.DHCExaBoroughFilePathS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
