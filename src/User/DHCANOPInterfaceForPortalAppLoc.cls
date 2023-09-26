Class User.DHCANOPInterfaceForPortalAppLoc Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OperDetailsByAppLoc";

//20161227+dylForPortal+1

Property operId As %String(TRUNCATE = 1);

//name+2

Property name As %String(TRUNCATE = 1);

//年龄+3

Property age As %String(TRUNCATE = 1);

//性别+4

Property sex As %String(TRUNCATE = 1);

//申请科室+5

Property operDep As %String(TRUNCATE = 1);

//主刀+6

Property surgeonName As %String(TRUNCATE = 1);

//手术日期+7

Property OpDate As %String(TRUNCATE = 1);

//展示情况+8

Property type As %String(TRUNCATE = 1);

//总共多少台手术/全院开放手术间数+9

Property operTotalNum As %String(TRUNCATE = 1);

//手术台次+10

Property operNum As %String(TRUNCATE = 1);

//手术间、手术科室id+11

Property operRoomId As %String(TRUNCATE = 1);

//手术间描述+12

Property operRoomDesc As %String(TRUNCATE = 1);

}
