/// 手术麻醉菜单组
Class User.DHCANCMenuGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANCMG_RowId, SqlTableName = DHC_ANC_MenuGroup, StorageStrategy = CacheStorage ]
{

/// 菜单组代码
Property ANCMGCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCMG_Code ];

/// 菜单组名称
Property ANCMGDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCMG_Desc ];

/// 菜单组图标
Property ANCMGIcon As %String [ SqlColumnNumber = 4, SqlFieldName = ANCMG_Icon ];

/// 菜单组顺序
Property ANCMGSeqNo As %Float [ SqlColumnNumber = 5, SqlFieldName = ANCMG_SeqNo ];

Index Code On ANCMGCode As AlphaUp;

Storage CacheStorage
{
<Data name="DHCANCMenuGroupDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ANCMGSeqNo</Value>
</Value>
</Data>
<Data name="Master">
<Value name="1">
<Value>ANCMGCode</Value>
</Value>
<Value name="2">
<Value>ANCMGDesc</Value>
</Value>
<Value name="3">
<Value>ANCMGIcon</Value>
</Value>
<Value name="4">
<Value>ANCMGSeqNo</Value>
</Value>
</Data>
<DataLocation>^DHCANC("MenuGroup")</DataLocation>
<DefaultData>DHCANCMenuGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("MenuGroup")</IdLocation>
<IndexLocation>^DHCANC("MenuGroup",0)</IndexLocation>
<StreamLocation>^DHCANCMenuGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
