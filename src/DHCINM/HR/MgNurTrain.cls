Class DHCINM.HR.MgNurTrain Extends %Persistent
{

/// 人员档案id
Property PerDR As %String [ SqlColumnNumber = 2, SqlFieldName = PerDR ];

/// 培训项目
Property TrainProject As %String [ SqlColumnNumber = 3, SqlFieldName = Train_Project ];

/// 培训开始时间
Property TrainStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Train_StDate ];

/// 培训结束时间
Property TrainEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Train_EndDate ];

/// 期限
Property TrainLength As %String [ SqlColumnNumber = 6, SqlFieldName = Train_Length ];

/// 状态 N:保存 S：提交 A：审核 B：驳回
Property TrainStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Train_Status ];

Index ssid On PerDR;

Storage Default
{
<Data name="MgNurTrainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerDR</Value>
</Value>
<Value name="3">
<Value>TrainProject</Value>
</Value>
<Value name="4">
<Value>TrainStDate</Value>
</Value>
<Value name="5">
<Value>TrainEndDate</Value>
</Value>
<Value name="6">
<Value>TrainLength</Value>
</Value>
<Value name="7">
<Value>TrainStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgNurTrainD</DataLocation>
<DefaultData>MgNurTrainDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurTrainD</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurTrainI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurTrainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
