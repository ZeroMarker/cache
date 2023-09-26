/// BTCheckValidAbsolute
Class dbo.BTCheckValidAbsolute Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidAbsolute, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidAbsolute created via DDL
ForeignKey FKCheckValidAbsolute(CheckValidRulesDR) References dbo.BTCheckValidRules(PKBTCHECKVALIDRULES) [ SqlName = FK_CheckValidAbsolute ];

/// Foreign Key FKCheckValidAbsoluteLocation created via DDL
ForeignKey FKCheckValidAbsoluteLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_CheckValidAbsoluteLocation ];

/// Foreign Key FKCheckValidAbsoluteSpecies created via DDL
ForeignKey FKCheckValidAbsoluteSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_CheckValidAbsoluteSpecies ];

/// Foreign Key FKCheckValidAbsoluteTestCode created via DDL
ForeignKey FKCheckValidAbsoluteTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_CheckValidAbsoluteTestCode ];

Index IndexDataMaster On (CheckValidRulesDR, TestCodeDR, OrderNo) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, OrderNo, CheckValidRulesDR) [ SqlName = Index_TestCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDABSOLUTE On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDABSOLUTE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 审核规则  
Property CheckValidRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 年龄范围  
Property Ages As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 缺省  {1:true,0:false}
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 8 ];

/// Delta结果天数  
Property DeltaDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 绝对值  
Property AbsoluteValue As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 绝对低值  
Property AbsoluteDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 绝对高值  
Property AbsoluteAsc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 关联科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// ApproType  
Property ApproType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTCheckValidAbsoluteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidRulesDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>OrderNo</Value>
</Value>
<Value name="5">
<Value>SpeciesDR</Value>
</Value>
<Value name="6">
<Value>Ages</Value>
</Value>
<Value name="7">
<Value>IsDefault</Value>
</Value>
<Value name="8">
<Value>DeltaDays</Value>
</Value>
<Value name="9">
<Value>AbsoluteValue</Value>
</Value>
<Value name="10">
<Value>AbsoluteDesc</Value>
</Value>
<Value name="11">
<Value>AbsoluteAsc</Value>
</Value>
<Value name="12">
<Value>LocationDR</Value>
</Value>
<Value name="13">
<Value>ApproType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidAbsoluteD</DataLocation>
<DefaultData>BTCheckValidAbsoluteDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidAbsoluteD</IdLocation>
<IndexLocation>^dbo.BTCheckValidAbsoluteI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidAbsoluteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
