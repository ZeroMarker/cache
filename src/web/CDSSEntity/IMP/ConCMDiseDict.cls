/// 名称:实施综合管理平台-字典对照-对接方中医诊断证型表
/// 描述:实体类
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2022-08-11
Class web.CDSSEntity.IMP.ConCMDiseDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.IMP.ConCMDiseDict";

/// rowid
Property ID As %String;

/// 代码
Property DiseaseCode As %String;

/// 描述
Property DiseaseName As %String;

/// 来源（住院/门诊/急诊）
Property Source As %String;

/// ICD代码
Property ICDCode As %String;

/// 医院
Property HospitalDR As %String;

/// 备注
Property Remarks As %String;

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String;

/// 创建时间（药品数据导入或者手动新增的时间）
Property CreateDate As %String;

/// 创建人
Property CreateUser As %String;

/// 修改时间（对应的就是所有操作时间,包括删除,确认,关联,取消关联）
Property UpdateDate As %String;

/// 修改人
Property UpdateUser As %String;

/// 开始日期	2021-9-3 阚延新 增加开始日期以及结束日期
Property StartDate As %String;

/// 结束日期
Property EndDate As %String;

/// 是否院方常用（1是，0否）
Property IsCommon As %String;

/// 疾病分类（中医/证型）
Property DiagnosisClass As %String;

/// 多院区DR
Property HospitalAreaDR As %String;

}
