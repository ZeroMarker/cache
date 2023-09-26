/// Desc: 	用户数据同步提示设置表
/// 			可以设置指定用户在查看病历时是否显示数据同步提示界面
Class EPRinstance.DataSyncTipUser Extends %Persistent
{

Property UserID As %String [ Required, SqlColumnNumber = 2 ];

/// 01 永久关闭指定用户查看病历时的数据同步提示功能
/// 02 暂时关闭指定用户本次登录查看病历时的数据同步提示功能
Property TipCode As %String [ Required, SqlColumnNumber = 3 ];

Property LogonSession As %String [ SqlColumnNumber = 4 ];

Property TipDesc As %String [ Calculated ];

Index IdxUserID On UserID [ Unique ];

Method TipDescGet() As %String
{
	q:(i%TipCode = "01") "关闭本人数据同步提示"
	q:(i%TipCode = "02") "关闭本人本次登录数据同步提示"
	q ""
}

Storage Default
{
<Data name="DataSyncTipUserDefaultData">
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
<Value>LogonSession</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.DataSyncTipUserD</DataLocation>
<DefaultData>DataSyncTipUserDefaultData</DefaultData>
<IdLocation>^DHCEPRI.DataSyncTipUserD</IdLocation>
<IndexLocation>^DHCEPRI.DataSyncTipUserI</IndexLocation>
<StreamLocation>^DHCEPRI.DataSyncTipUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
