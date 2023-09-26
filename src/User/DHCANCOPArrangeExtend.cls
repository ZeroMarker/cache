Class User.DHCANCOPArrangeExtend Extends %Persistent [ SqlRowIdName = ANCOPAE_RowId, SqlTableName = DHC_ANC_OPArrangeExtend, StorageStrategy = CacheStorage ]
{

Property ANCOPAECode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCOPAE_Code ];

Property ANCOPAEDesc As %String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = ANCOPAE_Desc ];

Property ANCOPAEType As %String(DISPLAYLIST = ",Plan,PreVisit,Induce,Anaesthesia,PACU,PostVisit,Recovery,OPSafety,OPCount,Transfer,BefDaySurgery,PostDaySurgery,DaySurgeryOut,OPNurseRecord", MAXLEN = 11, SELECTIVITY = "11.1111%", TRUNCATE = 1, VALUELIST = ",P,PR,I,A,PA,PO,R,OPS,OPC,T,BDS,PDS,ODS,OPNR") [ SqlColumnNumber = 4, SqlFieldName = ANCOPAE_Type ];

Property ANCOPAEActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANCOPAE_Active ];

Property ANCOPAEOption As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ANCOPAE_Option ];

Property ANCOPAESortNo As %String [ SqlColumnNumber = 7, SqlFieldName = ANCOPAE_SortNo ];

Property ANCOPAEANOPACode As %String [ SqlColumnNumber = 8, SqlFieldName = ANCOPAE_ANOPACode ];

Property ANCOPAEDataFormat As %String [ SqlColumnNumber = 9, SqlFieldName = ANCOPAE_DataFormat ];

Property ANCOPAEDataField As %String [ SqlColumnNumber = 10, SqlFieldName = ANCOPAE_DataField ];

Property ANCOPAEMainItem As User.DHCANCOPArrangeExtend [ SqlColumnNumber = 11, SqlFieldName = ANCOPAE_MainItem ];

Property ANCOPAEOptionType As %String(DISPLAYLIST = ",Radio,Check", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",R,C") [ SqlColumnNumber = 12, SqlFieldName = ANCOPAE_OptionType ];

Property ANCOPAEOptionCode As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ANCOPAE_OptionCode ];

Index Code On ANCOPAECode As Exact;

Index TypeCode On (ANCOPAEType As Exact, ANCOPAECode As Exact);

Storage CacheStorage
{
<Data name="ANCOPArrangeExtendClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="ANCOPArrangeExtendDefaultData">
<Value name="1">
<Value>ANCOPAECode</Value>
</Value>
<Value name="2">
<Value>ANCOPAEDesc</Value>
</Value>
<Value name="3">
<Value>ANCOPAEType</Value>
</Value>
<Value name="4">
<Value>ANCOPAEActive</Value>
</Value>
<Value name="5">
<Value>ANCOPAEOption</Value>
</Value>
<Value name="6">
<Value>ANCOPAESortNo</Value>
</Value>
<Value name="7">
<Value>ANCOPAEANOPACode</Value>
</Value>
<Value name="8">
<Value>ANCOPAEDataFormat</Value>
</Value>
<Value name="9">
<Value>ANCOPAEDataField</Value>
</Value>
<Value name="10">
<Value>ANCOPAEMainItem</Value>
</Value>
<Value name="11">
<Value>ANCOPAEOptionType</Value>
</Value>
<Value name="12">
<Value>ANCOPAEOptionCode</Value>
</Value>
</Data>
<DataLocation>^DHCANC("OPArrangeExtend")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("OPArrangeExtend")</IdLocation>
<IndexLocation>^DHCANC("OPArrangeExtend",0)</IndexLocation>
<StreamLocation>^User.DHCANCOPArrangeExtendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
