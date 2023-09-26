Class web.DHCREAGConsume Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 166;

/// Creator：      huhm
/// CreatDate：    20100901
/// Description：  确认试剂消耗
/// Table：        DHCREAGStockOut,DHCREAGStockOutMachine,DHCREAGTrace,DHCREAGStock,DHCREAGStockIems
/// Input：        出库单ID,用户代码
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others：       
ClassMethod CheckConsume(RowID As %String, User As %String, date As %String, time As %String) As %String
{
	New (RowID,User,date,time)
	Set RowID=$Get(RowID),User=$Get(User),date=$g(date),time=$g(time)
	Set chkDate=date //+$h //$zd(+$h,3)
	Set chkTime=time //$p($h,",",2) //$zt($p($h,",",2),2)
	Set Stus="A"
	&sql(select Status into :Stus from lab.DHCREAGStockOut where ID=:RowID)
	If SQLCODE=100 Quit "出库单不存在"
	If Stus="A" Quit "已审核"
	Set DepId=$li(^lab.DHCREAGStockOutD(RowID),4)
	Set StockOutNo=$li(^lab.DHCREAGStockOutD(RowID),2)
	Set OperateType=$li(^lab.DHCREAGStockOutD(RowID),3)
	If '$Length(DepId) Quit "科室为空"
	If '$Length(OperateType) Quit "操作类型为空"
	If $Length(OperateType),$li(^lab.DHCCTOperateTypeD(OperateType),5)'="O" Quit "不是出库单"
	SET $ZTRAP="ErrHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	&sql(update lab.DHCREAGStockOut set CheckDate=:chkDate,CheckTime=:chkTime,CheckUserDR=:User,Status='A' where ID=:RowID)
	If SQLCODE Quit $$ChkRollback("更新审核信息失败:"_SQLCODE)
	Set ReagId=""
	Set RetValue=0
	Set ReagId="" For  Set ReagId=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId)) Quit:ReagId=""  Do
	.Set lot="" For  Set lot=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot)) Quit:lot=""  Do
	..Set LotCnt="" For  Set LotCnt=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot,LotCnt)) Quit:LotCnt=""  Do
	...Set mach="" For  Set mach=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot,LotCnt,mach)) Quit:mach=""  Do
	....Set SubId="" For  Set SubId=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot,LotCnt,mach,SubId)) Quit:SubId=""  Do
	.....If '$Data(^lab.DHCREAGStockOutD(RowID,"Machine",SubId)) Quit
	.....Set ItmStr=$Get(^lab.DHCREAGStockOutD(RowID,"Machine",SubId))
	.....Set LotNo=$li(ItmStr,3)
	.....Set Quan=$li(ItmStr,9)
	.....Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(DepId,ReagId,"O",LotNo_"||"_LotCnt,Quan,StockOutNo,User,"",OperateType)
	If RetValue'=0 Quit $$ChkRollback(RetValue)
	TCOMMIT
	Quit 0
ChkRollback(para)
  s para=$g(para)
  TROLLBACK
  q "1"_$c(2)_para
  //错误处理
ErrHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  q $$ChkRollback(RetMsg)
}

/// Creator：      huhm
/// CreatDate：    20100902
/// Description：  取消试剂消耗
/// Table：        DHCREAGStockOut,DHCREAGStockOutMachine,DHCREAGTrace,DHCREAGStock,DHCREAGStockIems
/// Input：        出库单ID,用户代码
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others
ClassMethod CancelComsume(RowID As %String, User As %String, date As %String, time As %String) As %String
{
	New (RowID,User,date,time)
	Set RowID=$Get(RowID),User=$Get(User),date=$g(date),time=$g(time)
	Set chkDate=date //+$h //$zd(+$h,3)
	Set chkTime=time //$p($h,",",2) //$zt($p($h,",",2),2)
	Set Stus="R"
	&sql(select Status into :Stus from lab.DHCREAGStockOut where ID=:RowID)
	If SQLCODE=100 Quit "出库单不存在"
	If Stus'="A" Quit "未审核的出库单"
	Set DepId=$li(^lab.DHCREAGStockOutD(RowID),4)
	Set StockOutNo=$li(^lab.DHCREAGStockOutD(RowID),2)
	Set OperateType=$li(^lab.DHCREAGStockOutD(RowID),3)
	If '$Length(DepId) Quit "科室为空"
	If '$Length(OperateType) Quit "操作类型为空"
	If $Length(OperateType),$li(^lab.DHCCTOperateTypeD(OperateType),5)'="O" Quit "不是出库单"
	Set Stus="R" //作废
	SET $ZTRAP="ErrHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	Set LabNo=""
	&sql(update lab.DHCREAGStockOut set ReturnDate=:chkDate,ReturnTime=:chkTime,ReturnUserDR=:User,Status=:Stus where ID=:RowID)
	If SQLCODE Quit $$ChkRollback("更新审核信息失败:"_SQLCODE)
	Set ReagId=""
	Set RetValue=0
	Set ReagId="" For  Set ReagId=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId)) Quit:ReagId=""  Do
	.Set lot="" For  Set lot=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot)) Quit:lot=""  Do
	..Set LotCnt="" For  Set LotCnt=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot,LotCnt)) Quit:LotCnt=""  Do
	...Set mach="" For  Set mach=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot,LotCnt,mach)) Quit:mach=""  Do
	....Set SubId="" For  Set SubId=$Order(^lab.DHCREAGStockOutMachineI("MasterIndex",RowID,ReagId,lot,LotCnt,mach,SubId)) Quit:SubId=""  Do
	.....If '$Data(^lab.DHCREAGStockOutD(RowID,"Machine",SubId)) Quit
	.....Set ItmStr=$Get(^lab.DHCREAGStockOutD(RowID,"Machine",SubId))
	.....Set LotNo=$li(ItmStr,3)
	.....Set Quan=$li(ItmStr,9)
	.....Set Quan=0-Quan
	.....Set LabNo=$li(ItmStr,6)
	.....Set RetValue=##Class(web.DHCREAGCommon).SaveReturnTrans(DepId,ReagId,"O",LotNo_"||"_LotCnt,Quan,StockOutNo,User,"",OperateType)
	If RetValue'=0 Quit $$ChkRollback(RetValue)
	//取消项目标志
	Set SQLCODE=0
	If $l(LabNo) Do
	.Set itm="" For  Set itm=$Order(^DHCAuthosizedItemI(0,"StkOutNo",StockOutNo,LabNo,itm)) Quit:(itm="")!(SQLCODE)  Do
	..Set RowId=LabNo_"||"_itm
	..&sql(update lab.DHC_AuthosizedItem Set DATC_Status='N' where DATC_RowId=:RowId)
	If SQLCODE Quit $$ChkRollback(SQLCODE)
	TCOMMIT
	Quit 0
}

/// Creator：      huhm
/// CreatDate：    20100830
/// Description:： 试剂消耗
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod ReagentConsume(Depart As %String, ReagPara As %String, user As %String) As %String
{
	s Depart=$g(Depart),ReagPara=$g(ReagPara),user=$g(user)
	s ^TMP($zn,"Reagcon","para",1)=Depart_","_user
	s ^TMP($zn,"Reagcon","para",2)=ReagPara
	s CrtDate=+$h
	s CrtTime=$p($h,",",2)
	k ^TMP($zn,$j)
	s RetValue=0
	f i=1:1:$l(ReagPara,$c(2)) d
	.s str=$p(ReagPara,$c(2),i)
	.i '$l(str) q
	.s LabNo=$p(str,"^",1)
	.s ReagDr=$p(str,"^",2)
	.s LotId=$p(str,"^",3)
	.s Quantity=$p(str,"^",4)
	.s MachCode=$p(str,"^",5)
	.s TS=$p(str,"^",6)
	.s TC=$p(str,"^",7)
	.//s LotNo=$p(str,"^",3)
	.//s LotCnt=$p(str,"^",4)
	.i $d(^TMP($zn,$j,"LOT",LabNo,ReagDr,LotId,MachCode)) d
	..s ^TMP($zn,$j,"LOT",LabNo,ReagDr,LotId,MachCode)=+$g(^TMP($zn,$j,"LOT",LabNo,ReagDr,LotId,MachCode))+Quantity
	..s ^TMP($zn,$j,"LOT",LabNo,ReagDr,LotId,MachCode,1)=""
	.e  d  
	..s ^TMP($zn,$j,"LOT",LabNo,ReagDr,LotId,MachCode)=Quantity
	..s ^TMP($zn,$j,"LOT",LabNo,ReagDr,LotId,MachCode,1)=TS_"\"_TC
	.//s LotNo
	s labno="" f  s labno=$o(^TMP($zn,$j,"LOT",labno)) q:labno=""  d
	.s ReagStr=""
	.s reag="" f  s reag=$o(^TMP($zn,$j,"LOT",labno,reag)) q:reag=""  d
	..s LotId="" f  s LotId=$o(^TMP($zn,$j,"LOT",labno,reag,LotId)) q:LotId=""  d
	...//s LotNo="" f  s LotNo=$o(^TMP($zn,$j,"LOT",labno,reag,LotNo)) q:LotNo=""  d
	...//.s LotCnt="" f  s LotCnt=$o(^TMP($zn,$j,"LOT",labno,reag,LotNo,LotCnt)) q:LotCnt=""  d
	...s LotStr=$g(^lab.DHCREAGStockD(+LotId,"Items",$p(LotId,"||",2)))
	...i '$l(LotStr) q
	...s LotNo=$li(LotStr,2)
	...s LotCnt=$li(LotStr,3)
	...s InPrice=$li(LotStr,13)
	...s mach="" f  s mach=$o(^TMP($zn,$j,"LOT",labno,reag,LotId,mach)) q:mach=""  d
	....s Quantity=$g(^(mach))
	....s TS=$p(^TMP($zn,$j,"LOT",labno,reag,LotId,mach,1),"\",1)
	....s TC=$p(^TMP($zn,$j,"LOT",labno,reag,LotId,mach,1),"\",2)
	....s ReagStr=ReagStr_reag_"\"_LotNo_"\"_LotCnt_"\"_Quantity_"\"_mach_"\"_TS_"\"_TC_"\"_InPrice_$c(2)
	.i $l(ReagStr) s RetValue=..SaveReagent(labno,ReagStr,user,"8",Depart,CrtDate,CrtTime)
	.s ^TMP($zn,"Reagcon","RES",labno)=RetValue
	k ^TMP($zn,$j)
	q 0
}

/// 根据检验号将试剂保存到试剂消耗表
ClassMethod SaveReagent(LabNo As %String, ReagStr As %String, User As %String, OpType As %String, Depart As %String, OpDate As %String, OpTime As %String) As %String
{
	n (StkOutNo,LabNo,ReagStr,User,OpType,Depart,OpDate,OpTime)
	s LabNo=$g(LabNo),ReagStr=$g(ReagStr),User=$g(User),OpType=$g(OpType),Depart=$g(Depart),OpDate=$g(OpDate),OpTime=$g(OpTime)
	s StkOutNo=##Class(web.DHCREAGSysPara).GetEpisode("6")
	i '$l(StkOutNo) q "100"
    SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART
	&sql(insert into lab.DHCREAGStockOut(StockOutNo,OperateTypeDR,DepartmentDR,CreateDate,CreateTime,CreateUserDR,Status) 
	Values(:StkOutNo,:OpType,:Depart,:OpDate,:OpTime,:User,'C'))
	i SQLCODE q $$RollBack("出库单插入失败!错误："_SQLCODE)
	s ParRowId=$o(^lab.DHCREAGStockOutI("MasterIndex"," "_StkOutNo,""))
	i '$l(ParRowId) q $$RollBack("出库单插入失败!")
	//reag_"\"_LotNo_"\"_LotCnt_"\"_Quantity_"\"_Machine_"\"_TS_"\"_TC_$c(2)
	f i=1:1:$l(ReagStr,$c(2)) d  q:SQLCODE
	.s str=$p(ReagStr,$c(2),i)
	.i '$l(str) q
	.s reag=$p(str,"\",1)
	.s LotNo=$p(str,"\",2)
	.s LotCnt=$p(str,"\",3)
	.s Quantity=$p(str,"\",4)
	.s Machine=$p(str,"\",5)
	.s TS=$p(str,"\",6)
	.s TC=$p(str,"\",7)
	.//查询出库价格
	.s Price=$p(str,"\",8)
	.&sql(insert into lab.DHCREAGStockOutMachine(ParRef,ReagentDR,LotNo,LotCount,MachineDR,LabNo,TestSetDR,TestCodeDR,Quantity,Price) values(:ParRowId,:reag,:LotNo,:LotCnt,:Machine,:LabNo,:TS,:TC,:Quantity,:Price))
	.//更新项目
	.i SQLCODE q
	.s ItmRowId=""
	.i $l(TS) s ItmRowId=LabNo_"||"_TS
	.i $l(TC) s ItmRowId=LabNo_"||"_TC
	.i '$l(ItmRowId) q
	.&sql(update lab.DHC_AuthosizedItem set DATC_Status='Y',DATC_StockOutNo=:StkOutNo where DATC_RowId=:ItmRowId)
	i SQLCODE q $$RollBack("出库单明细插入失败!错误："_SQLCODE)
	//审核
	s RetValue=..CheckConsume(ParRowId,User,OpDate,OpTime)
	i RetValue q $$RollBack("审核失败!错误："_RetValue)
	TCOMMIT
	q SQLCODE
RollBack(para)
   TROLLBACK
   q para
ErrorHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  q $$RollBack(RetMsg)
}

ClassMethod QryCalReagByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCalReagByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCalReagByItemExecute(ByRef qHandle As %Binary, Depart As %String, MachList As %String, ADate As %String) As %Status
{
	s Depart=$g(Depart),MachList=$g(MachList),ADate=$g(ADate)
	s ^TMP($zn,"QryReag","para")=Depart_"\"_MachList_"\"_ADate
	i $l(ADate) s ADate=$zdh(ADate,3)
 	Set repid=$I(^CacheTemp)
 	s LABNS="labdata"
	If $g(ind)="" Set ind=1
    k ^TMP($zn,$j)
    f i=1:1:$l(MachList,",") d
    .s Machine=$p(MachList,",",i)
    .i '$l(Machine) q
    .s item="" f  s item=$o(^DHCAuthosizedItemI(0,"Status","N",Machine,item)) q:item=""  d
    ..s labno="" f  s labno=$o(^DHCAuthosizedItemI(0,"Status","N",Machine,item,labno)) q:labno=""  d
    ...s AuthDate=$p(^DHCAuthosizedItem(labno,item),"\",3)
    ...i $l(ADate),ADate'=AuthDate q
    ...s AuthTime=$p(^DHCAuthosizedItem(labno,item),"\",4)
    ...s type=$p(^DHCAuthosizedItem(labno,item),"\",9)
    ...//B
    ...d GetReagent(AuthDate,AuthTime,labno,item,type,Machine)
    //B
    s date="" f  s date=$o(^TMP($zn,$j,"Item",date)) q:date=""  d
    .s time="" f  s time=$o(^TMP($zn,$j,"Item",date,time)) q:time=""  d
    ..s labno="" f  s labno=$o(^TMP($zn,$j,"Item",date,time,labno)) q:labno=""  d
    ...s item="" f  s item=$o(^TMP($zn,$j,"Item",date,time,labno,item)) q:item=""  d
    ....s type=^(item)
    ....s seq="" f  s seq=$o(^TMP($zn,$j,"Item",date,time,labno,item,seq)) q:seq=""  d
    .....s id="" f  s id=$o(^TMP($zn,$j,"Item",date,time,labno,item,seq,id)) q:id=""  d
    ......s MachCode=^(id)
    ......s MachName=""
    ......i $d(^TMIF(MachCode)) s MachName=$p(^TMIF(MachCode),"\",1)
    ......s str=$g(^lab.DHCCTMachineD(MachCode,type,id))
    ......s ReagId=$li(str,3)
    ......i '$d(^lab.DHCCTReagentD(ReagId)) q
    ......s LotNo=$li(str,4)
    ......s quan=+$li(str,5)
    ......i quan<1 s quan="0"_quan
    ......s LotId=$li(str,6)
    ......i $l(LotId) d
    .......i '$d(^lab.DHCREAGStockD(+LotId,"Items",$p(LotId,"||",2))) q
    .......s LotNo=$li(^lab.DHCREAGStockD(+LotId,"Items",$p(LotId,"||",2)),2)
    .......s LotCnt=$li(^lab.DHCREAGStockD(+LotId,"Items",$p(LotId,"||",2)),3)
    ......s (ReagName,PackageDr,UnitDr,PackageName,UnitName,GroupName,ManuName)=""
	......s ReagName=$li(^lab.DHCCTReagentD(ReagId),3)
	......s ReagDr=$li(^lab.DHCCTReagentD(ReagId),2)
	......s PackageName=$li(^lab.DHCCTReagentD(ReagId),4)
	......//s UnitDr=$li(^lab.DHCCTReagentD(ReagId),5)
	......s UnitName=$li(^lab.DHCCTReagentD(ReagId),24)
	......s GrpId=$li(^lab.DHCCTReagentD(ReagId),6)
	......s ManuDR=$li(^lab.DHCCTReagentD(ReagId),14)
	......//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	......i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GroupName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	......//i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	......i $l(ManuDR),$d(^lab.DHCCTManufacturerD(ManuDR))  s ManuName=$li(^lab.DHCCTManufacturerD(ManuDR),3)
	......s ItemName=""
	......i $d(^TTAB(type,item)) s ItemName=$p(^TTAB(type,item),"\",1)
	......d OutputCheck			
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheck
	set Data=$lb(labno,ItemName,ReagName,PackageName,LotNo,quan,UnitName,ManuName,GroupName,MachName,ReagDr,item,type,LotCnt,MachCode,LotId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetReagent(date,time,labno,item,type,mach) n (date,time,labno,item,type,mach)
    s ItemIndex=" "_item
    i type="TS" d
    .s reag ="" f  s reag=$o(^lab.DHCCTMachineTSI("MasterIndex",mach,ItemIndex,reag)) q:reag=""  d
    ..s id="" f  s id=$o(^lab.DHCCTMachineTSI("MasterIndex",mach,ItemIndex,reag,id)) q:id=""  d
    ...s ^TMP($zn,$j,"Item",date,time,labno,item)=type
    ...s ShowSeq=+$li(^lab.DHCCTReagentD(reag),18)
    ...i ShowSeq=0 s ShowSeq=999
    ...s ^TMP($zn,$j,"Item",date,time,labno,item,ShowSeq,id)=mach
    i type="TC" d
    .s reag ="" f  s reag=$o(^lab.DHCCTMachineTCI("MasterIndex",mach,ItemIndex,reag)) q:reag=""  d
    ..s id="" f  s id=$o(^lab.DHCCTMachineTCI("MasterIndex",mach,ItemIndex,reag,id)) q:id=""  d
    ...s ^TMP($zn,$j,"Item",date,time,labno,item)=type
    ...s ShowSeq=+$li(^lab.DHCCTReagentD(reag),18)
    ...i ShowSeq=0 s ShowSeq=999
    ...s ^TMP($zn,$j,"Item",date,time,labno,item,ShowSeq,id)=mach
    q
}

ClassMethod QryCalReagByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCalReagByItemExecute ]
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
/// CreatDate：    20100827
/// Description:： 计算消耗试剂
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryCalReagByItem(Depart As %String, MachList As %String, ADate As %String) As %Query(ROWSPEC = "LabNo:%String,ItemName:%String,ReagName:%String,PackageName:%String,LotNo:%String,Quantity:%String,UnitName:%String,ManuName:%String,GroupName:%String,MachName:%String,ReagDr:%String,ItemCode:%String,ItemType:%String,LotCnt:%String,MachCode:%String,LotId:%String")
{
}

ClassMethod QryCalSumByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCalSumByItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCalSumByItemExecute(ByRef qHandle As %Binary, Depart As %String, MachList As %String, ADate As %String) As %Status
{
	s Depart=$g(Depart),MachList=$g(MachList),ADate=$g(ADate)
 	Set repid=$I(^CacheTemp)
 	s LABNS="labdata"
	If $g(ind)="" Set ind=1
    k ^TMP($zn,$j)
    /*
    s item="" f  s item=$o(^[LABNS]DHCAuthosizedItem(0,"Status","N",Machine,item)) q:item=""  d
    .s labno="" f  s labno=$o(^[LABNS]DHCAuthosizedItem(0,"Status","N",Machine,item,labno)) q:labno=""  d
    ..s AuthDate=$p(^[LABNS]DHCAuthosizedItem(labno,item),"\",3)
    ..s AuthTime=$p(^[LABNS]DHCAuthosizedItem(labno,item),"\",4)
    ..s type=$p(^[LABNS]DHCAuthosizedItem(labno,item),"\",9)
    ..//B
    ..d GetReagent(AuthDate,AuthTime,labno,item,type,Machine)
    */
    i $l(ADate) s ADate=$zdh(ADate,3)
    f i=1:1:$l(MachList,",") d
    .s Machine=$p(MachList,",",i)
    .i '$l(Machine) q
    .s item="" f  s item=$o(^DHCAuthosizedItemI(0,"Status","N",Machine,item)) q:item=""  d
    ..s labno="" f  s labno=$o(^DHCAuthosizedItemI(0,"Status","N",Machine,item,labno)) q:labno=""  d
    ...s AuthDate=$p(^DHCAuthosizedItem(labno,item),"\",3)
    ...i $l(ADate),ADate'=AuthDate q
    ...s AuthTime=$p(^DHCAuthosizedItem(labno,item),"\",4)
    ...s type=$p(^DHCAuthosizedItem(labno,item),"\",9)
    ...//B
    ...d GetReagent(AuthDate,AuthTime,labno,item,type,Machine)
    //B
    s date="" f  s date=$o(^TMP($zn,$j,"Item",date)) q:date=""  d
    .s time="" f  s time=$o(^TMP($zn,$j,"Item",date,time)) q:time=""  d
    ..s labno="" f  s labno=$o(^TMP($zn,$j,"Item",date,time,labno)) q:labno=""  d
    ...s item="" f  s item=$o(^TMP($zn,$j,"Item",date,time,labno,item)) q:item=""  d
    ....s type=^(item)
    ....s seq="" f  s seq=$o(^TMP($zn,$j,"Item",date,time,labno,item,seq)) q:seq=""  d
    .....s id="" f  s id=$o(^TMP($zn,$j,"Item",date,time,labno,item,seq,id)) q:id=""  d
    ......s MachCode=^(id)
    ......s str=$g(^lab.DHCCTMachineD(MachCode,type,id))
    ......s ReagId=$li(str,3)
    ......i '$d(^lab.DHCCTReagentD(ReagId)) q
    ......s LotNo=$li(str,4)
    ......s quan=$li(str,5)
    ......s LotId=$li(str,6)
    ......i $l(LotId) s ^TMP($zn,$j,"SUM",ReagId,LotId)=+$g(^TMP($zn,$j,"SUM",ReagId, LotId))+quan
    ......i '$l(LotId) s ^TMP($zn,$j,"SUM", ReagId,"REAG")=+$g(^TMP($zn,$j, "SUM",ReagId,"REAG"))+quan
    //^TMP("web.DHCREAGConsume.1",2912,"SUM",205,"140||166")=3.3
    s reag="" f  s reag=$o(^TMP($zn,$j,"SUM",reag)) q:reag=""  d
    .s LotId="" f  s LotId=$o(^TMP($zn,$j,"SUM",reag,LotId)) q:LotId=""  d
    ..s quan=+$g(^(LotId))
    ..s LotNo=""
    ..i LotId'="REAG" d
    ...s LotNo=$li(^lab.DHCREAGStockD(+LotId,"Items",$p(LotId,"||",2)),2)
    ...s LotQuan=$li(^lab.DHCREAGStockD(+LotId,"Items",$p(LotId,"||",2)),10)
    ..//
    ..s ReagId=reag
    ..s (ReagName,PackageName,UnitName,GroupName,ManuName)=""
	..s ReagName=$li(^lab.DHCCTReagentD(ReagId),3)
	..s ReagDr=$li(^lab.DHCCTReagentD(ReagId),2)
	..s PackageName=$li(^lab.DHCCTReagentD(ReagId),4)
	..s UnitDr=$li(^lab.DHCCTReagentD(ReagId),5)
	..s GrpId=$li(^lab.DHCCTReagentD(ReagId),6)
	..s ManuDR=$li(^lab.DHCCTReagentD(ReagId),14)
	..s Sequence=$li(^lab.DHCCTReagentD(ReagId),18)
	..s PackageVol=+$li(^lab.DHCCTReagentD(ReagId),23)
	..s VolUnit=$li(^lab.DHCCTReagentD(ReagId),24)
	..i PackageVol=0 s PackageVol=1
	..//i $l(PackageDr),$d(^lab.DHCCTPackageSizeD(PackageDr)) s PackageName=$li(^lab.DHCCTPackageSizeD(PackageDr),3)
	..i $l(GrpId),$d(^lab.DHCCTGroupTypeD(GrpId)) s GroupName=$li(^lab.DHCCTGroupTypeD(GrpId),3)
	..i $l(UnitDr),$d(^lab.DHCCTUnitD(UnitDr)) s UnitName=$li(^lab.DHCCTUnitD(UnitDr),3)
	..i $l(ManuDR),$d(^lab.DHCCTManufacturerD(ManuDR))  s ManuName=$li(^lab.DHCCTManufacturerD(ManuDR),3)
	..s LotQuan=+$fn(LotQuan/PackageVol,"",3)
	..i LotQuan<1,LotQuan>0 s LotQuan="0"_LotQuan
	..s ConQuan=+$fn(quan/PackageVol,"",3)
	..i ConQuan<1,ConQuan>0 s ConQuan="0"_ConQuan
	..i quan<1,quan>0 s quan="0"_quan
	..s quan=$fn(quan,"",3)
	..s LotQuan=$fn(LotQuan,"",3)
	..s ConQuan=$fn(ConQuan,"",3)
	..//
	..set Data=$lb(ReagName,PackageName,LotNo,quan,VolUnit,ConQuan,UnitName,LotQuan,ManuName,GroupName,ReagDr,LotId)
	..i '$l(Sequence) s Sequence=999
	..s ^TMP($zn,$j,"seq",Sequence,reag,LotId)=Data
	..//d OutputSum			
	s seq="" f  s seq=$o(^TMP($zn,$j,"seq",seq)) q:seq=""  d
	.s reag="" f  s reag=$o(^TMP($zn,$j,"seq",seq,reag)) q:reag=""  d
	..s lot="" f  s lot=$o(^TMP($zn,$j,"seq",seq,reag,lot)) q:lot=""  d
	...s Data=^(lot)
	...d OutputSum
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSum
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCalSumByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCalSumByItemExecute ]
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
/// CreatDate：    20100830
/// Description:： 汇总消耗试剂
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryCalSumByItem(Depart As %String, MachList As %String, ADate As %String) As %Query(ROWSPEC = "ReagName:%String,PackageName:%String,LotNo:%String,Quantity:%String,VolUnit:%String,ConQuan:%String,UnitName:%String,LotQuan:%String,ManuName:%String,GroupName:%String,ReagDr:%String,LotId:%String")
{
}

}
