Class CIS.AN.UserDefItemCounter Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = UserDefItemCounter ]
{

/// 自定义项目
Property UserDefinedItem As CF.AN.UserDefDataItem [ Required, SqlColumnNumber = 2 ];

/// 计数
Property Counter As %Integer [ SqlColumnNumber = 3 ];

/// 自定义项目索引
Index IItem On UserDefinedItem;

Storage Default
{
<Data name="UserDefItemCounterDefaultData">
<Value name="1">
<Value>UserDefinedItem</Value>
</Value>
<Value name="2">
<Value>Counter</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.UserDefItemCounterD</DataLocation>
<DefaultData>UserDefItemCounterDefaultData</DefaultData>
<IdLocation>^CIS.AN.UserDefItemCounterD</IdLocation>
<IndexLocation>^CIS.AN.UserDefItemCounterI</IndexLocation>
<StreamLocation>^CIS.AN.UserDefItemCounterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
