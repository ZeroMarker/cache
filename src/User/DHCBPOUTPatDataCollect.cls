Class User.DHCBPOUTPatDataCollect Extends (%Persistent, %Populate) [ Owner = {_SYSTEM}, SqlRowIdName = BPOUT_PAC_RowId, SqlTableName = DHC_BP_OUT_PationDataCollect ]
{

/// BPOUT_PAC_Admdr
Property BPOUTPACREGON As %Library.String [ SqlColumnNumber = 2, SqlFieldName = BPOUT_PAC_RegNo ];

/// BPOUT_PAC_Item
Property BPOUTPACItem As %Library.String [ SqlColumnNumber = 3, SqlFieldName = BPOUT_PAC_Item ];

/// BPOUT_PAC_Date
Property BPOUTPACDATE As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = BPOUT_PAC_Date ];

/// BPOUT_PAC_Time
Property BPOUTPACTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = BPOUT_PAC_Time ];

/// BPOUT_PAC_Value
Property BPOUTPACValue As %Library.String [ SqlColumnNumber = 6, SqlFieldName = BPOUT_PAC_Value ];

Index Regon On BPOUTPACREGON;

Index Value On (BPOUTPACREGON, BPOUTPACDATE);

Storage Default
{
<Data name="DHCBPOUTPatDataCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BPOUTPACREGON</Value>
</Value>
<Value name="3">
<Value>BPOUTPACItem</Value>
</Value>
<Value name="4">
<Value>BPOUTPACDATE</Value>
</Value>
<Value name="5">
<Value>BPOUTPACTime</Value>
</Value>
<Value name="6">
<Value>BPOUTPACValue</Value>
</Value>
</Data>
<DataLocation>^User.DHCBPOUTPatDataCollectD</DataLocation>
<DefaultData>DHCBPOUTPatDataCollectDefaultData</DefaultData>
<IdLocation>^User.DHCBPOUTPatDataCollectD</IdLocation>
<IndexLocation>^User.DHCBPOUTPatDataCollectI</IndexLocation>
<StreamLocation>^User.DHCBPOUTPatDataCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
