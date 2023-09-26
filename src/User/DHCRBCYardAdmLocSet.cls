Class User.DHCRBCYardAdmLocSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DYAS_RowID, SqlTableName = DHCRBC_YardAdmLocSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DYAS_Dispatcher_DR
Property DYASDispatcherDR As User.DHCRBCOutWorkerSet [ SqlColumnNumber = 2, SqlFieldName = DYAS_Dispatcher_DR ];

/// DYAS_AdmLoc_DR
Property DYASAdmLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DYAS_AdmLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCYardAdmLocSet)</SqlIdExpression>
<SQLMap name="IndexDispatcher">
<Global>^DHCRBCYardAdmLocSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DYAS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Yard-AdmLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DYAS_Dispatcher_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DYAS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DYAS_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DYAS_Dispatcher_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCYardAdmLocSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DYAS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DYAS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCYardAdmLocSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
