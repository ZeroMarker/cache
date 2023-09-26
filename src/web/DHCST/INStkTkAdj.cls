Import sqluser

Class web.DHCST.INStkTkAdj Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 执行盘点调整(盘点调整的条件是：已经实盘汇总)
/// Author:zhwh
/// Date:2012-08-09
/// Argu:
///  inst - 盘点主表rowid
/// Return:
///  0 - sucess
///  <0 - failure
///  w ##class(web.DHCST.INStkTkAdj).StkTkAdj(67,13609)
///  LastUpdate:yunhaibao21051214,修改为单条事务,明细如果一条插入失败,则删除对应库存调整记录,全部成功后
ClassMethod StkTkAdj(inst As %String, adjUser As %String) As %String
{
	//检查盘点状态，判断是否可以执行调整
	s obj=##class(User.DHCInStkTk).%OpenId(inst,0)	
	d obj.%Reload()
	i '$IsObject(obj) q -100
	d obj.%Reload()
	q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.INStkTk).%GetParameter("AppName")_inst)<0 -99
	s comp =obj.INSTCompleted
	s stktkComp =obj.INSTStockTakeComplete
	s adjComp=obj.INSTAdjustmentComplete
	i comp'="Y" d ..uLock(inst) q -1  				//未帐盘
	i stktkComp'="Y" d ..uLock(inst) q -2  		//未实盘汇总
	i adjComp="Y" d ..uLock(inst) q -3   			//盘点已经调整
	s instkAdjDr=$p($g(^DHCINST(inst)),"^",15)  	//对应调整主表id
	// 重点！！！首次失败,二次调整时需判断是否已经调整表
	i (instkAdjDr'="")&&('$d(^DHCINAD(instkAdjDr))) s instkAdjDr="",$p(^DHCINST(inst),"^",15)=""
	TSTART
	// 生成库存调整单主表,一张盘点单只对应一张调整单
	s adjLoc=obj.INSTCTLOCDRGetObjectId()	
	s HospID=$p($g(^CTLOC(adjLoc)),"^",22)
	s adjReason="" 
	s adjScg=obj.INSTSCGDRGetObjectId()
	s adjStkType=..sssCode()  		//5
	s adjInst=inst  				//6
	s adjComp="Y"   				//7  -自动设置为"完成"状态
	s adjState="11"  				//8
	s remark="盘点调整"  			//9
	s mdata=adjLoc_"^"_adjUser_"^"_adjReason_"^"_adjScg_"^"_adjStkType_"^"_adjInst_"^"_adjComp_"^"_adjState_"^"_remark
	s adj=##class(web.DHCST.DHCINAdj).Update(instkAdjDr,mdata) 
	i +adj<=0 TROLLBACK  d ..uLock(inst) q -4
	TCOMMIT
	// 生成库存调整单子表
	s ret=0
	s ch=0
	f  s ch=$o(^DHCINST(inst,"STI",ch)) q:(ch="")!(ret<0)  d
	. s insti=inst_"||"_ch  
	. s inci=$p(^DHCINST(inst,"STI",ch),"^",18)
	. s inclb=$p(^DHCINST(inst,"STI",ch),"^",1)
	. s adjqty=$p(^DHCINST(inst,"STI",ch),"^",13)
	. // 关联调整单子表,一个盘点明细对应一个调整明细
	. s inadi=$p(^DHCINST(inst,"STI",ch),"^",22)
	. i (inadi'="")&&('$d(^DHCINAD(+inadi,"ADI",$p(inadi,"||",2)))) d
	. . s inadi=""
	. . s $p(^DHCINST(inst,"STI",ch),"^",22)=""
	. q:(inadi'="")&&$d(^DHCINTR(0,"TypePointer","A",inadi)) // 已调整不再更新
	. q:(inadi="")&&(+adjqty=0)
	. i (inadi'="")&&($d(^DHCINAD(+inadi,"ADI",$p(inadi,"||",2)))) d
	. . i +adjqty=0 d
	. . . &SQL(DELETE FROM DHC_INAdjItm WHERE INADI_RowId=:inadi)
	. . . s inadi=""
	. . . s $p(^DHCINST(inst,"STI",ch),"^",22)=""
	. q:+adjqty=0
	. s adjuomDesc=""
	. s buom=$p($G(^INCI(inci,1)),"^",10)  // 盘点子表中记录的单位是实盘默认的单位，帐盘表中的数量及价格均对应的是基本单位   
	. q:buom=""
	. s adjuom=$p(^DHCINST(inst,"STI",ch),"^",17)
	. q:adjuom=""
	. s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(adjuom,buom)
	. i adjuom'="" s adjuomDesc=$p(^CT("UOM",adjuom),"^",2) 
	. q:adjuomDesc=""
	. s hospid=$p(^CTLOC(adjLoc),"^",22)
	. s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,adjuom,hospid,"G",+$h,"")
	. s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,adjuom,hospid,"G","")
	. s rpAmt=rp*adjqty            
	. s spAmt=sp*adjqty				
	. s adiData=inclb_"^"_adjqty_"^"_adjuom_"^"_rp_"^"_sp_"^"_rpAmt_"^"_spAmt_"^"_insti
	. // 已关联且调整数量一样,不需更新
	. q:(inadi'="")&&(adjqty=$p($g(^DHCINAD(+inadi,"ADI",$p(inadi,"||",2))),"^",2))
	. TSTART
	. s adi=##class(web.DHCST.DHCINAdjItm).Update(inadi,adj,adiData)
	. i adi<0 s ret=-10 TROLLBACK  q
	. s locd=1
	. ;更新盘点子表中相应信息,zdm,2013-02-17  //价格变化时更新价格和金额和库存调整保持一致 2020-09-10 yangsj
	. s freezeQty=$p(^DHCINST(inst,"STI",ch),"^",2)
	. s countQty=$p(^DHCINST(inst,"STI",ch),"^",5)
	. s freezeRpAmt=rp*freezeQty
	. s countRpAmt=rp*countQty
	. s freezeSpAmt=sp*freezeQty
	. s countSpAmt=sp*countQty
	. s VarianceRpAmt=rp*adjqty
	. s VarianceSpAmt=sp*adjqty
 	. s freezeRpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(freezeRpAmt,HospID)
 	. s countRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(countRpAmt,HospID)
 	. s freezeSpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(freezeSpAmt,HospID)
 	. s countSpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(countSpAmt,HospID)
 	. s VarianceRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(VarianceRpAmt,HospID)
 	. s VarianceSpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(VarianceSpAmt,HospID)
	. &sql(update dhc_instktkitm set INSTI_LocDFlag=:locd,INSTI_INADI_DR=:adi ,INSTI_Sp=:sp, INSTI_FreezeSpAmt=:freezeSpAmt, INSTI_Rp=:rp, INSTI_FreezeRpAmt=:freezeRpAmt,
	 INSTI_Count1SpAmt=:countSpAmt, INSTI_Count1RpAmt=:countRpAmt, INSTI_Variance1SpAmt=:VarianceSpAmt, INSTI_Variance1RpAmt=:VarianceRpAmt where %id=:insti)
	. i SQLCODE'=0 s ret=-11  TROLLBACK  q
	. TCOMMIT
	i ret<0  d 
	.d ..uLock(inst)
	.i instkAdjDr="" d
	..// 首次点击调整,部分失败,可全部删除,因尚未产生台账
	..&SQL(DELETE FROM DHC_INAdj WHERE INAD_RowId=:adj)  
	..&sql(UPDATE DHC_InStkTkItm set INSTI_INADI_DR=NULL where INSTI_INST_Parref=:inst)
	q:ret<0 -6
	// 全部插入成功后更新主表关联
	&sql(update dhc_instktk set inst_inad_dr=:adj where %id=:inst)
	i SQLCODE<0 d
	.d ..uLock(inst)
	.i instkAdjDr="" d
	..&SQL(DELETE FROM DHC_INAdj WHERE INAD_RowId=:adj)  
	..&sql(UPDATE DHC_InStkTkItm set INSTI_INADI_DR=NULL where INSTI_INST_Parref=:inst)
	q:ret<0 -6
	// 库存调整单审核,开始处理库存
	s ret=##class(web.DHCST.DHCINAdj).Audit(adj,adjUser)
	i ret<0 d ..uLock(inst) q -8_":"_ret
	// 审核成功,更新盘点调整完成
	&sql(update dhc_instktk set INST_AdjustmentComplete='Y' where %id=:inst)
	i SQLCODE'=0   d ..uLock(inst) q -9
	d ..uLock(inst)
	q 0
ErrorStkTkAdj
	d ..uLock(inst)
 	//&SQL(DELETE FROM DHC_INAdj WHERE INAD_RowId=:adj)  //报错删除对应调整单
 	s Error=$$Error^DHCSTERROR()
 	q Error
}

/// 解锁
/// Author:zhwh
/// Date:2012-08-08
/// Argu:
///     inst - 盘点主表rowid
/// 
ClassMethod uLock(inst As %String)
{
 q:inst=""
 d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.INStkTk).%GetParameter("AppName")_inst)
 q
}

/// 批量保存实盘表记录
/// Creater:	liangjiaquan
/// CreateDate:	2018-10-23
/// Input:盘点子表id^科室批次ID^实盘数量
/// Output:		
/// Return：成功：0；
/// -2   ;保存失败
/// -1   ;盘点id不能为空
ClassMethod Save(ListData As %String) As %String
{
	n (ListData)
	q:ListData="" -1
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(ListData,rowDelim)
	s inst=+$p($p(ListData,rowDelim,1),"^",1)
	q:(inst="")!(inst=0) -1
	s inputType=""
    s stp=$o(^DHCINST(inst,"STP",0))
    i stp'=""  d
    .s inputType=2      ;本盘点单是按品种进行实盘
    e  d
    .s stw=##class(web.DHCST.INStkTk).CheckItmWd(inst)
    .s:stw=1 inputType=1   ;本盘点单是按批次进行实盘
    q:##class(web.DHCST.Common.AppCommon).Lock("DHCSTINStkTkAdj"_inst)<0 -99
    s $ZT="Error^DHCSTERROR"
	s Err=""
	s Count=0
	f i=1:1:len  d
	.s Data=$p(ListData,rowDelim,i)
	.q:Data=""
	.s Rowid=$p(Data,"^",1)
	.q:Rowid=""
	.s Inclb=$p(Data,"^",2)
	.s CountQty=$p(Data,"^",3)
	.TStart
	.s IncDesc=$p(^INCI(+Inclb,1),"^",2)
	.s OldFreQty=$p(^DHCINST(+Rowid,"STI",$p(Rowid,"||",2)),"^",2)
	.s LbQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(Inclb,+$h)
	.s AfterQty=CountQty-OldFreQty+LbQty
	.i AfterQty<0  d
	..Tro
	..i Err=""  d
	...s Err=IncDesc
	..e  d
	...s Err=Err_","_IncDesc 
	.q:AfterQty<0
	.s OldCountQty=$p(^DHCINST(+Rowid,"STI",$p(Rowid,"||",2)),"^",5)
	.s DifQty=CountQty-OldCountQty
	.s ret=..UpdateINStkItm(Rowid,CountQty)
	.i ret'=0  d
	..Tro   
	..i Err=""  d
	...s Err=IncDesc
	..e  d
	...s Err=Err_","_IncDesc 
	.q:ret'=0
	.i inputType=2  d				//按品种
	..s rett=..UpdateINStkInput(inst, +Inclb, DifQty)
	.e  d							//按批次
	..s rett=..UpdateINStkItmWd(Rowid, +Inclb, DifQty)
	.i rett'=0  d
	..Tro   
	..i Err=""  d
	...s Err=IncDesc
	..e  d
	...s Err=Err_","_IncDesc 
	.q:rett'=0
	.s Count=Count+1
	.TCommit
	d ##class(web.DHCST.Common.AppCommon).UnLock("DHCSTINStkTkAdj"_inst)
	q:Count=0 -2   				;全部保存失败
	q:Err'="" -3_":"_Err		;部分保存失败
	q 0							;保存成功
}

/// 更新盘点子表
ClassMethod UpdateINStkItm(Rowid, CountQty)
{
	n (Rowid,CountQty)
	s Loc=$p(^DHCINST(+Rowid),"^",5)
	s HospID=$p(^CTLOC(Loc),"^",22)
	s Obj=##class(User.DHCInStkTkItm).%OpenId(Rowid)
 	d Obj.%Reload()
 	s FreQty=Obj.INSTIFreezeQty
 	s Rp=Obj.INSTIRp
 	s Sp=Obj.INSTISp
 	s FreSpAmt=Obj.INSTIFreezeSpAmt
 	s FreRpAmt=Obj.INSTIFreezeRpAmt
 	//s CountSpAmt=CountQty*Sp
 	//s CountRpAmt=CountQty*Rp
 	//s CountSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(CountSpAmt,HospID)
 	//s CountRpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(CountRpAmt,HospID)
 	s inclb = $P(^DHCINST(+Rowid,"STI",$P(Rowid,"||",2)),"^",1)
 	s buom = $P(^INCI(+inclb,1),"^",10)
 	s CountRpAmt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbRpAmt(inclb, CountQty, buom, HospID)
 	s CountSpAmt = ##class(web.DHCST.Common.DrugStkCommon).GetInclbSpAmt(inclb, CountQty, buom, HospID)
 
 	s Variance=CountQty-FreQty
 	s VarianceSpAmt=CountSpAmt-FreSpAmt
 	s VarianceRpAmt=CountRpAmt-FreRpAmt
 	s Obj.INSTICount1Qty=CountQty
 	s Obj.INSTICount1SpAmt=CountSpAmt
	s Obj.INSTICount1RpAmt=CountRpAmt
 	s Obj.INSTIVariance1=Variance
 	s Obj.INSTIVariance1RpAmt=VarianceRpAmt
 	s Obj.INSTIVariance1SpAmt=VarianceSpAmt
 	s sc=Obj.%Save()
	i $$$ISERR(sc)  q -1
	q 0
}

/// 更新盘点品种表
ClassMethod UpdateINStkInput(Inst, Inci, DifQty)
{
	n (Inst,Inci,DifQty)
	s Buom=$p(^INCI(Inci,1),"^",10)
	s Puom=$p(^INCI(Inci,3),"^",6)
	s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Puom,Buom)
	s Id=0,Err=0
	f  s Id=$o(^DHCINST(Inst,"STP",0,Inci,Id)) q:(Id="")||(Id=0)||(Err'=0)||(DifQty=0)  d
	.s CountQty=$p(^DHCINST(Inst,"STP",Id),"^",2)
	.s Rowid=Inst_"||"_Id
	.s Obj=##class(User.DHCInStkTkInput).%OpenId(Rowid)
	.d Obj.%Reload()
	.i (DifQty+CountQty)>=0  d
	..s InclbCountQty=DifQty+CountQty
	..s DifQty=0
	.e  d
	..s InclbCountQty=0
	..s DifQty=DifQty+CountQty
	.s Obj.DHCSTICountQty=InclbCountQty
	.s Obj.DHCSTIQtyPuom=InclbCountQty\Fac
	.s Obj.DHCSTIQtyBuom=InclbCountQty#Fac
	.s sc=Obj.%Save()
	.i $$$ISERR(sc) s Err=-1
	.q:Err'=0
	q Err
}

/// 更新盘点批次表
ClassMethod UpdateINStkItmWd(Rowid, Inci, DifQty)
{
	n (Rowid, Inci, DifQty)
	s Inst=+Rowid
	s Sti=$p(Rowid,"||",2)
	s Buom=$p(^INCI(Inci,1),"^",10)
	s Puom=$p(^INCI(Inci,3),"^",6)
	s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Puom,Buom)
	s Sub=0,Err=0
	f  s Sub=$o(^DHCINST(Inst,"STI",Sti,"STW",Sub)) q:(Sub="")!(Sub=0)  d
	.s CountQty=$p(^DHCINST(Inst,"STI",Sti,"STW",Sub),"^",2)
	.s InstWdid=Inst_"||"_Sti_"||"_Sub
	.s Obj=##class(User.DHCInStkTkItmWd).%OpenId(InstWdid)
	.d Obj.%Reload()
	.i (DifQty+CountQty)>=0  d
	..s InclbCountQty=DifQty+CountQty
	..s DifQty=0
	.e  d
	..s InclbCountQty=0
	..s DifQty=DifQty+CountQty
	.s Obj.INSTWCountQty=InclbCountQty
	.s Obj.INSTWQtyPuom=InclbCountQty\Fac
	.s Obj.INSTWQtyBuom=InclbCountQty#Fac
	.s sc=Obj.%Save()
	.i $$$ISERR(sc) s Err=-1
	.q:Err'=0
	q Err
}

}
