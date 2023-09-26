Class DHCPM.Query.PMQueryLookUp Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Query SelectPMPModule(XQmokuai As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","SelectPMPModule","")

ClassMethod SelectPMPModuleExecute(ByRef qHandle As %Binary, ModDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s MODERowid="" f  s MODERowid=$o(^PMPModule(MODERowid)) q:MODERowid=""  d
	.s desc=$p(^PMPModule(MODERowid),"^",2)
	.q:desc=""
	.s code=$p(^PMPModule(MODERowid),"^",1)
	.q:(ModDesc'="")&(desc'[ModDesc)
	.s rowid=MODERowid
	.d OutputRowMod
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowMod
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectPMPModuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPMPModuleExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPMPModuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPMPModuleExecute ]
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

/// 菜单
Query MenuBySQL(CRMenu As %String) As %SQLQuery(CONTAINID = 1)
{
	select Caption,ID from SQLUSER.websys.Menu where  Caption %STARTSWITH %ALPHAUP (:CRMenu)
}

Query PMUserLookUp(LocDesc As %String, PMFlag As %String) As %Query(ROWSPEC = "code:%String,TUserDesc:%String,TUserRowid:%String")
{
}

//人员

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","PMUserLookUp","","王静")

ClassMethod PMUserLookUpExecute(ByRef qHandle As %Binary, UserDesc As %String, PMFlag As %String) As %Status
{
	s ^dongzt("PMLocLookUpExecute")=UserDesc_"^"_PMFlag
	Set repid=$I(^CacheTemp)
	s ind=1
	
		if (PMFlag'="")
		{
		Set Data=$lb(PMFlag,"")
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		}
	s Userrowid="0" f  s Userrowid=$o(^SSU("SSUSR",Userrowid)) q:Userrowid=""  d
	.S code=$p(^SSU("SSUSR",Userrowid),"^",1)
	.s TUserDesc=$p(^SSU("SSUSR",Userrowid),"^",2)
	.q:(UserDesc'="")&($zcvt(TUserDesc,"U")'[$zcvt(UserDesc,"U")) //$zcvt(LocDesc,"U")
	.S UserName=TUserDesc_" "_code
	.b ;;
	.s TUserRowid=Userrowid
	.d OutputRowUser
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUser
	set Data=$lb(code,UserName,TUserRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMUserLookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMUserLookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMUserLookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMUserLookUpExecute ]
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

Query PMLocLookUp(LocDesc As %String, PMFlag As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//科室

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","PMLocLookUp","","")

ClassMethod PMLocLookUpExecute(ByRef qHandle As %Binary, LocDesc As %String, PMFlag As %String) As %Status
{
	s ^dongzt("PMLocLookUpExecute")=LocDesc_"^"_PMFlag
	Set repid=$I(^CacheTemp)
	s ind=1
	
		if (PMFlag'="")
		{
		Set Data=$lb(PMFlag,"")
    	Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		}
	s Trowid="0" f  s Trowid=$o(^CTLOC(Trowid)) q:Trowid=""  d
	.Q:Trowid=""
	.S code=$p(^CTLOC(Trowid),"^",1)
	.s desc=$p(^CTLOC(Trowid),"^",2)
	.q:(LocDesc'="")&($zcvt(desc,"U")'[$zcvt(LocDesc,"U")) //$zcvt(LocDesc,"U")
	.s rowid=Trowid
	.d OutputRowLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLoc
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMLocLookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMLocLookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMLocLookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMLocLookUpExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-14
/// Description:  增加统计维度
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","QryStatisticType")
Query QryStatisticType() As %Query(ROWSPEC = "TypeCode:%String,TypeDesc:%String")
{
}

ClassMethod QryStatisticTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set DateTypeList=$lb($lb(1,"科室维度"),$lb(2,"状态维度"))
	
	For indType=1:1:$listlength(DateTypeList)
	{
		Set Data=$list(DateTypeList,indType)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryStatisticTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatisticTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStatisticTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatisticTypeExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-02-01
/// Description:  查询需求方向
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","QryDemDirectoty")
Query QryDemDirectoty() As %Query(ROWSPEC = "TypeCode:%String,TypeDesc:%String")
{
}

ClassMethod QryDemDirectotyExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set DemDirectList=$lb($lb(1,"HIS需求"),$lb(2,"科内需求"))
	
	For indType=1:1:$listlength(DemDirectList)
	{
		Set Data=$list(DemDirectList,indType)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDemDirectotyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDemDirectotyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDemDirectotyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDemDirectotyExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-14
/// Description:  查询日期类型
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","QryDateType")
Query QryDateType() As %Query(ROWSPEC = "TypeCode:%String,TypeDesc:%String")
{
}

ClassMethod QryDateTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set DateTypeList=$lb($lb(1,"创建日期"),$lb(2,"完成日期"))
	
	For indType=1:1:$listlength(DateTypeList)
	{
		Set Data=$list(DateTypeList,indType)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDateTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDateTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDateTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDateTypeExecute ]
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

Query PMDicOtherLookUp(PMStatusDesc As %String, PMFlag As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String,code:%String")
{
}

//需求字典 需求状态 Improvement  紧急程度  Emergency    需求类型 Type

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","PMDicOtherLookUp","","AuthMode")

ClassMethod PMDicOtherLookUpExecute(ByRef qHandle As %Binary, PMStatusDesc As %String, PMFlag As %String) As %Status
{
	s ^dongzt("PMDicLookUpExecute")=PMStatusDesc_"^"_PMFlag
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:$p($G(^PMPDictionary(DTYROWID)),"^",5)="N"
	.q:flag'=PMFlag
	.q:(PMStatusDesc'="")&($zcvt(desc,"U")'[$zcvt(PMStatusDesc,"U"))
	.s rowid=DTYROWID
	.d OutputDic
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDic
	set Data=$lb(desc,rowid,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMDicOtherLookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMDicOtherLookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMDicOtherLookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMDicOtherLookUpExecute ]
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

Query PMDicLookUp(PMStatusDesc As %String, PMFlag As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//需求字典 需求状态 Improvement  紧急程度  Emergency    需求类型 Type

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","PMDicLookUp","","Improvement")

ClassMethod PMDicLookUpExecute(ByRef qHandle As %Binary, PMStatusDesc As %String, PMFlag As %String) As %Status
{
	s ^dongzt("PMDicLookUpExecute")=PMStatusDesc_"^"_PMFlag
	Set repid=$I(^CacheTemp)
	s ind=1
	i (PMFlag="Improvement")&(PMStatusDesc="")  d
	.Set Data=$lb("全部","")
    .Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	i (PMFlag'="Improvement")||((PMFlag="Improvement")&(PMStatusDesc'["HandleNeed"))  d	
	.s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	..Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	..S code=$p(^PMPDictionary(DTYROWID),"^",1)
	..q:$p($G(^PMPDictionary(DTYROWID)),"^",5)="N"
	..s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	..s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	..q:flag'=PMFlag
	..q:(PMStatusDesc'="")&(desc'[PMStatusDesc)
	..s rowid=DTYROWID
	..d OutputRowDic
	i (PMFlag="Improvement")&(PMStatusDesc["HandleNeed")  d
	.s HandleNeedRet=##class(web.PMP.Document).HandleNeed()
	.f no=1:1:$l(HandleNeedRet,",")  d
	..s (desc,rowid)=""
	..s rowid=$p(HandleNeedRet,",",no)
	..q:'$d(^PMPDictionary(rowid))
	..s desc=$p(^PMPDictionary(rowid),"^",2)
	..d OutputRowDic
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDic
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMDicLookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMDicLookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMDicLookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMDicLookUpExecute ]
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

Query PMStatus(PMPProduct As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//需求状态

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","PMStatus","")

ClassMethod PMStatusExecute(ByRef qHandle As %Binary, PMStatusDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:$p($G(^PMPDictionary(DTYROWID)),"^",5)="N"
	.q:flag'="Improvement"
	.q:(PMStatusDesc'="")&(desc'[PMStatusDesc)
	.s rowid=DTYROWID
	.d OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMStatusExecute ]
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

//USER

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","COMMClenteBySQL","")

Query COMMClenteBySQL(COMMClent1 As %String) As %SQLQuery(CONTAINID = 1)
{
	select SSUSR_Name,SSUSR_Initials,SSUSR_RowId from SQLUSER.SS_User where  SSUSR_Name %STARTSWITH %ALPHAUP (:COMMClent1) or SSUSR_Initials %STARTSWITH %ALPHAUP(:COMMClent1)
}

Query PMPProduct(PMPProduct As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//需求类型

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","PMPProduct","")

ClassMethod PMPProductExecute(ByRef qHandle As %Binary, PMPProduct As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:$p($G(^PMPDictionary(DTYROWID)),"^",5)="N"
	.q:flag'="Type"
	.q:(PMPProduct'="")&(desc'[PMPProduct)
	.s rowid=DTYROWID
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMPProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMPProductExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMPProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMPProductExecute ]
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

/// 紧急程度下拉框
Query SelectCREmergency(CREmergency As %String) As %Query(ROWSPEC = "name:%String,rowid:%String")
{
}

//d ##class(%ResultSet).RunQuery("DHCPM.Query.PMQueryLookUp","SelectCREmergency","")

ClassMethod SelectCREmergencyExecute(ByRef qHandle As %Binary, CREmergency As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:$p($G(^PMPDictionary(DTYROWID)),"^",5)="N"
	.q:flag'="Emergency"
	.q:(CREmergency'="")&(desc'[CREmergency)
	.s rowid=DTYROWID
	.d OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectCREmergencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectCREmergencyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectCREmergencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectCREmergencyExecute ]
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

Query COMMUuser(COMMUuser As %String) As %Query(ROWSPEC = "TUserDesc:%String,TUserRowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","COMMUuser","")

ClassMethod COMMUuserExecute(ByRef qHandle As %Binary, COMMUuser As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s PJURowid="0" f  s PJURowid=$o(^PMPProjectUser(PJURowid)) q:PJURowid=""  d
	.s PJUEnDate=$p(^PMPProjectUser(PJURowid),"^",5)
	.q:PJUEnDate'=""
	.s PJUUserDR=$p(^PMPProjectUser(PJURowid),"^",1)
	.q:$g(^SSU("SSUSR",PJUUserDR))=""
	.s desc=$p(^PMPProjectUser(PJURowid),"^",22)
	.q:(COMMUuser'="")&(desc'[COMMUuser)
	.s rowid=PJURowid
	.d OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod COMMUuserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COMMUuserExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COMMUuserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COMMUuserExecute ]
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

}
