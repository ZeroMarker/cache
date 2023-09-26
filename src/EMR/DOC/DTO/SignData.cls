/// 名称:	EMR.DOC.DTO.SignData
/// 描述:	签名数据对象
/// 编写者：yejian
/// 编写日期: 2022-9-21
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.SignData Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 文档ID
Property DocumentID As %String(TRUNCATE = 1);

/// 失效(撤销)签名列表
Property Authenticator As %DynamicArray;

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 病历顺序号
Property ListNo As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 签名用户ID
Property SignUserID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// 签名编码
Property Code As %String(TRUNCATE = 1);

/// 签名单元编码
Property ElementCode As %String(TRUNCATE = 1);

/// 失效签名编码
Property InvalidCode As %String(TRUNCATE = 1);

/// 用户证书标识(CA)
Property UserCertCode As %String(TRUNCATE = 1);

/// 证书编码(CA)
Property CertNo As %String(TRUNCATE = 1);

/// 签名哈希
Property Digest As %String(MAXLEN = 32000, TRUNCATE = 1);

/// CA签名ID(医护指向 CA.DigitalSignature，患者 EMR.DB.PatientSign)
Property SignID As %String;

/// 签名类型(CA or SYS)
Property Type As %String;

/// 角色编码(signLevel)
Property RoleName As %String;

/// 角色名称(levelName)
Property RoleDesc As %String;

/// 角色等级(roleLevel)
Property RoleLevel As %String;

/// 操作编码(CF.EMR.DOC.SignRole表的ActionCode)
Property ActionCode As %String;

/// 签名值
Property SignValue As %String(MAXLEN = 32000, TRUNCATE = 1);

/// ip地址
Property IPAddress As %String;

/// 产品标识
Property PmdType As %String;

/// 产品编码
Property PmdCode As %String;

/// 签名日期
Property SignDate As %Date;

/// 签名时间
Property SignTime As %Time;

/// 当前病历上次修改日期
Property PModifyDate As %Date;

/// 当前病历上次修改时间
Property PModifyTime As %Time;

/// 第三方版本(患签)
Property Version As %String(TRUNCATE = 1);

/// 记录ca的算法(患签)
Property Algorithm As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 事件证书(患签)
Property EventCert As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 时间戳(患签)
Property TSValue As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 生物特征(比如指纹、人脸图解析出特征值)(患签)
Property BioFeature As %GlobalCharacterStream;

/// 笔迹图(患签)
Property SignScript As %GlobalCharacterStream;

/// 拍照图(患签)
Property HeaderImage As %GlobalCharacterStream;

/// 指纹图(患签)
Property FingerPrint As %GlobalCharacterStream;

/// 整个签名数据包（某些厂商“生物特征、笔迹图、拍照图、指纹图”等是整体存储）(患签)
Property SignData As %GlobalCharacterStream;

/// 标题选择的医生姓名
Property DoctorName As %String;

/// 标题选择的医生ID
Property DoctorID As %String;

/// 医师级别
Property DoctorLevel As %String;

/// 医师级别编码
Property DoctorLevelCode As %String;

}
