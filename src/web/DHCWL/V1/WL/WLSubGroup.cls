/// 医技工作量归集子组
/// web.DHCWL.V1.WL.WLSubGroup
Class web.DHCWL.V1.WL.WLSubGroup Extends %Persistent [ ClassType = persistent ]
{

/// 关联分类大组
Property SGrpGrpDr As web.DHCWL.V1.WL.WLGroup [ Required, SqlColumnNumber = 2 ];

/// 代码
Property SGrpCode As %String [ Required, SqlColumnNumber = 3 ];

/// 描述
Property SGrpDesc As %String [ Required, SqlColumnNumber = 4 ];

/// 排序
Property SGrpSort As %Integer [ Required, SqlColumnNumber = 5 ];

/// 住院口径
Property IItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 6 ];

/// 门诊口径
Property OItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 7 ];

/// 急诊口径
Property EItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 8 ];

/// 体检口径
Property HItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 9 ];

Index GrpDr On SGrpGrpDr;

Index Code On (SGrpGrpDr, SGrpCode);

Index GrpDrSort On (SGrpGrpDr, SGrpSort);

Storage Default
{
<Data name="WLSubGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SGrpGrpDr</Value>
</Value>
<Value name="3">
<Value>SGrpCode</Value>
</Value>
<Value name="4">
<Value>SGrpDesc</Value>
</Value>
<Value name="5">
<Value>SGrpSort</Value>
</Value>
<Value name="6">
<Value>IItem</Value>
</Value>
<Value name="7">
<Value>OItem</Value>
</Value>
<Value name="8">
<Value>EItem</Value>
</Value>
<Value name="9">
<Value>HItem</Value>
</Value>
</Data>
<DataLocation>^web.DHCWL.V1.WL.WLSubGroupD</DataLocation>
<DefaultData>WLSubGroupDefaultData</DefaultData>
<IdLocation>^web.DHCWL.V1.WL.WLSubGroupD</IdLocation>
<IndexLocation>^web.DHCWL.V1.WL.WLSubGroupI</IndexLocation>
<StreamLocation>^web.DHCWL.V1.WL.WLSubGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
