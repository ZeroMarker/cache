Class User.DHCANCOperationCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = DHC_ANC_OperationCat, StorageStrategy = CacheStorage ]
{

Property ANCOCCode As %String [ SqlColumnNumber = 2, SqlFieldName = ANCOC_Code ];

Property ANCOCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANCOC_Desc ];

Property ANCOCCtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANCOC_Ctloc_Dr ];

Property ANCOCDiagCatDr As User.DHCCLCDiagCat [ SqlColumnNumber = 5, SqlFieldName = ANCOC_DiagCat_Dr ];

Property ANCOCType As %String(DISPLAYLIST = ",Operation,Diagnosis", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",O,P") [ SqlColumnNumber = 6, SqlFieldName = ANCOC_Type ];

Storage CacheStorage
{
<Data name="DHCANCOperationCatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCOperationCatDefaultData">
<Value name="1">
<Value>ANCOCCode</Value>
</Value>
<Value name="2">
<Value>ANCOCDesc</Value>
</Value>
<Value name="3">
<Value>ANCOCCtlocDr</Value>
</Value>
<Value name="4">
<Value>ANCOCDiagCatDr</Value>
</Value>
<Value name="5">
<Value>ANCOCType</Value>
</Value>
</Data>
<DataLocation>^DHCANC("OperationCat")</DataLocation>
<DefaultData>DHCANCOperationCatDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("OperationCat")</IdLocation>
<IndexLocation>^DHCANC("OperationCat",0)</IndexLocation>
<StreamLocation>^User.DHCANCOperationCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
