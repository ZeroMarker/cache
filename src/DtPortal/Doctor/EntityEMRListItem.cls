/// 名称:DtPortal.Doctor.EntityEMRList
/// 描述:D02.10.02查询当前医生待签病历列表服务返回值实体类,明细类
/// 编写者：Guozongtao
/// 编写日期: 2014-08-02
Class DtPortal.Doctor.EntityEMRListItem Extends %RegisteredObject
{

/// 床号
Property BedNum As %String;

/// 就诊号
Property EpisodeID As %String;

/// 登记号
Property PapmiNo As %String;

/// 姓名
Property PapmiName As %String;

/// 病历名称
Property DocumentDesc As %String;

/// 病历实例数据ID
Property InstanceID As %String;

/// 签名医师姓名
Property SignDocName As %String;

/// 状态
Property EMRStatus As %String;

/// 病历目录展现结构ID
Property EMRDocID As %String;

}
