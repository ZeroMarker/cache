/// Function:基础数据平台-排序表
/// Creator: 陈莹
/// CreateDate:2016-4-7
Class User.BDPSort Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_Sort ]
{

/// 表名称
Property TableName As %String(MAXLEN = "") [ Required ];

/// 对应表数据RowId
Property DataReference As %String(MAXLEN = "") [ Required ];

/// 排序类型
Property SortType As %String(MAXLEN = "") [ Required ];

/// 顺序号
Property SortNum As %String(MAXLEN = "") [ Required ];

Index TableTypeIdx On (TableName As Exact, SortType As Exact);

Index ReferenceIdx On (TableName As Exact, SortType As Exact, DataReference As Exact);

Index SortNumIdx On (TableName As Exact, SortType As Exact, SortNum As Exact);

Storage Default
{
<Data name="BDPSortDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>DataReference</Value>
</Value>
<Value name="4">
<Value>SortType</Value>
</Value>
<Value name="5">
<Value>SortNum</Value>
</Value>
</Data>
<DataLocation>^User.BDPSortD</DataLocation>
<DefaultData>BDPSortDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPSortD</IdLocation>
<IndexLocation>^User.BDPSortI</IndexLocation>
<StreamLocation>^User.BDPSortS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
