Class User.DHCSTVendorHistory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STVH_RowId, SqlTableName = DHC_STVendor_History, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 关联供应商
Property STVHVendorDR As User.APCVendor [ Required, SqlColumnNumber = 2, SqlFieldName = STVH_Vendor_DR ];

/// 开始日期
Property STVHStartDate As %Library.Date(FORMAT = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = STVH_StartDate ];

/// 截止日期
Property STVHEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = STVH_EndDate ];

/// 代码
Property STVHCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = STVH_Code ];

/// 名称
Property STVHName As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = STVH_Name ];

/// 地址
Property STVHAddr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = STVH_Addr ];

/// 电话
Property STVHTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = STVH_Tel ];

/// 开户银行
Property STVHBank As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = STVH_Bank ];

/// 银行账号
Property STVHBankAcct As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = STVH_BankAcct ];

/// 法人(联系人)
Property STVHPresident As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = STVH_President ];

/// 法人身份证号
Property STVHPresidentID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = STVH_PresidentID ];

/// STVH_RegCapital
Property STVHRegCapital As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = STVH_RegCapital ];

/// STVH_ComLic
Property STVHComLic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = STVH_ComLic ];

/// STVH_ComLicDate
Property STVHComLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = STVH_ComLicDate ];

/// STVH_RevReg
Property STVHRevReg As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = STVH_RevReg ];

/// STVH_RevRegDate
Property STVHRevRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = STVH_RevRegDate ];

/// STVH_DrugManLic
Property STVHDrugManLic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = STVH_DrugManLic ];

/// STVH_DrugManLicDate
Property STVHDrugManLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = STVH_DrugManLicDate ];

/// STVH_MatManLic
Property STVHMatManLic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = STVH_MatManLic ];

/// STVH_MatManLicDate
Property STVHMatManLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = STVH_MatManLicDate ];

/// STVH_Sanitation
Property STVHSanitation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = STVH_Sanitation ];

/// STVH_SanitationDate
Property STVHSanitationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = STVH_SanitationDate ];

/// STVH_OrgCode
Property STVHOrgCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = STVH_OrgCode ];

/// STVH_OrgCodeDate
Property STVHOrgCodeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = STVH_OrgCodeDate ];

/// STVH_Gsp
Property STVHGsp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = STVH_Gsp ];

/// STVH_GspDate
Property STVHGspDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = STVH_GspDate ];

/// STVH_AgentLic
Property STVHAgentLic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = STVH_AgentLic ];

/// STVH_AgentLicDate
Property STVHAgentLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = STVH_AgentLicDate ];

/// STVH_Promises
Property STVHPromises As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = STVH_Promises ];

/// STVH_TrustDeed
Property STVHTrustDeed As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = STVH_TrustDeed ];

/// STVH_Quality
Property STVHQuality As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = STVH_Quality ];

/// STVH_QualityDate
Property STVHQualityDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = STVH_QualityDate ];

/// STVH_SalesName
Property STVHSalesName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = STVH_SalesName ];

/// STVH_SalesDate
Property STVHSalesDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = STVH_SalesDate ];

/// STVH_SalesTel
Property STVHSalesTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = STVH_SalesTel ];

/// 上级供应商
Property STVHParVendorDr As User.APCVendor [ SqlColumnNumber = 37, SqlFieldName = STVH_ParVendor_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTVH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="STVH_Addr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STVH_AgentLic">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="STVH_AgentLicDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="STVH_Bank">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STVH_BankAcct">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STVH_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STVH_ComLic">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="STVH_ComLicDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="STVH_DrugManLic">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="STVH_DrugManLicDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="STVH_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STVH_Gsp">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="STVH_GspDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="STVH_MatManLic">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="STVH_MatManLicDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="STVH_Name">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STVH_OrgCode">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="STVH_OrgCodeDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="STVH_ParVendor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="STVH_President">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STVH_PresidentID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="STVH_Promises">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="STVH_Quality">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="STVH_QualityDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="STVH_RegCapital">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="STVH_RevReg">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="STVH_RevRegDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="STVH_SalesDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="STVH_SalesName">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="STVH_SalesTel">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="STVH_Sanitation">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="STVH_SanitationDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="STVH_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STVH_Tel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STVH_TrustDeed">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="STVH_Vendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSTVH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STVH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{STVH_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSDVend">
<Global>^DHCSTVH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STVH_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SDVend"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{STVH_Vendor_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{STVH_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{STVH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTVendorHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTVH)
	s oldI = +$g(^mdata("DHCSTVENDORHISTORY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTVH = maxI
	s ^mdata("DHCSTVENDORHISTORY") = maxI
}

}
