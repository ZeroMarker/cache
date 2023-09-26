Import sqluser

Class web.DHCSTMHUI.DHCINAdj Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTSTOCKADJM";

/// 保存库存调整单据主表和明细数据
/// w ##class(web.DHCSTMHUI.DHCINAdj).SaveAdj(^bintmp(13),^bintmp(23))
ClassMethod jsSaveAdj(MainInfo As %String, ListData) As %Library.String
{
	n (MainInfo,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveAdj(MainInfo,ListData)
	q RtnObj.Json()
}

ClassMethod SaveAdj(MainInfo As %String, ListData) As RtnObj
{
	n (MainInfo,ListData)
	s RtnObj=##class(RtnObj).%New()
	
	tstart
	//插入主表
	s RtnObj=..Update(MainInfo)
	i RtnObj.success'=0 tro  q RtnObj
	s AdjId=RtnObj.rowid
	
	//插入明细
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdjItm).Save(AdjId,ListData)
	i RtnObj.success'=0 tro  q RtnObj
	
	tcommit
	s RtnObj.rowid=AdjId
	q RtnObj
}

/// 插入或更新库存调整主表
/// Author:zhwh
/// Date:2012-07-09
/// Argu:
///  adj - 库存调整主表rowid
///  data - 库存调整主表数据串 
/// Return:
/// 	>0 - success
/// 	<=0 - failure
/// 	
ClassMethod Update(MainInfo As %String) As RtnObj
{
	n (MainInfo)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	s adj=PJObj.%Get("RowId")
	s adjLoc=PJObj.%Get("AdjLoc") 				//科室rowid
	s adjUser=PJObj.%Get("gUserId")   			//调整人
	s adjReason=PJObj.%Get("ForAdjustReasonId")	//调整原因
	s adjScg=PJObj.%Get("ScgStk")				//库存类组rowidScgStk
	s adjInst=PJObj.%Get("adjInst")				//盘点主表rowid(DHC_INStktk)
	s adjComp=PJObj.%Get("Complate")			//完成标志
	s adjState=PJObj.%Get("adjState")			//调整单状态
	s remark=PJObj.%Get("Remark")				//备注(备注的文本行之间须用$c(1)分隔)
	s adjDate=+$h    		//调整日期
	s adjTime=$p($h,",",2)  //调整时间
	s adjStkType="M"

	s AppName=..%GetParameter("AppName")
	i adj="" d
	.s adjNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,adjScg,adjLoc)
	.i adjNo="" s Sc=RtnObj.Err(-13,"","生成调整单号失败")
	q:RtnObj.success'=0 RtnObj
	
	i adj="" d
	.s obj=##class(User.DHCINAdj).%New()
	.s obj.INADNo=adjNo
	.s obj.INADDate=adjDate
	.s obj.INADTime=adjTime
	.s obj.INADStkType=adjStkType
	e  d
	.s obj=##class(User.DHCINAdj).%OpenId(adj)
	s obj.INADCompleted=adjComp
	d obj.INADSCGDRSetObjectId(adjScg)
	s obj.INADState=adjState
	d obj.INADSSUSRDRSetObjectId(adjUser)
	d obj.INADINSTDRSetObjectId(adjInst)
	s remark=$lfs(remark,$c(3))
	d obj.INADRemarks.Clear()
	d obj.INADRemarks.InsertList(remark)
	d obj.INADReasonAdjDRSetObjectId(adjReason)
	d obj.INADCTLOCDRSetObjectId(adjLoc)
	s result=obj.%Save()
	i $$$ISERR(result) q RtnObj.Err(-5,"","更新主表失败:"_result)
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// 删除库存调整记录主表记录
/// Author:zhwh
/// Date:2012-07-09
/// Argu：
///  adj - 库存调整记录主表rowid
/// Return:
/// 0 - success
/// <0 - failure
/// w ##class(web.DHCSTMHUI.DHCINAdj).Delete(350)
ClassMethod Delete(InAdj As %String) As %Library.String
{
	n (InAdj,%session)
	s RtnObj=##class(RtnObj).%New()
	i InAdj="" d RtnObj.Err(-1,"","未选择调整单!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s AllowDel=..AllowDel(InAdj)
	i AllowDel<0 d RtnObj.Err(-2,InAdj,"单据已完成不可删除","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i ..sssLock(..%GetParameter("AppName")_InAdj)<0 d RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	;先删除相关的高值跟踪信息
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrack).DelByPointer("A",+InAdj)
	i RtnObj.success<0 tro  d
	.d ..sssUnLock(..%GetParameter("AppName")_InAdj)  
	.d RtnObj.Err(-3,"","删除高值跟踪信息失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	&sql(delete from dhc_inadj where %ID=:InAdj)
	i SQLCODE'=0 tro  d
	.d ..sssUnLock(..%GetParameter("AppName")_InAdj)
	.d RtnObj.Err(-4,"","删除调整单失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	tc
	d ..sssUnLock(..%GetParameter("AppName")_InAdj)
	q RtnObj.Json()
}

/// 检查是否允许删除
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  adj -调整单主表rowid
/// Return:
///  0 - 允许
///  <0 -不允许
///    -1:记录不存在
///    -2:已经完成
///    -3:已经审核
///    -4:已经审核
ClassMethod AllowDel(InAdj As %String) As %String
{
	n (InAdj)
	s obj=##class(User.DHCINAdj).%OpenId(InAdj)
	i $$$ISERR(obj) q -1
	d obj.%Reload()
	s comp=obj.INADCompleted
	q:comp="Y" -2    	//已经完成
	s auditFlag=obj.INADChkFlag
	q:auditFlag="Y" -3  //已经审核
	q 0
}

/// 库存调整单审核
/// Author:zhwh
/// Date:2012-07-10
/// Argu：
///    adj - 库存调整记录主表rowid 
///    user - 审核人
/// Return:
///    0 :审核成功
///   -99:加锁失败
///   -100:业务数据基础代码发生变化(单位,售价)
///   -2:审核出错
///   -3:台帐处理出错
///   -4:库存处理出错
///   -1:状态不允许审核("未完成"等)
/// w ##class(web.DHCSTMHUI.DHCINAdj).JsAudit("95","{""RowId"":""95"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2""}")
ClassMethod JsAudit(AdjId As %String, Params As %String) As %String
{
	n (AdjId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..Audit(AdjId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 库存调整单审核
/// Author:zhwh
/// Date:2012-07-10
/// Argu：
///    adj - 库存调整记录主表rowid 
///    user - 审核人
/// Return:
///    0 :审核成功
///   -99:加锁失败
///   -100:业务数据基础代码发生变化(单位,售价)
///   -2:审核出错
///   -3:台帐处理出错
///   -4:库存处理出错
///   -1:状态不允许审核("未完成"等)
/// w ##class(web.DHCSTMHUI.DHCINAdj).Audit(^tmplh(13),^tmplh(2))
ClassMethod Audit(AdjId As %String, Params As %String) As RtnObj
{
	n (AdjId,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	s user=PJObj.%Get("gUserId")
	s MethodName=$CLASSNAME()_".Audit"
	//加锁
	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_AdjId)<0 q RtnObj.Err(-99,AdjId,MethodName_":加锁失败")
	s Ret=..AllowAudit(AdjId)
	i Ret<0 d ..sssUnLock(..%GetParameter("AppName")_AdjId)
	q:Ret=-2 RtnObj.Err(-2,AdjId,"调整单未完成,不允许审核!","",0)
	q:Ret=-3 RtnObj.Err(-2,AdjId,"调整单已审核,不允许再次审核!","",0)
	q:Ret'=0 RtnObj.Err(-2,AdjId,"请查看调整单状态,不允许审核!","",0)
	
	s RtnObj=..CheckDataValid(AdjId)
	q:RtnObj.success'=0 RtnObj

	//更新状态
	s status="20",chk="Y"
	s d=+$H,t=$p($h,",",2)
	&sql(update dhc_inadj set inad_chkflag=:chk,inad_chkDate=:d,inad_chktime=:t,
		INAD_ChkUSR_DR=:user,inad_state=:status where %ID=:AdjId )
	i SQLCODE'=0 d ..sssUnLock(..%GetParameter("AppName")_adj) q RtnObj.Err(-2,AdjId,MethodName_":更新数据失败") 
	//库存处理\台账处理
	s TrNo=""
	&sql(select inad_no into :TrNo from dhc_inadj where %ID=:AdjId)
	s err=0
	s ch=0
	f  s ch=$o(^DHCINAD(AdjId,"ADI",ch)) q:(ch="")!(RtnObj.success<0)  d
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.s adjitm=AdjId_"||"_ch
	.s obj=##class(User.DHCINAdjItm).%OpenId(adjitm)
	.d obj.%Reload()
	.s inclb=obj.INADIINCLBDR.%Id()
	.s qty=obj.INADIQty
	.s uom=obj.INADICTUOMDR.%Id()
	.s sp=obj.INADIUCost
	.s spAmt=obj.INADISPAmt
	.s rp=obj.INADIRP
	.s rpAmt=obj.INADIRPAmt
	.s trType="A"
	.s Pointer=adjitm
	.s trans=trType
	.s trans=trans_"^"_TrNo
	.s trans=trans_"^"_inclb
	.s trans=trans_"^"_qty
	.s trans=trans_"^"_uom
	.s trans=trans_"^"_sp
	.s trans=trans_"^"_user
	.s trans=trans_"^"_Pointer
	.s trans=trans_"^"_rp
	.s trans=trans_"^"_rpAmt
	.s trans=trans_"^"_spAmt
	.s inci=+inclb
	.s buom=$p(^INCI(inci,1),"^",10)
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s bqty=qty*fac   //换算成基本单位的数量
	.s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(inclb,bqty)   //处理库存
	.i ret<0 d ..sssUnLock(..%GetParameter("AppName")_AdjId)   s Sc=RtnObj.Err(2,"","库存处理失败!") q
	.s RtnObj=##class(web.DHCSTMHUI.Common.StockHandle).IntoTrans(trans)  //插入台账数据
	.i RtnObj.success'=0 d ..sssUnLock(..%GetParameter("AppName")_AdjId)  s Sc=RtnObj.Err(1,"","台账处理失败!") q
	.s dhcit=$o(^DHCITD(0,"Type","A","Pointer",Pointer,0))
	.s OriginalStatus=""
	.s:dhcit'="" OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	.s:(dhcit'="")&&(qty>0)&&(OriginalStatus'="NotUnique") ret=..UpdateBarCodeStatus("A",adjitm)
	.i (dhcit'="")&&(qty>0)&&(OriginalStatus'="NotUnique")&&(ret<0) d ..sssUnLock(..%GetParameter("AppName")_AdjId)  s Sc=RtnObj.Err(3,"","高值跟踪信息处理失败!") q
	q RtnObj
}

/// Descript:完成调整单(Js调用)
ClassMethod jsComplete(InAdj As %String, Params As %String) As %Library.String
{
	n (InAdj,Params)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..SetComplete(InAdj,Params)
	q RtnObj.Json()
}

/// Descript:取消完成调整单(Js调用)
ClassMethod jsCanComplete(InAdj As %String, Params As %String) As %Library.String
{
	n (InAdj,Params)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..SetCancelComplete(InAdj,Params)
	q RtnObj.Json()
}

/// 设置(或取消)库存调整单完成
/// Author:zhwh
/// Date:2012-10-24
/// Argu:
///  adj - 库存调整单主表 rowid
///  completed - 完成标志(Y,N)
/// Return:
/// 0 - success
/// <0 - failure
/// w ##class(web.DHCSTMHUI.DHCINAdj).SetComplete(234,"{""ScgStk"":""[object Object]"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""98"",""gHospId"":""2"",""AdjLoc"":""392"",""Complate"":"""",""Date"":""23/07/2018"",""User"":""4668"",""Audit"":"""",""ForAdjustReasonId"":"""",""RowId"":""235"",""INAdjNo"":""ZYXZ001YLMADJ20180723005"",""Time"":""14:43"",""Remark"":""""}")
ClassMethod SetComplete(InAdj As %String, Params As %String) As RtnObj
{
	n (InAdj,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	i InAdj=""	q RtnObj.Err(-2,"","主单ID不能为空!","",0)
	s adjComp=PJObj.%Get("INADCompleted")  //完成标志
	i (adjComp="Y")  q RtnObj.Err(-3,InAdj,":单据已完成,不允许修改状态","",0)
	i ..sssLock(..%GetParameter("AppName")_InAdj)<0 q RtnObj.Err(-99,"","加锁失败!")
	s audit=""
	&sql(select inad_completed,inad_chkflag into :comp,:audit from dhc_inadj where %id=:InAdj)
	i audit="Y"  d RtnObj.Err(-3,InAdj,":已审核,不允许修改状态","",0)
	i RtnObj.success'=0 d ..sssUnLock(..%GetParameter("AppName")_InAdj) q RtnObj
	&sql(update dhc_inadj set inad_completed='Y' where %id=:InAdj)
	i SQLCODE'=0 d RtnObj.Err(-4,InAdj,":设置完成状态失败","",0)
	i RtnObj.success'=0 d ..sssUnLock(..%GetParameter("AppName")_InAdj) q RtnObj
	q RtnObj
}

/// 是否允许审核
/// Author:zhwh
/// Date:2012-07-10
/// Argu:
///  adj - 调整单主表rowid
/// Return:
///  0 - sucess
/// <0 - failure
/// w ##class(web.DHCSTMHUI.DHCINAdj).AllowAudit(411)
ClassMethod AllowAudit(adj As %String) As %String
{
	n (adj)
	s obj=##class(User.DHCINAdj).%OpenId(adj)
	i $$$ISERR(obj) q -1
	d obj.%Reload()
	s comp=obj.INADCompleted
	q:comp'="Y" -2    //未完成
	s auditFlag=obj.INADChkFlag   //flag of audit
	q:auditFlag="Y" -3  //已经审核
	s state=obj.INADState
	i +state'<20 q -4
	q 0
}

/// 设置(或取消)库存调整单完成
/// Author:zhwh
/// Date:2012-10-24
/// Argu:
///  adj - 库存调整单主表 rowid
///  completed - 完成标志(Y,N)
/// Return:
/// 0 - success
/// <0 - failure
/// w ##class(web.DHCSTMHUI.DHCINAdj).SetCancelComplete(^TMPLH(10),^TMPLH(11))
ClassMethod SetCancelComplete(InAdj As %String, Params As %String) As RtnObj
{
	n (InAdj,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	i InAdj=""  q RtnObj.Err(-2,"","主单ID不能为空!","",0)
	s adjComp=PJObj.%Get("INADCompleted")  //完成标志
	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_InAdj)<0 -99
	s audit=""
	&sql(select inad_completed,inad_chkflag into :comp,:audit from dhc_inadj where %id=:InAdj)
	i (audit="Y")  d RtnObj.Err(-3,InAdj,"已审核,不允许修改状态","",0)
	i RtnObj.success'=0 d ..sssUnLock(..%GetParameter("AppName")_InAdj) q RtnObj
	&sql(update dhc_inadj set inad_completed='N' where %id=:InAdj)
	i SQLCODE'=0 d RtnObj.Err(-4,InAdj,"设置完成状态失败","",0)
	i RtnObj.success'=0 d ..sssUnLock(..%GetParameter("AppName")_InAdj) q RtnObj
	q RtnObj
}

/// 库存调整单主表记录Query
/// Author:zhwh
/// Date:2012-07-10
///   d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINAdj","DHCINAdjM","","",^lhtmp(134733311))
Query DHCINAdjM(Params As %String) As Query(ROWSPEC = "RowId,No,loc,AdjLocDesc,AdjDate,AdjTime,user,AdjUserName,chkDate,chkTime,chkUser,chkUserName,scg,scgDesc,Completed,state,chkFlag,stkType,remarks,RpAmt:%Float,SpAmt:%Float,ReasonDesc,AdjDateTime,chkDateTime")
{
}

ClassMethod DHCINAdjMExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")
	s EndDate=PJobj.%Get("EndDate") 
	s pRecLocId=PJobj.%Get("AdjLoc")
	s pCompleteFlag=PJobj.%Get("Complate")
	s pAuditFlag=PJobj.%Get("Audit")
	s user=PJobj.%Get("gUserId")
	s PHVFlag=PJobj.%Get("HVFlag")

	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s sql="select %ID adj,"
	s sql=sql_"inad_NO adjNo,"
	s sql=sql_"inad_ctloc_dr loc,"
	s sql=sql_"inad_ctloc_dr->ctloc_desc locDesc,"
	s sql=sql_"inad_date adjDate,"
	s sql=sql_"inad_time adjTime,"
	s sql=sql_"inad_ssusr_dr adjUser,"
	s sql=sql_"inad_ssusr_dr->ssusr_name userName,"
	s sql=sql_"inad_chkdate chkDate,"
	s sql=sql_"inad_chktime chkTime,"
	s sql=sql_"inad_chkusr_dr chkUser,"
	s sql=sql_"inad_chkusr_dr->ssusr_name chkUserName,"
	s sql=sql_"inad_scg_dr scg,"
	s sql=sql_"inad_scg_dr->scg_desc scgDesc,"
	s sql=sql_"nvl(inad_completed,'N') comp,"
	s sql=sql_"inad_state state,"
	s sql=sql_"nvl(inad_chkflag,'N') chkFlag,"
	s sql=sql_"inad_stktype stkType,"
	s sql=sql_"inad_remarks remarks,"
	s sql=sql_"INAD_ReasonAdj_DR->ADJ_Desc ReasonDesc"
	s sql=sql_" From dhc_inadj "
	s sql=sql_"Where inad_date between "_StartDate_" And "_EndDate
	s xrs=##class(%ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	s err=$$$ISERR(sc)
	i err q $$$OK
	while (xrs.Next())
	{
		s loc=xrs.Data("loc")
		continue:loc'=pRecLocId
		s state=xrs.Data("state")
		s chkFlag=xrs.Data("chkFlag")
		i pAuditFlag'="" continue:chkFlag'=pAuditFlag 
		s Completed=xrs.Data("comp")
		i (pAuditFlag="N")&(pCompleteFlag'="") continue:Completed'=pCompleteFlag

		i pCompleteFlag'="" continue:pCompleteFlag'=Completed
		s RowId=xrs.Data("adj")
		s No=xrs.Data("adjNo")
		s AdjLocDesc=xrs.Data("locDesc")
		s AdjLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(AdjLocDesc)
		s AdjDate=xrs.Data("adjDate")
		s AdjTime=xrs.Data("adjTime")
		s user=xrs.Data("adjUser")
		s AdjUserName=xrs.Data("userName")
		s chkDate=xrs.Data("chkDate")
		s chkTime=xrs.Data("chkTime")
		s chkUser=xrs.Data("chkUser")
		s chkUserName=xrs.Data("chkUserName")
		s scg=xrs.Data("scg")
		s scgDesc=xrs.Data("scgDesc")
		s stkType=xrs.Data("stkType")
		continue:stkType'=..sssCode()
		s remarks=xrs.Data("remarks")
		s ReasonDesc=xrs.Data("ReasonDesc")
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s remarks=$lts(remarks,MemoDelim)
		&sql(select sum(INADI_RPAmt),sum(INADI_SPAmt ) into :RpAmt,:SpAmt from DHC_INAdjItm
		where INADI_INAD_ParRef=:RowId)
		s AdjDate=..DL2H(AdjDate)
		s AdjTime=..TL2H(AdjTime)
		s chkDate=..DL2H(chkDate)
		s chkTime=..TL2H(chkTime)
		s AdjDateTime=AdjDate_" "_AdjTime
		s chkDateTime=chkDate_" "_chkTime
		i Completed="Y" d
		.s Completed="是"
		e  d
		.s Completed="否"
		i chkFlag="Y" d
		.s chkFlag="是"
		e  d
		.s chkFlag="否"
		s IsHVFlag="N"
		s Ch=$o(^DHCINAD(RowId,"ADI",0))
		i Ch'="" d
		.s Inclb=$p($g(^DHCINAD(RowId,"ADI",Ch)),"^",1)
		.s IsHVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(+Inclb)
		CONTINUE:(PHVFlag'="")&&(PHVFlag'=IsHVFlag)
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,No,loc,AdjLocDesc,AdjDate,AdjTime,user,AdjUserName,chkDate,chkTime,chkUser,chkUserName,scg,scgDesc,Completed,state,chkFlag,stkType,remarks,RpAmt,SpAmt,ReasonDesc,AdjDateTime,chkDateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.DHCINAdj).jsSelect()
ClassMethod jsSelect(InAdj As %String) As %String
{
	n (InAdj)
	q:+InAdj=0 "{}"
	s (INADRowId,Remark,INADINSTDR,INADSSUSRDR,INADDate,INAdjNo,INADTime,ForAdjustReasonId,INADState,INADChkDate,INADChkTime,INADChkUSRDR,INADAdjDR,ScgStk,INADCompleted,INADChkFlag,INADStkType,INADCTLOCDR,INADCTLOCDesc,INADSCGDesc,INADSSName,ReasonDesc)=""
	&sql(select INAD_RowId,INAD_Remarks,INAD_INST_DR,INAD_SSUSR_DR,INAD_Date,
		INAD_No,INAD_Time,INAD_ReasonAdj_DR,INAD_State,INAD_ChkDate,
		INAD_ChkTime,INAD_ChkUSR_DR,INAD_Adj_DR,INAD_SCG_DR,INAD_Completed,
		INAD_ChkFlag,INAD_StkType,INAD_CTLOC_DR,INAD_CTLOC_DR->CTLoc_Desc,INAD_SCG_DR->SCG_Desc,
		INAD_SSUSR_DR->SSUSR_Name,INAD_ReasonAdj_DR->ADJ_Desc 
		into
		INADRowId,Remark,INADINSTDR,INADSSUSRDR,INADDate,
		INAdjNo,INADTime,ForAdjustReasonId,INADState,INADChkDate,
		INADChkTime,INADChkUSRDR,INADAdjDR,ScgStk,INADCompleted,
		INADChkFlag,INADStkType,INADCTLOCDR,INADCTLOCDesc,INADSCGDesc,
		INADSSName,ReasonDesc
		from DHC_INAdj where %id=:InAdj
	)
	q:SQLCODE'=0 "{}"
	s Remark=$lts(Remark,..sssMemoDelim())

	s INADDate=..DL2H(INADDate)
	s INADTime=..TL2H(INADTime)
	s INADCTLOCDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(INADCTLOCDesc) 
	s AdjLoc=..sssComboStr(INADCTLOCDR,INADCTLOCDesc)
	s User=..sssComboStr(INADSSUSRDR,INADSSName)
	s ScgStk=..sssComboStr(ScgStk,INADSCGDesc)
	s DataStr=INADRowId_"^"_Remark_"^"_INADINSTDR_"^"_INADSSUSRDR_"^"_INADDate
		_"^"_INAdjNo_"^"_INADTime_"^"_ForAdjustReasonId_"^"_INADState_"^"_INADChkDate
		_"^"_INADChkTime_"^"_INADChkUSRDR_"^"_INADAdjDR_"^"_ScgStk_"^"_INADSCGDesc
		_"^"_INADCompleted_"^"_INADChkFlag_"^"_AdjLoc_"^"_INADCTLOCDesc_"^"_INADSSName
		_"^"_ReasonDesc
	s TitleStr="RowId^Remark^INADINSTDR^User^Date"
		_"^INAdjNo^Time^ForAdjustReasonId^INADState^INADChkDate"
		_"^INADChkTime^INADChkUSRDR^INADAdjDR^ScgStk^Description"
		_"^INADCompleted^INADChkFlag^AdjLoc^INADCTLOCDesc^INADSSName"
		_"^ReasonDesc"

	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q Rtn
}

/// Descript:验证数据是否正确
/// Creater:ZhangDongmei
/// CreateDate: 2012-10-19
/// Input:退货主表id
/// Output:     
/// Return：数据验证通过:0
/// 数据验证不通过:DHC_StkSysErrorRecord rowid
ClassMethod CheckDataValid(adj) As RtnObj
{
	n (adj)
	s RtnObj=##class(RtnObj).%New()
	q:adj="" RtnObj
	s AppCode=..%GetParameter("AppName")
	s KeyValue=$p(^DHCINAD(adj),"^",1)		;单号
	s AdjReasonId=$p(^DHCINAD(adj),"^",6)
	s LocId=$p(^DHCINAD(adj),"^",16)
	q:AdjReasonId="" RtnObj			//盘点调整不判断可用库存
	s ParamStr="^"_LocId_"^^"

	s Loc=$p(^DHCINAD(adj),"^",16)
	q:Loc="" RtnObj.Err(-41,adj,"调整科室不能为空!","",0)
	
	s Type="A"
	s Chl=0
	f  s Chl=$o(^DHCINAD(adj,"ADI",Chl)) q:(Chl="")!(RtnObj.success'=0)  d
	.s Inclb=$P(^DHCINAD(adj,"ADI",Chl),"^",1)
	.s Sp=$P(^DHCINAD(adj,"ADI",Chl),"^",4)
	.s UomId=$P(^DHCINAD(adj,"ADI",Chl),"^",5)
	.s Rp=$P(^DHCINAD(adj,"ADI",Chl),"^",9)
	.s Qty=$P(^DHCINAD(adj,"ADI",Chl),"^",2)
	.s retinfo=##class(web.DHCSTMHUI.Common.UtilCommon).CheckDetail(AppCode,Inclb,Qty,Rp,Sp,UomId,Type)
	.i retinfo'="" d RtnObj.Err(-41,adj,retinfo)
	.q:RtnObj.success'=0
	
	q RtnObj
}

/// Descript:   根据业务类型和业务子表rowid更新高值跟踪明细信息   
/// Return：0：成功，
ClassMethod UpdateBarCodeStatus(Type As %String, Pointer As %String) As %Library.String
{
	n (Type,Pointer)
	s ret=0
	s dhcit=$o(^DHCITD(0,"Type",Type,"Pointer",Pointer,0))
	q:dhcit="" -1
			
	s OldStatus=$p(^DHCIT(dhcit),"^",5)
	i ((Type="A")&&(OldStatus="InAdj")) d
	.s newStatus="Enable"
	&sql(update DHC_ItmTrack set DHCIT_Status=:newStatus where %id=:dhcit)
	i SQLCODE'=0 s ret=-2	
	q ret
}

/// 库存调整单取消审核
/// Author:ZhuoLK
/// Date:2021-11-23
/// Argu：
///    adj - 库存调整记录主表rowid 
///    user - 审核人
/// Return:
///    0 :审核成功
/// w ##class(web.DHCSTMHUI.DHCINAdj).CancelAudit("95","{""RowId"":""95"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2""}")
ClassMethod JsCancelAudit(AdjId As %String, Params As %String) As %String
{
	n (AdjId,Params)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..CancelAudit(AdjId,Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// 库存调整单取消审核
/// w ##class(web.DHCSTMHUI.DHCINAdj).CancelAudit(^tmplh(13),^tmplh(2))
ClassMethod CancelAudit(AdjId As %String, Params As %String) As RtnObj
{
	n (AdjId,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	s user=PJObj.%Get("gUserId")
	s MethodName=$CLASSNAME()_".Audit"
	//加锁
	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_AdjId)<0 q RtnObj.Err(-99,AdjId,MethodName_":加锁失败")
	s Ret=..AllowCancelAudit(AdjId)
	i Ret<0 d ..sssUnLock(..%GetParameter("AppName")_AdjId)
	q:Ret=-3 RtnObj.Err(-3,AdjId,"调整单未审核,不允许取消审核!","",0)
	q:Ret=-4 RtnObj.Err(-4,AdjId,"已经生成月报,不能撤销审核!","",0)
	s ch=0
	f  s ch=$o(^DHCINAD(AdjId,"ADI",ch)) q:(ch="")!(RtnObj.success'=0)  d
	.s adjitm=AdjId_"||"_ch
	.s inclb=$p(^DHCINAD(AdjId,"ADI",ch),"^",1)
	.s qty=$p(^DHCINAD(AdjId,"ADI",ch),"^",2)
	.s trType="A"
	.s Pointer=adjitm
	.s inci=+inclb
	.s dhcit=$o(^DHCITD(0,"Type","A","Pointer",Pointer,0))
	.s:dhcit'="" OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	.s:(dhcit'="")&&(qty>0)&&(OriginalStatus'="NotUnique") Ret=..UpdateCanBarCodeStatus("A",adjitm)
	.i Ret'=0 d ..sssUnLock(..%GetParameter("AppName")_AdjId) s Sc=RtnObj.Err(-5,"","更新高值信息失败") q
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("A",adjitm)
	.i Ret'=0 d ..sssUnLock(..%GetParameter("AppName")_AdjId) s Sc=RtnObj.Err(-6,"","恢复库存失败!") q
	.//更新状态
	.s chk="N"
	.&sql(update dhc_inadj set inad_chkflag=:chk,inad_chkDate=null,inad_chktime=null,INAD_ChkUSR_DR=null,inad_state=:status where %ID=:AdjId )
	.i SQLCODE'=0 d ..sssUnLock(..%GetParameter("AppName")_AdjId) s Sc=RtnObj.Err(-7,AdjId,MethodName_":更新调整主表数据失败") q
	i RtnObj.success'=0 q RtnObj
	s inst=$p(^DHCINAD(AdjId),"^",4)
	i inst'="" d
	.&sql(UPDATE DHC_InStkTk SET INST_AdjustmentComplete='N' WHERE INST_RowId=:inst)
	.i SQLCODE'=0 d ..sssUnLock(..%GetParameter("AppName")_AdjId) s Sc=RtnObj.Err(-8,AdjId,MethodName_":更新盘点主表数据失败") q
	.&sql(UPDATE DHC_InStkTkItm SET INSTI_INADI_DR=null WHERE INSTI_INST_Parref=:inst)
	.i SQLCODE'=0 d ..sssUnLock(..%GetParameter("AppName")_AdjId) s Sc=RtnObj.Err(-9,AdjId,MethodName_":更新盘点子表数据失败") q
	.&sql(delete from dhc_inadj where %ID=:AdjId)
	.i SQLCODE'=0 d ..sssUnLock(..%GetParameter("AppName")_AdjId) s Sc=RtnObj.Err(-10,AdjId,MethodName_":删除调整数据失败") q
	i RtnObj.success'=0 q RtnObj
	d ..sssUnLock(..%GetParameter("AppName")_AdjId)
	q RtnObj
}

ClassMethod AllowCancelAudit(adj As %String) As %String
{
	n (adj)
	s obj=##class(User.DHCINAdj).%OpenId(adj)
	i $$$ISERR(obj) q -1
	d obj.%Reload()
	s auditFlag=obj.INADChkFlag   //flag of audit
	q:auditFlag'="Y" -3  //未审核
	s loc=obj.INADCTLOCDR.%Id()
	s date=obj.INADChkDate
	&sql(select DHCSM_Rowid from DHC_StkMon where DHCSM_CTLOC_DR=:loc and DHCSM_ToDate>=:date)
	q:'SQLCODE -4
	q 0
}

/// Descript:   根据业务类型和业务子表rowid更新高值跟踪明细信息   
/// Return：0：成功，
ClassMethod UpdateCanBarCodeStatus(Type As %String, Pointer As %String) As %Library.String
{
	n (Type,Pointer)
	s ret=0
	s dhcit=$o(^DHCITD(0,"Type",Type,"Pointer",Pointer,0))
	q:dhcit="" -1
	s OldStatus=$p(^DHCIT(dhcit),"^",5)
	i ((Type="A")&&(OldStatus="Enable")) d
	.s newStatus="InAdj"
	&sql(update DHC_ItmTrack set DHCIT_Status=:newStatus where %id=:dhcit)
	i SQLCODE'=0 s ret=-21 q ret
	q ret
}

}
