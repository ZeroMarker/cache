/// Description:业务类型对应的csp
/// Creator:wangguoying
Class User.DHCPEWorkLinkUrl Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_WorkLinkUrl ]
{

Parameter ClassName = "User.DHCPEWorkLinkUrl";

Relationship WLUParRef As User.DHCPEWorkDistributeType [ Cardinality = parent, Inverse = WDTWUrl ];

/// 标题
Property WLUTitle As %String [ Required, SqlColumnNumber = 2, SqlFieldName = WLU_Title ];

/// CSP地址
Property WLULink As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3, SqlFieldName = WLU_Link ];

/// 排序
Property WLUSort As %Integer [ Required, SqlColumnNumber = 4, SqlFieldName = WLU_Sort ];

Index ParSortIndex On (WLUParRef, WLUSort) [ Unique ];

Storage Default
{
<Data name="DHCPEWorkLinkUrlDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WLUTitle</Value>
</Value>
<Value name="3">
<Value>WLULink</Value>
</Value>
<Value name="4">
<Value>WLUSort</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("WDTWUrl")</DataLocation>
<DefaultData>DHCPEWorkLinkUrlDefaultData</DefaultData>
<IdLocation>^User.DHCPEWorkDistributeTypeC("WDTWUrl")</IdLocation>
<IndexLocation>^User.DHCPEWorkLinkUrlI</IndexLocation>
<StreamLocation>^User.DHCPEWorkLinkUrlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
