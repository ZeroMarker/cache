Class User.DHCANRCManageAssess Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANRCMA_RowId, SqlTableName = DHC_ANRC_ManageAssess, StorageStrategy = CacheStorage ]
{

Property ANRCMAAnrcrcDr As User.DHCANRCRiskClass [ SqlColumnNumber = 2, SqlFieldName = ANRCMA_Anrcrc_Dr ];

Property ANRCMASourceType As %String(DISPLAYLIST = ",Booked,Restricted,Emergency", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",B,R,E") [ SqlColumnNumber = 3, SqlFieldName = ANRCMA_SourceType ];

Property ANRCMAAnrcmcDr As User.DHCANRCManageClass [ SqlColumnNumber = 4, SqlFieldName = ANRCMA_Anrcmc_Dr ];

Property ANRCMACtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = ANRCMA_Ctloc_Dr ];

Property ANRCMAMaxAgeDr As %Float [ SqlColumnNumber = 6, SqlFieldName = ANRCMA_MaxAge_Dr ];

Index Ctloc On ANRCMACtlocDr As Exact;

Storage CacheStorage
{
<Data name="DHCANRCManageAssessClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRCManageAssessDefaultData">
<Value name="1">
<Value>ANRCMAAnrcrcDr</Value>
</Value>
<Value name="2">
<Value>ANRCMASourceType</Value>
</Value>
<Value name="3">
<Value>ANRCMAAnrcmcDr</Value>
</Value>
<Value name="4">
<Value>ANRCMACtlocDr</Value>
</Value>
<Value name="5">
<Value>ANRCMAMaxAgeDr</Value>
</Value>
</Data>
<DataLocation>^DHCANRC("ManageAssess")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANRC("ManageAssess")</IdLocation>
<IndexLocation>^DHCANRC("ManageAssess",0)</IndexLocation>
<StreamLocation>^User.DHCANRCManageAssessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
