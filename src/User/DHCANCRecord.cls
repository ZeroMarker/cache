Class User.DHCANCRecord Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANCR_RowId, SqlTableName = DHC_ANC_Record, StorageStrategy = CacheStorage ]
{

Property ANCRCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCR_Code ];

Property ANCRDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCR_Desc ];

Property ANCRType As %String(DISPLAYLIST = ",Pre,Intra,Post,Consent,Summary,Analgesia,Recovery", SELECTIVITY = "12.50000%", VALUELIST = ",E,I,T,C,S,A,R") [ SqlColumnNumber = 4, SqlFieldName = ANCR_Type ];

Property ANCRFlag As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.33300%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANCR_Flag ];

Property ANCRValue As %String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = ANCR_Value ];

Property ANCRNote As %String(MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = ANCR_Note ];

Index Code On ANCRCode As Exact;

Storage CacheStorage
{
<Data name="DHCANCRecordClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCRecordDefaultData">
<Value name="1">
<Value>ANCRCode</Value>
</Value>
<Value name="2">
<Value>ANCRDesc</Value>
</Value>
<Value name="3">
<Value>ANCRType</Value>
</Value>
<Value name="4">
<Value>ANCRFlag</Value>
</Value>
<Value name="5">
<Value>ANCRValue</Value>
</Value>
<Value name="6">
<Value>ANCRNote</Value>
</Value>
</Data>
<DataLocation>^DHCANC("Record")</DataLocation>
<DefaultData>DHCANCRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("Record")</IdLocation>
<IndexLocation>^DHCANC("Record",0)</IndexLocation>
<StreamLocation>^User.DHCANCRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
