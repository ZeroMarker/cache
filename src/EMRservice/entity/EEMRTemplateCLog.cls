/// Desc:       病历展现树操作日志（对象关系模型）
/// Creator:    yejian
/// CreateDate: 2018-6-13
Class EMRservice.entity.EEMRTemplateCLog Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 类型 展现目录 EMRTEMCATEGORY，展现模板 EMRTEMPLATE
Property EmrType As %String(TRUNCATE = 1);

/// 关联数据ID
Property DataID As %String(TRUNCATE = 1);

/// 事件 添加 ADD，更新 UP,添加模板组：ADDGROUP,移除模板组:REMOVEGROUP，删除：DELETE
Property Action As %String(TRUNCATE = 1);

/// 状态 未启用：NOSTART ,启用：START,停用：STOP（只针对DOCID一级）
Property Status As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 启用日期
Property StartDate As %Date;

/// 启用时间
Property StartTime As %Time;

/// 停用日期
Property StopDate As %Date;

/// 停用时间
Property StopTime As %Time;

/// 操作者ID
Property UserID As %String(TRUNCATE = 1);

/// 操作者
Property UserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property MachineIP As %String(TRUNCATE = 1);

/// 备注信息
Property Remark As %String(MAXLEN = 5000, TRUNCATE = 1);

}
