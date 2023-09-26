Class web.DHCEntity.PCA.DHCCardRegInfoDefault Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property CardChequeNo As %String(TRUNCATE = 1);

Property PayAccNo As %String(TRUNCATE = 1);

Property PayCompany As %String(TRUNCATE = 1);

Property amt As %String(TRUNCATE = 1);

Property AccountType As %String(TRUNCATE = 1);

Property Address As %String(TRUNCATE = 1);

Property Age As %String(TRUNCATE = 1);

Property Birth As %String(TRUNCATE = 1);

Property Allergy As %String(TRUNCATE = 1);

Property CardNo As %String(TRUNCATE = 1);

Property CTRelation As %String(TRUNCATE = 1);

Property InMedicare As %String(TRUNCATE = 1);

Property CardRowID As %String(TRUNCATE = 1);

Property CardTypeDefine As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property CredNo As %String(TRUNCATE = 1);

Property OpMedicare As %String(TRUNCATE = 1);

Property CountryDesc As %String(TRUNCATE = 1);

/// 证件类型
Property CredType As %String(TRUNCATE = 1);

Property PAPMINo As %String(TRUNCATE = 1);

Property EMail As %String(TRUNCATE = 1);

Property IDCardNo1 As %String(TRUNCATE = 1);

Property EmployeeCompany As %String(TRUNCATE = 1);

/// PatType
Property PatType As %String(TRUNCATE = 1);

Property EmployeeCompanyLookUpRowID As %String(TRUNCATE = 1);

/// 使用默认密码
Property SetDefaultPassword As %String(TRUNCATE = 1);

Property ForeignName As %String(TRUNCATE = 1);

Property Sex As %String(TRUNCATE = 1);

Property IEType As %String(TRUNCATE = 1);

Property TelHome As %String(TRUNCATE = 1);

Property Vocation As %String(TRUNCATE = 1);

Property MobPhone As %String(TRUNCATE = 1);

Property NationDesc As %String(TRUNCATE = 1);

Property NationDescLookUpRowID As %String(TRUNCATE = 1);

Property PAPMIRowID As %String(TRUNCATE = 1);

/// 支付模式
Property PayMode As %String(TRUNCATE = 1);

Property ProvinceInfo As %String(TRUNCATE = 1);

Property CityDesc As %String(TRUNCATE = 1);

Property TelOffice As %String(TRUNCATE = 1);

Property Zip As %String(TRUNCATE = 1);

Property ZipLookUpRowID As %String(TRUNCATE = 1);

Property GetPatPaySum As %String(TRUNCATE = 1);

/// 关系
Property CTRelationDR As %String(TRUNCATE = 1);

/// 市（现住）
Property CityDescLookUpRowID As %String(TRUNCATE = 1);

/// 县（现住）
Property CityAreaLookUpRowID As %String(TRUNCATE = 1);

/// 省份(现住)
Property ProvinceInfoLookUpRowID As %String(TRUNCATE = 1);

/// 国籍
Property CountryDescLookUpRowID As %String(TRUNCATE = 1);

/// 医疗证 上海东方  对应 PA_PatMas表的PAPMI_ConcessionCardNo
Property MedicalCardNo As %String;

/// 工号  协和
Property EmployeeNo As %String;

/// 合同单位  协和
Property HCPDR As %String;

/// 公费医疗证号  PAPMI_InsurCardNo
Property InsurCardNo As %String;

/// 医联码
Property MedUnionCard As %String;

/// 联系人身份正号
Property ForeignIDCard As %String;

/// 联系人电话
Property ForeignPhone As %String;

/// 行政区域
Property HealthCareRegion As %String;

/// 是否专程来京就诊  PAPER_StayingPermanently  医联码新增
Property AdmSource As %String;

/// 工作单位
Property Company As %String;

/// 协和国际医疗部永久就诊卡标志
Property VIPFlag As %String;

/// 工作单位邮编 dhc_person.PAPER_Comment1 2012-11-16保存位置修改
Property CompanyPostCode As %String(TRUNCATE = 1);

/// 联系人地址
Property ForeignAddress As %String(TRUNCATE = 1);

/// 联系人邮编 联众导入用
Property ForeignPostCode As %String(TRUNCATE = 1);

/// 籍贯 联众导入用
Property HomePlace As %String(TRUNCATE = 1);

/// 家庭所在地区 联众导入用
Property HouseArea As %String(TRUNCATE = 1);

/// 非代码表邮编 联众导入用  dhc_person.PAPER_Comment2
Property PostCode As %String(TRUNCATE = 1);

/// 地址(户口) dhc_person.PAPER_HouseAddress 2012-11-16保存位置修改
Property RegisterPlace As %String(TRUNCATE = 1);

/// 照片信息Base64编码串 导入联众数据使用
Property PhotoInfo As %String(TRUNCATE = 1);

/// 国(籍贯) 
Property CountryHome As %String(TRUNCATE = 1);

/// 2012-11-16增加信息
/// 省(籍贯) PAPER_Province_Birth_DR
Property ProvinceHome As %String(TRUNCATE = 1);

/// 市(籍贯) PAPER_CityBirth_DR
Property CityHome As %String(TRUNCATE = 1);

/// 国(出生)
Property CountryBirth As %String(TRUNCATE = 1);

/// 省(出生)dhc_person.PAPER_BirthProvince_DR
Property ProvinceBirth As %String(TRUNCATE = 1);

/// 市(出生)dhc_person.PAPER_BirthCity_DR
Property CityBirth As %String(TRUNCATE = 1);

/// 县(出生)dhc_person.PAPER_BirthArea_dr
Property AreaBirth As %String(TRUNCATE = 1);

/// 地址(出生)dhc_person.PAPER_BirthAddress
Property AddressBirth As %String(TRUNCATE = 1);

/// 国(户口)
Property CountryHouse As %String(TRUNCATE = 1);

/// 省(户口)dhc_person.PAPER_HouseProvince_DR
Property ProvinceHouse As %String(TRUNCATE = 1);

/// 市(户口)dhc_person.PAPER_HouseCity_DR
Property Cityhouse As %String(TRUNCATE = 1);

/// 县(户口)dhc_person.PAPER_HouseArea_DR
Property AreaHouse As %String(TRUNCATE = 1);

/// 邮编(户口)dhc_person.PAPER_Comment3
Property PostCodeHouse As %String(TRUNCATE = 1);

/// 病人级别 
Property PoliticalLevel As %String(TRUNCATE = 1);

/// 病人密级 密级表 DHC_ SecretLevel
Property SecretLevel As %String(TRUNCATE = 1);

/// 出生时间
Property BirthTime As %String(TRUNCATE = 1);

}
