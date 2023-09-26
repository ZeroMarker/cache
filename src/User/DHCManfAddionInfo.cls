Class User.DHCManfAddionInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MANF_Rowid, SqlTableName = DHC_Manf_AddionInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MNF_ParManf_DR
Property MANFParManfDR As User.PHManufacturer [ SqlColumnNumber = 2, SqlFieldName = MANF_ParManf_DR ];

/// MANF_DrugProduct_Permit
Property MANFDrugProductPermit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MANF_DrugProduct_Permit ];

/// MANF_DrugProduct_ExpDate
Property MANFDrugProductExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MANF_DrugProduct_ExpDate ];

/// MANF_MatProduct_Permit
Property MANFMatProductPermit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MANF_MatProduct_Permit ];

/// MANF_MatProduct_ExpDate
Property MANFMatProductExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MANF_MatProduct_ExpDate ];

/// MANF_PhcManf_DR
Property MANFPhcManfDR As User.PHManufacturer [ SqlColumnNumber = 7, SqlFieldName = MANF_PhcManf_DR ];

/// Type G-Drug M-Meterial O-other
Property MANFType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MANF_Type ];

/// Business License
Property MANFComLic As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MANF_ComLic ];

/// Bussiness License ExpDate
Property MANFComLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = MANF_ComLicDate ];

/// MANF_Active
Property MANFActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MANF_Active ];

/// MANFBusinessRegNo - 工商注册号
Property MANFBusinessRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MANF_BusinessRegNo ];

/// MANF_BusinessReg_ExpDate - 工商注册效期
Property MANFBusinessRegExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = MANF_BusinessReg_ExpDate ];

/// MANF_OrgCode   - 组织机构代码
Property MANFOrgCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MANF_OrgCode ];

/// MANF_OrgCodeExpDate  - 组织机构代码效期
Property MANFOrgCodeExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = MANF_OrgCode_ExpDate ];

/// MANF_TaxRegNo  --税务登记号
Property MANFTaxRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MANF_TaxRegNo ];

/// MANF_MatManLic   - 器械经营许可证
Property MANFMatManLic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MANF_MatManLic ];

/// MANF_MatManLic_ExpDate  - 器械经营许可证效期
Property MANFMatManLicExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = MANF_MatManLic_ExpDate ];

/// MANF_Category   - 厂商分类
Property MANFCategory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = MANF_Category ];

/// MANF_ProPermitRegForm  - 生产许可登记表
Property MANFProPermitRegForm As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MANF_ProPermitRegForm ];

/// MANF_Alias
Property MANFAlias As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MANF_Alias ];

/// MANF_ProdEprsHygLic  生产企业卫生许可证
Property MANFProdEprsHygLic As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MANF_ProdEprsHygLic ];

/// MANF_ProdEprsHygLicExpDate  生产企业卫生许可证效期
Property MANFProdEprsHygLicExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = MANF_ProdEprsHygLicExpDate ];

/// MANF_GMP  GMP认证号
Property MANFGMP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MANF_GMP ];

/// MANF_SocialCreditCode  社会信用码
Property MANFSocialCreditCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MANF_SocialCreditCode ];

/// MANF_SocialCreditExpDate  社会信用码效期
Property MANFSocialCreditExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = MANF_SocialCreditExpDate ];

/// MANF_EnglishName
Property MANFEnglishName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MANF_EnglishName ];

/// MANF_EnglishAddress
Property MANFEnglishAddress As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MANF_EnglishAddress ];

/// MANF_PostalCode
Property MANFPostalCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MANF_PostalCode ];

/// MANF_DomesticRegNo 国产器械注册证号
Property MANFDomesticRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MANF_DomesticRegNo ];

/// MANF_DomesticRegExpDate  国产器械注册证号效期
Property MANFDomesticRegExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = MANF_DomesticRegExpDate ];

/// MANF_ImportRegNo  进口器械注册证号
Property MANFImportRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = MANF_ImportRegNo ];

/// MANF_ImportRegExpDate  进口器械注册证号效期
Property MANFImportRegExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = MANF_ImportRegExpDate ];

/// MANF_ForeignAgentLic  国外厂家总代理授权书授权书
Property MANFForeignAgentLic As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MANF_ForeignAgentLic ];

/// MANF_ForeignAgentLicDate  国外厂家总代理授权书授权书效期
Property MANFForeignAgentLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = MANF_ForeignAgentLicDate ];

/// MANF_DomesticManLic  国内厂家总代理营业许可证
Property MANFDomesticManLic As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = MANF_DomesticManLic ];

/// MANF_DomesticManLicDate  国内厂家总代理营业许可证效期
Property MANFDomesticManLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = MANF_DomesticManLicDate ];

/// MANF_DomesticMatManLic  国内厂家总代理器械营业许可证
Property MANFDomesticMatManLic As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = MANF_DomesticMatManLic ];

/// MANF_DomesticMatManLicExpDate  国内厂家总代理器械营业许可证
Property MANFDomesticMatManLicExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = MANF_DomesticMatManLicExpDate ];

/// MANF_CloudId  平台id
Property MANFCloudId As %Library.String [ SqlColumnNumber = 40, SqlFieldName = MANF_CloudId ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMANF)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MANF_Active">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MANF_Alias">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MANF_BusinessRegNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MANF_BusinessReg_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MANF_Category">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MANF_CloudId">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MANF_ComLic">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MANF_ComLicDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MANF_DomesticManLic">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MANF_DomesticManLicDate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MANF_DomesticMatManLic">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MANF_DomesticMatManLicExpDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MANF_DomesticRegExpDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MANF_DomesticRegNo">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MANF_DrugProduct_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MANF_DrugProduct_Permit">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MANF_EnglishAddress">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MANF_EnglishName">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MANF_ForeignAgentLic">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MANF_ForeignAgentLicDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MANF_GMP">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MANF_ImportRegExpDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MANF_ImportRegNo">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MANF_MatManLic">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MANF_MatManLic_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MANF_MatProduct_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MANF_MatProduct_Permit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MANF_OrgCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MANF_OrgCode_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MANF_ParManf_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MANF_PhcManf_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MANF_PostalCode">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MANF_ProPermitRegForm">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MANF_ProdEprsHygLic">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MANF_ProdEprsHygLicExpDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MANF_SocialCreditCode">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MANF_SocialCreditExpDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MANF_TaxRegNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MANF_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCMANF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MANF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MANF_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexManf">
<Global>^DHCMANF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MANF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MANF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MANF_PhcManf_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MANF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParManf">
<Global>^DHCMANF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MANF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PARMANF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MANF_ParManf_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MANF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAlias">
<Global>^DHCMANF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MANF_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MANF_Alias}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MANF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexType">
<Global>^DHCMANF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MANF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MANF_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MANF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexactive">
<Global>^DHCMANF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MANF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Act"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MANF_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MANF_Active}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MANF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCManfAddionInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMANF)
	s oldI = +$g(^mdata("DHCMANFADDIONINFO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMANF = maxI
	s ^mdata("DHCMANFADDIONINFO") = maxI
}

}
