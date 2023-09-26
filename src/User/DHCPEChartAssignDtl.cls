/// 科室体检医生站点权限
Class User.DHCPEChartAssignDtl Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ChartAssignDtl ]
{

Parameter ClassName = "User.DHCPEChartAssignDtl";

Relationship ParRef As User.DHCPEChartAssign [ Cardinality = parent, Inverse = ChildDtl ];

/// 站点
Property CADStationDR As User.DHCPEStation [ Required, SqlFieldName = CAD_StationDR ];

/// 是否可读
Property CADDetail As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CAD_Detail ];

/// 是否可写
Property CADWrite As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CAD_Write ];

/// 是否默认
Property CADDefault As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CAD_Default ];

/// 科室分配
Property CADWriteWay As %String(DISPLAYLIST = ",手动确认,保存结果,科室提交,不确认", TRUNCATE = 1, VALUELIST = ",1,2,3,4") [ SqlFieldName = CAD_WriteWay ];

/// ParRef + 站点 索引
Index IdxOfStation On (ParRef, CADStationDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CADStationDR</Value>
</Value>
<Value name="3">
<Value>CADDetail</Value>
</Value>
<Value name="4">
<Value>CADWrite</Value>
</Value>
<Value name="5">
<Value>CADDefault</Value>
</Value>
<Value name="6">
<Value>CADWriteWay</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DTL")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("DTL")</IdLocation>
<IndexLocation>^CF.PE.ChartAssignI("DTL")</IndexLocation>
<StreamLocation>^User.DHCPEChartAssignDtlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
