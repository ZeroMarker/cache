/// 名称: web.DHCEQ.Plat.CTStatCat
/// 描述: 设备类型
/// 编写者：ZC
/// 编写日期: 2018-09-20
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTStatCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-09-02
/// Description:   设备类型LookUp所需Query
/// Table：        DHC_EQCStatCat,DHC_EQCEquipType,DHC_EQCFinanceType
/// Input：        StatCat:设备类型描述
/// 				   EquipTypeDR:设备类组ID
/// modify by lmm 2019-09-04 添加EquipTypeFlag入参,改sql为for循环
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTStatCat","GetStatCat","","8","","")
Query GetStatCat(StatCat, EquipTypeDR, EquipTypeFlag As %Library.String = "", FinanceTypeDR As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TRemark:%String,TLimitYears:%String,TFinanceTypeDR:%String,TFinanceType:%String")
{
}

ClassMethod GetStatCatExecute(ByRef qHandle As %Binary, StatCat, EquipTypeDR, EquipTypeFlag As %Library.String = "", FinanceTypeDR As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	// modify by cjc 2022-07-26 增加管理类组多选筛选
	s FinanceTypeDRs=""
	i EquipTypeDR'="" d
	.s EquipTypeLen=$l(EquipTypeDR,",")
	.f n=1:1:EquipTypeLen d
	..s CurEquipTypeDR=$p(EquipTypeDR,",",n)
	..s FinanceTypeDRs=FinanceTypeDRs_","_$p($g(^DHCEQCCode("DHCEQCEquipType",CurEquipTypeDR)),"^",9)
	
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCStatCat",rowid)) quit:rowid=""  d
	.d ResetVariablesGetStatCat
	.s TRowID=rowid
	.q:(EquipTypeFlag="")&&(EquipTypeDR="")
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.s TFinanceTypeDR=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",12)
	.;q:(EquipTypeDR'="")&&($p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",9)'=TFinanceTypeDR)
	.q:(EquipTypeDR'="")&&((","_FinanceTypeDRs_",")'[(","_TFinanceTypeDR_",")) /// modify by cjc 2022-07-26 增加管理类组多选筛选
	.q:(FinanceTypeDR'="")&&(FinanceTypeDR'=TFinanceTypeDR)		//czf 2021-06-29
	.i TFinanceTypeDR'="" s TFinanceType=$p($g(^DHCEQCCode("DHCEQCFinanceType",TFinanceTypeDR)),"^",2)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",2)
	.;q:(StatCat'="")&&(TName'[StatCat)
	.q:(StatCat'="")&&(TName'[StatCat)&&((##class(web.DHCEQCHanZiEncoding).GetEncoding(TName,4,"","U"))'[$zcvt(StatCat,"U"))   /// modify by myl 2022-11-14 增加类型模糊筛选
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",3)
	.s TLimitYears=$p($g(^DHCEQCCode("DHCEQCStatCat",rowid)),"^",9)
	.s ASCRowID=0,ENSNotAccessFlag=""	//czf 2022-02-09 类组禁止访问类型过滤
	.i EquipTypeDR'="" s ASCRowID=$o(^DHCEQCCode("DHCEQETNotAccessSC",0,"StatCat",EquipTypeDR,TRowID,""))
	.i ASCRowID'="" s ENSNotAccessFlag=$p($g(^DHCEQCCode("DHCEQETNotAccessSC",ASCRowID)),"^",4)
	.q:ENSNotAccessFlag="Y"
	.d OutputRowGetStatCat
	Quit $$$OK
OutputRowGetStatCat
	s Data=$lb(TName,TRowID,TCode,TRemark,TLimitYears,TFinanceTypeDR,TFinanceType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStatCat
	s (TName,TRowID,TCode,TRemark,TInvalidFlag,TLimitYears,TFinanceTypeDR,TFinanceType)=""
	quit
}

ClassMethod GetStatCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatCatExecute ]
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

ClassMethod GetStatCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
