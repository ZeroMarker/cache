Class User.EnsKeyEvent Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_KeyEvent ]
{

/// 事件
Property IntEventName As %String(MAXLEN = 32767) [ SqlFieldName = Int_EventName ];

/// 事件描述
Property IntEventDesc As %String(MAXLEN = 32767) [ SqlFieldName = Int_EventDesc ];

/// 事件入参
Property IntInput As %String(MAXLEN = 32767) [ SqlFieldName = Int_Input ];

/// 入参描述
Property IntInputDesc As %String(MAXLEN = 32767) [ SqlFieldName = Int_InputDesc ];

Index IndextEventNameKeyString On IntEventName;

Storage Default
{
<Data name="EnsKeyEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IntEventName</Value>
</Value>
<Value name="3">
<Value>IntEventDesc</Value>
</Value>
<Value name="4">
<Value>IntInput</Value>
</Value>
<Value name="5">
<Value>IntInputDesc</Value>
</Value>
<Value name="6">
<Value>IntKeyString</Value>
</Value>
</Data>
<DataLocation>^User.EnsKeyEventD</DataLocation>
<DefaultData>EnsKeyEventDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsKeyEventD</IdLocation>
<IndexLocation>^User.EnsKeyEventI</IndexLocation>
<StreamLocation>^User.EnsKeyEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
