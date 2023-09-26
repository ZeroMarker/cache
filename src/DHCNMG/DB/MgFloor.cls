/// creator: xbl
/// createdate: 20170825
/// description: 楼层设置
Class DHCNMG.DB.MgFloor Extends %Persistent
{

/// 代码
Property FloorCode As %String [ SqlColumnNumber = 2, SqlFieldName = Floor_Code ];

/// 描述
Property FloorDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Floor_Desc ];

/// 简称
Property FloorShort As %String [ SqlColumnNumber = 4, SqlFieldName = Floor_Short ];

/// 备注
Property FloorRemark As %String [ SqlColumnNumber = 5, SqlFieldName = Floor_Remark ];

/// 启用状态
Property FloorStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Floor_Status ];

/// 病区
Property FloorWards As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Floor_Wards ];

Index Code On FloorCode;

Storage Default
{
<Data name="MgFloorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FloorCode</Value>
</Value>
<Value name="3">
<Value>FloorDesc</Value>
</Value>
<Value name="4">
<Value>FloorShort</Value>
</Value>
<Value name="5">
<Value>FloorRemark</Value>
</Value>
<Value name="6">
<Value>FloorStatus</Value>
</Value>
<Value name="7">
<Value>FloorWards</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgFloorD</DataLocation>
<DefaultData>MgFloorDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgFloorD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgFloorI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgFloorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
