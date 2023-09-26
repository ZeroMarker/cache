/// 试剂接收确认
Class web.DHCREAGReceive Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 120;

/// Creator：      huhm
/// CreatDate：    20100406
/// Description:： 确认试剂入库
/// Table：        DHCREAGStockIn,DHCREAGStockInItem,
/// Input：        入库单ID,用户代码
/// Output：       无
/// Return：       0:成功,非0:不成功
/// Others：       
ClassMethod CheckStockIn(RowID As %String, User As %String) As %String
{
	Set RowID=$Get(RowID),User=$Get(User)
	s ^TMP($zn,"para")=RowID_","_User
	Set chkDate=+$h //$zd(+$h,3)
	Set chkTime=$p($h,",",2) //$zt($p($h,",",2),2)
	Set Stus="A"
	&sql(select Status into :Stus from lab.DHCREAGStockIn where ID=:RowID)
	If Stus="A" Quit "已审核"
	SET $ZTRAP="ErrorHandle",$ECODE=""   //捕获错误开始
	TSTART  //事务开始
	&sql(update lab.DHCREAGStockIn set CheckDate=:chkDate,CheckTime=:chkTime,CheckUserDR=:User,Status='A' where ID=:RowID)
	If SQLCODE Quit $$Rollback("更新审核信息失败:"_SQLCODE)
	Set DepId=$li(^lab.DHCREAGStockInD(RowID),13)
	Set ReveiveNo=$li(^lab.DHCREAGStockInD(RowID),2)
	Set OperateType=$li(^lab.DHCREAGStockInD(RowID),9)
	If '$Length(DepId) Quit "科室为空"
	///计算试剂库存^lab.DHCREAGStockInD(1,"Items",109)
	///("","202","No20100101","M04","61727","62090","10","210.100006103516","","","","0","0","0","","0")>>
	Set RetValue=0 
	Set SubId="" For  Set SubId=$Order(^lab.DHCREAGStockInD(RowID,"RegItem",SubId)) Quit:(SubId="")!(RetValue'=0)  Do
	.Set ItmStr=$g(^(SubId))
	.Set LotNo=$li(ItmStr,3)
	.Set LotIndex=$c(32)_$zcvt(LotNo,"U")
	.Set ReagId=$li(ItmStr,2)
	.Set ProdDate=$li(ItmStr,6)
	.Set ExpDate=$li(ItmStr,7)
	.Set Quan=$li(ItmStr,8)
	.Set Price=$fn(+$li(ItmStr,9),"")
	.Set PositionDr=$li(ItmStr,11)
	.Set Remarks=$li(ItmStr,12)
	.Set LotCnt=$$GetCount(ReagId, LotNo,Price)
	.If '$l(LotCnt) Set LotCnt=1
	.&sql(insert into lab.DHCREAGStockInItems(ParRef,ReagentDR,LotNo,LotCount,ProductDate,ExpireDate,Quantity,Price,PositionDR,Remarks) values(:RowID,:ReagId,:LotNo,:LotCnt,:ProdDate,:ExpDate,:Quan,:Price,:PositionDr,:Remarks))
	.w !,"ret:",SQLCODE
	.Set RetValue=SQLCODE
	.If RetValue Quit
	.Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(DepId,ReagId,"I",LotNo_"||"_LotCnt,Quan,ReveiveNo,User,"",OperateType)
	.//Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(DepId,ReagId,"I",LotNo_"||"_LotCnt,Quan,ReveiveNo,User,"",OperateType,ProdDate,ExpDate,PositionDr,Price)
	/*
	Set SubId="" For  Set SubId=$Order(^lab.DHCREAGStockInD(RowID,"Items",SubId)) Quit:(SubId="")!(RetValue'=0)  Do
	.Set ItmStr=$g(^(SubId))
	.Set LotNo=$li(ItmStr,3)
	.Set ReagId=$li(ItmStr,2)
	.Set ProdDate=$li(ItmStr,5)
	.Set ExpDate=$li(ItmStr,6)
	.Set Quan=$li(ItmStr,7)
	.Set PositionDr=$li(ItmStr,10)
	.Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(DepId,ReagId,"I",LotNo,Quan,ReveiveNo,User,"",OperateType,ProdDate,ExpDate,PositionDr)

	*/	
	/*
	Set ReagId="" For  Set ReagId=$Order(^lab.DHCREAGStockInItemsI("MasterIndex",RowID,ReagId)) Quit:ReagId=""  Do
	.Set 
		Quit:RetValue'=0
		Set Id=$o(^lab.DHCREAGStockInItemsI("MasterIndex",RowID,ReagId,""))
		If $Length(Id){
			Set ItmStr=$g(^lab.DHCREAGStockInD(RowID,"Items",Id))
			Set LotNo=$li(ItmStr,3)
			Set ProdDate=$li(ItmStr,5)
			Set ExpDate=$li(ItmStr,6)
			Set Quan=$li(ItmStr,7)
			Set RetValue=##Class(web.DHCREAGCommon).SaveTransaction(DepId,ReagId,"I",LotNo,Quan,ReveiveNo,User,"",OperateType,ProdDate,ExpDate)
			///&sql(select ID,Quantity into :StkRowId,:StkQuan  from lab.DHCREAGStock where DepartmentDR=:DepId and ReagentDR=:ReagId)
		}
	}
	*/
	If RetValue'=0 Quit $$Rollback(RetValue)
	TCOMMIT
	Quit 0
Rollback(para)
  s para=$g(para)
  TROLLBACK
  s ^TMP($zn,"error")=para
  q "1"_$c(2)_para
  //错误处理
ErrorHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  q $$Rollback(RetMsg)
  //得到批号的对应价格的次编号
GetCount(ReagId, LotIndex,Price)
  s RetCnt=""
  s cnt="" f  s cnt=$o(^lab.DHCREAGStockInItemsI("LotNo",ReagId, LotIndex,cnt)) q:(cnt="")!($l(RetCnt))  d
  .s lotPrice=^(cnt)
  .i lotPrice=Price s RetCnt=cnt
  i '$l(RetCnt) d
  .s RetCnt=$o(^lab.DHCREAGStockInItemsI("LotNo",ReagId, LotIndex,""),-1)+1
  .s ^lab.DHCREAGStockInItemsI("LotNo",ReagId, LotIndex,RetCnt)=Price
  Quit RetCnt
}

ClassMethod TEST(Arg1 As %String) As %String
{
	s seq=""
	s ret=0
	f {
		s seq=$o(^lab.DHCREAGStockInD(seq))
		q:seq=""
		q:ret'=0
		s ord=""
		f {
			s ord=$o(^lab.DHCREAGStockInD(seq,"Items",ord))
			q:ord=""
			i ord="20" s ret=1 q
			w !,seq,",",ord
		}
	}
	quit 0
}

ClassMethod QryUnChkReceiveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnChkReceiveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUnChkReceiveExecute(ByRef qHandle As %Binary, Depart As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//<<$LB("","K0004","N0006","61846","S05","61846","31700","","01","050730013","李力","5000","D01","","","","","","C")>>
	s id="" f  s id=$o(^lab.DHCREAGStockInI("StatusIndex"," C",Depart,id)) q:id=""  d
	.s str=$g(^lab.DHCREAGStockInD(id))
	.s RecNo=$li(str,2)
	.s InvNo=$li(str,3)
	.s InvDate=$li(str,4)
	.s SuppDr=$li(str,5)
	.s CrtDate=$li(str,6)
	.s CrtTime=$li(str,7)
	.s CrtUser=$li(str,8)
	.s OptTypeDr=$li(str,9)
	.s PurUser=$li(str,10)
	.s SendUser=$li(str,11)
	.s TolPrice=$li(str,12)
	.s OrderNo=$li(str,14)
	.s Remark=$li(str,18)
	.s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	.i $l(InvDate) s InvDate=$zd(InvDate,3)
	.///
	.s SuppName=""
	.i $l(SuppDr),$d(^lab.DHCCTSupplierD(SuppDr)) s SuppName=$li(^lab.DHCCTSupplierD(SuppDr),3)
	.s CrtUserName=""
	.i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	.s PurUserName=""
	.i $l(PurUser),$d(^lab.DHCCTUserD(PurUser)) s PurUserName=$li(^lab.DHCCTUserD(PurUser),3)
	.s OptType=""
	.i $l(OptTypeDr),$d(^lab.DHCCTOperateTypeD(OptTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OptTypeDr),3)
	.d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,RecNo,InvNo,InvDate,SuppName,CrtDT,CrtUserName,OptType,PurUserName,SendUser,TolPrice,OrderNo,Remark,SuppDr,PurUser,CrtUser,OptTypeDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryUnChkReceiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnChkReceiveExecute ]
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
/// CreatDate：    20100428
/// Description:： 未审核的入库单查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryUnChkReceive(Depart As %String) As %Query(ROWSPEC = "StkInID:%String,RecNo:%String,InvoiceNo:%String,InvoiceDate:%String,Supplier:%String,CreateDT:%String,CreateUser:%String,OperateType:%String,PurUser:%String,SendUser:%String,TotalPrice:%String,OrderNo:%String,Remark:%String,SuppDr:%String,PurUserDr:%String,CrtUserDr:%String,OptTypeDr:%String")
{
}

ClassMethod QryCheckedReceiveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCheckedReceiveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCheckedReceiveExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, Supplier As %String, PurUsr As %String, SendUsr As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s Supplier=$g(Supplier),PurUsr=$g(PurUsr),SendUsr=$g(SendUsr)
 	s ^TMP($ZN,"PARA",2)=Depart_","_DateFrom_","_DateTo_","_Supplier_","_PurUsr_","_SendUsr
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInI("CheckDateIndex","D01",61851,46)=
	f Date=DateFrom:1:DateTo d
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("CheckDateIndex",Depart,Date,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockInD(id))
	..s RecNo=$li(str,2)
	..s InvNo=$li(str,3)
	..s InvDate=$li(str,4)
	..s SuppDr=$li(str,5)
	..i $l(Supplier),Supplier'=SuppDr q
	..s CrtDate=$li(str,6)
	..s CrtTime=$li(str,7)
	..s CrtUser=$li(str,8)
	..s OptTypeDr=$li(str,9)
	..s PurUser=$li(str,10)
	..i $l(PurUsr),PurUsr'=PurUser q
	..s SendUser=$li(str,11)
	..s send1=$c(2)_SendUsr,send2=$c(2)_SendUser
	..i $l(SendUsr),(send2'[send1) q
	..s TolPrice=$li(str,12)
	..s OrderNo=$li(str,14)
	..s ChkTime=$li(str,16)
	..s ChkUser=$li(str,17)
	..s Remark=$li(str,18)
	..s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	..i $l(InvDate) s InvDate=$zd(InvDate,3)
	..i $l(ChkTime) s ChkTime=$zt(ChkTime,1)
	..s ChkDT=$zd(Date,3)_" "_ChkTime
	..///
	..s SuppName=""
	..i $l(SuppDr),$d(^lab.DHCCTSupplierD(SuppDr)) s SuppName=$li(^lab.DHCCTSupplierD(SuppDr),3)
	..s CrtUserName=""
	..i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	..s PurUserName=""
	..i $l(PurUser),$d(^lab.DHCCTUserD(PurUser)) s PurUserName=$li(^lab.DHCCTUserD(PurUser),3)
	..s OptType=""
	..i $l(OptTypeDr),$d(^lab.DHCCTOperateTypeD(OptTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OptTypeDr),3)
	..s ChkUserName=""
	..i $l(ChkUser),$d(^lab.DHCCTUserD(ChkUser)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUser),3)
	..d OutputCheck			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCheck
	set Data=$lb(id,RecNo,InvNo,InvDate,SuppName,CrtDT,CrtUserName,OptType,PurUserName,SendUser,TolPrice,OrderNo,ChkDT,ChkUserName,Remark,SuppDr,PurUser,CrtUser,OptTypeDr,ChkUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryCheckedReceiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCheckedReceiveExecute ]
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
Query QryCheckedReceive(Depart As %String, DateFrom As %String, DateTo As %String, Supplier As %String, PurUsr As %String, SendUsr As %String) As %Query(ROWSPEC = "StkInNo:%String,RecNo:%String,InvoiceNo:%String,InvoiceDate:%String,Supplier:%String,CreateDT:%String,CreateUser:%String,OperateType:%String,PurUser:%String,SendUser:%String,TotalPrice:%String,OrderNo:%String,CheckDT:%String,CheckUser:%String,Remark:%String,SuppDr:%String,PurUserDr:%String,CrtUserDr:%String,OptTypeDr:%String,ChkUserDr:%String")
{
}

ClassMethod QryStockInByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStockInByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStockInByIdExecute(ByRef qHandle As %Binary, StockInNo As %String, InvoiceNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	s StockInNo=$g(StockInNo),InvoiceNo=$g(InvoiceNo)
	If $g(ind)="" Set ind=1
	k ^TMP($zn,$j)
	//^lab.DHCREAGStockInI("InvoiceNoIndex"," 1234567890",8)=
	i $l(InvoiceNo) d
	.s InvNo=$c(32)_$zcvt(InvoiceNo,"U")
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("InvoiceNoIndex",InvNo,id)) q:id=""  d
	..i '$d(^lab.DHCREAGStockInD(id)) q
	..s RecNo=$li(^lab.DHCREAGStockInD(id),2)
	..i '$l(RecNo) q
	..s ^TMP($zn,$j,RecNo,id)=""
	i $l(StockInNo) d
	.s StkInNo=$c(32)_$zcvt(StockInNo,"U")
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("MasterIndex",StkInNo,id)) q:id=""  d
	..i '$d(^lab.DHCREAGStockInD(id)) q
	..s RecNo=$li(^lab.DHCREAGStockInD(id),2)
	..i '$l(RecNo) q
	..s ^TMP($zn,$j,RecNo,id)=""
	s RecNo="" f  s RecNo=$o(^TMP($zn,$j,RecNo)) q:RecNo=""  d
	.s id="" f  s id=$o(^TMP($zn,$j,RecNo,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockInD(id))
	..s RecNo=$li(str,2)
	..s InvNo=$li(str,3)
	..s InvDate=$li(str,4)
	..s SuppDr=$li(str,5)
	..s CrtDate=$li(str,6)
	..s CrtTime=$li(str,7)
	..s CrtUser=$li(str,8)
	..s OptTypeDr=$li(str,9)
	..s PurUser=$li(str,10)
	..s SendUser=$li(str,11)
	..s TolPrice=$li(str,12)
	..s OrderNo=$li(str,14)
	..s ChkDate=$li(str,15)
	..s ChkTime=$li(str,16)
	..s ChkUser=$li(str,17)
	..s Remark=$li(str,18)
	..s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	..i $l(InvDate) s InvDate=$zd(InvDate,3)
	..i $l(ChkTime) s ChkTime=$zt(ChkTime,1)
	..s ChkDT=$zd(ChkDate,3)_" "_ChkTime
	..///
	..s SuppName=""
	..i $l(SuppDr),$d(^lab.DHCCTSupplierD(SuppDr)) s SuppName=$li(^lab.DHCCTSupplierD(SuppDr),3)
	..s CrtUserName=""
	..i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	..s PurUserName=""
	..i $l(PurUser),$d(^lab.DHCCTUserD(PurUser)) s PurUserName=$li(^lab.DHCCTUserD(PurUser),3)
	..s OptType=""
	..i $l(OptTypeDr),$d(^lab.DHCCTOperateTypeD(OptTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OptTypeDr),3)
	..s ChkUserName=""
	..i $l(ChkUser),$d(^lab.DHCCTUserD(ChkUser)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUser),3)
	..d OutputId		
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,$j)
	Quit $$$OK
OutputId
	set Data=$lb(id,RecNo,InvNo,InvDate,SuppName,CrtDT,CrtUserName,OptType,PurUserName,SendUser,TolPrice,OrderNo,ChkDT,ChkUserName,Remark,SuppDr,PurUser,CrtUser,OptTypeDr,ChkUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryStockInByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStockInByIdExecute ]
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
/// CreatDate：    20100612
/// Description:： 根据入库单号查询出库单
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryStockInById(StockInNo As %String, InvoiceNo As %String) As %Query(ROWSPEC = "StkInNo:%String,RecNo:%String,InvoiceNo:%String,InvoiceDate:%String,Supplier:%String,CreateDT:%String,CreateUser:%String,OperateType:%String,PurUser:%String,SendUser:%String,TotalPrice:%String,OrderNo:%String,CheckDT:%String,CheckUser:%String,Remark:%String,SuppDr:%String,PurUserDr:%String,CrtUserDr:%String,OptTypeDr:%String,ChkUserDr:%String")
{
}

}
