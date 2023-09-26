/// 用来传输 患者基本信息的 类
Class web.DHCEntity.PCA.PATMAS Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者地址
Property Address As %String(TRUNCATE = 1);

/// 过敏史
Property Allergy As %String(TRUNCATE = 1);

/// 出生日期
Property Birth As %String(TRUNCATE = 1);

/// PAPER_CTRLT_DR
Property CTRelationDR As %String(TRUNCATE = 1);

/// 市（现住）
Property CityDescLookUpRowID As %String(TRUNCATE = 1);

/// 县（现住）
Property CityAreaLookUpRowID As %String(TRUNCATE = 1);

/// 工作单位RowID
Property EmployeeCompanyLookUpRowID As %String(TRUNCATE = 1);

/// 国籍
Property CountryDescLookUpRowID As %String(TRUNCATE = 1);

/// 证件类型
Property CredType As %String(TRUNCATE = 1);

/// 证件号码  对应于 PAPATMas表的PAPMI_DVAnumber字段
Property CredNo As %String(TRUNCATE = 1);

/// 电子邮件
Property EMail As %String(TRUNCATE = 1);

/// PAPER_ForeignId
Property ForeignName As %String(TRUNCATE = 1);

/// 工作单位/ 所处的集团
Property EmployeeCompany As %String(TRUNCATE = 1);

/// 登记号
Property PAPMINo As %String(TRUNCATE = 1);

/// 身份证号
Property IDCardNo1 As %String(TRUNCATE = 1);

/// 住院病历号
Property InMedicare As %String(TRUNCATE = 1);

/// 移动电话
Property MobPhone As %String(TRUNCATE = 1);

/// 患者姓名
Property Name As %String(TRUNCATE = 1);

/// 民族
Property NationDescLookUpRowID As %String(TRUNCATE = 1);

/// 门诊病历号
Property OpMedicare As %String(TRUNCATE = 1);

/// PA_PatMas 表的RowID 
Property PAPMIRowID As %String(TRUNCATE = 1);

/// 患者类别， 患者的Social(患者类型)
Property PatType As %String(TRUNCATE = 1);

/// 省份(现住)
Property ProvinceInfoLookUpRowID As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 家庭电话
Property TelHome As %String(TRUNCATE = 1);

/// 办公室电话/ 单位电话
Property TelOffice As %String(TRUNCATE = 1);

/// 更新日期
Property UpdateDate As %String(TRUNCATE = 1);

/// 操作用户
Property UserDR As %String(TRUNCATE = 1);

/// 更新时间
Property UpdateTime As %String(TRUNCATE = 1);

/// 职业
Property Vocation As %String(TRUNCATE = 1);

/// 邮编
Property ZipLookUpRowID As %String(TRUNCATE = 1);

/// 医保号 by guorongyong BJFC  对应 PA_PatMas表的PAPMIName3
Property PatYBCode As %String;

/// 医疗证 上海东方  对应 PA_PatMas表的PAPMI_ConcessionCardNo
Property MedicalCardNo As %String;

/// 更多的证件
Property OtherCardInfo As %String(MAXLEN = 1000);

/// 工号  协和
Property EmployeeNo As %String;

/// 合同单位  协和
Property HCPDR As %String;

/// 费别  PAPMI_InsurSpecType
Property AdmReason As %String;

/// 公费医疗证号  PAPMI_InsurCardNo
Property InsurCardNo As %String;

/// 婚姻状况
Property PAPERMarital As %String;

/// 医联码
Property MedUnionCard As %String;

/// 联系人证件类型
Property ForeignCredType As %String;

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

/// 出生地 联众导入用 dhc_person.PAPER_BirthAddress 2012-11-16保存位置修改
Property BirthPlace As %String(TRUNCATE = 1);

/// 血型 联众导入用
Property BloodType As %String(TRUNCATE = 1);

/// 工作单位邮编 dhc_person.PAPER_Comment1 2012-11-16保存位置修改
Property CompanyPostCode As %String(TRUNCATE = 1);

/// 联系人地址
Property ForeignAddress As %String(TRUNCATE = 1);

/// 联系人邮编 联众导入用
Property ForeignPostCode As %String(TRUNCATE = 1);

/// 初诊科室 联众导入用
Property GPOrgAddress As %String(TRUNCATE = 1);

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

/// 2012-11-16增加信息
/// 省(籍贯) PAPER_Province_Birth_DR
Property ProvinceHome As %String(TRUNCATE = 1);

/// 市(籍贯) PAPER_CityBirth_DR
Property CityHome As %String(TRUNCATE = 1);

/// 省(出生)dhc_person.PAPER_BirthProvince_DR
Property ProvinceBirth As %String(TRUNCATE = 1);

/// 市(出生)dhc_person.PAPER_BirthCity_DR
Property CityBirth As %String(TRUNCATE = 1);

/// 县(出生)dhc_person.PAPER_BirthArea_dr
Property AreaBirth As %String(TRUNCATE = 1);

/// 地址(出生)dhc_person.PAPER_BirthAddress
Property AddressBirth As %String(TRUNCATE = 1);

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

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 母语1
Property PAPMILangPrimDR As %String(TRUNCATE = 1);

/// 母语2
Property PAPMILangSecondDR As %String(TRUNCATE = 1);

/// 学历
Property Education As %String(TRUNCATE = 1);

/// 街道出生
Property StreetBirth As %String(TRUNCATE = 1);

/// 街道户口
Property StreetHouse As %String(TRUNCATE = 1);

/// 街道现住
Property StreetNow As %String(TRUNCATE = 1);

/// 县（籍贯）
Property AreaHome As %String(TRUNCATE = 1);

/// 国籍/地区(现住)
Property CountryHouse As %String(TRUNCATE = 1);

/// 国籍/地区(出生)
Property CountryBirth As %String(TRUNCATE = 1);

/// 国籍/地区(籍贯)
Property CountryHome As %String(TRUNCATE = 1);

/// 多类型姓名
Property OtherNameInfo As %String(TRUNCATE = 1);

}
