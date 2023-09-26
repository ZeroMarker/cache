/// Desc:       签名表
/// Creator:    bianshuai
/// CreateDate: 2016-09-27
Class User.DHCPHEMRSign Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病历结构ID,历结构表中绑定模板的ID
Property EMRDocID As %String(TRUNCATE = 1);

/// 签名单元
Property Code As %String(TRUNCATE = 1);

/// 病历顺序号
Property EMRNum As %String(TRUNCATE = 1);

/// 病历ID, 
Property InstanceID As %String(TRUNCATE = 1);

/// 签名用户ID
Property UsrID As %String(TRUNCATE = 1);

/// 签名状态
Property Action As %String(TRUNCATE = 1);

/// 签名类型(CA or SYS)
Property Type As %String;

/// 签名日期
Property SignDate As %Date;

/// 签名时间
Property SignTime As %Time;

/// CA签名ID
Property SignID As %String(TRUNCATE = 1);

/// 摘要
Property Digest As %String(MAXLEN = 32766, TRUNCATE = 1);

/// 数字签名有效
Property isSignValid As %Boolean;

Index IdxUnique On (EpisodeID, EMRDocID, EMRNum, Code, Action) [ Unique ];

Index IdxMain On (EpisodeID, EMRDocID, EMRNum, Action);

Index IdxInstance On InstanceID;

Index IdxLast On (EpisodeID, EMRDocID, EMRNum, SignDate, SignTime);

Storage Default
{
<Data name="EMRSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EMRDocID</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>EMRNum</Value>
</Value>
<Value name="6">
<Value>InstanceID</Value>
</Value>
<Value name="7">
<Value>UsrID</Value>
</Value>
<Value name="8">
<Value>Action</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
<Value name="10">
<Value>SignDate</Value>
</Value>
<Value name="11">
<Value>SignTime</Value>
</Value>
<Value name="12">
<Value>SignID</Value>
</Value>
<Value name="13">
<Value>Digest</Value>
</Value>
<Value name="14">
<Value>isSignValid</Value>
</Value>
</Data>
<DataLocation>^DHCPHI.EMRSignD</DataLocation>
<DefaultData>EMRSignDefaultData</DefaultData>
<IdLocation>^DHCPHI.EMRSignD</IdLocation>
<IndexLocation>^DHCPHI.EMRSignI</IndexLocation>
<StreamLocation>^DHCPHI.EMRSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
