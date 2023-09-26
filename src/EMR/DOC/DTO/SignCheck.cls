/// 名称:	EMR.DOC.DTO.SignCheck
/// 描述:	签名检查传输对象
/// 编写者：yejian
/// 编写日期: 2022-4-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.SignCheck Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 文档ID
Property DocumentID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 签名单元最后签名编码
Property SignLevel As %String(TRUNCATE = 1);

/// 签名用户ID
Property SignUserID As %String(TRUNCATE = 1);

/// 签名角色编码(CF.EMR.DOC.SignRole表Name)
Property OriSignLevel As %String(TRUNCATE = 1);

/// 签名单元上所有签名的角色
Property AllSignLevel As %DynamicArray;

/// 签名个数
Property SignedLength As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板版本
Property TemplateVersion As %String(TRUNCATE = 1);

/// 业务活动记录编码
Property DOCCode As %String(TRUNCATE = 1);

/// 文档序号
Property ListNo As %String(TRUNCATE = 1);

/// 用户类型（PATIENT 患者， MEDICAL 医生）
Property UserType As %String(TRUNCATE = 1);

/// 登录用户ID
Property LogonUserID As %String(TRUNCATE = 1);

/// 签名元素编码
Property ElementCode As %String(TRUNCATE = 1);

}
