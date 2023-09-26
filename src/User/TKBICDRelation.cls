/// ICD映射、诊断关系表：TKB_ICDRelation
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-5-31
Class User.TKBICDRelation Extends %Persistent [ SqlRowIdName = TKBICDR_RowId, SqlTableName = TKB_ICDRelation, StorageStrategy = SQLStorage ]
{

//^TKBICDRE

Property TKBICDRDiag1 As %String [ SqlColumnNumber = 2, SqlFieldName = TKBICDR_Diag1 ];

Property TKBICDRDiag2 As %String [ SqlColumnNumber = 3, SqlFieldName = TKBICDR_Diag2 ];

Property TKBICDRDiag3 As %String [ SqlColumnNumber = 4, SqlFieldName = TKBICDR_Diag3 ];

Property TKBICDRTremDr As User.TKBTrem [ SqlColumnNumber = 5, SqlFieldName = TKBICDR_Trem_Dr ];

Property TKBICDRInterCode1 As %String [ SqlColumnNumber = 6, SqlFieldName = TKBICDR_InterCode1 ];

Property TKBICDRInterCode2 As %String [ SqlColumnNumber = 7, SqlFieldName = TKBICDR_InterCode2 ];

Property TKBICDRTremDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TKBICDR_TremDesc ];

Property TKBICDRNote As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TKBICDR_Note ];

Property TKBICDRState As %String [ SqlColumnNumber = 10, SqlFieldName = TKBICDR_State ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBICDRE(0))</SqlIdExpression>
<SQLMap name="IndexDiag1">
<Global>^TKBICDRE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBICDR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Diag1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBICDR_Diag1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBICDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTrem">
<Global>^TKBICDRE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBICDR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Trem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBICDR_Trem_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBICDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBICDR_Diag1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBICDR_Diag2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBICDR_Diag3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBICDR_InterCode1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TKBICDR_InterCode2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TKBICDR_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TKBICDR_State">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TKBICDR_TremDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TKBICDR_Trem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^TKBICDRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBICDR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBICDR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.TKBICDRelationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
