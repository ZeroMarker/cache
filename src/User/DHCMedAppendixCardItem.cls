Class User.DHCMedAppendixCardItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MACI_Rowid, SqlTableName = DHC_MedAppendixCardItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MACIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedAppendixCard Parent Reference
Relationship MACIParRef As User.DHCMedAppendixCard [ Cardinality = parent, Inverse = ChildDHCMedAppendixCardItem, Required, SqlFieldName = MACI_ParRef ];

/// Child subscript
Property MACIChildSub As %Library.Float [ InitialExpression = {$i(^DHCMAC($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MACI_ChildSub ];

/// MACI_MedDictory_DR
Property MACIMedDictoryDR As User.DHCMedDictory [ SqlColumnNumber = 3, SqlFieldName = MACI_MedDictory_DR ];

/// MACI_Active
Property MACIActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MACI_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MACI_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MACI_MedDictory_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedAppendixCard.MAC_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MACI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedAppendixCard.MAC_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MACI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAppendixCardItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
