Import sqluser

Class web.DHCSTMHUI.INStkTk Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTINSTKTKM";

/// Descript:	检索盘点主表明细记录
/// Creator:	lxt
/// CreateDate:	2018-7-06
/// Table:		
/// Input:		盘点数据
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTk","jsDHCSTINStkTk",^templxt("jsDHCSTINStkTk"))
Query jsDHCSTINStkTk(Params As %String) As Query(ROWSPEC = "RowId,InstNo,FreezeDate,FreezeTime,FreezeUserId,FreezeUserName,Status,LocId,LocDesc,CompFlag,StkTkCompFlag,AdjCompFlag,AdjId,ManaFlag,FreezeUomId,IncludeNotUse,OnlyNotUse,NotUseFlag,StkScgId,StkScgDesc,StkCatId,StkCatDesc,FrSbId,FrSbDesc,ToSbId,ToSbDesc,InputType,PrintFlag,MinRp:%Float,MaxRp:%Float,RandomNum:%Float,HVFlag,SumFreezeRpAmt:%Float,SumFreezeSpAmt:%Float,SumCount1SpAmt:%Float,SumCount1RpAmt:%Float,SumVariance1SpAmt:%Float,SumVariance1RpAmt:%Float,ChargeFlag")
{
}

ClassMethod jsDHCSTINStkTkExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s StkType=..sssCode()
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PRowId=PJobj.%Get("RowId")					
	s PStartDate=PJobj.%Get("FStartDate")			//起始日期
	s PEndDate=PJobj.%Get("FEndDate")				//截止日期
	s PLocId=PJobj.%Get("FLoc")						//申请部门 
	s PInstComp=PJobj.%Get("FInstComp")				//InstComp  -帐盘完成
	s PStkTkComp=PJobj.%Get("FStkTkComp")			//StkTkComp - 实盘（汇总）完成
	s PAdjComp=PJobj.%Get("FAdjComp")				//AdjComp - 盘点调整完成
	s FInciId=PJobj.%Get("FInciId")
	s FInciDesc=PJobj.%Get("FInciDesc")
	s FFreezeNonzero=PJobj.%Get("FFreezeNonzero")	//帐盘非零
	s FCountNonzero=PJobj.%Get("FCountNonzero")		//实盘非零
	s FInputFlag=PJobj.%Get("FInputFlag")			//是否实盘录入，实盘汇总时判断
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)

	s sql="select %id RowId,inst_no InstNo,inst_date FreezeDate,inst_time FreezeTime,"
		_"inst_ssusr_dr FreezeUserId,inst_ssusr_dr->ssusr_name FreezeUserName,inst_ctloc_dr LocId,inst_ctloc_dr->ctloc_desc LocDesc,"
		_"inst_status Status,inst_completed CompFlag,inst_stocktakecomplete StkTkCompFlag,inst_adjustmentComplete AdjCompFlag,inst_inad_dr AdjId,"
		_"inst_manaflag ManaFlag,inst_freezeuom FreezeUomId,inst_includenotuse IncludeNotUse,inst_onlynotuse OnlyNotUse,"
		_"inst_scg_dr StkScgId,inst_scg_dr->scg_desc StkScgDesc,inst_incsc_dr StkCatId,inst_incsc_dr->incsc_desc StkCatDesc,"
		_"inst_frstkbin FrSbId,inst_tostkbin ToSbId,INST_HighValueFlag HVFlag,INST_PrintFlag PrintFlag,INST_ChargeFlag ChargeFlag,"
		_"INST_MinRp MinRp,INST_MaxRp MaxRp,INST_RandomNum RandomNum"
		_" from dhc_instktk where INST_StkType='"_StkType_"' "
	i PRowId'="" d
	.s sql=sql_" and %ID="_PRowId
	e  d
	.i PLocId'="" d
	..s sql=sql_" and inst_ctloc_dr in ("_PLocId_")"
	.i (PStartDate'="")&&(PEndDate'="") d
	..s sql=sql_" and inst_date between "_PStartDate_" and "_PEndDate
	.s sql=sql_" order by RowId desc"
	
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s InstNo=xrs.Data("InstNo")
		s FreezeDate=xrs.Data("FreezeDate")
		s FreezeTime=xrs.Data("FreezeTime")
		s FreezeUserId=xrs.Data("FreezeUserId")
		s FreezeUserName=xrs.Data("FreezeUserName")
		s Status=xrs.Data("Status")
		s LocId=xrs.Data("LocId")
		s LocDesc=xrs.Data("LocDesc")
		s CompFlag=xrs.Data("CompFlag")
		s:CompFlag="" CompFlag="N"
		continue:(PInstComp'="")&(CompFlag'=PInstComp)
		s StkTkCompFlag=xrs.Data("StkTkCompFlag")
		s:StkTkCompFlag="" StkTkCompFlag="N"
		continue:(PStkTkComp'="")&(StkTkCompFlag'=PStkTkComp)
		s AdjCompFlag=xrs.Data("AdjCompFlag")
		s:AdjCompFlag="" AdjCompFlag="N"
		continue:(PAdjComp'="")&(AdjCompFlag'=PAdjComp)
		s AdjId=xrs.Data("AdjId")
		s ManaFlag=xrs.Data("ManaFlag")
		s FreezeUomId=xrs.Data("FreezeUomId")
		s IncludeNotUse=xrs.Data("IncludeNotUse")
		s OnlyNotUse=xrs.Data("OnlyNotUse")
		s StkScgId=xrs.Data("StkScgId")
		s StkScgDesc=xrs.Data("StkScgDesc")
		s StkCatId=xrs.Data("StkCatId")
		s StkCatDesc=xrs.Data("StkCatDesc")
		s FrSbId=xrs.Data("FrSbId")
		s (FrSbDesc,ToSbDesc)=""
		i FrSbId'="" s FrSbDesc=$p(^INC("SB",FrSbId),"^",2)
		s ToSbId=xrs.Data("ToSbId")
		i ToSbId'="" s ToSbDesc=$p(^INC("SB",ToSbId),"^",2)
		s InputType=..CheckItmWd(RowId)
		continue:(FInputFlag="Y")&&(InputType="")	//实盘录入
		s PrintFlag=xrs.Data("PrintFlag")
		s MinRp=xrs.Data("MinRp")
		s MaxRp=xrs.Data("MaxRp")
		s RandomNum=xrs.Data("RandomNum")
		s HVFlag=xrs.Data("HVFlag")
		s ChargeFlag=xrs.Data("ChargeFlag")
		
		i FreezeDate'="" s FreezeDate=..DL2H(FreezeDate)
		i FreezeTime'="" s FreezeTime=..TL2H(FreezeTime)
		
		i (IncludeNotUse="Y")&&(OnlyNotUse="Y") s NotUseFlag="是"
		e  i (IncludeNotUse="N")&&(OnlyNotUse="N") s NotUseFlag="否"
		e  s NotUseFlag="全部"
		
		s (SumFreezeRpAmt,SumFreezeSpAmt,SumCount1SpAmt,SumCount1RpAmt,SumVariance1SpAmt,SumVariance1RpAmt)=0
		&sql(SELECT sum(INSTI_FreezeRpAmt),sum(INSTI_FreezeSpAmt),sum(INSTI_Count1SpAmt),sum(INSTI_Count1RpAmt),sum(INSTI_Variance1SpAmt),sum(INSTI_Variance1RpAmt) 
		into:SumFreezeRpAmt,:SumFreezeSpAmt,:SumCount1SpAmt,:SumCount1RpAmt,:SumVariance1SpAmt,:SumVariance1RpAmt FROM DHC_InStkTkItm WHERE INSTI_INST_Parref=:RowId)
		continue:(FFreezeNonzero="Y")&&(SumFreezeRpAmt=0)
		continue:(FCountNonzero="Y")&&(SumCount1RpAmt=0)
		s ExistInciFlag=..CheckInciExist(RowId,FInciId,FInciDesc)
		continue:ExistInciFlag'="Y"
		d OutPurRow1
	}
	Quit $$$OK

OutPurRow1
	s Data=$lb(RowId,InstNo,FreezeDate,FreezeTime,FreezeUserId,FreezeUserName,Status,LocId,LocDesc,
		CompFlag,StkTkCompFlag,AdjCompFlag,AdjId,ManaFlag,FreezeUomId,IncludeNotUse,OnlyNotUse,NotUseFlag,
		StkScgId,StkScgDesc,StkCatId,StkCatDesc,FrSbId,FrSbDesc,ToSbId,ToSbDesc,InputType,PrintFlag,
		MinRp,MaxRp,RandomNum,HVFlag,SumFreezeRpAmt,SumFreezeSpAmt,SumCount1SpAmt,SumCount1RpAmt,
		SumVariance1SpAmt,SumVariance1RpAmt,ChargeFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:	lxt
ClassMethod CheckInciExist(Inst As %String, InciId As %String, InciDesc As %String) As %String
{
	n (Inst,InciId,InciDesc)
	s Flag="N"
	q:(InciId="")&&(InciDesc="") "Y"
	
	s ItmId=""
	i InciId'="" d
	.&sql(select %ID into :ItmId from dhc_instktkitm where INSTI_INST_Parref=:Inst and INSTI_INCI_DR=:InciId)
	e  i InciDesc'="" d
	.s InciDesc=$$ALPHAUP^SSUTIL4(InciDesc)
	.s InciDesc="%"_InciDesc_"%"
	.&sql(select %ID into :ItmId from dhc_instktkitm where INSTI_INST_Parref=:Inst and %ALPHAUP(INSTI_INCI_DR->Inci_desc) like :InciDesc)
	q:ItmId'="" "Y"
	
	q Flag
}

/// Descript:	取一条记录的数据串
/// Creator:	lxt
/// CreateDate:	2018-7-06
/// Table:		
/// Input:		盘点主表记录rowid
/// Return：	
/// w ##class(web.DHCSTMHUI.INStkTk).jsSelect(165)
ClassMethod jsSelect(Inst As %String) As %String
{
	n (Inst)
	q:Inst="" ""
	
	s result=""
	&sql(select INST_No,INST_Date,INST_SSUSR_DR,INST_CTLOC_DR,INST_Status,INST_Time,
		INST_Remarks,INST_Completed,INST_StockTakeComplete,INST_AdjustmentComplete,
		INST_INAD_DR,INST_ManaFlag,INST_FreezeUom,INST_IncludeNotUse,INST_OnlyNotUse,
		INST_SCG_DR,INST_INCSC_DR,INST_FrStkBin,INST_ToStkBin,INST_HighValueFlag,
		INST_MinRp,INST_MaxRp,INST_RandomNum
	into :InstNo,
		:InstDate,:UserId,:SupLocId,:Status,:InstTime,:Remarks,:CompFlag,:StkTkCompFlag,:AdjCompFlag,:AdjId,
		:ManaFlag,:TkUom,:IncludeNotUse,:OnlyNotUse,:StkScgId,:StkCatId,:FrStkBinId,:ToStkBinId,:HVFlag,
		:MinRp,:MaxRp,:RandomNum
	from DHC_InStkTk where %ID=:Inst)
	q:SQLCODE ""
	s (UserName,SupLocDesc,FrStkBinDesc,ToStkBinDesc,StkScgDesc,StkCatDesc)=""
	s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
	s:SupLocId'="" SupLocDesc=$p(^CTLOC(SupLocId),"^",2)
	s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	s:FrStkBinId'="" FrStkBinDesc=$p(^INC("SB",FrStkBinId),"^",2)
	s:ToStkBinId'="" ToStkBinDesc=$p(^INC("SB",ToStkBinId),"^",2)
	s:InstDate'="" InstDate=..DL2H(InstDate)
	s:InstTime'="" InstTime=..TL2H(InstTime)
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()  //备注内容分隔符
	s Remarks=$lts(Remarks,memoDelim)   //备注内容转换为字符串
	s StkScgDesc=$s(StkScgId'="":$p($g(^DHCSCG(StkScgId)),"^",2),1:"")
	s InStkGrpList=..GetInStkGrpList(Inst)
	s InStkGrpId=$p(InStkGrpList,"^",1)
	s InStkGrpDesc=$p(InStkGrpList,"^",2)
	
	s User=..sssComboStr(UserId,UserName)
	s SupLoc=..sssComboStr(SupLocId,SupLocDesc)
	s StkScg=..sssComboStr(StkScgId,StkScgDesc)
	s StkCat=..sssComboStr(StkCatId,StkCatDesc)
	s FrStkBin=..sssComboStr(FrStkBinId,FrStkBinDesc)
	s ToStkBin=..sssComboStr(ToStkBinId,ToStkBinDesc)
	s LocManGrp=..sssComboStr(InStkGrpId,InStkGrpDesc)
	i (IncludeNotUse="Y")&&(OnlyNotUse="Y") s NotUseFlag="Y"
	e  i (IncludeNotUse="N")&&(OnlyNotUse="N") s NotUseFlag="N"
	e  s NotUseFlag=""
	
	s data1=Inst_"^"_InstNo_"^"_InstDate_"^"_InstTime_"^"_User_"^"_UserId_"^"_UserName_"^"_SupLoc_"^"_SupLocId_"^"_SupLocDesc
	s data2=Status_"^"_Remarks_"^"_CompFlag_"^"_StkTkCompFlag_"^"_AdjCompFlag_"^"_AdjId_"^"_ManaFlag_"^"_TkUom_"^"_NotUseFlag
	s data3=IncludeNotUse_"^"_OnlyNotUse_"^"_StkScg_"^"_StkScgId_"^"_StkScgDesc_"^"_StkCat_"^"_StkCatId_"^"_StkCatDesc
	s data4=FrStkBin_"^"_FrStkBinId_"^"_FrStkBinDesc_"^"_ToStkBin_"^"_ToStkBinId_"^"_ToStkBinDesc_"^"_HVFlag
	s data5=MinRp_"^"_MaxRp_"^"_RandomNum_"^"_LocManGrp_"^"_InStkGrpId_"^"_InStkGrpDesc
	s Data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
	s Title1="Inst^InstNo^InstDate^InstTime^User^UserId^UserName^SupLoc^SupLocId^SupLocDesc"
	s Title2="Status^Remarks^CompFlag^StkTkCompFlag^AdjCompFlag^AdjId^ManaFlag^TkUom^NotUseFlag"
	s Title3="IncludeNotUse^OnlyNotUse^StkScg^StkScgId^StkScgDesc^StkCat^StkCatId^StkCatDesc"
	s Title4="FrStkBin^FrStkBinId^FrStkBinDesc^ToStkBin^ToStkBinId^ToStkBinDesc^HVFlag"
	s Title5="MinRp^MaxRp^RandomNum^LocManGrp^InStkGrpId^InStkGrpDesc"
	s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4_"^"_Title5
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Creator:	lxt
ClassMethod GetInStkGrpList(Inst As %String) As %String
{
	n (Inst)
	s InStkGrpIdList="",InStkGrpDescList=""
	q:+Inst=0 InStkGrpIdList_"^"_InStkGrpDescList
	s Ch=0
	
	f  s Ch=$o(^DHCINST(Inst,"TG",Ch)) q:Ch=""  d
	.q:+Ch=0
	.s InStkGrpId=$p(^DHCINST(Inst,"TG",Ch),"^",1)
	.q:+InStkGrpId=0
	.s InStkGrpDesc=$p(^DHCLMG(InStkGrpId),"^",3)
	.i InStkGrpIdList="" d
	..s InStkGrpIdList=InStkGrpId
	..s InStkGrpDescList=InStkGrpDesc
	.e  d
	..s InStkGrpIdList=InStkGrpId_","_InStkGrpIdList
	..s InStkGrpDescList=InStkGrpDesc_","_InStkGrpDescList
	
	q InStkGrpIdList_"^"_InStkGrpDescList
}

/// Descript:	创建盘点单
/// Creator:	lxt
/// CreateDate:	2018-7-06
/// Table:		
/// Input:		盘点数据
/// Return：	
/// w ##class(web.DHCSTMHUI.INStkTk).jsCreateInStktk(^templxt("Main"))
ClassMethod jsCreateInStktk(Main As %String) As %String
{
	n (Main)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	s ManGrpStr=PJObj.%Get("LocManGrp")   //管理组RowId串
	
	ts
	//插入主表
	s RtnObj=..Update(Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	s Inst=RtnObj.rowid
	//插入管理组
	i ManGrpStr'="" d
	.s RtnObj=##class(web.DHCSTMHUI.INStkTkGrp).InsStktkManGrp(Inst,ManGrpStr)
	i RtnObj.success<0 tro  q RtnObj.Json()
	//插入明细
	s RtnObj=..InsInStkTkItm(Inst,Main)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	s RtnObj.rowid=Inst
	tc
	q RtnObj.Json()
}

/// 盘点完成 (js 调用)
/// Creator:	lxt
ClassMethod jsSetComplete(Inst As %String) As %String
{
	n (Inst)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetComplete(Inst)
	q RtnObj.Json()
}

/// 盘点完成
/// Creator:	lxt
/// Date:2018-7-22
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  w ##class(web.DHCSTMHUI.INStkTk).SetComplete()
ClassMethod SetComplete(Inst As %String) As RtnObj
{
	n (Inst)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-101,"","入参错误!","",0)

	s CompleteFlag=$p(^DHCINST(Inst),"^",12)
	i CompleteFlag="Y" q RtnObj.Err(-102,"","已经完成不能重复操作!","",0)

	&sql(update dhc_instktk set INST_Completed='Y' where %ID=:Inst)
	i SQLCODE'=0 q RtnObj.Err(-104,"","操作失败!")
	
	q RtnObj
}

/// 盘点取消完成(js 调用)
/// Creator:	lxt
ClassMethod jsSetUnComplete(Inst As %String) As %String
{
	n (Inst)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetUnComplete(Inst)
	q RtnObj.Json()
}

/// 盘点取消完成
/// Creator:	lxt
/// Date:2018-7-22
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  w ##class(web.DHCSTMHUI.INStkTk).SetUnComplete(81)
ClassMethod SetUnComplete(Inst As %String) As RtnObj
{
	n (Inst)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-101,"","入参错误!","",0)
	
	s CompleteFlag=$p(^DHCINST(Inst),"^",12)
	i CompleteFlag'="Y" q RtnObj.Err(-102,"","未完成单据不能取消完成!","",0)
	
	s StockTakeComplete=$p(^DHCINST(Inst),"^",13) ;实盘完成标志
	i StockTakeComplete="Y" q RtnObj.Err(-103,"","已经实盘完成不能取消完成!","",0)
	
	&sql(update dhc_instktk set INST_Completed='N' where %ID=:Inst)
	i SQLCODE'=0 q RtnObj.Err(-104,"","操作失败!")
	
	q RtnObj
}

/// 删除盘点主表的一条记录(js调用)
/// Creator:	lxt
/// Date:2012-08-01
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  w ##class(web.DHCSTMHUI.INStkTk).Delete(2)
ClassMethod jsDelete(Inst As %String) As %String
{
	n (Inst)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Delete(Inst)
	q RtnObj.Json()
}

/// Creator:	lxt
ClassMethod Delete(Inst As %String) As RtnObj
{
	n (Inst)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-101,"","入参错误!","",0)

	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_Inst)<0 q RtnObj.Err(-102,"","加锁失败!")
	i ..AllowDel(Inst)<0 d ..uLock(..%GetParameter("AppName")_Inst) q RtnObj.Err(-103,"","删除验证失败!")
	&sql(delete from dhc_instktk where %ID=:Inst)
	i SQLCODE'=0 d ..uLock(..%GetParameter("AppName")_Inst) q RtnObj.Err(-104,"","操作失败!")
	
	q RtnObj
}

/// 更新打印标志
/// Creator:	lxt
/// Date:2015-07-30
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  
ClassMethod jsUpPrintFlag(Inst As %String) As %String
{
	n (Inst)
	s PrintFlag="Y"
	&sql(update dhc_instktk set INST_PrintFlag=:PrintFlag where %ID=:Inst)
	q SQLCODE
}

/// =================================前台后端分界线==============================
/// Descript:	插入或更新盘点主表
/// Creator:	lxt
/// CreateDate:	2012-08-01
/// Table:		DHC_InStkTk
/// Input:		盘点数据
/// Return：	
ClassMethod Update(Main As %String) As RtnObj
{
	n (Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-201,"","入参解析失败!")
	
	s FrLoc=PJObj.%Get("SupLoc")
	i FrLoc="" q RtnObj.Err(-202,"","盘点科室不能为空!","",0)
	s HaveInStkFlag=..CheckInStkTkByLoc(FrLoc)
	i HaveInStkFlag="Y" q RtnObj.Err(-206,"","本科室存在未盘点调整的盘点单!","",0)
	s gUserId=PJObj.%Get("gUserId")
	i gUserId="" q RtnObj.Err(-203,"","账盘人不能为空!","",0)
	s UomType=PJObj.%Get("TkUom")				//帐盘单位类型 (0基本单位,1入库单位)
	s Scg=PJObj.%Get("StkScg")					//类组RowId
	s Incsc=PJObj.%Get("StkCat")				//分类RowId
	s ManaFlag=PJObj.%Get("ManaFlag")			//重点关注标志（管理药标志）(""全部，N否，Y是)
	s NotUseFlag=PJObj.%Get("NotUseFlag")		//不可用标志(""全部，N可用，Y不可用)
	s FrStkBin=PJObj.%Get("FrStkBin")			//起始货位号
	s ToStkBin=PJObj.%Get("ToStkBin")			//截止货位号
	s Remarks=PJObj.%Get("Remarks")				//备注
	s HvFlag=PJObj.%Get("HVFlag")				//高值标志（Y高值，N非高值）(0:全部,1:高值,2:低值)
	s ChargeFlag=PJObj.%Get("ChargeFlag")
	s MinRp=PJObj.%Get("MinRp")
	s MaxRp=PJObj.%Get("MaxRp")
	s RandomNum=PJObj.%Get("RandomNum")
	s Supervision=PJObj.%Get("Supervision")
	
	i NotUseFlag="Y" s IncludeNotUse="Y",OnlyNotUse="Y"
	e  i NotUseFlag="N" s IncludeNotUse="N",OnlyNotUse="N"
	e  s IncludeNotUse="Y",OnlyNotUse="N"
	s dd=+$h
	s tt=$p($h,",",2)
	
	s InstNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),Scg,FrLoc)
	i InstNo="" q RtnObj.Err(-204,"","生成盘点单号报错!")
	
	s obj=##class(User.DHCInStkTk).%New()
	s obj.INSTNo=InstNo
	s obj.INSTStkType=..sssCode()
	s obj.INSTDate=dd
	s obj.INSTTime=tt
	s obj.INSTSSUSRDR=##class(User.SSUser).%OpenId(gUserId)
	s obj.INSTCTLOCDR=##class(User.CTLoc).%OpenId(FrLoc)
	s obj.INSTFreezeUom=UomType
	s obj.INSTManaFlag=ManaFlag
	s obj.INSTIncludeNotUse=IncludeNotUse
	s obj.INSTOnlyNotUse=OnlyNotUse
	s obj.INSTINCSCDR=##class(User.INCStkCat).%OpenId(Incsc)
	s obj.INSTSCGDR=##class(User.DHCStkCatGroup).%OpenId(Scg)
	s obj.INSTFrStkBin=FrStkBin
	s obj.INSTToStkBin=ToStkBin
	s obj.INSTHighValueFlag=HvFlag
	s obj.INSTMinRp=MinRp
	s obj.INSTMaxRp=MaxRp
	s obj.INSTRandomNum=RandomNum
	s obj.INSTChargeFlag=ChargeFlag
	s obj.INSTPhcPoison=Supervision
	//备注信息
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	d obj.INSTRemarks.Clear()
	f i=1:1:$l(Remarks,memoDelim) d
	.s rem1=$p(Remarks,memoDelim,i)
	.d obj.INSTRemarks.Insert(rem1)
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-205,"","生成盘点单主表报错!")
	s RtnObj.rowid=obj.%Id()
	q RtnObj
}

/// Descript:	检查科室是否存在未结束的盘点单
/// Creator:	zx
/// CreateDate:	2020-10-22
/// Table:		
/// Input:		LocId
/// Return：Y/N	
/// w ##class(web.DHCSTMHUI.INStkTk).CheckInStkTkByLoc(392)
ClassMethod CheckInStkTkByLoc(LocId As %String) As %String
{
	n (LocId)
	s Flag="N"
	q:+LocId=0 Flag
	s Date=""
	f  s Date=$o(^DHCINST(0,"LOCDATE",LocId,Date)) q:(Date="")||(Flag="Y")  d
	.s Inst=""
	.f  s Inst=$o(^DHCINST(0,"LOCDATE",LocId,Date,Inst)) q:(Inst="")||(Flag="Y")  d
	..q:+Inst=0
	..s INSTStkType=$p(^DHCINST(Inst),"^",34)
	..q:INSTStkType'="M"
	..s AdjFlag=$p(^DHCINST(Inst),"^",14)
	..q:AdjFlag="Y"
	..s Flag="Y"
	q Flag
}

/// Descript:	生成帐盘明细数据
/// Creator:	lxt
/// CreateDate:	2020-07-24
/// Table:		
/// Input:		主单id，主单信息
/// Return：	
ClassMethod InsInStkTkItm(Inst As %String, Main As %String) As RtnObj
{
	n (Inst,Main)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-401,"","入参解析失败!")
	
	s gLocId=PJObj.%Get("gLocId")
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s IfZero=PJObj.%Get("IfZero")
	s obj=##class(User.DHCInStkTk).%OpenId(Inst)
	d obj.%Reload()
	s pLocId=obj.INSTCTLOCDR.%Id()
	s pManaFlag=obj.INSTManaFlag
	s pScgId=$s(obj.INSTSCGDR'="":obj.INSTSCGDR.%Id(),1:"")
	s pIncscId=$s(obj.INSTINCSCDR'="":obj.INSTINCSCDR.%Id(),1:"")
	s pIncludeNotUse=obj.INSTIncludeNotUse
	s pOnlyNotUse=obj.INSTOnlyNotUse
	s pFrStkBinId=obj.INSTFrStkBin
	s pToStkBinId=obj.INSTToStkBin
	s pHVFlag=obj.INSTHighValueFlag
	s pUomType=obj.INSTFreezeUom
	s pMinRp=obj.INSTMinRp
	s pMaxRp=obj.INSTMaxRp
	s pRandomNum=obj.INSTRandomNum
	s pChargeFlag=obj.INSTChargeFlag
	s pSupervision=obj.INSTPhcPoison
	
	s pNotUseFlag=""
	i (pIncludeNotUse="Y")&&(pOnlyNotUse="Y") s pNotUseFlag="Y"
	e  i (pIncludeNotUse="N")&&(pOnlyNotUse="N") s pNotUseFlag="N"
	e  s pNotUseFlag=""
	s HospId=""
	s:pLocId'="" HospId=..sssHospId(pLocId)
	s:HospId="" HospId=gHospId
	s Param=gGroupId_"^"_pLocId_"^"_gUserId_"^"_HospId
	
	s AppName=..%GetParameter("AppName")
	s StkQtyNotZero=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"StkQtyNotZero",Param)	//Y批次数量不为0
	s UseItmTrack=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCITMTRACKM","UseItmTrack",Param)	//Y批次数量不为0
	
	s pManGrpStr=##class(web.DHCSTMHUI.INStkTkGrp).DHCSTInStkTkGrp(Inst)
	s pScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),pLocId,pScgId,HospId)

	s SbRowIdStr=""
	i (pFrStkBinId'="")&&(pToStkBinId'="") d
	.s SbRowIdStr=..GetStkBinScope(pLocId,pFrStkBinId,pToStkBinId)	//盘点项目货位串
	
	s Inclb="",n=0
	f  s Inclb=$o(^DHCINCLB(0,"A","Y",pLocId,Inclb)) q:(Inclb="")!(RtnObj.success'=0)  d	//dhc_incitmlcbt
	.s Incil=$P(Inclb,"||",1,2),InciId=$P(Inclb,"||",1),il=$p(Inclb,"||",2),lb=$p(Inclb,"||",3)
	.q:'$d(^INCI(InciId,"IL",il,"LB",lb))
	.
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.q:(pNotUseFlag'="")&&(pNotUseFlag'=NotUseFlag)	//当盘点不可用物资时，过滤可用物资
	.
	.s ScgStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s ScgId=$p(ScgStr,"^",5)
	.q:("^"_pScgStr_"^")'[("^"_ScgId_"^")
	.
	.s IncscId=$P(^INCI(InciId,2),"^",2)
	.q:(pIncscId'="")&&(IncscId'=pIncscId)
	.s StkType=$p(^INC("SC",IncscId),"^",3)
	.q:StkType'=..sssCode()
	.
	.s ManaFlag="",ManGrp=""
	.s dhcincil=$o(^DHCINCIL(0,"INCIL",Incil,""))
	.i dhcincil'="" d
	..s ManaFlag=$P(^DHCINCIL(dhcincil),"^",9)	//重点关注标志(1-Y,0-N)
	..i ManaFlag=1 s ManaFlag="Y"
	..i ManaFlag=0 s ManaFlag="N"
	..s ManGrp=$P(^DHCINCIL(dhcincil),"^",7)	//管理组
	.q:(pManaFlag'="")&&(pManaFlag'=ManaFlag)
	.q:(pManGrpStr'="")&&(ManGrp'="")&&(pManGrpStr'[("^"_ManGrp_"^"))
	.
	.s Incsb=$p(^INCI(InciId,"IL",il),"^",2)	//货位
	.q:(SbRowIdStr'="")&&((Incsb'=""))&&(SbRowIdStr'[("^"_Incsb_"^"))
	.
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	.q:(pHVFlag'="")&&(pHVFlag'=HVFlag)
	.s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(InciId)
	.q:(pChargeFlag'="")&&(pChargeFlag'=ChargeFlag)
	.s Supervision=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(InciId)
	.q:(pSupervision'="")&&(pSupervision'=Supervision)
	.
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s PUomId=$p(^INCI(InciId,3),"^",6)
	.s UomId=$s(pUomType=0:BUomId,1:PUomId)
	.s Rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	.q:(pMinRp'="")&&(Rp<pMinRp)
	.q:(pMaxRp'="")&&(Rp>pMaxRp)
	.
	.s Qty=$p(^INCI(InciId,"IL",il,"LB",lb),"^",2)
	.
	.s Inactive=0
	.i Qty=0 d
	..s Inactive=..CheckInclbInactive(Inclb,Inst)		//0保持激活状态 1改为未激活
	..i Inactive=1  d
	...s ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateDhcIncItmLcBt(Inclb,"N")
	...i +ret<=0 s Sc=RtnObj.Err(-402,"","更新批次库存项活动状态失败!")
	.q:RtnObj.success'=0
	.q:Inactive=1		;该批次库存项未激活
	.
	.q:(StkQtyNotZero="Y")&&(Qty=0)		;盘点生成数据只要库存不等于0的
	.q:(IfZero="Y")&&(Qty=0) 			;盘点生成数据只要库存不等于0的(页面过滤)
	.s RtnObj=##class(web.DHCSTMHUI.INStkTkItm).Update("",Inst,Inclb,UseItmTrack,HVFlag)
	.q:RtnObj.success'=0
	.s n=n+1
	.
	i n=0 d RtnObj.Err(-403,"","没有符合要求的数据","",0)
	q:RtnObj.success'=0 RtnObj

	i (+pRandomNum>0)&&(pRandomNum<n) d
	.s DelNum=n-pRandomNum
	.s InstiStr=..RandomItm(n,DelNum)
	.f i=1:1:DelNum q:err'=0  d
	..s Chl=$p(InstiStr,",",i)
	..s InstiId=Inst_"||"_Chl
	..&sql(delete from DHC_INStkTkItm where INSTI_RowId=:InstiId)
	..i SQLCODE<0 d RtnObj.Err(-404,"","DHC_INStkTkItm表随机删除数据出错SQLCODE:"_SQLCODE_",MSG:"_%msg)
	..q:RtnObj.success'=0
	
	s RtnObj.rowid=Inst
	q RtnObj
}

/// 盘点实盘完成
/// Author:zhangdongmei
/// Date:2012-09-11
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 - success
///  <0 - failure
///  
ClassMethod SetTkComplete(inst As %String) As %String
{
    n (inst)
    //加锁
    q:inst="" -1
    q:##class(web.DHCSTMHUI.Common.AppCommon).Lock(..%GetParameter("AppName")_inst)<0 -99
    s CompleteFlag=$p(^DHCINST(inst),"^",13)
    i CompleteFlag="Y" d ..uLock(..%GetParameter("AppName")_inst) q -2
    ;
    &sql(update dhc_instktk set INST_StockTakeComplete='Y',INST_Status='E' where %ID=:inst)
    s err=0
    i SQLCODE'=0 s err=-3
    d ..uLock(..%GetParameter("AppName")_inst) 
    q err
}

/// 判断是否允许删除一条盘点主表记录
/// Creator:	lxt
/// Date:2012-08-01
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  0 -  可以删除
///  <0 - 不可以
ClassMethod AllowDel(Inst As %String) As %String
{
	n (Inst)
	q:Inst=""
	s obj=##class(User.DHCInStkTk).%OpenId(Inst)
	d obj.%Reload()
	s comp=obj.INSTCompleted
	i comp="Y" q -3
	s adj=obj.INSTStockTakeComplete
	i adj="Y" q -1
	s adj=obj.INSTAdjustmentComplete
	i adj="Y" q -2
	q 0
}

/// 解锁
ClassMethod uLock(inst As %String)
{
 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(..%GetParameter("AppName")_inst)  
 q
}

/// 判断某一盘点单是否选择了实盘方式（1：分批次：2：按品种）
/// Creator:	lxt
/// Date:2012-09-10
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  "":未选择实盘录入方式, 1：分批次：2：按品种, 3:按高值条码
/// w ##class(web.DHCSTMHUI.INStkTk).CheckItmWd(708)
ClassMethod CheckItmWd(Inst) As %String
{
	n (Inst)
	s Flag=""	;没按批次进行实盘
	
	s HVFlag=$p(^DHCINST(Inst),"^",24)
	q:HVFlag="Y" 3
	&sql(select top 1 %id from dhc_instktkitmtrack where instit_insti_parref->insti_inst_parref=:Inst)
	q:SQLCODE=0 3

	s stp=$o(^DHCINST(Inst,"STP",0))
	q:stp'="" 2

	s chl=0
	f  s chl=$o(^DHCINST(Inst,"STI",chl))  q:(chl="")!(Flag'="")  d
	.s sub=0
	.f  s sub=$o(^DHCINST(Inst,"STI",chl,"STW",sub))  q:(sub="")!(Flag'="")  d
	..s Flag=1
	.
	q Flag
}

/// 取盘点的管理组信息串
/// Author:zhwh
/// Date:2012-08-06
/// Argu:
///  inst -盘点主表rowid
/// Return:
///   管理组信息串
ClassMethod GetManGrpStr(inst As %String) As %String
{
 s tgRs=##class(%ResultSet).%New("web.DHCSTMHUI.INStkTkGrp:DHCSTInStkTkGrp")
 i tgRs="" q "" 
  
 s sc=tgRs.Execute(inst)
 i $$$ISERR(sc) q ""
 s manaGrpStr=""
 while (tgRs.Next())
 {
  s tg=tgRs.Data("lmg")  
  s manaGrpStr= manaGrpStr_"^"_+tg
 }
 i manaGrpStr'="" s manaGrpStr=manaGrpStr_"^"
 q manaGrpStr
}

/// Desc:是否应当包括该库存项目
/// Create BY :zhwh
/// CreateDate:2011-03-29
/// return:
///   1- 包括
///   0 - 不包括
ClassMethod IfInclude(notuseFlag, includeNotUse, onlyNotUse)
{
  n (notuseFlag,includeNotUse,onlyNotUse) 
  s ret=""
  i onlyNotUse="Y" d
  .i notuseFlag="Y" s ret=1
  .e  s ret=0
  q:ret'="" ret
  i includeNotUse="Y" d
  . s ret=1
  e  d
  . i notuseFlag="Y" s ret=0
  . e  s ret=1
  q ret
}

/// 取出起始货位和截止货位之间的所有货位YYY
/// Creator:	lxt
/// Date:2012-08-06
/// Argu:
///  loc - 科室rowid
///  frStkBin- 起始货位名称
///  toStkBin- 截止货位名称
/// Return:
///  货位串
ClassMethod GetStkBinScope(Loc As %String, FrStkBin As %String, ToStkBin As %String) As %String
{
	n (Loc,FrStkBin,ToStkBin)
	s result=""
	
	s code= Loc_"P%"
	s FrStkBinDesc=$p(^INC("SB",FrStkBin),"^",2)
	s ToStkBinDesc=$p(^INC("SB",ToStkBin),"^",2)
	
	&sql(declare sb cursor for 
	 select incsb_rowid From inc_stkbin where incsb_code like :code
	 and incsb_desc between :FrStkBinDesc and :ToStkBinDesc order by incsb_desc)
	&sql(open sb)
	
	f  &sql(fetch sb into :sbRowId) q:SQLCODE  d
	.s result=result_"^"_sbRowId
	&sql(close sb)
	
	i result'="" s result=result_"^"
	
	q result
}

/// 取某药品帐盘批次(实盘录入方式二用)
/// Author:zhangdongmei
/// Date:2012-09-05
/// Argu:
///  Inst - 盘点单rowid
///  Inci- 库存项rowid
/// Return:盘点子表id^批次效期
ClassMethod GetItmFreezeBatch(Inst As %String, Inci As %String) As %String
{
    n (Inst,Inci)
    s ^tmpwfg(101,"GetItmFreezeBatch")=$lb(Inst,Inci)
    q:Inst="" ""
    q:Inci="" ""
    s Count=0
    s Result=""
    s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
    s Chl=0
    f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:Chl=""  d
    .s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
    .q:(+Inclb)'=Inci
    .s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
    .s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
    .s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
    .s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
    .s Insti=Inst_"||"_Chl
    .s:ExpDate'="" ExpDate=..DL2H(ExpDate)
    .s BatExp=BatNo_"~"_ExpDate
    .
    .s Data=Insti_"^"_BatExp_"^"_FreUom
    .d json.InsertRowData(Data)
    .s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
 	q Rtn
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTk","GetItmFreezeBatch","","",)
Query jsGetItmFreezeBatch(Inst As %String, Inci As %String) As Query(ROWSPEC = "Insti, BatNo, ExpDate, FreUom,BatExp") [ SqlProc ]
{
}

ClassMethod jsGetItmFreezeBatchExecute(ByRef qHandle As %Binary, Inst As %String, Inci As %String) As %Status
{
	n (qHandle,Inst,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s ^tmpwfg(101,"GetItmFreezeBatch")=$lb(Inst,Inci)
    q:Inst="" $$$OK
    q:Inci="" $$$OK
    s Chl=0
    f  s Chl=$o(^DHCINST(Inst,"STI",Chl)) q:Chl=""  d
    .s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
    .q:(+Inclb)'=Inci
    .s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
    .s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
    .s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
    .s FreUom=$p(^DHCINST(Inst,"STI",Chl),"^",17)
    .s Insti=Inst_"||"_Chl
    .s:ExpDate'="" ExpDate=..DL2H(ExpDate)
    .s BatExp=BatNo_"~"_ExpDate
    .
    .;s Data=Insti_"^"_BatExp_"^"_FreUom
    .d OutPutGetItmFreezeBatchRow
 Quit $$$OK
OutPutGetItmFreezeBatchRow
 s Data=$lb(Insti,BatNo,ExpDate,FreUom,BatExp)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Description:检查某批次是否可设置为未激活状态（上次盘存为0，且至今盘点未发生过业务）
/// Creator:	lxt
/// Date:2013-01-15
/// Argu:
///  Inclb - 批次id
///  Inst- 本次盘点rowid
/// Return:1：可设置为未激活状态；0：保持激活
ClassMethod CheckInclbInactive(Inclb As %String, Inst As %String) As %String
{
	n (Inclb,Inst)
	q:Inclb="" 0
	q:Inst="" 0

	s StkType=..sssCode()
	s LastInstId="",InclbQty=0
	s InstLoc=$p(^DHCINST(Inst),"^",5)
	s InstDate=$p(^DHCINST(Inst),"^",2)
	s InstDate=InstDate+1
	
	f  s InstDate=$o(^DHCINST(0,"LOCDATE",InstLoc,InstDate),-1) q:(InstDate="")!(LastInstId'="")  d
	.s LastInst=Inst
	.f  s LastInst=$o(^DHCINST(0,"LOCDATE",InstLoc,InstDate,LastInst),-1) q:(LastInst="")!(LastInstId'="")  d
	..s INSTStkType=$p(^DHCINST(LastInst),"^",34)
	..q:INSTStkType'=StkType
	..s AdjCompFlag=$p($g(^DHCINST(LastInst)),"^",14)	;调整完成标志
	..q:AdjCompFlag'="Y"	;该盘点单未进行盘点调整，不是有效的盘点单
	..s AdjDr=$p(^DHCINST(LastInst),"^",15)
	..q:AdjDr=""	;该盘点单未进行盘点调整，不是有效的盘点单
	..s chl=$o(^DHCINST(LastInst,"STI",0,Inclb,""))
	..i chl'=""  d
	...s LastInstId=LastInst
	...s InclbQty=$p(^DHCINST(LastInst,"STI",chl),"^",5)	//实盘数
	q:LastInstId="" 0	;该项目从未盘点过
	
	s LastAdjDr=$p(^DHCINST(LastInstId),"^",15)
	q:LastAdjDr="" 0
	s AdjDate=$p(^DHCINAD(LastAdjDr),"^",8)		;该批次最后一次盘点的调整日期
	s NowQty=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",2)
	s result=0
	i InclbQty=0 d		;上次结存等于0
	.s TrDate=$o(^DHCINTR(0,"INCLB",Inclb,AdjDate))		;该药品调整后的第一笔业务日期
	.i (TrDate="")&&(NowQty=0) s result=1		;上次结存等于0，且至今未发生业务，且当前批次库存为0,设置为未激活
	.
	q result
}

/// 在1至Num间获取Num个整数,逗号隔开
/// Creator:	lxt
ClassMethod RandomItm(Range, Num) As %String [ Private ]
{
	n (Range,Num)
	s Str=""
	while($ll($lfs(Str))<Num)
	{
		s random=$R(Range)+1
		i Str="" d
		.s Str=random
		e  i '$lf($lfs(Str),random) d
		.s Str=Str_","_random
	}
	q Str
}

/// creator: lihui
/// date: 20191227
/// description: 获取高值信息ComboBox 0:All, 1:HighValue, 2:Not HighValue
/// input:  
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INStkTk","GetHVflag",^litmp("GetHVflag"))
Query GetHVflag(HVFlagParams) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetHVflagExecute(ByRef qHandle As %Binary, HVFlagParams) As %Status
{
	n (qHandle,HVFlagParams)
	;s ^litmp("GetHVflag")=HVFlagParams
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s UseItmTrackParam=##class(web.DHCSTMHUI.DHCItmTrack).GetParamProp(HVFlagParams)
	s UseItmTrack=$p(UseItmTrackParam,"^",1)
	i UseItmTrack="Y" d
	.s num=2,count=1
	.f i=1:1:num d
	..s RowId=count
	..i RowId=1 d
	...s Description="是"
	..e  d
	...s Description="否"
	..d OutPutHVflagRow
	..s count=count+1
	e  d
	.s num=3,count=0
	.f i=1:1:num d
	..s RowId=count
	..i RowId=0 d
	...s Description="全部"
	..i RowId=1 d
	...s Description="是"
	..i RowId=2 d
	...s Description="否"
	..d OutPutHVflagRow
	..s count=count+1
    Quit $$$OK
OutPutHVflagRow
 s Data=$lb(RowId,Description)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// w ##class(web.DHCSTMHUI.INStkTk).CheckBeforeInstk("{""LocId"":326}")
/// Creator:	lxt
ClassMethod CheckBeforeInstk(Params) As %String
{
	n (Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PLocId=PJObj.%Get("LocId")
	
	s CheckStr=""
	s EndDate=+$h
	s StartDate=$zdh($p($SYSTEM.SQL.DATEADD("mm",-1,EndDate)," "),3)
	
	s (CheckInitNoStr,CheckIngrtNoStr,CheckInadjNoStr,CheckInscpNoStr,CheckIngrNoStr)=""
	f Date=StartDate:1:EndDate d
	.;出库单frloc
	.s Init=0
	.f  s Init=$o(^DHCINIT(0,"TrfDate",Date,Init)) q:Init=""  d
	..s InitNo=$p(^DHCINIT(Init),"^",1)
	..s FrLoc=$p(^DHCINIT(Init),"^",5)
	..s Status=$p(^DHCINIT(Init),"^",14)
	..s StkType=$p(^DHCINIT(Init),"^",24)
	..q:StkType'=..sssCode()
	..q:(FrLoc'=PLocId)
	..q:(Status=21)||(Status=31)||(Status=99)
	..i CheckInitNoStr="" s CheckInitNoStr=InitNo
	..e  s CheckInitNoStr=CheckInitNoStr_","_InitNo
	.
	.;调整单
	.s Inadj=0
	.f  s Inadj=$o(^DHCINAD(0,"Date",Date,Inadj)) q:Inadj=""  d
	..s type=$p(^DHCINAD(Inadj),"^",15)
	..q:type'=..sssCode()
	..s InadjNo=$p(^DHCINAD(Inadj),"^",1)
	..s AuditFlag=$p(^DHCINAD(Inadj),"^",14)
	..s LocId=$p(^DHCINAD(Inadj),"^",16)
	..q:(LocId'=PLocId)
	..q:AuditFlag="Y"
	..i CheckInadjNoStr="" s CheckInadjNoStr=InadjNo
	..e  s CheckInadjNoStr=CheckInadjNoStr_","_InadjNo
	.
	.;报损单
	.s Inscp=0
	.f  s Inscp=$o(^DHCINSP(0,"Date",Date,Inscp)) q:Inscp=""  d
	..s type=$p(^DHCINSP(Inscp),"^",15)
	..q:type'=..sssCode()
	..s InscpNo=$p(^DHCINSP(Inscp),"^",1)
	..s LocId=$p(^DHCINSP(Inscp),"^",5)
	..s AuditFlag=$p(^DHCINSP(Inscp),"^",14)
	..q:(LocId'=PLocId)
	..q:AuditFlag="Y"
	..i CheckInscpNoStr="" s CheckInscpNoStr=InscpNo
	..e  s CheckInscpNoStr=CheckInscpNoStr_","_InscpNo
	.
	.;退货单
	.s Ingrt=0
	.f  s Ingrt=$o(^INGRT(0,"DATE",Date,Ingrt)) q:Ingrt=""  d
	..s type=$p(^INGRT(Ingrt),"^",16)
	..q:type'=..sssCode()
	..s IngrtNo=$p(^INGRT(Ingrt),"^",1)
	..s LocId=$p(^INGRT(Ingrt),"^",7)
	..s AuditFlag=$p(^INGRT(Ingrt),"^",15)
	..q:(LocId'=PLocId)
	..q:AuditFlag="Y"
	..i CheckIngrtNoStr="" s CheckIngrtNoStr=IngrtNo
	..e  s CheckIngrtNoStr=CheckIngrtNoStr_","_IngrtNo
	.;入库单
	.s Ingr=0
	.f  s Ingr=$o(^DHCINGR(0,"CreateDate",Date,PLocId,Ingr)) q:Ingr=""  d
	..s type=$p(^DHCINGR(Ingr),"^",30)
	..q:type'=..sssCode()
	..s IngrNo=$p(^DHCINGR(Ingr),"^",1)
	..s LocId=$p(^DHCINGR(Ingr),"^",13)
	..s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
	..q:AuditFlag="Y"
	..i CheckIngrNoStr="" s CheckIngrNoStr=IngrNo
	..e  s CheckIngrNoStr=CheckIngrNoStr_","_IngrNo

	i CheckIngrNoStr'="" d RecordCheckStr("存在未审核状态的入库单:"_CheckIngrNoStr)
	i CheckInitNoStr'="" d RecordCheckStr("存在未审核状态的出库单:"_CheckInitNoStr)
	i CheckIngrtNoStr'="" d RecordCheckStr("存在未审核状态的退货单:"_CheckIngrtNoStr)
	i CheckInadjNoStr'="" d RecordCheckStr("存在未审核状态的调整单:"_CheckInadjNoStr)
	i CheckInscpNoStr'="" d RecordCheckStr("存在未审核状态的报损单:"_CheckInscpNoStr)

	q CheckStr
RecordCheckStr(Str)
	q:Str=""
	i CheckStr="" s CheckStr=Str
	e  s CheckStr=CheckStr_";"_Str
	q
}

/// Descript:	插入盘点科室管理组YYY
/// Creator:	lxt
/// CreateDate:	2020-07-24
/// Table:		DHC_InStkTk
/// Input:		账盘单id，管理组串
/// Return：	
ClassMethod InsStktkManGrp(Inst As %String, manGrpStr As %String) As RtnObj
{
	n (Inst,manGrpStr)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-301,"","插入盘点科室管理组时盘点单主表为空!","",0)
	i manGrpStr="" q RtnObj.Err(-302,"","插入盘点科室管理组时管理组为空!","",0)
	
	f i=1:1:$l(manGrpStr,",") q:RtnObj.success'=0  d
	.s manGrp=$p(manGrpStr,",",i)
	.s ch=$O(^DHCINST(Inst,"TG",""),-1)+1
	.&sql(insert into DHC_InStkTkGrp(TG_INST_Parref,TG_Childsub,TG_LMG_DR) values (:Inst,:ch,:ManGrp))
	.i SQLCODE'=0 d RtnObj.Err(-303,"","DHC_InStkTkGrp表插入错误SQLCODE:"_SQLCODE_",msg:"_%msg) 
	
	q RtnObj
}

/// 判断是否存在未调整完成的盘点单
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.INStkTk).CheckExistBeforeInstk(^templxt("CheckExistBeforeInstk"))
ClassMethod CheckExistBeforeInstk(Params) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q "N"

	s FrLoc=PJObj.%Get("SupLoc")
	s Scg=PJObj.%Get("ScgStk")						//类组RowId
	s Incsc=PJObj.%Get("StkCat")					//分类RowId
	s ManaFlag=PJObj.%Get("ManaFlag")			//重点关注标志（管理药标志）(""全部，N否，Y是)
	s NotUseFlag=PJObj.%Get("NotUseFlag")			//不可用标志(""全部，N可用，Y不可用)
	s FrStkBin=PJObj.%Get("StartLocStkBin")			//起始货位号
	s ToStkBin=PJObj.%Get("EndLocStkBin")			//截止货位号
	s HvFlag=PJObj.%Get("HVFlag")					//高值标志（Y高值，N非高值）(0:全部,1:高值,2:低值)
	s MinRp=PJObj.%Get("MinRp")
	s MaxRp=PJObj.%Get("MaxRp")

	s StkBinStr=""
	i (FrStkBin'="")&&(ToStkBin'="")  d
	.s StkBinStr=..GetStkBinScope(FrLoc,FrStkBin,ToStkBin)
	
	i NotUseFlag'="N" s IncludeNotUse="Y"
	e  s IncludeNotUse="N"
	s dd=+$h+1
	
	s ExistFlag="N"
	f  s dd=$o(^DHCINST(0,"LOCDATE",FrLoc,dd),-1) q:(dd="")||(ExistFlag="Y")  d
	.s RowId=""
	.s bb=$o(^DHCINST(0,"LOCDATE",FrLoc,dd,RowId),-1)
	.f  s RowId=$o(^DHCINST(0,"LOCDATE",FrLoc,dd,RowId),-1) q:(RowId="")||(ExistFlag="Y")  d
	..s obj=##class(User.DHCInStkTk).%OpenId(RowId)
	..s AdjCompFlag=obj.INSTAdjustmentComplete
	..q:(AdjCompFlag="Y")
	..s pManaFlag=obj.INSTManaFlag
	..s pScgId=$s(obj.INSTSCGDR'="":obj.INSTSCGDR.%Id(),1:"")
	..s pIncscId=$s(obj.INSTINCSCDR'="":obj.INSTINCSCDR.%Id(),1:"")
	..s pIncludeNotUse=obj.INSTIncludeNotUse
	..s pOnlyNotUse=obj.INSTOnlyNotUse
	..s pFrStkBinId=obj.INSTFrStkBin
	..s pToStkBinId=obj.INSTToStkBin
	..s pHVFlag=obj.INSTHighValueFlag
	..s pMinRp=obj.INSTMinRp
	..s pMaxRp=obj.INSTMaxRp
	..s pINSTNo=obj.INSTNo
	..i (pManaFlag="")||(ManaFlag="")||(pManaFlag=ManaFlag) d
	...i (pScgId="")||(Scg="")||(pScgId=Scg) d
	....i (pIncscId="")||(Incsc="")||(pIncscId=Incsc) d
	.....i (pOnlyNotUse="")||(NotUseFlag="")||(pOnlyNotUse=NotUseFlag) d
	......i (pHVFlag="")||(HvFlag="")||(pHVFlag=HvFlag) d
	.......i (StkBinStr'="") d
	........s pStkBinStr=..GetStkBinScope(FrLoc,pFrStkBinId,pToStkBinId)   //^1^
	........s len=$l(pStkBinStr,"^")
	........f i=1:1:len d
	.........s tmpStkBin=$p(pStkBinStr,"^",i)
	.........q:tmpStkBin=""
	.........i ("^"_tmpStkBin_"^")[StkBinStr s ExistFlag="Y"
	.......e  d
	........s ExistFlag="Y"
	
	i ExistFlag="Y" q pINSTNo
	
	q ExistFlag
}

/// 盘点期间是否允许发生业务
/// 返回值：Y-不允许、N-允许
/// w ##class(web.DHCSTMHUI.INStkTk).NoAllowBusinessNoCompleteInstk("G",84,2)
ClassMethod NoAllowBusinessNoCompleteInstk(Type As %String, Pointer As %String, HospId As %String = "") As %String
{
	n (Type,Pointer,HospId)
	q:(Type="")||(Pointer="") "N"
	s RtnFlag="N"
	s LocId=""
	i Type="G" d   ;入库时
	.q:'$d(^DHCINGR(+Pointer))
	.s LocId=$p(^DHCINGR(+Pointer),"^",13)
	i Type="R" d   
	.q:'$d(INGRT(+Pointer))
	.s LocId=$p(^INGRT(+Pointer),"^",7)
	
	i Type="T" d
	.s LocId=$p(^DHCINIT(+Pointer),"^",5) 
	i Type="K" d 
	.q:'$d(^DHCINIT(+Pointer))  
	.s LocId=$p(^DHCINIT(+Pointer),"^",6) 
	i (Type="P")||(Type="F")||(Type="MP")||(Type="MF") d
	.s Oeori=Pointer
	.s Oeord=$p(Oeori,"||",1),OeoriCh=$p(Oeori,"||",2)
	.q:(Oeord="")||(OeoriCh="")||'$d(^OEORD(Oeord,"I",OeoriCh)) 
	.s Param="^^^"_HospId
	.s AppName=##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName")
	.s RecAdmLocParam=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"RecAdmLoc",Param)
	.i RecAdmLocParam=1 d
	..s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,9),"^",2)		;OEORI_AdmLoc_DR 病人就诊科室(就诊病房)
	.e  i RecAdmLocParam=2  d
	..s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,7),"^",2)		;OEORI_UserDepartment_DR 医嘱录入科室
	.e  i RecAdmLocParam=3  d
	..s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,1),"^",3)		;OEORI_OrdDept_DR 下医嘱科室(医生科室?)
	.e  d
	..s InitRecLocId=$p(^OEORD(Oeord,"I",OeoriCh,3),"^",6)		;OEORI_RecDep_DR 医嘱接收科室
	i (Type="Y")||(Type="H")||(Type="MY")||(Type="MH") d 
	.s Oeori=Pointer
	.s Oeord=$p(Oeori,"||",1),OeoriCh=$p(Oeori,"||",2)
	.q:(Oeord="")||(OeoriCh="")||'$d(^OEORD(Oeord,"I",OeoriCh))  
	.s LocId=$p($g(^OEORD(Oeord,"I",$p(OeoriCh,"||",2),3)),"^",6)
	i Type="D" d  ;报损时
	.s LocId=$p(^DHCINSP(+Pointer),"^",5)
	s IfExistInStkTk=##class(web.DHCSTMHUI.INStkTk).CheckInStkTkByLoc(LocId)
	s:HospId="" HospId=..sssHospId(LocId)
	s Param="^"_LocId_"^^"_HospId
	s AllowBusiness=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTINSTKTKM","AllowBusiness",Param)
	i (AllowBusiness="N")&&(IfExistInStkTk="Y") s RtnFlag="Y"
	q RtnFlag
}

}
