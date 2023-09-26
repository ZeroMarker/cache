/// Desc:       数字签名日志
/// Creator:    Candy
/// CreateDate: 2015-7-20
Class EMRinstance.EMRSignLog Extends (%Persistent, %XML.Adaptor)
{

/// 数字签名ID
Property EMRSignID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病历结构ID,历结构表中绑定模板的ID
Property EMRDocID As %String(TRUNCATE = 1);

/// 签名单元
Property Code As %String(TRUNCATE = 1);

/// 病历顺序号
Property EMRNum As %String(TRUNCATE = 1);

/// 病历ID
Property InstanceID As %String(TRUNCATE = 1);

/// 签名用户ID
Property UsrID As %String(TRUNCATE = 1);

/// 签名用户登录科室
Property UsrLoginLocID As %String(TRUNCATE = 1);

/// 签名状态
Property Action As %String(TRUNCATE = 1);

/// 签名日期
Property SignDate As %Date;

/// 签名时间
Property SignTime As %Time;

/// CA签名ID
Property SignID As %String(TRUNCATE = 1);

/// 摘要
Property Digest As %String(TRUNCATE = 1);

/// 数字签名有效
Property isSignValid As %Boolean;

/// 病历原文
Property InstanceData As %GlobalBinaryStream(LOCATION = "^DHCEMRCA.EMRSignLogS");

/// 签名日志ID
Property EMRSignLogID As %String(TRUNCATE = 1);

/// 文档签名类型(cdaxml 签名域/compressxml 压缩整个原文签名/xml 非压缩整个原文签名/layoutxml 展现部分签名)
Property DocSignType As %String(TRUNCATE = 1);

Index IdxEMRSignID On EMRSignID;

Index IdxInstance On InstanceID;

Storage Default
{
<Data name="EMRSignLogDefaultData">
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
<Value>EMRNum</Value>
</Value>
<Value name="5">
<Value>InstanceID</Value>
</Value>
<Value name="6">
<Value>UsrID</Value>
</Value>
<Value name="7">
<Value>Action</Value>
</Value>
<Value name="8">
<Value>SignDate</Value>
</Value>
<Value name="9">
<Value>SignTime</Value>
</Value>
<Value name="10">
<Value>SignID</Value>
</Value>
<Value name="11">
<Value>Digest</Value>
</Value>
<Value name="12">
<Value>isSignValid</Value>
</Value>
<Value name="13">
<Value>InstanceData</Value>
</Value>
<Value name="14">
<Value>EMRSignID</Value>
</Value>
<Value name="15">
<Value>Code</Value>
</Value>
<Value name="16">
<Value>UsrLoginLocID</Value>
</Value>
<Value name="17">
<Value>EMRSignLogID</Value>
</Value>
<Value name="18">
<Value>DocSignType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRCA.EMRSignLogD</DataLocation>
<DefaultData>EMRSignLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRCA.EMRSignLogD</IdLocation>
<IndexLocation>^DHCEMRCA.EMRSignLogI</IndexLocation>
<StreamLocation>^DHCEMRCA.EMRSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
