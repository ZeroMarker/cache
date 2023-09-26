Class CT.AN.OperLinkPosition Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperLinkPosition ]
{

/// 手术
Property Operation As %String [ Required, SqlColumnNumber = 2 ];

/// 手术体位
Property OperPosition As %String [ Required, SqlColumnNumber = 3 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 5 ];

Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

Index IOperation On Operation;

Index IOperPosition On OperPosition;

Index IActive On Active;

Storage Default
{
<Data name="OperLinkPositionDefaultData">
<Value name="1">
<Value>Operation</Value>
</Value>
<Value name="2">
<Value>OperPosition</Value>
</Value>
<Value name="3">
<Value>ActiveDate</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperLinkPositionD</DataLocation>
<DefaultData>OperLinkPositionDefaultData</DefaultData>
<IdLocation>^CT.AN.OperLinkPositionD</IdLocation>
<IndexLocation>^CT.AN.OperLinkPositionI</IndexLocation>
<StreamLocation>^CT.AN.OperLinkPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
