Import sqluser

Class web.DHCSTMHUI.DHCINIsTrfItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新库存转移明细信息
/// Creator:	wangjiabin
/// CreateDate:	2018-05-30
/// Input:		InitId(转移单rowid), DetailRows({RowId:**,Inclb:**,...})
/// Output:		RtnObj
ClassMethod Save(InitId As %String, DetailRows As %String) As RtnObj
{
	n (InitId,DetailRows)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	
	i InitId="" q RtnObj.Err(-5,InitId,MethodName_":参数错误")
	i DetailRows="" s RtnObj.rowid=InitId q RtnObj
	
	s LocId=$p(^DHCINIT(InitId),"^",5)
	s UserId=$p(^DHCINIT(InitId),"^",8)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(DetailRows)
	i Sc'=0 q RtnObj.Err(-5,InitId,MethodName_":参数解析错误")
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s Initi=Obj.%Get("RowId")
		s Inclb=Obj.%Get("Inclb")
		s Qty=Obj.%Get("Qty")
		s Sp=Obj.%Get("Sp")
		s UomId=Obj.%Get("UomId")
		s Inrqi=Obj.%Get("Inrqi")
		s Remark=Obj.%Get("Remark")
		s Ingri=Obj.%Get("Ingri")
		s HVBarCode=Obj.%Get("HVBarCode")
		s ThirdCode=Obj.%Get("ThirdCode")
		s ThirdId=Obj.%Get("ThirdId")
		s AddionFlag=Obj.%Get("AddionFlag")		;补录标记,不判断库存
		s InitiDR=Obj.%Get("InitiDR")		;依据出库单退库保存原出库明细ID
		
		s Inci=$p(Inclb,"||",1)
		s InciDesc=$p(^INCI(Inci,1),"^",2)
		
		s CheckStr=Inclb_"^"_Qty_"^"_UomId
		s ErrInfo=""
		i AddionFlag'="Y" d
		.s ErrInfo=..CheckTransferDetail(Initi,CheckStr)
		i ErrInfo'="" d RtnObj.Err(-7,Initi,InciDesc_":"_ErrInfo)
		continue:RtnObj.success<0
		
		;处理占用库存
		i Initi'=""  d
		.q:AddionFlag="Y"
		.;减去原占用库存
		.s Ret=##class(web.DHCSTMHUI.DHCINIsTrf).HandleTransItmDirtyQty(Initi,0)
		.i Ret'=0 d RtnObj.Err(-1,"",MethodName_":移除"_InciDesc_"占用库存失败") q
		.;增加请求单在途数
		.s Ret=..HandleTransItmResQty(Initi,1)
		.i Ret'=0 d RtnObj.Err(-2,"",MethodName_":增加"_InciDesc_"请求单在途数失败") q
		continue:RtnObj.success<0
		
		s RowStr=Obj.%ToJSON()
		s RtnObj=..Update(InitId,RowStr)
		continue:RtnObj.success<0
		s InitiRowId=RtnObj.rowid			;留意Initi和InitiRowId的区分
		
		;处理高值条码
		i (Initi="")&&(HVBarCode'="") d
		.s OperData=LocId_"^"_UserId_"^"_Inci_"^^^"
		.s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).Update("T",InitiRowId,HVBarCode,OperData)
		continue:RtnObj.success<0
		
		;增加新占用库存
		s Ret=##class(web.DHCSTMHUI.DHCINIsTrf).HandleTransItmDirtyQty(InitiRowId,1)
		i Ret'=0 d RtnObj.Err(-3,"","增加"_InciDesc_"占用库存失败")
		continue:RtnObj.success<0
		;清除请求单对应在途数
		s Ret=..HandleTransItmResQty(InitiRowId,0)
		i Ret'=0 d RtnObj.Err(-8,"","清除"_InciDesc_"在途数失败")
		continue:RtnObj.success<0
		
		;保存第三方明细id(仅新增时)
		i (Initi="") d
		.s ThirdObj={},ThirdObj.ThirdCode=ThirdCode,ThirdObj.Type="T",ThirdObj.Pointer=InitiRowId,ThirdObj.ThirdId=ThirdId
		.s ThirdStr=ThirdObj.%ToJSON()
		.s RtnObj=##class(web.DHCSTMHUI.DHCServiceBill).Save(ThirdStr)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// Descript:	插入或更新库存转移单明细记录
/// Creator:	wangjiabin
/// CreateDate:	2018-05-31
/// Table:		DHC_InIsTrfItm
/// Input:		主表id, 明细行({"RowId:**,Inclb:**,Qty:**,UomId:**,...})
/// OutPut:		RtnObj
ClassMethod Update(Init As %String, Row As %String) As RtnObj
{
	n (Init,Row)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Update"
	i Init="" q RtnObj.Err(-1,"",MethodName_":参数Init错误")
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Row)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败:"_Row)
	
	s LocId=$p(^DHCINIT(Init),"^",5)
	s HospId=$p(^CTLOC(LocId),"^",22)
	
	s Initi=PJObj.%Get("RowId")
	s Inclb=PJObj.%Get("Inclb")
	s Qty=PJObj.%Get("Qty")
	s UomId=PJObj.%Get("UomId")
	s Inrqi=PJObj.%Get("Inrqi")
	;自动匹配请求明细
	s ReqId=$p(^DHCINIT(Init),"^",7)
	i (Inrqi="")&&(ReqId'="") d
	.s Inrqi=..GetInRqiId(ReqId,+Inclb)
	;自动匹配请求明细
	s Remark=PJObj.%Get("Remark")
	s Ingri=PJObj.%Get("Ingri")
	s SpecDesc=PJObj.%Get("SpecDesc")
	s InitiDR=PJObj.%Get("InitiDR")	;依据出库单退库保存原出库明细ID
	s Sp=PJObj.%Get("Sp")
	i +Sp=0 s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId)
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	s SpAmt=Sp*Qty
	s RpAmt=Rp*Qty
	s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	s Pp=Rp,PpAmt=RpAmt
	
	s AppName=##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName")
	i ..sssLock(AppName_Init)<0 q RtnObj.Err(-2,"",MethodName_"加锁失败")

	i Initi="" d
	.s obj=##class(User.DHCInIsTrfItm).%New(Init)
	.d obj.INITIINITParRefSetObjectId(Init)
	e  d
	.s obj=##class(User.DHCInIsTrfItm).%OpenId(Initi)
	
	d obj.INITIINCLBDRSetObjectId(Inclb)
	s obj.INITIQty=+Qty
	s obj.INITICTUOMDR=##class(User.CTUOM).%OpenId(UomId)
	s obj.INITIUCost=+Sp
	s obj.DHCITIPurPrice=+Pp
	s obj.DHCITIPPAmount=+PpAmt
	s obj.DHCITIRealPrice=+Rp
	s obj.DHCITIRPAmount=+RpAmt
	s obj.DHCITISalePrice=+Sp
	s obj.DHCITISPAmount=+SpAmt
	s obj.INITIINRQIDR=##class(User.INReqItm).%OpenId(Inrqi)
	s obj.DHCITIRemark=Remark
	s obj.INITIType="T"
	s obj.INITIINGRIDR=##class(User.DHCINGdRecItm).%OpenId(Ingri)
	s obj.INITISpecList=SpecDesc
	d obj.INITIITIDRSetObjectId(InitiDR)
	s Sc=obj.%Save()
	d ..sssUnLock(AppName_Init)
	i $$$ISERR(Sc) q RtnObj.Err(-2,"",MethodName_":保存失败!")
	
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// 删除库存转移单明细记录
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///   initi - 库存转移单明细记录rowid
/// Return：
///   0 -Success
///   <0 - failure
/// w ##class(web.DHCSTMHUI.DHCINIsTrfItm).Delete("")
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	
	s $ZT=..sssError()
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	s AppName=##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName")
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析错误").Json()
	
	ts
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s Initi=Obj.%Get("RowId")
		continue:Initi=""
		
		s Init=+Initi
		i ##class(web.DHCSTMHUI.DHCINIsTrf).AllowDel(Init)<0 d
		.d RtnObj.Err(-100,"","已完成的单据不允许删除!","",0)
		q:RtnObj.success<0
		
		i ..sssLock(AppName_Init)<0 d
		.d RtnObj.Err(-99,Init,MethodName_":加锁失败","")
		q:RtnObj.success<0
		
		s RtnObj=..Delete(Initi)
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Delete(Initi As %String) As RtnObj
{
	n (Initi)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(RtnObj).%New()
	s AppName=##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName")
	
	i Initi="" q RtnObj.Err(-1,"",MethodName_":参数错误")
	s Init=+Initi
	i ##class(web.DHCSTMHUI.DHCINIsTrf).AllowDel(Init)<0 d
	.d RtnObj.Err(-100,"",MethodName_":不允许删除!","",0)
	q:RtnObj.success<0 RtnObj
	
	i ..sssLock(AppName_Init)<0 d
	.d RtnObj.Err(-99,Init,MethodName_":加锁失败","")
	q:RtnObj.success<0 RtnObj
	
	;删除高值跟踪信息
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer("T",Initi)
	i RtnObj.success<0 d ..sssUnLock(AppName_Init) q RtnObj
	
	s ret=##class(web.DHCSTMHUI.DHCINIsTrf).HandleTransItmDirtyQty(Initi,0)  //占用数
	i ret<0 d
	.d ..sssUnLock(AppName_Init)
	.d RtnObj.Err(-2,"",MethodName_":处理占用数失败")
	q:RtnObj.success<0 RtnObj
	
	//处理在途数
	s ret=..HandleTransItmResQty(Initi,1)
	i ret<0 d
	.d ..sssUnLock(AppName_Init)
	.d RtnObj.Err(-2,"",MethodName_":处理在途数失败")
	q:RtnObj.success<0 RtnObj
	
	&sql(delete from dhc_inistrfitm where %ID=:Initi)
	i SQLCODE'=0 d
	.d ..sssUnLock(AppName_Init)
	.d RtnObj.Err(-5,Initi,MethodName_":删除失败","{Initi:"_Initi_"}")
	q:RtnObj.success<0 RtnObj
	
	;处理init_inrq_dr字段
	s ret=##class(web.DHCSTMHUI.DHCINIsTrf).UpdateInitInfo(Init)
	i ret<0 d
	.d ..sssUnLock(AppName_Init)
	.d RtnObj.Err(-6,Initi,MethodName_":删除失败")
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// 检索库存转移单的明细数据
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///  init -库存转移单主表rowid, InitType(T:出库单, K:退库单)
///  
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","DHCINIsTrfD","{""Init"":""187""}")
Query DHCINIsTrfD(Params As %String, RQInitStr As %String = "") As Query(ROWSPEC = "RowId,Inclb,InciId,InciCode,InciDesc,Spec,SpecDesc,UomId,UomDesc,Qty:%Float,Rp:%Float,RpAmt:%Float,Pp:%Float,PpAmt:%Float,Sp:%Float,SpAmt:%Float,NewSp:%Float,NewSpAmt:%Float,Status,VendorId,VendorDesc,ManfId,ManfDesc,Remark,StkBin,InclbQty:%Float,InclbDirtyQty:%Float,InclbAvaQty:%Float,ReqLocStkQty:%Float,BUomId,ConFac:%Float,BatExp,DirtyQty:%Float,HVFlag,HVBarCode,BarCode,AllAvaQty:%Float,IncscDesc,IncscType,Inrqi,ReqQty:%Float,ReqRemark,QtyApproved,AllDirtyQty:%Float,dhcit,SterilizedBat,CheckFlag,IntrStkQty:%Float,Model,LimitType,ReqAmt:%Float,LeftAmt:%Float,OriginalStatus,MatInsuCode,MatInsuDesc,BatNo,ExpDate,certNo,Ingri,InitiDR") [ SqlProc ]
{
}

ClassMethod DHCINIsTrfDExecute(ByRef qHandle As %Binary, Params As %String, RQInitStr As %String = "") As %Status
{
	n (qHandle,Params,RQInitStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Init=PJObj.%Get("Init")
	s InitType=PJObj.%Get("InitType")
	s ToReturnFlag=PJObj.%Get("ToReturnFlag")
	i Init="" d
	.s RQInit=$p(RQInitStr,",",1)
	.s RQInitType=$p(RQInitStr,",",2)
	.s Init=RQInit
	.s InitType=RQInitType
	s:InitType="" InitType="T"
	q:Init="" $$$OK
	s HospId=""
	s FrLocId=$p(^DHCINIT(Init),"^",5)
	s:FrLocId'="" HospId=$p(^CTLOC(FrLocId),"^",22)
	s sql="select %ID RowId,"
		_"initi_inclb_dr Inclb,"
		_"initi_ctuom_dr UomId,"
		_"initi_qty Qty,"
		_"initi_inrqi_dr Inrqi,"
		_"dhciti_realprice Rp,"
		_"dhciti_rpamount RpAmt,"
		_"dhciti_purprice Pp,"
		_"dhciti_ppamount PpAmt,"
		_"dhciti_saleprice Sp,"
		_"dhciti_spamount SpAmt,"
		_"dhciti_newsp NewSp,"
		_"dhciti_newspamt NewSpAmt,"
		_"dhciti_state Status,"
		_"INITI_UserAck_DR UserAck,"
		_"dhciti_remark Remark,"
		_"initi_ingri_dr Ingri,"
		_"INITI_ITI_DR InitiDR"
		_" from dhc_inistrfitm"
		_" where initi_init_parref="_Init
		_" ORDER BY INITI_ChildSub asc"
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	if $$$ISERR(sc) q $$$OK
	while(xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Init=+RowId
		s Inclb=xrs.Data("Inclb")
		s UomId=xrs.Data("UomId")
		s UomDesc=""
		s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
		s Qty=xrs.Data("Qty")
		s Inrqi=xrs.Data("Inrqi")
		s Rp=xrs.Data("Rp")
		s RpAmt=xrs.Data("RpAmt")
		s Pp=xrs.Data("Pp")
		s PpAmt=xrs.Data("PpAmt")
		s Sp=xrs.Data("Sp")
		s SpAmt=xrs.Data("SpAmt")
		s NewSp=xrs.Data("NewSp")
		s NewSpAmt=xrs.Data("NewSpAmt")
		s Status=xrs.Data("Status")
		s Remark=xrs.Data("Remark")
		s UserAck=xrs.Data("UserAck")
		s Ingri=xrs.Data("Ingri")
		s InitiDR=xrs.Data("InitiDR")
		s CheckFlag="N"
		s:+UserAck>0 CheckFlag="Y"
		s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
		s BatExpInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
		s BatNo=$p(BatExpInfo,"^",1)
		s ExpDate=$p(BatExpInfo,"^",2)
		s BatExp=BatNo_"~"_ExpDate 
		s InciId=+Inclb
		s Incil=$p(Inclb,"||",1,2)
		s InciCode=$P(^INCI(InciId,1),"^",1)
		s InciDesc=$P(^INCI(InciId,1),"^",2)
		s BarCode=$p(^INCI(InciId,3),"^",9)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(InciId)
		s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
		s ManfId=$P(ManfInfo,"^",1)
		s ManfDesc=$P(ManfInfo,"^",2)
		s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
		s VendorId=$p(VendorInfo,"^",1)
		s VendorDesc=$p(VendorInfo,"^",2)
		s SterilizedBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb(Inclb)
		
		s InitDate=$p(^DHCINIT(Init),"^",2)
		s ProLocId=$p(^DHCINIT(Init),"^",5)
		s ReqLocId=$p(^DHCINIT(Init),"^",6)
		
		s StkBinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(ProLocId,InciId)
		s StkBin=$p(StkBinInfo,"^",1)
		s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom(Inclb,UomId,+$h)		;当前库存
		s InclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,UomId)	;当前占用库存
		s InclbAvaQty=InclbQty-InclbDirtyQty			;当前可用库存
		s DirtyQty=0
		s Status=$p(^DHCINIT(Init),"^",14)
		i (Status'=21)!(Status'=31) s DirtyQty=Qty		;本次占用数量
		s ReqLocStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciId,ReqLocId,UomId,+$h)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s AllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(ProLocId,InciId,UomId) ;取物资库存项当前可用库存
		s AllDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurIncResQty(Incil,UomId) ;取物资库存项当前占用库存
		
		s (ReqQty,ReqRemark,QtyApproved)=""
		i Inrqi'=""  d
		.s ReqQty=$p(^INRQ(+Inrqi,"RQI",$p(Inrqi,"||",2)),"^",3)
		.s ReqUom=$p(^INRQ(+Inrqi,"RQI",$p(Inrqi,"||",2)),"^",5)
		.s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ReqUom,BUomId)
		.s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		.s ReqQty=ReqQty*Fac1/Fac2
		.s DhcInrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,""))
		.s ReqRemark=$s(DhcInrqi'="":$p(^DHCINRQI(DhcInrqi),"^",2),1:"") //请求明细中备注   
		.s QtyApproved=$s(DhcInrqi'="":$p(^DHCINRQI(DhcInrqi),"^",3),1:"")
		
		s HVBarCodeInfo=..GetHVBarCode(RowId)
		s HVBarCode=$p(HVBarCodeInfo,"^",1),dhcit=$p(HVBarCodeInfo,"^",2)
		s OriginalStatus=$p(HVBarCodeInfo,"^",3)
		s Incsc=$p(^INCI(InciId,2),"^",2)
		s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
		s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId),"^",6)
		s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty(InitType,RowId)
		s IntrStkQty=IntrStkQtyB/ConFac
		s LimitAmtStr=##class(web.DHCSTMHUI.LocLimitAmt).GetLimitAmtStr(ReqLocId,InciId)
		s LimitType=$p(LimitAmtStr,"^",1)
		s ReqAmt=$p(LimitAmtStr,"^",2)
		s LeftAmt=$p(LimitAmtStr,"^",3)
		s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(InciId,HospId)
		s MatInsuCode=$p(MatInsuInfo,"^",1)
		s MatInsuDesc=$p(MatInsuInfo,"^",2)
		s certinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(InciId)
		s certNo=$p(certinfo,"^",1)
		s ReturnInit=$o(^DHCINIT(0,"INITI",RowId,""),-1)
		continue:(ToReturnFlag="Y")&&(+ReturnInit>0)
		d OutPurRow
	}

	Quit $$$OK
OutPurRow
	s Data=$lb(RowId,Inclb,InciId,InciCode,InciDesc,
		Spec,SpecDesc,UomId,UomDesc,Qty,
		Rp,RpAmt,Pp,PpAmt,Sp,
		SpAmt,NewSp,NewSpAmt,Status,VendorId,
		VendorDesc,ManfId,ManfDesc,Remark,StkBin,
		InclbQty,InclbDirtyQty,InclbAvaQty,ReqLocStkQty,BUomId,
		ConFac,BatExp,DirtyQty,HVFlag,HVBarCode,
		BarCode,AllAvaQty,IncscDesc,IncscType,Inrqi,
		ReqQty,ReqRemark,QtyApproved,AllDirtyQty,dhcit,
		SterilizedBat,CheckFlag,IntrStkQty,Model,
		LimitType,ReqAmt,LeftAmt,OriginalStatus,MatInsuCode,
		MatInsuDesc,BatNo,ExpDate,certNo,Ingri,InitiDR
		)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取出库明细批次汇总信息
/// Creator:	wxj
/// CreateDate:	2022-06-07
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","GetDetailSum","{""Init"":""136"",""InitType"":""T""}")
Query GetDetailSum(Params As %String) As Query(ROWSPEC = "RowId,Inclb,InciId,InciCode,InciDesc,Spec,SpecDesc,UomId,UomDesc,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Status,VendorId,VendorDesc,ManfId,ManfDesc,InclbQty:%Float,InclbDirtyQty:%Float,InclbAvaQty:%Float,ReqLocStkQty:%Float,BUomId,ConFac:%Float,BatExp,DirtyQty:%Float,HVFlag,HVBarCode,BarCode,AllAvaQty:%Float,IncscDesc,IncscType,AllDirtyQty:%Float,SterilizedBat,Model,MatInsuCode,MatInsuDesc,BatNo,ExpDate,CertNo,StartBarCode,EndBarCode") [ SqlProc ]
{
}

ClassMethod GetDetailSumExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Init=PJObj.%Get("Init")
	s InitType=PJObj.%Get("InitType")
	s:InitType="" InitType="T"
	q:Init="" $$$OK
	s HospId=""
	s ProLocId=$p(^DHCINIT(Init),"^",5)
	s ReqLocId=$p(^DHCINIT(Init),"^",6)
	s Status=$p(^DHCINIT(Init),"^",14)
	s:ProLocId'="" HospId=$p(^CTLOC(ProLocId),"^",22)
	s sql="select %ID RowId,"
		_"initi_inclb_dr Inclb,"
		_"initi_ctuom_dr UomId,"
		_"initi_qty Qty"
		_" from dhc_inistrfitm"
		_" where initi_init_parref="_Init
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	if $$$ISERR(sc) q $$$OK
	while(xrs.Next())
	{
		s Initi=xrs.Data("RowId")
		s Inclb=xrs.Data("Inclb")
		s UomId=xrs.Data("UomId")
		s Qty=xrs.Data("Qty")		
		i '$d(^||InitiInclb(Inclb)) d
		.s ^||InitiInclb(Inclb)=Qty_"^"_UomId_"^"_Initi
		e  d
		.s $p(^||InitiInclb(Inclb),"^",1)=Qty+$p(^||InitiInclb(Inclb),"^",1)
		
	}
	s Inclb=""
	f  s Inclb=$o(^||InitiInclb(Inclb)) q:Inclb=""  d
	.s Qty=$p(^||InitiInclb(Inclb),"^",1)
	.s UomId=$p(^||InitiInclb(Inclb),"^",2)
	.s FirstIniti=$p(^||InitiInclb(Inclb),"^",3)
	.s Ch=$p(FirstIniti,"||",2)
	.s Rp=$p(^DHCINIT(Init,"ITI",Ch),"^",15)
	.s Sp=$p(^DHCINIT(Init,"ITI",Ch),"^",17)
	.s RpAmt=Rp*Qty
	.s SpAmt=Sp*Qty
	.s UomDesc=""
	.s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
	.s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	.s BatExpInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s BatNo=$p(BatExpInfo,"^",1)
	.s ExpDate=$p(BatExpInfo,"^",2)
	.s BatExp=BatNo_"~"_ExpDate 
	.s InciId=+Inclb
	.s Incil=$p(Inclb,"||",1,2)
	.s InciCode=$P(^INCI(InciId,1),"^",1)
	.s InciDesc=$P(^INCI(InciId,1),"^",2)
	.s BarCode=$p(^INCI(InciId,3),"^",9)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(InciId)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	.s ManfId=$P(ManfInfo,"^",1)
	.s ManfDesc=$P(ManfInfo,"^",2)
	.s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	.s VendorId=$p(VendorInfo,"^",1)
	.s VendorDesc=$p(VendorInfo,"^",2)
	.s SterilizedBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb(Inclb)
	.s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom(Inclb,UomId,+$h)		;当前库存
	.s InclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,UomId)	;当前占用库存
	.s InclbAvaQty=InclbQty-InclbDirtyQty			;当前可用库存
	.s DirtyQty=0
	.
	.i (Status'=21)!(Status'=31) s DirtyQty=Qty		;本次占用数量
	.s ReqLocStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciId,ReqLocId,UomId,+$h)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s AllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(ProLocId,InciId,UomId) ;取物资库存项当前可用库存
	.s AllDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurIncResQty(Incil,UomId) ;取物资库存项当前占用库存
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	.s Incsc=$p(^INCI(InciId,2),"^",2)
	.s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
	.s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId),"^",6)
	.s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(InciId)
	.s CertNo=$p(CertInfo,"^",1)	
	.s BarCodeInfo=..GetStartEndBarCode(Init,Inclb)
	.s StartBarCode=$p(BarCodeInfo,"^",1)
	.s EndBarCode=$p(BarCodeInfo,"^",2)
	.s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(InciId,HospId)
	.s MatInsuCode=$p(MatInsuInfo,"^",1)
	.s MatInsuDesc=$p(MatInsuInfo,"^",2)
	.d OutPutSumRow
	Quit $$$OK
OutPutSumRow
	s Data=$lb(RowId,Inclb,InciId,InciCode,InciDesc,
		Spec,SpecDesc,UomId,UomDesc,Qty,
		Rp,RpAmt,Sp,SpAmt,Status,
		VendorId,VendorDesc,ManfId,ManfDesc,InclbQty,
		InclbDirtyQty,InclbAvaQty,ReqLocStkQty,BUomId,ConFac,
		BatExp,DirtyQty,HVFlag,HVBarCode,BarCode,
		AllAvaQty,IncscDesc,IncscType,AllDirtyQty,
		SterilizedBat,Model,MatInsuCode,MatInsuDesc,BatNo,
		ExpDate,CertNo,StartBarCode,EndBarCode
		)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:zhangdongmei
/// CreatDate:2012-07-24
/// Description:按效期优先的规则匹配本次出库批次
/// Table:inc_itmlcbt
/// Input:科室id,库存项id,数量,出类型
/// Return:
ClassMethod GetInclbForTransfer(LocId As %String, IncId As %String, Qty As %String, OutType As %String = "", SpecDesc As %String = "") As %Library.String
{
	n (LocId,IncId,Qty,OutType,SpecDesc)
	i $g(OutType)="" s OutType="0"  //缺省使用效期先后做出库顺序
	q:'$d(^INCI("IL_LOC",LocId,IncId)) ""
	s Pid=..NewPid()
	k ^TMPGETINCLB(Pid),^DHCTMPYFINCLB(Pid)
	s NewQty=Qty
	s IL=$o(^INCI("IL_LOC",LocId,IncId,""))
	s Today=+$h
	s LB=0
	f  s LB=$o(^INCI(IncId,"IL",IL,"LB",LB)) q:LB=""  d
	.s Inclb=IncId_"||"_IL_"||"_LB
	.s Incib=""
	.s Incib=$P(^INCI(IncId,"IL",IL,"LB",LB),"^",1)
	.s Chl=$p(Incib,"||",2)
	.s ExpDays=0      ;失效天数
	.s ExpDate=+$p(^INCI(IncId,"IB",Chl),"^",2)
	.i ExpDate=0  d
	..s ExpDate=+$h+500
	.i ExpDate=+$h  s ExpDays=1
	.e  s ExpDays=ExpDate-(+$h)
	.
	.s IncQty=##CLASS(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Today)
	.s ResQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,"")
	.s AvaQty= ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,"")
	.q:AvaQty'>0
	.s BatNo=$p(^INCI(IncId,"IB",Chl),"^",1)
	.s ExpDate=$p(^INCI(IncId,"IB",Chl),"^",2)
	.s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	.s RecallFlag=$p(^INCI(IncId,"IB",Chl),"^",3)
	.q:RecallFlag="Y"   //批次锁定的不做出库单
	.s InclbSpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	.s Data=BatNo_"^"_IncQty_"^"_ExpDate_"^"_Inclb_"^"_ResQty_"^"_AvaQty
	.
	.i $g(OutType)="1" d   //先进先出
	..s Sub=..GetClbDate(Incib)
	.e  i $g(OutType)="0" d  //效期先后
	..s Sub=ExpDays
	.
	.;2017-12-27 若具体规格不一致,则往后排
	.;(以保证具体规格对应的批次库存不足时,能取其他批次的数据)
	.i (SpecDesc'="")&&(InclbSpecDesc'=SpecDesc) d
	..s Sub=ExpDays+9999900000		;这里是根据GetClbDate的格式确定的
	.
	.s ^DHCTMPYFINCLB(Pid,Sub,Inclb)=Data
	.
	;
	s Sub=""
	f  s Sub=$o(^DHCTMPYFINCLB(Pid,Sub)) q:(Sub="")!(NewQty=0)  d
	.s Inclb=""
	.f  s Inclb=$o(^DHCTMPYFINCLB(Pid,Sub,Inclb)) q:(Inclb="")!(NewQty=0)  d
	..s Data=^DHCTMPYFINCLB(Pid,Sub,Inclb)
	..s ^TMPGETINCLB(Pid,Inclb)=Data
	..s AvaQty=$p(Data,"^",6)
	..q:AvaQty<=0
	..i AvaQty'<NewQty  d
	...s $p(^TMPGETINCLB(Pid,Inclb),"^",7)=NewQty    ;批次转移数量
	...s NewQty=0  
	..e  d
	...s $p(^TMPGETINCLB(Pid,Inclb),"^",7)=AvaQty    ;批次转移数量                                       
	...s NewQty=NewQty-AvaQty
	..
	.
	k ^DHCTMPYFINCLB(Pid)
	q Pid
}

/// 2016-04-14 高值根据请求单出库简单改造(^TMPGETINCLB直接赋值,^DHCTMPYFINCLB)
/// Creator:zhangdongmei
/// CreatDate:2012-07-24
/// Description:按效期优先的规则匹配本次出库批次
/// Table:inc_itmlcbt
/// Input:科室id,库存项id,数量,出类型(0:按效期,1:按批次入库日期)
/// Return:
ClassMethod GetInclbForTransferForHV(LocId As %String, IncId As %String, Qty As %String, OutType As %String = "", SpecDesc As %String = "") As %Library.String
{
	n (LocId,IncId,Qty,OutType,SpecDesc)
	i $g(OutType)="" s OutType="0"  //缺省使用效期先后做出库顺序
	q:'$d(^INCI("IL_LOC",LocId,IncId)) ""
	s Pid=..NewPid()
	k ^DHCTMPYFINCLB(Pid),^TMPGETINCLB(Pid)
	s Today=+$h
	s IL=$o(^INCI("IL_LOC",LocId,IncId,""))
	s LB=0
	f  s LB=$o(^INCI(IncId,"IL",IL,"LB",LB)) q:LB=""  d
	.s Inclb=IncId_"||"_IL_"||"_LB
	.s Incib=""
	.s Incib=$P(^INCI(IncId,"IL",IL,"LB",LB),"^",1)
	.s Chl=$p(Incib,"||",2)
	.s ExpDays=0      ;失效天数
	.s ExpDate=+$p(^INCI(IncId,"IB",Chl),"^",2)
	.i ExpDate=0  d
	..s ExpDate=+$h+500
	.i ExpDate=+$h  s ExpDays=1
	.e  s ExpDays=ExpDate-(+$h)
	.
	.s IncQty=##CLASS(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Today)
	.s ResQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,"")
	.s AvaQty= ##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,"")
	.q:AvaQty'>0
	.s BatNo=$p(^INCI(IncId,"IB",Chl),"^",1)
	.s ExpDate=$p(^INCI(IncId,"IB",Chl),"^",2)
	.s:ExpDate'="" ExpDate=$zd(ExpDate,3)
	.s InclbSpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	.s Data=BatNo_"^"_IncQty_"^"_ExpDate_"^"_Inclb_"^"_ResQty_"^"_AvaQty
	.
	.i $g(OutType)="1" d   //先进先出
	..s Sub=..GetClbDate(Incib)
	.e  i $g(OutType)="0" d  //效期先后
	..s Sub=ExpDays
	.
	.;2017-12-27 若具体规格不一致,则往后排
	.;(以保证具体规格对应的批次库存不足时,能取其他批次的数据)
	.i (SpecDesc'="")&&(InclbSpecDesc'=SpecDesc) d
	..s Sub=ExpDays+9999900000		;这里是根据GetClbDate的格式确定的
	.
	.s ^DHCTMPYFINCLB(Pid,Sub,Inclb)=Data
	.
	;
	s Sub=""
	f  s Sub=$o(^DHCTMPYFINCLB(Pid,Sub)) q:(Sub="")  d
	.s Inclb=""
	.f  s Inclb=$o(^DHCTMPYFINCLB(Pid,Sub,Inclb)) q:(Inclb="")  d
	..s Data=^DHCTMPYFINCLB(Pid,Sub,Inclb)
	..s ^TMPGETINCLB(Pid,Sub,Inclb)=Data

	k ^DHCTMPYFINCLB(Pid)
	q Pid
}

/// Descript:	验证库存转移明细数据是否正确
/// Creator:	wangjiabin
/// CreateDate:	2018-07-05
/// Input:		明细id,批次id^数量^单位(供保存验证调用)
/// Output:		"":数据验证通过, 非空:验证不通过信息
ClassMethod CheckTransferDetail(Initi As %String, ListData As %String = "") As %Library.String
{
	n (Initi,ListData)
	q:(Initi="")&(ListData="") ""
	s DirtyQty=0
	;原保存数据
	s (Inclb,UomId,Status)=""
	s Qty=0
	i Initi'="" d
	.s Init=+Initi
	.s Chl=$p(Initi,"||",2)
	.q:'$d(^DHCINIT(Init,"ITI",Chl))
	.s initinfo=^DHCINIT(Init,"ITI",Chl)
	.s Inclb=$p(initinfo,"^",3)
	.s Qty=$p(initinfo,"^",1)
	.s UomId=$p(initinfo,"^",7)
	.s Status=$p(initinfo,"^",23)
	.i (Status'=21)&(Status'=31)  d    ;本张单据的占用数量
	..s DirtyQty=Qty
	
	;新数据
	i ListData'=""  d
	.s Inclb=$p(ListData,"^",1)
	.s Qty=$p(ListData,"^",2)
	.s UomId=$p(ListData,"^",3)
	.i (Status'=21)&(Status'=31)  d    ;本张单据的占用数量
	..s DirtyQty=Qty
	
	s AppCode=##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName")
	s KeyValue=Initi
	s Inci=+Inclb
	s:Inci'="" KeyValue=$p(^INCI(Inci,1),"^",2)

	s ret=0,ErrInfo=""
	i +Inclb'>0  d
	.s ErrInfo="库存转移批次为空"
	q:ErrInfo'="" ErrInfo

	i +Qty'>0  d
	.s ErrInfo="库存转移数量小于等于0"
	q:ErrInfo'="" ErrInfo

	i +UomId'>0  d
	.s ErrInfo="库存转移单位为空"
	q:ErrInfo'="" ErrInfo

	s BUomId=$p(^INCI(Inci,1),"^",10)
	i +BUomId'>0  d
	.s ErrInfo="转移项目基本单位为空"
	q:ErrInfo'="" ErrInfo

	s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	i +Fac=0  d
	.s ErrInfo="转移项目出库单位和基本单位不存在转换关系"
	q:ErrInfo'="" ErrInfo

	s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Inclb,UomId)
	s LeftQty=AvaQty+DirtyQty-Qty
	i LeftQty<0 d
	.s ErrInfo="可用库存不足"
	q:ErrInfo'="" ErrInfo

	q ""
}

/// Descript:	检索科室所有符合条件的批次
/// Creator:	lxt
/// CreateDate:	2019-04-08
/// Table:		inc_itmlcbt
/// Input:		StrParam(科室^类组^不可用是否显示^零库存要求^UserId)
/// Return：	科室批次信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","QueryInclbDetail","{""FrLoc"":""153"",""QtyFlag"":""1"",""NotUseFlag"":""N"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
Query QueryInclbDetail(Params As %String) As Query(ROWSPEC = "RowId,Inclb,InciId,InciCode,InciDesc,Spec,ManfId,ManfDesc,InclbQty:%Float,UomId,UomDesc,Rp:%Float,Sp:%Float,StkBin,BatExp,ReqLocStkQty:%Float,ConFac:%Float,BUomId,InclbDirtyQty:%Float,InclbAvaQty:%Float,HVFlag,ReqLocStkQty:%Float,ReqQty:%Float,Rerqi") [ SqlProc ]
{
}

ClassMethod QueryInclbDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s pFrLocId=PJObj.%Get("FrLoc")
	s pStkScgId=PJObj.%Get("StkScg")
	s pNotUseFlag=PJObj.%Get("NotUseFlag")
	s pQtyFlag=PJObj.%Get("QtyFlag")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	
	s type=..sssCode()
	s HospId=..sssHospId(pFrLocId)
	s:HospId="" HospId=gHospId
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,pFrLocId,pStkScgId,HospId)
		
	s InciId=0
	f  s InciId=$o(^INCI("IL_LOC",pFrLocId,InciId)) q:InciId=""  d
	.s IL=$o(^INCI("IL_LOC",pFrLocId,InciId,0))
	.q:IL=""
	.s Incil=InciId_"||"_IL
	.s LB=0
	.f  s LB=$o(^INCI(InciId,"IL",IL,"LB",LB)) q:LB=""  d
	..s Inclb=Incil_"||"_LB
	..s Incib=$p(^INCI(InciId,"IL",IL,"LB",LB),"^",1)
	..s NotUseFlag=$P(^INCI(InciId,2),"^",9)
	..i NotUseFlag="" s NotUseFlag="N"
	..q:(pNotUseFlag'="")&&(pNotUseFlag'=NotUseFlag)
	..s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	..s StkType=$p(ScgInfo,"^",3)
	..q:StkType'=type
	..s ScgId=$p(ScgInfo,"^",5)
	..q:(StkGrpStr'="")&&(ScgId'="")&&(("^"_StkGrpStr_"^")'[("^"_ScgId_"^"))
	..s InciCode=$P(^INCI(InciId,1),"^",1)             //代码
	..s InciDesc=$P(^INCI(InciId,1),"^",2)             //名称
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	..s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
	..s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	..s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	..s BatExp = BatNo_"~"_ExpDate
	..s ManfStr = ##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	..s ManfId=$P(ManfStr,"^",1)
	..s ManfDesc=$P(ManfStr,"^",2)
	..s (BUomDesc,PurUomDesc)=""
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	..s PurUomId=$p(^INCI(InciId,3),"^",6)
	..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	..s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(+PurUomId,+BUomId)
	..s InclbQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,PurUomId)
	..q:(pQtyFlag=1)&(InclbQty<=0)
	..S InitQty = 0
	..s Date=+$H
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,PurUomId,gHospId)
	..s Rp = ##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,PurUomId,gHospId)
	..s StkBinStr=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(pFrLocId,InciId)
	..s StkBin=$p(StkBinStr,"^",1)
	..s InclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,PurUomId)
	..s InclbAvaQty = InclbQty - InclbDirtyQty
	..s SupplyStockQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciId,pFrLocId,PurUomId,Date)
	..s (RowId,ReqLocStkQty,ReqQty,Rerqi)=""
	..s UomId=PurUomId,UomDesc=PurUomDesc
	..d OutPutRowInclb
	
	Quit $$$OK
OutPutRowInclb
	s Data=$lb(RowId,Inclb,InciId,InciCode,InciDesc,
			Spec,ManfId,ManfDesc,InclbQty,UomId,
			UomDesc,Rp,Sp,StkBin,BatExp,
			ReqLocStkQty,ConFac,BUomId,InclbDirtyQty,
			InclbAvaQty,HVFlag,ReqQty,Rerqi)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 取出批次的创建日期
/// Date:2015-07-14
/// Created By :zhwh
/// 
/// Arguments:
///  inclb -批次rowid
/// Return:
///   
ClassMethod GetClbDate(incib) As %String
{
   n (incib)
   s (d,t)=""
   &sql(SELECT incib_dateadd,incib_timeadd into :d,:t  FROM dhc_incitmbat WHERE INCIB_INCIB_DR=:incib)	
   i d="" s d=+$h-500
   i t=""  s t=1
   s str=$tr($j(d,5)_$j(t,5)," ","0")	
   q str
}

/// Description:检索库存转移单的明细数据吗(适用于高值)
/// Author:		wangjiabin
/// Date:		2015-07-21
/// Argu:		init -库存转移单主表rowid
///  
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","DHCINIsTrfDetail",191) 
Query DHCINIsTrfDetail(init As %String) As Query(ROWSPEC = "initi,inclb,inci,inciCode,inciDesc,spec,manf,manfName,uom,qty:%Float,inrqi,rp:%Float,rpAmt:%Float,pp:%Float,ppAmt:%Float,sp:%Float,spAmt:%Float,newSp:%Float,newSpAmt:%Float,status,remark,stkbin,inclbQty:%Float,inclbDirtyQty:%Float,inclbAvaQty:%Float,reqLocStkQty:%Float,BUomId,ConFac:%Float,reqQty:%Float,batexp,TrUomDesc,dirtyQty:%Float,HVFlag,HVBarCode,BarCode,AllAvaQty:%Float,SpecDesc,IncscDesc,IncscType") [ SqlProc ]
{
}

ClassMethod DHCINIsTrfDetailExecute(ByRef qHandle As %Binary, init As %String) As %Status
{
	n (qHandle,init)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:init="" $$$OK
	s sql= "select %ID initi,"
	s sql=sql_"initi_inclb_dr inclb,"
	s sql=sql_"initi_inclb_dr->inclb_incib_dr->incib_no batNo,"
	s sql=sql_"initi_inclb_dr->inclb_incib_dr->incib_expdate expDate,"
	s sql=sql_"initi_ctuom_dr uom,"
	s sql=sql_"initi_qty qty,"
	s sql=sql_"initi_inrqi_dr  inrqi,"
	s sql=sql_"dhciti_realprice rp,"
	s sql=sql_"dhciti_rpamount rpAmt,"
	s sql=sql_"dhciti_purprice pp,"
	s sql=sql_"dhciti_ppamount ppAmt,"
	s sql=sql_"dhciti_saleprice sp,"
	s sql=sql_"dhciti_spamount spAmt,"
	s sql=sql_"dhciti_newsp newSp,"
	s sql=sql_"dhciti_newspamt newSpAmt,"
	s sql=sql_"dhciti_state status,"
	s sql=sql_"dhciti_remark remark"
	s sql=sql_" from dhc_inistrfitm"
	s sql=sql_" where initi_init_parref="_init
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	if $$$ISERR(sc) q $$$OK
	while(xrs.Next())
	{
		s initi=xrs.Data("initi")
		s inclb=xrs.Data("inclb")
		s uom=xrs.Data("uom")
		s uomDesc=""
		s:uom'="" uomDesc=$p(^CT("UOM",uom),"^",2)
		s qty=xrs.Data("qty")
		s inrqi=xrs.Data("inrqi")
		s rp=xrs.Data("rp")
		s rpAmt=xrs.Data("rpAmt")
		s pp=xrs.Data("pp")
		s ppAmt=xrs.Data("ppAmt")
		s sp=xrs.Data("sp")
		s spAmt=xrs.Data("spAmt")
		s newSp=xrs.Data("newSp")
		s newSpAmt=xrs.Data("newSpAmt")
		s status=xrs.Data("status")
		s remark=xrs.Data("remark")

		s batNo=xrs.Data("batNo")
		s expDate=xrs.Data("expDate")
		i ((expDate'="")&&(expDate'["-")) d	;防止润乾报表在sql中将日期转换为Y-m-d格式造成的打印错误
		.s expDate=..DL2H(expDate)

		s batexp=batNo_"~"_expDate 
		s inci=+inclb
		s inciCode=$P(^INCI(inci,1),"^",1)
		s inciDesc=$P(^INCI(inci,1),"^",2)
		s BarCode=$p(^INCI(inci,3),"^",9)
		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		s manfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
		s manf=$P(manfInfo,"^",1)
		s manfName=$P(manfInfo,"^",2)
		
		s proLocId=$p(^DHCINIT(+initi),"^",5)
		s reqLocId=$p(^DHCINIT(+initi),"^",6)
		s initDate=$p(^DHCINIT(+initi),"^",2)
		s stkbin=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(proLocId,inci)
		s stkbin=$p(stkbin,"^",1)
		s inclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom(inclb,uom,+$h)  ;当前库存
		s inclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(inclb,uom)  ;当前占用库存
		s inclbAvaQty=inclbQty-inclbDirtyQty   ;当前可用库存
		s dirtyQty=0
		s status=$p(^DHCINIT(init),"^",14)
		i (status'=21)!(status'=31) s dirtyQty=qty   ;本次占用数量
		s reqLocStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(inci, reqLocId, uom, +$h)
		s BUomId=$p(^INCI(inci,1),"^",10)
		s PurUomId=$p(^INCI(inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s AllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(proLocId,inci,uom) ;取物资当前可用库存
		s reqQty=""
		i inrqi'=""  d
		.s reqQty=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",3)
		.s reqUom=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",5)
		.s fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(reqUom,BUomId)
		.s fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,BUomId)
		.s reqQty=reqQty*fac1/fac2
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
		s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("T",initi)
		;根据barcode状态,进行过滤
		s HVEnableFlag=..GetInitiHVEnable(initi)
		continue:(HVFlag="Y")&&(HVEnableFlag'="Y")
		s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(inclb)
		s Incsc=$p(^INCI(inci,2),"^",2)
		s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
		s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",6)
		d OutPurRowHV
	}
	Quit $$$OK

OutPurRowHV
	s Data=$lb(initi,inclb,inci,inciCode,inciDesc,spec,manf,manfName,uom,qty,
		inrqi,rp,rpAmt,pp,ppAmt,sp,spAmt,newSp,newSpAmt,status,
		remark,stkbin,inclbQty,inclbDirtyQty,inclbAvaQty,reqLocStkQty,BUomId,ConFac,reqQty,batexp,
		uomDesc,dirtyQty,HVFlag,HVBarCode,BarCode,AllAvaQty,SpecDesc,IncscDesc,IncscType)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	根据ingri获取高值条码,高值补录的按dhc_hvmat_orditm取值
/// 			ps:仅适用于显示
/// Creator:	wangjiabin
/// CreateDate:	2016-07-25
/// Input:		出库子表id
/// Output:		高值条码^dhcit
/// w ##class(web.DHCSTMHUI.DHCINIsTrfItm).GetHVBarCode("6531||1")
ClassMethod GetHVBarCode(Initi) As %String [ Private ]
{
	n (Initi)
	q:Initi="" ""
	s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr("T",Initi)
	;实库补录的数据,dhc_itmtrackdetail未记录,通过dhc_hvmat_orditm取值
	s hvm=""
	i HVBarCode="" d
	.;INITI_INGRI_DR
	.s Ingri=$p(^DHCINIT(+Initi,"ITI",$p(Initi,"||",2)),"^",26)
	.s:Ingri'="" hvm=$o(^DHCHVMORI(0,"INGRIModify",Ingri,0))
	.q:hvm'=""
	.;DHCITI_Remark(补录时记录ingri)
	.s Ingri=$p(^DHCINIT(+Initi,"ITI",$p(Initi,"||",2)),"^",24)
	.s:Ingri'="" hvm=$o(^DHCHVMORI(0,"INGRIModify",Ingri,0))
	
	s:hvm'="" HVBarCode=$p(^DHCHVMORI(hvm,1),"^",24)
	
	;撤销记录
	i HVBarCode="" d
	.s hcitdid=""
	.s stype="ST"
	.&sql(SELECT DHCITDA_DHCITD_DR INTO:dhcitdid FROM DHC_ItmTrackDetail_Addion WHERE DHCITDA_Pointer=:Initi AND DHCITDA_Type=:stype)
	.q:SQLCODE
	.s dhcitid=""
	.&sql(SELECT DHCITD_Parref into:dhcitid FROM DHC_ItmTrackDetail WHERE DHCITD_Rowid=:dhcitdid)
	.q:SQLCODE
	.q:'$d(^DHCIT(dhcitid))
	.s HVBarCode=$p(^DHCIT(dhcitid),"^",2)
	s dhcit="",OriginalStatus=""
	i HVBarCode'="" d
	.s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	.s:dhcit'="" OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	
	q HVBarCode_"^"_dhcit_"^"_OriginalStatus
}

/// 检索已接收库存转移单(inclb等信息按接收方取值)
/// Author:	wangjiabin
/// Date:	2017-07-16
/// Argu:
///  init -库存转移单主表rowid
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","InitToLocDetail",196)
Query InitToLocDetail(Init As %String) As Query(ROWSPEC = "RowId,Inclb,Inci,InciCode,InciDesc,Spec,SpecDesc,UomId,UomDesc,Qty:%Float,Rp:%Float,RpAmt:%Float,Pp:%Float,PpAmt:%Float,Sp:%Float,SpAmt:%Float,NewSp:%Float,NewSpAmt:%Float,Status,VendorId,VendorDesc,ManfId,ManfDesc,Remark,Stkbin,InclbQty,InclbDirtyQty,InclbAvaQty,ReqLocStkQty,BUomId,ConFac,BatExp,DirtyQty,HVFlag,HVBarCode,BarCode,AllAvaQty,IncscDesc,IncscType,Inrqi,ReqQty:%Float,Reqmark,QtyApproved,AllDirtyQty,dhcit,SterilizedBat,CheckFlag,IntrStkQty:%Float") [ SqlProc ]
{
}

ClassMethod InitToLocDetailExecute(ByRef qHandle As %Binary, Init As %String) As %Status
{
	n (qHandle,Init)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Init="" $$$OK
	
	;不是已接收状态的,不检索明细
	s InitStatus=$p(^DHCINIT(Init),"^",14)
	q:InitStatus'="31" $$$OK
	
	s sql="select %ID RowId,"
		_"initi_inclb_dr Inclb,"
		_"initi_ctuom_dr UomId,"
		_"initi_qty Qty,"
		_"initi_inrqi_dr Inrqi,"
		_"dhciti_realprice Rp,"
		_"dhciti_rpamount RpAmt,"
		_"dhciti_purprice Pp,"
		_"dhciti_ppamount PpAmt,"
		_"dhciti_saleprice Sp,"
		_"dhciti_spamount SpAmt,"
		_"dhciti_newsp NewSp,"
		_"dhciti_newspamt NewSpAmt,"
		_"dhciti_state Status,"
		_"INITI_UserAck_DR UserAck,"
		_"dhciti_remark Remark"
		_" from dhc_inistrfitm"
		_" where initi_init_parref="_Init
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	if $$$ISERR(sc) q $$$OK
	while(xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Init=+RowId
		;2016-07-27 inclb按接收科室取值
		s Intr=$o(^DHCINTR(0,"TypePointer","K",RowId,0))
		continue:Intr=""
		s Inclb=$p(^DHCINTR(Intr),"^",7)
		continue:Inclb=""
		
		s UomId=xrs.Data("UomId")
		s UomDesc=""
		s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
		s Qty=xrs.Data("Qty")
		s Inrqi=xrs.Data("Inrqi")
		s Rp=xrs.Data("Rp")
		s RpAmt=xrs.Data("RpAmt")
		s Pp=xrs.Data("Pp")
		s PpAmt=xrs.Data("PpAmt")
		s Sp=xrs.Data("Sp")
		s SpAmt=xrs.Data("SpAmt")
		s NewSp=xrs.Data("NewSp")
		s NewSpAmt=xrs.Data("NewSpAmt")
		s Status=xrs.Data("Status")
		s Remark=xrs.Data("Remark")
		s UserAck=xrs.Data("UserAck")
		s CheckFlag="N"
		s:+UserAck>0 CheckFlag="Y"
		s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
		s BatExpInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
		s BatNo=$p(BatExpInfo,"^",1)
		s ExpDate=$p(BatExpInfo,"^",2)
		s BatExp=BatNo_"~"_ExpDate 
		s Inci=+Inclb
		s Incil=$p(Inclb,"||",1,2)
		s InciCode=$P(^INCI(Inci,1),"^",1)
		s InciDesc=$P(^INCI(Inci,1),"^",2)
		s BarCode=$p(^INCI(Inci,3),"^",9)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
		s ManfId=$P(ManfInfo,"^",1)
		s ManfDesc=$P(ManfInfo,"^",2)
		s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
		s VendorId=$p(VendorInfo,"^",1)
		s VendorDesc=$p(VendorInfo,"^",2)
		s SterilizedBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb(Inclb)
		
		s InitDate=$p(^DHCINIT(Init),"^",2)
		s ProLocId=$p(^DHCINIT(Init),"^",5)
		s ReqLocId=$p(^DHCINIT(Init),"^",6)
		
		s StkBinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(ProLocId,Inci)
		s StkBin=$p(StkBinInfo,"^",1)
		s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom(Inclb,UomId,+$h)		;当前库存
		s InclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,UomId)	;当前占用库存
		s InclbAvaQty=InclbQty-InclbDirtyQty			;当前可用库存
		s DirtyQty=0
		s Status=$p(^DHCINIT(Init),"^",14)
		i (Status'=21)!(Status'=31) s DirtyQty=Qty		;本次占用数量
		s ReqLocStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(Inci,ReqLocId,UomId,+$h)
		s BUomId=$p(^INCI(Inci,1),"^",10)
		s PurUomId=$p(^INCI(Inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s AllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(ProLocId,Inci,UomId) ;取物资库存项当前可用库存
		s AllDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurIncResQty(Incil,UomId) ;取物资库存项当前占用库存
		
		s (ReqQty,ReqRemark,QtyApproved)=""
		i Inrqi'=""  d
		.s ReqQty=$p(^INRQ(+Inrqi,"RQI",$p(Inrqi,"||",2)),"^",3)
		.s ReqUom=$p(^INRQ(+Inrqi,"RQI",$p(Inrqi,"||",2)),"^",5)
		.s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ReqUom,BUomId)
		.s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		.s ReqQty=ReqQty*Fac1/Fac2
		.s DhcInrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,""))
		.s Reqmark=$s(DhcInrqi'="":$p(^DHCINRQI(DhcInrqi),"^",2),1:"") //请求明细中备注   
		.s QtyApproved=$s(DhcInrqi'="":$p(^DHCINRQI(DhcInrqi),"^",3),1:"")
		
		s HVBarCodeInfo=..GetHVBarCode(RowId)
		s HVBarCode=$p(HVBarCodeInfo,"^",1),dhcit=$p(HVBarCodeInfo,"^",2)
		s Incsc=$p(^INCI(Inci,2),"^",2)
		s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
		s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci),"^",6)
		s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty("K",RowId)
		s IntrStkQty=IntrStkQtyB/ConFac
		d OutPutInitiRow
	}

	Quit $$$OK
OutPutInitiRow
	s Data=$lb(RowId,Inclb,Inci,InciCode,InciDesc,
		Spec,SpecDesc,UomId,UomDesc,Qty,
		Rp,RpAmt,Pp,PpAmt,Sp,
		SpAmt,NewSp,NewSpAmt,Status,VendorId,
		VendorDesc,ManfId,ManfDesc,Remark,Stkbin,
		InclbQty,InclbDirtyQty,InclbAvaQty,ReqLocStkQty,BUomId,
		ConFac,BatExp,DirtyQty,HVFlag,HVBarCode,
		BarCode,AllAvaQty,IncscDesc,IncscType,Inrqi,
		ReqQty,Reqmark,QtyApproved,AllDirtyQty,dhcit,
		SterilizedBat,CheckFlag,IntrStkQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 在DHCINIsTrfDetail中有调用,其他位置调用前请留意用途
/// Y:该条可处理, N:不可处理
/// w ##class(web.DHCSTMHUI.DHCINIsTrfItm).GetInitiHVEnable("7573||1")
ClassMethod GetInitiHVEnable(initi As %String) As %String
{
	n (initi)
	s ret="N"
	;根据barcode状态,进行过滤
	s dhcit=$o(^DHCITD(0,"Type","T","Pointer",initi,0))
	q:dhcit="" ret
	s (dhcitInclb,dhcitCurrLoc,dhcitStatus,dhcitdType,isLastAudit)=""
	i dhcit'="" d
	.s dhcitStatus=$p(^DHCIT(dhcit),"^",5)
	.s dhcitInclb=$p(^DHCIT(dhcit),"^",12)
	.s:dhcitInclb'="" dhcitCurrLoc=$p(^INCI(+dhcitInclb,"IL",$p(dhcitInclb,"||",2)),"^",1)
	.s lastCh=$o(^DHCITD(dhcit,"I",""),-1)
	.q:lastCh=""
	.s dhcitdType=$p(^DHCITD(dhcit,"I",lastCh),"^",2)
	.s dhcitd=dhcit_"||"_lastCh
	.s lastAuditInfo=##class(web.DHCSTMHUI.DHCItmTrack).IsDetailAudit(dhcitd)
	.s isLastAudit=$p(lastAuditInfo,"^",1)
	.;不可用,已出库,最后明细未审核等情况, 均过滤
	.q:(dhcitStatus'="Enable")||(dhcitdType="T")||(isLastAudit="N")
	.s init=$p(initi,"||",1)
	.s InitToLoc=$p(^DHCINIT(init),"^",6)
	.;条码当前科室不是init_toloc_dr的过滤
	.q:(dhcitCurrLoc'=InitToLoc)
	.
	.s ret="Y"
	
	q ret
}

/// Description:(独立出来)检索库存转移请求单明细记录
/// Creator:	wangjiabin
/// CreateDate:	2018-06-15
/// Input:		Req(请求单rowid), ShowTransferedFlag(是否显示转移完成明细:1显示,0不显示), RefuseFlag(是否显示已拒绝明细:1显示,0不显示), StrParam(UserId^...)
/// Output:		
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","INReqD","59,60","{}")
Query INReqD(Req As %String, Params As %String) As Query(ROWSPEC = "RowId,Inci,InciCode,InciDesc,Qty:%Float,Uom,UomDesc,Spec,Manf,Sp:%Float,SpAmt:%Float,Remark,TransQty:%Float,NotTransQty:%Float,BUomId,ConFac:%Float,StkQty:%Float,Rp:%Float,RpAmt:%Float,QtyApproved,RpAmtApproved,SpAmtApproved,InciRemarks,RefuseFlag,BUomDesc,SpecDesc,ReqNo,ReqLocDesc,RepLev:%Float,ProvLoc,HVFlag,ZeroStkFlag,INRQIType,INRQICanceled,ReqPuomQty:%Float,ProLocAllAvaQty:%Float,ProvLocId,InciBarCode") [ SqlProc ]
{
}

ClassMethod INReqDExecute(ByRef qHandle As %Binary, Req As %String, Params As %String) As %Status
{
	n (qHandle,Req,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:Req="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pShowTransferedFlag=PJobj.%Get("ShowTransferedFlag")
	s:pShowTransferedFlag="" pShowTransferedFlag=1
	s pRefuseFlag=PJobj.%Get("RefuseFlag")
	s:pRefuseFlag="" pRefuseFlag=0
	s pHandleType=PJobj.%Get("HandleType")
	s pCanceled=PJobj.%Get("Canceled")
	s pHospId=PJobj.%Get("gHospId")
	s pIncludeDefLoc=PJobj.%Get("IncludeDefLoc")
	;s pReqDetailIdStr=PJobj.%Get("ReqDetailIdStr")
	s pSupplyPhaLoc=PJobj.%Get("SupplyPhaLoc")
	s pUserId=PJobj.%Get("gUserId")
	s HospId=..sssHospId(pSupplyPhaLoc)
	s StkGrpList=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(pUserId,..sssCode(),pSupplyPhaLoc,"",HospId)
	
	s sql="select %ID RowId,"
	s sql=sql_" inrqi_inci_dr Inci,"
	s sql=sql_"inrqi_inci_dr->inci_code InciCode,"
	s sql=sql_"inrqi_inci_dr->inci_desc InciDesc,"
	s sql=sql_"inrqi_reqqty Qty,"
	s sql=sql_"inrqi_ctuom_dr Uom,"
	s sql=sql_"inrqi_ctuom_dr->ctuom_desc UomDesc,INRQI_RefuseFlag as RefuseFlag,"
	s sql=sql_"INRQI_INRQ_ParRef->INRQ_No ReqNo,"
	s sql=sql_"INRQI_INRQ_ParRef->INRQ_RecLoc_DR ReqLoc,"
	s sql=sql_"INRQI_INRQ_ParRef->INRQ_RecLoc_DR->Ctloc_Desc ReqLocDesc"
	s sql=sql_" From in_reqitm"
	s sql=sql_" where inrqi_inrq_parref in ("_Req_")"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while(xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s ReqId=$p(RowId,"||",1)
		;continue:(pReqDetailIdStr'="")&&("^"_pReqDetailIdStr_"^"'[ReqitmId)  ;申请单模板里面多选使用lihui20170912
		s (ReqDate,RecLocDR,RequestedLoc,ReqPuomQty)=""
		&sql(select inrq_date,INRQ_ReqLoc_DR,INRQ_RecLoc_DR into :ReqDate,:RequestedLoc,:RecLocDR  from in_request where %ID=:ReqId)
		i pIncludeDefLoc=1 s RequestedLoc=pSupplyPhaLoc   //支配的情况下 供应科室取界面传入科室
		s Inci=xrs.Data("Inci")
		s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
		s ScgId=$p(ScgInfo,"^",5)
		continue:(StkGrpList'="")&&(("^"_StkGrpList_"^")'[("^"_ScgId_"^"))
		
		s InciCode=xrs.Data("InciCode")
		s InciDesc=xrs.Data("InciDesc")
		s Qty=xrs.Data("Qty")
		s Uom=xrs.Data("Uom")
		s UomDesc=xrs.Data("UomDesc")
		s RefuseFlag=xrs.Data("RefuseFlag")
		s ReqNo=xrs.Data("ReqNo")
		s ReqLoc=xrs.Data("ReqLoc")
		s ReqLocDesc=xrs.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		
		s TransQty=##class(web.DHCSTMHUI.DHCINIsTrf).TransQty(RowId)  ;已转移数量(基本单位)
		s BUom=$p(^INCI(Inci,1),"^",10)   ;基本单位
		s BUomDesc=""
		s:BUom'="" BUomDesc=$p(^CT("UOM",BUom),"^",2)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
		s PurUom=$p(^INCI(Inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUom,BUom)
		s TransQty=TransQty/Fac
		
		s InrqiType="",InrqiCanceled="N",Remark="",QtyApproved=TransQty,SpecDesc="",INRQIResQty=""
		s DhcInrqi=$o(^DHCINRQI(0,"INRQI",RowId,""))
		i DhcInrqi'="" d
		.s InrqiType=$p(^DHCINRQI(DhcInrqi),"^",7)
		.s InrqiCanceled=$p(^DHCINRQI(DhcInrqi),"^",8)
		.s Remark=$p(^DHCINRQI(DhcInrqi),"^",2)
		.s QtyApproved=$p(^DHCINRQI(DhcInrqi),"^",3)
		.s SpecDesc=$p(^DHCINRQI(DhcInrqi),"^",6)
		.s INRQIResQty=+$p(^DHCINRQI(DhcInrqi),"^",16)	;根据请求单设置的在途数
		s Type=""
		&sql(SELECT inrq_type
			INTO :Type
			FROM dhc_inrequest
			WHERE INRQ_INRQ_DR=:Req
		)
		continue:(Type="C")&(pHandleType'="")&(pHandleType'=InrqiType)
		continue:(pCanceled'="")&(InrqiCanceled="Y")
		continue:(pRefuseFlag=0)&(RefuseFlag="Y")
		s:RefuseFlag="Y" RefuseFlag="拒绝"
		s:InrqiType=1 InrqiType="采购"
		s:InrqiType=0 InrqiType="出库"
		s InciRemarks=""
		&sql(select inci_remarks into :InciRemarks from inc_itm where inci_rowid=:Inci)
		i $lv(InciRemarks) s InciRemarks=$lts(InciRemarks)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",3)
		i ReqDate="" s ReqDate=+$h
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,ReqDate,Uom,pHospId)
		s SpAmt=Sp*Qty
		s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,Uom,pHospId)
		s RpAmt=Rp*Qty
		s RpAmtApproved=Rp*QtyApproved		//批准进价金额
		s SpAmtApproved=Sp*QtyApproved		//批准售价金额
		
		;按批准数量计算
		s NotTransQty=QtyApproved-TransQty
		continue:(pShowTransferedFlag=0)&(NotTransQty<=0)	;不显示已转移完成的明细
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,RequestedLoc,+$h)	//供应科室库存
		s StkQty=StkQty/Fac
		s ProLocAllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(RequestedLoc,Inci,Uom) ;取供应科室物资库存项当前可用库存
		s ProLocAllAvaQty=ProLocAllAvaQty+INRQIResQty		;不考虑本请求单的在途数
		s ReqBuomQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,RecLocDR,+$h)
		s ReqPuomQty=ReqBuomQty/Fac							;申请科室库存
		s Incil="",RepLev=""
		s Inclb="" 
		i RequestedLoc'=ReqLoc d
		.s RequestedLocxx=RequestedLoc
		e  d
		.s RequestedLocxx=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(Inci,ReqLoc),"^",1)
		s:RequestedLocxx'="" Incil=$o(^INCI("IL_LOC",RequestedLocxx,Inci,""))
		s:Incil'="" RepLev=+$p(^INCI(Inci,"IL",Incil),"^",5)
		s RepLev=$s(RepLev'="":RepLev/ConFac,1:"")
		s ProvLocInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(Inci,ReqLoc)
		s ProvLoc=$p(ProvLocInfo,"^",2)
		s ProvLocId=$p(ProvLocInfo,"^",1)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		s ZeroStkFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetZeroStkFlag(Inci,ProvLoc)
		s InciBarCode=$p(^INCI(Inci,3),"^",9)
		s:InciBarCode="" InciBarCode=InciCode
		d OutPutRow
	}

	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Inci,InciCode,InciDesc,Qty,
		Uom,UomDesc,Spec,Manf,Sp,
		SpAmt,Remark,TransQty,NotTransQty,BUom,
		ConFac,StkQty,Rp,RpAmt,QtyApproved,
		RpAmtApproved,SpAmtApproved,InciRemarks,RefuseFlag,BUomDesc,
		SpecDesc,ReqNo,ReqLocDesc,RepLev,ProvLoc,
		HVFlag,ZeroStkFlag,InrqiType,InrqiCanceled,ReqPuomQty,
		ProLocAllAvaQty,ProvLocId,InciBarCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Input:	initi, sign(1:加在途, 0:减在途)
/// w ##class(web.DHCSTMHUI.DHCINIsTrfItm).HandleTransItmResQty("7587||2",0)
ClassMethod HandleTransItmResQty(initi As %String, sign As %String) As %String
{
	n (initi,sign)
	s obj=##class(User.DHCInIsTrfItm).%OpenId(initi)
	d obj.%Reload()
	s inrqi=obj.INITIINRQIDR
	q:inrqi="" 0	;未关联请求单的,过滤
	
	s inrqi=inrqi.%Id()
	s inclb=obj.INITIINCLBDR.%Id()
	s qty=obj.INITIQty
	s uom=obj.INITICTUOMDR.%Id()
	s buom=$p(^INCI(+inclb,1),"^",10)
	s uomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	i sign="0" s qty=-qty
	s qtyBuom=qty*uomFac
	s ret=##class(web.DHCSTMHUI.INRequest).HandleItmResQty(inrqi,qtyBuom)
	i ret'=0 s err=-1 q err
	q 0
}

/// Descript:	根据库存转移单RowId取得明细信息(合并同单品高值)打印单据用
/// Creator:	lxt
/// CreateDate:	2019-03-29
/// Table:		dhc_inistrfitm
/// Input:		排序，查询条件   
/// Return：	转移单明细
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","QueryHVColDetail","{""Init"":""235"",""InitType"":""T""}")
Query QueryHVColDetail(Params As %String) As Query(ROWSPEC = "InciCode,InciDesc,Spec,SpecDesc,UomDesc,Qty:%Float,Rp:%Float,RpAmt:%Float,Pp:%Float,PpAmt:%Float,Sp:%Float,SpAmt:%Float,NewSp:%Float,NewSpAmt:%Float,Status,VendorDesc,ManfDesc,Remark,StkBin,BatExp,HVFlag,BarCode,IncscDesc,ReqQty:%Float,ReqRemark,QtyApproved:%Float,SterilizedBat,CheckFlag,Model") [ SqlProc ]
{
}

ClassMethod QueryHVColDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Init=PJObj.%Get("Init")
	s InitType=PJObj.%Get("InitType")
	s:InitType="" InitType="T"
	q:Init="" $$$OK
	
	s sql="select %ID RowId,"
		_"initi_inclb_dr Inclb,"
		_"initi_ctuom_dr UomId,"
		_"initi_qty Qty,"
		_"initi_inrqi_dr Inrqi,"
		_"dhciti_realprice Rp,"
		_"dhciti_rpamount RpAmt,"
		_"dhciti_purprice Pp,"
		_"dhciti_ppamount PpAmt,"
		_"dhciti_saleprice Sp,"
		_"dhciti_spamount SpAmt,"
		_"dhciti_newsp NewSp,"
		_"dhciti_newspamt NewSpAmt,"
		_"dhciti_state Status,"
		_"INITI_UserAck_DR UserAck,"
		_"dhciti_remark Remark"
		_" from dhc_inistrfitm"
		_" where initi_init_parref="_Init
	
	k ^TMPINITHVCOLDETAIL
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	if $$$ISERR(sc) q $$$OK
	while(xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s Init=+RowId
		s Inclb=xrs.Data("Inclb")
		s UomId=xrs.Data("UomId")
		s UomDesc=""
		s:UomId'="" UomDesc=$p(^CT("UOM",UomId),"^",2)
		s Qty=xrs.Data("Qty")
		s Inrqi=xrs.Data("Inrqi")
		s Rp=xrs.Data("Rp")
		s RpAmt=xrs.Data("RpAmt")
		s Pp=xrs.Data("Pp")
		s PpAmt=xrs.Data("PpAmt")
		s Sp=xrs.Data("Sp")
		s SpAmt=xrs.Data("SpAmt")
		s NewSp=xrs.Data("NewSp")
		s NewSpAmt=xrs.Data("NewSpAmt")
		s Status=xrs.Data("Status")
		s Remark=xrs.Data("Remark")
		s UserAck=xrs.Data("UserAck")
		s CheckFlag="N"
		s:+UserAck>0 CheckFlag="Y"
		s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
		s BatExpInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
		s BatNo=$p(BatExpInfo,"^",1)
		s ExpDate=$p(BatExpInfo,"^",2)
		s BatExp=BatNo_"~"_ExpDate 
		s InciId=+Inclb
		s Incil=$p(Inclb,"||",1,2)
		s InciCode=$P(^INCI(InciId,1),"^",1)
		s InciDesc=$P(^INCI(InciId,1),"^",2)
		s BarCode=$p(^INCI(InciId,3),"^",9)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(InciId)
		s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
		s ManfId=$P(ManfInfo,"^",1)
		s ManfDesc=$P(ManfInfo,"^",2)
		s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
		s VendorId=$p(VendorInfo,"^",1)
		s VendorDesc=$p(VendorInfo,"^",2)
		s SterilizedBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb(Inclb)
		
		s InitDate=$p(^DHCINIT(Init),"^",2)
		s ProLocId=$p(^DHCINIT(Init),"^",5)
		s ReqLocId=$p(^DHCINIT(Init),"^",6)
		
		s StkBinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(ProLocId,InciId)
		s StkBin=$p(StkBinInfo,"^",1)
		s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom(Inclb,UomId,+$h)		;当前库存
		s InclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,UomId)	;当前占用库存
		s InclbAvaQty=InclbQty-InclbDirtyQty			;当前可用库存
		s DirtyQty=0
		s Status=$p(^DHCINIT(Init),"^",14)
		i (Status'=21)!(Status'=31) s DirtyQty=Qty		;本次占用数量
		s ReqLocStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciId,ReqLocId,UomId,+$h)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s AllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(ProLocId,InciId,UomId) ;取物资库存项当前可用库存
		s AllDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurIncResQty(Incil,UomId) ;取物资库存项当前占用库存
		
		s (ReqQty,ReqRemark,QtyApproved)=""
		i Inrqi'=""  d
		.s ReqQty=$p(^INRQ(+Inrqi,"RQI",$p(Inrqi,"||",2)),"^",3)
		.s ReqUom=$p(^INRQ(+Inrqi,"RQI",$p(Inrqi,"||",2)),"^",5)
		.s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ReqUom,BUomId)
		.s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		.s ReqQty=ReqQty*Fac1/Fac2
		.s DhcInrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,""))
		.s Reqmark=$s(DhcInrqi'="":$p(^DHCINRQI(DhcInrqi),"^",2),1:"") //请求明细中备注   
		.s QtyApproved=$s(DhcInrqi'="":$p(^DHCINRQI(DhcInrqi),"^",3),1:"")
		
		s HVBarCodeInfo=..GetHVBarCode(RowId)
		s HVBarCode=$p(HVBarCodeInfo,"^",1),dhcit=$p(HVBarCodeInfo,"^",2)
		s Incsc=$p(^INCI(InciId,2),"^",2)
		s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
		s IncscType=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId),"^",6)
		s IntrStkQtyB=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIntrStkQty(InitType,RowId)
		s IntrStkQty=IntrStkQtyB/ConFac
		
		i '$d(^TMPINITHVCOLDETAIL(InciId))  d
        .s Data1=InciCode_"^"_InciDesc_"^"_Spec_"^"_SpecDesc_"^"_UomDesc
        .s Data2=Qty_"^"_Rp_"^"_RpAmt_"^"_Pp_"^"_PpAmt
        .s Data3=Sp_"^"_SpAmt_"^"_NewSp_"^"_NewSpAmt_"^"_Status
		.s Data4=VendorDesc_"^"_ManfDesc_"^"_Remark_"^"_StkBin_"^"_BatExp
		.s Data5=HVFlag_"^"_BarCode_"^"_IncscDesc_"^"_ReqQty_"^"_ReqRemark
		.s Data6=QtyApproved_"^"_SterilizedBat_"^"_CheckFlag_"^"_Model
		.s ^TMPINITHVCOLDETAIL(InciId)=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
        e  d
        .s TmpQty=$p(^TMPINITHVCOLDETAIL(InciId),"^",6)+Qty
        .s TmpRpAmt=$p(^TMPINITHVCOLDETAIL(InciId),"^",8)+RpAmt
        .s TmpPpAmt=$p(^TMPINITHVCOLDETAIL(InciId),"^",10)+PpAmt
        .s TmpSpAmt=$p(^TMPINITHVCOLDETAIL(InciId),"^",12)+SpAmt
        .s TmpNewSpAmt=$p(^TMPINITHVCOLDETAIL(InciId),"^",14)+NewSpAmt
        .s TmpReqQty=$p(^TMPINITHVCOLDETAIL(InciId),"^",24)+ReqQty
        .s TmpQtyApproved=$p(^TMPINITHVCOLDETAIL(InciId),"^",26)+QtyApproved
        .s $p(^TMPINITHVCOLDETAIL(InciId),"^",6)=TmpQty
        .s $p(^TMPINITHVCOLDETAIL(InciId),"^",8)=TmpRpAmt
        .s $p(^TMPINITHVCOLDETAIL(InciId),"^",10)=TmpPpAmt
        .s $p(^TMPINITHVCOLDETAIL(InciId),"^",12)=TmpSpAmt
        .s $p(^TMPINITHVCOLDETAIL(InciId),"^",14)=TmpNewSpAmt
        .s $p(^TMPINITHVCOLDETAIL(InciId),"^",24)=TmpReqQty
        .s $p(^TMPINITHVCOLDETAIL(InciId),"^",26)=TmpQtyApproved
	}
	s Inci=0
    f  s Inci=$o(^TMPINITHVCOLDETAIL(Inci)) q:(Inci="")  d
    .s InciCode=$p(^TMPINITHVCOLDETAIL(Inci),"^",1)
    .s InciDesc=$p(^TMPINITHVCOLDETAIL(Inci),"^",2)
    .s Spec=$p(^TMPINITHVCOLDETAIL(Inci),"^",3)
    .s SpecDesc=$p(^TMPINITHVCOLDETAIL(Inci),"^",4)
    .s UomDesc=$p(^TMPINITHVCOLDETAIL(Inci),"^",5)
    .
    .s Qty=$p(^TMPINITHVCOLDETAIL(Inci),"^",6)
    .s Rp=$p(^TMPINITHVCOLDETAIL(Inci),"^",7)
    .s RpAmt=$p(^TMPINITHVCOLDETAIL(Inci),"^",8)
    .s Pp=$p(^TMPINITHVCOLDETAIL(Inci),"^",9)
    .s PpAmt=$p(^TMPINITHVCOLDETAIL(Inci),"^",10)
    .
    .s Sp=$p(^TMPINITHVCOLDETAIL(Inci),"^",11)
    .s SpAmt=$p(^TMPINITHVCOLDETAIL(Inci),"^",12)
    .s NewSp=$p(^TMPINITHVCOLDETAIL(Inci),"^",13)
    .s NewSpAmt=$p(^TMPINITHVCOLDETAIL(Inci),"^",14)
    .s Status=$p(^TMPINITHVCOLDETAIL(Inci),"^",15)
    .
    .s VendorDesc=$p(^TMPINITHVCOLDETAIL(Inci),"^",16)
    .s ManfDesc=$p(^TMPINITHVCOLDETAIL(Inci),"^",17)
    .s Remark=$p(^TMPINITHVCOLDETAIL(Inci),"^",18)
    .s StkBin=$p(^TMPINITHVCOLDETAIL(Inci),"^",19)
    .s BatExp=$p(^TMPINITHVCOLDETAIL(Inci),"^",20)
    .
    .s HVFlag=$p(^TMPINITHVCOLDETAIL(Inci),"^",21)
    .s BarCode=$p(^TMPINITHVCOLDETAIL(Inci),"^",22)
    .s IncscDesc=$p(^TMPINITHVCOLDETAIL(Inci),"^",23)
    .s ReqQty=$p(^TMPINITHVCOLDETAIL(Inci),"^",24)
    .s ReqRemark=$p(^TMPINITHVCOLDETAIL(Inci),"^",25)
    .
    .s QtyApproved=$p(^TMPINITHVCOLDETAIL(Inci),"^",26)
    .s SterilizedBat=$p(^TMPINITHVCOLDETAIL(Inci),"^",27)
    .s CheckFlag=$p(^TMPINITHVCOLDETAIL(Inci),"^",28)
    .s Model=$p(^TMPINITHVCOLDETAIL(Inci),"^",29)
    .d OutPutRowINITHVColDetail
	

	Quit $$$OK
OutPutRowINITHVColDetail
	s Data=$lb(InciCode,InciDesc,Spec,SpecDesc,UomDesc,
        Qty,Rp,RpAmt,Pp,PpAmt,
        Sp,SpAmt,NewSp,NewSpAmt,Status,
		VendorDesc,ManfDesc,Remark,StkBin,BatExp,
		HVFlag,BarCode,IncscDesc,ReqQty,ReqRemark,
		QtyApproved,SterilizedBat,CheckFlag,Model)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据申请单显示填充出库明细(高值依据申请单出库，不填充条码)
/// Author: lihui
/// Date: 20191018
/// Argu:
///  申请单ID,
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfItm","DHCINIsTrfFromReq",^tmpbin(1516))
Query DHCINIsTrfFromReq(Params As %String) As Query(ROWSPEC = "RowId,Inclb,InciId,InciCode,InciDesc,Spec,SpecDesc,UomId,UomDesc,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,VendorId,VendorDesc,ManfId,ManfDesc,StkBin,InclbQty:%Float,InclbDirtyQty:%Float,InclbAvaQty:%Float,ReqLocStkQty:%Float,BUomId,ConFac:%Float,BatExp,DirtyQty:%Float,HVFlag,BarCode,AllAvaQty:%Float,IncscDesc,Inrqi,ReqQty:%Float,QtyApproved,AllDirtyQty:%Float,Model") [ SqlProc ]
{
}

ClassMethod DHCINIsTrfFromReqExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	;s ^tmpbin(1516)=Params
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s ReqId=PJObj.%Get("ReqId")
	q:ReqId="" $$$OK
	
	s OutType=0  ;效期优先
	s FroLocid=$p(^INRQ(ReqId),"^",5)
	s ToLocId=$p(^INRQ(ReqId),"^",6)
	s HospId=$p(^CTLOC(FroLocid),"^",22)
	s Today=+$h
	
	s Chl=""
	f  s Chl=$o(^INRQ(ReqId,"RQI",Chl)) q:Chl=""  d
	.s Inrqi=ReqId_"||"_Chl
	.s ReqStr=^INRQ(ReqId,"RQI",Chl)
	.s ReqQty=+$p(ReqStr,"^",3)
	.s InciId=$p(ReqStr,"^",4)
	.s UomId=+$p(ReqStr,"^",5)
	.s refuse=$P(ReqStr,"^",6)
	.q:InciId=""
	.q:refuse="Y"	//排除掉"拒绝"的请求明细
	.
	.s (INRQICanceled,qtyApproved,SpecDesc)=""
	.s dhcinrqi=$o(^DHCINRQI(0,"INRQI",Inrqi,""))  ;请求子表附加表dr
	.i dhcinrqi'="" d
	..s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8) ;取消标志
	..s QtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)   ;批准数量
	..s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)      ;具体规格
	.q:INRQICanceled="Y"
	.
	.
	.s InciCode=$p(^INCI(InciId,1),"^",1)
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s PurUomDr=$p(^INCI(InciId,3),"^",6)
	.s BarCode=$p(^INCI(InciId,3),"^",9)		//条码
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(InciId)
	.s manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(InciId),"^",3)
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	.s StkBinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(FroLocid,InciId)
	.s StkBin=$p(StkBinInfo,"^",1)
	.s Incsc=$p(^INCI(InciId,2),"^",2)
	.s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
	.s UomDesc=$p(^CT("UOM",UomId),"^",2)
	.
	.
	.s TransQty=##class(web.DHCSTMHUI.DHCINIsTrf).TransQty(Inrqi)   ;已转移数量
	.
	.s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomDr,BUomId)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	.s QtyApproved=QtyApproved*Fac
	.s BasReqQty=ReqQty*Fac
	.if (HVFlag="Y") d
	..s ReqQty=BasReqQty
	..s UomId=BUomId
	..s UomDesc=$p(^CT("UOM",UomId),"^",2)
	.s NotTrQty=BasReqQty-TransQty    ;未转移数量(基本单位)
	.q:NotTrQty'>0     ;全部转移的明细过滤掉
	.
	.s ExistFlag=0   ;标识是否存在可转移的批次
	.s reqBuomQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,ToLocId,+$h)
	.s reqPuomQty=reqBuomQty/Fac     //申请科室库存
	.             
	.s pid=##class(web.DHCSTMHUI.DHCINIsTrfItm).GetInclbForTransfer(FroLocid,InciId,NotTrQty,OutType)
	.q:pid=""
	.
	.s Inclb=""
	.f  s Inclb=$o(^TMPGETINCLB(pid,Inclb)) q:Inclb=""  d
	..s IncInfo=^TMPGETINCLB(pid,Inclb)		;科室库存批次信息
	..s BatNo=$p(IncInfo,"^",1)
	..s ExpDate=$p(IncInfo,"^",3)
	..s Qty=$p(IncInfo,"^",7)				;批次转移数量
	..s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBUom(Inclb,UomId,+$h)		;当前库存
	..s InclbDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbResQty(Inclb,UomId)	;当前占用库存
	..s InclbAvaQty=InclbQty-InclbDirtyQty			;当前可用库存
	..s DirtyQty=0
	..s ReqLocStkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(InciId,ToLocId,UomId,+$h)
	..s AllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(FroLocid,InciId,UomId) ;取物资库存项当前可用库存
	..s Incil=$p(Inclb,"||",1,2)
	..s AllDirtyQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurIncResQty(Incil,UomId) ;取物资库存项当前占用库存
	..
	..;高值使用基本单位, 低值则转换
	..i (HVFlag'="Y") d
	...s Qty=Qty/Fac
	..
	..s BatExp=BatNo_"~"_ExpDate
	..s ExistFlag=1
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId)
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	..s SpAmt=Sp*Qty
	..s RpAmt=Rp*Qty
	..s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	..s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)   
	..s ProLocAllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,Today) ;取供应科室物资库存项批次当前可用库存
	..s stkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,UomId)	//当前批次供应科室库存
	..s basstkQty=stkQty
	..s stkQty=stkQty/Fac
	..if (HVFlag="Y") d
	...s stkQty=basstkQty
	..
	..s (ingr,VendorId,VendorDesc)=""
	..&sql(SELECT INGRI_INGR_ParRef into :ingr FROM dhc_ingdrecitm WHERE INGRI_INCLB_DR=:Inclb)
	..s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	..s VendorId=$p(VendorInfo,"^",1)
	..s VendorDesc=$p(VendorInfo,"^",2)
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	..s ManfId=$P(ManfInfo,"^",1)
	..s ManfDesc=$P(ManfInfo,"^",2)
	..
	..s OutInclb=Inclb
	..i (HVFlag="Y") d 
	...f i=1:1:Qty  d
	....s Qty=1,RpAmt=Rp,SpAmt=Sp
	....s OutInclb=""		;相关字段也需置空
	....s BatExp=""
	....s (InclbQty,InclbDirtyQty,InclbAvaQty,DirtyQty)=""
	....d OutPurRowReqInti
	..e  d
	...d OutPurRowReqInti
	Quit $$$OK
OutPurRowReqInti
	s Data=$lb(RowId,OutInclb,InciId,InciCode,InciDesc,
		Spec,SpecDesc,UomId,UomDesc,Qty,
		Rp,RpAmt,Sp,
		SpAmt,VendorId,VendorDesc,
		ManfId,ManfDesc,StkBin,InclbQty,InclbDirtyQty,
		InclbAvaQty,ReqLocStkQty,BUomId,ConFac,BatExp,
		DirtyQty,HVFlag,BarCode,AllAvaQty,IncscDesc,
		Inrqi,ReqQty,QtyApproved,AllDirtyQty,Model)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据请求单主表id和库存项id获取对应请求单子表id
ClassMethod GetInRqiId(ReqId, Inci)
{
	n (ReqId,Inci)
	q:(+ReqId=0)||(+Inci=0) ""
	s ReqiId=""
	s Ch=0
	f  s Ch=$o(^INRQ(ReqId,"RQI",Ch)) q:(Ch="")||(ReqiId'="")  d
	.s InciId=$p(^INRQ(ReqId,"RQI",Ch),"^",4)
	.i InciId=Inci d
	..s ReqiId=ReqId_"||"_Ch
	
	q ReqiId
}

/// w ##class(web.DHCSTM.DHCINIsTrfItm).GetDetailSum(0,30,18)
ClassMethod GetStartEndBarCode(Init As %String, Inclb As %String) As %String
{
	n (Init,Inclb)
	q:(Init="")||(Inclb="") ""
	
	s StartCh=""
	s (StartBarCode,EndBarCode)=""
	
	s Ch=0
	f  s Ch=$o(^DHCINIT(0,"INCLB",Inclb,Init,Ch)) q:(Ch="")  d
	.s Initi=Init_"||"_Ch
	.s HVBarCodeInfo=..GetHVBarCode(Initi)
	.s BarCode=$p(HVBarCodeInfo,"^",1)
	.q:BarCode=""
	.s BarCodeArray(BarCode)=""
	
	s StartBarCode=$o(BarCodeArray(""))
	s EndBarCode=$o(BarCodeArray(""),-1)
	q StartBarCode_"^"_EndBarCode
}

}
