Class DHCEPRFS.INST.AdmMRStatusLog Extends %Persistent [ Not Abstract, ClassType = persistent, ProcedureBlock ]
{

//表AdmMRStatus的rowID

Property AdmMRStatusID As %String(TRUNCATE = 1);

//系统编码(DHC)

Property SysCode As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

//操作日期

Property ChangeDate As %Date;

//操作时间

Property ChangeTime As %Time;

//最终结算操作人员

Property ChangeUserID As %String;

//最终结算操作状态

//COMPLETE--完成    BACK--退回		REVIEWED--复核通过

Property ChangeAct As %String;

//类型(最终结算或者病历完成)

//DOCTOR--病历完成     NURSE--最终结算   NECESSARY--必要条件   COMMON--一般（不区分角色）

Property Type As %String;

Property Act As %String;

Property Message As %String(MAXLEN = 1000, TRUNCATE = 1);

Index IdxEpisodeID On (SysCode, EpisodeID);

Index IdxAdmMRStatusID On AdmMRStatusID;

Index IdxStatusChangeDateTime On (AdmMRStatusID, ChangeDate, ChangeTime);

Index IdxStatusAct On (AdmMRStatusID, ChangeAct);

Index IdxAction On (SysCode, EpisodeID, Type, ChangeAct);

Storage Default
{
<Data name="AdmMRStatusLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SysCode</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>AdmMRStatusID</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>FlagFinalAccountDate</Value>
</Value>
<Value name="9">
<Value>FlagFinalAccountTime</Value>
</Value>
<Value name="10">
<Value>FlagFinalAccountUserID</Value>
</Value>
<Value name="11">
<Value>FlagFinalAccountChange</Value>
</Value>
<Value name="12">
<Value>FlagMRCompletionDate</Value>
</Value>
<Value name="13">
<Value>FlagMRCompletionTime</Value>
</Value>
<Value name="14">
<Value>FlagMRCompletionUserID</Value>
</Value>
<Value name="15">
<Value>FlagMRCompletionChange</Value>
</Value>
<Value name="16">
<Value>ChangeDate</Value>
</Value>
<Value name="17">
<Value>ChangeTime</Value>
</Value>
<Value name="18">
<Value>ChangeUserID</Value>
</Value>
<Value name="19">
<Value>ChangeAct</Value>
</Value>
<Value name="20">
<Value>Type</Value>
</Value>
<Value name="21">
<Value>Message</Value>
</Value>
<Value name="22">
<Value>Act</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AdmMRStatusLogD</DataLocation>
<DefaultData>AdmMRStatusLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.AdmMRStatusLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AdmMRStatusLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AdmMRStatusLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
