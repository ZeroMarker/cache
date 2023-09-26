///     
Class dbo.BBReactionNature Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReactionNature, StorageStrategy = Default ]
{

/// Foreign Key FKBBREACTTYPE created via DDL
ForeignKey FKBBREACTTYPE(NatureTypeDR) References dbo.BBReactionNatureType(PKBBREACTIONNATURETYPE) [ SqlName = FK_BB_REACT_TYPE ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexNatureType On NatureTypeDR [ SqlName = Index_NatureType, Type = index ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREACTIONNATURE On RowID [ PrimaryKey, SqlName = PK_BB_REACTIONNATURE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2 ];

Property NatureTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBReactionNatureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>NatureTypeDR</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>CName</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReactionNatureD</DataLocation>
<DefaultData>BBReactionNatureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBReactionNatureD</IdLocation>
<IndexLocation>^dbo.BBReactionNatureI</IndexLocation>
<StreamLocation>^dbo.BBReactionNatureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
