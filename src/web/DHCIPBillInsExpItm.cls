/// 执行记录附加收费项目
Class web.DHCIPBillInsExpItm Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator   :yyx
/// CreateDate:2012-02-29
/// Funtion   :对执行记录除医嘱与收费项目对应关系外插入附加的收费项目
/// ItmInfo   :数量^单价^折扣价^记账价^自付价^tarirowid^状态(收B,退R)
/// w ##class(web.DHCIPBillInsExpItm).InsOrdExcExpItm()
ClassMethod InsOrdExcExpItm(Adm, OEORE, ItmInfo, BillUser)
{
	
	tstart
	s Error=0
	s AdmBill=0,PBRowID="" ;add
	f  s AdmBill=$o(^DHCPB(0,"ADM",Adm,AdmBill)) q:(AdmBill="")!(PBRowID'="")  d
	.q:$p(^DHCPB(AdmBill),"^",16)="P"
	.s PBRowID=AdmBill
	i PBRowID="" d
	.s PBInsInfo=##class(UDHCJFPB).PBINS(Adm,BillUser) 
	.s Error=$p(PBInsInfo,"^",1)
	.s:'Error PBRowID=$p(Error,"^",2)
	s Error=..PBOINS(PBRowID, OEORE, ItmInfo,BillUser)
	i Error=0 d
	.Tcommit
	e  d
	.Trollback
	
	q Error_"^"_PBRowID
}

/// 插入表dhc_patbillorder
ClassMethod PBOINS(BILL, OEORE, ItmInfo, BillUser)
{
	n (BILL,OEORE,ItmInfo,BillUser) ;add ItmInfo
	;dhc_patbillorder表不存在记录时，直接插入记录
	s Error=0	;add
	i $d(^DHCPB(0,"OEEXC",OEORE))=0 d
	.k PLIST
	.s PLIST(0)=BILL
	.s PLIST(3)=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),1),"^",2)  ;pb_arcim_dr$p($g(^TMP("IB",$j,"ORDER",OEORE,4)),$c(1))
	.s PLIST(4)=+OEORE_"||"_$p(OEORE,"||",2)  ;pb_oeori_dr
	.s PLIST(20)=OEORE  ;保存执行记录的数据
    .s OEOREExStDate=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",1)	;add
    .s OEOREExStTime=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",2)
	.s PLIST(12)=OEOREExStDate  ;OEOREExStDate
	.s PLIST(13)=OEOREExStTime  ;OEOREExStTime
	.s err=##class(UDHCJFPBO).INSERT() 
	.s Error=Error+err
	.s PBO=$g(%ROWID)
	.;执行记录表记录账单医嘱指针
	.s $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL"),"^",2)=PBO  ;add ORD--OEORE
	.s BillStatus=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)
	.i BillStatus'="R" s $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
    e  d
    .s PB=$o(^DHCPB(0,"OEEXC",OEORE,""))
    .s OrdSub=$o(^DHCPB(0,"OEEXC",OEORE,PB,""))
    .s PBO=PB_"||"_OrdSub
    s TotalAmount=0,DiscAmount=0,InsAmount=0,PatAmount=0
	i Error=0 d
	.s PBDInsInfo=..PBODINS(PBO, OEORE, ItmInfo, BillUser)
	.s err=$p(PBDInsInfo,"^",1)
	.s Error=Error+err
	.s TotalAmount=TotalAmount+$p(PBDInsInfo,"^",2)
	.s DiscAmount=DiscAmount+$p(PBDInsInfo,"^",3)
	.s InsAmount=InsAmount+$p(PBDInsInfo,"^",4)
	.s PatAmount=PatAmount+$p(PBDInsInfo,"^",5)
	q:Error'=0 Error
	s err=##class(UDHCJFPBO).SELECT(PBO) 
	B ;1
	s Error=Error+err
	s PLIST(8)=PLIST(8)+TotalAmount 
	s PLIST(9)=PLIST(9)+DiscAmount
	s PLIST(10)=PLIST(10)+InsAmount
	s PLIST(11)=PLIST(11)+PatAmount
	s err=##class(UDHCJFPBO).UPDATE(PBO) 
	B ;2
	s Error=Error+err
	s PBRowID=+PBO
	s err=##class(UDHCJFPB).SELECT(PBRowID) 
	s Error=Error+err
	s PLIST(9)=PLIST(9)+TotalAmount 
	s PLIST(10)=PLIST(10)+DiscAmount
	s PLIST(12)=PLIST(12)+InsAmount
	s PLIST(13)=PLIST(13)+PatAmount
	s err=##class(UDHCJFPB).UPDATE(PBRowID) 
	B ;3
	s Error=Error+err
	q Error  ;_"^"_TotalAmount_"^"_DiscAmount_"^"_InsAmount_"^"_PatAmount
}

/// 插入表dhc_patbilldetails
ClassMethod PBODINS(PBO, OEORE, ItmInfo, User)
{
	n (PBO,ORD,ItmInfo,Status,User)
	;数量^单价^折扣价^记账价^自付价^收费项目rowid^状态(收B,退R)
	s Qty0=$p(ItmInfo,"^",1)
	s Price0=$p(ItmInfo,"^",2)
	s DiscPrice0=$p(ItmInfo,"^",3)
	s InsPrice0=$p(ItmInfo,"^",4)
	s PatPrice0=$p(ItmInfo,"^",5)
	s Itm=$p(ItmInfo,"^",6)
	s Status=$p(ItmInfo,"^",7)
	s Comment=$p(ItmInfo,"^",8)

	s BillDate=+$h
	s BillTime=$p($h,",",2)
	k PLIST
	s PLIST(0)=PBO
	s PLIST(3)=Itm
	s PLIST(4)=+Price0
	s PLIST(18)=+DiscPrice0
	s PLIST(19)=+InsPrice0
	s PLIST(20)=+PatPrice0
	;
	s PLIST(5)=+Qty0
	s PLIST(7)=+..round(Price0*PLIST(5))
	s PLIST(8)=+..round(DiscPrice0*PLIST(5))
	s PLIST(9)=+..round(InsPrice0*PLIST(5))
	s PLIST(10)=+(PLIST(7)-PLIST(8)-PLIST(9))  ;+$$round(PatPrice0*PLIST(5))

	i BillDate="" s BillDate=+$H
	i BillTime="" s BillTime=$p($H,",",2)
	s PLIST(11)=BillDate                ;计费日期
	s PLIST(12)=BillTime                ;计费时间
	s PLIST(13)=$g(Status)                  ;
	s PLIST(14)=+$H
	s PLIST(15)=$p($H,",",2)
	s PLIST(16)=$g(BillUser)
	s PLIST(22)="Y"
	s PLIST(24)=Comment
	s err=##class(UDHCJFPBOD).INSERT()
	B ;4
	q err_"^"_+PLIST(7)_"^"_+PLIST(8)_"^"_+PLIST(9)_"^"_+PLIST(10)
}

ClassMethod round(Num)
{
	n (Num)
	s NegFlag=0
	q:$g(Num)=""!(Num=0) 0
	i Num<0 s Num=-Num,NegFlag=1
	i Num<0.01 s Num=0.01       
	e  d
	.s Num=+Num+0.0000001
	.s np=$p(Num,".",1)_"."_$e($p(Num,".",2),1,2)
	.s point="0.00"_$e($p(Num,".",2),3,$l($p(Num,".",2)))
	.s Num=np 
	.s:point'<0.005 Num=Num+0.01
	i NegFlag=1 s Num=-Num
	q Num
}

/// 收费项目明细
/// Input:别名，病人收费类别(取单价用)
/// Output:收费项目编码，名称,单价,折扣价,记账价,自付价
/// d ##class(%ResultSet).RunQuery("web.DHCIPBillInsExpItm","FindTariItem","wss","")
ClassMethod FindTariItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTariItemExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTariItemExecute(ByRef qHandle As %Binary, ItemDesc, InsType) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ItemDesc=$$ALPHAUP^SSUTIL4(ItemDesc)
    s CurrItemDesc=ItemDesc
	s Flag="N"
	
	s CurrItemDesc=$o(^DHCTARAL("A",0,"Desc",CurrItemDesc),-1)
	f  s CurrItemDesc=$o(^DHCTARAL("A",0,"Desc",CurrItemDesc)) q:(CurrItemDesc="")!(Flag="Y")  d
	.i $e(CurrItemDesc,1,$L(ItemDesc))'=ItemDesc s Flag="Y" q
	.s RowId=""
	.f  s RowId=$o(^DHCTARAL("A",0,"Desc",CurrItemDesc,RowId)) q:RowId=""  d
	..s TariInfo=$g(^DHCTARI(RowId))
	..s TariCode=$p(TariInfo,"^",1)
	..s TariDesc=$p(TariInfo,"^",2)
	..s PriceInfo=##class(web.UDHCJFPRICE).GetItmPrice(RowId,+$h,InsType,"","")
	..s UnitPrice=$p(PriceInfo,"^",1)
	..s DisPrice=$p(PriceInfo,"^",2)
	..s InsPrice=$p(PriceInfo,"^",3)
	..s PatPrice=$p(PriceInfo,"^",4)
	..d OutputRow1

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TariCode,TariDesc,UnitPrice,DisPrice,InsPrice,PatPrice,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTariItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTariItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Query FindTariItem(ItemDesc, InsType) As %Query(ROWSPEC = "TariCode:%String:项目代码,TariDesc:%String:项目名称,UnitPrice:%String:项目单价,DisPrice:%String:折扣价,InsPrice:%String:记账价,PatPrice:%String:自付价,TariRowID:%String")
{
}

/// Function:取消收费项目费用
/// ##class(web.DHCIPBillInsExpItm).PBDetailRefund("199368||18||1",3,)
ClassMethod PBDetailRefund(PBDRowID, User, Comment)
{
	q:PBDRowID="" "-1"
	
    s PB=$p(PBDRowID,"||",1),PBO=$p(PBDRowID,"||",2),PBD=$p(PBDRowID,"||",3)
	q:$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",14)="P" "-1"  //结算过的账单明细不允许取消费用
	s ExecRowID=$P(^DHCPB(PB,"O",PBO),"^",20)
	s Error=0
	tstart
	s PBORowID=$p(PBDRowID,"||",1)_"||"_$p(PBDRowID,"||",2)
	s err=##CLASS(UDHCJFPBOD).SELECT(PBDRowID) 
	k PLIST(1),PLIST(2)
	s PLIST(0)=PBORowID
	s PLIST(5)=-PLIST(5)
	s PLIST(7)=-PLIST(7),PLIST(8)=-PLIST(8),PLIST(9)=-PLIST(9),PLIST(10)=-PLIST(10)
	s PLIST(14)=+$H,PLIST(15)=$p($H,",",2),PLIST(16)=User 
	s PLIST(22)="Y"
	s PLIST(23)=PBDRowID
	s PLIST(24)=Comment
	s TotalAmount=PLIST(7)
	s DiscAmount=PLIST(8)
	s InsAmount=PLIST(9)
	s PatAmount=PLIST(10)
	s err=##CLASS(UDHCJFPBOD).INSERT() 
	s Error=Error+err
	k PLIST
	s err=##class(UDHCJFPBO).SELECT(PBORowID) 
	s Error=Error+err

	s PLIST(8)=PLIST(8)+TotalAmount
	s PLIST(9)=PLIST(9)+DiscAmount
	s PLIST(10)=PLIST(10)+InsAmount
	s PLIST(11)=PLIST(11)+PatAmount
	s PLIST(16)="R"
	s err=##class(UDHCJFPBO).UPDATE(PBORowID) 
	s Error=Error+err

	s PBRowID=$p(PBORowID,"||",1)
	S PBTotal=$p(^DHCPB(PBRowID),"^",8)
	s PBTotalNew=PBTotal+TotalAmount
	s PBDiscTotal=$p(^DHCPB(PBRowID),"^",9)
	s PBDiscTotalNew=PBDiscTotal+DiscAmount
	s PBInsTotal=$p(^DHCPB(PBRowID),"^",11)
	s PBInsTotalNew=PBInsTotal+InsAmount
	s PBPatShare=$p(^DHCPB(PBRowID),"^",12)
	s PBPatShareNew=PBPatShare+PatAmount
	&sql(update sqluser.dhc_patientbill set pb_totalamount=:PBTotalNew,pb_discamount=:PBDiscTotalNew,pb_payorshare=:PBInsTotalNew,pb_patientshare=:PBPatShareNew where pb_rowid=:PBRowID)
	s Error=Error+err
	&sql(update sqluser.oe_ordexec set oeore_billed="R" where oeore_rowid=:ExecRowID)
	s Error=Error+err
	i Error=0 d
	.tc
	e  d
	.trollback
	
	q Error
}

}
