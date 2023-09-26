/// Description：住院Demo-麻醉记录
/// Table：User.DHCDSSDEMOAnesRec
Class web.CDSSEntity.Demo.AnesRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.AnesRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 术前诊断
Property PreOperaDiag As %String;

/// 术后诊断
Property PostOperaDiag As %String;

/// 手术名称
Property OperName As %String;

/// 拟施手术名称
Property PerOperaName As %String;

/// 手术类型
Property OperaType As %String;

/// 手术日期
Property OperaTime As %String;

/// 手术医师
Property SurDoctor As %String;

/// 麻醉医师
Property AnesDoctorName As %String;

/// 麻醉方式
Property AnesthesiaMethod As %String;

/// 麻醉开始时间
Property AnesStartTime As %String;

/// 麻醉结束时间
Property AnesEndTime As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
