Import SQLUser

/// 日志:LiangQiang 2012-03-08 修正
/// 适应流程  5 - 90  共11项
/// Description:配液状态工作量统计  
/// Creator: Liang Qiang
/// CreatDate:2010-04-07
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAWORKSTAT","WorkStat",64041,64041)
Class web.DHCSTPIVAWORKSTAT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod WorkStatExecute(ByRef qHandle As %Binary, StartDate, EndDate) As %Status
{
	//工作量统计
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//s pid=$j
	s pid=repid
	d KillTMP
	s locdr=$g(%session.Data("LOGON.CTLOCID"))
	//实现；
    f date=StartDate:1:EndDate d
    .;配液流程定制
    .s ssusr="" 
    .f  s ssusr=$o(^PIVA(0,"SDUS",date,ssusr)) q:ssusr=""  d
    ..s psdr=""
    ..f  s psdr=$o(^PIVA(0,"SDUS",date,ssusr,psdr)) q:psdr=""  d  
    ...s pog=""
    ...s lastpog=""
    ...f  s pog=$o(^PIVA(0,"SDUS",date,ssusr,psdr,pog)) q:pog=""  d
    ....i '$d(^TMP("PIVA",pid,"workstatpog",pog)) d
    .....//s pass=..GetPassNum(date,locdr,pog,pid) ;;配伍审核
    .....s refuse=..GetRefuseNum(pog,pid) ;;配液拒绝
    ....s ^TMP("PIVA",pid,"workstatpog",pog)="" 
    ....
    ....s number=$p(^PIVAS(psdr),"^",1)
    ....s num=+$g(^TMP("PIVA",pid,"workitm",ssusr,number))
    ....s ^TMP("PIVA",pid,"workitm",ssusr,number)=num+1
    .//单独统计配伍审核拒绝数据
    .s phaomr=""
    .f  s phaomr=$o(^DHCPHORDM(0,"DateLoc",date,locdr,phaomr)) q:phaomr=""  d
    ..s apptype=$p(^DHCPHORDM(phaomr),"^",9)
    ..q:apptype'="PIVAS"
    ..s result=$p(^DHCPHORDM(phaomr),"^",6)
    ..i result["拒绝" s auditcode="1050"
    ..e  i result["通过" s auditcode="1000"
    ..e  s auditcode=""
    ..q:auditcode=""
    ..s pivauser=$p(^DHCPHORDM(phaomr),"^",1)
    ..s ^TMP("PIVA",pid,"aduitnum",pivauser,auditcode)=+$g(^TMP("PIVA",pid,"aduitnum",pivauser,auditcode))+1
    ..s ^TMP("PIVA",pid,"workitm",pivauser,1)=""
    s ssusr=""
    f  s ssusr=$o(^TMP("PIVA",pid,"workitm",ssusr)) q:ssusr=""  d
    .s numberStr=5_"^"_10_"^"_20_"^"_25_"^"_30_"^"_40_"^"_50_"^"_60_"^"_70_"^"_80_"^"_90
    .s numcnt=$l(numberStr,"^")
    .f i=1:1:numcnt d
	..s psnumber=$p(numberStr,"^",i)
    ..s ^TMP("PIVA",pid,"worksum",ssusr,psnumber)=+$g(^TMP("PIVA",pid,"workitm",ssusr,psnumber))
    s worknum=0
    s ssusr=""
    f  s ssusr=$o(^TMP("PIVA",pid,"worksum",ssusr)) q:ssusr=""  d
    .s psnumber=0
    .s numstr=""
    .f  s psnumber=$o(^TMP("PIVA",pid,"worksum",ssusr,psnumber)) q:psnumber=""  d
    ..//s psdr=$o(^PIVAS(0,"NUMBER",psnumber,""))
    ..//q:psdr=""
    ..s user=$p(^SSU("SSUSR",ssusr),"^",2)
    ..//s pstate=$p($g(^PIVAS(psdr)),"^",2)
    ..s worknum=$g(^TMP("PIVA",pid,"worksum",ssusr,psnumber))
    ..i numstr="" d
    ...s numstr=worknum
    ..e  d
    ... s numstr=numstr_"^"_worknum
    .s othernumberstr=..GetOtherStateNum(ssusr,pid) ;;非流程定制
    .;
    .s numstr=numstr_"^"_othernumberstr
    .s pstate1=+$p(numstr,"^",1)	//复核不通过
    .s pstate2=+$p(numstr,"^",2)	//打签
    .s pstate3=+$p(numstr,"^",3)	//分签
    .s pstate4=+$p(numstr,"^",4)	//核对不通过
    .s pstate5=+$p(numstr,"^",5)	//排药
    .s pstate6=+$p(numstr,"^",6)	//贴签
    .s pstate7=+$p(numstr,"^",7)	//核对
    .s pstate8=+$p(numstr,"^",8)	//60 配置 
    .s pstate9=+$p(numstr,"^",9)	//70 复核 
    .s pstate10=+$p(numstr,"^",10)	//80 打包 
    .s pstate11=+$p(numstr,"^",11)	//90 病区接收 
    .s pstate12=+$p(numstr,"^",12)	//审核通过数
	.s pstate13=+$p(numstr,"^",13)	//审核拒绝数
	.s pstate14=+$p(numstr,"^",14)	//正常打包数
	.s pstate15=+$p(numstr,"^",15)	//非正常打包数
	.s pstate16=+$p(numstr,"^",16)	//配液拒绝数
	.s pstate17=+$p(numstr,"^",17)	//配液取消数
	.d OutPutRow
	;;非流程定制工作人员统计
	s ret=..GetOtherPersonNum(pid)
	i ret'=0 d KillTMP
	Quit:ret'=0 $$$OK
	s ssusr=""
	f  s ssusr=$o(^TMP("PIVA",pid,"othernum",ssusr)) q:ssusr=""  d
	.s numstr=^TMP("PIVA",pid,"othernum",ssusr)
	.s user=$p(^SSU("SSUSR",ssusr),"^",2)
	.s pstate1=+$p(numstr,"^",1)
    .s pstate2=+$p(numstr,"^",2)
    .s pstate3=+$p(numstr,"^",3)
    .s pstate4=+$p(numstr,"^",4)
    .s pstate5=+$p(numstr,"^",5)
    .s pstate6=+$p(numstr,"^",6)
    .s pstate7=+$p(numstr,"^",7)
    .s pstate8=+$p(numstr,"^",8)
    .s pstate9=+$p(numstr,"^",9)
    .s pstate10=+$p(numstr,"^",10)
    .s pstate11=+$p(numstr,"^",11)
	.s pstate12=+$p(numstr,"^",12)
	.s pstate13=+$p(numstr,"^",13)
	.s pstate14=+$p(numstr,"^",14)
	.s pstate15=+$p(numstr,"^",15)
	.s pstate16=+$p(numstr,"^",16)
	.s pstate17=+$p(numstr,"^",17)
	.d OutPutRow
	d KillTMP
	Quit $$$OK
	
OutPutRow
	set Data=$lb(user,pstate1,pstate2,pstate3,pstate4,pstate5,pstate6,pstate7,pstate8,pstate9,pstate10,pstate11,pstate12,pstate13,pstate14,pstate15,pstate16,pstate17)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
KillTMP
    k ^TMP("PIVA",pid,"workitm")
	k ^TMP("PIVA",pid,"worksum")
	k ^TMP("PIVA",pid,"aduitnum")
	k ^TMP("PIVA",pid,"refusenum")
	k ^TMP("PIVA",pid,"othernum")
	k ^TMP("PIVA",pid,"workstatpog")
	k ^TMP("PIVA",pid,"otherworkperson")
	q
}

ClassMethod WorkStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WorkStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query WorkStat(StartDate, EndDate) As %Query(ROWSPEC = "Tuser:%String,Tpstate1:%String,Tpstate2:%String,Tpstate3:%String,Tpstate4:%String,Tpstate5:%String,Tpstate6:%String,Tpstate7:%String,Tpstate8:%String,Tpstate9:%String,Tpstate10:%String,Tpstate11:%String,Tpstate12:%String,Tpstate13:%String,Tpstate14:%String,Tpstate15:%String,Tpstate16:%String,Tpstate17:%String")
{
}

ClassMethod WorkStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WorkStatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description:获取配伍审核,拒绝,打包等状态数量
/// Creator:Liang Qiang
/// CreatDate:2010-04-08
/// Input:关联医嘱组ID
/// Output:
/// others:yunhaibao20160520,此处不再用,审核数通过医嘱审核表统计
ClassMethod GetPassNum(date, locdr, pog, pid) As %String
{
  n (date,locdr,pog,pid)  
  S moedisp=$p(^PIVA(pog),"^",1)
  S oeori=$P(^DHCOEDISQTY(moedisp),"^",3)
  d getpnum(oeori)
  q 0
getpnum(goeori)
  s gord=$p(goeori,"||",1)
  s gchl=$p(goeori,"||",2)
  s authorize=$p(^OEORD(gord,"I",gchl,7),"^",3)
  Q:authorize=""
  s auditor=$P(authorize,",",1)
  s auditresult=$P(authorize,",",4)
  i auditresult="SHTG" s auditresult=1000 ;"审核通过"
  i auditresult="SHJJ" s auditresult=1050 ;"审核拒绝"
  i auditresult="ZCDB" s auditresult=1100 ;"正常打包"
  i auditresult="FZCDB" s auditresult=1150 ;"非正常打包"
  s ^TMP("PIVA",pid,"aduitnum",auditor,auditresult)=+$g(^TMP("PIVA",pid,"aduitnum",auditor,auditresult))+1
  q
}

/// Description:获取配液拒绝状态数量
/// Creator:Liang Qiang
/// CreatDate:2010-04-08
/// Input:关联医嘱组ID
/// Output:
ClassMethod GetRefuseNum(pog, pid) As %String
{
  n (pog,pid)  
  s oper=$p(^PIVA(pog),"^",8)
  i oper="R" s oper=1000 //拒绝
  i oper="C" s oper=1050 //取消
  s cuserdr=$p(^PIVA(pog),"^",12)
  q:oper="N" 0
  s ^TMP("PIVA",pid,"refusenum",cuserdr,oper)=+$g(^TMP("PIVA",pid,"refusenum",cuserdr,oper))+1
  q 0
}

/// Description:获取某个工作人员非流程定制的状态数量
/// Creator:Liang Qiang
/// CreatDate:2010-04-08
/// Input:工作人员ID
/// Output:审核通过数_"^"_审核拒绝数_"^"_正常打包数_"^"_非正常打包数_"^"_配液拒绝数_"^"_配液取消数
ClassMethod GetOtherStateNum(ssusr, pid) As %String
{
	n (ssusr,pid)
	
    s othernum=""
    s numberStr=1000_"^"_1050_"^"_1100_"^"_1150
    s aduitcnt=$l(numberStr,"^")
    f i=1:1:aduitcnt d
	.s st=$p(numberStr,"^",i)
	.i othernum="" d
	..s othernum=+$g(^TMP("PIVA",pid,"aduitnum",ssusr,st))
	.e  d
	..s othernum=othernum_"^"_+$g(^TMP("PIVA",pid,"aduitnum",ssusr,st))
	.
	.k ^TMP("PIVA",pid,"aduitnum",ssusr,st)
	
	s numberStr=1000_"^"_1050
	s refusecnt=$l(numberStr,"^")
    f i=1:1:refusecnt d
    .s st=$p(numberStr,"^",i)
	.s othernum=othernum_"^"_+$g(^TMP("PIVA",pid,"refusenum",ssusr,st))
	.
	.k ^TMP("PIVA",pid,"refusenum",ssusr,st)
	Q othernum
}

/// Description:获取非流程定制的状态内人员的其它人员工作状态数量 :配伍,配液拒绝
/// Creator:Liang Qiang
/// CreatDate:2010-04-08 
/// Input:
/// Output:-1 无记录,0有记录
ClassMethod GetOtherPersonNum(pid) As %String
{
	n (pid)
	s ret=-1
	
	s ssusr=""
	f  s ssusr=$o(^TMP("PIVA",pid,"aduitnum",ssusr)) q:ssusr=""  d
	.s ^TMP("PIVA",pid,"otherworkperson",ssusr)=""
	.s ret=0
	//
	s ssusr=""
	f  s ssusr=$o(^TMP("PIVA",pid,"refusenum",ssusr)) q:ssusr=""  d
	.s ^TMP("PIVA",pid,"otherworkperson",ssusr)=""
	.s ret=0
	q ret'=0  -1
	//
	s numberStr=1000_"^"_1050_"^"_1100_"^"_1150
    s aduitcnt=$l(numberStr,"^")
    s refnumberStr=1000_"^"_1050
	s refusecnt=$l(refnumberStr,"^")
    //
	s ssusr=""
	f  s ssusr=$o(^TMP("PIVA",pid,"otherworkperson",ssusr)) q:ssusr=""  d
	.s othernum=""
	.s psnumber=""
	.f  s psnumber=$o(^PIVAS(0,"NUMBER",psnumber)) q:psnumber=""  d
    ..i othernum="" d
    ...s othernum=0
    ..e  d
    ...s othernum=othernum_"^"_0
    .
    .f i=1:1:aduitcnt d
    ..s st=$p(aduitcnt,"^",i)
    ..s othernum=othernum_"^"_+$g(^TMP("PIVA",pid,"aduitnum",ssusr,st))
    .
    .f h=1:1:refusecnt d
    ..s st=$p(refnumberStr,"^",h)
    ..s othernum=othernum_"^"_+$g(^TMP("PIVA",pid,"refusenum",ssusr,st))
    .
    .s ^TMP("PIVA",pid,"othernum",ssusr)=othernum
	
	
	q 0
}

}
