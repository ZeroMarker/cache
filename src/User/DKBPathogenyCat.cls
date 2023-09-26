/// 病因表（树形）：User.DKBPathogenyCat
Class User.DKBPathogenyCat Extends %Persistent [ SqlRowIdName = DKBPA_RowId, SqlTableName = DKB_PathogenyCat, StorageStrategy = SQLStorage ]
{

//^DKBPATCAT

Property DKBPACode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DKBPA_Code ];

Property DKBPADesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DKBPA_Desc ];

Property DKBPALastLevel As User.DKBPositionCat [ SqlColumnNumber = 4, SqlFieldName = DKBPA_LastLevel ];

Property DKBPALevel As %String [ SqlColumnNumber = 5, SqlFieldName = DKBPA_Level ];

Property DKBPARemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DKBPA_Remark ];

Property DKBPAActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DKBPA_ActiveFlag ];

Property DKBPAText1 As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DKBPA_Text1 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBPATCAT(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DKBPATCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DKBPA_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DKBPATCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DKBPA_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DKBPA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBPA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBPA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBPA_LastLevel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBPA_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBPA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBPA_Text1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DKBPATCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DKBPA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParIdx">
<Global>^DKBPATCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBPA_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ParSeqIdx">
<Global>^DKBPATCAT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DKBPA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParSeqIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DKBPA_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DKBPA_Level}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DKBPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DKBPathogenyCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
