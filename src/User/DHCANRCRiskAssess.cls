Class User.DHCANRCRiskAssess Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANRCRA_RowId, SqlTableName = DHC_ANRC_RiskAssess, StorageStrategy = CacheStorage ]
{

Property ANRCRAOperDiffcultyDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANRCRA_OperDiffculty_Dr ];

Property ANRCRAASADr As %String [ SqlColumnNumber = 3, SqlFieldName = ANRCRA_ASA_Dr ];

Property ANRCRAAnrcrcDr As User.DHCANRCRiskClass [ SqlColumnNumber = 4, SqlFieldName = ANRCRA_Anrcrc_Dr ];

Property ANRCRACtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = ANRCRA_Ctloc_Dr ];

Index Ctloc On ANRCRACtlocDr As Exact;

Storage CacheStorage
{
<Data name="DHCANRCRiskAssessClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRCRiskAssessDefaultData">
<Value name="1">
<Value>ANRCRAOperDiffcultyDr</Value>
</Value>
<Value name="2">
<Value>ANRCRAASADr</Value>
</Value>
<Value name="3">
<Value>ANRCRAAnrcrcDr</Value>
</Value>
<Value name="4">
<Value>ANRCRACtlocDr</Value>
</Value>
</Data>
<DataLocation>^DHCANRC("RiskAssess")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANRC("RiskAssess")</IdLocation>
<IndexLocation>^DHCANRC("RiskAssess",0)</IndexLocation>
<StreamLocation>^User.DHCANRCRiskAssessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
