///     
Class dbo.QCEQANCCLPlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_EQANCCLPlan, StorageStrategy = Default ]
{

Index IndexMaster On (PlanYear, EQAItemDR, JoinNum) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexEQAItemClass On (EQAItemDR, PlanYear, JoinNum) [ SqlName = Index_EQAItemClass, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCEQANCCLPLAN On RowID [ PrimaryKey, SqlName = PK_QC_EQANCCLPLAN, Type = index, Unique ];

/// Foreign Key FKQCEQANCCLPlanEQAItem created via DDL
ForeignKey FKQCEQANCCLPlanEQAItem(EQAItemDR) References dbo.BTEQAItem(PKBTEQAITEM) [ SqlName = FK_QC_EQANCCLPlan_EQAItem ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PlanYear As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property EQAItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property JoinNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AcceptDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AcceptUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property DetermineDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property DetermineUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property ReportDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property ReportUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property BackDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property BackUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property AnalysisDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property AnalysisUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property EQAType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 16 ];

Storage Default
{
<Data name="QCEQANCCLPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanYear</Value>
</Value>
<Value name="3">
<Value>EQAItemDR</Value>
</Value>
<Value name="4">
<Value>JoinNum</Value>
</Value>
<Value name="5">
<Value>AcceptDate</Value>
</Value>
<Value name="6">
<Value>AcceptUserDR</Value>
</Value>
<Value name="7">
<Value>DetermineDate</Value>
</Value>
<Value name="8">
<Value>DetermineUserDR</Value>
</Value>
<Value name="9">
<Value>ReportDate</Value>
</Value>
<Value name="10">
<Value>ReportUserDR</Value>
</Value>
<Value name="11">
<Value>BackDate</Value>
</Value>
<Value name="12">
<Value>BackUserDR</Value>
</Value>
<Value name="13">
<Value>AnalysisDate</Value>
</Value>
<Value name="14">
<Value>AnalysisUserDR</Value>
</Value>
<Value name="15">
<Value>EQAType</Value>
</Value>
</Data>
<DataLocation>^dbo.QCEQANCCLPlanD</DataLocation>
<DefaultData>QCEQANCCLPlanDefaultData</DefaultData>
<IdLocation>^dbo.QCEQANCCLPlanD</IdLocation>
<IndexLocation>^dbo.QCEQANCCLPlanI</IndexLocation>
<StreamLocation>^dbo.QCEQANCCLPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
