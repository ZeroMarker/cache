Import SQLUser

/// 创建人:Mozy 2019-10-17
/// 配件管理HisUI改造	Maintenance Parts
/// 配件项
Class web.DHCEQ.MP.BUSAccessory Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// MZY0040	1408950		2020-7-21	配件采购合同
/// 配件入库业务明细配件项列表(时间倒序)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSAccessory","GetAccessoryList","")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSAccessory","GetAccessoryList","放射防护服",53,6,11)
Query GetAccessoryList(Desc As %String = "", TypeDR As %String = "", ProviderDR As %String = "", AISLRowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TShortDesc:%String,TModel:%String,TBaseUOM:%String,TBaseUOMDR:%String,TCurBPrice:%String,TCat:%String,TManuFactory:%String,TManuFactoryDR:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TType:%String,TSerialFlag:%String,TCTLRowID:%String,TContractNo:%String,TQuantityNum:%String")
{
}

ClassMethod GetAccessoryListExecute(ByRef qHandle As %Binary, Desc As %String = "", TypeDR As %String = "", ProviderDR As %String = "", AISLRowID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	;s ^DHCEQMozy("web.DHCEQ.MP.BUSAccessory.GetAccessoryList")=Desc_","_TypeDR_","_ProviderDR_","_AISLRowID
	
	s ContractDR=0
	f  s ContractDR=$o(^DHCEQContract(0,"Status",2,ContractDR)) quit:ContractDR=""  d
	.;s TContractName=$p($g(^DHCEQContract(ContractDR)),"^",1)
	.q:$p($g(^DHCEQContract(ContractDR)),"^",39)'=0	//0:采购合同,1:保修合同,2:协议合同,3:投放合同
	.q:$p($g(^DHCEQContract(ContractDR)),"^",53)'=4	//1:设备合同,2:工程合同,3:软件合同,4:配件合同
	.q:(ProviderDR'="")&&(ProviderDR'=$p($g(^DHCEQContract(ContractDR)),"^",18))
	.s clrowid=0
	.f  s clrowid=$o(^DHCEQContractList(0,"Contract",ContractDR,clrowid)) quit:clrowid=""  d
	..d ResetVariablesGetAccessoryList
	..s TCTLRowID=clrowid
	..s rowid=$p($g(^DHCEQContractList(clrowid)),"^",17)
	..q:rowid=""
	..s TContractNo=$p($g(^DHCEQContract(ContractDR)),"^",2)
	..s TQuantityNum=$p($g(^DHCEQContractList(clrowid)),"^",7)-##Class(web.DHCEQ.MP.BUSInStock).GetAInListQuantity(clrowid, AISLRowID)
	..q:TQuantityNum'>0
	..d SetAccessoryList
	
	s rowid=""  
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessory",rowid),-1) quit:(rowid=0)||(rowid="")  d
	.d ResetVariablesGetAccessoryList
	.d SetAccessoryList
	
	Quit $$$OK
SetAccessoryList
	s TRowID = rowid
	s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",77)
	q:InvalidFlag="Y"
	s TCode = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",1)
	s TDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",2)
	s TShortDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",3)
	;q:(Desc'="")&&(($ZCONVERT(TCode ,"U")'[$ZCONVERT(Desc,"U"))&($ZCONVERT(TDesc,"U")'[$ZCONVERT(Desc,"U"))&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(Desc,"U")))
	q:(Desc'="")&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(Desc,"U"))&($ZCONVERT(TDesc,"U")'[$ZCONVERT(Desc,"U"))
	s TType = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",14)
	q:(TypeDR'="")&&(TypeDR'=TType)
	Quit:##Class(web.DHCEQACommon).AccessoryTypeIsIn(TType)
	i TType'="" s TType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TType)),"^",2)
	s TCat = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",15)
	i TCat'="" s TCat=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",TCat)),"^",3)
	s TCurBPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",10)
	i TCurBPrice'="" s TCurBPrice=##Class(web.DHCEQCommon).FormatNumber(TCurBPrice,"",2)	// Mozy		2019-10-18
	s TModel = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",4)
	s TBaseUOMDR = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",5)
	i TBaseUOMDR'="" s TBaseUOM=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
	s TManuFactoryDR = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",27)
	i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)  //CZF0093
	s TSerialFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",35)	;##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",35),"bool")
	s TRemark = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",70)
	s THold1 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",78)
	s THold2 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",79)
	s THold3 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",80)
	q:THold3=""	;MZY0029	1340070		2020-05-29
	s THold4 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",81)
	s THold5 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",82)
	d OutputRowGetAccessoryList
	Quit
OutputRowGetAccessoryList
	Set Data=$lb(TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TCurBPrice,TCat,TManuFactory,TManuFactoryDR,THold1,THold2,THold3,THold4,THold5,TType,TSerialFlag,TCTLRowID,TContractNo,TQuantityNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAccessoryList
	Set (TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TCurBPrice,TCat,TManuFactory,TManuFactoryDR,THold1,THold2,THold3,THold4,THold5,TType,TSerialFlag,TCTLRowID,TContractNo,TQuantityNum)=""
	quit
}

ClassMethod GetAccessoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAccessoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
