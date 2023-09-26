/// DHC_AN_RoomEquip
Class User.DHCANRoomEquip Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANRE_RowId, SqlTableName = DHC_AN_RoomEquip, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCANRoomEquipDetail As User.DHCANRoomEquipDetail [ Cardinality = children, Inverse = ANREDParref ];

/// ANRE_Room_Dr
Property ANRERoomDr As User.DHCANCOperRoom [ SqlColumnNumber = 2, SqlFieldName = ANRE_Room_Dr ];

/// ANRE_Equip_Dr
Property ANREEquipDr As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = ANRE_Equip_Dr ];

/// ANRE_TcpipAddress
Property ANRETcpipAddress As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ANRE_TcpipAddress ];

/// ANRE_Port
Property ANREPort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ANRE_Port ];

/// ANRE_InterfaceProgram
Property ANREInterfaceProgram As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ANRE_InterfaceProgram ];

/// ANRE_DefaultInterval
Property ANREDefaultInterval As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ANRE_DefaultInterval ];

/// ANRE_EditTcpipAddress
Property ANREEditTcpipAddress As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ANRE_EditTcpipAddress ];

Index ANREEquipDrUnqIdx1 On ANREEquipDr [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANRoomEquip(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANRE_DefaultInterval">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANRE_EditTcpipAddress">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANRE_Equip_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANRE_InterfaceProgram">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANRE_Port">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANRE_Room_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANRE_TcpipAddress">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCANRoomEquip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ANRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ANRE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCANRoomEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANRE_Equip_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoom">
<Global>^DHCANRoomEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Room"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANRE_Room_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANRoomEquipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
