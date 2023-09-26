Class EMR.DOC.DTO.HFFormatVersionMLog Extends %Persistent
{

Property ID As %String;

/// 文档版本版本
Property HFVersion As %Integer;

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除(发布不允许删，删备注必填) 
Property Status As %String(TRUNCATE = 1);

/// 创建者ID
Property CreateID As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 修改者ID
Property ModifyID As %String;

/// 修改日期
Property ModifyDate As %Date;

/// 修改时间
Property ModifyTime As %Time;

/// 申请者ID
Property ApplicationID As %String;

/// 申请日期
Property ApplicationDate As %Date;

/// 申请时间
Property ApplicationTime As %Time;

/// 审核者ID
Property AuditID As %String;

/// 审核日期
Property AuditDate As %Date;

/// 审核时间
Property AuditTime As %Time;

/// 操作IP地址
Property OperateMachineIP As %String;

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

Storage Default
{
<Data name="HFFormatVersionMLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
</Value>
<Value name="3">
<Value>HFVersion</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>CreateID</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>ModifyID</Value>
</Value>
<Value name="9">
<Value>ModifyDate</Value>
</Value>
<Value name="10">
<Value>ModifyTime</Value>
</Value>
<Value name="11">
<Value>ApplicationID</Value>
</Value>
<Value name="12">
<Value>ApplicationDate</Value>
</Value>
<Value name="13">
<Value>ApplicationTime</Value>
</Value>
<Value name="14">
<Value>AuditID</Value>
</Value>
<Value name="15">
<Value>AuditDate</Value>
</Value>
<Value name="16">
<Value>AuditTime</Value>
</Value>
<Value name="17">
<Value>OperateMachineIP</Value>
</Value>
<Value name="18">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^EMR.DOC.DTO.HFFormatVerC684D</DataLocation>
<DefaultData>HFFormatVersionMLogDefaultData</DefaultData>
<IdLocation>^EMR.DOC.DTO.HFFormatVerC684D</IdLocation>
<IndexLocation>^EMR.DOC.DTO.HFFormatVerC684I</IndexLocation>
<StreamLocation>^EMR.DOC.DTO.HFFormatVerC684S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
