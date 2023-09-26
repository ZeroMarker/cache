Class web.DHCREAGStockOutConsume Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

/// Creator：      huhm
/// CreatDate：    20100908
/// Description：  取消试剂消耗
/// Table：        DHCREAGStockOut,DHCREAGStockOutMachine,DHCREAGTrace,DHCREAGStock,DHCREAGStockIems
/// Input：        出库单ID,用户代码
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others
ClassMethod DeAuthosizeConsume(Depart As %String, ChkDate As %String, ChkTime As %String, ChkUser As %String, OpUser As %String) As %String
{
	n (Depart,ChkDate,ChkTime,ChkUser,OpUser)
	s Depart=$g(Depart)
	s ChkDate=$zdh(ChkDate,3),ChkTime=$zth(ChkTime),ChkUser=$g(ChkUser),OpUser=$g(OpUser)
	s ^TMP($zn,"DeAuth","para")=Depart_","_ChkDate_","_ChkTime_","_ChkUser_","_OpUser
 	Set repid=$I(^CacheTemp)
 	s OpDate=+$h,OpTime=$p($h,",",2)
	If $g(ind)="" Set ind=1
	Set RetValue=0
	k ^TMP($zn,$j)
	SET $ZTRAP="ErrHdl",$ECODE=""   //捕获错误开始
	TSTART
	s id="" f  s id=$o( ^lab.DHCREAGStockOutI("CheckDateIndex",Depart,ChkDate,id)) q:(id="")!(RetValue)  d
	.s str=$g(^lab.DHCREAGStockOutD(id))
	.s time=$li(str,9)
	.s user=$li(str,10)
	.i time'=ChkTime q
	.i user'=ChkUser q
	.s RetValue=##Class(web.DHCREAGConsume).CancelComsume(id,OpUser,OpDate,OpTime)
	i RetValue'=0 TROLLBACK  Quit "取消失败！错误原因:"_RetValue
	TCOMMIT
	Quit RetValue
  //错误处理
ErrHdl
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  TROLLBACK
  Quit "取消失败！错误原因:"_RetMsg
}

ClassMethod QryCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCheckListExecute(ByRef qHandle As %Binary, Depart As %String, ChkDate As %String) As %Status
{
	// ^lab.DHCREAGStockOutI("CheckDateIndex","D02",61971,142)=
	s ChkDate=$zdh(ChkDate,3)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	s id="" f  s id=$o( ^lab.DHCREAGStockOutI("CheckDateIndex",Depart,ChkDate,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGStockOutD(id))
	.s time=$li(str,9)
	.s user=$li(str,10)
	.s stus=$li(str,11)
	.i stus'="A" q
	.s ^TMP($zn,$j,"list",time,user)=""
	s time="" f  s time=$o(^TMP($zn,$j,"list",time)) q:time=""  d
	.s user="" f  s user=$o(^TMP($zn,$j,"list",time,user)) q:user=""  d
	..s UserName=user
	..i $d(^lab.DHCCTUserD(user)) s UserName=$li(^lab.DHCCTUserD(user),3)
	..s ChkTime=$zt(time)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,$j)
	Quit $$$OK
OutputRow
	set Data=$lb(ChkTime,UserName,user)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCheckListExecute ]
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

Query QryCheckList(Depart As %String, ChkDate As %String) As %Query(ROWSPEC = "ChkTime:%String,ChkUser:%String,ChkUserDr:%String")
{
}

ClassMethod QryCheckDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCheckDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCheckDetailsExecute(ByRef qHandle As %Binary, Depart As %String, ChkDate As %String, ChkTime As %String, ChkUser As %String) As %Status
{
	// ^lab.DHCREAGStockOutI("CheckDateIndex","D02",61971,142)=
	s ChkDate=$zdh(ChkDate,3)
	s ChkTime=$zth(ChkTime),ChkUser=$g(ChkUser)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	s id="" f  s id=$o( ^lab.DHCREAGStockOutI("CheckDateIndex",Depart,ChkDate,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGStockOutD(id))
	.s time=$li(str,9)
	.s user=$li(str,10)
	.s stus=$li(str,11)
	.i time'=ChkTime q
	.i user'=ChkUser q
	.i stus'="A" q
	.//^lab.DHCREAGStockOutD(139,"Machine",61)=<<$LB("","202","200103","1","ALX20","A619695999","","A1012",".3","210","","")>>
	.s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,"Machine",subid)) q:subid=""  d
	..s str=$g(^lab.DHCREAGStockOutD(id,"Machine",subid))
	..s labno=$li(str,6)
	..s reag=$li(str,2)
	..s LotNo=$li(str,3)
	..s LotCnt=$li(str,4)
	..s MachCode=$li(str,5)
	..s quan=$li(str,9)
	..s ^TMP($zn,$j,"reag",labno,reag,LotNo_"||"_LotCnt)=quan_$c(2)_MachCode_$c(2)_id_"||"_subid
	//
	s labno="" f  s labno=$o(^TMP($zn,$j,"reag",labno)) q:labno=""  d
	.s ReagId="" f  s ReagId=$o(^TMP($zn,$j,"reag",labno,ReagId)) q:ReagId=""  d
	..s lot="" f  s lot=$o(^TMP($zn,$j,"reag",labno,ReagId,lot)) q:lot=""  d
	...s str=^(lot)
	...//b 100
	...s quan=$p(str,$c(2),1)
	...s MachCode=$p(str,$c(2),2)
	...s rowid=$p(str,$c(2),3)
	...s MachName=$li(^lab.DHCCTMachineD(MachCode),3)
	...s LotNo=$p(lot,"||",1)
    ...s (ReagName,PackageName,UnitName,GroupName,ManuName)=""
	...s ReagName=$li(^lab.DHCCTReagentD(ReagId),3)
	...s ReagDr=$li(^lab.DHCCTReagentD(ReagId),2)
	...s PackageDr=$li(^lab.DHCCTReagentD(ReagId),4)
	...s UnitDr=$li(^lab.DHCCTReagentD(ReagId),5)
	...s GrpId=$li(^lab.DHCCTReagentD(ReagId),6)
	...s ManuDR=$li(^lab.DHCCTReagentD(ReagId),14)
	...s Sequence=$li(^lab.DHCCTReagentD(ReagId),18)
	...i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	...i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GroupName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	...i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	...i $l(ManuDR),$d(^lab.DHCCTManufacturerD(ManuDR))  s ManuName=$li(^lab.DHCCTManufacturerD(ManuDR),3)
	...//
	..d OutputDetails
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDetails
	set Data=$lb(labno,GroupName,ReagName,PackageName,LotNo,quan,UnitName,MachName,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCheckDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCheckDetailsExecute ]
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

Query QryCheckDetails(Depart As %String, ChkDate As %String, ChkTime As %String, ChkUser As %String) As %Query(ROWSPEC = "LabNo:%String,GroupName:%String,ReagName:%String,PackageName:%String,LotNo:%String,Quantity:%String,UnitName:%String,MachName:%String,RowId:%String")
{
}

}
