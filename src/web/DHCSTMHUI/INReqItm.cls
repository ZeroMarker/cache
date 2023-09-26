Import sqluser

Class web.DHCSTMHUI.INReqItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 删除库存转移请求单明细
/// Author:XuChao
/// Date:2018-05-23
/// w ##class(web.DHCSTMHUI.INReqItm).Delete(^bintmp(92))
ClassMethod Delete(Params) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		i ##class(web.DHCSTMHUI.INRequest).AllowDel(+RowId)<0 d
		.s Sc=RtnObj.Err(-2,"","不允许删除","",0)
		q:RtnObj.success'=0
		//删除明细附加表信息
		&sql(delete from dhc_inreqitm where inrqi_inrqi_dr=:RowId)
		i SQLCODE<0 d
		.s Sc=RtnObj.Err(-3,"","删除明细附加表失败!")
		q:RtnObj.success'=0
		&sql(delete from in_reqitm where %ID=:RowId)
		i SQLCODE'=0 d
		.s Sc=RtnObj.Err(-4,"","删除明细表失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// 检索库存转移请求单明细记录
/// Author:zhwh
/// Date:2011-07-11
/// zdm,2012-10-19,增加参数：是否显示已转移完成的请求明细（1：显示；0：不显示）
/// 增加输出：已转移数量，未转移数量
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INReqItm","INReqD",62)
Query INReqD(Req As %String, Params As %String, RQReqStr As %String = "") As Query(ROWSPEC = "RowId,Inci,Code,Description,Qty:%Float,Uom,UomDesc,Spec,Manf,Sp:%Float,SpAmt:%Float,ReqRemarks,TransQty:%Float,NotTransQty:%Float,BUomId,ConFac:%Float,StkQty:%Float,Rp:%Float,RpAmt:%Float,ApprovedQty:%Float,RpAmtApproved:%Float,SpAmtApproved:%Float,InciRemarks,RefuseFlag,BUomDesc,SpecDesc,ReqNo,ReqLocDesc,RepLev:%Float,ProvLoc,HVFlag,ZeroStkFlag,INRQIType,INRQICanceled,ReqPuomQty:%Float,ProLocAllAvaQty:%Float,ProvLocId,NotUseFlag,LimitType,ReqAmt,LeftAmt,NoLocReqFlag") [ SqlProc ]
{
}

ClassMethod INReqDExecute(ByRef qHandle As %Binary, Req As %String, Params As %String, RQReqStr As %String = "") As %Status
{
	n (qHandle,Req,Params,RQReqStr)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Req="" $$$OK
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pShowTransferedFlag=PJobj.%Get("ShowTransferedFlag")
	s pRefuseFlag=PJobj.%Get("RefuseFlag")
	i RQReqStr'="" d
	.s pShowTransferedFlag=$p(RQReqStr,",",1)
	.s pRefuseFlag=$p(RQReqStr,",",2)
	s:pShowTransferedFlag="" pShowTransferedFlag=1
	s:pRefuseFlag="" pRefuseFlag=0
	s pHandleType=PJobj.%Get("HandleType")
	s pCanceled=PJobj.%Get("Canceled")
	s pHospId=PJobj.%Get("gHospId")
	s pIncludeDefLoc=PJobj.%Get("IncludeDefLoc")
	s pReqDetailIdStr=PJobj.%Get("ReqDetailIdStr")
	
	s Type=""
	&sql(SELECT inrq_type
		INTO :Type
		FROM dhc_inrequest WHERE INRQ_INRQ_DR=:Req)
	
	s sql="select %ID RowId,"
	s sql=sql_" inrqi_inci_dr Inci,"
	s sql=sql_"inrqi_inci_dr->inci_code Code,"
	s sql=sql_"inrqi_inci_dr->inci_desc Description,"
	s sql=sql_"inrqi_reqqty Qty,"
	s sql=sql_"inrqi_ctuom_dr Uom,"
	s sql=sql_"inrqi_ctuom_dr->ctuom_desc UomDesc,INRQI_RefuseFlag as RefuseFlag,"
	s sql=sql_"INRQI_INRQ_ParRef->INRQ_No ReqNo,"
	s sql=sql_"INRQI_INRQ_ParRef->INRQ_RecLoc_DR ReqLoc,"
 	s sql=sql_"INRQI_INRQ_ParRef->INRQ_RecLoc_DR->Ctloc_Desc ReqLocDesc"
	s sql=sql_" From in_reqitm"
	s sql=sql_" where inrqi_inrq_parref in ("_Req_")"
	s sql=sql_" order by INRQI_Childsub asc"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while(xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		continue:(pReqDetailIdStr'="")&&(("^"_pReqDetailIdStr_"^")'[("^"_RowId_"^"))  ;申请单模板里面多选使用lihui20170912
		s (ReqDate,RecLocDR,RequestedLoc,ReqPuomQty)=""
		&sql(select inrq_date,INRQ_ReqLoc_DR,INRQ_RecLoc_DR into :ReqDate,:RequestedLoc,:RecLocDR  from in_request where %ID=:Req)
		i pIncludeDefLoc=1 s RequestedLoc=SupplyPhaLoc   //支配的情况下 供应科室取界面传入科室
		s Inci=xrs.Data("Inci")
		s Code=xrs.Data("Code")
		s Description=xrs.Data("Description")
		s Qty=xrs.Data("Qty")
		s Uom=xrs.Data("Uom")
		s UomDesc=xrs.Data("UomDesc")
		s RefuseFlag=xrs.Data("RefuseFlag")
		s ReqNo=xrs.Data("ReqNo")
		s ReqLoc=xrs.Data("ReqLoc")
		s ReqLocDesc=xrs.Data("ReqLocDesc")
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s InrqiType="",InrqiCanceled="N",ReqRemarks="",ApprovedQty="",SpecDesc=""
		s DhcInrqi=$o(^DHCINRQI(0,"INRQI",RowId,""))
		i DhcInrqi'="" d
		.s InrqiType=$p(^DHCINRQI(DhcInrqi),"^",7)
		.s InrqiCanceled=$p(^DHCINRQI(DhcInrqi),"^",8)
		.s ReqRemarks=$p(^DHCINRQI(DhcInrqi),"^",2)
		.s ApprovedQty=$p(^DHCINRQI(DhcInrqi),"^",3)
		.s SpecDesc=$p(^DHCINRQI(DhcInrqi),"^",6)
		continue:(Type="C")&(pHandleType'="")&(pHandleType'=InrqiType)
		continue:(pCanceled'="")&(InrqiCanceled="Y")
		continue:(pRefuseFlag=0)&(RefuseFlag="Y")
		s:RefuseFlag="Y" RefuseFlag="拒绝"
		s:InrqiType=1 InrqiType="采购"
		s:InrqiType=0 InrqiType="出库"
		s InciRemarks=""
		&sql(select inci_remarks into :InciRemarks from inc_itm where inci_rowid=:Inci)
		s InciRemarks=$lts(InciRemarks)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",3)
		i ReqDate="" s ReqDate=+$h
		s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,ReqDate,Uom,pHospId)
		s SpAmt=Sp*Qty
		s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,Uom,pHospId)
		s RpAmt=Rp*Qty
		s RpAmtApproved=Rp*ApprovedQty   //批准进价金额
		s SpAmtApproved=Sp*ApprovedQty  //批准售价金额
		s TransQty=##class(web.DHCSTMHUI.DHCINIsTrf).TransQty(RowId)  ;已转移数量(基本单位)
		s BUom=$p(^INCI(Inci,1),"^",10)   ;基本单位
		s BUomDesc=""
		s:BUom'="" BUomDesc=$p(^CT("UOM",BUom),"^",2)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
		s PurUom=$p(^INCI(Inci,3),"^",6)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUom,BUom)
		s TransQty=TransQty/Fac
		s NotTransQty=Qty-TransQty
		i NotTransQty<0 s NotTransQty=0
		continue:(pShowTransferedFlag=0)&(NotTransQty<=0)  ;不显示已转移完成的明细
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,RequestedLoc,+$h)	//供应科室库存
		s StkQty=StkQty/Fac
		s ProLocAllAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(RequestedLoc,Inci,Uom) ;取供应科室物资库存项当前可用库存
		s ReqBuomQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,RecLocDR,+$h)
		s ReqPuomQty=ReqBuomQty/Fac                                    //申请科室库存
		s Incil="",RepLev=0
		s Inclb=""
		i RequestedLoc'=ReqLoc d
		.s RequestedLocxx=RequestedLoc
		e  d
		.s RequestedLocxx=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(Inci,ReqLoc),"^",1)
		s:RequestedLocxx'="" Incil=$o(^INCI("IL_LOC",RequestedLocxx,Inci,""))
		s:Incil'="" RepLev=+$p(^INCI(Inci,"IL",Incil),"^",5)
		s RepLev=RepLev/ConFac
		s ProvLoc=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(Inci,ReqLoc),"^",2)
		s ProvLocId=$P(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetprovLoc(Inci,ReqLoc),"^",1)
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
		s ZeroStkFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetZeroStkFlag(Inci,ProvLoc)
		s NotUseFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetNotUseFlag(Inci)
		i NotUseFlag="Y" s NotUseFlag="停用"
		e  s NotUseFlag="使用"
		s LimitAmtStr=##class(web.DHCSTMHUI.LocLimitAmt).GetLimitAmtStr(ReqLoc,Inci)
		s LimitType=$p(LimitAmtStr,"^",1)
		s ReqAmt=$p(LimitAmtStr,"^",2)
		s LeftAmt=$p(LimitAmtStr,"^",3)
		s NoLocReqFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncNoLocReq(Inci)
		d OutPutRow
	}

	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Inci,Code,Description,Qty,
		Uom,UomDesc,Spec,Manf,Sp,
		SpAmt,ReqRemarks,TransQty,NotTransQty,BUom,
		ConFac,StkQty,Rp,RpAmt,ApprovedQty,
		RpAmtApproved,SpAmtApproved,InciRemarks,RefuseFlag,BUomDesc,
		SpecDesc,ReqNo,ReqLocDesc,RepLev,ProvLoc,
		HVFlag,ZeroStkFlag,InrqiType,InrqiCanceled,ReqPuomQty,
		ProLocAllAvaQty,ProvLocId,NotUseFlag,
		LimitType,ReqAmt,LeftAmt,NoLocReqFlag
	)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 保存请求单明细数据
/// Author:XuChao
/// Date:2018-05-3
/// Argu:
///       Req - 请求单主表rowid
///       Rows - 请求单明细记录数据串(记录之间用","分隔)
/// Return:
ClassMethod Save(Req As %String, Rows As %String) As RtnObj
{
	n (Req,Rows)
	s RtnObj=##class(RtnObj).%New()
	i Req="" s Sc=RtnObj.Err(-1,"","Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	i ..sssLock(##class(web.DHCSTMHUI.INRequest).%GetParameter("AppName")_Req)<0 d
	.s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj  
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Inci=Obj.%Get("Inci")
		s Uom=Obj.%Get("Uom")
		s Qty=Obj.%Get("Qty")
		s ReqRemarks=Obj.%Get("ReqRemarks")
		s SpecDesc=Obj.%Get("SpecDesc")
		s AddFlag="Y"	//是否新增
		
		i RowId=""  d
		.s Ch=$o(^INRQ(Req,"RQI",""),-1)+1
		.s ReqDate=$p(^INRQ(Req),"^",2)
		.&sql(insert into in_reqitm 
			(inrqi_inrq_parref,inrqi_childsub,inrqi_inci_dr,inrqi_reqqty,inrqi_ctuom_dr,inrqi_date)
			values
			(:Req,:Ch,:Inci,:Qty,:Uom,:ReqDate) )
		.i SQLCODE'=0  s Sc=RtnObj.Err(-11,"","插入明细失败!")
		.i RtnObj.success'=0  q
		.s RowId=Req_"||"_Ch
		e  d
		.s AddFlag="N"
		.s obj=##class(User.INReqItm).%OpenId(RowId)
		.d obj.%Reload()
		.d obj.INRQIINCIDRSetObjectId(Inci)
		.s obj.INRQIDate=+$h
		.d obj.INRQICTUOMDRSetObjectId(Uom)
		.s obj.INRQIReqQty=+Qty
		.s sc= obj.%Save()
		.i $$$ISERR(sc) s Sc=RtnObj.Err(-21,"","更新明细失败!")
		.i RtnObj.success'=0 q
		q:RtnObj.success'=0
		
		s InrqiRowId=$o(^DHCINRQI(0,"INRQI",RowId,""))
		i (AddFlag="Y")&&(InrqiRowId'="") d
		.s InrqiRowId=""
		.&sql(delete from DHC_INReqItm WHERE INRQI_INRQI_DR=:RowId)
		.i SQLCODE'=0 d RtnObj.Err(-12,RowId,"附加表历史数据删除失败!"_SQLCODE)
		q:RtnObj.success'=0
		
		i InrqiRowId="" d
		.&sql(insert into dhc_inreqitm 
			(INRQI_INRQI_DR,INRQI_Remark,INRQI_SpecList)
			values 
			(:RowId,:ReqRemarks,:SpecDesc))
		.i SQLCODE'=0  s Sc=RtnObj.Err(-11,"","插入明细附加表失败!")
		.i RtnObj.success'=0  q
		e  d
		.&sql(update dhc_inreqitm set INRQI_Remark=:ReqRemarks,INRQI_SpecList=:SpecDesc where INRQI_INRQI_DR=:RowId)
		.i SQLCODE'=0  s Sc=RtnObj.Err(-31,"","更新附加表失败!")
		.i RtnObj.success'=0  q
		q:RtnObj.success'=0
	}
	d ..sssUnLock(##class(web.DHCSTMHUI.INRequest).%GetParameter("AppName")_Req)
	q RtnObj
}

/// Descript:	修改批准数量
/// Creater:	lxt
/// CreateDate:	2020-03-12
/// Table:		dhc_inreqitm
/// Input:		明细
/// Return：	成功，失败
ClassMethod jsModifyQtyApproved(Details As %String) As %String
{
	n (Details)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..ModifyQtyApproved(Details)
	q RtnObj.Json()
}

/// w #class(web.DHCSTMHUI.INReqItm).ModifyQtyApproved("[{""RowId"":""161||1"",""Inci"":""1492"",""Code"":""W050401055"",""Description"":""一次性雾化吸入嘴"",""Qty"":""10"",""Uom"":""5"",""UomDesc"":""个"",""Spec"":"""",""Manf"":""TADHHCDS-泰安东华合创大厦"",""Sp"":""1.8"",""SpAmt"":""18"",""ReqRemarks"":"""",""TransQty"":""0"",""NotTransQty"":""10"",""BUomId"":""5"",""ConFac"":""1"",""StkQty"":""0"",""Rp"":""1"",""RpAmt"":""10"",""QtyApproved"":""3"",""RpAmtApproved"":""10"",""SpAmtApproved"":""18"",""InciRemarks"":"""",""RefuseFlag"":"""",""BUomDesc"":""个"",""SpecDesc"":"""",""ReqNo"":""QXKKFWJWS MREQ20200313001"",""ReqLocDesc"":""QXKKF-器械科库房"",""RepLev"":""0"",""ProvLoc"":"""",""HVFlag"":""N"",""ZeroStkFlag"":""N"",""INRQIType"":"""",""INRQICanceled"":"""",""ReqPuomQty"":""0"",""ProLocAllAvaQty"":""0"",""ProvLocId"":""""}]")
ClassMethod ModifyQtyApproved(Details As %String) As RtnObj
{
	n (Details)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Details)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!") q RtnObj
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s ApprovedQty=Obj.%Get("ApprovedQty")
		
		s dhcInrqi=""
		&sql(select %id into :dhcInrqi from dhc_inreqitm where inrqi_inrqi_dr=:RowId)
		i SQLCODE d
		.&sql(insert into dhc_inreqitm(inrqi_inrqi_dr) values (:RowId))
		.i SQLCODE'=0  d RtnObj.Err(-2,"","插入明细失败!") q
		.s dhcInrqi=$g(%ROWID)

		i dhcInrqi'="" d
		. &sql(update dhc_inreqitm set inrqi_qtyapproved=:ApprovedQty where inrqi_rowid=:dhcInrqi)  //更新批准数量
		. i SQLCODE'=0 d RtnObj.Err(-3,"","插入明细失败!") q

		s Inrq=$p(RowId,"||",1),ch=$p(RowId,"||",2)
		s Qty=$p(^INRQ(Inrq,"RQI",ch),"^",3)
		s Inci=$p(^INRQ(Inrq,"RQI",ch),"^",4)
		s UomId=$p(^INRQ(Inrq,"RQI",ch),"^",5)
		s BUomId=$p(^INCI(Inci,1),"^",10)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s GapQtyBUom=(ApprovedQty-Qty)*UomFac
		i +GapQtyBUom'=0 d
		.s ret=##class(web.DHCSTMHUI.INRequest).HandleItmResQty(RowId,GapQtyBUom)
		.i ret'=0 d RtnObj.Err(-4,"","插入明细失败!") q

		q:RtnObj.success'=0
		s RtnObj.rowid=RowId
	}
	i RtnObj.success'=0  tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	设置请求单明细的拒绝状态
/// Creater:	lxt
/// CreateDate:	2018-06-08
/// Table:		in_reqitm
/// Input:		明细rowid
/// Return：	成功，失败
ClassMethod SetItmStatus(Reqi As %String) As %String
{
	n (Reqi)
	s RtnObj=##class(RtnObj).%New()
	i Reqi="" s Sc=RtnObj.Err(-1,"","入参不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Status="Y"
	&sql(update in_reqitm set INRQI_RefuseFlag=:Status where INRQI_RowId=:Reqi)
	i SQLCODE<0  s Sc=RtnObj.Err(-2,"","拒绝失败")
	q:RtnObj.success'=0 RtnObj.Json()
	
	q RtnObj.Json()
}

/// Descript: 撤销
/// w ##class(web.DHCSTMHUI.INReqItm).Cancel(reqi) 
/// -1 已经撤销
ClassMethod Cancel(reqi As %String, user As %String) As %Library.String
{
	n (reqi,user)
	s d=+$h
	s t=$p($h,",",2)
	s canceled="N"
	s yes="Y"
	&sql(select INRQI_Canceled into :canceled from DHC_INReqItm where INRQI_INRQI_DR=:reqi)
	q:canceled="Y" -1
	s find=0
	s ippi="",inti=""
	&sql(select INITI_RowId into :inti from DHC_InIsTrfItm where INITI_INRQI_DR=:reqi)
	i SQLCODE=0 d
	.s find=1
	q:find>0 find

	&sql(select PPREQI_RowId into :ippi from DHC_INPPReqItm where PPREQI_REQITM_DR=:reqi)
	i SQLCODE=0 d
	.s inp=+ippi
	.s AuditFlag="N"
	.s find=-1
	.&sql(select INPP_AuditFlag into :AuditFlag from IN_PURPLAN where INPP_Rowid=:inp)
	.i AuditFlag="Y" d
	..s find=2
	q:find>0 find
	///find 不大于0(0 和-1 ) 处理 canceled
	&sql(update DHC_INReqItm set INRQI_Canceled=:yes,INRQI_CanceledUser_DR=:user,INRQI_CanceledDate=:d,INRQI_CanceledTime=:t where INRQI_INRQI_DR=:reqi)
	i find=-1 d
	.&sql(update IN_PURPLANITM set INPPI_ReqCanceled=:yes where INPPI_Rowid=:ippi)
	q 0
}

/// 获取审批数量(审批数量为空的,取请求数量)
/// Author:	wangjiabin
/// Date:	2017-04-21
/// Argu:	inrqi
/// Return: 审批数量(或请求数量)
/// w ##class(web.DHCSTMHUI.INReqItm).GetApprovedQty("4386||1")
ClassMethod GetApprovedQty(inrqi As %String) As %String
{
	n (inrqi)
	
	s inrq=$p(inrqi,"||",1),ch=$p(inrqi,"||",2)
	q:(inrq="")||(ch="") ""
	s dhcInrqi=$o(^DHCINRQI(0,"INRQI",inrqi,""),-1)
	s qty=""
	i dhcInrqi'="" d
	.s qty=$p(^DHCINRQI(dhcInrqi),"^",3)
	q:qty'="" qty
	
	;没有供应方审批数量的,按请求数量取值
	s qty=$p(^INRQ(inrq,"RQI",ch),"^",3)
	q qty
}

/// 显示明细存在哪些出库单信息
/// Author:	lihui
/// Date:	20220811
/// Argu:	inrqi
/// Return: 出库单号^接收科室@出库单号^接收科@...
/// w ##class(web.DHCSTMHUI.INReqItm).GetTrfInfoByReqi("23||2")
ClassMethod GetTrfInfoByReqi(inrqi As %String) As %String
{
	n (inrqi)
	q:inrqi="" ""
	s returninfo=""
	s init=""
	f  s init=$o(^DHCINIT(0,"RQI",inrqi,init)) q:init=""  d
	.q:'$d(^DHCINIT(init))
	.s initinfo=^DHCINIT(init)
	.s initno=$p(initinfo,"^",1)
	.s toLocid=$p(initinfo,"^",6)
	.s toLocdesc=$s(toLocid'="":$p(^CTLOC(toLocid),"^",2),1:"")
	.i returninfo="" d
	..s returninfo=initno_","_toLocdesc
	.e  d
	..s returninfo=returninfo_"@"_initno_","_toLocdesc
	q returninfo
}

}
