/// JK数据采集接口
Class dhc.bonus.data.DataInterface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DataInterfaceID ]
{

Property InterfaceCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property InterfaceName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property InterfaceType As %Library.Integer [ Required, SqlColumnNumber = 4 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 5 ];

Property UpateDate As %Library.Date [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="DataInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InterfaceCode</Value>
</Value>
<Value name="3">
<Value>InterfaceName</Value>
</Value>
<Value name="4">
<Value>InterfaceType</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
<Value name="6">
<Value>UpateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsDataInterfaceD</DataLocation>
<DefaultData>DataInterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsDataInterfaceD</IdLocation>
<IndexLocation>^dhcbsDataInterfaceI</IndexLocation>
<StreamLocation>^dhcbsDataInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
