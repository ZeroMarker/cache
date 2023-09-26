/// Creater:wangcc
/// Descriptions:调配审批记录表
/// Date:2020-07-22
Class DHCINM.Trans.MgTransCheck Extends %Persistent
{

/// 调配申请ID
Property AppId As %String [ SqlColumnNumber = 2, SqlFieldName = Check_AppId ];

/// 状态
Property Status As %String [ SqlColumnNumber = 3, SqlFieldName = Check_Status ];

/// 审批人
Property ActionId As %String [ SqlColumnNumber = 4, SqlFieldName = Check_ActionId ];

/// 审批意见/驳回原因
Property Suggestion As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Check_Suggestion ];

/// 审批日期
Property Date As %Date [ SqlColumnNumber = 6, SqlFieldName = Check_Date ];

/// 审批时间
Property Time As %Time [ SqlColumnNumber = 7, SqlFieldName = Check_Time ];

/// 是否提交审核
Property IsCheck As %String [ SqlColumnNumber = 8, SqlFieldName = Check_IsCheck ];

Index app On (AppId, Status);

Index appid On AppId;

Index ischeck On (AppId, IsCheck);

Index checktime On (AppId, IsCheck, Time);

Storage Default
{
<Data name="MgTransCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppId</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>ActionId</Value>
</Value>
<Value name="5">
<Value>Suggestion</Value>
</Value>
<Value name="6">
<Value>Date</Value>
</Value>
<Value name="7">
<Value>Time</Value>
</Value>
<Value name="8">
<Value>IsCheck</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgTransCheckD</DataLocation>
<DefaultData>MgTransCheckDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgTransCheckD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgTransCheckI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgTransCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
