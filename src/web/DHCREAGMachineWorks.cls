Class web.DHCREAGMachineWorks Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

ClassMethod QryMachineItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMachineItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMachineItemExecute(ByRef qHandle As %Binary, Depart As %String, MachList As %String, ADate As %String, flag As %String) As %Status
{
	//^DHCAuthosizedItem("A619651000","A001")=AGENS\N\61965\1054\trak\\\\TS\
	s ^TMP($zn,"MachineItem","para")=Depart_"\"_MachList_"\"_ADate_"\"_flag
	i $l(ADate) s ADate=$zdh(ADate,3)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i '$l(ADate) Quit $$$OK
	k ^TMP($zn,$j)
	//^DHCAuthosizedItemI(0,"AuthDate",61965,"A1012","A619655002")=
	s item="" f  s item=$o(^DHCAuthosizedItemI(0,"AuthDate",ADate,item)) q:item=""  d
	.s labno="" f  s labno=$o(^DHCAuthosizedItemI(0,"AuthDate",ADate,item,labno)) q:labno=""  d
	..s str=$g(^DHCAuthosizedItem(labno,item))
	..s MachCode=$p(str,"\",1)
	..s Status=$p(str,"\",2)
	..i flag=1,Status'="Y" q
	..i flag=0,Status="Y" q
	..s Type=$p(str,"\",9)
	..i '$l(MachList) d  //仪器为空
	...i '$d(^TMP($zn,$j,"ITEM",item))  d
	....s ^TMP($zn,$j,"ITEM",item)=1
	....s ^TMP($zn,$j,"ITEM",item,"TYPE")=Type
	...e  d
	....s ^TMP($zn,$j,"ITEM",item)=+$g(^TMP($zn,$j,"ITEM",item))+1
	..e  d  //按仪器统计
	...s MachStr=MachCode_","
	...b ;100
	...i '$l(MachCode) q
	...i MachList'[MachStr q
	...i '$d(^TMP($zn,$j,"ITEM",item,MachCode))  d
	....s ^TMP($zn,$j,"ITEM",item,MachCode)=1
	....s ^TMP($zn,$j,"ITEM",item,MachCode,"TYPE")=Type
	...e  d
	....s ^TMP($zn,$j,"ITEM",item,MachCode)=+$g(^TMP($zn,$j,"ITEM",item,MachCode))+1
	//
	i '$l(MachList) d
	.s item="" f  s item=$o(^TMP($zn,$j,"ITEM",item)) q:item=""  d
	..s ItemSum=^(item)
	..s Type=$g(^TMP($zn,$j,"ITEM",item,"TYPE"))
	..s ItemName=""
	..i $l(Type) s ItemName=$p(^TTAB(Type,item),"\",1)
	..i Type="TS" s ItemType="医嘱套"
	..i Type="TC" s ItemType="检验项"
	..s MachName=""
	..d OutputRow		
	e  d
	.s item="" f  s item=$o(^TMP($zn,$j,"ITEM",item)) q:item=""  d
	..s mach="" f  s mach=$o(^TMP($zn,$j,"ITEM",item,mach)) q:mach=""  d
	...s ItemSum=^(mach)
	...s MachName=""
	...i $d(^lab.DHCCTMachineD(mach)) s MachName=$li(^lab.DHCCTMachineD(mach),2)
	...i $l(Type) s ItemName=$p(^TTAB(Type,item),"\",1)
	...i Type="TS" s ItemType="医嘱套"
	...i Type="TC" s ItemType="检验项"
	...d OutputRow
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(item,ItemName,ItemType,ItemSum,MachName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryMachineItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMachineItemExecute ]
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
/// CreatDate：    20100907
/// Description:： 查询仪器工作量
/// Table：       
/// Input：        flag:0 未完成,1 完成
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryMachineItem(Depart As %String, MachList As %String, ADate As %String, flag As %String) As %Query(ROWSPEC = "ItemCode:%String,ItemName:%String,ItemType:%String,ItemSum:%String,MachName:%String")
{
}

ClassMethod QryMachItmByLabnoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMachItmByLabnoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMachItmByLabnoExecute(ByRef qHandle As %Binary, labno As %String) As %Status
{
	s labno=$g(labno)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s item="" f  s item=$o(^DHCAuthosizedItem(labno,item)) q:item=""  d
	.s str=^(item)
	.s mach=$p(str,"\",1)
	.i '$l(mach) q
	.s Type=$p(str,"\",9)
	.s ItemName=""
	.i $l(Type) s ItemName=$p(^TTAB(Type,item),"\",1)
	.i Type="TS" s ItemType="医嘱套"
	.i Type="TC" s ItemType="检验项"
	.i $d(^lab.DHCCTMachineD(mach)) s MachName=$li(^lab.DHCCTMachineD(mach),2)
	.s ItemSum=1
	.d OutputId
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputId
	set Data=$lb(item,ItemName,ItemType,ItemSum,MachName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryMachItmByLabnoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMachItmByLabnoExecute ]
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
/// CreatDate：    20100907
/// Description:： 根据检验号查询查询项目
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryMachItmByLabno(labno As %String) As %Query(ROWSPEC = "ItemCode:%String,ItemName:%String,ItemType:%String,ItemSum:%String,MachName:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100907
/// Description:： 转移仪器工作量数据
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod MoveMachineWorks(AuthDate As %String) As %String
{
  s AuthDate=$g(AuthDate)
  s ^TMP($zn,"MoveMachineWorks")=$g(AuthDate)
  s RetValue=0
  i '$l(AuthDate) s AuthDate=+$h
  s labno="" f  s labno=$o(^TEPIi("AUTHORISED",AuthDate,labno)) q:labno=""  d
  .s ts="" f  s ts=$o(^TEPIi("AUTHORISED",AuthDate,labno,ts)) q:ts=""  d
  ..s tscnt="" f  s tscnt=$o(^TEPIi("AUTHORISED",AuthDate,labno,ts,tscnt)) q:tscnt=""  d
  ...s str=$g(^TEPI(labno,1,ts,tscnt))
  ...s mach=$p(str,"\",27)
  ...i '$l(mach) q
  ...s flag=$p(str,"\",33)
  ...i flag="Y" q
  ...b ;100
  ...i $$MoveData(labno,ts,tscnt) s RetValue=RetValue+1
  Quit RetValue
MoveData(labno,ts,tscnt) n (labno,ts,tscnt)
   s str=$g(^TEPI(labno,1,ts,tscnt))
   s tsIndex=" "_ts
   s mach=$p(str,"\",27)
   s date=$p(str,"\",4)
   s time=$p(str,"\",5)
   s user=$p(str,"\",6)
   SET $ZTRAP="ErrHandle",$ECODE=""   //捕获错误开始
   TSTART
   s RetStr=0
   i $d(^lab.DHCCTMachineTSI("MasterIndex",mach,tsIndex)) d
   .s RetStr=$$SaveTestSet(labno,ts,tscnt,date,time,user,"TS")
   e  d
   .s RetStr=$$SaveTestCode(labno,ts,tscnt,date,time,user,"TC")
   i RetStr TROLLBACK  q RetStr
   s rowid=labno_"||"_ts_"||"_tscnt
   //&sql(update lab.EP_VisitTestSet set VISTS_HISTO_BillingItem='Y' where VISTS_RowId=:rowid)
   //i SQLCODE q SQLCODE
   s $p(^TEPI(labno,1,ts,tscnt),"\",33)="Y"
   TCOMMIT
   q 0
ErrHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  TROLLBACK
  b ;200
  q RetMsg
SaveTestSet(labno,ts,tscnt,AuthDate,AuthTime,user,type)
  n (labno,ts,tscnt,AuthDate,AuthTime,user,type)
  s mach=$p(^TEPI(labno,1,ts,tscnt),"\",27)
  s RetValue=$$INSERT(labno,ts,mach,"N",AuthDate,AuthTime,user,type)
  q RetValue
SaveTestCode(labno,ts,tscnt,AuthDate,AuthTime,user,type)
  n (labno,ts,tscnt,AuthDate,AuthTime,user,type)
  s RetValue=0
  s LinkMachDr=$p(^TEPI(labno,1,ts,tscnt),"\",27)
  s tc="" f  s tc=$o(^TEPI(labno,1,ts,tscnt,"DATA",tc)) q:(tc="")!(RetValue)  d
  .s tcStr=$g(^(tc))
  .s mach=$p(tcStr,"\",6)
  .i '$l(mach) s mach=LinkMachDr
  .//i '$l(mach) q
  .s tcIndex=" "_tc
  .i $d(^lab.DHCCTMachineTCI("MasterIndex",mach,tcIndex)) d  q:RetValue
  ..s RetValue=$$INSERT(labno,tc,mach,"N",AuthDate,AuthTime,user,type)
  q RetValue
INSERT(labno,item,mach,stus,AuthDate,time,user,type)
  i $d(^DHCAuthosizedItem(labno,item)) q 0
  &sql(insert into lab.DHC_AuthosizedItem(DATC_LabNo,DATC_ItemCode,DATC_Machine,DATC_Status,DATC_AuthDate,DATC_AuthTime,DATC_AuthUserDR,DATC_ItemType) 
  values(:labno,:item,:mach,'N',:AuthDate,:time,:user,:type))
  q SQLCODE
}

}
