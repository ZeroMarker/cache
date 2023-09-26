/// Function: 诊断术语库 对照 北京版编码 
/// CreateDate: 2016-12-28
/// Creator:  谷雪萍
Class User.DKBICDContrastPek Extends %Persistent [ SqlRowIdName = DKBCTP_RowId, SqlTableName = DKB_ICDContrastPek, StorageStrategy = NewStorage1 ]
{

//^DKBICDCONPEK

Property DKBCTPCode As %String [ SqlColumnNumber = 2, SqlFieldName = DKBCTP_Code ];

Property DKBCTPDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBCTP_Desc ];

Property DKBCTPPekCode As %String [ SqlColumnNumber = 4, SqlFieldName = DKBCTP_PekCode ];

Property DKBCTPPekDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DKBCTP_PekDesc ];

Property DKBCTPDiaDr As User.DKBDiagnosis [ SqlColumnNumber = 6, SqlFieldName = DKBCTP_Dia_Dr ];

Property DKBCTPPekDr As User.DKBICDPek [ SqlColumnNumber = 7, SqlFieldName = DKBCTP_Pek_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DKBICDCONPEK(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBICDCONPEK</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBCTP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTP_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTP_PekCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBCTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaDrIndex">
<Global>^DKBICDCONPEK</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBCTP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DiaDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTP_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTP_Pek_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBCTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaIndex">
<Global>^DKBICDCONPEK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dia"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTP_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBCTP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBCTP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBCTP_Dia_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBCTP_PekCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBCTP_PekDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBCTP_Pek_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DKBICDCONPEK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBCTP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBCTP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PekCodeIndex">
<Global>^DKBICDCONPEK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PekCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTP_PekCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PerDrIndex">
<Global>^DKBICDCONPEK</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PekDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTP_Pek_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DKBICDContrastPekS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
