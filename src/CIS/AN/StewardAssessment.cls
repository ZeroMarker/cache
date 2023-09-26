/// Steward评分表
Class CIS.AN.StewardAssessment Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StewardAssessment ]
{

/// 手术安排记录
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 清醒程度
Property Conscious As %Integer [ SqlColumnNumber = 3 ];

/// 呼吸道通畅程度
Property Respiration As %Integer [ SqlColumnNumber = 4 ];

/// 肢体活动度
Property Motion As %Integer [ SqlColumnNumber = 5 ];

/// 总分
Property Score As %Integer [ SqlColumnNumber = 6 ];

/// 评估日期
Property AssessDate As %Date [ SqlColumnNumber = 7 ];

/// 评估时间
Property AssessTime As %Time [ SqlColumnNumber = 8 ];

/// 评估人
Property AssessUser As %String [ SqlColumnNumber = 9 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="StewardAssessmentDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>Conscious</Value>
</Value>
<Value name="3">
<Value>Respiration</Value>
</Value>
<Value name="4">
<Value>Motion</Value>
</Value>
<Value name="5">
<Value>Score</Value>
</Value>
<Value name="6">
<Value>AssessDate</Value>
</Value>
<Value name="7">
<Value>AssessTime</Value>
</Value>
<Value name="8">
<Value>AssessUser</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.StewardAssessmentD</DataLocation>
<DefaultData>StewardAssessmentDefaultData</DefaultData>
<IdLocation>^CIS.AN.StewardAssessmentD</IdLocation>
<IndexLocation>^CIS.AN.StewardAssessmentI</IndexLocation>
<StreamLocation>^CIS.AN.StewardAssessmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
