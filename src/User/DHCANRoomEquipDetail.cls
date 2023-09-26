/// DHC_AN_RoomEquipDetail
Class User.DHCANRoomEquipDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANRED_RowId, SqlTableName = DHC_AN_RoomEquipDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ANREDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_RoomEquip Parent Reference
Relationship ANREDParref As User.DHCANRoomEquip [ Cardinality = parent, Inverse = ChildDHCANRoomEquipDetail, Required, SqlFieldName = ANRED_Parref ];

/// Child subscript
Property ANREDChildSub As %Library.Float [ InitialExpression = {$i(^DHCANRoomEquip($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ANRED_ChildSub ];

/// ANRED_ComOrd_Dr
Property ANREDComOrdDr As User.DHCANCCommonOrd [ SqlColumnNumber = 3, SqlFieldName = ANRED_ComOrd_Dr ];

/// ANRED_Active
Property ANREDActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ANRED_Active ];

/// ANRED_ChannelNo
Property ANREDChannelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ANRED_ChannelNo ];

/// ANRED_ValuePiece
Property ANREDValuePiece As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ANRED_ValuePiece ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="ANRED_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANRED_ChannelNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANRED_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANRED_ValuePiece">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCANRoomEquip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_RoomEquip.ANRE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ANRED_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_RoomEquip.ANRE_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANRED_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChannelNo">
<Global>^DHCANRoomEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AN_RoomEquip.ANRE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ANRED_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ChannelNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANRED_ChannelNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AN_RoomEquip.ANRE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANRED_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANRoomEquipDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
