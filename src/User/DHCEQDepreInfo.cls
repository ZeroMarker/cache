Class User.DHCEQDepreInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DI_RowID, SqlTableName = DHC_EQDepreInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DI_EquipDR
Property DIEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = DI_EquipDR ];

/// DI_DepreTotal
Property DIDepreTotal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DI_DepreTotal ];

/// DI_PreDepreMonth
Property DIPreDepreMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DI_PreDepreMonth ];

/// DI_PreDepreFee
Property DIPreDepreFee As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DI_PreDepreFee ];

/// DI_Hold1
Property DIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DI_Hold1 ];

/// DI_Hold2
Property DIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DI_Hold2 ];

/// DI_Hold3
Property DIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DI_Hold3 ];

/// DI_Hold4
Property DIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DI_Hold4 ];

/// DI_Hold5
Property DIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDepreInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DI_DepreTotal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DI_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DI_PreDepreFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DI_PreDepreMonth">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQDepreInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQDepreInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DI_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDepreInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
