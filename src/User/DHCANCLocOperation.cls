Class User.DHCANCLocOperation Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LocOper_Id, SqlTableName = DHC_ANC_LocOperation, StorageStrategy = CacheStorage ]
{

Property ANCLOLocationDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANCLO_Location_Dr ];

Property ANCLOOperationDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANCLO_Operation_Dr ];

Index LocOper On (ANCLOLocationDr As Exact, ANCLOOperationDr As Exact);

Index OperLoc On (ANCLOOperationDr As Exact, ANCLOLocationDr As Exact);

Storage CacheStorage
{
<Data name="DHCANCLocOperationClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCLocOperationDefaultData">
<Value name="1">
<Value>ANCLOLocationDr</Value>
</Value>
<Value name="2">
<Value>ANCLOOperationDr</Value>
</Value>
</Data>
<DataLocation>^DHCANC("LocOperation")</DataLocation>
<DefaultData>DHCANCLocOperationDefaultData1</DefaultData>
<IdLocation>^DHCANC("LocOperation")</IdLocation>
<IndexLocation>^DHCANC("LocOperation",0)</IndexLocation>
<SqlRowIdName>LocOper_Id</SqlRowIdName>
<StreamLocation>^User.DHCANCLocOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
