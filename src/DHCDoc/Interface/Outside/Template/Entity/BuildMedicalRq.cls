Class DHCDoc.Interface.Outside.Template.Entity.BuildMedicalRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 预约机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// 客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 性别(CT)
Property Sex As %String(TRUNCATE = 1);

/// 出生日期(YYYY-MM-DD)
Property Birth As %String(TRUNCATE = 1);

/// 证件类型(CT)
Property CredType As %String(TRUNCATE = 1);

/// 证件号码
Property CredNo As %String(TRUNCATE = 1);

/// 医保号
Property PatYBCode As %String(TRUNCATE = 1);

/// 婚姻情况(CT)
Property PAPERMarital As %String(TRUNCATE = 1);

/// 联系电话
Property TelHome As %String(TRUNCATE = 1);

/// 病人类型(CT)
Property PatType As %String(TRUNCATE = 1);

/// 民族(CT)
Property Nation As %String(TRUNCATE = 1);

/// 国籍(CT)
Property Country As %String(TRUNCATE = 1);

/// 籍贯(CT)
Property HomePlace As %String(TRUNCATE = 1);

/// 出生国家(CT)
Property CountryBirth As %String(TRUNCATE = 1);

/// 出生省(CT)
Property ProvinceBirth As %String(TRUNCATE = 1);

/// 出生市(CT)
Property CityBirth As %String(TRUNCATE = 1);

/// 出生区县(CT)
Property AreaBirth As %String(TRUNCATE = 1);

/// 出生地址
Property AddressBirth As %String(TRUNCATE = 1);

/// 现住址国家(CT)
Property CountryCurrent As %String(TRUNCATE = 1);

/// 现住址省(CT)
Property ProvinceCurrent As %String(TRUNCATE = 1);

/// 现住市(CT)
Property CityCurrent As %String(TRUNCATE = 1);

/// 现住区县(CT)
Property AreaCurrent As %String(TRUNCATE = 1);

/// 现住地址
Property AddressCurrent As %String(TRUNCATE = 1);

/// 现住邮编
Property ZipCurrent As %String(TRUNCATE = 1);

/// 户口国家(CT)
Property CountryHouse As %String(TRUNCATE = 1);

/// 户口省(CT)
Property ProvinceHouse As %String(TRUNCATE = 1);

/// 户口市(CT)
Property CityHouse As %String(TRUNCATE = 1);

/// 户口区县(CT)
Property AreaHouse As %String(TRUNCATE = 1);

/// 户口地址
Property AddressHouse As %String(TRUNCATE = 1);

/// 户口邮编
Property ZipHouse As %String(TRUNCATE = 1);

/// 职业(CT)
Property Vocation As %String(TRUNCATE = 1);

/// 工作单位
Property Company As %String(TRUNCATE = 1);

/// 工作单位电话
Property TelOffice As %String(TRUNCATE = 1);

/// 工作单位邮编
Property CompanyZip As %String(TRUNCATE = 1);

/// 联系人姓名
Property ForeignName As %String(TRUNCATE = 1);

/// 与联系人关系(CT)
Property CTRelation As %String(TRUNCATE = 1);

/// 联系人地址
Property ForeignAddress As %String(TRUNCATE = 1);

/// 联系人邮编
Property ForeignZip As %String(TRUNCATE = 1);

/// 联系人电话
Property ForeignPhone As %String(TRUNCATE = 1);

/// 联系人证件号
Property ForeignIDCard As %String(TRUNCATE = 1);

/// 公费单位(CT)
Property HCP As %String(TRUNCATE = 1);

/// 公费证号
Property HCPNo As %String(TRUNCATE = 1);

/// 工号
Property EmployeeNo As %String(TRUNCATE = 1);

/// 行政区域(CT)
Property HealthCareRegion As %String(TRUNCATE = 1);

/// 是否专程来京就诊
Property AdmSource As %String(TRUNCATE = 1);

}
