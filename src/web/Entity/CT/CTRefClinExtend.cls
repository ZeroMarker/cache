/// Function: 医疗机构扩展表
/// CreateDate:2020-01-13
/// Creator:  sunfengchao
Class web.Entity.CT.CTRefClinExtend Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTRefClinExtend";

Property CTRFCRowId As %String;

Property CTRFCCode As %String;

Property CTRFCDesc As %String;

Property CTRFCActiveFlag As %String;

Property CTRFCVEMD As %String;

Property CTRFCDateFrom As %String;

Property CTRFCDateTo As %String;

/// 医疗机构地址  
Property CTRFCAddress As %String;

/// 医疗机构等级
Property CTRFCRank As %String;

/// 医疗机构收费等级
Property CTRFCChargeLevel As %String;

/// 医疗机构类别
Property CTRFCInstitutionType As %String;

/// 医疗机构经济类型   
Property CTRFCEconomyType As %String;

/// 医疗机构经营性质
Property CTRFCManageNature As %String;

/// 所有制形式
Property CTRFCOwnershipForm As %String;

/// 隶属关系
Property CTRFCSubordRelations As %String;

/// 服务对象
Property CTRFCServiceObject As %String;

/// 主管单位名称  
Property CTRFCCompetUnitName As %String;

/// 法人姓名
Property CTRFCPersonName As %String;

/// 法人证件类型
Property CTRFCCertificateType As %String;

/// 法人证件号码
Property CTRFCCertificateCode As %String;

/// 法人联系地址
Property CTRFCPersonAddress As %String;

/// 法人联系电话
Property CTRFCPersonPhone As %String;

/// 医疗机构邮政编码
Property CTRFCZipCode As %String;

/// 社会信用代码
Property CTRFCSociaCreditCode As %String;

/// 执业（经营）许可证号
Property CTRFBusinessClicenseCode As %String;

/// 工商营业执照
Property CTRFCInduComBusinessLicense As %String;

/// 税务登记代码
Property CTRFCTaxCode As %String;

/// 药品经营企业合格证号  
Property CTRFCPhaTradCertificateCode As %String;

/// 医疗机构银行行号
Property CTRFCBankCode As %String;

/// 医疗机构银行户名
Property CTRFCBankName As %String;

/// 医疗机构银行账号
Property CTRFCBankAccount As %String;

/// 建筑面积
Property CTRFCConstructionArea As %String;

/// 业务用房面积
Property CTRFCBusinessArea As %String;

/// 占地面积
Property CTRFCCoversArea As %String;

/// 医疗机构批准床位数
Property CTRFCApprovedBedsNum As %String;

/// 医疗机构实际开放床位数  
Property CTRFCActualBedsNum As %String;

/// 所属行政区划代码
Property CTRFCAdministDivisionCode As %String;

/// 注册地址 
Property CTRFCRegisteredAddress As %String;

/// 注册地址行政区划代码
Property CTRFCRegisteredDivisionCode As %String;

/// 组织机构代码
Property CTRFCInstitutionCode As %String;

/// 组织机构代码证号
Property CTRFCInstitutionCodeNum As %String;

/// 注册资金
Property CTRFCRegisteredCapital As %String;

/// 生产经营状态
Property CTRFCStatus As %String;

/// 母婴保健技术服务执业许可证号  
Property CTRFCMachildLicenseCode As %String;

/// 院长 
Property CTRFCGeneMgr As %String;

/// 上级医疗机构代码  
Property CTRFCParentOrgCode As %String;

}
