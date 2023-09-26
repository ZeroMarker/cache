Import SQLUser

/// 病区批次袋数统计
Class web.DHCSTPIVASTATWARDBAT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DispFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod DispClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod DispExecute(ByRef qHandle As %Binary, tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tState As %String, tSpecStat As %String, tOrdStDate As %String, tOrdEndDate As %String, tPhcCatDr As %String, tPhcStr As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	Q:tPLocID="" $$$OK
	Q:tStartDate="" $$$OK
	Q:tEndDate="" $$$OK
	S PID=""
	S PID=..CollData(tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tState, tSpecStat,tOrdStDate,tOrdEndDate,tPhcCatDr,tPhcStr)
	Q:PID="" $$$OK
	S statFlag=$p(tPhcStr,"^",3) //显示方式
	S jj="",totalnum=0
	F  S jj=$O(^TMP("PIVA",PID,"STWARD",jj)) Q:jj=""  D
	.S ii="",wardnum=0,showWard=0
	.F  S ii=$O(^TMP("PIVA",PID,"STWARD",jj,ii)) Q:ii=""  D
	..S Data=..GetData(PID,jj,ii,statFlag,showWard)
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	..S showWard=1
 	..S wardnum=wardnum+$LG(Data,5)
 	..S totalnum=totalnum+$LG(Data,5)
 	..S hh=""
 	..F  S hh=$O(^TMP("PIVA",PID,"STWARDTYPE",jj,ii,hh)) Q:hh=""  D
 	...S wardbnum=^TMP("PIVA",PID,"STWARDTYPE",jj,ii,hh)
 	...S tmpstr=$p(hh,"!!",2)
 	...S typeID=$p(tmpstr,"^",1)
	...s typeDesc=$p(tmpstr,"^",2)
	...i typeDesc="" s typeDesc="未定"
    ...
	...i statFlag=1 S ^CacheTemp(repid,ind)=$LB(PID,"","",typeDesc,wardbnum) //分类输出
	...i statFlag=1 S ind=ind+1
	..
 	.;S ^CacheTemp(repid,ind)=$LB(PID,jj,"合计",wardnum)
 	.i statFlag'=1 S ^CacheTemp(repid,ind)=$LB(PID,"","合计","",wardnum)
 	.S ind=ind+1
 	.
 	S ^CacheTemp(repid,ind)=$LB(PID,"总计","","",totalnum)
 	S ind=ind+1
 	Q $$$OK
}

Query Disp(tPLocID As %String, tWardID As %String, tStartDate As %String, tEndDate As %String, tRegNo As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tState As %String, tSpecStat As %String, tOrdStDate As %String, tOrdEndDate As %String, tPhcCatDr As %String, tPhcStr As %String) As %Query(ROWSPEC = "tbPID:%String,tbWard:%String,tbBatNo:%String,tbtype:%String,tbPacks:%String")
{
}

ClassMethod CollData(tPLocID As %String, tWardID As %String, tRegNo As %String, tStartDate As %String, tEndDate As %String, tBatNo As %String, tOecprID As %String, tItmID As %String, tPrintNo As %String, tPassAudit As %String, tState As %String, tSpecStat As %String, tOrdStDate As %String, tOrdEndDate As %String, tPhcCatDr As %String, tPhcStr As %String) As %Integer
{
	N (tPLocID, tWardID, tRegNo, tStartDate, tEndDate, tBatNo, tOecprID, tItmID, tPrintNo,tPassAudit,tState,tSpecStat,tOrdStDate,tOrdEndDate,tPhcCatDr,tPhcStr)
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""	
	S PID=..NewPid()
	D ..ClearAllTmp(PID)
	S tPrintStime=$p(tPhcStr,"^",4)
	i tPrintStime'="" s tPrintStime=$zth(tPrintStime,1)
	S tPrintEtime=$p(tPhcStr,"^",5)
	i tPrintEtime'="" s tPrintEtime=$zth(tPrintEtime,1)
	S i=0
	F date=tStartDate:1:tEndDate D
	.S pha=""
	.F  S pha=$O(^DHCPHAC(0,"PHP",tPLocID,"DATE",date,pha)) Q:pha=""  D
	..Q:($D(^DHCPHAC(pha))=0)!($D(^DHCPHAC(pha))=10)
	../// 病区
	..S ward=$P(^DHCPHAC(pha),"^",4)
	..;Q:(tWardID'="")&(tWardID'=ward)
	..Q:##class(web.DHCSTPIVA).CheckWard(tWardID,ward)=0
	..S ward=$P(^PAWARD(ward),"^",2)
	../// 打印单号
	..S printno=$P(^DHCPHAC(pha),"^",14)
	..Q:(tPrintNo'="")&(tPrintNo'=printno)
	..S pog=""
	..F  S pog=$O(^PIVA(0,"PHAC",pha,pog)) Q:pog=""  D
	...S pdata=^PIVA(pog)
	.../// 医嘱日期
	...S orddate=$P(pdata,"^",4)
	...Q:(tOrdStDate'="")&(orddate<tOrdStDate)
	...Q:(tOrdEndDate'="")&(orddate>tOrdEndDate)
	...///打印时间
	...S cpdateflag=0
	...S printdate=$P(^DHCPHAC(pha),"^",7)
	...S printtime=$P(^DHCPHAC(pha),"^",8)
	...I (tPrintStime'="")&(printdate=tStartDate)&(printtime<tPrintStime) S cpdateflag=-1
 	...I (tPrintEtime'="")&(printdate=tEndDate)&(printtime>tPrintEtime) S cpdateflag=-1
	...Q:cpdateflag=-1
	.../// 批次
	...S batno=$P(pdata,"^",3)
	...Q:(tBatNo'="")&(tBatNo'=batno)
	...///
	...S moedisp=$P(pdata,"^",1)
	...S moeori=$P(^DHCOEDISQTY(moedisp),"^",3)
	...S mord=$P(moeori,"||",1)
	.../// 登记号
	...S adm=$P(^OEORD(mord),"^",1)	/// 病人 PAADM_Rowid
	...S pat=##class(web.DHCSTPIVA).GetPat(adm)
	...S ipno=$P(pat,"^",1)
	...Q:(tRegNo'="")&(tRegNo'=ipno)
	.../// 优先级
	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
	...S pridr=$P(pri,"^",1)
	...Q:(tOecprID'="")&(tOecprID'=pridr)
	.../// 关联医嘱是否包含此药品
	...S qflag=0
 	...I tItmID'="" D
 	....S qflag=##class(web.DHCSTPIVA).ChkExItm(moeori,tItmID)
 	...Q:(tItmID'="")&(qflag=0)
 	.../// 关联医嘱是否包含此药学分类
 	...S qflag=0
 	...I tPhcCatDr'="" D
 	....S qflag=##class(web.DHCSTPIVA).ChkExPhcCat(moeori,tPhcCatDr)
 	...Q:(tPhcCatDr'="")&(qflag=0)
 	.../// 关联医嘱是否包含此药学子分类
 	...S qflag=0
 	...  //综合查询条件
 	...S tPhcSubCatDr=$P(tPhcStr,"^",1)
 	...I tPhcSubCatDr'="" D
 	....S qflag=##class(web.DHCSTPIVA).ChkExPhcSubCat(moeori,tPhcSubCatDr)
 	...Q:(tPhcSubCatDr'="")&(qflag=0)
 	.../// pass审核
 	...S chstr=##class(web.DHCSTPIVA).GetPassResult(moeori)
	...S passre=$p(chstr,",",4) /// 配伍审核结果
 	...Q:(tPassAudit'="")&(tPassAudit'=passre)
 	.../// 医嘱状态
	...//S oestate=##class(web.DHCSTPIVA).GetOeState(moeori)
	...//S oestcode=$P(oestate,"^",1)
 	...//Q:(tSpecStat="D")&(oestcode'=tSpecStat)
 	...//Q:(tSpecStat="N")&(oestcode="D")
 	...S OrdExeRowid=$p(^DHCOEDISQTY(moedisp),"^",3) 
 	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	...Q:(tSpecStat="D")&(ChkOrdState=1)
 	...Q:(tSpecStat="N")&(ChkOrdState=0)
 	.../// 特殊状态
 	...S spec=$P(pdata,"^",8)
 	...Q:(tSpecStat'="")&(tSpecStat'="D")&(tSpecStat'=spec)
 	.../// 配药状态
 	...S psdr=$P(pdata,"^",6)
 	...S cstat=##class(web.DHCSTPIVA).GetPSName(pog)
 	...Q:(tState'="")&(tState'=cstat)
 	...S typedr=$p(tPhcStr,"^",2)
 	...S ptypestr=##class(web.DHCSTPIVA).GetAuditedType(moeori)
 	...S typeID=$p(ptypestr,"^",1)
 	...i ptypestr="" d
 	....s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(moeori)
 	....s ptypestr="PT"_"^"_"PT"
 	....i remark["TPN" s ptypestr="TPN"_"^"_"TPN"
 	....i remark["HL"  s ptypestr="HL"_"^"_"HL"
 	...Q:(typedr'="")&(typedr'=typeID)
 	...//
 	...S i=i+1
 	...S ^TMP("PIVA",PID,"STWARD",ward,batno)=$G(^TMP("PIVA",PID,"STWARD",ward,batno))+1
 	...S ^TMP("PIVA",PID,"STWARDTYPE",ward,batno,batno_"!!"_ptypestr)=$G(^TMP("PIVA",PID,"STWARDTYPE",ward,batno,batno_"!!"_ptypestr))+1
 	...
	Q:i>0 PID
	Q ""
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("COLL"))
}

ClassMethod GetData(PID As %String, j As %String, i As %String, statFlag = "", showWard = "") As %String
{
	N (PID,j,i,statFlag,showWard)
	s show=""
	i statFlag=1 s show="合计"
	S nums=^TMP("PIVA",PID,"STWARD",j,i)
	i (showWard'="")&(showWard'=0) s j=""
 	S data=$LB(PID,j,i,show,nums)
 	Q data
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"STWARD")
	D ..CLEARTMP(pid,"STWARDTYPE")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

}
