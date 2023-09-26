/// DHC_ICU_BedEquip
Class User.DHCICUBedEquip Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUBE_RowId, SqlTableName = DHC_ICU_BedEquip, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCICUBedEquipDetail As User.DHCICUBedEquipDetail [ Cardinality = children, Inverse = ICUBEDParref ];

/// ICUBE_Bed_Dr
Property ICUBEBedDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ICUBE_Bed_Dr ];

/// ICUBE_Equip_Dr
Property ICUBEEquipDr As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = ICUBE_Equip_Dr ];

/// ICUBE_TcpipAddress
Property ICUBETcpipAddress As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ICUBE_TcpipAddress ];

/// ICUBE_Port
Property ICUBEPort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ICUBE_Port ];

/// ICUBE_InterfaceProgram
Property ICUBEInterfaceProgram As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ICUBE_InterfaceProgram ];

/// ICUBE_DefaultInterval
Property ICUBEDefaultInterval As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ICUBE_DefaultInterval ];

/// ICUBE_EditTcpipAddress
Property ICUBEEditTcpipAddress As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ICUBE_EditTcpipAddress ];

Index ICUBEEquipDrUnqIdx1 On ICUBEEquipDr [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUBedEquip(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUBE_Bed_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUBE_DefaultInterval">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUBE_EditTcpipAddress">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUBE_Equip_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUBE_InterfaceProgram">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUBE_Port">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUBE_TcpipAddress">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCICUBedEquip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICUBE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ICUBE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBed">
<Global>^DHCICUBedEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUBE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Bed"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUBE_Bed_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUBE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCICUBedEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUBE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUBE_Equip_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUBE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUBedEquipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
