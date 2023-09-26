/// Desc:       病历全部完成状态表
/// Creator:    lifengbo
/// CreateDate: 2023-04-17
Class EMR.DOC.DTO.AdmRecordStatus Extends %RegisteredObject
{

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 病历提交状态（1：提交，0：撤销 -1 退回 -2:召回）
Property CompletedStatus As %String;

/// 病历全部完成日期
Property FinishDate As %Date;

/// 病历全部完成时间
Property FinishTime As %Time;

/// 病历提交人
Property UserID As User.SSUser;

/// 操作人IP地址
Property IPAddress As %String;

/// 操作产品模块来源
Property ProductSource As %String;

}
