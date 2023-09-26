Class User.DHCRBCBodyPartMuscleSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DBPM_RowID, SqlTableName = DHCRBC_BodyPartMuscleSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DBPM_BodyPart_DR
Property DBPMBodyPartDR As User.MRCBodyParts [ SqlColumnNumber = 2, SqlFieldName = DBPM_BodyPart_DR ];

/// DBPM_Muscle_DR
Property DBPMMuscleDR As User.DHCRBCMuscleName [ SqlColumnNumber = 3, SqlFieldName = DBPM_Muscle_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCBodyPartMuscleSet)</SqlIdExpression>
<SQLMap name="IndexBodyParts">
<Global>^DHCRBCBodyPartMuscleSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DBPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DBPM_BodyPart_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DBPM_Muscle_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DBPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMuscleDR">
<Global>^DHCRBCBodyPartMuscleSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DBPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Muscle-Name"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DBPM_Muscle_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DBPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DBPM_BodyPart_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DBPM_Muscle_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCBodyPartMuscleSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DBPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DBPM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCBodyPartMuscleSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
