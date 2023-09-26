Import sqluser

/// Creator:2010-04-30
/// Function:每周菜谱制作
Class DHCBILL.Diet.DHCIPMealCreateMenu Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Function:制作某天的菜谱
/// 开始日期 科室 用户  备注  备注1  备注2
/// w ##class(DHCBILL.Diet.DHCIPMealCreateMenu).InsertMealMenu("","")
/// 预定日期（StartDate)^科室(MenuLoc)^用户(AddUser)^Remark(备注)
ClassMethod InsertMealMenu(InsInfo, MenuDetail)
{
	
	s RetVal=0
	s StartDate=$p(InsInfo,"^",1)
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	s MenuRowID=$o(^DHCIPMEALMENU(0,"StartDate",StartDate,""))
	
    i MenuRowID="" d
	.s PLIST(2)=StartDate
	.s PLIST(3)=""
	.s PLIST(4)="T"
	.s MenuLoc=$p(InsInfo,"^",2),PLSIT(5)=MenuLoc
	.s AddDate=+$h,PLIST(6)=AddDate
	.s AddTime=$p($h,",",2),PLIST(7)=AddTime
	.s AddUser=$p(InsInfo,"^",3),PLIST(8)=AddUser
	.s Remark=$p(InsInfo,"^",4),PLIST(9)=Remark
	.s Comment1=$p(InsInfo,"^",5),PLIST(10)=Comment1
	.s Comment2=$p(InsInfo,"^",6),PLIST(11)=Comment2
	.&sql(INSERT INTO DHC_IPMealMenu Values :PLIST())
	.s RetVal=SQLCODE
	.s MenuRowID=$g(%ROWID)
	
	i RetVal=0 D
	.s menuDetails=..SetMentDatailInfo(InsInfo, MenuDetail)
	.s RetVal=..InsertMenuDetail(MenuRowID,menuDetails) 
	i RetVal=0 d
	.Tcommit
	e  d
	.Trollback
	q RetVal
}

/// Lid
/// 2010-10-17
/// 根据客户端数据，生成菜谱明细信息(//"2010-10-11^^1^%%207^28^15,17,19,21^1^^2,3,4")
ClassMethod SetMentDatailInfo(menuData, menuDetailsdata)
{
	;菜谱数据
	s menuStartDate=$p(menuData,"^",1)  ;菜谱使用日期
	i menuStartDate["-" s menuStartDate=$zdh(menuStartDate,3)
	
	;菜谱明细数据
	s itmDr=$p(menuDetailsdata,"^",1)        ;菜指针
	s itmMTDr=$p(menuDetailsdata,"^",2)      ;餐别指针
	s itmMMDrList=$p(menuDetailsdata,"^",3)  ;餐形态指针列表
	s itmAddUserDr=$p(menuDetailsdata,"^",4) ;菜添加人
	s itmRemark=$p(menuDetailsdata,"^",5)    ;菜备注
	s itmUseWeekList=$p(menuDetailsdata,"^",6) ;菜使用日期信息
	
	s rtn=""
	f i=1:1:$l(itmUseWeekList,",") d
	.s week=$p(itmUseWeekList,",",i)
	.i week=0 s week=7
	.s itmUseDate=+menuStartDate+(week-1)   ;计算菜使用日期
	.f j=1:1:$l(itmMMDrList,",") d
	..s itmMMDr=$p(itmMMDrList,",",j)
	..i rtn="" d
	...s rtn=itmDr_"^"_itmMTDr_"^"_itmMMDr_"^"_itmAddUserDr_"^"_itmRemark_"^"_itmUseDate
	..e  d
	...s rtn=rtn_$c(2)_itmDr_"^"_itmMTDr_"^"_itmMMDr_"^"_itmAddUserDr_"^"_itmRemark_"^"_itmUseDate
    
    q rtn
}

/// 菜指针^餐别^餐谱形态串^用户^备注^使用日期串
ClassMethod InsertMenuDetail(MenuRowID, AllItmInfo)
{
	s maxIndex=0 ;wanghc 插入新数据时排到最后 2010-12-15
	&SQL(select max(DHCMMD_INDEX) into maxIndex FROM dhc_ipmealmenudetail)
	s RowNum=$l(AllItmInfo,$c(2)) 
	Tstart
	f i=1:1:RowNum d  q:SQLCODE'=0 
	.K PLIST,PLIST(1)
	.s ItmInfo=$p(AllItmInfo,$c(2),i)
	.s PLIST(0)=MenuRowID
	.s MealItmDr=$p(ItmInfo,"^",1),PLIST(3)=MealItmDr
	.s MealTypeDr=$p(ItmInfo,"^",2),PLIST(4)=MealTypeDr
	.s MealModalityDr=$p(ItmInfo,"^",3),PLIST(5)=MealModalityDr
	.S PLIST(6)=+$H
	.S PLIST(7)=$P($H,",",2)
	.s UpdateUser=$p(ItmInfo,"^",4),PLIST(8)=UpdateUser
	.s Remark=$p(ItmInfo,"^",5),PLIST(9)=Remark
	.s StartDate=$p(ItmInfo,"^",6)
    .i StartDate["-" s StartDate=$zdh(StartDate,3)
    .s PLIST(10)=StartDate
    .;wanghc 插入新数据时排到最后
	.s PLIST(12)=maxIndex+1
	.&sql(insert into DHC_IPMealMenuDetail values :PLIST())
	q SQLCODE
}

/// Lid 
/// 2010-08-09
/// 更新菜谱
ClassMethod UpdateMealMenu(InsInfo, MenuDetail)
{
    ;s menuInfo=$p(subDr,"||",1)_"^"_startDate_"^"_itmloc_"^"_guser_"^"_menucomment1
	;s menuItemInfo=subDr_"^"_mealitemrowid_"^"_comboMT_"^"_comboMM_"^"_guser_"^"_comboWeekDate

	;更新菜谱主表
	s menuRowID=$p(InsInfo,"^",1) 
	;s startDate=$p(InsInfo,"^",2) ;不能更新
	s itmloc=$p(InsInfo,"^",3)
	s guser=$p(InsInfo,"^",4)
	s menuRemark=$p(InsInfo,"^",5)
	k PLIST
	s RowID=menuRowID
	s PLIST(5)=itmloc
	s PLIST(12)=+$h
	s PLIST(13)=$p($h,",",2)
	s PLIST(14)=guser
	s PLIST(9)=menuRemark
	&sql(update DHC_IPMealMenu values :PLIST() where DHCMM_RowID=:RowID)
	s rtnValue=SQLCODE
	q:rtnValue'=0 rtnValue
	
	;更新菜谱子表
	s subDr=$p(MenuDetail,"^",1)
	s itemRowid=$p(MenuDetail,"^",2)
	s itmMT=$p(MenuDetail,"^",3)
	s itmMM=$p(MenuDetail,"^",4)
	s updateGuser=$p(MenuDetail,"^",5)
	s itmStDate=$p(MenuDetail,"^",6)
	
	k PLIST
	s RowID=subDr
	s PLIST(3)=itemRowid
	s PLIST(4)=itmMT
	s PLIST(5)=itmMM
	s PLIST(6)=+$h
	s PLIST(7)=$p($h,",",2)
	s PLIST(8)=updateGuser
	s PLIST(10)=itmStDate
	&sql(update DHC_IPMealMenuDetail values :PLIST() where DHCMMD_RowID=:RowID)
	s rtnValue=SQLCODE
	
	q rtnValue
}

/// Lid
/// 2010-08-10
/// 删除菜谱
ClassMethod DeleteMenu(menuRowidStr)
{
	q:menuRowidStr="" -1
	s l=$L(menuRowidStr,",")
	s rtn=0
	TSTART 
	f i=1:1:l d  q:((rtn'=0)!(err'=0))
	.s menuRowid=$p(menuRowidStr,",",i)
	.s err=..CheckMenuStatus(menuRowid,"") ;验证模板是否在用
	.&sql(delete from DHC_IPMealMenu where DHCMM_RowID=:menuRowid)
	.s rtn=SQLCODE
	
	i err'=0 s rtn="-1005" 
	
	i ((rtn=0)&&(err=0)) d
	.Tcommit
	e  d
	.Trollback
	q rtn
}

/// Lid
/// 2010-05-18
/// 删除菜谱明细
/// subRowidStr:"rowid,rowid,rowid,..."
/// w ##class(DHCBILL.Diet.DHCIPMealCreateMenu).DeleteMenuDetails("3||1")
ClassMethod DeleteMenuDetails(subRowidStr)
{
	q:subRowidStr="" -1
	s l=$L(subRowidStr,",")
	s rtn=0
	TSTART 
	f i=1:1:l d  q:((rtn'=0)!(err'=0))
	.s subRowid=$p(subRowidStr,",",i)
	.s err=..CheckMenuStatus("",subRowid) ;验证模板是否在用
	.&sql(delete from DHC_IPMealMenuDetail where DHCMMD_RowID=:subRowid)
	.s rtn=SQLCODE
	i err'=0 s rtn="-1005" 
	i ((rtn=0)&&(err=0)) d
	.Tcommit
	e  d
	.Trollback
	q rtn
}

/// Creator:yyx
/// Function:根据餐别，餐谱形态选择菜单定义
/// Input:餐别rowid，餐谱形态rowid，别名
/// OutPut    :ItmCode:菜代码,ItmDesc：菜名称,ItmMealType：餐别,
/// ItmMealModality：餐谱形态,ItmUom：单位,ItmRemark：备注,ItmPrice：单价,MealItemRowID：菜定义指针（dhc_ipmealitem),ItmMealTypeID:餐别rowid,ItmMealModalityID：餐谱形态rowid,ItmUomID：单位rowid
ClassMethod FindMealItemByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealItemByTypeExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMealItemByTypeExecute(ByRef qHandle As %Binary, MenuType As %String, MenuModiality As %String, Alias As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
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
	..s ItmMealTypeID=$p(^DHCIPMEALITEM(MealItemRowID),"^",3)
	..q:(ItmMealTypeID'=MenuType)&(MenuType'="")
	..s ItmMealModalityID=$p(^DHCIPMEALITEM(MealItemRowID),"^",4)
	..q:(ItmMealModalityID'=MenuModiality)&(MenuModiality'="")
	..d GetMealItemInfo(MealItemRowID)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetMealItemInfo(MealItemRowID)
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
    s ItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(MealItemRowID,+$h)
    d OutputRow1
	q
OutputRow1
	set Data=$lb(ItmCode,ItmDesc,ItmMealType,ItmMealModality,ItmUom,ItmRemark,ItmPrice,MealItemRowID,ItmMealTypeID,ItmMealModalityID,ItmUomID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealItemByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealItemByTypeExecute ]
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

Query FindMealItemByType(MenuType, MenuModiality As %String, Alias As %String) As %Query(ROWSPEC = "itmcode,itmdesc,itmmealtype,itmmealmodality,itmuom,itmremark,itmprice,mealitemrowid,itmmealtypeid,itmmealmodalityid,itmuomid")
{
}

ClassMethod FindMealDeatilClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMealDeatilExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Lid
/// 2010-05-17
/// 根据日期,菜谱Rowid,餐类型查询菜谱明细
/// 																		"45$2012-03-05$2012-03-05$106"
/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealCreateMenu","FindMealDeatil","45","2012-03-05","2012-03-05","106")
ClassMethod FindMealDeatilExecute(ByRef qHandle As %Binary, menuRowid As %String = "", startDate As %String = "", itmUseDate As %String = "", mealTypeRowid As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i (menuRowid="")&&(startDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i itmUseDate="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    i startDate["-" s startDate=$zdh(startDate,3)
    i itmUseDate["-" s itmUseDate=$zdh(itmUseDate,3)
    k ^DHCIPMEAL("MenuDetailQuery",$j) 
    b ;111
    ;wanghc 改走用户自定义顺序索引 2010-12-15 和订餐界面对应
    i menuRowid="" d
    .s index="" f  s index=$o(^DHCIPMEALMENU(0,"StartDateSort",itmUseDate,"Index",index)) q:index=""  d
    ..s menuDr="" f  s menuDr=$o(^DHCIPMEALMENU(0,"StartDateSort",itmUseDate,"Index",index,menuDr)) q:menuDr=""  d
    ...s str=^DHCIPMEALMENU(menuDr)
    ...b ;000
    ...s status=$p(str,"^",3)
    ...s menuStartDate=$p(str,"^",1)
    ...s menuAddDate=$p(str,"^",5)
    ...s menulAddUser=$p(str,"^",7)
    ...s menulAddUserName=""
    ...i menulAddUser'="" s menulAddUserName=$p(^SSU("SSUSR",menulAddUser),"^",2) 
    ...i menuStartDate'="" s menuStartDate=$zd(menuStartDate,3)
	...i menuAddDate'="" s menuAddDate=$zd(menuAddDate,3)
    ...s menuRemark=$p(str,"^",8)
    ...s subDr="0" f  s subDr=$o(^DHCIPMEALMENU(0,"StartDateSort",itmUseDate,"Index",index,menuDr,subDr)) q:subDr=""  d
    ....q:'$d(^DHCIPMEALMENU(menuDr,"M",subDr))
    ....s subStr=^DHCIPMEALMENU(menuDr,"M",subDr)
    ....s mealItmUseDate=$p(subStr,"^",8) ;菜使用日期
    ....s mealItmStatus=$p(subStr,"^",9)  ;状态，“Y:已使用”
    ....q:(itmUseDate'="")&&(mealItmUseDate'=itmUseDate)   ;按菜使用日期过滤
    ....i mealItmUseDate'="" s useseDate=$zd(mealItmUseDate,3)
    ....s mealItmDr=$p(subStr,"^",1)     ;菜指针
    ....s (mealItmDesc,mealItmCode,mealItmPrice,mealItmUOMDr,mealItmUOMDesc,mealItmRemark)=""
    ....i mealItmDr'="" d
    .....s itmStr=$g(^DHCIPMEALITEM(mealItmDr))
    .....s mealItmCode=$p(itmStr,"^",1)     ;菜编码
    .....s mealItmDesc=$p(itmStr,"^",2)     ;菜名
    .....s mealItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(mealItmDr,+$h) ;菜单价
    .....s mealItmUOMDr=$p(itmStr,"^",5) 
    .....s mealItmUOMDesc=$p(^DHCIPMEALUOM(mealItmUOMDr),"^",2)  ;菜单位
    .....s mealItmRemark=$p(itmStr,"^",12)      ;菜备注
    ....s mealTypeDr=$p(subStr,"^",2)   ;菜类型
    ....q:(mealTypeRowid'="")&&(mealTypeRowid'=mealTypeDr)
    ....s mealTypeDesc=""
    ....i mealTypeDr'="" s mealTypeDesc=$p(^DHCIPMEALTYPE(mealTypeDr),"^",2)
    ....s mealModDr=$p(subStr,"^",3)    ;菜形态
    ....s mealModDesc=""
    ....i mealModDr'="" s mealModDesc=$p(^DHCIPMEALMODALITY(mealModDr),"^",2)
    ....s mealItmIndex=+$p(subStr,"^",10)  ;菜顺序
    ....;i mealItmIndex=0 s mealItmIndex=99999  ;如果没有设置顺序，则放到最后
    ....s sortIndex=$p(subStr,"^",10)
    ....d OutputRow1
    e  d
    .d GetMenuDetails(menuRowid,itmUseDate,mealTypeRowid)
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetMenuDetails(menuDr,itmUseDate,mealTypeDr)
	b ;0
    q:'$d(^DHCIPMEALMENU(menuDr))
    s str=^DHCIPMEALMENU(menuDr)
    s status=$p(str,"^",3)
    s menuStartDate=$p(str,"^",1)
    s menuAddDate=$p(str,"^",5)
    s menulAddUser=$p(str,"^",7)
    s menulAddUserName=""
    i menulAddUser'="" s menulAddUserName=$p(^SSU("SSUSR",menulAddUser),"^",2) 
    i menuStartDate'="" s menuStartDate=$zd(menuStartDate,3)
	i menuAddDate'="" s menuAddDate=$zd(menuAddDate,3)
    s menuRemark=$p(str,"^",8)
    s subDr="0"
    f  s subDr=$o(^DHCIPMEALMENU(menuDr,"M",subDr)) q:subDr=""  d
    .q:'$d(^DHCIPMEALMENU(menuDr,"M",subDr))
    .s subStr=^DHCIPMEALMENU(menuDr,"M",subDr)
    .s mealItmUseDate=$p(subStr,"^",8) ;菜使用日期
    .s mealItmStatus=$p(subStr,"^",9)  ;状态，“Y:已使用”
    .q:(itmUseDate'="")&&(mealItmUseDate'=itmUseDate)   ;按菜使用日期过滤
    .i mealItmUseDate'="" s useseDate=$zd(mealItmUseDate,3)
    .s mealItmDr=$p(subStr,"^",1)     ;菜指针
    .s (mealItmDesc,mealItmCode,mealItmPrice,mealItmUOMDr,mealItmUOMDesc,mealItmRemark)=""
    .i mealItmDr'="" d
    ..s itmStr=$g(^DHCIPMEALITEM(mealItmDr))
    ..s mealItmCode=$p(itmStr,"^",1)     ;菜编码
    ..s mealItmDesc=$p(itmStr,"^",2)     ;菜名
    ..s mealItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(mealItmDr,+$h) ;菜单价
    ..s mealItmUOMDr=$p(itmStr,"^",5) 
    ..s mealItmUOMDesc=$p(^DHCIPMEALUOM(mealItmUOMDr),"^",2)  ;菜单位
    ..s mealItmRemark=$p(itmStr,"^",12)      ;菜备注
    .s mealTypeDr=$p(subStr,"^",2)   ;菜类型
    .q:(mealTypeRowid'="")&&(mealTypeRowid'=mealTypeDr)
    .s mealTypeDesc=""
    .i mealTypeDr'="" s mealTypeDesc=$p(^DHCIPMEALTYPE(mealTypeDr),"^",2)
    .s mealModDr=$p(subStr,"^",3)    ;菜形态
    .s mealModDesc=""
    .i mealModDr'="" s mealModDesc=$p(^DHCIPMEALMODALITY(mealModDr),"^",2)
    .s mealItmIndex=+$p(subStr,"^",10)  ;菜顺序
    .i mealItmIndex=0 s mealItmIndex=99999  ;如果没有设置顺序，则放到最后
    .s sortIndex=$p(subStr,"^",10)
    .;d OutputRow1
    .s ^DHCIPMEAL("MenuDetailQuery",$j,mealItmUseDate,mealTypeDr,mealItmIndex,subDr)=menuDr_"^"_menuStartDate_"^"_menulAddUser_"^"_menulAddUserName_"^"_menuAddDate_"^"_status_"^"_menuRemark_"^"_subDr_"^"_mealItmDr_"^"_mealItmDesc_"^"_mealItmCode_"^"_mealItmPrice_"^"_mealItmUOMDr_"^"_mealItmUOMDesc_"^"_mealItmRemark_"^"_mealTypeDr_"^"_mealTypeDesc_"^"_mealModDr_"^"_mealModDesc_"^"_useseDate_"^"_mealItmStatus    
    ;q
    s (menuDr,menuStartDate,menulAddUser,menulAddUserName,menuAddDate,status,menuRemark,subDr,mealItmDr,mealItmDesc,mealItmCode,mealItmPrice,mealItmUOMDr,mealItmUOMDesc,mealItmRemark,mealTypeDr,mealTypeDesc,mealModDr,mealModDesc,mealItmUseDate,mealItmStatus)=""
    s useDate=""
    f  s useDate=$o(^DHCIPMEAL("MenuDetailQuery",$j,useDate)) q:useDate=""  d
    .s MTDr="" 
    .f  s MTDr=$o(^DHCIPMEAL("MenuDetailQuery",$j,useDate,MTDr)) q:MTDr=""  d
    ..s itmIndex=""
    ..f  s itmIndex=$o(^DHCIPMEAL("MenuDetailQuery",$j,useDate,MTDr,itmIndex)) q:itmIndex=""  d
    ...s subDr=""
    ...f  s subDr=$o(^DHCIPMEAL("MenuDetailQuery",$j,useDate,MTDr,itmIndex,subDr)) q:subDr=""  d
    ....q:'$d(^DHCIPMEAL("MenuDetailQuery",$j,useDate,MTDr,itmIndex,subDr))
    ....s tmp=$g(^DHCIPMEAL("MenuDetailQuery",$j,useDate,MTDr,itmIndex,subDr))
    ....s menuDr=$p(tmp,"^",1),menuStartDate=$p(tmp,"^",2),menulAddUser=$p(tmp,"^",3),menulAddUserName=$p(tmp,"^",4)
    ....s menuAddDate=$p(tmp,"^",5),status=$p(tmp,"^",6),menuRemark=$p(tmp,"^",7),subDr=$p(tmp,"^",8)
    ....s mealItmDr=$p(tmp,"^",9),mealItmDesc=$p(tmp,"^",10),mealItmCode=$p(tmp,"^",11),mealItmPrice=$p(tmp,"^",12)
    ....s mealItmUOMDr=$p(tmp,"^",13),mealItmUOMDesc=$p(tmp,"^",14),mealItmRemark=$p(tmp,"^",15),mealTypeDr=$p(tmp,"^",16)
    ....s mealTypeDesc=$p(tmp,"^",17),mealModDr=$p(tmp,"^",18),mealModDesc=$p(tmp,"^",19),mealItmUseDate=$p(tmp,"^",20)
    ....s mealItmStatus=$p(tmp,"^",21)
    ....d OutputRow1
    k ^DHCIPMEAL("MenuDetailQuery",$j) 
	q
OutputRow1
    //菜谱Rowid^菜谱使用时间^菜谱添加人^菜谱添加时间^菜谱状态^菜谱备注^菜谱明细Dr^菜Rowid^菜名^菜编码^菜单价^菜单位Rowid^菜单位^菜备注^菜类型Rowid^菜类型^菜形态Rowid^菜形态^菜使用日期
	set Data=$lb(menuDr,menuStartDate,menulAddUser,menulAddUserName,menuAddDate,status,menuRemark,subDr,mealItmDr,mealItmDesc,mealItmCode,mealItmPrice,mealItmUOMDr,mealItmUOMDesc,mealItmRemark,mealTypeDr,mealTypeDesc,mealModDr,mealModDesc,useseDate,mealItmStatus,sortIndex)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMealDeatilFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMealDeatilExecute ]
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

Query FindMealDeatil(menuRowid As %String = "", startDate As %String = "", itmUseDate As %String = "", mealTypeRowid As %String = "") As %Query(ROWSPEC = "menurowid,menustartdate,menuladduser,menuladdusername,menuadddate,status,menuremark,subdr,mealitmdr,mealitmdesc,mealitmcode,mealitmprice,mealitmuomrowid,mealitmuomdesc,mealitmremark,mealtypedr,mealtypedesc,mealmoddr,mealmoddesc,mealitmusedate,mealitmstatus,sortIndex")
{
}

ClassMethod FindMenuInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuInfoExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Lid
/// 2010-05-17
/// 根据日期,菜谱Rowid,添加人查询菜谱模板信息
/// w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealCreateMenu","FindMenuInfo","","","","")
ClassMethod FindMenuInfoExecute(ByRef qHandle As %Binary, menuRowid As %String = "", startDate As %String = "", addUser As %String = "", status As %String = "", queryStDate As %String = "", queryEndDate As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    i startDate["-" s startDate=$zdh(startDate,3)
    i queryStDate["-" s queryStDate=$zdh(queryStDate,3)
    i queryEndDate["-" s queryEndDate=$zdh(queryEndDate,3)
 
    i (menuRowid="")&(startDate="")&(addUser="")&&((queryStDate="")!(queryEndDate="")) d
    .s menuDr="0"
    .f  s menuDr=$o(^DHCIPMEALMENU(menuDr)) q:menuDr=""  d
    ..d GetMenuDetails(menuDr,status) 
    e  d
    .s flag=0 ;开关，用于控制查询的优先级
    .i menuRowid'="" d
    ..s flag=-1
    ..d GetMenuDetails(menuRowid,status)
    .q:flag=-1
    .i addUser'="" d
    ..s flag=-1
    ..s menuDr=""
    ..f  s menuDr=$o(^DHCIPMEALMENU(0,"AddUser",addUser,menuDr)) q:menuDr=""  d
    ...d GetMenuDetails(menuDr,status) 
    .q:flag=-1
    .i startDate'="" d
    ..s menuDr="0"
    ..f  s menuDr=$o(^DHCIPMEALMENU(0,"StartDate",startDate,menuDr)) q:menuDr=""  d
    ...d GetMenuDetails(menuDr,status) 
    .e  i (queryStDate'="")&&(queryEndDate'="") d
    ..s date=queryStDate
    ..f date=date:1:queryEndDate d
    ...s menuDr="0"
    ...f  s menuDr=$o(^DHCIPMEALMENU(0,"StartDate",date,menuDr)) q:menuDr=""  d
    ....d GetMenuDetails(menuDr,status) 
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetMenuDetails(menuDr,status)
    q:'$d(^DHCIPMEALMENU(menuDr))
    s str=^DHCIPMEALMENU(menuDr)
    s menuStatus=$p(str,"^",3)   ;状态
    q:(status'="")&&(status'=menuStatus)  ;根据状态过滤
    s menuStartDate=$p(str,"^",1) ;使用日期
    s menuAddDate=$p(str,"^",5)   ;添加日期
    s menulAddUser=$p(str,"^",7)  ;添加人
    s menulAddUserName=""
    s menuLocDr=$p(str,"^",4)    
    s menuLocDesc="" 
    i menuLocDr'="" s menuLocDesc=$p(^CTLOC(menuLocDr),"^",2)  ;科室
    i menulAddUser'="" s menulAddUserName=$p(^SSU("SSUSR",menulAddUser),"^",2)
    i menuStartDate'="" s menuStartDate=$zd(menuStartDate,3)
	i menuAddDate'="" s menuAddDate=$zd(menuAddDate,3)
    s menuRemark=$p(str,"^",8)    ;备注
    s comment1=$p(str,"^",9)
    s comment2=$p(str,"^",10)
    s menuItmStatus=$p(str,"^",11)
   	
    d OutputRow1
	q
OutputRow1
	set Data=$lb(menuDr,menuStartDate,menulAddUser,menulAddUserName,menuAddDate,menuStatus,menuRemark,menuLocDesc,comment1,comment1,menuItmStatus)
	            //menurowid,menustartdate,menuladduser,menuaddusername,menuadddate,status,menuremark,menuloc,comment1,comment2
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMenuInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuInfoExecute ]
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

Query FindMenuInfo(menuRowid As %String = "", startDate As %String = "", addUser As %String = "", status As %String = "", queryStDate As %String = "", queryEndDate As %String = "") As %Query(ROWSPEC = "menurowid,menustartdate,menuladduser,menuaddusername,menuadddate,status,menuremark,menuloc,comment1,comment2,menuitmstatus")
{
}

/// Creator:yyx
/// CreateDate:2010-05-19
/// Function  :复制菜单模板
/// Input     :LastMenuRowID,UseDate,AddUser
ClassMethod InsertMenuTemplate(LastMenuRowID, UseDate, AddUser)
{
	;35^2012-03-12^1
   
    i UseDate["-" s UseDate=$zdh(UseDate,3)
	q:$d(^DHCIPMEALMENU(0,"StartDate",UseDate))=10 "err001"
	q:LastMenuRowID="" -1
	
	s RetVal=0
	TStart
	k PLIST
	&sql(select * into:PLIST() from dhc_ipmealmenu where dhcmm_rowid=:LastMenuRowID)
	s LastStartDate=PLIST(2)
	s PLIST(2)=UseDate
	s PLIST(4)="T"
	s PLIST(6)=+$h
	s PLIST(7)=$P($h,",",2)
	s PLIST(8)=AddUser
	k PLIST(1)
	&sql(INSERT INTO DHC_IPMealMenu Values :PLIST())
	s RetVal=SQLCODE
	s MenuRowID=$g(%ROWID)
	i RetVal=0  d
	.s Num=0
	.f OldDate=LastStartDate:1:(LastStartDate+6) d
	..s NewStDate=UseDate+Num
	..s Num=Num+1
	..s ChildSub=0
	..f  s ChildSub=$o(^DHCIPMEALMENU(0,"DetailStartDate",OldDate,LastMenuRowID,ChildSub)) q:(ChildSub="")!(RetVal'=0)  d
	...s MenuDetRowID=LastMenuRowID_"||"_ChildSub
	...k PLIST
	...&sql(select * into:PLIST() from dhc_ipmealmenudetail where dhcmmd_rowid=:MenuDetRowID)
    ...K PLIST(1),PLIST(2)
    ...s PLIST(0)=MenuRowID
    ...s PLIST(10)=NewStDate
    ...s PLIST(6)=+$H
    ...S PLIST(7)=$p($h,",",2)
    ...s PLIST(8)=AddUser
    ...s PLIST(11)="N"  ;模板另存后，设置模板明细的状态为可修改状态
    ...&sql(insert into DHC_IPMealMenuDetail values :PLIST())
    ...s RetVal=SQLCODE
    i RetVal=0 tcommit
    e  trollback
    q RetVal
}

/// Creator:Lid
/// CreateDate:2010-05-21
/// Function  :更新周菜谱状态
/// Input     :UpdateUser
/// 			   updateDate:menuRowid_^_menuStatus_$c(2)_menuRowid_^_menuStatus_$c(2)_...
/// w ##class(DHCBILL.Diet.DHCIPMealCreateMenu).UpdateMenuStatus("","")
ClassMethod UpdateMenuStatus(Data, UpdateUser)
{
	TStart
	s rtn=0
	s l=$L(Data,$c(2))
	f i=1:1:l d  q:rtn'=0
	.k PLIST
	.s str=$p(Data,$c(2),i)
	.s menuRowid=$p(str,"^",1)
	.s menuStatus=$p(str,"^",2)
	.s updateDate=+$h
	.s updateTime=$p($h,",",2)
	.s PLIST(4)=menuStatus,PLIST(12)=updateDate,PLIST(13)=updateTime,PLIST(14)=UpdateUser
	.&sql(update DHC_IPMealMenu values :PLIST() where DHCMM_RowID=:menuRowid)
	.s rtn=SQLCODE
	.i menuStatus="A" s menuItmStatus="Y"
	.e  s menuItmStatus="N"
	.s rtn=$$UpdateMenuDetalis(menuRowid,menuItmStatus)
	
	i rtn=0 tcommit
	e  trollback
	
	q rtn
	
UpdateMenuDetalis(menuRowid,menuItmStatus)
	s sub="0",rtnValue=0
	f  s sub=$o(^DHCIPMEALMENU(menuRowid,"M",sub)) q:((sub="")!(rtnValue'=0))  d
	.s menuItmRowid=menuRowid_"||"_sub
	.&sql(update DHC_IPMealMenuDetail set DHCMMD_ItmStatus=:menuItmStatus where DHCMMD_RowID=:menuItmRowid)
	.s rtnValue=SQLCODE
	q rtnValue
}

/// Lid 
/// 2010-08-10
/// 餐普Rowid或菜谱明细Rowid，验证菜谱状态
/// 返回值:0(模板),1(已用)
ClassMethod CheckMenuStatus(menuRowid, menuItmRowid)
{
	s rtn=0
	q:((menuRowid="")&(menuItmRowid="")) rtn
	s menuDr=""
	f  s menuDr=$o(^DHCIPMEALMENU(0,"Status","A",menuDr)) q:menuDr=""!rtn=1  d
	.i menuDr=menuRowid s rtn=1
	q:rtn=1 rtn
	q:menuItmRowid="" rtn
	s menuItmStatus=$p(^DHCIPMEALMENU(+menuItmRowid,"M",$p(menuItmRowid,"||",2)),"^",9)
	i "Y"=menuItmStatus s rtn=1
	q rtn
}

/// Lid
/// 2010-10-17
/// 保存菜谱明细顺序
/// indexList:(顺序号_$c(2)_菜谱明细Rowid_"^"_顺序号_$c(2)_菜谱明细Rowid_"^"_...)
/// guser:更新人
ClassMethod SaveMenuDetailOrder(indexList, guser)
{
	
	//序号交换,不能用界面上的序号
	k ^TMP("SaveMenuDetailOrder")
	s count=0
	;按sortIndex大小写顺序 ;wanghc 2010-12-15 分页情况
	s len=$l(indexList,"^")
	f i=1:1:len d 
	.s item=$p(indexList,"^",i) 
	.s sortIndex=$p(item,$c(2),2) 
	.i $d(^TMP("SaveMenuDetailOrder",sortIndex)) d
	..s count=count+1  
	.e  d
	..s ^TMP("SaveMenuDetailOrder",sortIndex)=0
	s maxIndex=0
	&sql(select Max(dhcmmd_index) into :maxIndex from DHC_IPMealMenuDetail)
	f j=1:1:count d
	.s ^TMP("SaveMenuDetailOrder",maxIndex+j)=0
	
	s sortIndex=0
	TStart
	s rtn=0
	s updateIndexDate=+$h
	s updateIndexTime=+$p($h,",",2)
	f i=1:1:len d  q:rtn'=0
	.s item=$p(indexList,"^",i) ;wanghc 
	.s menuItmRowid=$p(item,$c(2),1)
	.s sortIndex=$o(^TMP("SaveMenuDetailOrder",sortIndex))
	.&sql(update DHC_IPMealMenuDetail set DHCMMD_Index=:sortIndex,DHCMMD_UpdateIndexUser_Dr=:guser,DHCMMD_UpdateIndexDate=:updateIndexDate,DHCMMD_UpdateIndexTime=:updateIndexTime where DHCMMD_RowID=:menuItmRowid)
    .s rtn=SQLCODE
    i rtn=0 d
	.Tcommit
	e  d
	.Trollback
	k ^TMP("SaveMenuDetailOrder")
	q rtn
}

/// wanghc 第一次用来生成用户序号  
ClassMethod createIndex()
{
	s index=1
	s menu=0 f  s menu=$o(^DHCIPMEALMENU(menu)) q:menu=""  d
	.s sub=0  f  s sub=$o(^DHCIPMEALMENU(menu,"M",sub)) q:sub=""  d
	..s menuItmRowid=menu_"||"_sub
	..&sql(update DHC_IPMealMenuDetail set DHCMMD_Index=:index where DHCMMD_RowID=:menuItmRowid)
	..s index=index+1
}

ClassMethod test(arg1 As %String)
{
	q arg1
}

ClassMethod QueryMenuDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMenuDetailExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Lid
/// CreatDate:2012-03-20
/// Desc:菜谱明细查询
/// Input:MenuRowID:菜谱指针
/// Output:
/// Return:
/// Dubug:w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealCreateMenu","QueryMenuDetail",34,"","")
ClassMethod QueryMenuDetailExecute(ByRef qHandle As %Binary, MenuRowID As %String, Guser As %String, PrtDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set Job=$j
    Kill MenuDetailsAry(Job)
    Set Sub="0"
    For  Set Sub=$o(^DHCIPMEALMENU(MenuRowID,"M",Sub)) Quit:Sub=""  Do
    .Set s=$g(^DHCIPMEALMENU(MenuRowID,"M",Sub))
    .Set MealItmDR=$p(s,"^",1)	;DHCMMD_MealItm_Dr
    .Quit:+MealItmDR=0
    .Set ItmStartDate=$p(s,"^",8)
    .Set MenuDetailsAry(Job,ItmStartDate,MenuRowID_"||"_Sub)="" ;按时间排序索引 
  	;
    Set Date=""
    For  Set Date=$o(MenuDetailsAry(Job,Date)) Quit:Date=""  Do
    .;计算星期几
    .Set Week=$zd(Date,10)
    .Set:Week=0 Week="星期日"
    .Set:Week=1 Week="星期一"
    .Set:Week=2 Week="星期二"
    .Set:Week=3 Week="星期三"
    .Set:Week=4 Week="星期四"
    .Set:Week=5 Week="星期五"
    .Set:Week=6 Week="星期六"
    .Set DisplayDate=$zd(Date,3)_"("_Week_")"
    .Set MDRowID=""
    .For  Set MDRowID=$o(MenuDetailsAry(Job,Date,MDRowID)) Quit:MDRowID=""  Do
    ..Set MenuStartDate=$p(^DHCIPMEALMENU(+MDRowID),"^",1)
    ..Set:MenuStartDate'="" MenuStartDate=$zd(MenuStartDate,3)
    ..Set s=$g(^DHCIPMEALMENU(+MDRowID,"M",$p(MDRowID,"||",2)))
    ..Quit:+s=0
    ..Set MealItmDR=$p(s,"^",1)	;DHCMMD_MealItm_Dr
    ..Set ItmStr=$g(^DHCIPMEALITEM(MealItmDR))
    ..Set MealItmCode=$p(ItmStr,"^",1)     ;菜编码
    ..Set MealItmDesc=$p(ItmStr,"^",2)     ;菜名
    ..Set MealItmPrice=##class(DHCBILL.Diet.DHCIPMealFeeBill).GetMenuItmPrice(MealItmDR,+$h) ;菜单价
    ..Set MealItmUOMDR=$p(ItmStr,"^",5) 
    ..Set MealItmUOMDesc=$p(^DHCIPMEALUOM(MealItmUOMDR),"^",2)  ;菜单位
    ..Set MealItmRemark=$p(ItmStr,"^",12)      ;菜备注
    ..Set MealTypeDr=$p(s,"^",2)   ;菜类型
    ..Set MealTypeDesc=""
    ..If MealTypeDr'="" Set MealTypeDesc=$p(^DHCIPMEALTYPE(MealTypeDr),"^",2)
    ..Set MealModDr=$p(s,"^",3)    ;菜形态
    ..Set MealModDesc=""
    ..If MealModDr'="" Set MealModDesc=$p(^DHCIPMEALMODALITY(MealModDr),"^",2)
    ..Do OutputRow11
    ;
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow11
	set Data=$lb(DisplayDate,MealItmDesc,MealTypeDesc,MealModDesc,$j(MealItmPrice,3,2),MealItmRemark,MDRowID,MealItmDR,MenuStartDate)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryMenuDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMenuDetailExecute ]
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

Query QueryMenuDetail(MenuRowID As %String, Guser As %String, PrtDate As %String) As %Query(ROWSPEC = "DisplayDate,MealItmDesc,MealTypeDesc,MealModDesc,MealItmPrice,MealItmRemark,MDRowID,MealItmDR,MenuStartDate") [ SqlProc ]
{
}

}
