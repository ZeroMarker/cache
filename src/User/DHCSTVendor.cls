Class User.DHCSTVendor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = STV_RowId, SqlTableName = DHC_STVendor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// STV_Vendor_DR
Property STVVendorDR As User.APCVendor [ SqlColumnNumber = 2, SqlFieldName = STV_Vendor_DR ];

/// STV_ComLic
Property STVComLic As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = STV_ComLic ];

/// STV_ComLicDate
Property STVComLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = STV_ComLicDate ];

/// STV_RevReg
Property STVRevReg As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = STV_RevReg ];

/// STV_RevRegDate
Property STVRevRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = STV_RevRegDate ];

/// STV_DrugManLic
Property STVDrugManLic As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = STV_DrugManLic ];

/// STV_DrugManLicDate
Property STVDrugManLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = STV_DrugManLicDate ];

/// STV_MatManLic
Property STVMatManLic As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = STV_MatManLic ];

/// STV_MatManLicDate
Property STVMatManLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = STV_MatManLicDate ];

/// STV_MatEnrol
Property STVMatEnrol As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = STV_MatEnrol ];

/// STV_MatEnrolDate
Property STVMatEnrolDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = STV_MatEnrolDate ];

/// STV_Sanitation
Property STVSanitation As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = STV_Sanitation ];

/// STV_SanitationDate
Property STVSanitationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = STV_SanitationDate ];

/// STV_OrgCode
Property STVOrgCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = STV_OrgCode ];

/// STV_OrgCodeDate
Property STVOrgCodeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = STV_OrgCodeDate ];

/// STV_Gsp
Property STVGsp As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = STV_Gsp ];

/// STV_GspDate
Property STVGspDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = STV_GspDate ];

/// STV_MatPro
Property STVMatPro As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = STV_MatPro ];

/// STV_MatProDate
Property STVMatProDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = STV_MatProDate ];

/// STV_ProPermit
Property STVProPermit As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = STV_ProPermit ];

/// STV_ProPermitDate
Property STVProPermitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = STV_ProPermitDate ];

/// STV_ImportEnrol
Property STVImportEnrol As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = STV_ImportEnrol ];

/// STV_ImportEnrolDate
Property STVImportEnrolDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = STV_ImportEnrolDate ];

/// STV_ImportLic
Property STVImportLic As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = STV_ImportLic ];

/// STV_ImportLicDate
Property STVImportLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = STV_ImportLicDate ];

/// STV_AgentLic
Property STVAgentLic As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = STV_AgentLic ];

/// STV_Promises
Property STVPromises As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = STV_Promises ];

/// STV_TrustDeed
Property STVTrustDeed As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = STV_TrustDeed ];

/// STV_BackUp
Property STVQuality As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = STV_Quality ];

/// STV_AgentLicDate
Property STVAgentLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = STV_AgentLicDate ];

/// STV_QualityDate
Property STVQualityDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = STV_QualityDate ];

/// STV_SalesName
Property STVSalesName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = STV_SalesName ];

///  STV_SalesDate
Property STVSalesDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 34, SqlFieldName = STV_SalesDate ];

/// STV_SalesTel
Property STVSalesTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = STV_SalesTel ];

/// STV_Type
Property STVType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = STV_Type ];

/// STV_ParVendor_Dr
Property STVParVendorDr As User.APCVendor [ SqlColumnNumber = 37, SqlFieldName = STV_ParVendor_Dr ];

/// STV_Abbrev
Property STVAbbrev As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = STV_Abbrev ];

/// STV_SalesID
Property STVSalesID As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = STV_SalesID ];

/// STV_Email
Property STVEmail As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = STV_Email ];

/// STV_SalesCarrTel
Property STVSalesCarrTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = STV_SalesCarrTel ];

/// STV_SalesLic  - 业务员授权书
Property STVSalesLic As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = STV_SalesLic ];

/// STV_BarCode
Property STVBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = STV_BarCode ];

/// STV_ExpdtBySms  - 短信催货标志
Property STVExpdtBySms As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = STV_ExpdtBySms ];

/// STV_ExpdtByPurchPlat - 采购平台催货标志
Property STVExpdtByPurchPlat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = STV_ExpdtByPurchPlat ];

/// STV_Remarks
Property STVRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = STV_Remarks ];

/// STV_Alias
Property STVAlias As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = STV_Alias ];

/// STV_Category
Property STVCategory As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = STV_Category ];

/// STV_Hospital_DR
Property STVHospitalDR As User.CTHospital [ SqlColumnNumber = 49, SqlFieldName = STV_Hospital_DR ];

/// STV_Universal -通用性标志(不区分药品材料等)
Property STVUniversal As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = STV_Universal ];

/// STV_BankLicApprovalNo -开户行许可证核准号
Property STVBankLicApprovalNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = STV_BankLicApprovalNo ];

/// STV_BankLicNo -开户行许可证编号
Property STVBankLicNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = STV_BankLicNo ];

/// STV_BusinessTerm -营业期限
Property STVBusinessTerm As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 53, SqlFieldName = STV_BusinessTerm ];

/// STV_EstablishedDate -成立日期
Property STVEstablishedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 54, SqlFieldName = STV_EstablishedDate ];

/// STV_VendorEmail -供应商邮箱
Property STVVendorEmail As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = STV_VendorEmail ];

/// STV_CoRenameFlag -公司更名标志
Property STVCoRenameFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = STV_CoRenameFlag ];

/// STV_CarryFlag -转配送标志
Property STVCarryFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = STV_CarryFlag ];

/// STV_RegAddress -工商执照注册地址
Property STVRegAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = STV_RegAddress ];

/// STV_ResponsiblePerson -负责人
Property STVResponsiblePerson As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = STV_ResponsiblePerson ];

/// STV_QualityManager -质量管理人
Property STVQualityManager As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = STV_QualityManager ];

/// STV_DepotAddress -仓库地址
Property STVDepotAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = STV_DepotAddress ];

/// STV_FilingVoucher -备案凭证
Property STVFilingVoucher As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = STV_FilingVoucher ];

/// STV_ComLicIssuedDate -工商执照发证日期
Property STVComLicIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 63, SqlFieldName = STV_ComLicIssuedDate ];

/// STV_ComLicIssuedDept -工商执照发证机关
Property STVComLicIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = STV_ComLicIssuedDept ];

/// STV_RevRegIssuedDate -税务执照发证日期
Property STVRevRegIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 65, SqlFieldName = STV_RevRegIssuedDate ];

/// STV_RevRegIssuedDept -税务执照发证机关
Property STVRevRegIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = STV_RevRegIssuedDept ];

/// STV_OrgCodeIssuedDate -组织机构发证日期
Property STVOrgCodeIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 67, SqlFieldName = STV_OrgCodeIssuedDate ];

/// STV_OrgCodeIssuedDept -组织机构发证机关
Property STVOrgCodeIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = STV_OrgCodeIssuedDept ];

/// STV_DrugManLicIssuedDate -药品经营许可证发证日期
Property STVDrugManLicIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 69, SqlFieldName = STV_DrugManLicIssuedDate ];

/// STV_DrugManLicIssuedDept -药品经营许可证发证机关
Property STVDrugManLicIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = STV_DrugManLicIssuedDept ];

/// STV_MatManLicIssuedDate -医疗器械经营许可证发证日期
Property STVMatManLicIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 71, SqlFieldName = STV_MatManLicIssuedDate ];

/// STV_MatManLicIssuedDept -医疗器械经营许可证发证机关
Property STVMatManLicIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = STV_MatManLicIssuedDept ];

/// STV_MatProIssuedDate -医疗器械生产许可证发证日期
Property STVMatProIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 73, SqlFieldName = STV_MatProIssuedDate ];

/// STV_MatProIssuedDept -医疗器械生产许可证发证机关
Property STVMatProIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = STV_MatProIssuedDept ];

/// STV_GspIssuedDate -GSP认证发证日期
Property STVGspIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 75, SqlFieldName = STV_GspIssuedDate ];

/// STV_GspIssuedDept -GSP认证发证机关
Property STVGspIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = STV_GspIssuedDept ];

/// STV_DrugProIssuedDate -药品生产许可证发证日期
Property STVDrugProIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 77, SqlFieldName = STV_DrugProIssuedDate ];

/// STV_DrugProIssuedDept -药品生产许可证发证机关
Property STVDrugProIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = STV_DrugProIssuedDept ];

/// STV_MatCatOfficial_DR -经营范围(选择官方分类)
Property STVMatCatOfficialDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = STV_MatCatOfficial_DR ];

/// STV_SocialCreditExpDate -社会信用码效期
Property STVSocialCreditExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 80, SqlFieldName = STV_SocialCreditExpDate ];

/// STV_SalesFax -业务员传真
Property STVSalesFax As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 81, SqlFieldName = STV_SalesFax ];

/// STV_PayStatFlag -付款汇总标志(标志为Y才进行付款)
Property STVPayStatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 82, SqlFieldName = STV_PayStatFlag ];

/// STV_SecondMatManLic -第二类医疗器械经营备案凭证
Property STVSecondMatManLic As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = STV_SecondMatManLic ];

/// STV_SecondMatManLicDate -第二类医疗器械经营备案凭证日期
Property STVSecondMatManLicDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 84, SqlFieldName = STV_SecondMatManLicDate ];

/// STV_SecondMatManIssuedDate -第二类医疗器械经营备案凭证发证日期
Property STVSecondMatManIssuedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 85, SqlFieldName = STV_SecondMatManIssuedDate ];

/// STV_SecondMatProIssuedDept -第二类医疗器械经营备案凭证发证机关
Property STVSecondMatManIssuedDept As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = STV_SecondMatManIssuedDept ];

/// STV_ContractNo -合同编号
Property STVContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 87, SqlFieldName = STV_ContractNo ];

/// STV_BillTemplate -随货单模版
Property STVBillTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 88, SqlFieldName = STV_BillTemplate ];

/// STV_SealRecordTable -公司印章备案表
Property STVSealRecordTable As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 89, SqlFieldName = STV_SealRecordTable ];

/// STV_VATInvoiceTemplate -增值税发票模版
Property STVVATInvoiceTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 90, SqlFieldName = STV_VATInvoiceTemplate ];

/// STV_SalesOrderTemplate -销售单模版
Property STVSalesOrderTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = STV_SalesOrderTemplate ];

/// STV_MatQuaAgreement -医疗器械质量保证协议书
Property STVMatQuaAgreement As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 92, SqlFieldName = STV_MatQuaAgreement ];

///  STV_PromisesDate 售后服务承诺书的效期
Property STVPromisesDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 93, SqlFieldName = STV_PromisesDate ];

///  STV_SalesIDDate 业务员身份证的效期
Property STVSalesIDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 94, SqlFieldName = STV_SalesIDDate ];

/// STV_CreditReporting 供应商企业征信记录
Property STVCreditReporting As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = STV_CreditReporting ];

///  STV_CreditReportingDate 供应商企业征信记录有效期
Property STVCreditReportingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 96, SqlFieldName = STV_CreditReportingDate ];

/// STV_ZCYPackaging 中药饮片包装材料资质
Property STVHerbPackaging As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = STV_HerbPackaging ];

///  STV_ZCYPackagingDate 中药饮片包装材料资质有效期
Property STVHerbPackagingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 98, SqlFieldName = STV_HerbPackagingDate ];

///  STV_OfflineTradingFlag 网下标识 (线下交易标识，区分网上交易)
Property STVOfflineTradingFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 99, SqlFieldName = STV_OfflineTradingFlag ];

/// STV_DefInvType
Property STVDefInvType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = STV_DefInvType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTV)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="STV_Abbrev">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="STV_AgentLic">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STV_AgentLicDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="STV_Alias">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="STV_BankLicApprovalNo">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="STV_BankLicNo">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="STV_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="STV_BillTemplate">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="STV_BusinessTerm">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="STV_CarryFlag">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="STV_Category">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="STV_CoRenameFlag">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="STV_ComLic">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STV_ComLicDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STV_ComLicIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="STV_ComLicIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="STV_ContractNo">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="STV_CreditReporting">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="STV_CreditReportingDate">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="STV_DefInvType">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="STV_DepotAddress">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="STV_DrugManLic">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STV_DrugManLicDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STV_DrugManLicIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="STV_DrugManLicIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="STV_DrugProIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="STV_DrugProIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="STV_Email">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="STV_EstablishedDate">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="STV_ExpdtByPurchPlat">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="STV_ExpdtBySms">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="STV_FilingVoucher">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="STV_Gsp">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STV_GspDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="STV_GspIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="STV_GspIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="STV_HerbPackaging">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="STV_HerbPackagingDate">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="STV_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="STV_ImportEnrol">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="STV_ImportEnrolDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="STV_ImportLic">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="STV_ImportLicDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="STV_MatCatOfficial_DR">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="STV_MatEnrol">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="STV_MatEnrolDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="STV_MatManLic">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="STV_MatManLicDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="STV_MatManLicIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="STV_MatManLicIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="STV_MatPro">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="STV_MatProDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="STV_MatProIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="STV_MatProIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="STV_MatQuaAgreement">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="STV_OfflineTradingFlag">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="STV_OrgCode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="STV_OrgCodeDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="STV_OrgCodeIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="STV_OrgCodeIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="STV_ParVendor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="STV_PayStatFlag">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="STV_ProPermit">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="STV_ProPermitDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="STV_Promises">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="STV_PromisesDate">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="STV_Quality">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="STV_QualityDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="STV_QualityManager">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="STV_RegAddress">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="STV_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="STV_ResponsiblePerson">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="STV_RevReg">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="STV_RevRegDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="STV_RevRegIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="STV_RevRegIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="STV_SalesCarrTel">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="STV_SalesDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="STV_SalesFax">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="STV_SalesID">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="STV_SalesIDDate">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="STV_SalesLic">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="STV_SalesName">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="STV_SalesOrderTemplate">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="STV_SalesTel">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="STV_Sanitation">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="STV_SanitationDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="STV_SealRecordTable">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="STV_SecondMatManIssuedDate">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="STV_SecondMatManIssuedDept">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="STV_SecondMatManLic">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="STV_SecondMatManLicDate">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="STV_SocialCreditExpDate">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="STV_TrustDeed">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="STV_Type">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="STV_Universal">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="STV_VATInvoiceTemplate">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="STV_VendorEmail">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="STV_Vendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Global>^DHCSTV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{STV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCSTV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STV_Alias}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParVendor">
<Global>^DHCSTV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ParVend"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{STV_ParVendor_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{STV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^DHCSTV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>STV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{STV_Vendor_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{STV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexType">
<Global>^DHCSTV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{STV_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{STV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTVendorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTV)
	s oldI = +$g(^mdata("DHCSTVENDOR"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTV = maxI
	s ^mdata("DHCSTVENDOR") = maxI
}

}
