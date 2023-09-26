Class User.DHCBPOUTEquipInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPOUT_EqIn_RowId, SqlTableName = DHC_BP_OUT_EquipInfo ]
{

/// BPOUT_EqIn_LocalIP
Property BPOUTEqInLocalIP As %Library.String [ SqlColumnNumber = 2, SqlFieldName = BPOUT_EqIn_LocalIP ];

/// BPOUT_EqIn_EqNo
Property BPOBPOUTEqInEqNo As %Library.String [ SqlColumnNumber = 3, SqlFieldName = BPOUT_EqIn_EqNo ];

/// BPOUT_EqIn_EqIP
Property BPOUTEqInEqIP As %Library.String [ SqlColumnNumber = 4, SqlFieldName = BPOUT_EqIn_EqIP ];

/// BPOUT_EqIn_EqPort
Property BPOUTEqInEqPort As %Library.String [ SqlColumnNumber = 5, SqlFieldName = BPOUT_EqIn_EqPort ];

/// BPOUT_EqIn_CollCode
Property BPOUTEqInCollCode As %Library.String [ SqlColumnNumber = 6, SqlFieldName = BPOUT_EqIn_CollCode ];

Storage Default
{
<Data name="DHCBPOUTEquipInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BPOUTEqInLocalIP</Value>
</Value>
<Value name="3">
<Value>BPOBPOUTEqInEqNo</Value>
</Value>
<Value name="4">
<Value>BPOUTEqInEqIP</Value>
</Value>
<Value name="5">
<Value>BPOUTEqInEqPort</Value>
</Value>
<Value name="6">
<Value>BPOUTEqInCollCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCBPOUTEquipInfoD</DataLocation>
<DefaultData>DHCBPOUTEquipInfoDefaultData</DefaultData>
<IdLocation>^User.DHCBPOUTEquipInfoD</IdLocation>
<IndexLocation>^User.DHCBPOUTEquipInfoI</IndexLocation>
<StreamLocation>^User.DHCBPOUTEquipInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
