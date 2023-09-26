/// Function: 诊断术语库 对照 国际编码 
/// CreateDate: 2016-12-27
/// Creator:  谷雪萍
Class User.DKBICDContrastInt Extends %Persistent [ SqlRowIdName = DKBCTI_RowId, SqlTableName = DKB_ICDContrastInt, StorageStrategy = NewStorage1 ]
{

//^DKBICDCONINT

Property DKBCTICode As %String [ SqlColumnNumber = 2, SqlFieldName = DKBCTI_Code ];

Property DKBCTIDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBCTI_Desc ];

Property DKBCTIIntCode As %String [ SqlColumnNumber = 4, SqlFieldName = DKBCTI_IntCode ];

Property DKBCTIIntDesc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DKBCTI_IntDesc ];

Property DKBCTIIntLongDesc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DKBCTI_IntLongDesc ];

Property DKBCTIDiaDr As User.DKBDiagnosis [ SqlColumnNumber = 7, SqlFieldName = DKBCTI_Dia_Dr ];

Property DKBCTIIntDr As User.DKBICDInt [ SqlColumnNumber = 8, SqlFieldName = DKBCTI_Int_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DKBICDCONINT(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBICDCONINT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBCTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTI_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTI_IntCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBCTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaDrIndex">
<Global>^DKBICDCONINT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBCTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DiaDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTI_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTI_Int_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBCTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaIndex">
<Global>^DKBICDCONINT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dia"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTI_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IntCodeIndex">
<Global>^DKBICDCONINT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTI_IntCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IntDrIndex">
<Global>^DKBICDCONINT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTI_Int_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBCTI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBCTI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBCTI_Dia_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBCTI_IntCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBCTI_IntDesc">
<Node>"IntDesc"</Node>
</Data>
<Data name="DKBCTI_IntLongDesc">
<Node>"IntLongDesc"</Node>
</Data>
<Data name="DKBCTI_Int_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DKBICDCONINT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBCTI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBCTI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DKBICDContrastIntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
