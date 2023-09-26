Class User.DHCBPCAnticoagulantMode Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCAM_RowId, SqlTableName = DHC_BPC_AnticoagulantMode, StorageStrategy = CacheStorage ]
{

Property BPCAMCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCAM_Code ];

Property BPCAMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCAM_Desc ];

/// 是否选择药品
Property BPCAMIfSelectDrug As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "25%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = BPCAM_IfSelectDrug ];

/// 是否使用
Property BPCAMIfActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "25%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BPCAM_IfActive ];

/// 类型(血透、腹透)
Property BPCAMSubType As %String(DISPLAYLIST = ",HemoDialysis,PeritonealDialysis", MAXLEN = 7, SELECTIVITY = "33.3333%", VALUELIST = ",H,P") [ SqlColumnNumber = 6, SqlFieldName = BPCAM_SubType ];

Storage CacheStorage
{
<Data name="BPCAnticoagulantModeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPCAnticoagulantModeDefaultData">
<Value name="1">
<Value>BPCAMCode</Value>
</Value>
<Value name="2">
<Value>BPCAMDesc</Value>
</Value>
<Value name="3">
<Value>BPCAMIfSelectDrug</Value>
</Value>
<Value name="4">
<Value>BPCAMIfActive</Value>
</Value>
<Value name="5">
<Value>BPCAMSubType</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("AnticoagulantMode")</DataLocation>
<DefaultData>BPCAnticoagulantModeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("AnticoagulantMode")</IdLocation>
<IndexLocation>^DHCBPC("AnticoagulantMode")</IndexLocation>
<StreamLocation>^User.DHCBPCAnticoagulantModeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
