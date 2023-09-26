Class DHCCPMWeb.CPMSevice.entity.DHCERepPanels Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property RPCaption As %String(TRUNCATE = 1);

Property RPName As %String(TRUNCATE = 1);

Property ShowPackageInfo As %String(TRUNCATE = 1);

Property ParRef As %String(TRUNCATE = 1);

Property RPClassName As %String(TRUNCATE = 1);

Property RPQueryName As %String(TRUNCATE = 1);

Property RPType As %String(TRUNCATE = 1);

Property RepFields As list Of DHCERepFields;

Property RepParameters As list Of DHCERepParameters;

Property RowID As %String(TRUNCATE = 1);

}
