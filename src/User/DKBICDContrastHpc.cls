/// Function: 诊断术语库 对照 卫计委版编码 
/// CreateDate: 2016-12-28
/// Creator:  谷雪萍
Class User.DKBICDContrastHpc Extends %Persistent [ SqlRowIdName = DKBCTH_RowId, SqlTableName = DKB_ICDContrastHpc, StorageStrategy = NewStorage1 ]
{

//^DKBICDCONHPC

Property DKBCTHCode As %String [ SqlColumnNumber = 2, SqlFieldName = DKBCTH_Code ];

Property DKBCTHDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBCTH_Desc ];

Property DKBCTHHpcCode As %String [ SqlColumnNumber = 4, SqlFieldName = DKBCTH_HpcCode ];

Property DKBCTHHpcDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DKBCTH_HpcDesc ];

Property DKBCTHDiaDr As User.DKBDiagnosis [ SqlColumnNumber = 6, SqlFieldName = DKBCTH_Dia_Dr ];

Property DKBCTHHpcDr As User.DKBICDHpc [ SqlColumnNumber = 7, SqlFieldName = DKBCTH_Hpc_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DKBICDCONHPC(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBICDCONHPC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBCTH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTH_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTH_HpcCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBCTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaDrIndex">
<Global>^DKBICDCONHPC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBCTH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DiaDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTH_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTH_Hpc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBCTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaIndex">
<Global>^DKBICDCONHPC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dia"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTH_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="HpcCodeIndex">
<Global>^DKBICDCONHPC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HpcCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTH_HpcCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="HpcDrIndex">
<Global>^DKBICDCONHPC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBCTH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HpcDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBCTH_Hpc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBCTH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBCTH_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBCTH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBCTH_Dia_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBCTH_HpcCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBCTH_HpcDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBCTH_Hpc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DKBICDCONHPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBCTH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBCTH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DKBICDContrastHpcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
