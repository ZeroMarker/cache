Class DHCWL.MRIPDay.CalItem Extends %Persistent [ SqlRowIdName = CalItem_RowID, SqlTableName = CalItem ]
{

Property CalItemOPTLItemDR As OPTLItem [ Required, SqlColumnNumber = 2, SqlFieldName = CalItem_OPTLItemDR ];

Index CalItemOPTLItemDRIndex On CalItemOPTLItemDR;

// Property CalItemItemType As %String [ SqlColumnNumber = 3, SqlFieldName = CalItem_ItemType ];

Property CalItemCalExp As %String(MAXLEN = 150) [ SqlColumnNumber = 4, SqlFieldName = CalItem_CalExp ];

// 合计的计算方法：0表示合计的计算方法同科室， 1表示合计的计算方法是将各科室值累加

Property CalItemTotalType As %String(MAXLEN = 150) [ SqlColumnNumber = 5, SqlFieldName = CalItem_TotalType ];

Storage Default
{
<Data name="CalItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CalItemOPTLItemDR</Value>
</Value>
<Value name="3">
<Value>CalItemItemType</Value>
</Value>
<Value name="4">
<Value>CalItemCalExp</Value>
</Value>
<Value name="5">
<Value>CalItemTotalType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.CalItemD</DataLocation>
<DefaultData>CalItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.CalItemD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.CalItemI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.CalItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
