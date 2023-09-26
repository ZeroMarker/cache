/// 菜单授权
Class User.DHCANCMenuAuthorization Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANCMA_RowId, SqlTableName = DHC_ANC_MenuAuthorization, StorageStrategy = CacheStorage ]
{

/// 安全组指针
Property ANCMAGroupDR As %Integer [ SqlColumnNumber = 2, SqlFieldName = ANCMA_Group_DR ];

/// 用户指针(某些情况下，某个用户需要特殊权限)
Property ANCMAUserDR As %String [ SqlColumnNumber = 3, SqlFieldName = ANCMA_User_DR ];

/// 菜单项指针
Property ANCMAMenuItemDR As User.DHCANCMenuItem [ SqlColumnNumber = 4, SqlFieldName = ANCMA_MenuItem_DR ];

/// 编辑权限
Property ANCMAEditPermission As %String(SELECTIVITY = "33.3%", VALUELIST = ";Y;N") [ SqlColumnNumber = 5, SqlFieldName = ANCMA_EditPermission ];

Index Group On ANCMAGroupDR;

Index User On ANCMAUserDR;

Storage CacheStorage
{
<Data name="DHCANCMenuAuthorizationDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>ANCMAGroupDR</Value>
</Value>
<Value name="2">
<Value>ANCMAUserDR</Value>
</Value>
<Value name="3">
<Value>ANCMAMenuItemDR</Value>
</Value>
<Value name="4">
<Value>ANCMAEditPermission</Value>
</Value>
</Data>
<DataLocation>^DHCANC("MenuAuth")</DataLocation>
<DefaultData>DHCANCMenuAuthorizationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("MenuAuth")</IdLocation>
<IndexLocation>^DHCANC("MenuAuth",0)</IndexLocation>
<StreamLocation>^User.DHCANCMenuAuthorizationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
