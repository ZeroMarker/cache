/// 名称:实施综合管理平台-字典对照-药品字典表
/// 描述:实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-12-25
Class web.CDSSEntity.IMP.ConDrugDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.IMP.ConDrugDict";

// rowid

Property ID As %String;

/// 代码
Property DrugCode As %String;

/// 药品描述
Property DrugName As %String;

/// 商品名
Property DrugTradeName As %String;

/// 别名
Property DrugAlias As %String;

/// 来源（住院/门诊/急诊）
Property Source As %String;

/// 厂家
Property Manufacturers As %String;

/// 成分
Property DrugComposition As %String;

/// 剂型
Property DosageForm As %String;

/// 规格
Property Specification As %String;

/// 医院
Property HospitalDR As %String;

/// 备注（医院自制药品/药监局未报批药品/非药品/原料药/药品名称不明确/中药饮片/耗材）
Property Remarks As %String;

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String;

/// 创建时间（药品数据导入或者手动新增的时间）
Property CreateDate As %String;

/// 创建人
Property CreateUser As %String;

/// 修改时间（对应的就是所有操作时间 包括删除 确认 关联 取消关联）
Property UpdateDate As %String;

/// 修改人
Property UpdateUser As %String;

/// 开始日期	2021-9-3 阚延新 增加开始日期以及结束日期
Property StartDate As %String;

/// 结束日期
Property EndDate As %String;

/// 多院区DR
Property HospitalAreaDR As %String;

}
