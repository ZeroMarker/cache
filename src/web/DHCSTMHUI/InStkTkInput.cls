Import sqluser

/// Descript:实盘录入（按品种）相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// 
Class web.DHCSTMHUI.InStkTkInput Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 实盘 (js 调用)
/// w ##class(web.DHCSTMHUI.InStkTkInput).jsCreateStkTkInput(163,"","")
ClassMethod jsCreateStkTkInput(Inst As %String, UserId As %String, WinId As %String) As %String
{
	n (Inst,UserId,WinId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CreateStkTkInput(Inst,UserId,WinId)
	q RtnObj.Json()
}

/// Descript:根据帐盘记录生成实盘数据列表（实盘方式三）(js调用)
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:盘点主表id,盘点人id
/// Output:		
/// Return：成功：0；
/// -2   ;保存失败
/// -1   ;盘点id不能为空
/// w ##class(web.DHCSTMHUI.InStkTkInput).CreateStkTkInput(163,"","")
ClassMethod CreateStkTkInput(Inst As %String, UserId As %String, WinId As %String) As RtnObj
{
	n (Inst,UserId,WinId)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-1,"","入参错误!","",0)
	
	ts
	s InciId=0
	f  s InciId=$o(^DHCINST(Inst,"STI1",0,"INCI",InciId)) q:(InciId="")!(RtnObj.success'=0)  d
	.s Chl=""
	.i WinId'="" d
	..s Chl=$o(^DHCINST(Inst,"STP",0,"WININCI",WinId,InciId,0))
	.e  d
	..&sql(select DHCSTI_ChildSub into :Chl from dhc_instktkinput where DHCSTI_Parref=:Inst and DHCSTI_INCI_DR=:InciId and DHCSTI_PHW_DR is null)
	.q:Chl'=""
	.s FreezeUomFlag=$p(^DHCINST(Inst),"^",17)
	.i FreezeUomFlag=0  d
	..s UomId=$p(^INCI(InciId,1),"^",10)	;基本单位
	.e  d
	..s UomId=$p(^INCI(InciId,3),"^",6)	;入库单位
	.s obj=##class(User.DHCInStkTkInput).%New()
	.d obj.DHCSTIParrefSetObjectId(Inst)
	.s chi=$o(^DHCINST(Inst,"STP",""),-1)+1
	.s obj.DHCSTIChildSub=chi
	.d obj.DHCSTIINCIDRSetObjectId(InciId)
	.d obj.DHCSTIUomDrSetObjectId(UomId)
	.d obj.DHCSTICountUserDrSetObjectId(UserId)
	.s obj.DHCSTICountDate=+$h
	.s obj.DHCSTICountTime=$p($h,",",2)
	.d obj.DHCSTIPHWDRSetObjectId(WinId)
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d RtnObj.Err(-2,"","生成实盘数据失败") q
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// 批量保存实盘表记录(js调用)
/// Creator:	lxt
ClassMethod jsSave(Main As %String, ListData As %String) As %String
{
	n (Main,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,ListData)
	q RtnObj.Json()
}

/// 批量保存实盘表记录(js调用)
/// Creator:	lxt
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// 实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// Output:		
/// Return：成功：0；
/// -2   ;保存失败
/// -1   ;盘点id不能为空
/// d ##class(web.DHCSTMHUI.InStkTkInput).Save("{""ScgStk"":""12"",""gUserId"":""541"",""gLocId"":""153"",""gGroupId"":""234"",""gHospId"":""2"",""LocManaGrp"":"""",""StkCatBox"":"""",""LocStkBin"":"""",""InStkTkWin"":""5"",""inst"":""103"",""InstNo"":""QXKKFWJWSMST20180809005"",""InciDesc"":""""}","[{""rowid"":""103||31"",""parref"":""103"",""inci"":""9462"",""code"":""cl20161012"",""desc"":""cl20161012物资"",""spec"":"""",""uom"":""143"",""uomDesc"":""包[30g]"",""countQty"":""3"",""countDate"":"" 2018-08-09"",""countTime"":""15:52:09"",""userName"":""雷亚琦"",""freQty"":""90"",""IncsbDesc"":""""}]"))
ClassMethod Save(Main As %String, ListData As %String) As %String
{
	n (Main,ListData)
	s RtnObj=##class(RtnObj).%New()
	
	s MainPJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainPJobj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参错误!","",0)
	
	s pWinId=MainPJobj.%Get("InStkTkWin")
	s gUserId=MainPJobj.%Get("gUserId")
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 q RtnObj.Err(-2,"","入参错误!","",0)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s Inst=Obj.%Get("Inst")
		s RowId=Obj.%Get("RowId")
		s CountQty=Obj.%Get("CountQty")
		s StktkReasonId=Obj.%Get("StktkReasonId")
		s UomId=Obj.%Get("UomId")
		s InciId=Obj.%Get("InciId")
		i RowId=""  d
		.s obj=##class(User.DHCInStkTkInput).%New()
		.d obj.DHCSTIParrefSetObjectId(Inst)
		.s chi=$o(^DHCINST(Inst,"STP",""),-1)+1
		.s obj.DHCSTIChildSub=chi
		.d obj.DHCSTIINCIDRSetObjectId(InciId)
		.d obj.DHCSTIUomDrSetObjectId(UomId)
		.d obj.DHCSTIPHWDRSetObjectId(pWinId)
		e  d
		.s obj=##class(User.DHCInStkTkInput).%OpenId(RowId)
		.d obj.%Reload()
		i CountQty<0 s CountQty=0	//实盘不允许负数
		s obj.DHCSTICountQty=CountQty
		d obj.DHCSTICountUserDrSetObjectId(gUserId)
		s obj.DHCSTICountDate=+$h
		s obj.DHCSTICountTime=$p($h,",",2)
		s obj.DHCSTICountDate=+$h
		d obj.DHCSTIReasonDrSetObjectId(StktkReasonId)
		s sc=obj.%Save()
		i $$$ISERR(sc) d RtnObj.Err(-2,"","保存实盘信息是失败")
		q:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// 填充未录入实盘数记录的默认数(js调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.InStkTkInput).jsSetDefaultQty(^templxt("jsSetDefaultQtyP"),^templxt("jsSetDefaultQtyF"))
ClassMethod jsSetDefaultQty(Params As %String, Flag As %String) As %String
{
	n (Params,Flag)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SetDefaultQty(Params,Flag)
	q RtnObj.Json()
}

/// 填充未录入实盘数记录的默认数(js调用)
/// Author:zhangdongmei
/// Date:2012-09-03
/// Argu:
/// : 帐盘表id,实盘人rowid,填充标志(1:未填记录实盘数=0;2:未填记录实盘数=账盘数)
/// w ##class(web.DHCSTMHUI.InStkTkInput).SetDefaultQty(^templxt("jsSetDefaultQtyP"),^templxt("jsSetDefaultQtyF"))
ClassMethod SetDefaultQty(Params As %String, Flag As %String) As RtnObj
{
	n (Params,Flag)
	s RtnObj=##class(RtnObj).%New()
	i Flag="" q RtnObj.Err(-1,"","设置类型为空","",0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJobj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-2,"","入参错误!","",0)
	
	s Inst=PJobj.%Get("Inst")
	s gUserId=PJobj.%Get("gUserId")
	s pWinId=PJobj.%Get("InStkTkWin")
	
	i Inst="" q RtnObj.Err(-3,"","未选择盘点单","",0)
	
	ts
	s InciId=0
	f  s InciId=$o(^DHCINST(Inst,"STP",0,InciId)) q:(InciId="")||(RtnObj.success'=0)  d
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STP",0,InciId,Chl)) q:(Chl="")||(RtnObj.success'=0)  d
	..s WinId=$p(^DHCINST(Inst,"STP",Chl),"^",7)
	..q:pWinId'=WinId
	..
	..s Countqty=$p(^DHCINST(Inst,"STP",Chl),"^",2)
	..q:Countqty'=""
	..
	..s UomId=$p(^DHCINST(Inst,"STP",Chl),"^",3)
	..s UserId=$p(^DHCINST(Inst,"STP",Chl),"^",6)
	
	..i Flag=1  d
	...s DefaultQty=0
	..e  d
	...s DefaultQty=..SumFreQty(Inst,InciId)
	..i DefaultQty<0 s DefaultQty=0
	..
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	..s DefaultQty=DefaultQty/Fac
	..
	..s RowId=Inst_"||"_Chl
	..s obj=##class(User.DHCInStkTkInput).%OpenId(RowId)
	..d obj.%Reload()
	..d obj.DHCSTICountUserDrSetObjectId(gUserId)
	..s obj.DHCSTICountDate=+$h
	..s obj.DHCSTICountTime=$p($h,",",2)
	..s obj.DHCSTICountQty=DefaultQty
	..s sc=obj.%Save()
	..i $$$ISERR(sc) d RtnObj.Err(-2,"","保存实盘信息是失败")
	..q:RtnObj.success<0
	
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// Descript:查询实盘表记录
/// Creator:	lxt
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:开始行,一页显示记录数,排序字段，排序方向,
/// 管理组^类组^库存分类^货位^实盘窗口
/// Output:		
/// Return：成功：0；
/// -2    ;失败	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InStkTkInput","jsINStkTkInPut",^templxt("jsINStkTkInPut"))
Query jsINStkTkInPut(Params As %String) As Query(ROWSPEC = "RowId,Inst,InciId,InciCode,InciDesc,Spec,UomId,UomDesc,CountQty:%Float,CountDate,CountTime,CountUserName,FreezeQty:%Float,StkBinDesc,VarianceQty:%Float,Rp:%Float,FreezeRpAmt:%Float,CountRpAmt:%Float,VarianceRpAmt:%Float,StktkReasonId,StktkReason")
{
}

ClassMethod jsINStkTkInPutExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJobj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s Inst=PJobj.%Get("Inst")
	s pLocManGrpId=PJobj.%Get("LocManGrp")
	s pStkScgId=PJobj.%Get("StkScg")
	s pStkCatId=PJobj.%Get("StkCat")
	s pStkBinId=PJobj.%Get("LocStkBin")
	s pWinId=PJobj.%Get("InStkTkWin")
	s PInciId=PJobj.%Get("InciId")
	s pInciDesc=PJobj.%Get("InciDesc")
	s pInciCode=PJobj.%Get("InciCode")
	s pFreezeNonzero=PJobj.%Get("FreezeNonzero")
	s pInciCode=$$ALPHAUP^SSUTIL4(pInciCode)
	
	s LocId=$p(^DHCINST(Inst),"^",5)
	s HospId=..sssHospId(LocId)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",pStkScgId,HospId)
	
	s sql="select DHCSTI_Rowid RowId,"
		_"DHCSTI_INCI_DR InciId,"
		_"DHCSTI_INCI_DR->inci_code InciCode,"
		_"DHCSTI_INCI_DR->inci_desc InciDesc,"
		_"DHCSTI_Uom_Dr UomId,"
		_"DHCSTI_Uom_Dr->ctuom_desc UomDesc,"
		_"DHCSTI_CountQty CountQty,"
		_"DHCSTI_countDate CountDate,"
		_"DHCSTI_counttime CountTime,"
		_"DHCSTI_CountUser_Dr->ssusr_name CountUserName,"
		_"DHCSTI_Reason_Dr StktkReasonId,"
		_"DHCSTI_Reason_Dr->ISR_Desc StktkReason,"
		_"DHCSTI_PHW_DR WinId "
		_" from dhc_instktkinput"
		_" where DHCSTI_Parref="_Inst
	s xrs=##class(%ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s WinId=xrs.Data("WinId")
		continue:WinId'=pWinId
		
		s InciId=xrs.Data("InciId")
		continue:(PInciId'="")&(InciId'=PInciId)
		
		;管理组过滤
		s ch=$o(^INCI("IL_LOC",LocId,InciId,""))
		
		s incil=InciId_"||"_ch
		s LocManGrpId=##class(web.DHCSTMHUI.Common.DrugStkCommon).ManGrpByIncil(incil)
		continue:(pLocManGrpId'="")&&(pLocManGrpId'=LocManGrpId)
		
		;类组过滤
		s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s GrpId=$p(StkGrpInfo,"^",5)
		continue:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_GrpId_"^"))
		
		s StkCatId=$p(^INCI(InciId,2),"^",2)
		continue:(pStkCatId'="")&(StkCatId'=pStkCatId)
		
		s (StkBinDesc)=""
		s StkBinId=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(LocId,InciId),"^",2)
		continue:(pStkBinId'="")&(StkBinId'=pStkBinId)
		i StkBinId'="" s StkBinDesc=$p(^INC("SB",StkBinId),"^",2)
		
		s RowId=xrs.Data("RowId")
		s InciCode=xrs.Data("InciCode")
		continue:(pInciCode'="")&&($$ALPHAUP^SSUTIL4(InciCode)'[pInciCode)
		
		s InciDesc=xrs.Data("InciDesc")
		continue:(pInciDesc'="")&&(InciDesc'[pInciDesc)
		
		s UomId=xrs.Data("UomId")
		s UomDesc=xrs.Data("UomDesc")
		s CountQty=xrs.Data("CountQty")
		s CountDate=xrs.Data("CountDate")
		s CountTime=xrs.Data("CountTime")
		s CountUserName=xrs.Data("CountUserName")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciDesc)
		s FreezeQty=..SumFreQty(Inst,InciId)
		continue:(pFreezeNonzero="Y")&&(FreezeQty=0)
		
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s Rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,$h,BUomId)
		s FreezeQty=FreezeQty/Fac
		s Rp=Rp*Fac
		s FreezeRpAmt=FreezeQty*Rp
		s (VarianceQty,CountRpAmt,VarianceRpAmt)=""
		i CountQty'="" d
		.s VarianceQty=CountQty-FreezeQty
		.s VarianceRpAmt=VarianceQty*Rp
		.s CountRpAmt=CountQty*Rp
		i CountDate'="" s CountDate=..DL2H(CountDate)
		i CountTime'="" s CountTime=..TL2H(CountTime)
		s StktkReasonId=xrs.Data("StktkReasonId")
		s StktkReason=xrs.Data("StktkReason")
		d OutPutINStkTkInPutRow
	}
	Quit $$$OK

OutPutINStkTkInPutRow
	s Data=$lb(RowId,Inst,InciId,InciCode,InciDesc,Spec,UomId,UomDesc,CountQty,CountDate,CountTime,CountUserName,FreezeQty,
	StkBinDesc,VarianceQty,Rp,FreezeRpAmt,CountRpAmt,VarianceRpAmt,StktkReasonId,StktkReason)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// ====================================前端调用和后端代码的分界线================================
/// Descript:插入实盘表记录
/// Creater:ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:盘点主表id^药品id^单位id^实盘数^实盘人id^	
/// Output:		
/// Return：成功：实盘表id；
/// -3    ;保存失败	
ClassMethod Insert(Data) As %Library.String
{
	n (Data)
	s Inst=$P(Data,"^",1)
	s IncId=$p(Data,"^",2)
	s UomId=$p(Data,"^",3)
	s CountDate=+$h
	s CountTime=$p($h,",",2)
	s CountQty=$p(Data,"^",4)
	s UserId=$p(Data,"^",5)
	s InputWin=$p(Data,"^",6)
	s Err=0
	s Chl=+$o(^DHCINST(Inst,"STP",""),-1)+1
	&sql(insert into DHC_InStkTkInput(DHCSTI_Parref,DHCSTI_ChildSub,DHCSTI_INCI_DR,
		 DHCSTI_Uom_Dr,DHCSTI_CountQty,DHCSTI_CountUser_Dr,DHCSTI_CountDate,DHCSTI_CountTime,DHCSTI_PHW_DR) 
		 values (:Inst,:Chl,:IncId,:UomId,:CountQty,:UserId,:CountDate,:CountTime,:InputWin))
	i SQLCODE'=0  d
	.s Err=-3
	q:Err'=0 -3    ;保存失败
	;
	q $p($g(%ROWID),$c(1))
}

/// Descript:更新实盘表记录
/// Creater:ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:rowid^单位id^实盘数^实盘人id
/// Output:		
/// Return：成功：0；
/// -2    ;失败	
ClassMethod Update(Data) As %Library.String
{
	n (Data)
	s Rowid=$P(Data,"^",1)
	s UomId=$p(Data,"^",2)
	s CountDate=+$h
	s CountTime=$p($h,",",2)
	s CountQty=$p(Data,"^",3)
	s UserId=$p(Data,"^",4)
	s Err=0
	&sql(Update DHC_InStkTkInput set DHCSTI_Uom_Dr=:UomId,DHCSTI_CountQty=:CountQty,
		DHCSTI_CountUser_Dr=:UserId,DHCSTI_CountDate=:CountDate,DHCSTI_CountTime=:CountTime
	    where DHCSTI_Rowid=:Rowid) 
	i SQLCODE'=0  d
	.s Err=-2
	q:Err'=0 -2    ;更新失败
	;
	q 0
}

/// 查询盘点单中inci的账盘数(基本单位)
/// Input: inst 盘点单rowid, inci 库存项
/// Creator:	lxt
ClassMethod SumFreQty(Inst As %String, InciId As %String) As %String
{
	n (Inst,InciId)
	s SumFreQty=0
	q:(Inst="")||(InciId="") SumFreQty
	
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STI1",0,"INCI",InciId,ch)) q:ch=""  d
	.s FreQty=$p(^DHCINST(Inst,"STI",ch),"^",2)
	.s SumFreQty=SumFreQty+FreQty
	.
	q SumFreQty
}

/// 查询按品种实盘盘点单中的实盘数
/// Input: inst 盘点单rowid, inci 库存项
/// Creator: lxt
/// Y 全部录入  N存在未录入
ClassMethod CheckInput(Inst As %String) As %String
{
	n (Inst)
	s Flag="Y"
	q:Inst="" Flag

	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STP",ch)) q:(ch="")!(Flag="N")  d
	.s countQty=$p(^DHCINST(Inst,"STP",ch),"^",2)
	.s:countQty="" Flag="N"
	.q:Flag="N"
	
	q Flag
}

/// 查询按品种实盘盘点单中的实盘数
/// Input: inst 盘点单rowid, inci 库存项
/// Creator ：lxt
ClassMethod SumCountQty(Inst As %String, Inci As %String) As %String
{
	n (Inst,Inci)
	q:Inst="" 0
	q:Inci="" 0
	
	s SumCountQty=0
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s ch=0
	f  s ch=$o(^DHCINST(Inst,"STP",0,Inci,ch)) q:ch=""  d
	.s CountQty=$p(^DHCINST(Inst,"STP",ch),"^",2)
	.s CountUom=$p(^DHCINST(Inst,"STP",ch),"^",3)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CountUom,BUomId)
	.s CountQty=CountQty*Fac
	.s SumCountQty=SumCountQty+CountQty
	
	q SumCountQty
}

/// 盘点完成 (js 调用)
/// Creator:	lxt
/// w ##class(web.DHCSTMHUI.InStkTkInput).jsCompleteInput(163,873)
ClassMethod jsCompleteInput(Inst As %String, UserId As %String) As %String
{
	n (Inst,UserId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CompleteInput(Inst,UserId)
	q RtnObj.Json()
}

/// 实盘录入(按品种)完成, 按批次从后之前填写实盘数,多出冻结数量的部分存放在效期最近的一个批次
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:盘点主表id, 人员id, 未盘点库存项处理方式(0:默认为0, 1:默认为帐盘数)
/// Output:		
/// Return：成功：0；
/// -1   ;失败
/// wangjiabin 2013-09-25 Modified
ClassMethod CompleteInput(Inst As %String, UserId As %String) As RtnObj
{
	n (Inst,UserId)
	s RtnObj=##class(RtnObj).%New()
	i Inst="" q RtnObj.Err(-1,"","入参错误!","",0)
	
	s CompleteFlag=$p(^DHCINST(Inst),"^",13)
	i CompleteFlag="Y" q RtnObj.Err(-2,"","已经完成!")
	
	i ..CheckInput(Inst)="N" q RtnObj.Err(-3,"","盘点单中存在未录入实盘数")
	
	i ..sssLock("DHCSTINSTKTK"_Inst)<0  q RtnObj.Err(-99,"","加锁失败!")
	s InStkItmFlag="Y"

	ts
	s Inci=0
	f  s Inci=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci)) q:(Inci="")!(RtnObj.success<0)  d
	.s CountQty=..SumCountQty(Inst,Inci)
	.s LatelyExp=""     ;最近的效期
	.s SelInsti=""		;效期最近的帐盘明细
	.s Chl=""
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl),-1) q:(Chl="")!(RtnObj.success<0)  d
	..s Insti=Inst_"||"_Chl
	..s FreezeQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s ExpDate=$p(^DHCINST(Inst,"STI",Chl),"^",20)
	..s FreezeUomId=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s FreezeQtyUom=FreezeQty		;冻结数以基本单位计
	..s Rp=$P(^DHCINST(Inst,"STI",Chl),"^",30)
	..s Sp=$P(^DHCINST(Inst,"STI",Chl),"^",28)
	..
	..i LatelyExp=""  d
	...s LatelyExp=ExpDate
	...s SelInsti=Insti
	..e  i ExpDate>LatelyExp  d
	...s LatelyExp=ExpDate
	...s SelInsti=Insti
	..
	..;分配实盘数量
	..i (CountQty<=0)||(FreezeQtyUom<=0) d
	...s InclbCountQty=0
	..e  i CountQty>=FreezeQtyUom  d
	...s InclbCountQty=FreezeQtyUom
	...s CountQty=CountQty-FreezeQtyUom
	..e  d
	...s InclbCountQty=CountQty
	...s CountQty=0
	..
	..s SpAmt=Sp*InclbCountQty
	..s RpAmt=Rp*InclbCountQty
	..
	..s obj=##class(User.DHCInStkTkItm).%OpenId(Insti)
	..d obj.%Reload()
	..d obj.INSTICount1PersonDRSetObjectId(UserId)
	..s obj.INSTICount1Qty=+InclbCountQty
	..s obj.INSTICount1Date=+$H
	..s obj.INSTICount1Time=$P($H,",",2)
	..s obj.INSTICount1SpAmt=+SpAmt
	..s obj.INSTICount1RpAmt=+RpAmt
	..s varQty=InclbCountQty-FreezeQty
	..s obj.INSTIVariance1=varQty
	..s obj.INSTIVariance1RpAmt=obj.INSTICount1RpAmt-obj.INSTIFreezeRpAmt
	..s obj.INSTIVariance1SpAmt=obj.INSTICount1SpAmt-obj.INSTIFreezeSpAmt
	..s sc=obj.%Save()
	..i $$$ISERR(sc) d RtnObj.Err(-4,"","更新盘点明细失败")
	..q:RtnObj.success<0
	.;多出的实盘数保存至效期最新的一个批次
	.i CountQty>0  d
	..s Rp=$P(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2)),"^",30)
	..s Sp=$P(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2)),"^",28)
	..s ExcessRpAmt=Rp*CountQty
	..s ExcessSpAmt=Sp*CountQty
	..s obj=##class(User.DHCInStkTkItm).%OpenId(SelInsti)
	..d obj.%Reload()
	..s obj.INSTICount1Qty=obj.INSTICount1Qty+CountQty
	..s obj.INSTICount1SpAmt=obj.INSTICount1SpAmt+ExcessSpAmt
	..s obj.INSTICount1RpAmt=obj.INSTICount1RpAmt+ExcessRpAmt
	..s obj.INSTIVariance1=obj.INSTIVariance1+CountQty
	..s obj.INSTIVariance1RpAmt=obj.INSTICount1RpAmt-obj.INSTIFreezeRpAmt
	..s obj.INSTIVariance1SpAmt=obj.INSTICount1SpAmt-obj.INSTIFreezeSpAmt
	..s sc=obj.%Save()
	..i $$$ISERR(sc) d RtnObj.Err(-5,"","更新盘点明细失败")
	..q:RtnObj.success<0
	
	i RtnObj.success<0 d
	.tro 
	.d ..sssUnLock("DHCSTINSTKTK"_Inst)
	i RtnObj.success<0 q RtnObj

	&sql(update DHC_instktk  set inst_stocktakecomplete=:InStkItmFlag where inst_rowid =:Inst)
	i SQLCODE'=0  d
	.tro
	.d RtnObj.Err(-6,"","汇总错误!")
	.d ..sssUnLock("DHCSTINSTKTK"_Inst)
	q:RtnObj.success'=0 RtnObj
	
	tc
	d ..sssUnLock("DHCSTINSTKTK"_Inst)
	q RtnObj
}

/*
//// 实盘录入(按品种)完成
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-07
/// Table:DHC_InStkTkInput
/// Input:实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// 实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// Output:		
/// Return：成功：0；
/// -1   ;失败
/// 
ClassMethod CompleteInput(Inst As %String, User As %String) As %String
{
	n (Inst,User)
	q:Inst="" -1
	s Err=0
	;
	s Inci=0
	ts
	s $ZT=..sssError()
	f  s Inci=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci)) q:(Inci="")!(Err'=0)  d
	.s Sub=$o(^DHCINST(Inst,"STP",0,Inci,0))
	.q:Sub=""
	.s CountQty=$p(^DHCINST(Inst,"STP",Sub),"^",2)
	.s CountUomDr=$p(^DHCINST(Inst,"STP",Sub),"^",3)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s FacCountUom=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CountUomDr,BUomId)
	.s FacPurUom=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s LatelyExp=""     ;最近的效期
	.s SelInsti=""		;效期最近的帐盘明细
	.s Chl=0
	.f  s Chl=$o(^DHCINST(Inst,"STI1",0,"INCI",Inci,Chl)) q:(Chl="")!(Err'=0)  d
	..s FreezeQty=$p(^DHCINST(Inst,"STI",Chl),"^",2)
	..s Inclb=$p(^DHCINST(Inst,"STI",Chl),"^",1)
	..s ExpDate=$p(^DHCINST(Inst,"STI",Chl),"^",20)
	..s FreezeUomId=$p(^DHCINST(Inst,"STI",Chl),"^",17)
	..s FreezeQtyUom=FreezeQty
	..i FreezeUomId'=CountUomDr  d
	...s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(FreezeUomId,BUomId)
	...s FreezeQtyUom=FreezeQty*Fac1/FacCountUom
	...
	..i LatelyExp=""  d
	...s LatelyExp=ExpDate
	...s SelInsti=Inst_"||"_Chl
	..e  d
	...i ExpDate>LatelyExp  d
	....s LatelyExp=ExpDate
	....s SelInsti=Inst_"||"_Chl
	...
	..;分配实盘数量
	..i CountQty>=FreezeQtyUom  d
	...s InclbCountQty=FreezeQtyUom
	...s CountQty=CountQty-FreezeQtyUom
	..e  i FreezeQtyUom>0  d
	...s InclbCountQty=CountQty
	...s CountQty=0
	..
	..s Insti=Inst_"||"_Chl	
	..s BuomQty=InclbCountQty*FacCountUom
	..s PurUomQty=InclbCountQty*FacCountUom/FacPurUom
	..s StkBin=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBinByIncil($p(Inclb,"||",1,2))
	..s StkBin=$p(StkBin,"^",1)
	..s Data=User_"^"_InclbCountQty_"^"_CountUomDr_"^"_BuomQty_"^"_PurUomQty_"^"_StkBin_"^"
	..s Ret=##class(web.DHCSTMHUI.INStkTkItmWd).Update("",Insti,Data)
	..i +Ret<=0  d
	...s Err=-1
	..
	.q:Err'=0
	.i CountQty>0  d
	..s Instw=$o(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2),"STW",0))
	..s OldCountQty=$p(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2),"STW",Instw),"^",2)
	..s OldPurQty=$p(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2),"STW",Instw),"^",8)
	..s OldBQty=$p(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2),"STW",Instw),"^",9)
	..s AddPurQty=CountQty*FacCountUom/FacPurUom
	..s AddBQty=CountQty*FacCountUom
	..s $p(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2),"STW",Instw),"^",2)=OldCountQty+CountQty
	..s $p(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2),"STW",Instw),"^",8)=OldPurQty+AddPurQty
	..s $p(^DHCINST(+SelInsti,"STI",$p(SelInsti,"||",2),"STW",Instw),"^",9)=OldBQty+AddBQty
	..
	.
	i Err'=0 trollback
	q:Err'=0 Err
	tc
	q 0							;成功
}
*/
}
