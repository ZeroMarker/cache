/// 试剂库存转移
Class web.DHCREAGTransfer Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 133;

/// Creator：      huhm
/// CreatDate：    20100406
/// Description:： 确认库存转移
/// Table：        
/// Input：        转移单ID,用户代码
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others：       
ClassMethod CheckStockTransfer(RowID As %String, User As %String) As %String
{
	s ^TMP($zn,"SaveTrans","para")=RowID_","_User
	Set RowID=$Get(RowID),User=$Get(User)
	Set chkDate=+$h //$zd(+$h,3)
	Set chkTime=$p($h,",",2) //$zt($p($h,",",2),2)
	Set Stus="A"
	&sql(select Status into :Stus from lab.DHCREAGTransfer where ID=:RowID)
	If SQLCODE=100 Quit "领用单不存在"
	If Stus="A" Quit "已审核"
	Set TransNo=$li(^lab.DHCREAGTransferD(RowID),2)
	Set ToDepId=$li(^lab.DHCREAGTransferD(RowID),3)
	Set FromDepId=$li(^lab.DHCREAGTransferD(RowID),4)
	Set OperateType=$li(^lab.DHCREAGTransferD(RowID),5)
	If '$Length(ToDepId) Quit "接收科室为空"
	SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	&sql(update lab.DHCREAGTransfer set CheckDate=:chkDate,CheckTime=:chkTime,CheckUserDR=:User,Status='A' where ID=:RowID)
	If SQLCODE Quit $$Rollback("更新审核信息失败:"_SQLCODE)
	Set RetValue=0
	///计算试剂接收科室库存
	///^lab.DHCREAGTransferItemsI("MasterIndex",38,202," P90000",30)=
	Set ReagId="" For  Set ReagId=$Order(^lab.DHCREAGTransferItemsI("MasterIndex",RowID,ReagId)) Quit:(ReagId="")!(RetValue'=0)  Do
	.Set lot="" For  Set lot=$Order(^lab.DHCREAGTransferItemsI("MasterIndex",RowID,ReagId,lot)) Quit:(lot="")!(RetValue'=0)  Do
	..Set LotCnt="" For  Set LotCnt=$Order(^lab.DHCREAGTransferItemsI("MasterIndex",RowID,ReagId,lot,LotCnt)) q:(LotCnt="")!(RetValue'=0)  Do
	...Set SubId="" For  Set SubId=$o(^lab.DHCREAGTransferItemsI("MasterIndex",RowID,ReagId,lot,LotCnt,SubId)) Quit:(SubId="")!(RetValue'=0)  Do
	....If '$Data(^lab.DHCREAGTransferD(RowID,"Items",SubId)) Quit
	....Set ItmStr=$g(^lab.DHCREAGTransferD(RowID,"Items",SubId))
	....Set LotNo=$li(ItmStr,3)
	....Set LotCnt=$li(ItmStr,4)
	....Set PrtDate=$li(ItmStr,6)
	....Set ExpDate=$li(ItmStr,7)
	....Set Quan=$li(ItmStr,8)
	....Set Price=$li(ItmStr,9)
	....Set PosDr=$li(ItmStr,11)
	....//Set StkQuan=0
	....//s ^TMP($zn,"SaveTrans",ReagId)=RowID_"||"_SubId_":"_ToDepId_","_ReagId_","_LotNo_"||"_LotCnt_","_Quan_","_TransNo_","_User_","_FromDepId_","_OperateType_","_PrtDate_","_ExpDate_","_PosDr_","_Price
	....///DepId, ReagId , Module , LotNo, Quan , TransNo, User, FromDepId , OpType
	....Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(ToDepId,ReagId,"T",LotNo_"||"_LotCnt,Quan,TransNo,User,FromDepId,OperateType)
	....//Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(ToDepId,ReagId,"T",LotNo_"||"_LotCnt,Quan,TransNo,User,FromDepId,OperateType,PrtDate,ExpDate,PosDr,Price)
	If RetValue'=0 Quit $$Rollback(RetValue)
	TCOMMIT
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

ClassMethod QryUnChkTransferClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnChkTransferExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUnChkTransferExecute(ByRef qHandle As %Binary, Depart As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGTransferI("StatusIndex"
	//<<$LB("","LY2010050019","D02","D01","03","61857","56084","demo","","","","C","610009","","")>>
	s id="" f  s id=$o(^lab.DHCREAGTransferI("StatusIndex"," C",Depart,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGTransferD(id))
	.s TransNo=$li(str,2)
	.s FromDepDr=$li(str,4)
	.s ToDepDr=$li(str,3)
	.s OprTypeDr=$li(str,5)
	.s CrtDate=$li(str,6)
	.s CrtTime=$li(str,7)
	.s CrtUser=$li(str,8)
	.s TakeUserDr=$li(str,13)
	.s RequestId=$li(str,14)
	.s RequestNo=""
	.i $l(RequestId) s RequestNo=$li(^lab.DHCREAGRequestD(RequestId),2)
	.s Remark=$li(str,15)
	.s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	.///
	.s FromDepName=""
	.i $l(FromDepDr),$d(^lab.DHCCTDepartmentD(FromDepDr)) s FromDepName=$li(^lab.DHCCTDepartmentD(FromDepDr),3)
	.s ToDepName=""
	.i $l(ToDepDr),$d(^lab.DHCCTDepartmentD(ToDepDr)) s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
	.s CrtUserName=""
	.i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	.s TakeUserName=""
	.i $l(TakeUserDr),$d(^lab.DHCCTUserD(TakeUserDr)) s TakeUserName=$li(^lab.DHCCTUserD(TakeUserDr),3)
	.s OptType=""
	.i $l(OprTypeDr),$d(^lab.DHCCTOperateTypeD(OprTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OprTypeDr),3)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,TransNo,ToDepName,FromDepName,CrtDT,CrtUserName,OptType,TakeUserName,RequestNo,Remark,ToDepDr,FromDepDr,CrtUser,TakeUserDr,OprTypeDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryUnChkTransferFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnChkTransferExecute ]
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
/// CreatDate：    20100511
/// Description:： 未审核的领用单查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryUnChkTransfer(Depart As %String) As %Query(ROWSPEC = "TranferID:%String,TransNo:%String,ToDepart:%String,FromDepart:%String,CreateDT:%String,CreateUser:%String,OperateType:%String,TakeUser:%String,RequestNo:%String,Remark:%String,ToDepartDr:%String,FromDepartDr:%String,CrtUserDr:%String,TakeUserDr:%String,OptTypeDr:%String")
{
}

ClassMethod QrycheckedTransferClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrycheckedTransferExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrycheckedTransferExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, ToDepart As %String, TakeUser As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s ToDepart=$g(ToDepart)
 	s TakeUser=$g(TakeUser)
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGTransferI("CheckDateIndex","D01",61860,38)=
	f Date=DateFrom:1:DateTo d
	.s id="" f  s id=$o(^lab.DHCREAGTransferI("CheckDateIndex",Depart,Date,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGTransferD(id))
	..s TransNo=$li(str,2)
	..s FromDepDr=$li(str,4)
	..s ToDepDr=$li(str,3)
	..i $l(ToDepart),ToDepart'=ToDepDr q
	..s OprTypeDr=$li(str,5)
	..s CrtDate=$li(str,6)
	..s CrtTime=$li(str,7)
	..s CrtUser=$li(str,8)
	..s ChkDate=$li(str,9)
	..s ChkTime=$li(str,10)
	..s ChkUser=$li(str,11)
	..s TakeUserDr=$li(str,13)
	..i $l(TakeUser),TakeUser'=TakeUserDr q
	..s RequestId=$li(str,14)
	..s RequestNo=""
	..i $l(RequestId) s RequestNo=$li(^lab.DHCREAGRequestD(RequestId),2)
	..s Remark=$li(str,15)
	..s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	..s ChkDT=$zd(ChkDate,3)_" "_$zt(ChkTime,1)
	..///
	..s FromDepName=""
	..i $l(FromDepDr),$d(^lab.DHCCTDepartmentD(FromDepDr)) s FromDepName=$li(^lab.DHCCTDepartmentD(FromDepDr),3)
	..s ToDepName=""
	..i $l(ToDepDr),$d(^lab.DHCCTDepartmentD(ToDepDr)) s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
	..s CrtUserName=""
	..i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	..s ChkUserName=""
	..i $l(ChkUser),$d(^lab.DHCCTUserD(ChkUser)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUser),3)
	..s TakeUserName=""
	..i $l(TakeUserDr),$d(^lab.DHCCTUserD(TakeUserDr)) s TakeUserName=$li(^lab.DHCCTUserD(TakeUserDr),3)
	..s OptType=""
	..i $l(OprTypeDr),$d(^lab.DHCCTOperateTypeD(OprTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OprTypeDr),3)
	..d OutputCheck			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheck
	set Data=$lb(id,TransNo,ToDepName,FromDepName,TakeUserName,OptType,CrtDT,CrtUserName,ChkDT,ChkUserName,RequestNo,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QrycheckedTransferFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrycheckedTransferExecute ]
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
/// CreatDate：    20100507
/// Description:： 已审核的入库单查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QrycheckedTransfer(Depart As %String, DateFrom As %String, DateTo As %String, ToDepart As %String, TakeUser As %String) As %Query(ROWSPEC = "TranferID:%String,TransNo:%String,ToDepart:%String,FromDepart:%String,TakeUser:%String,OperateType:%String,CreateDT:%String,CreateUser:%String,CheckDT:%String,CheckUser:%String,RequestNo:%String,Remark:%String")
{
}

ClassMethod QryTransferByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTransferByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTransferByIdExecute(ByRef qHandle As %Binary, TransNo As %String, RequestNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	s TransNo=$g(TransNo)
 	s RequestNo=$g(RequestNo)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	i $l(TransNo) d
	.s id="" f  s id=$o(^lab.DHCREAGTransferI("MasterIndex",$c(32)_TransNo,id)) q:id=""  d
	..s ^TMP($zn,$j,id)=""
	i $l(RequestNo) d
	.s ReqId="" f  s ReqId=$o(^lab.DHCREAGRequestI("MasterIndex"," "_RequestNo,ReqId)) q:ReqId=""  d
	..s TransId="" f  s TransId=$o(^lab.DHCREAGTransferI("RequestNoIndex",ReqId,TransId)) q:TransId=""  d
	...s ^TMP($zn,$j,TransId)=""
	//i $l(RequestNo) 
	//^lab.DHCREAGTransferI("CheckDateIndex","D01",61860,38)=
	s id="" f  s id=$o(^TMP($zn,$j,id)) q:id=""  d
	.i '$d(^lab.DHCREAGTransferD(id)) q
	.s str=$g(^lab.DHCREAGTransferD(id))
	.s TransNo=$li(str,2)
	.s FromDepDr=$li(str,4)
	.s ToDepDr=$li(str,3)
	.s OprTypeDr=$li(str,5)
	.s CrtDate=$li(str,6)
	.s CrtTime=$li(str,7)
	.s CrtUser=$li(str,8)
	.s ChkDate=$li(str,9)
	.s ChkTime=$li(str,10)
	.s ChkUser=$li(str,11)
	.s status=$li(str,12)
	.i status'="A" q
	.s TakeUserDr=$li(str,13)
	.s RequestId=$li(str,14)
	.s RequestNo=""
	.i $l(RequestId) s RequestNo=$li(^lab.DHCREAGRequestD(RequestId),2)
	.s Remark=$li(str,15)
	.s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	.s ChkDT=$zd(ChkDate,3)_" "_$zt(ChkTime,1)
	.///
	.s FromDepName=""
	.i $l(FromDepDr),$d(^lab.DHCCTDepartmentD(FromDepDr)) s FromDepName=$li(^lab.DHCCTDepartmentD(FromDepDr),3)
	.s ToDepName=""
	.i $l(ToDepDr),$d(^lab.DHCCTDepartmentD(ToDepDr)) s ToDepName=$li(^lab.DHCCTDepartmentD(ToDepDr),3)
	.s CrtUserName=""
	.i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	.s ChkUserName=""
	.i $l(ChkUser),$d(^lab.DHCCTUserD(ChkUser)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUser),3)
	.s TakeUserName=""
	.i $l(TakeUserDr),$d(^lab.DHCCTUserD(TakeUserDr)) s TakeUserName=$li(^lab.DHCCTUserD(TakeUserDr),3)
	.s OptType=""
	.i $l(OprTypeDr),$d(^lab.DHCCTOperateTypeD(OprTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OprTypeDr),3)
	.d OutputId			
	k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputId
	set Data=$lb(id,TransNo,ToDepName,FromDepName,TakeUserName,OptType,CrtDT,CrtUserName,ChkDT,ChkUserName,RequestNo,Remark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryTransferByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTransferByIdExecute ]
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
/// CreatDate：    20100507
/// Description:： 已审核的入库单查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryTransferById(TransNo As %String, RequestNo As %String) As %Query(ROWSPEC = "TranferID:%String,TransNo:%String,ToDepart:%String,FromDepart:%String,TakeUser:%String,OperateType:%String,CreateDT:%String,CreateUser:%String,CheckDT:%String,CheckUser:%String,RequestNo:%String,Remark:%String")
{
}

}
