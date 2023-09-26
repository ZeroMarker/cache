Class EPRinstance.OneStepPrintRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病人就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 打印项目分类
Property CategoryID As %String(TRUNCATE = 1);

/// 打印模板DocID
Property PrintDocID As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 姓名
Property PatientName As %String(TRUNCATE = 1);

/// 打印者
Property UserID As %String(TRUNCATE = 1);

/// 打印者所在科室ID
Property UserCTLocID As %String(TRUNCATE = 1);

/// 打印完成日期
Property FinishDate As %Date;

/// 打印完成时间
Property FinishTime As %Time;

Index IdxEpisodeIDAndPrintDocID On (EpisodeID, PrintDocID);

Index IdxFinishDateTimeAndUserID On (FinishDate, FinishTime, UserID);

Storage Default
{
<Data name="OneStepPrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>FinishDate</Value>
</Value>
<Value name="4">
<Value>FinishTime</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>PatientName</Value>
</Value>
<Value name="7">
<Value>PrintDocID</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
<Value name="9">
<Value>CategoryID</Value>
</Value>
<Value name="10">
<Value>UserCTLocID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.OneStepPrintRecordD</DataLocation>
<DefaultData>OneStepPrintRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.OneStepPrintRecordD</IdLocation>
<IndexLocation>^DHCEPRI.OneStepPrintRecordI</IndexLocation>
<StreamLocation>^DHCEPRI.OneStepPrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
