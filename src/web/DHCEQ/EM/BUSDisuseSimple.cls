/// 名称: web.DHCEQ.EM.BUSDisuseSimple
/// 描述: 设备批量报废
/// 编写者：KDF
/// 编写日期: 2018-10-29
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSDisuseSimple Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetDisuseType(Desc As %String = "") As %SQLQuery(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String")
{
SELECT 
       DR_RowID,
       DR_Desc,
	   DR_Code
FROM sqluser.DHC_EQCDisuseType
where DR_InvalidFlag = 'N' and DR_Desc like nvl(:para,'')||'%'
}

/// Add By KDF 2018-10-29
/// 描述: 多批报废明细query
/// 入参:报废单ID
/// 访问表：DHC_EQDisuseList
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSDisuseSimple","DisuseList",2)
Query DisuseList(RowID As %String = "") As %Query(ROWSPEC = "TRow:%String,RowID:%String,DLRowID:%String,TSourceType:%String,TSourceID:%String,TSource:%String,TModel:%String,TManuFactory:%String,TUnit:%String,TProvider:%String,TLimitYears:%String,TInDate:%String,TQtyNum:%String,TTotalFee:%String,TUseState:%String,TDisuseReason:%String,TDisuseDate:%String,TRemark:%String,TOriginalFee:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TJob:%String,TEquipIDs:%String,TNo:%String,TSourceTypeDR:%String")
{
}

ClassMethod DisuseListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,DLRowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
		
	s TJob=$J
	s (TRow,TotalQty,Amount)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	
	if RowID'=""  d
	.s DLRowID=0
	.f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",RowID,DLRowID))  quit:DLRowID=""  d
	..d ResetVariablesGetDisuseList
	..s TRow=TRow+1
	..
	..s TSourceType=$p($g(^DHCEQDisuseList(DLRowID)),"^",2)
	..s TSourceTypeDR=TSourceType
	..s TSourceID=$p($g(^DHCEQDisuseList(DLRowID)),"^",3)
	..i TSourceType=0  d
	...s TSource=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	...s TManuFactory=$p($g(^DHCEQEquip(TSourceID)),"^",26)
	...s TModel=$p($g(^DHCEQEquip(TSourceID)),"^",3)
	...s TLimitYears=$p($g(^DHCEQEquip(TSourceID)),"^",31)
	...s TUnit=$p($g(^DHCEQEquip(TSourceID)),"^",5)
	...s TProvider=$p($g(^DHCEQEquip(TSourceID)),"^",25)
	...s TInDate = $p($g(^DHCEQEquip(TSourceID)),"^",45)
	...s TNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)			//Add By DJ 2016-04-25
	..e  d
	...s TSource=$p($g(^DHCEQInStockList(TSourceID)),"^",5)
	...s TManuFactory=$p($g(^DHCEQInStockList(TSourceID)),"^",6)
	...s TModel=$p($g(^DHCEQInStockList(TSourceID)),"^",9)
	...s TLimitYears=$p($g(^DHCEQInStockList(TSourceID)),"^",15)
	...s TUnit=$p($g(^DHCEQInStockList(TSourceID)),"^",10)
	...s TInStockDR=$p($g(^DHCEQInStockList(TSourceID)),"^",1)
	...s TProvider=$p($g(^DHCEQInStock(TInStockDR)),"^",17)
	...s TInDate = $p($g(^DHCEQInStock(TInStockDR)),"^",13)
	...s TNo=$p($g(^DHCEQInStock(TInStockDR)),"^",14)			//Add By DJ 2016-04-25
	..
	..i TManuFactory'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactory)),"^",1)
	..i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..i TProvider'=""  s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	..i TUnit'="" s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..i TInDate'="" s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	..
	..
	..s TQtyNum=$p($g(^DHCEQDisuseList(DLRowID)),"^",4)
	..s TUseState=$p($g(^DHCEQDisuseList(DLRowID)),"^",5)
	..s TDisuseReason=$p($g(^DHCEQDisuseList(DLRowID)),"^",6)
	..s TDisuseDate=$p($g(^DHCEQDisuseList(DLRowID)),"^",7)
	..s TRemark=$p($g(^DHCEQDisuseList(DLRowID)),"^",8)
	..s THold1=$p($g(^DHCEQDisuseList(DLRowID)),"^",9)
	..s THold2=$p($g(^DHCEQDisuseList(DLRowID)),"^",10)
	..s THold3=$p($g(^DHCEQDisuseList(DLRowID)),"^",11)
	..s THold4=$p($g(^DHCEQDisuseList(DLRowID)),"^",12)
	..s THold5=$p($g(^DHCEQDisuseList(DLRowID)),"^",13)
	..
	..s TTotalFee=TQtyNum*THold1
	..
	..s TotalQty=TotalQty+TQtyNum
	..s Amount=Amount+TTotalFee
	..
	..s TEquipIDs=$g(^DHCEQDisuseList(DLRowID,"EX"))
	..
	..d OutputRowGetDisuseList
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetDisuseList
	.s TRow=1
	.d OutputRowGetDisuseList
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetDisuseList
	.s DLRowID=-1
	.s TRow="合计"
	.s TQtyNum=TotalQty
	.s TTotalFee=Amount
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.d OutputRowGetDisuseList
	Quit $$$OK
	
OutputRowGetDisuseList
	i THold1'="" s THold1=##Class(web.DHCEQCommon).FormatNumber(THold1,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	
	s Data=$lb(TRow,RowID,DLRowID,TSourceType,TSourceID,TSource,TModel,TManuFactory,TUnit,TProvider,TLimitYears,TInDate,TQtyNum,TTotalFee,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TJob,TEquipIDs,TNo,TSourceTypeDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseList
	s (TSourceType,TSourceID,TSource,TModel,TManuFactory,TUnit,TProvider,TLimitYears,TInDate,TQtyNum,TTotalFee,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TEquipIDs,TNo,TSourceTypeDR)=""
	quit
}

ClassMethod DisuseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisuseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod DisuseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisuseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
