Class User.MRCDiagFavItem Extends %Persistent [ SqlTableName = MRC_DiagFavItem ]
{

Index IndexItem On (CatDR, ICDDR, Note, Prefix, SDSInfo) [ Unique ];

Index IndexSequece On (CatDR, Sequece) [ Unique ];

/// 指向子类
Property CatDR As MRCDiagFavCat [ Required, SqlColumnNumber = 2, SqlFieldName = CatDR ];

/// 指向MRC_ICDDx
Property ICDDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = ICDDR ];

/// 诊断备注
Property Note As %String [ SqlColumnNumber = 4, SqlFieldName = Note ];

/// 诊断类型
Property Type As %String [ SqlColumnNumber = 5, SqlFieldName = Type ];

/// 显示顺序
Property Sequece As %Integer [ SqlColumnNumber = 6, SqlFieldName = Sequece ];

/// 增加用户
Property UserAddDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = UserAddDR ];

/// 诊断前缀
Property Prefix As %String [ SqlColumnNumber = 8, SqlFieldName = Prefix ];

/// 结构化诊断信息
Property SDSInfo As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = SDSInfo ];

Storage Default
{
<Data name="MRCDiagFavItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CatDR</Value>
</Value>
<Value name="3">
<Value>ICDDR</Value>
</Value>
<Value name="4">
<Value>Note</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Sequece</Value>
</Value>
<Value name="7">
<Value>UserAddDR</Value>
</Value>
<Value name="8">
<Value>Prefix</Value>
</Value>
<Value name="9">
<Value>SDSInfo</Value>
</Value>
</Data>
<DataLocation>^User.MRCDiagFavItemD</DataLocation>
<DefaultData>MRCDiagFavItemDefaultData</DefaultData>
<IdLocation>^User.MRCDiagFavItemD</IdLocation>
<IndexLocation>^User.MRCDiagFavItemI</IndexLocation>
<StreamLocation>^User.MRCDiagFavItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
