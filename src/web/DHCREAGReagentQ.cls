Class web.DHCREAGReagentQ Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

ClassMethod QryReagentByGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReagentByGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReagentByGroupExecute(ByRef qHandle As %Binary, depart As %String, group As %String) As %Status
{
	s depart=$g(depart),group=$g(group)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	i $l(group) d
	.s id="" f  s id=$o(^lab.DHCCTReagentI("GroupTypeDRIndex",group,id)) q:id=""  d
	..s seq=$li(^lab.DHCCTReagentD(id),18)
	..s ^TMP($zn,$j,"seq",seq,id)=""
	..w !,"id1:",id
	e  d
	.s seq="" f  s seq=$o(^lab.DHCCTReagentI("SequenceIndex",seq)) q:seq=""  d
	..s id="" f  s id=$o(^lab.DHCCTReagentI("SequenceIndex",seq,id)) q:id=""  d
	...s ^TMP($zn,$j,"seq",seq,id)=""
	...w !,"id2:",id
	//
	s num1=1,num2=1
	s seq="" f  s seq=$o(^TMP($zn,$j,"seq",seq)) q:seq=""  d
	.s id="" f  s id=$o(^TMP($zn,$j,"seq",seq,id)) q:id=""  d
	..s ReagCode=$li(^lab.DHCCTReagentD(id),2)
	..//^lab.DHCREAGStockI("MasterIndex","D03",203,171)=
	..s stocks=0
	..s StkId=$o(^lab.DHCREAGStockI("MasterIndex",depart,ReagCode,""))
	..i $l(StkId) s stocks=+$li(^lab.DHCREAGStockD(StkId),4)
	..i stocks>0 d
	...s ^TMP($zn,$j,"SOTCKS","1",num1,id)=stocks_$c(2)_StkId
	...s num1=num1+1
	..i stocks=0 d
	...s ^TMP($zn,$j,"SOTCKS","2",num2,id)=stocks_$c(2)_StkId
	...s num2=num2+1
	//
	s type="" f  s type=$o(^TMP($zn,$j,"SOTCKS",type)) q:type=""  d
	.s num="" f  s num=$o(^TMP($zn,$j,"SOTCKS",type,num)) q:num=""  d
	..s ReagDr="" f  s ReagDr=$o(^TMP($zn,$j,"SOTCKS",type,num,ReagDr)) q:ReagDr=""  d
	...s str=^(ReagDr)
	...s stkSum=$p(str,$c(2),1)
	...s StkId=$p(str,$c(2),2)
	...s uSyn=$li(^lab.DHCCTReagentD(ReagDr),20)
	...s ReagName=uSyn_" "_$li(^lab.DHCCTReagentD(ReagDr),3)
	...//基本信息单位规格厂商
	...s ReagStr=""
	...s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(ReagDr)
	...i '$l(ReagStr) q
	...//s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	...s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	...s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	...s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	...s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	...s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	...s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	...s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	...s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	...s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	...s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	...s InPrice=$p(ReagStr,$c(2),7) //$li(ReagStr,8)
	...s OutPrice=+$p(ReagStr,$c(2),8) //$li(ReagStr,9
	...s PackageVol=$p(ReagStr,$c(2),27) //包装容量
	...s VolUnit=$p(ReagStr,$c(2),28) //消耗单位
	...s StockSum=$fn(stkSum/PackageVol,"",2)
	...d OutputReag
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
	set Data=$lb(StkId,ReagDr,ReagName,StockSum,PackageName,UnitName,ManuName,Group,InPrice,OutPrice,PackageVol,VolUnit) //,PackageDr,UnitDr,ManuDr,uSyn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryReagentByGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReagentByGroupExecute ]
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

/// Creator：      huhm
/// CreatDate：    20100506
/// Description:： 通过组别查询库存试剂
/// Table：        
/// Input：        科室
/// Output：       无
/// Return：       
/// Others：  //,PackageDr:%String,UnitDr:%String,ManuDr:%String,syn:%String") 
Query QryReagentByGroup(depart As %String, group As %String) As %Query(ROWSPEC = "StkId:%String,ReagDr:%String,ReagName:%String,Quantity:%String,PackageName:%String,UnitName:%String,ManuName:%String,group:%String,InPrice:%String,OutPrice:%String,PackageVol:%String,VolUnit:%String")
{
}

}
