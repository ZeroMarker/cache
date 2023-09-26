Class User.DHCHMCQDOLinkDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock ]
{

Relationship QDOLParRef As User.DHCHMCQDOptions [ Cardinality = parent, Inverse = QDOChild ];

Property QDOLCSDLinkID As User.DHCHMCSDLink [ Required, SqlFieldName = QDOL_CSDLinkID ];

Index CSDLinkID On QDOLCSDLinkID;

Storage Default
{
<Data name="DHCHMCQDOLinkDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDOLCSDLinkID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QDOChild")</DataLocation>
<DefaultData>DHCHMCQDOLinkDetailDefaultData</DefaultData>
<IdLocation>^User.DHCHMCQDOptionsC("QDOChild")</IdLocation>
<IndexLocation>^User.DHCHMCQDOLinkDetailI</IndexLocation>
<StreamLocation>^User.DHCHMCQDOLinkDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
