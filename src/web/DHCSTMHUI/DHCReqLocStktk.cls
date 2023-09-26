Import sqluser

/// Description:	盘点单相关(申请科室使用)
/// CreateDate:		2017-06-07 lihui
Class web.DHCSTMHUI.DHCReqLocStktk Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTSUBLOCSTKTKM";

/// Descript:	申请科室生成盘点单
/// Creator:	
/// CreateDate:	2017-06-07
/// Input:		StrParam(盘点科室^UserId^Scg^Incsc)
/// Output:     
/// Return：	"":保存正确, -11:保存主表失败, -12:保存子表失败, -13:没有明细
/// /w ##class("web.DHCSTMHUI.DHCReqLocStktk").Create("8^541^^")
ClassMethod Create(StrParam As %String) As %String
{
	n (StrParam)
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..CreateStkTk(StrParam)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	s SubStkTkId=RtnObj.rowid
	s RtnObj=..CreateStkTkItm(SubStkTkId,StrParam)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=SubStkTkId
	q RtnObj.Json()
}

/// Descript:	生成二级库盘点主表信息
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		StrParam(盘点科室^库房id^UserId^Scg^Incsc)
/// Output:     
/// Return：	"":保存正确, 非空:错误信息
ClassMethod CreateStkTk(StrParam As %String) As RtnObj
{
	n (StrParam)
 	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	s Sc=PJObj.%FromJSON(StrParam)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s StkTkLoc=PJObj.%Get("StkLoc")
	s CheckStkIfOver=..CheckStkIfOver(StkTkLoc)
	s Flag=$p(CheckStkIfOver,"^",1)
	s UnFinishedStkid=$p(CheckStkIfOver,"^",2)
	s UnFinishedStkNo=$s(UnFinishedStkid'="":$p(^DHCSLST(UnFinishedStkid),"^",1),1:"")
	q:Flag="Y" RtnObj.Err(-1,"","存在未盘点结束的单据:"_UnFinishedStkNo)
	s UserId=PJObj.%Get("gUserId")
	s Scg=PJObj.%Get("ScgStk")
	s Incsc=PJObj.%Get("StkCat")
	s Supervision=PJObj.%Get("Supervision")
	
	s obj=##class(User.DHCSubLocStkTk).%New()
	s AppName=..%GetParameter("AppName")
	s SubSTNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,Scg,StkTkLoc)
	q:SubSTNo="" RtnObj.Err(-1,"","生成单号失败!")
	s obj.SUBSTNo=SubSTNo
	s obj.SUBSTCreateDate=+$h
	s obj.SUBSTCreateTime=$p($h,",",2)
	s obj.SUBSTSupervision=Supervision
	d obj.SUBSTCreateUserDRSetObjectId(UserId)
	d obj.SUBSTCreateLocDRSetObjectId(StkTkLoc)
	d obj.SUBSTCTLocDRSetObjectId(StkTkLoc)
	d obj.SUBSTSCGDRSetObjectId(Scg)
	d obj.SUBSTINCSCDRSetObjectId(Incsc)
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-1,"","保存失败!")
	s RowId=obj.%Id()
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	插入DHC_SubLocStkTkItm明细
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		主表rowid, StrParam(盘点科室^UserId^Scg^Incsc)
/// Output:     
/// Return：	>0:保存成功, <0:有明细处理失败, 0:没有明细
ClassMethod CreateStkTkItm(RowId As %String, StrParam As %String) As RtnObj
{
	n (RowId,StrParam)
	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	s Sc=PJObj.%FromJSON(StrParam)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s StkTkLoc=PJObj.%Get("StkLoc")
	s UserId=PJObj.%Get("gUserId")
	s ScgStr=PJObj.%Get("ScgStk")
	s Incsc=PJObj.%Get("StkCat")
	s gHospId=PJObj.%Get("gHospId")
	s Supervision=PJObj.%Get("Supervision")
	s HospId=..sssHospId(StkTkLoc)
	s:HospId="" HospId=gHospId
	q:RowId="" RtnObj.Err(-1,"","主表ID为空","",0)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),StkTkLoc,ScgStr,HospId)  ;根据盘点科室授权类组lihui
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",StkTkLoc,Inci)) q:(Inci="")||(RtnObj.success'=0)  d
	.s il=$o(^INCI("IL_LOC",StkTkLoc,Inci,0))
	.q:il=""
	.s Incil=Inci_"||"_il
	.s lb=$o(^INCI(Inci,"IL",il,"LB",""))
	.q:lb=""
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s StkType=$p(ScgInfo,"^",3)
	.q:StkType'=..sssCode()
	.s ScgId=$p(ScgInfo,"^",5)
	.q:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_ScgId_"^"))
	.s IncscId=$p(^INCI(Inci,2),"^",2)
	.q:(Incsc'="")&&(IncscId'=Incsc)
	.s highflag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.q:highflag="Y"
	.s supervision=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(Inci)
	.q:(Supervision'="")&&(Supervision'=supervision)
	.s FreezeQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,StkTkLoc,+$h)
	.s ch=1+$o(^DHCSLST(RowId,"I",""),-1)
	.s RpAmt=##class(web.DHCSTMHUI.Common.PriceCommon).GetRpAmt(Incil,+$h,HospId)
	.s SpAmt=##class(web.DHCSTMHUI.Common.PriceCommon).GetSpAmt(Incil,+$h,HospId)
	.&sql(insert into DHC_SubLocStkTkItm
		(SUBSTI_SUBST_Parref,SUBSTI_Childsub,SUBSTI_INCIL_DR,SUBSTI_FreezeQty,SUBSTI_CountQty,
		SUBSTI_CTUOM_DR,SUBSTI_RpAmt,SUBSTI_SpAmt)
		values
		(:RowId,:ch,:Incil,:FreezeQty,null,
		:PUom,:RpAmt,:SpAmt))
	.i SQLCODE'=0   d RtnObj.Err(-1,"","插入数据失败!")
	q RtnObj
}

/// Descript:	将盘点单设置为完成状态
/// Creator:	wangjiabin
/// CreateDate:	2015-10-19
/// Input:		主表rowid
/// Output:     
/// Return：	"0":成功, 其他:错误
ClassMethod Complete(RowId As %String) As %String
{
	n (RowId)
	s Rtnobj=##class(RtnObj).%New()
	i RowId="" d Rtnobj.Err(-1,"","ID不能为空!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s AdjCompleted=$p(^DHCSLST(RowId),"^",12)
	i AdjCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经调整完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s CountCompleted=$p(^DHCSLST(RowId),"^",11)
	i CountCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经实盘完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Completed=$p(^DHCSLST(RowId),"^",9)
	i Completed="Y" d Rtnobj.Err(-1,"","该盘点单已经完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Comp="Y"
	&sql(update DHC_SubLocStkTk set SUBST_Completed=:Comp where SUBST_RowId=:RowId)
	i SQLCODE'=0  d Rtnobj.Err(-1,"","操作失败!")
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Rtnobj.rowid=RowId
	q Rtnobj.Json()
}

/// Descript:	取消完成盘点单
/// Creator:	wangjiabin
/// CreateDate:	2015-10-19
/// Input:		主表rowid
/// Output:     
/// Return：	"0":成功, 其他:错误
ClassMethod CancelComplete(RowId As %String) As %String
{
	n (RowId)
	s Rtnobj=##class(RtnObj).%New()
	i RowId="" d Rtnobj.Err(-1,"","ID不能为空!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	
	s Completed=$p(^DHCSLST(RowId),"^",9)
	i Completed'="Y" d Rtnobj.Err(-1,"","该盘点单尚未完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s CountCompleted=$p(^DHCSLST(RowId),"^",11)
	i CountCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经实盘完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s AdjCompleted=$p(^DHCSLST(RowId),"^",12)
	i AdjCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经调整完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	
	s Comp="N"
	&sql(update DHC_SubLocStkTk set SUBST_Completed=:Comp where SUBST_RowId=:RowId)
	i SQLCODE'=0  d Rtnobj.Err(-1,"","操作失败!")
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Rtnobj.rowid=RowId
	q Rtnobj.Json()
}

/// Descript:	将盘点单设置为实盘完成状态
/// Creator:	wangjiabin
/// CreateDate:	2015-10-19
/// Input:		主表rowid
/// Output:     
/// Return：	"0":成功, 其他:错误
ClassMethod CountComplete(RowId As %String) As %String
{
	n (RowId)
	s Rtnobj=##class(RtnObj).%New()
	i RowId="" d Rtnobj.Err(-1,"","ID不能为空!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	
	s Completed=$p(^DHCSLST(RowId),"^",9)
	i Completed'="Y" d Rtnobj.Err(-1,"","该盘点单尚未完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s CountCompleted=$p(^DHCSLST(RowId),"^",11)
	i CountCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经实盘完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s AdjCompleted=$p(^DHCSLST(RowId),"^",12)
	i AdjCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经调整完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s CheckFlag=##class("web.DHCSTMHUI.DHCReqLocStktk").CheckCountComplete(RowId)
	i CheckFlag'="" d Rtnobj.Err(-1,"","该盘点单存在明细未保存实盘数!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	
	s Comp="Y"
	&sql(update DHC_SubLocStkTk set SUBST_CountCompleted=:Comp where SUBST_RowId=:RowId)
	i SQLCODE'=0  d Rtnobj.Err(-1,"","操作失败!")
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Rtnobj.rowid=RowId
	q Rtnobj.Json()
}

/// Descript:	实盘完成前判断实盘数是否全部录入
/// Creator:	wangjiabin
/// CreateDate:	2020-03-7
/// Input:		主表rowid
/// Output:     
/// Return：	"":全部录入结束, 其他:没有全部录入
/// w ##class("web.DHCSTMHUI.DHCReqLocStktk").CheckCountComplete(8)
ClassMethod CheckCountComplete(RowId As %String) As %String
{
	n (RowId)
	s Ret=""
	q:+RowId=0 Ret
	s Ch=0
	f  s Ch=$o(^DHCSLST(RowId,"I",Ch)) q:((Ch="")||(Ret'=""))  d
	.q:+Ch=0
	.s CountQty=$p(^DHCSLST(RowId,"I",Ch),"^",3)
	.s SubStiRowId=RowId_"||"_Ch
	.s:CountQty="" Ret=SubStiRowId
	q Ret
}

/// Descript:	取消实盘完成
/// Creator:	wangjiabin
/// CreateDate:	2015-10-19
/// Input:		主表rowid
/// Output:     
/// Return：	"0":成功, 其他:错误
ClassMethod CountCancelComplete(RowId As %String) As %String
{
	n (RowId)
	s Rtnobj=##class(RtnObj).%New()
	i RowId="" d Rtnobj.Err(-1,"","ID不能为空!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	
	s Completed=$p(^DHCSLST(RowId),"^",9)
	i Completed'="Y" d Rtnobj.Err(-1,"","该盘点单尚未完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s CountCompleted=$p(^DHCSLST(RowId),"^",11)
	i CountCompleted'="Y" d Rtnobj.Err(-1,"","该盘点单尚未实盘完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s AdjCompleted=$p(^DHCSLST(RowId),"^",12)
	i AdjCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经调整完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	
	s Comp="N"
	&sql(update DHC_SubLocStkTk set SUBST_CountCompleted=:Comp where SUBST_RowId=:RowId)
	i SQLCODE'=0  d Rtnobj.Err(-1,"","操作失败!")
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Rtnobj.rowid=RowId	
	q Rtnobj.Json()
}

/// Descript:	保存明细信息(盘点数量等)
/// Creator:	wangjiabin
/// CreateDate:	2015-10-15
/// Input:		子表rowid^实盘数量^备注_$c(1)_...
/// Output:w ##class(web.DHCSTMHUI.DHCReqLocStktk).SaveStkTkItm(^tmpxu)
ClassMethod SaveStkTkItm(ListData As %String) As %String
{
	n (ListData)
   	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s CountQty=Obj.%Get("CountQty")
		s Remarks=Obj.%Get("Remarks")
		s Incil=$p(^DHCSLST(+RowId,"I",$p(RowId,"||",2)),"^",1)
		s Inci=+Incil
		s InciDesc=$p(^INCI(Inci,1),"^",2)
		s BUomId=$p(^INCI(Inci,1),"^",10)
		s PUomId=$p(^INCI(Inci,3),"^",6)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
		s CountQtyBUom=CountQty*UomFac
		&sql(update DHC_SubLocStkTkItm set SUBSTI_CountQty=:CountQtyBUom, SUBSTI_Remarks=:Remarks
			where SUBSTI_RowId=:RowId)
		i SQLCODE'=0 d
		.d RtnObj.Err(-1,"","插入失败!")
	}
	s RtnObj.rowid=+RowId
	q RtnObj.Json()
}

/// Descript:	生成调整单
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		主表rowid
/// Output:     
/// Return:		调整表rowid:成功, -11:调整失败
/// w ##class(web.DHCSTMHUI.DHCReqLocStktk).AdjStktk(^zx("Params"))
ClassMethod AdjStktk(Params) As %String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..CreateInadj(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()		;调整失败
	tc
	q RtnObj.Json()
}

/// Descript:	生成调整单
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		主表rowid
/// Output:     
/// Return：
/// w ##class(web.DHCSTMHUI.DHCReqLocStktk).CreateInadj(23,541)
ClassMethod CreateInadj(Params) As RtnObj [ Private ]
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s RowId=PJObj.%Get("RowId")
	s UserId=PJObj.%Get("gUserId")
	q:RowId="" RtnObj.Err(-1,"","ID不能为空!","",0)
	s AdjComplete=$p(^DHCSLST(RowId),"^",12)
	q:AdjComplete="Y" RtnObj.Err(-1,"","该单据已调整完成!","",0)
	s obj=##class(User.DHCSubLocStkTk).%OpenId(RowId)
	s adjLoc=obj.SUBSTCTLocDR.%Id()				//1 
	s adjReason=""								//3
	s adjScg=obj.SUBSTSCGDR
	i $IsObject(adjScg) s adjScg=adjScg.%Id()	//4
	s adjStkType=..sssCode()					//5
	s adjInst=""								//6	 此字段暂不处理
	s adjComp="Y"								//7  -自动设置为"完成"状态
	s adjState="11"								//8
	s remark="便易盘点调整"						//9
	s Data=adjLoc_"^"_UserId_"^"_adjReason_"^"_adjScg_"^"_adjStkType_"^"_adjInst_"^"_adjComp_"^"_adjState_"^"_remark
	s Title="AdjLoc^gUserId^ForAdjustReasonId^ScgStk^StkType^adjInst^Complate^adjState^Remark"
	s JData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Update(JData)
	i RtnObj.success'=0 q RtnObj
	s adj=RtnObj.rowid
	s HospId=..sssHospId(adjLoc)
	s ch=0
	f  s ch=$o(^DHCSLST(RowId,"I",ch)) q:(ch="")||(RtnObj.success'=0)  d
	.s SubST=RowId_"||"_ch
	.s Incil=$p(^DHCSLST(RowId,"I",ch),"^",1)
	.s FreezeQty=+$p(^DHCSLST(RowId,"I",ch),"^",2)
	.s CountQty=$p(^DHCSLST(RowId,"I",ch),"^",3)
	.q:CountQty=""			;实盘数量为空的过滤
	.s Inci=+Incil,IL=$p(Incil,"||",2)
	.q:Inci=""
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s PUomId=$p(^INCI(Inci,3),"^",6)
	.s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	.
	.s DiffQty=(CountQty-FreezeQty) ;
	.s DiffQtyPUom=DiffQty/UomFac
	.q:DiffQtyPUom=0		;差额为0的过滤
	.i DiffQtyPUom>0 d
	..;将盘盈的部分添加到最新的批次上去
	..;desc排序
	..&sql(DECLARE CurExpDesc CURSOR FOR
		SELECT INCLB_ROWID FROM INC_ITMLCBT 
		WHERE INCLB_INCIL_PARREF=:Incil order by INCLB_INCIB_DR->INCIB_EXPDATE desc)
	..&sql(open CurExpDesc)
	..&sql(fetch CurExpDesc into :Inclb)		;取第一条
	..s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId,"")
	..s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,BUomId,HospId)
	..;s rpAmt=rp*DiffQtyPUom
	..;s spAmt=sp*DiffQtyPUom
	..s rpAmt=rp*DiffQty
	..s spAmt=sp*DiffQty
	..s insti=""
	..s Data=Inclb_"^"_DiffQty_"^"_BUomId_"^"_rp_"^"_sp_"^"_insti
	..s Title="Inclb^Qty^UomId^Rp^Sp^insti"
	..s JData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	..s RtnObj=##class(web.DHCSTMHUI.DHCINAdjItm).Update(adj,JData)
	..q:RtnObj.success'=0
	..&sql(close CurExpDesc)
	.e  d
	..;将盘亏的部分,自效期较早的批次去除
	..;asc排序
	..;s tmpDiffQty=-DiffQtyPUom			;取正数
	..s tmpDiffQty=-DiffQty			;取正数  应该取小单位的数量
	..s isOK=0
	..
	..s InadiStr=""						;dhc_inadjitm rowidStr
	..&sql(DECLARE CurExpAsc CURSOR FOR
		SELECT INCLB_ROWID,INCLB_PhyQty,nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
		WHERE INCLB_INCIL_PARREF=:Incil order by INCLB_INCIB_DR->INCIB_EXPDATE)
	..&sql(open CurExpAsc)
	..f  &sql(fetch CurExpAsc into :Inclb,:InclbQty,:InclbDirtyQty) q:SQLCODE||isOK||(RtnObj.success<0)  d
	...s InclbAvaQty=InclbQty-InclbDirtyQty		;2015-10-16 这里用可用库存还是逻辑库存?
	...;s InclbAvaQty=InclbQty
	...q:+InclbAvaQty=0				; =0是没有调整的必要
	...s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId,"")
	...s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,BUomId,HospId)
	...s adjQty=""
	...i tmpDiffQty<=InclbAvaQty d
	....;调整-tmpDiffQty,退出
	....s adjQty=-tmpDiffQty
	....s isOK=1	;设置退出条件
	...e  i InclbAvaQty>0 d
	....;调整-InclbAvaQty,tmpDiffQty=tmpDiffQty-InclbAvaQty
	....s adjQty=-InclbAvaQty
	....s tmpDiffQty=tmpDiffQty-InclbAvaQty
	...q:+adjQty=0
	...s rpAmt=rp*adjQty
	...s spAmt=sp*adjQty
	...s insti=""
	...s adiData=Inclb_"^"_adjQty_"^"_BUomId_"^"_rp_"^"_sp_"^"_insti
	...s Title="Inclb^Qty^UomId^Rp^Sp^insti"
	...s JData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(adiData,Title)
	...s RtnObj=##class(web.DHCSTMHUI.DHCINAdjItm).Update(adj,JData)
	...q:RtnObj.success'=0
	...s adi=RtnObj.rowid
	...i InadiStr="" d
	....s InadiStr=adi
	...e  d
	....s InadiStr=InadiStr_","_adi
	..&sql(close CurExpAsc)
	.q:RtnObj.success'=0
	.&sql(update DHC_SubLocStkTkItm set SUBSTI_INADIStr=:InadiStr where SUBSTI_RowId=:SubST)
	.
	
	q:RtnObj.success'=0 RtnObj
	s Data=UserId
	s Title="gUserId"
	s JData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	//库存调整单审核
	s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Audit(adj,JData)
	i RtnObj.success'=0 q RtnObj
	
	;这里记录adj_dr,AdjCompleted
	s Comp="Y"
	&sql(update DHC_SubLocStkTk set SUBST_INAD_DR=:adj,SUBST_AdjCompleted=:Comp where SUBST_RowId=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-1,"","更新状态失败!")
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	删除主表信息
/// Creator:	wangjiabin
/// CreateDate:	2015-10-19
/// Input:		主表rowid
/// Output:     
/// Return：	"0":成功, 其他:失败
ClassMethod Delete(RowId As %String) As %String
{
	n (RowId)
	s Rtnobj=##class(RtnObj).%New()
	i RowId="" d Rtnobj.Err(-1,"","ID不能为空!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s AdjCompleted=$p(^DHCSLST(RowId),"^",12)
	i AdjCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经调整完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s CountCompleted=$p(^DHCSLST(RowId),"^",11)
	i CountCompleted="Y" d Rtnobj.Err(-1,"","该盘点单已经实盘完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Completed=$p(^DHCSLST(RowId),"^",9)
	i Completed="Y" d Rtnobj.Err(-1,"","该盘点单已经完成!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	&sql(delete from DHC_SubLocStkTk where SUBST_RowId=:RowId)
	i SQLCODE'=0  d Rtnobj.Err(-1,"","删除失败!")
	i Rtnobj.success'=0  q Rtnobj.Json()
	q Rtnobj.Json()
}

/// Descript:	获取主表信息
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		主表rowid
/// Output:     
/// Return：w ##class(web.DHCSTMHUI.DHCReqLocStktk).Select(RowId)	
ClassMethod Select(RowId As %String) As %String
{
	n (RowId)
	s SubSTNo=$p(^DHCSLST(RowId),"^",1)
	s CreateDate=$p(^DHCSLST(RowId),"^",2)
	s:CreateDate'="" CreateDate=..DL2H(CreateDate)
	s CreateTime=$p(^DHCSLST(RowId),"^",3)
	s:CreateTime'="" CreateTime=..TL2H(CreateTime)
	s CreateUser=$p(^DHCSLST(RowId),"^",4)
	s CreateLocId=$p(^DHCSLST(RowId),"^",5)
	s CreateLoc=$s(CreateLocId'="":$p($g(^CTLOC(CreateLocId)),"^",2),1:"")
	s CreateLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(CreateLoc)
	s StkTkLocId=$p(^DHCSLST(RowId),"^",6)
	s StkTkLoc=$s(StkTkLocId'="":$p($g(^CTLOC(StkTkLocId)),"^",2),1:"")
	s StkTkLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(StkTkLoc)
	s ScgId=$p(^DHCSLST(RowId),"^",7)
	s ScgDesc=$s(ScgId'="":$p(^DHCSCG(ScgId),"^",2),1:"")
	s Incsc=$p(^DHCSLST(RowId),"^",8)
	s IncscDesc=$s(Incsc'="":$p(^INC("SC",Incsc),"^",2),1:"")
	s Completed=$p(^DHCSLST(RowId),"^",9)
	s CountCompleted=$p(^DHCSLST(RowId),"^",11)
	s AdjCompleted=$p(^DHCSLST(RowId),"^",12)
	s Supervision=$p(^DHCSLST(RowId),"^",13)
	s StkTkLocInfo=..sssComboStr(StkTkLocId,StkTkLoc)
	s ScgInfo=..sssComboStr(ScgId,ScgDesc)
	s IncscInfo=..sssComboStr(Incsc,IncscDesc)
	s PhaLocInfo=..sssComboStr(CreateLocId,CreateLoc)
	s SupervisionInfo=..sssComboStr(Supervision,Supervision)
    s DataStr=RowId_"^"_StkTkLocInfo_"^"_CreateDate_"^"_CreateTime_"^"_ScgId_"^"_IncscInfo
    	_"^"_PhaLocInfo_"^"_SubSTNo_"^"_CreateUser_"^"_Completed_"^"_CountCompleted
    	_"^"_AdjCompleted_"^"_SupervisionInfo
	s TitleStr="RowId^StkLoc^Date^Time^ScgStk^StkCat"
    	_"^PhaLoc^No^User^Completed^CountCompleted"
    	_"^AdjCompleted^Supervision"
	s result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q result
}

/// Descript:	检索主表query
/// Creator:	wangjiabin
/// CreateDate:	2015-10-16
/// Input:		StrParam:(库房id^盘点科室id^起始日期^截至日期)
/// Output:     
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCReqLocStktk","QueryMaster","","","1^2017-06-01^2017-06-08")
Query QueryMaster(StrParam As %String) As Query(ROWSPEC = "RowId,SubSTNo,StkTkLoc,StkTkLocDesc,CreateLoc,CreateLocDesc,CreateUser,CreateDate,CreateTime,Completed,CountCompleted,AdjCompleted,Scg,ScgDesc,Incsc,IncscDesc") [ SqlProc ]
{
}

ClassMethod QueryMasterExecute(ByRef qHandle As %Binary, StrParam As %String) As %Status
{
	n (qHandle,StrParam)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(StrParam)
	s StartDate=PJobj.%Get("StartDate")	//起始日期
	s EndDate=PJobj.%Get("EndDate")			//截止日期
	s StkTkLoc=PJobj.%Get("StkLoc")			
	s StartDate=..DH2L(StartDate)
    s EndDate=..DH2L(EndDate)
	q:StkTkLoc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	s sqlStr="select SUBST_RowId RowId,SUBST_No SubSTNo,SUBST_CreateDate CreateDate,SUBST_CreateTime CreateTime,SUBST_CreateUser_DR->SSUSR_Name CreateUser,"
		_"SUBST_CreateLoc_DR CreateLoc,SUBST_CreateLoc_DR->CTLoc_Desc CreateLocDesc,SUBST_CTLoc_DR StkTkLoc,SUBST_CTLoc_DR->CTLoc_Desc StkTkLocDesc,"
		_"SUBST_SCG_DR Scg,SUBST_SCG_DR->Scg_Desc ScgDesc,SUBST_INCSC_DR Incsc,SUBST_INCSC_DR->Incsc_Desc IncscDesc, SUBST_Completed Completed,"
		_"SUBST_INAD_DR, SUBST_CountCompleted CountCompleted, SUBST_AdjCompleted AdjCompleted, SUBST_Remarks Remarks"
		_" from DHC_SubLocStkTk where SUBST_CTLoc_DR="_StkTkLoc_" and (SUBST_CreateDate between "_StartDate_" and "_EndDate_")"	
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	i err q $$$OK
	While(result.Next())
	{
		s RowId=result.Data("RowId")
		s SubSTNo=result.Data("SubSTNo")
		s StkTkLoc=result.Data("StkTkLoc")
		s StkTkLocDesc=result.Data("StkTkLocDesc")
		s StkTkLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(StkTkLocDesc)
		s CreateLoc=result.Data("CreateLoc")
		s CreateLocDesc=result.Data("CreateLocDesc")
		s CreateLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(CreateLocDesc)
		s CreateUser=result.Data("CreateUser")
		s CreateDate=result.Data("CreateDate")
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s CreateTime=result.Data("CreateTime")
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s Completed=result.Data("Completed")
		s CountCompleted=result.Data("CountCompleted")
		s AdjCompleted=result.Data("AdjCompleted")
		s Scg=result.Data("Scg")
		s ScgDesc=result.Data("ScgDesc")
		s Incsc=result.Data("Incsc")
		s IncscDesc=result.Data("IncscDesc")

		d OutPurRowMaster
	}
	Quit $$$OK

OutPurRowMaster
	s Data=$lb(RowId,SubSTNo,StkTkLoc,StkTkLocDesc,CreateLoc,CreateLocDesc,CreateUser,CreateDate,CreateTime,Completed,CountCompleted,AdjCompleted,Scg,ScgDesc,Incsc,IncscDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检索子表明细query
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		主表rowid,实盘状态(1:仅盘盈,2:仅盘亏,3:有实盘数据,0(其他):全部),库存项id^类组^库存分类^名称
/// Output:     
/// Return：	子表RowId,Incil,InciCode,InciDesc,Spec,RepLev标准库存,FreezeQty冻结数量(入库单位),PUomDesc,CountQty盘点数量(入库单位),RepQty补货量(入库单位),
/// 			RpAmt进价金额,SpAmt售价金额,Remarks备注
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCReqLocStktk","QueryDetail","code","ASC",33,0,"^12^^WZ")
Query QueryDetail(Parref As %String, Params As %String = "") As Query(ROWSPEC = "RowId,Incil,InciCode,InciDesc,Spec,RepLev:%Float,FreezeQty:%Float,PUomDesc,CountQty:%Float,RepQty:%Float,RpAmt:%Float,SpAmt:%Float,Remarks,Rp:%Float") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Parref As %String, Params As %String = "") As %Status
{
	n (qHandle,Parref,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s incid=PJobj.%Get("Inci")	
	s input=PJobj.%Get("InciDesc")			
	s CountStatus=PJobj.%Get("CountStatus")
	s sqlStr="select SUBSTI_RowId RowId,SUBSTI_INCIL_DR Incil,SUBSTI_INCIL_DR->INCIL_INCI_Parref->INCI_Code code,"
		_" SUBSTI_INCIL_DR->INCIL_INCI_Parref->INCI_Desc InciDesc, SUBSTI_FreezeQty FreezeQty, SUBSTI_CountQty CountQty, SUBSTI_CTUOM_DR, SUBSTI_CTUOM_DR->CTUom_Desc PUomDesc,"
		_" SUBSTI_RpAmt RpAmt, SUBSTI_SpAmt SpAmt, SUBSTI_Remarks Remarks"
		_" from DHC_SubLocStkTkItm where SUBSTI_SUBST_Parref="_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	i err q $$$OK
	While(result.Next())
	{
		s RowId=result.Data("RowId")
		s Incil=result.Data("Incil")
		s Inci=+Incil,IL=$p(Incil,"||",2)
		continue:(incid'="")&&(Inci'=incid)
		s RepLevBUom=$p(^INCI(Inci,"IL",IL),"^",5)		;补货标准
		s RepQtyBUom=$p(^INCI(Inci,"IL",IL),"^",6)		;标准库存
		s InciCode=result.Data("code")
		s InciDesc=result.Data("InciDesc")
		continue:(input'="")&('$f(InciDesc,input))
		s BUom=$p(^INCI(Inci,1),"^",10)
		s PUom=$p(^INCI(Inci,3),"^",6)
		s PUomDesc=$p($g(^CT("UOM",PUom)),"^",2)
		s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUom,BUom)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
		s FreezeQtyBUom=result.Data("FreezeQty")
		s FreezeQty=FreezeQtyBUom/UomFac
		s CountQtyBUom=result.Data("CountQty")
		i CountStatus="1" continue:(CountQtyBUom="")||(CountQtyBUom'>FreezeQtyBUom)		;仅盘盈
		i CountStatus="2" continue:(CountQtyBUom="")||(CountQtyBUom'<FreezeQtyBUom)		;仅盘亏
		i CountStatus="3" continue:CountQtyBUom=""		;有实盘数据
		s CountQty=$s(CountQtyBUom'="":CountQtyBUom/UomFac,1:"")
		s RepLev=RepLevBUom/UomFac
		s RepQty=RepQtyBUom/UomFac
		s RpAmt=result.Data("RpAmt")
		s SpAmt=result.Data("SpAmt")
		s Remarks=result.Data("Remarks")
		s LocId=$p($g(^DHCSLST(Parref)),"^",6)
		s HospId=$p($G(^CTLOC(LocId)),"^",22)
		s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,PUom,HospId)
		d OutPurRowDetail
	}
	Quit $$$OK

OutPurRowDetail
	s Data=$lb(RowId,Incil,InciCode,InciDesc,Spec,RepLev,FreezeQty,PUomDesc,CountQty,RepQty,RpAmt,SpAmt,Remarks,Rp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 填充未录入实盘数记录的默认数
/// Author:lihui
/// Date:20170608
/// Argu:
/// Input: 帐盘表id,填充标志(1:未填记录实盘数=0;2:未填记录实盘数=账盘数)
/// Return:0 成功;其他 失败;
ClassMethod SetDefaultQtyForReqLoc(Inst As %String, Flag As %String) As %String
{
	n (Inst,Flag)
	s Rtnobj=##class(RtnObj).%New()
	i Inst="" d Rtnobj.Err(-1,"","ID不能为空!","",0)
	i Rtnobj.success'=0  q Rtnobj.Json()
	s Flag=+Flag
	s $ZT=..sssError()
	ts
	s Chl=0,RowId=""
	f  s Chl=$o(^DHCSLST(Inst,"I",Chl)) q:(Chl="")||(Rtnobj.success'=0)  d
	.s countqty=$p(^DHCSLST(Inst,"I",Chl),"^",3) ;实盘数
	.q:countqty'=""  ;过滤实盘数不为空
	.s incil=$p(^DHCSLST(Inst,"I",Chl),"^",1)  ;科室库存id
	.s RowId=Inst_"||"_Chl
	.i Flag=1  d
	..s DefaultQty=0
	.e  d
	..s DefaultQty=$p(^DHCSLST(Inst,"I",Chl),"^",2)  ;账盘数
	.&sql(update DHC_SubLocStkTkItm set SUBSTI_CountQty=:DefaultQty where SUBSTI_RowId=:RowId)
	.i SQLCODE'=0 d
	..d Rtnobj.Err(-1,"","更新失败!")
	i Rtnobj.success'=0  d
	.tro
	e  d  
	.tc
	s Rtnobj.rowid=Inst
	q Rtnobj.Json()							;保存成功
}

/// Descript:	判断某个科室是否存在未盘点结束的单据
/// Creator:	lihui
/// CreateDate:	20210514
/// Input:		盘点科室ID
/// Output:     Y 存在未结束盘点单
/// Return：w ##class(web.DHCSTMHUI.DHCReqLocStktk).CheckStkIfOver(132)	
ClassMethod CheckStkIfOver(LocId As %String) As %String
{
	n (LocId)
	s Flag="N"
	s stkid="",tmpstkid=""
	f  s stkid=$o(^DHCSLST(0,"CTLOC",LocId,stkid)) q:(stkid="")!(Flag="Y")  d
	.q:'$d(^DHCSLST(stkid))
	.s stkinfo=^DHCSLST(stkid)
	.s AdjCompleted=$p(stkinfo,"^",12)
	.i AdjCompleted'="Y" s Flag="Y",tmpstkid=stkid
	q Flag_"^"_tmpstkid
}

}
