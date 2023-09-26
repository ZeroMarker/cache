Import sqluser

/// Descript:	依据转移请求生成采购计划制单
/// Creator:	lxt
/// CreateDate:	2018-06-07
Class web.DHCSTMHUI.INPurPlanAuxByReq Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询请求单主单信息
/// Creator:	lxt
/// CreateDate:	2018-06-07
/// Table:		IN_Request
/// Input:		"{""PurLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""08/05/2018"",""StkScg"":"""",""EndDate"":""07/06/2018"",""ReqType"":"""",""DefLocPP"":"""",""RowId"":"""",""ReqNo"":""""}
/// Return：	请求主表ROwid，请求单号，请求科室，制单日期，制单时间，制单人
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlanAuxByReq","INReqM","{""PurLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""08/05/2018"",""StkScg"":"""",""EndDate"":""07/06/2018"",""ReqType"":"""",""DefLocPP"":"""",""RowId"":"""",""ReqNo"":""""}")
Query INReqM(Params As %String) As Query(ROWSPEC = "RowId,ReqNo,ReqLocId,ReqLoc,StkScgId,StkScg,CreateUser,CreateDate,CreateTime,TransStatus") [ SqlProc ]
{
}

ClassMethod INReqMExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s LocId=PJObj.%Get("PurLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s ReqType=PJObj.%Get("ReqType")
	s userId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s No=PJObj.%Get("ReqNo")
	s Scg=PJObj.%Get("StkScg")
	s includeDefLocPP=PJObj.%Get("DefLocPP")
	s TransStatus0=PJObj.%Get("TransStatus0")
	s TransStatus1=PJObj.%Get("TransStatus1")
	s TransStatus2=PJObj.%Get("TransStatus2")
	s pReqLoc=PJObj.%Get("ReqLoc")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:LocId="" $$$OK
	s pHospId=..sssHospId(LocId)
	s:pHospId="" pHospId=gHospId
	i Scg'="" d
	.s UserCatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(userId,..sssCode(),LocId,Scg,pHospId)
	e  d
	.s UserCatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(userId,..sssCode(),LocId,"",pHospId)  //若类组为空，则传递User类组串
	s SqlStr="select INRQ_Rowid as RowId,"
	s SqlStr=SqlStr_"INRQ_No,"
	s SqlStr=SqlStr_"INRQ_RecLoc_DR,INRQ_RecLoc_DR->CTLOC_Desc as LocDesc,"
	s SqlStr=SqlStr_"INRQ_Date,INRQ_Time,"
	s SqlStr=SqlStr_"INRQ_SSUSR_DR->SSUSR_Name as UserName "
	s SqlStr=SqlStr_" from IN_Request "
	s SqlStr=SqlStr_" where INRQ_UserCompleted='Y' AND INRQ_RecLoc_DR<>INRQ_ReqLoc_DR "
	s SqlStr=SqlStr_" and (INRQ_Date between "_StartDate_" and "_EndDate_") "
	i LocId'=""  d
	.i includeDefLocPP'="Y" d  
	..s SqlStr=SqlStr_" and INRQ_ReqLoc_DR="_LocId
	.e  d
	..s domiLocs=##class(web.DHCSTMHUI.Common.UtilCommon).GetDominLoc(LocId)
	..i domiLocs'=""  d
	...s domiLocs=LocId_","_domiLocs
	...s SqlStr=SqlStr_" and INRQ_ReqLoc_DR in ("_domiLocs_")"
	..e  d
	...s SqlStr=SqlStr_" and INRQ_ReqLoc_DR="_LocId
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		CONTINUE:##class(web.DHCSTMHUI.INRequest).AuditStatus(RowId)'=2	;该请求单供应方未审核
		CONTINUE:..CheckPur(RowId)="Y"   ;该请求单明细已经全部采购
		s status="",StkScgId="",inrqrowid="",template=""
		s inrqrowid =$o(^DHCINRQ(0,"INRQ",RowId,inrqrowid)) 
		i inrqrowid'="" d
		.s status=$P(^DHCINRQ(inrqrowid),"^",1)
		.s StkScgId=$P(^DHCINRQ(inrqrowid),"^",10)
		.s template=$P(^DHCINRQ(inrqrowid),"^",18)
		CONTINUE:template="Y" 
		CONTINUE:(ReqType'="")&&(ReqType'=status)
		CONTINUE:(UserCatGrpStr'="")&&(StkScgId'="")&&(("^"_UserCatGrpStr_"^")'[("^"_StkScgId_"^"))
		s ReqNo = Result.Data("INRQ_No")
		CONTINUE:(No'="")&&(ReqNo'[No)
		s TransStatus=##class(web.DHCSTMHUI.DHCINIsTrf).TransferStatus(RowId)
		continue:(TransStatus=0)&&(TransStatus0'="Y")
		continue:(TransStatus=1)&&(TransStatus1'="Y")
		continue:(TransStatus=2)&&(TransStatus2'="Y")
		s ReqLocId = Result.Data("INRQ_RecLoc_DR")
		continue:(pReqLoc'="")&&(ReqLocId'=pReqLoc)
		s ReqLoc = Result.Data("LocDesc")
		s CreateDate = Result.Data("INRQ_Date")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s CreateTime = Result.Data("INRQ_Time")
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s CreateUser = Result.Data("UserName")
		s:StkScgId'="" StkScg=$p(^DHCSCG(StkScgId),"^",2)
		
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,ReqNo,ReqLocId,ReqLoc,StkScgId,StkScg,CreateUser,CreateDate,CreateTime,TransStatus)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	判断某请求单明细是否全部被采购
/// Creator:	lxt
/// CreateDate:	2018-06-07
/// Table:		DHC_INPPReqItm
/// Input:		请求单id
/// Return：	Y:全部采购;N:存在未采购项目
ClassMethod CheckPur(ReqId As %String) As %Library.String
{
	n (ReqId)
	q:ReqId="" "Y"
	s Flag="Y"
	s Chl=0
	f  s Chl=$o(^INRQ(ReqId,"RQI",Chl)) q:Chl=""  d
	.s refuseflag=$P(^INRQ(ReqId,"RQI",Chl),"^",6)
	.q:refuseflag="Y"
	.s ReqItmId=ReqId_"||"_Chl
	.i '$d(^INPP(0,"RQI",ReqItmId))  d
	..s Flag="N"
	q Flag
}

/// Descript:	查询请求单主单明细信息
/// Creator:	lxt
/// CreateDate:	2018-06-07
/// Table:		IN_Request
/// Input:		主表rowid
/// Return：	请求主表ROwid，请求单号，请求科室，制单日期，制单时间，制单人
/// Return：子表Rowid，药品代码，名称，请求数量，请求单位RowId,Desc,96,153
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INPurPlanAuxByReq","INReqD","RowId","Desc","100","153")
Query INReqD(ReqIdStr As %String, LocId As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Brand,Spec,ReqQty:%Float,UomId,UomDesc,Locqty:%Float,TransQty:%Float,RepQty:%Float,LocAvaQty:%Float,BUomId,ConFac:%Float,ReqLocId,ReqLocDesc,SpecDesc") [ SqlProc ]
{
}

ClassMethod INReqDExecute(ByRef qHandle As %Binary, ReqIdStr As %String, LocId As %String) As %Status
{
	n (qHandle,ReqIdStr,LocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:ReqIdStr="" $$$OK
	
	s SqlStr="select INRQI_Rowid as RowId,"
	s SqlStr=SqlStr_"INRQI_INCI_DR,INRQI_INCI_DR->INCI_Code as InciCode,INRQI_INCI_DR->INCI_Desc as InciDesc,"
	s SqlStr=SqlStr_"INRQI_ReqQty,INRQI_CTUOM_DR,INRQI_CTUOM_DR->CTUOM_Desc as ReqUom,"
	s SqlStr=SqlStr_"INRQI_RefuseFlag as RefuseFlag"
	s SqlStr=SqlStr_" from IN_ReqItm "
	s SqlStr=SqlStr_" where INRQI_INRQ_ParRef in ("_ReqIdStr_")"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ReqLocId=$p(^INRQ(+RowId),"^",6)		;请求部门
		s ReqLocDesc=""
		s:ReqLocId'="" ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2) 
		CONTINUE:$d(^INPP(0,"RQI",RowId))   ;已经生成采购计划
		s InciId = Result.Data("INRQI_INCI_DR")
		s RefuseFlag=Result.Data("RefuseFlag")
		CONTINUE:RefuseFlag="Y"
		s dhcinrqi=$o(^DHCINRQI(0,"INRQI",RowId,""))
		s INRQICanceled="N",SpecDesc=""
		i dhcinrqi'="" d
		.s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
		.s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)
		CONTINUE:INRQICanceled="Y"
		s Locqty=""
		s Locqty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,LocId,+$h)
		s InciCode = Result.Data("InciCode")
		s InciDesc = Result.Data("InciDesc")
		s ReqQty = Result.Data("INRQI_ReqQty")
		s UomId = Result.Data("INRQI_CTUOM_DR")
		s UomDesc = Result.Data("ReqUom")
		s TransQty=..TransQty(RowId)
		s RepQty=0  //标准库存
		&sql(select nvl(INCIL_RepQty,0) into :RepQty from inc_itmloc where INCIL_CTLOC_DR=:ReqLocId and INCIL_INCI_ParRef=:InciId)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s TransQty=TransQty/ConFac
		s Locqty=Locqty/ConFac
		s RepQty=RepQty/ConFac
		s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(InciId)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s LocAvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(LocId,InciId,UomId)
		d OutPutRow2
	}
	Quit $$$OK
OutPutRow2
	s Data=$lb(RowId,InciId,InciCode,InciDesc,Brand,Spec,ReqQty,UomId,UomDesc,Locqty,TransQty,RepQty,LocAvaQty,BUomId,ConFac,ReqLocId,ReqLocDesc,SpecDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 对象类型数据
/// w ##class(web.DHCSTMHUI.INPurPlanAuxByReq).jsCreatePurByReq(^litmp("Maininpur"),^litmp("Detailinpur"))
ClassMethod jsCreatePurByReq(Main As %String, Detail As %String) As %String
{
	n (Main,Detail)
	;s ^litmp("Maininpur")=Main
	;s ^litmp("Detailinpur")=Detail
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CreatePurByReq(Main,Detail)
	q RtnObj.Json()
}

/// Descript:	根据请求明细记录生成采购计划单
/// Creator:	lxt
/// CreateDate:	2018-07-24
/// Table:		IN_Purplan,IN_PurplanItm
/// Input:		科室Id,操作人Id,请求明细rowid^请求明细rowid,类组id
/// Return：	计划单id：成功，
ClassMethod CreatePurByReq(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail)
	s RtnObj=##class(RtnObj).%New()

	tstart
	s RtnObj=##class(web.DHCSTMHUI.INPurPlan).Update(Main)
	i RtnObj.success<0 tro  q RtnObj
	s PurId=RtnObj.rowid

	s PJMainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s ScMain=PJMainObj.%FromJSON(Main)
	i ScMain'=0  tro  q RtnObj.Err(-1,"","参数解析失败")
	s SupplyLocId=PJMainObj.%Get("PurLoc")

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0  tro  q RtnObj.Err(-2,"","参数解析失败")
	
	s Pid=..NewPid()
	k ^TMPPURPLAN(Pid)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s ReqiId=Obj.%Get("RowId")
		s InciId=Obj.%Get("InciId")
		s UomId=Obj.%Get("UomId")
		s Qty=Obj.%Get("Qty")
		s ReqLocIdSub=Obj.%Get("ReqLocId")
		s SpecDesc=Obj.%Get("SpecDesc")
		CONTINUE:ReqiId=""
		CONTINUE:InciId=""
		
		s Parref=+ReqiId
		s Chl=$p(ReqiId,"||",2)
		s ReqLocId=$p(^INRQ(Parref),"^",6)			;请求科室
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s ConFac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s ConFac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
		s PurQty=Qty*ConFac1/ConFac2
		s SubStr=InciId_"^"_ReqLocIdSub_"^"_SpecDesc
		i '$d(^TMPPURPLAN(Pid,"PurPlan",SubStr))  d
		.s ^TMPPURPLAN(Pid,"PurPlan",SubStr)=InciId_"^"_PurQty_"^"_PurUomId_"^"_ReqLocId_"^"_ReqiId_"^"_SpecDesc
		e  d
		.s $p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",2)=PurQty+$p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",2)
		.s $p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",5)=$p(^TMPPURPLAN(Pid,"PurPlan",SubStr),"^",5)_","_ReqiId
	}
	s Sub=""
	s count=0
	f  s Sub=$o(^TMPPURPLAN(Pid,"PurPlan",Sub)) q:(Sub="")!(RtnObj.success<0)  d
	.s SubData=^TMPPURPLAN(Pid,"PurPlan",Sub)
	.s InciId=$p(SubData,"^",1)
	.s Qty=$p(SubData,"^",2)
	.s UomId=$p(SubData,"^",3)
	.s ReqLocId=$p(SubData,"^",4)
	.s ReqIdStr=$p(SubData,"^",5)
	.s SpecDesc=$p(SubData,"^",6)
	.s ItmInfo=##class(web.DHCSTMHUI.INPurPlan).GetItmStr(InciId,"^"_SupplyLocId)
	.s VendorId=$p(ItmInfo,"^",1)
	.s ManfId=$p(ItmInfo,"^",3)
	.s CarrierId=$p(ItmInfo,"^",5)
	.s Rp=$p(ItmInfo,"^",9)
	.s title="RowId^InciId^SpecDesc^ManfId^Qty^UomId^Rp^VendorId^CarrierId^ReqLocId"
	.s data="^"_InciId_"^"_SpecDesc_"^"_ManfId_"^"_Qty_"^"_UomId_"^"_Rp_"^"_VendorId_"^"_CarrierId_"^"_ReqLocId
	.s nDetailObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,title)
	.s nDetailObjs="["_nDetailObj_"]"
	.s RtnObj=##class(web.DHCSTMHUI.INPurPlanItm).Save(PurId,nDetailObjs)
	.q:RtnObj.success<0
	.s PurItmId=RtnObj.rowid
	.s RtnObj=..Insert(PurItmId,ReqIdStr)
	.q:RtnObj.success<0
	.s count=count+1
	.
	i RtnObj.success<0 tro  q RtnObj
	s RtnObj.rowid=PurId
	tc
	k ^TMPPURPLAN(Pid)
	q RtnObj
}

/// Descript:	查找请求单明细的转移数
/// Creator:	lxt
/// CreateDate:	2018-07-25
/// Table:		DHC_inistrfitm
/// Input:		请求明细id
/// Return：	转移数量
ClassMethod TransQty(INRQI As %String) As %String
{
	n (INRQI)
	s sumQty=0
	s init=""
	f  s init=$O(^DHCINIT(0,"RQI",INRQI,init)) q:init=""  d
	.s ch=0
	.f  s ch=$O(^DHCINIT(0,"RQI",INRQI,init,ch)) q:ch=""  d
	..s inclb=$P(^DHCINIT(init,"ITI",ch),"^",3)
	..
	..s qty=$P(^DHCINIT(init,"ITI",ch),"^",1)
	..s uom=$P(^DHCINIT(init,"ITI",ch),"^",7)
	..s buom=$P(^INCI(+inclb,1),"^",10)
	..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	..s qty=qty*fac
	..s sumQty=sumQty+qty
	q sumQty
}

/// Descript:	插入采购计划明细和请求明细关联
/// Creator:	lxt
/// CreateDate:	2018-07-25
/// Table:		DHC_INPPReqItm
/// Input:		采购明细id，请求明细id串
/// Return：    成功，失败
ClassMethod Insert(Parref As %String, ListReqId As %String) As RtnObj
{
	n (Parref,ListReqId)
	s RtnObj=##class(RtnObj).%New()
	i Parref="" q RtnObj.Err(-1,"","关联采购明细为空","",0)
	i ListReqId="" q RtnObj.Err(-2,"","关联请求明细为空","",0)

	ts
	s Len=$l(ListReqId,",")
	f i=1:1:Len  q:RtnObj.success'=0  d
	.s ReqId=$p(ListReqId,",",i)
	.i ReqId=""  d RtnObj.Err(-3,"","关联请求明细为空","",0) q
	.s Chl=1+$o(^INPP(+Parref,"PPI",$p(Parref,"||",2),"RQI",""),-1)
	.&sql(insert into DHC_INPPReqItm(PPREQI_INPPI_Parref,PPREQI_ChildSub,PPREQI_REQITM_DR) 
	values (:Parref,:Chl,:ReqId))
	.i SQLCODE'=0  d RtnObj.Err(-4,"","插入关联关系失败") q

	i RtnObj.success'=0  tro  q RtnObj
	tc
	q RtnObj
}

}
