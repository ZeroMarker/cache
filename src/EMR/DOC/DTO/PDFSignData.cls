/// 名称:	EMR.DOC.DTO.PDFSignData
/// 描述:	PDF签名数据对象
/// 编写者：yejian
/// 编写日期: 2022-10-9
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.PDFSignData Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 文档ID
Property DocumentID As %String(TRUNCATE = 1);

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 业务活动记录名称
Property DOCName As %String(TRUNCATE = 0);

/// 病历顺序号
Property ListNo As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 签名编码
Property Code As %String(TRUNCATE = 1);

/// 数字签名有效
Property IsValid As %Boolean;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 文档编号
Property UniqueDocID As %String(MAXLEN = 200, TRUNCATE = 0);

/// 业务编号
Property BusinessNo As %String(MAXLEN = 200, TRUNCATE = 0);

/// 签名关键字“[患者签名]”
Property KeyWord As %String(MAXLEN = 200, TRUNCATE = 0);

/// 患者推送签名表ID CA.DigitalSignPatPush.ID
Property PatPushSignID As %String(TRUNCATE = 0);

/// CA端业务编号GUID
Property CABusinessGUID As %String(TRUNCATE = 0);

/// PDF的文件名
Property FileName As %String(MAXLEN = 200, TRUNCATE = 0);

/// PDF在FTP上全路径
Property FilePath As %String(MAXLEN = 200, TRUNCATE = 0);

/// 签名类型：患者签名——patsigned 机构签章orgsealed
Property Action As %String(MAXLEN = 50, TRUNCATE = 0);

/// 签名类型
Property SignType As %String(MAXLEN = 50, TRUNCATE = 0);

/// 签名状态，TOSIGN 待签，SIGNED 已签名
Property SignStatus As %String(MAXLEN = 50, TRUNCATE = 0);

/// 存储类型：FTP——ftp 数据库存储Base64—-db
/// 	混合：hybrid传输使用FTP中转，db存储签后PDF Base64
Property StoreType As %String(MAXLEN = 50, TRUNCATE = 0);

/// 企业签章后的PDF Base64字符串，解码后即为PDF的二进制文件
Property PDFBase64 As %GlobalCharacterStream;

///  待签名的PDF Base64字符串，解码后即为PDF的二进制文件
Property OriginalPDFBase64 As %GlobalCharacterStream;

}
