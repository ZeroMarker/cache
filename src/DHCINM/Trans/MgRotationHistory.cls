/// Creater:wangcc
/// Descriptions:轮转操作日志表
/// Date:2020-07-22
Class DHCINM.Trans.MgRotationHistory Extends %Persistent
{

/// 轮转记录ID
Property DepDR As DHCINM.Trans.MgRotationDep [ SqlColumnNumber = 2, SqlFieldName = Hist_DepDR ];

/// 终止原因
Property Reason As %String [ SqlColumnNumber = 3, SqlFieldName = Hist_Reason ];

/// 操作时间
Property StopDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Hist_StopDate ];

/// 终止操作
Property Operate As %String [ SqlColumnNumber = 5, SqlFieldName = Hist_Operate ];

Index dep On DepDR;

Storage Default
{
<Data name="MgRotationHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepDR</Value>
</Value>
<Value name="3">
<Value>Reason</Value>
</Value>
<Value name="4">
<Value>StopDate</Value>
</Value>
<Value name="5">
<Value>Operate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgRotationHistoryD</DataLocation>
<DefaultData>MgRotationHistoryDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgRotationHistoryD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgRotationHistoryI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgRotationHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
