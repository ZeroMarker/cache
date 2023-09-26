/// Creator:zhangdongmei
/// CreatDate:2012-04-12
/// Descriprtion:常用检查工具
Class web.DHCSTTOOLS Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zhangdongmei
/// CreatDate:2012-04-12
/// Descriprtion:检测某医嘱为什么不能发药
/// Table:DHC_oedispensing , OE_OrdItem
/// Input:医嘱id,发药科室id
/// Output:不能发药原因
/// Others:w ##class(web.DHCSTTOOLS).CheckDispOrd("30776||116",253)
ClassMethod CheckDispOrd(Oeori As %String, LocId As %String) As %Integer
{
 n (Oeori,LocId)
 s Msg="" 
 s DspId=0
 f  s DspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,DspId)) q:(DspId="")!(Msg'="")  d
 .
 .;w !,h
 .s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
 .s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针 ..
 .s AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
 .s:AdmDr="" Msg="AdmDr为空"
 .q:AdmDr=""
 .s AdmWard=$p(^PAADM(AdmDr),"^",70)  		;病人当前病房
 .s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
 .s:AdmType'="I" Msg=AdmDr_"非住院病人"
 .q:AdmType'="I"  							;过滤非住院病人     
 .s Ord=+OrdExeRowid
 .s Chl=$p(OrdExeRowid,"||",2)
 .s OreChl=$p(OrdExeRowid,"||",3)
 .s:Ord="" Msg="Ord为空"
 .q:Ord=""
 .s:Chl="" Msg="Chl为空"
 .q:Chl=""
 .s:'$d(^OEORD(Ord)) Msg="不存在^OEORD(Ord)"
 .q:'$d(^OEORD(Ord))
 .
 .s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8)
 .s:PriorDr="" Msg="优先级不存在" 
 .q:PriorDr=""  										
 .s Priority=$p(^OECPR(PriorDr),"^",1) 					
 .s:(Priority="OM")!(Priority="OMST") Msg="自备药即刻,长期"              
 .q:Priority="OM" 									;自备药即刻 
 .q:Priority="OMST" 									;自备药长期
 .s Doctor=$p(^OEORD(Ord,"I",Chl,7),"^",1)
 .s DoctorLoc=$p(^OEORD(Ord,"I",Chl,7),"^",2)   			;060725
 .s DocFlag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(LocId,DoctorLoc)
 .s:DocFlag=1 Msg=DoctorLoc_"为特殊科室"				
 .q:DocFlag=1
 .s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 .s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 .s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(AdmDr,ArcCatId_"^"_Priority)  ;最终结算,则不发药
 .s:AmtFlag=0 Msg=AdmDr_"最终结算"
 .q:AmtFlag=0
 .s Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),"") ) 
 .s:Inci="" Msg=ArcimId_"没有对应库存项"
 .q:Inci=""
 .s:'$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL")) Msg=OrdExeRowid_"不存在节点：^OEORD(Ord,I,Chl,X,OreChl,BILL)"
 .q:'$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"))
 .s OreFlag=##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)
 .s:OreFlag=0 Msg=OrdExeRowid_"执行记录状态是不可配药"
 .q:OreFlag=0  
 .//护士领药审核控制
 .s AuditFlag=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)  ;需要审核但是配药记录未审核则不发药
 .s:AuditFlag=0 Msg=DspId_"护士未审核"
 .q:AuditFlag=0
 .
 .s RefuseFlag=##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId)
 .s:RefuseFlag=1 Msg=DspId_"被拒绝发放"
 .q:RefuseFlag=1   ;被拒绝发放
 .
 q Msg
}

}
