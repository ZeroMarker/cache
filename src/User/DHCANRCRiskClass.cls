/// 
Class User.DHCANRCRiskClass Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANRCRC_RowId, SqlTableName = DHC_ANRC_RiskClass, StorageStrategy = CacheStorage ]
{

Property ANRCRCCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANRCRC_Code ];

Property ANRCRCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANRCRC_Desc ];

Property ANRCRCCtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANRCRC_Ctloc_Dr ];

Storage CacheStorage
{
<Data name="DHCANRCRiskClassClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRCRiskClassDefaultData">
<Value name="1">
<Value>ANRCRCCode</Value>
</Value>
<Value name="2">
<Value>ANRCRCDesc</Value>
</Value>
<Value name="3">
<Value>ANRCRCCtlocDr</Value>
</Value>
</Data>
<DataLocation>^DHCANRC("RiskClass")</DataLocation>
<DefaultData>DHCANRCRiskClassDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANRC("RiskClass")</IdLocation>
<IndexLocation>^DHCANRC("RiskClass",0)</IndexLocation>
<StreamLocation>^User.DHCANRCRiskClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
