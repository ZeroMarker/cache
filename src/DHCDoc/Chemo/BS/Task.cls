/// CTOR: QP
/// DATE: 2020-06-26
/// DESC: 化疗单任务
Class DHCDoc.Chemo.BS.Task Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-26
/// DESC: 自动发送消息,凌晨任务,住院[当天的改一次，前两天确认一次]
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Apply).GMisOK("1||1")
ClassMethod AutoMsg() As %String
{
	S PLID=""
	S CDate=+$H
	S CompareDate=CDate+1
	f  s PLID=$O(^BS.DOC.Chemo.PlanD(PLID)) Q:PLID=""  D
	.S Status=$P(^BS.DOC.Chemo.PlanD(PLID),"^",7)
	.S EpisodeID=$P(^BS.DOC.Chemo.PlanD(PLID),"^",6)
	.S PAAdmType=$p(^PAADM(EpisodeID),"^",2)
	.Q:PAAdmType'="I"
	.Q:Status'="Y"
	.S EndDate=##class(DHCDoc.Chemo.COM.Func).GetPlanEndDate(PLID,"2")
	.Q:EndDate<CDate
	.S CStage=##class(DHCDoc.Chemo.COM.Func).GetPatStage(PLID)
	.S Sub=$O(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,CStage,""))
	.Q:Sub=""
	.S PSID=PLID_"||"_Sub
	.S PlanDateS=##class(DHCDoc.Chemo.BS.Apply).GetPLDateS(PSID,2)
	.Q:PlanDateS=""
	.F i=1:1:$l(PlanDateS,",") D
	.S Item=$p(PlanDateS,",",i)
	.Q:(Item<CompareDate)&&(Item'=CDate)
	.;todo 执行发送消息
	
	.s Msg="【广州泰和肿瘤医院】尊敬的XX先生/女士，您好。"
	.s Msg=Msg_"您已预约XXXX年XX月XX日，XX时XX分的化疗治疗。"
	.s Msg=Msg_"温馨提示：1）请您提前XX分钟于我院XX处报到。若迟到XX分钟，有可能等候时间较长或需改约；"
	.s Msg=Msg_"2）请携带有效身份证件、医保卡、商保卡、信用卡或现金；"
	.s Msg=Msg_"3）如需取消预约或改约，请至少于就诊前XX时致电或柜台办理。未按时报到将被视为爽约；"
	.s Msg=Msg_"4）若当月累计三次爽约，将会影响下次预约。广州泰和肿瘤医院地址：XXXX。联系电话：XXXXXXXXX。祝您生活愉快！"
	
	
	Q 1
}

}
