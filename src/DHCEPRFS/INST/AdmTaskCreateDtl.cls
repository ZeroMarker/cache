Class DHCEPRFS.INST.AdmTaskCreateDtl Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病历生成日志
Property AdmTaskCreateID As %String(TRUNCATE = 1);

/// 序号
Property OrderNum As %Integer;

/// 病历项目ID
Property MRItemID As %String(TRUNCATE = 1);

/// 病历项目名称
Property MRItemName As %String(TRUNCATE = 1);

/// CTItemTypeCode
Property CTItemTypeCode As %String(TRUNCATE = 1);

/// CTItemTypeName
Property CTItemTypeName As %String(TRUNCATE = 1);

/// CTItemTypeProductSource
Property CTItemTypeProductSource As %String(TRUNCATE = 1);

/// 开始日期
Property BeginActDate As %Date;

/// 开始时间
Property BeginActTime As %Time;

/// 参数
Property Params As %String(MAXLEN = 2048, TRUNCATE = 1);

/// 调用方法
Property InvokeMethod As %String(MAXLEN = 2048, TRUNCATE = 1);

/// 结束日期
Property EndActDate As %Date;

/// 结束时间
Property EndActTime As %Time;

/// 生成服务器IP
Property CreateIP As %String;

Index IdxCreateMRItem On (AdmTaskCreateID, MRItemID);

Index IdxCreateOrderNum On (AdmTaskCreateID, OrderNum) [ Unique ];

Storage Default
{
<Data name="AdmTaskCreateDtlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>MRItemID</Value>
</Value>
<Value name="5">
<Value>MRItemName</Value>
</Value>
<Value name="6">
<Value>CTItemTypeCode</Value>
</Value>
<Value name="7">
<Value>CTItemTypeName</Value>
</Value>
<Value name="8">
<Value>CTItemTypeProductSource</Value>
</Value>
<Value name="9">
<Value>BeginActDate</Value>
</Value>
<Value name="10">
<Value>BeginActTime</Value>
</Value>
<Value name="11">
<Value>Params</Value>
</Value>
<Value name="12">
<Value>InvokeMethod</Value>
</Value>
<Value name="13">
<Value>EndActDate</Value>
</Value>
<Value name="14">
<Value>EndActTime</Value>
</Value>
<Value name="15">
<Value>AdmTaskCreateID</Value>
</Value>
<Value name="16">
<Value>OrderNum</Value>
</Value>
<Value name="17">
<Value>CreateIP</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AdmTaskCrDtlD</DataLocation>
<DefaultData>AdmTaskCreateDtlDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.AdmTaskCrDtlD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AdmTaskCrDtlI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AdmTaskCrDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
