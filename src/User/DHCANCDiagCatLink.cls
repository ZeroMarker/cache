Class User.DHCANCDiagCatLink Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ANC_DiagCatLink, StorageStrategy = CacheStorage ]
{

Property ANCDCLICDDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANCDCL_ICD_Dr ];

Property ANCDCLDiagCatDr As User.DHCANCDiagCat [ SqlColumnNumber = 3, SqlFieldName = ANCDCL_DiagCat_Dr ];

Property ANCDCLICDDescAlias As %String [ SqlColumnNumber = 4, SqlFieldName = ANCDCL_ICD_DescAlias ];

Index Cat On ANCDCLDiagCatDr As Exact;

Storage CacheStorage
{
<Data name="DHCANCDiagCatLinkClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCDiagCatLinkDefaultData">
<Value name="1">
<Value>ANCDCLICDDr</Value>
</Value>
<Value name="2">
<Value>ANCDCLDiagCatDr</Value>
</Value>
</Data>
<Data name="DHCANCDiagCatLinkDefaultData1">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>ANCDCLICDDescAlias</Value>
</Value>
</Data>
<DataLocation>^DHCANC("DiagCatLink")</DataLocation>
<DefaultData>DHCANCDiagCatLinkDefaultData1</DefaultData>
<IdLocation>^DHCANC("DiagCatLink")</IdLocation>
<IndexLocation>^DHCANC("DiagCatLink",0)</IndexLocation>
<StreamLocation>^User.DHCANCDiagCatLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
