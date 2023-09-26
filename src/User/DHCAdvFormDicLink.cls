Class User.DHCAdvFormDicLink Extends %Persistent [ SqlRowIdName = FDL_RowID, SqlTableName = DHC_AdvFormDicLink, StorageStrategy = SQLStorage ]
{

/// 元素表ID  FDL_FormDic_Dr
Property FDLFormDicDr As User.DHCAdvFormDic [ SqlColumnNumber = 2, SqlFieldName = FDL_FormDic_Dr ];

/// 元素数据源Code  FDL_SourceCode
Property FDLSourceCode As %String [ SqlColumnNumber = 3, SqlFieldName = FDL_SourceCode ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVFDLINK)</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCADVFDLINK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FDL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FDL_SourceCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FDL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="FormDicIndex">
<Global>^DHCADVFDLINK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FDL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FormDic"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FDL_FormDic_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FDL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="FDL_FormDic_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FDL_SourceCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVFDLINK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FDL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FDL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvFormDicLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
