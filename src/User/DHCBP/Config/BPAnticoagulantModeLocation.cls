Class User.DHCBP.Config.BPAnticoagulantModeLocation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BPAnticoagulantModeLocation ]
{

Index Anticoagulantmode On BPAMLBPCAMDr As Exact;

Index Ctloc On BPAMLCtlocDr As Exact;

/// 抗凝方式
Property BPAMLBPCAMDr As User.DHCBPCAnticoagulantMode [ SqlColumnNumber = 2, SqlFieldName = BPAML_BPCAM_Dr ];

/// 科室
Property BPAMLCtlocDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPAML_Ctloc_Dr ];

/// 抗凝方式名称
Property BPAMLAMAliasDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPAML_AMAliasDesc ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 5, SqlFieldName = BPAML_DataAttribution ];

Storage Default
{
<Data name="BPAnticoagulantModeLocationDefaultData">
<Value name="1">
<Value>BPAMLBPCAMDr</Value>
</Value>
<Value name="2">
<Value>BPAMLCtlocDr</Value>
</Value>
<Value name="3">
<Value>BPAMLAMAliasDesc</Value>
</Value>
<Value name="4">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBP.Config.BPAMLocationD</DataLocation>
<DefaultData>BPAnticoagulantModeLocationDefaultData</DefaultData>
<IdLocation>^DHCBP.Config.BPAMLocationD</IdLocation>
<IndexLocation>^DHCBP.Config.BPAMLocationI</IndexLocation>
<StreamLocation>^DHCBP.Config.BPAMLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
