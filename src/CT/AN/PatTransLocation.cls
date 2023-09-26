Class CT.AN.PatTransLocation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PatTransLocation ]
{

/// 代码
Property Code As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 2 ];

/// 描述
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 序号
Property Order As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 4 ];

/// 类型
Property Type As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 5 ];

/// 数据归属
Property DataAttribution As CF.AN.DataAttribution [ SqlColumnNumber = 6 ];

/// 序号索引索引
Index IOrder On Order;

/// 类型索引
Index IType On (Type, Order);

Storage Default
{
<Data name="PatTransLocationDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Order</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="6">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^CT.AN.PatTransLocationD</DataLocation>
<DefaultData>PatTransLocationDefaultData</DefaultData>
<IdLocation>^CT.AN.PatTransLocationD</IdLocation>
<IndexLocation>^CT.AN.PatTransLocationI</IndexLocation>
<StreamLocation>^CT.AN.PatTransLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
