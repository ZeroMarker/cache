Class CIS.AN.PatAdmission Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PatAdmission ]
{

Property AdmNo As %String [ SqlColumnNumber = 2 ];

Property Patient As CIS.AN.Patient [ SqlColumnNumber = 3 ];

/// Des Ref to CTLOC
Property Dept As CF.AN.Department [ SqlColumnNumber = 4 ];

/// Admission Date
Property AdmDate As %Date [ SqlColumnNumber = 5 ];

/// Admission Time
Property AdmTime As %Time [ SqlColumnNumber = 6 ];

/// Admission Type
Property AdmType As %String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,N,H") [ SqlColumnNumber = 7 ];

/// Des Ref to CTPCP
Property AdmDoc As CF.AN.CareProvider [ SqlColumnNumber = 8 ];

/// Discharge Date
Property DischgDate As %Date [ SqlColumnNumber = 9 ];

/// Discharge Time
Property DischgTime As %Time [ SqlColumnNumber = 10 ];

/// Des Ref to CTPCP
Property DischgDoc As CF.AN.CareProvider [ SqlColumnNumber = 11 ];

/// Visit Status
Property VisitStatus As %String(DISPLAYLIST = ",Admit,Cancel,Discharged,Pre-Admission,Released,DNA", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",A,C,D,P,R,N") [ SqlColumnNumber = 12 ];

/// Des Ref AdmReason
Property AdmReason As %String [ SqlColumnNumber = 13 ];

Property ExternalID As %String [ SqlColumnNumber = 14 ];

Index IPatient On Patient;

Index IAdmNo On AdmNo;

Index IAdmDate On AdmDate;

Index IAdmType On AdmType;

Index IDept On Dept;

Index IDischgDate On DischgDate;

Index IVisitStatus On VisitStatus;

Index IExt On ExternalID;

Storage Default
{
<Data name="PatAdmissionDefaultData">
<Value name="1">
<Value>AdmNo</Value>
</Value>
<Value name="2">
<Value>Patient</Value>
</Value>
<Value name="3">
<Value>Dept</Value>
</Value>
<Value name="4">
<Value>AdmDate</Value>
</Value>
<Value name="5">
<Value>AdmTime</Value>
</Value>
<Value name="6">
<Value>AdmType</Value>
</Value>
<Value name="7">
<Value>AdmDoc</Value>
</Value>
<Value name="8">
<Value>DischgDate</Value>
</Value>
<Value name="9">
<Value>DischgTime</Value>
</Value>
<Value name="10">
<Value>DischgDoc</Value>
</Value>
<Value name="11">
<Value>VisitStatus</Value>
</Value>
<Value name="12">
<Value>AdmReason</Value>
</Value>
<Value name="13">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PatAdmissionD</DataLocation>
<DefaultData>PatAdmissionDefaultData</DefaultData>
<IdLocation>^CIS.AN.PatAdmissionD</IdLocation>
<IndexLocation>^CIS.AN.PatAdmissionI</IndexLocation>
<StreamLocation>^CIS.AN.PatAdmissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
