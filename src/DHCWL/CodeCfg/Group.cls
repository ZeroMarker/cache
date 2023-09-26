/// 分组维护
Class DHCWL.CodeCfg.Group Extends (%Persistent, DHCWL.ABSCodeCFG) [ ClassType = persistent, SqlTableName = DHCWLCodeCfgGroup ]
{

/// 代码
Property GrpCode As %String [ SqlColumnNumber = 2, SqlFieldName = Grp_Code ];

/// 描述
Property GrpDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Grp_Desc ];

/// 关联配置类型表
Property GrpTypeDr As DHCWL.CodeCfg.Type [ SqlColumnNumber = 4, SqlFieldName = Grp_Type_Dr ];

/// 创建日期
Property GrpCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Grp_CreateDate ];

/// 创建时间
Property GrpCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = Grp_CreateTime ];

/// 创建人
Property GrpCreateUse As %String [ SqlColumnNumber = 7, SqlFieldName = Grp_CreateUse ];

/// 关联纬度
Property GrpDimDr As DHCWL.MKPI.MKPIDimType [ SqlColumnNumber = 8, SqlFieldName = Grp_Dim_Dr ];

Index TypeDr On GrpTypeDr;

Index Code On GrpCode;

Index DimDr On GrpDimDr;

/// DHCWL_CodeCfg.DHCWLCodeCfgGroup    d ##class(DHCWL.CodeCfg.Group).%BuildIndices()
Method test(a As %String) As %Status
{
 s obj=##class(DHCWL.CodeCfg.SubGroupItem).%New()
 s obj.SGrpIMSGrpDr=1
 q 1
}

Storage Default
{
<Data name="GroupDefaultData">
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
<Value>GrpTypeCreateDate</Value>
</Value>
<Value name="5">
<Value>GrpTypeCreateTime</Value>
</Value>
<Value name="6">
<Value>GrpTypeCreateUse</Value>
</Value>
<Value name="7">
<Value>GrpTypeDr</Value>
</Value>
<Value name="8">
<Value>GrpCreateDate</Value>
</Value>
<Value name="9">
<Value>GrpCreateTime</Value>
</Value>
<Value name="10">
<Value>GrpCreateUse</Value>
</Value>
<Value name="11">
<Value>GrpDimDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.GroupD</DataLocation>
<DefaultData>GroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.GroupD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.GroupI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.GroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
