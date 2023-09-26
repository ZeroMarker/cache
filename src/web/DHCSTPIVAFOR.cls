Import SQLUser

/// 配液for else
Class web.DHCSTPIVAFOR Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断医嘱是否被拒绝配液，护士站使用,1:被拒绝 0:否
ClassMethod GetOeRefuseOld(oeori As %String) As %String
{
	N (oeori)
	S pass=##class(DHCSTPIVA).GetPassResult(oeori)
	Q:$p(pass,",",4)="SHJJ" 1	/// 配伍审核拒绝
	S moeori=##class(DHCSTPIVA).GetMainOeori(oeori)
	Q:moeori="" 0
	S poper=##class(DHCSTPIVA).GetOePOper(moeori)
	Q:poper'="" 2	/// 拒绝操作
	Q 0
}

/// 判断医嘱是否被拒绝配液，护士站使用,1:被拒绝 0:否
ClassMethod GetOeRefuse(DspId As %String) As %String
{
	N (DspId)
	S oeori=$p(^DHCOEDISQTY(DspId),"^",1)
	S pass=##class(DHCSTPIVA).GetPassResult(oeori)
	Q:$p(pass,",",4)="SHJJ" 1	/// 配伍审核拒绝
	S moeori=##class(DHCSTPIVA).GetMainOeori(oeori)
	Q:moeori="" 0
	S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	S poper=##class(DHCSTPIVA).GetOePOper(mdodis)
	Q:poper'="" 2	/// 拒绝操作
	Q 0
}

/// 判断病人是否被拒绝配液，护士站使用,1:被拒绝 0:否
/// bianshuai 2015-12-08 增加判断"retflag=1",如果有一条拒绝,则退出for循环
ClassMethod GetAdmRefuse(adm As %String) As %String
{
	N (adm)
	q:adm="" 0
	s locstr=""
	&sql(declare xxx cursor for select CTLOC_RowID from ct_loc)
    s result=""
    &sql(open xxx)
    f  &sql(fetch xxx into :ctlocrowid) q:SQLCODE  d
	.s HospID=$p($g(^CTLOC(ctlocrowid)),"^",22)
	.s Param=""_"^"_ctlocrowid_"^"_""_"^"_$g(HospID)
    .s OnlyPIVALocFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTINPIVA","OnlyPIVALoc",Param)
	.q:OnlyPIVALocFlag'="Y" 
    .i locstr="" s locstr=ctlocrowid
    .e  s locstr=locstr_"^"_ctlocrowid
	&sql(close xxx)
	S ord=$o(^OEORD(0,"Adm",adm,""))
 	Q:ord="" 0
 	S ref=0
 	/// 长期医嘱
 	s datefrom=+$H-1
 	s dateto=+$H+1
 	s retflag=0
 	s cnt=$l(locstr,"^")
	f kk=1:1:cnt Q:retflag=1  d
	.s loc=$p(locstr,"^",kk)
 	.F date=datefrom:1:dateto Q:retflag=1  D
 	..S DspId=""
 	..F  s DspId=$o(^DHCOEDISQTY(0,"ADM",loc,date,"TC",adm,DspId)) q:(DspId="")||(retflag=1)  d
 	...S oeori=$p(^DHCOEDISQTY(DspId),"^",1)
 	...S OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)
 	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	...q:ChkOrdState'=1   ////停止医嘱过滤掉
 	...S moeori=##class(DHCSTPIVA).GetMainOeori(oeori)
 	...Q:moeori=""
 	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
 	...Q:pri=""
	...S pridr=$P(pri,"^",1)
	...Q:(pridr'=5)&(pridr'=8)
 	...S ref=..GetOeRefuse(DspId)
 	...i ref'=0 s retflag=1
 	Q:retflag'=0 1
 	/// 非长期医嘱
 	s datefrom=+$H
 	s dateto=+$H+1
 	S DspId=""
 	f kk=1:1:cnt Q:retflag=1  d
	.s loc=$p(locstr,"^",kk)
	.F date=datefrom:1:dateto Q:retflag=1  D
 	..F  S DspId=$o(^DHCOEDISQTY(0,"ADM",loc,date,"TC",adm,DspId)) q:(DspId="")||(retflag=1)  d
 	...S oeori=$p(^DHCOEDISQTY(DspId),"^",1)
 	...S OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)
 	...S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	...q:ChkOrdState'=1   ////停止医嘱过滤掉
 	...S moeori=##class(DHCSTPIVA).GetMainOeori(oeori)
 	...Q:moeori=""
 	...S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
 	...Q:pri=""
	...S pridr=$P(pri,"^",1)
	...Q:(pridr=5)||(pridr=8)
 	...S ref=..GetOeRefuse(DspId)
 	...i ref'=0 s retflag=1
 	q retflag
}

ClassMethod GetRefuseOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRefuseOrdExecute ]
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

ClassMethod GetRefuseOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRefuseOrdExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAFOR","GetRefuseOrd","2222")
ClassMethod GetRefuseOrdExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	s adm=EpisodeID
	Q:adm="" $$$OK
	s locstr=""
	&sql(declare xx cursor for select CTLOC_RowID from ct_loc)
    s result=""
    &sql(open xx)
    f  &sql(fetch xx into :ctlocrowid) q:SQLCODE  d
	.s HospID=$p($g(^CTLOC(ctlocrowid)),"^",22)
	.s Param=""_"^"_ctlocrowid_"^"_""_"^"_$g(HospID)
    .s OnlyPIVALocFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTINPIVA","OnlyPIVALoc",Param)
	.q:OnlyPIVALocFlag'="Y" 
    .i locstr="" s locstr=ctlocrowid
    .e  s locstr=locstr_"^"_ctlocrowid
	&sql(close xx)
	S ord=$o(^OEORD(0,"Adm",adm,""))
 	Q:ord="" 0
	S PID=""
	s cnt=$l(locstr,"^")
	f kk=1:1:cnt  d
	.s ploc=$p(locstr,"^",kk)
	.q:ploc=""
	.S PID=..GetRefuseData(ploc,adm)
	.Q:PID="" 
	.S num=""
	.F  S num=$O(^TMP("PIVA",PID,"FOR",num)) Q:num=""  D
	..S Data=^TMP("PIVA",PID,"FOR",num)
	..S ^CacheTemp(repid,ind)=Data	
 	..S ind=ind+1
 	.K ^TMP("PIVA",PID,"FOR")
 	Q $$$OK
}

Query GetRefuseOrd(EpisodeID As %String) As %Query(ROWSPEC = "tbPID:%String,tbSeqNo:%String,tbItmDesc:%String,tbFreq:%String,tbOeStatus:%String,tbDosage:%String,tbInst:%String,tbDura:%String,tbPresc:%String,tbOecpr:%String,tbDoctor:%String,tbMOeori:%String,tbOrdDate:%String,tbOrdTime:%String,tbCReason:%String,tbOeori:%String")
{
}

ClassMethod GetRefuseData(ploc As %String, AdmID As %String) As %String
{
	N (ploc,AdmID)
	S PID=..NewPid()
	K ^TMP("PIVA",PID,"FOR")
 	S ref=0,num=0
 	/// 长期医嘱
 	s datefrom=+$H-1
 	s dateto=+$h+1
 	F date=datefrom:1:dateto D
 	.S DspId=""
 	.F  s DspId=$o(^DHCOEDISQTY(0,"ADM",ploc,date,"TC",AdmID,DspId)) q:DspId=""  d
 	..S oeori=$p(^DHCOEDISQTY(DspId),"^",1)
 	..q:$d(ExistOeori(oeori))
 	..S dateadd=$p(^DHCOEDISQTY(DspId),"^",15)
 	..S OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)
 	..S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	..q:ChkOrdState'=1   ////停止医嘱过滤掉
 	..S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)
 	..Q:moeori=""
 	..S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
 	..Q:pri=""
	..S pridr=$P(pri,"^",1)
	..Q:(pridr'=5)&(pridr'=8)
 	..S pass=##class(web.DHCSTPIVA).GetPassResult(oeori)
 	..S passcode=$p(pass,",",4)
 	..I passcode="SHJJ" D
 	...S refstr="存在配伍禁忌"
 	...s reasondr=$p(pass,",",6)
 	...i reasondr'="" d
 	....s refstr=$p($g(^PIVAOR(reasondr)),"^",2)
 	...S oeinfo=..GetOeoriInfo(oeori,PID,refstr)
 	...Q:oeinfo=""
 	...S num=num+1
 	...S ^TMP("PIVA",PID,"FOR",num)=oeinfo
 	..Q:passcode="SHJJ"	/// 配伍审核拒绝
 	..S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	..S poper=##class(web.DHCSTPIVA).GetOePOper(mdodis) /// 拒绝操作
	..I poper'="" D
 	...S lenoper=$L(poper,"!")
 	...I lenoper>0 D
 	....S refstr=""
 	....F ii=1:1:lenoper D
 	.....S grpstr=$P(poper,"!",ii)
 	.....S grpno=$P(grpstr,"^",1)
 	.....S operea=$P(grpstr,"^",3)
 	.....I refstr="" S refstr="第"_grpno_"次:"_operea
 	.....E  S refstr=refstr_";第"_grpno_"次:"_operea
 	...S oeinfo=..GetOeoriInfo(oeori,PID,refstr)
 	...Q:oeinfo=""
 	...s ExistOeori(oeori)=""
 	...S num=num+1
 	...S ^TMP("PIVA",PID,"FOR",num)=oeinfo
 	..
 	.
 	/// 非长期医嘱
 	s datefrom=+$H
 	S dateto=+$H+1
 	F date=datefrom:1:dateto D
 	.S DspId=""
 	.F  s DspId=$o(^DHCOEDISQTY(0,"ADM",ploc,date,"TC",AdmID,DspId)) q:DspId=""  d
 	..S dateadd=$p(^DHCOEDISQTY(DspId),"^",15)
 	..S oeori=$p(^DHCOEDISQTY(DspId),"^",1)
 	..S OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)
 	..S ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 	..q:ChkOrdState'=1   ////停止医嘱过滤掉
 	..S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)
 	..Q:moeori=""
 	..S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)
 	..Q:pri=""
	..S pridr=$P(pri,"^",1)
	..Q:(pridr=5)||(pridr=8)||(pridr=29)
 	..S pass=##class(web.DHCSTPIVA).GetPassResult(oeori)
 	..S passcode=$p(pass,",",4)
 	..I passcode="SHJJ" D
 	...S refstr="存在配伍禁忌"
 	...s reasondr=$p(pass,",",6)
 	...i reasondr'="" d
 	....s refstr=$p($g(^PIVAOR(reasondr)),"^",2)
 	...S oeinfo=..GetOeoriInfo(oeori,PID,refstr)
 	...Q:oeinfo=""
 	...S num=num+1
 	...S ^TMP("PIVA",PID,"FOR",num)=oeinfo
 	..Q:passcode="SHJJ"	/// 配伍审核拒绝
	..S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	..S poper=##class(web.DHCSTPIVA).GetOePOper(mdodis) /// 拒绝操作
	..I poper'="" D
 	...S lenoper=$L(poper,"!")
 	...I lenoper>0 D
 	....S refstr=""
 	....F ii=1:1:lenoper D
 	.....S grpstr=$P(poper,"!",ii)
 	.....S grpno=$P(grpstr,"^",1)
 	.....S operea=$P(grpstr,"^",3)
 	.....I refstr="" S refstr="第"_grpno_"次:"_operea
 	.....E  S refstr=refstr_";第"_grpno_"次:"_operea
 	...S oeinfo=..GetOeoriInfo(oeori,PID,refstr)
 	...Q:oeinfo=""
 	...S num=num+1
 	...S ^TMP("PIVA",PID,"FOR",num)=oeinfo
 	k ^TMP("PIVA",PID,"MDISFOR")
 	Q:num>0 PID
 	Q ""
}

ClassMethod GetOeoriInfo(oeori As %String, PID As %String, refstr As %String = "") As %String
{
	N (oeori,PID,refstr)
	S ord=$P(oeori,"||",1)
	S chl=$P(oeori,"||",2)
	Q:ord="" ""
	Q:chl="" ""
	Q:'$D(^OEORD(ord,"I",chl,1)) ""
	S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)
	S seqno=$P($G(^OEORD(ord,"I",chl,3)),"^",4)		/// 关联医嘱号
	//优先级
	S pri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	S pridesc=$P(pri,"^",3)
	//医嘱状态
	S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)
 	S oestdesc=$P(oestate,"^",2)
 	//频次
 	S freqstr=##class(web.DHCSTPIVA).GetFreq(oeori)
 	S freqcode=$P(freqstr,"^",2)
 	S instruc=##class(web.DHCSTPIVA).GetInstruc(oeori)	/// 用法
	S dura=##class(web.DHCSTPIVA).GetDura(oeori)		/// 疗程
	S doctor=##class(web.DHCSTPIVA).GetDoctor(oeori)	/// 医生
	S seqno=$P($G(^OEORD(ord,"I",chl,3)),"^",4)		/// 关联医嘱号
	S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
	S itmdesc=$P(incitm,"^",3)
	S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)	/// 剂量
	S presc=$P(^OEORD(ord,"I",chl,1),"^",14)
 	S orddate=$P(^OEORD(ord,"I",chl,3),"^",7)
 	S ordtime=$P(^OEORD(ord,"I",chl,1),"^",17)
 	i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"PIVA")
	i ordtime'="" s ordtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordtime,"PIVA")
	S data=$LB(PID,seqno,itmdesc,freqcode,oestdesc,dosage,instruc,dura,presc,pridesc,doctor,moeori,orddate,ordtime,refstr,oeori)
	Q data
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("FOR"))
}

/// Descript:	根据主医嘱ID和顺序号取得配液批次
/// CreateDate:	20110330
/// Creater:	周永刚
/// Input:	Moeori-主医嘱ID,Seqno-按频次的顺序号
/// Output:	配液批次
/// Return： 	配液批次
ClassMethod GetBatNoByOe(Moeori As %String, Seqno As %String) As %String
{
	N (Moeori,Seqno)
	Q:Moeori="" ""
	Q:Seqno="" ""
	S Pog=$o(^PIVA(0,"OEGRP",Moeori,Seqno,""))
	Q:Pog="" ""
	S BatNo=$P(^PIVA(Pog),"^",3)
	Q BatNo
}

}
