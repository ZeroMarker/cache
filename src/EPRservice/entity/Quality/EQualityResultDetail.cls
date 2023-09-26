Class EPRservice.entity.Quality.EQualityResultDetail Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property TheResult As %String(TRUNCATE = 1);

Property EntryDR As %String(TRUNCATE = 1);

Property TriggerNumber As %Integer;

Property TriggerDate As %String(TRUNCATE = 1);

Property OneScore As %Library.Float;

Property AssignerDR As %String(TRUNCATE = 1);

Property AssignLocDR As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Property ResumeText As %String(TRUNCATE = 1);

}
