/// 子术语库大类： BKB_BaseCat
Class User.DKBBaseCat Extends %Persistent [ SqlRowIdName = DKBBC_RowId, SqlTableName = DKB_BaseCat, StorageStrategy = SQLStorage ]
{

//^DKBBASCAT 

Property DKBBCCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DKBBC_Code ];

Property DKBBCDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DKBBC_Desc ];

Property DKBBCType As %String(DISPLAYLIST = ",列表,树形,文本,引用术语,引用属性", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",L,T,TX,S,C") [ SqlColumnNumber = 4, SqlFieldName = DKBBC_Type ];

Property DKBBCDATSOU As User.DKBDATASources [ SqlColumnNumber = 5, SqlFieldName = DKBBC_DATSOU ];

Property DKBBCDiaDr As User.DKBDiagnosis [ SqlColumnNumber = 6, SqlFieldName = DKBBC_Dia_Dr ];

Property DKBBCExtend As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DKBBC_Extend ];

//主列名

Property DKBBCName As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DKBBC_Name ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBBASCAT(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBBASCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBBC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBBC_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({DKBBC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DKBBASCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBBC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBBC_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({DKBBC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DiaIndex">
<Global>^DKBBASCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBBC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dia"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBBC_Dia_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBBC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBBC_DATSOU">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBBC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBBC_Dia_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBBC_Extend">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBBC_Name">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DKBBC_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DKBBASCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBBC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBBC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.BKBBaseCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
