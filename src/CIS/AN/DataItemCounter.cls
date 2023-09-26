/// 数据项目使用计数器
Class CIS.AN.DataItemCounter Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DataItemCounter ]
{

/// 数据项目
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 2 ];

/// 计数
Property Counter As %Integer [ SqlColumnNumber = 3 ];

/// 数据项目索引
Index IDataItem On DataItem;

Storage Default
{
<Data name="DataItemCounterDefaultData">
<Value name="1">
<Value>DataItem</Value>
</Value>
<Value name="2">
<Value>Counter</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.DataItemCounterD</DataLocation>
<DefaultData>DataItemCounterDefaultData</DefaultData>
<IdLocation>^CIS.AN.DataItemCounterD</IdLocation>
<IndexLocation>^CIS.AN.DataItemCounterI</IndexLocation>
<StreamLocation>^CIS.AN.DataItemCounterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
