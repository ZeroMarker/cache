Class User.DHCANCInquiry Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ANC_Inquiry, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCANCInquiryItem As User.DHCANCInquiryItem [ Cardinality = children, Inverse = ANCIIParref ];

Index Ctloc On ANCICtlocDr As Exact;

Property ANCICode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCI_Code ];

Property ANCIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCI_Desc ];

Property ANCICtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANCI_Ctloc_Dr ];

Property ANCIStatus As %String(DISPLAYLIST = ",Initial,Search,Finish", MAXLEN = 7, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",I,S,F") [ SqlColumnNumber = 5, SqlFieldName = ANCI_Status ];

Property ANCIType As %String(DISPLAYLIST = ",All,Location,User", MAXLEN = 8, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",A,L,U") [ SqlColumnNumber = 6, SqlFieldName = ANCI_Type ];

Property ANCISearchLevel As %String [ SqlColumnNumber = 7, SqlFieldName = ANCI_SearchLevel ];

Property ANCIOpaCount As %Float [ SqlColumnNumber = 8, SqlFieldName = ANCI_OpaCount ];

Property ANCIResultCount As %Float [ SqlColumnNumber = 9, SqlFieldName = ANCI_ResultCount ];

Property ANCIIsByDate As %Boolean [ SqlColumnNumber = 10, SqlFieldName = ANCI_IsByDate ];

Property ANCIDataType As %String(DISPLAYLIST = ",Patient,MultiPatient,Location,Summary,CRF", MAXLEN = 12, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",P,M,L,S,C") [ SqlColumnNumber = 11, SqlFieldName = ANCI_DataType ];

Property ANCIDateTimeType As %String(DISPLAYLIST = ",Record,InWard", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",R,I") [ SqlColumnNumber = 12, SqlFieldName = ANCI_DateTimeType ];

Property ANCIUpdateUserDr As %String [ SqlColumnNumber = 13, SqlFieldName = ANCI_UpdateUser_Dr ];

Property ANCIUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = ANCI_UpdateDate ];

Property ANCIUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = ANCI_UpdateTime ];

Property ANCIIsActive As %Boolean [ SqlColumnNumber = 16, SqlFieldName = ANCI_IsActive ];

Property ANCIAvailableCtlocDr As %String(MAXLEN = 100) [ SqlColumnNumber = 17, SqlFieldName = ANCI_AvailableCtloc_Dr ];

Storage CacheStorage
{
<Data name="DHCANCInquiryClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCInquiryDefaultData">
<Value name="1">
<Value>ANCICode</Value>
</Value>
<Value name="2">
<Value>ANCIDesc</Value>
</Value>
<Value name="3">
<Value>ANCICtlocDr</Value>
</Value>
<Value name="4">
<Value>ANCIStatus</Value>
</Value>
<Value name="5">
<Value>ANCIType</Value>
</Value>
<Value name="6">
<Value>ANCISearchLevel</Value>
</Value>
<Value name="7">
<Value>ANCIOpaCount</Value>
</Value>
<Value name="8">
<Value>ANCIResultCount</Value>
</Value>
<Value name="9">
<Value>ANCIIsByDate</Value>
</Value>
<Value name="10">
<Value>ANCIDataType</Value>
</Value>
<Value name="11">
<Value>ANCIDateTimeType</Value>
</Value>
<Value name="12">
<Value>ANCIUpdateUserDr</Value>
</Value>
<Value name="13">
<Value>ANCIUpdateDate</Value>
</Value>
<Value name="14">
<Value>ANCIUpdateTime</Value>
</Value>
<Value name="15">
<Value>ANCIIsActive</Value>
</Value>
<Value name="16">
<Value>ANCIAvailableCtlocDr</Value>
</Value>
</Data>
<DataLocation>^DHCANCInquiry</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANCInquiry</IdLocation>
<IndexLocation>^DHCANCInquiry(0)</IndexLocation>
<StreamLocation>^User.DHCANCInquiryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
