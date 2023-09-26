/// 名称:EMRservice.entity.EQuotationScheme
/// 描述:病历引用科室配置对象
/// 编写者：yejian
/// 编写日期:2015-1-20
Class EMRservice.entity.EQuotationScheme Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 目录结构ID
Property DocID As %String;

/// 目录结构名称(冗余字段)
Property DocName As %String;

/// 科室ID
Property CTLocID As %String;

/// 科室名称(冗余字段)
Property CTLocDesc As %String;

/// 是否有效
Property IsActive As %String;

}
