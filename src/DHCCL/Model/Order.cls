/// 医嘱主表
Class DHCCL.Model.Order Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Order ]
{

Property Admission As DHCCL.Model.Admission [ Required, SqlColumnNumber = 2 ];

Property OrderDate As %Date [ SqlColumnNumber = 3 ];

Property OrderTime As %Time [ SqlColumnNumber = 4 ];

Property ExternalID As %String [ SqlColumnNumber = 5 ];

Index Adm On Admission;

Index Ext On ExternalID;

Storage Default
{
<Data name="OrderDefaultData">
<Value name="1">
<Value>Admission</Value>
</Value>
<Value name="2">
<Value>OrderDate</Value>
</Value>
<Value name="3">
<Value>OrderTime</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.OrderD</DataLocation>
<DefaultData>OrderDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.OrderD</IdLocation>
<IndexLocation>^DHCCL.Model.OrderI</IndexLocation>
<StreamLocation>^DHCCL.Model.OrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
