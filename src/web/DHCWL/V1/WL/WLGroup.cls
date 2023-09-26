/// 医技工作量
/// web_DHCWL_V1_WL.WLGroup
Class web.DHCWL.V1.WL.WLGroup Extends %Persistent [ ClassType = persistent ]
{

/// 代码
Property GrpCode As %String [ Required, SqlColumnNumber = 2 ];

/// 描述
Property GrpDesc As %String [ Required, SqlColumnNumber = 3 ];

/// 关联纬度
Property GrpDimDr As DHCWL.MKPI.MKPIDimType [ Required, SqlColumnNumber = 4 ];

/// 创建日期
Property GrpCreateDate As %Date [ SqlColumnNumber = 5 ];

/// 住院口径
Property IItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 6 ];

/// 门诊口径
Property OItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 7 ];

/// 急诊口径
Property EItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 8 ];

/// 体检口径
Property HItem As web.DHCWL.V1.WL.WLDataType [ Required, SqlColumnNumber = 9 ];

Index Code On GrpCode;

Index DimDr On GrpDimDr;

Storage Default
{
<Data name="WLGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GrpCode</Value>
</Value>
<Value name="3">
<Value>GrpDesc</Value>
</Value>
<Value name="4">
<Value>GrpDimDr</Value>
</Value>
<Value name="5">
<Value>GrpCreateDate</Value>
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
<DataLocation>^web.DHCWL.V1.WL.WLGroupD</DataLocation>
<DefaultData>WLGroupDefaultData</DefaultData>
<IdLocation>^web.DHCWL.V1.WL.WLGroupD</IdLocation>
<IndexLocation>^web.DHCWL.V1.WL.WLGroupI</IndexLocation>
<StreamLocation>^web.DHCWL.V1.WL.WLGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
