/// 质控流水
Class dbo.BTQCComparisonTestQC Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_ComparisonTestQC ]
{

Index IndexSampleID1 On (ComparisonTestDR, SampleID1) [ SqlName = Index_SampleID1, Type = index, Unique ];

Index IndexSampleID2 On (ComparisonTestDR, SampleID2) [ SqlName = Index_SampleID2, Type = index, Unique ];

Index IndexSampleID3 On (ComparisonTestDR, SampleID3) [ SqlName = Index_SampleID3, Type = index, Unique ];

Index IndexSampleID4 On (ComparisonTestDR, SampleID4) [ SqlName = Index_SampleID4, Type = index, Unique ];

Index IndexSampleID5 On (ComparisonTestDR, SampleID5) [ SqlName = Index_SampleID5, Type = index, Unique ];

/// Foreign Key FKBTQCComparisonTestQCComparisonTestDR created via DDL
ForeignKey FKBTQCComparisonTestQCComparisonTestDR(ComparisonTestDR) References dbo.BTQCComparisonTest(PKBTQCCOMPARISONTEST) [ SqlName = FK_BTQCComparisonTestQCComparisonTestDR ];

/// DDL Primary Key Specification
Index PKBTQCCOMPARISONTESTQC On RowID [ PrimaryKey, SqlName = PK_BTQC_COMPARISONTESTQC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 3 ];

/// 质控  
Property ComparisonTestDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 第一次流水  
Property SampleID1 As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

/// 第二次流水  
Property SampleID2 As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

/// 第三次流水  
Property SampleID3 As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

/// 第四次流水  
Property SampleID4 As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

/// 第五次流水  
Property SampleID5 As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 标本序号  
Property VisNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTQCComparisonTestQCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>ComparisonTestDR</Value>
</Value>
<Value name="4">
<Value>SampleID1</Value>
</Value>
<Value name="5">
<Value>SampleID2</Value>
</Value>
<Value name="6">
<Value>SampleID3</Value>
</Value>
<Value name="7">
<Value>SampleID4</Value>
</Value>
<Value name="8">
<Value>SampleID5</Value>
</Value>
<Value name="9">
<Value>VisNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCComparisonTestQCD</DataLocation>
<DefaultData>BTQCComparisonTestQCDefaultData</DefaultData>
<IdLocation>^dbo.BTQCComparisonTestQCD</IdLocation>
<IndexLocation>^dbo.BTQCComparisonTestQCI</IndexLocation>
<StreamLocation>^dbo.BTQCComparisonTestQCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
