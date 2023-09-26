Import SQLUSER

Class DHCBILL.Diet.DHCIPMealUom Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:yyx
/// CreateDate:2010-04-28
/// Function  :插入记录
/// Table     DHC_IPMealUom
ClassMethod Insert(InsInfo)
{
	k PLIST
	s ^InsInfo=InsInfo
	s MTPYM=$p(InsInfo,"^",1),PLIST(2)=MTPYM
	s MTDesc=$p(InsInfo,"^",2),PLIST(3)=MTDesc
	s rtn=..CheckIsExists("",MTDesc)
	q:(+rtn'=0) rtn ;判断是否存在
	s MTComment1=$p(InsInfo,"^",3),PLIST(4)=MTComment1
	s MTComment2=$p(InsInfo,"^",4),PLIST(5)=MTComment2
	s MTStatus=$p(InsInfo,"^",5),PLIST(6)=MTStatus
	&sql(INSERT INTO DHC_IPMealUom Values :PLIST())
	q SQLCODE
}

ClassMethod Update(UpdInfo)
{
	k PLIST
	s MTRowID=$p(UpdInfo,"^",1)
	s MTPYM=$p(UpdInfo,"^",2),PLIST(2)=MTPYM
	s MTDesc=$p(UpdInfo,"^",3),PLIST(3)=MTDesc
	s MTComment1=$p(UpdInfo,"^",4),PLIST(4)=MTComment1
	s MTComment2=$p(UpdInfo,"^",5),PLIST(5)=MTComment2
	s MTStatus=$p(UpdInfo,"^",6),PLIST(6)=MTStatus
	&sql(update DHC_IPMealUom values :PLIST() where DHCMU_RowID=:MTRowID)
	q SQLCODE
}

ClassMethod Delete(RowID)
{
	&sql(delete from DHC_IPMealUom where dhcmu_rowid=:RowID)
	q SQLCODE
}

ClassMethod CheckIsExists(Code, Desc)
{
	;i $d(^DHCIPMEALTYPE(0,"Code",Code)) q "CodeRepErr"
	q:$d(^DHCIPMEALUOM(0,"Desc",Desc)) -1001
	q 0
}

/// Function:根据code，desc查询单位或者查询所有单位
/// Table   :DHC_IPMealUom
ClassMethod FindMealUom1(Code, Desc)
{
	i ((Code="")&(Desc="")) d
	.s RowID=0
	.f  s RowID=$o(^DHCIPMEALUOM(RowID)) q:RowID=""  d
	..d GetMealUom1(RowID)
	i Code'="" d
	.s OldCode=Code,Code=$o(^DHCIPMEALUOM(0,"Code",Code),-1)
	.f  s Code=$o(^DHCIPMEALUOM(0,"Code",Code)) q:(Code="")!($e(Code,1,$l(OldCode))'=OldCode)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALUOM(0,"Code",Code,RowID)) q:RowID=""  d
	...d GetMealUom1(RowID) 
	e  i Desc'="" d
	.s OldDesc=Desc,Desc=$o(^DHCIPMEALUOM(0,"Desc",Desc),-1)
	.f  s Desc=$o(^DHCIPMEALUOM(0,"Desc",Desc)) q:(Desc="")!($e(Desc,1,$l(OldDesc))'=OldDesc)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALUOM(0,"Desc",Desc,RowID)) q:RowID=""  d
	...d GetMealUom1(RowID) 
	
GetMealUom1(RowID)
  s MealTypeInfo=^DHCIPMEALUOM(RowID)
  w !,MealTypeInfo
  q
}

ClassMethod FindMealUomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealUomExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealUomExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, Status As %String = "") As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealUom","FindMealUom","","","Y")
	///Code 表示拼音码
    Set repid=$I(^CacheTemp)
    s ind=1
    s Code=$ZCVT($g(Code),"U"),Desc=$g(Desc),Status=$g(Status)
    i ((Code="")&(Desc="")) d
	.s RowID=0
	.f  s RowID=$o(^DHCIPMEALUOM(RowID)) q:RowID=""  d
	..d GetMealUom(RowID,Status)
	i Code'="" d
	.s OldCode=Code,Code=$o(^DHCIPMEALUOM(0,"Code",Code),-1)
	.f  s Code=$o(^DHCIPMEALUOM(0,"Code",Code)) q:(Code="")!($e(Code,1,$l(OldCode))'=OldCode)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALUOM(0,"Code",Code,RowID)) q:RowID=""  d
	...b ;11
	...d GetMealUom(RowID,Status) 
	e  i Desc'="" d
	.s OldDesc=Desc,Desc=$o(^DHCIPMEALUOM(0,"Desc",Desc),-1)
	.f  s Desc=$o(^DHCIPMEALUOM(0,"Desc",Desc)) q:(Desc="")!($e(Desc,1,$l(OldDesc))'=OldDesc)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALUOM(0,"Desc",Desc,RowID)) q:RowID=""  d
	...d GetMealUom(RowID,Status) 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetMealUom(RowID,Status)
    s MealUomInfo=^DHCIPMEALUOM(RowID)
    s MealCode=$p(MealUomInfo,"^",1)
    s MealDesc=$p(MealUomInfo,"^",2)
    s MealComment1=$p(MealUomInfo,"^",3)
    s MealComment2=$p(MealUomInfo,"^",4)
    s MealStatus=$p(MealUomInfo,"^",5)
    b ;11
    q:((Status'="")&&(Status'=MealStatus))
    b ;22
    d OutputRow
    q
OutputRow
	set Data=$lb(MealCode,MealDesc,MealComment1,MealComment2,RowID,MealStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealUomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealUomExecute ]
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

Query FindMealUom(Code As %String, Desc As %String, Status As %String = "") As %Query(ROWSPEC = "pym:%String,desc:%String,comment1:%String,comment2:%String,rowid:%String,status")
{
}

}
