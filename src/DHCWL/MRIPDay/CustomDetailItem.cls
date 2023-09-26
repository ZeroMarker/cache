Class DHCWL.MRIPDay.CustomDetailItem Extends %Persistent [ SqlRowIdName = CustomDetailItem_RowID, SqlTableName = CustomDetailItem ]
{

//Property CustomDetailItemOPTLDetailItemDR As OPTLDetailItem [ Required, SqlColumnNumber = 2, SqlFieldName = CustomDetailItem_OPTLDetailItemDR ];

Property CstDtlItemOPTLDtlItemDR As OPTLDetailItem [ Required, SqlColumnNumber = 2, SqlFieldName = CustomDetailItem_OPTLDetailItemDR ];

Index CstDtlItemOPTLDtlItemDRIndex On CstDtlItemOPTLDtlItemDR;

//Index CustomDetailItemOPTLDetailItemDRIndex On CstDtlItemOPTLDtlItemDR;

Property CustomDetailItemCustomFunc As %String(MAXLEN = 150) [ SqlColumnNumber = 3, SqlFieldName = CustomDetailItem_CustomFunc ];

Storage Default
{
<Data name="CustomDetailItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CstDtlItemOPTLDtlItemDR</Value>
</Value>
<Value name="3">
<Value>CustomDetailItemCustomFunc</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.CustomDetai91D1D</DataLocation>
<DefaultData>CustomDetailItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.CustomDetai91D1D</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.CustomDetai91D1I</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.CustomDetai91D1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
