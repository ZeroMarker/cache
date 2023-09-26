/// 细菌组
Class dbo.BTOrganismGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrganismGroup, StorageStrategy = Default ]
{

/// Foreign Key FKOrganismFamily created via DDL
ForeignKey FKOrganismFamily(OrganismFamilyDR) References dbo.BTOrganismFamily(PKBTORGANISMFAMILY) [ SqlName = FK_OrganismFamily ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTORGANISMGROUP On RowID [ PrimaryKey, SqlName = PK_BT_ORGANISMGROUP, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 编码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 菌科  
Property OrganismFamilyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTOrganismGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>OrganismFamilyDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrganismGroupD</DataLocation>
<DefaultData>BTOrganismGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTOrganismGroupD</IdLocation>
<IndexLocation>^dbo.BTOrganismGroupI</IndexLocation>
<StreamLocation>^dbo.BTOrganismGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
