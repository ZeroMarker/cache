Import SQLUSER

Class DHCBILL.Diet.DHCIPMealItmPrice Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:yyx
/// CreateDate:2010-04-28
/// Function  :插入记录
/// Table     DHC_IPMealItemPrice
ClassMethod Insert(InsInfo)
{
	k PLIST
	s DHCMIParref=$p(InsInfo,"^",1),PLIST(0)=DHCMIParref
	s Price=$p(InsInfo,"^",2),PLIST(3)=Price
	s StartDate=$p(InsInfo,"^",3),PLIST(4)=StartDate
	s EndDate=$p(InsInfo,"^",4),PLIST(5)=EndDate
	s UpdateUser=$p(InsInfo,"^",5),PLIST(6)=UpdateUser
	s UpdateDate=+$h,PLIST(7)=UpdateDate
	s UpdateTime=$p($h,",",2),PLIST(8)=UpdateTime
	s PatInsuType=$p(InsInfo,"^",6),PLIST(9)=PatInsuType
	s Remark=$p(InsInfo,"^",7),PLIST(13)=Remark
	s Comment1=$p(InsInfo,"^",8),PLIST(14)=Comment1
	s Comment2=$p(InsInfo,"^",9),PLIST(15)=Comment2
	i PLIST(4)'="" s PLIST(4)=$zdh(PLIST(4),3)
	i PLIST(5)'="" s PLIST(5)=$zdh(PLIST(5),3)

	&sql(INSERT INTO DHC_IPMealItemPrice Values PLIST())
	q SQLCODE
}

/// Rowid^价格^开始日期^结算日期(可为空)^更新人^更新日期^更新时间^病人类型(暂时不用)^备注
ClassMethod Update(UpdInfo)
{
 
	k PLIST
	s RowID=$p(InsInfo,"^",1)
	s Price=$p(InsInfo,"^",2),PLIST(3)=Price
	s StartDate=$p(InsInfo,"^",3),PLIST(4)=StartDate
	s EndDate=$p(InsInfo,"^",4),PLIST(5)=EndDate
	s UpdateUser=$p(InsInfo,"^",5),PLIST(6)=UpdateUser
	s UpdateDate=+$h,PLIST(7)=UpdateDate
	s UpdateTime=$p($h,",",2),PLIST(8)=UpdateTime
	s PatInsuType=$p(InsInfo,"^",6),PLIST(9)=PatInsuType
	s Remark=$p(InsInfo,"^",7),PLIST(13)=Remark
	s Comment1=$p(InsInfo,"^",8),PLIST(14)=Comment1
	s Comment2=$p(InsInfo,"^",9),PLIST(15)=Comment2
	&sql(update DHC_IPMealItemPrice Values PLIST() where DHCIP_RowID=:RowID)
	q SQLCODE
}

ClassMethod GetMealItmPrice(MealItmRowID)
{
	s ChildSub=0
	f  s ChildSub=$o(^DHCIPMEALITEM(MealItmRowID,"P",ChildSub)) q:ChildSub=""  d
	.w !,^DHCIPMEALITEM(MealItmRowID,"P",ChildSub)
}

ClassMethod FindMealPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealPriceExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealPriceExecute(ByRef qHandle As %Binary, MealItmRowID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s MealItmRowID=$g(MealItmRowID)
    i MealItmRowID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ChildSub=0
	f  s ChildSub=$o(^DHCIPMEALITEM(MealItmRowID,"P",ChildSub)) q:ChildSub=""  d
	.s itmDesc=$p(^DHCIPMEALITEM(MealItmRowID),"^",2)  ;菜名
	.s MIARowID=MealItmRowID_"||"_ChildSub
	.s StartDate=$p(^DHCIPMEALITEM(MealItmRowID,"P",ChildSub),"^",2)
	.i StartDate'="" s StartDate=$zd(StartDate,3)
	.s Price=$p(^DHCIPMEALITEM(MealItmRowID,"P",ChildSub),"^",1)
	.s UpdateDate=$p(^DHCIPMEALITEM(MealItmRowID,"P",ChildSub),"^",5)
	.s UpdateTime=$p(^DHCIPMEALITEM(MealItmRowID,"P",ChildSub),"^",6)
	.i UpdateDate'="" s UpdateDate=$zd(UpdateDate,3)
	.i UpdateTime'="" s UpdateTime=$zt(UpdateTime,1)
	.s UpdateDate=UpdateDate_" "_UpdateTime
	.s UpdateUser=$p(^DHCIPMEALITEM(MealItmRowID,"P",ChildSub),"^",4)
	.i UpdateUser'="" s UpdateUser=$p(^SSU("SSUSR",UpdateUser),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(MIARowID,MealItmRowID,itmDesc,StartDate,Price,UpdateDate,UpdateUser,Comment1,Comment2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealPriceExecute ]
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

Query FindMealPrice(MealItmRowID As %String) As %Query(ROWSPEC = "rowid:%String,mealitmrowid,itmdesc,startdate:%String,price:%String,updatedate:%String,updateuser:%String,comment1:%String,comment2:%String")
{
}

}
