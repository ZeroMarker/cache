Class dhc.ca.cache.report.CostResultData Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Projection CostResultData As %Projection.Java(ROOTDIR = "c:\temp");

/// 核算区间
Property CostResultDataintervalName As %Library.String(TRUNCATE = 1);

/// 分摊科室
Property CostResultDatadistedDeptName As %Library.String(TRUNCATE = 1);

/// 接收科室
Property CostResultDatadistDeptName As %Library.String(TRUNCATE = 1);

/// 成本项
Property CostResultDataitemName As %Library.String(TRUNCATE = 1);

/// 成本项类别
Property CostItemTypeName As %Library.String(TRUNCATE = 1);

/// 金额
Property CostResultDatafee As %Library.Float;

/// 分摊标记
Property CostResultDatadistFlag As %Library.String(TRUNCATE = 1);

/// CostResultData_dealFlag
Property CostResultDatadealFlag As %Library.String(TRUNCATE = 1);

/// 分摊套
Property CostDistSetsName As %Library.String(TRUNCATE = 1);

/// 被分摊科室类别
Property distedLocTypeName As %Library.String(TRUNCATE = 1);

/// 接收科室类别
Property distLocTypeName As %Library.String(TRUNCATE = 1);

/// 科室分层套层级
Property levelNum As %Library.Integer;

/// 科室分层套树结构排序
Property sortNum As %Library.Integer;

/// 被分摊科室科室类别排序
Property locTypesortNum As %Library.Integer;

/// 数据类型标记
Property dataTypeFlag As %Library.String(TRUNCATE = 1);

/// 数据分层套树结构排序
Property itemSortNum As %Library.Integer;

/// 数据分层套层级
Property itemLevelNum As %Library.Integer;

/// 成本项类别排序
Property dataTypeSortNum As %Library.Integer;

Storage Default
{
<Data name="CostResultDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CostResultDatadealFlag</Value>
</Value>
<Value name="3">
<Value>CostResultDatadistDeptName</Value>
</Value>
<Value name="4">
<Value>CostResultDatadistFlag</Value>
</Value>
<Value name="5">
<Value>CostResultDatadistedDeptName</Value>
</Value>
<Value name="6">
<Value>CostResultDatafee</Value>
</Value>
<Value name="7">
<Value>CostResultDataintervalName</Value>
</Value>
<Value name="8">
<Value>CostResultDataitemName</Value>
</Value>
<Value name="9">
<Value>CostDistSetsname</Value>
</Value>
<Value name="10">
<Value>CostDistSetsName</Value>
</Value>
<Value name="11">
<Value>distLocTypeName</Value>
</Value>
<Value name="12">
<Value>distedLocTypeName</Value>
</Value>
<Value name="13">
<Value>levelNum</Value>
</Value>
<Value name="14">
<Value>sortNum</Value>
</Value>
<Value name="15">
<Value>locTypesortNum</Value>
</Value>
<Value name="16">
<Value>dataTypeFlag</Value>
</Value>
<Value name="17">
<Value>CostItemTypeName</Value>
</Value>
<Value name="18">
<Value>itemSortNum</Value>
</Value>
<Value name="19">
<Value>itemLevelNum</Value>
</Value>
<Value name="20">
<Value>dataTypeSortNum</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.CostResultDataD</DataLocation>
<DefaultData>CostResultDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.CostResultDataD</IdLocation>
<IndexLocation>^dhc.ca.c.CostResultDataI</IndexLocation>
<StreamLocation>^dhc.ca.c.CostResultDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
