/// 表名：DHCWL_MeasureDimrole.DHCWLDimRole  d ##class(DHCWL.MeasureDimrole.DimRole).%BuildIndices()
/// global:^DHCWL.MeasureDimrole.DimRoleD    ^DHCWL.MeasureDimrole.DimRoleI
/// 维度角色
Class DHCWL.MeasureDimrole.DimRole Extends %Persistent [ SqlTableName = DHCWLDimRole ]
{

/// 编码
Property DimroleCode As %String [ SqlColumnNumber = 2, SqlFieldName = Dimrole_Code ];

/// 描述
Property DimroleDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Dimrole_Desc ];

/// 名称
Property DimroleName As %String [ SqlColumnNumber = 4, SqlFieldName = Dimrole_Name ];

/// 关联维度表
Property DimroleDr As DHCWL.MKPI.MKPIDimType [ SqlColumnNumber = 5, SqlFieldName = Dimrole_Dr ];

/// 创建日期
Property DimroleCreateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Dimrole_CreateDate ];

/// 创建人
Property DimroleCreateUse As %String [ SqlColumnNumber = 7, SqlFieldName = Dimrole_CreateUse ];

/// 是否作废
Property DimroleVoidFlag As %String [ SqlColumnNumber = 8, SqlFieldName = Dimrole_VoidFlag ];

Index DimDr On (DimroleDr, DimroleCode);

Index Code On DimroleCode;

Storage Default
{
<Data name="DimRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimroleCode</Value>
</Value>
<Value name="3">
<Value>DimroleDesc</Value>
</Value>
<Value name="4">
<Value>DimroleName</Value>
</Value>
<Value name="5">
<Value>DimroleDr</Value>
</Value>
<Value name="6">
<Value>DimroleCreateDate</Value>
</Value>
<Value name="7">
<Value>DimroleCreateUse</Value>
</Value>
<Value name="8">
<Value>DimroleVoidFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MeasureDimrole.DimRoleD</DataLocation>
<DefaultData>DimRoleDefaultData</DefaultData>
<IdLocation>^DHCWL.MeasureDimrole.DimRoleD</IdLocation>
<IndexLocation>^DHCWL.MeasureDimrole.DimRoleI</IndexLocation>
<StreamLocation>^DHCWL.MeasureDimrole.DimRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
