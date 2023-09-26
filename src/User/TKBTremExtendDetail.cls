/// 术语扩展属性表明细表： TKB_TremExtendDetail
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-21
Class User.TKBTremExtendDetail Extends %Persistent [ SqlRowIdName = TKBTD_RowId, SqlTableName = TKB_TremExtendDetail, StorageStrategy = SQLStorage ]
{

//^TKBTREEXTDTL,^TKBTREEXTDTLi

Property TKBTDCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TKBTD_Code ];

Property TKBTDDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBTD_Desc ];

Property TKBTDLastLevel As User.TKBTremExtendDetail [ SqlColumnNumber = 4, SqlFieldName = TKBTD_LastLevel ];

Property TKBTDLevel As %String [ SqlColumnNumber = 5, SqlFieldName = TKBTD_Level ];

Property TKBTDExtDR As User.TKBTremExtend [ SqlColumnNumber = 6, SqlFieldName = TKBTD_ExtDR ];

Property TKBTDRemark As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TKBTD_Remark ];

Property TKBTDActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = TKBTD_ActiveFlag ];

Property TKBTDSequence As %String [ SqlColumnNumber = 9, SqlFieldName = TKBTD_Sequence ];

Storage SQLStorage
{
<SqlIdExpression>$i(^TKBTREEXTDTL(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^TKBTREEXTDTLi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTD_ExtDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({TKBTD_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ExtIndex">
<Global>^TKBTREEXTDTLi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ext"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTD_ExtDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ExtParIndex">
<Global>^TKBTREEXTDTLi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExtParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTD_ExtDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTD_LastLevel}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="TKBTD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TKBTD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TKBTD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TKBTD_ExtDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TKBTD_LastLevel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TKBTD_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TKBTD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TKBTD_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^TKBTREEXTDTL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TKBTD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TKBTD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParIndex">
<Global>^TKBTREEXTDTLi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TKBTD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParIdx"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTD_LastLevel}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="SeqIndex">
<Global>^TKBTREEXTDTLi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TKBTD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Seq"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TKBTD_ExtDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TKBTD_Sequence}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TKBTD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.TKBTremExtendDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
