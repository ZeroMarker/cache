Class User.ARCOrdFavSubCat Extends %Persistent [ SqlTableName = ARC_OrdFavSubCat ]
{

Index IndexName On (CatDR, Name) [ Unique ];

Index IndexSequece On (CatDR, Sequece) [ Unique ];

/// 指向大类
Property CatDR As ARCOrdFavCat [ Required, SqlColumnNumber = 2, SqlFieldName = CatDR ];

/// 子类名称
Property Name As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Name ];

/// 显示顺序
Property Sequece As %Integer [ SqlColumnNumber = 4, SqlFieldName = Sequece ];

/// 增加用户
Property UserAddDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = UserAddDR ];

Storage Default
{
<Data name="ARCOrdFavSubCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CatDR</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Sequece</Value>
</Value>
<Value name="5">
<Value>UserAddDR</Value>
</Value>
</Data>
<DataLocation>^User.ARCOrdFavSubCatD</DataLocation>
<DefaultData>ARCOrdFavSubCatDefaultData</DefaultData>
<IdLocation>^User.ARCOrdFavSubCatD</IdLocation>
<IndexLocation>^User.ARCOrdFavSubCatI</IndexLocation>
<StreamLocation>^User.ARCOrdFavSubCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
