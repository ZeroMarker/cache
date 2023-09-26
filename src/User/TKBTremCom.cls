/// 术语常用名/别名字典表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-18
Class User.TKBTremCom Extends %Persistent [ SqlRowIdName = TKBTRC_RowId, SqlTableName = TKB_TremCom, StorageStrategy = SQLStorage ]
{

//^TKBTRECOM ^TKBTRECOMi

Property TKBTRCTREDr As User.TKBTrem [ SqlColumnNumber = 2, SqlFieldName = TKBTRC_TRE_Dr ];

Property TKBTRCCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBTRC_Code ];

Property TKBTRCDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TKBTRC_Desc ];

Property TKBTRCType As %String(DISPLAYLIST = ",常用名,别名", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",C,A") [ SqlColumnNumber = 5, SqlFieldName = TKBTRC_Type ];

Property TKBTRCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = TKBTRC_ActiveFlag ];

Property TKBTRCSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TKBTRC_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBTRECOM(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^TKBTRECOMi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TKBTRC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRC_TRE_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({TKBTRC_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TKBTRC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^TKBTRECOMi</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TKBTRC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRC_TRE_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$UPPER({TKBTRC_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TKBTRC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTRC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TKBTRC_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTRC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBTRC_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TKBTRC_TRE_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBTRC_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^TKBTRECOM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTRC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTRC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TreIndex">
<Global>^TKBTRECOMi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTRC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Tre"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTRC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTRC_TRE_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTRC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremComS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
