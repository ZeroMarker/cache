Class web.DHCEQAMoveStockStat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Mozy	984422	2019-8-5	增加简称
/// modify BY:GBX GBX0014 配件转移明细查询
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAMoveStockStat","GetStoreMoveStat")
Query GetStoreMoveStat(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TSMRowID:%String,TFromLocDR:%String,TFromLoc:%String,TToLocDR:%String,TToLoc:%String,TSMNo:%String,TMakeDate:%String,TAccessoryTypeDR:%String,TAccessoryType:%String,TStatus:%String,TAccessory:%String,TPrice:%String,TQuantityNum:%String,TTotalFee:%String,TJob:%String,TApproveStep:%String,TApproveRole:%String,TRow:%String,TUnit:%String,TReciver:%String,TFileNo:%String,TEquipName:%String,TModel:%String,TShortDesc:%String")
{
}

ClassMethod GetStoreMoveStatExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^DHCEQTemp("AMoveStockStat",User)
 	d ##Class(web.DHCEQCommon).KillTempGlobal("AMoveStockStat")
 	/********************************************************/
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set FromLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"FromLocDR")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set Name=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(vData,"Name"),"U")
	;Set CatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
	Set AccessoryTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"AccessoryTypeDR")
	Set ToLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ToLocDR")
	Set MoveType=##Class(web.DHCEQCommon).GetDataByName(vData,"MoveType")
	Set StoreMoveNo=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(vData,"StoreMoveNo"),"U") //转移单号
	Set ShortDesc=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(vData,"ShortDesc"),"U")
	Set FileNo=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(vData,"FileNo"),"U")
	Set ReciverDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ReciverDR")
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s Total=0
	s TotalFee=0
	s PNum=1
	s TRow=1
	s index=2
	s SMRowID=0
	s rowid=0
	s TJob=$J
	d BuildDataGetStoreMoveStat
	Quit $$$OK
BuildDataGetStoreMoveStat
	i vData="" q
	i StartDate>EndDate q
	i FromLocDR'=""
	{
		f  s SMRowID=$o(^DHCEQAMoveStock(0,"FromLoc",FromLocDR,SMRowID))  quit:SMRowID=""  d
		.s TToLocDR=$p($G(^DHCEQAMoveStock(SMRowID)),"^",5)
		.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
		.s TStatusDR=$p($G(^DHCEQAMoveStock(SMRowID)),"^",28)
		.q:TStatusDR="3"
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TMakeDate=$p($g(^DHCEQAMoveStock(SMRowID)),"^",7) //制单日期
		.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)
		.s TMoveType=$p($g(^DHCEQAMoveStock(SMRowID)),"^",14)
		.q:(MoveType'="")&&(TMoveType'=MoveType)
		.s rowid=0
		.f  s rowid=$o(^DHCEQAMoveStockList(0,"MoveStock",SMRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p($G(^DHCEQAMoveStockList(rowid)),"^",10)
		..s TModel=$p($G(^DHCEQAMoveStockList(rowid)),"^",5)  //add by wy 2018-1-31
		..d GetOneStoreMoveStat
	}
	else
	{
		f  s SMRowID=$o(^DHCEQAMoveStock(SMRowID))  quit:SMRowID=""  d
		.s TToLocDR=$p($G(^DHCEQAMoveStock(SMRowID)),"^",5)
		.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)
		.s TStatusDR=$p($G(^DHCEQAMoveStock(SMRowID)),"^",28)
		.q:TStatusDR="3"
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TMakeDate=$p($g(^DHCEQAMoveStock(SMRowID)),"^",7)
		.q:(TMakeDate>EndDate)||(TMakeDate<StartDate)
		.s TMoveType=$p($g(^DHCEQAMoveStock(SMRowID)),"^",14)
		.q:(MoveType'="")&&(TMoveType'=MoveType)
		.s rowid=0
		.f  s rowid=$o(^DHCEQAMoveStockList(0,"MoveStock",SMRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p($G(^DHCEQAMoveStockList(rowid)),"^",10)
		..s TModel=$p($G(^DHCEQAMoveStockList(rowid)),"^",5)  //add by wy 2018-1-31
		..d GetOneStoreMoveStat
	}
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		d ResetVariablesGetStoreMoveStat
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		s TRow="合计:"		
		i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
		s Data=$lb(TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMakeDate,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TJob,TApproveStep,TApproveRole,TRow,TUnit,TReciver,TFileNo,TEquipName,TModel,TShortDesc)
		Set ^CacheTemp(repid,TotalLoc)=Data
		Set ^DHCEQTemp("AMoveStockStat",User,TJob,PNum)=TSMNo_"^"_TFromLoc_"^"_TToLoc_"^"_TAccessory_"^"_TAccessoryType_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee_"^"_TUnit_"^"_TReciver_"^"_TFileNo_"^"_TEquipName_"^"_TModel_"^"_TShortDesc
	}
	quit
GetOneStoreMoveStat
	d ResetVariablesGetStoreMoveStat
	s TSMRowID=SMRowID
	s TSMNo=$ZCONVERT($p($g(^DHCEQAMoveStock(TSMRowID)),"^",1),"U") //转移单号
	q:(StoreMoveNo'="")&&($e(TSMNo,1,$l(StoreMoveNo))'=StoreMoveNo)
	s TFromLocDR=$p($g(^DHCEQAMoveStock(TSMRowID)),"^",4) 
	s TToLocDR=$p($g(^DHCEQAMoveStock(TSMRowID)),"^",5)
	s Flag=0
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromLocDR))) s Flag=Flag+1 
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToLocDR))) s Flag=Flag+1 
	q:Flag=2
	q:##class(web.DHCEQCommon).FundsTypeIsIn(11,rowid)	// Mozy0231	访问资金来源类型
	i TFromLocDR'="" s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLocDR)
	i TToLocDR'="" s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLocDR)
	s TMakeDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAMoveStock(TSMRowID)),"^",7),"date")
	s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(TSMRowID)),"^",2)
	q:(AccessoryTypeDR'="")&&(AccessoryTypeDR'=TAccessoryTypeDR)
	s result=##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
	q:+result'=0
	i TAccessoryTypeDR '=""  d
	.s TAccessoryType = $p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQAMoveStock(TSMRowID)),"^",28)
	s ItemDR=$p($G(^DHCEQAMoveStockList(rowid)),"^",2) //配件
	s TAccessory=$ZCONVERT($p($G(^DHCEQAMoveStockList(rowid)),"^",4),"U") //配件名称
	q:(Name'="")&(TAccessory'[Name)	
	s TShortDesc = $ZCONVERT($p($g(^DHCEQCCode("DHCEQCAccessory",$p(^DHCEQAMoveStockList(rowid),"^",2))),"^",3),"U")
	q:(ShortDesc'="")&&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(ShortDesc,"U"))
	/// 2017-2-7	Mozy	???????????
	s TReciverDR=$p($g(^DHCEQAMoveStock(TSMRowID)),"^",15)
	q:(ReciverDR'="")&(TReciverDR'=ReciverDR)
	i TReciverDR'="" s TReciver=##Class(web.DHCEQCommon).GetTrakNameByID("user", TReciverDR)
	s TEquipDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",16)
	i TEquipDR'="" d
	.s TEquipName=$ZCONVERT($p($g(^DHCEQEquip(TEquipDR)),"^",1),"U")
	.s TFileNo=$ZCONVERT($p($g(^DHCEQEquip(TEquipDR)),"^",85),"U")
	s TUnitDR=$p($g(^DHCEQAMoveStockList(rowid)),"^",6)
	i TUnitDR '="" s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	
	s TPrice=$p($G(^DHCEQAMoveStockList(rowid)),"^",10)
	s TModel=$p($G(^DHCEQAMoveStockList(rowid)),"^",5)   //add by wy 2018-1-31
	s TQuantityNum=$p($G(^DHCEQAMoveStockList(rowid)),"^",11)
	s TTotalFee=TPrice*TQuantityNum
	s Total=Total+TQuantityNum
	s TotalFee=TotalFee+TTotalFee
		
	//格式化金额为小数点两位
	i TQuantityNum'="" s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)	/// 2017-2-7	Mozy	?????
	i TPrice'="" s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
	i TStatus'=0
	{
		s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("11",TSMRowID) //11:配件转移
		i ApproveInfo'=""
		{
			s TApproveRole=$p(ApproveInfo,"^",9)
			s TApproveStep=$p(ApproveInfo,"^",5)
			i TApproveRole="" s TApproveRole="提交"     ;add by kdf 2017-11-22 需求号：474205
		}
	}
	s TStatus=##Class(web.DHCEQAInStock).GetAInStockStatusList(TStatus)
	
	d OutputRowGetStoreMoveStat
	quit
OutputRowGetStoreMoveStat
	s Data=$lb(TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMakeDate,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TJob,TApproveStep,TApproveRole,TRow,TUnit,TReciver,TFileNo,TEquipName,TModel,TShortDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("AMoveStockStat",User,TJob,PNum)=TSMNo_"^"_TFromLoc_"^"_TToLoc_"^"_TAccessory_"^"_TAccessoryType_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee_"^"_TUnit_"^"_TReciver_"^"_TFileNo_"^"_TEquipName_"^"_TModel_"^"_TShortDesc
	s PNum=PNum+1
	s TRow=TRow+1
	quit
ResetVariablesGetStoreMoveStat
	s (TSMRowID,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TSMNo,TMakeDate,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TApproveStep,TApproveRole,TCommonName,TUnit,TReciver,TFileNo,TEquipName,TModel,TShortDesc)=""
	quit
}

ClassMethod GetStoreMoveStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetStoreMoveStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOneStoreMoveStat(PNum, job)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i PNum=0 q $o(^DHCEQTemp("AMoveStockStat",User,job,""),-1)
	q $g(^DHCEQTemp("AMoveStockStat",User,job,PNum))
}

ClassMethod MoveTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>出库</option>"
	w "<option value=1>库房调配</option>"
	w "<option value=2>退库</option>"
	w "</select>",!
}

/// Mozy003008	1268136		2020-04-09 		修正状态描述
ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"") //add hly 2019-04-26
	w "<option value=></option>"
	i (Type="0")||(Type="") w "<option value=0>新增</option>"
	;i Type'="2" w "<option value=1>提交</option>"
	w "<option value=1>提交</option>"
	w "<option value=2>审核</option>"
	w "</select>",!
}

}
