/// DHCWL_MRIPDay.RptItem  d ##class(DHCWL.MRIPDay.RptItem).%BuildIndices()
Class DHCWL.MRIPDay.RptItem Extends %Persistent [ SqlRowIdName = RptItem_RowID, SqlTableName = RptItem ]
{

Property RptItemCode As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = RptItem_Code ];

Index RptItemCodeIndex On RptItemCode;

Index RptItemRptDRCodeIndex On (RptItemRptDR, RptItemCode);

Property RptItemDesc As %String [ SqlColumnNumber = 3, SqlFieldName = RptItem_Desc ];

Property RptItemRptDR As Rpt [ SqlColumnNumber = 4, SqlFieldName = RptItem_RptDR ];

Index RptItemRptDRIndex On RptItemRptDR;

Property RptItemOPTLItemDR As OPTLItem [ SqlColumnNumber = 5, SqlFieldName = RptItem_OPTLItemDR ];

Index RptItemOPTLItemDRIndex On RptItemOPTLItemDR;

Property RptItemOrder As %Integer [ SqlColumnNumber = 6, SqlFieldName = RptItem_Order ];

Index RptOPTLIndex On (RptItemRptDR, RptItemOPTLItemDR);

Storage Default
{
<Data name="RptItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptItemCode</Value>
</Value>
<Value name="3">
<Value>RptItemDesc</Value>
</Value>
<Value name="4">
<Value>RptItemRptDR</Value>
</Value>
<Value name="5">
<Value>RptItemOPTLItemDR</Value>
</Value>
<Value name="6">
<Value>RptItemOrder</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.RptItemD</DataLocation>
<DefaultData>RptItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.RptItemD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.RptItemI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.RptItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
