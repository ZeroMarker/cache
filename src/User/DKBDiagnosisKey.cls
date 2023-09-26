/// 诊断拼音码字典表
Class User.DKBDiagnosisKey Extends %Persistent [ SqlRowIdName = DKBDIk_RowId, SqlTableName = DKB_DiagnosisKey, StorageStrategy = SQLStorage ]
{

//^DKBDGSKEY

Property DKBDIkDiaDr As %String [ SqlColumnNumber = 2, SqlFieldName = DKBDIk_Dia_Dr ];

Property DKBDIkCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DKBDIk_Code ];

Property DKBDIkDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DKBDIk_Desc ];

Property DKBDIkType As %String(DISPLAYLIST = ",常用名,别名,主症状", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",C,A,M") [ SqlColumnNumber = 5, SqlFieldName = DKBDIk_Type ];

Property DKBDIkActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DKBDIk_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBDGSKEY(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBDGSKEY</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DKBDIk_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBDIk_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDIk_Dia_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({DKBDIk_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DKBDIk_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="DKBDIk_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBDIk_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBDIk_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBDIk_Dia_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBDIk_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DKBDGSKEY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBDIk_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBDIk_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DKBDGSKEY</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DKBDIk_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBDIk_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDIk_Dia_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({DKBDIk_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DKBDIk_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaIndex">
<Global>^DKBDGSKEY</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBDIk_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dia"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBDIk_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBDIk_Dia_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBDIk_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DKBDiagnosisKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
