Class DHCEPRFS.Entity.ECTItemType Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 项目类型编码
Property TypeCode As %String(TRUNCATE = 1);

/// 项目类型名称
Property TypeName As %String(TRUNCATE = 1);

/// 项目类型描述
Property TypeDesc As %String(TRUNCATE = 1);

/// 打印csp路径
Property CSPPath As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 顺序号
Property Sequence As %Integer;

/// 产品来源
Property ProductSource As %String(TRUNCATE = 1);

/// 调用方式
Property InvokeType As %String;

/// webservices路径
Property TypeURL As %String(MAXLEN = 2000, TRUNCATE = 1);

/// webservices类
Property TypeClass As %String(MAXLEN = 2000, TRUNCATE = 1);

/// webservices方法
Property TypeMethod As %String(MAXLEN = 2000, TRUNCATE = 1);

/// FTPConfig参数
Property TypeFTPConfig As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 备注
/// 目前用来标识PDF下载中麻醉单的ftpconfig
Property TypeNote As %String;

/// 标识
/// 用来决定PDF下载的方式
Property TypeFlag As %String;

/// 生成方式
/// 目前有六种生成方式:exe,ftp,csp,thirdpartyftp,thirdpartyurl,epr2emr3
Property CreateType As %String;

/// 公司
Property Company As %String;

/// 产品组
Property ProductTeam As %String;

/// 确定生成方式之后的调用类型，比如FTP下面就有EKG、PACS、PIS等
Property CreateTypeSub As %String;

}
