Class User.DHCBPPunctureScheme Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_PunctureScheme, StorageStrategy = CacheStorage ]
{

Property BPPunPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPPun_PatRegister_Dr ];

Property BPPunVascularAccessDr As User.DHCBPVascularAccess [ SqlColumnNumber = 3, SqlFieldName = BPPun_VascularAccess_Dr ];

Property BPPunType As %String(DISPLAYLIST = ",Vein,Art", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",V,A") [ SqlColumnNumber = 4, SqlFieldName = BPPun_Type ];

Property BPPunPositionNum As %String [ SqlColumnNumber = 5, SqlFieldName = BPPun_PositionNum ];

Property BPPunLocationX As %Float [ SqlColumnNumber = 6, SqlFieldName = BPPun_LocationX ];

Property BPPunLocationY As %Float [ SqlColumnNumber = 7, SqlFieldName = BPPun_LocationY ];

Property BPPunLocationNote As %String [ SqlColumnNumber = 8, SqlFieldName = BPPun_LocationNote ];

Property BPPunStatus As %String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 9, SqlFieldName = BPPun_Status ];

Property BPPunUpdateUserDr As %String [ SqlColumnNumber = 10, SqlFieldName = BPPun_UpdateUser_Dr ];

Property BPPunUpdateDate As %Date [ SqlColumnNumber = 11, SqlFieldName = BPPun_UpdateDate ];

Property BPPunUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = BPPun_UpdateTime ];

Index Register On BPPunPatRegisterDr As Exact;

Index VascularAccess On BPPunVascularAccessDr As Exact;

Storage CacheStorage
{
<Data name="DHCBPPunctreSchemeDefaultData">
<Value name="1">
<Value>BPPunPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPPunVascularAccessDr</Value>
</Value>
<Value name="3">
<Value>BPPunType</Value>
</Value>
<Value name="4">
<Value>BPPunPositionNum</Value>
</Value>
<Value name="5">
<Value>BPPunLocationX</Value>
</Value>
<Value name="6">
<Value>BPPunLocationY</Value>
</Value>
<Value name="7">
<Value>BPPunLocationNote</Value>
</Value>
<Value name="8">
<Value>BPPunStatus</Value>
</Value>
<Value name="9">
<Value>BPPunUpdateUserDr</Value>
</Value>
<Value name="10">
<Value>BPPunUpdateDate</Value>
</Value>
<Value name="11">
<Value>BPPunUpdateTime</Value>
</Value>
</Data>
<Data name="DHCBPPunctureSchemeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<DataLocation>^DHCBPPunctureScheme</DataLocation>
<DefaultData>DHCBPBPPunctureSchemeDefaultData1</DefaultData>
<IdLocation>^DHCBPPunctureScheme</IdLocation>
<IndexLocation>^DHCBPPunctureScheme(0)</IndexLocation>
<StreamLocation>^User.DHCBPPunctureSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
