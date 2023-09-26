Class User.DHCManfHistory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MANFH_RowId, SqlTableName = DHC_Manf_History, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 关联厂商
Property MANFHPhmnfDr As User.PHManufacturer [ SqlColumnNumber = 2, SqlFieldName = MANFH_Phmnf_Dr ];

/// 开始日期
Property MANFHStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = MANFH_StartDate ];

/// 截止日期
Property MANFHEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MANFH_EndDate ];

/// 代码
Property MANFHCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MANFH_Code ];

/// 名称
Property MANFHName As %Library.String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MANFH_Name ];

/// 电话
Property MANFHTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MANFH_Tel ];

/// 地址
Property MANFHAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MANFH_Address ];

/// 药品生产许可证
Property MANFHDrugProductPermit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MANFH_DrugProduct_Permit ];

/// MANF_DrugProduct_ExpDate
Property MANFHDrugProductExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = MANFH_DrugProduct_ExpDate ];

/// MANF_MatProduct_Permit
Property MANFHMatProductPermit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MANFH_MatProduct_Permit ];

/// MANF_MatProduct_ExpDate
Property MANFHMatProductExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = MANFH_MatProduct_ExpDate ];

/// 工商执照
Property MANFHComLic As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MANFH_ComLic ];

/// 执照有效期
Property MANFHComLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = MANFH_ComLicDate ];

/// 工商注册号
Property MANFHBusinessRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MANFH_BusinessRegNo ];

/// 工商注册效期
Property MANFHBusinessRegExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = MANFH_BusinessReg_ExpDate ];

/// 组织机构代码
Property MANFHOrgCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MANFH_OrgCode ];

/// 组织机构代码效期
Property MANFHOrgCodeExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = MANFH_OrgCode_ExpDate ];

/// 税务登记号
Property MANFHTaxRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MANFH_TaxRegNo ];

/// 上级厂商
Property MANFHParManfDr As User.PHManufacturer [ SqlColumnNumber = 20, SqlFieldName = MANFH_ParManf_Dr ];

/// 更新日期
Property MANFHUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = MANFH_UpdateDate ];

/// 更新时间
Property MANFHUpdateTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = MANFH_UpdateTime ];

/// 更新人
Property MANFHUpdateUserDr As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = MANFH_UpdateUser_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMANFH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MANFH_Address">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MANFH_BusinessRegNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MANFH_BusinessReg_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MANFH_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MANFH_ComLic">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MANFH_ComLicDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MANFH_DrugProduct_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MANFH_DrugProduct_Permit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MANFH_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MANFH_MatProduct_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MANFH_MatProduct_Permit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MANFH_Name">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MANFH_OrgCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MANFH_OrgCode_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MANFH_ParManf_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MANFH_Phmnf_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MANFH_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MANFH_TaxRegNo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MANFH_Tel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MANFH_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MANFH_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MANFH_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^DHCMANFH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MANFH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MANFH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCMANFH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MANFH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SDManf"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MANFH_Phmnf_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MANFH_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{MANFH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCManfHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMANFH)
	s oldI = +$g(^mdata("DHCMANFHISTORY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMANFH = maxI
	s ^mdata("DHCMANFHISTORY") = maxI
}

}
