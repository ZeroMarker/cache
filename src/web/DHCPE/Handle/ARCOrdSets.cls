/// Created by SongDeBo 2006/6/8
/// Description: 有关表ARC_OrdSets的一些基本处理
Class web.DHCPE.Handle.ARCOrdSets Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Property ARCOSItemIds As %String(TRUNCATE = 1);

/// Description:获取医嘱套餐的子项 
/// 			根据套单ID取所有的项目ID,各ID用"^"分开
/// test: w ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet(11)
/// return: itemIds, separated by "^", eg "99||1^28||1^108||1"
/// s myObj=##Class(web.DHCPE.Handle.ARCOrdSets).%New()
/// w 
/// ReWrite by MLH
/// ##class(web.DHCPE.Handle.ARCOrdSets).GetItemIdsBySet("77^")
ClassMethod GetItemIdsBySet(ARCOSRowId)
{

 Quit:'ARCOSRowId ""
 s itemIds=""
 s id="" ,ParID=""                       //add by zl 20100510
 k ^DHCPETMPOrdSets("ARCOSRowId")
 s SCOrdSetsID=$P(ARCOSRowId,"^",2)
 s ARCOSRowId=$P(ARCOSRowId,"^",1)
 i SCOrdSetsID="" d
 .d ..GetAllOrdSetItem(ARCOSRowId,.itemIds)
 .d ..GetAllOrdSetItemPrint(ARCOSRowId,.id,ParID)  //add by zl 20100510
 e  d
  .s itemIds=##class(web.DHCPE.APSCItem).GetItemsBySCOrdSets(SCOrdSetsID)
 Quit itemIds
}

ClassMethod GetOrdSetItem(ARCOSRowId, drow, test)
{
	s itemIds=""
	s today=+$h
	s dateChildId="0"
	f  s dateChildId=$o(^ARCOS(ARCOSRowId,"DATE",dateChildId))  q:dateChildId=""  d
	.set strData=^ARCOS(ARCOSRowId,"DATE",dateChildId)
	.s from=$p(strData,"^",1)
	.i from="" s from=today-1
	.q:(from>today)
	.s to=$p(strData,"^",2)
	.i to="" s to=today+1
	.q:(to<today)
	.s itemChildId="0"
	.f  s itemChildId=$o(^ARCOS(ARCOSRowId,"DATE",dateChildId,"ITM",itemChildId))  q:itemChildId=""  d
	..s num=1
	..s strDataItm=^ARCOS(ARCOSRowId,"DATE",dateChildId,"ITM",itemChildId)
	..//w !,strDataItm,!
	..s num=$p(strDataItm,"^",2)
	..i $g(num)="" s num=1
	..f k=1:1:num d
	...i itemIds'="" s itemIds=itemIds_"^"_$p(strDataItm,"^",1)
	...e  s itemIds=$p(strDataItm,"^",1)
	s test=itemIds
	q // itemIds
}

/// w ##class(web.DHCPE.Handle.ARCOrdSets).GetOrderSetDate(905)
ClassMethod GetOrderSetDate(ARCOSRowId)
{
	s DATE=+$h
	///0926  renzwang
	s Returndrow=0
	s drow=0
	f  s drow=$o(^ARCOS(ARCOSRowId,"DATE",drow)) q:drow=""  d
	.s dto=$p($g(^ARCOS(ARCOSRowId,"DATE",drow)),"^",2)
	.i dto="" s dto=DATE+1
	.q:dto<DATE
	.s Returndrow=drow
	q Returndrow
	
	s dfrom=$o(^ARCOS(ARCOSRowId,"DATE",0,"DateFrom",.1+DATE),-1) //s dfrom=0
	s drow=$o(^ARCOS(ARCOSRowId,"DATE",0,"DateFrom",dfrom,"")) //s drow=0
	s dto=$p($g(^ARCOS(ARCOSRowId,"DATE",drow)),"^",2) //i dto,dto<DATE //q 0
	q drow
}

/// d ##class(web.DHCPE.Handle.ARCOrdSets).GetAllOrdSetItem(905,"")
/// [Previously private]
ClassMethod GetAllOrdSetItem(ARCOSRowId, itemIds)
{
	s drow=..GetOrderSetDate(ARCOSRowId)
	d ..GetOrdSetItem(ARCOSRowId,drow,.test)
	i itemIds'="" s itemIds=$g(itemIds)_"^"_test
	e  s itemIds=test
	//s ^lisatest("0814","GetAllOrdSetItem")
	//i ..ARCOSItemIds'="" s ..ARCOSItemIds=$g(..ARCOSItemIds)_"^"_test
	//e  s ..ARCOSItemIds=test
	s it1=1
	s it=0 f  s it=$o(^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)) q:it=""  d
	.s s=^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)
	.d ..GetAllOrdSetItem(+s,.itemIds)
}

// **************************************************************************

// ADMFeeType为医嘱套对应的体检费别

/// 计算项目套餐的价格
/// OrdSetId == ARC_OrdSets.ARCOS_RowId
/// test: w ##class(web.DHCPE.Handle.ARCOrdSets).GetPrice("6","","","8")
ClassMethod GetPrice(OrdSetId, SetDate = "", AdmId = "", ADMFeeType = "", Type As %String = "", LocID As %String = "", hospId As %String = "")
{
	s price=""
	i SetDate="" s SetDate=+$h
	s childId="0"
	s OType=$p(OrdSetId,"&",2)
	s OrdSetId=$p(OrdSetId,"&",1)
	// ARC_OrdSetPrice 
	f  s childId=$o(^ARCOS(OrdSetId,"PRICE",childId))  q:childId=""  d
	.  s strData=^ARCOS(OrdSetId,"PRICE",childId)
	.  s myDateStart=$p(strData,"^",1) // PRICE_DateFrom
	.  q:(myDateStart>SetDate)
	.  s price=($p(strData,"^",4)) // PRICE_Price
	if price="" s price=##class(web.DHCPE.Cashier).GetARCSetPrice(OrdSetId_"&"_OType,AdmId,ADMFeeType,Type,LocID,hospId)
	q price
}

// d ##class(web.DHCPE.Handle.ARCOrdSets).GetAllOrdSetItemPrint("987","^DHCPETMPOrdSets(")

/*
ClassMethod GetAllOrdSetItemPrint(ARCOSRowId, GlolbName) [ Private ]
{
	
	 
	s drow=..GetOrderSetDate(ARCOSRowId)
	s test=""
	d ..GetOrdSetItem(ARCOSRowId,drow,.test)
	s test="^"_test_"^"
	s GlolbName=GlolbName_ARCOSRowId
 	s text=GlolbName_","_"""Item"""_")="_""""_test_"""",@text
	s it=0 f  s it=$o(^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)) q:it=""  d
	.s s=^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)
	.d ..GetAllOrdSetItemPrint(+s,GlolbName_",")
}
*/
/// [Previously private]
ClassMethod GetAllOrdSetItemPrint(ARCOSRowId, itemIds, ARCOSRowIdStr)
{
 s Flag=0
 s drow=..GetOrderSetDate(ARCOSRowId)
 s test=""
 i ARCOSRowIdStr=""  s ARCOSRowIdStr=ARCOSRowId
 else  s ARCOSRowIdStr=ARCOSRowIdStr_"^"_ARCOSRowId
 s ^DHCPETMPOrdSets("ARCOSRowId")=ARCOSRowIdStr
 i $g(^DHCPEDataEx("OrdSetsEx",ARCOSRowId))="Y" d
 .d ..GetAllOrdSetItem(ARCOSRowId,.test)
 .i itemIds'="" s itemIds=$g(itemIds)_"^"_test
 .e  s itemIds=test
 .s Flag=1
 s ParARCOSID=$p($g(^DHCPETMPOrdSets("ARCOSRowId")),"^",1)
 if Flag=1{
 s ItemLength=$l(test,"^") 
	  for i=1:1:ItemLength
	  { 
	    s ItemID=$P(test,"^",i) 
	    s ^DHCPETMPOrdSets(ParARCOSID,ItemID,ARCOSRowId)=1}}
 q:Flag=1
 s it=0
 f  s it=$o(^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)) q:it=""  d
 .s s=^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)
 .d ..GetAllOrdSetItemPrint(+s,.itemIds,.ARCOSRowIdStr)
}

// d ##class(web.DHCPE.Handle.ARCOrdSets).Test("987","^DHCPETMPOrdSets(")

/// [Previously private]
ClassMethod Test(ARCOSRowId, GlolbName)
{
	s drow=..GetOrderSetDate(ARCOSRowId)
	s Flag=0
	s GlolbName=GlolbName_ARCOSRowId
	s Ids=""
	i $g(^DHCPEDataEx("OrdSetsEx",ARCOSRowId))="Y" d
	.d ..GetAllOrdSetItem(ARCOSRowId,.Ids)
	.s Items="^"_Ids_"^"
	.s text=GlolbName_")="_""""_Items_"""",@text
	.s Flag=1
	q:Flag=1
	s it=0 
	f  s it=$o(^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)) q:it=""  d
	.s s=^ARCOS(ARCOSRowId,"DATE",drow,"OS",it)
	.d ..Test(+s,GlolbName_",")
}

}
