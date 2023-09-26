/// 术语库实体类
Class web.CDSSEntity.CMKB.Term Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.Term";

Property MKBTRowId As %String;

Property MKBTCode As %String;

Property MKBTDesc As %String;

Property MKBTBaseDR As %String;

Property MKBTLastLevel As %String;

Property MKBTPYCode As %String;

Property MKBTNote As %String;

Property MKBTSequence As %String;

Property MKBTActiveFlag As %String;

Property MKBTDetailCount As %String;

/// 最后操作时间
Property UpdateDate As %String;

/// 责任人（编辑人）
Property ResponUser As %String;

/// 审核人
Property ReviewUser As %String;

/// 状态（初始、编辑中、待审核、审核不通过、已上线、已下线，默认初始）
Property Status As %String;

}
