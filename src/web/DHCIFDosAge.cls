Class web.DHCIFDosAge Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetDosAgeStatus(RowId, No) As %String
{
	s Dostatus=""
	q:(RowId'["||")||(RowId="")||(No="") "No"
	s oeordId=+RowId
	s chl=$P(RowId,"||",2)
	q:'$D(^OEORD(oeordId,"I",chl,"X",No)) "No"
	s ordStatCode=##Class(web.DHCIFComm).GetOrdStatCode(oeordId_"||"_chl) 
	q:ordStatCode="D" "Stop" 
	q:$p($g(^OEORD(oeordId,"I",chl,3)),"^",32)="Y" "ReturnStock"
	s DosRowId=$O(^User.DHCIFDosAgeI("Oeore"," "_RowId_"||"_No,""))
	q:DosRowId="" "UnExec"
	s Execstatus=$list(^User.DHCIFDosAgeD(DosRowId),4)
	q:Execstatus="Y" "OrdExec"  //医嘱已执行
	q:DosRowId'="" "Exec"  //已配置
	q 0
}

ClassMethod ExecDosAge(RowId, No, UserDr, CTLocId, Item) As %String
{
	s oeordId=+RowId
	s chl=$P(RowId,"||",2)
	s Episodeid=$P(^OEORD(oeordId),"^",1)
	s PapmiId=+^PAADM(Episodeid)
	s RegNo=$P(^PAPER(PapmiId,"PAT",1),"^",2) 
	s OeoreDr=RowId_"||"_No
	s DosDate=$P($h,",",1)
	s DosTime=$P($h,",",2)
	s parr="^"_Episodeid_"^"_OeoreDr_"^"_DosDate_"^"_DosTime_"^"_UserDr_"^"_"N"_"^"_RegNo
	s ret=##class(User.DHCIFDosAge).Save(parr)
    if (ret=0) d
    .s ret=..AdjustStock(OeoreDr,UserDr) //配液成功减库存
	.s rw="" f  s rw=$O(^User.DHCIFWorkItemD(rw)) q:rw=""  d
	..s typCode=$list(^User.DHCIFWorkItemD(rw),2)
	..q:typCode'=Item
	..d ##class(web.DHCIFWorkLoad).InsertWork(OeoreDr,rw,UserDr,CTLocId,"0")
    q ret
}

ClassMethod AdjustStock(oeoreId, userId) As %String
{
    //ypz 060602
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
    q:phlId="" -1
    s prtId=##class(DHCCLCom).GetPrtId(oeordId_"||"_oeoriSub)
    q:prtId="" -2
    s resStr=0
    s execFlag=$p(^DHCPHLOC(phlId),"^",7)
    i execFlag=1 d
        .//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
        .//s ordStatDesc=""
        .//i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
        .//i ordStatDesc["停止" s resStr="停止医嘱不执行!" q
        .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
        .i ordStatCode="D" s resStr="停止医嘱不执行!" q
        .s phwId=$o(^DHCPHWINi(phlId,""))
        .s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
        .s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
        .i phpId="" s resStr="你缺少药房人员身份!" q
        .s retStr=##class(web.DHCNurOPExec).InsertPHDisp(prtId,phlId,phwId,phpId,phpId,prescNo,"",oeoreId)
        .i retStr s resStr="插入发药记录错误!" q
        .
        .s retStr=##class(web.DHCNurOPExec).UpdatePyd("","",prtId, phlId, phpId, phpId,prescNo,"",oeoreId)
        .i retStr s resStr="减库存错误!" q
    i resStr=0 d
        .s oeoreSub=0,oeoreStatus="P"
		.f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
		    ..s dspSub=0
	    	..f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
	        	...i $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",6)="C" s oeoreStatus="C"
		.i oeoreStatus'="C" d
		    ..s $p(^OEORD(oeordId,"I",oeoriSub,6),"^",7)="1"
			..s retStr=##class(web.DHCOutPhDisp).collect(oeordId,oeoriSub)
			..i retStr s resStr="置发药状态错误!"
    q resStr
}

ClassMethod CancelDosAge(RowId, No, Item) As %String
{
	s OeoreDr=RowId_"||"_No
	s DosRowId=$O(^User.DHCIFDosAgeI("Oeore"," "_OeoreDr,""))
	q:DosRowId="" ""
	d ##class(User.DHCIFDosAge).%DeleteId(DosRowId)
	s rw="" f  s rw=$O(^User.DHCIFWorkItemD(rw)) q:rw=""  d
	.s typCode=$list(^User.DHCIFWorkItemD(rw),2)
	.q:typCode'=Item
	.d ##class(web.DHCIFWorkLoad).DeleteWork(OeoreDr,rw)
	q 0
}

ClassMethod GetDosAgeOrdItem(RowId, No) As %String
{
	s ArcRet=""
	s SeatNo=""
	s oeordId=+RowId
	s chl=$P(RowId,"||",2)
	s Episodeid=$P(^OEORD(oeordId),"^",1)
	s curWardId=$p($g(^PAADM(Episodeid)),"^",70)
	s Papmidr=$P(^PAADM(Episodeid),"^",1)
	s PatName=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
	s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	i RegNo'="" s SeatNo=##class(web.DHCIFComm).GetPatSeat(RegNo)
	s ArcRet=##class(web.DHCIFComm).getarcimDetail(oeordId,chl)
	if ArcRet'="" d
	.s DosRowId=$O(^User.DHCIFDosAgeI("Oeore"," "_RowId_"||"_No,""))
	.i DosRowId="" s ArcRet=ArcRet_"|"_"^"
	.e  d
	..s DosUserDr=$list(^User.DHCIFDosAgeD(DosRowId),8)
	..i DosUserDr'="" s UserName=$P(^SSU("SSUSR",DosUserDr),"^",2)
	..s ArcRet=ArcRet_"|"_$G(UserName)_"^"
	s curOriSub="" f  s curOriSub=$O(^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)) q:curOriSub=""  d
	.s ret=##class(web.DHCIFComm).getarcimDetail(oeordId,curOriSub)
	.if ret'="" d
	..s ret="___"_ret_"|"_$G(UserName)
	..s ArcRet=ArcRet_ret_"^"
	if ArcRet="" q:"No"
	if ArcRet'="" s ArcRet=RegNo_"&"_PatName_"&"_SeatNo_"&"_ArcRet
	q ArcRet
}

ClassMethod DosAgeDateTime(OeoreId As %String) As %String
{
	//取配液时间
	q:OeoreId="" ""
	s rw="" f  s rw=$O(^User.DHCIFDosAgeI("Oeore"," "_OeoreId,rw)) q:rw=""  d
	.s Date=$list(^User.DHCIFDosAgeD(rw),3) 
	.s Time=$list(^User.DHCIFDosAgeD(rw),7)
	.i (Date'="")&&(Time'="") s DateTime=$ZD(Date,3)_" "_$ZT(Time)
	q $G(DateTime)
}

ClassMethod ExecStatus(OeoreId As %String, flag As %String)
{
	q:OeoreId="" ""
	s DosRowId=$O(^User.DHCIFDosAgeI("Oeore"," "_OeoreId,""))
	q:DosRowId="" "UnDosAge" //未配置
	s a=##class(User.DHCIFDosAge).%OpenId(DosRowId)
	i flag="Exec" s a.DosAgeOeordStatus="Y"
	i flag="UnExec" s a.DosAgeOeordStatus="N" 
	d a.%Save()
	d a.%Close()
	q 0
}

ClassMethod IfPatUnExecOrd(RegNo As %String) As %String
{
	//判断病人是否有当日配置的要求三天内执行的医嘱
	//w ##class(web.DHCIFDosAge).IfPatUnExecOrd("03858186")
	q:RegNo="" 
	s ret="Y" //医嘱是否全部完成 Y:完成  N:未完成
	s papmiId=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),"")) 
 	q:papmiId=""
 	s EpisodeID="" f  s EpisodeID=$O(^PAPERdr(papmiId,"ADM","O",EpisodeID),-1) q:EpisodeID=""  d
    .s Oew=$O(^OEORD(0,"Adm",EpisodeID,""))
    .s OrdSub="" f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub)) q:OrdSub=""  d
    ..s ExceChl="" f  s ExceChl=$O(^OEORD(Oew,"I",OrdSub,"X",ExceChl)) q:ExceChl=""  d
    ...s OrdExecDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",1) //要求执行日期 
    ...q:(OrdExecDate<($h-2))||(OrdExecDate>+$h) //要求执行时间在三天内所有医嘱 
    ...s Oeore=Oew_"||"_OrdSub_"||"_ExceChl
    ...s rw="" f  s rw=$O(^User.DHCIFDosAgeI("Oeore"," "_Oeore,rw)) q:rw=""  d
    ....s ExecStatus=$list(^User.DHCIFDosAgeD(rw),4)
    ....q:ExecStatus="Y"
    ....s ExecDosAgeDate=$list(^User.DHCIFDosAgeD(rw),3)
    ....q:ExecDosAgeDate'=+$h 
    ....s ret="N" 
	q ret
}

}
