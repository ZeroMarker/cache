/// creator:xbl
/// createdate:20170831
/// description:岗位分组
Class DHCNMG.DB.MgWardPostGroup Extends %Persistent
{

/// 科室
Property WardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Ward_DR ];

/// 组代码
Property GroupCode As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Code ];

/// 组描述
Property GroupDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Desc ];

/// 班次列表
Property GroupPosts As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Group_Posts ];

/// 启用状态
Property GroupStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Group_Status ];

Index Ward On WardDR;

Storage Default
{
<Data name="MgWardPostGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>GroupCode</Value>
</Value>
<Value name="4">
<Value>GroupDesc</Value>
</Value>
<Value name="5">
<Value>GroupPosts</Value>
</Value>
<Value name="6">
<Value>GroupStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgWardPostGroupD</DataLocation>
<DefaultData>MgWardPostGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgWardPostGroupD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgWardPostGroupI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgWardPostGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
