Class DHCINSU.Model.BJ.INSUMedicatalog Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "medicatalog";

Property medicine As %String;

Property tmedicine As %String;

Property therb As %String;

Property labexam As %String;

Property xray As %String;

Property ultrasonic As %String;

Property ct As %String;

Property mri As %String;

Property examine As %String;

Property treatment As %String;

Property material As %String;

Property operation As %String;

Property oxygen As %String;

Property bloodt As %String;

Property orthodontics As %String;

Property prosthesis As %String;

Property forensicexpertise As %String(XMLNAME = "forensic_expertise");

Property other As %String;

}
