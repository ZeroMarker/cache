/// Created by SongDeBo 2006/6/13
/// Description: 访问CRM系统的接口, 根据此接口实现其他需要入口
Class web.DHCPE.CRM.IGateway Extends %RegisteredObject [ Abstract, ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// 获取用户信息
/// return: ...$C(1)patId^patName^Birthday^mobileNO^Address^corporator^CertCardNO^Gender^level
/// 				^Marital^Email^Zip^BloodType^Profession^Title^Race$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILE”, "PATNAME"
/// 		QueryValue: 具体的查询值
ClassMethod GetMemberByID(QueryType, QueryValue) As %String [ Abstract ]
{
}

/// 获取用户体检登记记录
/// return: ***$C(1)RegID^PatCardId^PreRegDate^RecordDate^IsAsCharged^Status^CountAmount^DiscountAmount^FinalAmount^PatNAME$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“HISCARDID”，“MID”、“CERTID”, “MOBILENO”,"REGID","PATNAME"
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。
ClassMethod GetRegListByPatInf(QueryType, QueryValue, Flag) As %String [ Abstract ]
{
}

/// 获取个人体检项目明细
/// return: ***$C(1)ItemID^DepID^Quantity^crmOItemID$C(1)...
/// param:
/// 		RegId
ClassMethod GetExamItemsByRegId(RegId) As %String [ Abstract ]
{
}

/// 获取团体的预约信息
/// return: ***$C(1)GroupID^GroupRegId^GroupName^PreRegDate^RecordDate^DiscountLevel^Status^CountAmount^DiscountAmount^FinalAmount$C(1)...
/// param:
/// 		QueryType: paraValue的类型,“GROUPID”，“GROUPNAME”、“GRPREGID”
/// 		QueryValue: 具体的查询值
/// 		Flag:"ALL"-客人的所有记录;  "UNCOMPLETED"-客人未结束的体检预约记录，包括进行中和未开始的。
ClassMethod GetGrpRegList(QueryType, QueryValue, Flag) As %String [ Abstract ]
{
}

/// 获取团体的分组信息
/// return: ***$C(1)GroupRegId^SmallGroupId^SmallGroupName$C(1)...
/// param:
/// 		GroupId 
ClassMethod GetSmallGrpByGrpRegId(GRegId) As %String [ Abstract ]
{
}

/// 获取团体的个人信息
/// return: ***$C(1)GroupRegId^SmallGroupId^AdmId$C(1)...
/// param:
/// 		CertNo 
ClassMethod GetMemberListByGrpRegId(GroupRegId) As %String [ Abstract ]
{
}

/// 体检过程变更通知, 由his通知CRM系统
/// return: “OK”  成功;  “ERROR: XXX” 失败
/// param:
/// 		RegType: RegId的类型，"PERSON"-个人　"GROUP"-团体 
/// 		RegId: 个人或团体的RegId(AdmId)
/// 		NewStatus: 新状态 %String ：PREREG-预挂号;REGISTERED-登记;ARRIVED-到达;CHARGED-收费;COMPLETED-完成(报告完成)
/// 		AddtionInfo: 附加信息.一般情况下为""
ClassMethod ExamStatusNotify(RegType, RegId, NewStatus, AddtionInfo) As %String [ Abstract ]
{
}

/// 按会员卡缴费
/// return: “OK”  成功;  “ERROR: XXX” 失败
/// param: 
/// 		PatCardId: 个人的卡号(即登记号), 团体为空
/// 		MemberCardNo: 会员卡卡号
/// 		Amount: 要扣的钱数
ClassMethod Discharge(PatCardId, MemberCardNO, Amount) As %String
{
}

ClassMethod test()
{
	W !,"<--TEST-->",..GetRegListByPatInf("HISCARDID","101","ALL")
	W !,"<--TEST-->",..GetMemberByID("HISCARDID","101")
	W !,"<--TEST-->",..GetExamItemsByRegId("101")
	W !,"<--TEST-->",..GetGrpRegList("GROUPNAME","FISHJUMPING")
	W !,"<--TEST-->",..GetSmallGrpByGrpRegId("FISHJUMPING")
	W !,"<--TEST-->",..GetMemberListByGrpRegId("FISHJUMPING")
	W !,"<--TEST-->",..ExamStatusNotify("101","ARRIVED")
}

}
