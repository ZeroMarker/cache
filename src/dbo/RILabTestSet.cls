///     
Class dbo.RILabTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RI_LabTestSet ]
{

/// Property RowId As %Library.BigInt(MINVAL = 1) [ Identity, Required, SqlColumnNumber = 2 ];
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestSetCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property TestSetName As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property TestSetRowID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 6 ];

Property Sequence As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ Required, SqlColumnNumber = 7 ];

Property BarCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property ArticleBarCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 9 ];

Property TestSetState As %Library.String(COLLATION = "EXACT", MAXLEN = 2) [ SqlColumnNumber = 10 ];

Property VisitNumberTestSetCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 11 ];

Property SpecimenCode As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 12 ];

Property SpecimenName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 13 ];

Property ContainerCode As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 14 ];

Property ContainerName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 15 ];

Property CollectNotes As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property LocationCode As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 17 ];

Property LocationName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 18 ];

Property WardCode As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 19 ];

Property WardName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 20 ];

Property BedNo As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 21 ];

Property DotorID As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 22 ];

Property DotorName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 23 ];

Property RequestDate As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 24 ];

Property RequestTime As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 25 ];

Property PrinterID As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 26 ];

Property PrinterName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 27 ];

Property PrintDate As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 28 ];

Property PrintTime As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 29 ];

Property PrintStatus As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 30 ];

Property CollectDate As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 31 ];

Property CollectTime As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 32 ];

Property CollectUserID As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 33 ];

Property CollectUserName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 34 ];

Property AnatomicalSite As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 35 ];

Property CollectPositon As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 36 ];

Property CarryDate As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 37 ];

Property CarryTime As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 38 ];

Property CarryUserID As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 39 ];

Property CarryUserName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 40 ];

Property ReceiveDate As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 41 ];

Property ReceiveTime As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 42 ];

Property ReceiveUserID As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 43 ];

Property ReceiveUserName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 44 ];

Property TestSetFee As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 45 ];

Property TestSetFeeFlag As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 46 ];

Property ReqNotes As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 47 ];

Property RequestNo As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 48 ];

Property Urgent As %Library.Boolean [ SqlColumnNumber = 49 ];

Property H24UVolume As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 50 ];

Property H24UTimePeriod As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 51 ];

Property BodyTemp As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 52 ];

Property BloodPressure As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 53 ];

Property Confidential As %Library.Boolean [ SqlColumnNumber = 54 ];

Property SpecimenQuality As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 55 ];

Property ReceiveHospitalID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 56 ];

Property ReceiveNotes As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 57 ];

Property SpecialFlag As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 58 ];

Property SpecialRowId As %Library.String(COLLATION = "EXACT", MAXLEN = 10) [ SqlColumnNumber = 59 ];

Property OrdDeptID As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 60 ];

Property OrdDeptName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 61 ];

Property HospitalCode As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 62 ];

Property HospitalName As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 63 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 64 ];

Property TransmitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 65 ];

Property AssayNo As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 66 ];

Property AcceptDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 67 ];

Property AcceptTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 68 ];

Property AcceptUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

Property ReportID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 70 ];

Property IsChanged As %Library.Boolean [ SqlColumnNumber = 71 ];

Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 72 ];

Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 73 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 74 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 75 ];

Index BarCode On BarCode [ SqlName = BarCode, Type = index ];

Index CarryDate On (CarryDate, HospitalCode) [ SqlName = CarryDate, Type = index ];

Index CollectDateTime On (CollectDate, HospitalCode) [ SqlName = CollectDateTime, Type = index ];

Index HospitalCode On (HospitalCode, RequestDate) [ SqlName = HospitalCode, Type = index ];

/// DDL Primary Key Specification
/// Index PKRILabTestSet On RowId [ IdKey, PrimaryKey, SqlName = PK_RI_LabTestSet, Unique ];
Index PKRILabTestSet On RowID [ PrimaryKey, SqlName = PK_RI_LabTestSet, Type = index, Unique ];

Index PKRITestSet On (VisitNumberDR, TestSetRowID) [ SqlName = PKRITestSet, Type = index ];

Index PrintDate On (PrintDate, HospitalCode) [ SqlName = PrintDate, Type = index ];

Index ReceiveDate On (ReceiveDate, HospitalCode) [ SqlName = ReceiveDate, Type = index ];

Index RequestDate On (RequestDate, HospitalCode) [ SqlName = RequestDate, Type = index ];

Index TestSetCode On (TestSetCode, CollectDate) [ SqlName = TestSetCode, Type = index ];

Index IndexMaster On (VisitNumberDR, TestSetRowID, Sequence) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexArticleBarCode On ArticleBarCode [ SqlName = Index_ArticleBarCode, Type = index ];

Index IndexIsChanged On (IsChanged, AddDate) [ SqlName = Index_IsChanged, Type = index ];

Index IndexSpecialRowId On SpecialRowId [ SqlName = Index_SpecialRowId, Type = index ];

Index IndexTransmitDate On (WorkGroupMachineDR, TransmitDate, AssayNo) [ SqlName = Index_TransmitDate, Type = index ];

/// Foreign Key FKRILabTestSet created via DDL
ForeignKey FKRILabTestSet(VisitNumberDR) References dbo.RILabRequest(PKRILabRequest) [ SqlName = FK_RILabTestSet ];

/// Foreign Key FKRILabTestSetAcceptUser created via DDL
ForeignKey FKRILabTestSetAcceptUser(AcceptUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RILabTestSetAcceptUser ];

Storage Default
{
<Data name="RILabTestSetDefaultData">
<Value name="1">
<Value>VisitNumberDR</Value>
</Value>
<Value name="2">
<Value>TestSetCode</Value>
</Value>
<Value name="3">
<Value>TestSetName</Value>
</Value>
<Value name="4">
<Value>TestSetRowID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>BarCode</Value>
</Value>
<Value name="7">
<Value>ArticleBarCode</Value>
</Value>
<Value name="8">
<Value>TestSetState</Value>
</Value>
<Value name="9">
<Value>VisitNumberTestSetCode</Value>
</Value>
<Value name="10">
<Value>SpecimenCode</Value>
</Value>
<Value name="11">
<Value>SpecimenName</Value>
</Value>
<Value name="12">
<Value>ContainerCode</Value>
</Value>
<Value name="13">
<Value>ContainerName</Value>
</Value>
<Value name="14">
<Value>CollectNotes</Value>
</Value>
<Value name="15">
<Value>LocationCode</Value>
</Value>
<Value name="16">
<Value>LocationName</Value>
</Value>
<Value name="17">
<Value>WardCode</Value>
</Value>
<Value name="18">
<Value>WardName</Value>
</Value>
<Value name="19">
<Value>BedNo</Value>
</Value>
<Value name="20">
<Value>DotorID</Value>
</Value>
<Value name="21">
<Value>DotorName</Value>
</Value>
<Value name="22">
<Value>RequestDate</Value>
</Value>
<Value name="23">
<Value>RequestTime</Value>
</Value>
<Value name="24">
<Value>PrinterID</Value>
</Value>
<Value name="25">
<Value>PrinterName</Value>
</Value>
<Value name="26">
<Value>PrintDate</Value>
</Value>
<Value name="27">
<Value>PrintTime</Value>
</Value>
<Value name="28">
<Value>PrintStatus</Value>
</Value>
<Value name="29">
<Value>CollectDate</Value>
</Value>
<Value name="30">
<Value>CollectTime</Value>
</Value>
<Value name="31">
<Value>CollectUserID</Value>
</Value>
<Value name="32">
<Value>CollectUserName</Value>
</Value>
<Value name="33">
<Value>AnatomicalSite</Value>
</Value>
<Value name="34">
<Value>CollectPositon</Value>
</Value>
<Value name="35">
<Value>CarryDate</Value>
</Value>
<Value name="36">
<Value>CarryTime</Value>
</Value>
<Value name="37">
<Value>CarryUserID</Value>
</Value>
<Value name="38">
<Value>CarryUserName</Value>
</Value>
<Value name="39">
<Value>ReceiveDate</Value>
</Value>
<Value name="40">
<Value>ReceiveTime</Value>
</Value>
<Value name="41">
<Value>ReceiveUserID</Value>
</Value>
<Value name="42">
<Value>ReceiveUserName</Value>
</Value>
<Value name="43">
<Value>TestSetFee</Value>
</Value>
<Value name="44">
<Value>TestSetFeeFlag</Value>
</Value>
<Value name="45">
<Value>ReqNotes</Value>
</Value>
<Value name="46">
<Value>RequestNo</Value>
</Value>
<Value name="47">
<Value>Urgent</Value>
</Value>
<Value name="48">
<Value>H24UVolume</Value>
</Value>
<Value name="49">
<Value>H24UTimePeriod</Value>
</Value>
<Value name="50">
<Value>BodyTemp</Value>
</Value>
<Value name="51">
<Value>BloodPressure</Value>
</Value>
<Value name="52">
<Value>Confidential</Value>
</Value>
<Value name="53">
<Value>SpecimenQuality</Value>
</Value>
<Value name="54">
<Value>ReceiveHospitalID</Value>
</Value>
<Value name="55">
<Value>ReceiveNotes</Value>
</Value>
<Value name="56">
<Value>SpecialFlag</Value>
</Value>
<Value name="57">
<Value>SpecialRowId</Value>
</Value>
<Value name="58">
<Value>OrdDeptID</Value>
</Value>
<Value name="59">
<Value>OrdDeptName</Value>
</Value>
<Value name="60">
<Value>HospitalCode</Value>
</Value>
<Value name="61">
<Value>HospitalName</Value>
</Value>
<Value name="62">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="63">
<Value>TransmitDate</Value>
</Value>
<Value name="64">
<Value>AssayNo</Value>
</Value>
<Value name="65">
<Value>AcceptDate</Value>
</Value>
<Value name="66">
<Value>AcceptTime</Value>
</Value>
<Value name="67">
<Value>AcceptUserDR</Value>
</Value>
<Value name="68">
<Value>ReportID</Value>
</Value>
<Value name="69">
<Value>IsChanged</Value>
</Value>
<Value name="70">
<Value>UpdateDate</Value>
</Value>
<Value name="71">
<Value>UpdateTime</Value>
</Value>
<Value name="72">
<Value>AddDate</Value>
</Value>
<Value name="73">
<Value>AddTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RILabTestSetD</DataLocation>
<DefaultData>RILabTestSetDefaultData</DefaultData>
<IdFunction>sequence</IdFunction>
<IdLocation>^dbo.RILabTestSetD</IdLocation>
<IndexLocation>^dbo.RILabTestSetI</IndexLocation>
<StreamLocation>^dbo.RILabTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
