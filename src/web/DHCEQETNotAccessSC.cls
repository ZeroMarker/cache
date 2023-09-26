Class web.DHCEQETNotAccessSC Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by HHM 20150922 HHM0021
/// 增加：类组禁止访问类型
/// 位置：ETNotAccessSC、SaveData
Query ETNotAccessSC(EquipTypeDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStatCat:%String,TStatCatDR:%String,TRemark:%String,TNotAccessFlag:%String,TRow:%String")
{
}

ClassMethod ETNotAccessSCExecute(ByRef qHandle As %Binary, EquipTypeDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i EquipTypeDR="" q $$$OK
 	
	s index=1
	s SCRowID=0
	for  s SCRowID=$o(^DHCEQCCode("DHCEQCStatCat",SCRowID)) quit:SCRowID=""  d
	.d ResetVariablesGetETNotAccessSC
	.s SCInvalidFlag=$p($g(^DHCEQCCode("DHCEQCStatCat",SCRowID)),"^",4)
	.q:SCInvalidFlag="Y"
	.s SCFinanceType=$p($g(^DHCEQCCode("DHCEQCStatCat",SCRowID)),"^",12)
	.s ETFinanceType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",9)
	.q:SCFinanceType'=ETFinanceType
	.s TRow=index
	.s TRowID=$o(^DHCEQCCode("DHCEQETNotAccessSC",0,"StatCat",EquipTypeDR,SCRowID,0))
	.s TStatCatDR=SCRowID
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",SCRowID)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCStatCat",SCRowID)),"^",3)
	.i TRowID'=""  d
	..s TNotAccessFlag=$p($g(^DHCEQCCode("DHCEQETNotAccessSC",TRowID)),"^",4)
	..i TNotAccessFlag'="" s TNotAccessFlag=##Class(web.DHCEQCommon).TransValueToPage(TNotAccessFlag,"bool")
	.d OutputRowGetETNotAccessSC
	Quit $$$OK
OutputRowGetETNotAccessSC
	s Data=$lb(TRowID,TStatCat,TStatCatDR,TRemark,TNotAccessFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetETNotAccessSC
	s (TRowID,TStatCat,TStatCatDR,TRemark,TNotAccessFlag,TRow)=""
	quit
}

ClassMethod ETNotAccessSCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ETNotAccessSCExecute ]
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

ClassMethod ETNotAccessSCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ETNotAccessSCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// d ##Class(web.DHCEQETNotAccessSC).SaveData("30^1^1^^^","true")
ClassMethod SaveData(val, isDel)
{
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	i (+isDel=1)
	{
		&SQL(delete from sqluser.DHC_EQETNotAccessSC where ENS_RowID = :rowid) 
		if SQLCODE  q SQLCODE
		q rowid
	} 
	s PLIST(2)=$p(val,"^",2)
	s PLIST(3)=$p(val,"^",3)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"bool")
	s EquipTypeDR=$p(val,"^",2)
	s StatCatDR=$p(val,"^",3)
	i (rowid="")
	{
		&SQL(Insert Into sqluser.DHC_EQETNotAccessSC Values :PLIST())
	} 
	else
	{
		&SQL(Update sqluser.DHC_EQETNotAccessSC Values :PLIST() where ENS_RowID = :rowid)
	}
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	q ID
}

}
