/// 病区
Class dbo.BTWard Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Ward, StorageStrategy = Default ]
{

/// Foreign Key FKWardLocation created via DDL
ForeignKey FKWardLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_WardLocation ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexHISCode On HISCode [ SqlName = Index_HISCode, Type = index ];

Index IndexLocation On LocationDR [ SqlName = Index_Location, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTWARD On RowID [ PrimaryKey, SqlName = PK_BT_WARD, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 4 ];

/// HIS对照码  
Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 临床科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

///       
Property PhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTWardDefaultData">
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
<Value>HISCode</Value>
</Value>
<Value name="5">
<Value>LocationDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>PhoneNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWardD</DataLocation>
<DefaultData>BTWardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTWardD</IdLocation>
<IndexLocation>^dbo.BTWardI</IndexLocation>
<StreamLocation>^dbo.BTWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
