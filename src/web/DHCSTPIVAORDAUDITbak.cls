Include webimport

Class web.DHCSTPIVAORDAUDITbak Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod FindOeoriExecute(ByRef qHandle As %Binary, sd As %Library.Date, ed As %Library.Date, st As %String, et As %String, reclocrowid As %String, regno As %String, tWardID As %String, tOecprID As %String, Checked As %String, tPassAudit As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1 	
	q:sd="" $$$OK
	q:ed="" $$$OK
	Q:(regno="")&(tWardID="") $$$OK
	s sd=$zdh(sd,4)
	s ed=$zdh(ed,4)
	i st="" s st=$zth("00:00:00")
	i et="" s et=$zth("23:59:59")
	s pid=$i(^RETRIEVEORDITMTOCHEMAUDIT)
	s ^pid=pid
	S nnnn=0
	s ^TMP("DDD08")=tPassAudit
	f date=sd:1:ed d
	.s ord=""
	.F  S ord=$O(^OEORDi(0,"LocStDtArr",reclocrowid,0,date,ord)) Q:ord=""  D
	..s ^WLTEMP=ord
	..s adm=$p(^OEORD(ord),"^",1)
	..s painfo=$$PaInfo(adm)
	..q:painfo=""
	..s pano=$p(painfo,"^",1)   //登记号 
	..s pabed= $p(painfo,"^",7)  //床号 
	..s paname= $p(painfo,"^",2)  //姓名  
	..s dept =$p(painfo,"^",8)  //科室   
	..s ward =$p(painfo,"^",6) //病区
	..s wardid=$p(painfo,"^",9) //病区ID
	..S weight=$p(painfo,"^",10) //体重
	..q:(regno'="")&(pano'=regno)
	..Q:(tWardID'="")&(tWardID'=wardid)
	..s ch=0
	..F  S ch=$o(^OEORDi(0,"LocStDtArr",reclocrowid,0,date,ord,ch)) Q:ch=""  D
	...s oeori=ord_"||"_ch  //ROWID
	...S nnnn=nnnn+1
	...///S ^tmp("AA",nnnn)=oeori
	.../// 医嘱状态
	...S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)	/// 医嘱核实、未核实、停止状态
	...S oeflag=$P(oestate,"^",1)
	...S oestatedesc=$P(oestate,"^",2)
	...q:(oeflag'="V")&(oeflag'="E")&(Checked=0)
	.../// 药剂师已经审核
	...S ifchemaudit=..ChemAudited(oeori)
	...Q:Checked'=ifchemaudit
	...S chstr=##class(web.DHCSTPIVA).GetPassResult(oeori)
	...Q:(tPassAudit'="")&($p(chstr,",",4)'=tPassAudit) /// 配伍审核
	...// 医嘱子分类 
    ...S arccat=##class(web.DHCSTPIVA).GetArcItmCat(oeori)
    ...s arccatid=$P($G(arccat),"^",1)
    ...Q:arccatid=""
    ...Q:$O(^PIVAA(0,"ARCIC",arccatid,""))="" ///  配液医嘱子分类没有维护 
	...//q:Passed(oeori)  //已经审核通过 
	...S mainoeori=##class(web.DHCSTPIVA).GetMainOeori(oeori) // 主医嘱
	...S seqno=$P(^OEORD(ord,"I",ch,3),"^",4)		/// 关联医嘱号
	.../// 优先级
	...S pri=##class(web.DHCSTPIVA).GetOePriority(mainoeori)
	...S pridr=$P(pri,"^",1)
	...Q:(tOecprID'="")&(tOecprID'=pridr)
	...S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	...S priority=$P(oepri,"^",3)
	.../// 禁忌原因
	...s interactReason=""
	...s interactReasonDr=$p($g(^OEORD(ord,"I",ch,9)),"^",8)
	...i interactReasonDr'="" s interactReason=$P(^OEC("ALR",interactReasonDr),"^",2)
	.../// 审核信息
	...s auditinfo=..AnaAuth(oeori)
	...s auditUser=$p(auditinfo,"^",1)   //执行人(药剂师)
	...s auditDate=$p(auditinfo,"^",2) //执行日期 
	...s auditTime=$p(auditinfo,"^",3) //执行时间 
	...s auditStatus=$p(auditinfo,"^",4)    //执行状态 
	.../// 医嘱信息
	...s ^WLOST=oeori_"^"_auditStatus
	...s ordinfo=$$OrdInfo(oeori) q:ordinfo=""
	...s ^WLORD=ordinfo
	...s drugname=$p(ordinfo,"^",4)    //药品名称   
	...s doseqty= $p(ordinfo,"^",6)   //剂量 
	...s doseunit= $p(ordinfo,"^",7)   //剂量单位
	...s freq= $p(ordinfo,"^",11)     //频率 
	...s instruction=$p(ordinfo,"^",2)   //治疗方法  
	...s arcic=$p(ordinfo,"^",12)  //医嘱子类
	...s sttdate=$p(ordinfo,"^",13)   //开始日期
	...s stttime=$p(ordinfo,"^",14)  //开始时间
	...s skintestflag=$p(ordinfo,"^",15  ) //皮试
	...s orddate=$p(ordinfo,"^",16)  //医嘱日期
	...s ordtime=$p(ordinfo,"^",19)  //医嘱时间
	...//q:orddate<sd
	...//q:orddate>ed
	...//i orddate=sd q:ordtime<st
	...//i orddate=ed q:orddate>et
	...i orddate'="" s orddate=$zd(orddate,3)
	...i ordtime'="" s ordtime=$zt(ordtime)
	...s doctorname=$p(ordinfo,"^",1)   //医生
	...s qty=$p(ordinfo,"^",17)
	...s uom=$p(ordinfo,"^",18)
	...///
	...s i=i+1
	...s a1=ward_"^"_dept_"^"_pano_"^"_paname_"^"_pabed
	...s a2=drugname_"^"_doseqty_"^"_doseunit_"^"_freq_"^"_instruction
	...s a3=arcic_"^"_sttdate_"^"_stttime_"^"_skintestflag_"^"_doctorname
	...s a4=priority_"^"_oestatedesc_"^"_auditUser_"^"_auditDate_"^"_auditTime
	...s a5=auditStatus_"^"_oeori_"^"_orddate_"^"_qty_"^"_uom
	...s a6=interactReason_"^"_mainoeori_"^"_ordtime_"^"_seqno_"^"_weight
	...S jj=sttdate_"^"_pabed_"^"_pano_"^"_seqno
 	...s ^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj,i)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6
 	...s ^WLPIVA=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6
	///
	s jj=""
	f  s jj=$o(^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj)) q:jj=""  d
	.s k=""  
	.f  s k=$o(^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj,k)) q:k=""  d
	.. s data=^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj,k)
	.. d output(data)
 	k ^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT")
	q $$$OK
output(data)
 	n (data,repid,ind)
	s ward=$p(data,"^",1)
	s dept=$p(data,"^",2)
	s pano=$p(data,"^",3)
	s paname=$p(data,"^",4)
	s bed=$p(data,"^",5)
	s arcimdesc=$p(data,"^",6)
	s doseqty=$p(data,"^",7)
	s doseunit=$p(data,"^",8)
	s freq=$p(data,"^",9)
	s instr=$p(data,"^",10)
	s arcic=$p(data,"^",11)
	s sttdate=$p(data,"^",12)
	s stttime=$p(data,"^",13)
	s skintest=$p(data,"^",14)
	s useradd=$p(data,"^",15)   //doctor name
	s priority=$p(data,"^",16)
	s oeflag=$p(data,"^",17)
	s audituser=$p(data,"^",18)
	s auditdate=$p(data,"^",19)
	s audittime=$p(data,"^",20)
	s auditstatus=$p(data,"^",21)
	s oeori=$p(data,"^",22)
	s orddate=$p(data,"^",23)
	s qty=$p(data,"^",24)
	s uom=$p(data,"^",25)
 	s contraindicationReason=$p(data,"^",26)
 	S moeori=$p(data,"^",27)
 	S ordtime=$p(data,"^",28)
 	S seqno=$p(data,"^",29)
 	S weight=$p(data,"^",30)
	set Data=$lb(oeori,pano,paname,arcimdesc,freq,instr,orddate,useradd,sttdate,stttime,doseqty,doseunit,qty,uom,dept,ward,bed,priority,audituser,auditdate,audittime,auditstatus,arcic,skintest,contraindicationReason,moeori,ordtime,oeflag,seqno,weight)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
 q 
	
PaInfo(adm) 
 //取病人的相关信息
 n (adm)
 q:adm="" ""
 s papmidr=$p($g(^PAADM(adm)),"^",1) q:papmidr="" ""
 s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
 s name=$p($g(^PAPER(papmidr,"ALL")),"^",1)
 s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
 s sex=""
 i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",1)
 s dob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
 s age=+$h-dob   ;days of age
 s ward=$p($g(^PAADM(adm)),"^",70)
 s bed=$p($g(^PAADM(adm)),"^",73)
 s wardcode="",warddesc="",bedno=""
 i ward'="" s wardcode=$p(^PAWARD(ward),"^",1), warddesc=$p(^PAWARD(ward),"^",2)
 i bed'="" s bedno=$p($g(^PAWARD(+bed,"BED",$P(bed,"||",2))),"^",1)  
 ;
 s deptdr=$P(^PAADM(adm),"^",4)
 i deptdr'="" s dept=$p(^CTLOC(deptdr),"^",2)
 S weight=##class(web.DHCSTPIVA).GetPatWeight(adm)
 s result=pano_"^"_name_"^"_sex_"^"_age_"^"_wardcode_"^"_warddesc_"^"_bedno_"^"_dept_"^"_ward_"^"_weight
 q result  
OrdInfo(oeori) 
 //取医嘱的相关信息
 n (oeori)
 s ^WLAR12=oeori
 s ord=+oeori
 s chl=$p(oeori,"||",2)
 q:ord="" ""
 q:chl="" ""
 s useradd=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
 i useradd'="" s useraddname=$p($g(^SSU("SSUSR",useradd)),"^",2 )
 s orddate=$p(^OEORD(ord,"I",chl,3),"^",7) 
 s ordtime=$p(^OEORD(ord,"I",chl,1),"^",17)		;医嘱时间
 s instrdr=$p($G(^OEORD(ord,"I",chl,2)),"^",7)		;医嘱用法
 S instr=""
 i instrdr'="" s instr=$p(^PHCIN(instrdr),"^",2)
 s arcim=$p(^OEORD(ord,"I",chl,1),"^",2) ;医嘱项rowid
 s arcicDr=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",10)
 s arcic=""
 i arcicDr'="" s arcic=$p(^ARC("IC",arcicDr),"^",2)      ;医嘱子类
 s inci=..GetINCI(arcim)
 s ^WLIN=inci
 q:inci="" ""
 s incicode=$p(^INCI(inci,1),"^",1) ;代码
 s incidesc=$p(^INCI(inci,1),"^",2) ;名称
 s spec=##class(web.DHCSTCOMINC).GetSpec(inci)
 s doseqty=$p(^OEORD(ord,"I",chl,2),"^",1)
 s ^WLDO=doseqty						;处方量(剂量)
 s unitdr=$p(^OEORD(ord,"I",chl,2),"^",3)							
 s unit=""
 i unitdr'="" s unit=$p(^CT("UOM",unitdr),"^",2) ;处方量(剂量)单位
 s sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)		;医嘱开始日期
 s freqdr=$p(^OEORD(ord,"I",chl,2),"^",4)		;频率
 s freq=""
 i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
 s sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
 i sttdate'="" s sttdate=$zd(sttdate,3)
 //
 s stttime=$p(^OEORD(ord,"I",chl,1),"^",10)
 i stttime'="" s stttime=$zt(stttime)
 //
 s skintest=##class(web.DHCSTPCHCOLLS2).SkinTest(ord_"||"_chl)
 s skintestflag=""
 i skintest>0 s skintestflag="皮试正常"
 i skintest<0 s skintestflag="皮试不正常"
 s qty=..OrdQty(oeori)  //药品数量
 s uom=""
 i $p(^INCI(inci,1),"^",10)'="" s uom=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2)  //药品数量单位
 //
 s a1=useraddname_"^"_instr_"^"_incicode_"^"_incidesc_"^"_spec
 s a2=doseqty_"^"_unit_"^"_sttdate_"^"_$g(occtime)_"^"_$g(freqfac)
 s a3=freq_"^"_arcic_"^"_sttdate_"^"_stttime_"^"_skintestflag
 s a4=orddate_"^"_qty_"^"_uom_"^"_ordtime
 //
 s result=a1_"^"_a2_"^"_a3_"^"_a4
 s ^WLRES=result
 q result
}

ClassMethod FindOeoriFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOeoriExecute ]
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

ClassMethod FindOeoriClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOeoriExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindOeori(sd As %Library.Date, ed As %Library.Date, st As %String, et As %String, reclocrowid As %String, regno As %String, tWardID As %String, tOecprID As %String, Checked As %String, tPassAudit As %String) As %Query(ROWSPEC = "oeori:%String,tbRegNo:%String,paname:%String,arcimdesc:%String,freq:%String,instr:%String,orddate:%String,useradd:%String,sttdate:%String,stttime:%String,doseqty:%String,doseunit:%String,qty:%String,uom:%String,dept:%String,ward:%String,bed:%String,priority:%String,audituser:%String,auditdate:%String,audittime:%String,auditstatus:%String,arcic:%String,skintest:%String,contraindicationReason:%String,mOeori:%String,ordtime:%String,exestatus:%String,seqno:%String,weight:%String")
{
}

ClassMethod ChemAudited(oeori As %String) As %Integer
{
	//检查是否审核(药剂师)
	// 返回: 1 - 已经审核 
	//     0 - 未审核
	n (oeori)
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	s auth=$p(^OEORD(ord,"I",chl,7),"^",3)
	q:auth="" 0
	q 1
}

ClassMethod Passed(oeori As %String) As %String
{
	n (oeori)
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	s auth=$p($g(^OEORD(ord,"I",chl,7)),"^",3)
	s pass=$p(auth,",",4)
	i pass="SHTG" q 1
	q 0
}

ClassMethod AnaAuth(oeori) As %String
{
	//药师审核信息
	n (oeori)
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	
	s authorize=$p(^OEORD(ord,"I",chl,7),"^",3)
	Q:authorize="" ""
 	s auditor=$P(authorize,",",1)
 	i auditor'="" s auditor=$p($g(^SSU("SSUSR",auditor)),"^",2) 
	s auditdate=$P(authorize,",",2)
	i auditdate'="" s auditdate=$zd(auditdate,3)
	s audittime=$P(authorize,",",3)
	i audittime'="" s audittime=$zt(audittime)
	s auditresult=$P(authorize,",",4)
	i auditresult="SHTG" s auditresult="审核通过"
	i auditresult="SHJJ" s auditresult="审核拒绝"
	i auditresult="ZCDB" s auditresult="正常打包"
	i auditresult="FZCDB" s auditresult="非正常打包"
	q auditor_"^"_auditdate_"^"_audittime_"^"_auditresult
}

ClassMethod MainOeoriAndSeqNo(oeori As %String) As %String
{
 //取主医嘱
 //非关联医嘱或者为主医嘱的返回医嘱本身的值
 n (oeori)
 q:oeori="" "^"
 s ord=$p(oeori,"||",1)
 s itm=$p(oeori,"||",2)
 q:ord="" "^"
 q:itm="" "^"
 ;
 s OEORIDR=$P(^OEORD(ord,"I",itm,11),"^",39)
 i OEORIDR="" s OEORIDR=ord_"||"_itm
 s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
 q OEORIDR_"^"_seqno
}

ClassMethod SetChemAudit(oeori As %String, user As %String, status As %String) As %String
{
 //填写oeori_authorise字段
 n (oeori,user,status)
 s ord=$p(oeori,"||",1)
 s chl=$p(oeori,"||",2)
 s data=user_","_$h_","_status
 i $d(^OEORD(ord,"I",chl,7)) d
 .s $p(^OEORD(ord,"I",chl,7),"^",3)=data
 .s ret=0
 e  s ret=-1
 q ret
}

ClassMethod GetINCI(arcim As %String) As %String
{
 //根据医嘱项rowid取得库存项目的rowid
 n (arcim)
 s ARCIMsub=$p(arcim,"||",1)
 s ARCIMsub=$p(ARCIMsub,$c(1))
 s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
 q $g(INCIrow)
}

ClassMethod OrdQty(oeori) As %String
{
	//取得医嘱中的药品数量
	n (oeori)
	s dodis=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dodis="" ""
	s disptotalqty=$p(^DHCOEDISQTY(dodis),"^",2)  //总数量 
	q disptotalqty
}

ClassMethod GetPaInfo(pano As %String) As %String
{
	n (pano)
	&sql(select papmi_name,papmi_sex_dr->ctsex_desc,nvl(papmi_dob,"") 
	        into :paname,:sex,:dob from pa_patmas
	       where papmi_no=:pano)
	q:SQLCODE ""
	i $g(dob)'="" d
	.s age=$fn((+$h-dob)/365,"",0)
	.s dob=$zd(dob,3)
	.s dob=dob_"( "_age_"岁 )" 
	s result=$g(paname)_"^"_$g(sex)_"^"_ $g(dob)
 q result
}

ClassMethod GetPrintLabelM(moeori As %String) As %String
{
	N (moeori)
	S ord=$P(moeori,"||",1) Q:ord="" ""
	S itm=$P(moeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord)) ""
	S adm=$P(^OEORD(ord),"^",1)	/// 病人 PAADM_Rowid
	Q:adm="" ""
	Q:'$D(^PAADM(adm))
	S ward=$P(^PAADM(adm),"^",70) /// 病人所在病房
	I ward'="" D
	.S:$D(^PAWARD(ward)) ward=$P(^PAWARD(ward),"^",2)
	S pno=""
	S pnumber=""	/// 打印序号
	S batno=""	/// 批次
	S cpno=""
	S cpnumber=""	/// 取消打印的序号
	S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	S pri=##class(web.DHCSTPIVA).GetOePriority(moeori)	/// 优先级
	S pri=$P(pri,"^",3)	
	S freq=##class(web.DHCSTPIVA).GetFreq(moeori)	/// 频率
	S freq=$P(freq,"^",2)
	S patstr=##class(web.DHCSTPIVA).GetOeInfoByMoeori(moeori)	/// 病人信息 bed_"^"_paname_"^"_ipno_"^"_age_"^"_sex
	S sttdate=$P(^OEORD(ord,"I",itm,1),"^",9)	/// 开始日期
	S:sttdate'="" sttdate=$ZD(sttdate,3)
	S dodis=$O(^DHCOEDISQTY(0,"OEORI",moeori,""))
	S stttime=""
	I dodis'="" D
	.S stttime=$p(^DHCOEDISQTY(dodis),"^",20)	/// 执行时间
 	.S:stttime'="" stttime=$ZT(stttime,1)
	S dt=sttdate_" "_stttime
	S TotalLiquid=##class(web.DHCSTPIVA).GetTotalLiquidOe(moeori)
	S pasts=""
	S pastno=""
	S pasts=""
	S pastno=""
	/// S pasts=..GetPasts(pid,phac,adm)
	/// S pastno=..GetPastNo(pid,pog)
	S grpno=""
	S stype="拒"
	S weight=##class(web.DHCSTPIVA).GetPatWeight(adm)
	S pog=""
	S retstr=pog_"^"_moeori_"^"_grpno_"^"_ward_"^"_pno_"^"_pnumber_"^"_batno_"^"_cpno_"^"_cpnumber_"^"_pri_"^"_freq_"^"_instruc_"^"_dt_"^"_TotalLiquid_"^"_pasts_"^"_pastno_"^"_patstr_"^"_stype_"^"_weight
	Q retstr
}

/// 取标签明细信息
ClassMethod GetPrintLabelItm(moeori As %String) As %String
{
	N (moeori)
	S pogistr="",ret=""
	Q:moeori="" ret
	S ord=$P(moeori,"||",1) Q:ord="" ret
	S itm=$P(moeori,"||",2) Q:itm="" ret
	Q:'$D(^OEORD(ord,"I",itm,1)) ret
	S pogistr=..GetOeItm(moeori)
	S gchl=0
	F  S gchl=$o(^OEORDi(0,"OEORI",ord,moeori,gchl)) Q:gchl=""  D
 	.S toeori=ord_"||"_gchl
	.S itmstr=..GetOeItm(toeori)
	.Q:itmstr=""
	.I pogistr="" S pogistr=itmstr
	.E  S pogistr=pogistr_"||"_itmstr
	Q pogistr
}

ClassMethod GetOeItm(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
	S incitm=##class(web.DHCSTPIVA).GetIncItm(oeori)
 	S inci=$P(incitm,"^",1)
 	S incidesc=$P(incitm,"^",3)
	S spec=##class(web.DHCSTCOMINC).GetSpec(inci)
	S dosage=##class(web.DHCSTPIVA).GetDosage(oeori)
	S sign=##class(web.DHCSTPIVA).GetPrintSign(oeori)
	S incidesc=sign_incidesc
	S comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
	S pogistr=incidesc_"^"_dosage_"^"_spec_"^"_comp
	Q pogistr
}

}
