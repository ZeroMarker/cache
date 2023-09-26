Class User.DHCCITypeDefine Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_CITypeDefine ]
{

Property CTDActiveFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 4, SqlFieldName = CTD_ActiveFlag ];

Property CTDCode As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTD_Code ];

Property CTDDateFrom As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = CTD_DateFrom ];

Property CTDDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CTD_DateTo ];

Property CTDDesc As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTD_Desc ];

Property CTDInstruction As %String(TRUNCATE = 1) [ SqlFieldName = CTD_Instruction ];

Relationship OrdRule As User.DHCCITypeDefineOrderRule [ Cardinality = children, Inverse = TORCTDParRef ];

Index CTDCodeIndex On (CTDCode, CTDInstruction) [ Unique ];

Storage Default
{
<Data name="DHCCITypeDefineClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCITypeDefineDefaultData">
<Value name="1">
<Value>CTDCode</Value>
</Value>
<Value name="2">
<Value>CTDDesc</Value>
</Value>
<Value name="3">
<Value>CTDActiveFlag</Value>
</Value>
<Value name="4">
<Value>CTDDateFrom</Value>
</Value>
<Value name="5">
<Value>CTDDateTo</Value>
</Value>
<Value name="6">
<Value>CTDInstruction</Value>
</Value>
</Data>
<DataLocation>^User.DHCCITypeDefineD</DataLocation>
<DefaultData>DHCCITypeDefineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCITypeDefineD</IdLocation>
<IndexLocation>^User.DHCCITypeDefineI</IndexLocation>
<StreamLocation>^User.DHCCITypeDefineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
