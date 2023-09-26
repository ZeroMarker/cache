Import SQLUser

Class web.DHCSTLOCDTOTAL Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod UpdateAllAndTrans(lstData As %String, transflag = "") As %String
{
 
	;Handle the following tables : DHC_LocDailytotal,DHC_LocbtDailytotal,DHC_Intrans
	;
	;s lstData="A^AD20041207_013^179||2||2^-999998999^支(500mg)^301106002^172^1423^107||184^ZYYF-住院药房"
	;lstData = Type_"^"_AdjNo_"^"_Inclb_"^"_Qty_"^"_UomDesc_"^"_ItmCode_"^"_Price_"^"_guser_"^"_pointer(Rowid)_"^"_floc
	n (lstData,transflag)
	s ItmCode=$p(lstData,"^",6)             ;ItmCode
	s Qty=$p(lstData,"^",4)                 ;BaseQty
	s LocDesc=$p(lstData,"^",10)    ;loc
	s INCLBRid=$p(lstData,"^",3)    ;Inclb
	s UomDesc=$p(lstData,"^",5)             ;UomDesc
	
	s LocRID=##class(web.DHCSTCOMMONSRV).LocToRowID(LocDesc)
	s ItemRID=##class(web.DHCSTCOMMONSRV).ItemCodeToID(ItmCode)
	s BaseUOMDesc=##class(web.DHCSTITMDESC).GetBaseUoDescByCode(ItmCode)
	s Factor=##class(web.DHCSTCOMMONSRV).CTUOMFactor(UomDesc,BaseUOMDesc)
	s BaseQty=Qty*Factor
	s MRowID=..UpdateMainByID(ItemRID,BaseQty,LocRID)
	q:MRowID="" ""
	s RRowID=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(INCLBRid,BaseQty,MRowID)
	q:RRowID="" ""
	i transflag="" s TROWID=##class(web.DHCSTINTRANS).IntoTrans(lstData)
	q:($g(transflag)="")&($g(TROWID)="") ""
	q MRowID
}

ClassMethod UpdateMainAndDetail(ItmCode As %String, Qty As %String, LocDesc As %String, INCLBRid As %String) As %String
{
	;Handle the following tables : DHC_LocDailytotal,DHC_LocbtDailytotal
	;
	n (ItmCode,Qty,LocDesc,INCLBRid)
	q:ItmCode="" ""
	q:Qty="" ""
	q:INCLBRid="" ""
	s ItemRID=##class(web.DHCSTCOMMONSRV).ItemCodeToID(ItmCode)
	s LocRID=##class(web.DHCSTCOMMONSRV).LocToRowID(LocDesc)
	s MRowID=..UpdateMainByID(ItemRID,Qty,LocRID)
	q:MRowID="" ""
	s RRowID=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(INCLBRid,Qty,MRowID)
	q:RRowID="" ""
	s P9=MRowID
	q P9
}

ClassMethod UpdateAll(ItemDesc As %String, Qty As %String, LocDesc As %String, INCLB As %String) As %String
{
	;Handle the following tables : DHC_LocDailytotal,DHC_LocbtDailytotal
	;
	s MRowID=..UpdateMain(ItemDesc,Qty,LocDesc)
	q:MRowID="" ""
	s RRowID=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(INCLB,Qty,MRowID)
	q:RRowID="" ""
	s P9=MRowID
	q P9
}

ClassMethod UpdateMain(ItemDesc As %String, Qty As %String, LocDesc As %String) As %String
{
	
	;Handle the following tables : DHC_LocDailytotal
	;
	n (ItemDesc,Qty,LocDesc)
	q:$g(ItemDesc)="" ""
	q:$g(Qty)="" ""
	q:$g(LocDesc)="" ""     
	s LocRID=##class(web.DHCSTCOMMONSRV).LocToRowID(LocDesc)
	s ItemRID=##class(web.DHCSTCOMMONSRV).ItemDescToID(ItemDesc)       
	s P9=..UpdateMainByID(ItemRID,Qty,LocRID)
	q P9
}

ClassMethod UpdateMainByID(ItemRID As %String, Qty As %String, LocRID As %String) As %String
{
	;Handle the following tables : DHC_LocDailytotal
	;The Code is the final executions to handle stock qty
	;
	n (ItemRID,Qty,LocRID)
	f i=1:1:6 s PLIST(i)=""
	s PLIST=6
	q:$g(ItemRID)="" ""
	q:$g(Qty)="" ""
	q:$g(LocRID)="" ""
	s EQty=0
	s sdate1=$p($h,",",1)+1
	s sdate2=$o(^DHCLOCTOT(0,"LOCITMDATE",LocRID,ItemRID,sdate1),-1)        
	i $g(sdate2)'="" d
	 .s IRID=$o(^DHCLOCTOT(0,"LOCITMDATE",LocRID,ItemRID, sdate2,""))
	 .s EQty=$p(^DHCLOCTOT(IRID),"^",4)
	
	;Is it today?
	i $g(sdate2)=$p($h,",",1) d
	        .s PLIST(1)=IRID
	        .s PLIST(5)=EQty+Qty      ;EndQty
	        .&sql(Update DHC_LocDailyTotal set Day_QtyEnd=:PLIST(5) where Day_RowID=:PLIST(1))
	        .s ret=SQLCODE
	e  d   
	        .s PLIST(2)=ItemRID
	        .s PLIST(3)=LocRID
	        .s PLIST(4)=EQty
	        .s PLIST(5)=EQty+Qty
	        .s PLIST(6)=$p($h,",",1)
	        .&sql(Insert into DHC_LocDailyTotal Values :PLIST())
	        .s ret=SQLCODE
	        
	s P9=+$g(%ROWID)
	q P9
}

ClassMethod UpdQtyAndTrans(lstData As %String) As %String
{
	;LstData = Type_"^"_No_"^"_Inclb_"^"_Qty_"^"_UomDR_"^"_Price_"^"_guser_"^"_pointer(Rowid)
	n (lstData)
	s INCLBRid=$p(lstData,"^",3)    		;Inclb
	s ItemRID=+INCLBRid						;ItmCode
	s Qty=+$p(lstData,"^",4)				;BaseQty
	s UomDr=$p(lstData,"^",5)             	;UomDr
	S ilsub=$P(INCLBRid,"||",2)
	S LocRID=$P(^INCI(ItemRID,"IL",ilsub),"^",1)
	S BUomDr=$P(^INCI(ItemRID,1),"^",10)
	s Factor=##class(web.DHCSTCOMMONSRV).UOMFac(UomDr,BUomDr)
	s BaseQty=Qty*Factor
	s MRowID=..UpdateMainByID(ItemRID,BaseQty,LocRID)
	q:MRowID="" -1
	s RRowID=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(INCLBRid,BaseQty,MRowID)
	q:RRowID="" -2
	s TROWID=##class(web.DHCSTINTRANS).IntoTrans2(lstData)
	q:TROWID="" -3
	q TROWID
}

// 余瑞英 2014-12-16 16:53:38

ClassMethod MakeUpStk(inclb, bqty) As %String
{
 n (inclb,bqty)
 ; Makeup the Medtrak-stock qty with the DHC-stock qty
 q:(inclb="")!(bqty="") -1
 n (inclb,bqty)
 s inci=$p(inclb,"||",1),ch=$p(inclb,"||",2),lb=$p(inclb,"||",3)
 q:$g(ch)="" -1
 q:$g(lb)="" -1
 s curLbQty=0
 s curLbQty=$p(^INCI(inci,"IL",ch,"LB",lb),"^",2)
 ;q:curLbQty'>0 0
 i (bqty+curLbQty)<0 d
 .//d UPDINV1^ST01(inclb,-curLbQty)
 .d ##Class(web.DHCST01).UPDINV1(inclb,-curLbQty)
 e  d
 .//d UPDINV1^ST01(inclb,bqty)
 .d ##Class(web.DHCST01).UPDINV1(inclb,bqty)
 q 0
}

}
