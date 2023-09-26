/// Description：住院Demo-转入记录
/// Table：User.DHCDSSDEMOTransInRec
Class web.CDSSEntity.Demo.TransInRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.TransInRec";

/// RowId
Property RowId As %String;

/************患者表信息********************/
/// 姓名
Property Name As %String;

/// 性别
Property Sex As %String;

/// 年龄
Property Age As %String;

/// 年龄单位
Property AgeUnit As %String;

/************交班记录表信息********************/
/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 主诉
Property ChiefCompSum As %String;

/// 入院情况
Property AdmisComplexion As %String;

/// 入院诊断
Property AdmisDisease As %String;

/// 诊疗经过
Property TreateProcess As %String;

/// 目前情况
Property CurrentSituation As %String;

/// 目前诊断
Property CurrentDiag As %String;

/// 转入诊疗计划
Property TransPurpose As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
