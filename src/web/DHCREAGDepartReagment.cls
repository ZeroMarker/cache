Class web.DHCREAGDepartReagment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

ClassMethod AddReagment(depart As %String, reag As %String) As %String
{
	i '$d(^lab.DHCCTReagentD(reag)) q 100
	s syn=$li(^lab.DHCCTReagentD(reag),20)
	s seq=$li(^lab.DHCCTReagentD(reag),18)
	s Mix=$li(^lab.DHCCTReagentD(reag),15)
	s Max=$li(^lab.DHCCTReagentD(reag),16)
	s WarnDays=$li(^lab.DHCCTReagentD(reag),22)
	s vis="Y"
	&sql(insert into lab.DHCCTDepartReagment(ParRef,ReagentDR,Synonym,MixQuantity,MaxQuantity,WarnDays,Sequence,Visible) values(:depart,:reag,:syn,:Mix,:Max,:WarnDays,:seq,:vis))
	q SQLCODE
}

ClassMethod DeleteReagment(depart As %String, reag As %String) As %String
{
	&sql(delete from lab.DHCCTDepartReagment where ParRef=:depart and ReagentDR=:reag)
	q SQLCODE
}

ClassMethod GetReagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReagListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReagListExecute(ByRef qHandle As %Binary, depart As %String, group As %String, visible As %String) As %Status
{
	s depart=$g(depart),group=$g(group)
	s ^TMP($zn,"para")=depart_","_group
 	Set repid=$I(^CacheTemp)
 	k ^TMP($zn,$j)
	If $g(ind)="" Set ind=1
	s seq="" f  s seq=$o(^lab.DHCCTReagentI("SequenceIndex",seq)) q:seq=""  d
	.s reag="" f  s reag=$o(^lab.DHCCTReagentI("SequenceIndex",seq,reag)) q:reag=""  d
	..i $d(^lab.DHCCTDepartReagmentI("MasterIndex",depart,reag)) q
	..s (ReagName,PackageName,UnitName,Group,ManuName,InPrice,OutPrice,GroupDr)=""
	..s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(reag)
	..i $l(ReagStr) d
	...s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	...s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	...//s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	...s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	...//s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	...s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	...s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	...//s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	...//s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	...s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	...//s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	...s InPrice=$p(ReagStr,$c(2),7)
	...s OutPrice=$p(ReagStr,$c(2),8)
    ..i $l(group),group'=GroupDr q
    ..i $l(visible),visible="No",uVis'="Y" q
    ..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(reag,ReagName,PackageName,UnitName,Group,InPrice,OutPrice,ManuName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetReagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReagListExecute ]
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
/// CreatDate：    20100421
/// Description:： 试剂科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetReagList(depart As %String, group As %String, visible As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,PackageSize:%String,Unit:%String,GroupType:%String,InPrice:%String,OutPrice:%String,Manufacturer:%String")
{
}

ClassMethod GetLinkReagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLinkReagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLinkReagExecute(ByRef qHandle As %Binary, depart As %String, group As %String, visible As %String) As %Status
{
	s group=$g(group)
	s ^TMP($zn,"para")=group
 	Set repid=$I(^CacheTemp)
 	//^lab.DHCCTDepartmentD("D01","Items",1)=<<$LB("","202","jzdhs","1")>>
	k ^TMP($zn,$j)
	If $g(ind)="" Set ind=1
	s id="" f  s id=$o(^lab.DHCCTDepartmentD(depart,"Items",id)) q:id=""  d
	.s str=^(id)
	.s reag=$li(str,2)
	.i '$l(reag) q
	.s uVis=$li(str,8)
    .i $l(visible),visible="No",uVis'="Y" q
	.s (ReagName,PackageName,UnitName,Group,ManuName,InPrice,OutPrice,GroupDr)=""
	.s (Syn,Mix,Max,WarnDays,BarCode,Remark,Seq)=""
	.s PackVol=1,VolUnit=""
	.s ReagStr=##Class(web.DHCREAGReagent).SelectReagent(reag)
	.i $l(ReagStr) d
	..s ReagName=$p(ReagStr,$c(2),2) //$li(ReagStr,3)
	..s PackageName=$p(ReagStr,$c(2),3) //$li(ReagStr,4)
	..//s PackageDr=$p(ReagStr,$c(2),21) //$li(ReagStr,22)
	..s UnitName=$p(ReagStr,$c(2),4) //$li(ReagStr,5)
	..//s UnitDr=$p(ReagStr,$c(2),22) //$li(ReagStr,23)
	..s Group=$p(ReagStr,$c(2),5) //$li(ReagStr,6)
	..s GroupDr=$p(ReagStr,$c(2),23) //$li(ReagStr,24)
	..//s SuppName=$p(ReagStr,$c(2),12) //$li(ReagStr,13)
	..//s SuppDr=$p(ReagStr,$c(2),24) //$li(ReagStr,25)
	..s ManuName=$p(ReagStr,$c(2),13) //$li(ReagStr,14)
	..//s ManuDr=$p(ReagStr,$c(2),25) //$li(ReagStr,26)
	..s InPrice=$p(ReagStr,$c(2),7)
	..s OutPrice=$p(ReagStr,$c(2),8)
	..s PackVol=+$p(ReagStr,$c(2),27)
	..s VolUnit=$p(ReagStr,$c(2),28)
	..//
	..//s Syn=$p(ReagStr,$c(2),20)
	..//s Mix=$p(ReagStr,$c(2),15)
	..//s Max=$p(ReagStr,$c(2),16)
	..//s WarnDays=$p(ReagStr,$c(2),22)
	..//s BarCode=$p(ReagStr,$c(2),21)
	..//s Remark=$p(ReagStr,$c(2),17)
	..//s Seq=$p(ReagStr,$c(2),18)
    .i PackVol=0 s PackVol=1
    .i $l(group),group'=GroupDr q
    .s Syn=$li(str,3)
    .s Mix=$li(str,4)
    .s Max=$li(str,5)
    .s WarnDays=$li(str,6)
    .s Seq=$li(str,7)
    .i '$l(Seq) s Seq="999"
    .set Data=$lb(reag,ReagName,PackageName,UnitName,Group,InPrice,OutPrice,ManuName,Syn,Mix,Max,WarnDays,Seq,uVis,PackVol,VolUnit)
    .s ^TMP($zn,$j,Seq,reag)=Data
    .//d OutputReag			
	//
	s seq="" f  s seq=$o(^TMP($zn,$j,seq)) q:seq=""  d
	.s reag="" f  s reag=$o(^TMP($zn,$j,seq,reag)) q:reag=""  d
	..s Data=^(reag)
	..d OutputReag
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputReag
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLinkReagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLinkReagExecute ]
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
/// CreatDate：    20100421
/// Description:： 试剂科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetLinkReag(depart As %String, group As %String, visible As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,PackageSize:%String,Unit:%String,GroupType:%String,InPrice:%String,OutPrice:%String,Manufacturer:%String,Synonym:%String,MixQuantity:%String,MaxQuantity:%String,WarnDays:%String,Sequence:%String,Visible:%String,PackageVol:%String,VolUnit:%String")
{
}

ClassMethod GetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataExecute(ByRef qHandle As %Binary, depart As %String) As %Status
{
	s depart=$g(depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCCTDepartReagmentI("SequenceIndex","D01",5,98)=
	s seq="" f  s seq=$o(^lab.DHCCTDepartReagmentI("SequenceIndex",depart,seq)) q:seq=""  d
	.s id="" f  s id=$o(^lab.DHCCTDepartReagmentI("SequenceIndex",depart,seq,id)) q:id=""  d
	..b
	..s ReagStr=$g(^lab.DHCCTDepartmentD(depart,"Items",id))
	..s uVis=$li(ReagStr,8)
	..s ReagId=$li(ReagStr,2)
	..i '$l(ReagId) q
	..i uVis'="Y" q
	..s str=$g(^lab.DHCCTReagentD(ReagId))
	..s uCode=$li(str,2)
	..s uName=$li(str,3)
	..//s name1=" "_name
	..//s name2=" "_uName
	..//i $l(name),name2'[name1 q
	..s uSyn=$li(str,20)
	..//s syn1=" "_syn
	..//s syn2=" "_uSyn
	..//i $l(syn),syn2'[syn1 q
	..///规格
	..s packDr="" //$li(str,4)
	..s packName=$li(str,4)
	..//i $l(packDr),$d(^lab.DHCCTPackageSizeD(packDr)) s packName=$li(^lab.DHCCTPackageSizeD(packDr),3)
	..///单位
	..s unitDr=$li(str,5)
	..s unitName=""
	..i $l(unitDr),$d(^lab.DHCCTUnitD(unitDr)) s unitName=$li(^lab.DHCCTUnitD(unitDr),3)
	..///类别
	..s typeDr=$li(str,6)
	..s typeName=""
	..i $l(typeDr),$d(^lab.DHCCTGroupTypeD(typeDr)) s typeName=$li(^lab.DHCCTGroupTypeD(typeDr),3)
	..///厂商
	..s ManuDr=$li(str,14)
	..s ManuName=""
	..i $l(ManuDr),$d(^lab.DHCCTManufacturerD(ManuDr)) s ManuName=$li(^lab.DHCCTManufacturerD(ManuDr),3)
	..s InPrice=$li(str,8)
	..s OutPrice=$li(str,9)
	..s Volumn=+$li(str,23)
	..i Volumn=0 s Volumn=1
	..d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(uCode,uSyn_" "_uName,packName,unitName,typeName,ManuName,InPrice,OutPrice,Volumn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataExecute ]
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
/// CreatDate：    20100429
/// Description:： 供应商快速查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetData(depart As %String) As %Query(ROWSPEC = "code:%String,name:%String,packagesize:%String,unit:%String,group:%String,ManuName:%String,InPrice:%String,OutPrice:%String,Volumn:%String")
{
}

}
