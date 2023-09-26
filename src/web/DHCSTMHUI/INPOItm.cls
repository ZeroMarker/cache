Import sqluser

/// Descript:	订单明细
/// Creator:	lxt
/// CreateDate:	2018-07-27
Class web.DHCSTMHUI.INPOItm Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询订单明细
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PoItm
/// Input:		排序，查询条件
/// Return：	订单明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPOItm","Query","72")
Query Query(PoId As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,UomId,UomDesc,AvaQty:%Float,Rp:%Float,PurQty:%Float,ImpQty:%Float,Spec,ManfDesc,RpAmt:%Float,SpecDesc,BUomId,ConFac:%Float,CerNo,CerExpDate,ImpQtyAudited,CancleFlag,PhManf,ApcVendor,Remark,GoodId,ThirdOrderDetailId") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, PoId As %String) As %Status
{
	n (qHandle,PoId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s SqlStr = "SELECT IN_POItm as RowId,"
	s SqlStr=SqlStr_"INPOI_Childsub as Ch,"
	s SqlStr=SqlStr_"INPOI_INCI_DR InciId,INPOI_INCI_DR->inci_code as InciCode,INPOI_INCI_DR->inci_desc as InciDesc,"
	s SqlStr=SqlStr_"INPOI_CTUOM_DR UomId,INPOI_CTUOM_DR->ctuom_desc as UomDesc,"
	s SqlStr=SqlStr_"INPOI_Pur_Qty as PurQty, INPOI_Req_Qty as Qty,INPOI_Remarks as Remark,"
	s SqlStr=SqlStr_"INPOI_UnitCost as Rp,INPOI_GrossAmt as RpAmt,INPOI_ThirdOrderDetailId as ThirdOrderDetailId "
	s SqlStr=SqlStr_" FROM IN_PoItm WHERE IN_PO="_PoId
	s SqlStr=SqlStr_" order by INPOI_Childsub asc"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s InciId = Result.Data("InciId")
		CONTINUE:InciId=""
		s InciCode=Result.Data("InciCode")
		s InciDesc=Result.Data("InciDesc")
		s UomId = Result.Data("UomId")
		s UomDesc=Result.Data("UomDesc")
		s Rp=Result.Data("Rp")
		s RpAmt=Result.Data("RpAmt")
		s PurQty =+ Result.Data("PurQty")  ;订购数量
		s Remark=Result.Data("Remark")
		s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s Remark=$LTS(Remark,memoDelim)
		s ImpQtyInfo=##class(web.DHCSTMHUI.INPOItm).GetImpQty(RowId,UomId)  ;到货数量
		s ImpQty=$p(ImpQtyInfo,"^",1)			;入库制单数量
		s ImpQtyAudited=$p(ImpQtyInfo,"^",2)	;入库审核数量
		s AvaQty=PurQty-ImpQty    ;还可以入库的数量		;未到货数量

		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s SpecDesc="",CancleFlag="",ManfId="",ManfDesc=""
		s dhcpoi=$o(^DHCINPOI(0,"INPOI",RowId,""),-1)
		i dhcpoi'="" d
		.s SpecDesc=$p(^DHCINPOI(dhcpoi),"^",5)
		.s CancleFlag=$p(^INPO(PoId),"^",18)
		.i CancleFlag'="Y" s CancleFlag="N"
		.s ManfId=$p(^DHCINPOI(dhcpoi),"^",14)
		.s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
		s CerInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(InciId)
		s CerNo=$p(CerInfo,"^",1)
		s CerExpDate=$p(CerInfo,"^",2)
		s PurItmInfo=##class(web.DHCSTMHUI.INPO).GetPlanItmInfo(RowId)
		s PhManf=$p(PurItmInfo,"^",2)
		i PhManf="" s PhManf=ManfDesc
		s ApcVendor=$p(PurItmInfo,"^",4)
		;阳光采购
		s SunPurPlanInfo=##class(web.DHCSTMHUI.ServiceForSCYGCG).GetSubCode(InciId)
		s GoodId=$p(SunPurPlanInfo,"^",3)
		s ThirdOrderDetailId=Result.Data("ThirdOrderDetailId")
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,InciId,InciCode,InciDesc,UomId,UomDesc,AvaQty,Rp,
		PurQty,ImpQty,Spec,ManfDesc,RpAmt,SpecDesc,BUomId,ConFac,CerNo,
		CerExpDate,ImpQtyAudited,CancleFlag,PhManf,ApcVendor,Remark,GoodId,ThirdOrderDetailId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	取某订单明细对应的入库数量
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PoItm，DHC_InGdRecItm
/// Input:		采购计划明细id
/// Return：	入库制单数量^入库审核数量
ClassMethod GetImpQty(PoItmId As %String, UomId As %String) As %Library.String
{
	n (PoItmId,UomId)
	q:PoItmId="" 0
	s PoId=$p(PoItmId,"||",1),PoItmCh=$p(PoItmId,"||",2)
	q:(PoId="")||(PoItmCh="") 0
	s IncId=$p(^INPO(PoId,"POI",PoItmCh),"^",1)
	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PurUomId=$p(^INCI(IncId,3),"^",6)

	s TotalQty=0,TotalQtyAudited=0
	s Ingr=0
	f  s Ingr=$o(^DHCINGR(0,"PODR",PoItmId,Ingr)) q:Ingr=""  d
	.s Chl=0
	.f  s Chl=$o(^DHCINGR(0,"PODR",PoItmId,Ingr,Chl)) q:Chl=""  d
	..s Inclb=$p(^DHCINGR(Ingr,"GRI",Chl),"^",1)
	..s Qty=$p(^DHCINGR(Ingr,"GRI",Chl),"^",4)
	..s RecUomId=$p(^DHCINGR(Ingr,"GRI",Chl),"^",10)
	..s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RecUomId,BUomId)
	..s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	..s Qty=Qty*Fac1/Fac2
	..s TotalQty=TotalQty+Qty
	..s:Inclb'="" TotalQtyAudited=TotalQtyAudited+Qty
	q TotalQty_"^"_TotalQtyAudited
}

/// Descript:	保存/更新订单明细信息
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PoItm
/// Input:		订单主表id,明细信息
/// Return：	成功，失败
ClassMethod Save(PoId As %String, Details As %String) As RtnObj
{
	n (PoId,Details)
	s RtnObj=##class(RtnObj).%New()
	i PoId="" d RtnObj.Err(-11,"","主单Id不能为空!","",0) q RtnObj
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Details)
	i Sc'=0 d RtnObj.Err(-12,"","入参解析失败!") q RtnObj
	i ..sssLock(##class(web.DHCSTMHUI.INPurPlan).%GetParameter("AppName")_PoId)<0  d RtnObj.Err(-99,"","加锁失败!") q RtnObj

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s IncId=Obj.%Get("InciId")
		i IncId=0  d RtnObj.Err(-13,"","缺少明细数据！","",0) q
		s UomId=Obj.%Get("UomId")
		s Rp=Obj.%Get("Rp")
		s Qty=+Obj.%Get("PurQty")
		s ReqQty=Obj.%Get("ReqQty")
		s SpecDesc=Obj.%Get("SpecDesc")
		s ManfId=Obj.%Get("ManfId")
		s DemandDate=Obj.%Get("DemandDate")
		s Remark=Obj.%Get("Remark")
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s Remark=$LFS(Remark,MemoDelim)
		
		i ReqQty="" s ReqQty=Qty
		s CreateDate=+$h
		s BuomId=$p(^INCI(IncId,1),"^",10)
		s (LocId,HospId)=""
		s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
		s:DhcPoId'="" LocId=$p(^DHCINPO(DhcPoId),"^",2)
		s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
		i UomId=BuomId d
		.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,2)
		e  d
		.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospId,1)
		s RpAmt=Rp*Qty
		s RpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(RpAmt,HospId)

		s AddFlag="Y"	//订单是否新增
		i RowId="" d
		.s Chl=$o(^INPO(PoId,"POI",""),-1)+1
		.&sql(insert into IN_PoItm(IN_PO,INPOI_Childsub,INPOI_Date,INPOI_INCI_DR,
		INPOI_CTUOM_DR,INPOI_UnitCost,INPOI_GrossAmt,INPOI_Req_Qty,INPOI_Pur_Qty,
		INPOI_CTLOC_DR,INPOI_Remarks)
		values (:PoId,:Chl,:CreateDate,:IncId,:UomId,:Rp,:RpAmt,:ReqQty,:Qty,:LocId,:Remark))
		.i SQLCODE'=0  d RtnObj.Err(-14,"","插入明细失败!") q
		.s RowId=PoId_"||"_Chl
		e  d
		.s AddFlag="N"
		.&sql(update IN_PoItm set INPOI_Date=:CreateDate,INPOI_INCI_DR=:IncId,
		INPOI_CTUOM_DR=:UomId,INPOI_UnitCost=:Rp,INPOI_GrossAmt=:RpAmt,INPOI_Req_Qty=:ReqQty,
		INPOI_Pur_Qty=:Qty,	INPOI_CTLOC_DR=:LocId,INPOI_Remarks=:Remark
		where %ID=:RowId)
		.i SQLCODE'=0  d RtnObj.Err(-16,"","更新明细失败!") q
		q:RtnObj.success'=0
		
		s DHCINPoItmId=$o(^DHCINPOI(0,"INPOI",RowId,""),-1)
		i (AddFlag="Y")&&(DHCINPoItmId'="") d
		.s DHCINPoItmId=""
		.&sql(delete from DHC_INPOItm where POI_INPOI_DR=:RowId)
		.i SQLCODE'=0 d RtnObj.Err(-12,RowId,"附加表历史数据删除失败!"_SQLCODE)
		q:RtnObj.success'=0
		
		i DHCINPoItmId="" d
		.&sql(insert into DHC_INPOItm (POI_INPOI_DR,POI_SpecList,POI_PHMNF_DR,POI_DemandDate) values (:RowId,:SpecDesc,:ManfId,:DemandDate))
		.i SQLCODE'=0  d RtnObj.Err(-15,"","插入明细附加表失败!") q
		e  d
		.&sql(update DHC_INPOItm set POI_SpecList=:SpecDesc,POI_PHMNF_DR=:ManfId,POI_DemandDate=:DemandDate where POI_INPOI_DR=:RowId)
		.i SQLCODE'=0  d RtnObj.Err(-17,"","更新明细附加表失败!") q

		q:RtnObj.success'=0
		s RtnObj.rowid=RowId
	}
	d ..sssUnLock(##class(web.DHCSTMHUI.INPurPlan).%GetParameter("AppName")_PoId)
	i RtnObj.success'=0  tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	删除订单明细信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.INPOItm).jsDelete("[{""RowId"":""40||1"",""InciId"":""9627"",""InciCode"":""cl0420ggggg"",""InciDesc"":""cl0420高值"",""UomId"":""5"",""UomDesc"":""个"",""AvaQty"":""0""   ,""Rp"":""77"",""PurQty"":""0"",""ImpQty"":""0"",""Spec"":""aaaaa"",""ManfDesc"":""cl超级飞侠2"",""RpAmt"":""0"",""SpecDesc"":"""",""BUomId"":""5"",""ConFac"":"    "1"",""CerNo"":"""",""CerExpDate"":"""",""ImpQtyAudited"":""0"",""CancleFlag"":""""}]")
ClassMethod jsDelete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Delete(Params)
	q RtnObj.Json()
}

/// Descript:	删除订单明细信息
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PurPlanItm
/// Input:		主表id，明细信息
/// Return：	失败，成功
/// w ##class(web.DHCSTMHUI.INPOItm).Delete("[{""RowId"":""40||1"",""InciId"":""9627"",""InciCode"":""cl0420ggggg"",""InciDesc"":""cl0420高值"",""UomId"":""5"",""UomDesc"":""个"",""AvaQty"":""0""   ,""Rp"":""77"",""PurQty"":""0"",""ImpQty"":""0"",""Spec"":""aaaaa"",""ManfDesc"":""cl超级飞侠2"",""RpAmt"":""0"",""SpecDesc"":"""",""BUomId"":""5"",""ConFac"":"    "1"",""CerNo"":"""",""CerExpDate"":"""",""ImpQtyAudited"":""0"",""CancleFlag"":""""}]")
ClassMethod Delete(Params As %String) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		i RowId=""  s Sc=RtnObj.Err(-2,"","不允许删除!","",0)
		q:RtnObj.success'=0
		s CompFlag=$p(^INPO(+RowId),"^",9)
		i CompFlag="Y"  s Sc=RtnObj.Err(-2,"","订单已经完成，不能删除!","",0)
		q:RtnObj.success'=0
		s SendFlag=$p(^INPO(+RowId),"^",24)
		i SendFlag="Y"  s Sc=RtnObj.Err(-2,"","订单已经上传，不能删除!","",0)
		q:RtnObj.success'=0
		&sql(Delete from DHC_INPOItm where POI_INPOI_DR=:RowId)
		i SQLCODE'=0  s Sc=RtnObj.Err(-3,"","删除明细附加表失败!")
		q:RtnObj.success'=0
		&sql(Delete from IN_PoItm  where In_PoItm=:RowId)
		i SQLCODE'=0  s Sc=RtnObj.Err(-4,"","删除明细失败!")
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0  tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:	查询所有订单明细
/// Creator:	lxt
/// CreateDate:	2018-08-11
/// Table:		IN_PoItm
/// Input:		主表信息，明细信息
/// Return：	明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPOItm","QueryAll",^bintmp(254))
Query QueryAll(Params As %String) As Query(ROWSPEC = "RowId,PoId,PoNo,VendorId,VendorDesc,PoLocId,PoLocDesc,PoStatus,CreateDate,CreateUserId,StkScgId,CompFlag,Email,ReqLocId,ReqLocDesc,InciId,InciCode,InciDesc,UomId,UomDesc,AvaQty:%Float,Rp:%Float,PurQty:%Float,ImpQty:%Float,Spec,ManfId,ManfDesc,RpAmt:%Float,BuomId,ConFac:%Float,SMSSentFlag,PlatSentFlag,Mobile,SpecDesc,ReqRemark,PurNo,PhManf") [ SqlProc ]
{
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	s pPoLocId=PJObj.%Get("PoLoc")		//采购科室
	s pPoNo=PJObj.%Get("PoNo")		//订单号
	s pVendorId=PJObj.%Get("Vendor")	 //供应商
	s pReqLocId=PJObj.%Get("ReqLoc")	 //请求科室
	s pCompFlag=PJObj.%Get("CompFlag")	 //完成标志
	s pApproveFlag=PJObj.%Get("ApproveFlag")	 //审核标志
	s pStatus=PJObj.%Get("Status")	 //订单状态
	s pInciId=PJObj.%Get("Inci")  //物资Id
	s pInciDesc=PJObj.%Get("InciDesc")  //物资名称
	s pDefLocPP=PJObj.%Get("DefLocPP")		//是否包含支配科室
	s pNoSend=PJObj.%Get("NoSend")  //未发送短信
	s pNoUpload=PJObj.%Get("NoUpload")  //未上传平台
	s pStkScgId=PJObj.%Get("StkScg")		//类组
	s pIncludeCancel=PJObj.%Get("IncludeCancel")  //拒绝明细
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")

	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)

	s type=..sssCode()
	s pHospId=..sssHospId(pPoLocId)
	s:pHospId="" pHospId=gHospId
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,pPoLocId,pStkScgId,pHospId)

	s result = ##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT IN_POItm as RowId,IN_PO PoId,IN_PO->INPO_No PoNo,"
	s SqlStr=SqlStr_"INPOI_INCI_DR InciId,INPOI_INCI_DR->inci_code InciCode,INPOI_INCI_DR->inci_desc InciDesc,"
	s SqlStr=SqlStr_"INPOI_CTUOM_DR UomId,INPOI_CTUOM_DR->CTUOM_desc UomDesc,"
	s SqlStr=SqlStr_"INPOI_UnitCost Rp,INPOI_Pur_Qty PurQty,INPOI_GrossAmt RpAmt,"
	s SqlStr=SqlStr_"IN_PO->INPO_APCVM_DR VendorId,IN_PO->INPO_APCVM_DR->APCVM_Name VendorDesc,"
	s SqlStr=SqlStr_"IN_PO->INPO_Date CreateDate,IN_PO->INPO_Completed CompFlag,IN_PO->INPO_Approved ApproveFlag,IN_PO->INPO_Cancelled CancelFlag "
	s SqlStr=SqlStr_" FROM IN_PoItm "
	s SqlStr=SqlStr_" WHERE IN_PO->INPO_Date between "_pStartDate_" and "_pEndDate
	s:pPoNo'="" SqlStr=SqlStr_" and IN_PO->INPO_No like '%"_pPoNo_"%' "
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK

	i ((pPoLocId'="")&&(pDefLocPP="Y")) d
	.s domiLocs=##class(web.DHCSTMHUI.Common.UtilCommon).GetDominLoc(pPoLocId)
	.i domiLocs'=""  d
	..s pPoLocId=pPoLocId_","_domiLocs

	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s PoId = Result.Data("PoId")
		s PoNo = Result.Data("PoNo")
		s InciId = Result.Data("InciId")
		CONTINUE:(pInciId'="")&(pInciId'=InciId)
		s InciCode = Result.Data("InciCode")
		s InciDesc = Result.Data("InciDesc")
		CONTINUE:(pInciId="")&&(pInciDesc'="")&&(pInciDesc'[InciId)
		s UomId = Result.Data("UomId")
		s UomDesc = Result.Data("UomDesc")
		s Rp = Result.Data("Rp")
		s PurQty = Result.Data("PurQty")
		s RpAmt = Result.Data("RpAmt")
		s VendorId = Result.Data("VendorId")
		CONTINUE:(pVendorId'="")&(pVendorId'=VendorId)
		s VendorDesc = Result.Data("VendorDesc")
		s CreateDate = Result.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s CompFlag = Result.Data("CompFlag")
		s:CompFlag="" CompFlag="N"
		CONTINUE:(pCompFlag'="")&(CompFlag'=pCompFlag)
		s ApproveFlag = Result.Data("ApproveFlag")
		s:ApproveFlag="" ApproveFlag="N"
		CONTINUE:(pApproveFlag'="")&(pApproveFlag'=ApproveFlag)
		s CancelFlag = Result.Data("CancelFlag")
		s:CancelFlag="" CancelFlag="N"
		CONTINUE:(pIncludeCancel="")&(CancelFlag="Y")
		s (Email,PoLocDesc,ReqLocDesc,ApproveUserDR,ApproveUser,ApproveDate,ApproveTime)=""
		&sql(select STV_VendorEmail into :Email from DHC_STVendor where STV_Vendor_DR=:VendorId)
		s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,""),-1)
		CONTINUE:DhcPoId=""
		s PoLocId =$p(^DHCINPO(DhcPoId),"^",2)
		CONTINUE:((","_pPoLocId_",")'[(","_PoLocId_","))
		s:PoLocId'="" PoLocDesc=$p(^CTLOC(PoLocId),"^",2),PoLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(PoLocDesc)
		s ReqLocId=$p(^DHCINPO(DhcPoId),"^",5)
		CONTINUE:(pReqLocId'="")&&(pReqLocId'=ReqLocId)
		s:ReqLocId'="" ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2),ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s PoType=$p(^DHCINPO(DhcPoId),"^",4)
		CONTINUE:(PoType'=type)
		s StkScgId=$p(^DHCINPO(DhcPoId),"^",3)
		CONTINUE:(StkScgId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkScgId_"^"))
		s CreateUserId=$p(^INPO(PoId),"^",7)
		s PoStatus=##class(web.DHCSTMHUI.INPO).GetPoStatus(PoId)
		CONTINUE:(pStatus'="")&('$f(pStatus,PoStatus))
		s PurQty =+ Result.Data("PurQty")  ;订购数量
		s ImpQtyInfo=##class(web.DHCSTMHUI.INPOItm).GetImpQty(RowId,UomId)  ;到货数量
		s ImpQty=$p(ImpQtyInfo,"^",1)			;入库制单数量
		s ImpQtyAudited=$p(ImpQtyInfo,"^",2)	;入库审核数量
		s AvaQty=PurQty-ImpQty    ;还可以入库的数量		;未到货数量
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s (ManfId,ManfDesc)=""
		s dhcpoi=$o(^DHCINPOI(0,"INPOI",RowId,""),-1)
		i dhcpoi'="" d
		.s ManfId=$p(^DHCINPOI(dhcpoi),"^",14)
		.s:ManfId'="" ManfDesc=$P(^PHMNF(ManfId),"^",2)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s SMSSentFlag="N",PlatSentFlag="N",CanceledFlag="N"
		&sql(select POI_SMS_SentFlag,POI_PlatSentFlag,POI_CanceledFlag into :SMSSentFlag,:PlatSentFlag,:CanceledFlag from DHC_INPOItm where POI_INPOI_DR=:RowId)
		continue:(pNoSend="Y")&(SMSSentFlag="Y")
		continue:(pNoUpload="Y")&(PlatSentFlag="Y")
		continue:CanceledFlag="Y"
		s Mobile=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbCarrier(InciId),"^",3)
		s ReqiId=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(RowId,"PO")
		s (INRQIType,INRQICanceled,QtyApproved,SpecDesc,ReqRemark)=""
		s dhcinrqi=$o(^DHCINRQI(0,"INRQI",ReqiId,""))
		i dhcinrqi'="" d
		.s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
		.s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
		.s ReqRemark=$p(^DHCINRQI(dhcinrqi),"^",2)
		.s QtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
		.s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)
		
		s PurNo=$p(^INPO(PoId),"^",1)
		s PurItmInfo=##class(web.DHCSTMHUI.INPO).GetPlanItmInfo(RowId)
		s PhManf=$p(PurItmInfo,"^",2)
		i PhManf="" s PhManf=ManfDesc
		
		s Inppi=""
		&sql(select %id into :Inppi from IN_PurPlanItm where INPPI_INPOI_DR =:RowId)
		i (Inppi="")||'$d(^INPP(+Inppi,"PPI",$p(Inppi,"||",2))) d
		.d OutPutRow2
		e  d
		.i '$d(^INPP(+Inppi,"PPI",$p(Inppi,"||",2),"RQI")) d
		..s ReqLocId=$p(^INPP(+Inppi,"PPI",$p(Inppi,"||",2)),"^",10)
		..s ReqLocDesc=$s(ReqLocId'="":$p(^CTLOC(ReqLocId),"^",2),1:"")
		..d OutPutRow2
		.e  d
		..&sql(declare InppReqCursor cursor for
			select PPREQI_REQITM_DR->INRQI_INRQ_Parref->INRQ_RecLoc_Dr,PPREQI_REQITM_DR->INRQI_INRQ_Parref->INRQ_RecLoc_Dr->CTLoc_Desc
			from DHC_INPPReqItm where PPREQI_INPPI_Parref=:Inppi)
		..&sql(open InppReqCursor)
		..f  &sql(fetch InppReqCursor into :ReqLocId,:ReqLocDesc) q:SQLCODE  d
		...d OutPutRow2
		..&sql(close InppReqCursor)
	}
	Quit $$$OK
OutPutRow2
	s Data=$lb(RowId,PoId,PoNo,VendorId,VendorDesc,PoLocId,PoLocDesc,PoStatus,
		CreateDate,CreateUserId,StkScgId,CompFlag,Email,ReqLocId,ReqLocDesc,InciId,
		InciCode,InciDesc,UomId,UomDesc,AvaQty,Rp,PurQty,ImpQty,Spec,ManfId,ManfDesc,
		RpAmt,BuomId,ConFac,SMSSentFlag,PlatSentFlag,Mobile,SpecDesc,ReqRemark,PurNo,PhManf)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// wangjiabin 2014-12-15 查询请求科室,请求数量报表
/// 用于订单对应请领科室的信息显示
Query INPOItmReqQuery(Parref As %String) As Query(ROWSPEC = "PoItmId,IncId,IncCode,IncDesc,PurUomId,PurUom,AvaQty:%Float,Rp:%Float,PurQty:%Float,ImpQty:%Float,Spec,Manf,RpAmt:%Float,ReqQty:%Float,ReqUom,ReqLocId,ReqLocDesc") [ SqlProc ]
{
}

ClassMethod INPOItmReqQueryExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle, Parref)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:Parref="" $$$OK
	&sql(select PO_CTLOC_DR,PO_CTLOC_DR->CTLoc_Desc,PO_ReqLoc_DR,PO_ReqLoc_DR->CTLoc_Desc into :PoLoc,:PoLocDesc,:PoReqLoc,:PoReqLocDesc from DHC_INPO where PO_INPO_DR=:Parref)
	s HospId=$p(^CTLOC(PoLoc),"^",22)
	s Params="^"_PoLoc_"^^"_HospId
	s PoByLoc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.INPO).%GetParameter("AppName"),"PoByLoc",Params)
	s result = ##class(%Library.ResultSet).%New()
	s StrSql = "SELECT IN_POItm as Rowid, INPOI_INCI_DR,INPOI_INCI_DR->inci_code as IncCode,"
		_"INPOI_INCI_DR->inci_desc as IncDesc, INPOI_CTUOM_DR,INPOI_CTUOM_DR->ctuom_desc as PurUom,"
		_"INPOI_UnitCost,INPOI_Pur_Qty,INPOI_GrossAmt "
		_"FROM IN_PoItm WHERE IN_PO= "_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s PoItmId = result.Data("Rowid")
		s IncId = result.Data("INPOI_INCI_DR")
		continue:IncId=""
		s PurUomId = result.Data("INPOI_CTUOM_DR")
		s PurUom=result.Data("PurUom")
		s Rp=result.Data("INPOI_UnitCost")
		s RpAmt=result.Data("INPOI_GrossAmt")
		s PurQty =+ result.Data("INPOI_Pur_Qty")  ;订购数量
		s ImpQty=+##class(web.DHCSTMHUI.INPOItm).GetImpQty(PoItmId,PurUomId)  ;到货数量
		s AvaQty=PurQty-ImpQty    ;还可以入库的数量		;未到货数量
		s IncCode=result.Data("IncCode")
		s IncDesc=result.Data("IncDesc")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s BUom=$p(^INCI(IncId,1),"^",10)
		s (ManfId,Manf)=""
		s dhcpoi=$o(^DHCINPOI(0,"INPOI",PoItmId,""),-1)
		i dhcpoi'="" d
		.s ManfId=$p(^DHCINPOI(dhcpoi),"^",14)
		.s:ManfId'="" Manf=$P(^PHMNF(ManfId),"^",2)
		s (Inppi,ReqLocId,ReqLocDesc,ReqQty,ReqUom)=""
		&sql(select %id into :Inppi from IN_PurPlanItm where INPPI_INPOI_DR =:PoItmId)
		i PoByLoc="Y" d
		.s ReqQty=PurQty,ReqUom=PurUom,ReqLocId=PoReqLoc,ReqLocDesc=PoReqLocDesc
		.d OutPutRowReq
		e   d
		.i (Inppi="")||'$d(^INPP(+Inppi,"PPI",$p(Inppi,"||",2))) d
		..d OutPutRowReq
		.e  d
		..i '$d(^INPP(+Inppi,"PPI",$p(Inppi,"||",2),"RQI")) d
		...s ReqLocId=$p(^INPP(+Inppi,"PPI",$p(Inppi,"||",2)),"^",10)
		...s ReqLocDesc=$s(ReqLocId'="":$p(^CTLOC(ReqLocId),"^",2),1:"")
		...d OutPutRowReq
		..e  d
		...&sql(declare InppiReqCursor cursor for
			select PPREQI_REQITM_DR,PPREQI_REQITM_DR->INRQI_ReqQty,PPREQI_REQITM_DR->INRQI_CTUOM_DR->CTUOM_Desc,PPREQI_REQITM_DR->INRQI_INRQ_Parref->INRQ_RecLoc_Dr,PPREQI_REQITM_DR->INRQI_INRQ_Parref->INRQ_RecLoc_Dr->CTLoc_Desc
			from DHC_INPPReqItm where PPREQI_INPPI_Parref=:Inppi)
		...&sql(open InppiReqCursor)
		...f  &sql(fetch InppiReqCursor into :Inrqi,:ReqQty,:ReqUom,:ReqLocId,:ReqLocDesc) q:SQLCODE  d
		....s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ReqUom,BUom)
		....s ReqQty=ReqQty*UomFac
		....s ReqQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(IncId,ReqQty)
		....d OutPutRowReq
		...&sql(close InppiReqCursor)
	}
	Quit $$$OK

OutPutRowReq
	s Data=$lb(PoItmId,IncId,IncCode,IncDesc,PurUomId,PurUom,AvaQty,Rp,PurQty,ImpQty,Spec,Manf,RpAmt,ReqQty,ReqUom,ReqLocId,ReqLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 支配科室
ClassMethod GetDominLoc(loc As %String) As %String
{
	n (loc)
	s dLocs=""
	&sql(declare domiLoc cursor for
		select dhcloc_ctloc_dr From dhcst_ctloc where dhcloc_mainloc_dr = :loc)
	&sql(open domiLoc)
	f  &sql(fetch domiLoc into :subLoc) q:SQLCODE  d
	.i dLocs="" s dLocs=subLoc
	.e  s dLocs=dLocs_"^"_subLoc
	&sql(close domiLoc)
	q dLocs
}

ClassMethod Send(poistr As %String, senduser As %String) As %String
{
 n (poistr,senduser)
 s len=$l(poistr,"^")
 s ret=0
 s d=+$h
 s zd=$zd(d,3)
 s t=$P($h,",",2)
 s yes="Y"
 s msg=""
 f i=1:1:len  d
 .s poi=$p(poistr,"^",i)
 .s PoNo=$p(^INPO(+poi),"^",1)
 .s Inci=$p(^INPO(+poi,"POI",$p(poi,"||",2)),"^",1)
 .s InciDesc=$p(^INCI(Inci,1),"^",2)
 .s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci) ;规格
 .s Qty=$p(^INPO(+poi,"POI",$p(poi,"||",2)),"^",7)
 .s Uom=$p(^INPO(+poi,"POI",$p(poi,"||",2)),"^",3)
 .s UomDesc=$p(^CT("UOM",Uom),"^",2)
 .s Reqi=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(poi,"PO")
 .s Loc="",LocDesc="",User=""
 .s:Reqi>0 Loc=$p(^INRQ(+Reqi),"^",6)
 .s:Loc'="" LocDesc=$p(^CTLOC(Loc),"^",2)
 .i $f(LocDesc,"-") d
 ..s LocDesc=$p(LocDesc,"-",2)
 .s:Reqi>0 User=$p(^INRQ(+Reqi),"^",4)
 .s UserName=""
 .s:User'="" UserName=$p(^SSU("SSUSR",User),"^",2)
 .s remark=""
 .s (INRQIType,INRQICanceled,remark,qtyApproved,SpecDesc)=""
 .s dhcinrqi=$o(^DHCINRQI(0,"INRQI",Reqi,""))
 .i dhcinrqi'="" d
 ..s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
 ..s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
 ..s remark=$p(^DHCINRQI(dhcinrqi),"^",2)
 ..s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
 ..s Spec=$p(^DHCINRQI(dhcinrqi),"^",6)
 .q:remark="打包收费"
 .;&sql(select INPOI_Remarks into :remark from IN_POItm where IN_POItm=:poi)
 .;&sql(select INRQI_Remark ,INRQI_SpecList into :remark,:Spec from DHC_INReqItm where INRQI_INRQI_DR=:Reqi)
 .s Exmsg=""
 .i $d(^DHCINPOI(0,"INPOI",poi)) d
 ..s Exmsg="催货,"
 .i msg="" d
 ..s msg=Exmsg_PoNo_","_LocDesc_","_UserName_","_InciDesc_","_Spec_","_Qty_","_UomDesc_","_remark_","_zd
 .e  d
 ..s msg=msg_"#"_Exmsg_PoNo_","_LocDesc_","_UserName_","_InciDesc_","_Spec_","_Qty_","_UomDesc_","_remark_","_zd
 .i '$d(^DHCINPOI(0,"INPOI",poi)) d
 ..&sql(insert into DHC_INPOItm(POI_INPOI_DR,POI_SMS_SentFlag) values(:poi,:yes))
 .e  d
 ..&sql(update DHC_INPOItm set POI_SMS_SentFlag=:yes where POI_INPOI_DR=:poi)
 s msg=msg_",---：北京同仁医院采购中心"
 s sendId=$p(^SSU("SSUSR",senduser),"^",1)
 s sendName=$p(^SSU("SSUSR",senduser),"^",2)
 s Mobile=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbCarrier(Inci),"^",3)
 s result=sendId_"^"_sendName_"^"_Mobile_"^"_msg_"^"_zd

 ////测试库未部署程序  暂时 注释
 i $d(^$R("^web.DHCENS.BLL.SMSPlatform.Method.SendInfoToSMS.1")) d
 .d ##class(web.DHCENS.BLL.SMSPlatform.Method.SendInfoToSMS).SendPurchaseInfoToSMS(result)
 s result=$REPLACE(result,"^",",")

 &sql(insert into DHC_INPOItmExpdLog(LOG_INPOI_DR,LOG_Type,LOG_Date,LOG_Time,LOG_SSUSR_DR,LOG_MSG)
 values(:poi,'S',:d,:t,:senduser,:result))
 q ret
}

/// Descript:   任务发送短信
/// Creater:    徐超
/// CreateDate: 2015-06-16
/// Table:
/// Input:
/// Output:
/// Return：0,成功
ClassMethod AutoSendSms()
{
	s d=+$h
	s inpo=0
	s user=""
	f  s inpo=$o(^INPO(inpo)) q:(inpo="")  d
	.s ch=0
	.f  s ch=$o(^INPO(inpo,"POI",ch)) q:(ch="")  d
	..s poi=inpo_"||"_ch
	..s smsflag="N"
	..&sql(select POI_SMS_SentFlag into :smsflag from DHC_INPOItm where POI_INPOI_DR=:poi)
	..q:smsflag="Y"
	..s ret=..Send(poi,user)
}

/// 拒绝一条
ClassMethod DenyDetail(RowIdStr As %String, senduser As %String) As %String
{
 n (RowIdStr,senduser)
 s Canceled=""
 &sql(select POI_CanceledFlag into :Canceled from DHC_INPOItm where POI_INPOI_DR=:RowIdStr)
 q:Canceled="Y" -2
 &sql(select INGRI_RowId from DHC_INGdRecItm where INGRI_INPOI_DR=:RowIdStr)
 q:SQLCODE=0 -1
 s yes="Y"
 i '$d(^DHCINPOI(0,"INPOI",RowIdStr)) d
 .&sql(insert into DHC_INPOItm(POI_INPOI_DR,POI_CanceledFlag) values(:RowIdStr,:yes))
 e  d
 .&sql(update DHC_INPOItm set POI_CanceledFlag=:yes  where POI_INPOI_DR=:RowIdStr)
 s len=$l(RowIdStr,"^")
 s ret=SQLCODE
 s d=+$h
 s zd=$zd(d,3)
 s t=$P($h,",",2)
 s yes="Y"
 s msg=""
 s len=$l(RowIdStr,"^")
 f i=1:1:len  d
 .s poi=$p(RowIdStr,"^",i)
 .s PoNo=$p(^INPO(+poi),"^",1)
 .s Inci=$p(^INPO(+poi,"POI",$p(poi,"||",2)),"^",1)
 .s InciDesc=$p(^INCI(Inci,1),"^",2)
 .s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci) ;规格
 .s Qty=$p(^INPO(+poi,"POI",$p(poi,"||",2)),"^",7)
 .s Uom=$p(^INPO(+poi,"POI",$p(poi,"||",2)),"^",3)
 .s UomDesc=$p(^CT("UOM",Uom),"^",2)
 .s Reqi=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(poi,"PO")
 .s Loc="",LocDesc="",User=""
 .s:Reqi>0 Loc=$p(^INRQ(+Reqi),"^",6)
 .s:Loc'="" LocDesc=$p(^CTLOC(Loc),"^",2)
 .i $f(LocDesc,"-") d
 ..s LocDesc=$p(LocDesc,"-",2)
 .s:Reqi>0 User=$p(^INRQ(+Reqi),"^",4)
 .s UserName=""
 .s:User'="" UserName=$p(^SSU("SSUSR",User),"^",2)
 .s remark=""
 .s (INRQIType,INRQICanceled,remark,qtyApproved,SpecDesc)=""
 .s dhcinrqi=$o(^DHCINRQI(0,"INRQI",Reqi,""))
 .i dhcinrqi'="" d
 ..s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
 ..s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
 ..s remark=$p(^DHCINRQI(dhcinrqi),"^",2)
 ..s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
 ..s Spec=$p(^DHCINRQI(dhcinrqi),"^",6)
 .q:remark="打包收费"
 .;&sql(select INPOI_Remarks into :remark from IN_POItm where IN_POItm=:poi)
 .;&sql(select INRQI_Remark ,INRQI_SpecList into :remark,:Spec from DHC_INReqItm where INRQI_INRQI_DR=:Reqi)
 .s msg=PoNo_","_LocDesc_","_UserName_","_InciDesc_","_Spec_","_Qty_","_UomDesc_","_remark_","_zd
 s msg=msg_",要货信息有误,不用处理!--北京同仁医院采购中心"
 s sendId=$p(^SSU("SSUSR",senduser),"^",1)
 s sendName=$p(^SSU("SSUSR",senduser),"^",2)
 s Mobile=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbCarrier(Inci),"^",3)
 s result=sendId_"^"_sendName_"^"_Mobile_"^"_msg_"^"_zd
 
 ////测试库未部署程序  暂时 注释
 i $d(^$R("^web.DHCENS.BLL.SMSPlatform.Method.SendInfoToSMS.1")) d
 .;d ##class(web.DHCENS.BLL.SMSPlatform.Method.SendInfoToSMS).SendPurchaseInfoToSMS(result)
 q ret
}

}
