Class DHCNMG.HR.MgNurNormativeGroup Extends %Persistent
{

Relationship GroupParref As DHCNMG.HR.MgNurNormalTrans [ Cardinality = parent, Inverse = GroupSub ];

/// 代码
Property GroupCode As %String [ SqlColumnNumber = 2, SqlFieldName = Group_Code ];

/// 描述
Property GroupDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Desc ];

/// 组长
Property GroupMaster As DHCNMG.HR.MgPersons [ SqlColumnNumber = 4, SqlFieldName = Group_Master ];

/// 组员
Property GroupMember As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Group_Member ];

/// 显示顺序
Property RowSort As %Integer [ SqlColumnNumber = 6, SqlFieldName = Row_Sort ];

Index Sort On (GroupParref, RowSort);

Storage Default
{
<Data name="MgNurNormativeGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupCode</Value>
</Value>
<Value name="3">
<Value>GroupDesc</Value>
</Value>
<Value name="4">
<Value>GroupMaster</Value>
</Value>
<Value name="5">
<Value>GroupMember</Value>
</Value>
<Value name="6">
<Value>RowSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgNurNormativeGroupD</DataLocation>
<DefaultData>MgNurNormativeGroupDefaultData</DefaultData>
<IdLocation>{%%PARENT}("GroupSub")</IdLocation>
<IndexLocation>^DHCNMG.HR.MgNurNormativeGroupI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgNurNormativeGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
