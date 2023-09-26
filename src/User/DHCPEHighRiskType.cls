Class User.DHCPEHighRiskType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HRT_RowId, SqlTableName = DHC_PE_HighRiskType, StorageStrategy = CacheStorage ]
{

Parameter ClassName = "User.DHCPEHighRiskType";

Parameter EXTENTSIZE = 250;

//Relationship ChildDHCPEHighRiskExpress As User.DHCPEHighRiskExpress [ Cardinality = children, Inverse = HREParRef ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = HRT_Code ];

Property Desc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = HRT_Desc ];

Property Express As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HRT_Express ];

Storage CacheStorage
{
<Data name="DHCPEHighRiskTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Desc</Value>
</Value>
<Value name="4">
<Value>Express</Value>
</Value>
</Data>
<DataLocation>^DHCPEHRType</DataLocation>
<DefaultData>DHCPEHighRiskTypeDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCPEHRType</IdLocation>
<IndexLocation>^DHCPEHRTypei</IndexLocation>
<StreamLocation>^User.DHCPEHighRiskTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
