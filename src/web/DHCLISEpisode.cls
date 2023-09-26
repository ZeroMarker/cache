/// 名称:     web.DHCLISEpisode
/// 描述:     检验号处理
/// 编写者：  huhm
/// 编写日期: 20120528
Class web.DHCLISEpisode Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      huhm
/// CreatDate：    20120528
/// Description:： 根据医嘱ID生成检验号
/// Table：        OE_Order,OE_OrdItem,OE_OrdSpecimen
/// Input：        医嘱ID,前缀(只能为字母或数字)
/// Output：       医嘱ID,是否成功生成(0成功,1失败),检验号或失败原因
/// Return：        
/// Others：        
Query GenerateEpisode(OrdItemList As %String, Pref As %String) As %Query(ROWSPEC = "OrdItemId:%String,Flag:%String,EpisodeNo:%String")
{
}

ClassMethod GenerateEpisodeExecute(ByRef qHandle As %Binary, OrdItemList As %String, Pref As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set OrdItemList=$Get(OrdItemList),Pref=$Get(Pref)
	If '$l(OrdItemList) Quit 0
	i '(Pref?1.99AN) s Pref=""  //前缀只能为字母或数字
	k ^TMP($zn,$j)
	/*
	s OrdItemList=""
	s subid="" f  s subid=$o(^OEORD(76373,"I",subid)) q:subid=""  d
	.s OrdItemList=OrdItemList_"76373||"_subid_"^"
	*/
	f i=1:1:$l(OrdItemList,"^") d
	.s OrdItemId=$p(OrdItemList,"^",i)
	.i '$l(OrdItemId) q
	.s OrdId=$p(OrdItemId,"||",1) q:'$l(OrdId)
	.s OrdSub=$p(OrdItemId,"||",2) q:'$l(OrdSub)
	.s ArcimId=$P($g(^OEORD(OrdId,"I",OrdSub,1)),"^",2)
	.i '$l(ArcimId) s ^TMP($zn,$j,"EPIS",OrdItemId)="1^医嘱项目为空" q
	.s LabType=..IsLabItem(ArcimId)
	.i LabType="0" s ^TMP($zn,$j,"EPIS",OrdItemId)="1^不是检验类型医嘱" q  //不是检验类型医嘱
	.s TestSet=..GetTSCode(ArcimId)
	.i '$l(TestSet) s ^TMP($zn,$j,"EPIS",OrdItemId)="1^无外部码" q //无外部码
	.s SpecStr=..GetSpecimen(OrdItemId)
	.s SpecCode=$p(SpecStr,"^",1)
	.s ConCode=$p(SpecStr,"^",2)
	.i '$l(SpecCode) s ^TMP($zn,$j,"EPIS",OrdItemId)="1^无标本类型" q  //无标本类型
	.i '$l(ConCode) s ConCode=$o(^TTAB("TS",TestSet,1,SpecCode,""))
	.//单独生成检验号
	.s RetVal=..GetLabItemSingleFlag(ArcimId) 
	.i RetVal="0" s ^TMP($zn,$j,3,OrdItemId)="" q
	.//相同医嘱,单独生成检验号
	.i $d(^TMP($zn,$j,"ARCIM",ArcimId)) s ^TMP($zn,$j,3,OrdItemId)="" q
	.s ^TMP($zn,$j,"ARCIM",ArcimId)=""
	.//接收科室
	.s DepCode=$e(TestSet)  
	.//w !,DepCode,",",SpecCode,",",ConCode
	.i $l(ConCode) s ^TMP($zn,$j,1,DepCode,SpecCode,ConCode,OrdItemId)="" q
	.s ^TMP($zn,$j,2,DepCode,SpecCode,OrdItemId)=""
	//
	s dep="" f  s dep=$o(^TMP($zn,$j,1,dep)) q:dep=""  d
	.s spec="" f  s spec=$o(^TMP($zn,$j,1,dep,spec)) q:spec=""  d
	..s con="" f  s con=$o(^TMP($zn,$j,1,dep,spec,con)) q:con=""  d
	...s epis=..NewEpisode(Pref)
	...s flag=0
	...i '$l(epis) s flag=1
	...s OrdId="" f  s OrdId=$o(^TMP($zn,$j,1,dep,spec,con,OrdId)) q:OrdId=""  d
	....s ^TMP($zn,$j,"EPIS",OrdId)=flag_"^"_epis
	s dep="" f  s dep=$o(^TMP($zn,$j,2,dep)) q:dep=""  d
	.s spec="" f  s spec=$o(^TMP($zn,$j,2,dep,spec)) q:spec=""  d
	..s epis=..NewEpisode(Pref)
	..s flag=0
	..i '$l(epis) s flag=1
	..s OrdId="" f  s OrdId=$o(^TMP($zn,$j,2,dep,spec,OrdId)) q:OrdId=""  d
	...s ^TMP($zn,$j,"EPIS",OrdId)=flag_"^"_epis
	s id="" f  s id=$o(^TMP($zn,$j,3,id)) q:id=""  d
	.s epis=..NewEpisode(Pref)
	.s flag=0
	.i '$l(epis) s flag=1
	.s ^TMP($zn,$j,"EPIS",id)=flag_"^"_epis
	//
	s OrdId="" f  s OrdId=$o(^TMP($zn,$j,"EPIS",OrdId)) q:OrdId=""  d
	.s flag=$p(^TMP($zn,$j,"EPIS",OrdId),"^",1)
	.s epis=$p(^TMP($zn,$j,"EPIS",OrdId),"^",2)
	.Do OutPut
	k ^TMP($zn,$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPut
	Set Data =$lb(OrdId,flag,epis)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GenerateEpisodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GenerateEpisodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GenerateEpisodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GenerateEpisodeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

//得到医嘱外部码

ClassMethod GetTSCode(ItemId) As %String
{
   s ts=""
   s ord="" f  s ord=$o(^ARCIM($p(ItemId,"||",1),$p(ItemId,"||",2),"EXT",ord)) q:ord=""!$l(ts)  d
   .s ExtCode=$p(^ARCIM($p(ItemId,"||",1),$p(ItemId,"||",2),"EXT",ord),"^",4)
   .s IsDefault=$p(^ARCIM($p(ItemId,"||",1),$p(ItemId,"||",2),"EXT",ord),"^",9)
   .i IsDefault="Y" s ts=ExtCode
   //如果没有设定默认值,取医嘱项的最后一个外部码
   i '$l(ts) s ts=ExtCode
   q ts
}

//判断是否是检验类型医嘱

ClassMethod IsLabItem(ItemId) As %String
{
	s ItemCat=$p(^ARCIM($p(ItemId,"||",1),$p(ItemId,"||",2),1),"^",10)
	i '$l(ItemCat) q "0"
	s Type=$p($g(^ARC("IC",ItemCat)),"^",7)
	i Type'="L" q "0"
	q "1"
}

//得到标本类型和容器

ClassMethod GetSpecimen(OrdItmId) As %String
{
	s SubId=$g(^OEORD($p(OrdItmId,"||",1),"I",$p(OrdItmId,"||",2),"SPEC",0))
	i '$l(SubId) q ""
	s SpecCode=$p($g(^OEORD($p(OrdItmId,"||",1),"I",$p(OrdItmId,"||",2),"SPEC",SubId)),"^",1)
	s ConCode=$p($g(^OEORD($p(OrdItmId,"||",1),"I",$p(OrdItmId,"||",2),"SPEC",SubId)),"^",11)
	q SpecCode_"^"_ConCode
}

ClassMethod GetDefSpecimen(Testsetcode) As %String
{
    //
}

/// Creator：      huhm
/// CreatDate：    20120528
/// Description:： 生成检验号
/// Table：        
/// Input：        前缀
/// Output：       检验号
/// Return：        
/// Others：
ClassMethod NewEpisode(pref) As %String
{
	n (pref)
	s pref=$g(pref)
  //添加新号判断
  s NewNum=0
nx  s NewEpis=""
  i '$l(pref) s NewEpis=$$next("^DHCLABEPIS(""EPIS-CNT"")")
  i $l(pref) s NewEpis=pref_$$next("^DHCLABEPIS(""EPIS-CNT"",pref)")
  //添加新号判断
  s NewNum=NewNum+1
  s bCnt=0
  i $l(NewEpis) d
  .s bCnt=$o(^DHCEPISCNT(NewEpis,""),-1)+1
  .i bCnt>1 q
  .s ^DHCEPISCNT(NewEpis,bCnt)=$zts
  i bCnt>1,NewNum>1000 q ""
  i bCnt>1 g nx
  q NewEpis
next(glo) n a
 l +@glo
 s a=$g(@glo)+1,@glo=a
 l -@glo
 q a
}

/// Creator：      周志强
/// CreatDate：    2009.07.10
/// Description:： 取得检验医嘱项的独立标志,代表此医嘱生成对立的标本号
/// Table：        ARC_ItemExternalCodes
/// Input：        ArcimRowid:医嘱项指针   
/// Return：       0:是  1:否
/// Others：       $$GetLabItemSingleFlag^DHCDocOrderCommon("7484||1)
ClassMethod GetLabItemSingleFlag(ArcimRowid)
{
	n (ArcimRowid)
	s arcsub=$p(ArcimRowid,"||",2)
	q:arcsub="" ""
	s ExCode=""
	s chl=0 f  s chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
	.s tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
	.s fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
	.q:(fromd'="")&(fromd>+$h)
	.q:(tod'="")&(tod<+$h)
	.s ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",9)
	Q:ExCode="Y" 0
	Q 1
}

}
