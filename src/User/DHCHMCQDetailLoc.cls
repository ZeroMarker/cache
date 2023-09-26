Class User.DHCHMCQDetailLoc Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQDetailLoc ]
{

Parameter ClassName = "User.DHCHMCQDetailLoc";

Relationship CQDLParRef As User.DHCHMCQuestionsDetail [ Cardinality = parent, Inverse = QDLoc ];

Property CQDLLocDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = CQDL_Loc_DR ];

Index IndexLoc On (CQDLParRef, CQDLLocDR) [ Unique ];

Storage Default
{
<Data name="DHCHMCQDetailLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CQDLLocDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCQDetailLocD</DataLocation>
<DefaultData>DHCHMCQDetailLocDefaultData</DefaultData>
<IdLocation>^User.DHCHMCQDetailLocD</IdLocation>
<IndexLocation>^User.DHCHMCQDetailLocI</IndexLocation>
<StreamLocation>^User.DHCHMCQDetailLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
