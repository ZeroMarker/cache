/// 名称:	EMR.DOC.DTO.LisData
/// 描述:	检验数据对象
/// 编写者：yejian
/// 编写日期: 2022-9-21
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.LisData Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 调用接口标识(默认HIS,数据平台、HSBToHis)
Property InterFace As %String(TRUNCATE = 1);

/// 就诊号以","分隔
Property EpisodeIDs As %String(TRUNCATE = 1);

/// 住院号
Property PatientID As %String(TRUNCATE = 1);

/// StDate:开始时间
Property StDate As %String(TRUNCATE = 1);

/// EndDate:结束时间
Property EndDate As %String(TRUNCATE = 1);

/// 审核查询开始时间
Property AuthStDate As %String(TRUNCATE = 1);

/// 审核查询结束时间
Property AuthEndDate As %String(TRUNCATE = 1);

/// 审核标识,0为本次就诊未审核;1为本次就诊审核;2为该患者最新两次就诊所有,目前仅HISUI门诊页面提供
Property AuthorizedFlag As %String(TRUNCATE = 1);

/// 返回分页开始页号
Property StartPage As %String(TRUNCATE = 1);

/// 返回分页结束页号
Property EndPage As %String(TRUNCATE = 1);

/// 就诊日期间隔,例如90天
Property DateGap As %String(TRUNCATE = 1);

/// 本次就诊类型,用于标识是否为门诊
Property AdmType As %String(TRUNCATE = 1);

/// 医嘱ID
Property OEItemRowID As %String(TRUNCATE = 1);

/// 登记号
Property LabEpisodeNo As %String(TRUNCATE = 1);

/// 语言ID
Property LangID As %String(TRUNCATE = 1);

}
