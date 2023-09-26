/// 护士执行界面扩展类
Class web.DHCNurOPExecExt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// description 门诊输液厅打印病人信息卡获取病人信息使用
/// property RegNo：登记号 AdmId：就诊ID(传入为在执行界面排队打印,不传为在座位图打印) LocId：登陆科室
/// 安排座位号是用最后一次就诊ID,可能存在不正确情况。插入队列的就诊ID根据医嘱取,队列的就诊号正确,
ClassMethod getPatInfo(RegNo As %String, AdmId As %String, LocId As %String)
{
	n (RegNo,AdmId,LocId)
	q:LocId="" "-1^传入科室为空"
	s LocType=$p(^CTLOC(LocId),"^",13)
	;i LocType="EM" s AdmType="E"
	;e  s AdmType="O"
	s PAPMI=$O(^PAPERi("PAPMI_PatNo",$$$ALPHAUP(RegNo),""))
	q:PAPMI="" "-2^没有找到病人信息"
	//安排座位先取门诊最后一次，若无门诊则为急诊最后一次
	s EpisodeIDO=$O(^PAPERdr(PAPMI,"ADM","O",""),-1)
	s:EpisodeIDO="" EpisodeIDO=0
	s EpisodeIDE=$O(^PAPERdr(PAPMI,"ADM","E",""),-1) //add by linyuxu
	s:EpisodeIDE="" EpisodeIDE=0
	s seatAdmId=""
	i EpisodeIDO>EpisodeIDE s seatAdmId=EpisodeIDO
	e  s seatAdmId=EpisodeIDE
	s treatAdmId=seatAdmId
	/*if AdmId=""
	{
		s tempAdmId="" f  s tempAdmId=$O(^PAPERdr(PAPMI,"ADM","O",tempAdmId),-1) q:(tempAdmId="")!(treatAdmId'="")  d
		.s treatId="" f  s treatId=$O(^User.DHCNurTreatQueueI("Adm"," "_tempAdmId,treatId)) q:(treatId="")!(treatAdmId'="")  d
		..s treatObj=##class(User.DHCNurTreatQueue).%OpenId(treatId)
		..s treatStatus=treatObj.TreatQueState
		..s treatLocId=treatObj.TreatLocDr
		..i (treatLocId=LocId)&(treatStatus'="Finish") s treatAdmId=tempAdmId
	}
	else 
	{
		s treatAdmId=AdmId
	}*/
	
	s PatName=$p(^PAPER(PAPMI,"ALL"),"^",1)
	s PatSex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMI,"ALL")),"^",7))),"^",2)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMI,AdmId)
	
	i +PatAge>13 s PatAgeLevel="成人"
	e  s PatAgeLevel="儿童"
	//取座位号
	s PatSeatNo=""
	i seatAdmId'="" d
	.s SyPatRec=$O(^User.DHCNurSyPatRecI("patseatStatus"," "_LocId," "_seatAdmId," Y",""))
	.i SyPatRec'="" d
	..s obj=##class(User.DHCNurSyPatRec).%OpenId(SyPatRec)
	..s SeatDr=obj.SySeatDr
	..i SeatDr'="" d
	...s objSeat=##class(User.DHCNurSySeat).%OpenId(SeatDr)
	...s PatSeatNo=objSeat.SySeatCode
	i PatSeatNo="" d
	.s seatAdmId=""
	.f  s seatAdmId=$o(^PAPERdr(PAPMI,"ADM","O",seatAdmId),-1) q:(seatAdmId="")!(PatSeatNo'="")  d
	..s SyPatRec=$O(^User.DHCNurSyPatRecI("patseatStatus"," "_LocId," "_seatAdmId," Y",""))
	..q:SyPatRec=""
	..s obj=##class(User.DHCNurSyPatRec).%OpenId(SyPatRec)
	..s SeatDr=obj.SySeatDr
	..q:SeatDr=""
	..s objSeat=##class(User.DHCNurSySeat).%OpenId(SeatDr)
	..s PatSeatNo=objSeat.SySeatCode
	.q:PatSeatNo'=""
	.s seatAdmId=""
	.f  s seatAdmId=$o(^PAPERdr(PAPMI,"ADM","E",seatAdmId),-1) q:(seatAdmId="")!(PatSeatNo'="")  d
	..s SyPatRec=$O(^User.DHCNurSyPatRecI("patseatStatus"," "_LocId," "_seatAdmId," Y",""))
	..q:SyPatRec=""
	..s obj=##class(User.DHCNurSyPatRec).%OpenId(SyPatRec)
	..s SeatDr=obj.SySeatDr
	..q:SeatDr=""
	..s objSeat=##class(User.DHCNurSySeat).%OpenId(SeatDr)
	..s PatSeatNo=objSeat.SySeatCode
	s PrintDateTime=$Zd(+$h,3)_" "_$zt($p($h,",",2),2)
	i treatAdmId'="" d
	.s TreatQueueID=$O(^User.DHCNurTreatQueueI("AdmDate"," "_treatAdmId,+$h,""),-1)
	.i TreatQueueID'="" d
	..s QueueObj=##class(User.DHCNurTreatQueue).%OpenId(TreatQueueID)
	..s TreatQueueNo=QueueObj.TreatQueNo_"号"
	s ret="REGNO@"_$$$ALPHAUP(RegNo)_"^SEX@"_PatSex_"^AGE@"_PatAge_"^PATNAME@"_PatName_"^SEAT@"_$g(PatSeatNo)_"^QUEUENO@"_$g(TreatQueueNo)_"^PRINTDATETIME@"_PrintDateTime_"^AGELEVEL@"_$g(PatAgeLevel)
	s ret=ret_"^REGNOEXT@"_$$$ALPHAUP("REG"_RegNo)           ; add by ljk 2016-04-21 条码区分登记号
	q ret
}

}
