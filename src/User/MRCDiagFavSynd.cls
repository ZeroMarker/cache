Class User.MRCDiagFavSynd Extends %Persistent [ SqlTableName = MRC_DiagFavSynd ]
{

Index IndexItem On (ItemDR, SyndromeDR, Note) [ Unique ];

Index IndexSequece On (ItemDR, Sequece) [ Unique ];

/// 指向模板项目
Property ItemDR As MRCDiagFavItem [ Required, SqlColumnNumber = 2, SqlFieldName = ItemDR ];

/// 证型 指向MRC_ICDDx
Property SyndromeDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = SyndromeDR ];

/// 证型备注
Property Note As %String [ SqlColumnNumber = 4, SqlFieldName = Note ];

/// 显示顺序
Property Sequece As %Integer [ SqlColumnNumber = 5, SqlFieldName = Sequece ];

/// 增加用户
Property UserAddDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = UserAddDR ];

Storage Default
{
<Data name="MRCDiagFavSyndDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemDR</Value>
</Value>
<Value name="3">
<Value>SyndromeDR</Value>
</Value>
<Value name="4">
<Value>Note</Value>
</Value>
<Value name="5">
<Value>Sequece</Value>
</Value>
<Value name="6">
<Value>UserAddDR</Value>
</Value>
</Data>
<DataLocation>^User.MRCDiagFavSyndD</DataLocation>
<DefaultData>MRCDiagFavSyndDefaultData</DefaultData>
<IdLocation>^User.MRCDiagFavSyndD</IdLocation>
<IndexLocation>^User.MRCDiagFavSyndI</IndexLocation>
<StreamLocation>^User.MRCDiagFavSyndS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
