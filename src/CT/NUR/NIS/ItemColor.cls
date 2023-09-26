Class CT.NUR.NIS.ItemColor Extends (%Persistent, User.Abstract) [ SqlTableName = ItemColor, StorageStrategy = SQLStorage ]
{

/// 项目编码
Property ItemCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = ItemCode ];

/// 项目类别 
Property Type As %String [ SqlColumnNumber = 3, SqlFieldName = Type ];

/// 颜色代码 
Property ColorCode As %String [ SqlColumnNumber = 4, SqlFieldName = ColorCode ];

/// 删除标记（0：未删除 1:删除）
Property DeleteFlag As %String(DISPLAYLIST = ",未删除,删除", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",0,1") [ Required, SqlColumnNumber = 5, SqlFieldName = DeleteFlag ];

/// 医院ID
Property HospDR As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = HospDR ];

/// 重建索引
/// Other:	w ##class(CT.NUR.NIS.ItemColor).RebuildIndex()
ClassMethod RebuildIndex()
{
	q ##class(CT.NUR.NIS.ItemColor).%BuildIndices()
}

Storage SQLStorage
{
<SqlIdExpression>$i(^CT.NUR.NIS.ItemColor(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ColorCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DeleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HospDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ItemCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT.NUR.NIS.ItemColor</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="HospIndex">
<Global>^CT.NUR.NIS.ItemColor</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HospDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IC_RowID</SqlRowIdName>
<StreamLocation>^CT.NUR.NIS.ItemColorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
