Class User.DHCANOPInterfaceForPortalRoomStat Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OperDetailsRoomStat";

Property operTotalNum As %String(TRUNCATE = 1);

//当日安排手术间数

Property operUsedNum As %String(TRUNCATE = 1);

//当日空闲手术间数

Property operVacancyNum As %String(TRUNCATE = 1);

}
