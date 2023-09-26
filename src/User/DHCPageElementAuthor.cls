Class User.DHCPageElementAuthor Extends (%Persistent, User.Abstract) [ SqlRowIdName = DHCPEA_RowId, SqlTableName = DHC_PageElementAuthor, StorageStrategy = SQLStorage ]
{

/// csp名称
Property DHCPEACspName As %String [ SqlColumnNumber = 2, SqlFieldName = DHCPEA_CspName ];

/// 表单id
Property DHCPEAFormID As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DHCPEA_FormID ];

/// 保存类型
Property DHCPEASaveFor As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DHCPEA_SaveFor ];

/// 表单控件ID
Property DHCPEAFieldID As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DHCPEA_FieldID ];

/// 表单控件Label
Property DHCPEAFieldLabel As %Library.String [ SqlColumnNumber = 6, SqlFieldName = DHCPEA_FieldLabel ];

/// 是否可用
Property DHCPEAEnable As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DHCPEA_Enable ];

/// 顺序
Property DHCPEAFieldIndex As %Integer [ SqlColumnNumber = 8, SqlFieldName = DHCPEA_FieldIndex ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPEA)</SqlIdExpression>
<SQLMap name="IndexCspForm">
<Global>^DHCPEA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHCPEA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CspForm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_CspName}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_FormID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_SaveFor}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_FieldID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCspFormFor">
<Global>^DHCPEA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCPEA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CspFormFor"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_CspName}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_FormID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_SaveFor}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DHCPEA_CspName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPEA_Enable">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPEA_FieldID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPEA_FieldIndex">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCPEA_FieldLabel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPEA_FormID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPEA_SaveFor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPEA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPEA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCPEA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCPEA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPageElementAuthorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPEA)
	s oldI = +$g(^mdata("DHCPEA"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPEA = maxI
	s ^mdata("DHCPEA") = maxI
}

}
