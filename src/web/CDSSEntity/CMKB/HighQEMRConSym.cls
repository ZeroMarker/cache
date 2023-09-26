/// 名称:优质病历关联诊断因子表
/// 描述:实体类
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2023-4-17
Class web.CDSSEntity.CMKB.HighQEMRConSym Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.HighQEMRConSym";

/// rowid
Property RowId As %String;

/// 优质病历指针
Property EMRDR As %String;

/// 病历节点（主诉/现病史）
Property EMRNode As %String;

/// 症状顺序号
Property SymptomNum As %String;

/// 症状
Property Symptom As %String;

/// 持续时长
Property Duration As %String;

/// 异常最大值
Property AbnormalMax As %String;

/// 异常最小值
Property AbnormalMin As %String;

/// 正常最大值
Property NormalMax As %String;

/// 正常最小值
Property NormalMin As %String;

/// 值域单位
Property RangeUnit As %String;

/// 值域类型
Property RangeType As %String;

/// 病因
Property Cause As %String;

/// 症状类型
Property SymptomType As %String;

/// 归一词
Property SymptomFormal As %String;

/// 上位词
Property SymptomCore As %String;

/// 症状属性
Property SymProperty As %String;

/// 孩子集合
Property SymptomChildren As %String;

/// 部位
Property PartDR As %String;

/// 方位
Property PositionWordDR As %String;

/// 备注
Property Remarks As %String;

}
