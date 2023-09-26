Class dbo.RPReqForm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_ReqForm ]
{

/// DDL Primary Key Specification
Index PKRPReqForm On RowID [ PrimaryKey, SqlName = PK_RP_ReqForm, Type = index, Unique ];

Index IndexReqFormNo On ReqFormNo [ SqlName = Index_ReqFormNo, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property ReqFormType As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 4 ];

Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 5 ];

Property AdmType As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 6 ];

Property AddDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 7 ];

Property AddTime As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 8 ];

Property AddUser As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 10 ];

Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 11 ];

Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 12 ];

Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 13 ];

Property Species As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14 ];

Property Age As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 15 ];

Property BirthDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 16 ];

Property CertType As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 17 ];

Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 18 ];

Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 19 ];

Property ABO As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 20 ];

Property RH As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 21 ];

Property Race As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 22 ];

Property Ethnicity As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 23 ];

Property Weight As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 24 ];

Property Height As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 25 ];

Property NativePlace As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 26 ];

Property Ward As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 27 ];

Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 28 ];

Property MobileNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 29 ];

Property Diagnosis As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 30 ];

Property MateName As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 31 ];

Property Hospital As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 32 ];

Property Location As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 33 ];

Property Doctor As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 34 ];

Property RequestDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 35 ];

Property RequestTime As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 36 ];

Property CollectUser As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 37 ];

Property CollectDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 38 ];

Property CollectTime As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 39 ];

Property TestSet As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 40 ];

Property Specimen As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 41 ];

Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 42 ];

Property AgreeFormNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 43 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 44 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 45 ];

Property CheckCause As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 46 ];

Property CheckDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 47 ];

Property CheckTime As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 48 ];

Property CheckUser As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 49 ];

Property IsPrinted As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 50 ];

Property ReceiveDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 51 ];

Property ReceiveTime As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 52 ];

Property ReceiveUser As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 53 ];

Property IsPregHistory As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 54 ];

Property Pregnancies As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 55 ];

Property ChildBirths As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 56 ];

Property FetalDeath As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 57 ];

Property RetardedBirths As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 58 ];

Property FetusNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 59 ];

Property LastMenstrualDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 60 ];

Property GestationalWeeks As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 61 ];

Property GestationalDays As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 62 ];

Property GestationalBase As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 63 ];

Property UltrasoundDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 64 ];

Property UltrasoundWeeks As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 65 ];

Property BPD As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 66 ];

Property CRL As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 67 ];

Property NT As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 68 ];

Property PreT21 As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 69 ];

Property PreT18 As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 70 ];

Property PreNT As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 71 ];

Property IDD As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 72 ];

Property IsForeAbortion As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 73 ];

Property IsSmoke As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 74 ];

Property AbnormalLife As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 75 ];

Property BadLifeHistory As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 76 ];

Property AbnormalPreHistory As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 77 ];

Property EmbryoTransDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 78 ];

Property RetrieveDate As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 79 ];

Property FatherOrigin As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 80 ];

Property MotherOrigin As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 81 ];

Property FatherNation As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 82 ];

Property MotherNation As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 83 ];

Property PreBirthAge As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 84 ];

Property CollectWeeks As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 85 ];

Property MateCondition As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 86 ];

Storage Default
{
<Data name="RPReqFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqFormNo</Value>
</Value>
<Value name="3">
<Value>AdmNo</Value>
</Value>
<Value name="4">
<Value>AdmType</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUser</Value>
</Value>
<Value name="8">
<Value>RegNo</Value>
</Value>
<Value name="9">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="10">
<Value>SurName</Value>
</Value>
<Value name="11">
<Value>GivenName</Value>
</Value>
<Value name="12">
<Value>Species</Value>
</Value>
<Value name="13">
<Value>Age</Value>
</Value>
<Value name="14">
<Value>BirthDate</Value>
</Value>
<Value name="15">
<Value>CertType</Value>
</Value>
<Value name="16">
<Value>CertNo</Value>
</Value>
<Value name="17">
<Value>IDNumber</Value>
</Value>
<Value name="18">
<Value>ABO</Value>
</Value>
<Value name="19">
<Value>RH</Value>
</Value>
<Value name="20">
<Value>Race</Value>
</Value>
<Value name="21">
<Value>Ethnicity</Value>
</Value>
<Value name="22">
<Value>Weight</Value>
</Value>
<Value name="23">
<Value>Height</Value>
</Value>
<Value name="24">
<Value>NativePlace</Value>
</Value>
<Value name="25">
<Value>Ward</Value>
</Value>
<Value name="26">
<Value>BedNo</Value>
</Value>
<Value name="27">
<Value>MobileNo</Value>
</Value>
<Value name="28">
<Value>Diagnosis</Value>
</Value>
<Value name="29">
<Value>MateName</Value>
</Value>
<Value name="30">
<Value>Hospital</Value>
</Value>
<Value name="31">
<Value>Location</Value>
</Value>
<Value name="32">
<Value>Doctor</Value>
</Value>
<Value name="33">
<Value>RequestDate</Value>
</Value>
<Value name="34">
<Value>RequestTime</Value>
</Value>
<Value name="35">
<Value>TestSet</Value>
</Value>
<Value name="36">
<Value>Specimen</Value>
</Value>
<Value name="37">
<Value>VisitNumber</Value>
</Value>
<Value name="38">
<Value>AgreeFormNo</Value>
</Value>
<Value name="39">
<Value>Remark</Value>
</Value>
<Value name="40">
<Value>Status</Value>
</Value>
<Value name="41">
<Value>CheckCause</Value>
</Value>
<Value name="42">
<Value>CheckDate</Value>
</Value>
<Value name="43">
<Value>CheckTime</Value>
</Value>
<Value name="44">
<Value>CheckUser</Value>
</Value>
<Value name="45">
<Value>IsPrinted</Value>
</Value>
<Value name="46">
<Value>ReceiveDate</Value>
</Value>
<Value name="47">
<Value>ReceiveTime</Value>
</Value>
<Value name="48">
<Value>ReceiveUser</Value>
</Value>
<Value name="49">
<Value>IsPregHistory</Value>
</Value>
<Value name="50">
<Value>Pregnancies</Value>
</Value>
<Value name="51">
<Value>ChildBirths</Value>
</Value>
<Value name="52">
<Value>FetalDeath</Value>
</Value>
<Value name="53">
<Value>RetardedBirths</Value>
</Value>
<Value name="54">
<Value>FetusNumber</Value>
</Value>
<Value name="55">
<Value>LastMenstrualDate</Value>
</Value>
<Value name="56">
<Value>GestationalWeeks</Value>
</Value>
<Value name="57">
<Value>UltrasoundDate</Value>
</Value>
<Value name="58">
<Value>UltrasoundWeeks</Value>
</Value>
<Value name="59">
<Value>BDP</Value>
</Value>
<Value name="60">
<Value>CRL</Value>
</Value>
<Value name="61">
<Value>NT</Value>
</Value>
<Value name="62">
<Value>PreT21</Value>
</Value>
<Value name="63">
<Value>PreT18</Value>
</Value>
<Value name="64">
<Value>PreNT</Value>
</Value>
<Value name="65">
<Value>IDD</Value>
</Value>
<Value name="66">
<Value>IsForeAbortion</Value>
</Value>
<Value name="67">
<Value>IsSmoke</Value>
</Value>
<Value name="68">
<Value>AbnormalLife</Value>
</Value>
<Value name="69">
<Value>BadLifeHistory</Value>
</Value>
<Value name="70">
<Value>AbnormalPreHistory</Value>
</Value>
<Value name="71">
<Value>EmbryoTransDate</Value>
</Value>
<Value name="72">
<Value>RetrieveDate</Value>
</Value>
<Value name="73">
<Value>FatherOrigin</Value>
</Value>
<Value name="74">
<Value>MotherOrigin</Value>
</Value>
<Value name="75">
<Value>FatherNation</Value>
</Value>
<Value name="76">
<Value>MotherNation</Value>
</Value>
<Value name="77">
<Value>CollectUser</Value>
</Value>
<Value name="78">
<Value>CollectDate</Value>
</Value>
<Value name="79">
<Value>CollectTime</Value>
</Value>
<Value name="80">
<Value>GestationalDays</Value>
</Value>
<Value name="81">
<Value>GestationalBase</Value>
</Value>
<Value name="82">
<Value>CollectWeeks</Value>
</Value>
<Value name="83">
<Value>PreBirthAge</Value>
</Value>
<Value name="84">
<Value>MateCondition</Value>
</Value>
<Value name="85">
<Value>BPD</Value>
</Value>
<Value name="86">
<Value>ReqFormType</Value>
</Value>
</Data>
<DataLocation>^dbo.RPReqFormD</DataLocation>
<DefaultData>RPReqFormDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPReqFormD</IdLocation>
<IndexLocation>^dbo.RPReqFormI</IndexLocation>
<StreamLocation>^dbo.RPReqFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
