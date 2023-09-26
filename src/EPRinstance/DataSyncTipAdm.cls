/// Desc: 	患者数据同步提示设置表
/// 			可以设置指定用户在查看指定患者病历时是否显示数据同步提示界面
Class EPRinstance.DataSyncTipAdm Extends %Persistent
{

Property UserID As %String [ Required, SqlColumnNumber = 2 ];

/// 03 关闭指定用户查看指定患者的数据同步提示功能
/// 04 关闭指定用户查看指定患者(出院后)的数据同步提示功能
Property TipCode As %String [ Required, SqlColumnNumber = 3 ];

Property EpisodeID As %String [ Required, SqlColumnNumber = 4 ];

Property TipDesc As %String [ Calculated ];

Index IdxMain On (UserID, EpisodeID) [ Unique ];

Method TipDescGet() As %String
{
	q:(i%TipCode = "03") "关闭此患者数据同步提示"
	q:(i%TipCode = "04") "关闭此患者出院后数据同步提示"
	q ""
}

Storage Default
{
<Data name="DataSyncTipAdmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>TipCode</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.DataSyncTipAdmD</DataLocation>
<DefaultData>DataSyncTipAdmDefaultData</DefaultData>
<IdLocation>^DHCEPRI.DataSyncTipAdmD</IdLocation>
<IndexLocation>^DHCEPRI.DataSyncTipAdmI</IndexLocation>
<StreamLocation>^DHCEPRI.DataSyncTipAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
