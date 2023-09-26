Import sqluser

Class web.DHCEMPhysiOreSheet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 928;

ClassMethod getphbasnum(dosunit, dosqty, scrip, ver) As %String
{
 //求剂量基本单位   149, 1000                 //540,1
    s drgfrm=$P(^ARCIM(scrip,ver,1),"^",12)
    s drg=+drgfrm,frm=$P(drgfrm,"||",2)
    s basuom=$P(^PHCD(+drgfrm,"DF",frm,2),"^",4)
    b
    if basuom=dosunit q dosqty_$p($g(^CT("UOM",basuom)),"^",2)
    s eqrw=0 f  s eqrw=$O(^PHCD(drg,"DF",frm,"EQ",eqrw)) q:eqrw=""  d
    .s equnit=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",1)
    .if equnit=dosunit d
    ..s eqval=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",2)
    if $G(eqval)'="" d
    .s num=dosqty/eqval
    .s ret=$FN(num,"",0)_$p($g(^CT("UOM",basuom)),"^",2)
    q $G(ret)
}

ClassMethod skinnote(Ord, OrdSub)
{
	n (Ord,OrdSub)
	s notes=""
	s notesdr=$P($G(^OEORD(Ord,"I",OrdSub,11)),"^",21)
    if notesdr'="" s notes=$P($g(^OEC("ACT",notesdr)),"^",2)
    q notes
}

ClassMethod getanloc() As %String
{
 //获取麻醉科室dr
	s num=$L(^DHCANOPSET("anloc"),"^")
 	f i=1:1:num
 	{   s detstr=$P(^DHCANOPSET("anloc"),"^",i)
	 	s rw=$P(prior,"|")
	 	s depdr=$G(depdr)_"^"_rw
	}
	q $G(depdr)_"^"
}

/// Description: 医嘱单查询
/// Creator:     congyue
/// CreateDate:  2016-08-14
/// Table: 		 
/// Input:  	 
/// Return： 	 医嘱单信息
/// Others:		 w ##class(web.DHCEMPhysiOreSheet).QueryGetTempOrdInfo(0,10,"592","","","","0","11","1","0","0","临时医嘱")
ClassMethod QueryGetTempOrdInfo(offset = 0, limit = 10, Adm, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0", ssuser As %String = "", CurDep = "", NurOrd, DocOrd, OrdType) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPhysiOreSheet","GetTempOrd","418","64142","64142","","0","11","1","0","0")
	n (offset , limit , Adm,StartDate,EndDate,ChangeDate,stop,ssuser,CurDep,NurOrd,DocOrd,OrdType)
	s ^oio("KKKK")=Adm_"^"_StartDate_"^"_EndDate_"^"_ChangeDate_"^"_stop_"^"_ssuser_"^"_CurDep_"^"_NurOrd_"^"_DocOrd
	
	S:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) //hxy $zdh(StartDate,3)
	S:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) //hxy $zdh(EndDate,3)
	
	S End = offset+limit
	S Start = offset+1
    S count=0,h=0
    Q:Adm="" "{""rows"":[],""total"":"_count_"}"
	w "{""rows"":["
 	s ind=1
    s nvar=""
    k ^mtemp($J,"temp",Adm)
    k ^OrdList($j,Adm)
    s ^cjbtest("ttttttt",Adm)=$J_"^"_StartDate_"^"_EndDate_"^"_ChangeDate_"^"_stop_"^"_ssuser_"^"_CurDep_"^"_NurOrd_"^"_DocOrd
    s adm=Adm
    s UsrTyp=##class(web.DHCLONGTIMEORD).ssusertyp(ssuser)
    s AdmType=$P(^PAADM(Adm),"^",2)
    d ..GetPatLoc(Adm)
    s depnum=1,OrdSub=""
    if CurDep=""  s depno=1  //s CurDep=$P(^PAADM(Adm),"^",4)
    e  s depno=CurDep
    //S ^DHCOEOrdPrintSet("OrdTyp")="^长期医嘱^自备药-长期医嘱^取药医嘱^出院带药^"
    ;S ^DHCOEOrdPrintSet("OrdTyp")="^自备药-长期医嘱^取药医嘱^"
	//S ^DHCOEOrdPrintSet("OrdCat")="^14^15^16^"
	//s ^DHCDoctorDep("Dep")="^214^" //214-住院麻醉 //过滤某些科室
	s num=0,i=""
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d 
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	..s OrdDep=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",3)
	..q:OrdDep=""
	..s odt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7),otim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s ODTim=odt*86400+otim
	..s depnum=##class(web.DHCLONGTIMEORD).getdepno(adm,ODTim)
	..q:(depnum'=depno)&&(depnum'="")  //depno 转科顺序号
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..//保存开医嘱时间于OrderTime()中
	..s OrderTime(Oew,OrdSub)=OrdTime
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR="" q //ypz
	..s PriorDes=$P(^OECPR(PriorDR),"^",2)
	..;b ;12
	..q:(OrdType'="")&(OrdType'[PriorDes)
	..;b ;1234
	..s oecprCode=$P(^OECPR(PriorDR),"^",1)
	..s PriorDes="^"_PriorDes_"^"
	..;q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)  //cy  gai 
	..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	..q:user=""
	..q:'$D(^SSU("SSUSR",user))
	..s DoctorDr=$P($g(^SSU("SSUSR",user)),"^",14)
	..q:DoctorDr=""  
	..s Notes=""
	..s truedoc=0
	..s DocLoc=""
	..f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	...if $D(^TMP($J,"loc",adm,DocLoc))  s truedoc=1
	..f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	...s Notes=Notes_$tr(^OEORD(Oew,"I",OrdSub,"DEP",rnum)," ","")
	..if $G(Notes)'="" d
	...s Notes="("_$G(Notes)_")"
	..i $G(Notes)="" s Notes=""
	..i DoctorDr'=""  s Doctor=$P($g(^CTPCP(DoctorDr,1)),"^",2) ;write doctor oeori_doctor_dr
	..e  s Doctor=""
    ..if DoctorDr'="" s CpTypDR=$P($g(^CTPCP(DoctorDr,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	..;if '$D(^CT("CPT",CpTypDR)) w !,DoctorDr
	..q:$g(CpTypDR)=""
	..q:'$D(^CT("CPT",CpTypDR))
	..s CpTyp=""
	..i $G(CpTypDR)'="" s CpTyp=$P($g(^CT("CPT",CpTypDR)),"^",4)  ;CT_CarPrvTp
	..q:($G(CpTyp)'="DOCTOR")&($G(^DHCOEOrdPrintSet("ifnur"))'="true")  //&(UsrTyp'="NURSE")  //ypz 061102
	..s SchLoc=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",2) // + 屏蔽科室修改，取开医嘱科室 090310
	..s SchLoc=$p(SchLoc,$c(1))
	..s SchLoc="^"_$G(SchLoc)_"^"
	..s lsNotLoc=$G(^DHCOEOrdPrintSet("NotLoc"))
	..q:($G(^DHCOEOrdPrintSet("NotLoc"))[SchLoc)&((lsNotLoc'="^^")!(lsNotLoc'="")) // +
	..if (NurOrd'=0)&(DocOrd=0)&($G(CpTyp)="DOCTOR") q
	..if (DocOrd'=0)&(NurOrd=0)&($G(CpTyp)="NURSE") q
    ..s DateEx="",TimeEx="" ,CPTEx=""
	..s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	..i cl=""  s cl=1
	..i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19) i DateEx'="" s DateEx=##class(web.DHCEMCommonUtil).DateLogicalToHtml(DateEx) //$ZD(DateEx,3)  ;nursing execute
	...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)  i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	...i CPTExDR'="" s CPTEx=$P($G(^CTPCP(CPTExDR,1)),"^",2)  
	...e  d
	....s StopStr=##class(web.DHCLONGTIMEORD).SingNur(Oew,OrdSub)
	....if StopStr'="" d
	.....s DateEx=$P(StopStr,"|",1),TimeEx=$P(StopStr,"|",2),CPTEx=$P(StopStr,"|",3)
	..s str=""
	..
	..s str=..PRX(Oew,OrdSub)
	..if str'="" d
	...s ExDoctor=$P(str,"|",3)
	...s ExDate=$P(str,"|",1)
	...s ExTime=$P(str,"|",2)
	..e  d
	...s ExDoctor=""
	...s ExDate=""
	...s ExTime=""
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2) 
	..s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	..if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	..q:(ItemCatDR="")
	..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	..s CatDR="^"_OrdCatDR_"^"
	..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	..s OrdCat="^"_OrdCat_"^"
	..s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
	..;s ARCIMDesc=$P(ARCIMD,"]",2) ;huaxiaoying 2017-01-16
	..s ARCIMDesc=ARCIMD ;huaxiaoying 2017-01-16
	..if ARCIMDesc="" s ARCIMDesc=$P(ARCIMD,"]",1)
	..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	..;if OrdTyp="R"  s ARCIMDesc=##class(web.DHCLONGTIMEORD).PhGener(ARCIMRowid,ARCIMSub)
    ..q:$G(^DHCOEOrdPrintSet("NotOrdCat"))[CatDR&($G(^DHCOEOrdPrintSet("NotOrdCat"))'="")
    ..s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)   //DiTan
    ..q:(flageCaiLiao=1)&(stop=0)
	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	..i (PHFreqDR'="") d
	...if $D(^PHCFR(PHFreqDR)) s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
	...e  s PHFreq=""
	..e  s PHFreq=""  ;table       PHC_Freq
	..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	..i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	..e  s UOM="" 
	..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	..if (DoseQty'="")&($P(DoseQty,"."))="" s DoseQty="0"_DoseQty
	..//if DoseQty'="" s ARCIMDesc=$P(ARCIMDesc,"(")
	..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	
	..i MethDR'=""  d
	...i '$d(^PHCIN(MethDR))  s ^LomgOrd(Oew,OrdSub)=MethDR
	...e  s Meth=$P(^PHCIN(MethDR),"^",2) ;PHCIN_Desc1 
	..e  d
	...s Meth=""
	..s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	..i DurDR'="" s During=$P(^PHCDU(DurDR),"^",3)   
	..e  s During=""  ;           period of treatment
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	..i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1) 
	..e  s OrdStat=""  ;ord status
	..q:OrdStatDR=11
	..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	..//医嘱序号存ORD索引时,如1.1保存为11
	..s OrdSeqNo(Oew,OrdSub)=Seq2
	..s Seq2=$Tr(Seq2,".","")
	..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
    ..if SeqNo'="" d
    ...s tmpSeqNo=$P(SeqNo,"||",2) ,ARCIMDesc="_____"_ARCIMDesc
    ..e  s tmpSeqNo=OrdSub
    ..s Seq1=tmpSeqNo
    ..//新关联到原主医嘱上的子医嘱可以与原子医嘱连续显示
	..i SeqNo'="" d
    ...s MainOrdId=$P(SeqNo,"||",1)
    ...s MainOrdSub=$P(SeqNo,"||",2)
    ...s MainOrdTime=$P($G(^OEORD(MainOrdId,"I",MainOrdSub,1)),"^",17)
    ...s OrdTime=MainOrdTime
    ..s PackNum=""
	..s PadmTyp=$P(^PAADM(adm),"^",2)
	..s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	..s RefundQty=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",23)
	..//if PackNum'="" w !,OrdSub
	..s TZh=""
	..if (OrdStatDR=4)&(^DHCOEOrdPrintSet("OrdCat")[OrdCat) d
	...s Ret=..PHPACK(Oew,OrdSub)  //退药情况
	...i Ret=1 s TZh="Pass"  
	..s numstr="",QtyStr=""
	..if $G(PackNum)'="" s PackStr=$G(PackNum)_""_$G(pacunit)
	..if $G(PhQtyOrd)'="" s QtyStr=$G(PhQtyOrd)_" "_$G(UOM)
	..if $G(PackStr)'="" s numstr=$G(PackStr)
	..e  s numstr=$G(QtyStr)
	..if PackNum="" s numstr=""
	..//q:(OrdStat="D")&($G(^DHCOEOrdPrintSet("ifstop"))'="true")
	..s xCtcpDesc="" //ypz 070802
	..s xCtcpId=$p($g(^OEORD(Oew,"I",OrdSub,3)),"^",29) //ypz 070802
	..i xCtcpId'="" s xCtcpDesc=" "_$p($g(^CTPCP(xCtcpId,1)),"^",2) //ypz 070802
	..i OrdStat="D" s Cancel="---DC"_xCtcpDesc ;Doctor //ypz 070802
	..e  s Cancel=""
	..//q:(OrdStat="D")&(stop="0")   ///(UsrTyp="NURSE")&jst add qse 070416
    ..s i=i+1
    ..//皮试
    ..s skintest="",abnorm=""
    ..s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
    ..if (skintest="Y")&(OrdStat'="D") d
    ...s skinnote=..skinnote(Oew,OrdSub) //w !,OrdSub
    ...s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
    ...if abnorm="Y" s ARCIMDesc=ARCIMDesc_"(+)"_skinnote  //070815
    ...if abnorm="N"  s ARCIMDesc=ARCIMDesc_"(-)"_skinnote
    ...;if abnorm="Y" s ARCIMDesc=ARCIMDesc_"(+)("_skinnote_")"
    ..if SeqNo'=""  s ARCIMDesc="   "_ARCIMDesc
	..if PriorDes["自备"  s ARCIMDesc=ARCIMDesc_"(自备)"
	..if PriorDes["出院"  s ARCIMDesc=ARCIMDesc_"(带药)"
	..if PriorDes["取药"  s ARCIMDesc=ARCIMDesc_"(取药)"
	..s CoverMainIns=$p($g(^OEORD(Oew,"I",OrdSub,3)),"^",3)
	..;if (CoverMainIns'="Y")&&(AdmType="I") s ARCIMDesc=ARCIMDesc_" (自费)"
	..if (CoverMainIns="N")&&(AdmType="I") s ARCIMDesc=ARCIMDesc_" (自费)"
	..s minDose=..getMinDose(ARCIMRowid,ARCIMSub)
	..if ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	...//.s ARCIMDesc=..GetArcim(ARCIMDesc)     ;w !, PriorDes_ARCIMDesc//
	...i oecprCode="OUT" d  // 药名+正包装数/剂量 用法，频次  d
	....//s ARCIMDesc=ARCIMDesc_" "_$G(numstr)_"/"_DoseQty_""_UOM_" "_Meth_" "_PHFreq_""_$G(Cancel)_" "_$G(Notes)
	....s ARCIMDesc=ARCIMDesc_" "_minDose_"*"_$G(numstr)_"/"_DoseQty_""_UOM_" "_Meth_" "_PHFreq
	...i oecprCode="ONE" d  //ypz 070802 //if PriorDes="^取药医嘱^" d
	....//s ARCIMDesc=ARCIMDesc_" "_$G(numstr)_"/"_DoseQty_""_UOM_" "_Meth_" "_PHFreq_""_$G(Cancel)_" "_$G(Notes)
	....if $G(numstr)="" d
	.....s DoseQty=..getsumdos(DurDR,PHFreqDR,DoseQty)
	.....//if OrdSub=1678 w !,DurDR,"--",PHFreqDR,"--",DoseQty,"--",UOMDR,"--",ARCIMRowid
	.....s ARCIMDesc=ARCIMDesc_" x"_..getphbasnum(UOMDR,DoseQty,ARCIMRowid,ARCIMSub)
	....if $G(numstr)'="" s ARCIMDesc=ARCIMDesc_" "_minDose_"x "_$G(numstr)
	...//if (PriorDes="^即刻医嘱^")!(PriorDes="^临时医嘱^")!(PriorDes="^自备药即刻^")!(PriorDes="^自备药临时^") d
	...if oecprCode="NORM" d
	....s ARCIMDesc=ARCIMDesc_" "_DoseQty_""_UOM_" "_$G(Meth)_" "_$G(PHFreq)
	...if oecprCode="HLJK" d  //徐国强化疗即刻
	....s ARCIMDesc=ARCIMDesc_" "_DoseQty_""_UOM_" "_$G(Meth)_" "_$G(PHFreq)
	...if (oecprCode="STAT")!(oecprCode="^自备药即刻^")!(oecprCode="OM") d
	....s ARCIMDesc=ARCIMDesc_" "_DoseQty_""_UOM_" "_$G(Meth)_" "_$G(PHFreq)  //_" "_"st"
	..e  d
	...if OrdCatDR=21 s ARCIMDesc=ARCIMDesc  //21医技检查
	...e  d
	....s flageX=..GetFlage(ARCIMRowid,ARCIMSub)
	....s ARCIMDesc=ARCIMDesc_" "_"x"_$G(PhQtyOrd)_$G(UOM)
	..if ^DHCOEOrdPrintSet("OrdCat")'[OrdCat  s ARCIMDesc=ARCIMDesc   //_"  "_$G(Cancel)
	..i $G(Notes)'="" s ARCIMDesc=ARCIMDesc_" "_$G(Notes)
	..s ARCIMDesc=ARCIMDesc_"  "_$G(Cancel)
	..s CoverMainIns=$p(^OEORD(Oew,"I",OrdSub,3),"^",3)
	..s ^OrdList($j,adm,OrdDate,OrdTime,Seq1,Seq2)=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdDate),1,10)_"|"_$ZT(OrderTime(Oew,OrdSub),1)_"|"_$G(Doctor)_"|"_ARCIMDesc_"|"_$G(ExDoctor)_"|"_$G(TimeEx)_"|"_$G(CPTEx)_"|"_$TR($E($G(DateEx),1,10),"-","/")
	..s OrdSub(OrdDate,OrdTime,Seq1,Seq2)=Oew_"||"_OrdSub
	..s OrdStat(OrdDate,OrdTime,Seq1,Seq2)=OrdStat
	..s OrdDose(OrdDate,OrdTime,Seq1,Seq2)=$G(DoseQty)
	..//w Oew_"||"_OrdSub
	..if StTime="" s StTime=OrdTime
    ;Q:OrdSub="" "{""rows"":[],""total"":"_count_"}"
	s i=0
 if $G(ChangeDate)=""{
	b ;11
	s OrdDate=""  f  s OrdDate=$O(^OrdList($j,adm,OrdDate))  q:OrdDate=""  d
	.b ;22
	.s tim="" f  s tim=$O(^OrdList($j,adm,OrdDate,tim))  q:tim=""  d
	..b ;tim
	..s Seq1=""  f  s Seq1=$O(^OrdList($j,adm,OrdDate,tim,Seq1)) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s ORW="", DisposNurDr="",DisposNur="",DisposDate="",DisposTime="",TimeEx="",DateEx="",CPTEx=""
	....s OerdDate=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",1)
	....s OerdTime=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",2)
	....s Doctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",3)
	....s ARCIMDesc=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",4)
	....s ExDoctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",5)
	....s TimeEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",6)
	....s DateEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",8)
	....s CPTEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",7)
	....i CPTEx="" s DateEx="",TimeEx=""
	....s ORW=OrdSub(OrdDate,tim,Seq1,Seq2),OrdStat=OrdStat(OrdDate,tim,Seq1,Seq2)
	....s rw=$P(ORW,"||"),chl=$P(ORW,"||",2)
	....if $D(^DHCLOGSHORTORD("lsord",ORW)) d
	.....s ExDC=$P(^DHCLOGSHORTORD("lsord",ORW),"^",1)
	.....;W ExDC_"$",!
	.....s ExNur=$P(^DHCLOGSHORTORD("lsord",ORW),"^",3)
	.....s ExTime=$P(^DHCLOGSHORTORD("lsord",ORW),"^",2)
    ....if $D(^DHCCLNurseExec("oeorid",ORW)) d
	.....s DisposNurDr=$P(^DHCCLNurseExec("oeorid",ORW),"^",3) //处理人
	.....s DisposDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P(^DHCCLNurseExec("oeorid",ORW),"^",1)) //$ZD($P(^DHCCLNurseExec("oeorid",ORW),"^",1),3) 
	.....s DisposTime=$ZT($P(^DHCCLNurseExec("oeorid",ORW),"^",2),2)
	.....if DisposNurDr'=""  s DisposNur=$P(^SSU("SSUSR",DisposNurDr),"^",2)
	....if $G(DisposNurDr)="" d
	.....s DisposNur=$G(CPTEx),DisposTime=$G(TimeEx)
	....q:((OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'="")))
    ....if $D(^DHCLONGSET("audittemp",Adm,ORW))  d  //核对
    .....s DisposNur=$G(DisposNur)_"_"_1
 	....s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)  //DiTan S 某些材料医嘱只显示但医嘱单不打印
	....s ARCIMRowid=$P(ArcimDR,"||",1)
	....s ARCIMSub=$P(ArcimDR,"||",2)
	....s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)
    ....q:(flageCaiLiao=1)                           //DiTan E
    ....q:(OrdStat(OrdDate,tim,Seq1,Seq2)="D")      //DiTan 停止医嘱打印在医嘱单上
    ....s i=i+1

    //20100106按日期与时间倒序显示医嘱单
    s OrdDate=""  f  s OrdDate=$O(^OrdList($j,adm,OrdDate),-1)  q:OrdDate=""  d
	.s tim="" f  s tim=$O(^OrdList($j,adm,OrdDate,tim),-1)  q:tim=""  d
	..s Seq1=""  f  s Seq1=$O(^OrdList($j,adm,OrdDate,tim,Seq1),-1) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s ORW="", DisposNurDr="",DisposNur="",DisposDate="",DisposTime="",TimeEx="",DateEx="",CPTEx=""
	....s OerdDate=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",1)
	....s OerdTime=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",2)
	....s Doctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",3)
	....s ARCIMDesc=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",4)
	....s ExDoctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",5)
	....s TimeEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",6)
	....s DateEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",8)
	....s CPTEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",7)
	....i CPTEx="" s DateEx="",TimeEx=""
	....s ORW=OrdSub(OrdDate,tim,Seq1,Seq2),OrdStat=OrdStat(OrdDate,tim,Seq1,Seq2)
	....s rw=$P(ORW,"||"),chl=$P(ORW,"||",2)
	....if $D(^DHCLOGSHORTORD("lsord",ORW)) d
	.....s ExDC=$P(^DHCLOGSHORTORD("lsord",ORW),"^",1)
	.....s ExNur=$P(^DHCLOGSHORTORD("lsord",ORW),"^",3)
	.....s ExTime=$P(^DHCLOGSHORTORD("lsord",ORW),"^",2)
    ....if $D(^DHCCLNurseExec("oeorid",ORW)) d
	.....s DisposNurDr=$P(^DHCCLNurseExec("oeorid",ORW),"^",3) //处理人
	.....s DisposDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P(^DHCCLNurseExec("oeorid",ORW),"^",1)) //$ZD($P(^DHCCLNurseExec("oeorid",ORW),"^",1),3) 
	.....s DisposTime=$ZT($P(^DHCCLNurseExec("oeorid",ORW),"^",2),2)
	.....if DisposNurDr'=""  s DisposNur=$P(^SSU("SSUSR",DisposNurDr),"^",2)
	....if $G(DisposNurDr)="" d
	.....s DisposNur=$G(CPTEx),DisposTime=$G(TimeEx)
	....q:((OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'="")))
    ....if $D(^DHCLONGSET("audittemp",Adm,ORW))  d  //核对
    .....s DisposNur=$G(DisposNur)_"_"_1
    ....//if ORW="1304082||122"
    ....s seqNo=OrdSeqNo(rw,chl)
    ....;D OutPut
	....//20100106按日期与时间倒序显示医嘱单
	....s TempStr=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_$j_"^"_$G(DisposTime)_"^"_$G(DisposNur)_"^"_$G(DisposNur)_"^"_$G(ExNur)_"^"_$G(ExTime)_"^"_$G(seqNo)
	....S count=count+1
	....s ^mtemp($J,"temp",Adm,count)=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_OrdStat_"^"_$J_"^"_$G(DisposTime)_"^"_$G(DisposNur)	
	....Q:count<Start
	....Q:count>End
   	....W $case(count,Start:"",:",") 
	....W ##class(web.DHCAPPJsonCommon).getJsonData("OerdDate^OerdTime^ARCIMDesc^Doctor^DateEx^TimeEx^CPTEx^ORW^ProcessNo^DisposTime^DisposNur^ExDC^ExNur^ExTime^seqNo",TempStr)
	....//s ^mtemp($J,"temp",Adm,count)=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_OrdStat_"^"_$J_"^"_$G(DisposTime)_"^"_$G(DisposNur)

	W "],""total"":"_count_",""offset"":"_offset_",""limit"":"_limit_"}"

	Q ""
	
 }else{  //医务科用
	s OrdDate=""  f  s OrdDate=$O(OrdListC(OrdDate))  q:OrdDate=""  d
	.s tim=""  f  s tim=$O(OrdListC(OrdDate,tim))  q:tim=""  d
	..s Seq1=""  f  s Seq1=$O(OrdListC(OrdDate,tim,Seq1)) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(OrdListC(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s ORW="", DisposNurDr="",DisposNur="",DisposDate="",DisposTime=""
	....s OerdDate=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",1)
	....s OerdTime=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",2)
	....s Doctor=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",3)
	....s ARCIMDesc=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",4)
	....s ExDoctor=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",5)
	....s TimeEx=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",6)
	....s DateEx=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",8)
	....s CPTEx=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",7)
	....s ORW=OrdSubC(OrdDate,tim,Seq1,Seq2),OrdStat=OrdStatC(OrdDate,tim,Seq1,Seq2)
	....s rw=$P(ORW,"||"),chl=$P(ORW,"||",2)
	....q:(stop'=2)&(OrdStatC(OrdDate,tim,Seq1,Seq2)="D")&('$d(^DHCTEMPHBORD(rw,chl)))&($G(OrdDose(OrdDate,tim,Seq1,Seq2))="")
	....q:(stop=2)&($G(OrdDoseC(OrdDate,tim,Seq1,Seq2))'="")  //&($G(XDate(rw,chl))="") //s Arcim=$G(Arcim)_" "_"作废"
	....q:(stop=2)&(OrdStatC(OrdDate,tim,Seq1,Seq2)'="D")
	....if $D(^DHCCLNurseExec("oeorid",ORW)) d
	.....s DisposNurDr=$P(^DHCCLNurseExec("oeorid",ORW),"^",3) //处理人
	.....s DisposDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P(^DHCCLNurseExec("oeorid",ORW),"^",1)) //$ZD($P(^DHCCLNurseExec("oeorid",ORW),"^",1),3) 
	.....s DisposTime=$ZT($P(^DHCCLNurseExec("oeorid",ORW),"^",2),2)
	.....if DisposNurDr'=""  s DisposNur=$P(^SSU("SSUSR",DisposNurDr),"^",2)
	....q:((OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'="")))
    ....;D OutPut
	....s TempStr=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_$j_"^"_$G(DisposTime)_"^"_$G(DisposNur)_"^"_$G(ExDC)_"^"_$G(ExNur)_"^"_$G(ExTime)_"^"_$G(seqNo)
	....S count=count+1
	....s ^mtemp($J,"temp",Adm,count)=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_OrdStat_"^"_$J_"^"_$G(DisposTime)_"^"_$G(DisposNur)
	....Q:count<Start
	....Q:count>End
   	....W $case(count,Start:"",:",") 
	....W ##class(web.DHCAPPJsonCommon).getJsonData("OerdDate^OerdTime^ARCIMDesc^Doctor^DateEx^TimeEx^CPTEx^ORW^ProcessNo^DisposTime^DisposNur^ExDC^ExNur^ExTime^seqNo",TempStr)
	....s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)  //DiTan S 某些材料医嘱只显示但医嘱单不打印
	....s ARCIMRowid=$P(ArcimDR,"||",1)
	....s ARCIMSub=$P(ArcimDR,"||",2)
	....s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)
    ....q:(flageCaiLiao=1)                           //DiTan E
    ....q:(OrdStat(OrdDate,tim,Seq1,Seq2)="D")      //DiTan 停止医嘱打印在医嘱单上
    ....s i=i+1
    ....if $G(DisposTime)="" d
    .....s DisposNur=$G(CPTEx),DisposTime=$G(TimeEx)
	W "],""total"":"_count_",""offset"":"_offset_",""limit"":"_limit_"}"

	Q ""
 }
 k ^OrdList($j,adm)
    s ^mtemp($J,"temp",Adm)=i
}

/// Description: 医嘱单查询
/// Creator:     congyue
/// CreateDate:  2016-08-14
/// Table: 		 
/// Input:  	 
/// Return： 	 医嘱单信息
/// Others:		 w ##class(web.DHCEMPhysiOreSheet).QueryGetLongOrdInfo(0,6,"12","","","","0","11","1","0","0","长期医嘱")
/// w ##class(web.DHCEMPhysiOreSheet).QueryGetTempOrdInfo(0,6,"12","","","","0","11","1","0","0","")
ClassMethod QueryGetLongOrdInfo(offset = 0, limit = 10, Adm, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0", ssuser As %String = "", CurDep = "", NurOrd, DocOrd, OrdType) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMPhysiOreSheet","GetTempOrd","418","64142","64142","","0","11","1","0","0")
	n (offset , limit , Adm,StartDate,EndDate,ChangeDate,stop,ssuser,CurDep,NurOrd,DocOrd,OrdType)
	;s ^oio("KKKK")=Adm_"^"_StartDate_"^"_EndDate_"^"_ChangeDate_"^"_stop_"^"_ssuser_"^"_CurDep_"^"_NurOrd_"^"_DocOrd
	
	S:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) //$zdh(StartDate,3)
	S:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) //$zdh(EndDate,3)
	
	S End = offset+limit
	S Start = offset+1
    S count=0,h=0
    Q:Adm="" "{""rows"":[],""total"":"_count_"}"
	w "{""rows"":["
	s ind=1
	s i=0
	q:$G(Adm)="" ""
	s adm=Adm
	s UsrTyp=##class(web.DHCLONGTIMEORD).ssusertyp(ssuser)
	s AdmType=$P(^PAADM(Adm),"^",2)
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	if CurDep="" s CurDep=1  //=$P(^PAADM(Adm),"^",4)
	e   s depno=CurDep
	k ^mtemp($j,"long",Adm)
	d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(adm)
	s depnum=1
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d
	.s OrdSub="0"  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:(OrdSub="")!(OrdSub="0")  d
	..s OrdDep=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",3)
	..s odt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7),otim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)  ;录入医嘱日期和时间
	..s ODTim=odt*86400+otim
	..s OrdStatDRyy=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13) 
	..q:OrdStatDRyy=2    //未核实
	..s OID=..GETOID(Oew,OrdSub)
	..s depnum=..getdepno(adm,ODTim)
	..i (Oew="681130")&(OrdSub="1")&(depnum="") s depnum=1
	..q:OrdDep=""
	..s fillerno=0  //s PreDep=OrdDep
	..if (OID'="") d
	...if $D(ARCIMDesc(+OID,$P(OID,",",2))) s fillerno=1
	..q:(depnum'=depno)&(fillerno=0)  //depno 转科顺序号
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)  
	..e  q     ///PriorDR --10--自备药长期医嘱
	..s PriorDes="^"_PriorDes_"^"
	..q:^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	..s XSTR=..PRX(Oew,OrdSub) ;求医生停止医嘱日期时间
	..i 1 d
	...i OID'="" d 
	....s Ow=$P(OID,",",1)
	....s cl=$P(OID,",",2)
	....s PreStr=..GetPreStopDate(Oew,OrdSub)  //求预停日期时间
	....if PreStr'="" d
	.....s PreStopDate(Ow,cl)=$P(PreStr,"^")
	.....s PreStopTime(Ow,cl)=$P(PreStr,"^",2)
	....if $G(XSTR)'="" d
	.....s ^TMP("XDATE",Ow,cl,OrdDate,OrdTime)=XSTR
	.....s XDate(Ow,cl)=$p(XSTR,"|",1),XTime(Ow,cl)=$P(XSTR,"|",2),XCpt(Ow,cl)=$P(XSTR,"|",3)
	....e  d
	.....k ^TMP("XDATE",Ow,cl,OrdDate,OrdTime)
	.....s XDate(Ow,cl)="",XTime(Ow,cl)="",XCpt(Ow,cl)=""
	...
	...e  d
	....i ($G(XDate(Oew,OrdSub))="")&($P(XSTR,"|",1)'="") d
	.....s XDate(Oew,OrdSub)=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdDate),XTime(Oew,OrdSub)=$P(XSTR,"|",2),XCpt(Oew,OrdSub)=$P(XSTR,"|",3) 
	.....s ^TMP("XDATE",Oew,OrdSub,OrdDate,OrdTime)=XSTR
	..s XSTR=##class(web.DHCLONGTIMEORD).SingNur(Oew,OrdSub)
	..i XSTR'="" d
	...s OID=..GETOID(Oew,OrdSub)
	...i OID'="" d 
	....s Ow=$P(OID,",",1)
	....s cl=$P(OID,",",2)
	....i 1 d
	.....s nursestopDate(Ow,cl)=$P(XSTR,"|",1),nursestopTime(Ow,cl)=$P(XSTR,"|",2),nursestop(Ow,cl)=$P(XSTR,"|",3) 
	.....if $P(XSTR,"|",1)'="" s ^TMP("NURXDATE",Ow,cl,OrdDate)=XSTR
	...e  d
	....i 1 d
	.....s nursestopDate(Oew,OrdSub)=$P(XSTR,"|",1),nursestopTime(Oew,OrdSub)=$P(XSTR,"|",2),nursestop(Oew,OrdSub)=$P(XSTR,"|",3) 
	.....if $P(XSTR,"|",1)'="" s ^TMP("NURXDATE",Oew,OrdSub,OrdDate)=XSTR
	..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	..i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
	..e  s OrdStat=""  ;ord status
	..s ODate=$P($G(^OEORD(Oew,"I",OrdSub,8)),"^",14) ;长期医嘱开医嘱日期
	..s OrdStat(Oew,OrdSub)=OrdStat 
	..//if OrdSub=31 w !, XCpt(Oew,OrdSub)
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)  ;取得医嘱表医嘱日期时间?加入基础数据表
	..s OrdDate=+OrdDate
	..s OrdTime(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	..s Status=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	..q:Status=11
	..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	..//医嘱序号存ORD索引时,如1.1保存为11
	..s OrdSeqNo(Oew,OrdSub)=Seq2
	..s Seq2=$Tr(Seq2,".","")
	..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
	..if SeqNo'="" d
	...s tmpSeqNo=$P(SeqNo,"||",2) //,val("arcimDesc")="_____"_tmpSeqNo_val("arcimDesc")
	..e  s tmpSeqNo=OrdSub
	..s Seq1=tmpSeqNo
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	..if StTime=""  s StTime=OrdTime(Oew,OrdSub) 
	..s StTime(Oew,OrdSub)=StTime
	..//新关联到原主医嘱上的子医嘱可以与原子医嘱连续显示
	..i SeqNo'="" d
	...s MainOrdId=$P(SeqNo,"||",1)
	...s MainOrdSub=$P(SeqNo,"||",2)
	...s MainOID=..GETOID(MainOrdId,MainOrdSub)
	...i MainOID'="" d
	....//关联到非新长嘱
	....s FirstMainOrdId=$P(MainOID,",",1)
	....s FirstMainOrdSub=$P(MainOID,",",2)
	....s FirstMainStDate=$P($G(^OEORD(FirstMainOrdId,"I",FirstMainOrdSub,1)),"^",9)
	....s FirstMainStTime=$P($G(^OEORD(FirstMainOrdId,"I",FirstMainOrdSub,1)),"^",10)
	....s StDate=FirstMainStDate
	....s StTime=FirstMainStTime
	....//s OrdDate=MainStDate
	....s OrdDate=FirstMainStDate
	....s OrdTime(Oew,OrdSub)=FirstMainStTime
	....s Seq1=FirstMainOrdSub
	...e  d
	....//关联到新开医嘱
	....s MainStDate=$P($G(^OEORD(MainOrdId,"I",MainOrdSub,1)),"^",9)
	....s MainStTime=$P($G(^OEORD(MainOrdId,"I",MainOrdSub,1)),"^",10)
	....s StDate=MainStDate
	....s StTime=MainStTime
	....s OrdDate=MainStDate
	....s OrdTime(Oew,OrdSub)=MainStTime
	....
	..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	..q:user=""
	..s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	..q:DoctorDr=""
	..i DoctorDr'=""  s Doctor(Oew,OrdSub)=$P($g(^CTPCP(DoctorDr,1)),"^",2) ;write doctor oeori_doctor_dr
	..i DoctorDr'=""  s Doctor(Oew,OrdSub)=$P($g(^CTPCP(DoctorDr,1)),"^",2) ;write doctor oeori_doctor_dr
	..e  s Doctor(Oew,OrdSub)=""
	..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	..if '$D(^CT("CPT",CpTypDR)) ;w !,DoctorDr,"---",user
	..q:'$D(^CT("CPT",CpTypDR))  
	..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	..q:($G(CpTyp)'="DOCTOR")&($G(^DHCOEOrdPrintSet("ifnur"))'="true")     // &(UsrTyp'="NURSE")ypz 061102////////////2005-12-3 qse add
	..s truedoc=0
	..if (NurOrd'=0)&(DocOrd=0)&($G(CpTyp)="DOCTOR") q
	..if (DocOrd'=0)&(NurOrd=0)&($G(CpTyp)="NURSE") q
	..s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	..f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	...if $D(^TMP($J,"loc",adm,DocLoc))  s truedoc=1
	..s ExceChl=0 s ExceChl=$O(^OEORD(Oew,"I",OrdSub,"X",ExceChl))
	..i ExceChl'=""  d
	...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19) i DateEx'="" s DateEx(Oew,OrdSub)=##class(web.DHCEMCommonUtil).DateLogicalToHtml(DateEx) //$ZD(DateEx,3)  ;nursing execute
	...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)  i TimeEx'=""  s TimeEx(Oew,OrdSub)=$ZT(TimeEx,2)
	...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
	...i CPTExDR'="" s CPTEx(Oew,OrdSub)=$P($G(^CTPCP(CPTExDR,1)),"^",2)  
	...e  s CPTEx=""
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..e  s DateEx(Oew,OrdSub)="",TimeEx(Oew,OrdSub)="",CPTEx(Oew,OrdSub)=""
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2)  
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	..s OrdCat="^"_OrdCat_"^"
	..s OrdCatDR="^"_OrdCatDR_"^"
	..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	..s ARCIMD(Oew,OrdSub)=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
	..s dos=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)
	..;if OrdTyp="R"  s ARCIMD(Oew,OrdSub)=..PhGener(ARCIMRowid,ARCIMSub)
	..s ARCIMDesc(Oew,OrdSub)=ARCIMD(Oew,OrdSub)
	..if ARCIMDesc(Oew,OrdSub)=""  s ARCIMDesc(Oew,OrdSub)=$P(ARCIMD(Oew,OrdSub),"]",1)
	..if SeqNo'="" s ARCIMDesc(Oew,OrdSub)="_____"_ ARCIMDesc(Oew,OrdSub)
	..q:$G(^DHCOEOrdPrintSet("NotOrdCat"))[OrdCatDR&($G(^DHCOEOrdPrintSet("NotOrdCat"))'="")
	..s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)   //DiTan
	..q:(flageCaiLiao=1)&(stop=0)
	..;2015-02-17
	..s ORD(OrdDate,OrdTime(Oew,OrdSub),Seq1,Seq2,Oew,OrdSub)=""
	..s ORDC(StDate,StTime,Seq1,Seq2,Oew,OrdSub)=""  //s ORDC(StDate,StTime,Seq1,Seq2,Oew,OrdSub)=""   //医务修改用
	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	..i PHFreqDR'="" s PHFreq(Oew,OrdSub)=$P(^PHCFR(PHFreqDR),"^",3) 
	..e  s PHFreq=""  ;table       PHC_Freq
	..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3) ;CT_UOM                      OEORI_Unit_DR
	..i UOMDR'="" s UOM(Oew,OrdSub)=$P(^CT("UOM",UOMDR),"^",2)  
	..e  s UOM="" 
	..s DoseQty(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	..//点前补零
	..if (DoseQty(Oew,OrdSub)'="")&($P(DoseQty(Oew,OrdSub),"."))="" s DoseQty(Oew,OrdSub)="0"_DoseQty(Oew,OrdSub)
	..s PhQtyOrd(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	..i MethDR'=""  d
	...i '$d(^PHCIN(MethDR))  s ^LomgOrd(Oew,OrdSub)=MethDR
	...e  s Meth(Oew,OrdSub)=$P(^PHCIN(MethDR),"^",2) ;PHCIN_Desc1 
	..e  d
	...s Meth(Oew,OrdSub)=""
	..s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	..i DurDR'="" s During(Oew,OrdSub)=$P(^PHCDU(DurDR),"^",3)   
	..e  s During=""  ;           period of treatment
	..s Notes(Oew,OrdSub)=""
	..f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	...if ($g(^OEORD(Oew,"I",OrdSub,"DEP",rnum))'="")  d 
	....s Notes(Oew,OrdSub)=Notes(Oew,OrdSub)_"("_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))_")"
	..s ggg=$F(Notes(Oew,OrdSub),"-")
	..if ($G(Notes(Oew,OrdSub))'="")&(ggg'=0) d
	...s Notes(Oew,OrdSub)=..note(Oew,OrdSub)
	..//停医嘱处理
	..s PHSPACK=0
	..if (OrdStat(Oew,OrdSub)="停止")&(^DHCOEOrdPrintSet("OrdCat")[OrdCat) d
	...if OrdDate=$g(XDate(Oew,OrdSub)) d  //change by liuxs 2009-10-17
	....s PHSPACK=##class(web.DHCTEMPOERPRINT).PHPACK(Oew,OrdSub)
	..if (PHSPACK=1)&(PriorDR'=7) d  //7--自备药
	..s PadmTyp(Oew,OrdSub)=$P(^PAADM(adm),"^",2)
	..s PackNum(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	..i (^DHCOEOrdPrintSet("OrdCat")[OrdCat)  d
	...i PackNum(Oew,OrdSub)=""  s Numeric(Oew,OrdSub)=" "_PhQtyOrd(Oew,OrdSub)
	...e  s Numeric(Oew,OrdSub)=" "_PackNum(Oew,OrdSub)
	..e  s Numeric(Oew,OrdSub)=""
	..i (^DHCOEOrdPrintSet("OrdCat")[OrdCat) d  
	...s ARCIMDesc(Oew,OrdSub)=..GetArcim(ARCIMDesc(Oew,OrdSub))
	...s DayNum(Oew,OrdSub)="  "   ;X"_"";PhQtyOrd(Oew,OrdSub)
	..e  s DayNum(Oew,OrdSub)=""  ;$g(During)
	..if (^DHCOEOrdPrintSet("OrdCat")[OrdCat)  d
	..e  d
	...s flageX=..GetFlage(ARCIMRowid,ARCIMSub)
	...s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)_" x"_PhQtyOrd(Oew,OrdSub)
	...e  s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)
	..if PriorDes["自备" s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)_"  (自备)"
	..s CoverMainIns=$p(^OEORD(Oew,"I",OrdSub,3),"^",3)
	..if (CoverMainIns'="Y")&&(AdmType="I") s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)_"  (自费)"
	..s ARCIMOrdCat(Oew,OrdSub)=OrdCat
	
	
	k MList
	s i=0
	if (ChangeDate="")
	{
		b ;1
	s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
	.b ;2
	.s tim="" f  s tim=$O(ORD(OrdDate,tim)) q:tim=""  d
	..b //
	..s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1)) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
	.....s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
	......q:$G(ARCIMDesc(rw,chl))=""
	......s Arcim="",DateEx="",XDate="",XTime="",TimeEx="",NurseStopDate="",NurseStopTime="",NurseStop="",OrdStat="" ;i Seq2>0 s ARCIMDesc(rw,chl)="    "_ARCIMDesc(rw,chl)
	......s Doctor="" //s OerdDate=$TR($E($ZD(OrdDate,3),6,10),"-","/"),OerdTime=$ZT(OrdTime(rw,chl),4),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
	......s OerdDate=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdDate),1,10),OerdTime=$ZT(OrdTime(rw,chl),2),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
	......s OerdDate=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdDate),1,10),OerdTime=$ZT(OrdTime(rw,chl),2),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
	......s OerdDate=$P($G(^OEORD(rw,"I",chl,1)),"^",9)
	......i OerdDate'="" s OerdDate=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OerdDate),1,10)
	......s OerdTime=$P($G(^OEORD(rw,"I",chl,1)),"^",10)
	......i OerdTime'="" s OerdTime=$ZT(OerdTime,2)
	......if ^DHCOEOrdPrintSet("OrdCat")'[$G(ARCIMOrdCat(rw,chl))  s Arcim=$G(ARCIMDesc(rw,chl))_" "_$G(PHFreq(rw,chl))_" "_$g(Notes(rw,chl)) //_PhQtyOrd(rw,chl)   change by wangli2008-08-09
	......e  s Arcim=$G(ARCIMDesc(rw,chl))_" "_$G(DoseQty(rw,chl))_""_$G(UOM(rw,chl))_" "_$G(Meth(rw,chl))_" "_$G(PHFreq(rw,chl))_" "_$g(Notes(rw,chl)) 
	......s DateEx=$G(DateEx(rw,chl)),TimeEx=$G(TimeEx(rw,chl))
	......s XDate=$G(XDate(rw,chl)),XTime=$G(XTime(rw,chl)),XCpt=$G(XCpt(rw,chl))
	......s PreStopDate=$G(PreStopDate(rw,chl))
	......s PreStopTime=$G(PreStopTime(rw,chl))
	......q:(XCpt'="")&(stop="0") //(UsrTyp="NURSE")&
	......if XDate'="" d
	.......if ##class(web.DHCEMCommonUtil).DateHtmlToLogical(XDate)=PreStopDate s XTime=$ZT(PreStopTime)
	......i PreStopDate'="" s PreStopDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PreStopDate),PreStopTime=$ZT(PreStopTime,2)   //070823W
	......if XDate'="" s XDate=$TR($E(XDate,6,10),"-","/")   //$ZD(XDate,3) 
	......e  s XDate="" //$E($ZD(XDate,3),3,10) //$TR($E($ZD(XDate,3),6,10),"-","/")
	......s NurseStopDate=$G(nursestopDate(rw,chl)),NurseStopTime=$G(nursestopTime(rw,chl))
	......s NurseStop=$G(nursestop(rw,chl)),ORW=rw_$C(1)_chl,OrdStat=$g(OrdStat(rw,chl))
	......if $G(XDate(rw,chl))=""  s XDate(rw,chl)=0
	......e  s XDate(rw,chl)=$G(XDate(rw,chl))   //liuxs change by 2009-10-17  
	......s rwno=rw_"||"_chl
	......if $D(^DHCLOGSHORTORD("longord",rwno)) d
	.......s ExNur=$P(^DHCLOGSHORTORD("longord",rwno),"^",1)
	.......s StopDateTime=$P(^DHCLOGSHORTORD("longord",rwno),"^",2)
	.......s StopDoc=$P(^DHCLOGSHORTORD("longord",rwno),"^",3)
	.......s StopNur=$P(^DHCLOGSHORTORD("longord",rwno),"^",4)
	......if XDate'="" s OrdStat="停止"
	......e  s OrdStat="核实"
	......q:(OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'=""))
	......if $D(^DHCLONGSET("audit",Adm,rw_"|"_chl)) d
	.......s OrdStat=OrdStat_"_"_1
	......if (CPTEx="")&(NurseStop'="") s CPTEx=NurseStop
	......;D OutPut
	......s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)  //DiTan S 某些材料医嘱只显示但医嘱单不打印
	......s ARCIMRowid=$P(ArcimDR,"||",1)
	......s ARCIMSub=$P(ArcimDR,"||",2)
	......s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)
	......q:(flageCaiLiao=1)                           //DiTan E
	......s i=i+1
	......s ^mtemp($j,"long",Adm,i)=OerdDate_"^"_OerdTime_"^"_Doctor_"^"_CPTEx_"^"_Arcim_"^"_XDate_"^"_XTime_"^"_XCpt_"^"_NurseStop_"^"_OrdStat_"^"_ORW_"^"_$J
	//20100106按日期与时间倒序显示医嘱单
	s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate),-1)  q:OrdDate=""  d
	.b ;12345
	.s tim="" f  s tim=$O(ORD(OrdDate,tim),-1) q:tim=""  d
	..s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1),-1) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
	.....s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
	......q:$G(ARCIMDesc(rw,chl))=""
	......s Arcim="",DateEx="",XDate="",XTime="",TimeEx="",NurseStopDate="",NurseStopTime="",NurseStop="",OrdStat=""
	......s Doctor="" 
	......s OerdDate=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdDate),1,10),OerdTime=$ZT(OrdTime(rw,chl),2),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
	......//新关联到原主医嘱上的子医嘱可以与原子医嘱连续显示
	......s OerdDate=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdDate),1,10),OerdTime=$ZT(OrdTime(rw,chl),2),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
	......s OerdDate=$P($G(^OEORD(rw,"I",chl,1)),"^",9)
	......i OerdDate'="" s OerdDate=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OerdDate),1,10)
	......s OerdTime=$P($G(^OEORD(rw,"I",chl,1)),"^",10)
	......i OerdTime'="" s OerdTime=$ZT(OerdTime,2)
	......if ^DHCOEOrdPrintSet("OrdCat")'[$G(ARCIMOrdCat(rw,chl))  s Arcim=$G(ARCIMDesc(rw,chl))_" "_$G(PHFreq(rw,chl))_" "_$g(Notes(rw,chl))
	......e  s Arcim=$G(ARCIMDesc(rw,chl))_" "_$G(DoseQty(rw,chl))_""_$G(UOM(rw,chl))_" "_$G(Meth(rw,chl))_" "_$G(PHFreq(rw,chl))_" "_$g(Notes(rw,chl)) 
	......//e  s Arcim=$G(ARCIMDesc(rw,chl))_" "_$G(DoseQty(rw,chl))_" "_$G(UOM(rw,chl))_" "_$G(Meth(rw,chl))_" "_$G(PHFreq(rw,chl))_" "_$G(DayNum(rw,chl))_" "_$G(Cancel(rw,chl))_" "_$g(Notes(rw,chl))
	......s DateEx=$G(DateEx(rw,chl)),TimeEx=$G(TimeEx(rw,chl))
	......s XDate=$G(XDate(rw,chl)),XTime=$G(XTime(rw,chl)),XCpt=$G(XCpt(rw,chl))
	......s PreStopDate=$G(PreStopDate(rw,chl))
	......s PreStopTime=$G(PreStopTime(rw,chl))
	......q:(XCpt'="")&(stop="0")
	......if XDate'="" d
	......//.if $ZDH(XDate,3)=OrdDate d
	......//..s XTime=OerdTime  //当天开当天停
	.......if ##class(web.DHCEMCommonUtil).DateHtmlToLogical(XDate)=PreStopDate s XTime=$ZT(PreStopTime)
	......i PreStopDate'="" s PreStopDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PreStopDate),PreStopTime=$ZT(PreStopTime,2)   //070823W
	......if XDate'="" s XDate=$TR($E(XDate,6,10),"-","/")   //$ZD(XDate,3) 
	......e  s XDate="" //$E($ZD(XDate,3),3,10) //$TR($E($ZD(XDate,3),6,10),"-","/")
	......s NurseStopDate=$G(nursestopDate(rw,chl)),NurseStopTime=$G(nursestopTime(rw,chl))
	......s NurseStop=$G(nursestop(rw,chl)),ORW=rw_$C(1)_chl,OrdStat=$g(OrdStat(rw,chl))
	......if $G(XDate(rw,chl))=""  s XDate(rw,chl)=0
	......//e  s XDate(rw,chl)=$ZDH($G(XDate(rw,chl)),3)  
	......e  s XDate(rw,chl)=$G(XDate(rw,chl))   //liuxs change by 2009-10-17  
	......//q:(stop'=2)&($G(XDate(rw,chl))=OrdDate)&('$d(^DHCLONGHBORD(rw,chl)))&($G(DoseQty(rw,chl))="")   ///查询后补医嘱 下医嘱日期＝停止日期,只查非药类
	......//q:(stop=2)&($G(DoseQty(rw,chl))'="")  //&($G(XDate(rw,chl))="") //s Arcim=$G(Arcim)_" "_"作废"
	......//q:(stop=2)&($G(XDate(rw,chl))'=OrdDate)
	......s rwno=rw_"||"_chl
	......if $D(^DHCLOGSHORTORD("longord",rwno)) d
	.......s ExNur=$P(^DHCLOGSHORTORD("longord",rwno),"^",1)
	.......s StopDateTime=$P(^DHCLOGSHORTORD("longord",rwno),"^",2)
	.......s StopDoc=$P(^DHCLOGSHORTORD("longord",rwno),"^",3)
	.......s StopNur=$P(^DHCLOGSHORTORD("longord",rwno),"^",4)
	......if XDate'="" s OrdStat="停止"
	......e  s OrdStat="核实"
	......q:(OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'=""))
	......if $D(^DHCLONGSET("audit",Adm,rw_"|"_chl)) d
	.......s OrdStat=OrdStat_"_"_1
	......if (CPTEx="")&(NurseStop'="") s CPTEx=NurseStop
	......s seqNo=OrdSeqNo(rw,chl)
	......;D OutPut
	......s TempStr=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_$j_"^"_$G(DisposTime)_"^"_$G(DisposNur)_"^"_$G(ExDC)_"^"_$G(ExNur)_"^"_$G(ExTime)_"^"_$G(seqNo)
	......S count=count+1
	......b ;234
	......Q:count<Start
	......Q:count>End
   	......W $case(count,Start:"",:",") 
	......W ##class(web.DHCAPPJsonCommon).getJsonData("OerdDate^OerdTime^ARCIMDesc^Doctor^DateEx^TimeEx^CPTEx^ORW^ProcessNo^DisposTime^DisposNur^ExDC^ExNur^ExTime^seqNo",TempStr)
	W "],""total"":"_count_"}"

	Q ""
	
	//20100106按日期与时间倒序显示医嘱单
	;s Ord=$O(^OEORD(0,"Adm",adm,""))
	// k ^TMP("NURXDATE",Ord),^TMP("XDATE",Ord)
	}else{ //医务修改
		s OrdDate=""  f  s OrdDate=$O(ORDC(OrdDate))  q:OrdDate=""  d
		.b ;12
		.s tim=""  f  s tim=$O(ORDC(OrdDate,tim))  q:tim=""  d
		..s Seq1=""  f  s Seq1=$O(ORDC(OrdDate,tim,Seq1)) q:Seq1=""  d
		...s Seq2=""  f  s Seq2=$O(ORDC(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
		....s rw=""  f  s rw=$O(ORDC(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
		.....s chl=""  f  s chl=$O(ORDC(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
		......q:$G(ARCIMDesc(rw,chl))=""
		......s Arcim="",DateEx="",XDate="",XTime="",TimeEx="",NurseStopDate="",NurseStopTime="",NurseStop="" ;i Seq2>0 s ARCIMDesc(rw,chl)="    "_ARCIMDesc(rw,chl)
		......s OerdDate=$E(##class(web.DHCEMCommonUtil).DateLogicalToHtml(OrdDate),1,10),OerdTime=$ZT(StTime(rw,chl),2),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
		......s Arcim=$G(ARCIMDesc(rw,chl))_" "_Notes(rw,chl)_" "_$G(DoseQty(rw,chl))_" "_$G(UOM(rw,chl))_" "_$G(PHFreq(rw,chl))_" "_$G(Meth(rw,chl))_" "_$G(DayNum(rw,chl))_" "_$G(Cancel(rw,chl))
		......s DateEx=$G(DateEx(rw,chl)),TimeEx=$G(TimeEx(rw,chl))
		......s XDate=$G(XDate(rw,chl)),XTime=$G(XTime(rw,chl)),XCpt=$G(XCpt(rw,chl))
		......if XDate'="" s XDate=$TR($E(XDate,3,10),"-","/")  //$ZD(XDate,3) 
		......e  s XDate="" //$E($ZD(XDate,3),3,10) //$TR($E($ZD(XDate,3),6,10),"-","/")
		......s NurseStopDate=$G(nursestopDate(rw,chl)),NurseStopTime=$G(nursestopTime(rw,chl))
		......s NurseStop=$G(nursestop(rw,chl)),ORW=rw_$C(1)_chl,OrdStat=OrdStat(rw,chl)
		......if $G(XDate(rw,chl))=""  s XDate(rw,chl)=0
		......e  s XDate(rw,chl)=##class(web.DHCEMCommonUtil).DateHtmlToLogical($G(XDate(rw,chl))) //$ZDH($G(XDate(rw,chl)),3)
		......q:(stop'=2)&($G(XDate(rw,chl))=OrdDate)&('$d(^DHCLONGHBORD(rw,chl)))&($G(DoseQty(rw,chl))="")   ///查询后补医嘱 下医嘱日期＝停止日期,只查非药类
		......q:(stop=2)&($G(DoseQty(rw,chl))'="")  //&($G(XDate(rw,chl))="") //s Arcim=$G(Arcim)_" "_"作废"
		......q:(stop=2)&($G(XDate(rw,chl))'=OrdDate)
		......if XDate'="" s OrdStat="停止"
		......q:(OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'=""))
		......if (CPTEx="")&(NurseStop'="") s CPTEx=NurseStop
		......;D OutPut
		......s TempStr=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_$j_"^"_$G(DisposTime)_"^"_$G(DisposNur)_"^"_$G(ExDC)_"^"_$G(ExNur)_"^"_$G(ExTime)_"^"_$G(seqNo)
		......b ;23454
		......S count=count+1
		......Q:count<Start
		......Q:count>End
		......W $case(count,Start:"",:",") 
		......W ##class(web.DHCAPPJsonCommon).getJsonData("OerdDate^OerdTime^ARCIMDesc^Doctor^DateEx^TimeEx^CPTEx^ORW^ProcessNo^DisposTime^DisposNur^ExDC^ExNur^ExTime^seqNo",TempStr)
		......s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)  //DiTan S 某些材料医嘱只显示但医嘱单不打印
		......s ARCIMRowid=$P(ArcimDR,"||",1)
		......s ARCIMSub=$P(ArcimDR,"||",2)
		......s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)
		......q:(flageCaiLiao=1)                           //DiTan E
		......s i=i+1
		......s ^mtemp($j,"long",Adm,i)=OerdDate_"^"_OerdTime_"^"_Doctor_"^"_CPTEx_"^"_Arcim_"^"_XDate_"^"_XTime_"^"_XCpt_"^"_NurseStop_"^"_OrdStat_"^"_ORW_"^"_$J
		...
		.
		W "],""total"":"_count_"}"

		Q ""
	}
	s ^mtemp($j,"long",Adm)=i
	Set qHandle=$lb(0,repid,0)
	//起始日期|<起始时间|<起始医生签字|<起始护士签字|<长期医嘱|<停止日期|<停止时间|<停止医生签字|<停止护士签字"
}

ClassMethod getsumdos(dur, freqdr, dosqty) As %String
{
 //取药医嘱总剂量
	 s durfactor=1,freqfactor=1
	if dur'="" s durfactor=$P(^PHCDU(dur),"^",2)
	if freqdr'="" s freqfactor=$P(^PHCFR(freqdr),"^",2)
	q dosqty*durfactor*freqfactor
}

ClassMethod PHPACK(Ord, OrdSub)
{
   n (Ord,OrdSub)
     s i=0
	 s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:(OrdEx="")  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:(OrdDsp="")!(i=1)  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s Stat=$P(Dsp,"^",6)
    ..q:Stat'="C"
    ..s Qty=$G(Qty)+$P(Dsp,"^",1) 
    ..s ReQty=$G(ReQty)+$P(Dsp,"^",7)
    ..
    if $G(Qty)=$G(ReQty) s Re=1
    e  s Re=0 
    q Re
}

ClassMethod PHASTAT(Ord, OrdSub)
{
 
   n (Ord,OrdSub)
     s i=0
	
	 s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:(OrdEx="")!(i=1)  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:(OrdDsp="")!(i=1)  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s i=i+1
    ..s Stat=$P(Dsp,"^",6)  
    ..b
 q $G(Stat)
}

ClassMethod GetItem(i As %String, Adm As %String, strj As %String)
{
	i $d(^mtemp(strj,"temp",Adm,i)) d
	.w ^mtemp(strj,"temp",Adm,i)
	q ""
}

/// w ##class(web.DHCEMPhysiOreSheet).GetItemNum(119,4632)
ClassMethod GetItemNum(Adm As %String, strj As %String)
{
	w $o(^mtemp(strj,"temp",Adm,""),-1)
	q ""
}

ClassMethod getmother(adm) As %String
{
 //取母亲的登记号
	s motheradm=$P(^PAADM(adm),"^",75)
	if motheradm'="" {
	    s papmiId=+^PAADM(motheradm)
        s regNo=##Class(web.DHCEMCommonUtil).GetMrNo(adm)     //病案号
	}
	q $G(regNo)
}

ClassMethod GetPatLoc11(Adm As %String)
{
  	n (Adm)
  	s i=1
  	s PreLoc=""
  	s stdate=$P(^PAADM(Adm),"^",6)
  	k ^TMP($J,"loc")
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
  	.s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
  	.s stdate=$P(^PAADM(Adm,"TRANS",chl),"^",1)
  	.s sttime=$P(^PAADM(Adm,"TRANS",chl),"^",2)
  	.s enddate=$P(^PAADM(Adm,"TRANS",chl),"^",3)
    .s endtime=$P(^PAADM(Adm,"TRANS",chl),"^",4)
    .q:loc=""
  	.//i (loc'=PreLoc) d
  	.s ^TMP1($J,"loc",Adm,chl,loc)=((stdate*86400)+sttime)_"^"_((enddate*86400)+endtime)
  	.s tmp(loc)=chl
  	.s i=i+1
  	.s PreLoc=loc
  	 //清除多余的，每个科室只保留一条记录
  	 s chl=""  f  s chl=$O(^TMP1($J,"loc",Adm,chl)) q:chl=""  d
  	 .s loc=""  f  s loc=$O(^TMP1($J,"loc",Adm,chl,loc)) q:loc=""  d
  	 ..if chl'=tmp(loc) k ^TMP1($J,"loc",Adm,chl,loc)
  	q
}

/// d ##class(web.DHCEMPhysiOreSheet).GetPatLoc("458")
ClassMethod GetPatLoc(Adm As %String)
{
  	n (Adm)
  	s i=1
  	s PreLoc=""
  	s tmp=""
  	s EmdepString="^195^"
  	s stdate=$P(^PAADM(Adm),"^",6)
  	s tod=(+$H*86400)+$P($H,",",2)
  	
  	s admLoc=$p($g(^PAADM(Adm)),"^",4)
      s admLoc2="^"_admLoc_"^"
  	k ^TMP($J,"loc"),^TMP($J,"PatLoc")
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
  	.s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
  	.s stdate=$P(^PAADM(Adm,"TRANS",chl),"^",1)
  	.s sttime=$P(^PAADM(Adm,"TRANS",chl),"^",2)
  	.s enddate=$P(^PAADM(Adm,"TRANS",chl),"^",3)
    .s endtime=$P(^PAADM(Adm,"TRANS",chl),"^",4)
    .i (loc="")&(EmdepString[admLoc2)&(admLoc2'="^^") s loc=admLoc
    .q:loc=""
    .s temp(chl,loc)=(enddate*86400)+endtime
  	.i (loc'=PreLoc) d
  	..s ^TMP($J,"loc",Adm,chl,loc)=((stdate*86400)+sttime)_"^"_((enddate*86400)+endtime)
  	..s i=i+1
  	..s tmp=chl_"^"_loc
  	.s PreLoc=loc
  	// 指定每个科最后时间
  	 s chl=""  f  s chl=$O(^TMP($J,"loc",Adm,chl)) q:chl=""  d
  	 .s loc=""  f  s loc=$O(^TMP($J,"loc",Adm,chl,loc)) q:loc=""  d
  	 ..s $P(^TMP($J,"loc",Adm,chl,loc),"^",2)=temp(chl,loc) 
  	 ..s ^TMP($J,"PatLoc",Adm,loc)=""
  	//指定最后一个科室的结束时间^TMP($J,"loc",admId,DocLoc)
  	q:tmp=""
  	s chl=+$G(tmp)
  	s loc=$P($G(tmp),"^",2)
  	s $P(^TMP($J,"loc",Adm,chl,loc),"^",2)=tod
  	q
}

ClassMethod PRX(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	  ; ^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub}, "ST",{ST_Childsub})
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub, "ST",chl)) q:chl=""  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",3)
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=##class(web.DHCEMCommonUtil).DateLogicalToHtml(xdate)_"|"_$ZT(xtime,2)_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=##class(web.DHCEMCommonUtil).DateLogicalToHtml(xdate)_"|"_$ZT(xtime,2)_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   q $G(STR)
}

ClassMethod note(Oew, OrdSub)
{
	   n (Oew,OrdSub)
	   s Notes=""
	   f rnum=2:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	.s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	q $G(Notes)
}

/// Others:		 w ##class(web.DHCEMPhysiOreSheet).startrow("lsord",325,1,1,1,"0000000088")
ClassMethod startrow(typ As %String, adm As %String, page As %String, strow As %String, Dep As %String, depno As %String) As %String
{
 n (typ, adm, page, strow, Dep,depno) ////////*
  s ^DHCBLPRINTROW("D",typ,"xd",adm,"TranNo",depno,Dep)=page_"|"_strow
	  q 0
}

ClassMethod TmpStartrow(typ, adm, page, startrow, Dep) As %String
{
  //扑打设置
 s ^DHCBLPRINTROWTMP(typ,"xd",adm,Dep)=page_"|"_startrow
 q 0
}

ClassMethod KTmpSet(typ, adm, Dep) As %String
{
  //清除补打设置
  k ^DHCBLPRINTROWTMP(typ,"xd",adm,Dep)
  q 0
}

ClassMethod schtystrow(typ, adm, Dep, tranNo) As %String
{
  q:(typ="")!(adm="")!(Dep="") "" //////*
  n (typ, adm, Dep,tranNo)
  //if ($G(^DHCBLPRINTROW(typ,"xd",adm,Dep))="") {
	//   s str=$G(^DHCBLPRINTROW(typ,adm))
	//   s str1=$G(^DHCBLPRINTROW(typ,adm,Dep))
	//   if str1'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str1
	//   if str'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
	//   k ^DHCBLPRINTROW(typ,adm)
	   //s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
 // }
  q $G(^DHCBLPRINTROW("D",typ,"xd",adm,"TranNo",tranNo,Dep))
}

ClassMethod TmpSch(typ, adm, Dep, tranNo) As %String
{
	n (typ, adm, Dep,tranNo)  //////*
  //if ($G(^DHCBLPRINTROW(typ,"xd",adm,Dep))="") {
	//   s str=$G(^DHCBLPRINTROW(typ,adm))
	//   s str1=$G(^DHCBLPRINTROW(typ,adm,Dep))
	//   if str1'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str1
	//   if str'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
	//   k ^DHCBLPRINTROW(typ,adm)
	   //s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
  //}
  q $G(^DHCBLPRINTROW("D",typ,"xd",adm,"TranNo",tranNo,Dep))
}

ClassMethod SetStartPage(typ, adm, Dep, StPag, depNo)
{
 //设定转科后的起始页码
	s ^DHCBLPRINTROW("D",typ,"StarPage",adm,"TranNo",depNo,Dep)=StPag
}

/// Others:		 w ##class(web.DHCEMPhysiOreSheet).GetStartPage("lsord",325,1,"0000000088")
ClassMethod GetStartPage(typ, adm, Dep, depNo)
{
	w $G(^DHCBLPRINTROW("D",typ,"StarPage",adm,"TranNo",depNo,Dep))
	q ""
}

ClassMethod changedata(typ, head) As %String
{
  //longord,lsord
   n (typ,head)
   s adm=""  f  s adm=$O(^DHCBLPRINTROW(typ,head,adm)) q:adm=""  d
   .s locstr=##class(web.DHCLONGTIMEORD).GetTranLoc(adm)
   .s ret=..changeadmdata(typ,head,adm)
   q 1
}

ClassMethod changeadmdata(typ, head, adm) As %String
{
 
   n (typ,head,adm)
   s locstr=##class(web.DHCLONGTIMEORD).GetTranLoc(adm)
   s Dep=""  f  s Dep=$O(^DHCBLPRINTROW(typ,head,adm,Dep)) q:Dep=""  d
   .if $D(^DHCBLPRINTROW(typ,head,adm,Dep)) d
   ..s depno=..getdepno(locstr,Dep)
   ..q:depno=""
   ..s str=^DHCBLPRINTROW(typ,head,adm,Dep)
   ..s ^DHCBLPRINTROW("D",typ,head,adm,"TranNo",depno,Dep)=str
   q 1
}

ClassMethod getdepno(locstr, dep) As %String
{
  n (locstr,dep)
   s ln=$L(locstr,"|")
   for i=1:1:ln
   {
	   s tranStr=$P(locstr,"|",i)
	   s tranloc=$P(tranStr,"^")
	   s tranno=$P(tranStr,"^",4)
	   if tranloc=dep s depno=tranno 
   }
   q $G(depno)
}

ClassMethod saveordno(typ, ordno, flag) As %String
{
	    s ^DHCLOGSHORTORD(typ,ordno)=flag
	    q 0
}

ClassMethod fetchordno(typ, ordno) As %String
{
	    q $G(^DHCLOGSHORTORD(typ,ordno))
}

ClassMethod savestopord(ordno, typ) As %String
{
  
        ///停止医嘱

	    /// k (typ,ordno)stoporditem
	      s ^DHCSTOPORDITEM(ordno,typ)=""
	      q 0
}

ClassMethod stoporditem(ordno, typ) As %String
{
 //k (typ,ordno)
	      q $D(^DHCSTOPORDITEM(ordno,typ))
}

ClassMethod GetArcim(arc) As %String
{
 n (arc)
 //s arc="asdfasdfadf(asdf)(d*sdf)"
 s arc1=$P(arc,"(",1) 
 s arc2=$P(arc,"(",2)
 s arc3=$P(arc,"(",3)
 s arc4=$P(arc,"(",4)
 s arc5=$P(arc,"(",5)
 s arc6=$P(arc,"(",6)
 s a=arc1
 s f1=$F(arc2,"*")
 
 if (f1=0)&(arc2'="") s a=$G(a)_"("_arc2
 b
 s f1=$F(arc3,"*")
 if (f1=0)&(arc3'="") s a=$G(a)_"("_arc3
 b
 s f1=$F(arc4,"*")
 if (f1=0)&(arc4'="") s a=$G(a)_"("_arc4
 b
 s f1=$F(arc5,"*")
 if (f1=0)&(arc5'="") s a=$G(a)_"("_arc5
 s f1=$F(arc6,"*")
 if (f1=0)&(arc6'="") s a=$G(a)_"("_arc6
 
 q a
}

ClassMethod UpdateDate(par, exdate, extime) As %String
{
	n (par,exdate,extime)
	s exdate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(exdate) //$ZDH(exdate,3)
	s extime=$ZTH(extime)
	&sql(update oe_ordexec set OEORE_DateExecuted=:exdate, OEORE_TimeExecuted=:extime where oeore_oeori_parref=:par)
	q SQLCODE
}

ClassMethod UpdateStDate(Row, StDate, StTime) As %String
{
	n (Row, StDate, StTime)
	S StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate) //$ZDH(StDate,3)
	s StTime=$ZTH(StTime)
	&sql(update oe_orditem set  OEORI_SttDat=:StDate,  OEORI_SttTim=:StTime where oeori_rowid=:Row)
	q SQLCODE
}

ClassMethod SaveHBord(oeoriIdStr) As %String
{
	//保存后补不打印医嘱
	s cl=$P(oeoriIdStr,"^",1)
	if cl="Clear"
	{
		s orw=$P($P(oeoriIdStr,"^",2),"||",1)
		k ^DHCTEMPHBORD(orw)
	}
	q:cl="Clear" 0
	s num=$l(oeoriIdStr,"^")
		s oeoriId=$p(oeoriIdStr,"^",1)
	    s oew=$P(oeoriId,"||")
        k ^DHCTEMPHBORD(oew)
		f i=1:1:num d
	    .s oeoriId=$p(oeoriIdStr,"^",i)
	    .s oew=$P(oeoriId,"||")
	    .s sub=$P(oeoriId,"||",2)
	    .s ^DHCTEMPHBORD(oew,sub)=""
	 q 0
}

ClassMethod GetOrdChecked(oeord) As %String
{
  n (oeord)
	s orw=$P(oeord,"||")
	s sub=$P(oeord,"||",2)
	if $D(^DHCTEMPHBORD(orw,sub)) s ret=1
	else  s ret=0
	q ret
}

ClassMethod getloc(oeord, ordsub) As %String
{
	 n (oeord,ordsub)
    s admId=$p($g(^OEORD(oeord)),"^",1)
	s ctlocdr=$P(^PAADM(admId),"^",4)
	 s user=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",1)
	 s userdep=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",2)  //oeori_UserDepartment_DR
	 q:user="" ""
	 q:'$D(^SSU("SSUSR",user)) ""
	 s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	 q:DoctorDr="" "" ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))

	 q:'$D(^CTPCP(DoctorDr,1)) ""
	 s typdr=$P(^CTPCP(DoctorDr,1),"^",4)
	 s typ=$P(^CT("CPT",typdr),"^",4)
	 s i=0
	 s loc="" f  s loc=$O(^RB("RES",0,"CTPCP",DoctorDr,loc)) q:(loc="")  d
	 .s i=i+1
	 s loc="" f  s loc=$O(^RB("RES",0,"CTPCP",DoctorDr,loc)) q:(loc="")!(loc=ctlocdr)  d
	 if (i>2)&(userdep'=ctlocdr)&(userdep'="")
	 {
		 q ""
	 }

	 q loc
}

// add by WKZ 071213

ClassMethod GetUserType(userId) As %String
{
	q:userId=""
	s userDr=$P($G(^SSU("SSUSR",userId)),"^",14)
	q:userDr="" "" 
    s CpTypDR=$P(^CTPCP(userDr,1),"^",4)         
	i $G(CpTypDR)'="" s CpTyp=$P($G(^CT("CPT",CpTypDR)),"^",4)  
	q CpTyp
}

ClassMethod GetFlage(ARCIMRowid, ARCIMSub) As %String
{
	s flage=0
	s billSubDr=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
	q:billSubDr="" flage
	i (billSubDr="61||2")!(billSubDr="61||3") s flage=1
	//s bgRowId=$P(billSubDr,"||",1)
	//s bgChilSub=$P(billSubDr,"||",1)
	//s sgCode=$P($G(^ARCBG(bgRowId,"SG",bgChilSub)),"^",1)
	//i (sgCode["HHH")!(sgCode["HHH")  s flage=1
	q flage
}

ClassMethod getMinDose(ARCIMRowid, ARCIMSub) As %String
{
	s retStr=""
	s phcDFDr=$P($G(^ARCIM(ARCIMRowid, ARCIMSub,1)),"^",12)
	q:phcDFDr="" retStr
	s phcDFRowId=$P($G(phcDFDr),"||",1)
	q:phcDFRowId="" retStr
	s phcDFSubRowId=$P($G(phcDFDr),"||",2)
	q:phcDFSubRowId="" retStr
	s phcDFChildSub=$O(^PHCD(phcDFRowId,"DF",phcDFSubRowId,"EQ",""),-1)
	q:phcDFChildSub="" retStr
	s eqQty=$P($G(^PHCD(phcDFRowId,"DF",phcDFSubRowId,"EQ",phcDFChildSub)),"^",2)
	q:eqQty="" retStr
	s uomDr=$P($G(^PHCD(phcDFRowId,"DF",phcDFSubRowId,"EQ",phcDFChildSub)),"^",1)
	i uomDr'="" s uomDesc=$P(^CT("UOM",uomDr),"^",2)
	i (eqQty'="")&(eqQty<1) 	s eqQty="0"_eqQty
	s retStr=eqQty_$G(uomDesc)
	q retStr
}

ClassMethod getFlageCL(ARCIMRowid, ARCIMSub)
{
	s flage=0
	s billSubDr=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
	q:billSubDr="" flage
	i billSubDr="61||1" s flage=1
	q flage
}

ClassMethod GetPreStopDate(Oew, OrdSub) As %String
{
  //取预停日期时间
 	   n (Oew, OrdSub)
 	   s retstr=""
 	   s PreStopDate=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",9)  ;stop date
	   s PreStopTime=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",10)   ;stop time
	   if PreStopDate'="" s retstr=PreStopDate_"^"_PreStopTime
	   e  s retstr=""
       q retstr
}

ClassMethod GETOID(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	  s oid=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",12)
	  i oid'="" d
	  .s OPar=$P(oid,"!!",1)
	  .s par=$P(OPar,"||",1)
	  .s chl=$P(OPar,"||",2)
	  .s RowId=par_","_chl
	  q $G(RowId)
}

/// w ##class(web.DHCEMPhysiOreSheet).QueryGetTempOrdInfo(0,6,"12","","","","0","11","1","0","0","长期医嘱")
ClassMethod ExeTempQuery(Adm, Dep, ssuser) As %String
{
 n (Adm, Dep, ssuser)
 Set rset = ##class(%ResultSet).%New()
 Set rset.ClassName = "web.DHCTEMweb.DHCEMPhysiOreSheetPOERPRINT"
 Set rset.QueryName = "QueryGetTempOrdInfo"
 ;Do rset.Execute(Adm,"","","", "",ssuser, Dep,1,1)
 Do rset.Execute(Adm,"","","", "",ssuser, Dep,0,1)
 q $j
}

}
