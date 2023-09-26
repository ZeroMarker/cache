Class User.DHCEQUseRecordEquip Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URE_RowID, SqlTableName = DHC_EQUseRecordEquip, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// URE_UseRecordDR
Property UREUseRecordDR As User.DHCEQUseRecord [ SqlColumnNumber = 2, SqlFieldName = URE_UseRecordDR ];

/// URE_EquipDR
Property UREEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = URE_EquipDR ];

/// URE_Fraction
Property UREFraction As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = URE_Fraction ];

/// URE_InCome
Property UREInCome As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = URE_InCome ];

/// URE_Cost
Property URECost As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = URE_Cost ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUseRecordEquip("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="URE_Cost">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="URE_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="URE_Fraction">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="URE_InCome">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="URE_UseRecordDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQUseRecordEquip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>URE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{URE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQUseRecordEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>URE_RowID</Field>
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
<Expression>{URE_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{URE_UseRecordDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{URE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseRecord">
<Global>^DHCEQUseRecordEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>URE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseRecord"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{URE_UseRecordDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{URE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUseRecordEquipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
