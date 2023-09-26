Class web.DHCDocCardioExam Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

//1.HIS系统的病人ID（HIS的唯一索引）   id

Property HisPatientID As %String;

//2.HIS系统提供的唯一检查号（医嘱号）  

Property HisExamID As %String;

//3.住院号															

Property InHospitalID As %String;

//4.诊疗号														

Property TreadID As %String;

//5.就诊类别，分为住院、门诊、急诊、体检

Property TreadType As %String;

//6.病区，大部分情况等于申请科室（ApplyDept）   

Property Location As %String;

//7.住院床位号					

Property BedNo As %String;

//8.病人姓名

Property Name As %String;

//9.出生日期（Date）

Property Birthday As %String;

//10.性别

Property Gender As %String;

//11.身高															

Property Height As %String;

//12.体重														

Property Weight As %String;

//13.种族									

Property Race As %String;

//14.民族										

Property Folk As %String;

//15.身份证号

Property IDNo As %String;

//16.永久通讯地址

Property MailingAddress As %String;

//17.对应通讯地址的邮政编码

Property ZipCode As %String;

//18.家庭电话号码

Property PhoneNumberHome As %String;

//19.移动电话号码

Property PhoneNumberMobile As %String;

//20.心电检查类型						

Property SpiritTestType As %String;

//21.申请医生ID

Property ApplyDoctID As %String;

//22.申请医生姓名

Property ApplyDoctName As %String;

//23.申请科室

Property ApplyDept As %String;

}
