/// Postoperative Analgesia
Class User.DHCANOPAnalgesia Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPP_RowId, SqlTableName = DHC_AN_OPAnalgesia, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OPA_RowId
Property OPPOPADR As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = OPP_OPA_DR ];

/// ANAOP_PostDiag_DR
Property OPPPostDiagDR As User.MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = OPP_PostDiag_DR ];

/// Post Diag Note
Property OPPPostDiagNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OPP_PostDiagNote ];

/// Is Post Analgesia
Property OPPIsAnalgesia As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = OPP_IsAnalgesia ];

/// Expected Extubation Date
Property OPPPreExtubationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OPP_PreExtubationDate ];

/// Expected Extubation Time
Property OPPPreExtubationTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = OPP_PreExtubationTime ];

/// Extubation Date
Property OPPExtubationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = OPP_ExtubationDate ];

/// Extubation Time
Property OPPExtubationTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = OPP_ExtubationTime ];

/// Extubation Doctor
Property OPPExtubationDoc As User.CTCareProv [ SqlColumnNumber = 10, SqlFieldName = OPP_ExtubationDoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANOPAnalgesia)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="OPP_ExtubationDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPP_ExtubationDoc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPP_ExtubationTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPP_IsAnalgesia">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPP_OPA_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPP_PostDiagNote">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPP_PostDiag_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPP_PreExtubationDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPP_PreExtubationTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCANOPAnalgesia</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OPP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExpectedDate">
<Global>^DHCANOPAnalgesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PreExtubationDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPP_PreExtubationDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtubationDate">
<Global>^DHCANOPAnalgesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtubationDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPP_ExtubationDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOPARowId">
<Global>^DHCANOPAnalgesia</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPARowId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPP_OPA_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANOPAnalgesiaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
