Class web.DHCREAGInvoice Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

ClassMethod QryInvoiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInvoiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInvoiceExecute(ByRef qHandle As %Binary, Depart As %String, DateFrom As %String, DateTo As %String, SuppId As %String, SendUser As %String) As %Status
{
	s Depart=$g(Depart)
 	Set repid=$I(^CacheTemp)
 	s DateFrom=$zdh(DateFrom,3)
 	s DateTo=$zdh(DateTo,3)
 	s ^TMPDATE=DateFrom_","_DateTo
	If $g(ind)="" Set ind=1
	//^lab.DHCREAGStockInI("InvoiceDateIndex",61821,"D01",60)=
	s Date=DateFrom-1 f  s Date=$o(^lab.DHCREAGStockInI("InvoiceDateIndex",Date)) q:(Date=(DateTo+1))!(Date="")  d
	.s id="" f  s id=$o(^lab.DHCREAGStockInI("InvoiceDateIndex",Date,Depart,id)) q:id=""  d
	..s str=$g(^lab.DHCREAGStockInD(id))
	..s SuppDr=$li(str,5)
	..i $l(SuppId),SuppId'=SuppDr q
	..s SendUsr=$li(str,11)
	..//i SendUser'=SendUsr q
	..s send1=$c(2)_SendUsr,send2=$c(2)_SendUser
	..i $l(SendUser),(send1'[send2) q
	..s Stus=$li(str,18)
	..s ChkStus=Stus
	..i Stus="C" s ChkStus="未审核"
	..i Stus="A" s ChkStus="已审核"
	..s RecNo=$li(str,2)
	..s InvNo=$li(str,3)
	..s InvDate=$li(str,4)
	..//
	..s CrtDate=$li(str,6)
	..s CrtTime=$li(str,7)
	..s CrtUser=$li(str,8)
	..s OptTypeDr=$li(str,9)
	..s PurUser=$li(str,10)
	..//
	..s TolPrice=$li(str,12)
	..s OrderNo=$li(str,14)
	..s ChkDate=$li(str,6)
	..s ChkTime=$li(str,7)
	..s ChkUser=$li(str,8)
	..s Remark=$li(str,18)
	..s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	..i $l(InvDate) s InvDate=$zd(InvDate,3)
	..s ChkDT=""
	..i $l(ChkDate),$l(ChkTime) s ChkDT=$zd(ChkDate,3)_" "_$zt(ChkTime,1)
	..///
	..s SuppName=""
	..i $l(SuppDr),$d(^lab.DHCCTSupplierD(SuppDr)) s SuppName=$li(^lab.DHCCTSupplierD(SuppDr),3)
	..s CrtUserName=""
	..i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	..s ChkUserName=""
	..i $l(ChkUser),$d(^lab.DHCCTUserD(ChkUser)) s ChkUserName=$li(^lab.DHCCTUserD(ChkUser),3)
	..s PurUserName=""
	..i $l(PurUser),$d(^lab.DHCCTUserD(PurUser)) s PurUserName=$li(^lab.DHCCTUserD(PurUser),3)
	..s OptType=""
	..i $l(OptTypeDr),$d(^lab.DHCCTOperateTypeD(OptTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OptTypeDr),3)
	..d OutputRow			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,RecNo,InvNo,TolPrice,InvDate,SuppName,CrtDT,CrtUserName,OptType,PurUserName,SendUsr,OrderNo,Remark,SuppDr,PurUser,CrtUser,OptTypeDr,ChkStus,ChkDT,ChkUserName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryInvoiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInvoiceExecute ]
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
/// Description:： 发票查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryInvoice(Depart As %String, DateFrom As %String, DateTo As %String, SuppId As %String, SendUser As %String) As %Query(ROWSPEC = "StkInID:%String,RecNo:%String,InvoiceNo:%String,TotalPrice:%String,InvoiceDate:%String,Supplier:%String,CreateDT:%String,CreateUser:%String,OperateType:%String,PurUser:%String,SendUser:%String,OrderNo:%String,Remark:%String,SuppDr:%String,PurUserDr:%String,CrtUserDr:%String,OptTypeDr:%String,Status:%String,CheckDT:%String,CheckUser:%String")
{
}

ClassMethod QryInvocByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInvocByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInvocByIdExecute(ByRef qHandle As %Binary, StockInNo As %String, InvoiceNo As %String) As %Status
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
	..s SuppDr=$li(str,5)
	..s SendUser=$li(str,11)
	..s Stus=$li(str,19)
	..s ChkStus=Stus
	..i Stus="C" s ChkStus="未审核"
	..i Stus="A" s ChkStus="已审核"
	..s RecNo=$li(str,2)
	..s InvNo=$li(str,3)
	..s InvDate=$li(str,4)
	..//
	..s CrtDate=$li(str,6)
	..s CrtTime=$li(str,7)
	..s CrtUser=$li(str,8)
	..s OptTypeDr=$li(str,9)
	..s PurUser=$li(str,10)
	..//
	..s TolPrice=$li(str,12)
	..s OrderNo=$li(str,14)
	..s Remark=$li(str,18)
	..s CrtDT=$zd(CrtDate,3)_" "_$zt(CrtTime,1)
	..i $l(InvDate) s InvDate=$zd(InvDate,3)
	..///
	..s SuppName=""
	..i $l(SuppDr),$d(^lab.DHCCTSupplierD(SuppDr)) s SuppName=$li(^lab.DHCCTSupplierD(SuppDr),3)
	..s CrtUserName=""
	..i $l(CrtUser),$d(^lab.DHCCTUserD(CrtUser)) s CrtUserName=$li(^lab.DHCCTUserD(CrtUser),3)
	..s PurUserName=""
	..i $l(PurUser),$d(^lab.DHCCTUserD(PurUser)) s PurUserName=$li(^lab.DHCCTUserD(PurUser),3)
	..s OptType=""
	..i $l(OptTypeDr),$d(^lab.DHCCTOperateTypeD(OptTypeDr)) s OptType=$li(^lab.DHCCTOperateTypeD(OptTypeDr),3)
	..d OutputId		
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,$j)
	Quit $$$OK
OutputId
	set Data=$lb(id,RecNo,InvNo,TolPrice,InvDate,SuppName,CrtDT,CrtUserName,OptType,PurUserName,SendUser,OrderNo,Remark,SuppDr,PurUser,CrtUser,OptTypeDr,ChkStus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryInvocByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInvocByIdExecute ]
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
/// Description:： 根据发票号或入库单号查询入库单
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QryInvocById(StockInNo As %String, InvoiceNo As %String) As %Query(ROWSPEC = "StkInID:%String,RecNo:%String,InvoiceNo:%String,TotalPrice:%String,InvoiceDate:%String,Supplier:%String,CreateDT:%String,CreateUser:%String,OperateType:%String,PurUser:%String,SendUser:%String,OrderNo:%String,Remark:%String,SuppDr:%String,PurUserDr:%String,CrtUserDr:%String,OptTypeDr:%String,Status:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20100722
/// Description:： 根据发票号查询发票信息
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod GetInvoice(InvoiceNo As %String) As %String
{
	s InvoiceNo=$g(InvoiceNo)
	s InvNo=$c(32)_$zcvt(InvoiceNo,"U")
	s id=$o(^lab.DHCREAGStockInI("InvoiceNoIndex",InvNo,""),-1)
	i '$l(id) q ""
	i '$d(^lab.DHCREAGStockInD(id)) q ""
	s InvDate=$li(^lab.DHCREAGStockInD(id),4)
	i $l(InvDate) s InvDate=$zd(InvDate,3)
	s InvPrice=$li(^lab.DHCREAGStockInD(id),12)
	q InvDate_$c(2)_InvPrice
}

}
