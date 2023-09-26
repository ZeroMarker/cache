/// DHCWL_MRIPDay.Rpt  d ##class(DHCWL.MRIPDay.Rpt).%BuildIndices()
Class DHCWL.MRIPDay.Rpt Extends %Persistent [ SqlRowIdName = Rpt_RowID, SqlTableName = Rpt ]
{

Property RptCode As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = Rpt_Code ];

Index RptCodeIndex On RptCode [ Unique ];

Property RptDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Rpt_Desc ];

Property RptMMgrCode As %String(MAXLEN = 150) [ SqlColumnNumber = 4, SqlFieldName = Rpt_MMgrCode ];

Property RptMMgrDR As DHCWL.MKPI.MMgrRptCfg [ SqlColumnNumber = 5, SqlFieldName = Rpt_MMgrDR ];

Property RptType As %String [ SqlColumnNumber = 6, SqlFieldName = Rpt_Type ];

Property RptDimProIDs As %String [ SqlColumnNumber = 7, SqlFieldName = Rpt_DimProIDs ];

Property RptDimProCodes As %String [ SqlColumnNumber = 8, SqlFieldName = Rpt_DimProCodes ];

Storage Default
{
<Data name="RptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptCode</Value>
</Value>
<Value name="3">
<Value>RptDesc</Value>
</Value>
<Value name="4">
<Value>RptMMgrCode</Value>
</Value>
<Value name="5">
<Value>RptMMgrDR</Value>
</Value>
<Value name="6">
<Value>RptType</Value>
</Value>
<Value name="7">
<Value>RptDimProIDs</Value>
</Value>
<Value name="8">
<Value>RptDimProCodes</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.RptD</DataLocation>
<DefaultData>RptDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.RptD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.RptI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.RptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
