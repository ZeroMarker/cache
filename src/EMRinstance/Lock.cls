/// Desc:         电子病历锁表
/// Creator:      Candy
/// CreateDate:   2015-2-12
Class EMRinstance.Lock Extends %Persistent
{

/// 用户ID
Property UserID As %String;

/// 计算机
Property Computer As %String;

/// 锁定日期
Property LockDate As %Date;

/// 锁定日间
Property LockTime As %Time;

/// 操作动作
Property Action As %String;

/// 操作目录CategoryID
Property CategoryID As %String;

/// 操作目录ChapterID
Property ChapterID As %String;

/// 操作目录DocID
Property DocID As %String;

/// 操作文档InstanceID
Property InstanceID As %String;

/// 就诊ID
Property EpisodeID As %String;

/// 指向 SS_USER表SSUSR_Initials
Property UserCode As %String;

/// 模板ID
Property TemplateID As %String;

/// session
Property SessionID As %String;

/// 计算机名ComputerName
Property ComputerName As %String;

/// 用户科室ID
Property UserLocID As %String;

Index IdxMain On (DocID, EpisodeID) [ Unique ];

Index IdxUserLock On (UserID, EpisodeID, DocID);

Index IdxCategory On (CategoryID, EpisodeID);

Index IdxSessionID On SessionID;

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="LockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>Computer</Value>
</Value>
<Value name="4">
<Value>LockDate</Value>
</Value>
<Value name="5">
<Value>LockTime</Value>
</Value>
<Value name="6">
<Value>Action</Value>
</Value>
<Value name="7">
<Value>CategoryID</Value>
</Value>
<Value name="8">
<Value>DocID</Value>
</Value>
<Value name="9">
<Value>InstanceID</Value>
</Value>
<Value name="10">
<Value>EpisodeID</Value>
</Value>
<Value name="11">
<Value>UserCode</Value>
</Value>
<Value name="12">
<Value>TemplateID</Value>
</Value>
<Value name="13">
<Value>SessionID</Value>
</Value>
<Value name="14">
<Value>ChapterID</Value>
</Value>
<Value name="15">
<Value>ComputerName</Value>
</Value>
<Value name="16">
<Value>UserLocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.LockD</DataLocation>
<DefaultData>LockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.LockD</IdLocation>
<IndexLocation>^DHCEMRI.LockI</IndexLocation>
<StreamLocation>^DHCEMRI.LockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
