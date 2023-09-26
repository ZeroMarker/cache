Class CHSSWeb.HISInterface.PersonOrganCheckRecordInfo Extends %Persistent
{

Property YearCheckRowId As %String;

Property LeftEyesight As %Float;

Property RightEyesight As %Float;

Property LeftCorrectEyesight As %Float;

Property RightCorrectEyesight As %Float;

Property Hearing As %String;

Property HearingId As %Integer;

Property Movement As %String;

Property MovementId As %Integer;

Property Skin As %String;

Property SkinId As %Integer;

Property Scrofula As %String;

Property ScrofulaId As %Integer;

Property ScrofulaOther As %String;

Property bBarrelChest As %String;

Property bBarrelChestId As %Integer;

Property BreathSounds As %String;

Property BreathSoundsInfo As %String;

Property Rale As %String;

Property RaleInfo As %String;

Property HeartRate As %Numeric;

Property CardiacRhythm As %String;

Property CardiacRhythmId As %Integer;

Property Souffle As %String;

Property SouffleInfo As %String;

Property Tenderness As %String;

Property TendernessInfo As %String;

Property EnclosedMass As %String;

Property EnclosedMassInfo As %String;

Property Hepatauxe As %String;

Property HepatauxeInfo As %String;

Property Splenomegaly As %String;

Property SplenomegalyInfo As %String;

Property ShiftingDullness As %String;

Property ShiftingDullnessInfo As %String;

Property EdemaOfLimbs As %String;

Property EdemaOfLimbsId As %Integer;

Property Anus As %String;

Property AnusId As %Integer;

Property AnusOther As %String;

Property Prostate As %String;

Property ProstateId As %Integer;

Property ProstateInfo As %String;

Property OrganOther As %String;

Property OralLips As %String;

Property Dentition As %String;

Property DentitionName As %String;

Property PharyngealCheck As %String;

Property VaginaInflammation As %String;

Property VaginaInflammationName As %String;

Property VaginaInflammationDes As %String;

Property Cervicitis As %String;

Property CervicitisName As %String;

Property CervicitisDes As %String;

Property DoubleWombs As %String;

Property DoubleWombsName As %String;

Property DoubleWombsDes As %String;

Property UterineFibroids As %String;

Property UterineFibroidsName As %String;

Property UterineFibroidsDes As %String;

Property AccessaryTumour As %String;

Property AccessaryTumourName As %String;

Property AccessaryTumourDes As %String;

Property Sclera As %String;

Property Galactophore As %String;

Storage Default
{
<Data name="PersonOrganCheckRecordInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AccessaryTumour</Value>
</Value>
<Value name="3">
<Value>AccessaryTumourDes</Value>
</Value>
<Value name="4">
<Value>AccessaryTumourName</Value>
</Value>
<Value name="5">
<Value>Anus</Value>
</Value>
<Value name="6">
<Value>AnusId</Value>
</Value>
<Value name="7">
<Value>AnusOther</Value>
</Value>
<Value name="8">
<Value>BreathSounds</Value>
</Value>
<Value name="9">
<Value>BreathSoundsInfo</Value>
</Value>
<Value name="10">
<Value>CardiacRhythm</Value>
</Value>
<Value name="11">
<Value>CardiacRhythmId</Value>
</Value>
<Value name="12">
<Value>Cervicitis</Value>
</Value>
<Value name="13">
<Value>CervicitisDes</Value>
</Value>
<Value name="14">
<Value>CervicitisName</Value>
</Value>
<Value name="15">
<Value>Dentition</Value>
</Value>
<Value name="16">
<Value>DentitionName</Value>
</Value>
<Value name="17">
<Value>DoubleWombs</Value>
</Value>
<Value name="18">
<Value>DoubleWombsDes</Value>
</Value>
<Value name="19">
<Value>DoubleWombsName</Value>
</Value>
<Value name="20">
<Value>EdemaOfLimbs</Value>
</Value>
<Value name="21">
<Value>EdemaOfLimbsId</Value>
</Value>
<Value name="22">
<Value>EnclosedMass</Value>
</Value>
<Value name="23">
<Value>EnclosedMassInfo</Value>
</Value>
<Value name="24">
<Value>Galactophore</Value>
</Value>
<Value name="25">
<Value>Hearing</Value>
</Value>
<Value name="26">
<Value>HearingId</Value>
</Value>
<Value name="27">
<Value>HeartRate</Value>
</Value>
<Value name="28">
<Value>Hepatauxe</Value>
</Value>
<Value name="29">
<Value>HepatauxeInfo</Value>
</Value>
<Value name="30">
<Value>LeftCorrectEyesight</Value>
</Value>
<Value name="31">
<Value>Movement</Value>
</Value>
<Value name="32">
<Value>MovementId</Value>
</Value>
<Value name="33">
<Value>OralLips</Value>
</Value>
<Value name="34">
<Value>OrganOther</Value>
</Value>
<Value name="35">
<Value>PharyngealCheck</Value>
</Value>
<Value name="36">
<Value>Prostate</Value>
</Value>
<Value name="37">
<Value>ProstateId</Value>
</Value>
<Value name="38">
<Value>ProstateInfo</Value>
</Value>
<Value name="39">
<Value>Rale</Value>
</Value>
<Value name="40">
<Value>RaleInfo</Value>
</Value>
<Value name="41">
<Value>RightCorrectEyesight</Value>
</Value>
<Value name="42">
<Value>RightEyesight</Value>
</Value>
<Value name="43">
<Value>Sclera</Value>
</Value>
<Value name="44">
<Value>Scrofula</Value>
</Value>
<Value name="45">
<Value>ScrofulaId</Value>
</Value>
<Value name="46">
<Value>ScrofulaOther</Value>
</Value>
<Value name="47">
<Value>ShiftingDullness</Value>
</Value>
<Value name="48">
<Value>ShiftingDullnessInfo</Value>
</Value>
<Value name="49">
<Value>Skin</Value>
</Value>
<Value name="50">
<Value>SkinId</Value>
</Value>
<Value name="51">
<Value>Souffle</Value>
</Value>
<Value name="52">
<Value>SouffleInfo</Value>
</Value>
<Value name="53">
<Value>Splenomegaly</Value>
</Value>
<Value name="54">
<Value>SplenomegalyInfo</Value>
</Value>
<Value name="55">
<Value>Tenderness</Value>
</Value>
<Value name="56">
<Value>TendernessInfo</Value>
</Value>
<Value name="57">
<Value>UterineFibroids</Value>
</Value>
<Value name="58">
<Value>UterineFibroidsDes</Value>
</Value>
<Value name="59">
<Value>UterineFibroidsName</Value>
</Value>
<Value name="60">
<Value>VaginaInflammation</Value>
</Value>
<Value name="61">
<Value>VaginaInflammationDes</Value>
</Value>
<Value name="62">
<Value>VaginaInflammationName</Value>
</Value>
<Value name="63">
<Value>YearCheckRowId</Value>
</Value>
<Value name="64">
<Value>bBarrelChest</Value>
</Value>
<Value name="65">
<Value>bBarrelChestId</Value>
</Value>
<Value name="66">
<Value>LeftEyesight</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonOrganCA37D</DataLocation>
<DefaultData>PersonOrganCheckRecordInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonOrganCA37D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonOrganCA37I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonOrganCA37S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
