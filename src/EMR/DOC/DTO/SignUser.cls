/// 名称:	EMR.DOC.DTO.UserConfig
/// 描述:	签名用户对象
/// 编写者：yejian
/// 编写日期: 2022-4-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.SignUser Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 文档ID
Property DocumentID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 用户编码
Property UserCode As %String(TRUNCATE = 1);

/// 用户密码
Property Password As %String(TRUNCATE = 1);

/// 科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// 院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// 随机数(CA证书会话是否过期)
Property ServerRan As %String(TRUNCATE = 1);

/// 用户证书标识(CA)
Property UserCertCode As %String(TRUNCATE = 1);

/// 证书编码(CA)
Property CertNo As %String(TRUNCATE = 1);

/// 签名角色编码(CF.EMR.DOC.SignRole表Name)
Property OriSignatureLevel As %String(TRUNCATE = 1);

/// 语言ID
Property LangID As %String;

}
