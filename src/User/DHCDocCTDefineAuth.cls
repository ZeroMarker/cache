Class User.DHCDocCTDefineAuth Extends %Persistent [ SqlTableName = DHCDoc_CT_DefineAuth ]
{

Index IndexGroupNode On (GroupDR, NodeID);

Index IndexGroup On GroupDR;

Index IndexNode On NodeID;

Property GroupDR As SSGroup [ SqlColumnNumber = 2, SqlFieldName = Group_DR ];

Property NodeID As %String [ SqlColumnNumber = 3, SqlFieldName = NodeID ];

Property HospDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = Hosp_DR ];

Storage Default
{
<Data name="DHCDocCTDefineAuthDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupDR</Value>
</Value>
<Value name="3">
<Value>NodeID</Value>
</Value>
<Value name="4">
<Value>HospDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocCTDefineAuthD</DataLocation>
<DefaultData>DHCDocCTDefineAuthDefaultData</DefaultData>
<IdLocation>^User.DHCDocCTDefineAuthD</IdLocation>
<IndexLocation>^User.DHCDocCTDefineAuthI</IndexLocation>
<StreamLocation>^User.DHCDocCTDefineAuthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
