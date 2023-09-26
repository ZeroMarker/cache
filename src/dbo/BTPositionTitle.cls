/// BTPositionTitle
Class dbo.BTPositionTitle Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_PositionTitle, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTPOSITIONTITLE On RowID [ PrimaryKey, SqlName = PK_BT_POSITIONTITLE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 申请最大血量  
Property Volumn As %Library.Float [ SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 是否激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 是否可以登记血型
Property RegBloodGroup As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 医师级别
Property PositionLevel As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTPositionTitleDefaultData">
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
<Value>Volumn</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>RegBloodGroup</Value>
</Value>
<Value name="8">
<Value>PositionLevel</Value>
</Value>
</Data>
<DataLocation>^dbo.BTPositionTitleD</DataLocation>
<DefaultData>BTPositionTitleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTPositionTitleD</IdLocation>
<IndexLocation>^dbo.BTPositionTitleI</IndexLocation>
<StreamLocation>^dbo.BTPositionTitleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
