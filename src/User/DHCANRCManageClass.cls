Class User.DHCANRCManageClass Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANRCMC_RowId, SqlTableName = DHC_ANRC_ManageClass, StorageStrategy = CacheStorage ]
{

Property ANRCMCCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANRCMC_Code ];

Property ANRCMCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANRCMC_Desc ];

Property ANRCMCCtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANRCMC_Ctloc_Dr ];

Property ANRCMCAuditCarPrvTpDr As %String [ SqlColumnNumber = 5, SqlFieldName = ANRCMC_Audit_CarPrvTpDr ];

Index Ctloc On ANRCMCCtlocDr As Exact;

Storage CacheStorage
{
<Data name="DHCANRCManageClassClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRCManageClassDefaultData">
<Value name="1">
<Value>ANRCMCCode</Value>
</Value>
<Value name="2">
<Value>ANRCMCDesc</Value>
</Value>
<Value name="3">
<Value>ANRCMCCtlocDr</Value>
</Value>
</Data>
<Data name="DHCANRCManageClassDefaultData1">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>ANRCMCAuditCarPrvTpDr</Value>
</Value>
</Data>
<DataLocation>^DHCANRC("ManageClass")</DataLocation>
<DefaultData>DHCANRCManageClassDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANRC("ManageClass")</IdLocation>
<IndexLocation>^DHCANRC("ManageClass",0)</IndexLocation>
<StreamLocation>^User.DHCANRCManageClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
