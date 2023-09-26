Class web.DHCOutPhSendMeg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLNAME = "Pharmacy";

//Pharmacy 药房名称

Property Pharmacy As %String(TRUNCATE = 1);

//PrtDate 收费日期 格式为：yyyy-MM-dd

Property PrtDate As %String(TRUNCATE = 1);

//登记号

Property PatNo As %String(TRUNCATE = 1);

//姓名

Property PatName As %String(TRUNCATE = 1);

//性别

Property PatSex As %String(TRUNCATE = 1);

//年龄

Property PatAge As %String(TRUNCATE = 1);

//病人类型

Property PatType As %String(TRUNCATE = 1);

//处方号

Property PrescNo As %String(TRUNCATE = 1);

//处方类型

Property PrescType As %String(TRUNCATE = 1);

//就诊科室

Property PatAdmLoc As %String(TRUNCATE = 1);

//开方医生

Property PatDoctor As %String(TRUNCATE = 1);

//发药人员

Property Chemist As %String(TRUNCATE = 1);

//收费人员

Property Cashier As %String(TRUNCATE = 1);

//收据号

Property BillNo As %String(TRUNCATE = 1);

//DispDate 发药日期 格式为：yyyy-MM-dd

Property DispDate As %String(TRUNCATE = 1);

//发退药明细

Property PhInformation As list Of web.DHCOutPhSendMegSub(XMLITEMNAME = "");

}
