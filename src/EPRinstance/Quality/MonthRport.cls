Class EPRinstance.Quality.MonthRport Extends %Persistent
{

Index IdxCTLocIDDateUserID On (RecoedDate, CTLocID, UserID);

Index IdxRecoedDate On RecoedDate;

Index IdxUserID On UserID;

Index IdxCTLocID On CTLocID;

Property RecoedDate As %String(TRUNCATE = 1);

Property CTLocID As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property Allcount As %String(TRUNCATE = 1);

Property GradeB As %String(TRUNCATE = 1);

Property GradeC As %String(TRUNCATE = 1);

Property GradeAPercent As %String(TRUNCATE = 1);

Property MedicalRecord As %String(MAXLEN = 5000, TRUNCATE = 1);

Property DailyRecord As %String(MAXLEN = 5000, TRUNCATE = 1);

Property Opinion As %String(MAXLEN = 5000, TRUNCATE = 1);

Property SaveDate As %Date;

Property SaveTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Storage Default
{
<Data name="MonthRportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecoedDate</Value>
</Value>
<Value name="3">
<Value>RecordTime</Value>
</Value>
<Value name="4">
<Value>LocID</Value>
</Value>
<Value name="5">
<Value>floor</Value>
</Value>
<Value name="6">
<Value>equipment</Value>
</Value>
<Value name="7">
<Value>name</Value>
</Value>
<Value name="8">
<Value>tel</Value>
</Value>
<Value name="9">
<Value>content</Value>
</Value>
<Value name="10">
<Value>status</Value>
</Value>
<Value name="11">
<Value>engineer</Value>
</Value>
<Value name="12">
<Value>engineerID</Value>
</Value>
<Value name="13">
<Value>UseID</Value>
</Value>
<Value name="14">
<Value>ManelDateTime</Value>
</Value>
<Value name="15">
<Value>FinishDateTime</Value>
</Value>
<Value name="16">
<Value>FinishUserID</Value>
</Value>
<Value name="17">
<Value>FinishUser</Value>
</Value>
<Value name="18">
<Value>CTLocID</Value>
</Value>
<Value name="19">
<Value>UserID</Value>
</Value>
<Value name="20">
<Value>Allcount</Value>
</Value>
<Value name="21">
<Value>GradeB</Value>
</Value>
<Value name="22">
<Value>GradeC</Value>
</Value>
<Value name="23">
<Value>GradeAPercent</Value>
</Value>
<Value name="24">
<Value>MedicalRecord</Value>
</Value>
<Value name="25">
<Value>DailyRecord</Value>
</Value>
<Value name="26">
<Value>Opinion</Value>
</Value>
<Value name="27">
<Value>SaveDate</Value>
</Value>
<Value name="28">
<Value>SaveTime</Value>
</Value>
<Value name="29">
<Value>UpdateDate</Value>
</Value>
<Value name="30">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.MonthRportD</DataLocation>
<DefaultData>MonthRportDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.MonthRportD</IdLocation>
<IndexLocation>^DHCEPRQ.MonthRportI</IndexLocation>
<StreamLocation>^DHCEPRQ.MonthRportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
