/// 临床决策支持-家族史信息
Class web.CDSSEntity.PatientView.FamilyHisInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.FamilyHisInfo";

Property FamilyHisID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property Relationship As %String;

Property RelativeName As %String;

Property GeneticDiseNo As %String;

Property GeneticDiseName As %String;

Property ConditionDescription As %String;

Property StartTime As %String;

Property EndTime As %String;

Property Duration As %String;

Property Criticality As %String;

Property IsCure As %String;

Property Remarks As %String;

Property PassFlag As %String;

}
