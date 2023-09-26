/// 描述：就诊病历状态表
Class DHCEPRFS.INST.AdmMRStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

// 系统编码(DHC)

Property SysCode As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

// 最终结算标识

Property FlagFinalAccount As %String;

Property FlagFinalAccountDate As %Date;

Property FlagFinalAccountTime As %Time;

Property FlagFinalAccountRemark As %String;

// 病历完成确认标识

Property FlagMRCompletion As %String;

Property FlagMRCompletionDate As %Date;

Property FlagMRCompletionTime As %Time;

Property FlagFinalAccountUserID As %String;

Property FlagMRCompletionUserID As %String;

//必要条件标识

Property NecessaryCondition As %String;

Property NecessaryConditionDate As %Date;

Property NecessaryConditionTime As %Time;

Property NecessaryConditionUserID As %String;

Index IdxEpisodeID On (SysCode, EpisodeID) [ Unique ];

Index IdxPatientID On (SysCode, PatientID, EpisodeID);

Index IdxCreateDateTime On (CreateDate, CreateTime);

Index IdxFlagFinalAccount On (FlagMRCompletion, FlagFinalAccount, FlagFinalAccountDate, FlagFinalAccountTime);

Storage Default
{
<Data name="AdmMRStatusDefaultData">
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
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>FlagFinalAccount</Value>
</Value>
<Value name="8">
<Value>FlagFinalAccountDate</Value>
</Value>
<Value name="9">
<Value>FlagFinalAccountTime</Value>
</Value>
<Value name="10">
<Value>FlagMRCompletion</Value>
</Value>
<Value name="11">
<Value>FlagMRCompletionDate</Value>
</Value>
<Value name="12">
<Value>FlagMRCompletionTime</Value>
</Value>
<Value name="13">
<Value>FlagFinalAccountUserID</Value>
</Value>
<Value name="14">
<Value>FlagMRCompletionUserID</Value>
</Value>
<Value name="15">
<Value>NecessaryCondition</Value>
</Value>
<Value name="16">
<Value>NecessaryConditionDate</Value>
</Value>
<Value name="17">
<Value>NecessaryConditionTime</Value>
</Value>
<Value name="18">
<Value>NecessaryConditionUserID</Value>
</Value>
<Value name="19">
<Value>FlagFinalAccountRemark</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AdmMRStatusD</DataLocation>
<DefaultData>AdmMRStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.AdmMRStatusD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AdmMRStatusI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AdmMRStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
