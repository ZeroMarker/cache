/// 指标明细统计项的定义
Class DHCWL.MRIPDay.KPIDetailItem Extends %Persistent [ SqlRowIdName = KPIDetailItem_RowID, SqlTableName = KPIDetailItem ]
{

//Property KPIDetailItemOPTLDetailItemDR As OPTLDetailItem [ Required, SqlColumnNumber = 2, SqlFieldName = KPIDetailItem_OPTLDetailItemDR ];

//Index KPIDetailItemOPTLDetailItemDRIndex On KPIDetailItemOPTLDetailItemDR;

Property KPIDtlItemOPTLDtlItemDR As OPTLDetailItem [ Required, SqlColumnNumber = 2, SqlFieldName = KPIDetailItem_OPTLDetailItemDR ];

Index KPIDtlItemOPTLDtlItemDRIndex On KPIDtlItemOPTLDtlItemDR;

Property KPIDetailItemDimProDR As DHCWL.MKPI.DimProperty [ SqlColumnNumber = 3, SqlFieldName = KPIDetailItem_DimProDR ];

Property KPIDetailItemDimProCode As %String [ SqlColumnNumber = 4, SqlFieldName = KPIDetailItem_DimProCode ];

Storage Default
{
<Data name="KPIDetailItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPIDtlItemOPTLDtlItemDR</Value>
</Value>
<Value name="3">
<Value>KPIDetailItemDimProDR</Value>
</Value>
<Value name="4">
<Value>KPIDetailItemDimProCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.KPIDetailItemD</DataLocation>
<DefaultData>KPIDetailItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.KPIDetailItemD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.KPIDetailItemI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.KPIDetailItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
