/// Desc:       病历导航操作日志（对象关系模型）
/// Creator:    yejian
/// CreateDate: 2023-2-2 
Class EMRservice.entity.EEMRNavigationLog Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 类型 方案类型 CATEGORY ，方案项目 ITEM,项目科室 ITEMLOC,项目安全组 ITEMGROUP
Property EmrType As %String(TRUNCATE = 1);

/// 操作数据
Property DataID As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 事件 添加 ADD，更新 UP,删除：DELETE
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作者ID
Property UserID As %String(TRUNCATE = 1);

/// 操作者
Property UserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property MachineIP As %String(TRUNCATE = 1);

/// 备注信息
Property Remark As %String(MAXLEN = 5000, TRUNCATE = 1);

}
