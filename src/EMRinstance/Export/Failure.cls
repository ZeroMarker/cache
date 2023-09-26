/// Desc:      病历导出失败队列表
/// Creator:   Candy
/// CreateDate:2015-4-29
Class EMRinstance.Export.Failure Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病人ID
Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 病历ID
Property InstanceID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 编辑器类型GRID 表格编辑器(首页用),DOC word编辑器 
Property PluginType As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 病历类型，可重复模板"Multiple"，唯一模板"Single"
Property ChartItemType As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 客户端IP
Property ClientIP As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 导出类型
Property Type As %String [ SqlColumnNumber = 8 ];

/// 导出页数
Property PageCount As %String [ SqlColumnNumber = 9 ];

/// 导出起始页
Property StartPage As %String [ SqlColumnNumber = 10 ];

/// 导出终止页
Property EndPage As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 优先级
Property Priority As %Integer [ SqlColumnNumber = 12 ];

/// 对列创建日期
Property HappenDate As %Date [ SqlColumnNumber = 13 ];

/// 对列创建时间
Property HappenTime As %Time [ SqlColumnNumber = 14 ];

/// 任务开始日期
Property TaskDate As %Date [ SqlColumnNumber = 15 ];

/// 任务开始时间
Property TaskTime As %Time [ SqlColumnNumber = 16 ];

Property TaskRemark As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 执行任务Ip
Property TaskIP As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// 就诊类型
Property AdmType As %String [ SqlColumnNumber = 19 ];

/// 文件类型jpg,xml等
Property FileType As %String [ SqlColumnNumber = 20 ];

Index IdxQueue On (PatientID, EpisodeID, InstanceID);

Index IdxTyQueue On (Type, PatientID, EpisodeID, InstanceID);

Index IdxPriority On (EpisodeID, Priority);

Index IdxHappenDateTime On (HappenDate, HappenTime);

Index IdxOTypeHappenDT On (Type, HappenDate, HappenTime);

Index IdxAdOTypeHappenDT On (AdmType, Type, HappenDate, HappenTime);

Index IdxTaskDateTime On (TaskDate, TaskTime);

Index IdxTyTaskDateTime On (Type, TaskDate, TaskTime);

Index IdxTaskFinished On (EpisodeID, PageCount, StartPage, EndPage, Type);

Storage Default
{
<Data name="FailureDefaultData">
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
<Value>InstanceID</Value>
</Value>
<Value name="5">
<Value>PluginType</Value>
</Value>
<Value name="6">
<Value>ChartItemType</Value>
</Value>
<Value name="7">
<Value>ClientIP</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>PageCount</Value>
</Value>
<Value name="10">
<Value>StartPage</Value>
</Value>
<Value name="11">
<Value>EndPage</Value>
</Value>
<Value name="12">
<Value>Priority</Value>
</Value>
<Value name="13">
<Value>HappenDate</Value>
</Value>
<Value name="14">
<Value>HappenTime</Value>
</Value>
<Value name="15">
<Value>TaskDate</Value>
</Value>
<Value name="16">
<Value>TaskTime</Value>
</Value>
<Value name="17">
<Value>TaskRemark</Value>
</Value>
<Value name="18">
<Value>TaskIP</Value>
</Value>
<Value name="19">
<Value>AdmType</Value>
</Value>
<Value name="20">
<Value>FileType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.Export.FailureD</DataLocation>
<DefaultData>FailureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.Export.FailureD</IdLocation>
<IndexLocation>^DHCEMRI.Export.FailureI</IndexLocation>
<StreamLocation>^DHCEMRI.Export.FailureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
