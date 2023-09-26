/// 体检项目流水记录
Class web.DHCPE.ItemDetailRecord Extends (%RegisteredObject, %XML.Adaptor)
{

/// 插入一个项目
/// web.DHCPE.PreItemList.StopOEORI调用
ClassMethod Insert(OEID, Type, UserID, Date As %String = "")
{
	s $ZT="DetailRecordInsertErr"
	s:Date="" Date=+$H
	s Time=$P($H,",",2)
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	s PAADM=$p(^OEORD(+OEID),"^",1)
	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" "0"
	s Status=$P(^DHCPEIADM(IADM),"^",8)
	q:Status'="ARRIVED" 0
	&SQL(insert into Sqluser.DHC_PE_ItemDetailRecord (IDR_OEORI_DR,IDR_Type,IDR_Date,IDR_Time,IDR_User_DR) values (:OEID,:Type,:Date,:Time,:UserID))
	i SQLCODE'=0 d
	.s ^DHCPEDateEx("ItemDetailRecord","Err",OEID,Type)=UserID_"^"_$H
	q SQLCODE
DetailRecordInsertErr
	q 0
}

/// 到达时调用、确认加项时调用
/// web.DHCPE.DHCPEIAdm.IAdmArrived
/// web.DHCPE.TransAdmInfo.ConfirmAddOrdItem
ClassMethod InsertByAdm(PAADM, UserID, OldSub As %String = "0", Date As %String = "")
{
	s $ZT="DetailRecordErr"
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" 0
	s Status=$P(^DHCPEIADM(IADM),"^",8)
	q:Status'="ARRIVED" 0
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	f  s OldSub=$O(^OEORD(OrderID,"I",OldSub)) q:OldSub=""  d
	.s Stat=$p($G(^OEORD(OrderID,"I",OldSub,1)),"^",13)
	.q:Stat="4"
	.s OrderItemID=OrderID_"||"_OldSub
	.s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OrderItemID,0))
	.q:CrmOrderID=""
	.d ..Insert(OrderItemID,"A",UserID,Date)
	q 0
DetailRecordErr
	q "-1"
}

/// 取消到达时调用
/// web.DHCPE.DHCPEIAdm.IAdmArrived
ClassMethod InsertDByAdm(PAADM, UserID, OldSub As %String = "0", Date As %String = "")
{
	s $ZT="DetailRecordErr"
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" 0
	s Status=$P(^DHCPEIADM(IADM),"^",8)
	q:Status'="REGISTERED" 0
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	f  s OldSub=$O(^OEORD(OrderID,"I",OldSub)) q:OldSub=""  d
	.s Stat=$p($G(^OEORD(OrderID,"I",OldSub,1)),"^",13)
	.q:Stat="4"
	.s OrderItemID=OrderID_"||"_OldSub
	.s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OrderItemID,0))
	.q:CrmOrderID=""
	.
	.d ..Insert(OrderItemID,"D",UserID,Date)
	q 0
DetailRecordErr
	q "-1"
}

/// d ##class(web.DHCPE.ItemDetailRecord).OldImport("","",1)
ClassMethod OldImport(StartDate, EndDate, UserID)
{
	s:StartDate[("-") StartDate=$ZDH(StartDate,3)
 	s:EndDate[("-") EndDate=$ZDH(EndDate,3)
 	s:StartDate[("/") StartDate=$ZDH(StartDate,4)
 	s:EndDate[("/") EndDate=$ZDH(EndDate,4)
 	s:StartDate="" StartDate=1
 	s:EndDate="" EndDate=+$H
 	s Date=StartDate-1
 	f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date)) q:Date=""  d
 	.q:$D(^DHCPEDateEx("ItemDetailRecord","OldImport",Date))
 	.s ^DHCPEDateEx("ItemDetailRecord","OldImport",Date)=""
 	.s Time=""
 	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:Time=""  d
 	..s AdmID=0
 	..f  s AdmID=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,AdmID)) q:AdmID=""  d
 	...s Status=$P(^DHCPEIADM(AdmID),"^",8)
	...q:Status'="ARRIVED"
	...s PAADM=$P(^DHCPEIADM(AdmID),"^",1)
	...d ..InsertByAdm(PAADM, UserID, 0,Date)
}

Query FindItemDetail(StartDate As %Library.String = "", EndDate As %String = "", RecLocID As %String = "", ItemMastID As %String = "", LocID As %String = "") As %Query(ROWSPEC = "OrderDepart:%String,DepartDesc:%String,RecLoc:%String,LocDesc:%String,ArcItem:%String,ArcItemDesc:%String,Acount:%Float,ItemCount:%Float") [ SqlProc ]
{
}

ClassMethod FindItemDetailExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %String = "", RecLocID As %String = "", ItemMastID As %String = "", LocID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.ItemDetailRecord", "FindItemDetail","2014-11-30","2014-12-30","","","")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s:LocID="" LocID=session.Get("LOGON.CTLOCID")
 	i (StartDate="")&&(EndDate="") d
	.s EndDate=+$H
	.s StartDate=+$H
	s:StartDate="" StartDate=1
 	s:EndDate="" EndDate=+$H
 	s:StartDate[("-") StartDate=$ZDH(StartDate,3)
 	s:EndDate[("-") EndDate=$ZDH(EndDate,3)
 	s:StartDate[("/") StartDate=$ZDH(StartDate,4)
 	s:EndDate[("/") EndDate=$ZDH(EndDate,4)
 	s Job=$J
 	k ^TempDHCPEItemDetailRecord(Job)
 	s Date=StartDate-1
 	f  s Date=$O(^User.DHCPEItemDetailRecordI("IDRDateIndex",Date)) q:(Date="")||(Date>EndDate)  d
 	.s ID=""
 	.f  s ID=$O(^User.DHCPEItemDetailRecordI("IDRDateIndex",Date,ID)) q:(ID="")  d
 	..s OEID=$LG(^User.DHCPEItemDetailRecordD(ID),2)
 	..s Type=$LG(^User.DHCPEItemDetailRecordD(ID),3)
 	..s Flag=1
 	..s:Type="D" Flag=-1
 	..s OEORD=+OEID
 	..s OESub=$P(OEID,"||",2)
 	..s ArcItemID=$P(^OEORD(OEORD,"I",OESub,1),"^",2)
 	..q:(ItemMastID'="")&&(ItemMastID'=ArcItemID)
 	..s OrderDepart=$P(^OEORD(OEORD,"I",OESub,1),"^",3)
 	..q:(LocID'="")&&(LocID'=OrderDepart)
 	..s RLoc=$P(^OEORD(OEORD,"I",OESub,3),"^",6)
 	..q:(RecLocID'="")&&(RecLocID'=RLoc)
 	..s CrmOrderID=$O(^DHCPECRMO(0,"OEORI",OEID,0))
 	..q:CrmOrderID=""
 	..s PreItemID=$P(^DHCPECRMO(CrmOrderID),"^",2)
 	..s Acount=$P(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2)),"^",14)
 	..s Acount=$J(Acount,"",2)
 	..s j=+$G(^TempDHCPEItemDetailRecord(Job,OrderDepart,RLoc,ArcItemID,Acount))
 	..s ^TempDHCPEItemDetailRecord(Job,OrderDepart,RLoc,ArcItemID,Acount)=j+Flag
 	s OrderDepart=""
 	f  s OrderDepart=$O(^TempDHCPEItemDetailRecord(Job,OrderDepart)) q:OrderDepart=""  d
 	.s DepartDesc=$P(^CTLOC(OrderDepart),"^",2)
 	.s RecLoc=""
 	.f  s RecLoc=$O(^TempDHCPEItemDetailRecord(Job,OrderDepart,RecLoc)) q:RecLoc=""  d
 	..s RecLocDesc=$P(^CTLOC(RecLoc),"^",2)
 	..s ArcItem=""
 	..f  s ArcItem=$O(^TempDHCPEItemDetailRecord(Job,OrderDepart,RecLoc,ArcItem)) q:ArcItem=""  d
 	...s ArcItemDesc=$P(^ARCIM(+ArcItem,1,1),"^",2)
 	...s Acount=""
 	...f  s Acount=$O(^TempDHCPEItemDetailRecord(Job,OrderDepart,RecLoc,ArcItem,Acount)) q:Acount=""  d
 	....s ItemCount=$G(^TempDHCPEItemDetailRecord(Job,OrderDepart,RecLoc,ArcItem,Acount))
 	....q:ItemCount=0
 	....d FindItemDetailBuild
 	k ^TempDHCPEItemDetailRecord(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindItemDetailBuild 
	set Data=$lb(OrderDepart,DepartDesc,RecLoc,RecLocDesc,ArcItem,ArcItemDesc,Acount,ItemCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindItemDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindItemDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ReBuildIndex()
{
	s obj=##class(User.DHCPEItemDetailRecord).%BuildIndices()
}

}
