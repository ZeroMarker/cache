/// 名称:中医疾病字典
/// 描述:实体类
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-08-23
Class web.CDSSEntity.CMKB.TCMDisease Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMDisease";

/// rowid
Property ID As %String;

/// 中医疾病编码
Property DiseaseCode As %String;

/// 中医疾病名称
Property DiseaseName As %String;

/// 对应西医名称
Property DiseaseMedicineName As %String;

/// 操作人
Property Operator As %String;

/// 操作时间
Property OperatTime As %String;

/// 状态(编辑中、已审核、已删除)
Property State As %String;

/// 备注
Property Remarks As %String;

/// 别名
Property DiseaseAlias As %String;

/// 版本
Property Version As %String;

/// 关联证型
Property Symptom As %String;

}
