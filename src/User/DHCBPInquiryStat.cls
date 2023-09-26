Class User.DHCBPInquiryStat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPIS_RowId, SqlTableName = DHC_BP_InquiryStat, StorageStrategy = CacheStorage ]
{

Property BPISBPCIDr As User.DHCBPCInquiry [ SqlColumnNumber = 2, SqlFieldName = BPIS_BPCI_Dr ];

Property BPISCode As %String [ SqlColumnNumber = 3, SqlFieldName = BPIS_Code ];

Property BPISDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPIS_Desc ];

Property BPISType As %String(DISPLAYLIST = ",Month,Season,Year", MAXLEN = 6, SELECTIVITY = "25%", VALUELIST = ",M,S,Y") [ SqlColumnNumber = 5, SqlFieldName = BPIS_Type ];

Property BPISStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BPIS_StartDate ];

Property BPISEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BPIS_EndDate ];

Property BPISUpdateUserDr As %String [ SqlColumnNumber = 8, SqlFieldName = BPIS_UpdateUser_Dr ];

Property BPISUpdateDate As %String [ SqlColumnNumber = 9, SqlFieldName = BPIS_UpdateDate ];

Property BPISUpdateTime As %String [ SqlColumnNumber = 10, SqlFieldName = BPIS_UpdateTime ];

Index BPCIType On (BPISBPCIDr As Exact, BPISType As Exact);

Storage CacheStorage
{
<Data name="DHCBPInquiryStatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPInquiryStatData">
<Value name="1">
<Value>BPISBPCIDr</Value>
</Value>
<Value name="2">
<Value>BPISCode</Value>
</Value>
<Value name="3">
<Value>BPISDesc</Value>
</Value>
<Value name="4">
<Value>BPISType</Value>
</Value>
<Value name="5">
<Value>BPISStartDate</Value>
</Value>
<Value name="6">
<Value>BPISEndDate</Value>
</Value>
<Value name="7">
<Value>BPISUpdateUserDr</Value>
</Value>
<Value name="8">
<Value>BPISUpdateDate</Value>
</Value>
<Value name="9">
<Value>BPISUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPInquiryStat</DataLocation>
<DefaultData>DHCBPInquiryStatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPInquiryStat</IdLocation>
<IndexLocation>^DHCBPInquiryStat(0)</IndexLocation>
<StreamLocation>^User.DHCBPInquiryStatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
