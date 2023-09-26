/// 检测项目参考范围
Class dbo.BTTestCodeRanges Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeRanges, StorageStrategy = Default ]
{

Index IndexMaster On (TestCodeDR, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestCodeSex On (TestCodeDR, SpeciesDR) [ SqlName = Index_TestCodeSex, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTCODERANGES On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODERANGES, Type = index, Unique ];

/// Foreign Key FKTestCodeRanges created via DDL
ForeignKey FKTestCodeRanges(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeRanges ];

/// Foreign Key FKTestCodeRangesClinic created via DDL
ForeignKey FKTestCodeRangesClinic(ClinicalConditionsDR) References dbo.BTClinicalConditions(PKBTCLINICALCONDITIONS) [ SqlName = FK_TestCodeRangesClinic ];

/// Foreign Key FKTestCodeRangesLoc created via DDL
ForeignKey FKTestCodeRangesLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_TestCodeRangesLoc ];

/// Foreign Key FKTestCodeRangesSex created via DDL
ForeignKey FKTestCodeRangesSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_TestCodeRangesSex ];

/// Foreign Key FKTestCodeRangesSpecimen created via DDL
ForeignKey FKTestCodeRangesSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_TestCodeRangesSpecimen ];

/// Foreign Key FKVisitNumberAgeUnit created via DDL
ForeignKey FKTestCodeRangesAgeLowUnit(SAgeLowUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_TestCodeRangesAgeLowUnit ];

/// Foreign Key FKVisitNumberAgeUnit created via DDL
ForeignKey FKTestCodeRangesAgeHighUnit(SAgeHighUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_TestCodeRangesAgeHighUnit ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 年龄低值  
Property AgeLow As %Library.Float [ SqlColumnNumber = 6 ];

/// 年龄高值  
Property AgeHigh As %Library.Float [ SqlColumnNumber = 7 ];

/// 标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 生理条件  
Property ClinicalConditionsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 临床科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 低值  
Property ValueLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 11 ];

/// 高值  
Property ValueHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 12 ];

/// 危机低值  
Property PanicLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

/// 危机高值  
Property PanicHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// 排除低值  
Property UnacceptLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// 排查高值  
Property UnacceptHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

/// 是否默认  {1:true,0:false}
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 参考范围  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

/// 临床症状  
Property Symptom As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 19 ];

/// 显示年龄低值  
Property SAgeLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 20 ];

/// 显示年龄高值 
Property SAgeHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 21 ];

/// 显示年龄低值单位 
Property SAgeLowUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 显示年龄高值单位 
Property SAgeHighUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 开始日期  
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 结束日期  
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Storage Default
{
<Data name="BTTestCodeRangesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>SpeciesDR</Value>
</Value>
<Value name="5">
<Value>AgeLow</Value>
</Value>
<Value name="6">
<Value>AgeHigh</Value>
</Value>
<Value name="7">
<Value>SpecimenDR</Value>
</Value>
<Value name="8">
<Value>ClinicalConditionsDR</Value>
</Value>
<Value name="9">
<Value>LocationDR</Value>
</Value>
<Value name="10">
<Value>ValueLow</Value>
</Value>
<Value name="11">
<Value>ValueHigh</Value>
</Value>
<Value name="12">
<Value>PanicLow</Value>
</Value>
<Value name="13">
<Value>PanicHigh</Value>
</Value>
<Value name="14">
<Value>UnacceptLow</Value>
</Value>
<Value name="15">
<Value>UnacceptHigh</Value>
</Value>
<Value name="16">
<Value>IsDefault</Value>
</Value>
<Value name="17">
<Value>RefRanges</Value>
</Value>
<Value name="18">
<Value>Symptom</Value>
</Value>
<Value name="19">
<Value>SAgeLow</Value>
</Value>
<Value name="20">
<Value>SAgeHigh</Value>
</Value>
<Value name="21">
<Value>SAgeLowUnitDR</Value>
</Value>
<Value name="22">
<Value>SAgeHighUnitDR</Value>
</Value>
<Value name="23">
<Value>StartDate</Value>
</Value>
<Value name="24">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeRangesD</DataLocation>
<DefaultData>BTTestCodeRangesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodeRangesD</IdLocation>
<IndexLocation>^dbo.BTTestCodeRangesI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeRangesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
