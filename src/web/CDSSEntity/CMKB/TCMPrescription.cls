/// Description：中医方剂字典表 
/// Table：CT.WDT.CDSS.TCMPrescription
Class web.CDSSEntity.CMKB.TCMPrescription Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMPrescription";

/// PrescriptionRowId
Property PrescriptionRowId As %String;

/// 方剂编码
Property PrescriptionCode As %String;

/// 方剂名称
Property PrescriptionName As %String;

/// 别名
Property PrescriptionAlias As %String;

/// 主治
Property PrescriptionAttending As %String;

/// 功用
Property PrescriptionFunction As %String;

/// 方剂分类
Property PrescriptionType As %String;

// 出处

// Property PrescriptionSource As %String;

// 关联疾病

// Property RelatedDisease As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %TimeStamp;

/// 状态
Property State As %String;

/// 备注
Property Remarks As %String;

/// Medicine
Property Medicine As %String;

}
