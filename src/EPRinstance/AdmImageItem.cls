/// 描述：患者就诊图片
/// 创建者：HouJian
/// 创建日期：2011-09-26
Class EPRinstance.AdmImageItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊指针
Property EpisodeID As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 图片数据
Property ImageData As %GlobalBinaryStream(LOCATION = "^DHCEPRI.AdmImageItemS");

/// 热区数据
Property HotSpotData As %GlobalCharacterStream(LOCATION = "^DHCEPRI.AdmImageItemS");

/// 图示数据
Property IconData As %GlobalCharacterStream(LOCATION = "^DHCEPRI.AdmImageItemS");

/// 状态
Property Status As %String(TRUNCATE = 1);

/// 发布状态(0:未发布;1:已发布)
Property IsPublish As %String(TRUNCATE = 1);

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="AdmImageItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>ImageData</Value>
</Value>
<Value name="8">
<Value>HotSpotData</Value>
</Value>
<Value name="9">
<Value>IconData</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>IsPublish</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.AdmImageItemD</DataLocation>
<DefaultData>AdmImageItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.AdmImageItemD</IdLocation>
<IndexLocation>^DHCEPRI.AdmImageItemI</IndexLocation>
<StreamLocation>^DHCEPRI.AdmImageItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
