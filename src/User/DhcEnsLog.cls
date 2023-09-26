Class User.DhcEnsLog Extends (%Persistent, %Populate, %XML.Adaptor) [ Inheritance = right, SqlTableName = DhcEns_Log ]
{

/// 函数类型
Property LogFunType As %String;

/// 方法名称
Property LogFunName As %String;

/// 入参
Property LogInPut As %GlobalCharacterStream;

/// 出参
Property LogOutPut As %GlobalCharacterStream;

/// 操作日期
Property LogDate As %Date;

/// 操作时间
Property LogTime As %Time;

Storage Default
{
<Data name="DhcEnsLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FunName</Value>
</Value>
<Value name="3">
<Value>Input</Value>
</Value>
<Value name="4">
<Value>OutPut</Value>
</Value>
<Value name="5">
<Value>SDate</Value>
</Value>
<Value name="6">
<Value>STime</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>InPut</Value>
</Value>
<Value name="9">
<Value>FunType</Value>
</Value>
<Value name="10">
<Value>LogDate</Value>
</Value>
<Value name="11">
<Value>LogFunName</Value>
</Value>
<Value name="12">
<Value>LogFunType</Value>
</Value>
<Value name="13">
<Value>LogInPut</Value>
</Value>
<Value name="14">
<Value>LogOutPut</Value>
</Value>
<Value name="15">
<Value>LogTime</Value>
</Value>
</Data>
<DataLocation>^User.DhcEnsLogD</DataLocation>
<DefaultData>DhcEnsLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DhcEnsLogD</IdLocation>
<IndexLocation>^User.DhcEnsLogI</IndexLocation>
<StreamLocation>^User.DhcEnsLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
