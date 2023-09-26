/// 数据项分类
Class CT.AN.DataCategory Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DataCategory ]
{

/// 数据项分类代码
Property Code As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 2 ];

/// 数据项分类名称
Property Description As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

/// 主分类
Property MainCategory As CT.AN.DataCategory [ SqlColumnNumber = 4 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7 ];

/// 数据项分类代码唯一索引
Index ICode On Code [ Unique ];

/// 主分类索引
Index IMainCategory On MainCategory;

Storage Default
{
<Data name="DataCategoryDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>MainCategory</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DataCategoryD</DataLocation>
<DefaultData>DataCategoryDefaultData</DefaultData>
<IdLocation>^CT.AN.DataCategoryD</IdLocation>
<IndexLocation>^CT.AN.DataCategoryI</IndexLocation>
<StreamLocation>^CT.AN.DataCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
