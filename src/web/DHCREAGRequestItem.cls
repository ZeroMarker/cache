Class web.DHCREAGRequestItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 100;

ClassMethod QryRequestItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRequestItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRequestItemExecute(ByRef qHandle As %Binary, RequestNo As %String, flag As %String) As %Status
{
    //
    s RequestNo=$g(RequestNo),flag=$g(flag)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RequestId=$o(^lab.DHCREAGRequestI("MasterIndex"," "_RequestNo,""))
	Set qHandle=$lb(0,repid,0)
	i '$l(RequestId) Quit $$$OK
	s Depart=$li(^lab.DHCREAGRequestD(RequestId),6)
	s id="" f  s id=$o(^lab.DHCREAGRequestD(RequestId,"Items",id)) q:id=""  d
	.s str=$g(^lab.DHCREAGRequestD(RequestId,"Items",id))
	.s ReagentDR=$li(str,2)
	.i '$l(ReagentDR) q
	.i '$d(^lab.DHCCTReagentD(ReagentDR)) q
	.s ReqQuan=+$li(str,3)
	.s TraQuan=+$li(str,4)
	.s Status=$li(str,5)
	.s Remarks=$li(str,6)
	.s LotNo=$li(str,7)
	.s LotCount=$li(str,8)
	.s (ExpDate,PrtDate,PosiDr)=""
	.s Price=0
	.s ItemStus="未审核"
	.i Status="Y",$l(LotNo) s ItemStus="已审核"
	.i Status="Y",'$l(LotNo) s ItemStus="删除"
	.i flag="Y",ItemStus="删除" q
	.//i flag="N",ItemStus="已审核" q
	.//
	.i $l(LotNo),$l(LotCount) d
	..s ItemStr=##Class(web.DHCREAGStockItem).GetStockItem(Depart,ReagentDR,LotNo,LotCount)
	..s ExpDate=$li(ItemStr,5)
	..s PrtDate=$li(ItemStr,4)
	..s PosiDr=$li(ItemStr,12)
	..s Price=$li(ItemStr,13)
	.i $l(ExpDate) s ExpDate=$zd(ExpDate,3)
	.i $l(PrtDate) s PrtDate=$zd(PrtDate,3)
	.s PositionName=""
	.i $l(PosiDr),$d(^lab.DHCCTPositionD(PosiDr)) s PositionName=$li(^lab.DHCCTPositionD(PosiDr),3)
	.///
	.s ManufacturerDR="",PackageDr="",PackageName=""
	.s UnitDr="",UnitName=""
	.s Volumn=1
	.i $d(^lab.DHCCTReagentD(ReagentDR)) d
	..s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	..s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	..s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	..s Volumn=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	.i Volumn=0 s Volumn=1
	.//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	.i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	.///
	.s ReagentName=$li(^lab.DHCCTReagentD(ReagentDR),3)
	.s ManufacturerName=""
	.i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s ManufacturerName=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	.s ReqQuan=$fn(ReqQuan/Volumn,"",2)
	.s TraQuan=$fn(TraQuan/Volumn,"",2)
	.s SumPrice=TraQuan*Price
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,ReagentName,PackageName,ReqQuan,TraQuan,UnitName,ManufacturerName,Remarks,ExpDate,PrtDate,PositionName,ReagentDR,LotNo,LotCount,Price,SumPrice,Status,ItemStus,Volumn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryRequestItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRequestItemExecute ]
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
/// CreatDate：    20100728
/// Description:： 请领单明细查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryRequestItem(RequestNo As %String, flag As %String) As %Query(ROWSPEC = "ItemId:%String,ReagName:%String,PackageName:%String,Quantity:%String,TransQty:%String,UnitName:%String,ManuName:%String,Remark:%String,ExpireDate:%String,ProductDate:%String,Position:%String,ReagDr:%String,LotNo:%String,LotCount:%String,Price:%String,SumPrice:%String,Status:%String,ItemStus:%String,PackageVol:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100729
/// Description:： 根据请领单号和试剂得到请领数量
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod GetReag(RequestId As %String, reag As %String) As %String
{
	s ReqQuan="",TranQuan="",memo=""
	s status="N"
	s ItemId=$o(^lab.DHCREAGRequestItemsI("MasterIndex",RequestId,reag,""))
	i $l(ItemId) d
	.s ReqQuan=$li(^lab.DHCREAGRequestD(RequestId,"Items",ItemId),3)
	.s TranQuan=$li(^lab.DHCREAGRequestD(RequestId,"Items",ItemId),4)
	.s status=$li(^lab.DHCREAGRequestD(RequestId,"Items",ItemId),5)
	.s memo=$li(^lab.DHCREAGRequestD(RequestId,"Items",ItemId),6)
	q ItemId_$c(2)_ReqQuan_$c(2)_TranQuan_$c(2)_status_$c(2)_memo
}

ClassMethod QryRequestItemDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRequestItemDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRequestItemDetailsExecute(ByRef qHandle As %Binary, FrmDepart As %String, ToDepart As %String, type As %String, manu As %String, group As %String) As %Status
{
    //^lab.DHCREAGRequestI("StatusIndex"," N","D03",37)=
    //^lab.DHCREAGRequestI("ToDepartmentDRIndex"," N","D05",24)=
    s FrmDepart=$g(FrmDepart),ToDepart=$g(ToDepart),type=$g(type),manu=$g(manu),group=$g(group)
 	s ^TMP($zn,"RequestItem","para")=FrmDepart_","_ToDepart_","_type_","_manu_","_group
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,$j)
	i type=0,$l(FrmDepart) d
	.s id="" f  s id=$o(^lab.DHCREAGRequestI("StatusIndex"," N",FrmDepart,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGRequestD(id))
	..s Printed=$li(str,12)
	..i Printed'="Y" q
	..s toDeartDr=$li(str,6)
	..i $l(ToDepart),ToDepart'=toDeartDr q  //被请求科室
	..s PrnDate=$li(str,9),PrnTime=$li(str,10)
	..i '$l(PrnDate) q
	..i '$l(PrnTime) s PrnTime=0
	..s ^TMP($zn,$j,"DATE",PrnDate,PrnTime,id)=""
	i type=1,$l(ToDepart) d
	.s id="" f  s id=$o(^lab.DHCREAGRequestI("ToDepartmentDRIndex"," N",ToDepart,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGRequestD(id))
	..s Printed=$li(str,12)
	..i Printed'="Y" q
	..s frmDeartDr=$li(str,7)
	..i $l(FrmDepart),FrmDepart'=frmDeartDr q //请求科室
	..s PrnDate=$li(str,9),PrnTime=$li(str,10)
	..i '$l(PrnDate) q
	..i '$l(PrnTime) s PrnTime=0
	..s ^TMP($zn,$j,"DATE",PrnDate,PrnTime,id)=""
	s date="" f  s date=$o(^TMP($zn,$j,"DATE",date)) q:date=""  d
	.s time="" f  s time=$o(^TMP($zn,$j,"DATE",date,time)) q:time=""  d
	..s id="" f  s id=$o(^TMP($zn,$j,"DATE",date,time,id)) q:id=""  d
	...s ReqStr=$g(^lab.DHCREAGRequestD(id))
	...i '$l(ReqStr) q
	...s ReqNo=$li(ReqStr,2)
	...s toDeartDr=$li(ReqStr,6)
	...s frmDeartDr=$li(ReqStr,7)
	...s DepName=""
	...i type="0",$l(toDeartDr),$d(^lab.DHCCTDepartmentD(toDeartDr)) s DepName=$li(^lab.DHCCTDepartmentD(toDeartDr),3)
	...i type="1",$l(frmDeartDr),$d(^lab.DHCCTDepartmentD(frmDeartDr)) s DepName=$li(^lab.DHCCTDepartmentD(frmDeartDr),3)
	...s PrnUsrDr=$li(ReqStr,11)
	...s PrintUser=""
	...i $l(PrnUsrDr),$d(^lab.DHCCTUserD(PrnUsrDr)) s PrintUser=$li(^lab.DHCCTUserD(PrnUsrDr),3)
	...s subid="" f  s subid=$o(^lab.DHCREAGRequestD(id,"Items",subid)) q:subid=""  d
	....s reagStr=$g(^lab.DHCREAGRequestD(id,"Items",subid))
	....s status=$li(reagStr,5)
	....//w ":",id,",",subid,",",status
	....i status="Y" q
	....s ReagentDR=$li(reagStr,2)
	....i '$l(ReagentDR) q
	....i '$d(^lab.DHCCTReagentD(ReagentDR)) q
	....s ReqQuan=$li(reagStr,3)
	....s Remarks=$li(reagStr,6)
	....//
	....s (PackageName,UnitName,Manufacturer,Group)=""
	....s ReagentName=$li(^lab.DHCCTReagentD(ReagentDR),3)
	....s PackageName=$li(^lab.DHCCTReagentD(ReagentDR),4)
	....s UnitDr=$li(^lab.DHCCTReagentD(ReagentDR),5)
	....s GroupDr=$li(^lab.DHCCTReagentD(ReagentDR),6)
	....s ManufacturerDR=$li(^lab.DHCCTReagentD(ReagentDR),14)
	....i $l(manu),manu'=ManufacturerDR q
	....i $l(group),group'=GroupDr q
	....s Volumn=+$li(^lab.DHCCTReagentD(ReagentDR),23)
	....i Volumn=0 s Volumn=1
	....//
	....s ReqQuan=$fn(ReqQuan/Volumn,"",2)
	....//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	....i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	....i $l(ManufacturerDR),$d(^lab.DHCCTManufacturerD(ManufacturerDR)) s Manufacturer=$li(^lab.DHCCTManufacturerD(ManufacturerDR),3)
	....i $l(GroupDr),$d(^lab.DHCCTGroupTypeD(GroupDr)) s Group=$li(^lab.DHCCTGroupTypeD(GroupDr),3)
	....s PrnDT=$zd(date,3)_" "_$zt(time,1)
	....d OutputDetails		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDetails
	set Data=$lb(id_"||"_subid,DepName,ReqNo,ReagentName,PackageName,Manufacturer,ReqQuan,UnitName,Group,Remarks,PrnDT,PrintUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryRequestItemDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRequestItemDetailsExecute ]
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
/// CreatDate：    20100811
/// Description:： 请领单试剂查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryRequestItemDetails(FrmDepart As %String, ToDepart As %String, type As %String, manu As %String, group As %String) As %Query(ROWSPEC = "Id:%String,Depart:%String,RequestNo:%String,ReagName:%String,PackageName:%String,ManuName:%String,Quantity:%String,UnitName:%String,Group:%String,Remark:%String,PrintDT:%String,PrintUser:%String")
{
}

}
