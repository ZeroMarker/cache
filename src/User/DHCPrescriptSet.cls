Class User.DHCPrescriptSet Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_PrescriptSet, StorageStrategy = DHCPrescriptSet ]
{

/// 代码
Property PSCode As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PSCode ];

/// 描述
Property PSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PSDesc ];

/// 类型
Property PSType As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PSType ];

/// 用户
Property PSCreatUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PSCreatUser ];

/// 是否有效
Property PSActive As %Library.String [ SqlColumnNumber = 6, SqlFieldName = PSActive ];

/// 子类定义
Property PSItemCatStr As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PSItemCatStr ];

/// 医院
Property PSHospDr As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = PSHospDr ];

Storage DHCPrescriptSet
{
<SqlIdExpression>$i(^DHCPRESCRIPTSET)</SqlIdExpression>
<SQLMap name="Masterdata">
<Data name="PSActive">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PSCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PSCreatUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PSDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PSHospDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PSItemCatStr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PSType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPRESCRIPTSET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCPrescriptSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
