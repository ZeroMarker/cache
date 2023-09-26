Class User.DHCMatRegCert Extends (%Persistent, User.Abstract) [ SqlRowIdName = MRC_RowID, SqlTableName = DHC_MatRegCert, StorageStrategy = SQLStorage ]
{

/// 库存项DR
Property MRCINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = MRC_INCI_DR ];

/// 生产厂家DR
Property MRCPHManfDR As User.PHManufacturer [ SqlColumnNumber = 3, SqlFieldName = MRC_PHManf_DR ];

/// 物资英文名称
Property MRCEnglishDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MRC_EnglishDesc ];

/// 生产场所
Property MRCProArea As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MRC_ProArea ];

/// 生产国家
Property MRCProCountry As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MRC_ProCountry ];

/// 生产国家英文描述
Property MRCProCouEngName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MRC_ProCou_EngName ];

/// 注册标准
Property MRCRegStandard As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MRC_RegStandard ];

/// 性能结构及组成
Property MRCStructure As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MRC_Structure ];

/// 适用范围
Property MRCAppliedRange As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MRC_AppliedRange ];

/// 注册代理
Property MRCRegAgent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MRC_RegAgent ];

/// 药监局变更日期
Property MRCSPDAChangeDate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MRC_SPDAChangeDate ];

/// 注册证号（备案号)
Property MRCNo As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MRC_No ];

/// 注册人名称 生产厂家
Property MRCRegName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MRC_RegName ];

/// 注册人地址 生产厂家地址
Property MRCRegPerAddress As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MRC_RegPerAddress ];

/// 代理人住所
Property MRCAgentAddress As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MRC_AgentAddress ];

/// 物资名称
Property MRCInciDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MRC_InciDesc ];

/// 规格型号
Property MRCSpecForm As %Library.String(COLLATION = "Exact", MAXLEN = 1300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MRC_SpecForm ];

/// 备注
Property MRCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MRC_Remark ];

/// 批准日期
Property MRCApprovalDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = MRC_ApprovalDate ];

/// 有效期至
Property MRCValidUntil As %Library.Date [ SqlColumnNumber = 21, SqlFieldName = MRC_ValidUntil ];

/// 注册证类型
Property MRCCategory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MRC_Category ];

/// 注册证长期标志
Property MRCValidLong As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = MRC_ValidLong ];

/// 注册证延期标志
Property MRCValidExtend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = MRC_ValidExtend ];

/// 型号规格数(医用耗材代码相关)
Property MRCSpecNum As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = MRC_SpecNum ];

/// 医用耗材代码
Property MRCMatInsuCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MRC_MatInsuCode ];

Property MRRegId As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MRC_RegID ];

Property MRManfId As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MRC_ManfID ];

Property MATICCompanyId As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MATIC_CompanyId ];

Property MATICRegCardId As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MATIC_RegCardId ];

/// 备注
Property MRCRemark2 As %Library.String(COLLATION = "Exact", MAXLEN = 1300, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MRC_Remark2 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMRCT)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="MATIC_CompanyId">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MATIC_RegCardId">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MRC_AgentAddress">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MRC_AppliedRange">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRC_ApprovalDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MRC_Category">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MRC_EnglishDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRC_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRC_InciDesc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MRC_ManfID">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MRC_MatInsuCode">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MRC_No">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MRC_PHManf_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRC_ProArea">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRC_ProCou_EngName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRC_ProCountry">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRC_RegAgent">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRC_RegID">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MRC_RegName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MRC_RegPerAddress">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MRC_RegStandard">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MRC_Remark2">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MRC_SPDAChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRC_SpecForm">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MRC_SpecNum">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MRC_Structure">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRC_ValidExtend">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MRC_ValidLong">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MRC_ValidUntil">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCMRCT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MRC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCMRCT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MRC_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MRC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsuMatProduct">
<Global>^DHCMRCT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Product"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MATIC_RegCardId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMatInsuCode">
<Global>^DHCMRCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"MATINSUCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MRC_MatInsuCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MRC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCMRCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MRC_No}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MRC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCMatRegCertS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMRCT)
	s oldI = +$g(^mdata("DHCMATREGCERT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMRCT = maxI
	s ^mdata("DHCMATREGCERT") = maxI
}

}
