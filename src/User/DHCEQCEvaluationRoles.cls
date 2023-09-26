Class User.DHCEQCEvaluationRoles Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ER_RowID, SqlTableName = DHC_EQCEvaluationRoles, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ER_EvaluationDR
Property EREvaluationDR As User.DHCEQCEvaluation [ SqlColumnNumber = 2, SqlFieldName = ER_EvaluationDR ];

/// ER_RoleDR
Property ERRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 3, SqlFieldName = ER_RoleDR ];

/// ER_FromDate
Property ERFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ER_FromDate ];

/// ER_ToDate
Property ERToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = ER_ToDate ];

/// ER_Hold1
Property ERHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ER_Hold1 ];

/// ER_Hold2
Property ERHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ER_Hold2 ];

/// ER_Hold3
Property ERHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ER_Hold3 ];

/// ER_Hold4
Property ERHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ER_Hold4 ];

/// ER_Hold5
Property ERHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ER_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCEvaluationRoles("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ER_EvaluationDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ER_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ER_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ER_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ER_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ER_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ER_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ER_RoleDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ER_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCEvaluationRoles</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ER_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCEvaluationRolesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
