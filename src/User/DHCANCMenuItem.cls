/// 手术麻醉菜单项
Class User.DHCANCMenuItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANCMI_RowId, SqlTableName = DHC_ANC_MenuItem, StorageStrategy = CacheStorage ]
{

/// 菜单项代码
Property ANCMICode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCMI_Code ];

/// 菜单项名称
Property ANCMIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCMI_Desc ];

/// 菜单项引用页面地址
Property ANCMIPageRoute As %String(MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = ANCMI_PageRoute ];

/// 菜单项关联的菜单分组
Property ANCMIMenuGroupDR As User.DHCANCMenuGroup [ SqlColumnNumber = 5, SqlFieldName = ANCMI_MenuGroup_DR ];

/// 菜单项图标
Property ANCMIIcon As %String [ SqlColumnNumber = 6, SqlFieldName = ANCMI_Icon ];

/// 菜单项的主菜单项
Property ANCMIMainMenuItem As User.DHCANCMenuItem [ SqlColumnNumber = 7, SqlFieldName = ANCMI_MainMenuItem ];

/// 菜单项顺序
Property ANCMISeqNo As %Float [ SqlColumnNumber = 8, SqlFieldName = ANCMI_SeqNo ];

Index MenuGroup On ANCMIMenuGroupDR;

Index Code On ANCMICode As AlphaUp;

Storage CacheStorage
{
<Data name="DHCANCMenuItemDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Master">
<Value name="1">
<Value>ANCMICode</Value>
</Value>
<Value name="2">
<Value>ANCMIDesc</Value>
</Value>
<Value name="3">
<Value>ANCMIPageRoute</Value>
</Value>
<Value name="4">
<Value>ANCMIMenuGroupDR</Value>
</Value>
<Value name="5">
<Value>ANCMIIcon</Value>
</Value>
<Value name="6">
<Value>ANCMIMainMenuItem</Value>
</Value>
<Value name="7">
<Value>ANCMISeqNo</Value>
</Value>
</Data>
<DataLocation>^DHCANC("MenuItem")</DataLocation>
<DefaultData>DHCANCMenuItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("MenuItem")</IdLocation>
<IndexLocation>^DHCANC("MenuItem",0)</IndexLocation>
<StreamLocation>^User.DHCANCMenuItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
