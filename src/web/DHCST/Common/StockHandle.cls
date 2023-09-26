Import sqluser

/// Creator:zdm
/// CreatDate:2011-12-30
/// Modify:zdm,2012-07-03
/// Description:库存及台帐处理相关方法，
/// 入库库存处理调用方法：UpdateStockForImp
/// 其它业务涉及库存处理，调用方法：UpdateStock
/// 本类中其它方法为内部方法
/// 
Class web.DHCST.Common.StockHandle Extends %RegisteredObject
{

/// Creator:zdm
/// CreatDate:2011-12-30
/// Description:更新库存
/// InPut：Inc_ItmLcBt表rowid,库存量
/// Table:Inc_ItmLcBt
/// OutPut:
/// Return:0,成功
/// -52  ;更新库存的参数为空
/// -50   ;不存在该药品
///  -51  ;不存在该科室
///  -53 ;加锁失败
/// -54 ;更新科室库存失败
/// -55   ;更新批次库存失败
/// -56  ;更新DHC库存失败
/// -57  ;更新DHC批次库存失败
/// -58  ;更新批次库存项活动状态失败
/// w ##class(web.DHCST.Common.StockHandle).UpdateStock("1||1||1",2)
ClassMethod UpdateStock(Inclb, Qty) As %Library.String
{
    q:Inclb="" -52  ;更新库存参数为空
    q:Qty="" -52
    ;
    s Inci=+Inclb
    s IL=$p(Inclb,"||",2)
    s LB=$p(Inclb,"||",3)
    s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
    q:'$d(^INCI(Inci)) -50   ;不存在该药品
    q:'$d(^CTLOC(LocId)) -51  ;不存在该科室
    s IncIL=Inci_"||"_IL
    s LockName="UPDATESTOCK:"_LocId_"||"_Inci
    ;
    ;对目标库存加锁
    s ret=##class(web.DHCST.Common.AppCommon).Lock(LockName)  
    q:ret'=0 -53 ;加锁失败
    ;
    tstart
    s $ZT="ErrUpdateStock"                      ;增加错误处理
    ;处理INC_ItmLoc库存
    s Ret=..UpdateIncItmLoc(Inci_"||"_IL,Qty)
    i Ret'=0  d
    .trollback
    .d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 -54            ;处理INC_ItmLoc失败
    ;处理INC_ItmLcBt库存
    s Ret=..UpdateIncItmLcBt(Inclb,Qty)
    i Ret'=0 trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 -55   ;更新批次库存失败
    ;处理DHC_LocDailyTotal库存
    s Ret=..UpdateMainByID(Inci,Qty,LocId)
    i +Ret>0  d
    .s DayId=Ret
    .s Ret=0
    i Ret'=0 trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 -56  ;更新DHC库存失败
    ;处理DHC_LocBtDailyTotal库存
    s Ret=..UpdateDayBT(Inclb,Qty,DayId)
    i +Ret>0  d
    .s DayBtId=Ret
    .s Ret=0
    i Ret'=0 trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 -57  ;更新DHC批次库存失败  
    s Ret=..UpdateDhcIncItmLcBt(Inclb,"Y","Y")    ;更新状态为活动
    i +Ret<=0  trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:+Ret<=0 -58  ;更新批次库存项活动状态失败
    
    tcommit
    d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q 0
ErrUpdateStock
    d ErrorRecord^DHCSTERROR("DHCSTPARAMER", Inclb _ "~" _ Qty, $ze)
    return "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Creator:zdm
/// CreatDate:2011-12-30
/// Modify:zdm,2012-07-04
/// Description:入库库存处理
/// InPut：库存项rowid,科室rowid,批次rowid,库存量
/// Table:
/// OutPut:
/// Return:成功;inc_itmlcbt表rowid
/// -52    ;输入参数为空
/// -50         ;不存在该药品
/// -51     ;不存在该科室
/// -53     ;加锁失败
/// -54    ;更新科室库存失败
/// -60    ;保存科室库存失败
/// -55   ;更新批次库存失败
/// -61   ;保存批次库存失败
/// -56  ;更新dhc库存失败
/// -57   ;更新dhc批次库存失败  
ClassMethod UpdateStockForImp(Inci As %String, LocId As %String, IncIb As %String, Qty As %String) As %Library.String
{
    ///n (Inci,LocId,IncIb,Qty)
    q:Inci="" -52    ;输入参数为空
    q:LocId="" -52
    q:IncIb="" -52
    ;
    q:'$d(^INCI(Inci)) -50          ;不存在该药品
    q:'$d(^CTLOC(LocId)) -51        ;不存在该科室
    s LockName="UPDATESTOCK:"_LocId_"||"_Inci
    ;对目标库存加锁
    s ret=##class(web.DHCST.Common.AppCommon).Lock(LockName)  
    q:ret'=0 -53 ;加锁失败
    ;
    tstart
    s $ZT="ErrUpdateStockForImp"                        ;增加错误处理
    ;处理INC_ItmLoc库存
    s IncIL=""
    s IL=$o(^INCI("IL_LOC",LocId,Inci,0))
    i IL'=""  d
    .s Ret=..UpdateIncItmLoc(Inci_"||"_IL,Qty)   ;更新库存
    .s:Ret'=0 Ret=-54    ;更新科室库存失败
    e  d
    .s Ret=..InsertIncItmLoc(LocId,Inci,Qty)    ;首次入库，插入库存
    .i +Ret>0  d
    ..s IL=$p(Ret,"||",2)
    ..s Ret=0
    .e  d
    ..s Ret=-60        ;保存科室库存失败
    i Ret'=0  trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 Ret            ;处理INC_ItmLoc失败
    ;
    ;处理INC_ItmLcBt库存
    s LB=$o(^INCI("LB_IB",IncIb,Inci,IL,0))
    i LB'=""  d
    .s Inclb=Inci_"||"_IL_"||"_LB
    .s Ret=..UpdateIncItmLcBt(Inclb,Qty)    ;存在该批次库存，则更新批次库存
    .s:Ret'=0 Ret=-55   ;更新批次库存失败
    e  d
    .s Incil=Inci_"||"_IL
    .s Ret=..InsertIncItmLcBt(Incil,IncIb,Qty)   ;新批次，插入批次库存
    .i +Ret>0  d
    ..s Inclb=Ret
    ..s Ret=0
    .e  d
    ..s Ret=-61   ;保存批次库存失败
    i Ret'=0 trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 Ret
    ;
    ;处理DHC_LocDailyTotal库存
    s Ret=..UpdateMainByID(Inci,Qty,LocId)
    i +Ret>0  d
    .s DayId=Ret
    .s Ret=0
    i Ret'=0 trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 -56  ;更新dhc库存失败
    ;
    ;处理DHC_LocBtDailyTotal库存
    s Ret=..UpdateDayBT(Inclb,Qty,DayId)
    i +Ret>0  d
    .s DayBtId=Ret
    .s Ret=0
    i Ret'=0 trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:Ret'=0 -57   ;更新dhc批次库存失败 
    s Ret=..UpdateDhcIncItmLcBt(Inclb,"Y","Y")    ;更新状态为活动
    i +Ret<=0  trollback  d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q:+Ret<=0   ;更新批次库存项活动状态失败
    tcommit
    d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q Inclb
ErrUpdateStockForImp
    d ErrorRecord^DHCSTERROR("DHCSTPARAMER", $lts($lb(Inci, LocId, IncIb, Qty), "~"), $ze)
    return "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Creator:zdm
/// CreatDate:2012-01-05
/// Description:更新占用库存
/// InPut：Inc_ItmLcBt表rowid,库存量
/// Table:Inc_ItmLcBt,Inc_ItmLoc
/// OutPut:
/// Return:0,成功
/// -1：传入参数为空
/// -2:传入参数不正确
/// -3:不存在需要更新的批次
/// -4 ;加锁失败
ClassMethod UpdateDirtyQty(Inclb, Qty) As %Library.String
{
    q:Inclb="" -1   ;传入参数为空
    s Qty=+Qty
    s Inci=+Inclb
    s IL=$p(Inclb,"||",2)
    s LB=$p(Inclb,"||",3)
    q:Inci="" -2     ;传入参数不正确
    q:IL="" -2
    q:LB="" -2
    q:'$d(^INCI(Inci,"IL",IL,"LB",LB)) -3    ;不存在需要更新的批次
    s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
    ;对目标库存加锁
    s LockName="UPDATESTOCK:"_LocId_"||"_Inci
    s ret=##class(web.DHCST.Common.AppCommon).Lock(LockName)  
    q:ret'=0 -4 ;加锁失败
    ;
    tstart
    s $ZT="ErrUpdateDirtyQty"                       ;增加错误处理
    ;处理批次库存占用数量
    s DirtyQty=+$p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)
    s EDityQty=DirtyQty+Qty
    i EDityQty<0  d   
    .s EDityQty=0
    s $p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)=EDityQty
    ;处理科室库存占用数量
    s DirtyQty=+$p(^INCI(Inci,"IL",IL),"^",9)
    s EDityQty=DirtyQty+Qty
    i EDityQty<0  d   
    .s EDityQty=0
    s $p(^INCI(Inci,"IL",IL),"^",9)=EDityQty
    tcommit
    d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q 0
ErrUpdateDirtyQty
    d ErrorRecord^DHCSTERROR("DHCSTPARAMER", Inclb _ "~" _ Qty, $ze)
    return "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Creator:zdm
/// CreatDate:2012-01-05
/// Description:删除台帐及相应库存
/// InPut：业务类型(G -入库,T - 转出,K - 转入, A - 调整,R-退货,C - 消耗, D - 报损,
/// P - 住院发药,Y -住院退药, F - 门诊发药,H - 门诊退药,S - 非正常门诊发药,Z - 非正常门诊退药)
/// Table:DHC_InTrans,DHC_LocDailyTotal,DHC_LocBtDailyTotal，Inc_ItmLcBt,Inc_ItmLoc
/// OutPut:
/// Return:0,成功：
/// -1    ;要删除的数据不存在
/// -3    ;要删除的数据批次为空，不能删除
/// -2   ;要删除的数据库存项为空，不能删除
/// -5  ;加锁失败
/// -79   ;删除台帐失败
/// -89   ;更新DHC库存失败
/// -99   ;更新DHC批次库存失败
/// -71   ;更新科室库存失败
/// -72   ;更新科室批次库存失败
/// -12   ;库存不足
/// w ##class(web.DHCST.Common.StockHandle).DelIntrs("A","100000011||1")
ClassMethod DelIntrs(type, point) As %Library.String
{
    ;Delete DHC_InTrans And BegQTy,EndQty of the date after fromdate
    s trid=$o(^DHCINTR(0,"TypePointer",type,point,"")) 
    q:trid="" -1    ;要删除的数据不存在
    q:($d(^DHCINTR(trid))=0)!($d(^DHCINTR(trid))=10) -1
    s inclb=$p(^DHCINTR(trid),"^",7)        
    q:inclb="" -3     ;要删除的数据批次为空，不能删除
    s tdate=$p(^DHCINTR(trid),"^",2)
    s uomdr=$p(^DHCINTR(trid),"^",10)
    s qty=-$p(^DHCINTR(trid),"^",6)
    q:($d(^INCI(+inclb,1))=0)!($d(^INCI(+inclb,1))=10) -2   ;要删除的数据库存项为空，不能删除
    s buomdr=$p(^INCI(+inclb,1),"^",10)
    s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
    s bqty=qty*fac
    s locdr=$p($g(^INCI($p(inclb,"||"),"IL",$p(inclb,"||",2))),"^")
    ;对目标库存加锁
    s LockName="UPDATESTOCK:"_locdr_"||"_+inclb
    s ret=##class(web.DHCST.Common.AppCommon).Lock(LockName)  
    q:ret'=0 -5 ;加锁失败
    s EQty=0
    s TmpDate=+$h+1
    s StkDate=$o(^DHCBTLOCTOT(0,"LocBtDate",locdr,inclb,TmpDate),-1) 
    i StkDate'=""  d
    .s TmpDayId=$o(^DHCBTLOCTOT(0,"LocBtDate",locdr,inclb,StkDate,""))      ;lastest bt DayId
    .s Chl=$o(^DHCBTLOCTOT(0,"LocBtDate",locdr,inclb,StkDate,TmpDayId,""))     ;lastest bt ChildSub 
    .s EQty=$p(^DHCBTLOCTOT(TmpDayId,"I",Chl),"^",3)
    q:(bqty+EQty<0)&(bqty<0) -12  
    tstart
    s $ZT="ErrDelIntrs"                     ;增加错误处理
    s ret=..DeleteTrans(trid)
    i ret'=0 trollback  d ULK3
    q:ret'=0 -79   ;删除台帐失败
    s ret=..UpdDayFdate(+inclb,bqty,locdr,tdate)
    i ret'=0 trollback  d ULK3
    q:ret'=0 -89   ;更新DHC库存失败
    s ret=..UpdDaybtFdate(inclb,bqty,tdate)
    i ret'=0 trollback  d ULK3
    q:ret'=0 -99   ;更新DHC批次库存失败
    s incil=+inclb_"||"_$p(inclb,"||",2)
    s ret=..UpdateIncItmLoc(incil,bqty)
    i ret'=0 trollback  d ULK3
    q:ret'=0 -71   ;更新科室库存失败
    s ret=..UpdateIncItmLcBt(inclb,bqty)
    i ret'=0 trollback  d ULK3
    q:ret'=0 -72    ;更新科室批次库存失败
    tcommit
    d ULK3
    q 0
    
ULK3
    d ##class(web.DHCST.Common.AppCommon).UnLock(LockName)
    q
ErrDelIntrs
    d ErrorRecord^DHCSTERROR("DHCSTPARAMER", $lts($lb(type, point), "~"), $ze)
    return "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Creator:zdm
/// CreatDate:2012-07-04
/// Description:删除某台帐
/// InPut：台帐表id
/// Table:DHC_InTrans
/// OutPut:
/// Return:0,成功：
/// -1    ;传入的参数为空
/// -2   ;删除失败
ClassMethod DeleteTrans(rid As %String) As %String [ Private ]
{
    q:rid="" -1
    s Err=0
    &sql(delete from DHC_InTrans Where intr_rowid=:rid)
    ;zdm,2009-04-08,增加错误记录
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("DeleteTrans:DHC_InTrans","rowid:"_rid,SQLCODE_":"_%msg) 
    .s Err=-2
    q Err
}

/// Creator:zdm
/// CreatDate:2012-07-04
/// Description:更新DHC科室库存
/// InPut：库存项id,更新数量,科室id,日期
/// Table:DHC_LocDailyTotal
/// OutPut:
/// Return:0,成功：
/// -1    ;传入的参数为空
ClassMethod UpdDayFdate(inci, qty, locdr, fda) As %String [ Private ]
{
    q:(inci="")!(qty="")!(locdr="")!(fda="") -1
    s tda=+$h
    f date=fda:1:tda d
    .s dayid=""
    .s dayid=$o(^DHCLOCTOT(0,"Date",date,locdr,inci,"")) 
    .q:dayid=""
    .s bqty=$p(^DHCLOCTOT(dayid),"^",3)
    .s eqty=$p(^DHCLOCTOT(dayid),"^",4)
    .i date'=fda s bqty=bqty+qty
    .s eqty=eqty+qty
    .
    .s $p(^DHCLOCTOT(dayid),"^",3)=bqty
    .s $p(^DHCLOCTOT(dayid),"^",4)=eqty
    .
    q 0
}

/// Creator:zdm
/// CreatDate:2012-07-04
/// Description:更新DHC批次库存
/// InPut：批次id,更新数量,日期
/// Table:DHC_LocBtDailyTotal
/// OutPut:
/// Return:0,成功：
/// -1    ;传入的参数为空
ClassMethod UpdDaybtFdate(inclb, qty, fda) As %String [ Private ]
{
    q:(inclb="")!(qty="")!(fda="") -1
    ;
    s tda=+$h
    f date=fda:1:tda d
    .s dayid="",btsub=""
    .s dayid=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,date,"")) 
    .q:dayid=""
    .s btsub=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,date,dayid,"")) 
    .q:btsub=""
    .s daybt=dayid_"||"_btsub
    .s bqty=$p(^DHCBTLOCTOT(dayid,"I",btsub),"^",2)
    .s eqty=$p(^DHCBTLOCTOT(dayid,"I",btsub),"^",3)
    .i date'=fda s bqty=bqty+qty
    .s eqty=eqty+qty
    .
    .s $p(^DHCBTLOCTOT(dayid,"I",btsub),"^",2)=bqty
    .s $p(^DHCBTLOCTOT(dayid,"I",btsub),"^",3)=eqty
    .
    q 0
}

/// Creator:zdm
/// CreatDate:2012-07-04
/// Description:更新DHC_LocDailyTotal
/// InPut：库存项id,库存量，科室id
/// Table:DHC_LocDailyTotal
/// OutPut:
/// Return:rowid，成功；
/// -16    ;传入的参数为空
/// -17   ;传入的参数不正确
/// -18   ;更新库存失败
ClassMethod UpdateMainByID(Inci As %String, Qty As %String, LocId As %String) As %String [ Private ]
{
    q:Inci="" -16    ;传入的参数为空
    q:Qty="" -16
    q:LocId="" -16
    q:'$d(^INCI(Inci)) -17   ;传入的参数不正确
    q:'$d(^CTLOC(LocId)) -17
    s StkDate=+$h
    s TmpDate=+$h+1
    s EQty=0
    s StkQty=Qty
    s LastDate=$o(^DHCLOCTOT(0,"LOCITMDATE",LocId,Inci,TmpDate),-1)    ;最后一次库存记录日期 
    i LastDate'=""  d
    .s DayId=$o(^DHCLOCTOT(0,"LOCITMDATE",LocId,Inci,LastDate,""))
    .s EQty=$p(^DHCLOCTOT(DayId),"^",4)
    .s StkQty=EQty+Qty
    q:(StkQty<0)&(Qty<0) -19   ///yunhaibao,加库存不用此判断,20150502
    //q:StkQty<0 -19
    s Err=0
    i LastDate=+$h  d
    .s $p(^DHCLOCTOT(DayId),"^",4)=StkQty 
    .s Rowid=DayId  
    e  d
    .&sql(Insert into DHC_LocDailyTotal(Day_Itm_DR,Day_Loc_DR,Day_QtyBeg,Day_QtyEnd,
     Day_Date) Values(:Inci,:LocId,:EQty,:StkQty,:StkDate))
    .i SQLCODE'=0  d
    ..s ret=$$ErrorRecord^DHCSTERROR("UpdateMainByID:DHC_LocDailyTotal",Inci_","_LocId,SQLCODE_":"_%msg)
    ..s Err=-18   ;更新库存失败
    .e  d
    ..s Rowid=$p(%ROWID,$c(1))
    .
    q:Err'=0 Err
    q Rowid
}

/// Creator:zdm
/// CreatDate:2011-12-30
/// Description:更新DHC_LocBtDailyTotal
/// InPut：dhc_locbtdailytotal表rowid,库存量
/// Table:DHC_LocBtDailyTotal
/// OutPut:
/// Return:rowid，成功；
/// -11  ;传入的参数为空
/// -12    ;更新批次库存失败
ClassMethod UpdateDayBT(Inclb As %String, Qty As %String, DayId As %String) As %String [ Private ]
{
    q:Inclb="" -11  ;传入的参数为空
    q:DayId="" -11
    s LocId=$p(^DHCLOCTOT(DayId),"^",2)
    s TmpDate=+$h+1
    s EQty=0
    s Err=0
    ;最后一次批次库存记录日期
    s StkDate=$o(^DHCBTLOCTOT(0,"LocBtDate",LocId,Inclb,TmpDate),-1) 
    i StkDate'=""  d
    .s TmpDayId=$o(^DHCBTLOCTOT(0,"LocBtDate",LocId,Inclb,StkDate,""))      ;lastest bt DayId
    .s Chl=$o(^DHCBTLOCTOT(0,"LocBtDate",LocId,Inclb,StkDate,TmpDayId,""))     ;lastest bt ChildSub 
    .s EQty=$p(^DHCBTLOCTOT(TmpDayId,"I",Chl),"^",3)
    q:(Qty+EQty<0)&(Qty<0) -12   ///yunhaibao20150502,加库存不用此判断 
    i StkDate=+$h  d
    .s $p(^DHCBTLOCTOT(DayId,"I",Chl),"^",3)=Qty+EQty
    .s Rowid=DayId_"||"_Chl
    e  d
    .s StkDate=+$h
    .s StkQty=Qty+EQty
    .s MaxSub=+$o(^DHCBTLOCTOT(DayId,"I",""),-1)+1
    .&sql(Insert into DHC_LocBTDailyTotal(DayBT_ParRef,DayBT_Bat_DR,DayBT_QtyBeg,
      DayBT_QtyEnd,DayBT_Childsub,DayBT_Date,DayBT_Loc_DR) values (:DayId,:Inclb,:EQty,:StkQty,
      :MaxSub,:StkDate,:LocId))
    .i SQLCODE'=0  d
    ..s ret=$$ErrorRecord^DHCSTERROR("UpdateDayBT:DHC_LocBTDailyTotal",DayId,SQLCODE_":"_%msg)
    ..s Err=-12    ;更新批次库存失败
    .e  d
    ..s Rowid=$p(%ROWID,$c(1)) 
    ;  
    q:Err'=0 Err   
    q Rowid
}

/// Creator:zdm
/// CreatDate:2011-12-30
/// Description:插入DHC_Intrans
/// InPut：类型^业务处理号^批次rowid^数量^单位id^单价^操作人id^业务指针^进价^进价金额^售价金额
/// Table:DHC_InTrans
/// OutPut:
/// Return:rowid，成功；
/// -1   ;基本单位不能为空
/// -2   ;插入台帐失败
ClassMethod IntoTrans(lstData As %String) As %String
{
    s Type=$p(lstData,"^",1)            ;INTR_Type
    s TrNo=$p(lstData,"^",2)            ;INTR_No
    s Inclb=$p(lstData,"^",3)           ;INCLBRowID
    s Inci=+Inclb
    s Qty=+$p(lstData,"^",4)            ;INTR_Qty
    s UomId=$p(lstData,"^",5)           ;Itm_UOM DESC
    s Sp=+$p(lstData,"^",6)             ;sp
    s UserId=$p(lstData,"^",7)          ;UserRowID
    s Pointer=$p(lstData,"^",8)         ;pointer
    s Rp=$p(lstData,"^",9)    ;进价
    s RpAmt=$p(lstData,"^",10) 
    s SpAmt=$p(lstData,"^",11)
    s LocId=$p(^INCI(Inci,"IL",$p(Inclb,"||",2)),"^",1)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s BUomId=$p(^INCI(Inci,1),"^",10)
    s StkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,+$h)    ;结余库存(总)
    s LbQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBUom(Inclb,BUomId,+$h)    ;结余库存(批次)
    s TrDate=+$h
    s TrTime=$p($h,",",2)
    ;
    s Err=0
    &sql(Insert into DHC_InTrans(INTR_Amount,INTR_AveragePrice,INTR_CTUOM_DR,
    INTR_Date,INTR_INCI_DR,INTR_INCLB_DR,INTR_No,INTR_Pointer,INTR_Qty,INTR_SSUSR_DR,
    INTR_Time,INTR_Type,INTR_UpdBalFlag,INTR_UpdFlag,INTR_Rp,INTR_RpAmount,INTR_StkQty,
    INTR_LbQty) values (:SpAmt,:Sp,:UomId,:TrDate,:Inci,:Inclb,:TrNo,:Pointer,:Qty,
    :UserId,:TrTime,:Type,'N','N',:Rp,:RpAmt,:StkQty,:LbQty))
    i SQLCODE'=0 d
    .s ret=$$ErrorRecord^DHCSTERROR("IntoTrans:DHC_InTrans","pointer:"_Pointer,SQLCODE_":"_%msg)
    .s Err=-2   ;插入台帐失败
    q:Err'=0 Err
    
    /* 对齐在途数 */
    i (Qty < 0)&&($LB("R", "T", "A", "D")[($LB(Type))) s Err=..UpdateReservedQty(Inclb)    
    q:Err'=0 -3 ;更新在途数失败

    q $p(%ROWID,$c(1))
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:更新inc_itmloc库存记录
/// InPut：int_itmloc表rowid，增加的数量
/// Table:Inc_ItmLoc
/// OutPut:
/// Return:0,成功；
/// -1  ;更新科室库存的参数为空
/// -2  ;更新科室库存的参数不正确
/// -3  ;该科室库存不存在
ClassMethod UpdateIncItmLoc(incil, qty) As %Library.String [ Private ]
{
    q:incil="" -1  ;更新科室库存的参数为空
    s inci=+incil
    s chl=$p(incil,"||",2)
    q:chl="" -2     ;更新科室库存的参数不正确
    q:'$d(^INCI(inci,"IL",chl)) -3  ;该科室库存不存在
    ;
    s logqty=$p(^INCI(inci,"IL",chl),"^",3)
    I logqty+qty<0 s qty=-logqty   //如果为负,直接给0  LiangQiang 2014-04-24
    s $p(^INCI(inci,"IL",chl),"^",3)=logqty+qty
    ;
    q 0
}

/// Creator:zdm
/// CreatDate:2011-12-30
/// Description:插入inc_itmloc库存记录
/// InPut：科室rowid，库存项rowid，增加的数量
/// Table:Inc_ItmLoc
/// OutPut:
/// Return:成功；Inc_ItmLoc表rowid
/// -6   ;参数为空
/// -7      ;库存项不存在
/// -8      ;科室不存在
/// -9   ;更新库存失败
ClassMethod InsertIncItmLoc(locdr, inci, qty) As %Library.String [ Private ]
{
     
    q:locdr="" -6   ;参数为空
    q:inci="" -6
    q:'$d(^INCI(inci)) -7       ;库存项不存在
    q:'$d(^CTLOC(locdr)) -8     ;科室不存在
    ;
    s Err=0
    &sql(insert into inc_itmloc(INCIL_INCI_ParRef,INCIL_CTLOC_DR,INCIL_LogQty) 
    values (:inci,:locdr,:qty))
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("CHSSWeb.DrugStorage.StockHandle.UpdateIncItmLoc","inci:"_inci_";Loc:"_locdr,SQLCODE_":"_%msg)
    .s Err=-9   ;更新库存失败
    q:Err'=0 Err
    q $p(%ROWID,$c(1))
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:插入inc_itmlcbt库存记录
/// InPut：inc_itmloc表rowid，inc_itmbat表rowid，增加的数量
/// Table:Inc_ItmLcBt
/// OutPut:
/// Return:成功；Inc_ItmLcBt表rowid
/// -25   ;参数为空
/// -26  ;不存在该科室库存记录
/// -27  ;不存在该批次记录
/// -28  ;更新批次库存失败
ClassMethod InsertIncItmLcBt(Incil, Incib, Qty) As %Library.String [ Private ]
{
    q:Incil="" -25   ;参数为空
    q:Incib="" -25
    s Inci=+Incil
    s IL=$p(Incil,"||",2)
    q:'$d(^INCI(Inci,"IL",IL)) -26  ;不存在该科室库存记录
    q:'$d(^INCI(Inci,"IB",$p(Incib,"||",2))) -27  ;不存在该批次记录
    ;
    s Err=0
    &sql(insert into inc_itmlcbt(INCLB_INCIL_ParRef,INCLB_PhyQty,INCLB_INCIB_DR) 
    values (:Incil,:Qty,:Incib))
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("InsertIncItmLcBt:inc_itmlcbt","incil:"_Incil_";Incib:"_Incib,SQLCODE_":"_%msg)
    .s Err=-28  ;更新批次库存失败
    q:Err'=0 Err
    q $p(%ROWID,$c(1))
}

/// Creator:zdm
/// CreatDate:2011-12-30
/// Description:更新inc_itmlcbt库存记录
/// InPut：inc_itmlcbt表rowid，增加的数量
/// Table:Inc_ItmLcBt
/// OutPut:
/// Return:0,成功；
/// -21  ;参数为空
/// -22  ;参数不正确
/// -24  ;不存在该批次库存记录
ClassMethod UpdateIncItmLcBt(Inclb, Qty) As %Library.String
{
    q:Inclb="" -21  ;参数为空
    s Inci=+Inclb
    s IL=$p(Inclb,"||",2)
    s Sub=$p(Inclb,"||",3)
    q:IL="" -22   ;参数不正确
    q:Sub="" -22
    q:'$d(^INCI(Inci,"IL",IL,"LB",Sub)) -24  ;不存在该批次库存记录
    ;
    s PhyQty=$p(^INCI(Inci,"IL",IL,"LB",Sub),"^",2)
    I PhyQty+Qty<0 s Qty=-PhyQty //如果为负,直接给0  LiangQiang 2014-04-24
    s $p(^INCI(Inci,"IL",IL,"LB",Sub),"^",2)=PhyQty+Qty
    q 0
}

/// Creator:zdm
/// CreatDate:2013-01-15
/// Description:更新批次库存项活动状态
/// InPut：inc_itmlcbt批次rowid,活动状态(Y:活动;N:不活动)
/// Table:DHC_IncItmLcBt
/// OutPut:
/// Return:成功；DHC_IncItmLcBt表rowid
/// Others:本类和web.dhcst.instktk.cls调用
/// Modify:hulihua 2017-12-08 库存激活改用INCLB_STKActive，原字段只控制开医嘱！
ClassMethod UpdateDhcIncItmLcBt(Inclb As %String, StkActive As %String, Active As %String) As %Library.String
{
    q:Inclb="" -61   ;参数为空
    ;
    s Err=0
    s Rowid=$o(^DHCINCLB(0,"LB",Inclb,0))
    i Rowid=""  d
    .&sql(insert into DHC_IncItmLcBt(INCLB_LB_DR,INCLB_STKActive,INCLB_Active) 
    values (:Inclb,:StkActive,:Active))
    .i SQLCODE'=0  d
    ..s ret=$$ErrorRecord^DHCSTERROR("web.DHCST.Common.StockHandle.UpdateDhcIncItmLcBt","inclb:"_Inclb,SQLCODE_":"_%msg)
    ..s Err=-91   ;更新批次库存活动状态失败
    .e  d
    ..s Rowid=$p(%ROWID,$c(1))
    e  d
    .s:$p(^DHCINCLB(Rowid),"^",6)'="" Active=$p(^DHCINCLB(Rowid),"^",2)
    .q:($p(^DHCINCLB(Rowid),"^",2)=Active)&&($p(^DHCINCLB(Rowid),"^",4)=StkActive)   ;状态一致的话不需要更新
    .&sql(update DHC_IncItmLcBt set INCLB_STKActive=:StkActive,INCLB_Active=:Active where INCLB_RowId=:Rowid)
    .i SQLCODE'=0  d
    ..s ret=$$ErrorRecord^DHCSTERROR("web.DHCST.Common.StockHandle.UpdateDhcIncItmLcBt","inclb:"_Inclb,SQLCODE_":"_%msg)
    ..s Err=-91   ;更新批次库存活动状态失败
    .
    q:Err'=0 Err
    q Rowid
}

/// Descript  : 对齐在途数(避免在途数大于库存数)
/// Creator   : yangsj
/// CreateDate: 2021-12-20
/// Table     : 
/// Input     : inclb 科室库存批次项
/// Return    : 0 成功; 其他 失败
/// Debugger  : w ##Class(web.DHCST.Common.StockHandle).UpdateReservedQty("3870||2||1")
ClassMethod UpdateReservedQty(Inclb)
{
    s inci = +Inclb
    s il = $p(Inclb, "||", 2)
    s loc = $P(^INCI(inci, "IL", il), "^", 1)
    s incil = inci_"||"_il
    s qtyStr = ##Class(web.DHCSTSTKQTY).GetIncilQtyList(incil,"N")
    s stockQty = $P(qtyStr, "^", 1)
    s ReservedQty = $P(qtyStr, "^", 3)
    q:(stockQty >= ReservedQty) 0
    s difQty = ReservedQty - stockQty
    
    s hospId = $P(^CTLOC(loc), "^", 22)
    s ruleFlag = ##Class(web.DHCSTCOMMPARA).GetRpRule(hospId)
    s ret = 0
    if (ruleFlag = 3) {  //批次价
        s dhcInclb = $O(^DHCINCLB(0,"LB",Inclb, ""))
        i (dhcInclb = "") tro  q 0
        s dhcResQty = $P(^DHCINCLB(dhcInclb), "^", 3)
        s typeStr = "1^5"
        s typeLen = $l(typeStr, "^")
        for i = 1:1:typeLen {
            q:(ret '= 0)||(difQty <= 0)||(dhcResQty <= 0)
            s type = $p(typeStr, "^", i)
            s date = ""
            for {  
                s date = $o(^DHCSTINCRQDi("IncilFlagTypeDate", incil, "N", type, date))
                q:(date = "")||(ret '= 0)||(difQty <= 0)||(dhcResQty <= 0)
                s iftdId=""
                for  {
                    s iftdId = $o(^DHCSTINCRQDi("IncilFlagTypeDate", incil, "N", type, date, iftdId)) 
                    q:(iftdId = "")||(ret '= 0)||(difQty <= 0)||(dhcResQty <= 0)
                    s iftdIdData=$g(^DHCSTINCRQD(iftdId))
                    s tmpInclb = $p(iftdIdData,"^",4)
                    continue:(tmpInclb '= Inclb)
                    s qty = $p(iftdIdData, "^", 3)
                    continue:(+qty <= 0)
                    s dhcResQty = dhcResQty - qty
                    s difQty = difQty - qty
                    i (dhcResQty < 0) s dhcResQty = 0
                    s $P(^DHCINCLB(dhcInclb), "^", 3) = dhcResQty
                    &SQL(
                        UPDATE 
                            SQLUSER.DHC_IncReservedQtyDetail 
                        SET 
                            INCRQD_ClrFlag = 'Y' 
                        WHERE 
                            INCRQD_RowID = :iftdId
                    )
                    s ret = SQLCODE
                }
            }
        }
    }
    else{ //统一价
        s typeStr = "1^5"
        s typeLen = $l(typeStr, "^")
        for i = 1:1:typeLen {
            q:(ret '= 0)||(difQty <= 0)||(ReservedQty <= 0)
            s type = $p(typeStr, "^", i)
            s date = ""
            for {  
                s date = $o(^DHCSTINCRQDi("IncilFlagTypeDate", incil, "N", type, date))
                q:(date = "")||(ret '= 0)||(difQty <= 0)||(ReservedQty <= 0)
                s iftdId=""
                for  {
                    s iftdId = $o(^DHCSTINCRQDi("IncilFlagTypeDate", incil, "N", type, date, iftdId)) 
                    q:(iftdId = "")||(ret '= 0)||(difQty <= 0)||(ReservedQty <= 0)
                    s iftdIdData=$g(^DHCSTINCRQD(iftdId))
                    s qty = $p(iftdIdData, "^", 3)
                    continue:(+qty <= 0)
                    s ReservedQty = ReservedQty - qty
                    s difQty = difQty - qty
                    i (ReservedQty < 0) s ReservedQty = 0
                    s $p(^INCI(inci, "IL", il), "^", 10) = ReservedQty
                    &SQL(
                        UPDATE 
                            SQLUSER.DHC_IncReservedQtyDetail 
                        SET 
                            INCRQD_ClrFlag = 'Y' 
                        WHERE 
                            INCRQD_RowID = :iftdId
                    )
                    s ret = SQLCODE
                }
            }
        }
    }
    q ret
}

/// Description：初始化科室库存和批次库存表记录(初始化前一天所有批次)
/// Author:      zhaoxinlong 2022-03-08
/// Input:       startDate --追加开始日期 , endDate --追加结束日期  flag --(1 (初始化时使用)所有批次，0 (后期任务)仅库存大于0)
/// Output:      0  -- 成功
/// w ##class(web.DHCST.Common.StockHandle).InitBTDaily("2022-02-25","2022-02-25", "1")
ClassMethod InitBTDaily(startDate, endDate, flag = "0") As %String
{
    k ^||TMP("PHA", $ClassName(), "InitBTDaily")
    q:(startDate = "")||(endDate = "") ""
    s startDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
    s endDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
    s count = 0

    s err = 0
    for date = startDate :1 :endDate {
        s lastDate = date - 1
        s inci = 0
        for {
            s inci = $o(^INCI(inci)) q:(inci = "")
            continue:(+inci = 0)
            s incsc = $p($g(^INCI(inci, 2)), "^", 2)
            continue:(+incsc = 0)
            s stkType = $p($g(^INC("SC", incsc)), "^", 3)
            continue:(stkType '= "G")
            s ilSub = 0
            for {
                s ilSub = $o(^INCI(inci, "IL", ilSub))
                q:(ilSub = "")
                s ilDataFlag = $d(^INCI(inci, "IL", ilSub))
                continue:(ilDataFlag = 10)||(ilDataFlag = 0)
                s loc = $p(^INCI(inci, "IL", ilSub), "^", 1)
                s lastQty = ##class(web.DHCST.Common.DrugStkCommon).IL(inci, loc, lastDate)
                continue:(lastQty '> 0)&&(flag = 0)
                /* 不需要考虑失败, 按科室库存项独立处理 */
                s ret = ..AddDHCLocDayRecord(inci, loc, date, flag)
                if (ret '= 0){
                    s ^||TMP("PHA", $ClassName(), "InitBTDaily", inci _ "||" _ ilSub) = ret
                }
                s count = count + 1
            }   
        }
    }
    
    q err
}

/// Description:追加科室库存和批次库存表记录
///             此方法只能追加历史记录, 不能应用于当前库存的处理
/// Creator:    zhaoxinlong  
/// CreateDate: 2022-03-08 
/// Table:      DHC_LocDailyTotal DHC_LocBTDailyTotal
/// Input:      inci --需要处理的库存项，date --增加日期 ，qtyFlag --(1 所有批次，0 仅库存大于0)
/// Return:     0 --成功
/// w ##class(web.DHCST.Common.StockHandle).AddDHCLocDayRecord(631, 246, "2022-03-07")
ClassMethod AddDHCLocDayRecord(inci, loc, date, qtyFlag = "0") As %String
{
    s $zt = "AddDHCLocDayRecordErr"
    s err = 0
    q:(inci = "")||(loc = "")||(date= "") "-1^入参为空"
    s qty = 0
    s lockName = "UPDATESTOCK:" _ loc _ "||" _ inci
    s ret = ##class(web.DHCST.Common.AppCommon).Lock(lockName)  
    q:(ret '= 0) "-1^加锁失败"
    
    ts
    
    s dayId = $o(^DHCLOCTOT(0,"LOCITMDATE", loc, inci, date, 0))
    if (+dayId = 0) {
        s lastQty = ##class(web.DHCST.Common.DrugStkCommon).IL(inci, loc, date)
        &SQL(
            Insert into DHC_LocDailyTotal(Day_Itm_DR, Day_Loc_DR, Day_QtyBeg, Day_QtyEnd, Day_Date) 
            Values(:inci, :loc, :lastQty, :lastQty, :date)
        )
        if (SQLCODE '= 0){
            d UnLock
            q "-1^更新DHC库存失败"
        }else {
            s dayId = %ROWID    
        }
    }
    
    s ilSub = $o(^INCI("IL_LOC", loc, inci, 0))
    if (+ilSub = 0 ) {
        d UnLock
        q "-1^科室库存项不存在"
    } 
      
    s lbSub = 0
    for {
        s lbSub = $o(^INCI(inci, "IL", ilSub, "LB", lbSub)) q:(lbSub = "")
        q:(+err '= 0)
        s inclb = inci _"||"_ ilSub _"||"_ lbSub
        continue:$d(^DHCBTLOCTOT(0,"LocBtDate", loc, inclb, date))
        s inclbQty = ##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb, date)
        continue:(inclbQty '> 0)&&(qtyFlag = 0)
        s maxSub = +$o(^DHCBTLOCTOT(dayId, "I", ""), -1) + 1
        &SQL(
            INSERT INTO DHC_LocBTDailyTotal(DayBT_ParRef, DayBT_Bat_DR, DayBT_QtyBeg, DayBT_QtyEnd,
                                            DayBT_Childsub, DayBT_Date, DayBT_Loc_DR)
            VALUES (:dayId, :inclb, :inclbQty, :inclbQty,
                    :maxSub, :date, :loc)
        )
        if (SQLCODE '= 0) {
            d UnLock
            s err = "-1^更新DHC批次库存失败"
        }
    }
    if (err = 0) {
        tc
        d ##class(web.DHCST.Common.AppCommon).UnLock(lockName)
    }else {
        d UnLock
    }
    q err
UnLock
    tro  
    d ##class(web.DHCST.Common.AppCommon).UnLock(lockName)
    q
AddDHCLocDayRecordErr
    s $zt = ""
    if ($tl > 0) { tro }
    d ##class(web.DHCST.Common.AppCommon).UnLock(lockName)  
    q $ze
}

}
