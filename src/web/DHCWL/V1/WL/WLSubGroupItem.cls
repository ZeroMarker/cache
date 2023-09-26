/// 医技工作量明细表格
Class web.DHCWL.V1.WL.WLSubGroupItem Extends %Persistent [ ClassType = persistent ]
{

/// 关联分类子组
Property SGrpIMSGrpDr As web.DHCWL.V1.WL.WLSubGroup [ Required, SqlColumnNumber = 2 ];

/// 明细项目ID
Property SGrpIMItemID As %String [ Required, SqlColumnNumber = 3 ];

/// 明细项目CODE
Property SGrpIMItemCode As %String [ SqlColumnNumber = 4 ];

/// 排序
Property SGrpIMSort As %Integer [ SqlColumnNumber = 5 ];

/// 住院口径
Property IItem As web.DHCWL.V1.WL.WLDataType [ SqlColumnNumber = 6 ];

/// 门诊口径
Property OItem As web.DHCWL.V1.WL.WLDataType [ SqlColumnNumber = 7 ];

/// 急诊口径
Property EItem As web.DHCWL.V1.WL.WLDataType [ SqlColumnNumber = 8 ];

/// 体检口径
Property HItem As web.DHCWL.V1.WL.WLDataType [ SqlColumnNumber = 9 ];

Index SGrpIM On (SGrpIMSGrpDr, SGrpIMItemID);

Index SGrpSort On (SGrpIMSGrpDr, SGrpIMSort, SGrpIMItemID);

Storage Default
{
<Data name="WLSubGroupItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SGrpIMSGrpDr</Value>
</Value>
<Value name="3">
<Value>SGrpIMItemID</Value>
</Value>
<Value name="4">
<Value>SGrpIMItemCode</Value>
</Value>
<Value name="5">
<Value>SGrpIMSort</Value>
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
<DataLocation>^web.DHCWL.V598C.WLSubGroupItemD</DataLocation>
<DefaultData>WLSubGroupItemDefaultData</DefaultData>
<IdLocation>^web.DHCWL.V598C.WLSubGroupItemD</IdLocation>
<IndexLocation>^web.DHCWL.V598C.WLSubGroupItemI</IndexLocation>
<StreamLocation>^web.DHCWL.V598C.WLSubGroupItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
