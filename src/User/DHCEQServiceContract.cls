Class User.DHCEQServiceContract Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SC_RowID, SqlTableName = DHC_EQServiceContract, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SC_EquipDR
Property SCEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = SC_EquipDR ];

/// SC_ContractDR
Property SCContractDR As User.DHCEQContract [ SqlColumnNumber = 3, SqlFieldName = SC_ContractDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQServiceContract("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SC_ContractDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SC_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQServiceContract</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContract">
<Global>^DHCEQServiceContract</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SC_ContractDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQServiceContract</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQServiceContractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
