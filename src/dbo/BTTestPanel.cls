Class dbo.BTTestPanel Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestPanel, StorageStrategy = Default ]
{

/// Foreign Key FKTestPanelHospital created via DDL
ForeignKey FKTestPanelHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TestPanelHospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTTestPanel On RowID [ PrimaryKey, SqlName = PK_BT_TestPanel, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 行数  
Property RowSum As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 5 ];

/// 列数  
Property ColSum As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 6 ];

/// 归属医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="RPMixPanelDefaultData">
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
<Value>RowSum</Value>
</Value>
<Value name="5">
<Value>ColSum</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestPanelD</DataLocation>
<DefaultData>RPMixPanelDefaultData</DefaultData>
<IdLocation>^dbo.BTTestPanelD</IdLocation>
<IndexLocation>^dbo.BTTestPanelI</IndexLocation>
<StreamLocation>^dbo.BTTestPanelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
