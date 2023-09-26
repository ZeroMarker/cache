Class User.DHCANRCLocCheck Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANRCLC_RowId, SqlTableName = DHC_ANRC_LocCheck, StorageStrategy = CacheStorage ]
{

Property ANRCLCAnrcmcDr As User.DHCANRCManageClass [ SqlColumnNumber = 2, SqlFieldName = ANRCLC_Anrcmc_Dr ];

Property ANRCLCAnrcciDr As User.DHCANRCCheckItem [ SqlColumnNumber = 3, SqlFieldName = ANRCLC_Anrcci_Dr ];

Property ANRCLCCtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANRCLC_Ctloc_Dr ];

Index Ctloc On ANRCLCCtlocDr As Exact;

Storage CacheStorage
{
<Data name="DHCANRCLocCheckClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRCLocCheckDefaultData">
<Value name="1">
<Value>ANRCLCAnrcmcDr</Value>
</Value>
<Value name="2">
<Value>ANRCLCAnrcciDr</Value>
</Value>
<Value name="3">
<Value>ANRCLCCtlocDr</Value>
</Value>
</Data>
<DataLocation>^DHCANRC("LocCheck")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANRC("LocCheck")</IdLocation>
<IndexLocation>^DHCANRC("LocCheck",0)</IndexLocation>
<StreamLocation>^User.DHCANRCLocCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
