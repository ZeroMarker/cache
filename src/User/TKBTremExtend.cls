/// 子术语库大类： TKB_TremExtend
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-20
Class User.TKBTremExtend Extends %Persistent [ SqlRowIdName = TKBTE_RowId, SqlTableName = TKB_TremExtend, StorageStrategy = SQLStorage ]
{

//^TKBTREEXT,^TKBTREEXTi

Relationship ChildTKBTremExtendCat As User.TKBTremExtendCat [ Cardinality = children, Inverse = TKBTECParDr ];

Property TKBTECode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TKBTE_Code ];

Property TKBTEDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBTE_Desc ];

Property TKBTEType As %String(DISPLAYLIST = ",列表,树形,文本,引用术语,引用属性,映射", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",L,T,TX,S,C,CT") [ SqlColumnNumber = 4, SqlFieldName = TKBTE_Type ];

Property TKBTEDATSOU As User.TKBTremBase [ SqlColumnNumber = 5, SqlFieldName = TKBTE_DATSOU ];

Property TKBTETreDr As User.TKBTrem [ SqlColumnNumber = 6, SqlFieldName = TKBTE_Tre_Dr ];

Property TKBTEName As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TKBTE_Name ];

Property TKBTEFlag As %String(DISPLAYLIST = ",诊断展示名", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",S") [ SqlColumnNumber = 8, SqlFieldName = TKBTE_Flag ];

Property TKBTEPublic As %String(DISPLAYLIST = ",是,否", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = TKBTE_Public ];

Property TKBTEDefinedNode As %String [ SqlColumnNumber = 10, SqlFieldName = TKBTE_DefinedNode ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBTREEXT(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^TKBTREEXTi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTE_Tre_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({TKBTE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^TKBTREEXTi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTE_Tre_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({TKBTE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="FlagIndex">
<Global>^TKBTREEXTi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTE_Tre_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTE_Flag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBTE_DATSOU">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TKBTE_DefinedNode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TKBTE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTE_Flag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TKBTE_Name">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TKBTE_Public">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TKBTE_Tre_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TKBTE_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^TKBTREEXT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TreIndex">
<Global>^TKBTREEXTi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Tre"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTE_Tre_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremExtendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
