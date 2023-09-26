Class dbo.RPOutVisitNumber Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_OutVisitNumber ]
{

Index IndexStartDate On (StartDate, Code) [ SqlName = Index_StartDate, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexLabNo On LabNo [ SqlName = Index_LabNo, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 3 ];

Property OrdID As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property LabNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

Property ArcimCode As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

Property ArcimDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

Property OrderQty As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property BillCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

Property SpecimenTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

Property SpecimenTypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

Property SpVolume As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

Property ColInfo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

Property Container As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 14 ];

Property GTSeq As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Property SpecFlag As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property VerifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property VerifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property ColDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property ColTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Property AppDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 21 ];

Property AppDeptDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 22 ];

Property RecDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 23 ];

Property RecDeptDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 24 ];

Property TSPrice As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 25 ];

Property OrderStatus As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 26 ];

Property DocCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 27 ];

Property DocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 28 ];

Property RepLoct As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 29 ];

Property RepDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

Property RepTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

Property Note As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 32 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 33 ];

Property AdmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

Property AdmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 35 ];

Property AdmTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 36 ];

Property AdmTypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 37 ];

Property FeeType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 38 ];

Property PatientWard As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 39 ];

Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 40 ];

Property Diagnose As %Library.String(COLLATION = "Exact", MAXLEN = 600) [ SqlColumnNumber = 41 ];

Property RegisterNo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 42 ];

Property PatientName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 43 ];

Property SexCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 44 ];

Property SexDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 45 ];

Property DOB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 46 ];

Property Age As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 47 ];

Property DocumentID As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 48 ];

Property PatientAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 49 ];

Property IdentityCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 50 ];

Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 51 ];

Property SpecUserCode As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 52 ];

Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 54 ];

Property SendFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 55 ];

Storage Default
{
<Data name="RPOutVisitNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>OrdID</Value>
</Value>
<Value name="4">
<Value>LabNo</Value>
</Value>
<Value name="5">
<Value>ArcimCode</Value>
</Value>
<Value name="6">
<Value>ArcimDesc</Value>
</Value>
<Value name="7">
<Value>OrderQty</Value>
</Value>
<Value name="8">
<Value>BillCode</Value>
</Value>
<Value name="9">
<Value>SpecimenTypeCode</Value>
</Value>
<Value name="10">
<Value>SpecimenTypeDesc</Value>
</Value>
<Value name="11">
<Value>SpVolume</Value>
</Value>
<Value name="12">
<Value>ColInfo</Value>
</Value>
<Value name="13">
<Value>Container</Value>
</Value>
<Value name="14">
<Value>GTSeq</Value>
</Value>
<Value name="15">
<Value>SpecFlag</Value>
</Value>
<Value name="16">
<Value>VerifyDate</Value>
</Value>
<Value name="17">
<Value>VerifyTime</Value>
</Value>
<Value name="18">
<Value>ColDate</Value>
</Value>
<Value name="19">
<Value>ColTime</Value>
</Value>
<Value name="20">
<Value>AppDeptCode</Value>
</Value>
<Value name="21">
<Value>AppDeptDesc</Value>
</Value>
<Value name="22">
<Value>RecDeptCode</Value>
</Value>
<Value name="23">
<Value>RecDeptDesc</Value>
</Value>
<Value name="24">
<Value>TSPrice</Value>
</Value>
<Value name="25">
<Value>OrderStatus</Value>
</Value>
<Value name="26">
<Value>DocCode</Value>
</Value>
<Value name="27">
<Value>DocDesc</Value>
</Value>
<Value name="28">
<Value>RepLoct</Value>
</Value>
<Value name="29">
<Value>RepDate</Value>
</Value>
<Value name="30">
<Value>RepTime</Value>
</Value>
<Value name="31">
<Value>Note</Value>
</Value>
<Value name="32">
<Value>AdmNo</Value>
</Value>
<Value name="33">
<Value>AdmDate</Value>
</Value>
<Value name="34">
<Value>AdmTime</Value>
</Value>
<Value name="35">
<Value>AdmTypeCode</Value>
</Value>
<Value name="36">
<Value>AdmTypeDesc</Value>
</Value>
<Value name="37">
<Value>FeeType</Value>
</Value>
<Value name="38">
<Value>PatientWard</Value>
</Value>
<Value name="39">
<Value>BedNo</Value>
</Value>
<Value name="40">
<Value>Diagnose</Value>
</Value>
<Value name="41">
<Value>RegisterNo</Value>
</Value>
<Value name="42">
<Value>PatientName</Value>
</Value>
<Value name="43">
<Value>SexCode</Value>
</Value>
<Value name="44">
<Value>SexDesc</Value>
</Value>
<Value name="45">
<Value>DOB</Value>
</Value>
<Value name="46">
<Value>Age</Value>
</Value>
<Value name="47">
<Value>DocumentID</Value>
</Value>
<Value name="48">
<Value>PatientAddress</Value>
</Value>
<Value name="49">
<Value>IdentityCardNo</Value>
</Value>
<Value name="50">
<Value>Telephone</Value>
</Value>
<Value name="51">
<Value>SpecUserCode</Value>
</Value>
<Value name="52">
<Value>StartDate</Value>
</Value>
<Value name="53">
<Value>StartTime</Value>
</Value>
<Value name="54">
<Value>SendFlag</Value>
</Value>
</Data>
<DataLocation>^dbo.RPOutVisitNumberD</DataLocation>
<DefaultData>RPOutVisitNumberDefaultData</DefaultData>
<IdLocation>^dbo.RPOutVisitNumberD</IdLocation>
<IndexLocation>^dbo.RPOutVisitNumberI</IndexLocation>
<StreamLocation>^dbo.RPOutVisitNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
