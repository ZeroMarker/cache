/// Description：住院Demo-手术记录
/// Table：User.DHCDSSDEMOOperaRec
Class web.CDSSEntity.Demo.OperaRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.OperaRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 术前诊断
Property PreOperaDiag As %String;

/// 拟施手术名称
Property PerOperaName As %String;

/// 拟施手术日期
Property PerOperaDate As %String;

/// 手术名称
Property OperaName As %String;

/// 手术开始时间
Property OperaStartTime As %String;

/// 手术截止时间
Property OperaEndTime As %String;

/// 麻醉方式
Property AnesthesiaMethod As %String;

/// 麻醉开始时间
Property AnesStartTime As %String;

/// 麻醉结束时间
Property AnesEndTime As %String;

/// 手术经过
Property OperaProcess As %String;

/// 手术一般情况
Property OperaGeneral As %String;

/// 术中出现情况及处理
Property OperaCondition As %String;

/// 参加手术人员
Property SurgicalStaff As %String;

/// 术后诊断
Property PostOperaDiag As %String;

/// 手术医师代码
Property SurDoctorCode As %String;

/// 手术医生姓名
Property SurDoctorName As %String;

/// 麻醉医师代码
Property AnesDoctorCode As %String;

/// 麻醉医师姓名
Property AnesDoctorName As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
