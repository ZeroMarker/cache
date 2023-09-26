Class EPRinstance.EPRMessageGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 组内用户
Property UserIDS As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EPRMessageGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserIDS</Value>
</Value>
<Value name="3">
<Value>ReceiverUserID</Value>
</Value>
</Data>
<DataLocation>^EPRinstance.EPRMessageGroupD</DataLocation>
<DefaultData>EPRMessageGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRinstance.EPRMessageGroupD</IdLocation>
<IndexLocation>^EPRinstance.EPRMessageGroupI</IndexLocation>
<StreamLocation>^EPRinstance.EPRMessageGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
