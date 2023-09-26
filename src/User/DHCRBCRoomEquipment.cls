Class User.DHCRBCRoomEquipment Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCRME_RowID, SqlTableName = DHCRBC_Room_Equipment, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCRMEChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRBC_Room Parent Reference
Relationship DCRMEParRef As User.DHCRBCRoom [ Cardinality = parent, Inverse = ChildDHCRBCRoomEquipment, Required, SqlFieldName = DCRME_ParRef ];

/// Child subscript
Property DCRMEChildSub As %Library.Float [ InitialExpression = {$i(^DHCRBC("DHCRBCROOMEQUIPMENT"))}, Required, SqlColumnNumber = 2, SqlFieldName = DCRME_ChildSub ];

/// DCRME_Equipment_DR
Property DCRMEEquipmentDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DCRME_Equipment_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DCRME_Equipment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRBC_Room.DCRM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DCRME_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RoomEquipment"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRBC_Room.DCRM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRME_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEQ">
<Global>^DHCRBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRBC_Room.DCRM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DCRME_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EQDR-ROOM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRME_Equipment_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRBC_Room.DCRM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRME_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCRoomEquipmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
