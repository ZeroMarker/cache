/// 药品业务表 年龄限制维护 
Class web.Entity.KB.DHCPHDiseaseAge Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseAge";

Property PDARowId As %String;

Property PDAInstDr As %String;

Property PDAAgeDr As %String;

Property PDAMinVal As %String;

Property PDAMaxVal As %String;

Property PDAUomDr As %String;

}
