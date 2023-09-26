Class User.DHCANOPInterfaceForPortalOperDetails Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OperationDetails";

//20161227+dylForPortal+1

Property operId As %String(TRUNCATE = 1);

//状态+2

Property operState As %String(TRUNCATE = 1);

//name+3

Property name As %String(TRUNCATE = 1);

//年龄+4

Property age As %String(TRUNCATE = 1);

//性别+5

Property sex As %String(TRUNCATE = 1);

//床号+6

Property bedNo As %String(TRUNCATE = 1);

//病案号+7

Property medicalNo As %String(TRUNCATE = 1);

//术前诊断+8

Property diagnosis As %String(TRUNCATE = 1);

//手术名称+9

Property operName As %String(TRUNCATE = 1);

//申请科室+10

Property operDep As %String(TRUNCATE = 1);

//主刀+11

Property surgeonName As %String(TRUNCATE = 1);

//一助+12

Property firstAssistantName As %String(TRUNCATE = 1);

//二助+13

Property secondAssistantName As %String(TRUNCATE = 1);

//麻醉师+14

Property anesthesiaName As %String(TRUNCATE = 1);

//护士名称+15

Property nurseName As %String(TRUNCATE = 1);

//预约时间+16

Property appointTime As %String(TRUNCATE = 1);

//实际开始+17

Property startTime As %String(TRUNCATE = 1);

//实际结束+18

Property endTime As %String(TRUNCATE = 1);

//手术日期+19

Property OpDate As %String(TRUNCATE = 1);

}
