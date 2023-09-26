Import SQLUser

/// Creator: 	qqa
/// CreateDate: 2016-06-20
/// Descript: 	新产品图标定义
Class web.DHCEMNurExecImg Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 判断是否有新医嘱
/// OrdPriorityFlag=1:表示当有[即刻医嘱]未执行返回 1 ，有其他优先级医嘱返回为0
/// OrdPriorityFlag=2:表示当有除[即刻医嘱]未执行返回 1 ，有[即刻医嘱]未执行返回 0
/// 检验医嘱打印过就不提示,其他医嘱执行过不提示
/// OEC_Priority:表中 rowid=1 表示即刻医嘱
ClassMethod IfNewOrdItem(AdmNo, OrdPriorityFlag, Flag = 0) As %String
{
 	n (AdmNo,OrdPriorityFlag,Flag)
	q:$g(AdmNo)="" 0
	s amdType=$p($G(^PAADM(AdmNo)),"^",2)
	q:$g(amdType)="I" 0
	s oeordId=$o(^OEORD(0,"Adm",AdmNo,""))
	q:oeordId="" 0
	s ret=0
	s fl=0
	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime)) q:(ordSttTime="")!(fl=1)  d
	.s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub)) q:(oeoriSub="")!(fl=1)  d
	..q:'$d(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub,1))
	..q:'$d(^OEORD(oeordId,"I",oeoriSub,"X",1))
	..s ItemStatDR=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
	..s ordtyp=##Class(web.DHCSETIMAGE).GetOrdItemTyp(oeordId,oeoriSub)
	..s printflag=""
	..;if ordtyp="L" d
	..s printflag=##Class(web.DHCSETIMAGE).getprintflag(oeordId,oeoriSub,1)
	..;q:$G(printflag)'=""
	..s PriorDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)     ;OEC_Priority
	..q:ItemStatDR'=1
	..s catdesc=##Class(web.DHCSETIMAGE).GetOrdCat(oeordId, oeoriSub)
	..;q:(catdesc="材料(收费)")!(catdesc="普通项目")
	..s arcimDr=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) 
	..s ItemCatDR=$P($G(^ARCIM(+arcimDr,1,1)),"^",10)
	..s ItemCatDRStr="^"_ItemCatDR_"^" 
	..q:$G(^DHCOEOrdPrintSet("NotSordCat"))[ItemCatDRStr&($G(^DHCOEOrdPrintSet("NotSordCat"))'="")
	..s cptype=""
	..i $d(^OEORD(oeordId,"I",oeoriSub,7)) d
	... s adduser=$p(^OEORD(oeordId,"I",oeoriSub,7),"^",1)
	... q:adduser=""
	... i $d(^SSU("SSUSR",adduser)) s cpdr=$p(^SSU("SSUSR",adduser),"^",14) 
	... q:$g(cpdr)=""
	... i $d(^CTPCP(cpdr,1)) s cptypedr=$p(^CTPCP(cpdr,1),"^",4)
	... i $d(^CT("CPT",cptypedr)) s cptype=$p(^CT("CPT",cptypedr),"^",4)
	..q:cptype="NURSE"
	..s retul=##Class(web.DHCSETIMAGE).getloc(oeordId,oeoriSub)
	..q:retul=""
	..s seeInfo=##class(web.DHCLCNUREXCUTE).GetSeeOrdInfo(oeordId,oeoriSub)
	..q:(seeInfo'="^^")&($g(Flag)=1)
	..s ech="" 
	..s thisexec=0       ;先定此医嘱未被执行
	..s flag=0
	..s execdate=$p(^OEORD(oeordId,"I",oeoriSub,"X",1),"^",19)   ;执行日期
	..s execcp=$p(^OEORD(oeordId,"I",oeoriSub,"X",1),"^",15)     ;执行人
	..i (execdate'="")&(execcp'="") d
	...s thisexec=1   ;此医嘱已经被执行  
	..i ( (thisexec=0) &&($g(PriorDR)=1)&& (OrdPriorityFlag=1))  d
	... s ret=1
	..i ( (thisexec=0) &&(($g(PriorDR)=5)||($g(PriorDR)=8))&& (OrdPriorityFlag=3))  d
	... s ret=1
	..i ( (thisexec=0) &&(($g(PriorDR)'=1)&&($g(PriorDR)'=5)&&($g(PriorDR)'=8))&& (OrdPriorityFlag=2))  d
	... s ret=1 
	..;i ( (thisexec=0) &&($g(PriorDR)=1)&& ((OrdPriorityFlag=2)||(OrdPriorityFlag=3)))  d
	...; s ret=0
	...; s fl=1
	q ret
}

/// 病人当前状态是否是死亡状态  1:是，0:否
ClassMethod GetPatIsDeath(EpisodeID)
{
	n (EpisodeID)
	s Ret = 0
	i EpisodeID="" q Ret
	;s AvsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	;q:AvsId="" ""
	;s PvsId=$P(^DHCADMVisitStatus(AvsId),"^",2)
   	;s StatusDesc = $P(^DHCPACVisitStatus(PvsId),"^",1,2)
   	;s:StatusDesc["死亡" Ret=1
   	
   	s PatientID = $P(^PAADM(EpisodeID),"^",1)
   	s Deceased = $p(^PAPER(PatientID,"ALL"),"^",12)
   	s:Deceased="Y" Ret=1
   	q Ret
}

}
