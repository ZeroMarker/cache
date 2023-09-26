/// 名称：		EMRservice.entity.EFtpData
/// 描述：		FTP配置传输对象
/// 编写者：	yejian
/// 编写时间：	2020-3-10
Class EMRservice.entity.EFtpData Extends (%RegisteredObject, %XML.Adaptor)
{

/// FTPip地址
Property Server As %String(TRUNCATE = 1);

/// FTP端口
Property Port As %String(TRUNCATE = 1);

/// FTP用户
Property Username As %String(TRUNCATE = 1);

/// FTP密码
Property Password As %String(TRUNCATE = 1);

/// 存储文件路径
Property StoreFileName As %String(TRUNCATE = 1);

/// 存储文件目录
Property FileDirectory As %String(TRUNCATE = 1);

}
