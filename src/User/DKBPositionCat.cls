/// 部位表（树形）：User.DKBPositionCat
Class User.DKBPositionCat Extends %Persistent [ SqlRowIdName = DKBPC_RowId, SqlTableName = DKB_PositionCat, StorageStrategy = NewStorage1 ]
{

//^DKBPOSCAT

Property DKBPCCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DKBPC_Code ];

Property DKBPCDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DKBPC_Desc ];

Property DKBPCLastLevel As User.DKBPositionCat [ SqlColumnNumber = 4, SqlFieldName = DKBPC_LastLevel ];

Property DKBPCLevel As %String [ SqlColumnNumber = 5, SqlFieldName = DKBPC_Level ];

Property DKBPCRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DKBPC_Remark ];

Property DKBPCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DKBPC_ActiveFlag ];

Property DKBPCText1 As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DKBPC_Text1 ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DKBPOSCAT(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBPOSCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DKBPC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DKBPOSCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DKBPC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBPC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBPC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBPC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBPC_LastLevel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBPC_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBPC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBPC_Text1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DKBPOSCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBPC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParIdx">
<Global>^DKBPOSCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBPC_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ParSeqIdx">
<Global>^DKBPOSCAT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParSeqIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBPC_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPC_Level}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DKBPositionCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
