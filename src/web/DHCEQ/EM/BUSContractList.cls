Class web.DHCEQ.EM.BUSContractList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-08-16
/// 描述：hisui改造 查询采购合同
/// 入参：Name 设备项名称
/// 		  AssetType 资产类型
/// 		  SourceType	合同类型 1:采购合同,2:协议合同,3:投放合同
/// 		  CheckDate 	日期
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSContractList","GetContractList","")
Query GetContractList(Name, AssetType As %Library.String = "", SourceType As %Library.String = "", CheckDate As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TModel:%String,TNum:%String,TProvider:%String,TManuFac:%String,TContractNo:%String,TCode:%String,TEquipType:%String,TEquipTypeDR:%String,TStatCat:%String,TStatCatDR:%String,TEquipCat:%String,TEquipCatDR:%String,TUnit:%String,TUnitDR:%String,TModelDR:%String,TProviderDR:%String,TManuFacDR:%String,TContractName:%String,TLimitYears:%String,TCommonName:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, Name, AssetType As %Library.String = "", SourceType As %Library.String = "", CheckDate As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	i CheckDate="" s CheckDate=+$h
 	s CheckDate=##class(web.DHCEQCommon).TransValueFromPage(CheckDate,"date") 	

	s index=1
	s rowid=0
	d BuildDataGetContractList
	Quit $$$OK
BuildDataGetContractList
	s TContractDR=0
	f  s TContractDR=$o(^DHCEQContract(0,"Status",2,TContractDR)) quit:TContractDR=""  d
	.s TContractName=$p($g(^DHCEQContract(TContractDR)),"^",1)
	.s TContractNo=$p($g(^DHCEQContract(TContractDR)),"^",2)
	.s TContractType=$p($g(^DHCEQContract(TContractDR)),"^",39)  //add by lmm 2107-07-18 405602
	.q:(TContractType'="0")&&(TContractType'=2)    // Mozy	 2108-10-30
	.q:(SourceType=1)&&(TContractType'=0)	//0:采购合同,1:保修合同,2:协议合同,3:投放合同 czf 20181109
	.q:(SourceType=4)&&(TContractType'=2)
	.q:(SourceType=5)&&(TContractType'=3)
	.s TStartDate=$p($g(^DHCEQContract(TContractDR)),"^",11)
	.s TEndDate=$p($g(^DHCEQContract(TContractDR)),"^",12)
	.q:(SourceType=4)&&((CheckDate<TStartDate)||(CheckDate>TEndDate))
	.s TProviderDR=$p($g(^DHCEQContract(TContractDR)),"^",18)
	.s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s rowid=0
	.f  s rowid=$o(^DHCEQContractList(0,"Contract",TContractDR,rowid)) quit:rowid=""  d
	..d ResetVariablesGetContractList
	..s TRowID=rowid
	..s ArriveNum=##class(web.DHCEQOpenCheck).GetArriveNum("","",rowid)
	..q:(TContractType=0)&&(ArriveNum'>0)
	..q:(TContractType=3)&&(ArriveNum'>0)
	..i TContractType="2" s ArriveNum=0	//协议合同数量为空,减了已经到货的数量会是负数.
	..s TCommonName = $p($g(^DHCEQContractList(rowid)),"^",2)	//2013-06-24 DJ0118
	..s ItemDR= $p($g(^DHCEQContractList(rowid)),"^",18)
	..s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1) //2013-06-24 DJ0118
	..s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
	..q:(Name'="")&&(TContractName'[Name)&&(TName'[Name)&&($e(TContractNo,1,$l(Name))'=Name)&&($ZCONVERT($e(TCode,1,$l(Name)),"U")'=Name)
	..s TModelDR = $p($g(^DHCEQContractList(rowid)),"^",3)
	..i TModelDR '=""  d
	...s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TManuFacDR = $p($g(^DHCEQContractList(rowid)),"^",4)
	..i TManuFacDR '=""  d
	...s TManuFac = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
	..s TNum=ArriveNum
	..s TEquipTypeDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	..q:((TEquipTypeDR'="")&&(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0))
	..i TEquipTypeDR '="" d
	...s TEquipType = $P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
	..s TStatCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
	..i TStatCatDR '="" d
	...s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	..Quit:(TStatCatDR'="")&&(AssetType'="")&&(AssetType'=0)&&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	///modified by GR0027 卫计委与武汉资产类型兼容 
	..s TEquipCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	..i TEquipCatDR '="" d
	...s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	..s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	..i TUnitDR'="" d
	...s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..
	..;Modified by jdl 2012-3-7 JDL0120
	..s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
	..
	..d OutputRowGetContractList
	quit
OutputRowGetContractList
	s Data=$lb(TName,TRowID,TModel,TNum,TProvider,TManuFac,TContractNo,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TProviderDR,TManuFacDR,TContractName,TLimitYears,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	s (TName,TRowID,TModel,TNum,TManuFac,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TCommonName)=""
	;s (TProvider,TContractNo,TProviderDR)=""
	s TLimitYears=""
	quit
}

ClassMethod GetContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListExecute ]
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

ClassMethod GetContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
