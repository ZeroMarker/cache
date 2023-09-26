Class User.DHCStkAuditLevel Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STAL_RowId, SqlTableName = DHC_StkAuditLevel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SAL_Type
Property STALType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = STAL_Type ];

/// SAL_ItmLimit
Property STALItmLimit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = STAL_ItmLimit ];

/// SAL_ItmLevel
Property STALItmLevel As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = STAL_ItmLevel ];

/// SAL_SSGroup
Property STALSSGroup As User.SSGroup [ SqlColumnNumber = 5, SqlFieldName = STAL_SSGroup ];

/// SAL_ActiveFlag
Property STALActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = STAL_ActiveFlag ];

/// STAL_StkGrp
Property STALStkGrp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = STAL_StkGrp ];

/// STAL_Condition
Property STALCondition As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = STAL_Condition ];

/// STAL_ItmLoc_Dr
Property STALItmLocDr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = STAL_ItmLoc_Dr ];

/// STAL_SSUser_Dr
Property STALSSUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = STAL_SSUser_Dr ];

/// STAL_Generic_Dr
Property STALGenericDr As User.PHCGeneric [ SqlColumnNumber = 12, SqlFieldName = STAL_Generic_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTAL)</SqlIdExpression>
<SQLMap name="IndexLevel">
<Global>^DHCSTAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>STAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Level"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{STAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{STAL_StkGrp}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{STAL_ItmLevel}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{STAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCSTAL</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STAL_StkGrp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAL_SSUser_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{STAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="STAL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STAL_Condition">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STAL_Generic_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STAL_ItmLevel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STAL_ItmLimit">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STAL_ItmLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STAL_SSGroup">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STAL_SSUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STAL_StkGrp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STAL_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSTAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{STAL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkAuditLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
