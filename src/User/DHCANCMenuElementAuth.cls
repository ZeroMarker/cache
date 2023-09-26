/// 菜单链接页面的元素授权
Class User.DHCANCMenuElementAuth Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANCMEA_RowId, SqlTableName = DHC_ANC_MenuElementAuth, StorageStrategy = CacheStorage ]
{

/// 菜单授权表指针
Property ANCMEAMenuAuthDR As User.DHCANCMenuAuthorization [ SqlColumnNumber = 2, SqlFieldName = ANCMEA_MenuAuth_DR ];

/// 页面元素ID
Property ANCMEAElementID As %String [ SqlColumnNumber = 3, SqlFieldName = ANCMEA_Element_ID ];

/// 编辑权限
Property ANCMAEditPermission As %String(SELECTIVITY = "33.3%", VALUELIST = ";Y;N") [ SqlColumnNumber = 4, SqlFieldName = ANCMEA_EditPermission ];

/// 读取权限(如无读取权限就隐藏元素)
Property ANCMAShowPermission As %String(SELECTIVITY = "33.3%", VALUELIST = ";Y;N") [ SqlColumnNumber = 5, SqlFieldName = ANCMEA_ShowPermission ];

Index MenuAuth On ANCMEAMenuAuthDR;

Storage CacheStorage
{
<Data name="DHCANCMenuElementAuthDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>ANCMEAMenuAuthDR</Value>
</Value>
<Value name="2">
<Value>ANCMEAElementID</Value>
</Value>
<Value name="3">
<Value>ANCMAEditPermission</Value>
</Value>
<Value name="4">
<Value>ANCMAShowPermission</Value>
</Value>
</Data>
<DataLocation>^DHCANC("MenuElementAuth")</DataLocation>
<DefaultData>DHCANCMenuElementAuthDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("MenuElementAuth")</IdLocation>
<IndexLocation>^DHCANC("MenuElementAuth",0)</IndexLocation>
<StreamLocation>^User.DHCANCMenuElementAuthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
