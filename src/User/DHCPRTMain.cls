Class User.DHCPRTMain Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MA_RowID, SqlTableName = DHC_PRTMain, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPRTMAINITEM As User.DHCPRTMainItem [ Cardinality = children, Inverse = MAIParRefDr ];

/// 模板名称 MA_Code
Property MACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MA_Code ];

/// 模板描述 MA_Desc
Property MADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MA_Desc ];

/// 模板宽 MA_Width(mm)
Property MAWidth As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = MA_Width ];

/// 模板高 MA_Height(mm)
Property MAHeight As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MA_Height ];

/// 创建日期 MA_CreateDate
Property MACreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MA_CreateDate ];

/// 创建时间 MA_CreateTime
Property MACreateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MA_CreateTime ];

/// 模板类型 (正常,表格)
Property MAType As %Library.String [ SqlColumnNumber = 8, SqlFieldName = MA_Type ];

/// 模板列数
Property MALineNum As %Library.String [ SqlColumnNumber = 9, SqlFieldName = MA_LineNum ];

/// 模板内容
Property MAText As %Library.Text(MAXLEN = 50000) [ SqlColumnNumber = 10, SqlFieldName = MA_Text ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPRTMA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MA_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MA_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MA_Height">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MA_LineNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MA_Text">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MA_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MA_Width">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPRTMA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPRTMA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MA_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCPRTMA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IindexType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPRTMainS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
