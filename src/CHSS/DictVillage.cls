Class CHSS.DictVillage Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DictVillage ]
{

//Relationship RowIdParref As CHSS.DictStreet [ Cardinality = parent, Inverse = ChildDictVillage, Required, SqlFieldName = RowIdParref ];

/// Parent Reference
/// 编码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Code ];

/// 描述
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Description ];

/// 开始日期
Property StartDate As %Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = StartDate ];

/// 结束日期
Property EndDate As %Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = EndDate ];

/// 有效
Property Active As %Library.String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Active ];

/// 排序
Property Sort As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Sort ];

/// 拼音码
Property SepllCode As %Library.String(MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SepllCode ];

/// 父节点
Property RowIdParref As CHSS.DictStreet [ SqlColumnNumber = 9, SqlFieldName = RowIdParref ];

/// 上级
Property UpCode As %Library.String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = UpCode ];

Index CodeIndex On Code;

Storage Default
{
<Data name="DictVillageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>RowIdParref</Value>
</Value>
<Value name="7">
<Value>SepllCode</Value>
</Value>
<Value name="8">
<Value>Sort</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>UpCode</Value>
</Value>
</Data>
<DataLocation>^CHSS.DictVillageD</DataLocation>
<DefaultData>DictVillageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictVillageD</IdLocation>
<IndexLocation>^CHSS.DictVillageI</IndexLocation>
<StreamLocation>^CHSS.DictVillageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
