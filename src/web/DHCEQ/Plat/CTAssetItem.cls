/// add by zy 20180814  ZY0171
/// 产品库功能代码
Class web.DHCEQ.Plat.CTAssetItem Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Add by wsp 2016-4-12
/// 保存数据
/// w ##Class(web.DHCEQ.Plat.CtAssetItem).SaveData()
ClassMethod SaveData(val, IsDel)
{
	k PList
	new rowid,SQLCODE
	s SQLCODE=0
	s rowid=$P(val,"^",1)
	if IsDel=1
	{
		s PList(14)="Y"
		&SQL(Update sqluser.DHC_EQPLATCAssetItem values :PList() where AI_RowID=:rowid)
	}
	else
	{
		s PList(2)=$P(val,"^",2)
		s PList(3)=$P(val,"^",3)
		s PList(4)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",4),"bool")
		s PList(5)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",5),"bool")
		s PList(6)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",6),"bool")
		s PList(7)=$P(val,"^",7)
		s PList(8)=$P(val,"^",8)
		s PList(9)=$P(val,"^",9)
		s PList(10)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",10),"bool")
		s PList(11)=$P(val,"^",11)
		s PList(12)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",12),"date")
		s PList(13)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",13),"date")
		s PList(14)="N"
		s PList(15)=##Class(web.DHCEQCommon).TransValueFromPage($P(val,"^",15),"bool")
		s tmpid=""
		&SQL(select AI_RowID into :tmpid from sqluser.DHC_EQPLATCAssetItem where AI_Code=:PList(2) and AI_Desc=:PList(3) and AI_InvalidFlag<>'Y')
		if ((tmpid'="")&&(tmpid'=rowid)) q "0^"_tmpid	;重复记录
		i rowid=""
		{
			&SQL(Insert into SQLUser.DHC_EQPLATCAssetItem values :PList())
			s rowid=$g(%ROWID)
		}
		else
		{
			&SQL(Update sqluser.DHC_EQPLATCAssetItem values :PList() where AI_RowID=:rowid)
			i SQLCODE=100 s SQLCODE=0
		}
	}
	q SQLCODE_"^"_rowid
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQPC.DHCEQPCCAssetItem","GetAssetItem","","","","","","","","")
Query GetAssetItem(Code, Desc, AssetClass As %Library.String = "", DrugFlag As %Library.String = "", MedicalDeviceFlag As %Library.String = "", MeterageFlag As %Library.String = "", RadiationFlag As %Library.String = "") As %Query(ROWSPEC = "TRowID,TCode,TDesc,TAssetClassDR,TAssetClass,TRemark,TDateFrom,TDateTo,TInvalidFlag,TDrugFlag,TMedicalDeviceFlag,TMeterageFlag,TMICycleNum,TMICycleUnitDR,TMICycleUnit,TMICycle,TUnitDR,TUnit,TRadiationFlag,TInfectionFlag")
{
}

ClassMethod GetAssetItemExecute(ByRef qHandle As %Binary, Code, Desc, AssetClass As %Library.String = "", DrugFlag As %Library.String = "", MedicalDeviceFlag As %Library.String = "", MeterageFlag As %Library.String = "", RadiationFlag As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	//i DateFrom'="" s DateFrom=##Class(web.DHCEQCommon).TransValueFromPage(DateFrom,"date","3")
 	//i DateTo'="" s DateTo=##Class(web.DHCEQCommon).TransValueFromPage(DateTo,"date","3")
 	s rowid=0
 	f  s rowid=$O(^DHCEQPCCT("DHCEQPCCAssetItem",rowid)) q:rowid=""  d
 	.d ResetVariableGetAssetItem
 	.s TInvalidFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",14)
 	.q:TInvalidFlag="Y"
 	.s TRowID=rowid
 	.s TCode=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",1)
 	.s TDesc=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",2)
 	.q:(Code'="")&(TCode'[Code)
 	.q:(Desc'="")&(TDesc'[Desc)
 	.s TAssetClassDR=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",3)
 	.q:(AssetClass'="")&(TAssetClassDR'=AssetClass)
 	.i TAssetClassDR'="" s TAssetClass=$P(^DHCEQPCCT("DHCEQPCCAssetClass",TAssetClassDR),"^",2)
 	.s TDrugFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",4)
 	.q:(DrugFlag="Y")&(TDrugFlag'=DrugFlag)
 	.s TMedicalDeviceFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",5)
 	.q:(MedicalDeviceFlag="Y")&(TMedicalDeviceFlag'=MedicalDeviceFlag)
 	.s TMeterageFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",6)
 	.q:(MeterageFlag="Y")&(TMeterageFlag'=MeterageFlag)
 	.i TMeterageFlag="Y" d
 	..s TMICycleNum=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",7)
 	..s TMICycleUnitDR=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",8)
 	..i TMICycleUnitDR'="" s TMICycleUnit=$P(^DHCEQCCode("DHCEQCCycleUnit",TMICycleUnitDR),"^",2)
 	..s TMICycle=TMICycleNum_TMICycleUnit
 	.s TUnitDR=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",9)
 	.i TUnitDR'="" s TUnit=$P(^DHCEQCCode("DHCEQCUOM",TUnitDR),"^",4)
 	.s TRadiationFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",10)
 	.q:(RadiationFlag="Y")&(TRadiationFlag'=RadiationFlag)
 	.s TRemark=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",11)
 	.s TDateFrom=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",12)
 	.s TDateTo=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",13)
 	.i TDateFrom'="" s TDateFrom=##Class(web.DHCEQCommon).TransValueToPage(TDateFrom,"date","3")
 	.i TDateTo'="" s TDateTo=##Class(web.DHCEQCommon).TransValueToPage(TDateTo,"date","3")
 	.s TInfectionFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",15)
 	.d OutputRowGetAssetItem
 	
	Quit $$$OK
	
ResetVariableGetAssetItem
	s (TRowID,TCode,TDesc,TRemark,TDateFrom,TDateTo,TInvalidFlag,TAssetClassDR,TAssetClass,TDrugFlag,TMedicalDeviceFlag,TMeterageFlag,TMICycleNum,TMICycleUnitDR,TMICycleUnit,TMICycle,TUnitDR,TUnit,TRadiationFlag,TInfectionFlag)=""
	quit
	
OutputRowGetAssetItem
	s Data=$lb(TRowID,TCode,TDesc,TAssetClassDR,TAssetClass,TRemark,TDateFrom,TDateTo,TInvalidFlag,TDrugFlag,TMedicalDeviceFlag,TMeterageFlag,TMICycleNum,TMICycleUnitDR,TMICycleUnit,TMICycle,TUnitDR,TUnit,TRadiationFlag,TInfectionFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetAssetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssetItemExecute ]
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

ClassMethod GetAssetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
