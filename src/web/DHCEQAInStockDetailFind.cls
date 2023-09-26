Class web.DHCEQAInStockDetailFind Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Mozy	984422	2019-8-5	增加简称和采购人
/// modefy BY:GBX GBX0013 配件入库详细查询
/// d ##Class(%ResultSet).RunQuery("web.DHCEQAInStockDetailFind","GetInStockDetail")
Query GetInStockDetail(vData As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TAccessoryTypeDR:%String,TAccessoryType:%String,TStatus:%String,TAccessory:%String,TPrice:%String,TQuantityNum:%String,TTotalFee:%String,TJob:%String,TApproveStep:%String,TApproveRole:%String,TInvoice:%String,TRow:%String,TShortDesc:%String,TBuyUser:%String")
{
}

ClassMethod GetInStockDetailExecute(ByRef qHandle As %Binary, vData As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	
	k ^DHCEQTemp("AInStockDetail",+$H,$j)  //打印用临时globle
	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
	Set LocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"LocDR")
	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
	Set MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	Set MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")
	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
	Set Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	Set AccessoryTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"AccessoryTypeDR")
	Set InStockNo=##Class(web.DHCEQCommon).GetDataByName(vData,"InStockNo") //入库单号
	Set InvoiceNos=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNos") //发票号
	Set ChkNoInvoice=##Class(web.DHCEQCommon).GetDataByName(vData,"ChkNoInvoice")
	Set BuyUserDR=##Class(web.DHCEQCommon).GetDataByName(vData,"BuyUserDR")		//Mozy	2017-2-2
	Set ShortDesc=##Class(web.DHCEQCommon).GetDataByName(vData,"ShortDesc")
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s index=2
	s ISRowID=0
	s rowid=0
	s Total=0
	s TotalFee=0
	s PNum=1
	s TRow=1
	s TJob=$J
	d BuildDataGetInStockDetail
	Quit $$$OK
BuildDataGetInStockDetail
	i vData="" q
	i StartDate>EndDate q
	i ProviderDR'=""
	{
		f  s ISRowID=$o(^DHCEQAInStock(0,"Provider",ProviderDR,ISRowID))  quit:ISRowID=""  d
		.s TLocDR=$p(^DHCEQAInStock(ISRowID),"^",3)
		.q:(LocDR'="")&&(LocDR'=TLocDR)
		.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
		.s TStatusDR=$p(^DHCEQAInStock(ISRowID),"^",16)
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TInDate=$p($g(^DHCEQAInStock(ISRowID)),"^",1)
		.q:(TInDate>EndDate)||(TInDate<StartDate)
		.s TAccessoryTypeDR=$p($g(^DHCEQAInStock(ISRowID)),"^",2)
		.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQAInStockList(0,"AInStock",ISRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
		..q:(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(TPrice<MinPrice)
		..d GetOneInStockDetail		
	}
	else
	{
		f  s ISRowID=$o(^DHCEQAInStock(ISRowID))  quit:ISRowID=""  d
		.s TLocDR=$p(^DHCEQAInStock(ISRowID),"^",3)
		.q:(LocDR'="")&&(LocDR'=TLocDR)
		.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
		.s TStatusDR=$p(^DHCEQAInStock(ISRowID),"^",16)
		.q:(Status'="")&&(TStatusDR'=Status)
		.s TInDate=$p($g(^DHCEQAInStock(ISRowID)),"^",1)
		.q:(TInDate>EndDate)||(TInDate<StartDate)
		.s TAccessoryTypeDR=$p($g(^DHCEQAInStock(ISRowID)),"^",2)
		.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR))
		.s rowid=0
		.f  s rowid=$o(^DHCEQAInStockList(0,"AInStock",ISRowID,rowid))  quit:rowid=""  d
		..s TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
		..q:(MaxPrice'="")&&(TPrice>MaxPrice)
		..q:(MinPrice'="")&&(TPrice<MinPrice)
		..d GetOneInStockDetail	
	}
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")  //将'401001'改为'301006'. Modified By HZY 2012-04-23 HZY0027.公司测试出的Bug.
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		d ResetVariablesGetInStockDetail
		s TQuantityNum=Total
		s TTotalFee=TotalFee
		s TRow="合计:"
		s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TJob,TApproveStep,TApproveRole,TInvoice,TRow,TShortDesc,TBuyUser)
		Set ^CacheTemp(repid,TotalLoc)=Data
		Set ^DHCEQTemp("AInStockDetail",+$H,TJob,PNum)=TISNo_"^"_TLoc_"^"_TAccessory_"^"_TAccessoryType_"^"_TProvider_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee_"^"_TShortDesc_"^"_TBuyUser_"^"_TInvoice	// MZY0125	2623935		2022-06-08
	}
	quit
GetOneInStockDetail
	d ResetVariablesGetInStockDetail
	s TISRowID=ISRowID
	q:##class(web.DHCEQCommon).FundsTypeIsIn(10,rowid)	// Mozy0231	访问资金来源类型
	s TProviderDR=$p($g(^DHCEQAInStock(TISRowID)),"^",8)
	q:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TInDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(TISRowID)),"^",1),"date")
	s TISNo=$p($g(^DHCEQAInStock(TISRowID)),"^",6) //入库单号
	q:(InStockNo'="")&&(TISNo'[InStockNo)
	s TLocDR=$p(^DHCEQAInStock(TISRowID),"^",3)
	i TLocDR'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	i TLoc'="" s TLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TLoc,"-")
	s TAccessoryTypeDR=$p($g(^DHCEQAInStock(TISRowID)),"^",2)
	q:(AccessoryTypeDR'="")&&(TAccessoryTypeDR'=AccessoryTypeDR)
	i TAccessoryTypeDR '=""  d
	.s TAccessoryType = $p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	s TStatus=+$p($g(^DHCEQAInStock(TISRowID)),"^",16)
	q:TStatus>2
	s TAccessory=$ZCONVERT($p(^DHCEQAInStockList(rowid),"^",4),"U") //配件名称
	q:(Name'="")&(TAccessory'[Name)
	i $p(^DHCEQAInStockList(rowid),"^",2)'="" s TShortDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",$p(^DHCEQAInStockList(rowid),"^",2))),"^",3)
	q:(ShortDesc'="")&&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(ShortDesc,"U"))
	//s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(3,rowid)
	//s TInvoice=$p(InvoiceInfo,"^",1)
	//s TInvoice=$p(^DHCEQAInStockList(rowid),"^",19) //发票号信息 modify BY：GBX 2014-8-20 10:18:57
	;Modified By QW20210917 BUG:QW0153 begin 修改取发票数量及相关信息
	s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(3,rowid)
	s InvoiceLen=$l(InvoiceInfo,"&")
	for i=1:1:InvoiceLen d
	.s Invoice=$p(InvoiceInfo,"&",i)
	.i TInvoice'="" s TInvoice=TInvoice_","
	.s TInvoice=TInvoice_$p(Invoice,"^",1)
	q:(ChkNoInvoice="Y")&&(TInvoice'="")
	q:(InvoiceNos'="")&&((","_TInvoice_",")'[(","_InvoiceNos_","))	
	;Modified By QW20210917 BUG:QW0153 end
	//Mozy	2017-2-2
	s TBuyUserDR=$p($g(^DHCEQAInStock(TISRowID)),"^",11)
	q:(BuyUserDR'="")&(BuyUserDR'=TBuyUserDR)
	s TBuyUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TBuyUserDR)
	s TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
	s TQuantityNum=$p(^DHCEQAInStockList(rowid),"^",9)
	s TTotalFee=TPrice*TQuantityNum
	s Total=Total+TQuantityNum
	s TotalFee=TotalFee+TTotalFee
	
	//格式化金额为小数点两位
	i TQuantityNum'="" s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)	//Mozy	2017-2-2
	i TPrice'="" s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
	i TotalFee'="" s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"",4)	
	i TStatus'=0  d
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("10",TISRowID)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	s TStatus=##Class(web.DHCEQAInStock).GetAInStockStatusList(TStatus)
	
	d OutputRowGetInStockDetail
	quit
OutputRowGetInStockDetail
	s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TJob,TApproveStep,TApproveRole,TInvoice,TRow,TShortDesc,TBuyUser)
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("AInStockDetail",+$H,TJob,PNum)=TISNo_"^"_TLoc_"^"_TAccessory_"^"_TAccessoryType_"^"_TProvider_"^"_TPrice_"^"_TQuantityNum_"^"_TTotalFee_"^"_TShortDesc_"^"_TBuyUser_"^"_TInvoice	// MZY0125	2623935		2022-06-08
	Set PNum=PNum+1
	Set TRow=TRow+1
	Set index=index+1
	quit
ResetVariablesGetInStockDetail
	s (TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,TAccessory,TPrice,TQuantityNum,TTotalFee,TUseYearsNum,TISRowID,TApproveStep,TApproveRole,TFunds,TCommonName,TInvoice,TShortDesc,TBuyUser)=""
	quit
}

ClassMethod GetInStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockDetailExecute ]
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

ClassMethod GetInStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"") //add hly 2019-04-26
	w "<option value=></option>"
	i (Type="")||(Type="0")||(Type="4") w "<option value=0>"_##Class(web.DHCEQAInStock).GetAInStockStatusList(0)_"</option>"
	;i Type'="2" w "<option value=1>"_##Class(web.DHCEQAInStock).GetAInStockStatusList(1)_"</option>"
	w "<option value=1>"_##Class(web.DHCEQAInStock).GetAInStockStatusList(1)_"</option>"
	w "<option value=2>"_##Class(web.DHCEQAInStock).GetAInStockStatusList(2)_"</option>"
	;w "<option value=3>"_##Class(web.DHCEQAInStock).GetAInStockStatusList(3)_"</option>"
	w "</select>",!
}

ClassMethod GetOneInStockDetail(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("AInStockDetail",+$H,job,""),-1)
	q $g(^DHCEQTemp("AInStockDetail",+$H,job,PNum))
}

}
