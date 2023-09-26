Import SQLUSER

/// 菜定义维护
Class DHCBILL.Diet.DHCIPMealItm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:yyx
/// CreateDate:2010-04-28
/// Function  :插入记录
/// Table     DHC_IPMealItem
ClassMethod Insert(InsInfo, PriceInfo, Alias)
{
	tstart
	s Code=$p(InsInfo,"^",1),PLIST(2)=Code
	s Desc=$p(InsInfo,"^",2),PLIST(3)=Desc
	s rtn=..CheckIsExists("", Desc)
	q:+rtn'=0 rtn
	s MealTypeDr=$p(InsInfo,"^",3),PLIST(4)=MealTypeDr
	s MealModalityDr=$p(InsInfo,"^",4),PLIST(5)=MealModalityDr
	s UomDr=$p(InsInfo,"^",5),PLIST(6)=UomDr
	s LocDr=$p(InsInfo,"^",6),PLIST(7)=LocDr
	s ActiveFlag=$p(InsInfo,"^",7),PLIST(8)=ActiveFlag
	s StartDate=$p(InsInfo,"^",8),PLIST(9)=StartDate
	s StartTime=$p(InsInfo,"^",9),PLIST(10)=StartTime
	s EndDate=$p(InsInfo,"^",10),PLIST(11)=EndDate
	s EndTime=$p(InsInfo,"^",11),PLIST(12)=EndTime
	s Remark=$p(InsInfo,"^",12),PLIST(13)=Remark
	s Comment1=$p(InsInfo,"^",13),PLIST(14)=Comment1
	s Comment2=$p(InsInfo,"^",14),PLIST(15)=Comment2
	s User=$p(InsInfo,"^",15),PLIST(16)=User
	
	i +$g(PLIST(9))'=0 s PLIST(9)=$zdh(PLIST(9),3)
	i +$g(PLIST(10))'=0 s PLIST(10)=$zth(PLIST(10),1)
	i +$g(PLIST(11))'=0 s PLIST(11)=$zdh(PLIST(11),3)
	i +$g(PLIST(12))'=0 s PLIST(12)=$zth(PLIST(12),1)
	&sql(INSERT INTO DHC_IPMealItem Values PLIST())
	s DHCMIParref=$g(%ROWID)
	s err=SQLCODE
	;b ;1
	i err=0 d
	.s InsPriceInfo=DHCMIParref_"^"_$p(PriceInfo,"^",1)_"^"_$p(PriceInfo,"^",2)_"^"_""_"^"_$p(PriceInfo,"^",3)_"^"_""_"^"_""_"^"_""_"^"_""
	.s err=##class(DHCBILL.Diet.DHCIPMealItmPrice).Insert(InsPriceInfo)
	;b ;2
	i err=0 d
	.s AliasInfo=DHCMIParref_"^"_Alias
	.s err=##class(DHCBILL.Diet.DHCIPMealItm).InsertAlias(AliasInfo)
	;b ;3
	i err=0 Tcommit
	e  trollback
	q err
}

/// Function:更新dhc_ipmealitem
/// Input:dhc_ipmealitem.dhcmi_rowid^...按column顺序传入
ClassMethod Update(UpdInfo)
{
	k PLIST
	f i=1:1:$l(UpdInfo,"^") d
	.s PLIST(i)=$P(UpdInfo,"^",i)
	s RowID=PLIST(1)
	i +$g(PLIST(9))'=0 s PLIST(9)=$zdh(PLIST(9),3)
	i +$g(PLIST(10))'=0 s PLIST(10)=$zth(PLIST(10),1)
	i +$g(PLIST(11))'=0 s PLIST(11)=$zdh(PLIST(11),3)
	i +$g(PLIST(12))'=0 s PLIST(12)=$zth(PLIST(12),1)
	&sql(update DHC_IPMealItem values :PLIST() where DHCMI_RowID=:RowID)
	q SQLCODE
}

/// Function:删除某个菜定义
ClassMethod Delete(RowID)
{
	&sql(delete from DHC_IPMealItem where dhcmi_rowid=:RowID)
	q SQLCODE
}

/// Function:插入别名
/// Input:dhcipmealitem.dhcmi_rowid^别名^备注1^备注2
ClassMethod InsertAlias(InsInfo)
{
	k PLIST
	s DHCMIDr=$p(InsInfo,"^",1),PLIST(2)=DHCMIDr
	s Alias=$p(InsInfo,"^",2)
	s Alias=$ZCVT(Alias,"U")
	s PLIST(3)=Alias
	s Comment1=$p(InsInfo,"^",3),PLIST(4)=Comment1
	s Comment2=$p(InsInfo,"^",4),PLIST(5)=Comment2
	&sql(INSERT INTO DHC_IPMealItemAlias Values PLIST())
	q SQLCODE
}

/// Function:更新别名
/// Input:dhc_ipmealitemalias.dhcmia_rowid^别名^备注1^备注2
ClassMethod UpdateAlias(UpdInfo)
{
	k PLIST
	s AliasRowID=$p(UpdInfo,"^",1)
	s Alias=$p(UpdInfo,"^",2)
	s Alias=$ZCVT(Alias,"U")
	s PLIST(3)=Alias
	s Comment1=$p(UpdInfo,"^",3),PLIST(4)=Comment1
	s Comment2=$p(UpdInfo,"^",4),PLIST(5)=Comment2
	&sql(update DHC_IPMealItemAlias values :PLIST() where DHCMIA_RowID=:AliasRowID)
	q SQLCODE
}

/// Lid
/// 2010-05-24
/// 删除别名
ClassMethod DeleteAlias(RowID)
{
	&sql(delete from DHC_IPMealItemAlias where DHCMIA_RowID=:RowID)
	q SQLCODE
}

ClassMethod CheckIsExists(Code, Desc)
{
	;i $d(^DHCIPMEALTYPE(0,"Code",Code)) q "CodeRepErr"
	q:$d(^DHCIPMEALITEM(0,"Desc",Desc)) -1001
	q 0
}

/// Function:取某个菜定义的别名
/// Input   :dhc_ipmealitem.dhcmi_rowid
ClassMethod FindMealItemAlias1(MealItmRowID)
{
	s MIARowID=0
	f  s MIARowID=$o(^DHCIPMEALITEMALIAS(0,"DHCMI",MealItmRowID,MIARowID)) q:MIARowID=""  d
	.s Alias=$p(^DHCIPMEALITEMALIAS(MIARowID),"^",2)
	.s Comment1=$p(^DHCIPMEALITEMALIAS(MIARowID),"^",3)
	.s Comment2=$p(^DHCIPMEALITEMALIAS(MIARowID),"^",4)
	.B
	q
}

ClassMethod FindMealAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealAliasExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealAliasExecute(ByRef qHandle As %Binary, MealItmRowID As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItm","FindMealAlias","15")
    Set repid=$I(^CacheTemp)
    s ind=1
    s MealItmRowID=$g(MealItmRowID)
    i MealItmRowID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s MealItmDesc="",MIARowID=0
	f  s MIARowID=$o(^DHCIPMEALITEMALIAS(0,"DHCMI",MealItmRowID,MIARowID)) q:MIARowID=""  d
	.s Alias=$p(^DHCIPMEALITEMALIAS(MIARowID),"^",2)
	.s Comment1=$p(^DHCIPMEALITEMALIAS(MIARowID),"^",3)
	.s Comment2=$p(^DHCIPMEALITEMALIAS(MIARowID),"^",4)
	.s MealItmDesc=$p(^DHCIPMEALITEM(MealItmRowID),"^",2) ;菜名
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(MIARowID,MealItmRowID,Alias,Comment1,Comment2,MealItmDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Query FindMealAlias(MealItmRowID As %String) As %Query(ROWSPEC = "rowid:%String,mealitmrowid,alias:%String,comment1:%String,comment2:%String,mealitmdesc:%String")
{
}

/// Function:按别名查询菜定义明细或查询所有的菜定义
/// Table   :dhc_ipmealitem,dhc_ipmealitemalias
ClassMethod FindMealItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealItemExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealItemExecute(ByRef qHandle As %Binary, Alias As %String, Guser As %String = "", Status As %String = "") As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItm","FindMealItem","","","")
    Set repid=$I(^CacheTemp)
    s ind=1
    s Alias=$ZCVT(Alias,"U") ;转换大小
    i Alias'="" d
	.s OldAlias=Alias
	.s Alias=$o(^DHCIPMEALITEMALIAS(0,"Alias",Alias),-1)
	.f  s Alias=$o(^DHCIPMEALITEMALIAS(0,"Alias",Alias)) q:(Alias="")!($e(Alias,1,$l(OldAlias))'=OldAlias)  d
	..s AliasRowID=0
	..f  s AliasRowID=$o(^DHCIPMEALITEMALIAS(0,"Alias",Alias,AliasRowID)) q:AliasRowID=""  d
	...s MealItemRowID=$p(^DHCIPMEALITEMALIAS(AliasRowID),"^",1)
	...q:$d(TMP(MealItemRowID))
	...s TMP(MealItemRowID)=""
	...d GetMealItemInfoMealItem(MealItemRowID,Guser,Status)
	e  d
	.s MealItemRowID=0
	.f  s MealItemRowID=$o(^DHCIPMEALITEM(MealItemRowID)) q:MealItemRowID=""  d
	..d GetMealItemInfoMealItem(MealItemRowID,Guser,Status)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetMealItemInfoMealItem(MealItemRowID,Guser,Status)
    s ItmCode=$p(^DHCIPMEALITEM(MealItemRowID),"^",1)
    s ItmDesc=$p(^DHCIPMEALITEM(MealItemRowID),"^",2)
    s ItmMealTypeID=$p(^DHCIPMEALITEM(MealItemRowID),"^",3)
    i ItmMealTypeID'="" s ItmMealType=$p($g(^DHCIPMEALTYPE(ItmMealTypeID)),"^",2)
    s ItmMealModalityID=$p(^DHCIPMEALITEM(MealItemRowID),"^",4)
    i ItmMealModalityID'="" s ItmMealModality=$p($g(^DHCIPMEALMODALITY(ItmMealModalityID)),"^",2)
    s ItmUomID=$p(^DHCIPMEALITEM(MealItemRowID),"^",5)
    i ItmUomID'="" s ItmUom=$p($g(^DHCIPMEALUOM(ItmUomID)),"^",2)
    s ItmLocDr=$p(^DHCIPMEALITEM(MealItemRowID),"^",6)
    i ItmLocDr'="" s ItmLoc=$p($g(^CTLOC(ItmLocDr)),"^",2)
    s ItmActiveFlag=$p(^DHCIPMEALITEM(MealItemRowID),"^",7)
    q:((+Status'=0)&&(Status'=ItmActiveFlag))
    s ItmStartDate=$p(^DHCIPMEALITEM(MealItemRowID),"^",8)
    i +$g(ItmStartDate)'=0 s ItmStartDate=$zd(ItmStartDate,3)
    s ItmStartTime=$p(^DHCIPMEALITEM(MealItemRowID),"^",9)
    i +$g(ItmStartTime)'=0 s ItmStartTime=$zt(ItmStartTime,1)
    s ItmEndDate=$p(^DHCIPMEALITEM(MealItemRowID),"^",10)
    i +$g(ItmEndDate)'=0 s ItmEndDate=$zd(ItmEndDate,3)
    s ItmEndTime=$p(^DHCIPMEALITEM(MealItemRowID),"^",11)
    i +$g(ItmEndTime)'=0 s ItmEndTime=$zt(ItmEndTime,1)
    s ItmRemark=$p(^DHCIPMEALITEM(MealItemRowID),"^",12)
    s ItmComment1=$p(^DHCIPMEALITEM(MealItemRowID),"^",13)
    s ItmComment2=$p(^DHCIPMEALITEM(MealItemRowID),"^",14)
    s ItmUser=$p(^DHCIPMEALITEM(MealItemRowID),"^",15)
    q:((+Guser'=0)&&(Guser'=ItmUser))
    s ItmUserName=""
    i ItmUser'="" s ItmUserName=$p(^SSU("SSUSR",ItmUser),"^",2)
    s ItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(MealItemRowID,+$h)
    d OutputRowMealItem
	q
OutputRowMealItem
	set Data=$lb(ItmCode,ItmDesc,ItmMealType,ItmMealModality,ItmUom,ItmLoc,ItmActiveFlag,ItmStartDate,ItmStartTime,ItmEndDate,ItmEndTime,ItmRemark,ItmComment1,ItmComment2,ItmPrice,MealItemRowID,ItmMealTypeID,ItmMealModalityID,ItmUomID,ItmUserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Query FindMealItem(Alias As %String, Guser As %String = "", Status As %String = "") As %Query(ROWSPEC = "itmcode,itmdesc,itmmealtype,itmmealmodality,itmuom,itmloc,itmactiveflag,itmstartdate,itmstarttime,itmenddate,itmendtime,itmremark,itmcomment1,itmcomment2,itmprice,mealitemrowid,itmmealtypeid,itmmealmodalityid,itmuomid,gusername")
{
}

/// Function:按别名,菜类型,菜形态查询菜定义明细或查询所有的菜定义
/// Table   :dhc_ipmealitem,dhc_ipmealitemalias
/// 注:根据南通需求，不需要按菜形态进行过滤
ClassMethod FindItemByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemByAliasExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItm","FindItemByAlias","mt","51","")
ClassMethod FindItemByAliasExecute(ByRef qHandle As %Binary, Alias As %String = "") As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealItm","FindItemByAlias","mt")
    Set repid=$I(^CacheTemp)
    s ind=1
    s Alias=$ZCVT(Alias,"U")
    i Alias'="" d
	.s OldAlias=Alias
	.s Alias=$o(^DHCIPMEALITEMALIAS(0,"Alias",Alias),-1)
	.f  s Alias=$o(^DHCIPMEALITEMALIAS(0,"Alias",Alias)) q:(Alias="")!($e(Alias,1,$l(OldAlias))'=OldAlias)  d
	..s AliasRowID=0
	..f  s AliasRowID=$o(^DHCIPMEALITEMALIAS(0,"Alias",Alias,AliasRowID)) q:AliasRowID=""  d
	...s MealItemRowID=$p(^DHCIPMEALITEMALIAS(AliasRowID),"^",1)
	...q:$d(TMP(MealItemRowID))
	...s TMP(MealItemRowID)=""
	...d GetMealItemInfo(MealItemRowID)
	e  d
	.s MealItemRowID=0
	.f  s MealItemRowID=$o(^DHCIPMEALITEM(MealItemRowID)) q:MealItemRowID=""  d
	..d GetMealItemInfo(MealItemRowID)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetMealItemInfo(MealItemRowID)
    s ItmCode=$p(^DHCIPMEALITEM(MealItemRowID),"^",1)
    s ItmDesc=$p(^DHCIPMEALITEM(MealItemRowID),"^",2)
    s ItmUomID=$p(^DHCIPMEALITEM(MealItemRowID),"^",5)
    i ItmUomID'="" s ItmUom=$p($g(^DHCIPMEALUOM(ItmUomID)),"^",2)
    s ItmLocDr=$p(^DHCIPMEALITEM(MealItemRowID),"^",6)
    i ItmLocDr'="" s ItmLoc=$p($g(^CTLOC(ItmLocDr)),"^",2)
    s ItmActiveFlag=$p(^DHCIPMEALITEM(MealItemRowID),"^",7)
    q:ItmActiveFlag'="Y"  ;过滤“非可用状态”
    s ItmStartDate=$p(^DHCIPMEALITEM(MealItemRowID),"^",8)
    i +$g(ItmStartDate)'=0 s ItmStartDate=$zd(ItmStartDate,3)
    s ItmStartTime=$p(^DHCIPMEALITEM(MealItemRowID),"^",9)
    i +$g(ItmStartTime)'=0 s ItmStartTime=$zt(ItmStartTime,1)
    s ItmEndDate=$p(^DHCIPMEALITEM(MealItemRowID),"^",10)
    q:(+ItmEndDate'=0)&&($h>ItmEndDate)     ;过滤超过使用日期的菜
    i +$g(ItmEndDate)'=0 s ItmEndDate=$zd(ItmEndDate,3)
    s ItmEndTime=$p(^DHCIPMEALITEM(MealItemRowID),"^",11)
    i +$g(ItmEndTime)'=0 s ItmEndTime=$zt(ItmEndTime,1)
    s ItmRemark=$p(^DHCIPMEALITEM(MealItemRowID),"^",12)
    s ItmComment1=$p(^DHCIPMEALITEM(MealItemRowID),"^",13)
    s ItmComment2=$p(^DHCIPMEALITEM(MealItemRowID),"^",14)
    s ItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(MealItemRowID,+$h)
    d OutputRow1
	q
OutputRow1
	set Data=$lb(ItmCode,ItmDesc,ItmUom,ItmLoc,ItmActiveFlag,ItmStartDate,ItmStartTime,ItmEndDate,ItmEndTime,ItmRemark,ItmComment1,ItmComment2,ItmPrice,MealItemRowID,ItmMealTypeID,ItmMealModalityID,ItmUomID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindItemByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemByAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Query FindItemByAlias(Alias As %String) As %Query(ROWSPEC = "itmcode,desc,itmuom,itmloc,itmactiveflag,itmstartdate,itmstarttime,itmenddate,itmendtime,itmremark,itmcomment1,itmcomment2,itmprice,rowid,itmmealtypeid,itmmealmodalityid,itmuomid")
{
}

}
