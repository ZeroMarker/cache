Class User.DHCCLCScoreLink Extends %Library.Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCSL_RowId, SqlTableName = DHC_CLC_ScoreLink, StorageStrategy = CacheStorage ]
{

Property CLCSLMainCLCSDr As User.DHCCLCScore [ SqlColumnNumber = 2, SqlFieldName = CLCSL_MainCLCS_Dr ];

Property CLCSLLinkCLCSDr As User.DHCCLCScore [ SqlColumnNumber = 3, SqlFieldName = CLCSL_LinkCLCS_Dr ];

Index M On CLCSLMainCLCSDr As Exact;

Storage CacheStorage
{
<Data name="DHCCLCScoreLinkClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCScoreLinkDefaultData">
<Value name="1">
<Value>CLCSLMainCLCSDr</Value>
</Value>
<Value name="2">
<Value>CLCSLLinkCLCSDr</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("ScoreLink")</DataLocation>
<DefaultData>DHCCLCScoreLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("ScoreLink")</IdLocation>
<IndexLocation>^DHCCLC("ScoreLink",0)</IndexLocation>
<StreamLocation>^User.DHCCLCScoreLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
