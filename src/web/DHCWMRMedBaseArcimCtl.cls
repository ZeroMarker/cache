Import SQLUser

Class web.DHCWMRMedBaseArcimCtl Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

ClassMethod GetOrdsDrug(paadm, DrugFlag)
{
	n (paadm,DrugFlag)
    s num=0,s=""
    q:'$d(^OEORD(0,"Adm",+paadm)) s
       
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
       
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .;q:$$CheckOrderType(arcim,OrderType)=0
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    .q:Type'="R"
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...;s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    ...;s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    ...;s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    ...;w !,oeoriSub_"---"_OrderStatus
    ...;q:OrderStatus'="Y"
    ...s oeori=oeord_"||"_oeoriSub
    ...q:..CheckOrderStatus(oeori)<0
    ...s TMP=..GetOrdsDrugItms(arcim,oeori,DrugFlag)
    ...s:TMP'="" s=s_TMP_$c(1)
       q s
}

ClassMethod GetOrdsDrugItms(arcim, oeori, DrugFlag)
{
   n (arcim,oeori,DrugFlag)
   s phccat=..GetPhcCat(arcim)
   s HospCode=##Class(DHCWMRMedBase01).GetHospitalCode()
   s:HospCode="ChengDu_HX" phccat=..GetPhcSubCat(+arcim)
   s:HospCode="ZheJiang_QZ" phccat=..GetPhcSubCat(+arcim)
   q:(DrugFlag'="")&((phccat'["抗感染")&(phccat'["抗生素")&(phccat'["抗微生物")) ""   ;by wuqk 2008-05-12
   s phccat=..GetPhcCat(+arcim)
   s oeord=$p(oeori,"||",1)
   s oeoriSub=$p(oeori,"||",2)
   s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
   s sttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
   s ctuom=+$p($g(^ARCIM(+arcim,"1",1)),"^",4),uomDesc=""
   s:ctuom>0 uomDesc=$p($g(^CT("UOM",+ctuom)),"^",2)
   s InstrDR=+$p($g(^OEORD(+oeord,"I",+oeoriSub,2)),"^",7),InstrDesc=""
   s:InstrDR>0 InstrDesc=$p($g(^PHCIN(InstrDR)),"^",2)
   s DoseQty=+$p($g(^OEORD(+oeord,"I",+oeoriSub,2)),"^",1)
   s PhQtyOrd=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",12)
   s PriorityDR=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",8),PriorityDesc=""
   s:PriorityDR>0 PriorityDesc=$p($g(^OECPR(PriorityDR)),"^",2)
   s PHFreqDR=+$p($g(^OEORD(+oeord,"I",+oeoriSub,2)),"^",4),PHFreqDesc=""
   s:PHFreqDR>0 PHFreqDesc=$p($g(^PHCFR(PHFreqDR)),"^",1)
   s DuratDR=+$p($g(^OEORD(+oeord,"I",+oeoriSub,2)),"^",6),DuratDays=1,DuratDesc=""
   s:DuratDR>0 DuratDays=+$p($g(^PHCDU(DuratDR)),"^",2),DuratDesc=$p($g(^PHCDU(DuratDR)),"^",3)
   s endDate=sttDate+DuratDays-1
   s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
   s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
   s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
   s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
   s s=oeori_$c(2)_arcimDesc_$c(2)_PriorityDesc_$c(2)_sttDate_$c(2)_endDate_$c(2)_PHFreqDesc_$c(2)_DoseQty_$c(2)_DuratDesc_$c(2)_InstrDesc_$c(2)_uomDesc_$c(2)_phccat_$c(2)_PhQtyOrd_$c(2)_OrderStatusDesc
      
   q s
}

ClassMethod GetPhcSubCat(arcim)
{
     n (arcim) 
     s s=""
     s drgfrmrowid=$p(^ARCIM(+arcim,1,1),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p(^PHCD(drugrowid,1),"^",3)        ;PHC_SubCat药理学子分类
     q:psubcatrowid="" ""
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s phcsub=$p(psubcatrowid,"||",2)
     s s=psubcatrowid_"/"_$p($g(^PHCC(phccat,"SC",phcsub)),"^",1)_"/"_$p($g(^PHCC(phccat,"SC",phcsub)),"^",2)
     q s
}

ClassMethod GetPhcCat(arcim)
{
     n (arcim) 
     s s=""
     s drgfrmrowid=$p(^ARCIM(+arcim,1,1),"^",12)        ;PHC_DrgForm:药学形态
     s drugrowid=+drgfrmrowid                           ;PHC_DrgMast药理学项
     q:drugrowid=0 s
     s psubcatrowid=$p(^PHCD(drugrowid,1),"^",3)        ;PHC_SubCat药理学子分类
     ;s pmincatrowid=$p(^PHCD(drugrowid,1),"^",6)        ;PHC_MinorSubCat药理学最小分类
     s phccat=+psubcatrowid                             ;phc_cat药理学分类
     s s=phccat_"/"_$p($g(^PHCC(phccat)),"^",1)_"/"_$p($g(^PHCC(phccat)),"^",2)
     q s
}

ClassMethod CheckOrderStatus(oeori)
{
    n (oeori)
    s flag=0
    s oeord=$p(oeori,"||",1)
    s oeoriSub=$p(oeori,"||",2)
    s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    s:OrderStatusCode="D" flag=-1   ;停止
    s:OrderStatusCode="S" flag=-1   ;暂缓
    q flag
}

ClassMethod GetOrdsOper(paadm)
{
	n (paadm)
	s s=..GetOperationInfo(paadm)
	q s
}

ClassMethod GetOperationInfo(paadm)
{
    ;取手术记录
    n (paadm)
    s ret=""
    ;s tmpConfig=$g(^DHCMedInfConfig(0))   ;modify by wuqk 2008-03-31
    ;手术=0-取手术类医嘱信息
    ;     1-取手术申请单信息(安贞)
    ;     2-从手术麻醉系统取手术信息
    s tmpConfig=$g(^DHCMedConfig("Inf",0)) 
    s OperConfig=+$p(tmpConfig,"^",1)
    s:OperConfig=0 ret=..GetOrdsOperM(paadm)       ;取手术医嘱信息
    s:OperConfig=1 ret=..GetAZOperation(paadm)    ;取安贞手术记录单信息
    s:OperConfig=2 ret=..GetSysOper(paadm)       ;取手术医嘱信息
    
    q ret
}

ClassMethod GetSysOper(Paadm)
{
   n (Paadm)
   s ret=""
   ;^DHCANOPArrange是DHC_AN_OPArrange手术排班表
   ;^DHCANOPArrange(0,"Adm",{OPA_Adm_dr},{OPA_RowId})
   ;麻醉表OR_Anaesthesia
   ;^OR({PA_Adm.PAADM_RowID},"ANA",{ANA_Childsub})  
   ;手术表OR_Anaest_Operation
   ;^OR({PA_Adm.PAADM_RowID},"ANA",{Childsub},"OP",{ANAOP_Childsub})  
   q:'$d(^DHCANOPArrange(0,"Adm",Paadm)) ret
   
   s oparr=0
   f  s oparr=$o(^DHCANOPArrange(0,"Adm",Paadm,oparr)) q:oparr=""  d
   .s anaRowid=$p($g(^DHCANOPArrange(oparr)),"^",2)  ;OPA_Anaest_dr
   .s anaChild=$p(anaRowid,"||",2)
   .s opChild=0
   .f  s opChild=$o(^OR(Paadm,"ANA",anaChild,"OP",opChild)) q:opChild=""  d
   ..s opRowid=Paadm_"||"_anaChild_"||"_opChild
   ..s TMP=..GetSysOperInfo(opRowid,oparr)
   ..s:TMP'="" ret=ret_TMP_$c(1)
   
   /*
   s anaChild=0
   f  s anaChild=$o(^OR(Paadm,"ANA",anaChild)) q:anaChild=""  d
   .q:'$d(^OR(Paadm,"ANA",anaChild,"OP"))
   .s opChild=0
   .f  s opChild=$o(^OR(Paadm,"ANA",anaChild,"OP",opChild)) q:opChild=""  d
   ..s opRowid=Paadm_"||"_anaChild_"||"_opChild
   ..s TMP=$$GetSysOperInfo(opRowid)
   ..w !,TMP
   ..s:TMP'="" ret=ret_TMP_$c(1)
   */
   q ret
}

ClassMethod GetSysOperInfo(opRowid, oparrRowid)
{
   n (opRowid,oparrRowid)
   s Paadm=$p(opRowid,"||",1)
   s anaChild=$p(opRowid,"||",2)
   s opChild=$p(opRowid,"||",3)
   s ret=""
   s s=$g(^OR(Paadm,"ANA",anaChild,"OP",opChild))
   s OPTypeDR=$p(s,"^",6)            ;->ORC_Operation
   s OPDescription=$p($g(^ORC("OPER",OPTypeDR)),"^",2)
   s OPICD9Map=$p($g(^ORC("OPER",OPTypeDR)),"^",21)
   
   s sArr=$g(^DHCANOPArrange(oparrRowid))
   ;手术状态OPA_Status
   s OperStatus=$p(sArr,"^",27)
   ;Apply,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp
   
   s OpStartDate=$p(sArr,"^",14)
   s:OpStartDate'="" OpStartDate=$zd(OpStartDate,3)
   s OpStartTime=$p(sArr,"^",15)
   s:OpStartTime'="" OpStartTime=$zt(OpStartTime,2)
   
   s OpEndDate=$p(sArr,"^",16)
   s:OpEndDate'="" OpEndDate=$zd(OpEndDate,3)
   s OpEndTime=$p(sArr,"^",17)
   s:OpEndTime'="" OpEndTime=$zt(OpEndTime,2)
   
   
   ;手术医生ANAOP_Surgeon_DR 
   s opDoctor=""
   s opDocDr=$p(s,"^",8)
   s:opDocDr'="" opDoctor=##Class(DHCWMRMedBase).GetUserByCTCP(opDocDr)
   
   ;一助
   ;二助
   s assList=""
   s ass=0
   f  s ass=$o(^OR(Paadm,"ANA",anaChild,"OP",opChild,"ASS",ass)) q:ass=""  d
   .s assDr=$g(^OR(Paadm,"ANA",anaChild,"OP",opChild,"ASS",ass))
   .s assDoctor=""
   .s:assDr'="" assDoctor=##Class(DHCWMRMedBase).GetUserByCTCP(assDr)
   .s:assDoctor'="" assList=assList_assDoctor_$c(3)
   
   
   s Anaesthesia=$g(^OR(Paadm,"ANA",anaChild))
   s anDoctor=""
   s anDocDr=$p(Anaesthesia,"^",7)
   s:anDocDr'="" anDoctor=##Class(DHCWMRMedBase).GetUserByCTCP(anDocDr)
   ;麻醉医师
   ;ANA_Anaesthetist_DR  ?
   s anaMethod=""
   s anaMethodDr=$p(Anaesthesia,"^",5)
   s:anaMethodDr'="" anaMethod=$p(^ORC("ANMET",anaMethodDr),"^",2)
   ;麻醉方法
   ;ANA_Method?
   
   s TMP=opRowid_$c(2)_OPDescription_$c(2)_OpStartDate_$c(2)_OperStatus_$c(2)_OpStartDate_$c(2)_OpStartTime_$c(2)_OpEndDate_$c(2)_OpEndTime_$c(2)_opDoctor_$c(2)_anaMethod_$c(2)_anDoctor_$c(2)_assList_$c(2)_OPICD9Map
   q TMP
}

ClassMethod GetAZOperation(paadm)
{
    ;取安贞手术记录单手术信息
    ;功能同$$GetOrdsOper^DHCWMRMedBaseArcim(paadm)
    n (paadm)
    s s=""
    
    ;^opeschi(0,"ADM",{sch_adm_dr},{sch_rowid})
    q:'$d(^opeschi(0,"ADM",+paadm)) s
    s id=0
    f  s id=$o(^opeschi(0,"ADM",+paadm,id)) q:id=""  d
    .q:'$d(^opesch(id))
    .s tmpOper=$g(^opesch(id))
    .;s OperDesc=$p(tmpOper,"^",21)
    .;s OperDate=$p(tmpOper,"^",17)
    .s OperStatus=$p(tmpOper,"^",28)
    .q:(OperStatus'["停止")&&(OperStatus'["完成")
    .s TMP=..GetAZOperInfo(id)
    .;s TMP=id_$c(2)_OperDesc_$c(2)_$zd(OperDate,3)_$c(2)_OperStatus
    .s s=s_TMP_$c(1)
    q s
}

ClassMethod GetAZOperInfo(OperRowid)
{
    ;取安贞手术记录单详细信息
    n (OperRowid)
    s ret=""
    ;s tmpConfig=$g(^DHCMedInfConfig(0))   ;modify by wuqk 2008-03-31
    ;s tmpConfig=$g(^DHCMedConfig("Inf",0))   
    ;q:(+$p(tmpConfig,"^",1))'=1 ret
    q:'$d(^opesch(+OperRowid)) ret
    s tmpOper=$g(^opesch(+OperRowid))
    s StartDate=+$p(tmpOper,"^",17)
    s:StartDate'=0 StartDate=$zd(StartDate,3)
    s:StartDate=0 StartDate=""
    s StartTime=+$p(tmpOper,"^",18)
    s:StartTime'=0 StartTime=$zt(StartTime,2)
    s:StartTime=0 StartTime=""
    s EndDate=+$p(tmpOper,"^",22)
    s:EndDate'=0 EndDate=$zd(EndDate,3)
    s:EndDate=0 EndDate=""
    s EndTime=+$p(tmpOper,"^",23)
    s:EndTime'=0 EndTime=$zt(EndTime,2)
    s:EndTime=0 EndTime=""
    s OperDoc=$p(tmpOper,"^",12)
    ;^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP({SSUSR_Name}),{SSUSR_RowId})
    s tmpId=0,DocId="",DocCode="",DocDesc=""
    f  s tmpId=$o(^SSU("SSUSR",0,"SSUSR_Name",OperDoc,tmpId)) q:(tmpId="")||(DocDesc'="")  d
    .s DocId=tmpId
    .s DocCode=$p($g(^SSU("SSUSR",DocId)),"^",1)
    .s DocDesc=$p($g(^SSU("SSUSR",DocId)),"^",2)
    s:DocDesc="" OperDoc="//"_OperDoc
    s:DocDesc'="" OperDoc=DocId_"/"_DocCode_"/"_DocDesc
    s Anamed=$p(tmpOper,"^",34)
    s:Anamed'="全麻" Anamed="非全麻"
    s:Anamed="全麻" Anamed=1
    s:Anamed="非全麻" Anamed=2
    
    ;add by wuqk 2008-03-31
    s OperDesc=$p(tmpOper,"^",21)
    s OperStatus=$p(tmpOper,"^",28)
    s TMP=OperRowid_$c(2)_OperDesc_$c(2)_StartDate_$c(2)_OperStatus_$c(2)_StartDate_$c(2)_StartTime_$c(2)_EndDate_$c(2)_EndTime_$c(2)_OperDoc_$c(2)_Anamed
    
    ;s ret=StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_OperDoc_"^"_Anamed
    q TMP
}

ClassMethod GetOrdsOperM(paadm)
{
    n (paadm)
    s num=0,s=""
    q:'$d(^OEORD(0,"Adm",+paadm)) s       
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
    s HospCode=##Class(DHCWMRMedBase01).GetHospitalCode()
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s OrdCat=+$p($g(^ARC("IC",+ItmCat)),"^",8)
    .S OrdCatSubDesc=$p($g(^ARC("IC",+ItmCat)),"^",2) //医嘱子类描述
    .s OrdCatDesc=$p($g(^OEC("ORCAT",OrdCat)),"^",2)  //医嘱大类描述
    .q:OrdCatDesc'["手术"
    .q:(HospCode="ShangHai_HSDY")&&(OrdCatSubDesc'["普通手术")  //add by zf 20091027
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...;q:$$CheckOrderStatus(oeord_"||"_oeoriSub)<0
    ...s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    ...s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    ...s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    ...s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...;w !,oeoriSub_"---"_OrderStatus
    ...;q:OrderStatus'="Y"
    ...s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    ...s sttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
    ...s oeori=oeord_"||"_oeoriSub
    ...s TMP=oeori_$c(2)_arcimDesc_$c(2)_$zd(sttDate,3)_$c(2)_OrderStatusDesc
    ...s s=s_TMP_$c(1)
    q s
}

ClassMethod GetOrdsLab(paadm)
{
	n (paadm)
    s num=0,s=""
    q:'$d(^OEORD(0,"Adm",+paadm)) s       
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
    s aNum=..BuildCurrDepArcim(paadm)
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    .;w:Type="L" !,"arcimDesc="_arcimDesc_"   Type="_Type
    .q:Type'="L"
    .s flag=""
    .s:$d(^CacheTemp($zn,$j,"ARCIM",arcim)) flag="1"
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...;q:$$CheckOrderStatus(oeord_"||"_oeoriSub)<0
    ...s ItemStatDR=$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",13)
    ...s OrderStatus=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",3)
    ...s OrderStatusDesc=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",2)
    ...s OrderStatusCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
    ...q:(OrderStatusCode="D")!(OrderStatusCode="S")
    ...;w !,"    oeori="_oeord_"||"_oeoriSub_"  "_OrderStatus_"  "_OrderStatusDesc
    ...;w !,oeoriSub_"---"_OrderStatus
    ...;q:OrderStatus'="Y"
    ...;s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    ...s sttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
    ...s labtestsetrow=$p($g(^OEORD(+oeord,"I",+oeoriSub,3)),"^",35)
    ...;w !," oeori="_oeord_"||"_oeoriSub_"    labtestsetrow="_labtestsetrow
    ...s oeori=oeord_"||"_oeoriSub
    ...s TMP=oeori_$c(2)_arcimDesc_$c(2)_$zd(sttDate,3)_$c(2)_flag_$c(2)_labtestsetrow_$c(2)_OrderStatusDesc
    ...s s=s_TMP_$c(1)
    k ^CacheTemp($zn,$j,"ARCIM")
    q s
}

ClassMethod BuildCurrDepArcim(paadm)
{
    ;From DHC_MedDepGroupArcim
    n (paadm)
    s num=0
    k ^CacheTemp($zn,$j,"ARCIM")
    s ctloc=+$p($g(^PAADM(+paadm)),"^",4)
    s cDep=+$p($g(^CTLOC(+ctloc)),"^",19)
    
    q:'$d(^DHCMDG(0,"FlagDepGroup","Y",cDep)) num
    
    s MDGRowid=$o(^DHCMDG(0,"FlagDepGroup","Y",cDep,""))
    
    q:'$d(^DHCMDG(MDGRowid)) num
    s ChildSub="0"
    f  s ChildSub=$o(^DHCMDG(MDGRowid,"A",ChildSub)) q:(ChildSub="")  d
    .s tmp=$g(^DHCMDG(MDGRowid,"A",ChildSub))
    .q:$p(tmp,"^",1)'="Y"
    .s arcim=$p(tmp,"^",2)
    .q:'$d(^ARCIM(+arcim))
    .s num=num+1
    .s ^CacheTemp($zn,$j,"ARCIM",arcim)=""
    q num
}

ClassMethod GetOrdsDrugArcim(paadm, DrugFlag)
{
	n (paadm,DrugFlag)
    s num=0,s=""
    q:'$d(^OEORD(0,"Adm",+paadm)) s
       
    s oeord=$o(^OEORD(0,"Adm",+paadm,""))
       
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .;q:$$CheckOrderType(arcim,OrderType)=0
    .s ItmCat=+$p($g(^ARCIM(+arcim,"1",1)),"^",10)
    .s Type=$p($g(^ARC("IC",+ItmCat)),"^",7)
    .q:Type'="R"
    .s phccat=..GetPhcCat(+arcim)
    .s HospCode=##Class(DHCWMRMedBase01).GetHospitalCode()
    .s:HospCode="ChengDu_HX" phccat=..GetPhcSubCat(+arcim)
    .s:HospCode="ZheJiang_QZ" phccat=..GetPhcSubCat(+arcim)
    .q:(DrugFlag'="")&((phccat'["抗感染")&(phccat'["抗生素")&(phccat'["抗微生物"))    ;by wuqk 2008-05-12
    .s phccat=..GetPhcCat(+arcim)
    .s arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
    .s sttDate="",endDate="",Days=0,TMP=""
    .s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
    ...s oeori=oeord_"||"_oeoriSub
    ...;q:$$CheckOrderStatus(oeori)<0
    ...s TsttDate=+$p($g(^OEORD(+oeord,"I",+oeoriSub,1)),"^",9)
    ...s DuratDR=+$p($g(^OEORD(+oeord,"I",+oeoriSub,2)),"^",6),DuratDays=1
    ...s:DuratDR>0 DuratDays=+$p($g(^PHCDU(DuratDR)),"^",2)
    ...s TendDate=TsttDate+DuratDays-1
    ...s:sttDate="" sttDate=TsttDate
    ...s endDate=TendDate
    ...;q:$$CheckOrderStatus(oeori)<0
    ...s Days=Days+DuratDays
    .s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
    .;s:sttDate'="" sttDate=$zd(sttDate,3)
    .;s:endDate'="" endDate=$zd(endDate,3)
    .s TMP=arcim_$c(2)_arcimDesc_$c(2)_sttDate_$c(2)_endDate_$c(2)_Days
    .s s=s_TMP_$c(1)
    q s
}

}
