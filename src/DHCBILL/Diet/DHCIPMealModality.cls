Import sqluser

Class DHCBILL.Diet.DHCIPMealModality Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:yyx
/// CreateDate:2010-04-28
/// Function  :插入记录
/// Table     :dhc_ipmealmodality
ClassMethod Insert(InsInfo)
{
	k PLIST
	s MTCode=$p(InsInfo,"^",1),PLIST(2)=MTCode
	s MTDesc=$p(InsInfo,"^",2),PLIST(3)=MTDesc
	s rtn=..CheckIsExists("",MTDesc)
	q:(+rtn'=0) rtn ;判断是否存在
	s MTRemark=$p(InsInfo,"^",3),PLIST(4)=MTRemark
	s MTPYM=$p(InsInfo,"^",4),PLIST(5)=MTPYM
	s MTComment1=$p(InsInfo,"^",5),PLIST(6)=MTComment1
	s MTComment2=$p(InsInfo,"^",6),PLIST(7)=MTComment2
	s MTStatus=$p(InsInfo,"^",7),PLIST(8)=MTStatus
	&sql(INSERT INTO DHC_IPMealModality Values PLIST())
	q SQLCODE
}

ClassMethod Update(UpdInfo)
{
	k PLIST
	s MTRowID=$p(UpdInfo,"^",1)
	s MTCode=$p(UpdInfo,"^",2),PLIST(2)=MTCode
	s MTDesc=$p(UpdInfo,"^",3),PLIST(3)=MTDesc
	s MTRemark=$p(UpdInfo,"^",4),PLIST(4)=MTRemark
	s MTPYM=$p(UpdInfo,"^",5),PLIST(5)=MTPYM
	s MTComment1=$p(UpdInfo,"^",6),PLIST(6)=MTComment1
	s MTComment2=$p(UpdInfo,"^",7),PLIST(7)=MTComment2
	s MTStatus=$p(UpdInfo,"^",8),PLIST(8)=MTStatus
	&sql(update DHC_IPMealModality values :PLIST() where DHCMM_RowID=:MTRowID)
	q SQLCODE
}

ClassMethod Delete(RowID)
{
	&sql(delete from DHC_IPMealModality where dhcmm_rowid=:RowID)
	q SQLCODE
}

ClassMethod CheckIsExists(Code, Desc)
{
	;i $d(^DHCIPMEALTYPE(0,"Code",Code)) q "CodeRepErr"
	q:$d(^DHCIPMEALMODALITY(0,"Desc",Desc)) -1001
	q 0
}

/// Function:根据code，desc，pym查询餐别或者查询所有餐别
/// Table   :DHC_IPMealType
ClassMethod FindMealModality1(Code, Desc, PYM)
{
	i ((Code="")&(Desc="")&(PYM="")) d
	.s RowID=0
	.f  s RowID=$o(^DHCIPMEALMODALITY(RowID)) q:RowID=""  d
	..d GetMealModalityMealModality(RowID)
	i Code'="" d
	.s OldCode=Code,Code=$o(^DHCIPMEALMODALITY(0,"Code",Code),-1)
	.f  s Code=$o(^DHCIPMEALMODALITY(0,"Code",Code)) q:(Code="")!($e(Code,1,$l(OldCode))'=OldCode)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALMODALITY(0,"Code",Code,RowID)) q:RowID=""  d
	...d GetMealModalityMealModality(RowID) 
	e  i Desc'="" d
	.s OldDesc=Desc,Desc=$o(^DHCIPMEALMODALITY(0,"Desc",Desc),-1)
	.f  s Desc=$o(^DHCIPMEALMODALITY(0,"Desc",Desc)) q:(Desc="")!($e(Desc,1,$l(OldDesc))'=OldDesc)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALMODALITY(0,"Desc",Desc,RowID)) q:RowID=""  d
	...d GetMealModalityMealModality(RowID) 
	e  i PYM'="" d
	.s OldPYM=PYM,PYM=$o(^DHCIPMEALMODALITY(0,"PYM",PYM),-1)
	.f  s PYM=$o(^DHCIPMEALMODALITY(0,"Desc",PYM)) q:(PYM="")!($e(PYM,1,$l(OldPYM))'=OldPYM)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALMODALITY(0,"PYM",PYM,RowID)) q:RowID=""  d
	...d GetMealModalityMealModality(RowID) 
	
GetMealModalityMealModality(RowID)
  s MealTypeInfo=^DHCIPMEALMODALITY(RowID)
  w !,MealTypeInfo
  q
}

ClassMethod FindMealModalityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealModalityExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealModalityExecute(ByRef qHandle As %Binary, Code As %String, Desc As %String, PYM As %String, Status As %String = "") As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealModality","FindMealModality","","","wc","Y")
    Set repid=$I(^CacheTemp)
    s ind=1
    s Code=$g(Code),Desc=$g(Desc),PYM=$ZCVT($g(PYM),"U"),Status=$g(Status)
    i ((Code="")&(Desc="")&(PYM="")) d
	.s RowID=0
	.f  s RowID=$o(^DHCIPMEALMODALITY(RowID)) q:RowID=""  d
	..b
	..d GetMealModality(RowID,Status)
	i Code'="" d
	.s OldCode=Code,Code=$o(^DHCIPMEALMODALITY(0,"Code",Code),-1)
	.f  s Code=$o(^DHCIPMEALMODALITY(0,"Code",Code)) q:(Code="")!($e(Code,1,$l(OldCode))'=OldCode)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALMODALITY(0,"Code",Code,RowID)) q:RowID=""  d
	...d GetMealModality(RowID,Status) 
	e  i Desc'="" d
	.s OldDesc=Desc,Desc=$o(^DHCIPMEALMODALITY(0,"Desc",Desc),-1)
	.f  s Desc=$o(^DHCIPMEALMODALITY(0,"Desc",Desc)) q:(Desc="")!($e(Desc,1,$l(OldDesc))'=OldDesc)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALMODALITY(0,"Desc",Desc,RowID)) q:RowID=""  d
	...d GetMealModality(RowID,Status) 
	e  i PYM'="" d
	.s OldPYM=PYM,PYM=$o(^DHCIPMEALMODALITY(0,"PYM",PYM),-1)
	.f  s PYM=$o(^DHCIPMEALMODALITY(0,"PYM",PYM)) q:(PYM="")!($e(PYM,1,$l(OldPYM))'=OldPYM)  d
	..s RowID=0
	..f  s RowID=$o(^DHCIPMEALMODALITY(0,"PYM",PYM,RowID)) q:RowID=""  d
	...b ;11
	...d GetMealModality(RowID,Status) 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetMealModality(RowID,Status)
    s MealModalityInfo=^DHCIPMEALMODALITY(RowID)
    s MealCode=$p(MealModalityInfo,"^",1)
    s MealDesc=$p(MealModalityInfo,"^",2)
    s MealRemark=$p(MealModalityInfo,"^",3)
    s MealPYM=$p(MealModalityInfo,"^",4)
    s MealComment1=$p(MealModalityInfo,"^",5)
    s MealComment2=$p(MealModalityInfo,"^",6)
    s MealStatus=$p(MealModalityInfo,"^",7)
    q:((Status'="")&&(Status'=MealStatus))
    d OutputRow
    q
OutputRow
	set Data=$lb(MealCode,MealDesc,MealRemark,MealPYM,MealComment1,MealComment2,RowID,MealStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealModalityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealModalityExecute ]
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

Query FindMealModality(Code As %String, Desc As %String, PYM As %String, Status As %String = "") As %Query(ROWSPEC = "code:%String,desc:%String,remark:%String,pym:%String,comment1:%String,comment2:%String,rowid:%String,status")
{
}

}
