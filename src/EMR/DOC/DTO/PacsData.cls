/// 名称:	EMR.DOC.DTO.PacsData
/// 描述:	检查数据对象
/// 编写者：yejian
/// 编写日期: 2022-9-21
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.PacsData Extends %RegisteredObject
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

/// 报告开始时间
Property RrtStartDate As %String(TRUNCATE = 1);

/// 报告结束时间
Property RrtEndDate As %String(TRUNCATE = 1);

/// 报告标识
Property RrtedFlag As %String(TRUNCATE = 1);

/// 返回分页开始页号
Property StartPage As %String(TRUNCATE = 1);

/// 返回分页结束页号
Property EndPage As %String(TRUNCATE = 1);

/// 就诊日期间隔,例如90天
Property DateGap As %String(TRUNCATE = 1);

/// PACS目录ID
Property PacscategoryID As %String(TRUNCATE = 1);

/// 检查医嘱ID
Property OEItemRowID As %String(TRUNCATE = 1);

/// 语言ID
Property LangID As %String(TRUNCATE = 1);

}
