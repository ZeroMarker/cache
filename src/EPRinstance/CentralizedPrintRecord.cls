Class EPRinstance.CentralizedPrintRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 打印者
Property UserID As %String(TRUNCATE = 1);

/// 病人就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 登记号
Property RegisterNo As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 打印项目ID
Property PrintItemsID As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 打印开始日期
Property StartDate As %Date;

/// 打印开始时间
Property StartTime As %Time;

/// 打印完成日期
Property FinishDate As %Date;

/// 打印完成时间
Property FinishTime As %Time;

Index IdxEpisodeID On EpisodeID;

Index IdxStartDateTimeAndUserID On (StartDate, StartTime, UserID);

Index IdxName On (Name, EpisodeID, FinishDate, FinishTime);

Index IdRegisterNo On (RegisterNo, EpisodeID, FinishDate, FinishTime);

Storage Default
{
<Data name="CentralizedPrintRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>FinishTime</Value>
</Value>
<Value name="4">
<Value>PrintItemsDesc</Value>
</Value>
<Value name="5">
<Value>PrintItemsID</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>PatientID</Value>
</Value>
<Value name="9">
<Value>FinishDate</Value>
</Value>
<Value name="10">
<Value>StartDate</Value>
</Value>
<Value name="11">
<Value>RegisterNo</Value>
</Value>
<Value name="12">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.CentralizedRecordD</DataLocation>
<DefaultData>CentralizedPrintRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.CentralizedRecordD</IdLocation>
<IndexLocation>^DHCEPRI.CentralizedRecordI</IndexLocation>
<StreamLocation>^DHCEPRI.CentralizedRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
