Class EMRservice.entity.ETextKBContent Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

Property CategoryID As %String;

/// 创建者UserID
Property UserID As %String;

/// 创建时间
Property CreateDate As %String;

/// 审核者ID
Property AuditID As %String;

/// 审核时间
Property AuditDate As %String;

/// 使用状态 0 未审核，1 已审核,2 申请审核,3 重新申请审核,4 审核不通过,-1 已删除 
Property Status As %String(TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Content As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEMRKBContentStream($J)");

/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..Content.GetStreamId()
	if $find(id,"^CacheTempDHCEMRKBContentStream($J)")
	{
  		do ..Content.Clear()
	}
  	quit "1"
}

}
