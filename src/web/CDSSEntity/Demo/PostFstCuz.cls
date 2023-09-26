/// Description：住院Demo-术后首次病程
/// Table：User.DHCDSSDEMOPostFstCuz
Class web.CDSSEntity.Demo.PostFstCuz Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.PostFstCuz";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 患者基本信息
Property PatientInfo As %String;

/// 术前诊断
Property PreOperaDiag As %String;

/// 手术时间
Property OperaTime As %String;

/// 手术名称
Property OperName As %String;

/// 术后诊断
Property PostOperaDiag As %String;

/// 手术经过
Property OperaProcess As %String;

/// 手术方式
Property OperaMethod As %String;

/// 麻醉方式
Property AnesthesiaMethod As %String;

/// 术后处理措施
Property PostOperaMeasure As %String;

/// 术后注意事项
Property PostOperaAttention As %String;

/// 手术一般情况
Property OperaGeneral As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
