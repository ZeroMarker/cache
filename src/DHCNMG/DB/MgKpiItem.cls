/// Creator:wangpf
/// Descriptions:Kpi项目维护
/// Date:2019-09-04
/// 
Class DHCNMG.DB.MgKpiItem Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgKpiItemSub [ Cardinality = children, Inverse = Parref ];

/// 项目代码
Property KpiCode As %String [ SqlColumnNumber = 2, SqlFieldName = Kpi_Code ];

/// 项目名称
Property KpiDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Kpi_Desc ];

/// 项目所属组别
Property KpiGroup As DHCNMG.DB.MgKpiGroup [ SqlColumnNumber = 4, SqlFieldName = Kpi_Group ];

/// 项目类型
/// Property KpiType As %String(DISPLAYLIST = ",ALL,LOC,WARD", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",A,L,W") [ SqlColumnNumber = 4, SqlFieldName = Kpi_Type ];
/// 关联科室
/// Property KpiLocDR As list Of DHCNMG.DB.MgWardLoc [ SqlColumnNumber = 5, SqlFieldName = Kpi_LocDR ];
/// 关联病区
/// Property KpiWardDR As list Of DHCNMG.DB.MgWard [ SqlColumnNumber = 6, SqlFieldName = Kpi_WardDR ];
/// 分值
Property KpiScore As %String [ InitialExpression = 0, SqlColumnNumber = 5, SqlFieldName = Kpi_Score ];

Index group On KpiGroup;

Storage Default
{
<Data name="MgKpiItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KpiCode</Value>
</Value>
<Value name="3">
<Value>KpiDesc</Value>
</Value>
<Value name="4">
<Value>KpiGroup</Value>
</Value>
<Value name="5">
<Value>KpiScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgKpiItemD</DataLocation>
<DefaultData>MgKpiItemDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgKpiItemD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgKpiItemI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgKpiItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
