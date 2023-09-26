Class User.DHCANOPInterfaceForPortalDeptOperInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OperDetailsDeptOperInfo";

//20170223+dylForPortal

//当日安排手术间数

Property operUsedNum As %String(TRUNCATE = 1);

//当日空闲手术间数

Property operVacancyNum As %String(TRUNCATE = 1);

//当日已完成手术台数

Property operCompletedNum As %String(TRUNCATE = 1);

//当日已完成手术台数

Property operUnfinishedNum As %String(TRUNCATE = 1);

}
