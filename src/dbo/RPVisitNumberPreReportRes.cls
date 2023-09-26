Class dbo.RPVisitNumberPreReportRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberPreReportRes ]
{

Index IndexAdmItem On (AdmNo, TestCodeDR, AuthDate, AuthTime) [ SqlName = Index_AdmItem, Type = index ];

Index IndexPatientItem On (RegNo, TestCodeDR, AuthDate, AuthTime) [ SqlName = Index_PatientItem, Type = index ];

Index IndexMachine On (MachineParameterDR, TestCodeDR, AuthDate) [ SqlName = Index_Machine, Type = index ];

Index IndexReportItem On (VisitNumberReportDR, TestCodeDR) [ SqlName = Index_ReportItem, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERPREREPORTRES On RowID [ PrimaryKey, SqlName = PK_RP_VisitNumberPreReportRes, Type = index, Unique ];

/// Foreign Key FKVisitNumberReportResult created via DDL
ForeignKey FKVisitNumberPreReportDR(VisitNumberReportDR) References dbo.RPVisitNumberRepMid(PKRPVISITNUMBERREPMID) [ SqlName = FK_VisitNumberReportResult ];

/// Foreign Key FKVisitNumberReportResultMachine created via DDL
ForeignKey FKVisitNumberPreReportResMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_VisitNumberReportResultMachine ];

/// Foreign Key FKVisitNumberReportResultMethod created via DDL
ForeignKey FKVisitNumberPreReportResMethod(MethodDR) References dbo.BTTestMethod(PKBTTESTMETHOD) [ SqlName = FK_VisitNumberReportResultMethod ];

/// Foreign Key FKVisitNumberReportResultTC created via DDL
ForeignKey FKVisitNumberPreReportResTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_VisitNumberReportResultTC ];

/// Foreign Key FKVisitNumberReportResultUser created via DDL
ForeignKey FKVisitNumberPreReportResUser(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportResultUser ];

Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5 ];

Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property ExtraRes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property OtherRes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property ResNoes As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 9 ];

Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 10 ];

Property ResClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 11 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 13 ];

Property MethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property AssayDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property AssayTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property AssayStatus As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 20 ];

Property ReAssayNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

Property ExpertRule As %Library.String(COLLATION = "Exact", MAXLEN = 400) [ SqlColumnNumber = 22 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 23 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 24 ];

Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Property ReAssayNumber As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 27 ];

Property MultipleResistant As %Library.Boolean [ SqlColumnNumber = 28 ];

Property IsNotReport As %Library.Boolean [ SqlColumnNumber = 30 ];

Property IsMandatory As %Library.Boolean [ SqlColumnNumber = 31 ];

Storage Default
{
<Data name="RPVisitNumberPreReportResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>TextRes</Value>
</Value>
<Value name="6">
<Value>ExtraRes</Value>
</Value>
<Value name="7">
<Value>OtherRes</Value>
</Value>
<Value name="8">
<Value>ResNoes</Value>
</Value>
<Value name="9">
<Value>AbFlag</Value>
</Value>
<Value name="10">
<Value>ResClass</Value>
</Value>
<Value name="11">
<Value>Unit</Value>
</Value>
<Value name="12">
<Value>RefRanges</Value>
</Value>
<Value name="13">
<Value>MethodDR</Value>
</Value>
<Value name="14">
<Value>MachineParameterDR</Value>
</Value>
<Value name="15">
<Value>OperateUserDR</Value>
</Value>
<Value name="16">
<Value>AssayDate</Value>
</Value>
<Value name="17">
<Value>AssayTime</Value>
</Value>
<Value name="18">
<Value>Sequence</Value>
</Value>
<Value name="19">
<Value>AssayStatus</Value>
</Value>
<Value name="20">
<Value>ReAssayNum</Value>
</Value>
<Value name="21">
<Value>ExpertRule</Value>
</Value>
<Value name="22">
<Value>RegNo</Value>
</Value>
<Value name="23">
<Value>AdmNo</Value>
</Value>
<Value name="24">
<Value>AuthDate</Value>
</Value>
<Value name="25">
<Value>AuthTime</Value>
</Value>
<Value name="26">
<Value>ReAssayNumber</Value>
</Value>
<Value name="27">
<Value>MultipleResistant</Value>
</Value>
<Value name="28">
<Value>TestSetDR</Value>
</Value>
<Value name="29">
<Value>IsNotReport</Value>
</Value>
<Value name="30">
<Value>IsMandatory</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberPreReportResD</DataLocation>
<DefaultData>RPVisitNumberPreReportResDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberPreReportResD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberPreReportResI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberPreReportResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
