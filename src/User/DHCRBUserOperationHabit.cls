Class User.DHCRBUserOperationHabit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DUOH_RowID, SqlTableName = DHCRB_UserOperationHabit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DUOH_User_DR
Property DUOHUserDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DUOH_User_DR ];

/// DUOH_Code
Property DUOHCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DUOH_Code ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBUserOperationHabit)</SqlIdExpression>
<SQLMap name="IndexUser">
<Global>^DHCRBUserOperationHabiti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DUOH_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DUOH_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUOH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Mastermap">
<Data name="DUOH_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DUOH_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBUserOperationHabit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DUOH_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DUOH_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBUserOperationHabitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
