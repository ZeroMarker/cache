Import sqluser

/// Descript:	同第三方物资管理软件间的库存同步类
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
Class web.DHCSTMHUI.ServiceOnStock Extends (%RegisteredObject, StkTypeM, %XML.Adaptor) [ Not ProcedureBlock ]
{

/*
<?xml version="1.0" encoding="utf-8" ?>
<Response>
	<Msg>
		<ItemArray>								失败列表
			<Item>
				<BatId>dongruan0001</BatId>		东软批次id
				<RET>-1</RET>					处理失败返回值
			</Item>
			...
		</ItemArray>
		<FailCount>1</FailCount>				失败条数
		<SuccCount>99</SuccCount>				成功条数
		<MsgInfo>部分失败</MsgInfo>				处理信息: 成功,失败,部分失败
		<MsgStatus></MsgStatus>					其他错误信息
	</Msg>
</Response>
*/
/// w ##class(web.DHCSTMHUI.ServiceOnStock).UpdateStockInfo("<Request><Header><SourceSystem>HRP系统</SourceSystem><MessageID></MessageID></Header><Body><BasiType>0</BasiType><BatList><BatItem><BatId>284</BatId><store_code>2035</store_code><InciCode>11051000041</InciCode><LocCode>1002110103</LocCode><ExpDate>2018-12-31</ExpDate><BatchNo></BatchNo><Rp>1.8900</Rp><sp>1.8900</sp><Qty>48499.00</Qty></BatItem></BatList></Body></Request>")
/// 
ClassMethod UpdateStockInfo(Input) As %GlobalCharacterStream
{
	s $zt="Exception"
#;	i '$ISOBJECT(Input1) d
#;	.d Input.Write(Input1)
#;	e  d
#;	.d Input.CopyFrom(Input1)
#;	s ^tempUpdateStockInfoInfo(+$h)=Input
#;	d Input.Rewind()
	
	s AppName=##class(web.DHCSTMHUI.INAdjPriceBatch).%GetParameter("AppName")
	s AdjBatchNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","")
	
	s ReturnStream=##class(%GlobalCharacterStream).%New()
	//s Header="<?xml version=""1.0"" encoding=""utf-8"" ?>"
	d ReturnStream.Write("<Response><Header><SourceSystem>HIS系统</SourceSystem><MessageID>70751</MessageID></Header><Body><ResultList>")
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	if $$$ISERR(tSC) {
		d ReturnStream.Write("<MsgInfo>解析xml失败</MsgInfo>")
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Header/MessageID","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set MessageID=tRes.GetAt(1).Value
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/BasiType","text()",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set BasiType=tRes.GetAt(1).Value
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/BatList","count(BatItem)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			s FailCount=0,SuccCount=0
						
			for i=1:1:hsCount {
				s (BatId,InciCode,LocCode,ExpDate,BatchNo,Rp,Sp,Qty)=""
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/BatId","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set BatId=tRes.GetAt(1).Value
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/InciCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set InciCode=tRes.GetAt(1).Value
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/LocCode","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set LocCode=tRes.GetAt(1).Value
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/ExpDate","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set ExpDate=tRes.GetAt(1).Value
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/BatchNo","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set BatchNo=tRes.GetAt(1).Value
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/Rp","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set Rp=tRes.GetAt(1).Value
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/Sp","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set Sp=tRes.GetAt(1).Value
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/BatList/BatItem["_i_"]/Qty","text()",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set Qty=tRes.GetAt(1).Value
				}
			
				s StrParam=BatId_"^"_InciCode_"^"_LocCode_"^"_ExpDate_"^"_BatchNo_"^"_Rp_"^"_Sp_"^"_Qty
				s RET=..UpdateStock(BasiType,StrParam,AdjBatchNo)
				i RET<0 d
				.s FailCount=FailCount+1
				.s ItemErrStr="<Item><BatId>"_BatId_"</BatId>"_"<RET>"_RET_"</RET></Item>"
				.d ReturnStream.Write(ItemErrStr)
				e  d
				.s SuccCount=SuccCount+1
			}
			d ReturnStream.Write("</ResultList><ResponseCount>")
			s CountInfoStr="<FailCount>"_FailCount_"</FailCount><SuccCount>"_SuccCount_"</SuccCount></ResponseCount>"
			d ReturnStream.Write(CountInfoStr)
			s ResultCode=$s(FailCount=0:"0",SuccCount=0:"-1",1:"-1")
			s ResultContent=$s(FailCount=0:"成功",SuccCount=0:"失败",1:"部分失败")
			s MsgInfoStr="<ResultCode>"_ResultCode_"</ResultCode>"
			s MsgInfoStr=MsgInfoStr_"<ResultContent>"_ResultContent_"</ResultContent>"
			d ReturnStream.Write(MsgInfoStr)

			d ReturnStream.Write("")
		}
	}

	d ReturnStream.Write("</Body></Response>")
	q ReturnStream
	
Exception
	TROLLBACK
	s ErrStream=##class(%GlobalCharacterStream).%New()
	//s Header="<?xml version=""1.0"" encoding=""utf-8"" ?>"
	//d ErrStream.Write(Header)
	d ErrStream.Write("<Response><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>数据或程序异常</ResultContent><ResponseCount></ResponseCount></Body></Response>")
	///d ErrStream.Write("<Response><Msg><MsgInfo>失败</MsgInfo><MsgStatus>数据或程序异常</MsgStatus></Msg></Response>")
	q ErrStream
}

/// Descript:	根据第三方信息生成incib,inclb等数据
/// 			同步实时库存, 还是按天同步??? 请说明
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
/// Table:		
/// Input:		Basitype 业务类型	0 同步库存   1 库存调整
/// 			StrParam(BatId^InciCode^LocCode^ExpDate^BatchNo^Rp^Sp^Qty)
/// 				 第三方批次Id^库存项代码^科室代码^效期(Y-m-d)^批号^进价^售价^数量
/// 			批次调价表单号
/// Return:		0:成功, <0:失败
/// w ##class(web.DHCSTMHUI.ServiceOnStock).UpdateStock(0,"881^11051000040^1001030201^2018-12-31^^56.7000^56.700000^4.00","")
ClassMethod UpdateStock(Basitype, StrParam, AdjBatchNo) As %String
{
	n (Basitype,StrParam,AdjBatchNo)
	i AdjBatchNo="" d
	.s AppName=##class(web.DHCSTMHUI.INAdjPriceBatch).%GetParameter("AppName")
	.s AdjBatchNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","")

	s BatId=$p(StrParam,"^",1)
	s InciCode=$p(StrParam,"^",2)
	s LocCode=$p(StrParam,"^",3)
	s ExpDate=$p(StrParam,"^",4)
	s BatchNo=$p(StrParam,"^",5)
	s Qty=+$p(StrParam,"^",8)
	s InciCode=$$ALPHAUP^SSUTIL4(InciCode)
	s LocCode=$$ALPHAUP^SSUTIL4(LocCode)
	q:BatId="" -1_"^批次id为空"
	q:InciCode="" -1_"^物资代码为空"
	q:LocCode="" -1_"^科室代码为空"
	
	s Inci=$o(^INCI(0,"Code1",InciCode_"Z",0))
	q:Inci="" -2_"^物资代码错误"
	q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3)) -2
	
	s LocId=$o(^CTLOC(0,"Code",LocCode,0))
	q:LocId="" -2_"^科室代码错误"
	
	i Basitype="0" s StockDate=+$h-1		;同步到昨天的库存
	i Basitype="1" s StockDate=+$h		;调整库存
	s Err=0
	
	ts
	s Incib=..GetIncib(StrParam,AdjBatchNo)
	i Incib<0 tro 1 q -10_"^获取批次信息失败"
	
	s Inclb=..GetINCLB(Incib,LocId)
	i Inclb<0 tro 1 q -20_"^获取批次信息失败"
	
	s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,StockDate)
	i Basitype="0" s QtyGap=Qty-InclbQty
	i Basitype="1" s QtyGap=Qty
	i ($ZABS(QtyGap)>InclbQty)&&(QtyGap<0) tro 1 q -40_"^可用库存不足"
	i QtyGap'=0 d
	.s Ret=##class(web.DHCSTMHUI.Common.StockHandle).UpdateStock(Inclb,QtyGap)
	.i Ret<0 s Err=-30_"^同步库存失败"
	i Err<0 tro 1 q Err
	
	tc
	q 0
}

/// Description:获取Inclb
/// Descript:	根据第三方批次id等信息获取已有批次,或新建批次信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
/// Input:		Incib, 科室rowid
/// OutPut:		inclb:成功, <0:失败
/// w ##class(web.DHCSTMHUI.ServiceOnStock).GetINCLB("9041||5",153)
ClassMethod GetINCLB(Incib As %String, LocId As %String) As %String [ Private ]
{
	n (Incib,LocId)
	q:Incib="" -1
	
	s Inci=$p(Incib,"||",1),IB=$p(Incib,"||",2)
	q:(Inci="")||(IB="") -1
	q:($d(^INCI(Inci,"IB",IB))=0)||($d(^INCI(Inci,"IB",IB))=10) -1
	
	l +^DBLock($zn,Inci_"^"_LocId):20 e  q -99
	
	s Err=0
	ts
	s Incil="",Inclb=""
	s IL=$O(^INCI("IL_LOC",LocId,Inci,""))
	i IL="" d
	.&sql(insert into inc_itmloc
		(incil_Inci_parref,incil_ctloc_dr)
		values
		(:Inci,:LocId)
	 )
	.i SQLCODE=0 s Incil=$p($g(%ROWID),$c(1)) 
	.e  s Err=-20 
	.s IL=$p(Incil,"||",2)
	e  d
	.s Incil=Inci_"||"_IL
	i (IL="")||(Err<0) tro 1 q Err
	
	s LB=$O(^INCI("LB_IB",Incib,Inci,IL,""))
	i LB="" d
	.&sql(insert into INC_ItmLcBt
		(inclb_incil_parref,inclb_incib_dr)
		values(:Incil,:Incib)
	 )
	.i SQLCODE=0 s Inclb=$p($g(%ROWID),$c(1))
	.e  s Err=-21
	e  d
	.s Inclb=Inci_"||"_IL_"||"_LB 
	l -^DBLock($zn,Inci_"^"_LocId)
	i (Inclb="")||(Err<0) tro 1 q Err
	
	tc
	q Inclb
}

/// Descript:	根据第三方批次id等信息获取已有批次,或新建批次信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
/// Input:		StrParam(BatId^InciCode^LocCode^ExpDate^BatchNo^Rp^Sp)
/// 					第三方批次Id^库存项代码^科室代码^效期(Y-m-d)^批号^进价^售价
/// 			AdjBatchNo批次调价表单号
/// Return:		incib:成功, <0:失败
/// w ##class(web.DHCSTMHUI.ServiceOnStock).GetIncib("296^11051000519^1002110103^2018-12-31^^137.0300^137.0300","20170001")
ClassMethod GetIncib(StrParam As %String, AdjBatchNo As %String) As %String
{
	n (StrParam,AdjBatchNo)
	
	s BatId=$p(StrParam,"^",1)
	s InciCode=$p(StrParam,"^",2)
	s LocCode=$p(StrParam,"^",3)
	s ExpDate=$p(StrParam,"^",4)
	s BatchNo=$p(StrParam,"^",5)
	s InciCode=$$ALPHAUP^SSUTIL4(InciCode)
	s LocCode=$$ALPHAUP^SSUTIL4(LocCode)
	q:BatId="" -1
	q:InciCode="" -1
	q:LocCode="" -1
	
	s Inci=$o(^INCI(0,"Code1",InciCode_"Z",0))
	q:Inci="" -2
	q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3)) -2
	s LocId=$o(^CTLOC(0,"Code",LocCode,0))
	
	s Incib=""
	s DHCIncib=$o(^DHCINCIB(0,"DetailId",BatId,0))
	i DHCIncib'="" d
	.s Incib=$p(^DHCINCIB(DHCIncib),"^",1)
	q:(DHCIncib'="")&&(Incib="") -3
	;;q:Incib'="" Incib		;获取到Incib的,退出
	
	s $ZT=..sssError()
	ts
	;1.传入INC_ItmBat
	s:ExpDate["-" ExpDate=$zdh(ExpDate,3)
	s Uom=$p(^INCI(Inci,1),"^",10)
	s BuomDr=$p(^INCI(Inci,1),"^",10)
	s PuruomDr=$p(^INCI(Inci,3),"^",6)
	s PFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
	;s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BuomDr)
	
	s ProduceDate=""
	s Mnf=""
	s Rp=$p(StrParam,"^",6)
	s Sp=$p(StrParam,"^",7)
	s SpecList=""
	s Vendor=""
	s GiftFlag=""
	s AdjCheque=""
	s SourceOfFund=""
	s SterilizedBat=""
	;按基本单位处理
	s BRp=Rp
	s PurRp=Rp*PFac
	s BSp=Sp
	s PurSp=Sp*PFac
	
	s Date=+$h
	s Time=$p($h,",",2)
	s Err=0
	
	
	i Incib="" 
	{
		&sql(insert into inc_itmbat
			(INCIB_INCI_ParRef,INCIB_No,INCIB_ExpDate)
			values
			(:Inci,:BatchNo,:ExpDate)
		)
		i SQLCODE'=0  d
		.s Err=-10
		i Err'=0 tro 1 q Err
		s Incib=$p($g(%ROWID),$c(1))
		
		;2.插入DHC_INCItmBat
		s Dhcingri=""
		&sql(insert into dhc_incitmbat
			(INCIB_INCIB_Dr,INCIB_ProduceDate,INCIB_Rp,INCIB_RpPuruom,INCIB_Sp,
			INCIB_SpPuruom,INCIB_PHMNF_Dr,INCIB_APCVM_Dr,INCIB_INGRI_Dr,INCIB_DateAdd,
			INCIB_TimeAdd,INCIB_SourceOfFund,INCIB_SpecList,INCIB_GiftFlag,INCIB_AdjCheque,
			INCIB_SterilizedBat,INCIB_DetailId)
			values
			(:Incib,:ProduceDate,:BRp,:PurRp,:BSp,
			:PurSp,:Mnf,:Vendor,:Dhcingri,:Date,
			:Time,:SourceOfFund,:SpecList,:GiftFlag,:AdjCheque,
			:SterilizedBat,:BatId)
		)
		i SQLCODE'=0  d
		.s Err=-11
		i Err'=0 tro 1 q Err
	}
	;3.Insert批次调价表
	s AdjUomId=$p(^INCI(Inci,1),"^",10)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s AdjDate=+$h,AdjUserId="",Status="Y"
	s ExecuteDate=+$h
	s PriorRp=0,PriorSp=0,BPriorRp=0,BPriorSp=0
	s PriceFileNo="",WarNoDate="",PreExecuteDate=+$h
	s Remark="",AdjReasonId=""
	s PriceInfo=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,AdjUomId,HospId)
	s OldSp=$p(PriceInfo,"^",2)
	i +OldSp'=+Sp {
		&sql(insert into IN_AdjPriceBatch
			(INAPB_date,INAPB_Incib_Dr,INAPB_ssusr_dr,INAPB_status,INAPB_No,
			INAPB_ExecuteDate,INAPB_Uom_Dr,INAPB_PriorRpUom,INAPB_ResultRpUom,INAPB_PriorSpUom,
			INAPB_ResultSpUom,INAPB_PriorRP,INAPB_ResultRP,INAPB_priorsp,INAPB_resultsp,INAPB_Hospital_Dr,
			INAPB_WarrentNO,INAPB_WNODate,INAPB_PreExeDate,INAPB_Remark,INAPB_REASON_DR) 
			values
			(:AdjDate,:Incib,:AdjUserId,:Status,:AdjBatchNo,
			:ExecuteDate,:AdjUomId,:PriorRp,:Rp,:PriorSp,
			:Sp,:BPriorRp,:Rp,:BPriorSp,:Sp,:HospId,
			:PriceFileNo,:WarNoDate,:PreExecuteDate,:Remark,:AdjReasonId)
		)
		i SQLCODE'=0 tro 1 q -12
	}
	tc
	q Incib
}

/*
字段名称		字段描述
receive_id		流水号(唯一)
sell_price		销售价格
amount			数量
bar_code		条形码(高值耗材填写，非高值不用填写）
is_high_value	是否高值耗材(0-普通材料，1-高值耗材)
doc_advice_code	医嘱编码
doc_advice_date	医嘱日期
patient_code	患者编码
patient_name	患者姓名
emp_code		医生编码
doctor_name		医生姓名
charge_date		收费日期
message			备注
oper_date		使用日期
bed_no			床位号
hospital_no		住院号
exec_dept_name	执行科室名称
exec_dept_code	执行科室编码
order_dept_name	开单科室名称
order_dept_code	开单科室编码
charge_code		收费项目编码
charge_name		收费项目名称
in_iow_id		移库单明细id号（HRP移库确认时推送至His）
*/
/// Descript:	医嘱台帐信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-27
/// Input:		开始日期(Y-m-d), 截止日期(Y-m-d)
/// Return:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceOnStock","GetDispInfo","2017-07-28","2017-07-28")
Query GetDispInfo(StartDate As %String, EndDate As %String) As Query(ROWSPEC = "receive_id,sell_price:%Float,amount:%Float,bar_code,is_high_value,doc_advice_code,doc_advice_date,patient_code,patient_name,emp_code,doctor_name,charge_date,message,oper_date,bed_no,hospital_no,exec_dept_name,exec_dept_code,order_dept_name,order_dept_code,charge_code,charge_name,in_iow_id")
{
}

ClassMethod GetDispInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	n (qHandle,StartDate,EndDate)
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	s StkType=..sssCode()
	s TypeStr="P^Y^F^H"
	s Len=$l(TypeStr,"^")
	f i=1:1:Len d
	.s TrType=$p(TypeStr,"^",i)
	.
	.f TrDate=StartDate:1:EndDate d
	..s TrDateZ=$zd(TrDate,3)
	..s Intr=0
	..f  s Intr=$o(^DHCINTR(0,"TypeDate",TrType,TrDate,Intr)) q:Intr=""  d
	...s TrInfo=^DHCINTR(Intr)
	...s Qty=$p(TrInfo,"^",6)
	...s Inclb=$p(TrInfo,"^",7)
	...s Pointer=$p(TrInfo,"^",9)
	...s Sp=$p(TrInfo,"^",14)
	...
	...s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	...q:(Inci="")||(IL="")||(LB="")
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	...s ScgType=$p(ScgInfo,"^",3)
	...q:ScgType'=StkType
	...s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
	...q:Incib=""
	...s IB=$p(Incib,"||",2)
	...s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	...q:DHCIncib=""
	...s BatId=$p(^DHCINCIB(DHCIncib),"^",20)		;第三方DetailId
	...q:BatId=""
	...
	...s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	...q:LocId=""
	...s LocCode=$p(^CTLOC(LocId),"^",1)
	...s LocDesc=$p(^CTLOC(LocId),"^",2)
	...
	...s Oeori=Pointer
	...
	...s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	...s HVBarCode=##class(web.DHCSTMHUI.SRVCOMMON).GetBarcodeByOrd(Oeori)
	...s Arcim=$p(^INCI(Inci,1),"^",3)
	...s ArcimSub=$p(Arcim,"||",1),ArcimVer=$p(Arcim,"||",2)
	...q:(Arcim="")||(ArcimSub="")||(ArcimVer="")
	...
	...s ArcCode=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",1)
	...s ArcDesc=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	...
	...s Ord=$p(Oeori,"||",1),OrdCh=$p(Oeori,"||",2)
	...q:(Ord="")||(OrdCh="")
	...s AdmId=$p(^OEORD(Ord),"^",1)
	...q:AdmId=""
	...s Papmi=$p($g(^PAADM(AdmId)),"^",1)
	...q:Papmi=""
	...s AdmNo=$p($g(^PAPER(Papmi,"PAT",1)),"^",1)		;登记号
	...s AdmName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	...s Medno=##class(web.DHCSTMHUI.Common.ServiceCommon).GetMrNoByEpisodeID(AdmId)
	...s BedId=$p($g(^PAADM(AdmId)),"^",73)
	...s BedNo=$s(BedId'="":$p($g(^PAWARD(+BedId,"BED",$p(BedId,"||",2))),"^",1),1:"")
	...s OrdDate=$p(^OEORD(Ord,"I",OrdCh,3),"^",7)
	...s:OrdDate'="" OrdDate=$zd(OrdDate,3)
	...
	...s DoctorId=$p(^OEORD(Ord,"I",OrdCh,7),"^",1)		;OEORI_UserAdd 医嘱录入人
	...s DocLocId=$p(^OEORD(Ord,"I",OrdCh,7),"^",2)
	...s DoctorInitial=$p(^SSU("SSUSR",DoctorId),"^",1)
	...s DoctorName=$p(^SSU("SSUSR",DoctorId),"^",2)
	...s DocLocCode=$s(DocLocId'="":$p(^CTLOC($g(DocLocId)),"^",1),1:"")
	...s DocLocDesc=$s(DocLocId'="":$p(^CTLOC($g(DocLocId)),"^",2),1:"")
	...s Remark=""
	...
	...d OutPutTrDetail
	Quit $$$OK

OutPutTrDetail
	Set Data=$lb(Intr,Sp,Qty,HVBarCode,HVFlag,
		ArcCode,OrdDate,AdmNo,AdmName,DoctorInitial,
		DoctorName,TrDateZ,Remark,OrdDate,BedNo,
		Medno,LocCode,LocDesc,DocLocDesc,DocLocCode,
		ArcCode,ArcDesc,BatId
	)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// receive_id,sell_price:%Float,amount:%Float,bar_code,is_high_value,doc_advice_code,doc_advice_date,patient_code,patient_name,emp_code,doctor_name,charge_date,message,oper_date,bed_no,hospital_no,exec_dept_name,exec_dept_code,order_dept_name,order_dept_code,charge_code,charge_name,in_iow_id
/// w ##class(web.DHCSTMHUI.ServiceOnStock).SendDispInfo("2017-07-29","2017-07-29")
ClassMethod SendDispInfo(Stdate As %String, Endate As %String) As %GlobalCharacterStream
{
  s stream=##class(%GlobalCharacterStream).%New()
  s return=##class(%GlobalCharacterStream).%New()
  s Head="<Request><Header><SourceSystem>02</SourceSystem><MessageID></MessageID></Header><Body>"
  s Afterward="</Body></Request>"
  s Soap=##class(web.DHCENS.STBLL.SOAP.PUB004Soap).%New()
  SET rs=##class(%ResultSet).%New()
  SET rs.ClassName="web.DHCSTMHUI.ServiceOnStock"
  set rs.QueryName="GetDispInfo"
  DO rs.Execute(Stdate,Endate)
  s objList=##class(web.DHCSTMHUI.SendDispInfoModelList).%New()
  While rs.Next(.sc) {
	  	s obj=##class(web.DHCSTMHUI.SendDispInfoModel).%New()
		s obj.receiveid= rs.Data("receive_id")
		s obj.sellprice= rs.Data("sell_price")
		s obj.amount= rs.Data("amount")
		s obj.barcode= rs.Data("bar_code")
		s obj.ishighvalue= rs.Data("is_high_value")
		s obj.docadvicecode= rs.Data("doc_advice_code")
		s obj.docadvicedate= rs.Data("doc_advice_date")
		s obj.patientcode= rs.Data("patient_code")
		s obj.patientname= rs.Data("patient_name")
		s obj.empcode= rs.Data("emp_code")
		s obj.doctorname= rs.Data("doctor_name")
		s obj.chargedate= rs.Data("charge_date")
		s obj.message= rs.Data("message")
		s obj.operdate= rs.Data("oper_date")
		s obj.bedno= rs.Data("bed_no")
		s obj.hospitalno= rs.Data("hospital_no")
		s obj.execdeptname= rs.Data("exec_dept_name")
		s obj.execdeptcode= rs.Data("exec_dept_code")
		s obj.orderdeptname= rs.Data("order_dept_name")
		s obj.orderdeptcode= rs.Data("order_dept_code")
		s obj.chargecode= rs.Data("charge_code")
		s obj.chargename= rs.Data("charge_name")
		s obj.iniowid= rs.Data("in_iow_id")
		d objList.InfoModes.Insert(obj)
		
		if objList.InfoModes.Count()>5{
			d objList.XMLExportToStream(.str)
			d stream.Write(Head)
			d stream.CopyFrom(str)
			d stream.Write(Afterward)
			s return=Soap.HIPMessageServer("T0049",stream)
			d objList.InfoModes.Clear()
		}
	}
	 if objList.InfoModes.Count()>0{
		d objList.XMLExportToStream(.str)
		d stream.Write(Head)
		d stream.CopyFrom(str)
		d stream.Write(Afterward)
		s return=Soap.HIPMessageServer("T0049",stream)
		
	}
	q return.Read()
}

}
