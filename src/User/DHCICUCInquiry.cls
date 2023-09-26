Class User.DHCICUCInquiry Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUCI_RowId, SqlTableName = DHC_ICUC_Inquiry, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCICUCInquiryItem As User.DHCICUCInquiryItem [ Cardinality = children, Inverse = ICUCIIParref ];

Index Ctloc On ICUCICtlocDr As Exact;

Property ICUCICode As %String [ SqlColumnNumber = 2, SqlFieldName = ICUCI_Code ];

Property ICUCIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ICUCI_Desc ];

Property ICUCICtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ICUCI_Ctloc_Dr ];

Property ICUCIStatus As %String(DISPLAYLIST = ",Initial,Search,Finish", MAXLEN = 7, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",I,S,F") [ SqlColumnNumber = 5, SqlFieldName = ICUCI_Status ];

Property ICUCIType As %String(DISPLAYLIST = ",All,Location,User,SelfDefine,DataDefine", MAXLEN = 10, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",A,L,U,S,D") [ SqlColumnNumber = 6, SqlFieldName = ICUCI_Type ];

Property ICUCISearchLevel As %String [ SqlColumnNumber = 7, SqlFieldName = ICUCI_SearchLevel ];

Property ICUCIIcuaCount As %Float [ SqlColumnNumber = 8, SqlFieldName = ICUCI_IcuaCount ];

Property ICUCIResultCount As %Float [ SqlColumnNumber = 9, SqlFieldName = ICUCI_ResultCount ];

Property ICUCIIsByDate As %Boolean [ SqlColumnNumber = 10, SqlFieldName = ICUCI_IsByDate ];

Property ICUCIDataType As %String(DISPLAYLIST = ",Patient,MultiPatient,Location,Summary,CRF,DateTime", MAXLEN = 12, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",P,M,L,S,C,D") [ SqlColumnNumber = 11, SqlFieldName = ICUCI_DataType ];

Property ICUCIDateTimeType As %String(DISPLAYLIST = ",Record,InWard", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",R,I") [ SqlColumnNumber = 12, SqlFieldName = ICUCI_DateTimeType ];

Property ICUCIUpdateUserDr As %String [ SqlColumnNumber = 13, SqlFieldName = ICUCI_UpdateUser_Dr ];

Property ICUCIUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = ICUCI_UpdateDate ];

Property ICUCIUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = ICUCI_UpdateTime ];

Property ICUCIClassifyCode As %String(DISPLAYLIST = ",Normal,User", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,U") [ SqlColumnNumber = 16, SqlFieldName = ICUCI_ClassifyCode ];

Index TypeUser On (ICUCIType As Exact, ICUCIUpdateUserDr As Plus);

Storage CacheStorage
{
<Data name="DHCICUCInquiryClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUCInquiryDefaultData">
<Value name="1">
<Value>ICUCICode</Value>
</Value>
<Value name="2">
<Value>ICUCIDesc</Value>
</Value>
<Value name="3">
<Value>ICUCICtlocDr</Value>
</Value>
<Value name="4">
<Value>ICUCIStatus</Value>
</Value>
<Value name="5">
<Value>ICUCIType</Value>
</Value>
<Value name="6">
<Value>ICUCISearchLevel</Value>
</Value>
<Value name="7">
<Value>ICUCIIcuaCount</Value>
</Value>
<Value name="8">
<Value>ICUCIResultCount</Value>
</Value>
<Value name="9">
<Value>ICUCIIsByDate</Value>
</Value>
<Value name="10">
<Value>ICUCIDataType</Value>
</Value>
<Value name="11">
<Value>ICUCIDateTimeType</Value>
</Value>
<Value name="12">
<Value>ICUCIUpdateUserDr</Value>
</Value>
<Value name="13">
<Value>ICUCIUpdateDate</Value>
</Value>
<Value name="14">
<Value>ICUCIUpdateTime</Value>
</Value>
<Value name="15">
<Value>ICUCIClassifyCode</Value>
</Value>
</Data>
<DataLocation>^DHCICUCInquiry</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUCInquiry</IdLocation>
<IndexLocation>^DHCICUCInquiry(0)</IndexLocation>
<StreamLocation>^User.DHCICUCInquiryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
