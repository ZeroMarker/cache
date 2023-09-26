///     
Class dbo.QCEQAWGPlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQAWGPlan, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupDR, OpenYear, EQAItemDR, JoinNum) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKQCEQAWGPLAN On RowID [ PrimaryKey, SqlName = PK_QC_EQAWGPLAN, Type = index, Unique ];

/// Foreign Key FKQCEQAWGPlanWorkGroup created via DDL
ForeignKey FKQCEQAWGPlanWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_QC_EQAWGPlan_WorkGroup ];

ForeignKey FKQCEQAWGPlanQAEQANCCLPlan(QCEQANcclPlanDR) References dbo.QCEQANCCLPlan(PKQCEQANCCLPLAN) [ SqlName = FK_QC_EQAWGPlan_EQANCCLPlan ];

/// Foreign Key FKQCEQAWGPlanEQAItem created via DDL
ForeignKey FKQCEQAWGPlanEQAItem(EQAItemDR) References dbo.BTEQAItem(PKBTEQAITEM) [ SqlName = FK_QC_EQAWGPlan_EQAItem ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OpenYear As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property EQAItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property JoinNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property JoinDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property EQAType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 8 ];

Property OtherEQAType As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 9 ];

Property ReportDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ReportTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ReportUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property RepCheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property RepCheckDTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property RepCheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property BackDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property BackTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property BackUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property ReportFile As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

Property BackSummary As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 20 ];

Property BackSumDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property BackSumTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property BackSumUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property CheckOpition As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 24 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Property CheckUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

Property VerifyOption As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 28 ];

Property VerifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

Property VerifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property VerifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property PlanStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 32 ];

Property QCEQANcclPlanDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

Property SampleStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 37 ];

Storage Default
{
<Data name="QCEQAWGPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>OpenYear</Value>
</Value>
<Value name="4">
<Value>EQAItemDR</Value>
</Value>
<Value name="5">
<Value>JoinNum</Value>
</Value>
<Value name="6">
<Value>JoinDate</Value>
</Value>
<Value name="7">
<Value>EQAType</Value>
</Value>
<Value name="8">
<Value>OtherEQAType</Value>
</Value>
<Value name="9">
<Value>ReportDate</Value>
</Value>
<Value name="10">
<Value>ReportTime</Value>
</Value>
<Value name="11">
<Value>ReportUserDR</Value>
</Value>
<Value name="12">
<Value>RepCheckDate</Value>
</Value>
<Value name="13">
<Value>RepCheckDTime</Value>
</Value>
<Value name="14">
<Value>RepCheckUserDR</Value>
</Value>
<Value name="15">
<Value>BackDate</Value>
</Value>
<Value name="16">
<Value>BackTime</Value>
</Value>
<Value name="17">
<Value>BackUserDR</Value>
</Value>
<Value name="18">
<Value>ReportFile</Value>
</Value>
<Value name="19">
<Value>BackSummary</Value>
</Value>
<Value name="20">
<Value>BackSumDate</Value>
</Value>
<Value name="21">
<Value>BackSumTime</Value>
</Value>
<Value name="22">
<Value>BackSumUserDR</Value>
</Value>
<Value name="23">
<Value>CheckOpition</Value>
</Value>
<Value name="24">
<Value>CheckDate</Value>
</Value>
<Value name="25">
<Value>CheckTime</Value>
</Value>
<Value name="26">
<Value>CheckUserDR</Value>
</Value>
<Value name="27">
<Value>VerifyOption</Value>
</Value>
<Value name="28">
<Value>VerifyDate</Value>
</Value>
<Value name="29">
<Value>VerifyTime</Value>
</Value>
<Value name="30">
<Value>VerifyUserDR</Value>
</Value>
<Value name="31">
<Value>PlanStatus</Value>
</Value>
<Value name="32">
<Value>QCEQANcclPlanDR</Value>
</Value>
<Value name="33">
<Value>CancelDate</Value>
</Value>
<Value name="34">
<Value>CancelTime</Value>
</Value>
<Value name="35">
<Value>CancelUserDR</Value>
</Value>
<Value name="36">
<Value>SampleStatus</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQAWGPlanD</DataLocation>
<DefaultData>QCEQAWGPlanDefaultData</DefaultData>
<IdLocation>^dbo.QCEQAWGPlanD</IdLocation>
<IndexLocation>^dbo.QCEQAWGPlanI</IndexLocation>
<StreamLocation>^dbo.QCEQAWGPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
