/// creator:xbl
/// createdate:20170829
/// description:排班记录行
Class DHCNMG.Arg.MgArrangeRow Extends %Persistent
{

/// 排班记录
Property ArrangeDR As DHCNMG.Arg.MgArrange [ SqlColumnNumber = 2, SqlFieldName = Arrange_DR ];

/// 人员
Property ArgPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 3, SqlFieldName = Arg_PerDR ];

/// 显示顺序
Property ArgPerSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = Arg_PerSort ];

/// 工作分配
Property ArgWorkRemark As %String [ SqlColumnNumber = 5, SqlFieldName = Arg_WorkRemark ];

/// 符号标记
Property ArgSymbol As %String [ SqlColumnNumber = 6, SqlFieldName = Arg_Symbol ];

/// 人员分组
Property ArgGroupDR As DHCNMG.Arg.MgArrangeGroup [ SqlColumnNumber = 7, SqlFieldName = Arg_GroupDR ];

/// 人员标记 Y: 护士长添加 N:调科记录读取
Property ArgPerAddFlag As %String [ SqlColumnNumber = 8, SqlFieldName = Arg_PerFlag ];

/// 人员岗位
Property ArgPerCode As %String [ SqlColumnNumber = 9, SqlFieldName = Arg_PerCode ];

/// 人员分管床位【粤北人民要手动输入】
Property ArgPerBeds As %String [ SqlColumnNumber = 10, SqlFieldName = Arg_PerBeds ];

Index ArgPerson On (ArrangeDR, ArgPerDR);

Index ArgSort On (ArrangeDR, ArgPerSort);

Index ArgGrp On (ArrangeDR, ArgGroupDR);

Index Arrange On ArrangeDR;

Storage Default
{
<Data name="MgArrangeRowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeDR</Value>
</Value>
<Value name="3">
<Value>ArgPerDR</Value>
</Value>
<Value name="4">
<Value>ArgPerSort</Value>
</Value>
<Value name="5">
<Value>ArgWorkRemark</Value>
</Value>
<Value name="6">
<Value>ArgSymbol</Value>
</Value>
<Value name="7">
<Value>ArgGroupDR</Value>
</Value>
<Value name="8">
<Value>ArgPerAddFlag</Value>
</Value>
<Value name="9">
<Value>ArgPerCode</Value>
</Value>
<Value name="10">
<Value>ArgPerBeds</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArrangeRowD</DataLocation>
<DefaultData>MgArrangeRowDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgArrangeRowD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArrangeRowI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArrangeRowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
