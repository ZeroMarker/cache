Class User.DHCDocOrdBloodSugarGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocOrdBloodSugarGroup, StorageStrategy = NewStorage1 ]
{

Index LabOrdArcimDr On (LabOrdHospDr, LabOrdArcimDr);

Index LabOrdBloodSugarGroupDr On (LabOrdHospDr, LabOrdBloodSugarGroupDr);

Property LabOrdArcimDr As User.ARCItmMast [ SqlColumnNumber = 2 ];

Property LabOrdBloodSugarGroupDr As User.DHCDocLabBloodSugarGroup [ SqlColumnNumber = 3 ];

Property LabOrdHospDr As User.CTHospital [ SqlColumnNumber = 4 ];

Storage NewStorage1
{
<Data name="DHCDocOrdBloodSugarGroupDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Node1">
<Value name="1">
<Value>LabOrdArcimDr</Value>
</Value>
<Value name="2">
<Value>LabOrdBloodSugarGroupDr</Value>
</Value>
<Value name="3">
<Value>LabOrdHospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocOrdBloodSugarGroupD</DataLocation>
<DefaultData>DHCDocOrdBloodSugarGroupDefaultData</DefaultData>
<IdLocation>^User.DHCDocOrdBloodSugarGroupD</IdLocation>
<IndexLocation>^User.DHCDocOrdBloodSugarGroupI</IndexLocation>
<StreamLocation>^User.DHCDocOrdBloodSugarGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
