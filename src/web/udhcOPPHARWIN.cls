Import SQLUser

Class web.udhcOPPHARWIN Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取窗口的渠道--0：his自己分配窗口,1:第三方摆药机分配窗口
Parameter PHWINCHANNEL = 0;

/// 更新门诊药房的数据接口?
ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_PHARWIN WHERE PHA_ROWID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_PHARWIN Values PLIST())
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod InsertNewInv(OldINVRID As %String, NewINVRID As %String) As %String
{
	;w ##class(web.udhcOPPHARWIN).InsertNewInv("358","360")
	;^DHCPHARi("PRT",{PHA_PRT_DR},{PHA_ROWID})
	
	q:$d(^DHCPHARi("PRT",OldINVRID))=0 0
	s myrid=0
	s rtn=0
	f  s myrid=$o(^DHCPHARi("PRT",OldINVRID,myrid)) q:((myrid="")!(rtn='0))  d
	.s nouseflag=$p($g(^DHCPHARW(myrid)),"^",7)
	.s myoutflag=$p($g(^DHCPHARW(myrid)),"^",6)
	.q:myoutflag=1 //已经发药完成
	.s phl=$p($g(^DHCPHARW(myrid)),"^",3)
	.s phw=$p($g(^DHCPHARW(myrid)),"^",4)
	.s status=$p($g(^DHCPHARW(myrid)),"^",35)
	.s startPyFlag=$p($g(^DHCPHARW(myrid)),"^",36)
	.s rtv=0
	.i nouseflag=1 d
	..s rtn=##class(web.DHCMZYFXTYW02).UpdCurrWinWork(phl,phw,-1)
	..q:rtn'=0
	..s ret=..CheckOrdState(myrid)
	..q:ret=1
	..
	..s Prescno=$p($g(^DHCPHARW(myrid)),"^",16)
	..s PartRefund=##Class(web.DHCBillInterface).IIsPartialRefund(OldINVRID,NewINVRID,Prescno) //0:处方没有变化或此发票上未找到指定的处方. 1:处方发生变化
	..i PartRefund=1 d
	...s rtn=..SELECT(myrid)
	...q:rtn'=0
	...k PLIST(8)				;;->PHA_NOUSER
	...k PLIST(9)				;;->PHA_printflag by tang 20060824
	...k PLIST(11)				;;->PHA_printdate by tang 20060824
	...s PLIST(2)=NewINVRID		;->PHA_PRT_DR
	...s PLIST(3)=+$h			;->PHA_DATE
	...s PLIST(4)=$p($h,",",2)	;->PHA_TIME
	...s PLIST(36)=status		;->PHA_Status
	...s PLIST(37)=startPyFlag	;->PHA_StartPyFlag
	...s PLIST(39)=+$h			;->PHA_LastDate
	...s PLIST(40)=$p($h,",",2) ;->PHA_LastTime
	...s rtn=..INSERT()
	...q:rtn'=0
	...s rtn=##class(web.DHCMZYFXTYW02).UpdCurrWinWork(phl,phw,1)
	...q:rtn'=0
	..e  d
	...s rtn=..UpdPhInv(myrid,NewINVRID)
	...q:rtn'=0
	...&sql(update DHC_PHARWIN set PHA_NOUSER=0,PHA_PRT_DR=:NewINVRID where PHA_ROWID=:myrid)
	quit rtn	;
}

/// 部分退费时判断该处方是否所有医嘱都已停止 liangqiang
/// 1 全停  0 未全
ClassMethod CheckOrdState(phar) As %String
{
	s prescNo=$p($g(^DHCPHARW(phar)),"^",16)
	s phl=$p($g(^DHCPHARW(phar)),"^",3)
	s phlocdr=$p(^DHCPHLOC(phl),"^",1)
	s retflag=1
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescNo,ord)) q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescNo,ord,chl) ) q:chl=""  d
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态 
    ..q:oeflag="D"  
    ..q:(oeflag'="V")&(oeflag'="E")
    ..s reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
    ..q:reclocdr'=phlocdr
    ..s retflag=0
    q retflag
}

ClassMethod ReadRefundQty(INVRowID As %String = "", OEORIRowID As %String = "") As %String
{
	;;w ##class(web.udhcOPPHARWIN).ReadRefundQty("348","1877||2")
	;退出系统
	;^DHCPHRETi("NEWPRT",{PHRET_NEWPRT_DR},{PHRET_PHL_DR},{PHRET_ROWID})
	;没有办理过退药
	q:($d(^DHCPHRETi("NEWPRT",INVRowID))=0) 0
	s refundQty=0
	
	;办理过退药?
	s PhLocrid=0
	f  s PhLocrid=$o(^DHCPHRETi("NEWPRT",INVRowID,PhLocrid)) q:(PhLocrid="")  d
	.s RetRID=0
	.f  s RetRID=$o(^DHCPHRETi("NEWPRT",INVRowID,PhLocrid,RetRID)) q:(RetRID="")  d
	..;^DHCPHRTI({DHC_PHRETURN.PHRET_ROWID},"RTI",{PHRTI_CHILDSUB})
	..s RetSubRID=0
	..f  s RetSubRID=$o(^DHCPHRTI(RetRID,"RTI",RetSubRID)) q:(RetSubRID="")  d
	...s myOERid=$p(^DHCPHRTI(RetRID,"RTI",RetSubRID),"^",2)
	...b  ;
	...i OEORIRowID=myOERid d
	....s refundQty=+refundQty+$p($g(^DHCPHRTI(RetRID,"RTI",RetSubRID)),"^",3)
	
	;s ^TMPRefund="Out"
	
	quit refundQty
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_PHARWIN WHERE PHA_ROWID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod UPDATE(RowId)
{
	;
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_PHARWIN VALUES PLIST() WHERE PHA_ROWID= :RowId)
	d ..tc()
	q SQLCODE
	;
	;i 'SQLCODE q ..SELECT(%ROWID)
	;q $$code^SSUTILSQ(SQLCODE)
	;
}

/// 通过第三方接口获取发药窗口
/// w ##class(web.udhcOPPHARWIN).UpdatePHWINV(1017535,"")
ClassMethod UpdatePHWINVOLD(INVRowIdStr As %String, ExpStr As %String) As %String
{
	n (INVRowIdStr, ExpStr)
	s myrid=0
	s rtn=0
	s prescNoStr=""
	s myLen=$l(INVRowIdStr,"^")
	f myIdx=1:1:myLen  d
	.s myPRTRowID=$p(INVRowIdStr,"^", myIdx)
	.q:(myPRTRowID="")
	.q:(+myPRTRowID=0)
	.s myFlag=$p(^DHCINVPRT(myPRTRowID),"^", 8)
	.q:(myFlag'="N")
	.;^DHCPHARi("PRT",{PHA_PRT_DR},{PHA_ROWID})
	.s myrid=0
	.f  s myrid=$o(^DHCPHARi("PRT",myPRTRowID,myrid)) q:((myrid=""))  d
	..s myPresno=$p(^DHCPHARW(myrid),"^",16)
	..i prescNoStr="" s prescNoStr=myPresno
	..e  s prescNoStr=prescNoStr_$c(1)_myPresno
	;
	;调用药房接口
	k WinAry("Window",$j)
	;i INVRowIdStr'="" s ^LidPhWinFromManf("PHWIN",INVRowIdStr,1)=prescNoStr
	s AllRetWin=##class(web.DHCMZYFXTYW02).GetPhWinFromManf(prescNoStr)
	;i INVRowIdStr'="" s ^LidPhWinFromManf("PHWIN",INVRowIdStr,2)=AllRetWin
	f i=1:1:$l(AllRetWin,$c(1)) d
	.s tmp=$p(AllRetWin,$c(1),i)
	.q:tmp=""
	.s myPresno=$p(tmp,"^",4)
	.q:myPresno=""
	.s WinAry("Window",$j,myPresno)=tmp
	;
	;更新发药窗口表
	s myLen=$l(INVRowIdStr,"^")
	f myIdx=1:1:myLen  d
	.s myPRTRowID=$p(INVRowIdStr,"^", myIdx)
	.q:(myPRTRowID="")
	.q:(+myPRTRowID=0)
	.s myFlag=$p(^DHCINVPRT(myPRTRowID),"^", 8)
	.q:(myFlag'="N")
	.;^DHCPHARi("PRT",{PHA_PRT_DR},{PHA_ROWID})
	.s myrid=0
	.f  s myrid=$o(^DHCPHARi("PRT",myPRTRowID,myrid)) q:((myrid=""))  d
	..s myPresno=$p(^DHCPHARW(myrid),"^",16)
	..q:myPresno=""
	..q:'$d(WinAry("Window",$j,myPresno))
	..q:$g(WinAry("Window",$j,myPresno))=""
	..s PresnoWinInfo=WinAry("Window",$j,myPresno)
	..s win=$p(PresnoWinInfo,"^",2)
	..;q:+win=0
	..s rtn=..SELECT(myrid)
	..i +win'=0 s PLIST(5)=win		;更新窗口
	..s PLIST(14)=1			;RetFlag
	..s rtn=..UPDATE(myrid)
	;
	k WinAry("Window",$j)
	q 0
}

ClassMethod UpdatePHWINV(INVRowIdStr As %String, ExpStr As %String) As %String
{
	n (INVRowIdStr, ExpStr)
	;
	s myrid=0
	s rtn=0
	s channel=..#PHWINCHANNEL
	i (channel=1) {
		s prescNoStr=""
		s myLen=$l(INVRowIdStr,"^")
		f myIdx=1:1:myLen  d
		.s myPRTRowID=$p(INVRowIdStr,"^",myIdx)
		.q:(+myPRTRowID=0)
		.s myFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)
		.q:(myFlag'="N")
		.s myPrescnoStr=..GetPrescNoByPrtRowId(myPRTRowID)   //+2018-11-22 ZhYW
		.q:(myPrescnoStr="")
		.i (prescNoStr="") d
		..s prescNoStr=myPrescnoStr
		.e  d
		..s prescNoStr=prescNoStr_"^"_myPrescnoStr
		;
		k WinAry("Window",$j)
		;此处调用药房组接口，在此接口中再调用平台组接口，对应调用web服务时一定要设置超时时间
		s AllRetWin=##class(web.DHCMZYFXTYW02).GetPhWinFromManf(prescNoStr)
		f i=1:1:$l(AllRetWin,$c(1))  d
		.s tmp=$p(AllRetWin,$c(1),i)
		.q:(tmp="")
		.s myPresno=$p(tmp,"^",4)
		.q:(myPresno="")
		.s WinAry("Window",$j,myPresno)=tmp
		;
		;更新发药窗口表
		f prescIdx=1:1:$l(prescNoStr,"^") d
		.s myPresno=$p(prescNoStr,"^",prescIdx)
		.q:(myPresno="")
		.q:'$d(WinAry("Window",$j,myPresno))
		.q:WinAry("Window",$j,myPresno)=""
		.s PresnoWinInfo=WinAry("Window",$j,myPresno)
		.s win=$p(PresnoWinInfo,"^",2)
		.;q:(+win=0)
		.s myrid=0
		.f  s myrid=$o(^DHCPHARi("PRESCNO",myPresno,myrid)) q:(myrid="")  d
		..s rtn=..SELECT(myrid)
		..i (+win'=0) s PLIST(5)=win	   ;更新窗口
		..s PLIST(14)=1			           ;RetFlag
		..s rtn=..UPDATE(myrid)
		;
		k WinAry("Window",$j)
		
	}else {
		s myLen=$l(INVRowIdStr,"^")
		f myIdx=1:1:myLen  d
		.s myPRTRowID=$p(INVRowIdStr,"^",myIdx)
		.q:(+myPRTRowID=0)
		.s myFlag=$p(^DHCINVPRT(myPRTRowID),"^",8)
		.q:(myFlag'="N")
		.//+2018-11-12 ZhYW 处方可拆分发药
		.s myPrescnoStr=..GetPrescNoByPrtRowId(myPRTRowID)
		.q:(myPrescnoStr="")
		.f prescIdx=1:1:$l(myPrescnoStr,"^") d
		..s myPresno=$p(myPrescnoStr,"^",prescIdx)
		..q:(myPresno="")
		..s myrid=0
		..f  s myrid=$o(^DHCPHARi("PRESCNO",myPresno,myrid)) q:(myrid="")  d
		...s rtn=..SELECT(myrid)
		...s PLIST(14)=1			//RetFlag
		...s rtn=..UPDATE(myrid)
	}
	
	q 0
}

/// 在停止医嘱的过程中,要求更新处方接口NoUser=1  未发药处方
/// w ##class(web.udhcOPPHARWIN).UpdateUDOPresc("","")
ClassMethod UpdateUDOPresc(PRTRowID As %String = "", OEPrescNo As %String = "") As %String
{
	&sql(update DHC_PHARWIN set PHA_NOUSER=1 where PHA_PRT_DR=:PRTRowID and  PHa_PrescNo=:OEPrescNo)	
	quit SQLCODE
}

/// w ##class(web.udhcOPPHARWIN).UpdateRETFLAG("213")
ClassMethod UpdateRETFLAG(PRTRowIDStr As %String = "") As %String
{
	s rtn="0"
	q:$g(PRTRowIDStr)="" rtn
	s len=$l(PRTRowIDStr,"^")
	f i=1:1:len  q:rtn'="0"  d
	.s PRTRowID=$p(PRTRowIDStr,"^",i)
	.q:+PRTRowID=0
	.q:'$d(^DHCPHARi("PRT",PRTRowID))
	.d ..tb()
	.&sql(update DHC_PHARWIN set PHA_RETFLAG='1' where PHA_PRT_DR=:PRTRowID)
	.s rtn=SQLCODE
	.d ..tc()
	
	quit rtn
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// Creator: ZhYW
/// CreatDate: 2018-10-16
/// Description: 获取结算的处方号
/// Input: prtRowId:DHC_INVPRT.RowId
/// Output: 
/// Return: rtn(^分割的处方号串)
/// Debug: w ##class(web.udhcOPPHARWIN).GetPrescNoByPrtRowId(228873)
ClassMethod GetPrescNoByPrtRowId(prtRowId As %String) As %String
{
	new (prtRowId)
	set rtn=""
	quit:(+prtRowId=0) rtn
		
	set bciDr=0
    for  set bciDr=$o(^DHCBCI(0,"INV",prtRowId,bciDr)) quit:(bciDr="")  do
    .set pb=$p(^DHCBCI(bciDr),"^",2)
	.quit:(+pb=0)
    .set pbo=0
    .for  set pbo=$o(^DHCPB(pb,"O",pbo)) quit:(pbo="")  do
    ..set pboInfo=$g(^DHCPB(pb,"O",pbo))
    ..quit:(pboInfo="")
    ..set oeitm=$p(pboInfo,"^",4)
    ..set priorityId=$p($g(^OEORD(oeitm,"I",$p(oeitm,"||",2),1)),"^",8)
	..set priorityCode=$s((priorityId'=""):$p(^OECPR(priorityId),"^",1),1:"")
	..quit:(priorityCode["OM")	   //过滤自备药医嘱
    ..set prescNo=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",14)
    ..quit:(prescNo="")
    ..quit:(("^"_rtn_"^")[("^"_prescNo_"^"))
    ..set rtn=$s((rtn=""):prescNo,1:(rtn_"^"_prescNo))
    
    quit rtn
}

/// Descript：作废重打时如果已配药但未发药的情况要更新配药表的发票和欠药单的发票
/// 		  如果发药后又作废重打,会引起新产生的发票无法退费
/// Creator:	zhouyg
/// CreatDate:	2018-04-24，20200624
/// Input：		phar-DHC_PHARWIN表的ID,newinv-新发票ID
/// Modify:WangYaJun 2020-06-18 改为只更新最后一条发药表数据，避免部分退费后又进行作废重打导致把发药表所有发票都更新成了最新的
/// w ##class(web.udhcOPPHARWIN).UpdPhInv(1856744,"O200618005529")
ClassMethod UpdPhInv(phar, newinv) As %String
{
	s ret=0
	s phl=$p($g(^DHCPHARW(phar)),"^",3)
	s prescno=$p(^DHCPHARW(phar),"^",16)
	s Exit=0   //改为只更新最后一条数据 WangYaJun 2020-06-28
	s phd=""
	f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd),-1) q:(phd="")||(Exit=1)  d
	.s fyflag=$p(^DHCPHDISP(phd),"^",4)
	.s oldprt=+$p(^DHCPHDISP(phd),"^",2)
	.s Exit=1  //只更新最后一条数据
	.//q:oldprt=0
	.q:fyflag="1"
	.&sql(update DHC_PHDISPEN set PHD_PRT_DR=:newinv where PHD_ROWID=:phd )
	.i SQLCODE'=0 s ret=-1
	.q:SQLCODE'=0
	.s flag=0
	.s phow=""
	.f  s phow=$o(^DHCPHOWi(0,"PRT",oldprt,phow)) q:(phow="")||(flag'=0)  d
	..s phowstate=$p(^DHCPHOW(phow),"^",8)
	..q:phowstate=2 //已发药
	..s phowretdate=$p(^DHCPHOW(phow),"^",10)
	..q:phowretdate'=""  //已退药 
	..//s phowretprt=$p(^DHCPHOW(phow),"^",13)
	..&sql(update DHC_PHOweList set PHO_PRT_Dr=:newinv where PHO_RowID=:phow)
	..i SQLCODE'=0 s flag=-2
	..q:SQLCODE'=0
	q ret
}

}
