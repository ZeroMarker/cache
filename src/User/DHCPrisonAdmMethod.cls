/// 罪犯就诊方式表
Class User.DHCPrisonAdmMethod Extends %Persistent [ SqlRowIdName = PAM_RowId, SqlTableName = DHC_PrisonAdmMethod, StorageStrategy = SQLStorage ]
{

/// 代码
Property PAMCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PAM_Code ];

/// 描述
Property PAMDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAM_Desc ];

/// 创建日期
Property PAMDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PAM_DateFrom ];

/// 截至日期
Property PAMDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PAM_DateTo ];

Property PAMText As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PAM_Text ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPAM("PAM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PAM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAM_Text">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPAM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PAM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPAM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAM_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPrisonAdmMethodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
