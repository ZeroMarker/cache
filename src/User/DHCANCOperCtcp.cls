Class User.DHCANCOperCtcp Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ANC_OperCtcp, StorageStrategy = CacheStorage ]
{

Property ANCOCOperationDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANCOC_Operation_Dr ];

Property ANCOCCtcpDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANCOC_Ctcp_Dr ];

Storage CacheStorage
{
<Data name="DHCANCOperCtcpClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCOperCtcpDefaultData">
<Value name="1">
<Value>ANCOCOperationDr</Value>
</Value>
<Value name="2">
<Value>ANCOCCtcpDr</Value>
</Value>
</Data>
<DataLocation>^DHCANC("OperCtcp")</DataLocation>
<DefaultData>DHCANCOperCtcpDefaultData1</DefaultData>
<IdLocation>^DHCANC("OperCtcp")</IdLocation>
<IndexLocation>^DHCANC("OperCtcp",0)</IndexLocation>
<StreamLocation>^User.DHCANCOperCtcpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index OperDr On ANCOCOperationDr As Exact;

}
