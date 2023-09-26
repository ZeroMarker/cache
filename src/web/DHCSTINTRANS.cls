Import SQLUser

Class web.DHCSTINTRANS Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Insert() As %String
{
 ;&sql(Insert into DHC_InTrans(INTR_Type,INTR_Date,INTR_Time,INTR_UpdFlag,INTR_UpdBalFlag,
 ;                             INTR_Pointer,INTR_Amount,INTR_INCLB_DR,INTR_Qty,INTR_CTUOM_DR,
  ;                             INTR_INCI_DR,INTR_No,INTR_AveragePrice,INTR_SSUSR_DR,INTR_GLBatch_DR)
  ;                                  values(:PLIST(1),:PLIST(2),:PLIST(3),:PLIST(4),:PLIST(5),
  ;                             :PLIST(6),:PLIST(7),:PLIST(8),:PLIST(9),:PLIST(10),
  ;                             :PLIST(11),:PLIST(12),:PLIST(13),:PLIST(14),:PLIST(15)))
  &sql(Insert into DHC_InTrans values :PLIST())
  q SQLCODE
}

ClassMethod IntoMain(lstData As %String) As %String
{
	n (lstData)
	;s lstData="T^XYC20040705_02^0308^-221^支^WSSCZS-维生素C注射剂 20ml^2.04^2873^58^xyk-西药库"
	;lstData=INTR_Type^INTR_No^INCLBNO^INTR_Qty^Itm_UOM^Itm_Name^Itm_price^UserRowID^INTR_Pointer^Provider
	f i=1:1:16 s PLIST(i)=""
	s PLIST=16
	s sType=$p(lstData,"^",1)       ;INTR_Type
	s sTrNo=$p(lstData,"^",2)       ;INTR_No
	s sInclbNo=$p(lstData,"^",3)    ;INCLBNO
	s sQty=$p(lstData,"^",4)        ;INTR_Qty
	s sUom=$p(lstData,"^",5)        ;Itm_UOM DESC
	s sItmName=$p(lstData,"^",6)    ;Itm_Name
	s sPrice=$p(lstData,"^",7)      ;Itm_price
	s sUsrID=$p(lstData,"^",8)      ;UserRowID
	s sTrRowID=$p(lstData,"^",9)    ;INTR_Pointer
	s sDept=$p(lstData,"^",10)      ;Provider DESC
	s PLIST(2)=+sQty*sPrice                                                  ;INTR_Amount
	s PLIST(3)=+sPrice                                                       ;INTR_AveragePrice
	s PLIST(4)=##class(web.DHCSTCOMMONSRV).CTUOMToID(sUom)                              ;INTR_CTUOM_DR
	s PLIST(5)=$p($h,",",1)                                                  ;INTR_Date
	s PLIST(6)=""                                                            ;INTR_GLBatch_DR
	s PLIST(7)=##class(web.DHCSTCOMMONSRV).ItemDescToID(sItmName)                       ;INTR_INCI_DR
	s PLIST(8)=sInclbNo														;INTR_INCLB_DR
	s PLIST(9)=sTrNo                                                         ;INTR_No
	s PLIST(10)=sTrRowID                                                     ;INTR_Pointer
	s PLIST(11)=+sQty                                                        ;INTR_Qty
	s PLIST(12)=sUsrID                                                       ;INTR_SSUSR_DR
	s PLIST(13)=$p($h,",",2)                                                 ;INTR_Time
	s PLIST(14)=sType                                                        ;INTR_Type
	s PLIST(15)="N"                                                          ;INTR_UpdBalFlag       
	s PLIST(16)="N"                                                          ;INTR_UpdFlag
	;
	&sql(Insert into DHC_InTrans values :PLIST())
	q:SQLCODE'=0 ""
	s P9=$P($g(%ROWID),$c(1),1)
	q P9
}

ClassMethod IntoTrans(lstData As %String) As %String
{
	;LstData = Type_"^"_No_"^"_Inclb_"^"_Qty_"^"_UomDesc_"^"_ItmCode_"^"_Price_"^"_guser_"^"_pointer(Rowid)_"^"_科室描述_"^"_进价_"^"_进价金额_"^"_售价金额
	;s lstData="A^AD20041208_002^383||2||2^-49999949505^支(10ml)^301112041^17.7^1423^109||1^ZYYF-住院药房"
	n (lstData)
	f i=1:1:16 s PLIST(i)=""
	s PLIST=16
	s sType=$p(lstData,"^",1)       ;INTR_Type
	s sTrNo=$p(lstData,"^",2)       ;INTR_No
	s sInclb=$p(lstData,"^",3)      ;INCLBRowID
	s sQty=$p(lstData,"^",4)        ;INTR_Qty
	s sUom=$p(lstData,"^",5)        ;Itm_UOM DESC
	s sItmCode=$p(lstData,"^",6)    ;Itm_Code
	s sPrice=$p(lstData,"^",7)      ;Itm_price
	s sUsrID=$p(lstData,"^",8)      ;UserRowID
	s sTrRowID=$p(lstData,"^",9)    ;INTR_Pointer
	s rp=$p(lstData,"^",11)
	s RpAmt="" //$p(lstData,"^",12)
	s SpAmt="" //$p(lstData,"^",13)
	//
	s uomID=##class(web.DHCSTCOMMONSRV).CTUOMToID(sUom)
	i (SpAmt="")!(RpAmt="") d
	.s LocID=$$LOC^ST01(sInclb)
	.s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocID)
 	.s HospID=$p(CustStr,"^",5)
 	.s CustID=$p(CustStr,"^",1)
	.S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+sInclb)
	.S StkTypeDesc=$P(CatGrpStr,"^",4)
	.S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	.i SpAmt="" d
	..//s sPrice=+##Class(web.DHCSTPRICE).GetCurSp(sInclb,uomID,HospID)
	..s SpAmt=sPrice*sQty
	..s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
	.i RpAmt="" d
	..//i rp="" d
	..//.s rp=+##Class(web.DHCSTPRICE).GetCurRp(sInclb,uomID,HospID)
	..s RpAmt=rp*sQty
	..s RpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(RpAmt,Perv,"FmtRA",1)
	s inci=+sInclb
	s PLIST(2)=+SpAmt	                          ;INTR_Amount
	s PLIST(3)=+sPrice                            ;INTR_AveragePrice
	s PLIST(4)=uomID                              ;INTR_CTUOM_DR
	s PLIST(5)=$p($h,",",1)                       ;INTR_Date
	s PLIST(6)=""                                 ;INTR_GLBatch_DR
	s PLIST(7)=inci                       		  ;INTR_INCI_DR
	s PLIST(8)=sInclb                             ;INTR_INCLB_DR
	s PLIST(9)=sTrNo                              ;INTR_No
	s PLIST(10)=sTrRowID                          ;INTR_Pointer
	s PLIST(11)=+sQty                             ;INTR_Qty
	s PLIST(12)=sUsrID                            ;INTR_SSUSR_DR
	s PLIST(13)=$p($h,",",2)                      ;INTR_Time
	s PLIST(14)=sType                             ;INTR_Type
	s PLIST(15)="N"                               ;INTR_UpdBalFlag       
	s PLIST(16)="N"
	s PLIST(17)=+rp
	s PLIST(18)=+RpAmt
	&sql(Insert into DHC_InTrans values :PLIST())
	q:SQLCODE'=0 ""
	s P9=$P($g(%ROWID),$char(1),1)
	//损益 add wyx 2014-05-06
	;插入退药损益表 DHC_RetAspAmount         
    s DataStr=sInclb_"^"_inci_"^"_LocID_"^"_sPrice_"^"_+sQty_"^"_+SpAmt_"^"_sUsrID_"^"_sTrRowID_"^"_sType_"^"_rp_"^"_RpAmt_"^"_HospID_"^"_uomID_"^"_CustID
    s ret=..InsertRetA(DataStr)
    q:ret<0 ""	
	q P9
}

// wyx,2014-05-06,台帐统一处理损益(住院发药，住院退药，门诊发药，门诊退药)

ClassMethod InsertRetA(DataStr As %String) As %String
{
 n (DataStr)
 s inclb=$p(DataStr,"^",1)
 s inci=$p(DataStr,"^",2)
 s locdr=$p(DataStr,"^",3)
 s retSp=$p(DataStr,"^",4)
 s qty=$p(DataStr,"^",5)
 s retSpAmt=$p(DataStr,"^",6)
 s userdr=$p(DataStr,"^",7)
 s pointerrowid=$p(DataStr,"^",8)
 s rettype=$p(DataStr,"^",9)
 s retRp=$p(DataStr,"^",10)
 s retRpAmt=$p(DataStr,"^",11)
 s HospID=$p(DataStr,"^",12)
 s Uom=$p(DataStr,"^",13)
 s CustID=$p(DataStr,"^",14)
 s CurSp=+##Class(web.DHCSTPRICE).GetCurSp(inclb,Uom,HospID)
 s CurRp=+##Class(web.DHCSTPRICE).GetCurRp(inclb,Uom,HospID)
 s buom=$p(^INCI(inci,1),"^",10)

 s adjSp=CurSp-retSp    ;损益价格
 s adjRp=CurRp-retRp
 s CurSpAmt=CurSp*qty
 s CurRpAmt=CurRp*qty
 s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
 s StkTypeDesc=$P(CatGrpStr,"^",4)
 s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 s CurSpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurSpAmt,Perv,"FmtSA",1)
 s CurRpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurRpAmt,Perv,"FmtRA",1)
 s AdjSpAmt=CurSpAmt-retSpAmt
 s AdjRpAmt=CurRpAmt-retRpAmt
 q:(AdjSpAmt=0)&&(AdjRpAmt=0) 0
 s date=+$h               ;date is the current date
 s time=$p($h,",",2)      ;time is the current time
 ;
 &sql(insert into  DHC_RetAspAmount(RETA_INCI_DR,RETA_CTLOC_DR,RETA_AdjPrice,RETA_Qty,
 RETA_Amount,RETA_SSUSR_DR,RETA_Date,RETA_Time,RETA_Pointer,RETA_Type,RETA_RpDiff,RETA_RpAmt,RETA_Uom_Dr,RETA_INCLB_DR) 
  values (:inci,:locdr,:adjSp,:qty,:AdjSpAmt,:userdr,:date,:time,:pointerrowid,:rettype,:adjRp,:AdjRpAmt,:buom,:inclb))
 i SQLCODE'=0  d
 .s ret=$$SqlErrorRecord^DHCSTERROR("InsertRetA:DHC_RetAspAmount",pointerrowid,SQLCODE_":"_$g(%msg))
 q:SQLCODE'=0 -2
 q 0
}

ClassMethod IntoTrans2(lstData As %String) As %String
{
	;LstData = Type_"^"_No_"^"_Inclb_"^"_Qty_"^"_UomDR_"^"_Price_"^"_guser_"^"_pointer(Rowid)
	;s lstData="A^AD20041208_002^383||2||2^-49999949505^22^^17.7^1423^109||1"
	n (lstData)
	f i=1:1:16 s PLIST(i)=""
	s PLIST=16
	s sType=$p(lstData,"^",1)       ;INTR_Type
	s sTrNo=$p(lstData,"^",2)       ;INTR_No
	s sInclb=$p(lstData,"^",3)      ;INCLBRowID
	s sQty=$p(lstData,"^",4)        ;INTR_Qty
	s sUom=$p(lstData,"^",5)        ;Itm_UOM rowid
	s sPrice=$p(lstData,"^",6)      ;Itm_price
	s sUsrID=$p(lstData,"^",7)      ;UserRowID
	s sTrRowID=$p(lstData,"^",8)    ;INTR_Pointer
	//
	s LocID=$$LOC^ST01(sInclb)
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocID)
 	s HospID=$p(CustStr,"^",5)
 	s CustID=$p(CustStr,"^",1)
	s SpAmt=sPrice*sQty
	S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+sInclb)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
	S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
	s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
	;
	s PLIST(2)=+SpAmt				;INTR_Amount
	s PLIST(3)=+sPrice				;INTR_AveragePrice
	s PLIST(4)=sUom					;INTR_CTUOM_DR
	s PLIST(5)=$p($h,",",1)			;INTR_Date
	s PLIST(6)=""					;INTR_GLBatch_DR
	s PLIST(7)=+sInclb				;INTR_INCI_DR
	s PLIST(8)=sInclb				;INTR_INCLB_DR
	s PLIST(9)=sTrNo				;INTR_No
	s PLIST(10)=sTrRowID			;INTR_Pointer
	s PLIST(11)=+sQty				;INTR_Qty
	s PLIST(12)=sUsrID				;INTR_SSUSR_DR
	s PLIST(13)=$p($h,",",2)		;INTR_Time
	s PLIST(14)=sType                                                        ;INTR_Type
	s PLIST(15)="N"                                                          ;INTR_UpdBalFlag       
	s PLIST(16)="N"
	&sql(Insert into DHC_InTrans values :PLIST())
	q:SQLCODE'=0 ""
	Q $P($g(%ROWID),$char(1))
}

}
