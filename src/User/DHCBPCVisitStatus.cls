Class User.DHCBPCVisitStatus Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCVS_RowId, SqlTableName = DHC_BPC_VisitStatus, StorageStrategy = CacheStorage ]
{

//转归代码

Property BPCVSCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCVS_Code ];

//转归描述

Property BPCVSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCVS_Desc ];

//转归所属类型(血透、腹透)

Property BPCVSSubType As %String(DISPLAYLIST = ",HemoDialysis,PeritonealDialysis", MAXLEN = 7, SELECTIVITY = "33.3333%", VALUELIST = ",H,P") [ SqlColumnNumber = 4, SqlFieldName = BPCVS_SubType ];

Storage CacheStorage
{
<Data name="DHCBPCVisitStatusClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCVisitStatusDefaultData">
<Value name="1">
<Value>BPCVSCode</Value>
</Value>
<Value name="2">
<Value>BPCVSDesc</Value>
</Value>
<Value name="3">
<Value>BPCVSSubType</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("VisitStatus")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("VisitStatus")</IdLocation>
<IndexLocation>^DHCBPC("VisitStatus")</IndexLocation>
<StreamLocation>^User.DHCBPCVisitStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
