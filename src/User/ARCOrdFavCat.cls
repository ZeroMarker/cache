Class User.ARCOrdFavCat Extends %Persistent [ SqlTableName = ARC_OrdFavCat ]
{

Index IndexName On (Type, TypeValue, Name) [ Unique ];

Index IndexSequece On (Type, TypeValue, Sequece) [ Unique ];

/// 类型 科室User.CTLoc,用户 User.SSUser|WNewOrderEntry|O、User.SSUser|WNewOrderEntry|I
Property Type As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Type ];

/// 类型对应的值
Property TypeValue As %String [ Required, SqlColumnNumber = 3, SqlFieldName = TypeValue ];

/// 大类名称
Property Name As %String [ Required, SqlColumnNumber = 4, SqlFieldName = Name ];

/// 显示顺序
Property Sequece As %Integer [ SqlColumnNumber = 5, SqlFieldName = Sequece ];

/// 增加用户
Property UserAddDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = UserAddDR ];

Storage Default
{
<Data name="ARCOrdFavCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>TypeValue</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Sequece</Value>
</Value>
<Value name="6">
<Value>UserAddDR</Value>
</Value>
</Data>
<DataLocation>^User.ARCOrdFavCatD</DataLocation>
<DefaultData>ARCOrdFavCatDefaultData</DefaultData>
<IdLocation>^User.ARCOrdFavCatD</IdLocation>
<IndexLocation>^User.ARCOrdFavCatI</IndexLocation>
<StreamLocation>^User.ARCOrdFavCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
