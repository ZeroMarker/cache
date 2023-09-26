Class dhc.pa.data.DeptKPIIndex Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DKX_Rowid, SqlTableName = Dept_KPIIndex ]
{

/// 代码
Property code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DKX_code ];

/// 名称
Property name As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DKX_name ];

/// 快捷键
Property shortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DKX_shortcut ];

/// 类别 1-单文本 2-选项 3-多文本
Property type As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DKX_type ];

/// 描述
Property desc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DKX_desc ];

/// 单位
Property calUnitDr As dhc.pa.data.CalUnit [ SqlColumnNumber = 6, SqlFieldName = DKX_calUnitDr ];

/// 层级
Property level As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DKX_level ];

/// 是否为末层
Property isEnd As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DKX_isEnd ];

/// 上级项目
Property parent As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DKX_parent ];

Index parent On parent;

Storage Default
{
<Data name="DeptKPIIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>code</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
<Value name="4">
<Value>shortcut</Value>
</Value>
<Value name="5">
<Value>type</Value>
</Value>
<Value name="6">
<Value>desc</Value>
</Value>
<Value name="7">
<Value>calUnitDr</Value>
</Value>
<Value name="8">
<Value>level</Value>
</Value>
<Value name="9">
<Value>isEnd</Value>
</Value>
<Value name="10">
<Value>parent</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPADeptKPIIndexD</DataLocation>
<DefaultData>DeptKPIIndexDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPADeptKPIIndexD</IdLocation>
<IndexLocation>^DHCCJXPADeptKPIIndexI</IndexLocation>
<StreamLocation>^DHCCJXPADeptKPIIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
