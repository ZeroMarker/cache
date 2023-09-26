/// Creator:gzj
/// Desctiptions:质控打分公共类
/// Date:2017-09-20
Class web.NurMgQualCheckComm Extends %RegisteredObject
{

/// Creator:lulin
/// Description:获取重组三级评分项
/// Date:2017-09-20
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindModelItems","2")
Query FindModelItems(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindModelItemsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualModelSubI("par"," ",parr,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0 ;一级合并数量，所含二级数量
	.s obj1=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parr_"||"_rw1)
	.q:'$IsObject(obj1)
	.q:((obj1.RestructStDate'="")&&(obj1.RestructStDate>nowdate))
	.q:((obj1.RestructEndDate'="")&&(obj1.RestructEndDate<nowdate))
	.q:$L(obj1.RestructSort,".")'=2
	.i '$d(^DHCNMG.DB.MgQualModelSubI("par"," "_obj1.%Id(),parr)) d
	..s tmp("colspan",rw1)=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualModelSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0 ;二级合并数量（二级下三级数量）
	...s obj2=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parr_"||"_rw2)
	...q:('$IsObject(obj2))
	...q:((obj2.RestructStDate'="")&&(obj2.RestructStDate>nowdate))
	...q:((obj2.RestructEndDate'="")&&(obj2.RestructEndDate<nowdate))
	...q:$L(obj2.RestructSort,".")'=3
	...i '$d(^DHCNMG.DB.MgQualModelSubI("par"," "_obj2.%Id(),parr)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualModelSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.RestructStDate'="")&&(obj3.RestructStDate>nowdate))
	.....q:((obj3.RestructEndDate'="")&&(obj3.RestructEndDate<nowdate))
	.....q:$L(obj3.RestructSort,".")'=2
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	
	s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(parr)
	;2、循环输出，包含每一级的隐藏信息（重组模版id等）
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualModelSubI("par"," ",parr,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parr_"||"_rw1)
	.q:('$IsObject(obj1))
	.q:((obj1.RestructStDate'="")&&(obj1.RestructStDate>nowdate))
	.q:((obj1.RestructEndDate'="")&&(obj1.RestructEndDate<nowdate))
	.q:$L(obj1.RestructSort,".")'=2
	.i '$d(^DHCNMG.DB.MgQualModelSubI("par"," "_obj1.%Id(),parr)) d
	..;无子集
	..s realscore=obj1.RestructScore
	..s:obj.RestructScoreType'=2 realscore=1
	..s sort=obj1.RestructSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.RestructItem_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|1"_"^onesort|"_obj1.RestructSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj1.RestructStand_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualModelSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parr_"||"_rw2)
	...q:('$IsObject(obj2))
	...q:((obj2.RestructStDate'="")&&(obj2.RestructStDate>nowdate))
	...q:((obj2.RestructEndDate'="")&&(obj2.RestructEndDate<nowdate))
	...q:$L(obj2.RestructSort,".")'=3
	...s realscore=obj2.RestructScore
	...s:obj.RestructScoreType'=2 realscore=1
	...s sort=obj2.RestructSort
	...i '$d(^DHCNMG.DB.MgQualModelSubI("par"," "_obj2.%Id(),parr)) d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.RestructItem_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.RestructSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.RestructItem_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.RestructSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj2.RestructStand_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	...e  d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.RestructItem_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.RestructSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.RestructItem_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.RestructSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^twoRealScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualModelSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.RestructStDate'="")&&(obj3.RestructStDate>nowdate))
	.....q:((obj3.RestructEndDate'="")&&(obj3.RestructEndDate<nowdate))
	.....q:$L(obj3.RestructSort,".")'=4
	.....s realscore=obj3.RestructScore
	.....s:obj.RestructScoreType'=2 realscore=1
	.....s sort=obj3.RestructSort
	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.RestructItem_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.RestructSort_"^twoModelDesc|"_obj2.RestructItem_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twoIsShow|"_isShow2_"^twosort|"_obj2.RestructSort_"^threeModelDesc|"_obj3.RestructItem_"^threeModelId|"_$tr(obj3.%Id(),"||","__")_"^threesort|"_obj3.RestructSort_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj3.RestructStand_"^twoRealScore|"_tmp("colspan",rw2)_"^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	.....//s isShow1=0,isShow2=0
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreData
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindModelItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindModelItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindModelItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindModelItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪聪
/// Description:获取标版评分项（包钢）
/// Date:2019-09-05
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCheckItemsBG","17")
Query FindCheckItemsBG(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckItemsBGExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0 ;一级合并数量，所含二级数量
	.s obj1=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw1)
	.q:'$IsObject(obj1)
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr)) d
	..s tmp("colspan,rw1")=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0 ;二级合并数量（二级下三级数量）
	...s obj2=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw2)
	...q:'$IsObject(obj2)
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	
	s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(parr)
	;2、循环输出，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw1)
	.q:('$IsObject(obj1))
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr)) d
	..;无子集
	..s realscore=obj1.SubScore
	..s:obj.QualScoreType'=2 realscore=1
	..s sort=obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|1"_"^onesort|"_obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_realscore_"^realScore|"_realscore_"^negScore|"_0_"^StandardScore|"_obj1.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw2)
	...q:('$IsObject(obj2))
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...s realscore=obj1.SubScore
	...s:obj.QualScoreType'=2 realscore=1
	...s sort=obj2.SubSort
	...i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr))  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_realscore_"^realScore|"_realscore_"^negScore|"_0_"^StandardScore|"_obj2.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	...e  d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^negScore|^StandardScore|^twoRealScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s realscore=obj3.SubScore
	.....s:obj.QualScoreType'=2 realscore=1
	.....s sort=obj3.SubSort
	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort_"^threeModelDesc|"_obj3.SubDesc_"^threeModelId|"_$tr(obj3.%Id(),"||","__")_"^threesort|"_obj3.SubSort_"^Score|"_realscore_"^realScore|"_realscore_"^StandardScore|"_obj3.SubStandard_"^twoRealScore|"_tmp("colspan",rw2)_"^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	.....//s isShow1=0,isShow2=0
	
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..//s:sort2=0 TwoIsShow=0
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreData
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckItemsBGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckItemsBGExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckItemsBGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckItemsBGExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取标版评分项
/// Date:2017-09-20
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCheckItems","17")
Query FindCheckItems(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckItemsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0 ;一级合并数量，所含二级数量
	.s obj1=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw1)
	.q:'$IsObject(obj1)
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr)) d
	..s tmp("colspan,rw1")=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0 ;二级合并数量（二级下三级数量）
	...s obj2=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw2)
	...q:'$IsObject(obj2)
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	
	s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(parr)
	;2、循环输出，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.DB.MgQualItemSubI("par"," ",parr,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw1)
	.q:('$IsObject(obj1))
	.q:((obj1.SubStDate'="")&&(obj1.SubStDate>nowdate))
	.q:((obj1.SubEndDate'="")&&(obj1.SubEndDate<nowdate))
	.q:$l(obj1.SubSort,".")'=2
	.i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr)) d
	..;无子集
	..s realscore=obj1.SubScore
	..s:obj.QualScoreType'=2 realscore=1
	..s sort=obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|1"_"^onesort|"_obj1.SubSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_$fn(realscore,"",2)_"^realScore|"_$fn(realscore,"",2)_"^StandardScore|"_obj1.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj1.%Id(),parr,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw2)
	...q:('$IsObject(obj2))
	...q:((obj2.SubStDate'="")&&(obj2.SubStDate>nowdate))
	...q:((obj2.SubEndDate'="")&&(obj2.SubEndDate<nowdate))
	...q:$l(obj2.SubSort,".")'=3
	...s realscore=obj2.SubScore
	...s:obj.QualScoreType'=2 realscore=1
	...s sort=obj2.SubSort
	...i '$d(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr))  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_$fn(realscore,"",2)_"^realScore|"_$fn(realscore,"",2)_"^StandardScore|"_obj2.SubStandard_"^twoRealScore|1^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	...e  d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^twoRealScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s rw3="" f  s rw3=$o(^DHCNMG.DB.MgQualItemSubI("par"," "_obj2.%Id(),parr,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.DB.MgQualItemSub).%OpenId(parr_"||"_rw3)
	.....q:('$IsObject(obj3))
	.....q:((obj3.SubStDate'="")&&(obj3.SubStDate>nowdate))
	.....q:((obj3.SubEndDate'="")&&(obj3.SubEndDate<nowdate))
	.....q:$l(obj3.SubSort,".")'=4
	.....s realscore=obj3.SubScore
	.....s:obj.QualScoreType'=2 realscore=1
	.....s sort=obj3.SubSort
	.....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.SubDesc_"^oneModelId|"_$tr(obj1.%Id(),"||","__")_"^oneColSpan|"_tmp("colspan",rw1)_"^onesort|"_obj1.SubSort_"^twoModelDesc|"_obj2.SubDesc_"^twoModelId|"_$tr(obj2.%Id(),"||","__")_"^twoColSpan|"_tmp("colspan",rw2)_"^twosort|"_obj2.SubSort_"^threeModelDesc|"_obj3.SubDesc_"^threeModelId|"_$tr(obj3.%Id(),"||","__")_"^threesort|"_obj3.SubSort_"^Score|"_$fn(realscore,"",2)_"^realScore|"_$fn(realscore,"",2)_"^StandardScore|"_obj3.SubStandard_"^twoRealScore|"_tmp("colspan",rw2)_"^SubRowID|^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	.....//s isShow1=0,isShow2=0
	
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..//s:sort2=0 TwoIsShow=0
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreData
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:判断当前节点是否存在子节点
/// Date:2017-09-21
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod IsExistChildNode(par, rw) As %String
{
	s flag=0
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualModelSubD(par,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_rowid)
	.q:obj.RestructPar=""
	.q:(obj.RestructPar'=(par_"||"_rw))
	.s flag=1
	q flag
}

/// Creator:lulin
/// Description:计算质控指标所有节点都≥3符合要求，否则不符合要求
/// Date:2018年3月16日 08:52:20
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod qualLevelIsOk(parr) As %String
{
	s flag=1
	//计算一共有多少层
	s rw="" f  s rw=$o(^DHCNMG.DB.MgQualModelSubD(parr,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(parr_"||"_rw)
	.q:('$IsObject(obj))
	.s levelNum=$l(obj.RestructSort,".")-1	
	.s:(levelNum<3)&&('$d(^DHCNMG.DB.MgQualModelSubI("par"," "_obj.%Id()))) flag=0
	s:'$d(^DHCNMG.DB.MgQualModelSubD(parr)) flag=0
	q flag
}

/// Creator:gzj
/// Description:获取质控模板总分
/// Date:2017-09-26
/// Table: DHCNMG.DB.MgQualModelSub
/// Input:
/// Output：
/// Return:
ClassMethod GetCheckRoomRecScore(par As %String) As %String
{
	s score=0
	s row="" f  s row=$O(^DHCNMG.DB.MgQualModelSubD(par,row)) q:row=""  d
	.s obj=##class(DHCNMG.DB.MgQualModelSub).%OpenId(par_"||"_row)
	.s flag=..IsExistChildNode(par,row)
	.q:flag=1
	.s score=score+obj.RestructScore
	q score
}

/// Creator:gzj
/// Description:保存质控检查父表数据
/// Date:2017-09-26
/// Table: DHCNMG.CHK.MgCheckRoom
/// Input:
/// Output：
/// Return:
ClassMethod SaveCheckRoomRec(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("RowID"))'="" d
	.s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(tmp("RowID"))
	e  s obj=##class(DHCNMG.CHK.MgCheckRoom).%New()
	i $g(tmp("ScoreWard"))'="" s obj.ScoreWard=$g(tmp("ScoreWard"))
	i $g(tmp("CheckUser"))'="" s obj.CheckUser=$g(tmp("CheckUser"))
	i $g(tmp("CheckMonth"))'="" s obj.CheckMonth=$zdh(tmp("CheckMonth")_"-01",3)
	e  s obj.CheckMonth=""
	s obj.CheckScore=$g(tmp("CheckScore"))
	s obj.Status=$g(tmp("Status"))
	s obj.CheckDR=$g(tmp("CheckDR"))
	s obj.CheckType=$g(tmp("CheckType"))
	s obj.CheckScoreType=$g(tmp("CheckScoreType"))
	i $g(tmp("Status"))="S" s obj.SubmitDate=+$H
	s obj.TaskID=$g(tmp("TaskID"))
	s obj.Remark=$replace($tr($g(tmp("CheckRemark"))," ",""),$c(10),"")
	s sc=obj.%Save()
	q obj.%Id()
}

/// Creator:gzj
/// Description:保存质控检查对应子表数据
/// Date:2017-09-26
/// UpdateDate:2018年3月21日 08:57:40
/// Table: DHCNMG.CHK.MgCheckRoomSub
/// Input:
/// Output：
/// Return:
ClassMethod SaveCheckRoomSub(parr As %String, par As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s type=tmp("checkType")
	i $g(tmp("SubRowID"))="" d
	.i $g(tmp("threeModelId"))'="" d
	..s id=$O(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("threeModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id
	.e  i $g(tmp("twoModelId"))'="" d
	..s id=$O(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("twoModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id
	.e  d
	..s id=$O(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("oneModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id

	i $g(tmp("SubRowID"))="" d
	.s type=tmp("checkType"),parentId=""
	.;检测一级质控是否已存在，不存在则保存。
	.i ($g(tmp("oneModelId"))'="")&&('$d(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("oneModelId"),par))) d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%New()
	..s obj.Parref=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	..s obj.CheckItem=$g(tmp("oneModelDesc"))
	..s obj.CheckModelDR=tmp("oneModelId")
	..s obj.CheckColSpan=+$g(tmp("oneColSpan"))
	..s obj.ItemFlag="1"
	..s obj.CheckType=type
	..s obj.CheckSort=$g(tmp("onesort"))
	..s sc=obj.%Save()
	.s parentId=$o(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("oneModelId"),par,""))
	.i ($g(tmp("twoModelId"))'="")&&('$d(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("twoModelId"),par))) d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%New()
	..s obj.Parref=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	..s obj.CheckItem=$g(tmp("twoModelDesc"))
	..s obj.CheckModelDR=tmp("twoModelId")
	..s:parentId'="" obj.CheckItemParentDR=par_"||"_parentId
	..s obj.CheckColSpan=+$g(tmp("twoColSpan"))
	..s obj.ItemFlag="2"
	..s obj.CheckType=type
	..s obj.CheckSort=$g(tmp("twosort"))
	..s sc=obj.%Save()
	.s parentId=$o(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("twoModelId"),par,""))
	.i $g(tmp("threeModelId"))'="" d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%New()
	..s obj.Parref=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	..s obj.CheckItem=$g(tmp("threeModelDesc"))
	..s obj.CheckModelDR=tmp("threeModelId")
	..s:parentId'="" obj.CheckItemParentDR=par_"||"_parentId
	..s obj.ItemFlag="3"
	..s obj.CheckType=type
	..s obj.CheckColSpan="1"
	..s obj.CheckSort=$g(tmp("threesort"))
	..s sc=obj.%Save()
	.s obj.CheckItemStand=tmp("StandardScore")
	.s obj.StandardScore=tmp("Score")
	.s obj.CheckType=type
	e  s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(tmp("SubRowID"))
	s obj.CheckItemScore=tmp("realScore")
	s obj.CheckTwoScore=tmp("twoRealScore")
	s obj.CheckItemRemark=tmp("CheckItemRemark")
	s sc=obj.%Save()
	
	Tc
	q $$$ISOK(sc)
}

/// Creator:王聪聪
/// Description:保存质控检查对应子表数据（包钢）
/// Date:2017-09-26
/// UpdateDate:2019年9月5日 08:57:40
/// Table: DHCNMG.CHK.MgCheckRoomSub
/// Input:
/// Output：
/// Return:
ClassMethod SaveCheckRoomSubBG(parr As %String, par As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	TS
	s type=tmp("checkType")
	i $g(tmp("SubRowID"))="" d
	.i $g(tmp("threeModelId"))'="" d
	..s id=$O(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("threeModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id
	.e  i $g(tmp("twoModelId"))'="" d
	..s id=$O(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("twoModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id
	.e  d
	..s id=$O(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("oneModelId"),par,""))
	..s:id'="" tmp("SubRowID")=par_"||"_id

	i $g(tmp("SubRowID"))="" d
	.s type=tmp("checkType"),parentId=""
	.;检测一级质控是否已存在，不存在则保存。
	.i ($g(tmp("oneModelId"))'="")&&('$d(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("oneModelId"),par)))&&($g(tmp("twoModelId"))="") d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%New()
	..s obj.Parref=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	..s obj.CheckItem=$g(tmp("oneModelDesc"))
	..s obj.CheckModelDR=tmp("oneModelId")
	..s obj.CheckItemScore=tmp("realScore")
	..s obj.CheckItemNegScore=tmp("negScore")
	..s obj.CheckColSpan=+$g(tmp("oneColSpan"))
	..s obj.ItemFlag="1"
	..s obj.CheckType=type
	..s obj.CheckSort=$g(tmp("onesort"))
	..s sc=obj.%Save()

	.i ($g(tmp("oneModelId"))'="")&&('$d(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("oneModelId"),par)))&&($g(tmp("twoModelId"))'="") d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%New()
	..s obj.Parref=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	..s obj.CheckItem=$g(tmp("oneModelDesc"))
	..s obj.CheckModelDR=tmp("oneModelId")
	..s obj.CheckItemScore=tmp("realScore")
	..s obj.CheckColSpan=+$g(tmp("oneColSpan"))
	..s obj.ItemFlag="1"
	..s obj.CheckType=type
	..s obj.CheckSort=$g(tmp("onesort"))
	..s sc=obj.%Save()
	.s parentId=$o(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("oneModelId"),par,""))
	
	.i ($g(tmp("twoModelId"))'="")&&('$d(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("twoModelId"),par))) d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%New()
	..s obj.Parref=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	..s obj.CheckItem=$g(tmp("twoModelDesc"))
	..s obj.CheckModelDR=tmp("twoModelId")
	..s:parentId'="" obj.CheckItemParentDR=par_"||"_parentId
	..s obj.CheckColSpan=+$g(tmp("twoColSpan"))
	..s obj.ItemFlag="2"
	..s obj.CheckType=type
	..s obj.CheckItemScore=tmp("realScore")
	..s obj.CheckItemNegScore=tmp("negScore")
	..s obj.CheckSort=$g(tmp("twosort"))
	..s sc=obj.%Save()
	.s parentId=$o(^DHCNMG.CHK.MgCheckRoomSubI("model",type," "_tmp("twoModelId"),par,""))
	
	.i $g(tmp("threeModelId"))'="" d
	..s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%New()
	..s obj.Parref=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	..s obj.CheckItem=$g(tmp("threeModelDesc"))
	..s obj.CheckModelDR=tmp("threeModelId")
	..s:parentId'="" obj.CheckItemParentDR=par_"||"_parentId
	..s obj.ItemFlag="3"
	..s obj.CheckType=type
	..s obj.CheckColSpan="1"
	..s obj.CheckSort=$g(tmp("threesort"))
	..s sc=obj.%Save()
	.s obj.CheckItemStand=tmp("StandardScore")
	.s obj.StandardScore=tmp("Score")
	.s obj.CheckType=type
	.s obj.CheckItemScore=tmp("realScore")
	.s obj.CheckItemNegScore=tmp("negScore")
	e  s obj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(tmp("SubRowID"))
	s obj.CheckItemScore=tmp("realScore")
	s obj.CheckItemNegScore=tmp("negScore")
	s obj.CheckTwoScore=tmp("twoRealScore")
	s obj.CheckItemRemark=tmp("CheckItemRemark")
	s sc=obj.%Save()
	
	Tc
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:质控打分列表
/// Date:2017-09-27
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCheckLists","")
Query FindCheckLists(modelid As %String = "", sorce As %String = "", parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckListsExecute(ByRef qHandle As %Binary, modelid As %String = "", sorce As %String = "", parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s statuParam=$p(parr,"^",1) //状态
	s stdateParam=$p(parr,"^",2) //开始日期
	i stdateParam'="" s stdateParam=$zdh(stdateParam,3)
	s enddateParam=$p(parr,"^",3) //结束日期
	i enddateParam'="" s enddateParam=$zdh(enddateParam,3)
	s wardParam=$p(parr,"^",4) //病区
	s loginID=$p(parr,"^",5)
	i sorce="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i modelid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s isCheck=0
	i sorce=2 d
	.s modelObj=##class(DHCNMG.DB.MgQualModel).%OpenId(modelid)
	.s:($IsObject(modelObj))&&($IsObject(modelObj.RestructGroup)) isCheck=##class(web.NurMgSetComm).IsPerInCheckGroup(loginID,modelObj.RestructGroup.%Id())
	s ward="" f  s ward=$O(^DHCNMG.CHK.MgCheckRoomI("stat",sorce," "_modelid,ward)) q:ward=""  d
	.s month="" f  s month=$O(^DHCNMG.CHK.MgCheckRoomI("stat",sorce," "_modelid,ward,month)) q:month=""  d
	..s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgCheckRoomI("stat",sorce," "_modelid,ward,month,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(rowid)
	...q:(isCheck=1)&&(obj.CheckUser'=loginID)
	...q:((statuParam'="")&&(obj.Status'=statuParam))
	...q:((stdateParam'="")&&(obj.CheckMonth<stdateParam))
	...q:((enddateParam'="")&&(obj.CheckMonth>enddateParam))
	...q:((wardParam'="")&&(obj.ScoreWard'=wardParam))
	...;q:((modelid'="")&&(obj.CheckType'=modelid))
	...s ScoreWard=""
	...i obj.ScoreWard'="" d
	....s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ScoreWard)
	....s ScoreWard=wardObj.WardDesc
	...e  s ScoreWard=""
	...s CheckUser=""
	...i obj.CheckUser'="" d
	....i obj.CheckUser="0" d
	.....s CheckUser="demo"
	....e  d
	.....s nurObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CheckUser)
	.....s CheckUser=nurObj.PerName
	...e  s CheckUser=""
	...s CheckMonth=""
	...i obj.CheckMonth'="" d
	....s CheckMonth=$E($zd(obj.CheckMonth,8),1,6)
	...e  s CheckMonth=""
	...s CheckScore=obj.CheckScore
	...i obj.CreateDate'="" s CreateDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.CreateDate)
	...e  s CreateDate=""
	...i obj.Status="S" s Status="已提交"
	...e  i obj.Status="N" s Status="未提交"
	...e  i obj.Status="B" s Status="驳回"
	...s ret="scoreWard|"_ScoreWard_"^checkUser|"_CheckUser_"^checkMonth|"_CheckMonth_"^checkScore|"_CheckScore_"^createDate|"_CreateDate_"^status|"_Status_"^rowid|"_rowid 
	...d OutputScoreData

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckListsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCheckTitle(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(id)
	s ScoreWard=obj.ScoreWard
	s CheckUser=obj.CheckUser
	s CheckMonth=$zd(obj.CheckMonth,3)
	s CheckScore=obj.CheckScore
	s Status=obj.Status
	s CheckRemark=obj.Remark
	s ret="ScoreWard|"_ScoreWard_"^CheckUser|"_CheckUser_"^CheckMonth|"_CheckMonth_"^CheckScore|"_CheckScore_"^RowID|"_id_"^CheckRemark|"_CheckRemark
	s ret=ret_"^Status|"_Status
	q ret
}

/// Creator:gzj
/// Description:
/// Date:2017-09-20
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindScoreLists","8")
Query FindScoreLists(par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindScoreListsExecute(ByRef qHandle As %Binary, par As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," ",par,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0
	.s obj1=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw1)
	.q:'$IsObject(obj1)
	.i '$d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par)) d
	..s tmp("colspan",rw1)=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0
	...s obj2=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw2)
	...q:'$IsObject(obj2)
	...i '$d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1,tmp("score",rw2)=0
	....s rw3="" f  s rw3=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	.....s tmp("score",rw2)=tmp("score",rw2)+obj3.CheckItemScore
	
	s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	;2、存储输出数据临时数组，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," ",par,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw1)
	.q:'$IsObject(obj1)
	.i '$d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par)) d
	..;无子集
	..s realscore=obj1.CheckItemScore
	..;s:obj.QualScoreType'=2 realscore=1
	..s sort=obj1.CheckSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckModelDR,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_obj1.StandardScore_"^realScore|"_realscore_"^StandardScore|"_obj1.CheckItemStand_"^twoRealScore|"_realscore_"^SubRowID|"_$tr(obj1.%Id(),"||","__")
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^checkType|1"_"^CheckItemRemark|"_obj1.CheckItemRemark_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw2)
	...q:'$IsObject(obj2)
	...s realscore=obj2.CheckItemScore
	...s sort=obj2.CheckSort
	...//s isShow1=..isItemShow(sort,par)
	...i $d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par)) d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckModelDR,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.CheckItem_"^twoModelId|"_$tr(obj2.CheckModelDR,"||","__")_"^twoColSpan|"_obj2.CheckColSpan_"^twosort|"_obj2.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^StandardScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoRealScore|"_tmp("score",rw2)
	...e  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckItem,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.CheckItem_"^twoModelId|"_$tr(obj2.CheckModelDR,"||","__")_"^twoColSpan|"_obj2.CheckColSpan_"^twosort|"_obj2.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_obj2.StandardScore_"^realScore|"_realscore_"^StandardScore|"_obj2.CheckItemStand_"^SubRowID|"_$tr(obj2.%Id(),"||","__")_"^checkType|1"_"^CheckItemRemark|"_obj2.CheckItemRemark_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoRealScore|"_realscore
	...s rw3="" f  s rw3=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par,rw3)) q:rw3=""  d
	....s obj3=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw3)
	....q:'$IsObject(obj3)
	....s realscore=obj3.CheckItemScore
	....s sort=obj3.CheckSort
	....//s isShow1=..isItemShow(obj2.CheckSort,par)
	....//s isShow2=..isItemShow(sort,par)
	....//s isShow1=((isShow1=1)&&(isShow2=1))
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckModelDR,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort_"^twoModelDesc|"_obj2.CheckItem_"^twoModelId|"_$tr(obj2.CheckModelDR,"||","__")_"^twoColSpan|"_obj2.CheckColSpan_"^twosort|"_obj2.CheckSort_"^threeModelDesc|"_obj3.CheckItem_"^threeModelId|"_$tr(obj3.CheckModelDR,"||","__")_"^threesort|"_obj3.CheckSort_"^Score|"_obj3.StandardScore_"^realScore|"_realscore_"^StandardScore|"_obj3.CheckItemStand_"^SubRowID|"_$tr(obj3.%Id(),"||","__")_"^checkType|1"_"^CheckItemRemark|"_obj3.CheckItemRemark_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))=tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))_"^twoRealScore|"_tmp("score",rw2)
	
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreLists
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreLists
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreLists
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindScoreListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreListsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindScoreListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:王聪聪
/// Description:
/// Date:2019-09-05
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindScoreListsBG","8")
Query FindScoreListsBG(par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindScoreListsBGExecute(ByRef qHandle As %Binary, par As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	s rows=1
	s nowdate=+$h
	s showTree=0
	;1、计算出每一层需要合并的数
	s rw1="" f  s rw1=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," ",par,rw1)) q:rw1=""  d
	.s tmp("colspan",rw1)=0,tmp("tworows",rw1)=0
	.s obj1=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw1)
	.q:'$IsObject(obj1)
	.i '$d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par)) d
	..s tmp("colspan",rw1)=tmp("colspan",rw1)+1
	.e  d
	..s rw2="" f  s rw2=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par,rw2)) q:rw2=""  d
	...s tmp("colspan",rw2)=0
	...s obj2=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw2)
	...q:'$IsObject(obj2)
	...i '$d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par)) d
	....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1
	...e  d
	....s tmp("tworows",rw1)=tmp("tworows",rw1)+1,tmp("score",rw2)=0
	....s rw3="" f  s rw3=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par,rw3)) q:rw3=""  d
	.....s obj3=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw3)
	.....q:'$IsObject(obj3)
	.....s tmp("colspan",rw1)=tmp("colspan",rw1)+1,tmp("colspan",rw2)=tmp("colspan",rw2)+1,showTree=1
	.....s tmp("score",rw2)=tmp("score",rw2)+obj3.CheckItemScore
	
	s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(par)
	;2、存储输出数据临时数组，包含每一级的隐藏信息（id等）
	s rw1="" f  s rw1=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," ",par,rw1)) q:rw1=""  d
	.//s isShow1=1
	.s obj1=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw1)
	.q:'$IsObject(obj1)
	.i '$d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par)) d
	..;无子集
	..s realscore=obj1.CheckItemScore
	..s:obj1.CheckItemNegScore="" negscore=0
	..s:obj1.CheckItemNegScore'="" negscore=obj1.CheckItemNegScore
	..;s:obj.QualScoreType'=2 realscore=1
	..s sort=obj1.CheckSort
	..s tmp("sort",$p(sort,"."),0)="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckModelDR,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^twoModelDesc|^twoModelId|^twoColSpan|1^twosort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^threeModelDesc|^threeModelId|^threesort|"
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^Score|"_obj1.StandardScore_"^realScore|"_realscore_"^negScore|"_negscore_"^StandardScore|"_obj1.CheckItemStand_"^twoRealScore|"_realscore_"^SubRowID|"_$tr(obj1.%Id(),"||","__")
	..s tmp("sort",$p(sort,"."),0)=tmp("sort",$p(sort,"."),0)_"^checkType|1"_"^CheckItemRemark|"_obj1.CheckItemRemark_"^tworows|0^show|1"_"^showthree|"_showTree
	..//s isShow1=0
	.e  d
	..;有子集
	..s rw2="" f  s rw2=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj1.%Id(),par,rw2)) q:rw2=""  d
	...//s isShow2=1
	...s obj2=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw2)
	...q:'$IsObject(obj2)
	...s realscore=obj2.CheckItemScore
	...s:obj2.CheckItemNegScore="" negscore=0
	...s:obj2.CheckItemNegScore'="" negscore=obj2.CheckItemNegScore
	...s sort=obj2.CheckSort
	...//s isShow1=..isItemShow(sort,par)
	...i $d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par)) d
	....;有子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckModelDR,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.CheckItem_"^twoModelId|"_$tr(obj2.CheckModelDR,"||","__")_"^twoColSpan|"_obj2.CheckColSpan_"^twosort|"_obj2.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|^realScore|^negScore|^StandardScore|^SubRowID|"_"^checkType|1"_"^CheckItemRemark|"_"^tworows|"_tmp("tworows",rw1)_"^show|0"_"^showthree|"_showTree
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoRealScore|"_tmp("score",rw2)
	...e  d
	....;无子集
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckItem,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoModelDesc|"_obj2.CheckItem_"^twoModelId|"_$tr(obj2.CheckModelDR,"||","__")_"^twoColSpan|"_obj2.CheckColSpan_"^twosort|"_obj2.CheckSort
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^threeModelDesc|^threeModelId|^threesort|"
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^Score|"_obj2.StandardScore_"^realScore|"_realscore_"^negScore|"_negscore_"^StandardScore|"_obj2.CheckItemStand_"^SubRowID|"_$tr(obj2.%Id(),"||","__")_"^checkType|1"_"^CheckItemRemark|"_obj2.CheckItemRemark_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),0)=tmp("sort",$p(sort,"."),$p(sort,".",3),0)_"^twoRealScore|"_realscore
	...s rw3="" f  s rw3=$o(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_obj2.%Id(),par,rw3)) q:rw3=""  d
	....s obj3=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw3)
	....q:'$IsObject(obj3)
	....s realscore=obj3.CheckItemScore
	....s sort=obj3.CheckSort
	....//s isShow1=..isItemShow(obj2.CheckSort,par)
	....//s isShow2=..isItemShow(sort,par)
	....//s isShow1=((isShow1=1)&&(isShow2=1))
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))="oneModelDesc|"_obj1.CheckItem_"^oneModelId|"_$tr(obj1.CheckModelDR,"||","__")_"^oneColSpan|"_obj1.CheckColSpan_"^onesort|"_obj1.CheckSort_"^twoModelDesc|"_obj2.CheckItem_"^twoModelId|"_$tr(obj2.CheckModelDR,"||","__")_"^twoColSpan|"_obj2.CheckColSpan_"^twosort|"_obj2.CheckSort_"^threeModelDesc|"_obj3.CheckItem_"^threeModelId|"_$tr(obj3.CheckModelDR,"||","__")_"^threesort|"_obj3.CheckSort_"^Score|"_obj3.StandardScore_"^realScore|"_realscore_"^StandardScore|"_obj3.CheckItemStand_"^SubRowID|"_$tr(obj3.%Id(),"||","__")_"^checkType|1"_"^CheckItemRemark|"_obj3.CheckItemRemark_"^tworows|"_tmp("tworows",rw1)_"^show|1"_"^showthree|"_showTree
	....//s isShow1=0,isShow2=0
	....s tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))=tmp("sort",$p(sort,"."),$p(sort,".",3),$p(sort,".",4))_"^twoRealScore|"_tmp("score",rw2)
	
	s ret=""
	s sort1="" f  s sort1=$o(tmp("sort",sort1)) q:sort1=""  d
	.s isShow1=1
	.s sort2="" f  s sort2=$o(tmp("sort",sort1,sort2)) q:sort2=""  d
	..s isShow2=1
	..i $g(tmp("sort",sort1,sort2))'="" d
	...s ret=tmp("sort",sort1,sort2)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...s isShow1=0,isShow2=0
	...d OutputScoreLists
	..s sort3="" f  s sort3=$o(tmp("sort",sort1,sort2,sort3)) q:sort3=""  d
	...s ret=tmp("sort",sort1,sort2,sort3)_"^oneIsShow|"_isShow1_"^twoIsShow|"_isShow2
	...i (sort3'=0)||(($O(tmp("sort",sort1,sort2,sort3))="")) d
	....s isShow1=0,isShow2=0
	...d OutputScoreLists
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputScoreLists
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindScoreListsBGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreListsBGExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindScoreListsBGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreListsBGExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:质控考评病区情况
/// Date:2017-09-28
/// Table:
/// Input:来源^单子id^月份^展现类型(1、一览表。2、未提交)^检索内容
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindListViews","1^17^2019-01^1^")
Query FindListViews(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindListViewsExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	//parr="typeid^2017-09"
	s source=$p(parr,"^")
	s typeid=$p(parr,"^",2)
	s month=$p(parr,"^",3)
	s type=$p(parr,"^",4)
	s input=$tr($p(parr,"^",5)," ","")
	s tmp="",isUsedTmp=0
	s checkObj=##class(DHCNMG.DB.MgQualModel).%OpenId(typeid)
	i '$IsObject(checkObj) {Set qHandle=$lb(0,repid,0) Quit $$$OK}
	;大科、病区只需要所辖病区
	i (checkObj.RestructLevel="W")||(checkObj.RestructLevel="L") d
	.s isUsedTmp=1
	.d:$IsObject(checkObj.RestructPerDR) ..getQualWardTMP1(checkObj.RestructPerDR.%Id(),.tmp) 
	;s ward="" f  s ward=$O(^DHCNMG.DB.MgWardI("CTLoc",ward)) q:ward=""  d
	;.s rw="" f  s rw=$O(^DHCNMG.DB.MgWardI("CTLoc",ward,rw)) q:rw=""  d
	s ward="" f  s ward=$O(^DHCNMG.DB.MgNurCheckWardI("Type"," Q",ward)) q:ward=""  d
	.s rw=$tr(ward," ","")
	.q:(isUsedTmp)&&('$d(tmp(rw)))
	.s obj=##class(DHCNMG.DB.MgWard).%OpenId(rw)
	.s warddesc=obj.WardDesc
	.q:(input'="")&&(warddesc'[input)
	.s wardid=rw
	.s itmmonth=month
	.s listview=..GetCheckInfo(typeid,source,wardid,month) //status_"^"_flag
	.s status=$p(listview,"^",1)
	.q:(type'=1)&&(status="S")
	.s flag=$p(listview,"^",2)
	.s checker=$p(listview,"^",3)
	.s checkscore=$p(listview,"^",4)
	.i flag=0 s itmcolor="background-color:#CCC;"
	.e  i ((flag=1)&&(status="N")) s itmcolor="background-color:#FCC;"
	.e  i ((flag=1)&&(status="S")) s itmcolor="background-color:#0FC;"
	.i checker="" s checker="×"
	.i checkscore="" s checkscore="×"
	.s ret="warddesc|"_warddesc_"^wardid|"_wardid_"^itmmonth|"_itmmonth_"^itmcolor|"_itmcolor_"^checker|"_checker_"^checkscore|"_checkscore
	.d OutputListView
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputListView
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindListViewsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindListViewsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindListViewsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindListViewsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCheckInfo(typeid, source, wardid, month) As %String
{
	/*
	s ret=""
	s flag=0
	s status="",checker="",checkscore=""
	i month'="" s month=$zdh(month_"-01",3)
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgCheckRoomI("stat",source," "_typeid," "_wardid,month,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(rowid)
	.s status=obj.Status //N 未提交 S 提交
	.s flag=1
	.s checkscore=obj.CheckScore
	.i (obj.CheckUser'=""&&obj.CheckUser'=0) d
	..s nurobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CheckUser)
	..s checker=nurobj.PerName
	e  i obj.CheckUser=0 s checker="超级管理员"
	s ret=status_"^"_flag_"^"_checker_"^"_checkscore
	q ret
	*/
	s ret=""
	s flag=0
	s status="",checker="",checkscore="",num=1
	i month'="" s month=$zdh(month_"-01",3)
	s rowid="" f  s rowid=$O(^DHCNMG.CHK.MgCheckRoomI("stat",source," "_typeid," "_wardid,month,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(rowid)
	.s:status'="S" status=obj.Status //N 未提交 S 提交
	.s flag=1
	.q:status'="S"
	.s checkscore=obj.CheckScore+((+$g(checkscore))*(num-1))/num
	.s PerName=""
	.i obj.CheckUser'="" d
	..i obj.CheckUser=0 d
	...s PerName="demo"
	..e  d
	...s nurobj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.CheckUser)
	...s:$IsObject(nurobj) PerName=nurobj.PerName
	.s:num=1 checker=PerName
	.s:num>1 checker=checker_","_PerName
	.s num=num+1
	;s:(checkscore'="")&&(num>1) checkscore=$fn(checkscore/(num-1),"",2)
	s ret=status_"^"_flag_"^"_checker_"^"_checkscore
	q ret
}

/// input:sort,parid
/// 根据sort计算是否合并二级质控、三级质控
ClassMethod isItemShow(parr, par) As %String
{
	s sortUp=$tr($o(^DHCNMG.CHK.MgCheckRoomSubI("Sort",par," "_parr),-1)," ","")
	s show=0
	s:((sortUp'="")&&($l(sortUp,".")<$l(parr,"."))) show=1
	q show
}

/// Creator:lulin
/// CreatDate: 2018-05-23
/// UpdateDate:
/// Description: 清空质控Global
/// Table：
/// Input：
/// Return：
/// Other:d ##class(web.NurMgQualCheckComm).ClearQualData()
ClassMethod ClearQualData() As %String
{
	k ^DHCNMG.CHK.MgCheckRoomSubI
	k ^DHCNMG.CHK.MgCheckRoomSubD
	k ^DHCNMG.CHK.MgCheckRoomI
	k ^DHCNMG.CHK.MgCheckRoomD
	k ^DHCNMG.DB.MgQualModelSubI
	k ^DHCNMG.DB.MgQualModelSubD
	k ^DHCNMG.DB.MgQualModelI
	k ^DHCNMG.DB.MgQualModelD
	k ^DHCNMG.DB.MgQualItemSubI
	k ^DHCNMG.DB.MgQualItemSubD
	k ^DHCNMG.DB.MgQualItemI
	k ^DHCNMG.DB.MgQualItemD
}

/// Creator:lulin
/// Description:查询登录者在质控检查中可显示的重组单子
/// Date:2018-05-28
/// Table:DHCNMG.DB.MgQualModel
/// Input:检索条件,登录人id，登录权限，登录病区
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCheckModel","2019^8__1^0^^admin")
Query FindCheckModel(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckModelExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^Tmpll("FindRestructModel")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s year=$tr($p(parr,"^",1)," ","")
	s type=$tr($p(parr,"^",2),"__","||")
	s:type["_" type=$tr(type,"_","|")
	s loginID=$tr($p(parr,"^",3)," ","")
	s loginDep=$tr($p(parr,"^",4)," ","")
	s loginRoleCode=$zcvt($tr($p(parr,"^",5)," ",""),"U")
	s Level="",LevelId=""
	;护理部
	i (loginRoleCode="HLB")||(loginRoleCode="HLBZR")||(loginRoleCode="MANAGER")||(loginRoleCode="ADMIN") d
	.s Level="H"
	;护士长
	i loginRoleCode="NURHEAD" d
	.s Level="W"
	.s LevelId=loginDep
	;大科护士长
	i loginRoleCode="ZNURHEAD" d
	.s Level="L"
	.s objWard=##class(DHCNMG.DB.MgWard).%OpenId(loginDep)
	.;s:($IsObject(objWard))&&($IsObject(objWard.WardLocDR)) LevelId=objWard.WardLocDR.%Id()
	.s:($IsObject(objWard))&&($d(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id()))) LevelId=$O(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id(),""))
	i Level="" {set qHandle=$lb(0,repid,0) Quit $$$OK}
	s tmp=""
	;检查小组
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualModelD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.RestructGroup)
	.s isChecker=##class(web.NurMgSetComm).IsPerInCheckGroup(loginID,obj.RestructGroup.%Id())
	.q:(isChecker=0)
	.s tmp(obj.RestructLevel,rowid)=rowid
	;大科/病区创建者角色对应表单
	i ((Level="L")||(Level="W")) { 
		s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualModelD(rowid)) q:rowid=""  d
		.s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(rowid)
		.q:'$IsObject(obj)
		.s objLevel=$zcvt(obj.RestructLevel,"U")
		.q:$d(tmp(objLevel,rowid))
		.q:(objLevel'="")&&(objLevel'=Level)
		.q:(obj.RestructLevelId'="")&&(obj.RestructLevelId'=LevelId)
		.s tmp(objLevel,rowid)=rowid
	}
	;不是检查者护理部对应表单（全部显示）
	i (($o(tmp(""))="")&&(Level="H")) {
		s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualModelD(rowid)) q:rowid=""  d
		.s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(rowid)
		.q:'$IsObject(obj)
		.s objLevel=$zcvt(obj.RestructLevel,"U")
		.q:$d(tmp(objLevel,rowid))
		.s tmp(objLevel,rowid)=rowid	
	}
	s levelType="" f  s levelType=$o(tmp(levelType)) q:levelType=""  d
	.s rowid="" f  s rowid=$o(tmp(levelType,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(rowid)
	..q:(year'="")&&(year'=obj.RestructYear)
	..q:(type'="")&&(type'=obj.RestructType)
	..s restructCode=$zcvt(obj.RestructCode,"U")
	..s restructDesc=obj.RestructDesc
	..s restructType=""
	..s restructTyperw=$tr(obj.RestructType,"|","_")
	..i obj.RestructType'="" d
	...s TypeObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.RestructType)
	...s restructType=TypeObj.SubDesc
	..e  s restructType=""
	..s restructScore=obj.RestructScore
	..s:restructScore="" restructScore=0
	..s restructscoretype="按比例"
	..s:obj.RestructScoreType="2" restructscoretype="按分值"
	..s GroupDesc="",GroupDR=""
	..s:$IsObject(obj.RestructGroup) GroupDesc=obj.RestructGroup.GroupDesc,GroupDR=obj.RestructGroup.%Id()
	..s QualLevel=obj.RestructLevel
	..s QualLevelDesc=""
	..s:QualLevel="H" QualLevelDesc="护理部"
	..s:QualLevel="L" QualLevelDesc="大科"
	..s:QualLevel="W" QualLevelDesc="病区"
	..s ret="qualYear|"_obj.RestructYear_"^qualDesc|"_restructDesc_"^qualType|"_restructType_"^qualCode|"_restructCode_"^rowid|"_rowid_"^qualScore|"_restructScore_"^qualScoreType|"_restructscoretype_"^qualTyperw|"_restructTyperw
	..s ret=ret_"^GroupDesc|"_GroupDesc_"^GroupDR|"_GroupDR_"^QualLevel|"_QualLevel_"^QualLevelDesc|"_QualLevelDesc
	..;s ret="restructCode|"_restructCode_"^restructDesc|"_restructDesc_"^restructType|"_restructType_"^restructYear|"_restructYear_"^rowid|"_rowid_"^restructScore|"_restructScore_"^restructscoretype|"_restructscoretype_"^restructTyperw|"_restructTyperw
	..do OutputQualData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckModelExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取重组质控科室/病区对应的病区id
/// Date:2018-05-28
/// Table:DHCNMG.DB.MgQualModel
/// Input:病区id/科室id
/// Output：
/// Return:tmp(病区id)=病区id
/// Others:
ClassMethod getQualWardTMP(id, tmp) As %String
{
	s checkObj=##class(DHCNMG.DB.MgQualModel).%OpenId(id)
	q:'$IsObject(checkObj) 0
	i checkObj.RestructLevel="W" d
	.s:checkObj.RestructLevelId'="" tmp(checkObj.RestructLevelId)=checkObj.RestructLevelId
	i checkObj.RestructLevel="L" d
	.s locId=checkObj.RestructLevelId
	.s warid="" f  s warid=$o(^DHCNMG.DB.MgWardLocUnitI("Loc",locId,warid)) q:warid=""  d
	..s tmp(warid)=warid
	q 0
}

/// Creator:lulin
/// Description:获取重组质控科室/病区对应的病区id
/// Date:2018-05-28
/// Table:DHCNMG.DB.MgQualModel
/// Input:病区id/科室id
/// Output：
/// Return:tmp(病区id)=病区id
/// Others:
ClassMethod getQualWardTMP1(nurseid, tmp) As %String
{
	q:nurseid="" ""
	s trole="" f  s trole=$O(^DHCNMG.DB.MgDataLimitI("Role",trole)) q:trole=""  d
	.s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_trole," "_nurseid,rolerw)) q:rolerw=""  d
	..s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
	...s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
	...s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	....s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
	.....q:(id'=roledepobj.SubWard)
	.....s tmp(id)=id
	q ""
}

/// Creator:lulin
/// Description:判断登录者是否有权限打分
/// Date:2018-06-07
/// Table:DHCNMG.DB.MgQualModel
/// Input:登录者ID,登录者病区，登录者科室，表单ID
/// Output：
/// Return:1,0
/// Others:w ##class(web.NurMgQualCheckComm).getIsCreateQual("0^^admin^1")
ClassMethod getIsCreateQual(parr As %String = "") As %String
{
	s loginID=$tr($p(parr,"^")," ","")
	s loginDep=$tr($p(parr,"^",2)," ","")
	s loginRoleCode=$zcvt($tr($p(parr,"^",3)," ",""),"U")
	s id=$tr($p(parr,"^",4)," ","")
	q:(loginID="")||(id="") "无相关信息，请刷新界面"
	s Level="",LevelId=""
	;护理部
	i (loginRoleCode="HLB")||(loginRoleCode="HLBZR")||(loginRoleCode="MANAGER")||(loginRoleCode="ADMIN") d
	.s Level="H"
	;护士长
	i loginRoleCode="NURHEAD" d
	.s Level="W"
	.s LevelId=loginDep
	;大科护士长
	i loginRoleCode="ZNURHEAD" d
	.s Level="L"
	.s objWard=##class(DHCNMG.DB.MgWard).%OpenId(loginDep)
	.;s:($IsObject(objWard))&&($IsObject(objWard.WardLocDR)) LevelId=objWard.WardLocDR.%Id()
	.s:($IsObject(objWard))&&($d(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id()))) LevelId=$O(^DHCNMG.DB.MgWardLocUnitI("Ward",objWard.%Id(),""))
	q:Level="" "无相关权限"
	s obj=##class(DHCNMG.DB.MgQualModel).%OpenId(id)
	q:'$IsObject(obj) "无对应信息，请刷新界面"
	s ret=0
	;有检查小组只有检查小组可以新建
	i $IsObject(obj.RestructGroup) d 
	.f i=1:1:obj.RestructGroup.GroupMember.Count() q:ret=1  d
	..s:obj.RestructGroup.GroupMember.GetAt(i)=loginID ret=1
	e  d ;无检查小组只有同角色可以创建
	.i (obj.RestructLevel=Level)&&((obj.RestructLevelId="")||(obj.RestructLevelId=LevelId)) d
	..s ret=1
	s:ret=0 ret="无新建权限"
	q ret
}

/// Creator:lulin
/// Description:查询问题汇总项
/// Date:2018-05-28
/// Table:DHCNMG.CHK.MgCheckRomm
/// Input:检查日期^截止日期^检查级别^状态^问题来源^病区id
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCheckQuesList","2019-01-01^2019-01-31^^^^","0","0")
Query FindCheckQuesList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckQuesListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stdate=$p(parr,"^")
	s enddate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s level=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s source=$tr($p(parr,"^",5),"_","|")
	s ward=$p(parr,"^",6)
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	//质控检查、特殊科室检查
	s id="" f  s id=$O(^DHCNMG.CHK.MgCheckRoomD(id)) q:id=""  d
	.s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.Status'="S"
	.q:(stdate'="")&&(obj.CreateDate<stdate)
	.q:(enddate'="")&&(obj.CreateDate>enddate)
	.q:(ward'="")&&(obj.ScoreWard'=ward)
	.q:(isAll=0)&&((obj.ScoreWard="")||('$d(tmpWard(obj.ScoreWard))))
	.s qualObj=##class(DHCNMG.DB.MgQualModel).%OpenId(obj.CheckDR) //重组
	.q:'$IsObject(qualObj)
	.q:(source'="")&&(qualObj.RestructType'=source)
	.s sourcedesc=""
	.s sourceObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(qualObj.RestructType)
	.s:$IsObject(sourceObj) sourcedesc=sourceObj.SubDesc
	.q:(level'="")&&(qualObj.RestructLevel'=level)
	.s retDate=obj.CreateDate
	.s:retDate'="" retDate=##class(web.NurMgHISComm).DateLogicalToHtml(retDate)
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.ScoreWard)
	.q:'$IsObject(wardObj)
	.s retWard=wardObj.WardDesc
	.s retLevel=qualObj.RestructLevel,retDesc="",retStatus="N"
	.s Quesid=$o(^DHCNMG.CHK.MgCheckQuesI("Check"," Q"," "_id,"")) 
	.s quesObj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(Quesid)
	.q:(Quesid'="")&&('$IsObject(quesObj))
	.i $IsObject(quesObj) d
	..q:(status'="")&&(quesObj.QuesStatus'=status)
	..s retStatus=quesObj.QuesStatus
	..s retDesc=quesObj.QuesDesc
	.e  d
	..q:(status'="")&&(status'="N")
	..s retDesc=..GetQuesDescById("Q",id,qualObj.RestructScoreType)
	.q:retDesc=""
	.s retLevelDesc=$case(retLevel,"W":"病区","L":"大科","H":"护理部",:"")
	.s retStatusDesc=$case(retStatus,"N":"待处理","N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	.s ret="stdate|"_retDate_"^ward|"_retWard_"^source|"_$tr(source,"|","_")_"^sourcedesc|"_sourcedesc_"^question|"_retDesc_"^status|"_retStatus_"^level|"_retLevel_"^subid|"_id
	.s ret=ret_"^levelDesc|"_retLevelDesc_"^statusDesc|"_retStatusDesc_"^type|Q"
	.s ret=ret_"^scoretype|"_qualObj.RestructScoreType
	.s ret=ret_"^"_..getCheckQuesSubItem(Quesid)
	.do OutputCheckQuesData
	//夜查房
	s id="" f  s id=$O(^DHCNMG.CHK.MgNurNightCheckD(id)) q:id=""  d
	.s nightObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(id)
	.q:'$IsObject(nightObj)
	.q:(stdate'="")&&(nightObj.TaskDate<stdate) //日期限制
	.q:(enddate'="")&&(nightObj.TaskDate>enddate)
	.s retDate=nightObj.TaskDate
	.s:retDate'="" retDate=##class(web.NurMgHISComm).DateLogicalToHtml(retDate)
	.q:(ward'="")&&(nightObj.TaskWard'=ward) //病区限制
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(nightObj.TaskWard)
	.q:'$IsObject(wardObj)
	.s retWard=wardObj.WardDesc
	.q:(isAll=0)&&((nightObj.TaskWard="")||('$d(tmpWard(nightObj.TaskWard))))
	.//类型限制
	.q:'$IsObject(nightObj.TaskID)
	.s qualNightObj=##class(DHCNMG.DB.MgQualItem).%OpenId(nightObj.TaskQualID)
	.q:'$IsObject(qualNightObj)
	.q:nightObj.TaskID.CheckStatus="B"
	.s tSource="8||2"
	.i nightObj.TaskID.CheckType="W" s tSource="8||4"
	.e  i nightObj.TaskID.CheckType="H" s tSource="8||5"
	.q:(source'="")&&(tSource'=source)
	.s sourcedesc=""
	.s sourceObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(tSource)
	.s:$IsObject(sourceObj) sourcedesc=sourceObj.SubDesc
	.s Quesid=$o(^DHCNMG.CHK.MgCheckQuesI("Check"," N"," "_id,"")) 
	.s quesObj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(Quesid)
	.q:(Quesid'="")&&('$IsObject(quesObj))
	.s retLevel="",retDesc="",retStatus="N"
	.i $IsObject(quesObj) d
	..q:(status'="")&&(quesObj.QuesStatus'=status) //状态限制
	..s retStatus=quesObj.QuesStatus
	.e  d
	..q:(status'="")&&(status'="N")
	..s retDesc=..GetQuesDescById("N",id,qualNightObj.QualScoreType)
	.q:retDesc=""
	.s retLevelDesc=$case(retLevel,"W":"病区","L":"大科","H":"护理部",:"")
	.s retStatusDesc=$case(retStatus,"N":"待处理","N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	.s ret="stdate|"_retDate_"^ward|"_retWard_"^source|"_$tr(tSource,"|","_")_"^sourcedesc|"_sourcedesc_"^question|"_retDesc_"^status|"_retStatus_"^level|"_retLevel_"^subid|"_id
	.s ret=ret_"^levelDesc|"_retLevelDesc_"^statusDesc|"_retStatusDesc_"^type|N"
	.s ret=ret_"^scoretype|"_qualNightObj.QualScoreType
	.s ret=ret_"^"_..getCheckQuesSubItem(Quesid)
	.do OutputCheckQuesData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckQuesData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckQuesListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckQuesListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckQuesListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckQuesListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:查询问题汇总项详情列表
/// Date:2018-06-14
/// Table:DHCNMG.CHK.MgCheckRomm
/// Input:质控检查子项ID
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindQuesSubList","2__1")
Query FindQuesSubList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQuesSubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s parr=$tr(parr,"_","|")
	s checkid=$P(parr,"^")
	s checkType=$P(parr,"^",2)
	s scoreType=$P(parr,"^",3)
	s desc=""
	s id=$O(^DHCNMG.CHK.MgCheckQuesI("Check"," "_checkType," "_checkid,""))
	s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
	s status=""
	s ret=""
	s desc=..GetQuesDescById(checkType,checkid,scoreType)
	i '$IsObject(obj) d
	.s desc=desc
	.s ret="desc|"_desc_"^status|未处理"
	.do OutputCheckQuesSubData
	e  d
	.s subid="" f  s subid=$o(^DHCNMG.CHK.MgCheckQuesSubD(id,subid)) q:subid=""  d
	..s subObj=##class(DHCNMG.CHK.MgCheckQuesSub).%OpenId(id_"||"_subid)
	..s hander=subObj.QuesSubHander
	..s handerName=""
	..i hander=0 d
	...s handerName="demo"
	..e  d
	...s nurObj=##class(DHCNMG.HR.MgPersons).%OpenId(hander)
	...s:$IsObject(nurObj) handerName=nurObj.PerName
	..s auditorName=""
	..s auditor=subObj.QuesSubAuditor
	..i auditor=0 d
	...s auditorName="demo"
	..e  d
	...s auditorObj=##class(DHCNMG.HR.MgPersons).%OpenId(auditor)
	...s:$IsObject(auditorObj) auditorName=auditorObj.PerName
	..s rea=subObj.QuesSubRea
	..s nurRea=subObj.QuesSubNurRea
	..s patRea=subObj.QuesSubPatRea
	..s deviceRea=subObj.QuesSubDeviceRea
	..s workRea=subObj.QuesSubWorkRea
	..s goodsRea=subObj.QuesSubGoodsRea
	..s steps=subObj.QuesSubSteps
	..s goal=subObj.QuesSubGoal
	..s assess=subObj.QuesSubAssess
	..s subView=subObj.QuesSubView
	..s status=subObj.QuesStatus
	..s retStatusDesc=$case(status,"N":"待处理","N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	..s ret="hander|"_handerName_"^auditor|"_auditorName_"^status|"_retStatusDesc_"^desc|"_desc_"^rea|"_rea_"^nurRea|"_nurRea_"^patRea|"_patRea_"^deviceRea|"_deviceRea_"^workRea|"_workRea_"^goodsRea|"_goodsRea_"^steps|"_steps_"^goal|"_goal_"^assess|"_assess_"^subView|"_subView
	..do OutputCheckQuesSubData
	i status="B" d
	.s ret="desc|"_desc_"^status|未处理"
	.do OutputCheckQuesSubData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckQuesSubData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuesSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuesSubListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQuesSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuesSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取质控问题汇总项详情数据
/// Date:2018-06-14
/// Table:DHCNMG.CHK.MgCheckRommSub/DHCNMG.CHK.MgCheckQues
/// Input:质控检查子项ID
/// Output：
/// Return:
/// Other: w ##class(web.NurMgQualCheckComm).getCheckQuesForm("10^Q")
ClassMethod getCheckQuesForm(parr As %String = "") As %String
{
	s parr=$tr(parr,"_","|")
	s par=$p(parr,"^",1)
	s type=$p(parr,"^",2)
	s checkobj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par)
	s id=$O(^DHCNMG.CHK.MgCheckQuesI("Check"," "_type," "_par,""))
	s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
	q:'$IsObject(obj) "nowstatus|N"
	s nowstatus=obj.QuesStatus
	s member=""
	f i=1:1:obj.QuesMember.Count() d
	.s perId=obj.QuesMember.GetAt(i)
	.i perId=0 d
	..s pername="demo"
	.e  d
	..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perId)
	..q:'$IsObject(perObj)
	..s pername=perObj.PerName
	.s:member'="" member=member_","_pername
	.s:member="" member=pername
	s remark=obj.QuesRemark
	s ret="nowstatus|"_nowstatus_"^member|"_member_"^remark|"_remark_"^rw|"_id
	q ret
}

/// Creator:lulin
/// Description:保存质控问题汇总项详情数据
/// Date:2018-06-14
/// Table:DHCNMG.CHK.MgCheckRommSub/DHCNMG.CHK.MgCheckQues
/// Input:质控检查子项ID
/// Output：
/// Return:
/// Other:w ##class(web.NurMgQualCheckComm).saveCheckQues("subid|2__1^desc|抢救车清洁无尘土^status|未处理^nowstatus|N^status|S^creater|^createrName|^member|^remark|^source|^rw|^hander|0^handerName|demo")
ClassMethod saveCheckQues(parr As %String = "") As %String
{
	//rw|2__1^desc|抢救车清洁无尘土^status|未处理
	//^nowstatus|S^status|^hander|0^handerName|demo^member|^remark|
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:('$d(tmp("subid")))||(tmp("subid")="")
	s checkObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId($p(tmp("subid"),"||"))
	s checkSubObj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(tmp("subid"))
	i '$d(^DHCNMG.CHK.MgCheckQuesI("Check"," "_tmp("subid"))) d
	.s obj=##class(DHCNMG.CHK.MgCheckQues).%New()
	e  d
	.s id=$o(^DHCNMG.CHK.MgCheckQuesI("Check"," "_tmp("subid"),""))
	.s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
	s obj.QuesCheckDR=checkSubObj.%Id()
	s obj.QuesCheckDate=checkObj.CreateDate
	s obj.QuesUser=checkObj.CheckUser
	s obj.QuesDesc=checkSubObj.CheckItem
	s QualObj=##class(DHCNMG.DB.MgQualModel).%OpenId(checkObj.CheckDR)
	s:$IsObject(QualObj) obj.QuesLevel=QualObj.RestructLevel
	s obj.QuesRemark=$g(tmp("remark"))
	s obj.QuesSource=$g(tmp("source")) ;来源需确认
	s obj.QuesStand=checkSubObj.CheckItemStand
	s obj.QuesStatus=$g(tmp("status"))
	s IsNurHearder=0
	if ($g(tmp("status"))="S")||(($g(tmp("status"))="Q")){
		s IsNurHearder=1
	}
	i IsNurHearder=1 d
	.s isExist=0
	.f i=1:1:obj.QuesMember.Count() q:isExist=1  d
	..s:obj.QuesMember.GetAt(i)=$g(tmp("creater")) isExist=1
	.d:isExist=0 obj.QuesMember.Insert($g(tmp("creater")))
	Ts
	s sc=obj.%Save()
	if '$$$ISOK(sc) {
		Tro
		q 0	
	}
	s subid=$O(^DHCNMG.CHK.MgCheckQuesSubD(obj.%Id(),""),-1)
	i ($g(tmp("status"))="S")||(($g(tmp("status"))="Q")) d
	.s subobj=##class(DHCNMG.CHK.MgCheckQuesSub).%New()
	.s subobj.Parref=obj
	e  d
	.s subobj=##class(DHCNMG.CHK.MgCheckQuesSub).%OpenId(obj.%Id()_"||"_subid)
	s subobj.QuesStatus=$g(tmp("status"))
	s subobj.QuesSubAssess=$g(tmp("assess"))
	if ($g(tmp("status"))="S")||(($g(tmp("status"))="Q")){
		s subobj.QuesSubHandDate=+$h
		s subobj.QuesSubHander=$g(tmp("creater"))
	}else{
		s subobj.QuesSubAudDate=+$h
		s subobj.QuesSubAuditor=$g(tmp("creater"))
	}
	s subobj.QuesSubDeviceRea=$g(tmp("deviceRea"))
	s subobj.QuesSubGoal=$g(tmp("goal"))
	s subobj.QuesSubGoodsRea=$g(tmp("goodsRea"))
	s subobj.QuesSubNurRea=$g(tmp("nurRea"))
	s subobj.QuesSubPatRea=$g(tmp("patRea"))
	s subobj.QuesSubRea=$g(tmp("rea"))
	s subobj.QuesSubSteps=$g(tmp("steps"))
	s subobj.QuesSubView=$g(tmp("subView"))
	s subobj.QuesSubWorkRea=$g(tmp("workRea"))
	s sc=subobj.%Save()
	if $$$ISOK(sc) {
		TC
		q 1	
	}else{
		TRO
		q 0	
	}
}

/// Creator:gzj
/// CreateDate:2018-06-14
/// Description:保存质控问题汇总项详情数据
/// Table:DHCNMG.CHK.MgCheckRommSub/DHCNMG.CHK.MgCheckQues
/// Input:质控检查ID
/// Output：
/// Return:
/// Other:w ##class(web.NurMgQualCheckComm).SaveQuesBack("subid|2__1^desc|抢救车清洁无尘土^status|未处理^nowstatus|N^status|S^creater|^createrName|^member|^remark|^source|^rw|^hander|0^handerName|demo")
ClassMethod SaveQuesBack(parr As %String = "") As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:('$d(tmp("checkPar")))||(tmp("checkPar")="")
	i $g(tmp("CheckType"))="N" s checkObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId($tr(tmp("checkPar")," ",""))
	e  i $g(tmp("CheckType"))="Q" s checkObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId($tr(tmp("checkPar")," ",""))
	
	i '$d(^DHCNMG.CHK.MgCheckQuesI("Check"," "_$tr(tmp("CheckType")," ","")," "_$tr(tmp("checkPar")," ",""))) d
	.s obj=##class(DHCNMG.CHK.MgCheckQues).%New()
	e  d
	.s id=$o(^DHCNMG.CHK.MgCheckQuesI("Check"," "_$tr(tmp("CheckType")," ","")," "_$tr(tmp("checkPar")," ",""),""))
	.s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
	s obj.QuesCheckDR=$tr(tmp("checkPar")," ","")
	i $g(tmp("CheckType"))="Q" d
	.s obj.QuesCheckDate=checkObj.CreateDate
	.s obj.QuesUser=checkObj.CheckUser
	e  i $g(tmp("CheckType"))="N" d
	.s obj.QuesCheckDate=checkObj.TaskChkDate
	.s obj.QuesUser=checkObj.TaskUser
	s obj.QuesDesc=$tr(tmp("desc")," ","")
	;s QualObj=##class(DHCNMG.DB.MgQualModel).%OpenId(checkObj.CheckDR)
	;s:$IsObject(QualObj) obj.QuesLevel=QualObj.RestructLevel
	s obj.QuesRemark=$g(tmp("remark"))
	s obj.QuesSource=$g(tmp("source")) ;来源需确认
	;s obj.QuesStand=checkSubObj.CheckItemStand
	s obj.QuesStatus=$g(tmp("status"))
	s obj.QuesCheckType=$g(tmp("CheckType"))
	s IsNurHearder=0
	if ($g(tmp("status"))="S")||(($g(tmp("status"))="Q"))
	{
		s IsNurHearder=1
	}
	i IsNurHearder=1 d
	.s isExist=0
	.f i=1:1:obj.QuesMember.Count() q:isExist=1  d
	..s:obj.QuesMember.GetAt(i)=$g(tmp("creater")) isExist=1
	.d:isExist=0 obj.QuesMember.Insert($g(tmp("creater")))
	Ts
	s sc=obj.%Save()
	if '$$$ISOK(sc) 
	{
		Tro
		q 0	
	}
	s subid=$O(^DHCNMG.CHK.MgCheckQuesSubD(obj.%Id(),""),-1)
	i ($g(tmp("status"))="S")||(($g(tmp("status"))="Q")) d
	.s subobj=##class(DHCNMG.CHK.MgCheckQuesSub).%New()
	.s subobj.Parref=obj
	e  d
	.s subobj=##class(DHCNMG.CHK.MgCheckQuesSub).%OpenId(obj.%Id()_"||"_subid)
	s subobj.QuesStatus=$g(tmp("status"))
	s subobj.QuesSubAssess=$g(tmp("assess"))
	if ($g(tmp("status"))="S")||(($g(tmp("status"))="Q")){
		s subobj.QuesSubHandDate=+$h
		s subobj.QuesSubHander=$g(tmp("creater"))
	}else{
		s subobj.QuesSubAudDate=+$h
		s subobj.QuesSubAuditor=$g(tmp("creater"))
	}
	s subobj.QuesSubDeviceRea=$g(tmp("deviceRea"))
	s subobj.QuesSubGoal=$g(tmp("goal"))
	s subobj.QuesSubGoodsRea=$g(tmp("goodsRea"))
	s subobj.QuesSubNurRea=$g(tmp("nurRea"))
	s subobj.QuesSubPatRea=$g(tmp("patRea"))
	s subobj.QuesSubRea=$g(tmp("rea"))
	s subobj.QuesSubSteps=$g(tmp("steps"))
	s subobj.QuesSubView=$g(tmp("subView"))
	s subobj.QuesSubWorkRea=$g(tmp("workRea"))
	s sc=subobj.%Save()
	if $$$ISOK(sc) 
	{
		TC
		q 1	
	}
	else
	{
		TRO
		q 0	
	}
}

/// Creator:lulin
/// Description:保存质控问题汇总项详情数据
/// Date:2018-06-14
/// Table:DHCNMG.CHK.MgCheckRommSub/DHCNMG.CHK.MgCheckQues
/// Input:质控检查子项ID
/// Output：
/// Return:
/// Other:w ##class(web.NurMgQualCheckComm).saveCheckQues("subid|2__1^desc|抢救车清洁无尘土^status|未处理^nowstatus|N^status|S^creater|^createrName|^member|^remark|^source|^rw|^hander|0^handerName|demo")
ClassMethod saveCheckQuesSign(parr As %String = "") As %String
{
		s id=$p(parr,"^")
		s per=$p(parr,"^",2)
		q:(id="")||(per="") ""
		s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
		q:'$IsObject(obj) ""
		s isExist=0
		f i=1:1:obj.QuesMember.Count() q:isExist=1  d
		.s:obj.QuesMember.GetAt(i)=per isExist=1
		q:isExist=1 2
		d obj.QuesMember.Insert(per)
		s sc=obj.%Save()
		if $$$ISOK(sc){
			q 1
		}else{
			q 0	
		}
}

/// Creator:lulin
/// Description:根据类型及父节点id获取问题描述
/// Date:2018-06-14
/// Table:DHCNMG.CHK.MgCheckRommSub/DHCNMG.CHK.MgNurNightCheckSub
/// Input:类型，父节点id
/// Output：
/// Return:
/// Other:
ClassMethod GetQuesDescById(type, id, scoretype) As %String
{
	s index=1
	s retDesc=""
	i type="Q" d
	.s subid="" f  s subid=$O(^DHCNMG.CHK.MgCheckRoomSubD(id,subid)) q:subid=""  d
	..s subObj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(id_"||"_subid)
	..q:'$IsObject(subObj)
	..q:$d(^DHCNMG.CHK.MgCheckRoomSubI("par"," "_id_"||"_subid))
	..q:(scoretype=2)&&(subObj.CheckItemScore=subObj.StandardScore)
	..q:(scoretype=1)&&(subObj.CheckItemScore'=0)
	..i retDesc="" s retDesc=subObj.CheckItem
	..e  s retDesc=retDesc_"；"_subObj.CheckItem
	..s index=index+1
	e  d
	.s subid="" f  s subid=$O(^DHCNMG.CHK.MgNurNightCheckSubD(id,subid)) q:subid=""  d
	..s subNightObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(id_"||"_subid)
	..q:'$IsObject(subNightObj)
	..q:$d(^DHCNMG.CHK.MgNurNightCheckSubI("par"," "_id_"||"_subid))
	..q:(scoretype=2)&&(subNightObj.TaskResult=subNightObj.TaskValue)
	..q:(scoretype'=2)&&(subNightObj.TaskResult'="×")
	..i retDesc="" s retDesc=subNightObj.TaskItems
	..e  s retDesc=retDesc_"；"_subNightObj.TaskItems
	..s index=index+1
	q retDesc
}

/// Creator:lulin
/// Description:质控数据同列列头
/// Date:2019-02-16
/// Table:DHCNMG.CHK.MgNurNightCheck
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCountColumnList","2019-01")
Query FindCountColumnList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCountColumnListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s month=$p(parr,"^",1)
	s qualtype=$P(parr,"^",2)
	s id="" f  s id=$O(^DHCNMG.CHK.MgNurNightCheckD(id)) q:id=""  d
	.s obj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.TaskID)
	.s TaskCode="8||2"
	.i obj.TaskID.CheckType="W" s TaskCode="8||4"
	.e  i obj.TaskID.CheckType="H" s TaskCode="8||5"
	.q:(qualtype'="")&&(obj.TaskID.CheckType'=qualtype)
	.s tDate=obj.TaskDate
	.q:tDate=""
	.s tDate=$zd(tDate,3)
	.s tMonth=+tDate_"-"_$P(tDate,"-",2)
	.q:tMonth'=month
	.s tmp(obj.TaskDate)=obj.TaskDate
	s date="" f  s date=$O(tmp(date)) q:date=""  d
	.s ret="date|"_$zd(date,3)
	.d OutputCountColumnData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCountColumnData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCountColumnListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCountColumnListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCountColumnListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCountColumnListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取质控分数统计
/// Date:2019-02-16
/// Table:DHCNMG.CHK.MgNurNightCheck，DHCNMG.CHK.MgNurNightCheckSub
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindScoreCountList","S^2019-01")
Query FindScoreCountList(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindScoreCountListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s type=$P(parr,"^")
	s month=$P(parr,"^",2)
	s qualtype=$P(parr,"^",3)
	i ((type="")||(month="")) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s tmp=""
	s id="" f  s id=$O(^DHCNMG.CHK.MgNurNightCheckD(id)) q:id=""  d
	.s obj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.TaskID)
	.q:(qualtype'="")&&(obj.TaskID.CheckType'=qualtype)
	.q:obj.TaskID.CheckStatus="B"
	.s tDate=obj.TaskDate
	.q:tDate=""
	.s tDate=$zd(tDate,3)
	.s tMonth=+tDate_"-"_$P(tDate,"-",2)
	.q:tMonth'=month
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.TaskWard)
	.q:'$IsObject(wardObj)
	.q:(isAll'=1)&&('$d(tmpWard(obj.TaskWard)))
	.//获取对应病区、科室
	.s qualObj=##Class(DHCNMG.DB.MgQualItem).%OpenId(obj.TaskQualID)
	.q:'$IsObject(qualObj)
	.s scoretype=qualObj.QualScoreType
	.s score=""
	.s score=0,duckScore=0
	.s subid="" f  s subid=$O(^DHCNMG.CHK.MgNurNightCheckSubD(id,subid)) q:subid=""  d
	..s subObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(id_"||"_subid)
	..q:'$IsObject(subObj)
	..q:$d(^DHCNMG.CHK.MgNurNightCheckSubI("par"," "_id_"||"_subid))
	..i scoretype'=2 d
	...i subObj.TaskResult'="-" s score=score+1
	...i subObj.TaskResult="×" s duckScore=duckScore+1
	..e  d
	...s score=score+subObj.TaskValue,duckScore=duckScore+subObj.TaskResult
	..q:type="S"
	..s qualid=qualObj.%Id()
	..s qualSubId=$P(subObj.TaskQual,"||",2)
	..s tmp("quesnum",obj.TaskDate,qualid,qualSubId)=$g(tmp("quesnum",obj.TaskDate,qualid,qualSubId))+1
	..q:(scoretype=2)&&(subObj.TaskResult=subObj.TaskValue)
	..q:(scoretype'=2)&&(subObj.TaskResult'="×")
	..s QuesIndex=$g(tmp("ducknum",obj.TaskDate,qualid,qualSubId))+1
	..s WardQues=QuesIndex_"."_wardObj.WardDesc_":"_subObj.TaskRemark_"；"
	..i $d(tmp("ques",obj.TaskDate,qualid,qualSubId)) d
	...s WardQues=$P(tmp("ques",obj.TaskDate,qualid,qualSubId),"^",3)_WardQues
	..s tmp("ques",obj.TaskDate,qualid,qualSubId)=qualObj.QualDesc_"^"_subObj.TaskItems_"^"_WardQues_"^"_obj.TaskID.CheckType
	..s tmp("ducknum",obj.TaskDate,qualid,qualSubId)=QuesIndex
	.q:(score=0)||(type'="S")
	.s realscore=duckScore
	.i scoretype'=2 d
	..s realscore=score-duckScore
	..s realscore=$fn(realscore/score*100,"",2)
	.s tmp(wardObj.WardSort,wardObj.%Id(),obj.TaskDate)=realscore
	s index=1
	i type="S" d //分数统计
	.s sort="" f  s sort=$O(tmp(sort)) q:sort=""  d
	..s wardid=""  f  s wardid=$O(tmp(sort,wardid)) q:wardid=""  d
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	...s WardDesc=wardObj.WardDesc
	...s AreaDesc=""
	...i $IsObject(wardObj.WardAreaDR) d
	....s AreaDesc=wardObj.WardAreaDR.AreaDesc
	...s ret="WardDesc|"_WardDesc_"^AreaDesc|"_AreaDesc,allScore=0,num=0
	...s date="" f  s date=$O(tmp(sort,wardid,date)) q:date=""  d
	....s tDate=$zd(date,3)
	....s ret=ret_"^Date"_tDate_"|"_tmp(sort,wardid,date)
	....s allScore=allScore+tmp(sort,wardid,date)
	....s num=num+1
	...s ScoreAvg=$FN(allScore/num,"",2)
	...s ret=ret_"^ScoreAvg|"_ScoreAvg
	...s tmpRet(ScoreAvg*100,sort,wardid)=ret
	.s num=0,oScore=""
	.s score="" f  s score=$O(tmpRet(score),-1) q:score=""  d
	..s sort="" f  s sort=$O(tmpRet(score,sort)) q:sort=""  d
	...s wardid="" f  s wardid=$O(tmpRet(score,sort,wardid)) q:wardid=""  d
	....i (oScore'=score) d
	.....s num=index
	.....s oScore=score
	....s ret=tmpRet(score,sort,wardid)_"^ScoreRank|"_num_"^Index|"_index
	....s index=index+1
	....d OutScoreCounData
	e  d //问题统计
	.s date="" f  s date=$O(tmp("ques",date)) q:date=""  d
	..s tDate=$zd(date,3)
	..s id="" f  s id=$O(tmp("ques",date,id)) q:id=""  d
	...s subid="" f  s subid=$O(tmp("ques",date,id,subid)) q:subid=""  d
	....s CheckDesc=$P(tmp("ques",date,id,subid),"^")
	....s QuesWardNum=tmp("ducknum",date,id,subid)
	....s CheckWardNum=tmp("quesnum",date,id,subid)
	....s CheckItem=$P(tmp("ques",date,id,subid),"^",2)
	....s WardDesc=$P(tmp("ques",date,id,subid),"^",3)
	....s QualType=$P(tmp("ques",date,id,subid),"^",4)
	....s QualType=$Case(QualType,"N":"夜巡查","W":"周末巡查","H":"假期巡查",:"")
	....s ret="CheckDate|"_tDate_"^WardDesc|"_WardDesc_"^CheckDesc|"_CheckDesc_"^CheckItem|"_CheckItem_"^CheckWardNum|"_CheckWardNum_"^QuesWardNum|"_QuesWardNum
	....s ret=ret_"^QualType|"_QualType_"^Index|"_index
	....s index=index+1
	....d OutScoreCounData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutScoreCounData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindScoreCountListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreCountListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindScoreCountListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreCountListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// CreateDate:2019-01-15
/// Description:根据质控类型查询检查人员
/// Table:
/// Input:
/// Output:
/// Other
Query FindCheckerForType(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckerForTypeExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmp=""
	s len=$l(parr,"^")
	f i=1:1:len d
	.s itm=$p(parr,"^",i)
	.q:itm=""
	.s par=$o(^DHCNMG.Set.MgRolesI("code"," Y"," "_itm,""))
	.q:par=""
	.s nurse="" f  s nurse=$o(^DHCNMG.Set.MgRoleNurseI("nurse",par,nurse)) q:nurse=""  d
	..s tmp($tr(nurse," ",""))=1
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	.q:'$IsObject(obj)
	.s nurseID=obj.PerID
	.s nurseName=obj.PerName
	.s currward=##class(web.NurMgHRComm).GetCurrentWard(id,+$h)
	.q:(isAll'=1)&&((currward="")||('$d(tmpWard(currward))))
	.s nurseSpell=##class(ext.util.String).ToChineseSpell(nurseName) //增加首字母首拼
	.s ret="nurseName|"_nurseName_"^nurseID|"_nurseID_"^rw|"_id_"^nurseSpell|"_nurseSpell
	.do OutputCheckers
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckers
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckerForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckerForTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckerForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckerForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// CreateDate:2019-01-15
/// Description:根据质控类型获取病区列表
/// Table：
/// Input:
/// Output:
/// Other:
Query FindWardsForType(id As %String, parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardsForTypeExecute(ByRef qHandle As %Binary, id As %String, parr As %String, role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i id="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId($replace($tr($g(id)," ",""),"__","||"))
	i '$IsObject(obj) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s QualCode=obj.SubCode
	i QualCode="qualcheck" s QualType="Q" //质控检查
	e  i QualCode="nightcheck" s QualType="N" //夜巡查
	e  i QualCode="specialcheck" s QualType="S" //特殊科室检查
	e  i QualCode="weekcheck" s QualType="W" //周末巡
	e  i QualCode="holidaycheck" s QualType="H" //节假日巡查
	e  i QualCode="deptcheck" s QualType="D" //病区自查
	e  i QualCode="mastercheck" s QualType="M" //科护士长督查
	e  i QualCode="quartercheck" s QualType="J" //季度质控检查
	i QualType="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s input=$P(parr,"^")
	s area=$P(parr,"^",2)
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s WardID="" f  s WardID=$o(^DHCNMG.DB.MgNurCheckWardI("Type"," "_QualType,WardID)) q:WardID=""  d
	.s WardObj=##class(DHCNMG.DB.MgWard).%OpenId($tr(WardID," ",""))
	.q:'$IsObject(WardObj)
	.q:(isAll'=1)&&('$d(tmpWard(WardObj.%Id())))
	.s WardDesc=WardObj.WardDesc
	.s spell=##class(web.NurMgVueComm).ToChineseSpell(WardDesc)
	.q:((input'="")&&((WardDesc_spell)'[$zcvt($tr(input," ",""),"U")))
	.;q:(area'="")&&(('$IsObject(WardObj.WardAreaDR))||(WardObj.WardAreaDR.%Id()'=area))
	.s areas=""
	.s tmpLoc="" f  s tmpLoc=$o(^DHCNMG.DB.MgWardLocUnitI("Ward",$tr(WardID," ",""),tmpLoc)) q:tmpLoc=""  d
	..s LocObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(tmpLoc)
	..q:'$IsObject(LocObj)
	..q:'$IsObject(LocObj.LocAreaDR)
	..i areas="" s areas="^"_LocObj.LocAreaDR.%Id()_"^"
	..e  s areas=areas_LocObj.LocAreaDR.%Id()_"^"
	.q:((area'="")&&(areas'[("^"_area_"^")))
	.s ret="WardID|"_$tr(WardID," ","")_"^WardDesc|"_WardDesc
	.do OutputCheckWards
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckWards
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardsForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardsForTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardsForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardsForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// CreateDate:2019-01-16
/// Description:根据质控类型选择质控项目
/// Table:
/// Input:id:质控类型id parr：年份参数
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindQualForType","8__1","2019")
Query FindQualForType(id As %String, parr As %String = "", checkitem As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualForTypeExecute(ByRef qHandle As %Binary, id As %String, parr As %String, checkitem As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i id="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s id=$replace($tr($g(id)," ",""),"__","||")
	s year=$p(parr,"^",1)
	i year="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s code="" f  s code=$o(^DHCNMG.DB.MgQualItemI("Type",year,code)) q:code=""  d
	.q:((id'="")&&($tr(code," ","")'[id))
	.s rw="" f  s rw=$o(^DHCNMG.DB.MgQualItemI("Type",year,code,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(rw)
	..s spell=##class(web.NurMgVueComm).ToChineseSpell(obj.QualDesc)
	..s desc=obj.QualDesc
	..q:((checkitem'="")&&((desc_spell)'[$zcvt($tr(checkitem," ",""),"U"))) //检索输入信息
	..s desc=obj.QualDesc
	..s ret="QualDesc|"_desc_"^QualID|"_rw
	..do OutputCheckWards
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckWards
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualForTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualForTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualForTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualForTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// CreateDate:2019-01-16
/// Description:保存质控任务
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod SaveTaskData(checkers As %String, checkerGroup As %String = "", stDate As %String, endDate As %String, items As %String, type As %String, wards As %String, creator As %String, id As %String, status As %String, QualLevel As %String = "") As %String
{
	s ^TMP("SaveTaskData")=checkers_"#"_checkerGroup_"#"_stDate_"#"_endDate_"#"_items_"#"_type_"#"_wards_"#"_creator_"#"_id_"#"_status_"#"_QualLevel
	i id="" s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%New()
	e  s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(id)
	q:(id'="")&&(obj.TaskCreator'=creator) "非创建人不可修改"
	s obj.TaskType=$tr(type,"__","||")
	i stDate'="" s obj.TaskStDate=$zdh(stDate,3)
	e  s obj.TaskStDate=""
	i endDate'="" s obj.TaskEndDate=$zdh(endDate,3)
	e  s obj.TaskEndDate=""
	s obj.QualLevel=QualLevel
	s l=$l(checkers,",")
	d obj.TaskChecker.Clear()
	f i=1:1:l
	{
		s checker=$p(checkers,",",i)
		i checker="" continue
		d obj.TaskChecker.Insert(checker)
	}
	s m=$l(wards,",")
	d obj.TaskWards.Clear()
	f j=1:1:m
	{
		s ward=$p(wards,",",j)
		i ward="" continue
		d obj.TaskWards.Insert(ward)
	}
	s n=$l(items,",")
	d obj.TaskQuals.Clear()
	f k=1:1:n
	{
		s item=$p(items,",",k)
		i item="" continue
		d obj.TaskQuals.Insert(item)
	}
	s obj.TaskCreator=creator
	s obj.Status=status
	s obj.TaskCheckGroup=checkerGroup
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:gzj
/// CreateDate:2019-01-16
/// Description:查询发布任务列表
/// Table:
/// Input:
/// Output:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindQualReleaseList","")
Query FindQualReleaseList(parr As %String = "", roles As %String, nurseId As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualReleaseListExecute(ByRef qHandle As %Binary, parr As %String, roles As %String, nurseId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s paramType=$tr($p(parr,"^",1),"__","||")
	s paramStDate=$p(parr,"^",2)
	i paramStDate'="" s paramStDate=$zdh(paramStDate,3)
	s paramEndDate=$p(parr,"^",3)
	i paramEndDate'="" s paramEndDate=$zdh(paramEndDate,3)
	s status="" f  s status=$O(^DHCNMG.CHK.MgNurTaskReleaseI("type",status)) q:status=""  d
	.s type="" f  s type=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type",status,type)) q:type=""  d
	..s date="" f  s date=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type",status,type,date)) q:date=""  d
	...s id="" f  s id=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type",status,type,date,id)) q:id=""  d
	....s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(id)
	....q:((paramType'="")&&(obj.TaskType'=paramType))
	....;q:((paramStDate'="")&&(obj.TaskStDate<paramStDate)&&(obj.TaskEndDate<paramStDate))
	....q:(((paramStDate'="")&&(paramStDate>obj.TaskEndDate))||((paramEndDate'="")&&(paramEndDate<obj.TaskStDate)))
	....q:((nurseId'="")&&(obj.TaskCreator'=nurseId))
	....s QualType=""
	....i obj.TaskType'="" d
	.....s QualObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.TaskType)
	.....q:'$IsObject(QualObj)
	.....s QualType=QualObj.SubDesc
	....s TaskStDate=""
	....i obj.TaskStDate'="" s TaskStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskStDate)
	....s TaskEndDate=""
	....i obj.TaskEndDate'="" s TaskEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskEndDate)
	....s TaskChecker=""
	....s l=obj.TaskChecker.Count()
	....f i=1:1:l d
	.....s itm=obj.TaskChecker.GetAt(i)
	.....q:itm=""
	.....s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(itm)
	.....q:'$IsObject(NurObj)
	.....i TaskChecker="" s TaskChecker=NurObj.PerName
	.....e  s TaskChecker=TaskChecker_","_NurObj.PerName
	....s TaskQuals=""
	....s m=obj.TaskQuals.Count()
	....f j=1:1:m d
	.....s item=obj.TaskQuals.GetAt(j)
	.....q:item=""
	.....s ItemObj=##class(DHCNMG.DB.MgQualItem).%OpenId(item)
	.....q:'$IsObject(ItemObj)
	.....i TaskQuals="" s TaskQuals=ItemObj.QualDesc
	.....e  s TaskQuals=TaskQuals_","_ItemObj.QualDesc
	....s TaskWards=""
	....s n=obj.TaskWards.Count()
	....f k=1:1:n d
	.....s ward=obj.TaskWards.GetAt(k)
	.....q:ward=""
	.....s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	.....q:'$IsObject(WardObj)
	.....i TaskWards="" s TaskWards=WardObj.WardDesc
	.....e  s TaskWards=TaskWards_","_WardObj.WardDesc
	....s TaskCreator=""
	....i obj.TaskCreator=0 s TaskCreator="管理员"
	....e  d
	.....s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.TaskCreator)
	.....q:'$IsObject(PerObj)
	.....s TaskCreator=PerObj.PerName
	....s CreateDate=""
	....i obj.CreateDate'="" s CreateDate=$zd(obj.CreateDate,3)
	....s Status=""
	....i obj.Status="N" s Status="保存"
	....e  i obj.Status="Y" s Status="发布"
	....s ret="QualType|"_QualType_"^TaskStDate|"_TaskStDate_"^TaskEndDate|"_TaskEndDate_"^TaskChecker|"_TaskChecker_"^TaskQuals|"_TaskQuals_"^TaskWards|"_TaskWards_"^TaskCreator|"_TaskCreator_"^CreateDate|"_CreateDate_"^Status|"_Status_"^RowID|"_id
	....s QualLevel=obj.QualLevel
	....s QualLevel=$case(QualLevel,"W":"病区自查","L":"科室督查","H":"护理部","":"护理部")
	....s ret=ret_"^QualLevel|"_QualLevel
	....do OutputTaskList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTaskList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualReleaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualReleaseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualReleaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualReleaseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// CreateDate:2019-01-16
/// Description:获取质控发布数据
/// Table：
/// Input:
/// Output:
/// Other:
ClassMethod GetQualReleaseData(id As %String) As %String
{
	q:id="" "[]"
	s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(id)
	q:'$IsObject(obj) "[]"
	s TaskType=$tr(obj.TaskType,"||","__")
	i obj.TaskStDate'="" s TaskStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskStDate)
	e  s TaskStDate=""
	i obj.TaskEndDate'="" s TaskEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskEndDate)
	e  s TaskEndDate=""
	s TaskChecker=""
	s l=obj.TaskChecker.Count()
	f i=1:1:l
	{
		s itm=obj.TaskChecker.GetAt(i)
		i itm="" continue
		i TaskChecker="" s TaskChecker=""""_itm_""""
		e  s TaskChecker=TaskChecker_","""_itm_""""
	}
	s TaskChecker="["_TaskChecker_"]"
	s TaskWards=""
	s m=obj.TaskWards.Count()
	f j=1:1:m
	{
		s ward=obj.TaskWards.GetAt(j)
		i ward="" continue
		s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
		q:'$IsObject(WardObj)
		i j=1 s TaskWards="{""WardDesc"":"""_WardObj.WardDesc_""",""WardID"":"""_ward_"""}"
		e  s TaskWards=TaskWards_",{""WardDesc"":"""_WardObj.WardDesc_""",""WardID"":"""_ward_"""}"
	}
	s TaskWards="["_TaskWards_"]"
	s TaskQuals=""
	s n=obj.TaskQuals.Count()
	f k=1:1:n
	{
		s qual=obj.TaskQuals.GetAt(k)
		i qual="" continue
		s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(qual)
		q:'$IsObject(QualObj)
		i k=1 s TaskQuals="{""QualDesc"":"""_QualObj.QualDesc_""",""QualID"":"""_qual_"""}"
		e  s TaskQuals=TaskQuals_",{""QualDesc"":"""_QualObj.QualDesc_""",""QualID"":"""_qual_"""}"
	}
	s TaskQuals="["_TaskQuals_"]"
	s QualCheckGroup=obj.TaskCheckGroup
	s QualLevel=obj.QualLevel
	s:QualLevel="" QualLevel="H"
	w "[{""QualType"":"""_TaskType_""",""QualStDate"":"""_TaskStDate_""",""QualEndDate"":"""_TaskEndDate_""",""QualChecker"":"_TaskChecker_",""QualWards"":"_TaskWards_",""QualItems"":"_TaskQuals_",""RowID"":"""_id_""",""QualCheckGroup"":"""_QualCheckGroup_""",""QualLevel"":"""_QualLevel_"""}]"
	q ""
}

/// Creator:gzj
/// CreateDate:2019-01-16
/// Description:获取发布记录的状态
/// Table:
/// Input:
/// Output:
/// Other
ClassMethod GetQualReleaseStatus(id As %String) As %String
{
	q:id="" 0
	s flag=0
	s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.Status="Y" s flag=1
	q flag
}

/// Creator:gzj
/// Description:查询发布的质控任务
/// Date:2019-01-17
/// Table:
/// Input:检索条件,登录人id，登录权限，登录病区
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindQualReleaseTask","2018^8__1^0^^admin")
Query FindQualReleaseTask(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualReleaseTaskExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^Tmpll("FindQualReleaseTask")=parr
	/*
	qualYear|2018^qualDesc|测试^qualType|质控查房^qualCode|测试^rowid|1
	^qualScore|9^qualScoreType|按分值^qualTyperw|8__1^GroupDesc|^GroupDR|^QualLevel|H^QualLevelDesc|护理部:
	*/
	s repid=$I(^CacheTemp)
	s ind=1
	
	do OutputQualTask
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQualTask
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualReleaseTaskFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualReleaseTaskExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualReleaseTaskClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualReleaseTaskExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// CreateDate:2019-01-17
/// Descrption:获取发布的质控任务
/// Table:
/// Input:
/// Output:
/// Other: d ##class(web.NurMgQualCheckComm).GetQualReleaseTask("2019-01-02^2019-02-22^0^^admin")
ClassMethod GetQualReleaseTask(parr As %String = "") As %String
{
	s stDate=$tr($p(parr,"^",1)," ","")
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$tr($p(parr,"^",2)," ","")
	i endDate'="" s endDate=$zdh(endDate,3)
	s loginID=$tr($p(parr,"^",3)," ","")
	s loginDep=$tr($p(parr,"^",4)," ","")
	s loginRoleCode=$zcvt($tr($p(parr,"^",5)," ",""),"U")
	s tmp=""
	s QualType="" f  s QualType=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualType)) q:QualType=""  d
	.s CheckDate="" f  s CheckDate=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualType,CheckDate)) q:CheckDate=""  d
	..s RowID="" f  s RowID=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualType,CheckDate,RowID)) q:RowID=""  d
	...s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(RowID)
	...q:'$IsObject(obj)
	...q:(((obj.TaskStDate'="")&&(endDate'="")&&(endDate<obj.TaskStDate))!((obj.TaskEndDate'="")&&(stDate'="")&&(stDate>obj.TaskEndDate)))
	...s flag=0
	...s checkLen=obj.TaskChecker.Count()
	...f l=1:1:checkLen d
	....s checker=obj.TaskChecker.GetAt(l)
	....q:checker=""
	....i checker=loginID s flag=1
	...q:((loginRoleCode'="ADMIN")&&(loginRoleCode'="HLB")&&(loginRoleCode'="HLBZR")&&(loginRoleCode'="MANAGER")&&(flag'=1))
	...s TypeDesc=""
	...i obj.TaskType'="" d
	....s TypeObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.TaskType)
	....q:'$IsObject(TypeObj)
	....s TypeDesc=TypeObj.SubDesc
	...;s TaskStDate=$zd(obj.TaskStDate,3)
	...;s TaskEndDate=$zd(obj.TaskEndDate,3)
	...s TaskStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskStDate)
	...s TaskEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskEndDate)
	...s TaskQuals=""
	...s len=obj.TaskQuals.Count()
	...s n=1
	...f i=1:1:len d
	....s itm=obj.TaskQuals.GetAt(i)
	....q:itm=""
	....s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(itm)
	....q:'$IsObject(QualObj)
	....s WardCount=obj.TaskWards.Count()
	....s scoreWard="" f  s scoreWard=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_RowID,1," "_itm,scoreWard)) q:scoreWard=""  d
	.....s scoreRw="" f  s scoreRw=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_RowID,1," "_itm,scoreWard,scoreRw)) q:scoreRw=""  d
	......s ChkObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(scoreRw)
	......i ChkObj.Status="S" s WardCount=WardCount-1
	....i n=1 s TaskQuals="{""QualDesc"":"""_QualObj.QualDesc_""",""QualScoreType"":"""_QualObj.QualScoreType_""",""QualID"":"""_itm_""",""QID"":"""_RowID_""",""TaskStDate"":"""_TaskStDate_""",""WardCount"":"""_WardCount_"""}"
	....e  s TaskQuals=TaskQuals_",{""QualDesc"":"""_QualObj.QualDesc_""",""QualScoreType"":"""_QualObj.QualScoreType_""",""QualID"":"""_itm_""",""QID"":"""_RowID_""",""TaskStDate"":"""_TaskStDate_""",""WardCount"":"""_WardCount_"""}"
	....s n=n+1
	...s tmp(obj.TaskType,RowID)="{""TaskStDate"":"""_TaskStDate_""",""TaskEndDate"":"""_TaskEndDate_""",""TaskQuals"":["_TaskQuals_"]}"
	
	w "["
	s m=1
	s type="" f  s type=$o(tmp(type)) q:type=""  d
	.s ret="",k=1
	.s SubObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(type)
	.q:'$IsObject(SubObj)
	.s rw="" f  s rw=$o(tmp(type,rw)) q:rw=""  d
	..i k=1 s ret=tmp(type,rw)
	..e  s ret=ret_","_tmp(type,rw)
	..s k=k+1
	.i m=1 w "{""TypeDesc"":"""_SubObj.SubDesc_""",""children"":["_ret_"]}"
	.e  w ",{""TypeDesc"":"""_SubObj.SubDesc_""",""children"":["_ret_"]}"
	.s m=m+1
	w "]"
	q ""
}

ClassMethod SetQualLoginWard(role, id, tmpWard) As %String
{
	q:id="" 0
	q:id=0 1
	s isHLB=##class(web.NurMgSetComm).IsNurInRole(id,"hlb")
	s:isHLB'=1 isHLB=##class(web.NurMgSetComm).IsNurInRole(id,"hlbzr")
	s:isHLB'=1 isHLB=##class(web.NurMgSetComm).IsNurInRole(id,"manager")
	q:isHLB=1 1
	f i=1:1:$L(role,"^")  d
	.s troleCode=$P(role,"^",i)
	.s trole=$O(^DHCNMG.Set.MgRolesI("code"," Y"," "_troleCode,""))
	.q:trole=""
	.s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_trole," "_id,rolerw)) q:rolerw=""  d
	..s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
	...s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
	...s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	....s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
	.....q:(id'=roledepobj.SubWard)
	.....s tmpWard(id)=id	
	//s curward=##class(web.NurMgHRComm).GetCurrentWard(nurseid,+$h)
	//s:(curward'="")&&('$d(tmpWard(curward))) tmpWard(curward)=curward
	q 0
}

ClassMethod GetQualReleaseTaskTest(parr As %String = "") As %String
{
	s stDate=$tr($p(parr,"^",1)," ","")
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$tr($p(parr,"^",2)," ","")
	i endDate'="" s endDate=$zdh(endDate,3)
	s loginID=$tr($p(parr,"^",3)," ","")
	s loginDep=$tr($p(parr,"^",4)," ","")
	s loginRoleCode=$zcvt($tr($p(parr,"^",5)," ",""),"U")
	s tmp=""
	s QualType="" f  s QualType=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualType)) q:QualType=""  d
	.s CheckDate="" f  s CheckDate=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualType,CheckDate)) q:CheckDate=""  d
	..s RowID="" f  s RowID=$o(^DHCNMG.CHK.MgNurTaskReleaseI("type"," Y",QualType,CheckDate,RowID)) q:RowID=""  d
	...s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(RowID)
	...q:'$IsObject(obj)
	...q:(((obj.TaskStDate'="")&&(endDate'="")&&(endDate<obj.TaskStDate))!((obj.TaskEndDate'="")&&(stDate'="")&&(stDate>obj.TaskEndDate)))
	...s flag=0
	...s checkLen=obj.TaskChecker.Count()
	...f l=1:1:checkLen d
	....s checker=obj.TaskChecker.GetAt(l)
	....q:checker=""
	....i checker=loginID s flag=1
	...q:((flag'=1)&&((obj.QualLevel="L")||(obj.QualLevel="H")))
	...i ((obj.QualLevel="W")||(obj.QualLevel="L")) s flag2=1
	...q:((loginRoleCode'="ADMIN")&&(loginRoleCode'="HLB")&&(loginRoleCode'="HLBZR")&&(loginRoleCode'="MANAGER")&&(flag2'=1))
	...s TypeDesc=""
	...i obj.TaskType'="" d
	....s TypeObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(obj.TaskType)
	....q:'$IsObject(TypeObj)
	....s TypeDesc=TypeObj.SubDesc
	...s TaskStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskStDate)
	...s TaskEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskEndDate)
	...s TaskQuals=""
	...//大科、病区只显示所辖权限病区
	...s isAll=0
	...i obj.QualLevel="W" d
	....k tmpWard
	....s tmpWard="" 
	....s isAll=..SetQualLoginWard("NURHEAD^ZKXZ",loginID,.tmpWard)
	...;i obj.QualLevel="L" d
	....;k tmpWard
	....;s tmpWard="" 
	....;s isAll=..SetQualLoginWard("ZNURHEAD^NURHEAD^ZKXZ",loginID,.tmpWard)
	...s tWardCount=obj.TaskWards.Count(),flag1=0
	...;i (isAll=0)&&((obj.QualLevel="W")||(obj.QualLevel="L")) d
	...i ((isAll=0)&&(obj.QualLevel="W")) d
	....f i=1:1:obj.TaskWards.Count() d
	.....i '$d(tmpWard(obj.TaskWards.GetAt(i))) s tWardCount=tWardCount-1
	.....e  s flag1=1
	...e  s flag1=1
	...q:(flag1=0)
	...s len=obj.TaskQuals.Count()
	...s n=1
	...f i=1:1:len d
	....s itm=obj.TaskQuals.GetAt(i)
	....q:itm=""
	....s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(itm)
	....q:'$IsObject(QualObj)
	....s WardCount=tWardCount
	....s scoreWard="" f  s scoreWard=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_RowID,1," "_itm,scoreWard)) q:scoreWard=""  d
	.....//wangpf
	.....q:(loginRoleCode'="ADMIN")&&(loginRoleCode'="HLB")&&(loginRoleCode'="HLBZR")&&(loginRoleCode'="MANAGER")&&('$d(tmpWard($tr(scoreWard," ",""))))
	.....s scoreRw="" f  s scoreRw=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_RowID,1," "_itm,scoreWard,scoreRw)) q:scoreRw=""  d
	......s ChkObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(scoreRw)
	......i ChkObj.Status="S" s WardCount=WardCount-1
	....i n=1 s TaskQuals="{""QualDesc"":"""_QualObj.QualDesc_""",""QualScoreType"":"""_QualObj.QualScoreType_""",""QualID"":"""_itm_""",""QID"":"""_RowID_""",""TaskStDate"":"""_TaskStDate_""",""WardCount"":"""_WardCount_"""}"
	....e  s TaskQuals=TaskQuals_",{""QualDesc"":"""_QualObj.QualDesc_""",""QualScoreType"":"""_QualObj.QualScoreType_""",""QualID"":"""_itm_""",""QID"":"""_RowID_""",""TaskStDate"":"""_TaskStDate_""",""WardCount"":"""_WardCount_"""}"
	....s n=n+1
	....s tmp(obj.TaskType,itm,RowID)=WardCount
	...;s tmp(obj.TaskType,RowID)="{""TaskStDate"":"""_TaskStDate_""",""TaskEndDate"":"""_TaskEndDate_""",""TaskQuals"":["_TaskQuals_"]}"
	
	w "["
	s m=1
	s type="" f  s type=$o(tmp(type)) q:type=""  d
	.s ret="",k=1
	.s SubObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(type)
	.q:'$IsObject(SubObj)
	.s qitm="" f  s qitm=$o(tmp(type,qitm)) q:qitm=""  d
	..s QItmSetObj=##class(DHCNMG.DB.MgQualItem).%OpenId(qitm)
	..q:'$IsObject(QItmSetObj)
	..s l=1,QIDS="",wardCount=0
	..s rw="" f  s rw=$o(tmp(type,qitm,rw)) q:rw=""  d
	...i QIDS="" s QIDS=rw
	...e  s QIDS=QIDS_","_rw
	...s wardCount=wardCount+tmp(type,qitm,rw)
	..i k=1 s ret="{""QualDesc"":"""_QItmSetObj.QualDesc_""",""QualID"":"""_qitm_""",""QualScoreType"":"""_QItmSetObj.QualScoreType_""",""QID"":"""_QIDS_""",""WardCount"":"""_wardCount_"""}"
	..e  s ret=ret_","_"{""QualDesc"":"""_QItmSetObj.QualDesc_""",""QualID"":"""_qitm_""",""QualScoreType"":"""_QItmSetObj.QualScoreType_""",""QID"":"""_QIDS_""",""WardCount"":"""_wardCount_"""}"
	..s k=k+1
	.i m=1 w "{""TypeDesc"":"""_SubObj.SubDesc_""",""children"":["_ret_"]}"
	.e  w ",{""TypeDesc"":"""_SubObj.SubDesc_""",""children"":["_ret_"]}"
	.s m=m+1
	w "]"
	q ""
}

/// Creator:gzj
/// CreateDate:2019-01-19
/// Descrption:查询检查任务()
/// Table:
/// Input:
/// Output:
/// Return:
/// Other: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCheckTask","18","5,6","","")
Query FindCheckTask(QualID As %String, TaskID As %String, RowID As %String, Status As %String, nurseid As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckTaskExecute(ByRef qHandle As %Binary, QualID As %String, TaskID As %String, RowID As %String, Status As %String, nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i TaskID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s TaskLen=$l(TaskID,",")
	f k=1:1:TaskLen
	{
		s Task=$p(TaskID,",",k)
		s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(Task)
		q:'$IsObject(obj)
		//大科、病区只显示所辖权限病区
		s isAll=0,tmpWard=""
		i obj.QualLevel="W" d
		.k tmpWard
		.s tmpWard="" 
		.s isAll=..SetQualLoginWard("NURHEAD^ZKXZ",nurseid,.tmpWard)
		i obj.QualLevel="L" d
		.k tmpWard
		.s tmpWard="" 
		.s isAll=..SetQualLoginWard("ZNURHEAD^NURHEAD^ZKXZ",nurseid,.tmpWard)
		s tWardCount=obj.TaskWards.Count(),flag=0
		i (isAll=0)&&((obj.QualLevel="W")||(obj.QualLevel="L")) d
		.f i=1:1:obj.TaskWards.Count() d
		..i '$d(tmpWard(obj.TaskWards.GetAt(i))) s tWardCount=tWardCount-1
		..e  s flag=1
		e  s flag=1
		q:(flag=0)&&((obj.QualLevel="W")||(obj.QualLevel="L"))
	
		s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(QualID)
		q:'$IsObject(QualObj)
		s TaskType=obj.TaskType
		s SubObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(TaskType)
		q:'$IsObject(SubObj)
	
		s len=obj.TaskWards.Count()
		f i=1:1:len
		{
			s ward=obj.TaskWards.GetAt(i)
			i ward="" continue
			i (isAll=0)&&((obj.QualLevel="W")||(obj.QualLevel="L"))&&('$d(tmpWard(ward))) continue
			s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
			q:'$IsObject(WardObj)
			s ChkRw=$o(^DHCNMG.CHK.MgCheckRoomI("task"," "_Task,1," "_QualID," "_ward,""))
			s SubmitDate="",Score="",Remark="",status="",CreateDate="",CheckUser=""
			i ChkRw'="" d
			.s ChkObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(ChkRw)
			.q:'$IsObject(ChkObj)
			.s Score=ChkObj.CheckScore
			.i ChkObj.SubmitDate'="" s SubmitDate=##class(web.NurMgHISComm).DateLogicalToHtml(ChkObj.SubmitDate) ;$zd(ChkObj.SubmitDate,3)
			.i ChkObj.CreateDate'="" s CreateDate=##class(web.NurMgHISComm).DateLogicalToHtml(ChkObj.CreateDate)
			.s Remark=ChkObj.Remark
			.s status=ChkObj.Status
			.i ChkObj.CheckUser=0 s CheckUser="管理员"
			.e  d
			..s CheckUserObj=##class(DHCNMG.HR.MgPersons).%OpenId(ChkObj.CheckUser)
			..q:'$IsObject(CheckUserObj)
			..s CheckUser=CheckUserObj.PerName
			.;i ChkObj.Status="S" s status="已考核"
			.;e  i ChkObj.Status="N" s status="已保存"
			.s Remark=ChkObj.Remark
			i status="S" s statusDesc="已考核"
			e  i status="N" s statusDesc="已保存"
			e  s statusDesc="未考核"
			i ((Status'="")&&(status'=Status)) continue
			s WardDesc=WardObj.WardDesc
			s QualDesc=QualObj.QualDesc
			;s StDate=$zd(obj.TaskStDate,3)
			;s EndDate=$zd(obj.TaskEndDate,3)
			s StDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskStDate)
			s EndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.TaskEndDate)
			s TypeDesc=SubObj.SubDesc
			s Checkers=""
			s cLen=obj.TaskChecker.Count()
			f j=1:1:cLen
			{
				s checker=obj.TaskChecker.GetAt(j)
				i checker="" continue
				s CheckObj=##class(DHCNMG.HR.MgPersons).%OpenId(checker)
				q:'$IsObject(CheckObj)
				i Checkers="" s Checkers=CheckObj.PerName
				e  s Checkers=Checkers_","_CheckObj.PerName
			}
			s Creator=""
			i obj.TaskCreator=0 s Creator="管理员"
			e  d
			.s CreateObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.TaskCreator)
			.q:'$IsObject(CreateObj)
			.s Creator=CreateObj.PerName
			s ret="TaskID|"_Task_"^WardID|"_ward_"^WardDesc|"_WardDesc_"^QualID|"_QualID_"^QualDesc|"_QualDesc_"^StDate|"_StDate_"^EndDate|"_EndDate_"^TypeDesc|"_TypeDesc_"^Checkers|"_Checkers_"^Creator|"_Creator_"^RowID|"_ChkRw_"^Score|"_Score_"^Remark|"_Remark_"^Status|"_statusDesc_"^SubmitDate|"_SubmitDate
			s ret=ret_"^CreateDate|"_CreateDate_"^CheckUser|"_CheckUser
			do OutputCheckTask
		
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckTask
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckTaskFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckTaskExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckTaskClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckTaskExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTaskFlag(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.Status
	q ret
}

/// Creator:gzj
/// Description:查询问题汇总项
/// Date:2019-01-22
/// Table:DHCNMG.CHK.MgCheckRomm
/// Input:检查日期^截止日期^检查级别^状态^问题来源^病区id
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindCheckQuestions","2011-09-01^2019-09-30^^^^^8__1^","0","0")
Query FindCheckQuestions(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCheckQuestionsExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s stdate=$p(parr,"^")
	s enddate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s level=$p(parr,"^",3)
	s status=$p(parr,"^",4)
	s source=$tr($p(parr,"^",5),"_","|")
	s ward=$p(parr,"^",6)
	s type=$tr($p(parr,"^",7),"__","||") //质控类型
	s focus=$p(parr,"^",8) //重点关注
	
	//除了夜查房的都走此处
	s taskID="" f  s taskID=$o(^DHCNMG.CHK.MgCheckRoomI("task",taskID)) q:taskID=""  d
	.s checkType="" f  s checkType=$o(^DHCNMG.CHK.MgCheckRoomI("task",taskID,checkType)) q:checkType=""  d
	..s checkDR="" f  s checkDR=$o(^DHCNMG.CHK.MgCheckRoomI("task",taskID,checkType,checkDR)) q:checkDR=""  d
	...s checkWard="" f  s checkWard=$o(^DHCNMG.CHK.MgCheckRoomI("task",taskID,checkType,checkDR,checkWard)) q:checkWard=""  d
	....s checkRw="" f  s checkRw=$o(^DHCNMG.CHK.MgCheckRoomI("task",taskID,checkType,checkDR,checkWard,checkRw)) q:checkRw=""  d
	.....s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(checkRw)
	.....q:'$IsObject(obj)
	.....q:obj.Status'="S"
	.....q:obj.TaskID=""
	.....i obj.IfFocus="1" s ifFocus = "true" //是否重点关注
	.....e  s ifFocus="false"
	.....q:((focus'="")&&(ifFocus'=focus))
	.....;q:(((stdate'="")&&(obj.CreateDate'="")&&(obj.CreateDate<stdate))!((enddate'="")&&(obj.CreateDate'="")&&(obj.CreateDate>enddate)))
	.....s TaskObj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(obj.TaskID)
	.....q:'$IsObject(TaskObj)
	.....q:(((stdate'="")&&(TaskObj.CreateDate'="")&&(TaskObj.CreateDate<stdate))!((enddate'="")&&(TaskObj.CreateDate'="")&&(TaskObj.CreateDate>enddate)))
	.....s TaskCode=TaskObj.TaskType
	.....s question=""
	.....s flag=0
	.....s sort="" f  s sort=$o(^DHCNMG.CHK.MgCheckRoomSubI("Sort",checkRw,sort)) q:sort=""  d
	......s rw="" f  s rw=$o(^DHCNMG.CHK.MgCheckRoomSubI("Sort",checkRw,sort,rw)) q:rw=""  d
	.......s subObj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(checkRw_"||"_rw)
	.......q:'$IsObject(subObj)
	.......q:subObj.CheckItemScore="-"
	.......s ItemRemark=subObj.CheckItemRemark
	.......i ((subObj.CheckItemScore'="")&&(subObj.StandardScore'="")&&((+subObj.CheckItemScore)<(+subObj.StandardScore))) d
	........i question="" d
	.........i ItemRemark'="" s question=subObj.CheckItem_"【"_ItemRemark_"】"
	.........e  s question=subObj.CheckItem
	........e  d
	.........i ItemRemark'="" s question=question_";"_subObj.CheckItem_"【"_ItemRemark_"】"
	.........e  s question=question_";"_subObj.CheckItem
	........s flag=1
	.....i flag=1 s tmp("Q",TaskCode,obj.CheckType,obj.CheckDR,checkRw,obj.ScoreWard)=question //Q "质控检查"

	s qual="" f  s qual=$o(tmp(qual)) q:qual=""  d
	.q:qual'="Q"
	.s TypeCode="" f  s TypeCode=$o(tmp(qual,TypeCode)) q:TypeCode=""  d
	..q:((type'="")&&(TypeCode'=type))
	..s CheckType="" f  s CheckType=$o(tmp(qual,TypeCode,CheckType)) q:CheckType=""  d //质控来源 1：标准；2：重组
	...s QualType="" f  s QualType=$o(tmp(qual,TypeCode,CheckType,QualType)) q:QualType=""  d //质控类型id
	....q:((source'="")&&(QualType'=source))
	....s CheckRw="" f  s CheckRw=$o(tmp(qual,TypeCode,CheckType,QualType,CheckRw)) q:CheckRw=""  d //查房ID
	.....s CheckWard="" f  s CheckWard=$o(tmp(qual,TypeCode,CheckType,QualType,CheckRw,CheckWard)) q:CheckWard=""  d //质控病区
	......q:((ward'="")&&(CheckWard'=ward))
	......s roleFlag=..GetRoleDesc(role)
	......s IsWardFlag=..CheckWardFlag(role,nurseid,CheckWard)
	......q:((IsWardFlag=0)&&(roleFlag=0))
	......s CheckObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(CheckRw)
	......q:'$IsObject(CheckObj)
	......i CheckObj.IfFocus="1" s ifFocus = "true" //是否重点关注
	......e  s ifFocus="false"
	......q:((focus'="")&&(ifFocus'=focus))
	......;s QueDate=""
	......;i CheckObj.CreateDate'="" s QueDate=$zd(CheckObj.CreateDate,3)
	......s TypeDesc=""
	......s TypeObj=##class(DHCNMG.DB.MgQualItem).%OpenId(QualType)
	......q:'$IsObject(TypeObj)
	......s TypeDesc=TypeObj.QualDesc
	......s QueWard=""
	......i CheckObj.ScoreWard'="" d
	.......s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(CheckObj.ScoreWard)
	.......q:'$IsObject(WardObj)
	.......s QueWard=WardObj.WardDesc
	......s Question=tmp(qual,TypeCode,CheckType,QualType,CheckRw,CheckWard)
	......s QualDesc=""
	......s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(QualType)
	......q:'$IsObject(QualObj)
	......s QualDesc=QualObj.QualDesc
	......s TaskObj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(CheckObj.TaskID)
	......q:'$IsObject(TaskObj)
	......s QueDate=""
	......i TaskObj.CreateDate'="" s QueDate=$zd(TaskObj.CreateDate,3)
	......s TaskType=$tr(TaskObj.TaskType,"||","__")
	......s SysSubObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(TaskObj.TaskType)
	......q:'$IsObject(SysSubObj)
	......s TaskDesc=SysSubObj.SubDesc
	......s retStatus="N"
	......s QuesID=$o(^DHCNMG.CHK.MgCheckQuesI("Check"," Q"," "_CheckRw,""),-1)
	......i QuesID'="" d
	.......s QuesObj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(QuesID)
	.......q:'$IsObject(QuesObj)
	.......s retStatus=QuesObj.QuesStatus
	......q:(status'="")&&(retStatus'=status)
	......s retStatusDesc=$case(retStatus,"N":"待处理","N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	......s ret="TypeDesc|"_TypeDesc_"^TaskType|"_TaskType_"^TaskDesc|"_TaskDesc_"^QualID|"_QualType_"^QualDesc|"_QualDesc_"^stdate|"_QueDate_"^ward|"_QueWard_"^question|"_Question_"^checkPar|"_CheckRw_"^ifFocus|"_ifFocus
	......s ret=ret_"^statusDesc|"_retStatusDesc_"^CheckType|Q"_"^RelationWard|"_TaskObj.TaskWards.Count()
	......;增加返回值 原因分析 整改措施 护理部意见
	......s id=$O(^DHCNMG.CHK.MgCheckQuesI("Check"," Q"," "_CheckRw,""))
	......s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
	......i '$IsObject(obj) d
	.......s ret=ret_"^rea|"_"^steps|^subView|"
	......e  d
	.......s subid="" f  s subid=$o(^DHCNMG.CHK.MgCheckQuesSubD(id,subid)) q:subid=""  d
	........s subObj=##class(DHCNMG.CHK.MgCheckQuesSub).%OpenId(id_"||"_subid)
	........s rea=subObj.QuesSubRea
	........s nurRea=subObj.QuesSubNurRea
	........s patRea=subObj.QuesSubPatRea
	........s deviceRea=subObj.QuesSubDeviceRea
	........s workRea=subObj.QuesSubWorkRea
	........s goodsRea=subObj.QuesSubGoodsRea
	........s rea=rea_";"_nurRea_";"_patRea_";"_deviceRea_";"_workRea_";"_goodsRea
	........s steps=subObj.QuesSubSteps
	........s subView=subObj.QuesSubView
	........s ret=ret_"^rea|"_rea_"^steps|"_steps_"^subView|"_subView
	......do OutputCheckQuestons
	
	s NTaskID="" f  s NTaskID=$o(^DHCNMG.CHK.MgNurNightCheckI("Ward",NTaskID)) q:NTaskID=""  d
	.s NQualID="" f  s NQualID=$o(^DHCNMG.CHK.MgNurNightCheckI("Ward",NTaskID,NQualID)) q:NQualID=""  d
	..s NWard="" f  s NWard=$o(^DHCNMG.CHK.MgNurNightCheckI("Ward",NTaskID,NQualID,NWard)) q:NWard=""  d
	...s NID="" f  s NID=$o(^DHCNMG.CHK.MgNurNightCheckI("Ward",NTaskID,NQualID,NWard,NID)) q:NID=""  d
	....s NObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(NID)
	....q:'$IsObject(NObj)
	....q:NObj.TaskID.%Id()=""
	....;q:((stdate'="")&&(NObj.TaskChkDate'="")&&(NObj.TaskChkDate<stdate))!((enddate'="")&&(NObj.TaskChkDate'="")&&(NObj.TaskChkDate>enddate))
	....q:((stdate'="")&&(NObj.TaskDate'="")&&(NObj.TaskDate<stdate))!((enddate'="")&&(NObj.TaskDate'="")&&(NObj.TaskDate>enddate))
	....i NObj.IfFocus="1" s NIfFocus = "true" //是否重点关注
	....e  s NIfFocus="false"
	....q:((focus'="")&&(NIfFocus'=focus))
	....i NObj.TaskID.CheckType="N" s TaskCode="8||2"
	....e  i NObj.TaskID.CheckType="W" s TaskCode="8||4"
	....e  i NObj.TaskID.CheckType="H" s TaskCode="8||5"
	....s question=""
	....s flag=0
	....s NSubRw="" f  s NSubRw=$o(^DHCNMG.CHK.MgNurNightCheckSubD(NID,NSubRw)) q:NSubRw=""  d
	.....s NSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(NID_"||"_NSubRw)
	.....q:'$IsObject(NSubObj)
	.....s ItemRemark=NSubObj.TaskRemark
	.....i ((NSubObj.TaskResult'="")&&(NSubObj.TaskValue'="")&&((+NSubObj.TaskResult)<(+NSubObj.TaskValue))) d
	......i question="" d
	.......i ItemRemark'="" s question=NSubObj.TaskItems_"【"_ItemRemark_"】"
	.......e  s question=NSubObj.TaskItems
	......e  d
	.......i ItemRemark'="" s question=question_";"_NSubObj.TaskItems_"【"_ItemRemark_"】"
	.......e  s question=question_";"_NSubObj.TaskItems
	......s flag=1
	....i flag=1 s tmp("N",TaskCode,1,NObj.TaskQualID,NID,NObj.TaskWard)=question //Q "质控检查"
	
	s qual="" f  s qual=$o(tmp(qual)) q:qual=""  d
	.q:qual'="N"
	.s TypeCode="" f  s TypeCode=$o(tmp(qual,TypeCode)) q:TypeCode=""  d
	..q:((type'="")&&(TaskCode'=type))
	..s CheckType="" f  s CheckType=$o(tmp(qual,TypeCode,CheckType)) q:CheckType=""  d //质控来源 1：标准；2：重组
	...s QualType="" f  s QualType=$o(tmp(qual,TypeCode,CheckType,QualType)) q:QualType=""  d //质控类型id
	....q:((source'="")&&(QualType'=source))
	....s CheckRw="" f  s CheckRw=$o(tmp(qual,TypeCode,CheckType,QualType,CheckRw)) q:CheckRw=""  d //查房ID
	.....s CheckWard="" f  s CheckWard=$o(tmp(qual,TypeCode,CheckType,QualType,CheckRw,CheckWard)) q:CheckWard=""  d //质控病区
	......q:((ward'="")&&(CheckWard'=ward))
	......s roleFlag=..GetRoleDesc(role)
	......s IsWardFlag=..CheckWardFlag(role,nurseid,CheckWard)
	......q:((IsWardFlag=0)&&(roleFlag=0))
	......s NCheckObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(CheckRw)
	......q:'$IsObject(NCheckObj)
	......i NCheckObj.IfFocus="1" s NIfFocus = "true" //是否重点关注
	......e  s NIfFocus="false"
	......q:((focus'="")&&(NIfFocus'=focus))
	......s QueDate=""
	......;i NCheckObj.TaskChkDate'="" s QueDate=$zd(NCheckObj.TaskChkDate,3)
	......i NCheckObj.TaskDate'="" s QueDate=$zd(NCheckObj.TaskDate,3)
	......s TypeDesc=""
	......s TypeObj=##class(DHCNMG.DB.MgQualItem).%OpenId(QualType)
	......q:'$IsObject(TypeObj)
	......s TypeDesc=TypeObj.QualDesc
	......s QueWard=""
	......i NCheckObj.TaskWard'="" d
	.......s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(NCheckObj.TaskWard)
	.......q:'$IsObject(WardObj)
	.......s QueWard=WardObj.WardDesc
	......s Question=tmp(qual,TypeCode,CheckType,QualType,CheckRw,CheckWard)
	......s QualDesc=""
	......s QualObj=##class(DHCNMG.DB.MgQualItem).%OpenId(QualType)
	......q:'$IsObject(QualObj)
	......s QualDesc=QualObj.QualDesc
	......s TaskObj=##class(DHCNMG.CHK.MgNurHeadSchdule).%OpenId(NCheckObj.TaskID.%Id())
	......q:'$IsObject(TaskObj)
	......i TaskObj.CheckType="N" s TaskType=$tr("8||2","||","__")
	......e  i TaskObj.CheckType="W" s TaskType=$tr("8||4","||","__")
	......e  i TaskObj.CheckType="H" s TaskType=$tr("8||5","||","__")
	......s SysSubObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId($tr(TaskType,"__","||"))
	......q:'$IsObject(SysSubObj)
	......s TaskDesc=SysSubObj.SubDesc
	......s retStatus="N"
	......s QuesID=$o(^DHCNMG.CHK.MgCheckQuesI("Check"," N"," "_CheckRw,""),-1)
	......i QuesID'="" d
	.......s QuesObj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(QuesID)
	.......q:'$IsObject(QuesObj)
	.......s retStatus=QuesObj.QuesStatus
	......q:(status'="")&&(retStatus'=status)
	......s retStatusDesc=$case(retStatus,"N":"待处理","N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	......s ret="TypeDesc|"_TypeDesc_"^TaskType|"_TaskType_"^TaskDesc|"_TaskDesc_"^QualID|"_QualType_"^QualDesc|"_QualDesc_"^stdate|"_QueDate_"^ward|"_QueWard_"^question|"_Question_"^checkPar|"_CheckRw_"^ifFocus|"_NIfFocus
	......s ret=ret_"^statusDesc|"_retStatusDesc_"^CheckType|N"_"^RelationWard|"_TaskObj.CheckWards.Count()
	......;增加返回值 原因分析 整改措施 护理部意见
	......s id=$O(^DHCNMG.CHK.MgCheckQuesI("Check"," N"," "_CheckRw,""))
	......s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
	......i '$IsObject(obj) d
	.......s ret=ret_"^rea|"_"^steps|^subView|"
	......e  d
	.......s subid="" f  s subid=$o(^DHCNMG.CHK.MgCheckQuesSubD(id,subid)) q:subid=""  d
	........s subObj=##class(DHCNMG.CHK.MgCheckQuesSub).%OpenId(id_"||"_subid)
	........s rea=subObj.QuesSubRea
	........s nurRea=subObj.QuesSubNurRea
	........s patRea=subObj.QuesSubPatRea
	........s deviceRea=subObj.QuesSubDeviceRea
	........s workRea=subObj.QuesSubWorkRea
	........s goodsRea=subObj.QuesSubGoodsRea
	........s rea=rea_";"_nurRea_";"_patRea_";"_deviceRea_";"_workRea_";"_goodsRea
	........s steps=subObj.QuesSubSteps
	........s subView=subObj.QuesSubView
	........s ret=ret_"^rea|"_rea_"^steps|"_steps_"^subView|"_subView
	......do OutputCheckQuestons
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckQuestons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCheckQuestionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckQuestionsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCheckQuestionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckQuestionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// CreateDate:2019-1-30
/// Description:判断角色是否为护理部 管理员 超级管理员 护理部主任
/// Table:
/// Input:
/// Output:
/// Return:1 是 0 否
ClassMethod GetRoleDesc(role As %String) As %String
{
	i role=0 q "1"
	s len=$l(role,"^")
	s flag=0
	f i=1:1:len
	{
		s itm=$p(role,"^",i)
		i itm="" continue
		s obj=##class(DHCNMG.Set.MgRoles).%OpenId(itm)
		i '$IsObject(obj) continue
		s desc=obj.RoleDesc
		i ((desc="admin")!(desc="manager")!(desc="hlbzr")!(desc="hlb")) s flag=1
	}
	q flag
}

/// Creator:gzj
/// CreateDate:2019-01-23
/// Description:检查该病区是否在此角色的所辖范围之内
/// Table：
/// Input:role:角色ID串（7^6） nurseId:人员ID ward:病区ID
/// Output:
/// Return:1 存在 0 不存在
/// Others:
ClassMethod CheckWardFlag(role As %String, nurseId As %String, ward As %String) As %String
{
	q:((role=0)!(nurseId=0)) 1
	s len=$l(role,"^")
	s flag=0
	f i=1:1:len
	{
		s roleItm=$p(role,"^",i)
		i roleItm="" continue
		s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(roleItm)
		i ((rolecode="hlbzr")||(rolecode="hlb")||(rolecode="znurhead")||(rolecode="nurhead")||(rolecode="manager"))
		{
			s rw=$o(^DHCNMG.DB.MgDataLimitI("Role"," "_roleItm," "_nurseId,""))
			i rw'="" 
			{
				s sub="" f  s sub=$o(^DHCNMG.DB.MgDataLimitSubD(rw,sub)) q:sub=""  d
				.s obj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rw_"||"_sub)
				.q:'$IsObject(obj)
				.s LimitWard=obj.SubWard
				.i LimitWard=ward s flag=1
			}
		}
		elseif(rolecode="nurse")
		{
			s NurObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseId)
			q:'$IsObject(NurObj)
			s LimitWard=NurObj.PerDepDR
			i LimitWard=ward s flag=1
		}
	}
	q flag
}

/// Creator:gzj
/// CreateDate:2019-01-25
/// Description:获取全部质控项目+year
/// Table:
/// Input:
/// Output:
/// Other:
Query FindQualItemsAll(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualItemsAllExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s yearParam=$tr($p(parr,"^",1)," ","")
	s typeParam=$tr($p(parr,"^",2),"__","||")
	s rowid="" f  s rowid=$O(^DHCNMG.DB.MgQualItemD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.DB.MgQualItem).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:((yearParam'="")&&(obj.QualYear'=yearParam))
	.q:((typeParam'="")&&(obj.QualType'[typeParam))
	.s QualCode=$zcvt(obj.QualCode,"U")
	.s QualDesc=obj.QualDesc
	.s QualYear=obj.QualYear
	.s qualDescSpell=##class(ext.util.String).ToChineseSpell(QualDesc) //首字母简拼
	.s ret="qualDesc|"_QualDesc_"("_QualYear_")"_"^qualCode|"_QualCode_"^rowid|"_rowid_"^qualDescSpell|"_qualDescSpell
	.do OutQualData
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualItemsAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualItemsAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualItemsAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualItemsAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:查询问题汇总项详情列表【珠海】
/// Date:2019-01-26
/// Table:DHCNMG.CHK.MgCheckRomm
/// Input:质控检查ID
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindQuesBack","10^Q")
Query FindQuesBack(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindQuesBackExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s par=$p(parr,"^",1)
	s type=$p(parr,"^",2)
	s desc=""
	i type="Q"
	{
		s rw="" f  s rw=$o(^DHCNMG.CHK.MgCheckRoomSubD(par,rw)) q:rw=""  d
		.s checkObj=##class(DHCNMG.CHK.MgCheckRoomSub).%OpenId(par_"||"_rw)
		.q:'$IsObject(checkObj)
		.s ItemRemark=$tr(checkObj.CheckItemRemark," ","")
		.i ((checkObj.CheckItemScore'="")&&(checkObj.StandardScore'="")&&((+checkObj.CheckItemScore)<(+checkObj.StandardScore))) d
		..i desc="" d
		...i ItemRemark'="" s desc=checkObj.CheckItem_"【"_ItemRemark_"】"
		...e  s desc=checkObj.CheckItem
		..e  d
		...i ItemRemark'="" s desc=desc_";"_checkObj.CheckItem_"【"_ItemRemark_"】"
		...e  s desc=desc_";"_checkObj.CheckItem
	}
	elseif (type="N")
	{
		s nRw="" f  s nRw=$o(^DHCNMG.CHK.MgNurNightCheckSubD(par,nRw)) q:nRw=""  d
		.s NCheckObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(par_"||"_nRw)
		.q:'$IsObject(NCheckObj)
		.s ItemRemark=$tr(NCheckObj.TaskRemark," ","")
		.i ((NCheckObj.TaskResult'="")&&(NCheckObj.TaskValue'="")&&((+NCheckObj.TaskResult)<(+NCheckObj.TaskValue))) d
		..i desc="" d
		...i ItemRemark'="" s desc=NCheckObj.TaskItems_"【"_ItemRemark_"】"
		...e  s desc=NCheckObj.TaskItems
		..e  d
		...i ItemRemark'="" s desc=desc_";"_NCheckObj.TaskItems_"【"_ItemRemark_"】"
		...e  s desc=desc_";"_NCheckObj.TaskItems
	}
	s id=$O(^DHCNMG.CHK.MgCheckQuesI("Check"," "_type," "_par,""))
	s obj=##class(DHCNMG.CHK.MgCheckQues).%OpenId(id)
	s status=""
	s ret=""
	i '$IsObject(obj) d
	.s ret="desc|"_desc_"^statusDesc|未处理"
	.do OutputCheckQuesSubData
	e  d
	.s subid="" f  s subid=$o(^DHCNMG.CHK.MgCheckQuesSubD(id,subid)) q:subid=""  d
	..s subObj=##class(DHCNMG.CHK.MgCheckQuesSub).%OpenId(id_"||"_subid)
	..s hander=subObj.QuesSubHander
	..s handerName=""
	..i hander=0 d
	...s handerName="demo"
	..e  d
	...s nurObj=##class(DHCNMG.HR.MgPersons).%OpenId(hander)
	...s:$IsObject(nurObj) handerName=nurObj.PerName
	..s auditorName=""
	..s auditor=subObj.QuesSubAuditor
	..i auditor=0 d
	...s auditorName="demo"
	..e  d
	...s auditorObj=##class(DHCNMG.HR.MgPersons).%OpenId(auditor)
	...s:$IsObject(auditorObj) auditorName=auditorObj.PerName
	..s rea=subObj.QuesSubRea
	..s nurRea=subObj.QuesSubNurRea
	..s patRea=subObj.QuesSubPatRea
	..s deviceRea=subObj.QuesSubDeviceRea
	..s workRea=subObj.QuesSubWorkRea
	..s goodsRea=subObj.QuesSubGoodsRea
	..b ;110
	..s rea=rea_$case($g(nurRea),1:(";"_$g(nurRea)),:"")_$case($g(patRea),1:(";"_$g(patRea)),:"")_$case($g(deviceRea),1:(";"_$g(deviceRea)),:"")_$case($g(workRea),1:(";"_$g(workRea)),:"")_$case($g(goodsRea),1:(";"_$g(goodsRea)),:"")
	..s steps=subObj.QuesSubSteps
	..s goal=subObj.QuesSubGoal
	..s assess=subObj.QuesSubAssess
	..s subView=subObj.QuesSubView
	..s status=subObj.QuesStatus
	..s handDate=subObj.QuesSubHandDate
	..i handDate'="" s handDate=$zd(handDate,3)
	..s audDate=subObj.QuesSubAudDate
	..i audDate'="" s audDate=$zd(audDate,3)
	..s retStatusDesc=$case(status,"N":"待处理","N":"待处理","S":"已处理","A":"已解决","Q":"问题上诉","B":"驳回","I":"忽略",:"")
	..s ret="hander|"_handerName_"^auditor|"_auditorName_"^statusDesc|"_retStatusDesc_"^desc|"_desc_"^rea|"_rea_"^nurRea|"_nurRea_"^patRea|"_patRea_"^deviceRea|"_deviceRea_"^workRea|"_workRea_"^goodsRea|"_goodsRea_"^steps|"_steps_"^goal|"_goal_"^assess|"_assess_"^subView|"_subView
	..s ret=ret_"^handDate|"_handDate_"^audDate|"_audDate
	..do OutputCheckQuesSubData
	i status="B" d
	.s ret="desc|"_desc_"^statusDesc|未处理"
	.do OutputCheckQuesSubData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheckQuesSubData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQuesBackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQuesBackExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQuesBackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQuesBackExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:lulin
/// Description:获取质控问题最后一条分析
/// Date:2019-02-25
/// Table:DHCNMG.CHK.MgCheckRommSub/DHCNMG.CHK.MgCheckQues
/// Input:ques id
/// Output：
/// Return:
/// Other:
ClassMethod getCheckQuesSubItem(id As %String = "") As %String
{
	s ret="rea|^nurRea|^patRea|^deviceRea|^workRea|^goodsRea|^steps|^goal|^assess|^subView|"	
	q:id="" ret
	s subid=$O(^DHCNMG.CHK.MgCheckQuesSubD(id,""),-1)
	q:subid="" ret
	s subObj=##class(DHCNMG.CHK.MgCheckQuesSub).%OpenId(id_"||"_subid)
	q:'$IsObject(subObj) ret
	s rea=subObj.QuesSubRea
	s nurRea=subObj.QuesSubNurRea
	s patRea=subObj.QuesSubPatRea
	s deviceRea=subObj.QuesSubDeviceRea
	s workRea=subObj.QuesSubWorkRea
	s goodsRea=subObj.QuesSubGoodsRea
	s steps=subObj.QuesSubSteps
	s goal=subObj.QuesSubGoal
	s assess=subObj.QuesSubAssess
	s subView=subObj.QuesSubView
	s ret="rea|"_rea
	_"^nurRea|"_nurRea
	_"^patRea|"_patRea
	_"^deviceRea|"_deviceRea
	_"^workRea|"_workRea
	_"^goodsRea|"_goodsRea
	_"^steps|"_steps
	_"^goal|"_goal
	_"^assess|"_assess
	_"^subView|"_subView
	q ret
}

ClassMethod GetQuestions(RowID As %String, Type As %String) As %String
{
	q "sssss"
}

/// Creator:gzj
/// Date:2019-05-10
/// Description:删除质控发布任务记录
/// 
ClassMethod DeleteTask(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(id)
	q:'$IsObject(obj)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator:王鹏飞
/// Description:置重点关注状态
/// Date:2019-08-20
/// Table:DHCNMG.CHK.MgCheckRomm
/// Input:记录ID 是否重点关注 质控类型 角色ID 用户ID
/// Output：
/// Return:0 成功 1 失败
/// Others: w ##class(web.NurMgQualCheckComm).SetRecFocus("1^true^N","0","0")
ClassMethod SetRecFocus(parr As %String = "", role As %String, nurseid As %String) As %String
{
	s roleFlag=..TestRoleAboveNurhead(role)
	s id=$p(parr,"^")
	q:id="" 1
	s ifFocus=$p(parr,"^",2)
	q:((ifFocus'="true")&&(ifFocus'="false")) 1
	s checkType=$p(parr,"^",3)
	q:checkType="" 1
	if checkType="N" {
		s obj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(id)
		q:'$IsObject(obj) 1
		s IsWardFlag=..CheckWardFlag(role,nurseid,obj.TaskWard)
		
	}else {
		s obj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(id)
		q:'$IsObject(obj) 1
		s IsWardFlag=..CheckWardFlag(role,nurseid,obj.ScoreWard)
	}
	q:((IsWardFlag=0)&&(roleFlag=0)) 1
	i ifFocus="true" s obj.IfFocus=1
	e  s obj.IfFocus=0
	s sc=obj.%Save()
	i $$$ISERR(sc) q 1
	q 0
}

/// Creator:王鹏飞
/// CreateDate:2019-08-21
/// Description:判断角色是否为护理部 管理员 超级管理员 护理部主任 科护士长 护士长
/// Table:
/// Input:
/// Output:
/// Return:1 是 0 否
ClassMethod TestRoleAboveNurhead(role As %String) As %String
{
	i role=0 q "1"
	s len=$l(role,"^")
	s flag=0
	f i=1:1:len
	{
		s itm=$p(role,"^",i)
		i itm="" continue
		s obj=##class(DHCNMG.Set.MgRoles).%OpenId(itm)
		i '$IsObject(obj) continue
		s desc=obj.RoleDesc
		i ((desc="admin")!(desc="manager")!(desc="hlbzr")!(desc="hlb")!(desc="znurhead")!(desc="nurhead")) s flag=1
	}
	q flag
}

/// Creator:wangpf
/// CreateDate:2019-09-29
/// Description:获取质控项目菜单最大层级数
/// Table:DHCNMG.DB.MgQualItem DHCNMG.DB.MgQualItemSub
/// Input:id
/// Return:成功:最大层级数 失败:-1
/// Other:w ##class(web.NurMgQualCheckComm).GetQualItemLevel("19")
ClassMethod GetQualItemLevel(id As %String) As %String
{
	q:id="" -1
	s qualItemObj=##class(DHCNMG.DB.MgQualItem).%OpenId(id)
	q:'$IsObject(qualItemObj) -1
	s level=0,key="" 
	d {
		s qualItemSubObj = qualItemObj.ChildSub.GetNext(.key)
		i $Isobject(qualItemSubObj) d
		.s:($l(qualItemSubObj.SubSort,".")-1>level) level=$l(qualItemSubObj.SubSort,".")-1
		.d qualItemObj.ChildSub.%UnSwizzleAt(key)
	} while (key'="")
	q level
}

/// Creator:wangpf
/// CreateDate:2019-09-29
/// Description:获取扣分统计
/// Table:
/// Input:
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.NurMgQualCheckComm","FindQualStatistics","Ward|^QualItem|19^Level|3")
Query FindQualStatistics(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindQualStatisticsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ret=""
	k tmp
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:$g(tmp("QualItem"))=""
	q:$g(tmp("Level"))=""
	
	//夜查房
	i ($g(tmp("CheckType"))="")||(((tmp("CheckType"))'="")&&($zcvt(tmp("CheckType"),"U")=$zcvt("nightcheck","U")))
	{
		s nightRset=""
		s taskData="" f  s taskData=$o(^DHCNMG.CHK.MgNurNightCheckI("date",taskData)) q:taskData=""  d
		.q:(($g(tmp("StData"))'="")&&(taskData<$zdh(tmp("StData"),3)))||(($g(tmp("EndData"))'="")&&(taskData>$zdh(tmp("EndData"),3)))
		.s taskId="" f  s taskId=$o(^DHCNMG.CHK.MgNurNightCheckI("date",taskData,taskId)) q:taskId=""  d
		..s nightCheckId="" f  s nightCheckId=$o(^DHCNMG.CHK.MgNurNightCheckI("date",taskData,taskId,nightCheckId)) q:nightCheckId=""  d
		...s nightCheckObj=##class(DHCNMG.CHK.MgNurNightCheck).%OpenId(nightCheckId)
		...q:'$IsObject(nightCheckObj)
		...q:($g(tmp("Ward"))'="")&&(nightCheckObj.TaskWard'=tmp("Ward"))
		...s key="" f  s nightCheckSubObj=nightCheckObj.ChildSub.GetNext(.key) q:(key="")||('$IsObject(nightCheckSubObj))||($p(nightCheckSubObj.TaskQual,"||")'=tmp("QualItem"))  d
		....q:(nightCheckSubObj.TaskResult>=nightCheckSubObj.TaskValue)
		....s subObjSort=nightCheckSubObj.TaskSort,len=tmp("Level")+1
		....i len=$l(subObjSort,".") d
		.....i $g(nightRset(subObjSort))="" s nightRset(subObjSort)=subObjSort_"^"_nightCheckSubObj.TaskItems_"^"_"1"
		.....e  s nightRset(subObjSort)=subObjSort_"^"_nightCheckSubObj.TaskItems_"^"_($p(nightRset(subObjSort),"^",3)+1)
		....e  i len<$l(subObjSort,".") d
		.....i $g(nightRset($e(subObjSort,0,len*2-1)))="" d
		......s targetSubId=$o(^DHCNMG.CHK.MgNurNightCheckSubI("Sort",nightCheckId," "_$e(subObjSort,0,len*2-1),""))
		......s targetSubObj=##class(DHCNMG.CHK.MgNurNightCheckSub).%OpenId(nightCheckId_"||"_targetSubId)
		......i '$IsObject(targetSubObj) s nightRset($e(subObjSort,0,len*2-1))=$e(subObjSort,0,len*2-1)_"^"_"^"_"1"
		......e  s nightRset($e(subObjSort,0,len*2-1))=$e(subObjSort,0,len*2-1)_"^"_targetSubObj.TaskItems_"^"_"1"
		.....e  s nightRset($e(subObjSort,0,len*2-1))=$e(subObjSort,0,len*2-1)_"^"_$p(nightRset($e(subObjSort,0,len*2-1)),"^",2)_"^"_($p(nightRset($e(subObjSort,0,len*2-1)),"^",3)+1)
	}
	//其他类型
	i ($g(tmp("CheckType"))="")||((tmp("CheckType")'="")&&($zcvt(tmp("CheckType"),"U")'=$zcvt("nightcheck","U")))
	{
		s qualRset=""
		s qualItemId="" f  s qualItemId=$o(^DHCNMG.CHK.MgCheckRoomI("stic",qualItemId)) q:qualItemId=""  d
		.q:$tr(qualItemId," ","")'=tmp("QualItem")
		.s wardId="" f  s wardId=$o(^DHCNMG.CHK.MgCheckRoomI("stic",qualItemId,wardId)) q:wardId=""  d
		..q:($g(tmp("Ward"))'="")&&(tmp("Ward")'=$tr(wardId," ",""))
		..s checkRoomId="" f  s checkRoomId=$o(^DHCNMG.CHK.MgCheckRoomI("stic",qualItemId,wardId,checkRoomId)) q:checkRoomId=""  d
		...s checkRoomObj=##class(DHCNMG.CHK.MgCheckRoom).%OpenId(checkRoomId)
		...q:'$IsObject(checkRoomObj)
		...q:checkRoomObj.Status'="S"
		...s taskObj=##class(DHCNMG.CHK.MgNurTaskRelease).%OpenId(checkRoomObj.TaskID)
		...q:'$IsObject(taskObj)
		...q:(($g(tmp("StData"))'="")&&($zdh(tmp("StData"),3)>taskObj.CreateDate))||(($g(tmp("EndData"))'="")&&($zdh(tmp("EndData"),3)<taskObj.CreateDate))
		...s key="" f  s checkRoomSubObj=checkRoomObj.ChildSub.GetNext(.key) q:(key="")  d
		....q:'$IsObject(checkRoomSubObj)
		....q:(checkRoomSubObj.CheckItemScore'="")&&(checkRoomSubObj.StandardScore'="")&&(checkRoomSubObj.CheckItemScore>=checkRoomSubObj.StandardScore)
		....s subObjSort=checkRoomSubObj.CheckSort,len=tmp("Level")+1
		....i len=$l(subObjSort,".") d
		.....i $g(qualRset(subObjSort))="" d
		......i (checkRoomSubObj.CheckItemScore'="")&&(checkRoomSubObj.StandardScore'="")&&(checkRoomSubObj.CheckItemScore<checkRoomSubObj.StandardScore) s qualRset(subObjSort)=subObjSort_"^"_checkRoomSubObj.CheckItem_"^"_"1"
		......e  s qualRset(subObjSort)=subObjSort_"^"_checkRoomSubObj.CheckItem_"^"_"0"
		.....e  i (checkRoomSubObj.CheckItemScore'="")&&(checkRoomSubObj.StandardScore'="")&&(checkRoomSubObj.CheckItemScore<checkRoomSubObj.StandardScore) s qualRset(subObjSort)=subObjSort_"^"_checkRoomSubObj.CheckItem_"^"_($p(qualRset(subObjSort),"^",3)+1)
		....e  i len<$l(subObjSort,".") d
		.....i $g(qualRset($e(subObjSort,0,len*2-1)))="" d
		......i (checkRoomSubObj.CheckItemScore'="")&&(checkRoomSubObj.StandardScore'="")&&(checkRoomSubObj.CheckItemScore<checkRoomSubObj.StandardScore) s qualRset($e(subObjSort,0,len*2-1))=$e(subObjSort,0,len*2-1)_"^"_"^"_"1"
		......e  s qualRset($e(subObjSort,0,len*2-1))=$e(subObjSort,0,len*2-1)_"^"_"^"_"0"
		.....e  i (checkRoomSubObj.CheckItemScore'="")&&(checkRoomSubObj.StandardScore'="")&&(checkRoomSubObj.CheckItemScore<checkRoomSubObj.StandardScore) s qualRset($e(subObjSort,0,len*2-1))=$e(subObjSort,0,len*2-1)_"^"_$p(qualRset($e(subObjSort,0,len*2-1)),"^",2)_"^"_($p(qualRset($e(subObjSort,0,len*2-1)),"^",3)+1)
	}
	//若没选择质控类型,则合并重复项(一个项目可为质控、夜查房、特殊科室检查等多种类型)
	i $g(tmp("CheckType"))=""
	{
		k finalRset
		s i="" f  s i=$o(nightRset(i)) q:i=""  d
		.q:$p(nightRset(i),"^",3)<1
		.i $g(qualRset(i))'="" s finalRset(i)=$p(nightRset(i),"^")_"^"_$p(nightRset(i),"^",2)_"^"_($p(nightRset(i),"^",3)+$p(qualRset(i),"^",3))
		.e  s finalRset(i)=$p(nightRset(i),"^")_"^"_$p(nightRset(i),"^",2)_"^"_$p(nightRset(i),"^",3)
		
		s i="" f  s i=$o(qualRset(i)) q:i=""  d
		.q:$p(qualRset(i),"^",3)<1
		.q:$g(finalRset(i))'=""
		.s finalRset(i)=$p(qualRset(i),"^")_"^"_$p(qualRset(i),"^",2)_"^"_$p(qualRset(i),"^",3)

		s i="" f  s i=$o(finalRset(i)) q:i=""  d
		.q:$p(finalRset(i),"^",3)<1
		.s tmpSort=$e($p(finalRset(i),"^"),1,1)_$e($p(finalRset(i),"^"),4,*)
		.s ret="Sort|"_tmpSort_"^Desc|"_$p(finalRset(i),"^",2)_"^Count|"_$p(finalRset(i),"^",3)
		.d OutQualData
	}
	elseif  $zcvt(tmp("CheckType"),"U")=$zcvt("nightcheck","U")
	{
		s i="" f  s i=$o(nightRset(i)) q:i=""  d
		.q:$p(nightRset(i),"^",3)<1
		.s tmpSort=$e($p(nightRset(i),"^"),1,1)_$e($p(nightRset(i),"^"),4,*)
		.s ret="Sort|"_tmpSort_"^Desc|"_$p(nightRset(i),"^",2)_"^Count|"_$p(nightRset(i),"^",3)
		.d OutQualData
	}
	elseif $zcvt(tmp("CheckType"),"U")'=$zcvt("nightcheck","U")
	{
		s i="" f  s i=$o(qualRset(i)) q:i=""  d
		.q:$p(qualRset(i),"^",3)<1
		.s tmpSort=$e($p(qualRset(i),"^"),1,1)_$e($p(qualRset(i),"^"),4,*)
		.s ret="Sort|"_tmpSort_"^Desc|"_$p(qualRset(i),"^",2)_"^Count|"_$p(qualRset(i),"^",3)
		.d OutQualData
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutQualData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualStatisticsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2019-11-27
/// Description:根据人员登录ID获取检查级别
/// Table:
/// Input:
/// Output:
/// Other:
/// Return:
ClassMethod GetCheckLevel(roles As %String, id As %String) As %String
{
	i roles=0
	{
		s ret="[{""rw"":""W"",""desc"":""病区""},{""rw"":""L"",""desc"":""科室""},{""rw"":""H"",""desc"":""护理部""}]"
	}else{
		s flag=0
		f i=1:1:$l(roles,"^")
		{
			s role=$p(roles,"^",i)
			i role="" continue
			s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
			i '$IsObject(roleObj) continue
			s roleCode=roleObj.RoleCode
			i ((roleCode="nurhead")&&((flag=0)||(flag=3))) s flag=3
			i ((roleCode="znurhead")&&(flag>2)) s flag=2
			;i roleCode="hlb" s flag=1
			i roleCode="hlb" s flag=1
			e  i roleCode="znurhead" s flag=2
			e  i roleCode="nurhead" s flag=3
		}
		i flag=1
		{
			s ret="[{""rw"":""W"",""desc"":""病区""},{""rw"":""L"",""desc"":""科室""},{""rw"":""H"",""desc"":""护理部""}]"
		}elseif flag=2
		{
			s ret="[{""rw"":""W"",""desc"":""病区""},{""rw"":""L"",""desc"":""科室""}]"
		}elseif flag=3
		{
			s ret="[{""rw"":""W"",""desc"":""病区""}]"
		}else{
			s ret="[]"	
		}
	}
	q ret
}

}
