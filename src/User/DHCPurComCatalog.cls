Class User.DHCPurComCatalog Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_PurComCatalog, StorageStrategy = SQLStorage ]
{

/// 企业编号
Property DHCPCcompanyId As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DHCPC_companyId ];

/// 企业名称
Property DHCPCcompanyName As %String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DHCPC_companyName ];

/// 地址
Property DHCPCaddress As %String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCPC_address ];

/// 企业联系电话
Property DHCPCcompanyContactTel As %String [ SqlColumnNumber = 5, SqlFieldName = DHCPC_companyContactTel ];

/// 企业传真号码
Property DHCPCcompanyContactFax As %String [ SqlColumnNumber = 6, SqlFieldName = DHCPC_companyContactFax ];

/// 邮编
Property DHCPCzipCode As %String [ SqlColumnNumber = 7, SqlFieldName = DHCPC_zipCode ];

/// 邮箱
Property DHCPCemail As %String [ SqlColumnNumber = 8, SqlFieldName = DHCPC_email ];

/// 添加日期
Property DHCPCaddDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = DHCPC_addDate ];

/// 添加时间
Property DHCPCaddTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCPC_addTime ];

/// 变更日期
Property DHCPClastUpdateDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = DHCPC_lastUpdateDate ];

/// 变更时间
Property DHCPClastUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DHCPC_lastUpdateTime ];

/// 下载日期
Property DHCPCDownDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = DHCPC_DownDate ];

/// 下载时间
Property DHCPCDownTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = DHCPC_DownTime ];

/// 下载人
Property DHCPCDownUser As SSUser [ SqlColumnNumber = 15, SqlFieldName = DHCPC_DownUser ];

/// HIS企业ID(供应商、生产商、配送商)
Property DHCPCPointer As %String [ SqlColumnNumber = 16, SqlFieldName = DHCPC_Pointer ];

/// HIS企业类型(V:供应商、M:生产商、配送商：C)
Property DHCPCType As %String [ SqlColumnNumber = 17, SqlFieldName = DHCPC_Type ];

/// 营业执照注册号 统一社会信用代码
Property DHCPCBusinessLicense As %String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = DHCPC_BusinessLicense ];

/// 地区id号
Property DHCPCAreaId As %String [ SqlColumnNumber = 19, SqlFieldName = DHCPC_AreaId ];

/// 地区名称
Property DHCPCAreaName As %String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = DHCPC_AreaName ];

/// 企业类型
Property DHCPCCompanyType As %String [ SqlColumnNumber = 21, SqlFieldName = DHCPC_CompanyType ];

/// 企业账号
Property DHCPCloginUserName As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = DHCPC_loginUserName ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PURCOMCAT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCPC_AreaId">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPC_AreaName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPC_BusinessLicense">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPC_CompanyType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCPC_DownDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCPC_DownTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCPC_DownUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCPC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCPC_Type">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCPC_addDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPC_addTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPC_address">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPC_companyContactFax">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCPC_companyContactTel">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCPC_companyId">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCPC_companyName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCPC_email">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCPC_lastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCPC_lastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCPC_loginUserName">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCPC_zipCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^PURCOMCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCPC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PURCOMCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPC_companyId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextypepoint">
<Global>^PURCOMCAT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCPC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPEPOINT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCPC_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCPC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCPC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPurComCatalogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
