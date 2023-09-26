/// 名称: 用户模板表
/// 描述: 用户模板表
/// 编写者：叶剑
/// 编写日期: 2017-11-7
Class EMRmeta.UserTemplate Extends %Persistent
{

Index IdxTemplateID On (TemplateID, Sequence);

Index IdxCode On Code;

Index IdxSequence On Sequence;

Index IdxSimpleSpelName On (TemplateID, SimpleSpelName);

Index IdxName On (TemplateID, Name);

Index IdxTemplateIDType On (TemplateID, Type);

Index IdxTemplateCode On (TemplateID, Code);

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
Property Sequence As %Integer;

/// 使用状态 0 未审核，1 已审核,2 申请审核,3 重新申请审核,4 审核不通过,-1 已删除 
Property Status As %String(TRUNCATE = 1);

/// 类型状态 0 全院通用，1 科室
Property Type As %String(TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

Property VersionNumber As %Integer;

Property TemplateData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.UserTemplateS");

Storage Default
{
<Data name="UserTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiagnosCode</Value>
</Value>
<Value name="3">
<Value>DiagnosName</Value>
</Value>
<Value name="4">
<Value>CategoryCode</Value>
</Value>
<Value name="5">
<Value>CategoryName</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>Code</Value>
</Value>
<Value name="11">
<Value>Name</Value>
</Value>
<Value name="12">
<Value>TemplateID</Value>
</Value>
<Value name="13">
<Value>TitleCode</Value>
</Value>
<Value name="14">
<Value>VersionNumber</Value>
</Value>
<Value name="15">
<Value>MetaData</Value>
</Value>
<Value name="16">
<Value>PresentationData</Value>
</Value>
<Value name="17">
<Value>ScriptData</Value>
</Value>
<Value name="18">
<Value>MediasData</Value>
</Value>
<Value name="19">
<Value>InitialData</Value>
</Value>
<Value name="20">
<Value>GridData</Value>
</Value>
<Value name="21">
<Value>TemplateData</Value>
</Value>
<Value name="22">
<Value>SimpleSpelName</Value>
</Value>
<Value name="23">
<Value>Remark</Value>
</Value>
<Value name="24">
<Value>type</Value>
</Value>
<Value name="25">
<Value>Type</Value>
</Value>
<Value name="26">
<Value>AuditID</Value>
</Value>
<Value name="27">
<Value>AuditDate</Value>
</Value>
<Value name="28">
<Value>ModifyID</Value>
</Value>
<Value name="29">
<Value>ModifyDate</Value>
</Value>
<Value name="30">
<Value>OperateMachineIP</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserTemplateD</DataLocation>
<DefaultData>UserTemplateDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserTemplateD</IdLocation>
<IndexLocation>^DHCEMRM.UserTemplateI</IndexLocation>
<StreamLocation>^DHCEMRM.UserTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
