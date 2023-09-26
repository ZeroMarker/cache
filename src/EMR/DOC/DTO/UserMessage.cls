/// 名称:	EMR.DOC.DTO.UserMessage
/// 描述:	当前用户信息对象
/// 编写者：yejian
/// 编写日期: 2022-4-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.UserMessage Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 病种ID
Property DiseaseID As %String(TRUNCATE = 1);

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 医院ID
Property HospitalID As %String(TRUNCATE = 1);

/// 地址
Property IPAddress As %String(TRUNCATE = 1);

/// 患者ID
Property PatientID As %String(TRUNCATE = 1);

/// 产品Code
Property ProductSourceCode As %String(TRUNCATE = 1);

/// 产品来源
Property ProductSourceType As %String(TRUNCATE = 1);

/// HIS的sessionID
Property SessionID As %String(TRUNCATE = 1);

/// 安全组
Property SsgroupID As %String(TRUNCATE = 1);

/// 用户编码
Property UserCode As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 用户科室
Property UserLocID As %String(TRUNCATE = 1);

/// 用户姓名
Property UserName As %String(TRUNCATE = 1);

/// 病历实例ID集合
Property DocumentIDs As %DynamicArray;

/// 病历实例ID
Property DocumentID As %String;

/// 模板ID
Property TemplateID As %String;

/// 业务活动记录编码
Property DocCode As %String;

/// 业务活动记录名称
Property DocName As %String;

/// 语言ID
Property LangID As %String;

}
