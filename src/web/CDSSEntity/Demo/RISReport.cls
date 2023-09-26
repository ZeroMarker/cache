/// Description：住院Demo-RIS报告
/// Table：User.DHCDSSDEMORISReport
Class web.CDSSEntity.Demo.RISReport Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.RISReport";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 检查科室
Property ExamLoc As %String;

/// 检查编号
Property ExamNumber As %String;

/// 目前诊断
Property CurrentDiag As %String;

/// 检查项目
Property ExamItem As %String;

/// 检查结果
Property ExamResult As %String;

/// 报告人员签名
Property DoctorSign As %String;

/// 报告日期
Property RecordTime As %String;

/// 指向检查医嘱
Property OrdersDR As %String;

}
