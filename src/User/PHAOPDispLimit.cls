Class User.PHAOPDispLimit Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PODL_RowID, SqlTableName = PHAOP_DispLimit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PODL_Ctloc_Dr
Property PODLCtlocDr As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = PODL_Ctloc_Dr ];

/// PODL_Inci_Dr
Property PODLInciDr As User.CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = PODL_Inci_Dr ];

/// PODL_User_Dr
Property PODLUserDr As User.CTLoc [ Required, SqlColumnNumber = 4, SqlFieldName = PODL_User_Dr ];

/// PODL_Active
Property PODLActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PODL_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CF.PHA.OP.DispLimit)</SqlIdExpression>
<SQLMap name="DATAMASTER">
<Data name="PODL_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PODL_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PODL_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PODL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.OP.DispLimit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PODL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PODL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXINCILOCUSER">
<Global>^CF.PHA.OP.DispLimiti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PODL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"INCILOCUSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PODL_Inci_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PODL_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PODL_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PODL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXLOCINCI">
<Global>^CF.PHA.OP.DispLimiti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PODL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOCINCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PODL_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PODL_Inci_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PODL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAOPDispLimitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
