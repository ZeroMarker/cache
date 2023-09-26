Class DHCExternalService.BillInterface.DHCEntity.PAPerson Extends (%RegisteredObject, %XML.Adaptor, DHCExternalService.BillInterface.DHCEntity.PATMAS, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 年龄
Property PAPERAge As %String(TRUNCATE = 1);

/// 省
Property PAPERCTProvinceDR As %String(TRUNCATE = 1);

/// 家庭 
Property PAPERCTRLTDR As %String(TRUNCATE = 1);

/// 地区
Property PAPERCityAreaDR As %String(TRUNCATE = 1);

/// 出生城市
Property PAPERCityBirthDR As %String(TRUNCATE = 1);

/// 所在城市
Property PAPERCityCodeDR As %String(TRUNCATE = 1);

/// 联系方式
Property PAPERContactNotes As %String(TRUNCATE = 1);

/// 国家
Property PAPERCountryDR As %String(TRUNCATE = 1);

/// 出生日期
Property PAPERDob As %String(TRUNCATE = 1);

/// 教育程度
Property PAPEREducationDR As %String(TRUNCATE = 1);

/// 电子邮件
Property PAPEREmail As %String(TRUNCATE = 1);

/// 家庭地址
Property PAPERForeignAddress As %String(TRUNCATE = 1);

/// 联系人
Property PAPERForeignId As %String(TRUNCATE = 1);

/// 证件号
Property PAPERID As %String(TRUNCATE = 1);

/// 姓名
Property PAPERName As %String(TRUNCATE = 1);

/// 民族
Property PAPERNationDR As %String(TRUNCATE = 1);

/// 职业
Property PAPEROccupationDR As %String(TRUNCATE = 1);

/// 性别
Property PAPERSexDR As %String(TRUNCATE = 1);

/// 病人类型
Property PAPERSocialStatusDR As %String(TRUNCATE = 1);

/// 街道
Property PAPERStName As %String(TRUNCATE = 1);

/// 家庭电话
Property PAPERTelH As %String(TRUNCATE = 1);

/// 更新时间
Property PAPERUpdateDate As %String(TRUNCATE = 1);

/// 邮政编码
Property PAPERZipDR As %String(TRUNCATE = 1);

/// 过敏史
Property PAPMIAllergy As %String(TRUNCATE = 1);

/// 证件类型
Property PAPMICardTypeDR As %String(TRUNCATE = 1);

/// 证件号
Property PAPMIDVAnumber As %String(TRUNCATE = 1);

/// 登记号
Property PAPMINo As %String(TRUNCATE = 1);

/// 联系电话
Property TelHome As %String(TRUNCATE = 1);

/// 医疗证 上海东方  对应 PA_PatMas表的PAPMI_ConcessionCardNo
Property MedicalCardNo As %String;

/// 更多的证件
Property OtherCardInfo As %String;

/// 工号  协和
Property EmployeeNo As %String;

/// 婚姻状况
Property PAPERMarital As %String;

/// 联系人电话
Property ForeignPhone As %String(TRUNCATE = 1);

/// 是否是关注病人
Property PAPERName8 As %String;

}
