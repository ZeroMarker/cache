Class User.DHCMedICURes Extends %Persistent
{

Property ResPaadm As %String;

Property ResCurrentWard As %String;

Property ResCurrentBed As %String;

Property ResCtlocNum As %String;

Property ResDeepVeinPipe As %String;

Property ResUrinePipe As %String;

Property ResWindPipeOrCut As %String;

Property ResTopTemp As %String;

Property ResBloodInf As %String;

Property ResUrinaryInf As %String;

Property ResPneuInf As %String;

Property ResInfNum As %String;

Property ResInfBacilliNum1 As %String;

Property ResCulResNum11 As %String;

Property ResCulResNum12 As %String;

Property ResInfBacilliNum2 As %String;

Property ResCulResNum21 As %String;

Property ResCulResNum22 As %String;

Property ResPrognosisRes As %String;

Property ResBesesetDiag As %String;

Property ResTraLoc As %String;

Property ResForBed As %String;

Property ResResNo As %String;

Property ResResDate As %String;

Property ResResTime As %String;

Property ResRecNo As %String;

Property ResRecDate As %String;

Property ResRecTime As %String;

Property IsActive As %String;

Property Resume As %String;

Index ResDate On (ResResDate, ResCurrentWard, ResCurrentBed);

Storage Default
{
<Data name="DHCMedICUResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsActive</Value>
</Value>
<Value name="3">
<Value>ResBesesetDiag</Value>
</Value>
<Value name="4">
<Value>ResBloodInf</Value>
</Value>
<Value name="5">
<Value>ResCtlocNum</Value>
</Value>
<Value name="6">
<Value>ResCulResNum11</Value>
</Value>
<Value name="7">
<Value>ResCulResNum12</Value>
</Value>
<Value name="8">
<Value>ResCulResNum21</Value>
</Value>
<Value name="9">
<Value>ResCulResNum22</Value>
</Value>
<Value name="10">
<Value>ResCurrentBed</Value>
</Value>
<Value name="11">
<Value>ResDeepVeinPipe</Value>
</Value>
<Value name="12">
<Value>ResForBed</Value>
</Value>
<Value name="13">
<Value>ResInfBacilliNum1</Value>
</Value>
<Value name="14">
<Value>ResInfBacilliNum2</Value>
</Value>
<Value name="15">
<Value>ResInfNum</Value>
</Value>
<Value name="16">
<Value>ResPaadm</Value>
</Value>
<Value name="17">
<Value>ResPneuInf</Value>
</Value>
<Value name="18">
<Value>ResPrognosisRes</Value>
</Value>
<Value name="19">
<Value>ResRecDate</Value>
</Value>
<Value name="20">
<Value>ResRecNo</Value>
</Value>
<Value name="21">
<Value>ResRecTime</Value>
</Value>
<Value name="22">
<Value>ResResDate</Value>
</Value>
<Value name="23">
<Value>ResResNo</Value>
</Value>
<Value name="24">
<Value>ResResTime</Value>
</Value>
<Value name="25">
<Value>ResTopTemp</Value>
</Value>
<Value name="26">
<Value>ResTraLoc</Value>
</Value>
<Value name="27">
<Value>ResUrinaryInf</Value>
</Value>
<Value name="28">
<Value>ResUrinePipe</Value>
</Value>
<Value name="29">
<Value>ResWindPipeOrCut</Value>
</Value>
<Value name="30">
<Value>Resume</Value>
</Value>
<Value name="31">
<Value>ResCurrentWard</Value>
</Value>
</Data>
<DataLocation>^User.DHCMedICUResD</DataLocation>
<DefaultData>DHCMedICUResDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMedICUResD</IdLocation>
<IndexLocation>^User.DHCMedICUResI</IndexLocation>
<StreamLocation>^User.DHCMedICUResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
