Class EMRservice.entity.ETemKBApprove Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 名称
Property UserID As %String(MAXLEN = 200, TRUNCATE = 1);

/// 备注	
Property Remark As %String(MAXLEN = 200, TRUNCATE = 1);

/// 知识库kbnode或者模板templateversion的ID
Property RelationID As %String(TRUNCATE = 1);

/// 类型：TEMPLATE,KB
Property Type As %String(TRUNCATE = 1);

/// 状态（针对未发布状态）：1、审核者审核发布，2、需要创建者修改
Property Status As %String(TRUNCATE = 1);

}
