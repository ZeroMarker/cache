Class DHCWL.MRIPDay.DetailRpt Extends %Persistent [ SqlRowIdName = DetailRpt_RowID, SqlTableName = DetailRpt ]
{

Property DetailRptCode As %String [ SqlColumnNumber = 2, SqlFieldName = DetailRpt_Code ];

Property DetailRptDesc As %String [ SqlColumnNumber = 3, SqlFieldName = DetailRpt_Desc ];

Property DetailRptRptDR As Rpt [ SqlColumnNumber = 4, SqlFieldName = DetailRpt_RptDR ];

Property DetailRptOPTLItemDR As OPTLItem [ SqlColumnNumber = 5, SqlFieldName = DetailRpt_OPTLItemDR ];

Property DetailRptOPTLDetailItems As %String [ SqlColumnNumber = 6, SqlFieldName = DetailRpt_OPTLDetailItems ];

Index RptOPTLItem On (DetailRptRptDR, DetailRptOPTLItemDR);

Index RptOPTL On DetailRptRptDR;

Storage Default
{
<Data name="DetailRptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailRptCode</Value>
</Value>
<Value name="3">
<Value>DetailRptDesc</Value>
</Value>
<Value name="4">
<Value>DetailRptRptDR</Value>
</Value>
<Value name="5">
<Value>DetailRptOPTLItemDR</Value>
</Value>
<Value name="6">
<Value>DetailRptOPTLDetailItems</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.DetailRptD</DataLocation>
<DefaultData>DetailRptDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.DetailRptD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.DetailRptI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.DetailRptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
