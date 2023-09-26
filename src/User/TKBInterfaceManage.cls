/// 知识库接口管理表
Class User.TKBInterfaceManage Extends %Persistent [ SqlRowIdName = TKBINM_RowId, SqlTableName = TKB_InterfaceManage, StorageStrategy = SQLStorage ]
{

//^TKBINTMAG

Property TKBINMCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TKBINM_Code ];

Property TKBINMDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBINM_Desc ];

Property TKBINMFunction As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TKBINM_Function ];

Property TKBINMReturnValue As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TKBINM_ReturnValue ];

Property TKBINMLastLevel As User.TKBInterfaceManage [ SqlColumnNumber = 6, SqlFieldName = TKBINM_LastLevel ];

Property TKBINMLevel As %String [ SqlColumnNumber = 7, SqlFieldName = TKBINM_Level ];

Property TKBINMRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TKBINM_Remark ];

Property TKBINMActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = TKBINM_Active ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBINTMAG(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^TKBINTMAG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBINM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({TKBINM_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBINM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBINM_Active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TKBINM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBINM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBINM_Function">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBINM_LastLevel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TKBINM_Level">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TKBINM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TKBINM_ReturnValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^TKBINTMAG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBINM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBINM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParIdx">
<Global>^TKBINTMAG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBINM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBINM_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBINM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ParSeqIdx">
<Global>^TKBINTMAG</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBINM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParSeqIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBINM_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBINM_Level}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBINM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBInterfaceManageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
