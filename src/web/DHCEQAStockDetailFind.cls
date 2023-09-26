Class web.DHCEQAStockDetailFind Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQAStockDetailFind","GetAccessoryDetail","","","","动力手柄","","",""),Management As %String
Query GetAccessoryDetail(Type As %String = "", Status As %String = "", No As %String = "", Desc As %String = "", BatchNo As %String = "", SerialNo As %String = "", MinValue As %String = "", MaxValue As %String = "", AccessoryTypeDR As %String = "", Loc As %String = "", LocDR As %String = "", Management As %String = "", ShortDesc As %String = "", Model As %String = "", BillPage As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TLoc:%String,TLocDR:%String,TAccessoryType:%String,TAccessoryTypeDR:%String,TBaseUOM:%String,TBaseUOMDR:%String,TStdSPrice:%String,TCurProvider:%String,TCurProviderDR:%String,TBatchNo:%String,TExpiryDate:%String,TFinalBPrice:%String,TStock:%String,TBprice:%String,TSerialNo:%String,TNo:%String,TStatus:%String,TDisuseDate:%String,TInSourceID:%String,TToSourceID:%String,TDStock:%String,TRow:%String,TLocation:%String,TBillPage:%String,TModel:%String,TAmountFee:%String")
{
}

ClassMethod GetAccessoryDetailExecute(ByRef qHandle As %Binary, Type As %String = "", Status As %String = "", No As %String = "", Desc As %String = "", BatchNo As %String = "", SerialNo As %String = "", MinValue As %String = "", MaxValue As %String = "", AccessoryTypeDR As %String = "", Loc As %String = "", LocDR As %String = "", Management As %String = "", ShortDesc As %String = "", Model As %String = "", BillPage As %String = "") As %Status
{
	new repid, index, rowid,TAInStockListDR, TSerialFlag,TBatchFlag,TTStock,TTDStock
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s TRow=1
	s rowid=0
	;s TTStock=0
	s TTDStock=0
	s TStock=0
	s amountfee=0
	s gnum=1
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("GetAccessoryDetail",curuser)
	d BuildDataGetGetAccessoryDetail
	Quit $$$OK
	
BuildDataGetGetAccessoryDetail
	f  s rowid=$o(^DHCEQAStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetGetAccessoryDetail
	.s TLocDR =	$p($g(^DHCEQAStock(rowid)),"^",1) //科室
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.i TLocDR'="" d
	..s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.q:((Loc'="")&&(TLoc'[Loc))  // add by jy  2015-12-21  JY0009
	.S TItemDR = $p($g(^DHCEQAStock(rowid)),"^",2) //配件项ID
	.i TItemDR'="" d
	..s TBaseUOMDR = $p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",5)
	..i TBaseUOMDR '="" s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",(TBaseUOMDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	..s TStdSPrice	=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",7)  //标准单价
	.S TCode = $p($g(^DHCEQAStock(rowid)),"^",3)
	.S TDesc = $p($g(^DHCEQAStock(rowid)),"^",4) //名称
	.q:(Desc'="")&&(TDesc'[Desc)
	.S TAccessoryTypeDR = $p($g(^DHCEQAStock(rowid)),"^",5) //类组
	.q:##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
	.q:(AccessoryTypeDR'="")&&(AccessoryTypeDR'=TAccessoryTypeDR)
	.i TAccessoryTypeDR'="" d
	..S TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	.S TFinalBPrice = $p($g(^DHCEQAStock(rowid)),"^",7)  //最后进价
	.S TStock = $p($g(^DHCEQAStock(rowid)),"^",10) //库存
	.;s TTStock=TTStock+TStock 
	.q:(TStock=0)&&(Type="0")	// MZY0073	1781205		2021-04-26
	.s DRowID=0
	.f  s DRowID = $o(^DHCEQAStockDetail(0,"AStock",rowid,DRowID))  quit:DRowID=""  d
	..s TRowID= DRowID
	..s TItemDR=$p($g(^DHCEQAStockDetail(DRowID)),"^",2)
	..s TShortDesc=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",3)
	..q:(ShortDesc'="")&&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(ShortDesc,"U"))
	..s TAInStockListDR=$p($g(^DHCEQAStockDetail(DRowID)),"^",3)
	..i TAInStockListDR'="" d
	...s TSerialFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)
	...s TBatchFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",16)
	..q:(Management="0")&&(TSerialFlag="N")
	..q:(Management="1")&&(TBatchFlag="N")
	..S TBatchNo=$p($g(^DHCEQAStockDetail(DRowID)),"^",6)
	..q:(BatchNo'="")&&(TBatchNo'[BatchNo)
	..S TExpiryDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(DRowID)),"^",7),"date")
	..S TBprice = +$p($g(^DHCEQAStockDetail(DRowID)),"^",8)
	..q:(MinValue'="")&&(MinValue>TBprice)
	..q:(MaxValue'="")&&(MaxValue<TBprice)
	..S TSerialNo=$p($g(^DHCEQAStockDetail(DRowID)),"^",9)
	..q:(SerialNo'="")&&(TSerialNo'[SerialNo)
	..S TNo=$p($g(^DHCEQAStockDetail(DRowID)),"^",10)
	..q:(No'="")&&(TNo'[No)
	..s TStatus=$p($g(^DHCEQAStockDetail(DRowID)),"^",12)
	..q:(Type="0")&&((TStatus="2")||(TStatus="3"))
	..q:(Type="1")&&((TStatus="0")||(TStatus="1"))
	..q:(Status'="")&&(Status'="4")&&(Status'=TStatus)  //Modify by zx 2022-12-04 增加全部查询 2757110 
	..s TStatus=..GetStatus(TStatus)
	..S TModel = $p($g(^DHCEQAStockDetail(DRowID)),"^",15)
	..q:(Model'="")&&($ZCONVERT(TModel,"U")'[$ZCONVERT(Model,"U"))
	..s TCurProviderDR=$p($g(^DHCEQAStockDetail(DRowID)),"^",16)
	..i TCurProviderDR'="" s TCurProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TCurProviderDR)),"^",2)
	..S TDStock = +$p($g(^DHCEQAStockDetail(DRowID)),"^",17)
	..q:TDStock'>0
	..s TTDStock=TTDStock+TDStock	//库存合计
	..s TAmountFee=TBprice*TDStock
	..s amountfee=amountfee+TAmountFee
	..S TDisuseDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(DRowID)),"^",20),"date")		
	..S TInSourceID	= $p($g(^DHCEQAStockDetail(DRowID)),"^",23)
	..S TToSourceID	= $p($g(^DHCEQAStockDetail(DRowID)),"^",25)
	..S TLocation= $p($g(^DHCEQAStockDetail(DRowID)),"^",28)
	..S TBillPage= $p($g(^DHCEQAStockDetail(DRowID)),"^",29)
	..q:(BillPage'="")&&(TBillPage'=BillPage)
	..
	..If TModel ="" Do
	...Set ^DHCEQTemp("GetAccessoryDetail",curuser,TCode,"/",gnum)=$lb(TRowID,TDesc,TLoc,TLocDR,TAccessoryType,TAccessoryTypeDR,TBaseUOM,TBaseUOMDR,TStdSPrice,TCurProvider,TCurProviderDR,TBatchNo,TExpiryDate,TFinalBPrice,TStock,TBprice,TSerialNo,TNo,TStatus,TDisuseDate,TInSourceID,TToSourceID,TDStock,TRow,TLocation,TBillPage,TModel,TAmountFee)
	..Else  Do
	...Set ^DHCEQTemp("GetAccessoryDetail",curuser,TCode,TModel,gnum)=$lb(TRowID,TDesc,TLoc,TLocDR,TAccessoryType,TAccessoryTypeDR,TBaseUOM,TBaseUOMDR,TStdSPrice,TCurProvider,TCurProviderDR,TBatchNo,TExpiryDate,TFinalBPrice,TStock,TBprice,TSerialNo,TNo,TStatus,TDisuseDate,TInSourceID,TToSourceID,TDStock,TRow,TLocation,TBillPage,TModel,TAmountFee)
	..Set gnum=gnum+1
	
	/// 输出
	Set TCode=""
	For  Set TCode=$Order(^DHCEQTemp("GetAccessoryDetail",curuser,TCode)) Quit:TCode=""  Do
	.Set TModel=""
	.For  Set TModel=$Order(^DHCEQTemp("GetAccessoryDetail",curuser,TCode,TModel)) Quit:TModel=""  Do
	..Set gnum=""
	..For  Set gnum=$Order(^DHCEQTemp("GetAccessoryDetail",curuser,TCode,TModel,gnum)) Quit:gnum=""  Do
	...Set Data=$Get(^DHCEQTemp("GetAccessoryDetail",curuser,TCode,TModel,gnum))
	...Set $LIST(Data,24)=TRow			//序号
	...Set ^CacheTemp(repid,index)=Data
	...Set index=index+1
	...Set TRow=TRow+1
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")	// MZY0024	1312401		2020-05-09	修正系统参数取值
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesGetGetAccessoryDetail
		s TRow="合计:"
		s TDStock=TTDStock
		s TAmountFee=amountfee
		s Data=$lb(TRowID,TDesc,TLoc,TLocDR,TAccessoryType,TAccessoryTypeDR,TBaseUOM,TBaseUOMDR,TStdSPrice,TCurProvider,TCurProviderDR,TBatchNo,TExpiryDate,TFinalBPrice,TStock,TBprice,TSerialNo,TNo,TStatus,TDisuseDate,TInSourceID,TToSourceID,TDStock,TRow,TLocation,TBillPage,TModel,TAmountFee)
		Set ^CacheTemp(repid,TotalLoc)=Data
	}
	quit
ResetVariablesGetGetAccessoryDetail
	s (TRowID,DRowID,TDesc,TLoc,TLocDR,TAccessoryType,TAccessoryTypeDR,TBaseUOM,TBaseUOMDR,TStdSPrice,TCurProvider,TCurProviderDR,TBatchNo,TExpiryDate,TFinalBPrice,TStock,TBprice,TSerialNo,TNo,TStatus,TDisuseDate,TInSourceID,TToSourceID,TDStock,TLocation,TBillPage,TAmountFee)=""
	quit
}

ClassMethod GetAccessoryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryDetailExecute ]
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

ClassMethod GetAccessoryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// modify by wl 20190925 添加默认

ClassMethod StatusList(name, width, Type, value As %String = "") As %String
{
	s selectfir=$case(value,0:"selected",:"")
	s selectsec=$case(value,1:"selected",:"")
	s selectthi=$case(value,2:"selected",:"")
	s selectfou=$case(value,3:"selected",:"")
	s selectfiv=$case(value,4:"selected",:"")  //Modify by zx 2022-12-04 增加全部查询 2757110 
		;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	//hisui 改造 by wjt 2019-03-08
	w "<option value=></option>"
	i (Type="0") d
	.w "<option value=4 "_selectfiv_">全 部</option>"   //Modify by zx 2022-12-04 增加全部查询 2757110 
	.w "<option value=0 "_selectfir_" >在 库</option>"
	.w "<option value=1 "_selectsec_">在 用</option>"
	e  d 
	.w "<option value=2 "_selectthi_">消 耗</option>"
	.w "<option value=3 "_selectfou_">退 货</option>"
	;w "<option value=3>"_..GetStatus(3)_"</option>"
	w "</select>",!
}

ClassMethod ManagementStatusList(name, width) As %String
{
		;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>序列号管理</option>"
	w "<option value=1>批号管理</option>"
	w "</select>",!
}

ClassMethod GetStatus(Status)
{

	q $CASE(Status,"0":"在 库","1":"在 用","2":"消 耗","3":"退 货",:"没有定义")
}

/// d ##Class(web.DHCEQAStockFind).GetAccessoryList(5)
ClassMethod GetAccessoryList(ASDRowID)
{
	i ASDRowID="" q ""
	s (result,resultex,SerialFlag,BatchFlag,StartDate)=""
	s result=^DHCEQAStockDetail(ASDRowID)
	s AInStockListDR=$p(result,"^",3)
	i AInStockListDR'="" d
	.s SerialFlag=$p($g(^DHCEQAInStockList(AInStockListDR)),"^",15)
	.s SerialFlag=$Case(SerialFlag,"Y":"1","N":"0","":"0")
	.s BatchFlag=$p($g(^DHCEQAInStockList(AInStockListDR)),"^",16)
	.s BatchFlag=$Case(BatchFlag,"Y":"1","N":"0","":"0")
	.s StartDate=$p($g(^DHCEQAInStockList(AInStockListDR)),"^",17)
	;s StartDate=##class(web.DHCEQCommon).TransValueToPage(StartDate,"date")
	s resultex=resultex_"^"	;LocDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",1))
	s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;ExpiryDate
	s resultex=resultex_"^"	;AccessoryTypeDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryType",$p(result,"^",11))),"^",2)
	i $p(result,"^",12)'=""  d
	.s $p(result,"^",12)=$CASE($p(result,"^",12),"0":"在库","1":"在用","2":"消耗","3":"退货")
	s resultex=resultex_"^"	;BaseUOMDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",13))
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", $p(result,"^",14))	// MZY0027	1326285		2020-05-21
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",16))
	s $p(result,"^",19)=##class(web.DHCEQCommon).TransValueToPage(StartDate,"date")	;StartDate
	s $p(result,"^",20)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",20),"date")	;DisuseDate
	s ItemDR=$p(result,"^",2)
	s AccessoryInfo=$g(^DHCEQCCode("DHCEQCAccessory",ItemDR))
	s TypeDR=$p(AccessoryInfo,"^",14)
	s TypeInfo=$g(^DHCEQCCode("DHCEQCAccessoryType",TypeDR))
	s FundsType=$p(result,"^",30)	;Mozy0236	2019-12-6
	i FundsType'="" s FundsType=$Piece($Get(^DHCEQCCode("DHCEQCFundsType",FundsType)),"^",2)
	q result_"^"_resultex_"^"_AccessoryInfo_"^"_SerialFlag_"^"_BatchFlag_"^"_TypeInfo_"^"_FundsType
	//////////////////////////////93/////////////94/////////////95/////////////
}

}
