/// 仪器比对结果
Class dbo.QCCompareTaskRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_CompareTaskRes ]
{

/// Foreign Key FKQCCompareTaskResQCCompareTaskDR created via DDL
ForeignKey FKQCCompareTaskResCompareTaskDR(CompareTaskDR) References dbo.BTQCCompareTask(PKBTQCCOMPARETASK) [ SqlName = FK_QCCompareTaskResCompareTaskDR ];

/// Foreign Key FKQCCompareTaskResMachineParameterDR created via DDL
ForeignKey FKQCCompareTaskResMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_QCCompareTaskResMachineParameterDR ];

/// Foreign Key FKQCCompareTaskResTestCodeDR created via DDL
ForeignKey FKQCCompareTaskResTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_QCCompareTaskResTestCodeDR ];

/// Foreign Key FKQCCompareTaskResSaveUserDR created via DDL
ForeignKey FKQCCompareTaskResSaveUserDR(SaveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCCompareTaskResSaveUserDR ];

/// Foreign Key FKQCCompareTaskResAuthUserDR created via DDL
ForeignKey FKQCCompareTaskResAuthUserDR(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCCompareTaskResAuthUserDR ];

/// DDL Primary Key Specification
Index PKQCCOMPARETASKRES On RowID [ PrimaryKey, SqlName = PK_QC_COMPARETASKRES, Type = index, Unique ];

Index IndexMaster On (CompareTaskDR, MachineParameterDR, TestCodeDR, TestNum, TestDate) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexMachineParameter On (MachineParameterDR, TestCodeDR, TestDate) [ SqlName = Index_MachineParameter, Type = index ];

Index IndexAuthUser On (AuthUserDR, AuthDate) [ SqlName = Index_AuthUser, Type = index ];

Index IndexCompareTask On (CompareTaskDR, AddDate) [ SqlName = Index_CompareTask, Type = index ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 比对计划
Property CompareTaskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 仪器
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 测试日期
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 测试时间
Property TestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 标识号
Property SampleID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 8 ];

/// 结果
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 9 ];

/// 测试次数
Property TestNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

/// 靶机对比偏差标准
Property TarCV As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

/// 自身对比偏差标准
Property SelfCV As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// 靶机对比偏差
Property TarCVRes As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// 自身对比偏差
Property SelfCVRes As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

/// 是否合格
Property Qualified As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 状态
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 18 ];

/// 保存日期
Property SaveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 保存时间
Property SaveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 保存人
Property SaveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 审核日期
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 审核时间
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 审核人
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="QCCompareTaskResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CompareTaskDR</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>TestDate</Value>
</Value>
<Value name="6">
<Value>TestTime</Value>
</Value>
<Value name="7">
<Value>SampleID</Value>
</Value>
<Value name="8">
<Value>Result</Value>
</Value>
<Value name="9">
<Value>TestNum</Value>
</Value>
<Value name="10">
<Value>AddDate</Value>
</Value>
<Value name="11">
<Value>AddTime</Value>
</Value>
<Value name="12">
<Value>TarCV</Value>
</Value>
<Value name="13">
<Value>SelfCV</Value>
</Value>
<Value name="14">
<Value>TarCVRes</Value>
</Value>
<Value name="15">
<Value>SelfCVRes</Value>
</Value>
<Value name="16">
<Value>Qualified</Value>
</Value>
<Value name="17">
<Value>Status</Value>
</Value>
<Value name="18">
<Value>SaveDate</Value>
</Value>
<Value name="19">
<Value>SaveTime</Value>
</Value>
<Value name="20">
<Value>SaveUserDR</Value>
</Value>
<Value name="21">
<Value>AuthDate</Value>
</Value>
<Value name="22">
<Value>AuthTime</Value>
</Value>
<Value name="23">
<Value>AuthUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.QCCompareTaskResD</DataLocation>
<DefaultData>QCCompareTaskResDefaultData</DefaultData>
<IdLocation>^dbo.QCCompareTaskResD</IdLocation>
<IndexLocation>^dbo.QCCompareTaskResI</IndexLocation>
<StreamLocation>^dbo.QCCompareTaskResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
