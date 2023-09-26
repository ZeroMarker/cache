Import SQLUser

Class web.DHCBPArrangeStock Extends %RegisteredObject
{

/// w ##class(web.DHCBPArrangeStock).ConsumeStock(194,89,12828)
ClassMethod ConsumeStock(ctlocId, bpaId, userId)
{
	//DHC_BPC_StockItem的BPCSI_Type
	q:bpaId=""
	q:'$d(^DHCBPArrange(bpaId))
	k stockList
	s bpacAmount=1
	s bpacId=""
	f  s bpacId=$o(^DHCBPArrangeConsumable(0,"Arrange",bpaId,bpacId)) q:bpacId=""  d //录入的材料
		.q:'$d(^DHCBPArrangeConsumable(bpacId))
		.q:$lg(^DHCBPArrangeConsumable(bpacId),6)="Y"
		.s bpccId=$lg(^DHCBPArrangeConsumable(bpacId),2)
		.q:bpccId<1
		.s bpcsiId=$o(^DHCBPC("StockItem",0,"TypeConSumable","C",bpccId,""))
		.i bpcsiId="" w bpccId_"未配置库存项bpcsiId",!
		.q:bpcsiId=""
		.s bpacAmount=$lg(^DHCBPArrangeConsumable(bpacId),4)
		.s stockList(bpcsiId)=$g(stockList(bpcsiId))+bpacAmount		//汇总总量
		.w bpccId_","_bpcsiId_"/"_stockList(bpcsiId),!
	/*s bpccId="" //暂时不使用
	f  s bpccId=$o(^DHCBPArrangeStock(0,"ArrConsumable",bpaId,bpccId)) q:bpccId=""  d //当前已减的库存
		.s bpasId=""
			..f  s bpasId=$o(^DHCBPArrangeStock(0,"ArrConsumable",bpaId,bpccId,bpasId),-1) q:bpasId=""  d
				...q:'$d(^DHCBPArrangeStock(bpasId))
				...s $p(stockList(bpccId),"^",2)=$lg(^DHCBPArrangeStock(bpasId),3)  //最后一条，总数量
	*/
	s bpcsiId="" //全部透析都有的项目，无材料项DHC_BP_ArrangeConsumable
	f  s bpcsiId=$o(^DHCBPC("StockItem",0,"TypeConSumable","A",0,bpcsiId)) q:bpcsiId=""  d
		.s stockList(bpcsiId)=$lg($g(^DHCBPC("StockItem",bpcsiId)),2)
		.w bpcsiId_" id/stockList(bpcsiId) "_stockList(bpcsiId)
	
	s bpaBpcBedId=$lg(^DHCBPArrange(bpaId),7)
	s bpcEquipId=$o(^DHCBPBedEquip(0,"Bed",+bpaBpcBedId,""))
	s bpcEquipModelId=$lg($g(^DHCBPC("Equip",+bpcEquipId)),1)
	s bpaBpcvaId=$lg(^DHCBPArrange(bpaId),75)
	
	s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
	s bpaSecondBPCBPModeDr=$lg(^DHCBPArrange(bpaId),27)
	s bpaThirdBPCBPModeDr=$lg(^DHCBPArrange(bpaId),28)
	s bpaBPCBPModeIdStr=bpaBPCBPModeDr
	i bpaSecondBPCBPModeDr'="" s bpaBPCBPModeIdStr=bpaBPCBPModeIdStr_"^"_bpaSecondBPCBPModeDr
	i bpaThirdBPCBPModeDr'="" s bpaBPCBPModeIdStr=bpaBPCBPModeIdStr_"^"_bpaThirdBPCBPModeDr
		
	i bpcEquipModelId'="" d //设备型号对应库存，无记录材料项DHC_BP_ArrangeConsumable
		.s bpcsiId=""
		.f  s bpcsiId=$o(^DHCBPC("StockItem",0,"TypeConSumable","E",0,bpcsiId)) q:bpcsiId=""  d
			..q:bpcEquipModelId'=$lg($g(^DHCBPC("StockItem",+bpcsiId)),5)
			..s bpcsiBPModeDr=$lg($g(^DHCBPC("StockItem",+bpcsiId)),6)
			..q:(+bpcsiBPModeDr'=0)&(bpcsiBPModeDr'=+bpaBPCBPModeDr)
			..s stockList(bpcsiId)=$lg($g(^DHCBPC("StockItem",bpcsiId)),2)
			..w bpcsiId_" id/stockList(bpcsiId) "_stockList(bpcsiId)
		
	i bpaBpcvaId'="" d //血管通路对应库存，无记录材料项DHC_BP_ArrangeConsumable
		.s bpcsiId=""
		.f  s bpcsiId=$o(^DHCBPC("StockItem",0,"TypeConSumable","V",0,bpcsiId)) q:bpcsiId=""  d
			..q:bpaBpcvaId'=$lg($g(^DHCBPC("StockItem",+bpcsiId)),7)
			..s stockList(bpcsiId)=$lg($g(^DHCBPC("StockItem",bpcsiId)),2)
			..w bpcsiId_" id/stockList(bpcsiId) "_stockList(bpcsiId)
	b ;1
	;TStart
	s bpcsiId="",stockRet=0
	f  s bpcsiId=$o(stockList(bpcsiId)) q:bpcsiId=""  d
		.q:stockRet'=0
		.s bpcsiIncItemCode=$lg($g(^DHCBPC("StockItem",bpcsiId)),1)
		.s bpasPreQty=0
		.s bpasId=$o(^DHCBPArrangeStock(0,"ArrStockItem",bpaId,bpcsiId,""),-1)
		.w "pre bpasId="_bpasId,!
		.i bpasId'="" s bpasPreQty=$lg($g(^DHCBPArrangeStock(bpasId)),3) //最后一次记录全部减库存
		.w bpasPreQty_" pre/qty="_stockList(bpcsiId),!
		.s bpasStockAdjQty=bpasPreQty-stockList(bpcsiId)
		.s bpasQty=bpacAmount
		.s userId=""
		.s curDate=+$h
		.s curTime=$p($h,",",2)
		.w bpcsiId_"/"_bpcsiIncItemCode_" adjQty="_bpasStockAdjQty,!
		.b ;2
		.q:bpasStockAdjQty=0
		.&sql(insert into DHC_BP_ArrangeStock(BPAS_BPArrange_Dr,BPAS_BPCSI_Dr,BPAS_Qty,BPAS_PreQty,BPAS_StockAdjQty,BPAS_UpdateUser_Dr,BPAS_UpdateDate,BPAS_UpdateTime) 
				values(:bpaId,:bpcsiId,:bpasQty,:bpasPreQty,:bpasStockAdjQty,:userId,:curDate,:curTime))
		.s bpasId=$g(%ROWID)
		.w " bpcsiIncItemCode="_bpcsiIncItemCode,"/"_bpasStockAdjQty_" bpasId="_bpasId,!
		.;s stockRet=##Class(web.DHCSTM.Common.DHCSTPCHCOLLSM).MatConsume(ctlocId,bpcsiIncItemCode,bpasStockAdjQty,userId,"O",bpaId,bpasId)
	;i stockRet'=0 TRollBack  q stockRet
	;e  TCommit  q 0
	q 0
}

/// 说明：通过透析安排表ID获取病人基本信息数据
/// 入参：透析安排表ID
/// 返回：病人登记号、病案号、透析登记时的病人就诊ID、姓名、性别、名族、出生日期、家庭住址等字符串
/// 		 其中用"^"分割
/// w ##class(web.DHCBPArrangeStock)GetPatInfoByBpaId(18683)
ClassMethod GetPatInfoByBpaId(bpaId As %String)
{
	
	q:bpaId="" "透析安排ID不能为空！"
	s retstr=""
	s bpprId=$lg(^DHCBPArrange(bpaId),1) //透析登记表RowID
	q:bpprId="" "不存在此透析记录！"	
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)	
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1) //登记号	
	s admId=$lg(^DHCBPPatRegister(bpprId),26) //透析登记时病人就诊ID
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号 20200515统一走病案接口
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) //姓名
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2) //性别
	s patNation=$p($g(^CT("NAT",$p($g(^PAPER(papmiId,"PER",2)),"^",1))),"^",2) //名族
 	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	i patBirth'="" s patBirth=$zd(patBirth,3)	
	s bpprAddress=$lg(^DHCBPPatRegister(bpprId),2) //家庭住址
	s retstr=regNo_"^"_papmiMedicare_"^"_admId_"^"_patName_"^"_patSex_"^"_patNation_"^"_patBirth_"^"_bpprAddress
	q retstr
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPArrangeStock","GetArrangeStockBySIID","2015-1-1","2015-12-30","2249","")
/// d ##class(%ResultSet).RunQuery("web.DHCBPArrangeStock","GetArrangeStockBySIID","2015-1-1","2015-12-30","16","")
Query GetArrangeStockBySIID(fromDate As %String = "", toDate As %String = "", locId As %String = "", stockItemID As %String = "") As %Query(ROWSPEC = "regNo:%String,papmiMedicare:%String,admId:%String,bpaId:%String,patName:%String,patSex:%String,bpccDesc:%String,bpasQty:%String,bpasStockAdjQty:%String,bpasUpdateDate:%String,bpasUpdateTime:%String")
{
}

ClassMethod GetArrangeStockBySIIDExecute(ByRef qHandle As %Binary, fromDate As %String = "", toDate As %String = "", locId As %String = "", stockItemID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s bpcsiId=stockItemID
	f  s bpcsiId=$o(^DHCBPC("StockItem",bpcsiId)) q:bpcsiId=""  d
	 .s bpcsiQty=$lg($g(^DHCBPC("StockItem",bpcsiId)),2)
	 .s bpcsiBPCConsumableDr=$lg($g(^DHCBPC("StockItem",bpcsiId)),8)
	 .q:bpcsiBPCConsumableDr=""	 
	 .s bpccDesc=$lg($g(^DHCBPC("Consumable",bpcsiBPCConsumableDr)),2)
	 .f curDate=fromDate:1:toDate d
	  ..s bpaId=""
	  ..f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
	  ...s bpprId=$lg(^DHCBPArrange(bpaId),1)
	  ...q:bpprId=""
	  ...s status=$lg(^DHCBPArrange(bpaId),9)
	  ...q:status="D"
	  ...s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
	  ...;w bpprPatLocationDr,!
      ...q:(bpprPatLocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_bpprPatLocationDr_"^"))
	  ...s bpasId=""
	  ...f  s bpasId=$o(^DHCBPArrangeStock(0,"ArrStockItem",bpaId,bpcsiId,bpasId)) q:bpasId=""  d	  
	  ....s papmiId=$lg(^DHCBPPatRegister(bpprId),1)	
	  ....s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1) //登记号	  
	  ....s admId=$lg(^DHCBPPatRegister(bpprId),26) //透析登记时病人就诊ID
	  ....//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号 20200515统一走病案接口
	  ....s paadmtype=$p($g(^PAADM(admId)),"^",2)
	  ....s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	  ....s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) //姓名
	  ....s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2) //性别
	  ....s bpasQty=$lg($g(^DHCBPArrangeStock(bpasId)),3)
	  ....s bpasStockAdjQty=$lg($g(^DHCBPArrangeStock(bpasId)),5)
      ....s bpasUpdateDate=$lg($g(^DHCBPArrangeStock(bpasId)),7)
      ....s bpasUpdateTime=$lg($g(^DHCBPArrangeStock(bpasId)),8)
      ....s bpasUpdateDate=##class(web.DHCClinicCom).ConvertToDate(bpasUpdateDate)
      ....s bpasUpdateTime=##class(web.DHCClinicCom).ConvertToTime(bpasUpdateTime)
	  ....d OutputRow1	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(regNo,papmiMedicare,admId,bpaId,patName,patSex,bpccDesc,bpasQty,bpasStockAdjQty,bpasUpdateDate,bpasUpdateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetArrangeStockBySIIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArrangeStockBySIIDExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetArrangeStockBySIIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArrangeStockBySIIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
