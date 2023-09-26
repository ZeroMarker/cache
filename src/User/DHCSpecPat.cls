Class User.DHCSpecPat Extends %Persistent [ ClassType = persistent, SqlRowIdName = DHCSP_RowID, SqlTableName = DHC_SpecPat, StorageStrategy = SQLStorage ]
{

/// 姓名
Property DHCSPName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCSP_Name ];

/// 身份证号
Property DHCSPCredNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCSP_CredNo ];

/// 备注
Property DHCSPNote As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCSP_Note ];

/// 类型
Property DHCSPTypeDR As User.DHCPatListType [ SqlColumnNumber = 5, SqlFieldName = DHCSP_Type_DR ];

/// 生效开始日期
Property DHCSPStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DHCSP_StDate ];

/// 生效结束日期
Property DHCSPEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DHCSP_EndDate ];

/// 创建人
Property DHCSPCreateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = DHCSP_CreateUser_DR ];

/// 创建日期
Property DHCSPCreateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = DHCSP_CreateDate ];

/// 创建时间
Property DHCSPCreateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = DHCSP_CreateTime ];

/// 更新人
Property DHCSPUpdateUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = DHCSP_UpdateUser_DR ];

/// 更新日期
Property DHCSPUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = DHCSP_UpdateDate ];

/// 更新时间
Property DHCSPUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = DHCSP_UpdateTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCSP(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCSP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCSP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCSP_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCSP_CredNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCSP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCSP_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSP_Note">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCSP_StDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCSP_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCSP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCSP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCSP_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCSP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCSP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCredNo">
<Global>^DHCSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCSP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CredNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSP_CredNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCSP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCSP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCSP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSP_Type_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCSP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCSP_RowID</SqlRowIdName>
<StreamLocation>^User.DHCSpecPatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
