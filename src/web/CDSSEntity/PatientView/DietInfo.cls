/// 临床决策支持-患者饮食信息
Class web.CDSSEntity.PatientView.DietInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.DietInfo";

Property DietID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property GroupFlag As %String;

Property GroupSequence As %String;

Property DietMethod As %String;

Property DietType As %String;

Property DietContent As %String;

Property DietAmount As %String;

Property DietInstructions As %String;

Property Duration As %String;

Property StartTime As %String;

Property EndTime As %String;

Property PassFlag As %String;

}
