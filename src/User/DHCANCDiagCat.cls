Class User.DHCANCDiagCat Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ANC_DiagCat, StorageStrategy = CacheStorage ]
{

/// Descripation：当前表最初是作为诊断分类使用，后作为一个大分类（人体系统分类）使用，诊断分类与手术分类合一张表
/// 		DHC_ANC_OperationCat,通过查询表结构可以知，同时DHC_ANC_OperationCat 表又可以看作DHC_ANC_DiagCat表的子表
/// 
Property ANCDCCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCDC_Code ];

Property ANCDCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCDC_Desc ];

Storage CacheStorage
{
<Data name="DHCANCDiagCatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCDiagCatDefaultData">
<Value name="1">
<Value>ANCDCCode</Value>
</Value>
<Value name="2">
<Value>ANCDCDesc</Value>
</Value>
</Data>
<DataLocation>^DHCANC("DiagCat")</DataLocation>
<IdLocation>^DHCANC("DiagCat")</IdLocation>
<IndexLocation>^DHCANC("DiagCat",0)</IndexLocation>
<StreamLocation>^User.DHCANCDiagCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
