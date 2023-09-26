/// 科室透析方式
Class User.DHCBP.Config.BPModeLocation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BPModeLocation ]
{

Index Mode On BPMLBPCModeDr As Exact;

Index Ctloc On BPMLCtlocDr As Exact;

/// 透析方式
Property BPMLBPCModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 2, SqlFieldName = BPML_BPCMode_Dr ];

/// 科室
Property BPMLCtlocDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPML_Ctloc_Dr ];

/// 透析方式名称
Property BPMLModeAliasDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPML_ModeAliasDesc ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 5, SqlFieldName = BPML_DataAttribution ];

Storage Default
{
<Data name="BPModeLocationDefaultData">
<Value name="1">
<Value>BPMLBPCModeDr</Value>
</Value>
<Value name="2">
<Value>BPMLCtlocDr</Value>
</Value>
<Value name="3">
<Value>BPMLModeAliasDesc</Value>
</Value>
<Value name="4">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBP.Config.BPModeLocationD</DataLocation>
<DefaultData>BPModeLocationDefaultData</DefaultData>
<IdLocation>^DHCBP.Config.BPModeLocationD</IdLocation>
<IndexLocation>^DHCBP.Config.BPModeLocationI</IndexLocation>
<StreamLocation>^DHCBP.Config.BPModeLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
