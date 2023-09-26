/// Creater:wangpf
/// Descriptions:排班护士分组
/// Date:2020-06-22
Class DHCINM.Arg.MgNurGroup Extends %Persistent
{

/// 病区
Property GroupWardDR As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Group_WardDR ];

/// 描述
Property GroupDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Desc ];

/// 组长
Property GroupMaster As CF.DHCINM.HR.Persons [ SqlColumnNumber = 4, SqlFieldName = Group_Master ];

/// 组员
Property GroupMember As list Of %String [ SqlColumnNumber = 5, SqlFieldName = Group_Member ];

/// 负责床位
Property GroupResBeds As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Group_ResBeds ];

/// 说明
Property GroupRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Group_Remark ];

/// 关联HIS床位分组
Property GroupBedGroup As %String [ SqlColumnNumber = 8, SqlFieldName = Group_BedGroup ];

/// 顺序
Property GroupSort As %Integer [ SqlColumnNumber = 9, SqlFieldName = Group_Sort ];

Index Ward On GroupWardDR;

Index Sort On (GroupWardDR, GroupSort);

Storage Default
{
<Data name="MgNurGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupWardDR</Value>
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
<Value>GroupResBeds</Value>
</Value>
<Value name="7">
<Value>GroupRemark</Value>
</Value>
<Value name="8">
<Value>GroupBedGroup</Value>
</Value>
<Value name="9">
<Value>GroupSort</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgNurGroupD</DataLocation>
<DefaultData>MgNurGroupDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgNurGroupD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgNurGroupI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgNurGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
