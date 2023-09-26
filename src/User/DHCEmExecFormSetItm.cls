Class User.DHCEmExecFormSetItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = FSI_RowID, SqlTableName = DHC_EmExecFormSetItm, StorageStrategy = SQLStorage ]
{

/// 执行单表 FSI_ExecFS_Dr
Property FSIExecFSDr As User.DHCEmExecFormSet [ SqlColumnNumber = 2, SqlFieldName = FSI_ExecFS_Dr ];

/// 配置类型值 FSI_TypeCode	
Property FSITypeCode As %String [ SqlColumnNumber = 3, SqlFieldName = FSI_TypeCode ];

/// 配置类型值 指针串	
Property FSIPoniter As %Text(MAXLEN = 2500) [ SqlColumnNumber = 4, SqlFieldName = FSI_Poniter ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMEFSI)</SqlIdExpression>
<SQLMap name="IndexExecForm">
<Global>^DHCEMEFSI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FSI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExecForm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FSI_ExecFS_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FSI_TypeCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="FSI_ExecFS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FSI_Poniter">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FSI_TypeCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMEFSI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FSI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FSI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmExecFormSetItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
