/// 天健体检数据采集表BonusTJData                                                                                                               
Class dhc.bonus.subs.BonusTJData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusTJDataID ]
{

Property TJItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property TJItemType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property TJItemNums As %Library.Integer [ SqlColumnNumber = 4 ];

Property TJItemJE As %Library.Float [ SqlColumnNumber = 5 ];

Property ZXDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property ZXDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property TJDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Property TJItemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property TJItemTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property InDate As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Index TJItemID On (TJItemCode, ZXDeptCode, ZXDeptName, TJDate);

Storage Default
{
<Data name="BonusTJDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TJItemCode</Value>
</Value>
<Value name="3">
<Value>TJItemType</Value>
</Value>
<Value name="4">
<Value>TJItemNums</Value>
</Value>
<Value name="5">
<Value>TJItemJE</Value>
</Value>
<Value name="6">
<Value>ZXDeptCode</Value>
</Value>
<Value name="7">
<Value>ZXDeptName</Value>
</Value>
<Value name="8">
<Value>TJDate</Value>
</Value>
<Value name="9">
<Value>TJItemName</Value>
</Value>
<Value name="10">
<Value>TJItemTypeName</Value>
</Value>
<Value name="11">
<Value>InDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusTJDataD</DataLocation>
<DefaultData>BonusTJDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusTJDataD</IdLocation>
<IndexLocation>^dhcbsBonusTJDataI</IndexLocation>
<StreamLocation>^dhcbsBonusTJDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
