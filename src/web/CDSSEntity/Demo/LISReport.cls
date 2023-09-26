/// Description：住院Demo-LIS报告
/// Table：User.DHCDSSDEMOLISReport
Class web.CDSSEntity.Demo.LISReport Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.LISReport";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 实验室名称
Property Laboratory As %String;

/// 检验编号
Property LabNumber As %String;

/// 目前诊断
Property CurrentDiag As %String;

/// 标本接收时间
Property SpecReceiveTime As %String;

/// 操作人员签名
Property OperatorSign As %String;

/// 审核人员签名
Property ReviewerSign As %String;

/// 报告日期
Property RecordTime As %String;

/// 检验明细数据串
Property Detail As %String;

/// 指向检验医嘱
Property OrdersDR As %String;

}
