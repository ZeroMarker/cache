/// Function: 医疗机构扩展表
/// CreateDate:2020-01-13
/// Creator:  sunfengchao
Class User.CTRefClinExtend Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = CTRFC_RowId, SqlTableName = CT_RefClinExtend, StorageStrategy = SQLStorage ]
{

/// 医疗机构地址  
Property CTRFCAddress As %String [ SqlColumnNumber = 2, SqlFieldName = CTRFC_Address ];

/// 医疗机构等级
Property CTRFCRank As %String [ SqlColumnNumber = 3, SqlFieldName = CTRFC_Rank ];

/// 医疗机构收费等级
Property CTRFCChargeLevel As %String [ SqlColumnNumber = 4, SqlFieldName = CTRFC_ChargeLevel ];

/// 医疗机构类别
Property CTRFCInstitutionType As %String [ SqlColumnNumber = 5, SqlFieldName = CTRFC_InstitutionType ];

/// 医疗机构经济类型   
Property CTRFCEconomyType As %String [ SqlColumnNumber = 6, SqlFieldName = CTRFC_EconomyType ];

/// 医疗机构经营性质
Property CTRFCManageNature As %String [ SqlColumnNumber = 7, SqlFieldName = CTRFC_ManageNature ];

/// 所有制形式
Property CTRFCOwnershipForm As %String [ SqlColumnNumber = 8, SqlFieldName = CTRFC_OwnershipForm ];

/// 隶属关系
Property CTRFCSubordRelations As %String [ SqlColumnNumber = 9, SqlFieldName = CTRFC_SubordRelations ];

/// 服务对象
Property CTRFCServiceObject As %String [ SqlColumnNumber = 10, SqlFieldName = CTRFC_ServiceObject ];

/// 主管单位名称  
Property CTRFCCompetUnitName As %String [ SqlColumnNumber = 11, SqlFieldName = CTRFC_CompetUnitName ];

/// 法人姓名
Property CTRFCPersonName As %String [ SqlColumnNumber = 12, SqlFieldName = CTRFC_PersonName ];

/// 法人证件类型
Property CTRFCCertificateType As %String [ SqlColumnNumber = 13, SqlFieldName = CTRFC_CertificateType ];

/// 法人证件号码
Property CTRFCCertificateCode As %String [ SqlColumnNumber = 14, SqlFieldName = CTRFC_CertificateCode ];

/// 法人联系地址
Property CTRFCPersonAddress As %String [ SqlColumnNumber = 15, SqlFieldName = CTRFC_PersonAddress ];

/// 法人联系电话
Property CTRFCPersonPhone As %String [ SqlColumnNumber = 16, SqlFieldName = CTRFC_PersonPhone ];

/// 医疗机构邮政编码
Property CTRFCZipCode As %String [ SqlColumnNumber = 17, SqlFieldName = CTRFC_ZipCode ];

/// 社会信用代码
Property CTRFCSociaCreditCode As %String [ SqlColumnNumber = 18, SqlFieldName = CTRFC_SociaCreditCode ];

/// 执业（经营）许可证号
Property CTRFBusinessClicenseCode As %String [ SqlColumnNumber = 19, SqlFieldName = CTRFC_BusinessClicenseCode ];

/// 工商营业执照
Property CTRFCInduComBusinessLicense As %String [ SqlColumnNumber = 20, SqlFieldName = CTRFC_InduComBusinessLicense ];

/// 税务登记代码
Property CTRFCTaxCode As %String [ SqlColumnNumber = 21, SqlFieldName = CTRFC_TaxCode ];

/// 药品经营企业合格证号  
Property CTRFCPhaTradCertificateCode As %String [ SqlColumnNumber = 22, SqlFieldName = CTRFC_PhaTradCertificateCode ];

/// 医疗机构银行行号
Property CTRFCBankCode As %String [ SqlColumnNumber = 23, SqlFieldName = CTRFC_BankCode ];

/// 医疗机构银行户名
Property CTRFCBankName As %String [ SqlColumnNumber = 24, SqlFieldName = CTRFC_BankName ];

/// 医疗机构银行账号
Property CTRFCBankAccount As %String [ SqlColumnNumber = 25, SqlFieldName = CTRFC_BankAccount ];

/// 建筑面积
Property CTRFCConstructionArea As %String [ SqlColumnNumber = 26, SqlFieldName = CTRFC_ConstructionArea ];

/// 业务用房面积
Property CTRFCBusinessArea As %String [ SqlColumnNumber = 27, SqlFieldName = CTRFC_BusinessArea ];

/// 占地面积
Property CTRFCCoversArea As %String [ SqlColumnNumber = 28, SqlFieldName = CTRFC_CoversArea ];

/// 医疗机构批准床位数
Property CTRFCApprovedBedsNum As %String [ SqlColumnNumber = 29, SqlFieldName = CTRFC_ApprovedBedsNum ];

/// 医疗机构实际开放床位数  
Property CTRFCActualBedsNum As %String [ SqlColumnNumber = 30, SqlFieldName = CTRFC_ActualBedsNum ];

/// 所属行政区划代码
Property CTRFCAdministDivisionCode As %String [ SqlColumnNumber = 31, SqlFieldName = CTRFC_AdministDivisionCode ];

/// 注册地址 
Property CTRFCRegisteredAddress As %String [ SqlColumnNumber = 32, SqlFieldName = CTRFC_RegisteredAddress ];

/// 注册地址行政区划代码
Property CTRFCRegisteredDivisionCode As %String [ SqlColumnNumber = 33, SqlFieldName = CTRFC_RegisteredDivisionCode ];

/// 组织机构代码
Property CTRFCInstitutionCode As %String [ SqlColumnNumber = 34, SqlFieldName = CTRFC_InstitutionCode ];

/// 组织机构代码证号
Property CTRFCInstitutionCodeNum As %String [ SqlColumnNumber = 35, SqlFieldName = CTRFC_InstitutionCodeNum ];

/// 注册资金
Property CTRFCRegisteredCapital As %String [ SqlColumnNumber = 36, SqlFieldName = CTRFC_RegisteredCapital ];

/// 生产经营状态
Property CTRFCStatus As %String [ SqlColumnNumber = 37, SqlFieldName = CTRFC_Status ];

/// 母婴保健技术服务执业许可证号  
Property CTRFCMachildLicenseCode As %String [ SqlColumnNumber = 38, SqlFieldName = CTRFC_MachildLicenseCode ];

/// 院长 
Property CTRFCGeneMgr As %String [ SqlColumnNumber = 39, SqlFieldName = CTRFC_GeneMgr ];

/// 上级医疗机构代码  
Property CTRFCParentOrgCode As %String [ SqlColumnNumber = 40, SqlFieldName = CTRFC_ParentOrgCode ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterCTRFC">
<Data name="CTRFC_ActualBedsNum">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>29</Piece>
</Data>
<Data name="CTRFC_Address">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>1</Piece>
</Data>
<Data name="CTRFC_AdministDivisionCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>30</Piece>
</Data>
<Data name="CTRFC_ApprovedBedsNum">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>28</Piece>
</Data>
<Data name="CTRFC_BankAccount">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>24</Piece>
</Data>
<Data name="CTRFC_BankCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>22</Piece>
</Data>
<Data name="CTRFC_BankName">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>23</Piece>
</Data>
<Data name="CTRFC_BusinessArea">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>26</Piece>
</Data>
<Data name="CTRFC_BusinessClicenseCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>18</Piece>
</Data>
<Data name="CTRFC_CertificateCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>13</Piece>
</Data>
<Data name="CTRFC_CertificateType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>12</Piece>
</Data>
<Data name="CTRFC_ChargeLevel">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>3</Piece>
</Data>
<Data name="CTRFC_CompetUnitName">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>10</Piece>
</Data>
<Data name="CTRFC_ConstructionArea">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>25</Piece>
</Data>
<Data name="CTRFC_CoversArea">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>27</Piece>
</Data>
<Data name="CTRFC_EconomyType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>5</Piece>
</Data>
<Data name="CTRFC_GeneMgr">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>38</Piece>
</Data>
<Data name="CTRFC_InduComBusinessLicense">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>19</Piece>
</Data>
<Data name="CTRFC_InstitutionCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>33</Piece>
</Data>
<Data name="CTRFC_InstitutionCodeNum">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>34</Piece>
</Data>
<Data name="CTRFC_InstitutionType">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>4</Piece>
</Data>
<Data name="CTRFC_MachildLicenseCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>37</Piece>
</Data>
<Data name="CTRFC_ManageNature">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>6</Piece>
</Data>
<Data name="CTRFC_OwnershipForm">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>7</Piece>
</Data>
<Data name="CTRFC_ParentOrgCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>39</Piece>
</Data>
<Data name="CTRFC_PersonAddress">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>14</Piece>
</Data>
<Data name="CTRFC_PersonName">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>11</Piece>
</Data>
<Data name="CTRFC_PersonPhone">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>15</Piece>
</Data>
<Data name="CTRFC_PhaTradCertificateCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>21</Piece>
</Data>
<Data name="CTRFC_Rank">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>2</Piece>
</Data>
<Data name="CTRFC_RegisteredAddress">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>31</Piece>
</Data>
<Data name="CTRFC_RegisteredCapital">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>35</Piece>
</Data>
<Data name="CTRFC_RegisteredDivisionCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>32</Piece>
</Data>
<Data name="CTRFC_ServiceObject">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>9</Piece>
</Data>
<Data name="CTRFC_SociaCreditCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>17</Piece>
</Data>
<Data name="CTRFC_Status">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>36</Piece>
</Data>
<Data name="CTRFC_SubordRelations">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>8</Piece>
</Data>
<Data name="CTRFC_TaxCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>20</Piece>
</Data>
<Data name="CTRFC_ZipCode">
<Delimiter>"^"</Delimiter>
<Node>"EXT"</Node>
<Piece>16</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTRFC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CTRFC_RowId</SqlRowIdName>
<StreamLocation>^User.CTRefClinS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
