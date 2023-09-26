Class User.DHCHMCSDLink Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CSDLink ]
{

Parameter ClassName = "User.DHCHMCSDLink";

Relationship SDLParRef As User.DHCHMCQuestionSubject [ Cardinality = parent, Inverse = QSDLink ];

Property SDLQuestionsDetailDR As User.DHCHMCQuestionsDetail;

Property SDLOrder As %Integer [ SqlFieldName = SDL_Order ];

Property SDLActive As %String [ SqlFieldName = SDL_Active ];

Property SDLNote As %String [ SqlFieldName = SDL_Note ];

Index SDLOrderIndex On (SDLParRef, SDLOrder);

Index SDLDetailIndex On SDLQuestionsDetailDR;

Storage Default
{
<Data name="DHCHMCSDLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDLActive</Value>
</Value>
<Value name="3">
<Value>SDLNote</Value>
</Value>
<Value name="4">
<Value>SDLOrder</Value>
</Value>
<Value name="5">
<Value>SDLQuestionsDetailDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QSDLink")</DataLocation>
<DefaultData>DHCHMCSDLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQuestionSubjectC("QSDLink")</IdLocation>
<IndexLocation>^User.DHCHMCSDLinkI</IndexLocation>
<StreamLocation>^User.DHCHMCSDLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
