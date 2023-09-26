/// 名称:EPRinstance.Query.MedicalQueryTaskList
/// 描述:病历后台查询任务表
/// 编写者：liuyunfei
/// 编写日期: 2020-10-12
Class EPRinstance.Query.MedicalQueryTaskList Extends %Persistent
{

/// 任务名称
Property Name As %String;

/// 任务开始时间
Property StartTime As %String;

/// 任务结束时间
Property EndTime As %String;

/// 任务状态 开始：0；成功：1；失败：2
Property Status As %String;

/// 查询日期类型
Property QueryType As %String;

/// 执行人ID
Property UserID As %String;

/// 执行人Name
Property UserName As %String;

/// 原有查询后会把结果放在临时global中，GUID是临时global的唯一标识
Property GUID As %String;

/// 查询条件
Property Conditions As %String(MAXLEN = 2048);

/// 查询条件中文描述
Property ConditionsDesc As %String(MAXLEN = 1024);

/// 查询结果列
Property ResultColumn As %String(MAXLEN = 2048);

/// HOSPID
Property HospitalId As %String;

Index IdxGUID On GUID [ Unique ];

Index IdxUserID On UserID;

Trigger OnInsert [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
	n id
    s id = {ID}
    
    //开另一个进程去执行，等待进程创建最长是3600秒
    JOB ##class(EPRservice.BLL.Query.BLMedicalQueryTasklist).GetSearchResult(id)::3600

	q 0
}

Storage Default
{
<Data name="MedicalQueryTaskListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>QueryType</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>UserName</Value>
</Value>
<Value name="9">
<Value>GUID</Value>
</Value>
<Value name="10">
<Value>Conditions</Value>
</Value>
<Value name="11">
<Value>ConditionsDesc</Value>
</Value>
<Value name="12">
<Value>ResultColumn</Value>
</Value>
<Value name="13">
<Value>HospitalId</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.MedicalQueryTD</DataLocation>
<DefaultData>MedicalQueryTaskListDefaultData</DefaultData>
<IdLocation>^DHCEPRI.MedicalQueryTD</IdLocation>
<IndexLocation>^DHCEPRI.MedicalQueryTI</IndexLocation>
<StreamLocation>^DHCEPRI.MedicalQueryTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
