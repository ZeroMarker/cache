Class User.DHCEQEquipRentAffix Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ERA_RowID, SqlTableName = DHC_EQEquipRentAffix, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ERA_EquipRentDR
Property ERAEquipRentDR As User.DHCEQEquipRent [ SqlColumnNumber = 2, SqlFieldName = ERA_EquipRentDR ];

/// ERA_Desc
Property ERADesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ERA_Desc ];

/// ERA_Model
Property ERAModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ERA_Model ];

/// ERA_Quantity
Property ERAQuantity As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ERA_Quantity ];

/// ERA_Remark
Property ERARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ERA_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipRentAffix("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ERA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ERA_EquipRentDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ERA_Model">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ERA_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ERA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQEquipRentAffix</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ERA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ERA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipRent">
<Global>^DHCEQEquipRentAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ERA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipRent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERA_EquipRentDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipRentAffixS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
