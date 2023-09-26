Class User.ARCOrdFavItem Extends %Persistent [ SqlTableName = ARC_OrdFavItem ]
{

Index IndexItem On (SubCatDR, ItemID, PartInfo) [ Unique ];

Index IndexSequece On (SubCatDR, Sequece) [ Unique ];

/// 指向子类
Property SubCatDR As ARCOrdFavSubCat [ Required, SqlColumnNumber = 2, SqlFieldName = SubCatDR ];

/// 项目ID(医嘱或医嘱套ID)
Property ItemID As %String [ Required, SqlColumnNumber = 3, SqlFieldName = ItemID ];

/// 显示顺序
Property Sequece As %Integer [ SqlColumnNumber = 4, SqlFieldName = Sequece ];

/// 增加用户
Property UserAddDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = UserAddDR ];

/// 项目备注
Property Note As %String [ SqlColumnNumber = 6, SqlFieldName = Note ];

/// 检查部位信息
Property PartInfo As %String [ SqlColumnNumber = 7, SqlFieldName = PartInfo ];

Storage Default
{
<Data name="ARCOrdFavItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubCatDR</Value>
</Value>
<Value name="3">
<Value>ItemID</Value>
</Value>
<Value name="4">
<Value>Sequece</Value>
</Value>
<Value name="5">
<Value>UserAddDR</Value>
</Value>
<Value name="6">
<Value>Note</Value>
</Value>
<Value name="7">
<Value>PartInfo</Value>
</Value>
</Data>
<DataLocation>^User.ARCOrdFavItemD</DataLocation>
<DefaultData>ARCOrdFavItemDefaultData</DefaultData>
<IdLocation>^User.ARCOrdFavItemD</IdLocation>
<IndexLocation>^User.ARCOrdFavItemI</IndexLocation>
<StreamLocation>^User.ARCOrdFavItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
