Class web.DHCEQAInStock Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 595;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AIS_RowID";

Parameter SQLROWID = "AIS_RowID";

Parameter SQLDESCRIPTION = "AIS_RowID";

/// d ##class(%ResultSet).RunQuery("web.DHCEQAInStock","GetAInStock","","","","")
Query GetAInStock(WaitAD, ApproveRole, InStockNo, LocDR, Status, StartDate, EndDate, BuyLocDR) As %Query(ROWSPEC = "TRowID:%String,TInStockNo:%String,TInDate:%String,TAccessoryTypeDR:%String,TAccessoryType:%String,TLocDR:%String,TLoc:%String,TInType:%String,TProviderDR:%String,TProvider:%String,TBuyLocDR:%String,TBuyLoc:%String,TBuyUserDR:%String,TBuyUser:%String,TStatus:%String,TRemark:%String,TRequestUserDR:%String,TRequestUser:%String,TRequestDate:%String,TSourceID:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectUser:%String,TRejectDate:%String,TRejectTime:%String,TAddUserDR:%String,TAddUser:%String,TAddDate:%String,TAddTime:%String,TSubmitUserDR:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditUser:%String,TAuditDate:%String,TAduitTime:%String,TTotal:%String,TNum:%String,TFee:%String,TRow:%String,TBackGroupColor:%String,TApprovals:%String")
{
}

ClassMethod GetAInStockExecute(ByRef qHandle As %Binary, WaitAD, ApproveRole, InStockNo, LocDR, Status, StartDate, EndDate, BuyLocDR) As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
 	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("10")
 	// Mozy	888605	2019-5-21	Hisui改造
	Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	Set index=1
	Set TRow=1
	Set rowid=0
	Do BuildDataGetAInStock
	Quit $$$OK
BuildDataGetAInStock 
	For  Set rowid=$Order(^DHCEQAInStock(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetAInStock
	.Set TRowID = rowid
	.If StartDate="" Set StartDate=0
	.If EndDate="" Set EndDate=+$h
	.Quit:($Piece($Get(^DHCEQAInStock(rowid)),"^",1)>EndDate)||($Piece($Get(^DHCEQAInStock(rowid)),"^",1)<StartDate)
	.Set TInStockNo = $Piece($Get(^DHCEQAInStock(rowid)),"^",6)
	.q:TInStockNo="" 
	.q:(InStockNo'="")&&($e(TInStockNo,1,$l(InStockNo))'=InStockNo)
	.Set TInDate = ##class(web.DHCEQCommon).TransValueToPage($Piece($Get(^DHCEQAInStock(rowid)),"^",1),"date")
	.Set TAccessoryTypeDR=$Piece($Get(^DHCEQAInStock(rowid)),"^",2)
	.// Mozy	888605	2019-5-21	Hisui改造
	.q:(##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)'=0)
	.s TAccessoryType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
	.Set TLocDR = $Piece($Get(^DHCEQAInStock(rowid)),"^",3)
	.Quit:(LocDR'="")&&(LocDR'=TLocDR)
	.Set TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.s TRequestUserDR = $p($g(^DHCEQAInStock(rowid)),"^",4)
	.s TRequestUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(rowid)),"^",5),"date")
	.Set TInType = $Piece($Get(^DHCEQAInStock(rowid)),"^",7)
	.Set TInType = ..GetInType(TInType)
	.Set TProviderDR = $Piece($Get(^DHCEQAInStock(rowid)),"^",8)
	.Set TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.Set TSourceID = $Piece($Get(^DHCEQAInStock(rowid)),"^",9)
	.Set TBuyLocDR = $Piece($Get(^DHCEQAInStock(rowid)),"^",10)
	.Quit:(BuyLocDR'="")&&(BuyLocDR'=TBuyLocDR)
	.Set TBuyLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TBuyLocDR)
	.Set TBuyUserDR = $Piece($Get(^DHCEQAInStock(rowid)),"^",11)
	.Set TBuyUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBuyUserDR)
	.s TRejectReason = $Piece($Get(^DHCEQAInStock(rowid)),"^",12)
	.s TRejectUserDR = $p($g(^DHCEQAInStock(rowid)),"^",13)
	.s TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	.s TRejectDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(rowid)),"^",14),"date")
	.s TRejectTime = $Piece($Get(^DHCEQAInStock(rowid)),"^",15)
	.Set TStatus = $Piece($Get(^DHCEQAInStock(rowid)),"^",16)
	.q:TStatus=3		//Add By DJ 2018-10-18 作废单据过滤
	.q:(WaitAD="on")&&(TStatus="0")
	.Quit:(Status'="")&&(Status'=TStatus)
	.Set TStatus=##Class(web.DHCEQAInStock).GetAInStockStatusList(TStatus)
	.s TAddUserDR = $p($g(^DHCEQAInStock(rowid)),"^",17)
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(rowid)),"^",18),"date")
	.s TAddTime = $Piece($Get(^DHCEQAInStock(rowid)),"^",19)
	.s TSubmitUserDR = $p($g(^DHCEQAInStock(rowid)),"^",20)
	.s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	.s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(rowid)),"^",21),"date")
	.s TSubmitTime = $Piece($Get(^DHCEQAInStock(rowid)),"^",22)
	.s TAuditUserDR = $p($g(^DHCEQAInStock(rowid)),"^",23)
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(rowid)),"^",24),"date")
	.s TAduitTime = $Piece($Get(^DHCEQAInStock(rowid)),"^",25)
	.Set TRemark = $Piece($Get(^DHCEQAInStock(rowid)),"^",26)
	.
	.s result=0		// Mozy0231	访问资金来源类型
	.;Set TTotal=..GetOneInStockTotalFeeNum(rowid)
	.;Set TNum=$Piece(TTotal,"^",1)
	.;Set TFee=$Piece(TTotal,"^",2)
	.;设置行背景色	Mozy	2016-6-14
	.s lrowid=""
	.For  Set lrowid=$Order(^DHCEQAInStockList(0,"AInStock",rowid,lrowid)) Quit:(lrowid="")||(TBackGroupColor'="")  Do
	..i ($d(^DHCEQMMaintPart(0,"AInStockList",lrowid)))&&(##Class(web.DHCEQM.DHCEQMMaintPart).BussPrintInfo("A01",rowid)=0) s TBackGroupColor="#00ffff"
	..s result=##class(web.DHCEQCommon).FundsTypeIsIn(10,lrowid)
	.q:+result'=0
	.s TApprovals="无"
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.i AIRowID'="" d
	..s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..s TApproveRoleDR=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRoleDR'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR),"^",2)	//add by CZF0080 2020-02-24
	.i $Piece($Get(^DHCEQAInStock(rowid)),"^",16)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	.i ((WaitAD="on")&&(CurRole'="")) q:CurRole'=ApproveRole
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("10",rowid)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	.DO OutputRowGetAInStock
	Quit
OutputRowGetAInStock
	Set Data=$ListBuild(TRowID,TInStockNo,TInDate,TAccessoryTypeDR,TAccessoryType,TLocDR,TLoc,TInType,TProviderDR,TProvider,TBuyLocDR,TBuyLoc,TBuyUserDR,TBuyUser,TStatus,TRemark,TRequestUserDR,TRequestUser,TRequestDate,TSourceID,TRejectReason,TRejectUserDR,TRejectUser,TRejectDate,TRejectTime,TAddUserDR,TAddUser,TAddDate,TAddTime,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAduitTime,TTotal,TNum,TFee,TRow,TBackGroupColor,TApprovals)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesGetAInStock
	Set (CurRole,TRowID,TInStockNo,TInDate,TAccessoryTypeDR,TAccessoryType,TLocDR,TLoc,TInType,TProviderDR,TProvider,TBuyLocDR,TBuyLoc,TBuyUserDR,TBuyUser,TStatus,TRemark,TRequestUserDR,TRequestUser,TRequestDate,TSourceID,TRejectReason,TRejectUserDR,TRejectUser,TRejectDate,TRejectTime,TAddUserDR,TAddUser,TAddDate,TAddTime,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAduitTime,TTotal,TNum,TFee,TBackGroupColor,TApprovals)=""
	Quit
}

ClassMethod GetAInStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAInStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy		888605	2019-5-21	Hisui改造
ClassMethod StatusList(name, width, Type, Value As %Library.String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	s selectedone=$case(Value,0:"selected",:"")
	s selectedtwo=$case(Value,1:"selected",:"")
	s selectedthree=$case(Value,2:"selected",:"")
	
	w "<option value=></option>"
	i (Type="")||(Type="0") w "<option value=0 "_selectedone_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(0)_"</option>"
	i Type'="2" w "<option value=1 "_selectedtwo_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(1)_"</option>"
	w "<option value=2 "_selectedthree_">"_##Class(web.DHCEQAInStock).GetAInStockStatusList(2)_"</option>"
	
	w "</select>",!
}

/// w ##Class(web.DHCEQAInStock).GetAInStockStatusList()
ClassMethod GetAInStockStatusList(Status)
{
	/// Mozy		888605	2019-5-21	Hisui改造
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"未定义")
}

ClassMethod GetAInStockStatus(AInStockDR As %Library.String = "")
{
	Quit:AInStockDR=""
	Set Status=""
	Set Status=$Piece($Get(^DHCEQAInStock(AInStockDR)),"^",22)

	Quit Status
}

ClassMethod InTypeList(name, width) As %String
{
	Write "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	
	Write "<option value=></option>"
	Write "<option value=0>采购</option>"
	;Write "<option value=1>盘盈</option>"
	Write "<option value=2>接受捐赠</option>"
	;Write "<option value=3>分解</option>"
	Write "<option value=9>其他</option>"
	Write "</select>",!
}

ClassMethod GetInType(InTypeDR)
{
	Quit $CASE(InTypeDR,"0":"采购","1":"盘盈","2":"接受捐赠","3":"分解","9":"其他",:"没有定义")
}

/*
ClassMethod GetOneInStockTotalFeeNum(ISRowID)
{
	If ISRowID="" Quit ""
	New ISLRowID,Fee,Num
	Set ISLRowID=""
	Set Fee=0
	Set Num=0
	For  Set ISLRowID=$Order(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) Quit:ISLRowID=""  Do
	.Set QuantityNum=$Piece(^DHCEQInStockList(ISLRowID),"^",8)
	.Set OriginalFee=$Piece(^DHCEQInStockList(ISLRowID),"^",7)
	.Set Fee=Fee+(QuantityNum*OriginalFee)
	.Set Num=Num+QuantityNum
	If Fee=0 Set Fee=""
	If Num=0 Set Num=""
	Quit Num_"^"_Fee
}*/
ClassMethod GetSysInfo(code)
{
	new rowid,Info
	s Info=""
	s rowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code",code,0))
	i rowid'="" s Info=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",2)
	q Info
}

/// 描述：设置从设备配件入库类型取默认值
/// 访问表:DHC_EQCAccessoryType
/// 输入：val：表RowID号
/// 输出：无
/// 返回：成功返回设备配件入库类型，失败返回0
/// 备注：
/// w ##Class(web.DHCEQAInStock).GetDefaultAccessoryType("1")
ClassMethod GetDefaultAccessoryType(val)
{
	Quit:val'="" $Piece($Get(^DHCEQCCode("DHCEQCAccessoryType",val)),"^",2)
	Quit 0
}

}
