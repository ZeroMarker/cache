/// 科室血管通路
Class User.DHCBP.Config.BPVascularAccessLocation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BPVascularAccessLocation ]
{

Index VascularAccess On BPVALBPCVADr As Exact;

Index Ctloc On BPVALCtlocDr As Exact;

/// 血管通路
Property BPVALBPCVADr As User.DHCBPCVascularAccess [ SqlColumnNumber = 2, SqlFieldName = BPVAL_BPCVA_Dr ];

/// 科室
Property BPVALCtlocDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPVAL_Ctloc_Dr ];

/// 血管通路名称
Property BPVALVAAliasDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPVAL_VAAliasDesc ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 5, SqlFieldName = BPVAL_DataAttribution ];

Storage Default
{
<Data name="BPVascularAccessLocationDefaultData">
<Value name="1">
<Value>BPVALBPCVADr</Value>
</Value>
<Value name="2">
<Value>BPVALCtlocDr</Value>
</Value>
<Value name="3">
<Value>BPVALVAAliasDesc</Value>
</Value>
<Value name="4">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBP.Config.BPVALocationD</DataLocation>
<DefaultData>BPVascularAccessLocationDefaultData</DefaultData>
<IdLocation>^DHCBP.Config.BPVALocationD</IdLocation>
<IndexLocation>^DHCBP.Config.BPVALocationI</IndexLocation>
<StreamLocation>^DHCBP.Config.BPVALocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
