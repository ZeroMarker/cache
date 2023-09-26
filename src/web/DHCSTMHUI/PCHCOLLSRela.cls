Import sqluser

/// Description:web.DHCSTMHUI.PCHCOLLSM相关调用
/// Creator:    wangjiabin
/// CreateDate: 2014-07-21
Class web.DHCSTMHUI.PCHCOLLSRela Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Creator:    wangjiabin
/// CreatDate:	2014-07-18
/// Description:取消医嘱时实库补录单据的处理
/// Table:		dhc_hvmat_orditm,dhc_ingdrecitm,dhc_inistrfitm
/// Input:		医嘱明细rowid
/// Return:		0,成功；非0，错误 
/// w ##class(web.DHCSTMHUI.PCHCOLLSRela).HandleMainLocInfo("447||92","WJWS20170419001")
ClassMethod HandleMainLocInfo(oeori As %String, barcode As %String, ClientDoFlag As %String = "") As %String
{
	n (oeori,barcode,ClientDoFlag)
	//step 1		判断是否走虚库
	s mainLoc=""		;支配科室
	s RtnObj=##class(RtnObj).%New()
	s IntrInfo=..sssOeoriTrType(oeori)
	s DispType=$p(IntrInfo,"^",1)
	s DHCIT=$o(^DHCITD(0,"Type",DispType,"Pointer",oeori,0))
	s OriginalStatus=$s(DHCIT'="":$p(^DHCIT(DHCIT),"^",35),1:"")
	s ingri=##class(web.DHCSTMHUI.PCHCOLLSM).GetIngri(barcode)
	i (ingri'="") {
		s ingrLoc=$p(^DHCINGR(+ingri),"^",13)
		&sql(select dhcloc_mainloc_dr into :mainLoc From DHCST_CtLoc where dhcloc_ctloc_dr=:ingrLoc)
		q:mainLoc="" 0
		q:ingrLoc=mainLoc 0
	}elseif(OriginalStatus="Temp"){
		;临时导入的跟台高值,暂不做特殊处理
	}else{
		;跟台高值(没有G入库记录),处理自带条码,避免后续重复
		s ret=##class(web.DHCSTMHUI.DHCItmTrack).UpOriBarToOldOriBar(barcode)
		q:ret'=0 -51
	}
	//step 2		判断是否已经实库补录
	s (OriId,hvmatIngri,hvmatLoc,IngrFlag)=""
	&sql(select ORI_RowId,ORI_INGRI_Modify_DR,ORI_INGRI_Modify_DR->INGRI_CTLOC_DR,ORI_IngrFlag
		into :OriId,:hvmatIngri,:hvmatLoc,:IngrFlag from DHC_HVMat_OrdItm
		where ORI_BarCode=:barcode and ORI_OEORI_DR=:oeori)
	q:(SQLCODE'=0)||(hvmatLoc="") 0
	q:(mainLoc'="")&&(hvmatLoc'=mainLoc) 0		;未进行实库补录的, 不处理
	q:(IngrFlag'="Y")||(hvmatIngri="") 0
	//step 3		获取ingri和initi(通过ingri关联获取),删除台帐,或是创建退货单(已月报或已付款等)
	s ingr=+hvmatIngri,ingrCh=$p(hvmatIngri,"||",2)
	s inclb=$p(^DHCINGR(ingr,"GRI",ingrCh),"^",1)
	s initi=$p(^DHCINGR(ingr,"GRI",ingrCh),"^",44)
	q:initi="" -45   ;20180203 针对手工撤销的还未审核入库单的情况
	s user="",demo="demo"
	&sql(select %id into :user from ss_user where SSUSR_Initials=:demo)
	s isMon=..IfMakeMon(ingr)
	s isPay=..IfPay(hvmatIngri)
	s AppName=##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName")
	s oeoriDepDR=$p(^OEORD($p(oeori,"||",1),"I",$p(oeori,"||",2),7),"^",2)
	s HospId=$s(oeoriDepDR'="":$p(^CTLOC(oeoriDepDR),"^",22),1:"")
	s Param="^"_oeoriDepDR_"^^"_HospId
	s DeleteWhileOeoriOver=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"DeleteWhileOeoriOver",Param)
	ts
	i (((DeleteWhileOeoriOver'="Y")&&(ClientDoFlag'="Y"))||(isMon=1)||(isPay=1)){
		;DeleteWhileOeoriOver参数不为Y, 或做了月报/付款的, 进行退货制单
		;ClientDoFlag 医嘱提取界面撤销 则直接删除入库出库单
		s ret=0
		l +^DHCINCLCBT(inclb):20  e  q -99
		;已接收的,不重复处理
		i '$d(^DHCINTR(0,"TypePointer","K",initi)) d
		.s ret=..TransInAuditYesItm(initi,user)
		i ret'=0 tro  l -^DHCINCLCBT(inclb) q -31
		
		s RtnObj=..CreateInIsTrf(initi,user)		;生成反向库存转移单,完成状态
		i RtnObj.success<0 tro  l -^DHCINCLCBT(inclb) q -32
		s Init=RtnObj.rowid
		s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(Init,user,"","Y")
		i RtnObj.success<0 tro  l -^DHCINCLCBT(inclb) q -33
		s Status=$p(^DHCINIT(Init),"^",14)
		i Status'="31" d
		.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransInAuditYes(Init,user)
		i RtnObj.success<0 tro  l -^DHCINCLCBT(inclb) q -34
		s ingrt=..CreateINGdRet(hvmatIngri,user)	;生成退货单
		i ingrt<0 tro  l -^DHCINCLCBT(inclb) q -35
		s obj=##class(User.DHCINGDRET).%OpenId(ingrt)
		s obj.INGRTCompleted="Y"
		s sc=obj.%Save()
		i $$$ISERR(sc) l -^DHCINCLCBT(inclb) q -35
		s Data=ingrt_"^"_user
		s Title="RowId^gUserId"
		s IngrtData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Audit(IngrtData)
		i RtnObj.success<0 tro  l -^DHCINCLCBT(inclb) q -36
		l -^DHCINCLCBT(inclb)
		
		;根据Init,ingrt记录对应补录入库出库的退库和退货
		i (ClientDoFlag'="Y") d
		.s ret=##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).RecordReturn(oeori,barcode,Init,ingrt)
		i ((OriId'="")&&(ClientDoFlag="Y")) d ;提取界面撤销则清空补录标志
		.&sql(update DHC_HVMat_OrdItm set ORI_IngrFlag=null,ORI_INGRI_Modify_DR=null,ORI_DateOfManu=null where %id=:OriId)
	}else{
		s ret=0
		;2018-03-21 跟台高值若进行了自动接收,则删除相应台帐(2018-08-06 医嘱台帐不删)
		i $d(^DHCINTR(0,"TypePointer","K",initi)) d
		.s ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("K",initi)
		i ret'=0 tro  q -41
		
		s ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("T",initi)
		i ret'=0 tro  q -41
		&sql(delete from DHC_INIsTrfItm where %id=:initi)
		s last=$o(^DHCINIT(+initi,"ITI",""),-1)
		i last=0 d
		.s init=+initi
		.&sql(delete from DHC_INIsTrf where %id=:init)
		//删除入库台帐,入库子表等
		s ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("G",hvmatIngri)
		i ret'=0 tro  q -42
		&sql(delete from DHC_INGdRecItm where %id=:hvmatIngri)
		s last=$o(^DHCINGR(ingr,"GRI",""),-1)
		i last="" d
		.&sql(delete from DHC_INGdRec where %id=:ingr)
		i OriId'="" d
		.&sql(update DHC_HVMat_OrdItm set ORI_IngrFlag=null,ORI_INGRI_Modify_DR=null,ORI_DateOfManu=null where %id=:OriId)
	}
	tc
	
	q 0
}

/// 接收某条明细,设置dhciti_state=31
/// Author:	wangjiabin
/// Date:	2014-07-21
/// Argu:
///   initi - 库存转移子表 RowId
/// Return:	0:成功, 其他:失败
ClassMethod TransInAuditYesItm(initi As %String, user As %String) As %String
{
	n (initi,user)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	//加锁
	s init=+initi
	s lockName="DHCSTTRANSFERM"_init
	q:..sssLock(lockName)<0 -99
	
	;已有K台帐的,不重复处理
	i $d(^DHCINTR(0,"TypePointer","K",initi)) q 0
	
	ts
	s newStatus="31"
	s d=+$h,t=$p($h,",",2)
	&sql(update dhc_inistrfitm set dhciti_state=:newStatus where %id=:initi)
	i SQLCODE'=0 tro  d ..sssUnLock(lockName) q -2
 
	//处理库存，台账记录
	s err=0,ret=0
	s initNo=$p(^DHCINIT(init),"^",1)
	s type="K"
	s ch=$p(initi,"||",2)
	s inclb=$p(^DHCINIT(init,"ITI",ch),"^",3)
	s toInclb=..GetToLocINCLB(initi)  //取入方科室的库存批次rowid
	s qty=$p(^DHCINIT(init,"ITI",ch),"^",1)
	s trQty=qty
	s uom=$p(^DHCINIT(init,"ITI",ch),"^",7)
	s inci=+inclb
	s buom=$P(^INCI(inci,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	s qty=qty*fac
	s rp=$p(^DHCINIT(init,"ITI",ch),"^",15)
	s rpAmt=$p(^DHCINIT(init,"ITI",ch),"^",16)
	s sp=$p(^DHCINIT(init,"ITI",ch),"^",17)
	s spAmt=$p(^DHCINIT(init,"ITI",ch),"^",18)
	s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(toInclb,qty)
	i ret<0 tro  s err=-3  q 
	
	s trData=type
	s trData=trData_"^"_initNo
	s trData=trData_"^"_toInclb
	s trData=trData_"^"_+trQty
	s trData=trData_"^"_uom
	s trData=trData_"^"_+sp
	s trData=trData_"^"_user
	s trData=trData_"^"_initi
	s trData=trData_"^"_+rp
	s trData=trData_"^"_+rpAmt
	s trData=trData_"^"_+spAmt
	
	s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(trData)
	i RtnObj.success'=0 tro   s err=-4  q 
	
	i err=0  tc
	d ..sssUnLock(lockName)
	q err
}

/// 根据库存转移单明细得出入方的批次
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///  initi  - 库存转移单明细rowid
/// Return:
///  入方的批次rowid
///  
ClassMethod GetToLocINCLB(initi As %String) As %String
{
 n (initi)
 s init=+initi
 s ch=$P(initi,"||",2)
 s toLocDR= $p(^DHCINIT(init),"^",6)
 s ProvLocInclb=$P(^DHCINIT(init,"ITI",ch),"^",3)
 q:ProvLocInclb="" -1
 s inci="",incilsub="",inclbsub="",incib=""
 s ibsub="",batno="",expdate="",inclb=""
 s inci=$p(ProvLocInclb,"||",1)  q:inci="" -1
 s incilsub=$p(ProvLocInclb,"||",2) q:incilsub="" -1
 s inclbsub=$p(ProvLocInclb,"||",3) q:inclbsub="" -1
 q:'$d(^INCI(inci,"IL",incilsub,"LB",inclbsub)) -1
 s incib=$p(^INCI(inci,"IL",incilsub,"LB",inclbsub),"^",1) q:incib="" -1
 s ibsub=$p(incib,"||",2) q:ibsub="" -1
 q:($d(^INCI(inci,"IB",ibsub))=0)!($d(^INCI(inci,"IB",ibsub))=10) -1
 ;
 l +^DBLock($zn,inci_"^"_toLocDR):20 e  q ""
 s incil="",inclb=""
 s ilch=$O(^INCI("IL_LOC",toLocDR,inci,""))
 i ilch="" d
 .&sql(insert into inc_itmloc(incil_Inci_parref,incil_ctloc_dr)
   values (:inci,:toLocDR) )
 .i SQLCODE=0 s incil=%ROWID  
 .s ilch=$P(incil,"||",2)
 e  d
 .s incil=inci_"||"_ilch
 s lb=$O(^INCI("LB_IB",incib,inci,ilch,"")  )
 i lb="" d
 .&sql(insert into INC_ItmLcBt (inclb_incil_parref,inclb_incib_dr)
   values(:incil,:incib) )
 .i SQLCODE=0 s inclb=%ROWID
 e  d
 .s inclb=inci_"||"_ilch_"||"_lb 
 
 l -^DBLock($zn,inci_"^"_toLocDR)
 Q inclb
}

/// Creator:zdm
/// CreatDate:2013-02-26
/// Description:判断该入库单是否已经生成月报
/// InPut：入库主表id
/// Table:
/// OutPut:
/// Return:0,未生成；1,已生成
ClassMethod IfMakeMon(ingr As %String) As %Library.String
{
	;if loc have maked monreport
	n (ingr)
	q:ingr="" 0
	
	s loc=$p(^DHCINGR(ingr),"^",13)
	s date=$p(^DHCINGR(ingr),"^",4) ;审核日期
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_ToDate>=:date)
	q:'SQLCODE 1
	q 0
}

/// Creator:zhangxiao
/// CreatDate:2013-06-20
/// Description:判断该入库明细是否已经生成付款单
/// InPut：入库明细id
/// Table:
/// OutPut:
/// Return:1 已经生成付款单  0 未生成付款单
ClassMethod IfPay(Ingri As %String) As %Library.String
{
	n (Ingri)
	q:Ingri="" 0
	s Ret=0
	s Pay=$o(^DHCPAY(0,"TYPEGR","G",Ingri,0))
	i Pay'="" s Ret=1 q Ret			;已经生成付款单
	s VenInvId=$o(^DHCVendorInv(0,"TypeItm","G",Ingri,0))
	i VenInvId'="" s Ret=1 q Ret	;已锁定发票
	
	q Ret
}

/// 根据initi明细信息反向制作库存转移单(完成状态,state=11)
/// Author:		wangjiabin
/// Date:		2014-07-21
/// Arguments:	initi, userId
/// Return:
/// 	>0  : 发放单rowid
/// 	<0 : 失败	-3:保存主表信息失败
ClassMethod CreateInIsTrf(initi As %String, UserId As %String) As %String
{
	n (initi,UserId)
	s RtnObj=##class(RtnObj).%New()
	q:initi="" RtnObj.Err(-5,initi,"参数解析错误")
	s InIt=+initi
	
	s statu=$p(^DHCINIT(InIt),"^",14)
	q:statu'=31 RtnObj.Err(-10,"","单据状态错误")		;仅处理状态为"已接收"的单据
	s frLoc=$p(^DHCINIT(InIt),"^",5)
	s toLoc=$p(^DHCINIT(InIt),"^",6)
	s scg=$p(^DHCINIT(InIt),"^",23)
	s comp="Y",status=11,stkType=..sssCode()
	s opDesc="正常出库",opType="OM"
	&sql(select %id into :opType from dhc_operatetype where ipt_desc=:opDesc and ipt_type=:opType)
	s MainInfo=toLoc_"^"_frLoc_"^"_opType_"^"_comp_"^"_status_"^"_UserId_"^"_scg
	s Title="InitFrLoc^InitToLoc^OperateType^InitComp^InitState^InitUser^InitScg"
	s InitData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainInfo,Title)
	
	s qty=$p(^DHCINIT(+initi,"ITI",$p(initi,"||",2)),"^",1)
	s uom=$p(^DHCINIT(+initi,"ITI",$p(initi,"||",2)),"^",7)
	s toInclb=..GetToLocINCLB(initi)
	s Data=toInclb_"^"_qty_"^"_uom
	s Title2="Inclb^Qty^UomId"
	s InitDetailData="["_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title2)_"]"

	s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Save(InitData,InitDetailData)
	q RtnObj
}

/// Creator:	wangjiabin
/// CreatDate:	2014-07-21
/// Description:根据ingri生成相应的退货单
/// InPut：		入库子表id,userId
/// OutPut:
/// Return:		>0:成功, 其他:失败
ClassMethod CreateINGdRet(ingri As %String, userId As %String) As %String
{
	n (ingri,userId)
	q:ingri="" ""
	s ingr=+ingri
	q:'$d(^DHCINGR(ingr)) ""
	&sql(select INGR_APCVM_DR,INGR_Loc_Dr,INGR_SCG_DR,INGR_AdjCheque
		into :vendor,:loc,:scg,:adjChequeFlag
		from dhc_ingdrec where %id=:ingr)
	s mainInfo=loc_"^"_vendor_"^"_userId_"^"_scg_"^"_adjChequeFlag
	s Title="RetLoc^Vendor^gUserId^ScgStk^AdjChequeFlag"
	s IngrtData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(mainInfo,Title)
	
	s objItm=##class(User.DHCINGdRecItm).%OpenId(ingri)
	s recqty=objItm.INGRIRecQty
	s uom=objItm.INGRICTUOMDR.%Id()
	i uom="" s uom=+$p($g(^INCI(+INCLB,1)),"^",10)
	s rp=objItm.initmrealprice
	s sp=objItm.initmsaleprice
	s pp=objItm.initmBatPrice
	s invNo=objItm.initminvno
	s invDate=objItm.initminvdate
	i invDate'="" s invDate=$zd(invDate,3)
	s invAmt=objItm.initminvmoney
	s stkType=..sssCode()
	s ingrti="",sxNo="",retReasonId="",HVBarCode=""		//退货原因可以用特殊值
	s listData=ingrti_"^"_ingri_"^"_recqty_"^"_uom_"^"_rp
			_"^"_sp_"^"_invNo_"^"_invDate_"^"_invAmt_"^"_sxNo
			_"^"_retReasonId_"^"_HVBarCode
	s Title2="RowId^Ingri^Qty^Uom^Rp^Sp^InvNo^InvDate^InvAmt^SxNo^ReasonId^HvBarCode"
	s IngrtDetailData="["_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(listData,Title2)_"]"		
	s RtnObj=##class(RtnObj).%New()		

	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Save(IngrtData,IngrtDetailData)

	i RtnObj.success<0 q -11
	s ingrt=RtnObj.rowid
	q ingrt
}

}
