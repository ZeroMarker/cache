/// 名称: 用户模板表
/// 描述: 用户模板表
/// 编写者：叶剑
/// 编写日期: 2017-11-9
Class EMRservice.entity.EUserTemplate Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 代码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 名称简拼
Property SimpleSpelName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String;

/// 创建者UserID
Property UserID As %String;

/// 创建时间
Property CreateDate As %String;

/// 审核者ID
Property AuditID As %String;

/// 审核时间
Property AuditDate As %String;

/// 修改者ID
Property ModifyID As %String;

/// 修改日期
Property ModifyDate As %String;

/// 操作IP地址
Property OperateMachineIP As %String;

/// 顺序
Property Sequence As %String;

/// 使用状态 0 未审核，1 已审核，2 申请审核，-1 已删除 
Property Status As %String(TRUNCATE = 1);

/// 类型状态 0 全院通用，1 科室
Property Type As %String(TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

Property VersionNumber As %String;

Property TemplateData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..TemplateData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..TemplateData.Clear()
	}
  	quit "1"
}

}
