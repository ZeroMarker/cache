/// 医生指标定义表
/// DHCWL_DocQuery.DHCWLDocKpiDef   d ##class(DHCWL.DocQuery.DocKpiCFG).%BuildIndices()
Class DHCWL.DocQuery.DocKpiDef Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLDocKpiDef ]
{

/// 医生指标代码
Property MDocKPIDefCode As %String [ SqlColumnNumber = 2, SqlFieldName = MDocKPIDef_Code ];

/// 医生指标描述 
Property MDocKPIDefDesc As %String [ SqlColumnNumber = 3, SqlFieldName = MDocKPIDef_Desc ];

Property MDocKPIDefType As %String [ SqlColumnNumber = 4, SqlFieldName = MDocKPIDef_Type ];

/// 医生指标类型(1:门诊,2:住院)
/// 创建日期
Property MDocKPIUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MDocKPI_UpdateDate ];

/// 指标分类(1:门诊,2:住院)
Property MDocKPIDefClass As %String [ SqlColumnNumber = 6, SqlFieldName = MDocKPIDef_Class ];

/// 医生指标类别(计算类指标，普通指标)
Property MDocKPIDefCategory As %String [ SqlColumnNumber = 7, SqlFieldName = MDocKPIDef_Category ];

Index MDocKPIDefCode On MDocKPIDefCode As AlphaUp;

Index MDocKPIDefClass On MDocKPIDefClass;

Index MDocKPIDefCategory On MDocKPIDefCategory;

Storage Default
{
<Data name="DocKpiDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MDocKPIDefCode</Value>
</Value>
<Value name="3">
<Value>MDocKPIDefDesc</Value>
</Value>
<Value name="4">
<Value>MDocKPIDefType</Value>
</Value>
<Value name="5">
<Value>MDocKPIDefRemark</Value>
</Value>
<Value name="6">
<Value>MDocKPIUpdateDate</Value>
</Value>
<Value name="7">
<Value>MDocKPIDefClass</Value>
</Value>
<Value name="8">
<Value>MDocKPIDefCategory</Value>
</Value>
<Value name="9">
<Value>MDocKPIDefYesOrNo</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DocQuery.DocKpiDefD</DataLocation>
<DefaultData>DocKpiDefDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.DocQuery.DocKpiDefD</IdLocation>
<IndexLocation>^DHCWL.DocQuery.DocKpiDefI</IndexLocation>
<StreamLocation>^DHCWL.DocQuery.DocKpiDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
