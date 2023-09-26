/// BTCheckValidRange
Class dbo.BTCheckValidRange Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidRange, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidRange created via DDL
ForeignKey FKCheckValidRange(CheckValidRulesDR) References dbo.BTCheckValidRules(PKBTCHECKVALIDRULES) [ SqlName = FK_CheckValidRange ];

/// Foreign Key FKCheckValidRangeLocation created via DDL
ForeignKey FKCheckValidRangeLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_CheckValidRangeLocation ];

/// Foreign Key FKCheckValidRangeTestCode created via DDL
ForeignKey FKCheckValidRangeTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_CheckValidRangeTestCode ];

/// Foreign Key FKCheckValidRangesSpecies created via DDL
ForeignKey FKCheckValidRangesSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_CheckValidRangesSpecies ];

/// Foreign Key FKTestSetDefSpecimen created via DDL
ForeignKey FKCheckValidRangesSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_CheckValidRangesSpecimen ];

Index IndexDataMaster On (CheckValidRulesDR, TestCodeDR, OrderNo) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, OrderNo, CheckValidRulesDR) [ SqlName = Index_TestCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDRANGE On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDRANGE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 自动审核规则  
Property CheckValidRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 年龄  
Property Ages As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 默认  {1:true,0:false}
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 低值  
Property LowRange As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 高值  
Property HighRange As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 申请科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// ApproType  
Property ApproType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BTCheckValidRangeDefaultData">
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
<Value>LowRange</Value>
</Value>
<Value name="9">
<Value>HighRange</Value>
</Value>
<Value name="10">
<Value>LocationDR</Value>
</Value>
<Value name="11">
<Value>ApproType</Value>
</Value>
<Value name="12">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidRangeD</DataLocation>
<DefaultData>BTCheckValidRangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidRangeD</IdLocation>
<IndexLocation>^dbo.BTCheckValidRangeI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidRangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
