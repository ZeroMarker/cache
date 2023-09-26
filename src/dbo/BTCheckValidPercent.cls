/// BTCheckValidPercent
Class dbo.BTCheckValidPercent Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidPercent, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidPercent created via DDL
ForeignKey FKCheckValidPercent(CheckValidRulesDR) References dbo.BTCheckValidRules(PKBTCHECKVALIDRULES) [ SqlName = FK_CheckValidPercent ];

/// Foreign Key FKCheckValidPercentLocation created via DDL
ForeignKey FKCheckValidPercentLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_CheckValidPercentLocation ];

/// Foreign Key FKCheckValidPercentSpecies created via DDL
ForeignKey FKCheckValidPercentSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_CheckValidPercentSpecies ];

/// Foreign Key FKCheckValidPercentTestCode created via DDL
ForeignKey FKCheckValidPercentTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_CheckValidPercentTestCode ];

Index IndexDataMaster On (CheckValidRulesDR, TestCodeDR, OrderNo) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, OrderNo, CheckValidRulesDR) [ SqlName = Index_TestCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDPERCENT On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDPERCENT, Type = index, Unique ];

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

/// 年龄  
Property Ages As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 默认  {1:true,0:false}
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 默认天数  
Property DeltaDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 百分比值  
Property Percentage As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 百分比低值  
Property PercentageDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 百分比高值  
Property PercentageAsc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 申请科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// ApproType  
Property ApproType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTCheckValidPercentDefaultData">
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
<Value>Percentage</Value>
</Value>
<Value name="10">
<Value>PercentageDesc</Value>
</Value>
<Value name="11">
<Value>PercentageAsc</Value>
</Value>
<Value name="12">
<Value>LocationDR</Value>
</Value>
<Value name="13">
<Value>ApproType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidPercentD</DataLocation>
<DefaultData>BTCheckValidPercentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidPercentD</IdLocation>
<IndexLocation>^dbo.BTCheckValidPercentI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidPercentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
