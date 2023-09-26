Class User.DHCBPCEquipRunPara Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_EquipRunPara, StorageStrategy = CacheStorage ]
{

Property BPCERPBPCERPCDr As User.DHCBPCEquipRunParaCat [ SqlColumnNumber = 2, SqlFieldName = BPCERP_BPCERPC_Dr ];

Property BPCERPCode As %String [ SqlColumnNumber = 3, SqlFieldName = BPCERP_Code ];

Property BPCERPDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPCERP_Desc ];

Property BPCERPImage As %String [ SqlColumnNumber = 5, SqlFieldName = BPCERP_Image ];

Property BPCERPMin As %Float [ SqlColumnNumber = 6, SqlFieldName = BPCERP_Min ];

Property BPCERPMax As %Float [ SqlColumnNumber = 7, SqlFieldName = BPCERP_Max ];

Property BPCERPValue As %Float [ SqlColumnNumber = 8, SqlFieldName = BPCERP_Value ];

Property BPCERPIncrement As %Float [ SqlColumnNumber = 9, SqlFieldName = BPCERP_Increment ];

Property BPCERPShowImage As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = BPCERP_ShowImage ];

Property BPCERPShowRange As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = BPCERP_ShowRange ];

Property BPCERPShowValue As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = BPCERP_ShowValue ];

Index ParaCat On BPCERPBPCERPCDr;

Storage CacheStorage
{
<Data name="EquipRunParaClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="EquipRunParaDefaultData">
<Value name="1">
<Value>BPCERPBPCERPCDr</Value>
</Value>
<Value name="2">
<Value>BPCERPCode</Value>
</Value>
<Value name="3">
<Value>BPCERPDesc</Value>
</Value>
<Value name="4">
<Value>BPCERPImage</Value>
</Value>
<Value name="5">
<Value>BPCERPMin</Value>
</Value>
<Value name="6">
<Value>BPCERPMax</Value>
</Value>
<Value name="7">
<Value>BPCERPValue</Value>
</Value>
<Value name="8">
<Value>BPCERPIncrement</Value>
</Value>
<Value name="9">
<Value>BPCERPShowImage</Value>
</Value>
<Value name="10">
<Value>BPCERPShowRange</Value>
</Value>
<Value name="11">
<Value>BPCERPShowValue</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("EquipRunPara")</DataLocation>
<DefaultData>DHCBPCEquipRunParaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("EquipRunPara")</IdLocation>
<IndexLocation>^DHCBPC("EquipRunPara",0)</IndexLocation>
<StreamLocation>^User.DHCBPCEquipRunParaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
