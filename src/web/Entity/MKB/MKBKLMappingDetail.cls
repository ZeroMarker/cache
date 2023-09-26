/// Creator:谷雪萍
/// CreatDate:2018-05-15
/// Description：医用知识库知识点映射明细表
/// Table：User.MKBKLMappingDetail
Class web.Entity.MKB.MKBKLMappingDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBKLMappingDetail";

/// RowId
Property MKBKMDRowId As %String;

/// 行号
Property MKBKMDRowNum As %String;

/// 知识点映射字段表DR
Property MKBKMDKMBaseFieldDr As %String;

/// 列值
Property MKBKMDValue As %String;

/// 知识点映射表DR
Property MKBKMDKMBaseDr As %String;

}
