/// 神经阻滞入路
Class CT.AN.NerveBlockSite Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = NerveBlockSite ]
{

/// 神经阻滞入路代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 神经阻滞入路名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 神经阻滞入路代码唯一索引
Index ICode On Code;

Storage Default
{
<Data name="NerveBlockSiteDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CT.AN.NerveBlockSiteD</DataLocation>
<DefaultData>NerveBlockSiteDefaultData</DefaultData>
<IdLocation>^CT.AN.NerveBlockSiteD</IdLocation>
<IndexLocation>^CT.AN.NerveBlockSiteI</IndexLocation>
<StreamLocation>^CT.AN.NerveBlockSiteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
