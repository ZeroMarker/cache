Class User.DHCAdvStatTemp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ST_RowID, SqlTableName = DHC_AdvStatTemp, StorageStrategy = SQLStorage ]
{

/// 表单类型  ST_ForNrame_Dr
Property STForNameDr As %Library.String [ SqlColumnNumber = 2, SqlFieldName = ST_ForName_Dr ];

/// 模板名称 STTempName
Property STTempName As %Library.Text(MAXLEN = 100, MINLEN = 0) [ SqlColumnNumber = 3, SqlFieldName = ST_TempName ];

/// 模板内容 PCL_Reg_Dr
Property STTempInfo As %Library.Text(MAXLEN = 100, MINLEN = 0) [ SqlColumnNumber = 4, SqlFieldName = ST_TempInfo ];

Storage SQLStorage
{
<ExtentSize>10000</ExtentSize>
<SqlIdExpression>$i(^DHCADVST)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ST_ForName_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ST_TempInfo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ST_TempName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ST_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ST_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFormName">
<Global>^DHCADVST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ST_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexFormName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ST_ForName_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTemp">
<Global>^DHCADVST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ST_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TempName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ST_TempName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvStatTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
