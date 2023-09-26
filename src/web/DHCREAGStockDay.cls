Class web.DHCREAGStockDay Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 132;

ClassMethod CalculateDayStock()
{
	k ^TMP($zn,$j)
	s LastDate=$o(^lab.DHCREAGDayStockI("CreateDateIndex",""),-1)
	i '$l(LastDate) s LastDate=+$h-2
	s RetValue=0
	f Date=(LastDate+1):1:(+$h-1) d  Q:RetValue'=0
	.s RetValue=..SetDayStock(Date)
	q RetValue
	i ($h-Day)<1 q "100"
    
	//计算入库数^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,4)=
	s dep="" f  s dep=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep)) q:dep=""  d
	.s date=Day f  s date=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep,date)) q:date=""  d
	..s id="" f  s id=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep,date,id)) q:id=""  d
	...//^lab.DHCREAGStockInD(23,"Items",146)
	...s subid="" f  s subid=$o(^lab.DHCREAGStockInD(id,"Items",subid)) q:subid=""  d
	....s str=$g(^lab.DHCREAGStockInD(id,"Items",subid))
	....i '$l(str) q
	....s reag=$li(str,2)
	....s lot=$li(str,3)
	....s LotCnt=$li(str,4)
	....s quan=+$li(str,8)
	....s sum=+$g(^TMP($zn,$j,1,dep,date,reag,lot,LotCnt,"IN"))+quan
	....s ^TMP($zn,$j,1,dep,date,reag,lot,LotCnt,"IN")=sum
	//计算出库数^lab.DHCREAGStockOutI("CheckDateIndex","D01",61871,15)=
	s dep="" f  s dep=$o(^lab.DHCREAGStockOutI("CheckDateIndex",dep)) q:dep=""  d
	.s date=Day f  s date=$o(^lab.DHCREAGStockOutI("CheckDateIndex",dep,date)) q:date=""  d
	..s id="" f  s id=$o(^lab.DHCREAGStockOutI("CheckDateIndex",dep,date,id)) q:id=""  d
	...s OpType=$li(^lab.DHCREAGStockOutD(id),2)
	...s OutType="OUT1"
	...i OpType="4" s OutType="OUT2" //退货
	...i OpType="5" s OutType="OUT3" //报损
	...s type="Items"
	...i OpType=8 s type="Machine"
	...//^lab.DHCREAGStockOutD(14,"Items",12)=<<$LB("","203","No0004","","","","","3","10","","","")>>
	...s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,type,subid)) q:subid=""  d
	....s str=$g(^lab.DHCREAGStockOutD(id,type,subid))
	....i '$l(str) q
	....s reag=$li(str,2)
	....s lot=$li(str,3)
	....s LotCnt=$li(str,4)
	....s quan=+$li(str,9)
	....i quan=0 q
	....s sum=+$g(^TMP($zn,$j,1,dep,date,reag,lot,LotCnt,OutType))+quan
	....s ^TMP($zn,$j,1,dep,date,reag,lot,LotCnt,OutType)=sum
	//计算领用数^lab.DHCREAGTransferI("CheckDateIndex","D01",61865,47)=
	s dep="" f  s dep=$o(^lab.DHCREAGTransferI("CheckDateIndex",dep)) q:dep=""  d
	.s date=Day f  s date=$o(^lab.DHCREAGTransferI("CheckDateIndex",dep,date)) q:date=""  d
	..//^lab.DHCREAGTransferD(41,"Items",53)=<<$LB("","203","No0004","M04","61727","62082","2","10","","","","")>>
	..s id="" f  s id=$o(^lab.DHCREAGTransferD(id)) q:id=""  d
	...s ToDep=$li(^lab.DHCREAGTransferD(id),3)
	...i '$l(ToDep) q
	...s subid="" f  s subid=$o(^lab.DHCREAGTransferD(id,"Items",subid)) q:subid=""  d
	....s str=$g(^lab.DHCREAGTransferD(id,"Items",subid))
	....i '$l(str) q
	....s reag=$li(str,2)
	....s lot=$li(str,3)
	....s LotCnt=$li(str,4)
	....s quan=+$li(str,8)
	....i quan=0 q
	....s sum=+$g(^TMP($zn,$j,1,dep,date,reag,lot,LotCnt,"OUT1"))+quan
	....s ^TMP($zn,$j,1,dep,date,reag,lot,LotCnt,"OUT1")=sum
	....s sum=+$g(^TMP($zn,$j,1,ToDep,date,reag,lot,LotCnt,"IN"))+quan
	....s ^TMP($zn,$j,1,ToDep,date,reag,lot,LotCnt,"IN")=sum
	m ^TMPSUM=^TMP($zn,$j,1)
	//上一天结余数
	s dep="" f  s dep=$o(^TMP($zn,$j,1,dep)) q:dep=""  d
	.s date="" f  s date=$o(^TMP($zn,$j,1,dep,date)) q:date=""  d
	..s reag="" f  s reag=$o(^TMP($zn,$j,1,dep,date,reag)) q:reag=""  d
	...s lot="" f  s lot=$o(^TMP($zn,$j,1,dep,date,reag,lot)) q:lot=""  d
	....s lotCnt="" f  s lotCnt=$o(^TMP($zn,$j,1,dep,date,reag,lot,lotCnt)) q:lotCnt=""  d
	.....s SumIn=+$g(^TMP($zn,$j,1,dep,date,reag,lot,lotCnt,"IN"))
	.....s SumOut=+$g(^TMP($zn,$j,1,dep,date,reag,lot,lotCnt,"OUT1"))
	.....s SumCan=+$g(^TMP($zn,$j,1,dep,date,reag,lot,lotCnt,"OUT2"))
	.....s SumDis=+$g(^TMP($zn,$j,1,dep,date,reag,lot,lotCnt,"OUT3"))
	.....s PreStock=+$g(^TMP($zn,$j,3,dep,date-1,reag,lot,lotCnt,"STK"))
	.....s SumStock=PreStock+SumIn-SumOut-SumCan-SumDis
	.....s ^TMP($zn,$j,3,dep,date,reag,lot,lotCnt,"STK")=SumStock
	.....s ^TMP($zn,$j,2,dep,date,reag,lot,lotCnt)=SumStock_$c(2)_SumIn_$c(2)_SumOut_$c(2)_SumCan_$c(2)_SumDis
	//m ^RESULT=^TMP($zn,$j,2)
	s dep="" f  s dep=$o(^TMP($zn,$j,2,dep)) q:dep=""  d
	.s date="" f  s date=$o(^TMP($zn,$j,2,dep,date)) q:date=""  d
	..s reag="" f  s reag=$o(^TMP($zn,$j,2,dep,date,reag)) q:reag=""  d
	...s lot="" f  s lot=$o(^TMP($zn,$j,2,dep,date,reag,lot)) q:lot=""  d
	....s lotCnt="" f  s lotCnt=$o(^TMP($zn,$j,2,dep,date,reag,lot,lotCnt)) q:lotCnt=""  d
	.....s SumStock=$p(^TMP($zn,$j,2,dep,date,reag,lot,lotCnt),$c(2),1)
	.....&SQL(insert into lab.DHCREAGDayStock(DepartmentDR,CreateDate,ReagentDR,LotNo,LotCount,Quantity) values(:dep,:date,:reag,:lot,:lotCnt,:SumStock))
	.....w !,SQLCODE
	k ^TMP($zn,$j)
	Quit "0"
}

ClassMethod SetDayStock(Date As %String) As %String
{
	n (Date)
	//b 101
	k ^TMP($zn,$j)
	s Date=$g(Date)
	s ChkDate=$o(^lab.DHCREAGDayStockI("CreateDateIndex",""),-1)
	i $l(ChkDate),(Date-ChkDate)'=1 q 100
	b ;100
	//计算前一天的库存数^lab.DHCREAGDayStockI("MasterIndex","D01",61895,202," 20100601",12)=
	s PreDate=Date-1
	s dep="" f  s dep=$o(^lab.DHCREAGDayStockI("MasterIndex",dep)) q:dep=""  d
	.s reag="" f  s reag=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,PreDate,reag)) q:reag=""  d
	..s lot="" f  s lot=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,PreDate,reag,lot)) q:lot=""  d
	...s lotCnt="" f  s lotCnt=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,PreDate,reag,lot,lotCnt)) q:lotCnt=""  d
	....s id="" f  s id=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,PreDate,reag,lot,lotCnt,id)) q:id=""  d
	.....s quan=+$li(^lab.DHCREAGDayStockD(id),7)
	.....s LotNo=$li(^lab.DHCREAGDayStockD(id),5)
	.....//s LotCnt=$li(^lab.DHCREAGDayStockD(id),6)
	.....s ^TMP($zn,$j,1,dep,reag,LotNo,lotCnt,"STK")=quan
	//计算入库数^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,4)=
	s dep="" f  s dep=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep)) q:dep=""  d
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep,Date,id)) q:id=""  d
	..s subid="" f  s subid=$o(^lab.DHCREAGStockInD(id,"Items",subid)) q:subid=""  d
	...s str=$g(^lab.DHCREAGStockInD(id,"Items",subid))
	...i '$l(str) q
	...s reag=$li(str,2)
	...s lot=$li(str,3)
	...s LotCnt=$li(str,4)
	...s quan=+$li(str,8)
	...s sum=+$g(^TMP($zn,$j,1,dep,reag,lot,LotCnt,"IN"))+quan
	...s ^TMP($zn,$j,1,dep,reag,lot,LotCnt,"IN")=sum
	//计算出库数^lab.DHCREAGStockOutI("CheckDateIndex","D01",61871,15)=
	s dep="" f  s dep=$o(^lab.DHCREAGStockOutI("CheckDateIndex",dep)) q:dep=""  d
	.s id="" f  s id=$o(^lab.DHCREAGStockOutI("CheckDateIndex",dep,Date,id)) q:id=""  d
	..s OpType=$li(^lab.DHCREAGStockOutD(id),3)
	..s OutType="OUT1"
	..i OpType="4" s OutType="OUT2" //退货
	..i OpType="5" s OutType="OUT3" //报损
	..s type="Items"
	..i OpType=8 s type="Machine"
	..//^lab.DHCREAGStockOutD(14,"Items",12)=<<$LB("","203","No0004","","","","","3","10","","","")>>
	..s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,type,subid)) q:subid=""  d
	...s str=$g(^lab.DHCREAGStockOutD(id,type,subid))
	...i '$l(str) q
	...s reag=$li(str,2)
	...w !,id,",",subid,",",reag
	...s lot=$li(str,3)
	...s LotCnt=$li(str,4)
	...s quan=+$li(str,9)
	...i quan=0 q
	...s sum=+$g(^TMP($zn,$j,1,dep,reag,lot,LotCnt,OutType))+quan
	...s ^TMP($zn,$j,1,dep,reag,lot,LotCnt,OutType)=sum
	//计算领用数^lab.DHCREAGTransferI("CheckDateIndex","D01",61865,47)=
	s dep="" f  s dep=$o(^lab.DHCREAGTransferI("CheckDateIndex",dep)) q:dep=""  d
	.//^lab.DHCREAGTransferD(41,"Items",53)=<<$LB("","203","No0004","M04","61727","62082","2","10","","","","")>>
	.//s id="" f  s id=$o(^lab.DHCREAGTransferD(id)) q:id=""  d
	.s id="" f  s id=$o(^lab.DHCREAGTransferI("CheckDateIndex",dep,Date,id)) q:id=""  d
	..s ToDep=$li(^lab.DHCREAGTransferD(id),3)
	..i '$l(ToDep) q
	..s subid="" f  s subid=$o(^lab.DHCREAGTransferD(id,"Items",subid)) q:subid=""  d
	...s str=$g(^lab.DHCREAGTransferD(id,"Items",subid))
	...i '$l(str) q
	...s reag=$li(str,2)
	...//
	...s lot=$li(str,3)
	...s LotCnt=$li(str,4)
	...s quan=+$li(str,8)
	...i quan=0 q
	...s sum=+$g(^TMP($zn,$j,1,dep,reag,lot,LotCnt,"OUT1"))+quan
	...s ^TMP($zn,$j,1,dep,reag,lot,LotCnt,"OUT1")=sum
	...s sum=+$g(^TMP($zn,$j,1,ToDep,reag,lot,LotCnt,"IN"))+quan
	...s ^TMP($zn,$j,1,ToDep,reag,lot,LotCnt,"IN")=sum
	m ^RESULT=^TMP($zn,$j,1)
	//b 104
	TSTART
	s SQLCODE=0
	s dep="" f  s dep=$o(^TMP($zn,$j,1,dep)) q:dep=""!SQLCODE'=0  d
	.s reag="" f  s reag=$o(^TMP($zn,$j,1,dep,reag)) q:reag=""!SQLCODE'=0  d
	..s lot="" f  s lot=$o(^TMP($zn,$j,1,dep,reag,lot)) q:lot=""!SQLCODE'=0  d
	...s (PreStk,StkIn,StkOut,StkCan,StkDis,Stock)=0
	...s lotCnt="" f  s lotCnt=$o(^TMP($zn,$j,1,dep,reag,lot,lotCnt)) q:lotCnt=""!SQLCODE'=0  d
	....//
	....s PreStk=+$g(^TMP($zn,$j,1,dep,reag,lot,lotCnt,"STK"))
	....s StkIn=+$g(^TMP($zn,$j,1,dep,reag,lot,lotCnt,"IN"))
	....s StkOut=+$g(^TMP($zn,$j,1,dep,reag,lot,lotCnt,"OUT1"))
	....s StkCan=+$g(^TMP($zn,$j,1,dep,reag,lot,lotCnt,"OUT2"))
	....s StkDis=+$g(^TMP($zn,$j,1,dep,reag,lot,lotCnt,"OUT3"))
	....s Stock=PreStk+StkIn-StkOut-StkCan-StkDis
	....//b 103
	....&sql(insert into lab.DHCREAGDayStock(DepartmentDR,CreateDate,ReagentDR,LotNo,LotCount,Quantity) values(:dep,:Date,:reag,:lot,:lotCnt,:Stock))
	k ^TMP($zn,$j)
	i SQLCODE TROLLBACK  q SQLCODE
	TCOMMIT
	q "0"
}

ClassMethod StockIn(Depart As %String, Date As %String) As %String
{
	s RetValue=0
	//计算入库数^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,4)=
	s dep="" f  s dep=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep)) q:dep=""  d
	.s date=Day f  s date=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep,date)) q:date=""  d
	..s id="" f  s id=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep,date,id)) q:id=""  d
	...//^lab.DHCREAGStockInD(23,"Items",146)
	...s subid="" f  s subid=$o(^lab.DHCREAGStockInD(id,"Items",subid)) q:subid=""  d
	....s str=$g(^lab.DHCREAGStockInD(id,"Items",subid))
	....i '$l(str) q
	....s reag=$li(str,2)
	....s lot=$li(str,3)
	....s quan=+$li(str,8)
    Quit RetValue
}

ClassMethod QryReportSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportSumExecute(ByRef qHandle As %Binary, DepCode As %String, DateFrom As %String, DateTo As %String, group As %String, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	s DateFrom=$g(DateFrom),DateTo=$g(DateTo),group=$g(group),dep=$g(DepCode)
	s DateFrom=$zdh(DateFrom,3),DateTo=$zdh(DateTo,3)
	s type=+$g(type)
	s ^TMP($zn,"para")=DateFrom_","_DateTo_","_group_","_DepCode_","_type
	d ..CalculateDayStock()
	s DateS=DateFrom-1,DateE=DateTo+1
	If $g(ind)="" Set ind=1
	k ^TMP($ZN,"TLL")
	k ^TMP($zn,$j)
	//计算期初库存^lab.DHCREAGDayStockI("MasterIndex","D01",61895,202," 20100601",47)=
	s reag="" f  s reag=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateS,reag)) q:reag=""  d
	.s lot="" f  s lot=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateS,reag,lot)) q:lot=""  d
	..s lotCnt="" f  s lotCnt=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateS,reag,lot,lotCnt)) q:lotCnt=""  d
	...s id="" f  s id=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateS,reag,lot,lotCnt,id)) q:id=""  d
	....s quan=+$li(^lab.DHCREAGDayStockD(id),7)
	....s LotNo=$li(^lab.DHCREAGDayStockD(id),5)
	....//s LotCnt=$li(^lab.DHCREAGDayStockD(id),6)
	....s ^TMP($zn,$j,1,reag,LotNo,lotCnt,"PSTK")=quan
	//计算期末库存
	s reag="" f  s reag=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateTo,reag)) q:reag=""  d
	.s lot="" f  s lot=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateTo,reag,lot)) q:lot=""  d
	..s lotCnt="" f  s lotCnt=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateTo,reag,lot,lotCnt)) q:lotCnt=""  d
	...s id="" f  s id=$o(^lab.DHCREAGDayStockI("MasterIndex",dep,DateTo,reag,lot,lotCnt,id)) q:id=""  d
	....//
	....s quan=+$li(^lab.DHCREAGDayStockD(id),7)
	....s LotNo=$li(^lab.DHCREAGDayStockD(id),5)
	....s ^TMP($zn,$j,1,reag,LotNo,lotCnt,"STK")=quan
	//计算入库数^lab.DHCREAGStockInI("CheckDateIndex","D01",61867,4)=
	//^lab.DHCREAGStockInI("CheckDateIndex","D01",61895,25)=
	s Date=DateS f  s Date=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep,Date)) q:(Date="")!(Date'<DateE)  d
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("CheckDateIndex",dep,Date,id)) q:id=""  d
	..s subid="" f  s subid=$o(^lab.DHCREAGStockInD(id,"Items",subid)) q:subid=""  d
	...s str=$g(^lab.DHCREAGStockInD(id,"Items",subid))
	...i '$l(str) q
	...s reag=$li(str,2)
	...s lot=$li(str,3)
	...s LotCnt=$li(str,4)
	...s quan=+$li(str,8)
	...s sum=+$g(^TMP($zn,$j,1,reag,lot,LotCnt,"IN"))+quan
	...s ^TMP($zn,$j,1,reag,lot,LotCnt,"IN")=sum
	//计算出库数^lab.DHCREAGStockOutI("CheckDateIndex","D01",61871,15)=
	s Date=DateS f  s Date=$o(^lab.DHCREAGStockOutI("CheckDateIndex",dep,Date)) q:(Date="")!(Date'<DateE)  d
	.s id="" f  s id=$o(^lab.DHCREAGStockOutI("CheckDateIndex",dep,Date,id)) q:id=""  d
	..s OpType=$li(^lab.DHCREAGStockOutD(id),3)
	..s OutType="OUT1"
	..i OpType="4" s OutType="OUT2" //退货
	..i OpType="5" s OutType="OUT3" //报损
	..s Table="Items"
	..i OpType=8 s Table="Machine"
	..//^lab.DHCREAGStockOutD(14,"Items",12)=<<$LB("","203","No0004","","","","","3","10","","","")>>
	..s subid="" f  s subid=$o(^lab.DHCREAGStockOutD(id,Table,subid)) q:subid=""  d
	...s str=$g(^lab.DHCREAGStockOutD(id,Table,subid))
	...i '$l(str) q
	...s reag=$li(str,2)
	...//w !,id,",",subid,",",reag
	...s lot=$li(str,3)
	...s LotCnt=$li(str,4)
	...s quan=+$li(str,9)
	...i quan=0 q
	...s sum=+$g(^TMP($zn,$j,1,reag,lot,LotCnt,OutType))+quan
	...s ^TMP($zn,$j,1,reag,lot,LotCnt,OutType)=sum
	//计算领用数^lab.DHCREAGTransferI("CheckDateIndex","D01",61865,47)=
	s DepId="" f  s DepId=$o(^lab.DHCREAGTransferI("CheckDateIndex",DepId)) q:DepId=""  d
	.//^lab.DHCREAGTransferD(41,"Items",53)=<<$LB("","203","No0004","M04","61727","62082","2","10","","","","")>>
	.s Date=DateS f  s Date=$o(^lab.DHCREAGTransferI("CheckDateIndex",DepId,Date)) q:(Date="")!(Date'<DateE)  d
	..s id="" f  s id=$o(^lab.DHCREAGTransferI("CheckDateIndex",DepId,Date,id)) q:id=""  d
	...s ToDep=$li(^lab.DHCREAGTransferD(id),3)
	...i '$l(ToDep) q
	...s subid="" f  s subid=$o(^lab.DHCREAGTransferD(id,"Items",subid)) q:subid=""  d
	....s str=$g(^lab.DHCREAGTransferD(id,"Items",subid))
	....i '$l(str) q
	....s reag=$li(str,2)
	....//
	....s lot=$li(str,3)
	....s LotCnt=$li(str,4)
	....s quan=+$li(str,8)
	....i quan=0 q
	....i DepId=dep d
	.....s sum=+$g(^TMP($zn,$j,1,reag,lot,LotCnt,"OUT1"))+quan
	.....s ^TMP($zn,$j,1,reag,lot,LotCnt,"OUT1")=sum
	....i ToDep=dep d
	.....s sum=+$g(^TMP($zn,$j,1,reag,lot,LotCnt,"IN"))+quan
	.....s ^TMP($zn,$j,1,reag,lot,LotCnt,"IN")=sum
	//库存
	m ^TMP($ZN,"TLL")=^TMP($zn,$j,1)
	s reag="" f  s reag=$o(^TMP($zn,$j,1,reag)) q:reag=""  d
	.//试剂基本信息
	.s (Reagent,PackageDr,PackageName,UnitDr,UnitName,GrpId,GrpName,ManuDr,ManuName)=""
	.s Volumn=1,Sequence=""
	.i $d(^lab.DHCCTReagentD(reag)) d
	..s Reagent=$li(^lab.DHCCTReagentD(reag),3)
	..s PackageName=$li(^lab.DHCCTReagentD(reag),4)
	..s UnitDr=$li(^lab.DHCCTReagentD(reag),5)
	..s GrpId=$li(^lab.DHCCTReagentD(reag),6)
	..s ManuDr=$li(^lab.DHCCTReagentD(reag),14)
	..s Volumn=+$li(^lab.DHCCTReagentD(reag),23)
	..s Sequence=$li(^lab.DHCCTReagentD(reag),18)
	.i Volumn=0 s Volumn=1
	.i Sequence="" s Sequence=999
	.//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	.i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	.i $l(ManuDr),$d(^lab.DHCCTManufacturerD(ManuDr)) s ManuName=$li(^lab.DHCCTManufacturerD(ManuDr),3)
	.i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GrpName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	.s (StkIn,StkOut,StkCan,StkDis,Stock,StkPre)=0
	.s lot="" f  s lot=$o(^TMP($zn,$j,1,reag,lot)) q:lot=""  d
	..s lotCnt="" f  s lotCnt=$o(^TMP($zn,$j,1,reag,lot,lotCnt)) q:lotCnt=""  d
	...i type=0 d
	....s Sum1=+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"IN"))
	....s Sum2=+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"OUT1"))
	....s Sum3=+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"OUT2"))
	....s Sum4=+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"OUT3"))
	....s Sum5=+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"STK"))
	....s Sum6=+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"PSTK"))
	...e  d
	....s Sum1=$fn(+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"IN"))/Volumn,"",2)
	....s Sum2=$fn(+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"OUT1"))/Volumn,"",2)
	....s Sum3=$fn(+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"OUT2"))/Volumn,"",2)
	....s Sum4=$fn(+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"OUT3"))/Volumn,"",2)
	....s Sum5=$fn(+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"STK"))/Volumn,"",2)
	....s Sum6=$fn(+$g(^TMP($zn,$j,1,reag,lot,lotCnt,"PSTK"))/Volumn,"",2)
	...s StkIn=StkIn+(Sum1*$$LotPrice(type,reag,lot,lotCnt))
	...s StkOut=StkOut+(Sum2*$$LotPrice(type,reag,lot,lotCnt))
	...s StkCan=StkCan+(Sum3*$$LotPrice(type,reag,lot,lotCnt))
	...s StkDis=StkDis+(Sum4*$$LotPrice(type,reag,lot,lotCnt))
	...s Stock=Stock+(Sum5*$$LotPrice(type,reag,lot,lotCnt))
	...s StkPre=StkPre+(Sum6*$$LotPrice(type,reag,lot,lotCnt))
	.S ^TMP($ZN,"TLL","100",reag)=StkPre
	.i type=0 d
	..s StkIn=$fn(StkIn/Volumn,"",2)
	..s StkOut=$fn(StkOut/Volumn,"",2)
	..s StkCan=$fn(StkCan/Volumn,"",2)
	..s StkDis=$fn(StkDis/Volumn,"",2)
	..s Stock=$fn(Stock/Volumn,"",2)
	..s StkPre=$fn(StkPre/Volumn,"",2)
	.s Data=$lb(reag,Reagent,PackageName,ManuName,GrpName,StkPre,StkIn,StkOut,StkCan,StkDis,Stock,UnitName)
	.s ^TMP($zn,$j,"LIST",Sequence,reag)=Data
	.//d OutputId		
	s seq="" f  s seq=$o(^TMP($zn,$j,"LIST",seq)) q:seq=""  d
	.s reag="" f  s reag=$o(^TMP($zn,$j,"LIST",seq,reag)) q:reag=""  d
	..s Data=$g(^TMP($zn,$j,"LIST",seq,reag))
	..d OutputId
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,$j)
	Quit $$$OK
OutputId
	//set Data=$lb(reag,Reagent,PackageName,ManuName,GrpName,StkPre,StkIn,StkOut,StkCan,StkDis,Stock,UnitName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
LotPrice(type,reag,lot,lotCnt)
    i type=0 Quit 1
    s RetPrc=+$g(^lab.DHCREAGStockInItemsI("LotNo",reag,lot,lotCnt))
    i RetPrc=0 s RetPrc=1
    Quit RetPrc
}

ClassMethod QryReportSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportSumExecute ]
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
/// CreatDate：    20100628
/// Description:： 查询总帐
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryReportSum(DepCode As %String, DateFrom As %String, DateTo As %String, group As %String, type As %String) As %Query(ROWSPEC = "ReagDr:%String,ReagName:%String,PackSize:%String,ManuName:%String,Group:%String,StkPre:%String,StkIn:%String,StkOut:%String,StkCan:%String,StkDis:%String,Stock:%String,UnitName:%String")
{
}

}
