Import sqluser

/// DHCBILL.Diet.DHCIPMealMenuLogic.cls
/// 菜谱制作逻辑类
/// Lid
/// 2010-05-15
Class DHCBILL.Diet.DHCIPMealMenuLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取菜谱导航树信息
/// w ##class(DHCBILL.Diet.DHCIPMealMenuLogic).GetMealMenuTreeJson("tree"_$c(2)_1_$c(2)_"2010-05-14")
/// node:根节点id
/// date:默认为该日期所在周的星期一的日期
ClassMethod GetMealMenuTreeJson(nodestr)
{
	q:nodestr="" "[]"
	
	s node=+$p(nodestr,$c(2),2)
	s date=$p(nodestr,$c(2),3)
	b ;1
	i date["-" s date=$zdh(date,3)
	s tmp="星期一^星期二^星期三^星期四^星期五^星期六^星期日"
	s treeJson="["

	i node=0 d   ;0：根节点ID
	.//如果是根节点则取根节点上日期绑定的日期对应的下周一的日期
	.s date=##class(DHCBILL.Diet.DHCIPMealCommon).getWeedDateByDate("N",date,1)
	.s weekDate=date
	.f i=1:1:7 d                                                                                                            
	..i treeJson="[" s treeJson=treeJson_"{id:'tree"_$c(2)_i_$c(2)_$zd(weekDate,3)_"',text:'"_$p(tmp,"^",i)_"',isClass:true,iconCls:'week',singleClickExpand:true,qtip:'"_$zd(weekDate,3)_" "_$p(tmp,"^",i)_"'}"
	..e  s treeJson=treeJson_",{id:'tree"_$c(2)_i_$c(2)_$zd(weekDate,3)_"',text:'"_$p(tmp,"^",i)_"',isClass:true,iconCls:'week',singleClickExpand:true,qtip:'"_$zd(weekDate,3)_" "_$p(tmp,"^",i)_"'}"
	..s weekDate=weekDate+1
	e  d
	.;s parentid=$p(node,$c(2),2)   ;父节点id
	.;s mmdate=$p(node,$c(2),3)     ;所查询的菜谱日期
	.s RowID=0
	.f  s RowID=$o(^DHCIPMEALTYPE(RowID)) q:RowID=""  d
	..q:'$d(^DHCIPMEALTYPE(RowID))
    ..s MealTypeInfo=^DHCIPMEALTYPE(RowID)
    ..s MealCode=$p(MealTypeInfo,"^",1)
    ..s MealDesc=$p(MealTypeInfo,"^",2)
    ..s MealRemark=$p(MealTypeInfo,"^",3)
    ..s MealPYM=$p(MealTypeInfo,"^",4)
	..i treeJson="[" s treeJson=treeJson_"{id:'tree"_$c(2)_node_$c(2)_RowID_$c(2)_$zd(date,3)_"',text:'"_MealDesc_"',isClass:true,singleClickExpand:true,leaf:true,qtip:'"_$zd(date,3)_" "_MealDesc_"'}"
	..e  s treeJson=treeJson_",{id:'tree"_$c(2)_node_$c(2)_RowID_$c(2)_$zd(date,3)_"',text:'"_MealDesc_"',isClass:true,singleClickExpand:true,leaf:true,qtip:'"_$zd(date,3)_" "_MealDesc_"'}"
	
	//i node=0 s treeJson=treeJson_",{id:'tree"_$c(2)_"WEEK"_$c(2)_$zd(date,3)_"'}"
   	//e  s treeJson=treeJson_",{id:'tree"_$c(2)_"DAY"_$c(2)_$zd(date,3)_"',text:'全天',isClass:true,singleClickExpand:true,leaf:true,qtip:'"_$zd(date,3)_"'}"
   	i node'=0 s treeJson=treeJson_",{id:'tree"_$c(2)_"DAY"_$c(2)_$zd(date,3)_"',text:'全天',isClass:true,singleClickExpand:true,leaf:true,qtip:'"_$zd(date,3)_"'}"
    s treeJson=treeJson_"]"
	
	q treeJson
	
	/*
	s RowID=0
	f  s RowID=$o(^DHCIPMEALTYPE(RowID)) q:RowID=""  d
	.q:'$d(^DHCIPMEALTYPE(RowID))
    .s MealTypeInfo=^DHCIPMEALTYPE(RowID)
    .s MealCode=$p(MealTypeInfo,"^",1)
    .s MealDesc=$p(MealTypeInfo,"^",2)
    .s MealRemark=$p(MealTypeInfo,"^",3)
    .s MealPYM=$p(MealTypeInfo,"^",4)
    .s MealComment1=$p(MealTypeInfo,"^",5)
    .s MealComment2=$p(MealTypeInfo,"^",6)
    .
    
    q
    */
    /*
    	q:+wardRowid=0 "[]"
	s paadmTreeJson="["
	s roomRowid="" f  s roomRowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid))  q:roomRowid=""  d
	.s rowid="" f  s rowid=$o(^PAADMi("CurrWard",wardRowid,roomRowid,rowid)) q:rowid=""  d
	..s patinfo=$g(^PAADM(rowid))
	..q:patinfo=""
	..s papmidr=+$p(^PAADM(rowid),"^",1)
	..s name=$p(^PAPER(papmidr,"ALL"),"^",1)
	..s medicare=$p(^PAPER(papmidr,"PAT",1),"^",22)
	..s info=name_"("_medicare_")"
	..i paadmTreeJson="[" d
	...s paadmTreeJson=paadmTreeJson_"{id:'PAPER-"_papmidr_"-AdmRowid-"_rowid_"',text:'"_info_"',leaf:true}"
	..e  d
	...s paadmTreeJson=paadmTreeJson_",{id:'PAPER-"_papmidr_"-AdmRowid-"_rowid_"',"_"text:'"_info_"',leaf:true}"
	q paadmTreeJson_"]"
    */
}

/// Lid
/// 2010-08-09
/// 根据菜谱开始日期生成星期
ClassMethod GetWeekByMenuStDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWeekByMenuStDateExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Lid
/// 2010-05-17
/// 根据日期,菜谱Rowid,餐类型查询菜谱明细
/// w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealMenuLogic","GetWeekByMenuStDate","2010-08-09")
ClassMethod GetWeekByMenuStDateExecute(ByRef qHandle As %Binary, startDate As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i (startDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    s startDate=$zdh(startDate,3)
    b ;
    f i=0:1:6 d
    .s weekDate=$zd(startDate+i,3)
    .b ;2
    .i i=0 s week="星期一"
    .i i=1 s week="星期二"
    .i i=2 s week="星期三"
    .i i=3 s week="星期四"
    .i i=4 s week="星期五"
    .i i=5 s week="星期六"
    .i i=6 s week="星期日"
    .d Output
   	Set qHandle=$lb(0,repid,0)
   	Quit $$$OK
Output
	set Data=$lb(weekDate,week)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWeekByMenuStDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWeekByMenuStDateExecute ]
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

Query GetWeekByMenuStDate(startDate As %String = "") As %Query(ROWSPEC = "id,week")
{
}

}
