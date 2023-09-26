/// 名称 : DHCMed.DC.EMR.DailyCourse
/// 说明 : 日常病程记录
Class DHCMed.DC.EMR.DailyCourse Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 记录ID（EMR.InstanceID）
Property ResultID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊号（PA_Adm.ID）
Property EpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标题
Property Title As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病程内容
Property Course As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 发生日期
Property ActDate As %Date;

/// 发生时间
Property ActTime As %Time;

/// 记录医生
Property ActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Storage Default
{
<Data name="DailyCourseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResultID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>Title</Value>
</Value>
<Value name="5">
<Value>ProNote</Value>
</Value>
<Value name="6">
<Value>HappenDate</Value>
</Value>
<Value name="7">
<Value>HappenTime</Value>
</Value>
<Value name="8">
<Value>ActDate</Value>
</Value>
<Value name="9">
<Value>ActTime</Value>
</Value>
<Value name="10">
<Value>ActUser</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UpdateTime</Value>
</Value>
<Value name="14">
<Value>Course</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.EMR.DailyCourseD</DataLocation>
<DefaultData>DailyCourseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.EMR.DailyCourseD</IdLocation>
<IndexLocation>^DHCMed.DC.EMR.DailyCourseI</IndexLocation>
<StreamLocation>^DHCMed.DC.EMR.DailyCourseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
