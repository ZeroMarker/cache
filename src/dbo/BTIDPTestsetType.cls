/// 鉴定医嘱类型
Class dbo.BTIDPTestsetType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_TestsetType ]
{

Index IndexMaster On TestSetDR [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKTestSetConclusionTS created via DDL
ForeignKey FKIDPTestsetTypeTS(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_IDPTestsetTypeTS ];

/// DDL Primary Key Specification
Index PKBTIDPTESTSETTYPE On RowID [ PrimaryKey, SqlName = PK_BTIDP_TESTSETTYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 类型  Type M:主医嘱 C：费用医嘱，相同小组有主医嘱时候不渲染费用医嘱项目
Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTIDPTestsetTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPTestsetTypeD</DataLocation>
<DefaultData>BTIDPTestsetTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPTestsetTypeD</IdLocation>
<IndexLocation>^dbo.BTIDPTestsetTypeI</IndexLocation>
<StreamLocation>^dbo.BTIDPTestsetTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
