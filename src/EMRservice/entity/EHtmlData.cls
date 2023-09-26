/// 名称：		EMRservice.entity.EHtmlData
/// 描述：		FTP配置传输对象
/// 编写者：	yejian
/// 编写时间：	2020-3-10
Class EMRservice.entity.EHtmlData Extends (%RegisteredObject, %XML.Adaptor)
{

/// 登记号
Property PATPatientID As %String(TRUNCATE = 1);

/// 住院次数
Property PAADMVisitNumber As %String(TRUNCATE = 1);

/// HTML名称
Property HTMLFileName As %String(TRUNCATE = 1);

/// 病历名称
Property EMRName As %String(TRUNCATE = 1);

/// 医生
Property MedDoc As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDateTime As %String(TRUNCATE = 1);

/// 更新日期
Property UpdateDateTime As %String(TRUNCATE = 1);

/// 更新人
Property UpdateUser As %String(TRUNCATE = 1);

/// 存放位置
Property HTMLFilePath As %String(TRUNCATE = 1);

/// FTPip地址
Property Server As %String(TRUNCATE = 1);

/// FTP端口
Property Port As %String(TRUNCATE = 1);

/// FTP用户
Property Username As %String(TRUNCATE = 1);

/// FTP密码
Property Password As %String(TRUNCATE = 1);

}
