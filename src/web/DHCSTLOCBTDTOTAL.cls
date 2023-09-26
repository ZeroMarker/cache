Import SQLUser

Class web.DHCSTLOCBTDTOTAL Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod UpdateMain(ItemDesc, INCLB, Qty, MRid, LocDesc) As %String
{
	n (ItemDesc,INCLB,Qty,MRid,LocDesc)
	f i=0:1:7 s PLIST(i)=""
	s PLIST=8
	q:$g(ItemDesc)="" ""
	q:$g(INCLB)="" ""
	q:$g(Qty)="" ""
	q:$g(MRid)="" ""
	q:$g(LocDesc)="" ""
	;
	q ..UpdateDayBT(INCLB,Qty,MRid)
}

ClassMethod UpdateDayBT(INCLBRid, Qty, MRid)
{
	// The code is the final execution code to handle the stock qty .
	// 
	;According to INCLB and MRid,Update the date in table of DHC_LocBTDailyTotal
	q:INCLBRid="" ""
	q:MRid="" ""
	s sdate1=$p($h,",",1)+1
	n INCI,ILCH
	s INCI=+INCLBRid,ILCH=$p(INCLBRid,"||",2)
	s LocRID=+$p(^INCI(INCI,"IL",ILCH),"^",1)  ;ctloc dr
	s Eqty=0
	;
	s sdate1=$p($h,",",1)+1
	s sdate2=$o(^DHCBTLOCTOT(0,"LocBtDate",LocRID,INCLBRid,sdate1),-1)              ;lastest bt Date
	s YMRID="",YCRID="",Eqty=0
	;       
	i $g(sdate2)'="" d
	        .s YMRID=$o(^DHCBTLOCTOT(0,"LocBtDate",LocRID,INCLBRid,sdate2,""))               ;lastest bt Main ROWID         
	        .s YCRID=$o(^DHCBTLOCTOT(0,"LocBtDate",LocRID,INCLBRid,sdate2,YMRID,""))     ;lastest bt ChildSub 
	        .s Eqty=$p(^DHCBTLOCTOT(YMRID,"I",YCRID),"^",3)                                  ;lastest bt EndQty
	
	i $g(sdate2)=$p($h,",",1) d
	        .s PLIST(1)=YMRID_"||"_YCRID    ;RowID
	        .s PLIST(4)=Eqty+Qty
	        .&sql(Update DHC_LocBTDailyTotal set  DayBT_QtyEnd=:PLIST(4) where DayBT_RowID=:PLIST(1))
	        .s ret=SQLCODE

	e  d
	        .s PLIST(2)=INCLBRid
	        .s MaxSub=$o(^DHCBTLOCTOT(MRid,"I",""),-1)
	        .i $g(MaxSub)="" d
	                ..s PLIST(5)="1"
	        .e  d
	                ..s PLIST(5)=MaxSub+1   ;childsub
	        .s PLIST(0)=MRid
	        .s PLIST(3)=Eqty                ;StartQty=Last EndQty
	        .s PLIST(4)=Eqty+Qty            ;EndQty
	        .s PLIST(6)=$p($h,",",1)
	        .s PLIST(7)=LocRID
	        .&sql(Insert into DHC_LocBTDailyTotal values :PLIST())
	        .s ret=SQLCODE
	s P9=$g(%ROWID)
	q P9
}

}
