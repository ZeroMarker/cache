/// 名称:	EMR.OP.DTO.OPHistory
/// 描述:	门诊病历-历史就诊对象
/// 编写者：yejian
/// 编写日期: 2022-10-21
/// 产品组：电子病历产品组
Class EMR.OP.DTO.OPHistory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 产品标识
Property Product As %String(TRUNCATE = 1);

/// 住院号
Property PatientID As %String(TRUNCATE = 1);

/// 标识（0 本医师,1 本科室,2 全院）
Property Flag As %String(TRUNCATE = 1);

/// 标识值
Property FlagArg As %String(TRUNCATE = 1);

/// 当前就诊ID
Property CurEpisodeID As %String(TRUNCATE = 1);

/// 就诊ID
Property LastEpisodeID As %String(TRUNCATE = 1);

/// 就诊类型(O门诊,I 住院,E 急诊,"" 全院)
Property AdmType As %String(TRUNCATE = 1);

/// 用户code
Property UserCode As %String(TRUNCATE = 1);

/// 科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// 院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// 安全组ID
Property SSGroupId As %String(TRUNCATE = 1);

/// 是否过滤掉未写门诊病历的记录(Y/N)
Property FilterOPHistoryEmr As %String(TRUNCATE = 1);

/// 是否包含医嘱信息(Y/N)
Property IncludeOeordHistory As %String(TRUNCATE = 1);

/// 语言ID
Property LangID As %String;

}
