Class User.DHCHMCSCQLink Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CSCQLink ]
{

Parameter ClassName = "User.DHCHMCSCQLink";

Relationship SCQLParRef As User.DHCHMCServiceClass [ Cardinality = parent, Inverse = DHCHMCSCQLink ];

/// 4	SCQL_CQuestionnaire_DR	问卷评估内容
Property SCQLCQuestionnaireDR As User.DHCHMCQuestionnaire;

/// QEDL_Order	顺序	Number
Property SCQLOrder As %Integer;

/// SC_Remark	备注	Text
Property SCQLRemark As %String(MAXLEN = 200);

Index SCQLOrderIndex On (SCQLParRef, SCQLOrder);

Index SCQLQDRIndex On (SCQLParRef, SCQLCQuestionnaireDR) [ Unique ];

Storage Default
{
<Data name="DHCHMCSCQLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DHCHMCQuestionnaire</Value>
</Value>
<Value name="3">
<Value>QEDLOrder</Value>
</Value>
<Value name="4">
<Value>SCRemark</Value>
</Value>
<Value name="5">
<Value>SCQLCQuestionnaireDR</Value>
</Value>
<Value name="6">
<Value>SCQLOrder</Value>
</Value>
<Value name="7">
<Value>SCQLRemark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DHCHMCSCQLink")</DataLocation>
<DefaultData>DHCHMCSCQLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCServiceClassC("DHCHMCSCQLink")</IdLocation>
<IndexLocation>^User.DHCHMCSCQLinkI</IndexLocation>
<StreamLocation>^User.DHCHMCSCQLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
