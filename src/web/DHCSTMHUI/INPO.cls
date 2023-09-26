Import sqluser

/// Descript:	订单
/// Creator:	lxt
/// CreateDate:	2018-07-27
Class web.DHCSTMHUI.INPO Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName = "DHCSTPOM";

/// Descript:	查询订单
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_Po
/// Input:		排序，查询条件
/// Return：	订单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPO","QueryMain","","","{""StartDate"":""24/07/2016"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""PoLoc"":""153"",""CancelReason"":"""",""EndDate"":""31/07/2018"",""Vendor"":"""",""ApproveFlag"":""N"",""ReqLoc"":"""",""IncludeCancelInPo"":"""",""DefLocPP"":""Y"",""PoNo"":"""",""Inci"":"""",""SxNo"":"""",""CompFlag"":""Y""}")
Query QueryMain(Params As %String) As Query(ROWSPEC = "RowId,PoNo,CreateDate,CreateUser,CompFlag,ApproveFlag,CancelFlag,CancelReasonId,CancelReasonDesc,VendorId,VendorDesc,Email,TransDate,NeedDate,PoLocId,PoLocDesc,ReqLocId,ReqLocDesc,ApproveUser,ApproveDate,PoStatus,PurNo,SendFlag,ApproveStatus,PlatStat,PurPlanCodeId") [ SqlProc ]
{
}

ClassMethod QueryMainExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pRowId=PJObj.%Get("RowId")		//主单RowId
	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	s pPoLocId=PJObj.%Get("PoLoc")		//采购科室
	s pVendorId=PJObj.%Get("Vendor")		//供应商
	s pStkScgId=PJObj.%Get("StkScg")		//类组
	s pInciId=PJObj.%Get("Inci")		//物资
	s pInciDesc=PJObj.%Get("InciDesc")		//物资
	s pPoNo=PJObj.%Get("PoNo")		//单号
	s pCompFlag=PJObj.%Get("CompFlag")		//完成标志
	s pApproveFlag=PJObj.%Get("ApproveFlag")		//审核标志
	s pDefLocPP=PJObj.%Get("DefLocPP")		//是否包含支配科室
	s pStatus=PJObj.%Get("Status")  //订单状态
	s pReqLocId=PJObj.%Get("ReqLoc") //请求科室
	s pFilterDetail=PJObj.%Get("FilterDetail")  //是否过滤无明细订单
	s pIncludeCancelInPo=PJObj.%Get("IncludeCancelInPo")  //是否包含拒绝明细
	s pIncscId=PJObj.%Get("StkCat")
	s pSendFlag=PJObj.%Get("SendFlag")	//是否推送至平台
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")

	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)

	s type=..sssCode()
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,type,pPoLocId,pStkScgId)

	s result = ##class(%Library.ResultSet).%New()
	s SqlStr = "select IN_PO as RowId,"
	s SqlStr=SqlStr_"INPO_No as PoNo,"
	s SqlStr=SqlStr_"INPO_APCVM_DR as VendorId,INPO_APCVM_DR->APCVM_Name as VendorDesc,"
	s SqlStr=SqlStr_"INPO_Date CreateDate,INPO_SSUSR_DR as CreateUserId,"
	s SqlStr=SqlStr_"INPO_Completed CompFlag,"
	s SqlStr=SqlStr_"INPO_Approved ApproveFlag,"
	s SqlStr=SqlStr_"INPO_PlatSend SendFlag,"
	s SqlStr=SqlStr_"INPO_ReasonCancFullFilled_DR as CancelReasonId,INPO_ReasonCancFullFilled_DR->CFR_Desc as CancelReasonDesc,"
	s SqlStr=SqlStr_"INPO_TransDate TransDate,"
	s SqlStr=SqlStr_"INPO_DateNeeded NeedDate,"
	s SqlStr=SqlStr_"INPO_Cancelled CancelFlag "
	s SqlStr=SqlStr_" from IN_PO "
	s SqlStr=SqlStr_" where INPO_No like '%"_pPoNo_"%' "
	i (pStartDate'="")&&(pEndDate'="") d
	.s SqlStr=SqlStr_"and (INPO_Date between "_pStartDate_" and "_pEndDate_")"
	s Result=##class(%Library.ResultSet).%New()
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
		s PoNo = Result.Data("PoNo")
		s CompFlag=Result.Data("CompFlag")
		s:CompFlag="" CompFlag="N"
		CONTINUE:(pCompFlag'="")&(CompFlag'=pCompFlag)
		s ApproveFlag=Result.Data("ApproveFlag")
		s:ApproveFlag="" ApproveFlag="N"
		CONTINUE:(pApproveFlag'="")&(pApproveFlag'=ApproveFlag)
		s SendFlag=Result.Data("SendFlag")
		s:SendFlag="" SendFlag="N"
		CONTINUE:(pSendFlag'="")&(pSendFlag'=SendFlag)
		s VendorId = Result.Data("VendorId")
		CONTINUE:(pVendorId'="")&(pVendorId'=VendorId)
		s VendorDesc=Result.Data("VendorDesc")
		s CreateDate=Result.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s CreateUserId=Result.Data("CreateUserId")
		s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
		s CancelFlag=Result.Data("CancelFlag")
		CONTINUE:(pIncludeCancelInPo'="Y")&(CancelFlag="Y")
		s CancelReasonId=Result.Data("CancelReasonId")
		s CancelReasonDesc=Result.Data("CancelReasonDesc")
		s TransDate=Result.Data("TransDate")
		s:TransDate'="" TransDate=..DL2H(TransDate)
		s NeedDate=Result.Data("NeedDate")
		s:NeedDate'="" NeedDate=..DL2H(NeedDate)
		s (Email,PoLocDesc,ReqLocDesc,ApproveUserDR,ApproveUser,ApproveDate,ApproveTime)=""
		&sql(select STV_Email into :Email from DHC_STVendor where STV_Vendor_DR=:VendorId)
		s DhcPoId=$o(^DHCINPO(0,"INPO",RowId,""),-1)
		CONTINUE:DhcPoId=""
		s PoLocId =$p(^DHCINPO(DhcPoId),"^",2)
		s:PoLocId'="" PoLocDesc=$p(^CTLOC(PoLocId),"^",2),PoLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(PoLocDesc)
		CONTINUE:((","_pPoLocId_",")'[(","_PoLocId_","))
		s ReqLocId=$p(^DHCINPO(DhcPoId),"^",5)
		CONTINUE:(pReqLocId'="")&&(pReqLocId'=ReqLocId)
		s:ReqLocId'="" ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2),ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		s PoType=$p(^DHCINPO(DhcPoId),"^",4)
		CONTINUE:(PoType'=type)
		s StkScgId=$p(^DHCINPO(DhcPoId),"^",3)
		CONTINUE:(StkScgId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkScgId_"^"))
		s ApproveUserDR=$p(^DHCINPO(DhcPoId),"^",6)
		s:ApproveUserDR'="" ApproveUser=$p(^SSU("SSUSR",ApproveUserDR),"^",2)
		s ApproveDate=$p(^DHCINPO(DhcPoId),"^",7)
		s ApproveTime=$p(^DHCINPO(DhcPoId),"^",8)
		s:ApproveDate'="" ApproveDate=..DL2H(ApproveDate)
		s checkinciflag="Y"
		i ((pInciId'="")||(pIncscId'="")||(pStkScgId'="")||(pInciDesc'=""))  d
		.s checkinciflag=..CheckInciInclude(RowId,pInciId,pIncscId,pStkScgId,pPoLocId,gUserId,pInciDesc)
		CONTINUE:checkinciflag'="Y"
		s PoStatus=..GetPoStatus(RowId)
		CONTINUE:(pStatus'="")&('$f(pStatus,PoStatus))
		s EffecQty=$p(..GetPoDetailQty(RowId),"^",2)
		CONTINUE:(pFilterDetail="Y")&(EffecQty=0)
		s PurInfo=##class(web.DHCSTMHUI.INPO).GetPlanInfo(RowId)
		s PurNo=$p(PurInfo,"^",1)
		s ApproveStatus="未验收"
		s:ApproveFlag="Y" ApproveStatus="已验收"
		s PlatStat=$p(^DHCINPO(DhcPoId),"^",19)
		s PurPlanCodeId=$p(^DHCINPO(DhcPoId),"^",14) ;阳光平台订单ID
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,PoNo,CreateDate,CreateUser,CompFlag,ApproveFlag,CancelFlag,CancelReasonId,CancelReasonDesc,VendorId,VendorDesc,Email,TransDate,NeedDate,PoLocId,PoLocDesc,ReqLocId,ReqLocDesc,ApproveUser,ApproveDate,PoStatus,PurNo,SendFlag,ApproveStatus,PlatStat,PurPlanCodeId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检查某订单中是否包含某库存项
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_POItm
/// Input:		RowId,InciId,IncscId,StkScgId,PoLocId,UserId
/// Return：	Y是，N否
ClassMethod CheckInciInclude(RowId, InciId, IncscId, Scg, LocId, UserId, InciDesc)
{
	n (RowId, InciId, IncscId, Scg, LocId, UserId, InciDesc)
	s flag="N"
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),LocId,Scg)
	s ch=0
	s ok=0
	f  s ch=$o(^INPO(RowId,"POI",ch)) q:(ch="")!(flag="Y")  d
	.s PoiInci=$p(^INPO(RowId,"POI",ch),"^",1)
	.s PoiInciDesc=$p(^INCI(PoiInci,1),"^",2)
	.s PoiIncsc=$p(^INCI(PoiInci,2),"^",2)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(PoiInci)
	.s PoiScg=$p(ScgInfo,"^",5)
	.q:(InciId'="")&&(PoiInci'=InciId)
	.q:(InciId="")&&(InciDesc'="")&&(PoiInciDesc'[InciDesc)
	.q:(IncscId'="")&&(PoiIncsc'=IncscId)
	.q:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_PoiScg_"^"))
	.s flag="Y"
	q flag
}

/// Descript:	取订单状态
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_POItm
/// Input:		订单主表id
/// Return：	订单状态
ClassMethod GetPoStatus(PoId As %String) As %String
{
	n (PoId)
	s Ingr=$o(^DHCINGR(0,"PO",PoId,0))
	;q:Ingr="" 0
	s Flag=2   ;初始化为全部入库
	s ChlNum=0,ZeroNum=0
	s Chl=0
	f  s Chl=$o(^INPO(PoId,"POI",Chl))  q:(Chl="")!(Flag=1)  d
	.s PoiQty=$p(^INPO(PoId,"POI",Chl),"^",7)
	.s PoItmId=PoId_"||"_Chl
	.s ChlNum=ChlNum+1
	.s Flag=$$CheckInpoArrival(PoItmId)
	.i Flag=0 s ZeroNum=ZeroNum+1

	i (Flag'=1)&&(ZeroNum=ChlNum) s Flag=0
	i (Flag'=1)&&(ZeroNum'=0)&&(ZeroNum<ChlNum) s Flag=1

	q Flag
CheckInpoArrival(PoItmId)
	n (PoItmId)
	s PoId=$p(PoItmId,"||",1),PoItmCh=$p(PoItmId,"||",2)
	q:(PoId="")||(PoItmCh="") 0
	s IncId=$p(^INPO(PoId,"POI",PoItmCh),"^",1)
	s PoiUom=$p(^INPO(PoId,"POI",PoItmCh),"^",3)
	s PoiQty=$p(^INPO(PoId,"POI",PoItmCh),"^",7)
	s BUomId=$p(^INCI(IncId,1),"^",10)
	s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PoiUom,BUomId)
	s PoiQtyBUom=PoiQty*UomFac

	s ingriQtySum=0
	s ingr=""
	f  s ingr=$o(^DHCINGR(0,"PODR",PoItmId,ingr)) q:ingr=""  d
	.s ch=""
	.f  s ch=$o(^DHCINGR(0,"PODR",PoItmId,ingr,ch)) q:ch=""  d
	..s Inclb=$p(^DHCINGR(ingr,"GRI",ch),"^",1)
	..q:Inclb=""			;2015-09-16 仅统计已审核部分
	..s ingriQty=$p(^DHCINGR(ingr,"GRI",ch),"^",4)
	..s ingriUom=$p(^DHCINGR(ingr,"GRI",ch),"^",10)
	..s ingriUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ingriUom,BUomId)
	..s ingriQtyBuom=ingriQty*ingriUomFac
	..s ingriQtySum=ingriQtySum+ingriQtyBuom	;2015-09-16 rem: 这里暂时没有考虑单位转换
	q:ingriQtySum=0 0
	q:ingriQtySum<PoiQtyBUom 1
	q 2
}

/// Descript:	取订单明细数量
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_POItm
/// Input:		订单主表id
/// Return：	订单明细数量：订单明细数量^未撤销数量^已撤销数量
/// w ##class(web.DHCSTMHUI.INPO).GetPoDetailQty(10)
ClassMethod GetPoDetailQty(PoId As %String) As %String
{
	n (PoId)
	q:PoId="" 0
	s TotalQty=0,EffecQty=0,DenyQty=0
	s Chl=0
	f  s Chl=$o(^INPO(PoId,"POI",Chl))  q:(Chl="")  d    //IN_POItm子表
	.s inpoi=PoId_"||"_Chl
	.s TotalQty=TotalQty+1
	.s dhcpoi=$o(^DHCINPOI(0,"INPOI",inpoi,""))    //DHC_INPOItm订单子表附加表
	.i dhcpoi'=""  d
	..s cancleflag=$p(^DHCINPOI(dhcpoi),"^",4)
	..i cancleflag="Y"  s DenyQty=DenyQty+1
	s EffecQty=TotalQty-DenyQty
	s listQty=TotalQty_"^"_EffecQty_"^"_DenyQty
	q listQty
}

/// Descript:	查询订单主单信息
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	订单主单信息数据串
/// w ##class(web.DHCSTMHUI.INPO).Select(41)
ClassMethod Select(PoId As %String) As %String
{
	n (PoId)
	q:+PoId=0 ""

	s (RowId,PoNo,Vendor,VendorDesc,CreateDate,CreateUser,
		CompFlag,ApproveFlag,CancelReasonId,CancelReasonDesc,
		TransDate,NeedDate,CancelFlag,Remark)=""

	&sql(select IN_PO,INPO_No,INPO_APCVM_DR,INPO_APCVM_DR->APCVM_Name,INPO_Date,INPO_SSUSR_DR,
		INPO_Completed,INPO_Approved,INPO_ReasonCancFullFilled_DR,INPO_ReasonCancFullFilled_DR->CFR_Desc,
		INPO_TransDate,INPO_DateNeeded,INPO_Cancelled,INPO_Remarks
	into :RowId,:PoNo,:Vendor,:VendorDesc,:CreateDate,:CreateUser,
		:CompFlag,:ApproveFlag,:CancelReason,:CancelReasonDesc,
		:TransDate,:NeedDate,:CancelFlag,:Remark
	from IN_PO where IN_PO=:PoId)

	s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	s:TransDate'="" TransDate=..DL2H(TransDate)
	s:NeedDate'="" NeedDate=..DL2H(NeedDate)
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s Remark=$LTS(Remark,memoDelim)

	s (PoLoc,PoLocDesc,StkScg,StkScgDesc,ReqLocId,ReqLocDesc)=""
	s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
	i DhcPoId'=""  d
	.s PoLoc=$p(^DHCINPO(DhcPoId),"^",2)
	.s StkScg=$p(^DHCINPO(DhcPoId),"^",3)
	.s Type=$p(^DHCINPO(DhcPoId),"^",4)
	.s ReqLocId=$p(^DHCINPO(DhcPoId),"^",5)
	.s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2),PoLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(PoLocDesc)
	.s:StkScg'="" StkScgDesc=$p(^DHCSCG(StkScg),"^",2)
	.s ReqLocDesc=$s(ReqLocId'="":$p(^CTLOC(ReqLocId),"^",2),1:"")
	.s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
	s ReqLoc=..sssComboStr(ReqLocId,ReqLocDesc)
	s Data=RowId_"^"_PoNo_"^"_Vendor_"^"_VendorDesc_"^"_CreateDate
		_"^"_CreateUser_"^"_CompFlag_"^"_ApproveFlag_"^"_CancelReason_"^"_CancelReasonDesc
		_"^"_TransDate_"^"_NeedDate_"^"_CancelFlag_"^"_Remark_"^"_PoLoc
		_"^"_PoLocDesc_"^"_StkScg_"^"_StkScgDesc_"^"_ReqLoc

	s Title="RowId^PoNo^Vendor^VendorDesc^CreateDate"
		_"^CreateUser^CompFlag^ApproveFlag^CancelReason^CancelReasonDesc"
		_"^TransDate^NeedDate^CancelFlag^Remark^PoLoc"
		_"^PoLocDesc_^StkScg^StkScgDesc^ReqLoc"

	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:	保存订单
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO，IN_POItm
/// Input:		主单信息，明细信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INPO).Save("6^102^590^1^N^^2013-03-25","^969^71^0^2")
ClassMethod Save(Main As %String, Detail As %String) As %Library.String
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..Update(Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	s MainId=RtnObj.rowid
	s RtnObj=##class(web.DHCSTMHUI.INPOItm).Save(MainId,Detail)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=MainId
	q RtnObj.Json()
}

/// Descript:	保存订单主单信息
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单信息
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.INPO).Update(123)
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")

	s PoId=PJObj.%Get("RowId")
	s StkGrpId=PJObj.%Get("StkScg")
	s LocId=PJObj.%Get("PoLoc")
	s UserId=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")
	s VendorId=PJObj.%Get("Vendor")
	s Remark=PJObj.%Get("Remark")
	s NeedDate=PJObj.%Get("NeedDate")
	s ReqLoc=PJObj.%Get("ReqLoc")
	
	i LocId="" q RtnObj.Err(-1,"","订单科室不能为空!","",0)
	s:NeedDate'="" NeedDate=..DH2L(NeedDate)
	s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s Remark=$LFS(Remark,MemoDelim)
	
	s Type=..sssCode()
	s AppName=..%GetParameter("AppName")
	s PoDate=+$h
	s PoTime=$p($h,",",2)
	s CompFlag="N"
	s ApproveFlag="N"
	s LockName=AppName_PoId
	s AddFlag="Y"	//订单是否新增
	
	ts
	i PoId="" d
	.s PoNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
	.i PoNo="" d RtnObj.Err(-2,"","订单号生成失败","",0) q
	.s Params=GroupId_"^"_LocId_"^"_UserId
	.i NeedDate="" d
	..s NeedDays=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"NeedDays",Params)
	..s NeedDate=+$h+NeedDays
	.
	.s Obj=##class(User.INPO).%New()
	.s Obj.INPONo=PoNo
	.s Obj.INPODate=PoDate
	.d Obj.INPOCTCURDRSetObjectId(1)	;固定值
	.s Obj.INPOCompleted=CompFlag
	.s Obj.INPOApproved=ApproveFlag
	e  d
	.s AddFlag="N"
	.s LocRet=..sssLock(LockName)
	.i LocRet<0 d RtnObj.Err(-10,"","加锁失败!") q
	.s Obj=##class(User.INPO).%OpenId(PoId)
	i RtnObj.success<0 tro  q RtnObj
	
	d Obj.INPOAPCVMDRSetObjectId(VendorId)
	d Obj.INPOSSUSRDRSetObjectId(UserId)
	s Obj.INPODateNeeded=NeedDate
	d Obj.INPORemarks.Clear()
	d Obj.INPORemarks.InsertList(Remark)
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) d ..sssUnLock(LockName) tro  q RtnObj.Err(-11,"","主表更新失败!")
	
	s PoId=Obj.%Id()
	s DHCINPoId=$o(^DHCINPO(0,"INPO",PoId,""),-1)
	i (AddFlag="Y")&&(DHCINPoId'="") d
	.s DHCINPoId=""
	.&sql(delete from DHC_INPO where PO_INPO_DR=:PoId)
	.i SQLCODE'=0 d RtnObj.Err(-12,PoId,"附加表历史数据删除失败!"_SQLCODE)
	i RtnObj.success'=0 d ..sssUnLock(LockName) tro  q RtnObj
	
	i DHCINPoId="" d
	.s DHCObj=##class(User.DHCINPO).%New()
	.d DHCObj.POINPODRSetObjectId(PoId)
	e  d
	.s DHCObj=##class(User.DHCINPO).%OpenId(DHCINPoId)
	d DHCObj.POCTLOCDRSetObjectId(LocId)
	d DHCObj.POSCGDRSetObjectId(StkGrpId)
	s DHCObj.POStkType=Type
	d DHCObj.POReqLocDRSetObjectId(ReqLoc)
	s Sc=DHCObj.%Save()
	i $$$ISERR(Sc) d ..sssUnLock(LockName) tro  q RtnObj.Err(-11,"","主表附加表更新失败!")
	
	d ..sssUnLock(LockName)
	tc
	s RtnObj.rowid=PoId
	q RtnObj
}

/// Descript:	删除订单信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.INPO).jsDelete(43)
ClassMethod jsDelete(PoId As %String) As %String
{
	n (PoId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Delete(PoId)
	q RtnObj.Json()
}

/// Descript:	删除订单信息
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod Delete(PoId As %String) As RtnObj
{
	n (PoId)
	s RtnObj=##class(RtnObj).%New()
	i PoId="" d RtnObj.Err(-1,"","入参不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	i ..sssLock(..%GetParameter("AppName")_PoId)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	s CompFlag=$p(^INPO(+PoId),"^",9)
	i CompFlag="Y" d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-2,"","已完成或已审核,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	s SendFlag=$p(^INPO(+PoId),"^",24)
	i SendFlag="Y" d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-2,"","订单已经上传,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj
	s PurId=..GetPurIdByPo(PoId)
	ts
	&sql(Delete from DHC_INPOItm where POI_INPOI_DR->IN_PO=:PoId)
	i SQLCODE<0 d ..sssUnLock(..%GetParameter("AppName")_PoId) tro  d RtnObj.Err(-3,"","删除明细附加表失败!","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(Delete From DHC_InPo where PO_INPO_DR=:PoId)
	i SQLCODE<0 d ..sssUnLock(..%GetParameter("AppName")_PoId) tro  d RtnObj.Err(-3,"","删除明细附加表失败!","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(Delete From IN_Po where IN_PO=:PoId)
	i SQLCODE<0 d ..sssUnLock(..%GetParameter("AppName")_PoId) tro  d RtnObj.Err(-3,"","删除明细附加表失败!","",0)
	q:RtnObj.success'=0 RtnObj
	i PurId'="" d
	.s PoFlag="N"
	.&sql(update IN_PURPLAN set INPP_PoFlag=:PoFlag where INPP_Rowid=:PurId)
	.i SQLCODE'=0 d ..sssUnLock(..%GetParameter("AppName")_PoId) tro  d RtnObj.Err(-3,"","更新采购主表失败!")
	q:RtnObj.success'=0 RtnObj
	tc
	q RtnObj
}

/// Descript:	确认完成订单
/// 对象类型数据
ClassMethod jsSetComplete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetComplete(Params)
	q RtnObj.Json()
}

/// Descript:	确认完成订单信息
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod SetComplete(Params As %String) As RtnObj
{
	n (Params)
	s Flag="Y"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s PoId=PJObj.%Get("RowId")
	i PoId="" d RtnObj.Err(-2,"","订单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj

	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("PoLoc")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")

	s CompFlag=$p(^INPO(+PoId),"^",9)
	i CompFlag="Y" d RtnObj.Err(-3,"","已经完成,不能重复完成!","",0)
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(..%GetParameter("AppName")_PoId)<0  d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj

	ts
	&sql(update IN_PO set inpo_completed=:Flag,inpo_usercompleted=:Flag,inpo_usercompleted_dr=:UserId,INPO_Approved=null where %ID=:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单状态失败!")
	q:RtnObj.success'=0 RtnObj

	&sql(update DHC_INPO set PO_ApprovedUser_DR=null,PO_ApprovedDate=null,PO_ApprovedTime=null where PO_INPO_DR =:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单附加表失败!")
	q:RtnObj.success'=0 RtnObj
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(PoId,"POD",UserId,"PO")

	s ParamsStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s PoAduit=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.INPO).%GetParameter("AppName"),"AutoAduit",ParamsStr)
	i (PoAduit="Y") d
	.s Param=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(PoId_"^"_LocId_"^"_HospId_"^"_GroupId,"RowId^PoLoc^gHospId^gGroupId")
	.s RtnObj= ..Approve(Param)  //自动审核不保存审核人user
	i RtnObj.success'=0 tro  d ..sssUnLock(..%GetParameter("AppName")_PoId)  q RtnObj

	;自动推送(借用采购的推送参数)
	s InppAppName=##class(web.DHCSTMHUI.INPurPlan).%GetParameter("AppName")
	s AutoSendToSci=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(InppAppName,"AutoSendToSci",ParamsStr)
	i AutoSendToSci="Y" d ##class(web.DHCSTMHUI.INPurPlan).CheckSendInpo(PoId)

	d ..sssUnLock(..%GetParameter("AppName")_PoId)

	tc
	s RtnObj.rowid=PoId
	q RtnObj
}

/// Descript:	取消完成订单
/// 对象类型数据
ClassMethod jsCancelComplete(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelComplete(Params)
	q RtnObj.Json()
}

/// Descript:	取消完成订单
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod CancelComplete(Params As %String) As RtnObj
{
	n (Params)
	s Flag="N"
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s PoId=PJObj.%Get("RowId")
	i PoId="" d RtnObj.Err(-2,"","订单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj

	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("PoLoc")
	s GroupId=PJObj.%Get("gGroupId")
	s HospId=PJObj.%Get("gHospId")

	s CompFlag=$p(^INPO(+PoId),"^",9)
	i CompFlag'="Y" d RtnObj.Err(-3,"","未完成,不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj

	s ingr=$O(^DHCINGR(0,"PO",PoId,""))
	i +ingr>0 d RtnObj.Err(-4,"","该订单已经入库,禁止修改状态!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s PlatSendFlag=$p(^INPO(+PoId),"^",24)
	i PlatSendFlag="Y" d RtnObj.Err(-4,"","已发送平台，不允许取消完成!","",0)
	q:RtnObj.success'=0 RtnObj

	s Approve=$p(^INPO(PoId),"^",8)
	s ApproveUser=""
	&sql(select PO_ApprovedUser_DR into :ApproveUser from dhc_inpo where PO_INPO_DR=:PoId)
	i ((Approve="Y")&&(ApproveUser'="")) d RtnObj.Err(-5,"","订单非自动审核后不能取消完成!","",0)
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(..%GetParameter("AppName")_PoId)<0  d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj

	ts
	&sql(update IN_PO set inpo_completed=:Flag,inpo_usercompleted=:Flag,inpo_usercompleted_dr=:UserId,INPO_Approved=null where %ID=:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单状态失败!")
	q:RtnObj.success'=0 RtnObj

	&sql(update DHC_INPO set PO_ApprovedUser_DR=null,PO_ApprovedDate=null,PO_ApprovedTime=null where PO_INPO_DR =:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单附加表失败!")
	q:RtnObj.success'=0 RtnObj

	d ..sssUnLock(..%GetParameter("AppName")_PoId)
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(PoId,"POD","PO")

	tc
	s RtnObj.rowid=PoId
	q RtnObj
}

/// Descript:	验收订单
/// 对象类型数据
ClassMethod jsApprove(Params As %String, PoIdStr As %String = "") As %String
{
	n (Params,PoIdStr)
	
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s del="^"
	s cnt=$l(PoIdStr,del)
	s ErrMsg="",Succnt=0,RowidStr=""
	f i=1:1:cnt d
	.s PoId=$p(PoIdStr,del,i)
	.s RtnObj=..Approve(Params,PoId)
	.i RtnObj.success=0 d
	..s Succnt=Succnt+1
	..i RowidStr="" d
	...s RowidStr= PoId
	..e  d
	...s RowidStr=RowidStr_"^"_PoId
	.e  d
	..s msginfo=PoId_":"_RtnObj.msg
	..i ErrMsg="" d
	...s ErrMsg= msginfo
	..e  d
	...s ErrMsg=ErrMsg_"#"_msginfo
	s RtnObj.rowid=RowidStr
	s RtnObj.msg=cnt_"@"_Succnt_"@"_ErrMsg
	s RtnObj.success=0
	q RtnObj.Json()
}

/// Descript:	验收订单
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod Approve(Params As %String, JsPoId As %String = "") As RtnObj
{
	n (Params,JsPoId)

	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s PoId=PJObj.%Get("RowId")
	s:JsPoId'="" PoId=JsPoId
	i +PoId=0  d RtnObj.Err(-1,"","订单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("PoLoc")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s ApproveDate=+$h
	s ApproveTime=$p($h,",",2)
	s ApproveFlag="Y"

	s CompFlag=$p(^INPO(PoId),"^",9)
	i CompFlag'="Y" d RtnObj.Err(-2,"","订单未完成，不能验收","",0)
	q:RtnObj.success'=0 RtnObj
	s CancelFlag=$p(^INPO(PoId),"^",18)
	i CancelFlag="Y" d RtnObj.Err(-2,"","订单已取消，不能验收","",0)
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(..%GetParameter("AppName")_PoId)<0  d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj

	ts
	&sql(update DHC_INPO set PO_ApprovedUser_DR=:UserId,PO_ApprovedDate=:ApproveDate,PO_ApprovedTime=:ApproveTime where PO_INPO_DR =:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单附加表失败!")
	q:RtnObj.success'=0 RtnObj

	&sql(update IN_PO set INPO_Approved=:ApproveFlag where IN_PO=:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单失败!")
	q:RtnObj.success'=0 RtnObj
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(PoId,"POA",UserId,"PO")

	s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s AutoGenerateIngr=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.INPO).%GetParameter("AppName"),"AutoGenerateIngr",Params)
	i AutoGenerateIngr="Y" d
	.s RtnObj=..SaveIngrByInPo(PoId,UserId)
	i RtnObj.success'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","依据订单生成入库单失败!")
	q:RtnObj.success'=0 RtnObj

	d ..sssUnLock(..%GetParameter("AppName")_PoId)

	tc
	s RtnObj.rowid=PoId
	q RtnObj
}

/// Descript:	验收订单时自动生成入库单
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		订单Id,审核人Id
/// Return：	成功，失败
/// {""RecLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""PurchaseUser"":"""",""ApcvmDr"":""812"",""CreateDate"":""31/07/2018"",""AcceptUserId"":"""",""StkGrpId"":""12"",""IngrTypeId"":""1"",""SourceOfFund"":"""",""ReqLocId"":"""",""Complete"":"""",""AdjCheque"":"""",""GiftFlag"":"""",""IngrId"":"""",""InGrNo"":"""",""SxNo"":"""",""InGrRemarks"":""""}
/// [{""IncId"":""9625"",""IncCode"":""cl00001"",""IncDesc"":""cl一次针管"",""S    pec"":"""",""HVFlag"":""N"",""ManfId"":"""",""Manf"":"""",""BatchNo"":"""",""ExpDate"":"""",""QualityNo"":"""",""MtDesc"":"""",""PubDesc"":"""",""Remarks"":"""",""BUomId"":""5"",""ConFacPur"":""1"",""MtDr"":"""",""MtDr2"":"""",""SterilizedNo"":"""",""InPoQty"":"""",""BatchReq"":""N"",""ExpReq"":""N"",""BarCode"":"""",""AdmNo"":"""",""AdmExpdate"":"""",""SpecDesc"":"""",""IngrUomId"":""5"",""IngrUom"":""个"",""Rp"":""31"",""Sp"":""34"",""NewSp"":""34"",""reqLocId"":"""",""reqL ocDesc"":"""",""Marginnow"":""0.097"",""RecQty"":""20"",""InvNo"":"""",""InvDate"":"""",""SxNo"":"""",""Remark"":"""",""Tax"":"""",""RpAmt"":620,""InvMoney"":620,""NewSpAmt"":680,""TaxAmt"":0},{""IncId"":""9625"",""IncCode"":""cl00001"",""IncDesc"":""cl一次针管"",""Spec"":"""",""HVFlag"":""N"",""ManfId"":"""",""Manf"":    """",""BatchNo"":"""",""ExpDate"":"""",""QualityNo"":"""",""MtDesc"":"""",""PubDesc"":"""",""Remarks"":"""",""BUomId"":""5"",""ConFacPur"":""1"",""MtDr"":"""",""MtDr2"":"""",""SterilizedNo"":"""",""InPoQty"":"""",""BatchReq"":""N"",""ExpReq"":""N"",""BarCode"":"""",""AdmNo"":"""",""AdmExpdate"":"""",""SpecDesc"":"""",""IngrUomId"":""5"",""IngrUom"":""个"",""Rp"":""31"",""Sp"":""34"",""NewSp"":""34 "",""reqLocId"":"""",""reqLocDesc"":"""",""Marginnow"":""0.097"",""RecQty"":""10"",""InvNo"":"""",""InvDate"":"""",""SxNo"":"""",""Remark"":"""",""Tax"":"""",""RpAmt"":310,""InvMoney"":310,""NewSpAmt"":340,""TaxAmt"":0}]
ClassMethod SaveIngrByInPo(InPo, User) As RtnObj
{
	n (InPo,User)

	s RtnObj=##class(RtnObj).%New()
	i InPo="" d RtnObj.Err(-11,"","订单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj

	s Vendor=$p(^INPO(InPo),"^",2)
	s DhcInPo=$o(^DHCINPO(0,"INPO",InPo,0))
	i DhcInPo="" d RtnObj.Err(-12,"","订单主表附加表不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s LocId=$p(^DHCINPO(DhcInPo),"^",2)
	s StkGrpId=$p(^DHCINPO(DhcInPo),"^",3)
	s PresentFlag="N"
	s ExchangeFlag="N"
	s PurUserId=$p(^INPO(InPo),"^",7)
	s ReqLoc=$p(^DHCINPO(DhcInPo),"^",5)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Remarks=""
	&sql(select INPO_Remarks into :Remarks from IN_PO where %ID=:InPo)
	s MainInfo="{""RecLoc"":"""_LocId_""",""gUserId"":"""_User_""",""ApcvmDr"":"""_Vendor_""",""GiftFlag"":"""_PresentFlag_""",""AdjCheque"":"""_ExchangeFlag_""",""PurchaseUser"":"""_PurUserId_""",""StkGrpId"":"""_StkGrpId_""",""PoId"":"""_InPo_""",""InGrRemarks"":"""_Remarks_""",""ReqLocId"":"""_ReqLoc_"""}"

	s DetailInfo=""
	s Ch=0
	f  s Ch=$o(^INPO(0,"Loc",LocId,InPo,Ch))  q:(Ch="")!(RtnObj.success'=0)  d
	.s InPoi=InPo_"||"_Ch
	.s Rowid=""
	.s IncId=$p(^INPO(InPo,"POI",Ch),"^",1)
	.s DhcPoi=$o(^DHCINPOI(0,"INPOI",InPoi,0))
	.i DhcPoi="" d RtnObj.Err(-13,"","订单明细附加表不能为空!","",0) q
	.s BatNo=$p(^DHCINPOI(DhcPoi),"^",6)
	.s ExpDate=$p(^DHCINPOI(DhcPoi),"^",7)
	.s ManfId=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(IncId),"^",1)
	.s UomId=$p(^INPO(InPo,"POI",Ch),"^",3)
	.s Qty=$p(^INPO(InPo,"POI",Ch),"^",7)
	.s Rp=$p(^INPO(InPo,"POI",Ch),"^",4)
	.s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetMtSp(IncId,UomId,Rp,HospId)
	.s SxNo=$p(^DHCINPOI(DhcPoi),"^",11)
	.s InvNo=$p(^DHCINPOI(DhcPoi),"^",8)
	.s InvDate=$p(^DHCINPOI(DhcPoi),"^",9)
	.s Remarks=$g(^INPO(InPo,"POI",Ch,"REM",1))
	.s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
	.s (MtDr,CerNo,CerExpDate)=""
	.i Info'="" d
	..s MtDr=$p(^DHCITMINFO(Info),"^",15)
	..s INFOMatRegCertDR=$p(^DHCITMINFO(Info,1),"^",18)
	..s:INFOMatRegCertDR'="" CerNo=$p(^DHCMRCT(INFOMatRegCertDR),"^",12)
	..s:INFOMatRegCertDR'="" CerExpDate=$p(^DHCMRCT(INFOMatRegCertDR),"^",20)
	..s:CerExpDate'="" CerExpDate=$zd(CerExpDate,3)
	.
	.s InvAmt=$p(^DHCINPOI(DhcPoi),"^",10)
	.s SpecDesc=$p(^DHCINPOI(DhcPoi),"^",5)
	.s Data="{""IncId"":"""_IncId_""",""BatchNo"":"""_BatNo_""",""ExpDate"":"""_ExpDate_""",""ManfId"":"""_ManfId_""",""IngrUomId"":"""_UomId_""",""RecQty"":"""_Qty_""",""Rp"":"""_Rp_""",""Sp"":"""_Sp_""",""SxNo"":"""_SxNo_""",""InvNo"":"""_InvNo_""",""InvDate"":"""_InvDate_""",""Inpoi"":"""_InPoi_""",""Remarks"":"""_Remarks_""",""MtDr"":"""_MtDr_""",""AdmNo"":"""_CerNo_""",""AdmExpdate"":"""_CerExpDate_""",""InvMoney"":"""_InvAmt_""",""SpecDesc"":"""_SpecDesc_""",""reqLocId"":"""_ReqLoc_""",""NewSp"":"""_Sp_"""}"
	.i DetailInfo="" d
	..s DetailInfo=Data
	.e  d
	..s DetailInfo=DetailInfo_","_Data

	i DetailInfo'=""  d
	.s DetailInfo="["_DetailInfo_"]"

	i DetailInfo="" d RtnObj.Err(-14,"","入库明细为空","",0)
	q:RtnObj.success'=0 RtnObj

	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Save(MainInfo,DetailInfo)
	i RtnObj.success'=0 d RtnObj.Err(-15,"","生成入库单失败")
	q RtnObj
}

/// Descript:	拒绝订单
/// 对象类型数据
ClassMethod jsDeny(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Deny(Params)
	q RtnObj.Json()
}

/// Descript:	拒绝订单
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod Deny(Params As %String) As RtnObj
{
	n (Params)

	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s PoId=PJObj.%Get("RowId")
	i +PoId=0  d RtnObj.Err(-1,"","订单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("PoLoc")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s ApproveDate=+$h
	s ApproveTime=$p($h,",",2)
	s ApproveFlag="N"

	s CompFlag=$p(^INPO(PoId),"^",9)
	i CompFlag'="Y" d RtnObj.Err(-2,"","订单未完成，不能拒绝","",0)
	q:RtnObj.success'=0 RtnObj
	s CancelFlag=$p(^INPO(PoId),"^",18)
	i CancelFlag="Y" d RtnObj.Err(-2,"","订单已取消，不能拒绝","",0)
	q:RtnObj.success'=0 RtnObj
	s ApproveFlag=$p(^INPO(PoId),"^",8)
	i ApproveFlag="Y" d RtnObj.Err(-2,"","订单已验收，不能拒绝","",0)
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(..%GetParameter("AppName")_PoId)<0  d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj

	ts
	&sql(update DHC_INPO set PO_ApprovedUser_DR=NULL,PO_ApprovedDate=NULL,PO_ApprovedTime=NULL where PO_INPO_DR =:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单附加表失败!")
	q:RtnObj.success'=0 RtnObj

	&sql(update IN_PO set INPO_Approved=:ApproveFlag where IN_PO=:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单失败!")
	q:RtnObj.success'=0 RtnObj

	s CompFlag="N"
	&sql(update IN_PO set inpo_completed=:CompFlag,inpo_usercompleted=:CompFlag where %ID=:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单失败!")
	q:RtnObj.success'=0 RtnObj

	d ..sssUnLock(..%GetParameter("AppName")_PoId)
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).Complete(PoId,"POA",UserId,"PO")

	tc
	s RtnObj.rowid=PoId
	q RtnObj
}

/// Descript:	取消订单
/// 对象类型数据
ClassMethod jsCancel(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Cancel(Params)
	q RtnObj.Json()
}

/// Descript:	取消订单
/// Creator:	lxt
/// CreateDate:	2018-07-27
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod Cancel(Params As %String) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s PoId=PJObj.%Get("RowId")
	s CancelReson=PJObj.%Get("CancelReson")
	i PoId=0 d RtnObj.Err(-2,"","订单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s UserId=PJObj.%Get("gUserId")
	s Date=+$h
	s Time=$p($h,",",2)

	s comp=$p(^INPO(PoId),"^",9)
	i comp'="Y" d RtnObj.Err(-3,"","订单未完成，不能取消!","",0)
	q:RtnObj.success'=0 RtnObj
	s cancelflag=$p(^INPO(PoId),"^",18)
	i cancelflag="Y" d RtnObj.Err(-4,"","订单已取消!","",0)
	q:RtnObj.success'=0 RtnObj
	s DHCINGR=$o(^DHCINGR(0,"PO",PoId,0))
	i DHCINGR'="" d RtnObj.Err(-5,"","订单已生成入库单，不能取消!","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(update IN_PO set INPO_Cancelled='Y', INPO_UserCancFullFilled_DR=:UserId,INPO_DateCancelFullFilled=:Date,INPO_TimeCancelFullFilled=:Time,INPO_ReasonCancFullFilled_DR=:CancelReson where IN_PO =:PoId)
	i SQLCODE'=0  d RtnObj.Err(-6,"","订单取消失败!")
	q RtnObj
}

/// Descript:	查询订单主信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-07-30
/// Table:IN_Po
/// Input:供应商RowId^科室RowId^制单人^类组^完成标志^审核标志
/// Output:
/// Return：成功:rowid
/// -1:科室或供应商为空
/// -2   ;生成订单号失败
/// -3   ;保存订单失败
/// -4   ;保存订单附加表失败
/// Description:	查询订单
/// Creator:zhangdongmei
/// Create Date:2012-07-31
/// Input:开始行,一页显示记录数,排序字段,排序方向,
/// 开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^库存项id^是否包含支配科室
/// ^请求科室^人员rowid^过滤无明细订单（明细删除/明细撤销，过滤Y，不过滤N，缺省N）
/// Output:
/// Return：订单主表id^订单号^供应商^订购科室^订单状态^订单日期
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPO","Query","","",^tmpli("QueryStrParam"))
Query Query(Params As %String) As Query(ROWSPEC = "PoId,PoNo,Vendor,PoLocDesc,PoStatus,PoDate,VenId,PurUserId,StkGrpId,CmpFlag,Email,ReqLocDesc,ReqLoc,Approveed,ApproveedUser,ApproveedDate,CancelReasonId,CancelReason")
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("PoStartDate")  ;开始日期
	s EndDate=PJobj.%Get("PoEndDate")   ;截止日期
	s No=PJobj.%Get("PoNo")  //订单号
	s VendorId=PJobj.%Get("VendorBox")  //供应商id
	s LocId=PJobj.%Get("PoRecLoc")  //科室id
	q:LocId="" $$$OK
	s pCompleteFlag=PJobj.%Get("CompleteFlag")  //完成标志
	s pAuditFlag=PJobj.%Get("AuditFlag")  //审核标志
	s pStatus=PJobj.%Get("Status")  //订单状态
	s pIncId=PJobj.%Get("IncId")  //
	s pincludeDefLocPP=PJobj.%Get("includeDefLocPP") //zhwh 2014-01-09
	s pRequestPhaLoc=PJobj.%Get("RequestPhaLoc") //zhwh 2014-01-09
	s pUserId=PJobj.%Get("UserId")
	s pfilterDetail=PJobj.%Get("filterDetail")  //是否过滤无明细订单 2017-3-14
	s pincludeCancelInPo=PJobj.%Get("includeCancelInPo")
	s pScg=PJobj.%Get("Scg")
	s pIncsc=PJobj.%Get("Incsc")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(pUserId,..sssCode(),LocId,pScg)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select IN_PO as Rowid,INPO_No,INPO_APCVM_DR,INPO_APCVM_DR->APCVM_Name as Vendor,"_
	"INPO_Date,INPO_Completed,INPO_Approved,INPO_ReasonCancFullFilled_DR as CancelReasonId,INPO_ReasonCancFullFilled_DR->CFR_Desc as CancelReason from IN_PO where INPO_No like '%"_No_"%' "
	i (StartDate'="")&&(EndDate'="") d
	.s sqlStr=sqlStr_"and (INPO_Date between "_StartDate_" and "_EndDate_")"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	s domiLocs=..GetDominLoc(LocId)
	i pincludeDefLocPP=1 s LocId=LocId_"^"_domiLocs
	While(result.Next())
	{
		s PoId = result.Data("Rowid")
		s PoNo = result.Data("INPO_No")
		s Vendor = result.Data("Vendor")
		s VenId=result.Data("INPO_APCVM_DR")
		s CancelReasonId=result.Data("CancelReasonId")
		s CancelReason=result.Data("CancelReason")
		s Email=""
		&sql(select STV_Email into :Email from DHC_STVendor where STV_Vendor_DR=:VenId)
		s PoDate=result.Data("INPO_Date")
		s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,""),-1)
		CONTINUE:DhcPoId=""		;2014-02-26 C/S药库订单没有附加表,加以过滤
		s PoLocDesc=""
		s ReqLocDesc="",ApproveedUserDR="",ApproveedUser="",ApproveedDate="",ApproveedTime=""
		s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
		s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2),PoLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(PoLocDesc)
		s ReqLoc=$p(^DHCINPO(DhcPoId),"^",5)
		s:ReqLoc'="" ReqLocDesc=$p(^CTLOC(ReqLoc),"^",2),ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		CONTINUE:(pRequestPhaLoc'="")&&(pRequestPhaLoc'=ReqLoc)
		s Type=$p(^DHCINPO(DhcPoId),"^",4)
		s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
		continue:(StkGrpId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkGrpId_"^"))
		s ApproveedUserDR=$p(^DHCINPO(DhcPoId),"^",6)
		s ApproveedDate=$p(^DHCINPO(DhcPoId),"^",7)
		s ApproveedTime=$p(^DHCINPO(DhcPoId),"^",8)
		s:ApproveedUserDR'="" ApproveedUser=$p(^SSU("SSUSR",ApproveedUserDR),"^",2)
		s:ApproveedDate'="" ApproveedDate=..DL2H(ApproveedDate)
		s PurUserId=$p(^INPO(PoId),"^",7)
		s CmpFlag=result.Data("INPO_Completed")
		s Approveed=result.Data("INPO_Approved")
		s includeCancelInPoTemp=$p(^INPO(PoId),"^",18)
		CONTINUE:(pincludeCancelInPo'="Y")&(includeCancelInPoTemp="Y")
		CONTINUE:((pIncId'="")||(pIncsc'="")||(pScg'=""))&&($$ChkInci(pIncId_"^"_pIncsc_"^"_pScg_"^"_LocId_"^"_pUserId,PoId)=0)
		CONTINUE:(Type'=..sssCode())
		CONTINUE:(pincludeDefLocPP'=1)&(LocId'="")&(PoLoc'=LocId)
		CONTINUE:(pincludeDefLocPP=1)&&(("^"_LocId_"^")'[("^"_PoLoc_"^"))
		CONTINUE:(VendorId'="")&(VenId'=VendorId)
		CONTINUE:(pCompleteFlag'="")&(CmpFlag'=pCompleteFlag)
		CONTINUE:(pAuditFlag'="")&(Approveed'=pAuditFlag)
		s PoStatus=..GetPoStatus(PoId)
		CONTINUE:(pStatus'="")&('$f(pStatus,PoStatus))
		s:PoDate'="" PoDate=..DL2H(PoDate)
		s EffecQty=$p(..GetPoDetailQty(PoId),"^",2)
		CONTINUE:(pfilterDetail="Y")&(EffecQty=0)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(PoId,PoNo,Vendor,PoLocDesc,PoStatus,PoDate,VenId,PurUserId,StkGrpId,CmpFlag,Email,ReqLocDesc,ReqLoc,Approveed,ApproveedUser,ApproveedDate,CancelReasonId,CancelReason)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
ChkInci(inciStr,inpp)
	;检查某订单中是否包含某库存项
	;return : 0 - 否 1 -是
	n (inciStr,inpp)
	s Inci=$p(inciStr,"^",1)
	s Incsc=$p(inciStr,"^",2)
	s Scg=$p(inciStr,"^",3)
	s LocId=$p(inciStr,"^",4)
	s UserId=$p(inciStr,"^",5)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),LocId,Scg)
	s ch=0
	s ok=0
	f  s ch=$o(^INPO(inpp,"POI",ch)) q:(ch="")!(ok>0)  d
	.s PoiInci=$p(^INPO(inpp,"POI",ch),"^",1)
	.s PoiIncsc=$p(^INCI(PoiInci,2),"^",2)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(PoiInci)
	.s PoiScg=$p(ScgInfo,"^",5)
	.q:(Inci'="")&&(PoiInci'=Inci)
	.q:(Incsc'="")&&(PoiIncsc'=Incsc)
	.q:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_PoiScg_"^"))
	.s ok=1
	q ok
}

/// 设置备注信息
/// Author:zhwh
/// Date:2012-10-29
/// Argu:
///  po -订单主表rowid
///  remarks -　备注内容串
/// Return:
///  0 - success
///  <0 - failure
ClassMethod SetRemarks(po As %String, remarks As %String) As %String
{
	n (po,remarks)
	s po=+po
	i po'>0 q -1

	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_po)<0 q -99
	s obj=##class(User.INPO).%OpenId(po)
	d obj.%Reload()
	d obj.INPORemarks.Clear()
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	f i=1:1:$l(remarks,memoDelim) d
	.s rem1=$p(remarks,memoDelim,i)
	.d obj.INPORemarks.Insert(rem1)
	.
	s ret= obj.%Save()
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_po)
	i $$$ISERR(ret) q -2
	;
	q 0
}

/// Description:获取库存项信息
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Input:		库存项Id,Params-医院\安全组\科室\人员
/// Return:		
ClassMethod GetItmInfo(IncId As %String, Params As %String) As %Library.String
{
	n (IncId,Params)
	s Data=..GetItmStr(IncId,Params)
	s Title="VenId^VenDesc^ManfId^ManfDesc^CarrierId^CarrierDesc^PurUomId^PurUomDesc^Rp^Sp"
		_"^StkQty^MaxQty^MinQty^BRp^BSp^BUomDesc^Spec^BUomId^Confac"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

ClassMethod GetItmStr(IncId As %String, Params As %String) As %Library.String
{
	n (IncId,Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	q:+IncId=0 ""
	s AppCode=..%GetParameter("AppName")
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s LocId=PJObj.%Get("LocId")
	s:((HospId="")&&(LocId'="")) HospId=$p(^CTLOC(LocId),"^",22)
	s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId

	s VenInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigVendor(IncId,AppCode,ParamStr)
	s VenId=$p(VenInfo,"^",1)
	s VenDesc=$p(VenInfo,"^",2)

	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigManf(IncId,AppCode,ParamStr)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfDesc=$p(ManfInfo,"^",2)

	s CarrierInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigCarrier(IncId,AppCode,ParamStr)
	s CarrierId=$p(CarrierInfo,"^",1)
	s CarrierDesc=$p(CarrierInfo,"^",2)

	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PurUomId=$p(^INCI(IncId,3),"^",6)
	s PurUomDesc=""
	s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	s Confac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)

	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetConfigRp(IncId,PurUomId,AppCode,ParamStr)
	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId)
	s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(IncId,LocId,PurUomId,+$h)
	s QtyInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetItmLocMNRQtyUO(IncId,LocId,PurUomId)
	s MinQty=$p(QtyInfo,"^",1)
	s MaxQty=$p(QtyInfo,"^",2)

	s BUomDesc=$s(BUomId'="":$p(^CT("UOM",BUomId),"^",2),1:"")
	s BRp=$s(+Confac'=0:Rp/Confac,1:Rp)
	s BSp=$s(+Confac'=0:Sp/Confac,1:Sp)
	s BRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(BRp,HospId,2)
	s BSp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(BSp,HospId,2)
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)

	s Data=VenId_"^"_VenDesc_"^"_ManfId_"^"_ManfDesc_"^"_CarrierId_"^"_CarrierDesc_"^"_PurUomId_"^"_PurUomDesc_"^"_Rp_"^"_Sp
		_"^"_StkQty_"^"_MaxQty_"^"_MinQty_"^"_BRp_"^"_BSp_"^"_BUomDesc_"^"_Spec_"^"_BUomId_"^"_Confac

	q Data
}

/// 取订单主表的数据
/// Author:zhangxiao
/// Date:2013-06-24
/// Argu:
/// 		IN_Po -主表rowid
/// Return:
///  主表的数据
/// w ##class(web.DHCSTMHUI.INPO).SelectMain("884")
ClassMethod SelectMain(PoId As %String) As %String
{
	n (PoId)
	q:PoId="" ""
	s result=""
	&sql(SELECT IN_PO, INPO_No, INPO_APCVM_DR, INPO_Date, INPO_CTCUR_DR, INPO_ExRate, INPO_HandChg,
	INPO_SSUSR_DR,INPO_Remarks, INPO_Approved , INPO_Completed, INPO_Reference_DR, INPO_TransDate,
	INPO_TransTime, INPO_DateNeeded, INPO_UserCompleted, INPO_UserCompleted_DR, INPO_CreditTerm_DR,
	INPO_UserUpdated_DR, INPO_Cancelled, INPO_FullFilled, INPO_UserCancFullFilled_DR,
	INPO_DateCancelFullFilled, INPO_TimeCancelFullFilled, INPO_ReasonCancFullFilled_DR
	into INPO, INPONo, INPOAPCVMDR, INPODate, INPOCTCURDR, INPOExRate, INPOHandChg,INPOSSUSRDR,
	INPORemarks, INPOApproved , INPOCompleted, INPOReferenceDR, INPOTransDate,INPOTransTime,
	INPODateNeeded, INPOUserCompleted, INPOUserCompletedDR, INPOCreditTermDR,INPOUserUpdatedDR,
	INPOCancelled, INPOFullFilled, INPOUserCancFullFilledDR,INPODateCancelFullFilled, INPOTimeCancelFullFilled,
	INPOReasonCancFullFilledDR
	from IN_PO where %ID=:PoId)
	q:SQLCODE result
	s result=INPO_"^"_INPONo_"^"_INPOAPCVMDR_"^"_INPODate_"^"_INPOCTCURDR_"^"_INPOExRate_"^"_INPOHandChg_"^"_INPOSSUSRDR_"^"_
	INPORemarks_"^"_INPOApproved_"^"_INPOCompleted_"^"_INPOReferenceDR_"^"_INPOTransDate_"^"_INPOTransTime_"^"_
	INPODateNeeded_"^"_INPOUserCompleted_"^"_INPOUserCompletedDR_"^"_INPOCreditTermDR_"^"_INPOUserUpdatedDR_"^"_
	INPOCancelled_"^"_INPOFullFilled_"^"_INPOUserCancFullFilledDR_"^"_INPODateCancelFullFilled_"^"_INPOTimeCancelFullFilled_"^"_
	INPOReasonCancFullFilledDR

	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim() //备注分隔符
	s InGrRemarks=$lts($g(INPORemarks),memoDelim)
	i INPOAPCVMDR'="" d
	.s VenDesc=$p(^APC("APCVM",INPOAPCVMDR),"^",3)
	i INPOSSUSRDR'="" d
	.s user=$p(^SSU("SSUSR",INPOSSUSRDR),"^",2)
	i (INPODate'="")&&(INPODate'["-") d
	.s date=..DL2H(INPODate)

	s PoLoc=""
	s PoLocDesc=""
	s StkGrpId=""
	s StkType=""
	s DhcPoId=$o(^DHCINPO(0,"INPO",PoId,0))
	i DhcPoId'=""  d
	.s PoLoc =$p(^DHCINPO(DhcPoId),"^",2)
	.s:PoLoc'="" PoLocDesc=$p(^CTLOC(PoLoc),"^",2)
	.s Type=$p(^DHCINPO(DhcPoId),"^",4)
	.s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
	.s:StkGrpId'="" StkType=$p(^DHCSCG(StkGrpId),"^",2)
	q result_"^"_PoLoc_"^"_PoLocDesc_"^"_StkGrpId_"^"_StkType_"^"_VenDesc_"^"_user_"^"_date
}

/// Description:推送订单到平台
/// Creator:	tsr
/// CreatDate:	2019-05-29
/// Table:		IN_PO
/// Others: 	d ##class(web.DHCSTMHUI.INPO).SendInPo()
ClassMethod SendInPo(Detail As %String, emflag As %String) As %String
{
	n (Detail,emflag)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s HospId=""
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		
		i HospId="" d
		.s DhcPoId=$o(^DHCINPO(0,"INPO",RowId,""),-1)
		.i DhcPoId'="" d
		..s PoLocId =$p(^DHCINPO(DhcPoId),"^",2)
		..s HospId=..sssHospId(PoLocId)
		
		s ret=+##class(web.DHCSTMHUI.ServiceForSCI).getHopOrder(RowId, emflag)
		i ret'=0 d RtnObj.Err(-2,RowId,"推送失败!")
		q:RtnObj.success'=0
		s ret=+##class(web.DHCSTMHUI.ServiceForECS).saveSupOrder(RowId, emflag,HospId)
		i ret'=0 d RtnObj.Err(-3,RowId,"推送失败!")
		q:RtnObj.success'=0
		s PlatSend="Y"
		&sql(UPDATE IN_PO SET INPO_PlatSend=:PlatSend, INPO_Cancelled=null WHERE IN_PO=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-4,RowId,"更新订单推送状态失败!")
		q:RtnObj.success'=0
	}
	q RtnObj.Json()
}

/// 催单
ClassMethod ReminderInPo(Detail As %String) As %String
{
	n (Detail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s InpoiStr="",HospId=""
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		
		i HospId="" d
		.s DhcPoId=$o(^DHCINPO(0,"INPO",RowId,""),-1)
		.i DhcPoId'="" d
		..s PoLocId =$p(^DHCINPO(DhcPoId),"^",2)
		..s HospId=..sssHospId(PoLocId)
		
		s InpoiStr=""
		s Ch=0
		f  s Ch=$o(^INPO(RowId,"POI",Ch)) q:Ch=""  d
		.s Inpoi=RowId_"||"_Ch
		.i InpoiStr="" s InpoiStr=Inpoi
		.e  s InpoiStr=InpoiStr_"^"_Inpoi
		
		s ret=+##class(web.DHCSTMHUI.ServiceForSCI).updateOrder("1", InpoiStr)
		i ret'=0 d RtnObj.Err(-2,RowId,"加急失败!")
		q:RtnObj.success'=0
		s ret=+##class(web.DHCSTMHUI.ServiceForECS).remindOrder(InpoiStr,HospId)
		i ret'=0 d RtnObj.Err(-2,RowId,"加急失败!")
		q:RtnObj.success'=0
		
	}
	q RtnObj.Json()
}

/// Descript:	撤销平台订单
/// Creator:	wangjiabin
/// CreateDate:	2020-09-22
/// Input:		
/// Output:		
ClassMethod CancelInPo(Detail As %String) As %String
{
	n (Detail)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	s InpoiStr="",HospId=""
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		continue:RowId=""
		i HospId="" d
		.s DhcPoId=$o(^DHCINPO(0,"INPO",RowId,""),-1)
		.i DhcPoId'="" d
		..s PoLocId =$p(^DHCINPO(DhcPoId),"^",2)
		..s HospId=..sssHospId(PoLocId)
		
		s InpoiStr=""
		s Ch=0
		f  s Ch=$o(^INPO(RowId,"POI",Ch)) q:Ch=""  d
		.s Inpoi=RowId_"||"_Ch
		.i InpoiStr="" s InpoiStr=Inpoi
		.e  s InpoiStr=InpoiStr_"^"_Inpoi
		
		s ret=+##class(web.DHCSTMHUI.ServiceForSCI).updateOrder("2",InpoiStr)
		i ret'=0 d RtnObj.Err(-2,RowId,"撤单失败!")
		q:RtnObj.success'=0
		s ret=+##class(web.DHCSTMHUI.ServiceForECS).cancelOrder(InpoiStr,HospId)
		i ret'=0 d RtnObj.Err(-2,RowId,"撤单失败!")
		q:RtnObj.success'=0
		
		s Len=$l(InpoiStr,"^")
		f i=1:1:Len q:RtnObj.success<0  d
		.s Inpoi=$p(InpoiStr,"^",i)
		.q:Inpoi=""
		.s DHCInpoi=$o(^DHCINPOI(0,"INPOI",Inpoi,0))
		.q:DHCInpoi=""
		.;暂按整单撤销
		.;s Flag=$p(^DHCINPOI(DHCInpoi),"^",3)
		.;q:Flag="N"		;已撤销发送平台
		.
		.s DHCInpoiObj=##class(User.DHCINPOItm).%OpenId(DHCInpoi)
		.s DHCInpoiObj.POIPlatSentFlag="N"
		.s DHCInpoiObj.POICanceledFlag="Y"
		.s Sc=DHCInpoiObj.%Save()
		.i $$$ISERR(Sc) d RtnObj.Err(-3,RowId,"撤单处理POIPlatSentFlag失败!")
		q:RtnObj.success'=0
		
		s InpoObj=##class(User.INPO).%OpenId(RowId)
		s InpoObj.INPOPlatSend="N"
		s InpoObj.INPOCancelled="Y"
		s Sc=InpoObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,RowId,"撤单处理INPOPlatSend失败!") q
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 同步ECS供应链订单状态
/// w ##class(web.DHCSTMHUI.INPO).getOrdersState
ClassMethod getOrdersState(Params)
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".getOrdersState"
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_"参数解析错误").Json()
	
	s InpoIdStr=PJObj.%Get("InpoIdStr")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s HospId=PJObj.%Get("HospId")
	s Ret=##class(web.DHCSTMHUI.ServiceForECS).getOrdersState(InpoIdStr,StartDate,EndDate,HospId)
	q RtnObj.Json()
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
	.e  s dLocs=dLocs_","_subLoc
	&sql(close domiLoc)
	q dLocs
}

/// Description: 根据订单获取采购信息
/// Creator: lihui 20200703
/// Table: 
/// Input: 订单ID
/// Return: 采购单号
/// w ##class(web.DHCSTMHUI.INPO).GetPlanInfo()
ClassMethod GetPlanInfo(InpoId As %String) As %String
{
	n (InpoId)
	q:InpoId="" ""
	s info=""
	s inpochl=$o(^INPO(InpoId,"POI",""))
	q:+inpochl'>0 ""
	s poitmid=InpoId_"||"_inpochl
	s PurId=$o(^INPP(0,"INPOI",poitmid,""))
	q:+PurId'>0 ""
	s PurInfo=^INPP(PurId)
	s INPPNo=$p(PurInfo,"^",1)
	s info=INPPNo
	q info
}

/// Description: 根据订单明细ID获取采购信息
/// Creator: lihui 20200703
/// Table: 
/// Input: 订单明细ID
/// Return: 生产厂家
/// w ##class(web.DHCSTMHUI.INPO).GetPlanItmInfo("40||1")
ClassMethod GetPlanItmInfo(PoitmId As %String) As %String
{
	n (PoitmId)
	q:PoitmId="" ""
	s info=""
	s (PhManfId,PhManf)=""
	s PurId=$o(^INPP(0,"INPOI",PoitmId,""))
	i +PurId>0 d
	.s PurChl=$o(^INPP(0,"INPOI",PoitmId,PurId,""))
	.q:+PurChl'>0
	.s PurItmInfo=^INPP(PurId,"PPI",PurChl)
	.s PhManfId=$p(PurItmInfo,"^",6)
	.s PhManf=$s(+PhManfId>0:$p(^PHMNF(PhManfId),"^",2),1:"")
	s Poinfo=^INPO(+PoitmId)
	s ApcVenId=$p(Poinfo,"^",2)
	s ApcVendor=$s(+ApcVenId>0:$p(^APC("APCVM",ApcVenId),"^",3),1:"") 
	s info=PhManfId_"^"_PhManf_"^"_ApcVenId_"^"_ApcVendor
	q info
}

/// Descript:	取消验收订单
/// 对象类型数据
ClassMethod jsCalApprove(Params As %String) As %String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CalApprove(Params)
	q RtnObj.Json()
}

/// Descript:	取消验收订单
/// Table:		IN_PO
/// Input:		主单RowId
/// Return：	成功，失败
ClassMethod CalApprove(Params As %String) As RtnObj
{
	n (Params)

	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s PoId=PJObj.%Get("RowId")
	i +PoId=0  d RtnObj.Err(-1,"","订单ID不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("PoLoc")
	s HospId=PJObj.%Get("gHospId")
	s GroupId=PJObj.%Get("gGroupId")
	s ApproveDate=""
	s ApproveTime=""
	s gUserId=""
	s ApproveFlag="N"

	s CompFlag=$p(^INPO(PoId),"^",9)
	i CompFlag'="Y" d RtnObj.Err(-2,"","订单未完成，不能取消验收","",0)
	q:RtnObj.success'=0 RtnObj
	s CancelFlag=$p(^INPO(PoId),"^",18)
	i CancelFlag="Y" d RtnObj.Err(-2,"","订单已取消，不能取消验收","",0)
	q:RtnObj.success'=0 RtnObj

	i ..sssLock(..%GetParameter("AppName")_PoId)<0  d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj

	ts
	&sql(update DHC_INPO set PO_ApprovedUser_DR=:gUserId,PO_ApprovedDate=:ApproveDate,PO_ApprovedTime=:ApproveTime where PO_INPO_DR =:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单附加表失败!")
	q:RtnObj.success'=0 RtnObj

	&sql(update IN_PO set INPO_Approved=:ApproveFlag where IN_PO=:PoId)
	i SQLCODE'=0  tro  d ..sssUnLock(..%GetParameter("AppName")_PoId) d RtnObj.Err(-3,"","更新主单失败!")
	q:RtnObj.success'=0 RtnObj
	
	d ##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).UnComplete(PoId,"POA","PO")

	d ..sssUnLock(..%GetParameter("AppName")_PoId)

	tc
	s RtnObj.rowid=PoId
	q RtnObj
}

/// 获取订单关联采购单Rowid
/// w ##class(web.DHCSTMHUI.INPO).GetPurIdByPo(63)
ClassMethod GetPurIdByPo(Inpo As %String) As %String
{
	n (Inpo)	
	q:Inpo="" ""
	s PurId=""
	s Ch=""
	f  s Ch=$o(^INPO(Inpo,"POI",Ch)) q:(Ch="")||(PurId'="")  d
	.s Inpoi=Inpo_"||"_Ch
	.s PurId=$o(^INPP(0,"INPOI",Inpoi,""))
	q PurId
}

}
