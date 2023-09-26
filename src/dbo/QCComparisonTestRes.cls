/// 质控对比结果
Class dbo.QCComparisonTestRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_ComparisonTestRes ]
{

/// Foreign Key FKQCComparisonTestResTestCodeDR created via DDL
ForeignKey FKQCComparisonTestResTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCComparisonTestResTestCodeDR ];

/// Foreign Key FKQCComparisonTestResMachineParameterDR created via DDL
ForeignKey FKQCComparisonTestResMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QCComparisonTestResMachineParameterDR ];

/// Foreign Key FKQCComparisonTestResAddUserDR created via DDL
ForeignKey FKQCComparisonTestResAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCComparisonTestResAddUserDR ];

/// Foreign Key FKQCComparisonTestResUpdateUserDR created via DDL
ForeignKey FKQCComparisonTestResUpdateUserDR(UpdateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCComparisonTestResUpdateUserDR ];

/// Foreign Key FKQCComparisonTestResAutUserDR created via DDL
ForeignKey FKQCComparisonTestResAutUserDR(AutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCComparisonTestResAutUserDR ];

/// DDL Primary Key Specification
Index PKQCCOMPARISONTESTRES On RowID [ PrimaryKey, SqlName = PK_QC_COMPARISONTESTRES, Type = index, Unique ];

Index IndexTestDate On (TestDate, VisNum, MachineParameterDR, TestCodeDR, Num) [ SqlName = Index_TestDate, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// VisNum  
Property VisNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// Num  
Property Num As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 检测日期  
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 检测时间  
Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// ID  
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 文本结果  
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 添加日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 添加时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 添加用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 更新日期  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 更新时间  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 更新用户  
Property UpdateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 备注  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

/// 审核用户  
Property AutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="QCComparisonTestResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>VisNum</Value>
</Value>
<Value name="4">
<Value>Num</Value>
</Value>
<Value name="5">
<Value>TestDate</Value>
</Value>
<Value name="6">
<Value>TestTime</Value>
</Value>
<Value name="7">
<Value>MachineParameterDR</Value>
</Value>
<Value name="8">
<Value>SampleID</Value>
</Value>
<Value name="9">
<Value>Result</Value>
</Value>
<Value name="10">
<Value>TextRes</Value>
</Value>
<Value name="11">
<Value>AddDate</Value>
</Value>
<Value name="12">
<Value>AddTime</Value>
</Value>
<Value name="13">
<Value>AddUserDR</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
<Value name="16">
<Value>UpdateUserDR</Value>
</Value>
<Value name="17">
<Value>Remark</Value>
</Value>
<Value name="18">
<Value>AutUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.QCComparisonTestResD</DataLocation>
<DefaultData>QCComparisonTestResDefaultData</DefaultData>
<IdLocation>^dbo.QCComparisonTestResD</IdLocation>
<IndexLocation>^dbo.QCComparisonTestResI</IndexLocation>
<StreamLocation>^dbo.QCComparisonTestResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
