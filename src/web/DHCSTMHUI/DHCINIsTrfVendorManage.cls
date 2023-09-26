Import sqluser

Class web.DHCSTMHUI.DHCINIsTrfVendorManage Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:查询请求单
/// Creator:	tsr
/// CreatDate:	2018-10-24
/// Table:		IN_Request,DHC_INRequest
/// d ##class(%ResultSet).Run("web.DHCSTMHUI.DHCINIsTrfVendorManage","ReqList",)
Query ReqList(Params As %String) As Query(ROWSPEC = "RowId,ReqNo,RecLocId,RecLoc,UserName,Date,Time,ScgDesc") [ SqlProc ]
{
}

ClassMethod ReqListExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s LocId=PJObj.%Get("IngrLoc")
	s ScgStk=PJObj.%Get("ScgStk")
	s pPartTransFlag=PJObj.%Get("PartTransFlag")
	s pOnlyReqFlag=PJObj.%Get("OnlyReqFlag")
	q:LocId="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)

	s SqlStr="select INRQ_RowId,INRQ_No,INRQ_RecLoc_DR,INRQ_RecLoc_DR->CTLOC_Desc as LocDesc,INRQ_Date,"
		_"INRQ_Time,INRQ_SSUSR_DR->SSUSR_Name as UserName"
		_" from IN_Request where INRQ_ReqLoc_DR="_LocId
		_" and (INRQ_Date between '"_StartDate_"' and '"_EndDate_"') and INRQ_UserCompleted='Y'"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("INRQ_RowId")
		s DHCReqId =$o(^DHCINRQ(0,"INRQ",RowId,0))
		s Type=$s(DHCReqId'="":$P(^DHCINRQ(DHCReqId),"^",1),1:"")		//请求单类型
		s StkGrpId=$s(DHCReqId'="":$P(^DHCINRQ(DHCReqId),"^",10),1:"")	//类组Id
		s PreFlag=$s(DHCReqId'="":$P(^DHCINRQ(DHCReqId),"^",20),1:"")	//预申领标志
		;s ReqAudit=$s(DHCReqId'="":$P(^DHCINRQ(DHCReqId),"^",11),1:"")	//请求方审核人
		;s ProvAudit=$s(DHCReqId'="":$P(^DHCINRQ(DHCReqId),"^",14),1:"")	//供应方审核人
		s ReqAudit=$s(DHCReqId'="":$P(^DHCINRQ(DHCReqId),"^",12),1:"")	//请求方审核时间
		s ProvAudit=$s(DHCReqId'="":$P(^DHCINRQ(DHCReqId),"^",15),1:"")	//供应方审核时间
		CONTINUE:PreFlag="Y"
		CONTINUE:(ReqAudit="")!(ProvAudit="")		//未审核
		CONTINUE:(ScgStk'="")&&(ScgStk'=StkGrpId)	//类组过滤
		CONTINUE:(pOnlyReqFlag="Y")&&(Type'="C")	//申领计划过滤
		s TransferStatus=##class(web.DHCSTMHUI.DHCINIsTrf).TransferStatus(RowId)  //转移状态
		CONTINUE:TransferStatus="2"		//全部转移
		CONTINUE:(pPartTransFlag="N")&&(TransferStatus="1")
		CONTINUE:(pPartTransFlag="Y")&&(TransferStatus="0")
		s ReqNo=xrs.Data("INRQ_No")
		s RecLocId=xrs.Data("INRQ_RecLoc_DR")
		s RecLoc=xrs.Data("LocDesc")
		s UserName=xrs.Data("UserName")
		s Date=xrs.Data("INRQ_Date")
		s:Date'="" Date=..DL2H(Date)
		s Time=xrs.Data("INRQ_Time")
		s:Time'="" Time=..TL2H(Time)
		s ScgDesc=$s(StkGrpId'="":$p(^DHCSCG(StkGrpId),"^",2),1:"")
		d OutPutRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,ReqNo,RecLocId,RecLoc,UserName,Date,Time,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询请求单明细信息
/// Creator:	tsr
/// CreatDate:	2018-10-25
/// Table:		IN_ReqItm,DHC_INReqItm
/// Input:		请求单Id
Query ReqItmList(Req As %String) As Query(ROWSPEC = "RowId,ReqQty:%Float,IncId,InciCode,InciDesc,ReqUomDesc,LocQty:%Float,TransQty:%Float,ApprovedQty:%Float,Spec") [ SqlProc ]
{
}

ClassMethod ReqItmListExecute(ByRef qHandle As %Binary, Req As %String) As %Status
{
	n (qHandle,Req)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Req="" $$$OK

	s SqlStr="SELECT INRQI_RowId, INRQI_INCI_DR, INRQI_INCI_DR->INCI_Code as IncCode, INRQI_INCI_DR->INCI_Desc as IncDesc,"
		_"INRQI_ReqQty, INRQI_CTUOM_DR, INRQI_CTUOM_DR->CTUOM_Desc as ReqUomDesc"
		_" FROM SQLUser.IN_ReqItm"
		_" WHERE INRQI_INRQ_ParRef = "_Req
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId = xrs.Data("INRQI_RowId")
		s ReqQty = xrs.Data("INRQI_ReqQty")
		s IncId = xrs.Data("INRQI_INCI_DR")
		s InciCode = xrs.Data("IncCode")
		s InciDesc = xrs.Data("IncDesc")
		s ReqUomId = xrs.Data("INRQI_CTUOM_DR")
		s ReqUomDesc = xrs.Data("ReqUomDesc")
		s LocId = $p(^INRQ(Req),"^",5)			//供应科室
		s LocQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(IncId,LocId,+$h)	//当前科室库存(基本单位)
		s TransQty=##class(web.DHCSTMHUI.DHCINIsTrf).TransQty(RowId)				//已经转移的数量(基本单位)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ReqUomId,BUomId)
		s TransQty=TransQty/Fac					//换算为请求单位
		s ApprovedQty=..QtyApproved(RowId)		//批准数量
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		d OutPutItmRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutItmRow
	s Data=$lb(RowId,ReqQty,IncId,InciCode,InciDesc,ReqUomDesc,LocQty,TransQty,ApprovedQty,Spec)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:查询请求单明细批准数量
/// Creator:	tsr
/// CreatDate:	2018-10-25
/// Table:		DHC_INReqItm
/// Input:		请求单Id
ClassMethod QtyApproved(inrqi As %String) As %String
{
	n (inrqi)
	s qty=0
	s dhcinrqi=$o(^DHCINRQI(0,"INRQI",inrqi,0))
	s:dhcinrqi'="" qty=$p(^DHCINRQI(dhcinrqi),"^",3)
	q qty
}

/// Description:汇总请求单明细信息
/// Creator:	tsr
/// CreatDate:	2018-10-25
/// Table:		IN_ReqItm,DHC_INReqItm
/// Input:		请求单Id串
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfVendorManage","SumReqItm","99,102")
Query SumReqItm(ReqStr As %String) As Query(ROWSPEC = "ReqItmStr,IncId,InciCode,InciDesc,ReqUomId,ReqUomDesc,Qty:%Float,TransQty:%Float,ApprovedQty:%Float,Spec,Model,ManfDesc,Vendor,VendorDesc,Rp:%Float,Sp:%Float,BatReq,ExpReq,BatNo,ExpDate") [ SqlProc ]
{
}

ClassMethod SumReqItmExecute(ByRef qHandle As %Binary, ReqStr As %String) As %Status
{
	n (qHandle,ReqStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:ReqStr="" $$$OK

	k ^TMPSUMREQ($j,"REQI")
	s SqlStr="SELECT INRQI_RowId, INRQI_INCI_DR, INRQI_ReqQty, INRQI_CTUOM_DR, INRQI_Type"
		_" FROM SQLUser.IN_ReqItm"
		_" WHERE INRQI_INRQ_ParRef IN ("_ReqStr_")"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId = xrs.Data("INRQI_RowId")
		s IncId = xrs.Data("INRQI_INCI_DR")
		s ReqQty = xrs.Data("INRQI_ReqQty")
		s ReqUomId = xrs.Data("INRQI_CTUOM_DR")
		s Type = xrs.Data("INRQI_Type")
		s ApprovedQty=..QtyApproved(RowId)		//批准数量
		s:ApprovedQty="" ApprovedQty=ReqQty
		s TransQty=##class(web.DHCSTMHUI.DHCINIsTrf).TransQty(RowId)				//已经转移的数量(基本单位)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ReqUomId,BUomId)
		s TransQty=TransQty/Fac					//已转移数量(请求单位)
		s Qty=ApprovedQty-TransQty				//本次配送数量
		CONTINUE:Qty'>0
		i '$d(^TMPSUMREQ($j,"REQI",IncId)) d
		. s ^TMPSUMREQ($j,"REQI",IncId)=Qty_"^"_ReqUomId_"^"_RowId_"^"_TransQty
		e  d
		.s ToUom=$p(^TMPSUMREQ($j,"REQI",IncId),"^",2)
		.i ReqUomId'=ToUom d
		..s Qty=..GetQty(IncId,Qty,ReqUomId,ToUom)
		..s TransQty=..GetQty(IncId,TransQty,ReqUomId,ToUom)
		.s $p(^TMPSUMREQ($j,"REQI",IncId),"^",1)=$p(^TMPSUMREQ($j,"REQI",IncId),"^",1)+Qty
		.s $p(^TMPSUMREQ($j,"REQI",IncId),"^",3)=$p(^TMPSUMREQ($j,"REQI",IncId),"^",3)_","_RowId 
		.s $p(^TMPSUMREQ($j,"REQI",IncId),"^",4)=$p(^TMPSUMREQ($j,"REQI",IncId),"^",4)+TransQty 
	}
	d xrs.Close()

	s count=0,IncId=0
	f  s IncId=$o(^TMPSUMREQ($j,"REQI",IncId))  q:IncId=""  d
	.s Qty=$p(^TMPSUMREQ($j,"REQI",IncId),"^",1)
	.s ReqUom=$p(^TMPSUMREQ($j,"REQI",IncId),"^",2)
	.s ReqUomDesc=$P(^CT("UOM",ReqUom),"^",2)
	.s ReqItmStr=$p(^TMPSUMREQ($j,"REQI",IncId),"^",3)
	.s TransQty=$p(^TMPSUMREQ($j,"REQI",IncId),"^",4)
	.s InciCode=$p(^INCI(IncId,1),"^",1)
	.s InciDesc=$p(^INCI(IncId,1),"^",2)
	.s BatReq=$p(^INCI(IncId,2),"^",10)
	.s ExpReq=$p(^INCI(IncId,2),"^",11)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(IncId)
	.s ManfStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(IncId)
	.s Manf=$p(ManfStr,"^",1)
	.s ManfDesc=$p(ManfStr,"^",2)
	.s VendorStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(IncId)
	.s Vendor=$p(VendorStr,"^",1)
	.s VendorDesc=$p(VendorStr,"^",2)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(IncId,+$H,ReqUom,"")
	.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(IncId,+$H,ReqUom,"")
	.s (BatNo,ExpDate)=""
	.d OutPutReqItmRow 

	Quit $$$OK
OutPutReqItmRow
	s Data=$lb(ReqItmStr,IncId,InciCode,InciDesc,ReqUom,ReqUomDesc,Qty,TransQty,ApprovedQty,Spec,Model,ManfDesc,Vendor,VendorDesc,Rp,Sp,BatReq,ExpReq,BatNo,ExpDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:按要求的单位转换数量值
/// Creator:	tsr
/// CreatDate:	2018-10-25
ClassMethod GetQty(inci, qty, frUom, toUom) As %String
{
	n (inci,qty,frUom,toUom)
	s buom=$p(^INCI(inci,1),"^",10)
	s fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(frUom,buom)
	s fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(toUom,buom)
	q (qty*fac1)/fac2
}

/// Description:将请求单明细信息配送出库
/// Creator:	tsr
/// CreatDate:	2018-10-25
/// Table:		IN_ReqItm,DHC_INReqItm
/// Input:		请求单Id串
/// w ##class(web.DHCSTMHUI.DHCINIsTrfVendorManage).Handle("{""IngrLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""30/11/2018"",""ScgStk"":""12"",""EndDate"":""30/11/2018"",""PartTransFlag"":"""",""OnlyReqFlag"":""""}","[{""ReqItmStr"":""124||1"",""IncId"":""1748"",""ReqUomId"":""17"",""Qty"":""10"",""Vendor"":""814"",""Rp"":""40"",""Sp"":""100"",""BatNo"":""20181130001"",""ExpDate"":""28/11/2030""}]")
ClassMethod Handle(Main As %String, Data As %String) As %String
{
	n (Main,Data,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s LocId=PJObj.%Get("IngrLoc")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s Sc=PJObj.%FromJSON(Data)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	k ^TMPVENMAN($j,"VENDORMAN")
	s count=0
	tstart
	s $ZT=..sssError()
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s IncId=Obj.%Get("IncId")
		s UomId=Obj.%Get("ReqUomId")
		s Qty=Obj.%Get("Qty")
		s BatNo=Obj.%Get("BatNo")
		s ExpDate=Obj.%Get("ExpDate")
		s Rp=Obj.%Get("Rp")
		s Sp=Obj.%Get("Sp")
		s Vendor=Obj.%Get("Vendor")
		s Manf=Obj.%Get("Manf")
		s ReqItmStr=Obj.%Get("ReqItmStr")
		s count=count+1
		s ^TMPVENMAN($j,"VENDORMAN",Vendor,count)=IncId_"^"_UomId_"^"_Qty_"^"_BatNo_"^"_ExpDate_"^"_Rp_"^"_Sp_"^"_Manf_"^"_ReqItmStr
	}
	//生成入库单
	s AllIngr="",Vendor=0
	f  s Vendor=$o(^TMPVENMAN($j,"VENDORMAN",Vendor)) q:(Vendor="")!(RtnObj.success'=0)  d
	.s MainInfo=""
	.s $p(MainInfo,"^",1)=Vendor
	.s $p(MainInfo,"^",2)=LocId
	.s $p(MainInfo,"^",3)=UserId
	.s Ingr=..CreateIngr(MainInfo)
	.i Ingr<0 d RtnObj.Err(-2,"","生成入库单失败!")
	.q:RtnObj.success'=0
	.s RowCount=0
	.f  s RowCount=$o(^TMPVENMAN($j,"VENDORMAN",Vendor,RowCount)) q:(RowCount="")!(RtnObj.success'=0)  d
	..s TmpVendorMan=^(RowCount)
	..s IncId=$P(TmpVendorMan,"^",1)
	..s UomId=$P(TmpVendorMan,"^",2)
	..s Qty=$P(TmpVendorMan,"^",3)
	..s BatNo=$P(TmpVendorMan,"^",4)
	..s ExpDate=$P(TmpVendorMan,"^",5)
	..s Rp=$P(TmpVendorMan,"^",6)
	..s Sp=$P(TmpVendorMan,"^",7)
	..s Manf=$P(TmpVendorMan,"^",8)
	..s ReqItmStr=$P(TmpVendorMan,"^",9)
	..s DetInfo=""
	..s $P(DetInfo,"^",1)=IncId
	..s $P(DetInfo,"^",2)=BatNo
	..s $P(DetInfo,"^",3)=ExpDate
	..s $P(DetInfo,"^",4)=Manf
	..s $P(DetInfo,"^",5)=UomId
	..s $P(DetInfo,"^",6)=Qty
	..s $P(DetInfo,"^",7)=Rp
	..s $P(DetInfo,"^",8)=Sp
	..s $P(DetInfo,"^",9)=ReqItmStr
	..s Ingri=..CreateIngri(Ingr,DetInfo)
	..i Ingri'=0 d RtnObj.Err(-3,Ingr,"生成入库单明细失败!")
	.q:RtnObj.success'=0
	.s Ret=..CompleteIngr(Ingr,UserId)
	.i Ret'=0 d RtnObj.Err(-4,Ingr,"完成入库单失败!")
	.q:RtnObj.success'=0
	.s Ret=..AuditIngr(Ingr,UserId,LocId,GroupId)
	.i Ret'=0 d RtnObj.Err(-5,Ingr,"审核入库单失败!")
	.q:RtnObj.success'=0
	.i AllIngr="" s AllIngr=Ingr
	.e  s AllIngr=AllIngr_"^"_Ingr
	i RtnObj.success'=0 tro  k ^TMPVENMAN($j,"VENDORMAN") q RtnObj.Json()
	i AllIngr="" d RtnObj.Err(-6,"","未生成入库单!","",0) 
	i RtnObj.success'=0 tro  k ^TMPVENMAN($j,"VENDORMAN") q RtnObj.Json()
	//根据入库单\请求单准备出库数据
	f i=1:1:$l(AllIngr,"^") d
	.s Ingr=$p(AllIngr,"^",i)
	.s Ch=0
	.f  s Ch=$o(^DHCINGR(Ingr,"GRI",Ch)) q:Ch=""  d
	..s Inclb=$p(^DHCINGR(Ingr,"GRI",Ch),"^",1)
	..s Qty=$p(^DHCINGR(Ingr,"GRI",Ch),"^",4)
	..s Uom=$p(^DHCINGR(Ingr,"GRI",Ch),"^",10)
	..s Rqi=$p(^DHCINGR(Ingr,"GRI",Ch),"^",44)
	..s Rp=$p(^DHCINGR(Ingr,"GRI",Ch),"^",30)
	..s Sp=$p(^DHCINGR(Ingr,"GRI",Ch),"^",32)
	..s Ingri=Ingr_"||"_Ch
	..s Ret=..SetTransferQty(Inclb,Qty,Uom,Rqi,Ingri)
	i '$d(^TMPTRANS("TOTRANS")) d RtnObj.Err(-7,"","出库数量分配失败!")
	i RtnObj.success'=0 tro  k ^TMPVENMAN($j,"VENDORMAN") q RtnObj.Json()

	//生成出库单
	s InitStr=""
	s Req=""
	f  s Req=$o(^TMPTRANS("TOTRANS",Req)) q:(Req="")!(RtnObj.success'=0)  d
	.s Init=..CreateInitByReq(Req,UserId)
	.i Init<0 d RtnObj.Err(-8,"","生成出库单失败!")
	.q:RtnObj.success'=0
	.i InitStr="" s InitStr=Init
	.e  s InitStr=InitStr_"^"_Init
	.s Ch=0
	.f  s Ch=$o(^TMPTRANS("TOTRANS",Req,Ch)) q:(Ch="")!(RtnObj.success'=0)  d
	..s Inclb=$p(^TMPTRANS("TOTRANS",Req,Ch),"^",1)
	..s Qty=$p(^TMPTRANS("TOTRANS",Req,Ch),"^",2)
	..s UomId=$p(^TMPTRANS("TOTRANS",Req,Ch),"^",3)
	..s Ingri=$p(^TMPTRANS("TOTRANS",Req,Ch),"^",4)
	..s Detail=""
	..s $P(Detail,"^",1)=Inclb
	..s $P(Detail,"^",2)=Qty
	..s $P(Detail,"^",3)=UomId
	..s $P(Detail,"^",4)=Req_"||"_Ch
	..s $P(Detail,"^",5)=Ingri
	..s Initi=..CreateIniti(Init,Detail)
	..i Initi'=0 d RtnObj.Err(-9,Init,"生成出库单明细失败!")
	.q:RtnObj.success'=0
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).SetCompleted(Init,"Y",GroupId)
	.i RtnObj.success'=0 d RtnObj.Err(-10,Init,"完成出库单失败!")
	.q:RtnObj.success'=0
	i RtnObj.success'=0 tro  k ^TMPVENMAN($j,"VENDORMAN") q RtnObj.Json()

	//生成配送记录
	s Ret=..CreateDistribution(LocId,UserId,InitStr)
	i Ret<0 d RtnObj.Err(-12,"","生成配送记录失败!")
	i RtnObj.success'=0 tro  k ^TMPVENMAN($j,"VENDORMAN") q RtnObj.Json()

	tc
	k ^TMPVENMAN($j,"VENDORMAN")
	k ^TMPTRANS("TOTRANS")
	s RtnObj.rowid=Ret
	q RtnObj.Json()
}

/// Description:生成入库单主表
/// Creator:	tsr
/// CreatDate:	2018-10-30
ClassMethod CreateIngr(MainInfo As %String) As %String
{
	n (MainInfo,%session)
	s Vendor=$p(MainInfo,"^",1)
	s LocId=$p(MainInfo,"^",2)
	s CreateUser=$p(MainInfo,"^",3)
	q:Vendor="" -1
	q:LocId="" -1

	s err=0
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	s InGrRemarks="托管配送出库"
	s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s InGrRemarks=$lfs(InGrRemarks,MemoDelim)
	s IptDesc="正常入库",IptType="IM"
	s HospId=..sssHospId(LocId)
	s TmpIngrType=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",IptDesc,"DHC_OperateType",HospId,IptType)
	s IngrTypeId=TmpIngrType
	s Complete="N"
	s AuditFlag="N"
	s StkType=..sssCode()
	s AppName=##class(web.DHCSTMHUI.DHCINGdRec).%GetParameter("AppName")
	s ret=..sssLock("IMPORTNO")  
	i ret'=0 s err=-2
	q:err'=0 err
	s IngrNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"",LocId)
	i IngrNo="" d ..sssUnLock("IMPORTNO") s err=-3
	q:err'=0 err
	&sql(insert into dhc_ingdrec(INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,INGR_ExRate,INGR_HandChg,
		INGR_No,INGR_Loc_Dr,INGR_CreateUser,INGR_CreateDate,INGR_CreateTime,
		INGR_Type,INGR_AuditFlag,INGR_StkType,INGR_Remarks)
		values (:Vendor,:Complete,1,1,0,
		:IngrNo,:LocId,:CreateUser,:CreateDate,:CreateTime,
		:IngrTypeId,:AuditFlag,:StkType,:InGrRemarks))
	i SQLCODE'=0 d ..sssUnLock("IMPORTNO") s err=SQLCODE
	q:err'=0 err
	q $p($g(%ROWID),$c(1))
}

/// Description:生成入库单明细
/// Creator:	tsr
/// CreatDate:	2018-10-30
ClassMethod CreateIngri(Ingr As %String, ListData As %String) As %String
{
	n (Ingr,ListData)
	s IncId=$p(ListData,"^",1)
	s BatNo=$p(ListData,"^",2)
	s ExpDate=$p(ListData,"^",3)
	s:ExpDate'="" ExpDate=..DH2L(ExpDate)
	s ManfId=$p(ListData,"^",4)
	s UomId=$p(ListData,"^",5)
	s Qty=$p(ListData,"^",6)
	s Rp=$p(ListData,"^",7)
	s NewSp=$p(ListData,"^",8)
	s ReqItmStr=$p(ListData,"^",9)
	s BuomId=$p(^INCI(IncId,1),"^",10)
	q:BuomId="" -1
	q:NewSp="" -1
	q:(Qty="")!(Qty=0) -1

	s Chl=1+$o(^DHCINGR(Ingr,"GRI",""),-1)
	s LocId=$p(^DHCINGR(Ingr),"^",13)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Sp=NewSp
	s Tax=0

	i UomId=BuomId d
	.s NewSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(NewSp,HospId,2)
	.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,2)
	e  d
	.s NewSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(NewSp,HospId,1)
	.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,1)
	s SpAmt=Sp*Qty
	s RpAmt=Rp*Qty
	s NewSpAmt=NewSp*Qty
	s TaxAmt=Tax*Qty
	s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	s NewSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
	s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	s Margin=$s(+Rp'=0:Sp/Rp-1,1:"")
	s Remarks=$lfs(ReqItmStr)
	s InciDesc=$p(^INCI(IncId,1),"^",2)
	s MtInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(IncId)
	s MtDr=$p(MtInfo,"^",1)
	s Err=0
	&sql(INSERT INTO DHC_INGdRecItm(INGRI_INGR_ParRef,INGRI_ChildSub,INGRI_BatchNo,INGRI_CTLOC_DR,INGRI_CTUOM_DR,
		INGRI_ExpDate,INGRI_Margin,INGRI_RecQty,INGRI_StkDesc,initm_INCI_DR,
		initm_phmnf_dr,initm_realprice,initm_realtotal,initm_saleprice,initm_BatPrice,
		initm_newSp,initm_newSpAmt,initm_SpAmt,INGRI_Remarks,initm_MT_Dr,
		INGRI_Tax,INGRI_TaxAmount,initm_Remark)
	VALUES(:Ingr,:Chl,:BatNo,:LocId,:UomId,
		:ExpDate,:Margin,:Qty,:InciDesc,:IncId,
		:ManfId,:Rp,:RpAmt,:Sp,:Rp,
		:NewSp,:NewSpAmt,:SpAmt,:Remarks,:MtDr,
		:Tax,:TaxAmt,:ReqItmStr))
	i SQLCODE'=0 s Err=SQLCODE
	q:Err'=0 Err
	q Err
}

/// Description:完成入库单
/// Creator:	tsr
/// CreatDate:	2018-10-30
ClassMethod CompleteIngr(Ingr As %String, UserId As %String) As %String
{
	n (Ingr,UserId)
	q:Ingr="" -1
	q:'$d(^DHCINGR(Ingr)) -1
	q:$p(^DHCINGR(Ingr),"^",12)="Y" -2

	s Err=0,Comp="Y"
	&sql(update dhc_ingdrec set ingr_completed=:Comp where ingr_rowid=:Ingr)
	i SQLCODE'=0 s Err=SQLCODE
	q:Err'=0 Err
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Ingr,"IMD",UserId,"G")
	q Err
}

/// Description:审核入库单
/// Creator:	tsr
/// CreatDate:	2018-10-30
ClassMethod AuditIngr(Ingr As %String, UserId As %String, LocId As %String, GroupId As %String) As %String
{
	n (Ingr,UserId,LocId,GroupId)
	q:Ingr="" -1
	q:'$d(^DHCINGR(Ingr)) -1
	q:..sssLock("LOCKREC"_Ingr)'=0 -99
	s Err=0
	s Comp=$p(^DHCINGR(Ingr),"^",12)
	i Comp'="Y" d ..sssUnLock("LOCKREC"_Ingr) s Err=-2
	q:Err'=0 Err
	s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	i AuditFlag="Y" d ..sssUnLock("LOCKREC"_Ingr) s Err=-3
	q:Err'=0 Err
	s CH=0
	f  s CH=$o(^DHCINGR(Ingr,"GRI",CH)) q:(CH="")!(Err'=0)  d
	.s INCLB=$p(^DHCINGR(Ingr,"GRI",CH),"^",1)
	.i INCLB'="" s Err=-4
	.q:Err'=0
	.s DHCINGRI=Ingr_"||"_CH
	.tstart
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).HandleStock(DHCINGRI,UserId,GroupId_"^"_LocId)
	.i RtnObj.success'=0 tro  s Err=-5
	.q:Err'=0
	.tcommit
	i Err'=0 d ..sssUnLock("LOCKREC"_Ingr)
	q:Err'=0 Err
	s ret=##class(web.DHCSTMHUI.DHCINGdRec).UpdateDHCINGdRec(Ingr,UserId)
	d ..sssUnLock("LOCKREC"_Ingr)   
	i ret'=0 s Err=-6
	q:Err'=0 Err
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(Ingr,"IMA",UserId,"G")
	q Err
}

/// Description:根据请求单生成库存转移单主表
/// Creator:	tsr
/// CreatDate:	2018-10-30
/// Table:		dhc_inrequest
/// Input:		请求单Id,用户Id
ClassMethod CreateInitByReq(ReqId As %String, InitUser As %String) As %String
{
	n (ReqId,InitUser,%session)
	q:ReqId="" -1
	s InitFrLoc=$p(^INRQ(ReqId),"^",5)
	s InitToLoc=$p(^INRQ(ReqId),"^",6)

	s Err=0,InitScg=""
	&sql(select inrq_scg_dr into :InitScg from dhc_inrequest where inrq_inrq_dr=:ReqId)
	s OperDesc="正常出库",OperStkType="OM"
	s HospId=..sssHospId(InitFrLoc)
	s OperateType=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",OperDesc,"DHC_OperateType",HospId,OperStkType)
	s AppName=##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName")
	s TrNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,InitScg,InitFrLoc)
	i (TrNo<0)||(TrNo="") s Err=-2
	q:Err'=0 Err

	s Date=+$H
	s Time=$p($H,",",2)
	s StkType=..sssCode()
	s obj=##class(User.DHCInIsTrf).%New()
	s obj.INITNo=TrNo
	s obj.INITDate=Date
	s obj.INITTime=Time
	d obj.INITINRQDRSetObjectId(ReqId)
	s obj.INITStkType=StkType
	d obj.INITFrLocDRSetObjectId(InitFrLoc)
	d obj.INITToLocDRSetObjectId(InitToLoc)
	d obj.INITOperateTypeSetObjectId(OperateType)
	d obj.INITSCGDRSetObjectId(InitScg)
	d obj.INITSSUSRDRSetObjectId(InitUser)
	d obj.INITRemarks.Clear()
	s sc=obj.%Save()
	i $$$ISERR(sc) s Err=-3
	q:Err'=0 Err
	q obj.%Id()
}

/// Description:生成库存转移单明细
/// Creator:	tsr
/// CreatDate:	2018-10-30
ClassMethod CreateIniti(Init As %String, Detail As %String) As %String
{
	n (Init,Detail)
	q:Init="" -1
	s LocId=$p(^DHCINIT(Init),"^",5)
	s UserId=$p(^DHCINIT(Init),"^",8)
	s HospId=$p(^CTLOC(LocId),"^",22)

	s Inclb=$p(Detail,"^",1)
	s Qty=$p(Detail,"^",2)
	s UomId=$p(Detail,"^",3)
	s Inrqi=$p(Detail,"^",4)
	s Ingri=$p(Detail,"^",5)
	s Remark="托管配送出库"
	s Inci=$p(Inclb,"||",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)

	s Err=0
	s CheckStr=Inclb_"^"_Qty_"^"_UomId
	s ErrInfo=##class(web.DHCSTMHUI.DHCINIsTrfItm).CheckTransferDetail("",CheckStr)
	i ErrInfo'="" s Err=-2
	q:Err'=0 Err

	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId)
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	s SpAmt=Sp*Qty
	s RpAmt=Rp*Qty
	s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	s Pp=Rp,PpAmt=RpAmt

	s AppName=##class(web.DHCSTMHUI.DHCINIsTrf).%GetParameter("AppName")
	i ..sssLock(AppName_Init)<0 q -99

	s obj=##class(User.DHCInIsTrfItm).%New(Init)
	d obj.INITIINITParRefSetObjectId(Init)
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
	s Sc=obj.%Save()
	d ..sssUnLock(AppName_Init)
	i $$$ISERR(Sc) q -3
	s Initi=obj.%Id()

	//增加新占用库存
	s Ret=##class(web.DHCSTMHUI.DHCINIsTrf).HandleTransItmDirtyQty(Initi,1)
	i Ret'=0 s Err=-4
	q:Err'=0 Err

	//清除请求单对应在途数
	s Ret=##class(web.DHCSTMHUI.DHCINIsTrfItm).HandleTransItmResQty(Initi,0)
	i Ret'=0 s Err=-5
	q:Err'=0 Err
	q Err
}

/// Description:生成配送记录
/// Creator:	tsr
/// CreatDate:	2018-10-30
ClassMethod CreateDistribution(LocId As %String, UserId As %String, InitStr As %String) As %String
{
	n (LocId,UserId,InitStr)

	//生成配送主表数据
	s Date=+$H,Time=$p($H,",",2)
	s No=$i(^DHCSTMVendorMan)
	s dstr=""
	&sql(insert into dhc_indistribute(dstr_no,dstr_ctloc_dr,dstr_date,dstr_time,dstr_ssusr_dr)
		values (:No,:LocId,:Date,:Time,:UserId) )	
	q:SQLCODE'=0 -1 

	s dstr=$G(%ROWID) 
	i dstr="" q -2

	s err=0
	f i=1:1:$l(InitStr,"^") q:err'=0  d
	.s Init=$P(InitStr,"^",i)
	.&sql(insert into dhc_indistributeitm (dstri_dstr_parref,dstri_init_dr)
	values (:dstr,:Init)    )
	.i SQLCODE'=0 s err=-3

	q:err'=0 err
	q dstr
}

/// Description:根据入库单\请求单分配出库数量
/// Creator:	tsr
/// CreatDate:	2018-10-30
/// Table:		IN_ReqItm,DHC_INReqItm
///  1748||1||5,10,17,,238||1
ClassMethod SetTransferQty(inclb As %String, qty As %String, uom As %String, rqi As %String, ingri As %String) As %String
{
	n (inclb,qty,uom,rqi,ingri) 
	s inci=+inclb
	s buom=$p(^INCI(inci,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	s qty=qty*fac  //换算成基本单位数量
	k ^TMPTRANS("TOTRANS")
	s result=""
	f i=1:1:$l(rqi,",") d
	.s reqitm=$P(rqi,",",i)
	.s req=+reqitm,reqch=$p(reqitm,"||",2)
	.s reqqty=$P(^INRQ(req,"RQI",reqch),"^",3)
	.s dhcinrqi=$o(^DHCINRQI(0,"INRQI",reqitm,""))
 	.s qtyApproved=""
 	.i dhcinrqi'="" d
 	..s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
 	.s:qtyApproved'="" reqqty=qtyApproved
	.s requom=$P(^INRQ(req,"RQI",reqch),"^",5)
	.s fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(requom,buom)
	.s reqqty=reqqty*fac1
	.s transferQty=0 
	.i reqqty'>qty d
	..s transferQty=reqqty
	.e  d
	..i qty'<0 s transferQty=qty
	.s qty=qty-transferQty  //总数消减
	.s transferQty=transferQty/fac1
	.s ^TMPTRANS("TOTRANS",req,reqch)=inclb_"^"_transferQty_"^"_requom_"^"_ingri //记录下配送数量
	q 0
}

/// Description:查询本次配送信息
/// Creator:	tsr
/// CreatDate:	2018-11-01
/// Table:		dhc_indistributeitm
/// Input:		配送单Id
Query InitByDstr(Dstr As %String) As Query(ROWSPEC = "RowId,InitNo,FrLoc,ToLoc,InitDate,InitTime,ScgDesc") [ SqlProc ]
{
}

ClassMethod InitByDstrExecute(ByRef qHandle As %Binary, Dstr As %String) As %Status
{
	n (qHandle,Dstr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Dstr="" $$$OK

	s SqlStr="SELECT dstri_init_dr RowId,dstri_init_dr->init_no InitNo,dstri_init_dr->init_frloc_dr->ctloc_Desc FrLoc,"
		_"dstri_init_dr->init_toloc_dr->ctloc_desc ToLoc,dstri_init_dr->init_date InitDate,dstri_init_dr->init_time InitTime,"
		_"dstri_init_dr->init_scg_dr->scg_desc ScgDesc"
		_" FROM dhc_indistributeitm"
		_" WHERE dstri_dstr_parref = "_Dstr
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId = xrs.Data("RowId")
		s InitNo = xrs.Data("InitNo")
		s FrLoc = xrs.Data("FrLoc")
		s ToLoc = xrs.Data("ToLoc")
		s InitDate = xrs.Data("InitDate")
		s InitTime = xrs.Data("InitTime")
		s ScgDesc = xrs.Data("ScgDesc")
		s:InitDate'="" InitDate = ..DL2H(InitDate)
		s:InitTime'="" InitTime = ..TL2H(InitTime)
		d OutPutInitRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutInitRow
	s Data=$lb(RowId,InitNo,FrLoc,ToLoc,InitDate,InitTime,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
