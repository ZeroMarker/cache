/// creator: xbl
/// createdate: 20170901
/// description: 人员分组
Class DHCINM.Arg.MgArrangeGroup Extends %Persistent
{

/// 排班记录
Property ArrangeDR As DHCINM.Arg.MgArrange [ SqlColumnNumber = 2, SqlFieldName = Arrange_DR ];

/// 组代码
Property GroupCode As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Code ];

/// 组描述
Property GroupDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Desc ];

/// 组长
Property GroupMaster As CF.DHCINM.HR.Persons [ SqlColumnNumber = 5, SqlFieldName = Group_Master ];

/// 负责床位
Property GroupResBeds As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Group_ResBeds ];

/// 说明
Property GroupRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Group_Remark ];

/// 关联HIS床位分组
Property GroupBedGroup As %String [ SqlColumnNumber = 8, SqlFieldName = Group_BedGroup ];

Index Arrange On ArrangeDR;

Index ArgCode On (ArrangeDR, GroupCode);

Storage Default
{
<Data name="MgArrangeGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeDR</Value>
</Value>
<Value name="3">
<Value>GroupCode</Value>
</Value>
<Value name="4">
<Value>GroupDesc</Value>
</Value>
<Value name="5">
<Value>GroupMaster</Value>
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
</Data>
<DataLocation>^DHCINM.Arg.MgArrangeGroupD</DataLocation>
<DefaultData>MgArrangeGroupDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgArrangeGroupD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgArrangeGroupI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgArrangeGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
