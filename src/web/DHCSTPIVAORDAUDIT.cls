Include webimport

Class web.DHCSTPIVAORDAUDIT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:新版医嘱规则
/// CreatDate:2012-02-23
/// Creator:LiangQiang
ClassMethod FindOeoriExecute(ByRef qHandle As %Binary, sd As %Library.Date, ed As %Library.Date, st As %String, et As %String, reclocrowid As %String, regno As %String, tWardID As %String, tOecprID As %String, Checked As %String, tPassAudit As %String, tNotAudit As %String, tOecType As %String, tItmID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1 	
	q:sd="" $$$OK
	q:ed="" $$$OK
	q:tWardID="" $$$OK
	s sd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(sd)
	s ed=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ed)
	i st="" s st=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical("00:00:00")
	i et="" s et=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical("23:59:59")
	s pid=$i(^RETRIEVEORDITMTOCHEMAUDIT)
	s LastMainOrd=""  //上次的主医嘱Rowid
	s WardDr=tWardID
	s WardLocDr=$p(^PAWARD(WardDr),"^",5)	
	f date=sd:1:ed d
	.s DspId=""
    .F  s DspId=$O(^DHCOEDISQTY(0,"REC",reclocrowid,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d  //DSP_Category为0的数据是配液中心的 //add wyx 
	..s oeori=$P(^DHCOEDISQTY(DspId),"^",1)
	..s Ord=+oeori
	..s Chl=$p(oeori,"||",2)
	..s AdmDr=$p(^OEORD(Ord),"^",1)
	..s painfo=$$PaInfo(AdmDr)
	..q:painfo=""
	..s pano=$p(painfo,"^",1)   //登记号 
	..s pabed= $p(painfo,"^",7)  //床号 
	..s paname= $p(painfo,"^",2)  //姓名  
	..s dept =$p(painfo,"^",8)  //科室   
	..s ward =$p(painfo,"^",6) //病区
	..s wardid=$p(painfo,"^",9) //病区ID
	..S weight=$p(painfo,"^",10) //体重
	..s allergy=$p(painfo,"^",11) //过敏史
	..s wardid=WardDr
	..s ward=""
	..i wardid'="" s ward=$p(^PAWARD(wardid),"^",2)
	..q:(regno'="")&(pano'=regno)
	..s AdmWard=$p(^PAADM(AdmDr),"^",70)  		;病人当前病房
	..q:wardid'=WardDr //yunhaibao,20160225,统一以dhcoedispsing病区为准
    ..s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
    ..q:AdmType'="I"  							;过滤非住院病人
    ..s papmi=$p($g(^PAADM(AdmDr)),"^",1)
    ..s EncryptLevelInfo=""
    ..s EncryptLevel=""
    ..s PatLevel=""
    ..s HospID=$p($g(^CTLOC(reclocrowid)),"^",22)
    ..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospID)
    ..i EncryptFlag=1 d
    ...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	...s PatLevel=$p(EncryptLevelInfo,"^",2)
    ..//s Chl=0
	..//F  S Chl=$o(^OEORDi(0,"LocStDtArr",reclocrowid,0,date,Ord,Chl)) Q:Chl=""  D
	..//s oeori=Ord_"||"_Chl  //ROWID
    ..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)
    ..s ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	..////q:ChkOrdState'=1
	..///// 医嘱状态
	..S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)	/// 医嘱核实、未核实、停止状态
	..S oeflag=$P(oestate,"^",1)
	..q:(oeflag'="V")&(oeflag'="E")&(ChkOrdState'=1)&(Checked=0) //判断医嘱和执行都不停止 20151110  zhouyg
	..//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //检查是否配液 //zhouyg 20150624 注释
	..S oestatedesc=$P(oestate,"^",2)
	..S mainoeori=##class(web.DHCSTPIVA).GetMainOeori(oeori) // 主医嘱
	..S seqno=$P(^OEORD(Ord,"I",Chl,3),"^",4)		/// 关联医嘱号
	../// 优先级
	..S pri=##class(web.DHCSTPIVA).GetOePriority(mainoeori)
	..S pridr=$P(pri,"^",1)
	..Q:pridr=""
	..Q:$O(^PIVAO(0,"OECPR",reclocrowid,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	..Q:(tOecprID'="")&(tOecprID'=pridr)
	..S oepri=##class(web.DHCSTPIVA).GetOePriority(oeori)
	..S priority=$P(oepri,"^",3)
	..///// 护士审核
	..//S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	..//Q:(tNotAudit'="on")&(Audited=0) /// 护士未审
	../// 护士审核
	..S Audited=##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)
	..Q:(tNotAudit'="on")&(Audited=0) /// 护士未审核
	../// 药剂师已经审核
	..S ifchemaudit=..ChemAudited(oeori)
	..Q:Checked'=ifchemaudit
	../// 已经出院结算
	..Q:(Checked=0)&(##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmDr)=1) 
	../// 配伍审核
	..S chstr=##class(web.DHCSTPIVA).GetPassResult(oeori)
	..Q:(tPassAudit'="")&($p(chstr,",",4)'=tPassAudit) 
	../// 医嘱子分类 
    ..S arccat=##class(web.DHCSTPIVA).GetArcItmCat(oeori)
    ..s arccatid=$P($G(arccat),"^",1)
    ..Q:arccatid=""
    ..Q:$O(^PIVAA(0,"ARCIC",arccatid,""))="" ///  配液医嘱子分类没有维护 
	../// 配液分类 
	..i LastMainOrd'=mainoeori d
	...i (Checked'=0) s ptypestr=##class(web.DHCSTPIVA).GetAuditedType(oeori)
	...i (Checked=0) s ptypestr=##class(web.DHCSTPIVA).GetPivaType(oeori)
	..s typeID=$p(ptypestr,"^",1)
	..s typeID=$p(ptypestr,"^",1)
	..Q:(tOecType'="")&(tOecType'=$g(typeID))
	..///医嘱是否包含库存项
	..S qflag=0
 	..I tItmID'="" D
 	...S qflag=##class(web.DHCSTPIVA).ChkExItm(oeori,tItmID)
 	..Q:(tItmID'="")&(qflag=0) 
	../// 护士审核信息
	..S wauditinfo=##class(web.DHCSTPIVA).GetAuditByWard(oeori)
	..s wauditUser=$p(wauditinfo,"^",1)   //执行人(药剂师)
	..s wauditDate=$p(wauditinfo,"^",2) //执行日期 
	..s wauditTime=$p(wauditinfo,"^",3) //执行时间 
	..//S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
 	..//S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
	../// 禁忌原因
	..s interactReason=""
	..s interactReasonDr=$p($g(^OEORD(Ord,"I",Chl,9)),"^",8)
	..i interactReasonDr'="" s interactReason=$P(^OEC("ALR",interactReasonDr),"^",2)
	../// 审核信息
	..s auditinfo=..AnaAuth(oeori)
	..s auditUser=$p(auditinfo,"^",1)   //执行人(药剂师)
	..s auditDate=$p(auditinfo,"^",2) //执行日期 
	..s auditTime=$p(auditinfo,"^",3) //执行时间 
	..s auditStatus=$p(auditinfo,"^",4)    //执行状态 
	..s auditReason=$p(auditinfo,"^",5)    //执行不通过原因 
	../// 医嘱信息
	..s ordinfo=$$OrdInfo(oeori) q:ordinfo=""
	..s drugname=$p(ordinfo,"^",4)    //药品名称   
	..s doseqty= $p(ordinfo,"^",6)   //剂量 
	..s doseunit= $p(ordinfo,"^",7)   //剂量单位
	..s freq= $p(ordinfo,"^",11)     //频率 
	..s instruction=$p(ordinfo,"^",2)   //治疗方法  
	..s arcic=$p(ordinfo,"^",12)  //医嘱子类
	..s sttdate=$p(ordinfo,"^",13)   //开始日期
	..s stttime=$p(ordinfo,"^",14)  //开始时间
	..s skintestflag=$p(ordinfo,"^",15  ) //皮试
	..s orddate=$p(ordinfo,"^",16)  //医嘱日期
	..s qty=$p(ordinfo,"^",17)		//医嘱数量
	..s ordtime=$p(ordinfo,"^",19)  //医嘱时间
	..i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate,"PIVA")
	..i ordtime'="" s ordtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ordtime,"PIVA")
	..s doctorname=$p(ordinfo,"^",1)   //医生
	..s uom=$p(ordinfo,"^",18)
	..s comp=##class(web.DHCSTPIVA).GetCompFlag(oeori)	/// 剂量是否整包装
	..s remark=##class(web.DHCSTPIVA).GetOrdItmRemark(oeori)
	..s drugcatdr=$p(ptypestr,"^",1) //药学分类(或子类)rowid
	..s drugcatdesc=$p(ptypestr,"^",2) //药学分类(或子类)描述
	..s ordexe=$o(^OEORD(Ord,"I",Chl,"X",0)) //取执行表的第一个
	..s sttdate=$p(^OEORD(Ord,"I",Chl,"X",ordexe),"^",1) 
	..s sttdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sttdate,"PIVA")
	..s stttime=$p(^OEORD(Ord,"I",Chl,"X",ordexe),"^",2)   ;分发时间
	..s stttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stttime,"PIVA")
	..//s qty=$p(^DHCOEDISQTY(DspId),"^",11)
	..//每五个一行
	..s data1=ward_"^"_dept_"^"_pano_"^"_paname_"^"_pabed
	..s data2=drugname_"^"_doseqty_"^"_doseunit_"^"_freq_"^"_instruction
	..s data3=arcic_"^"_sttdate_"^"_stttime_"^"_skintestflag_"^"_doctorname
	..s data4=priority_"^"_oestatedesc_"^"_auditUser_"^"_auditDate_"^"_auditTime
	..s data5=auditStatus_"^"_oeori_"^"_orddate_"^"_qty_"^"_uom
	..s data6=interactReason_"^"_mainoeori_"^"_ordtime_"^"_seqno_"^"_weight
	..s data7=comp_"^"_remark_"^"_wauditUser_"^"_wauditDate_"^"_wauditTime
	..s data8=drugcatdr_"^"_drugcatdesc_"^"_auditReason_"^"_EncryptLevel_"^"_PatLevel_"^"_allergy
	..i '$f(seqno,".") s seqno=seqno_".0" 
	..S jj=sttdate_"^"_pabed_"^"_pano_"^"_seqno_"^"_oeori
	..i '$d(^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj)) d
	...s ^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5_"^"_data6_"^"_data7_"^"_data8
	..e  d
	...s $p(^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj),"^",24)=$p(^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj),"^",24)+qty
	///输出数据
 	s hh=0
 	s lpano=""
 	s patcolor="W"
	s jj=""
	f  s jj=$o(^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj)) q:jj=""  d
	. s data=^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT",jj)
	. s hh=hh+1
	. d output(data)
	//
	//合理用药
	s moeori=""
	f  s moeori=$o(^TMP(pid,"PassOrd",moeori)) q:moeori=""  d
	.s str=^TMP(pid,"PassOrd",moeori)
	.s seqno=$p(str,"#",1)
	.s ^TMP(pid,"PassPresc",seqno)=str
	.
	k ^TMP(pid,"PassOrd")
 	k ^TMP(pid,"RETRIEVEORDITMTOCHEMAUDIT")
	q $$$OK
output(data)
 	n (data,repid,ind,pid,hh,lpano,patcolor)
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
	s sttdate=$p(data,"^",12) ;_" "_stttime
	s stttime=$p(data,"^",13)
	//s sttdate=sttdate_" "_stttime
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
 	S comp=$p(data,"^",31)
 	S remark=$p(data,"^",32)
 	S waduitUser=$p(data,"^",33)
 	S waduitDate=$p(data,"^",34)
 	S waduitTime=$p(data,"^",35)
 	S drugcatdr=$p(data,"^",36)
 	S drugcatdesc=$p(data,"^",37)
 	S areason=$p(data,"^",38)
 	S EncryptLevel=$p(data,"^",39)
 	S PatLevel=$p(data,"^",40)
 	s allergy=$p(data,"^",41)
 	s colortypeStr=##class(web.DHCSTPIVA).GetColorType(pano,lpano,oeflag,auditstatus,patcolor,"")
 	s colortype=$p(colortypeStr,"^",1)
 	s patcolor=$p(colortypeStr,"^",2)
 	s lpano=pano
 	
 	//合理用药
 	i $d(^TMP(pid,"PassOrd",moeori)) d
 	.s ^TMP(pid,"PassOrd",moeori)=^TMP(pid,"PassOrd",moeori)_"^"_oeori
 	e  d
 	.s ^TMP(pid,"PassOrd",moeori)=hh_"#"_oeori
 	//
	set Data=$lb(oeori,pano,paname,arcimdesc,freq,instr,orddate,useradd,sttdate,stttime,doseqty,doseunit,qty,uom,dept,ward,bed,priority,audituser,auditdate,audittime,auditstatus,arcic,skintest,contraindicationReason,moeori,ordtime,oeflag,seqno,weight,comp,remark,waduitUser,waduitDate,waduitTime,drugcatdr,drugcatdesc,areason,pid,colortype,EncryptLevel,PatLevel,allergy)
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
 s allergy=..GetPAAllergy(papmidr,$c(13,10))
 s result=pano_"^"_name_"^"_sex_"^"_age_"^"_wardcode_"^"_warddesc_"^"_bedno_"^"_dept_"^"_ward_"^"_weight_"^"_allergy
 q result  
OrdInfo(oeori) 
 //取医嘱的相关信息
 n (oeori)
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
 q:inci="" ""
 s incicode=$p(^INCI(inci,1),"^",1) ;代码
 s incidesc=$p(^INCI(inci,1),"^",2) ;名称
 s spec=##class(web.DHCSTCOMINC).GetSpec(inci)
 s doseqty=$p(^OEORD(ord,"I",chl,2),"^",1) ;处方量(剂量)
 s unitdr=$p(^OEORD(ord,"I",chl,2),"^",3)							
 s unit=""
 i unitdr'="" s unit=$p(^CT("UOM",unitdr),"^",2) ;处方量(剂量)单位
 s freqdr=$p(^OEORD(ord,"I",chl,2),"^",4)		;频率
 s freq=""
 i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
 s sttdah=$p(^OEORD(ord,"I",chl,1),"^",9)
 s sttdate=""
 i sttdah'="" s sttdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sttdah,"PIVA")
 //
 s stttime=$p(^OEORD(ord,"I",chl,1),"^",10)
 i stttime'="" s stttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stttime,"PIVA")
 //
 s skintest=##class(web.DHCSTPIVA).SkinTest(ord_"||"_chl)
 s skintestflag=""
 ;i skintest>0 s skintestflag="皮试正常"
 ;i skintest<0 s skintestflag="皮试不正常"
 i skintest>0 s skintestflag="皮试( - )"
 i skintest<0 s skintestflag="皮试( + )"
 i skintest=-5 s skintestflag="皮试(   )"
 //s qty=..OrdQty(oeori,sttdah)  //药品数量
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

Query FindOeori(sd As %Library.Date, ed As %Library.Date, st As %String, et As %String, reclocrowid As %String, regno As %String, tWardID As %String, tOecprID As %String, Checked As %String, tPassAudit As %String, tNotAudit As %String, tOecType As %String, tItmID As %String) As %Query(ROWSPEC = "oeori:%String,tbRegNo:%String,paname:%String,arcimdesc:%String,freq:%String,instr:%String,orddate:%String,useradd:%String,sttdate:%String,stttime:%String,doseqty:%String,doseunit:%String,qty:%String,uom:%String,dept:%String,ward:%String,bed:%String,priority:%String,audituser:%String,auditdate:%String,audittime:%String,auditstatus:%String,arcic:%String,skintest:%String,contraindicationReason:%String,mOeori:%String,ordtime:%String,exestatus:%String,seqno:%String,weight:%String,comp:%String,remark:%String,TwaduitUser:%String,TwaduitDate:%String,TwaduitTime:%String,Tdrugcatdr:%String,Tdrugcatdesc:%String,Tareason:%String,tPid:%String,TordColorType:%String,TEncryptLevel:%String, TPatLevel:%String,allergy:%String")
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
	i auditdate'="" s auditdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(auditdate,"PIVA")
	s audittime=$P(authorize,",",3)
	i audittime'="" s audittime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(audittime,"PIVA")
	s auditresult=$P(authorize,",",4)
	i auditresult="SHTG" s auditresult="审核通过"
	i auditresult="SHJJ" s auditresult="审核拒绝"
	i auditresult="ZCDB" s auditresult="正常打包"
	i auditresult="FZCDB" s auditresult="非正常打包"
	s auditreasondr=$P(authorize,",",6)
	i auditreasondr'="" s auditreason=$p($g(^PIVAOR(auditreasondr)),"^",2)
	q auditor_"^"_auditdate_"^"_audittime_"^"_auditresult_"^"_$g(auditreason)
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

/// 取消审核
ClassMethod SetChemAudit(oeori As %String, user As %String, status As %String, type = "", resdondr = "") As %String
{
 //填写oeori_authorise字段
 n (oeori,user,status,type,resdondr)
 s ord=$p(oeori,"||",1)
 s chl=$p(oeori,"||",2)
 s data=user_","_$h_","_status
 s data=data_","_type //分类
 i resdondr'="" s data=data_","_resdondr //不通过原因
 i status="" s data="" 
 S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)
 Q:moeori="" -1
 s ret=0
 i status="" d
 .s mord=+moeori,mchl=$p(moeori,"||",2)
 .s mainoedsp=##Class(web.DHCSTPIVA).GetFDspIDByOeori(moeori)	
 .i $d(^PIVA(0,"OEGRP",mainoedsp)) s ret=100
 .i $d(^PIVABU(0,"OEGRP",mainoedsp)) s ret=101
 q:ret'=0 ret
 s moedisp=##Class(web.DHCSTPIVA).GetFDspIDByOeori(oeori)	//zhouyg 2015-11-03
 i $d(^OEORD(ord,"I",chl,7)) d
 .i $d(^PIVA(0,"OEGRP",moedisp)) s ret=100
 .Q:ret=100
 .s $p(^OEORD(ord,"I",chl,7),"^",3)=data
 .//审核拒绝插入医嘱审核表,用于统计工作量yunhaibao20160519
 .s auditflag="",auditnote=""
 .i data["SHJJ" s auditflag="N",auditnote="配液审核拒绝"
 .e  i data["SHTG" s auditflag="Y",auditnote="配液审核通过"
 .i auditflag'="" d
 ..i '$d(^DHCPHORDM(0,"OrdItem",moeori)) d
 ...s PLIST(2)=user
 ...s PLIST(3)=auditflag
 ...s PLIST(4)=+$h
 ...s PLIST(5)=$p($h,",",2)
 ...s PLIST(6)=$p(^OEORD(ord,"I",chl,3),"^",6)
 ...s PLIST(7)=auditnote
 ...s PLIST(10)="PIVAS"
 ...&sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
 ...s phaomr=+%ROWID
 ...k PLIST
 ...s PLIST(0)=phaomr
 ...s PLIST(2)=moeori
 ...s PLIST(4)=""
 ...s PLIST(3)=1
 ...s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""))+1
 ...s PLIST(6)=$p(^OEORD(ord,"I",chl,1),"^",14)
 ...&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
 .i (data'["SHJJ")&&(data'["SHTG") d
 ..i $d(^DHCPHORDM(0,"OrdItem",moeori)) d
 ...s phaomr=$o(^DHCPHORDM(0,"OrdItem",moeori,""))
 ...&SQL(delete from DHC_PHAORDMONITOR where PHAOM_ROWID=:phaomr)
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

ClassMethod OrdQty(oeori, dah = "") As %String
{
	//取得医嘱中的药品数量
	n (oeori,dah)
	//zhouyg 20141220 dah允许传入为空,取第一天的数量,改为取单次数量
	i dah="" d
	.s dah=$o(^DHCOEDISQTY(0,"SEQNO",oeori,dah))
	q:dah="" 0
	s seqno="",disptotalqty=0
	s seqno=$o(^DHCOEDISQTY(0,"SEQNO",oeori,dah,seqno))
	q:seqno="" 0
	s dodis=$o(^DHCOEDISQTY(0,"SEQNO",oeori,dah,seqno,""))
	s disptotalqty=$p(^DHCOEDISQTY(dodis),"^",5)
	//f  s seqno=$o(^DHCOEDISQTY(0,"SEQNO",oeori,dah,seqno)) q:seqno=""  d
	//.s dodis=""
	//.f  s dodis=$o(^DHCOEDISQTY(0,"SEQNO",oeori,dah,seqno,dodis)) q:dodis=""  d
	//..s disptotalqty=disptotalqty+$p(^DHCOEDISQTY(dodis),"^",5)  //总数量 
	q disptotalqty
}

ClassMethod GetPaInfo(pano As %String) As %String
{
	n (pano)
	&sql(select papmi_name,papmi_sex_dr->ctsex_desc,nvl(papmi_dob,"") 
	        into :paname,:sex,:dob from pa_patmas
	       where papmi_no=:pano)
	q:SQLCODE ""
	s pmi=$o(^PAPERi("PAPMI_PatNo",pano,""))
    s dob=##class(web.DHCSTKUTIL).GetAge(pmi,"") //年龄统一调用接口wyx 2015-01-29
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
	S:sttdate'="" sttdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sttdate,"PIVA")
	S dodis=$O(^DHCOEDISQTY(0,"OEORI",moeori,""))
	S stttime=""
	I dodis'="" D
	.S stttime=$p(^DHCOEDISQTY(dodis),"^",20)	/// 执行时间
 	.S:stttime'="" stttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stttime,"PIVA")
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

Query GetNotAuditWard(tPLocID As %String, tStartDate As %Library.Date, tEndDate As %Library.Date, tWardID As %String, tOecprID As %String, TypeList, AuditFlag As %String = "") As %Query(ROWSPEC = "tbPID:%String,tbWard:%String,tbWardID:%String")
{
}

ClassMethod GetNotAuditWardExecute(ByRef qHandle As %Binary, tPLocID As %String, tStartDate As %Library.Date, tEndDate As %Library.Date, tWardID As %String, tOecprID As %String, TypeList, AuditFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1 	
	q:tPLocID="" $$$OK
	q:tStartDate="" $$$OK
	q:tEndDate="" $$$OK
	S PID=""
	S PID=..GetWardList(tPLocID, tStartDate, tEndDate,tWardID,tOecprID,TypeList,AuditFlag)
	Q:PID="" $$$OK
	S wardid=""
	F  S wardid=$O(^TMP("PIVA",PID,"WARDLIST",wardid)) Q:wardid=""  D
	.S warddesc=^TMP("PIVA",PID,"WARDLIST",wardid)
	.i $F(warddesc,"-") s warddesc=$p(warddesc,"-",2)
	.S ^CacheTemp(repid,ind)=$LB(PID,warddesc,wardid)	
 	.S ind=ind+1
 	D ..ClearAllTmp(PID)
 	Q $$$OK
}

ClassMethod GetNotAuditWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNotAuditWardExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNotAuditWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNotAuditWardExecute ]
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

ClassMethod GetWardList(tPLocID As %String, tStartDate As %String, tEndDate As %String, tWardID As %String, tOecprID As %String, TypeList, AuditFlag As %String) As %Integer
{
	N (tPLocID,tStartDate, tEndDate,tWardID,tOecprID,TypeList,AuditFlag)
	S PID=..NewPid()
	Q:tPLocID="" ""
	Q:tStartDate="" ""
	Q:tEndDate="" ""
	D ..ClearAllTmp(PID)
	S LastMainOrd=""
	s WardID=tWardID
	S i=0,nn=0
	F date=tStartDate:1:tEndDate D
	.s WardLocDr=""
	.F  s WardLocDr=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr)) q:WardLocDr=""  d
	..s WardRowid=$o(^PAWARD(0,"WARD_LocationDR",WardLocDr,""))
	..s DspId=""
	..s flag=0
    ..F  s DspId=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,"TC",WardLocDr,0,DspId)) q:DspId=""  d // DSP_Category为0的数据是配液中心的 //add wyx 
	...s Ord=""
	...s oeori=$P(^DHCOEDISQTY(DspId),"^",1)
	...s Ord=+oeori
	...s Chl=$p(oeori,"||",2)
	...s AdmDr=$p(^OEORD(Ord),"^",1)
	...Q:AdmDr=""
	...s AdmWard=$p(^PAADM(AdmDr),"^",70)  		;病人当前病房
	...q:AdmWard=""
	...Q:$D(^TMP("PIVA",PID,"WARDLIST",WardRowid))
	...Q:##class(web.DHCSTPIVA).CheckWard(WardID,WardRowid)=0
    ...s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
    ...q:AdmType'="I"  							;过滤非住院病人
    ...Q:##Class(web.DHCSTPIVA).IfQuitAdmStatusD(AdmDr)=1	//已经结算退出
    ...S warddesc=$p($G(^PAWARD(WardRowid)),"^",2)
	...Q:warddesc=""
	...// 医嘱状态
    ...s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)
    ...s ChkOrdState=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
	...//q:ChkOrdState'=1
	...S oestate=##class(web.DHCSTPIVA).GetOeState(oeori)	/// 医嘱核实、未核实、停止状态
	...S oeflag=$P(oestate,"^",1)
	...q:(oeflag'="V")&(oeflag'="E")&(ChkOrdState'=1)	//医嘱停止同时执行也停止的，才退出20151110 zhouyg
	...//Q:##Class(web.DHCSTPIVA).IfQuitPIVA(oeori)=1 //检查是否配液 //zhouyg 20150624 注释
	...// 药剂师已经审核
	...S ifchemaudit=..ChemAudited(oeori) 
	...Q:(ifchemaudit=1)&(AuditFlag'=1)
	...Q:(ifchemaudit'=1)&(AuditFlag=1)
	...// 医嘱子分类 
    ...S arccat=##class(web.DHCSTPIVA).GetArcItmCat(oeori)
    ...s arccatid=$P($G(arccat),"^",1)
    ...Q:arccatid=""
    ...Q:$O(^PIVAA(0,"ARCIC",arccatid,""))="" ///  配液医嘱子分类没有维护
    ...S mainoeori=##class(web.DHCSTPIVA).GetMainOeori(oeori) // 主医嘱 
    ...S pri=##class(web.DHCSTPIVA).GetOePriority(mainoeori)
	...S pridr=$P(pri,"^",1)
	...Q:pridr=""
	...Q:$O(^PIVAO(0,"OECPR",tPLocID,pridr,""))=""  	/// 没有维护科室配液的医嘱优先级
	...Q:(tOecprID'="")&(pridr'=tOecprID)
    ...// 护士未审核
	...//S Audited=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)
	...//Q:(Audited=0) 
	...s locset=##class(web.DHCSTPHALOC).GetPhaflag(tPLocID)
	...s tNotAudit=$p(locset,"^",11)
	...S Audited=##class(web.DHCSTPIVA).IfAuditByPriority(oeori,pridr)
	...Q:(tNotAudit="Y")&(Audited=0) /// 护士未审核
	...i LastMainOrd'=mainoeori d
	....s ptypestr=##class(web.DHCSTPIVA).GetPivaType(mainoeori)
    ....s typeID=$p(ptypestr,"^",1)
    ...Q:##class(web.DHCSTPIVA).CheckLimitType(TypeList,typeID)=0
    ...S LastMainOrd=mainoeori
	...S i=i+1
	...S flag=1
	..S:flag=1 ^TMP("PIVA",PID,"WARDLIST",WardRowid)=warddesc
	Q:i>0 PID
	Q ""
}

ClassMethod NewPid() As %String
{
 	Q $I(^DHCSTPIVA("WARDLIST"))
}

ClassMethod ClearAllTmp(pid As %String) As %String
{
	D ..CLEARTMP(pid,"WARDLIST")
}

ClassMethod CLEARTMP(pid As %String, PAR As %String) As %String
{
	K ^TMP("PIVA",pid,PAR)
}

/// 是否发完药 0 - 发完 ,1 -未发完
ClassMethod CheckTC(oeori As %String) As %String
{
 n (oeori)
 s tcflac=0
 s dodis=""
 F  S dodis=$O(^DHCOEDISQTY(0,"OEORI",oeori,dodis)) Q:dodis=""  D
 .s dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 .i dspstatus="TC" d
 ..s tcflac=1
 q tcflac
}

/// 返回合理用药医嘱Rowid
ClassMethod ListPassOrd(pid, oeori) As %String
{
	n (pid,oeori)
	s i=$o(^TMP(pid,"PassPresc",oeori))
	q:i="" ""
	s str=^TMP(pid,"PassPresc",i)
	q str
}

/// 清除合理用药医嘱Rowid
ClassMethod ClearTmpAfterDatong(pid) As %String
{
	n (pid)
	i $d(^TMP(pid,"PassPresc")) d
	.k ^TMP(pid,"PassPresc")
	q
}

/// 过敏史
/// w ##class(web.DHCSTPIVAORDAUDIT).GetPAAllergy(650,",")
ClassMethod GetPAAllergy(PatientID As %String, DelimStr As %String) As %String
{
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.DHCPAAllergy:Allergies")
	d obj.Execute(PatientID)
	For  Quit:'obj.Next()  Do
	.s Rowid=obj.Data("RowID")
	.s Allergen=obj.Data("Allergen")
	.s ALGItem=obj.Data("ALGItem")
	.s comm=$G(^PAPER(PatientID,"ALG",$P(Rowid,"||",2),"CMT",1))
    .S Desc=""
	.i Allergen'="" S Desc=Allergen
	.i ALGItem'="" D
	..I Desc="" S Desc=ALGItem
	..E  S Desc=Desc_","_ALGItem
	.I comm'="" D
	..I Desc="" S Desc=comm
	..E  S Desc=Desc_","_comm
	.Q:Desc=""
	.s i=i+1
	.s Desc=i_"."_Desc
	.if retval="" s retval=Desc
	.e  s retval=retval_DelimStr_Desc
	d obj.Close()
	Q retval
}

}
