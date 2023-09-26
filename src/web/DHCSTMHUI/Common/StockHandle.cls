Import sqluser

/// Creator:zdm
/// CreatDate:2011-12-30
/// Modify:zdm,2012-07-03
/// Description:库存及台帐处理相关方法，
/// 入库库存处理调用方法：UpdateStockForImp
/// 其它业务涉及库存处理，调用方法：UpdateStock
/// 本类中其它方法为内部方法
/// 
Class web.DHCSTMHUI.Common.StockHandle Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
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
/// -54	;更新科室库存失败
/// -55   ;更新批次库存失败
/// -56  ;更新DHC库存失败
/// -57  ;更新DHC批次库存失败
/// -58  ;更新批次库存项活动状态失败
ClassMethod UpdateStock(Inclb, Qty) As %Library.String
{
	n (Inclb,Qty)
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
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock(LockName)  
	q:ret'=0 -53 ;加锁失败
	;
	tstart
	s $ZT=..sssError()						;增加错误处理
	;处理INC_ItmLoc库存
	s Ret=..UpdateIncItmLoc(Inci_"||"_IL,Qty)
	i Ret'=0  d
	.trollback
	.d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q:Ret'=0 -54			;处理INC_ItmLoc失败
	;处理INC_ItmLcBt库存
	s Ret=..UpdateIncItmLcBt(Inclb,Qty)
	i Ret'=0 trollback  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q:Ret'=0 -55   ;更新批次库存失败
	;处理DHC_LocDailyTotal库存
	s Ret=..UpdateMainByID(Inci,Qty,LocId)
	i +Ret>0  d
	.s DayId=Ret
	.s Ret=0
	i Ret'=0 trollback  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q:Ret'=0 -56  ;更新DHC库存失败
	;处理DHC_LocBtDailyTotal库存
	s Ret=..UpdateDayBT(Inclb,Qty,DayId)
	i +Ret>0  d
	.s DayBtId=Ret
	.s Ret=0
	i Ret'=0 trollback  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q:Ret'=0 -57  ;更新DHC批次库存失败	
	s Ret=..UpdateDhcIncItmLcBt(Inclb,"Y")    ;更新状态为活动
	i +Ret<=0  trollback  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q:+Ret<=0 -58  ;更新批次库存项活动状态失败
	tcommit
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q 0
}

/// Creator:zdm
/// CreatDate:2011-12-30
/// Modify:zdm,2012-07-04
/// Description:入库库存处理
/// InPut：库存项rowid,科室rowid,批次rowid,库存量
/// Table:
/// OutPut:
/// Return:成功;inc_itmlcbt表rowid
/// -1    ;输入参数为空
/// -2  		;不存在该药品
/// -3		;不存在该科室
/// -4 	;加锁失败
/// -5    ;更新科室库存失败
/// -6    ;保存科室库存失败
/// -51   ;更新批次库存失败
/// -61   ;保存批次库存失败
/// -52  ;更新dhc库存失败
/// -62   ;更新dhc批次库存失败	
ClassMethod UpdateStockForImp(Inci As %String, LocId As %String, IncIb As %String, Qty As %String) As %Library.String
{
	n (Inci,LocId,IncIb,Qty)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	i ((Inci="")||(LocId="")||(IncIb="")) s Sc=RtnObj.Err(-1,"","入库库存处理入参为空!","",0) q RtnObj 
	i ('$d(^INCI(Inci))) s Sc=RtnObj.Err(-2,"","物资不存在!","",0) q RtnObj
	i ('$d(^CTLOC(LocId))) s Sc=RtnObj.Err(-3,"","入库科室不存在!","",0) q RtnObj
	s LockName="UPDATESTOCK:"_LocId_"||"_Inci
	;对目标库存加锁
	s ret=..sssLock(LockName)  
	i (ret'=0) s Sc=RtnObj.Err(-4,"","对"_LocId_"科室的"_Inci_"目标库存加锁失败!") q RtnObj
	tstart
	s $ZT=..sssError()						;增加错误处理
	;处理INC_ItmLoc库存
	s IncIL=""
	s IL=$o(^INCI("IL_LOC",LocId,Inci,0))
	i IL'=""  d
	.s Ret=..UpdateIncItmLoc(Inci_"||"_IL,Qty)   ;更新库存
	.s:Ret'=0 Ret=-5    ;更新科室库存失败
	e  d
	.s Ret=..InsertIncItmLoc(LocId,Inci,Qty)    ;首次入库，插入库存
	.i +Ret>0  d
	..s IL=$p(Ret,"||",2)
	..s Ret=0
	.e  d
	..s Ret=-6        ;保存科室库存失败
	i (Ret'=0) tro  d ..sssUnLock(LockName)
	i (Ret'=0) s Sc=RtnObj.Err(-5,"","对"_LocId_"科室的"_Inci_"目标库存处理失败!") q RtnObj
	;
	;处理INC_ItmLcBt库存
	s LB=$o(^INCI("LB_IB",IncIb,Inci,IL,0))
	i LB'=""  d
	.s Inclb=Inci_"||"_IL_"||"_LB
	.s Ret=..UpdateIncItmLcBt(Inclb,Qty)    ;存在该批次库存，则更新批次库存
	.s:Ret'=0 Ret=-51   ;更新批次库存失败
	e  d
	.s Incil=Inci_"||"_IL
	.s Ret=..InsertIncItmLcBt(Incil,IncIb,Qty)   ;新批次，插入批次库存
	.i +Ret>0  d
	..s Inclb=Ret
	..s Ret=0
	.e  d
	..s Ret=-61   ;保存批次库存失败
	i (Ret'=0) tro  d ..sssUnLock(LockName)
	i (Ret'=0) s Sc=RtnObj.Err(-6,"","对"_LocId_"科室的"_Inci_"批次库存处理失败!") q RtnObj
	;
	;处理DHC_LocDailyTotal库存
	s Ret=..UpdateMainByID(Inci,Qty,LocId)
	i +Ret>0  d
	.s DayId=Ret
	.s Ret=0
	i (Ret'=0) tro  d ..sssUnLock(LockName)
	i (Ret'=0) s Sc=RtnObj.Err(-7,"","对"_LocId_"科室的"_Inci_"dhc库存处理失败!") q RtnObj
	;
	;处理DHC_LocBtDailyTotal库存
	s Ret=..UpdateDayBT(Inclb,Qty,DayId)
	i +Ret>0  d
	.s DayBtId=Ret
	.s Ret=0
	i (Ret'=0) tro  d ..sssUnLock(LockName)
	i (Ret'=0) s Sc=RtnObj.Err(-8,"","对"_LocId_"科室的"_Inci_"dhc批次库存处理失败!") q RtnObj
	s Ret=..UpdateDhcIncItmLcBt(Inclb,"Y")    ;更新状态为活动
	i +Ret<=0  trollback  d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q:+Ret<=0   ;更新批次库存项活动状态失败
	i (+Ret<=0) tro  d ..sssUnLock(LockName)
	i (+Ret<=0) s Sc=RtnObj.Err(-8,"","对"_LocId_"科室的"_Inci_"批次库存项活动状态处理失败!") q RtnObj
	tcommit
	d ..sssUnLock(LockName)
	s RtnObj.rowid=Inclb
	q RtnObj
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
	n (Inclb, Qty)
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
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock(LockName)  
	q:ret'=0 -4 ;加锁失败
	;
	tstart
	s $ZT=..sssError()						;增加错误处理
	;处理批次库存占用数量
	s DirtyQty=+$p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)
	i DirtyQty+Qty<0 s Qty=-DirtyQty			;避免出现负数可用库存
	s EDityQty=DirtyQty+Qty
	s $p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)=EDityQty
	;处理科室库存占用数量
	s ILDirtyQty=+$p(^INCI(Inci,"IL",IL),"^",9)
	s EILDirtyQty=ILDirtyQty+Qty
	s $p(^INCI(Inci,"IL",IL),"^",9)=EILDirtyQty
	tcommit
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	q 0
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
/// -5 	;加锁失败
/// -79   ;删除台帐失败
/// -89   ;更新DHC库存失败
/// -99   ;更新DHC批次库存失败
/// -71   ;更新科室库存失败
/// -72   ;更新科室批次库存失败
ClassMethod DelIntrs(type, point) As %Library.String
{
	n (type,point)
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
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomdr,buomdr)
	s bqty=qty*fac
	s locdr=$p($g(^INCI($p(inclb,"||"),"IL",$p(inclb,"||",2))),"^")
	;对目标库存加锁
	s LockName="UPDATESTOCK:"_locdr_"||"_+inclb
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock(LockName)  
	q:ret'=0 -5 ;加锁失败
	;
	tstart
	s $ZT=..sssError()						;增加错误处理
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
 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
 q
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
	n (rid)
	q:rid="" -1
	s Err=0
	&sql(delete from DHC_InTrans Where intr_rowid=:rid)
	i SQLCODE'=0  d
	.s Err=-2
	q:Err<0 Err
	s AspId=$O(^ASPA(0,"TranType","YW","Trans",rid,""))
	i AspId'="" d
	.&sql(delete from DHC_ASPAmount where ASPA_ASPTran_Dr=:rid)
	.i SQLCODE'=0  d
	..s Err=-3
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
	n (inci,qty,locdr,fda)
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
	n (inclb,qty,fda)
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
	n (Inci,Qty,LocId)
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
	;
	s Err=0
	i LastDate=+$h  d
	.s $p(^DHCLOCTOT(DayId),"^",4)=StkQty 
	.s Rowid=DayId  
	e  d
	.&sql(Insert into DHC_LocDailyTotal(Day_Itm_DR,Day_Loc_DR,Day_QtyBeg,Day_QtyEnd,
		Day_Date) Values(:Inci,:LocId,:EQty,:StkQty,:StkDate))
	.i SQLCODE'=0  d
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
	n (Inclb,Qty,DayId)
	q:Inclb="" -11  ;传入的参数为空
	q:DayId="" -11
	s LocId=$p(^DHCLOCTOT(DayId),"^",2)
	s TmpDate=+$h+1
	s EQty=0
	s Err=0
	;最后一次批次库存记录日期
	s StkDate=$o(^DHCBTLOCTOT(0,"LocBtDate",LocId,Inclb,TmpDate),-1) 
	i StkDate'=""  d
	.s TmpDayId=$o(^DHCBTLOCTOT(0,"LocBtDate",LocId,Inclb,StkDate,""))  	;lastest bt DayId
	.s Chl=$o(^DHCBTLOCTOT(0,"LocBtDate",LocId,Inclb,StkDate,TmpDayId,""))     ;lastest bt ChildSub
	.s EQty=$p(^DHCBTLOCTOT(TmpDayId,"I",Chl),"^",3)
	i StkDate=+$h  d
	.s $p(^DHCBTLOCTOT(DayId,"I",Chl),"^",3)=Qty+EQty
	.s Rowid=DayId_"||"_Chl
	e  d
	.;s StkDate=+$h
	.s StkDate=$p(^DHCLOCTOT(DayId),"^",5)	;20200515取主表日期
	.s StkQty=Qty+EQty
	.s MaxSub=+$o(^DHCBTLOCTOT(DayId,"I",""),-1)+1
	.&sql(Insert into DHC_LocBTDailyTotal(DayBT_ParRef,DayBT_Bat_DR,DayBT_QtyBeg,
	DayBT_QtyEnd,DayBT_Childsub,DayBT_Date,DayBT_Loc_DR) values (:DayId,:Inclb,:EQty,:StkQty,
	:MaxSub,:StkDate,:LocId))
	.i SQLCODE'=0  d
	..s Err=-12    ;更新批次库存失败
	.e  d
	..s Rowid=$p(%ROWID,$c(1))
	
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
ClassMethod IntoTrans(lstData As %String) As web.DHCSTMHUI.RtnObj
{
	n (lstData)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()

	s Type=$p(lstData,"^",1)       		;INTR_Type
	s TrNo=$p(lstData,"^",2)       		;INTR_No
	s Inclb=$p(lstData,"^",3)      		;INCLBRowID
	s Inci=+Inclb
	s Qty=+$p(lstData,"^",4)        		;INTR_Qty
	s UomId=$p(lstData,"^",5)        	;Itm_UOM DESC
	s Sp=+$p(lstData,"^",6)    			;sp
	s UserId=$p(lstData,"^",7)      	;UserRowID
	s Pointer=$p(lstData,"^",8)      	;pointer
	s Rp=$p(lstData,"^",9)    ;进价
	s RpAmt=$p(lstData,"^",10) 
	s SpAmt=$p(lstData,"^",11)
	s PrtId=$p(lstData,"^",12)
	s LocId=$p(^INCI(Inci,"IL",$p(Inclb,"||",2)),"^",1)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,+$h)    ;结余库存(总)
	s LbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom(Inclb,BUomId,+$h)    ;结余库存(批次)
	s TrDate=+$h
	s TrTime=$p($h,",",2)
	
	s Err=0
	&sql(Insert into DHC_InTrans(INTR_Amount,INTR_AveragePrice,INTR_CTUOM_DR,
	INTR_Date,INTR_INCI_DR,INTR_INCLB_DR,INTR_No,INTR_Pointer,INTR_Qty,INTR_SSUSR_DR,
	INTR_Time,INTR_Type,INTR_UpdBalFlag,INTR_UpdFlag,INTR_Rp,INTR_RpAmount,INTR_StkQty,
	INTR_LbQty,INTR_PrtDR) values (:SpAmt,:Sp,:UomId,:TrDate,:Inci,:Inclb,:TrNo,:Pointer,:Qty,
	:UserId,:TrTime,:Type,'N','N',:Rp,:RpAmt,:StkQty,:LbQty,:PrtId))
	i SQLCODE'=0 d
	.s Sc=RtnObj.Err(-1,"","插入台帐失败!") 
	i RtnObj.success'=0  q RtnObj
	s intrID=$p(%ROWID,$c(1)) 
	s AspId=##class(web.DHCSTMHUI.Common.AspAmount).CreateAdjAmount(lstData,intrID)
	i AspId<0 d
	.s Sc=RtnObj.Err(-6,"","生成调价数据失败!") 
	i RtnObj.success'=0  q RtnObj
	
	////更新业务最后日期
	d ##class(web.DHCSTMHUI.Common.AutoStopUse).Update(Inci,Pointer,Type)
	s RtnObj.rowid=$p(%ROWID,$c(1))
	q RtnObj
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
	n (incil,qty)
	q:incil="" -1  ;更新科室库存的参数为空
	s inci=+incil
	s chl=$p(incil,"||",2)
	q:chl="" -2     ;更新科室库存的参数不正确
	q:'$d(^INCI(inci,"IL",chl)) -3  ;该科室库存不存在
	
	s logqty=$p(^INCI(inci,"IL",chl),"^",3)
	s $p(^INCI(inci,"IL",chl),"^",3)=logqty+qty
	
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
/// -7   	;库存项不存在
/// -8  	;科室不存在
/// -9   ;更新库存失败
ClassMethod InsertIncItmLoc(locdr, inci, qty) As %Library.String [ Private ]
{
	n (locdr,inci,qty)
	q:locdr="" -6   ;参数为空
	q:inci="" -6
	q:'$d(^INCI(inci)) -7   	;库存项不存在
	q:'$d(^CTLOC(locdr)) -8  	;科室不存在
	
	s Err=0
	&sql(insert into inc_itmloc(INCIL_INCI_ParRef,INCIL_CTLOC_DR,INCIL_LogQty) values (:inci,:locdr,:qty))
	i SQLCODE'=0  d
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
ClassMethod InsertIncItmLcBt(Incil, Incib, Qty) As %Library.String
{
	n (Incil,Incib,Qty)
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
	n (Inclb,Qty)
	q:Inclb="" -21  ;参数为空
	s Inci=+Inclb
	s IL=$p(Inclb,"||",2)
	s Sub=$p(Inclb,"||",3)
	q:IL="" -22   ;参数不正确
	q:Sub="" -22
	q:'$d(^INCI(Inci,"IL",IL,"LB",Sub)) -24  ;不存在该批次库存记录
	;
	s PhyQty=$p(^INCI(Inci,"IL",IL,"LB",Sub),"^",2)
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
/// Others:本类和web.DHCSTMHUI.instktk.cls调用
ClassMethod UpdateDhcIncItmLcBt(Inclb As %String, Active As %String) As %Library.String
{
	n (Inclb,Active)
	q:Inclb="" -61   ;参数为空
	;
	s Err=0
	s Rowid=$o(^DHCINCLB(0,"LB",Inclb,0))
	i Rowid=""  d
	.&sql(insert into DHC_IncItmLcBt(INCLB_LB_DR,INCLB_Active) 
	values (:Inclb,:Active))
	.i SQLCODE'=0  d
	..s Err=-91   ;更新批次库存活动状态失败
	.e  d
	..s Rowid=$p(%ROWID,$c(1))
	e  d
	.q:$p(^DHCINCLB(Rowid),"^",2)=Active   ;状态一致的话不需要更新
	.&sql(update DHC_IncItmLcBt set INCLB_Active=:Active where INCLB_RowId=:Rowid)
	.i SQLCODE'=0  d
	..s Err=-91   ;更新批次库存活动状态失败
	.
	q:Err'=0 Err
	q Rowid
}

/// Description:更新在途数
/// Creator:	wangjiabin
/// CreatDate:	2017-03-24
/// InPut:		Inc_ItmLoc表rowid,库存量
/// Table:		Inc_ItmLoc
/// OutPut:
/// Return:		0: 成功, <0: 失败
ClassMethod UpdateResQty(Incil, Qty) As %Library.String
{
	n (Incil,Qty)
	s LockName="User.DHCINCItmLoc"_Incil
	q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(LockName)<0 -99
	s inci=$p(Incil,"||",1),il=$p(Incil,"||",2)
	ts
	s resqty=$p(^INCI(inci,"IL",il),"^",10)
	i resqty+Qty<0 s Qty=-resqty			//当Qty<0时,消去resqty时到零为止
	s incilObj=##class(User.INCItmLoc).%OpenId(Incil)
	s incilObj.INCILReservedQty=incilObj.INCILReservedQty+Qty
	s sc=incilObj.%Save()
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(LockName)
	i $$$ISERR(sc) tro 1 q -4
	tc
	q 0
}

/// Descript：		处理科室库存批次的医嘱在途数
/// CreateDate：	2014-07-07(20141224)
/// Table：			inc_itmlcbt,dhc_incitmlcbt
/// Input：			inc_itmlcbt的ID,数量
/// Return：		0-成功,其它-失败
/// w ##class(web.DHCSTMHUI.Common.StockHandle).UpdInclbResQty("1799||2||1",3)
ClassMethod UpdInclbResQty(inclb As %String, qty As %String) As %String
{
	n (inclb,qty)
	q:inclb="" -1
	s dhcInclb=$O(^DHCINCLB(0,"LB",inclb,""))
	q:dhcInclb'>0 -2
	q:##class(web.DHCSTMHUI.Common.AppCommon).Lock("User.DHCINCItmLcBt"_inclb)<0 -99
	ts
	s resqty=+$p(^DHCINCLB(dhcInclb),"^",3)			//INCLB_ReservedQty
	i resqty+qty<0 s qty=-resqty					//消去resqty时到零为止
	s dhcInclbObj=##class(User.DHCINCItmLcBt).%OpenId(dhcInclb)
	s dhcInclbObj.INCLBReservedQty=dhcInclbObj.INCLBReservedQty+qty
	s sc=dhcInclbObj.%Save()
	i $$$ISERR(sc) tro 1 d UNLockInclb() q -3
	s incil=$p(inclb,"||",1,2)
	s incilObj=##class(User.INCItmLoc).%OpenId(incil)
	s incilObj.INCILReservedQty=incilObj.INCILReservedQty+qty
	s sc=incilObj.%Save()
	i $$$ISERR(sc) tro 1 d UNLockInclb() q -4
	d UNLockInclb()
	tc
	q 0
UNLockInclb()
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.DHCINCItmLcBt"_inclb)
	k dhcInclbObj,incilObj
	q
}

/// Description:生成新的incil/inclb记录
/// Creator:	wangjiabin
/// CreatDate:	2021-03-14
/// InPut:		科室rowid, 库存项rowid
/// OutPut:
/// Return:		Incil, ""表示生成失败
/// w ##class(web.DHCSTMHUI.Common.StockHandle).CreateZeroIncil(164,3718)
ClassMethod CreateZeroIncil(LocId, InciId) As %String
{
	n (LocId,InciId)
	q:(LocId="")||(InciId="") ""
	s IL=$o(^INCI("IL_LOC",LocId,InciId,0))
	i IL'="" s Incil=InciId_"||"_IL q Incil
	
	;获取Incib
	s Incib=""
	s Ingr=""
	f  s Ingr=$o(^DHCINGR(0,"INCI",InciId,Ingr),-1) q:(Ingr="")||(Incib'="")  d
	.s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	.q:AuditFlag'="Y"
	.s IngriCh=""
	.f  s IngriCh=$o(^DHCINGR(0,"INCI",InciId,Ingr,IngriCh),-1) q:(IngriCh="")||(Incib'="")  d
	..s Inclb=$p(^DHCINGR(Ingr,"GRI",IngriCh),"^",1)
	..q:Inclb=""
	..s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	..q:(IL="")||(LB="")
	..s Incib=$p(^INCI(InciId,"IL",IL,"LB",LB),"^",1) q
	
	q:Incib="" ""
	
	ts
	s Incil=..InsertIncItmLoc(LocId,InciId,0)
	i Incil<0 tro  q ""
	
	s Inclb=..InsertIncItmLcBt(Incil,Incib,0)
	i Inclb<0 tro  q ""
	
	s Ret=..UpdateDhcIncItmLcBt(Inclb,"Y")
	i +Ret<=0 tro  q ""
	
	tc
	q Incil
}

/// 更新科室库存表清在途时间
/// w ##class(web.DHCSTMHUI.Common.StockHandle).UpdateIncilClearTime("2051||2")
ClassMethod UpdateIncilClearTime(Incil, Date = "", Time = "") As %String
{
	n (Incil,Date,Time)
	s Inci=+Incil
	s Ch=$p(Incil,"||",2)
	s DhcIncil=$o(^DHCINCIL(0,"INCIL",Inci_"||"_Ch,""))
	s:Date="" Date=+$h
	s:Time="" Time=$p($h,",",2)
	s ret=0
	i DhcIncil="" d
	.&sql(insert into DHC_IncItmLoc(INCIL_INCIL_DR,INCIL_ClearDate,INCIL_ClearTime) values(:Incil,:Date,:Time))
	.i SQLCODE'=0  s ret=-1
	.e  s DhcIncil=$p(%ROWID,$c(1))
	e  d
	.s $p(^DHCINCIL(DhcIncil),"^",52)=Date
	.s $p(^DHCINCIL(DhcIncil),"^",53)=Time
	
	q ret
}

}
