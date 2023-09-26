Class web.DHCREAGStockCancel Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

/// Creator：      huhm
/// CreatDate：    20100412
/// Description：  确认试剂退货
/// Table：        DHCREAGStockOut,DHCREAGStockOutItems,DHCREAGTrace,DHCREAGStock,DHCREAGStockIems
/// Input：        出库单ID,用户代码
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others：       
ClassMethod CheckCancel(RowID As %String, User As %String) As %String
{
	New (RowID,User)
	Set RowID=$Get(RowID),User=$Get(User)
	s ^TMP($zn,"Check","para")=RowID_","_User
	Set chkDate=+$h //$zd(+$h,3)
	Set chkTime=$p($h,",",2) //$zt($p($h,",",2),2)
	Set Stus="A"
	&sql(select Status into :Stus from lab.DHCREAGStockOut where ID=:RowID)
	If SQLCODE=100 Quit "退货单不存在"
	If Stus="A" Quit "已审核"
	Set DepId=$li(^lab.DHCREAGStockOutD(RowID),4)
	Set StockOutNo=$li(^lab.DHCREAGStockOutD(RowID),2)
	Set OperateType=$li(^lab.DHCREAGStockOutD(RowID),3)
	If '$Length(DepId) Quit "科室为空"
	If '$Length(OperateType) Quit "操作类型为空"
	If $Length(OperateType),$li(^lab.DHCCTOperateTypeD(OperateType),5)'="C" Quit "不是退货单"
	//SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	&sql(update lab.DHCREAGStockOut set CheckDate=:chkDate,CheckTime=:chkTime,CheckUserDR=:User,Status='A' where ID=:RowID)
	If SQLCODE Quit $$Rollback("更新审核信息失败:"_SQLCODE)
	Set ReagId=""
	Set RetValue=0
	Set ReagId="" For  Set ReagId=$Order(^lab.DHCREAGStockOutItemsI("MasterIndex",RowID,ReagId)) Quit:ReagId=""  Do
	.Set lot="" For  Set lot=$Order(^lab.DHCREAGStockOutItemsI("MasterIndex",RowID,ReagId,lot)) Quit:lot=""  Do
	..Set LotCnt="" For  Set LotCnt=$Order(^lab.DHCREAGStockOutItemsI("MasterIndex",RowID,ReagId,lot,LotCnt)) Quit:LotCnt=""  Do 
	...Set SubId="" For  Set SubId=$Order(^lab.DHCREAGStockOutItemsI("MasterIndex",RowID,ReagId,lot,LotCnt,SubId)) Quit:SubId=""  Do
	....If '$Data(^lab.DHCREAGStockOutD(RowID,"Items",SubId)) Quit
	....Set ItmStr=$Get(^lab.DHCREAGStockOutD(RowID,"Items",SubId))
	....Set LotNo=$li(ItmStr,3)
	....Set Quan=$li(ItmStr,9)
	....Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(DepId,ReagId,"C",LotNo_"||"_LotCnt,Quan,StockOutNo,User,"",OperateType)
	If RetValue'=0 Quit $$Rollback(RetValue)
	TCOMMIT
	/*
	&sql(select Status into :Stus from lab.DHCREAGStockOut where ID=:RowID)
	If SQLCODE=100 Quit "退货单不存在"
	If Stus="A" Quit "已审核"
	Set DepId=$li(^lab.DHCREAGStockOutD(RowID),4)
	Set StockOutNo=$li(^lab.DHCREAGStockOutD(RowID),2)
	Set OperateType=$li(^lab.DHCREAGStockOutD(RowID),3)
	If $Length(OperateType),$li(^lab.DHCCTOperateTypeD(OperateType),5)'="C" Quit "不是退货单"
	If '$Length(DepId) Quit "科室为空"
	SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	&sql(update lab.DHCREAGStockOut set CheckDate=:chkDate,CheckTime=:chkTime,CheckUserDR=:User where ID=:RowID)
	If SQLCODE Quit $$Rollback("更新审核信息失败:"_SQLCODE)
	Set ReagId=""
	Set RetValue=0
	For {
		///计算试剂库存
		Set ReagId=$Order(^lab.DHCREAGStockOutItemsI("MasterIndex",RowID,ReagId))
		Quit:ReagId=""
		Quit:RetValue'=0
		Set Id=$o(^lab.DHCREAGStockOutItemsI("MasterIndex",RowID,ReagId,""))
		If $Length(Id){
			Set ItmStr=$g(^lab.DHCREAGStockOutD(RowID,"Items",Id))
			Set LotNo=$li(ItmStr,3)
			Set Quan=$li(ItmStr,4)
			Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(DepId,ReagId,"C",LotNo,Quan,StockOutNo,User,"",OperateType)
			///&sql(select ID,Quantity into :StkRowId,:StkQuan  from lab.DHCREAGStock where DepartmentDR=:DepId and ReagentDR=:ReagId)
		}
	}
	If RetValue'=0 Quit $$Rollback(RetValue)
	TCOMMIT
	*/
	Quit 0
Rollback(para)
  s para=$g(para)
  TROLLBACK
  q "1"_$c(2)_para
  //错误处理
ErrorHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  q $$Rollback(RetMsg)
}

ClassMethod QryUnChkCancelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnChkCancelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUnChkCancelExecute(ByRef qHandle As %Binary, Depart As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGTransferI("StatusIndex"
	s id="" f  s id=$o(^lab.DHCREAGStockOutI("StatusIndex"," C",Depart,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGStockOutD(id))
	.s StockOutNo=$li(str,2)
	.s OprTypeDr=$li(str,3)
	.i OprTypeDr'="4" q //4:退货
	.s DepartDr=$li(str,4)
	.s CrtDate=$li(str,5)
	.s CrtTime=$li(str,6)
	.s CrtUser=$li(str,7)
	.s ReasonDr=$li(str,12)
	.s Remark=$li(str,13)
	.s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	.///
	.s DepartName=""
	.i $l(DepartDr),$d(^lab.DHCCTDepartmentD(DepartDr)) s DepartName=$li(^lab.DHCCTDepartmentD(DepartDr),3)
	.s CrtUserName=""
	.i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	.s OptType=""
	.i $l(OprTypeDr),$d(^lab.DHCCTOperateTypeD(OprTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OprTypeDr),3)
	.s Reason=""
	.i $l(ReasonDr),$d(^lab.DHCCTReasonD(ReasonDr)) s Reason=$li(^lab.DHCCTReasonD(ReasonDr),2)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,StockOutNo,DepartName,CrtDT,CrtUserName,OptType,Reason,Remark,DepartDr,CrtUser,OprTypeDr,ReasonDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryUnChkCancelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnChkCancelExecute ]
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
/// CreatDate：    20100520
/// Description:： 未审核的出库单查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       
/// Others：
Query QryUnChkCancel(Depart As %String) As %Query(ROWSPEC = "StockOutID:%String,StockOutNo:%String,DepartName:%String,CreateDT:%String,CreateUser:%String,OperateType:%String,Reason:%String,Remark:%String,DepartDr:%String,CrtUserDr:%String,OptTypeDr:%String,ReasonDr:%String")
{
}

ClassMethod QryCheckedCancelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCheckedCancelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCheckedCancelExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, CheckUser As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s OpType=$g(OpType)
 	s CheckUser=$g(CheckUser)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockOutI("CheckDateIndex"
	f Date=DateFrom:1:DateTo d
	.s id="" f  s id=$o(^lab.DHCREAGStockOutI("CheckDateIndex",Depart,Date,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockOutD(id))
	..s StockOutNo=$li(str,2)
	..s OprTypeDr=$li(str,3)
	..i $l(OpType),OpType'=OprTypeDr q
	..i OprTypeDr'="4" q //4:退货
	..s CrtDate=$li(str,5)
	..s CrtTime=$li(str,6)
	..s CrtUser=$li(str,7)
	..s ChkDate=$li(str,8)
	..s ChkTime=$li(str,9)
	..s ChkUser=$li(str,10)
	..i $l(CheckUser),CheckUser'=ChkUser q
	..s Status=$li(str,11)
	..i Status'="A" q
	..s ReasonDr=$li(str,12)
	..s Remark=$li(str,13)
	..s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	..s ChkDT=$zd(ChkDate,3)_" "_$zt(ChkTime,1)
	..///
	..s CrtUserName=""
	..i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	..s ChkUserName=""
	..i $l(ChkUser),$d(^lab.DHCCTUserD(ChkUser)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUser),3)
	..s OptType=""
	..i $l(OprTypeDr),$d(^lab.DHCCTOperateTypeD(OprTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OprTypeDr),3)
	..s Reason=""
	..i $l(ReasonDr),$d(^lab.DHCCTReasonD(ReasonDr)) s Reason=$li(^lab.DHCCTReasonD(ReasonDr),2)
	..d OutputCheck			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheck
	set Data=$lb(id,StockOutNo,CrtDT,CrtUserName,ChkDT,ChkUserName,OptType,Reason,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCheckedCancelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCheckedCancelExecute ]
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
/// CreatDate：    20100601
/// Description:： 已审核的出库库单查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryCheckedCancel(Depart As %String, DateFrom As %String, DateTo As %String, CheckUser As %String) As %Query(ROWSPEC = "StockOutID:%String,StockOutNo:%String,CreateDT:%String,CreateUser:%String,CheckDT:%String,CheckUser:%String,OperateType:%String,Reason:%String,Remark:%String")
{
}

ClassMethod QryCancelByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCancelByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCancelByIdExecute(ByRef qHandle As %Binary, StockOutNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	s StkOutNo=$c(32)_$zcvt($g(StockOutNo),"U")
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockOutI("MasterIndex"
	s id="" f  s id=$o(^lab.DHCREAGStockOutI("MasterIndex",StkOutNo,id)) q:id=""  d
	.i '$d(^lab.DHCREAGStockOutD(id)) q
	.s str=$g(^lab.DHCREAGStockOutD(id))
	.s StockOutNo=$li(str,2)
	.s OprTypeDr=$li(str,3)
	.i OprTypeDr'="4" q //4:退货
	.s CrtDate=$li(str,5)
	.s CrtTime=$li(str,6)
	.s CrtUser=$li(str,7)
	.s ChkDate=$li(str,8)
	.s ChkTime=$li(str,9)
	.s ChkUser=$li(str,10)
	.s Status=$li(str,11)
	.i Status'="A" q
	.s ReasonDr=$li(str,12)
	.s Remark=$li(str,13)
	.s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	.s ChkDT=$zd(ChkDate,3)_" "_$zt(ChkTime,1)
	.///
	.s CrtUserName=""
	.i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	.s ChkUserName=""
	.i $l(ChkUser),$d(^lab.DHCCTUserD(ChkUser)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUser),3)
	.s OptType=""
	.i $l(OprTypeDr),$d(^lab.DHCCTOperateTypeD(OprTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OprTypeDr),3)
	.s Reason=""
	.i $l(ReasonDr),$d(^lab.DHCCTReasonD(ReasonDr)) s Reason=$li(^lab.DHCCTReasonD(ReasonDr),2)
	.d OutputId		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputId
	set Data=$lb(id,StockOutNo,CrtDT,CrtUserName,ChkDT,ChkUserName,OptType,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCancelByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCancelByIdExecute ]
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
/// CreatDate：    20100601
/// Description:： 根据报废单号查询报废单
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryCancelById(StockOutNo As %String) As %Query(ROWSPEC = "StockOutID:%String,StockOutNo:%String,CreateDT:%String,CreateUser:%String,CheckDT:%String,CheckUser:%String,OperateType:%String,Remark:%String,Remark:%String")
{
}

}
