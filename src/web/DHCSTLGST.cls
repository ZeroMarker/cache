Import sqluser

Class web.DHCSTLGST Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ;-->>dhc_inistrf
ClassMethod IntoDHCMain(DataInput, PLc, RLc, RequestNo, UserRowid, TrNoPre, Remarks, TranStr, AppName = "") As %String
{
    ;Insert DHC_InIsTrf
 f i=1:1:14 s PLIST(i)=""
  s PLIST(1)=$zdh(DataInput,3) ;Trans Date
  s PLIST(2)=$p($h,",",2)      ;Trans Time
  s PLIST(3)=##class(web.DHCSTCOMMONSRV).LocToRowID(PLc)   ;ProvideL
  s PLIST(4)=##class(web.DHCSTCOMMONSRV).LocToRowID(RLc)   ;RequestL
  s PLIST(5)=UserRowid  ;Operater ROWID
  s PLIST(6)="T"  ;INIT_Type
  s PLIST(7)=""   ;INIT_UserCompleted
  s PLIST(8)=""   ;INIT_Remarks
  s PLIST(12)=Remarks      ;INIT_OperationRemark
  S Stype=$P(TranStr,"^",1)
  S IngrID=$P(TranStr,"^",2)
  s PLIST(13)=Stype
  s PLIST(14)=IngrID
  i RequestNo'="" s PLIST(9)=..ReqNoToRowid(RequestNo)  ;RequestRowID
  s PLIST(10)=10   ;INIT_State(10 no Complete?can't OutCheck)
  I AppName="" D
  .//s trno=$$DHCGetSttrNo^DHCSTCOMMONSRV(TrNoPre)
  E  D
  .//S trno=$$GetAppNo^DHCSTCOMMONSRV3(AppName,TrNoPre)
  ;if TrNoPre'=""  s PLIST(11)=$$DHCGetSttrNo^DHCSTCOMMONSRV(TrNoPre)
  s PLIST(11)=trno
  //s ret=$$INSERT^DHCSTMVBSTTR()
  s ret=##class(web.DHCSTMVBSTTR).INSERT()
  s P9=$P($g(%ROWID),$char(1),1)
  q P9
}

/// ;-->>dhc_inistrfitm
ClassMethod IntoDHCDetail(ListDetail, MainID) As %String
{
 n (ListDetail,MainID)
 k PLIST
 f i=0:1:27 s PLIST(i)=""
 s PLIST=27
 s uomdr="",uom=""
 s IDM=..DHCStrNoToRowid(MainID)
 s itmcode=$P(ListDetail,"^",1)
 s qty=+$P(ListDetail,"^",2)
 s uom=$P(ListDetail,"^",3)     ;uom
 s ttype=$P(ListDetail,"^",4)   ;trans type
 s inclbrowid=$P(ListDetail,"^",5)  ;inclb rowid
 s aspflag=$p(ListDetail,"^",6) ;adjsp flag
 S HospID=..GetHospIDByInit(MainID)
 s uomdr=##class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
 s ss=itmcode_"^"_""_"^"_uom
 s sp=+##class(web.DHCSTCOMMONSRV).GetItemSp(ss,HospID)
 s pricedata=##class(web.DHCSTPRICE).LastPrice(inclbrowid,uomdr)
 s pp=+$p(pricedata,"^",1)
 s rp=+$p(pricedata,"^",2)
 s ppa=+(pp*qty)
 s rpa=+(rp*qty)
 s spa=+(sp*qty)
 s newsp=+##class(web.DHCSTCALSP).BatSpUom(inclbrowid,uomdr)
 s newspamt=+(newsp*qty) 
 s hosp=##class(web.DHCSTCUSTOMER).GetCustomer()
 i hosp="SG" d
 .s ppa=+$fn(ppa,"",2)
 .s rpa=+$fn(rpa,"",2)
 .s spa=+$fn(spa,"",2)
 .s newspamt=+$fn(newspamt,"",2)
 s PLIST(0)=IDM
 s PLIST(3)=$o(^DHCINIT(IDM,"ITI",""),-1)+1    ;2006-07-31
 s PLIST(5)=inclbrowid
 s PLIST(7)=qty
 s PLIST(14)=uomdr    ;UOM ROWID
 s PLIST(11)=ttype
 s PLIST(12)=sp
 s PLIST(24)=aspflag
 s PLIST(17)=ppa
 s PLIST(18)=pp
 s PLIST(19)=rp
 s PLIST(20)=rpa
 s PLIST(21)=sp
 s PLIST(22)=spa
 s PLIST(27)=10				;zdm,2009-3-31,库存转移明细增加状态字段
 s ret=##class(web.DHCSTMVBSTTRI).INSERT()
 s rr=$g(%ROWID)
 i rr'="" d 
 .s buomdr=$p(^INCI(+inclbrowid,1),"^",10)
 .s fact=+##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 .s bqty=+qty*fact
 .s ret=..UpInclbResQty(inclbrowid,bqty)
 .&sql(update dhc_inistrfitm set dhciti_newsp=:newsp,dhciti_newspamt=:newspamt where initi_rowid=:rr)
 q rr
}

ClassMethod UpdateDHCDetail(ListDl, MDLG) As %String
{
 n (ListDl,MDLG)
 k PLIST
 
 f i=0:1:24 s PLIST(i)=""
 s PLIST=24
 s uomdr="",uom="" 
 s itmcode=$P(ListDl,"^",1)
 s qty=+$P(ListDl,"^",2)
 s uom=$P(ListDl,"^",3)
 s ttype=$P(ListDl,"^",4) ;transfer type
 s inclbrowid=$P(ListDl,"^",5)
 s aspflag=$p(ListDl,"^",6)     ;adjsp flag
 S HospID=..GetHospIDByInit(+MDLG)
 s uomdr=##class(web.DHCSTCOMMONSRV).CTUOMToID(uom)
 s ss=itmcode_"^"_""_"^"_uom
 s sp=+##class(web.DHCSTCOMMONSRV).GetItemSp(ss,HospID)
 s pricedata=##class(web.DHCSTPRICE).LastPrice(inclbrowid,uomdr)
 s pp=+$p(pricedata,"^",1)
 s rp=+$p(pricedata,"^",2)
 s ppa=+(pp*qty)
 s rpa=+(rp*qty)
 s spa=+(+sp*qty)
 s newsp=##class(web.DHCSTCALSP).BatSpUom(inclbrowid,uomdr)
 s newsp=+newsp
 s newspamt=+(newsp*qty)
 s hosp=##class(web.DHCSTCUSTOMER).GetCustomer()
 i hosp="SG" d
 .s ppa=+$fn(ppa,"",2)
 .s rpa=+$fn(rpa,"",2)
 .s spa=+$fn(spa,"",2)
 .s newspamt=+$fn(newspamt,"",2)
 s ret=##class(web.DHCSTMVBSTTRI).SELECT(MDLG)
 s yqty=+PLIST(7)
 S yuomdr=PLIST(14)
 s PLIST(5)=inclbrowid
 s PLIST(7)=qty ;qty
 s PLIST(14)=uomdr  ;uom - ROWID
 s PLIST(11)=ttype
 s PLIST(12)=sp
 s PLIST(17)=ppa
 s PLIST(18)=pp
 s PLIST(19)=rp
 s PLIST(20)=rpa
 s PLIST(21)=sp
 s PLIST(22)=spa
 s PLIST(24)=aspflag
 s PLIST(25)=newsp
 s PLIST(26)=newspamt
 s ret=##class(web.DHCSTMVBSTTRI).UPDATE()
 i ret=0 d
 .s buomdr=$p(^INCI(+inclbrowid,1),"^",10)
 .s fact=+##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 .S yfact=+##class(web.DHCSTCOMMONSRV).UOMFac(yuomdr,buomdr)
 .s bqty=+qty*fact      ;本次保存的基本数量
 .s byqty=+yqty*yfact    ;原基本数量
 .s aqty=bqty-byqty     ;需要更新的占用数量
 .s ret=..UpInclbResQty(inclbrowid,aqty)
 q ret
}

/// ;-->>to medtrak
/// ;DHC_InIsTrf -> INISTrf according to TransNo
ClassMethod IntoMainFDHC(TransNo) As %String
{
 /*
 ;s TransNo="XYC20040611_02"
 s datas=$$SelctByNo^DHCSTMVBSTTR(TransNo)
 q:'datas ""
 f i=1:1:18 s PLIST(i)=""
 s PLIST(3)=$p(datas,"^",1)   ;date
 s PLIST(4)=$p(datas,"^",2)   ;time
 s PLIST(5)=$p(datas,"^",3)   ;RowID of providing loc
 s PLIST(6)=$p(datas,"^",4)   ;RowID of request loc
 s PLIST(7)=$p(datas,"^",5)   ;UserRowid
 i $p(datas,"^",6)'="" s PLIST(11)=$p(datas,"^",6)      ;RequestRowID
 s TrNo=$p(datas,"^",7)
 s ret=$$INSERT^MVBSTTR()
 s P9=$g(%ROWID)
 
 i $g(%ROWID)'="" d
  .s ret=$$UpdTrNo(P9,TrNo)  ;Update TransNo
 q P9
 */
 q ""
}

/// ; DHC_INIsTrfItm -> IN_IsTrfItm according to TransNo,ReqNo,FromLocDesc
ClassMethod IntoDetailFDHC(MainID, ReqNo, FLoc) As %String
{
  /*
 ;s MainID="XYC20040831_05"
 ;s ReqNo=""
 ;s FLoc="xyk-西药库"
 s ret=$$DHCGetDetail^DHCSTLGSTST1(MainID,ReqNo)
 s cnum=P5
 i cnum>0 d
 .f j=1:1:cnum d
 ..s ret=$$ListDetail^DHCSTLGSTST1(j)
 ..s dhcItmRid=PLIST(12)
 ..s ListData=PLIST(1)_"^"_PLIST(3)_"^"_PLIST(5)_"^"_PLIST(6)_"^"_$E(PLIST(8),1,1)_"^"_FLoc_"^"_PLIST(7)_"^"_PLIST(17)
 ..s rid=$$IntoDetail(ListData,MainID)
 ..s ret=$$UpdateIsTrfIDR^DHCSTMVBSTTRI(dhcItmRid,rid)
 
 q rid
  */
 q ""
}

/// ;Delete inTrans and Qty of the transfer by the tranno
ClassMethod DelTrans(trno) As %String
{
 q:trno="" -1
 n trid,trisub,triid,ret,merr
 s trid=..DHCStrNoToRowid(trno)
 q:(trid="")!(trid=0) -2
 s trfsub="",ret="",merr="0"
 f  s trfsub=$o(^DHCINIT(trid,"ITI",trfsub)) q:(trfsub="")!(trfsub=0)!(merr<0)  d
 .s triid=trid_"||"_trfsub
 .//s ret=$$DelIntrs^DHCSTLOCDTOTAL("T",triid)
 .s ret=##class(web.DHCSTLOCDTOTAL).DelIntrs("T",triid)  //此处有点问题 zhwh 2010-12-26
 .i ret<0 s merr=ret q
 q:merr<0 merr
 q 0
}

/// ;-->>get request infor
ClassMethod GetReqDetail(ID) As %String
{
 &sql(DECLARE DetailCur CURSOR
 FOR SELECT INRQI_INCI_DR->INCI_CODE,INRQI_INCI_DR->INCI_DESC,INRQI_REQQTY,INRQI_CTUOM_DR->CTUOM_DESC
 FROM IN_REQITM
 WHERE INRQI_INRQ_PARREF->INRQ_NO=:ID  )
   
 &sql(open DetailCur)
 s num=1
 f  &sql(fetch DetailCur INTO :ItemCode(num),:Item(num),:Number(num),:Part(num)) q:SQLCODE  d  
 .s num=num+1
 &sql(close DetailCur)
 s P5=0
 s P5=num-1   
 q 0   
 ;PLIST
}

ClassMethod ListReqDetail(i) As %String
{
 K PLIST
 s PLIST=9
 s PLIST(1)=ItemCode(i) ;
 s PLIST(2)=Item(i)     ;    
 s PLIST(3)=$p(Number(i),$c(1),2)     ;
 s PLIST(4)=Part(i)     ;  
 q 0
}

/// ;-->>Get inclb infor
ClassMethod GetTimeQTY(ITEMCODE, CTLOCDESC, HospCode, Stktype) As %String
{
 &sql(DECLARE TimeCurr CURSOR FOR
 SELECT INCLB_INCIB_DR,INCLB_ROWID,INCLB_INCIB_DR->INCIB_NO,
 INCLB_INCIB_DR->INCIB_EXPDATE,INCLB_PHYQTY,INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_Hospital_DR
 FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF->INCIL_INCI_PARREF->INCI_CODE=:ITEMCODE
 AND INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_DESC=:CTLOCDESC
 order by INCLB_ROWID desc   )
 &sql(open TimeCurr)
 s num=1
 f  &sql(fetch TimeCurr INTO :IBN(num),:CLB(num),:TimeID(num),
 :ExpTime(num),:PHYQTY(num),:HospID)     q:SQLCODE  d
 .s Eqty(num)=##class(web.DHCSTSTKQTY).CurQtyINCLB(CLB(num))
 .S HospID=$P(HospID,$C(1))
 .s Price(num)=..GetSP(ITEMCODE,HospID)
 .s BatSalePrice(num)=##class(web.DHCSTCALSP).BatSp(CLB(num))  ;2006-10-02
 .s num=num+1
 &sql(close TimeCurr) 
 s P5=0
 s P5=num-1   
 q +P5
}

ClassMethod GetOptId(opt) As %String
{
 s opt=$p(opt,"~",1)
 s optr=""
 i opt'="" d
 .s optr=$o(^DHCOPTYPE(0,"Code",opt,optr))
 q optr
}

ClassMethod GetIpType(inclbt) As %String
{
 s incibt=$$CIBrow^at299(inclbt)
 q:incibt="" ""
 s INGRt=$o(^DHCINGR(0,"GRI_INCIB",incibt,""),-1)
 i INGRt d
 .s IpType= $p(^DHCINGR(INGRt),"^",23)
 q $g(IpType)
}

ClassMethod GetTimeQTYBYIpType(ITEMCODE, CTLOCDESC, HospCode, Stktype, IpGup) As %String
{
 s ipt=..GetOptId(IpGup)
 &sql(DECLARE TimeCip CURSOR FOR
 SELECT INCLB_INCIB_DR,INCLB_ROWID,INCLB_INCIB_DR->INCIB_NO,
 INCLB_INCIB_DR->INCIB_EXPDATE,INCLB_PHYQTY,INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_Hospital_DR
 FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF->INCIL_INCI_PARREF->INCI_CODE=:ITEMCODE
 AND INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_DESC=:CTLOCDESC
 order by INCLB_ROWID desc   )
 &sql(open TimeCip)
 s num=1
 f  &sql(fetch TimeCip INTO :IBN(num),:CLB(num),:TimeID(num),
 :ExpTime(num),:PHYQTY(num),:HospID)     q:SQLCODE  d
 .s ipgtype=..GetIpType(CLB(num))
 .q:(ipt'="")&(ipgtype'=ipt)
 .s Eqty(num)=##class(web.DHCSTSTKQTY).CurQtyINCLB(CLB(num))
 .S HospID=$P(HospID,$C(1))
 .s Price(num)=..GetSP(ITEMCODE,HospID)
 .s BatSalePrice(num)=##class(web.DHCSTCALSP).BatSp(CLB(num))  ;2006-10-02
 .s num=num+1
 &sql(close TimeCip) 
 s P5=0
 s P5=num-1   
 q +P5
}

ClassMethod GetTimeQTYbyID(CLBRowid, ITEMCODE1, HospCode1, Stktype1) As %String
{
 ;n (CLBRowid,ITEMCODE1,HospCode1,Stktype1)
 &sql(SELECT INCLB_INCIB_DR,INCLB_INCIB_DR->INCIB_NO,
 INCLB_INCIB_DR->INCIB_EXPDATE,INCLB_PHYQTY,INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_Hospital_DR
 INTO :IBN1,:TimeID1,:ExpTime1,:PHYQTY1,:HospID
 FROM INC_ITMLCBT 
 WHERE INCLB_ROWID=:CLBRowid)
 q:IBN1="" -1
 S HospID=$P(HospID,$C(1))    
 i HospCode1="LF"  d
 .s item=ITEMCODE1_"^"_IBN1  ;if the sale price is batch mode (Such as "LF")
 .s Price1=..GetSP(item,HospID)
 s Eqty=##class(web.DHCSTSTKQTY).CurQtyINCLB(CLBRowid)
 s Price1=..GetSP(ITEMCODE1,HospID)  
 K PLIST
 f i=1:1:5  s PLIST(i)=""
 s Rprice1=0
 s PLIST(1)=TimeID1   ;
 s PLIST(2)=$zd(ExpTime1,3)  ; 
 s PLIST(3)=+Eqty     ;STQty
 s PLIST(4)=Price1    ;sp
 s RP=##class(web.DHCSTPRICE).LastInPrice(CLBRowid,"")
 s PLIST(5)=$g(RP)     ;rprice
 s PLIST(6)=##class(web.DHCSTCALSP).BatSp(CLBRowid)
 s PLIST=$o(PLIST(""),-1)
 q 0
}

/// ;by expdate
ClassMethod GetTimeQTYObExp(ITEMCODE, CTLOCDESC, HospCode, Stktype, reqqty) As %String
{
 &sql(DECLARE CurrExp CURSOR FOR
 SELECT INCLB_INCIB_DR,INCLB_ROWID,INCLB_INCIB_DR->INCIB_NO,
 INCLB_INCIB_DR->INCIB_EXPDATE,INCLB_PHYQTY,INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_Hospital_DR
 FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF->INCIL_INCI_PARREF->INCI_CODE=:ITEMCODE
 AND INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_DESC=:CTLOCDESC
 order by INCLB_INCIB_DR->INCIB_EXPDATE )
 &sql(open CurrExp)
 s num=1
 f  &sql(fetch CurrExp INTO :IBN(num),:CLB(num),:TimeID(num),
 :ExpTime(num),:PHYQTY(num),:HospID)     q:SQLCODE  d      
 .s Eqty(num)=##class(web.DHCSTSTKQTY).CurQtyINCLB(CLB(num))
 .s ResQty(num)=..GetInclbResQty(CLB(num),"")
 .s AvaQty(num)=Eqty(num)-ResQty(num)
 .;q:$g(AvaQty(num))<$g(reqqty)
 .S HospID=$P(HospID,$C(1))
 .s Price(num)=..GetSP(ITEMCODE,HospID)
 .s BatSalePrice(num)=##class(web.DHCSTCALSP).BatSp(CLB(num))  ;2006-10-02
 .s num=num+1
 .;s ITEMCODE=""
 &sql(close CurrExp) 
 s P5=0
 s P5=num-1   
 q +P5
}

/// ;by stk_qty and expdate
ClassMethod GetTimeQTYFReqObExp(ITEMCODE, CTLOCDESC, HospCode, Stktype, reqqty) As %String
{
 &sql(DECLARE CurrFQty CURSOR FOR
 SELECT INCLB_INCIB_DR,INCLB_ROWID,INCLB_INCIB_DR->INCIB_NO,
 INCLB_INCIB_DR->INCIB_EXPDATE,INCLB_PHYQTY,INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_Hospital_DR
 FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF->INCIL_INCI_PARREF->INCI_CODE=:ITEMCODE
 AND INCLB_INCIL_PARREF->INCIL_CTLOC_DR->CTLOC_DESC=:CTLOCDESC
 order by INCLB_INCIB_DR->INCIB_EXPDATE )
 &sql(open CurrFQty)
 s num=1
 f  &sql(fetch CurrFQty INTO :IBN(num),:CLB(num),:TimeID(num),
 :ExpTime(num),:PHYQTY(num),:HospID)     q:SQLCODE  d      
 .s Eqty(num)=##class(web.DHCSTSTKQTY).CurQtyINCLB(CLB(num))
 .s ResQty(num)=..GetInclbResQty(CLB(num),"")
 .s AvaQty(num)=Eqty(num)-ResQty(num)
 .q:$g(AvaQty(num))<$g(reqqty)
 .;q:$g(Eqty(num))<$g(reqqty)
 .S HospID=$P(HospID,$C(1))
 .s Price(num)=..GetSP(ITEMCODE,HospID)
 .s BatSalePrice(num)=##class(web.DHCSTCALSP).BatSp(CLB(num))  ;2006-10-02
 .s num=num+1
 &sql(close CurrFQty) 
 s P5=0
 s P5=num-1   
 q +P5
}

ClassMethod ListReq(i) As %String
{
  
 K PLIST s Rprice=0
 s PLIST(1)=TimeID(i) ;
 s PLIST(2)=$zd(ExpTime(i),3) ;
 s PLIST(3)=+Eqty(i)   ;Basic Uom Qty
 s PLIST(4)=Price(i)  ;
 s PLIST(5)=CLB(i)
 s RPprice=##class(web.DHCSTPRICE).LastPrice(CLB(i),"")
 s Rprice="",Pprice=""
 i $g(RPprice)'="" d
 .s Rprice=$p(RPprice,"^",2)
 .s Pprice=$p(RPprice,"^",1)
 s PLIST(6)=Rprice
 s PLIST(7)=Pprice
 s PLIST(8)=..GetInclbResQty(CLB(i),"")
 s PLIST(9)=PLIST(3)-PLIST(8)
 s PLIST(10)=$g(BatSalePrice(i))  ;2006-10-02
 s PLIST(11)=..GetBatRecDate(CLB(i))
 S PLIST(12)=$p(..GetInclbVend(CLB(i),+$H),"^",2)	//供应商
 s PLIST=$o(PLIST(""),-1)
 q 0
}

/// ;-->>Else
ClassMethod GetSP(item, HospID) As %String
{
   
 s sp=""
 s sp=$p(##class(web.DHCSTCOMMONSRV).GetItemSp(item,HospID),"^",1)
 q sp
}

ClassMethod ReqNoToRowid(PD) As %String
{
 &sql(SELECT INRQ_ROWID INTO :BPd FROM IN_REQUEST WHERE INRQ_NO=:PD)
 q $g(BPd)
}

ClassMethod StrNoToRowid(MDIDI) As %String
{
 q:MDIDI="" ""
 s MDIDI=$$ALPHAUP^SSUTIL4(MDIDI)
 s rd=0,rd=$o(^INIT(0,"No",MDIDI,rd))
 q $g(rd)
}

ClassMethod DHCTrRowidToNo(PM) As %String
{
      
 &sql(SELECT INIT_NO INTO :BB FROM DHC_INISTRF WHERE INIT_ROWID=:PM)
 S P6=$g(BB)   
 q $g(BB)
}

ClassMethod DHCStrNoToRowid(MDIDI) As %String
{
 q:MDIDI="" ""
 s MDIDI=$$ALPHAUP^SSUTIL4(MDIDI)
 s rd=0,rd=$o(^DHCINIT(0,"No",MDIDI,rd))
 q $g(rd)
}

/// ;Get RequLoc inclb By ProvLoc Inclb and RequLocDesc
ClassMethod GetRequInclb(ProvLocInclb, RequLoc) As %String
{
 n (ProvLocInclb,RequLoc)
 q:ProvLocInclb="" -1
 q:RequLoc="" -1
 s inci="",incilsub="",inclbsub="",incib=""
 s requlocdr="",rincilsub="",rinclbsub="",rinclb=""
 s inci=$p(ProvLocInclb,"||",1)  q:inci="" -1
 s incilsub=$p(ProvLocInclb,"||",2) q:incilsub="" -1
 s inclbsub=$p(ProvLocInclb,"||",3) q:inclbsub="" -1
 q:'$d(^INCI(inci,"IL",incilsub,"LB",inclbsub)) -1
 s incib=$p(^INCI(inci,"IL",incilsub,"LB",inclbsub),"^",1) q:incib="" -1
 s requlocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(RequLoc) q:requlocdr="" -1
 s rincilsub=$o(^INCI("IL_LOC",requlocdr,inci,0)) q:rincilsub="" -1
 s rinclbsub=$o(^INCI("LB_IB",incib,inci,rincilsub,0)) q:rinclbsub="" -1
 s rinclb=inci_"||"_rincilsub_"||"_rinclbsub
 q rinclb
}

ClassMethod InsRequInclb(ProvLocInclb, RequLoc) As %String
{
 n (ProvLocInclb,RequLoc)
 q:ProvLocInclb="" -1
 q:RequLoc="" -1
 s inci="",incilsub="",inclbsub="",incib=""
 s requlocdr="",ibsub="",batno="",expdate="",inclb=""
 s inci=$p(ProvLocInclb,"||",1)  q:inci="" -1
 s incilsub=$p(ProvLocInclb,"||",2) q:incilsub="" -1
 s inclbsub=$p(ProvLocInclb,"||",3) q:inclbsub="" -1
 q:'$d(^INCI(inci,"IL",incilsub,"LB",inclbsub)) -1
 s incib=$p(^INCI(inci,"IL",incilsub,"LB",inclbsub),"^",1) q:incib="" -1
 s requlocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(RequLoc) q:requlocdr="" -1
 s ibsub=$p(incib,"||",2) q:ibsub="" -1
 q:($d(^INCI(inci,"IB",ibsub))=0)!($d(^INCI(inci,"IB",ibsub))=10) -1
 s batno=$p(^INCI(inci,"IB",ibsub),"^",1) ;q:batno="" -1
 s expdate=$p(^INCI(inci,"IB",ibsub),"^",2) ;q:expdate="" -1
 s inclb=$$CHKIMLB^ST01(inci,requlocdr,batno,expdate)
 i inclb="" s inclb=$$INSIMLB^ST01(inci,requlocdr,batno,expdate)
 q inclb
}

ClassMethod MakeUpStk(inclbrowid, qty, uomid) As %String
{
 ; Makeup the stock qty of providing location to be enough
 n (inclbrowid,qty,uomid)
 s inci=+inclbrowid q:inci<1 -1
 s buom=$P(^INCI(inci,1),"^",10)
 s fac=##class(web.DHCSTCOMMONSRV).UOMFac(uomid,buom)
 s qty=qty*fac
 s ch=$p(inclbrowid,"||",2),lb=$p(inclbrowid,"||",3)
 q:ch="" -1
 q:lb="" -1
 s curLbQty=$p(^INCI(inci,"IL",ch,"LB",lb),"^",2)
 i qty>curLbQty d
  . s diffqty=qty-curLbQty
  . d UPDINV1^ST01(inclbrowid,diffqty)
 q 0
}

ClassMethod UpInclbResQty(inclb, qty) As %String
{
 ;Set Qty of inclb that Tranfered but not Outchecked 
 q:inclb="" -1
 q:qty="" -1
 n inci,ilsub,lbsub,dqty,eqty
 s inci="",ilsub="",lbsub="",dqty=0
 s inci=$p(inclb,"||",1) q:inci="" -2
 s ilsub=$p(inclb,"||",2) q:ilsub="" -2
 s lbsub=$p(inclb,"||",3) q:lbsub="" -2
 q:'$d(^INCI(inci,"IL",ilsub,"LB",lbsub)) -3
 l +^INCI(inci,"IL",ilsub,"LB",lbsub):10 E  Q -4 ;Lock
 s dqty=+$p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",3)
 s eqty=dqty+qty
 i eqty<0  d   ;2006-07-27 add
 .s eqty=0
 s eqty=+eqty
 s $p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",3)=eqty
 l -^INCI(inci,"IL",ilsub,"LB",lbsub)
 ;&sql(Update INC_ItmLcBt set INCLB_DirtyQty=:eqty)
 q 0
}

ClassMethod UpTransResQty(trno, flag) As %String
{
 n tid,tsub,tqty,tuomdr,tinclb,buomdr,fact,tbqty
 s tsub="0"
 s tid=..DHCStrNoToRowid(trno) q:tid="" -1
 f  s tsub=$o(^DHCINIT(tid,"ITI",tsub)) q:tsub=""  d
 .s tinclb=$p(^DHCINIT(tid,"ITI",tsub),"^",3)
 .s tqty=$p(^DHCINIT(tid,"ITI",tsub),"^",1)
 .s tuomdr=$p(^DHCINIT(tid,"ITI",tsub),"^",7)
 .s buomdr=$p(^INCI(+tinclb,1),"^",10)
 .s fact=+##class(web.DHCSTCOMMONSRV).UOMFac(tuomdr,buomdr)
 .s tbqty=tqty*fact
 .;i flag="1" s tbqty=tbqty  ;Completed
 .i flag="2" s tbqty=-tbqty ;Checked
 .d ..UpInclbResQty(tinclb,tbqty)
 q 0
}

ClassMethod UpTrDetaResQty(derid, flag) As %String
{
 n tid,tsub,inclb,qty,uomdr,buomdr,fact,bqty
 s tid=$p(derid,"||",1)
 s tsub=$p(derid,"||",2)
 q:$g(tid)="" -1
 q:$g(tsub)="" -1
 q:($d(^DHCINIT(tid,"ITI",tsub))=0)!($d(^DHCINIT(tid,"ITI",tsub))=10) -2
 s inclb=$p(^DHCINIT(tid,"ITI",tsub),"^",3)
 s qty=$p(^DHCINIT(tid,"ITI",tsub),"^",1)
 s uomdr=$p(^DHCINIT(tid,"ITI",tsub),"^",7)
 s buomdr=$p(^INCI(+inclb,1),"^",10)
 s fact=+##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 s bqty=qty*fact
 i flag="2" s bqty=-bqty
 d ..UpInclbResQty(inclb,bqty)
 q 0
}

ClassMethod GetInclbResQty(inclb, uomdr) As %String
{
 n inci,ilsub,lbsub,dqty,buomdr,qty
 s inci="",ilsub="",lbsub="",dqty=0,qty=0
 s inci=$p(inclb,"||",1) q:inci="" 0
 s ilsub=$p(inclb,"||",2) q:ilsub="" 0
 s lbsub=$p(inclb,"||",3) q:lbsub="" 0
 q:'$d(^INCI(inci,"IL",ilsub,"LB",lbsub)) ""
 s dqty=+$p(^INCI(inci,"IL",ilsub,"LB",lbsub),"^",3)
 s buomdr=$p(^INCI(+inclb,1),"^",10)
 i uomdr="" s uomdr=buomdr
 s fact=+##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 s qty=+dqty/fact
 q qty
}

ClassMethod GetInclbResQtyUom(inclb, uomdesc) As %String
{
 n (inclb,uomdesc)
 s uomdr="",qty=0
 s uomdr=##class(web.DHCSTCOMMONSRV).CTUOMToID(uomdesc) q:uomdr="" 0
 s qty=..GetInclbResQty(inclb,uomdr)
 q qty
}

ClassMethod GetTQtyById(drid, uomdesc) As %String
{
 q:drid="" 0
 n (drid,uomdesc)
 s mid=$p(drid,"||",1),idsub=$p(drid,"||",2)
 q:($g(mid)="")!($g(idsub)="") 0
 q:($d(^DHCINIT(mid,"ITI",idsub))=0)!($d(^DHCINIT(mid,"I",idsub))=10) 0
 s trqty=0,uomdr="",inci="",tuomdr=""
 s trqty=+$p(^DHCINIT(mid,"ITI",idsub),"^",1)
 s tuomdr=+$p(^DHCINIT(mid,"ITI",idsub),"^",7)
 s uomdr=##class(web.DHCSTCOMMONSRV).CTUOMToID(uomdesc)
 s inci=+$p(^DHCINIT(mid,"ITI",idsub),"^",3)
 s buomdr=$p(^INCI(inci,1),"^",10)
 i uomdr="" s uomdr=buomdr
 s fact1=+##class(web.DHCSTCOMMONSRV).UOMFac(uomdr,buomdr)
 s fact2=+##class(web.DHCSTCOMMONSRV).UOMFac(tuomdr,buomdr)
 i tuomdr'=uomdr d
 .i fact2>fact1 s trqty=trqty*fact2
 .e  s trqty=trqty/fact2
 q trqty
}

ClassMethod GetBatRecDate(inclb) As %String
{
 n (inclb)
 s INGRI=##class(web.DHCSTPRICE).LastINGRI(inclb) q:INGRI="" ""
 s DHCINGR=$p(INGRI,"||",1)
 q:'$d(^DHCINGR(DHCINGR))
 s RecDate=$p(^DHCINGR(DHCINGR),"^",14)
 q:RecDate="" ""
 s RecDate=$zd(RecDate,3)
 q RecDate
}

ClassMethod TransferSetup(stktype, str) As %String
{
 s h=1
 s property="" f  s property=$p(str,"||",h)  q:property=""  d
 .s name=$p(property,"^",1)
 .s flag=$p(property,"^",2)
 .s ^DhcStkDataSetup("Transfer",stktype,name)=flag
 .s h=h+1
 q h
}

ClassMethod GetTransferSetup(stktype, name) As %String
{
 q:'$d(^DhcStkDataSetup("Transfer",stktype,name)) ""
 s flag=$g(^DhcStkDataSetup("Transfer",stktype,name))
 q flag
}

ClassMethod GetItemInfo(itemcode, flag) As %String
{
 n (itemcode,flag)
 s str=""
 s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(itemcode)
 s spec=##class(web.DHCSTCOMMONSRV).GetSpec(itemcode,"")
 s genri=##class(web.DHCSTCOMMONSRV).GetPhcGenricByCode(itemcode)
 s form=##class(web.DHCSTCOMMONSRV).GetItmDrugForm(itemcode)
 s str=spec_flag_genri_flag_form
 q str
}

ClassMethod UpdReqloc(trno As %String, reqloc As %String) As %String
{
 N (trno,reqloc)
 Q:trno="" -1
 Q:reqloc="" -2
 S reqlocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(reqloc)
 Q:reqlocdr="" -3
 S trid=$O(^DHCINIT(0,"No",$$ALPHAUP^SSUTIL4(trno),""))
 Q:trid="" -4
 S state=$P($G(^DHCINIT(trid)),"^",14)
 Q:state=31 -999
 &SQL(Update DHC_InIsTrf Set Init_ToLoc_DR=:reqlocdr Where Init_No=:trno)
 Q SQLCODE
}

/// Descript:	根据出库主表ID取医院ID
/// Input:		init-DHC_InIsTrf的Rowid
/// Output:	CT_Hospital的Rowid
ClassMethod GetHospIDByInit(init As %String) As %String
{
 N (init)
 Q:init="" ""
 Q:'$D(^DHCINIT(init)) ""
 S locdr=$P(^DHCINIT(init),"^",5)
 Q:locdr="" ""
 Q:'$D(^CTLOC(locdr)) ""
 S HospID=$P(^CTLOC(locdr),"^",22)
 Q HospID
}

ClassMethod GetClbDHCIngr(inclb As %String, dah As %String) As %String
{
 ;查找截止到某日期的最后一个入库单
 n (inclb,dah)
 s inclb=$g(inclb),dah=$g(dah)
 i dah="" s dah=+$h
 q:inclb="" ""
 s incib=$$CIBrow^at299(inclb) q:incib="" ""
 s tingr="",INGR=""
 s INGR=""
 f  s INGR=$o(^DHCINGR(0,"GRI_INCIB",incib,INGR),-1)  q:(tingr'="")!(INGR="")   d
 . s grdate=$p(^DHCINGR(INGR),"^",4)
 . s:grdate'>dah tingr=INGR
 s dhcingr=tingr
 q:dhcingr="" ""
 q:'$d(^DHCINGR(dhcingr)) ""
 q dhcingr
}

ClassMethod GetInclbVend(inclb As %String, dah As %String) As %String
{
 ;查找截止到某日期的最后一个供应商
 n (inclb,dah)
 q:inclb="" ""
 s dhcingr=..GetClbDHCIngr(inclb,dah)
 q:dhcingr="" ""
 s vendr=$p(^DHCINGR(dhcingr),"^",3)
 q:vendr="" ""
 q:'$d(^APC("APCVM",vendr)) ""
 s vendesc=$p(^APC("APCVM",vendr),"^",3)
 q vendr_"^"_vendesc
}

}
