Class User.DHCRBCItemPatTypeSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIPTS_RowID, SqlTableName = DHCRBC_ItemPatTypeSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DIPTS_ArcItmMast_DR
Property DIPTSArcItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DIPTS_ArcItmMast_DR ];

/// DIPTS_PatientType_Code
Property DIPTSPatientTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DIPTS_PatientType_Code ];

/// DIPTS_AppointMethod_DR
Property DIPTSAppointMethodDR As User.DHCRBCAppointMethod [ SqlColumnNumber = 4, SqlFieldName = DIPTS_AppointMethod_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCItemPatTypeSet("ItemPatTypeSet"))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCItemPatTypeSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DIPTS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIPTS_ArcItmMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIPTS_PatientType_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DIPTS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DIPTS_AppointMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIPTS_ArcItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIPTS_PatientType_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCItemPatTypeSet</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIPTS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItemPatTypeSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIPTS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemPatTypeSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
