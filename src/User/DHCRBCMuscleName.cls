Class User.DHCRBCMuscleName Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMN_RowID, SqlTableName = DHCRBC_MuscleName, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DMN_Desc
Property DMNDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DMN_Desc ];

/// DMN_Code
Property DMNCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DMN_Code ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCMuscleName)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCMuscleNamei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DMN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MUSCLECODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DMN_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCRBCMuscleNamei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DMN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MUSCLEDESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DMN_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DMN_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCMuscleName</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DMN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DMN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCMuscleNameS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
