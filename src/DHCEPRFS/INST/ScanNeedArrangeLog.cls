/// 描述：待分类就诊表
Class DHCEPRFS.INST.ScanNeedArrangeLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊病案号
Property MRMedRecordID As %String(TRUNCATE = 1);

/// 就诊号
Property MREpisodeID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 是否有未分类  Y--有,N--没有
Property NeedArrange As %String(TRUNCATE = 1);

/// 分类页数
Property ArrangePage As %Integer;

/// 扫描页数
Property ScanPage As %Integer;

/// 病案号
Property MedRecordID As %String(TRUNCATE = 1);

/// IP地址
Property IP As %String(TRUNCATE = 1);

/// 锁的状态
/// Y--锁住 ,N或""--没锁
Property LockStatus As %String(TRUNCATE = 1);

/// 操作日期
Property ActDate As %Date;

/// 操作时间
Property ActTime As %Time;

Relationship ScanNeedArrangeSub As DHCEPRFS.INST.ScanNeedArrangeSub [ Cardinality = children, Inverse = ScanNeedArrangeLog ];

Index IdxOnNeedArrange On NeedArrange;

Index IdxMain On (NeedArrange, UserID);

Index IdxOnEpisodeID On MREpisodeID;

Index IdxOnMedRecordID On MRMedRecordID;

Index IdxOnUser On UserID;

Index IdxOnActDate On (NeedArrange, UserID, ActDate, ActTime);

Index IdxOnAllActDate On (NeedArrange, ActDate, ActTime);

Storage Default
{
<Data name="ScanNeedArrangeLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedRecordID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>NeedArrange</Value>
</Value>
<Value name="6">
<Value>NeedArrangePage</Value>
</Value>
<Value name="7">
<Value>ScanPage</Value>
</Value>
<Value name="8">
<Value>ArrangePage</Value>
</Value>
<Value name="9">
<Value>MRMedRecordID</Value>
</Value>
<Value name="10">
<Value>MREpisodeID</Value>
</Value>
<Value name="11">
<Value>IP</Value>
</Value>
<Value name="12">
<Value>LockStatus</Value>
</Value>
<Value name="13">
<Value>ActDate</Value>
</Value>
<Value name="14">
<Value>ActTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ScanArrangeD</DataLocation>
<DefaultData>ScanNeedArrangeLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.ScanArrangeD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ScanArrangeI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ScanArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
