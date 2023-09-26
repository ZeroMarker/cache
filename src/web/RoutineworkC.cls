Import SQLUser

Class web.RoutineworkC Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

// w ##Class(web.RoutineworkC).CheckPatSorP("3886265")

ClassMethod CheckPatSorP(admId) As %String
{
	s ret="顺产"
	s OrderId=""  ;832858||50
	s OrderId=$O(^OEORD(0,"Adm",admId,""))
 	q:OrderId=""
 	s OrderSub=0
 	s MRAdmRowid=$p($g(^PAADM(admId)),"^",61)
 	s MRDiagnoseDesc=##class(web.Routinework).getdiagnos(MRAdmRowid)
 	s:MRDiagnoseDesc["流产" ret="流产"
 	f  s OrderSub=$O(^OEORD(OrderId,"I",OrderSub)) q:OrderSub=""  d
	.s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	.s status=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	.q:status="2"    //过滤作废医嘱  sunhuan
	.;w !,arcItemRowId
	.if arcItemRowId=("5517||1") d
	..s ret="顺产"
	.if arcItemRowId=("4805||1") d
	..s ret="顺产"
	.s DepProcNotes=$g(^OEORD(OrderId,"I",OrderSub,"DEP",1))
	.if DepProcNotes["剖宫产" d
	..s ret="剖腹产"
	
	
	q ret
}

// w ##class(web.RoutineworkC).InsertDebitCredit("1^200^100^64263^0^0^^")

ClassMethod InsertDebitCredit(data) As %String
{
	//Data="200^100^2016-12-11^0^0^^"
	//     
		
	k PLIST
	
	;b ;insert
	;s data="0"_"^"_data
	s Collection=$p(data,"^",2)
	i Collection'="" s PLIST(2)=Collection           //收预交金
	
	s Refund=$p(data,"^",3)
	i Refund'="" s PLIST(3)=Refund                  //退预交金
	
	s TradeDate=$p(data,"^",4)
	i TradeDate'="" s PLIST(4)=TradeDate            //交易日期
	
	s Margin=$p(data,"^",5)
	i Margin'="" s PLIST(5)=Margin                  //收退差额
	
	
	s Balance=$p(data,"^",6)
	i Balance'="" s PLIST(6)=Balance                //余额
	
	s Str1=$p(data,"^",7)
	i Str1'="" s PLIST(7)=Str1                      //str1
	
	s Str2=$p(data,"^",8)
	i Str2'="" s PLIST(8)=Str2                      //str2

	&SQL(INSERT INTO SQLUser.DHC_DebitCredit VALUES PLIST())
	
	q SQLCODE
}

// d ##class(web.RoutineworkC).GetYJJColAndRef()

ClassMethod GetYJJColAndRef() As %String
{
	s StDate="",EndDate="",Guser=""
	if StDate="" set StDate=+$h-2
    if EndDate="" set EndDate=+$h-2
    if StDate["-" set StDate=$zdh(StDate,3)
    if EndDate["-" set EndDate=$zdh(EndDate,3)
    set job=$j
    set (HandDeposit,HandDepositNum,PatFeeAmt,PatInvNum,PatSelfee,PatCashAmt,PatYHKAmt,PatZPAmt,PatYHAmt,DepositAmt,DepositNum,UserHandAmt,UserHandAmtRMB)=""
    for JKDate=StDate:1:EndDate d
	.set jsrowid="" for  set jsrowid=$o(^DHCJFUSERJK(0,"date",JKDate,jsrowid)) q:jsrowid=""  d
	..q:($d(^DHCSFPRINTDETAIL(0,"JKDR",jsrowid))=0)&&($d(^DHCINVPRTZY(0,"JK",jsrowid))=0)
	..s AddUser=$p(^DHCJFUSERJK(jsrowid),"^",5)
	..q:(AddUser'=Guser)&(Guser'="")
	..s PrtRowID=""
	..f  s PrtRowID=$o(^DHCSFPRINTDETAIL(0,"JKDR",jsrowid,PrtRowID)) q:PrtRowID=""  d   ;^DHCSFPRINTDETAIL(0,"PrtDate",PrtDate,PrtRowID)
	...set PrtStatus=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",8)
	...set PrtStatus=$p(PrtStatus,$c(1))
	...set PrtDepNO=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",1)
	...set PayAmt=+$p(^DHCSFPRINTDETAIL(PrtRowID),"^",6)
	...set PayMode=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",9) 
	...quit:PrtStatus=2 
	...set:(PrtDepNO'="") DepositNum=$g(DepositNum)+1  ;收据张数不统计作废的 yq 20150715
	...set DepositAmt=$g(DepositAmt)+PayAmt
	..set InvRowID=""   
	..for  set InvRowID=$o(^DHCINVPRTZY(0,"JK",jsrowid,InvRowID)) q:InvRowID=""  d 
	...set Acount=$p(^DHCINVPRTZY(InvRowID),"^",6)  
	...set PrtStatus=$p(^DHCINVPRTZY(InvRowID),"^",8)
    ...set PayAmt=+$p(^DHCINVPRTZY(InvRowID),"^",6)
    ...set PBRowID=$p(^DHCINVPRTZY(InvRowID),"^",5)
    ...set Deposit=$p(^DHCINVPRTZY(InvRowID),"^",22)
	...quit:PrtStatus="A"
	...if $d(^DHCJFDepositRowID("ZYJF",PBRowID)) d
	....set DepInfo=^DHCJFDepositRowID("ZYJF",PBRowID)
	....for i=1:1:$l(DepInfo,"^") d
	.....set yjrowid=$p(DepInfo,"^",i)
	.....set depositDr=$p(yjrowid,"!",1)
	.....set depositStatus=$p(yjrowid,"!",2)
	.....quit:depositStatus="2"   ;如果押金状态为"作废",则退出 
	.....set payMDr=$p(^DHCSFPRINTDETAIL(depositDr),"^",9)  ;prt_paymode->CT_PayMode 
	.....set amount=$p(^DHCSFPRINTDETAIL(depositDr),"^",6) 
	.....if PrtStatus="S"  d
	......set HandDeposit=$g(HandDeposit)-amount
	.....else  d
	......set HandDeposit=$g(HandDeposit)+amount
	q DepositAmt_"^"_HandDeposit
}

// w ##class(web.RoutineworkC).GetYJJColAndRefDate("2019-10-05","2019-10-05","")

ClassMethod GetYJJColAndRefDate(StDate, EndDate, Guser) As %String
{
	;s StDate="",EndDate="",Guser=""
	;if StDate="" set StDate=+$h-2
    ;if EndDate="" set EndDate=+$h-2
    if StDate["-" set StDate=$zdh(StDate,3)
    if EndDate["-" set EndDate=$zdh(EndDate,3)
    set job=$j
    set (HandDeposit,HandDepositNum,PatFeeAmt,PatInvNum,PatSelfee,PatCashAmt,PatYHKAmt,PatZPAmt,PatYHAmt,DepositAmt,DepositNum,UserHandAmt,UserHandAmtRMB)="0"
    for JKDate=StDate:1:EndDate d
	.set jsrowid="" for  set jsrowid=$o(^DHCJFUSERJK(0,"date",JKDate,jsrowid)) q:jsrowid=""  d
	..q:($d(^DHCSFPRINTDETAIL(0,"JKDR",jsrowid))=0)&&($d(^DHCINVPRTZY(0,"JK",jsrowid))=0)
	..s AddUser=$p(^DHCJFUSERJK(jsrowid),"^",5)
	..q:(AddUser'=Guser)&(Guser'="")
	..s PrtRowID=""
	..f  s PrtRowID=$o(^DHCSFPRINTDETAIL(0,"JKDR",jsrowid,PrtRowID)) q:PrtRowID=""  d   ;^DHCSFPRINTDETAIL(0,"PrtDate",PrtDate,PrtRowID)
	...set PrtStatus=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",8)
	...set PrtStatus=$p(PrtStatus,$c(1))
	...set PrtDepNO=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",1)
	...set PayAmt=+$p(^DHCSFPRINTDETAIL(PrtRowID),"^",6)
	...set PayMode=$p(^DHCSFPRINTDETAIL(PrtRowID),"^",9) 
	...quit:PrtStatus=2 
	...set:(PrtDepNO'="") DepositNum=$g(DepositNum)+1  ;收据张数不统计作废的 yq 20150715
	...set DepositAmt=$g(DepositAmt)+PayAmt
	...;w !,PayAmt
	..set InvRowID=""   
	..for  set InvRowID=$o(^DHCINVPRTZY(0,"JK",jsrowid,InvRowID)) q:InvRowID=""  d 
	...set Acount=$p(^DHCINVPRTZY(InvRowID),"^",6)  
	...set PrtStatus=$p(^DHCINVPRTZY(InvRowID),"^",8)
    ...set PayAmt=+$p(^DHCINVPRTZY(InvRowID),"^",6)
    ...set PBRowID=$p(^DHCINVPRTZY(InvRowID),"^",5)
    ...set Deposit=$p(^DHCINVPRTZY(InvRowID),"^",22)
	...quit:PrtStatus="A"
	...if $d(^DHCJFDepositRowID("ZYJF",PBRowID)) d
	....set DepInfo=^DHCJFDepositRowID("ZYJF",PBRowID)
	....for i=1:1:$l(DepInfo,"^") d
	.....set yjrowid=$p(DepInfo,"^",i)
	.....set depositDr=$p(yjrowid,"!",1)
	.....set depositStatus=$p(yjrowid,"!",2)
	.....quit:depositStatus="2"   ;如果押金状态为"作废",则退出 
	.....set payMDr=$p(^DHCSFPRINTDETAIL(depositDr),"^",9)  ;prt_paymode->CT_PayMode 
	.....set amount=$p(^DHCSFPRINTDETAIL(depositDr),"^",6) 
	.....if PrtStatus="S"  d
	......set HandDeposit=$g(HandDeposit)-amount
	.....else  d
	......set HandDeposit=$g(HandDeposit)+amount
	q DepositAmt_"^"_HandDeposit
}

// 运行此方法将财务预交金数据插入DHC_DebitCredit表

// w ##class(web.RoutineworkC).GetYJJDate()

ClassMethod GetYJJDate() As %String
{
	
	s Sdate=$h-1
	s Edate=$h-1
	s Colection=0,Refund=0,magi=0
	s InputStr=""
	s retu="",ret=""
	f idate=Sdate:1:Edate  d
	.s Str=..GetYJJColAndRefDate(idate,idate,"")
	.s OldAmt=..GetYestAmt((idate-1))
	.s Colection=$p(Str,"^",1)
	.s Refund=$p(Str,"^",2)
	.s magi=Colection-Refund
	.s InputStr="1^"_Colection_"^"_Refund_"^"_idate_"^"_magi_"^"_(OldAmt+magi)_"^^"            ;200^100^64263^0^0^^
	.s Flag=..GetYESORNO(idate)
	.if Flag="-1" d
	..s ret=..InsertDebitCredit(InputStr)
	..s retu=ret_"^"_retu
	.else  d
	..s ret="-1"
	..s retu=ret_"^"_retu
	q retu
}

// w ##class(web.RoutineworkC).GetYESORNO("64266")

ClassMethod GetYESORNO(date) As %String
{
	
	s DCrowid="",ret="-1"
	f  s DCrowid=$o(^DHCDCAMTTrade("Date",date,DCrowid))  q:DCrowid=""  d
	.s ret=DCrowid
	q ret
}

ClassMethod GetYestAmt(date) As %String
{
	
	s DCrowid="",OldAmt="0",ret="0"
	if date<"63683" d
	.s ret=0
	if date="63683" d
	.s ret=0
	f  s DCrowid=$o(^DHCDCAMTTrade("Date",date,DCrowid))  q:DCrowid=""  d
	.s OldAmt=$p(^DHCDCAMT(DCrowid),"^",5)
	s ret=OldAmt
	q ret
}

// w ##class(web.RoutineworkC).GetInsuTarCode("5165")

ClassMethod GetInsuTarCode(Tari, Type) As %String
{
	
	s Contrastid="",InsuCode="",InsuDesc=""
	f  s Contrastid=$O(^DHCINTCT("0","DHCTID",Tari,Contrastid))  q:Contrastid=""  d
	.s InsuType=$p($g(^DHCINTCT(Contrastid)),"^",12)
	.q:InsuType'=Type
	.s InsuCode=$p($g(^DHCINTCT(Contrastid)),"^",5)
	.s InsuDesc=$p($g(^DHCINTCT(Contrastid)),"^",6)
	q InsuCode_"^"_InsuDesc
}

ClassMethod INDPAY(INDPAY) As %String
{
	s insuDivID=""
	s PrtAcount=$p(^DHCINVPRT(INDPAY),"",1)
	s Grzf=PrtAcount
	s insuDivID=$O(^DHCINDIV("0","DHCInvPrt",INDPAY,insuDivID))
	if insuDivID'="" {
	s Grzf=$p(^DHCINDIV(insuDivID),"^",15)
	}
	else 
	{  
		s Grzf=PrtAcount
		
		} 
		
	q Grzf
}

// w ##class(web.RoutineworkC).INDPAYIP("2543478")

ClassMethod INDPAYIP(IPrtid) As %String
{
	s insuDivID=""
	s PrtAcount=""
	s Grzf=PrtAcount
	s insuDivID=$O( ^DHCINDIV("0","DHCPB",IPrtid,insuDivID) )
	if insuDivID'="" {
	s Grzf=$p(^DHCINDIV(insuDivID),"^",15)
	}
	else 
	{  
		s Grzf=PrtAcount
		
		} 
		
	q Grzf
}

ClassMethod GetPaadmID(PrtRowID) As %String
{
	s Conid=""
	f  s Conid=$O(^DHCBCI(0,"INV",PrtRowID,Conid)) q:Conid=""  d
	.s Adm=$P(^DHCBCI(Conid),"^",3)
	
	q Adm
}

// 通过发票或者账单号获取相应的收费项目并且转换为医保码

// w ##class(web.RoutineworkC).GetTaritemByInvPB("2200208","")

// 

// w ##class(web.RoutineworkC).GetTaritemByInvPB("","2546142")

ClassMethod GetTaritemByInvPB(PrtRowID, PB) As %GlobalCharacterStream
{
		
	
	k ^TMPRet
	s i=1
	s Sub1="0",Sub2="0",Sum=0,ret="",i=""
	if (PrtRowID'="")&&(PB="") d
	.s Conid=""
	.f  s Conid=$O(^DHCBCI(0,"INV",PrtRowID,Conid)) q:Conid=""  d
	..s PBDR=$P(^DHCBCI(Conid),"^",2)
	..f  s Sub1=$O(^DHCPB(PBDR,"O",Sub1)) q:Sub1=""  d
	...f  s Sub2=$O(^DHCPB(PBDR,"O",Sub1,"D",Sub2))  q:Sub2=""   d
	....s Taritem=$P(^DHCPB(PBDR,"O",Sub1,"D",Sub2),"^",3)
	....q:Taritem=""
	....s TarAcCat=$p(^DHCTARI(Taritem),"^",5)
	....s YBFL=..HisTypeToArea(TarAcCat)
	....s YBTar=..GetInsuTarCode(Taritem,"XZFYA")
	....s YBCode=$p(YBTar,"^",1)
	....s YBDesc=$p(^DHCTARI(Taritem),"^",2)
	....S Price=$P(^DHCPB(PBDR,"O",Sub1,"D",Sub2),"^",4)
	....S Qty=$P(^DHCPB(PBDR,"O",Sub1,"D",Sub2),"^",5)
	....s Amt=$P(^DHCPB(PBDR,"O",Sub1,"D",Sub2),"^",7)
	....s itmid=PBDR_"_"_Sub1_"_"_Sub2
	....if ret="" d
	.....s ret=YBCode_"^"_YBDesc_"^"_YBFL_"^"_Price_"^"_Qty_"^"_Amt_"^"_itmid
	....else  d
	.....s ret=ret_"!"_YBCode_"^"_YBDesc_"^"_YBFL_"^"_Price_"^"_Qty_"^"_Amt_"^"_itmid
	if (PrtRowID="")&&(PB'="") d
	.f  s Sub1=$O(^DHCPB(PB,"O",Sub1)) q:Sub1=""  d
	..f  s Sub2=$O(^DHCPB(PB,"O",Sub1,"D",Sub2))  q:Sub2=""   d
	...s Taritem=$P(^DHCPB(PB,"O",Sub1,"D",Sub2),"^",3)
	...q:Taritem=""

	...S Price=$P(^DHCPB(PB,"O",Sub1,"D",Sub2),"^",4)
	...S Qty=$P(^DHCPB(PB,"O",Sub1,"D",Sub2),"^",5)
	...s Amt=$P(^DHCPB(PB,"O",Sub1,"D",Sub2),"^",7)
	...s itmid=PB_"_"_Sub1_"_"_Sub2
	...s Sum=Sum+Amt
	...q:Price=0
	...s TarAcCat=$p(^DHCTARI(Taritem),"^",5)
	...s YBFL=..HisTypeToArea(TarAcCat)
	...s YBTar=..GetInsuTarCode(Taritem,"XZFYA")

	...s YBCode=$P(YBTar,"^",1)
	...s YBDesc=$P(YBTar,"^",2)
	...s:ret="" ret=1
	...s ^TMPRet(PB,ret)=YBCode_"^"_YBDesc_"^"_YBFL_"^"_Price_"^"_Qty_"^"_Amt_"^"_itmid
	...s ret=ret+1
	q ret
	/*...if $g(^TMPRet)="" d
	....s ^TMPRet=YBCode_"^"_YBDesc_"^"_YBFL_"^"_Price_"^"_Qty_"^"_Amt
	...else  d
	....s ^TMPRet=$g(^TMPRet)_"!"_YBCode_"^"_YBDesc_"^"_YBFL_"^"_Price_"^"_Qty_"^"_Amt */


	;set RtStream=##class(%GlobalCharacterStream).%New()
	;do ret.XMLExportToStream(.RpStream,"Response")
	;d objResultRp.XMLExport(.string)
	;d objResultRp.%Close()
	;w !,string
 	;q RpStream
}

ClassMethod HisTypeToArea(ACCat) As %String
{
	s ret="9999"
	if ACCat="1" {
		s ret="0703"
		}
	elseif ACCat="2" {
		s ret="9900"
		}
	elseif ACCat="3" {
		s ret="0101"
		}		
	elseif ACCat="4" {
		s ret="0101"
		}
	elseif ACCat="5" {
		s ret="0102"
		}
	elseif ACCat="6" {
		s ret="0200"
		}
	elseif ACCat="7" {
		s ret="0199"
		}
	elseif ACCat="8" {
		s ret="0103"
		}
	elseif ACCat="9" {
		s ret="0900"
		}
	elseif ACCat="10" {
		s ret="0202"
		}
	elseif ACCat="11" {
		s ret="0303"
		}
	elseif ACCat="12" {
		s ret="0600"
		}
	elseif ACCat="13" {
		s ret="0701"
		}
	else 
	{
		s ret="9999"
		}
		
	q ret
}

ClassMethod GetDocNameByOeord(Oeord) As %String
{
	
	q:Oeord="" "无"
	s OrdDocID="",UseraddID=""
	s PBord=Oeord
	set OrdDocID=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),1)),"^",11)
	set UseraddID=$p($g(^OEORD(+PBord,"I",$p(PBord,"||",2),7)),"^",1)
	S:OrdDocID'="" OrdDoc=$p($g(^CTPCP(OrdDocID,1)),"^",2)
	s:OrdDocID="" OrdDoc=$p($g(^SSU("SSUSR",UseraddID)),"^",2)
	;s:OrdDoc="" OrdDoc=$p()
	q OrdDoc
}

// w ##class(web.RoutineworkC).GetYBCodeBYoeord("879486||16")

ClassMethod GetYBCodeBYoeord(OEORdItm) As %String
{
	
	
	s ArcItm="",ret=""
	set ArcItm=$p($g(^OEORD(+OEORdItm,"I",$p(OEORdItm,"||",2),1)),"^",2) ;医嘱项id
	s StDate=""
	s Tarid=""
	f  s StDate=$O(^DHCOLT(0,"ARCIM",ArcItm,"Z",StDate))  q:StDate=""  d
	.f  s Tarid=$O(^DHCOLT(0,"ARCIM",ArcItm,"Z",StDate,Tarid))  q:Tarid=""  d
	..s EndDate=$p(^DHCOLT(0,"ARCIM",ArcItm,"Z",StDate,Tarid),"^",5)
	..q:EndDate'=""
	..s Taritem=$p( ^DHCOLT(Tarid),"^",2)
	..q:Taritem=""
	..s SubCate=$p(^DHCTARI(Taritem),"^",4)
	..q:(SubCate'="8")&(SubCate'="14")
	..s Code=..GetInsuTarCode(Taritem,"XZFYA")
	..q:Code["270800004"
	..q:Code["220800008"
	..if ret=""  d
	...s ret=$p(Code,"^",1)
	..else  d
	...if ret'[$p(Code,"^",1) d
	....s ret=ret_"^"_$p(Code,"^",1)
	
	q ret
}

// d ##class(web.RoutineworkC).APPOEReport("881473||39")

ClassMethod APPOEReport(OEORDID) As %String
{
	s appid="",ret=""
	
	f  s appid=$O(^DHCRBAppOrdi(0,OEORDID,appid)) q:appid=""  d
	.s ret=appid
	
	
	q ret
}

// w ##class(web.RoutineworkC).GetPatIcdDiag("")

ClassMethod GetPatIcdDiag(Adm) As %String
{
	s MRAdmRowid=$p($g(^PAADM(Adm)),"^",61)
 	s dia="",sub="",ICDCodeStr="",ICDCodeDR="",DiagnosiCode=""
	s MRDiagnoseDesc=""
	f  s sub=$O(^MR(MRAdmRowid,"DIA",sub))  q:sub=""   d
	.q:sub=0
	.s ICDCodeDR=$p(^MR(MRAdmRowid,"DIA",sub),"^",1)
	.q:ICDCodeDR=""
	.s ICDCodeStr=ICDCodeDR_"^"_ICDCodeStr
	
	s DiagnosiCode=$p(ICDCodeStr,"^",1)
	q:DiagnosiCode="" ""
	s dia=$p(^MRC("ID",DiagnosiCode),"^","4")_"^"_$p(^MRC("ID",DiagnosiCode),"^","2")
	q dia
}

/// w ##class(web.RoutineworkC).GetInsuItemByTarRowCode("4827","XZFYA")
ClassMethod GetInsuItemByTarRowCode(DHCTarid As %String, Type As %String)
{
	
	s:Type="2" Type="XZFYA" 
	s:Type="4" Type="XZFYA"
	s:Type="18" Type="XZFYA"
	s:Type="19" Type="XZFYA"
	s TarConid="0",ConStr=""
	s XMDJ="", XMLB=""
	f  s TarConid=$o(^DHCINTCT("0","DHCTID",DHCTarid,TarConid)) q:TarConid=""  d
	.s sCon=$g(^DHCINTCT(TarConid))

	.q:Type'=$p(sCon,"^",12)    ;非本目录类别

	.s InsuTarItemID=$p(sCon,"^",4)  
	.q:InsuTarItemID="" 

	.s XMBM=$p($g(^DHCINTIM(InsuTarItemID)),"^",3)   ;项目编码
	.s XMDJ=$p($g(^DHCINTIM(InsuTarItemID)),"^",23) 
	.s XMLB=$p($g(^DHCINTIM(InsuTarItemID)),"^",7)  ;项目类别  1 2 3
	.s:XMBM="9999" XMDJ="丙类" 
	.i XMDJ="" d 
	..s XMDJ=$p($g(^DHCINTIM(InsuTarItemID)),"^",24)
	..s:XMDJ'="" XMDJ=XMDJ_"类"
	..s:XMDJ="" XMDJ="乙类"
	s:XMDJ="自费" XMDJ="丙类"
	q XMDJ
}

// w ##class(web.RoutineworkC).YBFLbyDivideSub("2584078","降钙素原检测")

ClassMethod YBFLbyDivideSub(PB As %String, Itm As %String) As %String
{
	
	s DivSub=""
	s XMDJ=""
	s DHCItmid=""
	s DHCItmid=$O(^DHCTARI(0,"Desc",Itm,DHCItmid))
	f  s DivSub=$O(^DHCINDIS("0","PBDr",PB,DivSub))  q:DivSub=""  d
	.s ItmID=$p(^DHCINDIS(DivSub),"^",3)
	.;s ItmDesc=$p(^DHCTARI(ItmID),"^",2)
	.;b ;234
	.q:ItmID'=DHCItmid
	.s XMDJ=$p(^DHCINDIS(DivSub),"^",10)
	
	q XMDJ
}

// w ##class(web.RoutineworkC).YBFLbyINSUItms("2521437||247||2","XZFYA")

ClassMethod YBFLbyINSUItms(pbdRowid As %String, Type As %String) As %String
{
	
	
	S InsuDivSubID="",XMLB=""

	S InsuDivSubID=$O(^DHCINDIS("0","PBDDr",pbdRowid,InsuDivSubID),-1)  
	;q:InsuDivSubID=""


	if InsuDivSubID'="" {
	s XMLB=$p(^DHCINDIS(InsuDivSubID),"^",10)
	i XMLB="01" s XMLB="甲类"
	i XMLB="02" s XMLB="乙类"
	i XMLB="03" s XMLB="丙类"
	s ItmID=$p(^DHCINDIS(InsuDivSubID),"^",3)
	
	}
	else
	{
	s Fir=$p(pbdRowid,"||",1)  
	s Sec=$p(pbdRowid,"||",2)  
	s Thi=$p(pbdRowid,"||",3)
	s ItmID=$p(^DHCPB(Fir,"O",Sec,"D",Thi),"^",3)
		}
	if XMLB="" s XMLB=..GetInsuItemByTarRowCode(ItmID,"00A")
	q XMLB
}

/// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","DocMedCount","2016-12-01","2016-12-31","" )
/// 统计病区医生开药品详细信息
ClassMethod DocMedCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DocMedCountExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod DocMedCountExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s wordLoadID=""
	s admrowid=""
	s Amt=0
	s Sum=0
	k ^TMPDOCMED("DocMed")
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	F iDate=SDate:1:EDate D
	.f  s wordLoadID=$o(^DHCWorkLoad(0,"ORDDATE",iDate,wordLoadID))  q:wordLoadID=""   d
	..s PatType=$p(^DHCWorkLoad(wordLoadID),"^",4)
	..q:PatType'="I"
	..s ArcimDr=$p(^DHCWorkLoad(wordLoadID),"^",2)		;医嘱id
	..s ARCCATRowid=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)
	..s ArcName=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",2)
	..s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..q:ARCOrdType'="R"   //表示是药品
	..s WorkLoadResDepDR=$P(^DHCWorkLoad(wordLoadID),"^",3)	;病人科室
	..s ResDep=$p(^CTLOC(WorkLoadResDepDR),"^",1)
	..q:WorkLoadResDepDR'="89"
	
	..s WorkLoadResDocDR=$p(^DHCWorkLoad(wordLoadID),"^",19)	;下医嘱医生
	..s Price=$p(^DHCWorkLoad(wordLoadID),"^",14)	;价格
	..s Qty=$p(^DHCWorkLoad(wordLoadID),"^",15)	;医嘱数量
	..s Amt=Price*Qty
	..s DocName=$p(^CTPCP(WorkLoadResDocDR,1),"^",2)
	..s DocNameCode=DocName_"&"
	..q:"陈琳&^董兆鹏&^杜苏华&^韩飞鹏&^胡宇&^秦娅&^宋彦&^王明玉&^郑翠芳&^臧培培&^刘彦楠&^曹永军&^王志伟&^赵伟&^孙经侠&^刘旭&^李维维&^施蓉&^丁兆霞&"'[DocNameCode
	..s ^TMPDOCMED("DocMed",$j,ResDep)=$g(^TMPDOCMED("DocMed",$j,ResDep))+Amt
	
	s a="",b="",c="",d=""
	
	f  s a=$O(^TMPDOCMED("DocMed",$j,a))  q:a=""  d
	.s b=$g(^TMPDOCMED("DocMed",$j,a))
	.s c=0,d=0
	.d OutPutDocMed
	;.f  s b=$O(^TMPDOCMED("DocMed",$j,a,b))  q:b=""  d
	;..f  s c=$O(^TMPDOCMED("DocMed",$j,a,b,c))  q:c=""  d
	;...s d=$g(^TMPDOCMED("DocMed",$j,a,b,c))
	;...d OutPutDocMed
	
	;s a="",b="",c="",d=""
	;b ;4324
	;f  s a=$O(^TMPDOCMED("DocMed",$j,a))  q:a=""
	;.b	; !,a
	/*.f  s b=$O(^TMPDOCMED($j,a,b))  q:b=""
	..f  s c=$O(^TMPDOCMED($j,a,b,c))  q:c=""
	...s d=$g(^TMPDOCMED($j,a,b,c))
	...d OutPutDocMed */
	
	
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutDocMed    
	set Data=$lb(a,b,c,d)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DocMedCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DocMedCountExecute ]
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

Query DocMedCount(SDate, EDate) As %Query(ROWSPEC = "CTLoc,DocName,ArcName,Qty") [ SqlProc ]
{
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","IPZYYJJ","2016-09-01","2016-09-10","")

ClassMethod IPZYYJJClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPZYYJJExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod IPZYYJJExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1,Sum=0,myPreSum=0,myRefPreSum=0,Sub=0,myPayNum=0,wCharge=0,wResu=0,wFee=0
	s:EDate="" EDate="2015-05-10"
	s:SDate="" SDate="2015-05-10"
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	s DHCDCID="",Syjj=0,tyjj=0,SyjjSum=0,TyjjSum=0,Syestday=0,today=0,Stoday=0,SMargin=0
	f idate=SDate:1:EDate  d
	.s DHCDCID=$O(^DHCDCAMTTrade("Date",idate,DHCDCID))  q:DHCDCID=""  d
	.s Syjj=$j($p(^DHCDCAMT(DHCDCID),"^",1),3,2)
	.s tyjj=$j($p(^DHCDCAMT(DHCDCID),"^",2),3,2)
	.;s SyjjSum=SyjjSum+Syjj
	.;s TyjjSum=tyjj+tyjj
	.s Syestday=$j(..GetYestAmt(idate-1),3,2)
	.s today=$j($p(^DHCDCAMT(DHCDCID),"^",5),3,2)
	.s outDate=$zd(idate,3)
	.d BuildTarCatepatnum1
	/*.if idate=SDate d
	..;w !,SDate
	..s SMargin=$p(^DHCDCAMT(DHCDCID),"^",4) ;收退差额
	..s Stoday=$p(^DHCDCAMT(DHCDCID),"^",5) ;今日余额
	..;w !,Stoday
	..;w !,SMargin
	..s Syestday=Stoday-SMargin  ;昨日余额
	.if idate=EDate  d
	..s today=$p(^DHCDCAMT(DHCDCID),"^",5) ;今日余额
	.d BuildTarCatepatnum1*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCatepatnum1    
	set Data=$lb(Syjj,tyjj,Syestday,today,outDate)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod IPZYYJJFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPZYYJJExecute ]
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

Query IPZYYJJ(SDate, EDate, ctcareprov) As %Query(ROWSPEC = "SyjjSum,TyjjSum,Syestday,today,outDate") [ SqlProc ]
{
}

// w ##class(web.RoutineworkC).GetPatNameByID("320322199002283543")

ClassMethod GetPatNameByID(ID) As %String
{
	q:ID="" "^"
	s PatID=""
	&sql(select PAPMI_RowId1 into:PatID from pa_patmas where PAPMI_ID=:ID)
	q:PatID="" "^"
	set Name=""
	set Med=""
	set Name=$p(^PAPER(PatID,"ALL"),"^",1)  
	set Med=$p(^PAPER(PatID,"PAT",1),"^",22)
	q Name_"^"_Med
}

// d ##class(web.RoutineworkC).GetPatBornCount("914511")

ClassMethod GetPatBornCount(Input) As %String
{
  
  	s arr = ##class(%ArrayOfDataTypes).%New()
	s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(Input,"HDSD00.11")	
	set Doucoment=arr.GetAt("HDSD00.11.006") //产次
	w !,Doucoment
}

// w ##class(web.RoutineworkC).GetPatPBDet("2654305")

ClassMethod GetPatPBDet(PB) As %String
{
	s PBSub=0
	s sub=0
	s Sum=0
	k ^TMPPatPBDet
	f  s PBSub=$O(^DHCPB(PB,"O",PBSub))  q:PBSub=""  d
	.f  s sub=$O(^DHCPB(PB,"O", PBSub,"D",sub))  q:sub=""  d
	..s itmid=$p(^DHCPB(PB,"O", PBSub,"D",sub),"^",3)
	..q:itmid=""
	..s itmdesc=$p(^DHCTARI(itmid),"^",2)
	..s Price=$j($p(^DHCPB(PB,"O", PBSub,"D",sub),"^",4),3,2)
	..q:+Price=0
	..s Qty=$p(^DHCPB(PB,"O", PBSub,"D",sub),"^",5)
	..s Amt=$p(^DHCPB(PB,"O", PBSub,"D",sub),"^",7)
	..s Date=$zd($p(^DHCPB(PB,"O", PBSub,"D",sub),"^",11),3)
	..w !, Date_"^"_itmdesc_"^"_Price_"^"_Qty_"^"_Amt
	..s Sum=Sum+Amt
	w !,Sum
}

// w ##class(web.RoutineworkC).CSprintflag("US0038294")

ClassMethod CSprintflag(Study) As %String
{
	zn "PACS"
	s PrintFlag=""
	s PrintFlag=##Class(PACS.RISInterface).GetPrintFlag(Study)
	zn "dhc-app"
	q PrintFlag
}

ClassMethod GetPBfeeByAdm(Adm) As %String
{
	s PBid=""
	s Sum=0,Amt=0
	f  s PBid=$O(^DHCPB(0,"ADM",Adm,PBid))  q:PBid=""  d
	.s Amt=$P( ^DHCPB(PBid),"^",8)
	.s Sum=Amt+Sum	
	q Sum
}

// w ##class(web.RoutineworkC).GetInPatRecord("0000277531")

ClassMethod GetInPatRecord(RegNo) As %String
{
	s ^tmprec=RegNo
	s Adm="",Papmi="",rtn=""
	q:RegNo="" ""
	s:RegNo["^" RegNo=$p(RegNo,"^",1)
	s Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,Papmi)) 
	f  s Adm=$O(^PAPERdr(Papmi,"ADM","I",Adm))  q:Adm=""  d
	.s Statue=$p(^PAADM(Adm),"^",20)
	.q:Statue'="A"
	.s rtn=Adm
	q rtn
}

// w ##class(web.RoutineworkC).GetInpatLYSOrder("2460839","0")

// 没什么好说的 就是获取医嘱信息 

ClassMethod GetInpatLYSOrder(Adm, Type) As %String
{
	s ^xzfygetipordtmp=Adm_"&&&"_Type
	s rtn=""
	s OeOrdid="",Sub=0,ExecSub=0
	s:Type=0 Ordtype=1
	s:Type=1 Ordtype=6
	s rtn="",OEDateTimeExecuted="",CareProv="",ExecStaDesc="",XDate="",XTime=""
	s OeOrdid=$O(^OEORD(0,"Adm",Adm,OeOrdid))  
	q:OeOrdid="" ""
	f  s Sub=$O(^OEORD(OeOrdid,"I",Sub))  q:Sub=""  d
	.q:OeOrdid_"||"_Sub="4795757||91^4795757"
	.s RecLoc=$p(^OEORD(OeOrdid,"I",Sub,3),"^",6)
	.q:(RecLoc'="31")&&(RecLoc'="32")&&(RecLoc'="33")&&(RecLoc'="30")
	.s OrdSta=$p(^OEORD(OeOrdid,"I",Sub,1),"^",13)
	.q:OrdSta'=Ordtype 
	.s OrdSta=$p(^OEC("OSTAT",OrdSta),"^",2)
	.s ArcItm=$p(^OEORD(OeOrdid,"I",Sub,1),"^",2)
	.s ArcDesc=$p(^ARCIM(+ArcItm,$p(ArcItm,"||",2),1),"^",2)
	.s OrdTime=$zd($p(^OEORD(OeOrdid,"I",Sub,1),"^",9),3)_" "_$zt($p(^OEORD(OeOrdid,"I",Sub,1),"^",10),1)
	.s InsertTime=OrdTime
	.s Doc=$p(^CTPCP($p(^OEORD(OeOrdid,"I",Sub,1),"^",11),1),"^",2)   
	.s CTloc=$p(^CTLOC(RecLoc),"^",1)
	.s ArcCatDr=$p(^ARC("IC",$p(^ARCIM(+ArcItm,$p(ArcItm,"||",2),1),"^",10)),"^",8)
	.s OECate=$P(^OEC("ORCAT",ArcCatDr),"^",2)
	.s Price=$p(^OEORD(OeOrdid,"I",Sub,2),"^",13)
	.s Qty=$p(^OEORD(OeOrdid,"I",Sub,1),"^",12)
	.s Amt=Price*Qty
	.s OEORDID=OeOrdid_"||"_Sub
	.s ID=OEORDID
	.s XDate=$P($g(^OEORD(OeOrdid,"I",Sub,6)),"^",2)
	.s XTime=$P($g(^OEORD(OeOrdid,"I",Sub,6)),"^",3)
	.s CareProvid=$P($g(^OEORD(OeOrdid,"I",Sub,6)),"^",4)
	.if (XDate'="")&&(XTime'="") d
	..s OEDateTimeExecuted=$zd(XDate,3)_" "_$zt(XTime,1)
	.s:CareProvid'="" CareProv=$p(^SSU("SSUSR",CareProvid),"^",2)

	.if rtn="" d
	..s rtn=ArcDesc_"^"_OrdTime_"^"_OEDateTimeExecuted_"^"_CareProv_"^"_OrdTime_"^"_Doc_"^"_CTloc_"^"_OrdSta_"^"_OECate_"^"_ExecStaDesc_"^"_Price_"^"_Amt_"^"_ID_"^"_OEORDID
	.else  d
	..s rtn=rtn_"!"_ArcDesc_"^"_OrdTime_"^"_OEDateTimeExecuted_"^"_CareProv_"^"_OrdTime_"^"_Doc_"^"_CTloc_"^"_OrdSta_"^"_OECate_"^"_ExecStaDesc_"^"_Price_"^"_Amt_"^"_ID_"^"_OEORDID
	
	q rtn
	;q OECate
		/*.f  s ExecSub=$O(^OEORD(OeOrdid,"I",Sub,"X",ExecSub))  q:ExecSub=""  d
	..q:ExecSub=0
	..s ID=OeOrdid_"||"_Sub_"||"_ExecSub
	..;w !,Sub_"||"_ExecSub
	..s ExecSta=$p(^OEORD(OeOrdid,"I",Sub,"X",ExecSub),"^",16)
	..s:ExecSta'="" ExecStaDesc=$p($g(^OEC("STAT",ExecSta)),"^",2)
	..s:ExecSta="" ExecStaDesc="未执行"
	..s Xdate=$p($g(^OEORD(OeOrdid,"I",Sub,"X",ExecSub)),"^",19)
	..s Xtime=$p($g(^OEORD(OeOrdid,"I",Sub,"X",ExecSub)),"^",20)
	..s OEDateTimeExecuted=""
	..if (Xdate'="")&&(Xtime'="") d
	...s OEDateTimeExecuted=$zd(Xdate,3)_" "_$zt(Xtime,1)
	..s CareID=$p(^OEORD(OeOrdid,"I",Sub,"X",ExecSub),"^",15)
	..s:CareID'="" CareProv=$p(^CTPCP(CareID,1),"^",2) */
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","InAutoDespoit","2018-07-01","2018-07-01")

/// /自助机住院预交金报表
ClassMethod InAutoDespoitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InAutoDespoitExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod InAutoDespoitExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	k ^TMPwcwcAutoPayamt
	;Set repid=$I(^CacheTemp)
	set prtid="",MecCashAmt=0,MecYJKAmt=0,MecCashNum=0,MecYJKNum=0
	set tmpcashsum=0,RMB="",PrtStr=""
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	set (MNCash,MNYHK,MNALI,MNWEI,AutoCash,AutoYHK,AutoALI,AutoWEI)=0
	F iDate=SDate:1:EDate D
	.f  s prtid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",iDate,prtid)) q:prtid=""  d
	..s statue=$p(^DHCSFPRINTDETAIL(prtid),"^",8)
	..q:statue="2"
	..s User=$p(^DHCSFPRINTDETAIL(prtid),"^",20)
	..s UserGroup=$p(^SSU("SSUSR",User),"^",5)
	..q:UserGroup'="10"
	..q:User="2499"
	..q:User="2612"
	..q:User="2611"
	..;q:User=""
	..s username=$p(^SSU("SSUSR",User),"^",2)
	..s payamount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
	..s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
	..s PrtNo=$p(^DHCSFPRINTDETAIL(prtid),"^",1)
	..if $g(^TMPwcwcAutoPayamt($j,username,"PrtNo"))="" d
	...s ^TMPwcwcAutoPayamt($j,username,"PrtNo")=PrtNo
	..else  d
	...s ^TMPwcwcAutoPayamt($j,username,"PrtNo")=$g(^TMPwcwcAutoPayamt($j,username,"PrtNo"))_"^"_PrtNo
	..if paymode="1" d
	...s tmpcashsum=tmpcashsum+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"Cash")=$g(^TMPwcwcAutoPayamt($j,username,"Cash"))+ payamount
	...s:username["迷你" MNCash=MNCash+payamount
	...s:username'["迷你" AutoCash=AutoCash+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"Cash","count")=$g(^TMPwcwcAutoPayamt($j,username,"Cash","count"))+1
	
	
	..if paymode="4" d
	...s tmpcashsum=tmpcashsum+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"YHK")=$g(^TMPwcwcAutoPayamt($j,username,"YHK"))+ payamount
	...s:username["迷你" MNYHK=MNYHK+payamount
	...s:username'["迷你" AutoYHK=AutoYHK+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"YHK","count")=$g(^TMPwcwcAutoPayamt($j,username,"YHK","count"))+1
	
	..if paymode="36" d
	...s tmpcashsum=tmpcashsum+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"ALI")=$g(^TMPwcwcAutoPayamt($j,username,"ALI"))+ payamount
	...s:username["迷你" MNALI=MNALI+payamount
	...s:username'["迷你" AutoALI=AutoALI+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"ALI","count")=$g(^TMPwcwcAutoPayamt($j,username,"ALI","count"))+1
	
	..if paymode="37" d
	...s tmpcashsum=tmpcashsum+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"WEI")=$g(^TMPwcwcAutoPayamt($j,username,"WEI"))+ payamount
	...s:username["迷你" MNWEI=MNWEI+payamount
	...s:username'["迷你" AutoWEI=AutoWEI+payamount
	...s ^TMPwcwcAutoPayamt($j,username,"WEI","count")=$g(^TMPwcwcAutoPayamt($j,username,"WEI","count"))+1
	
	
	if tmpcashsum'=0 s RMB=##class(web.DHCINSUPort).RMBConvert(tmpcashsum)
	s MecName=""
	f  s MecName=$O(^TMPwcwcAutoPayamt($j,MecName)) q:MecName=""  d
	.s MecCashAmt=$g(^TMPwcwcAutoPayamt($j,MecName,"Cash"))
	.s MecCashNum=$g(^TMPwcwcAutoPayamt($j,MecName,"Cash","count"))
	.s MecYJKAmt=$g(^TMPwcwcAutoPayamt($j,MecName,"YHK"))
	.s MecYJKNum=$g(^TMPwcwcAutoPayamt($j,MecName,"YHK","count"))
	.s MecALIAmt=$g(^TMPwcwcAutoPayamt($j,MecName,"ALI"))
	.s MecALINum=$g(^TMPwcwcAutoPayamt($j,MecName,"ALI","count"))
	.s MecWEIAmt=$g(^TMPwcwcAutoPayamt($j,MecName,"WEI"))
	.s MecWEINum=$g(^TMPwcwcAutoPayamt($j,MecName,"WEI","count"))
	.s rcptno=..GetStarEnd($g(^TMPwcwcAutoPayamt($j,MecName,"PrtNo")))
	.s:MecCashAmt="" MecCashAmt=0
	.s:MecCashNum="" MecCashNum=0
	.s:MecYJKAmt="" MecYJKAmt=0
	.s:MecYJKNum="" MecYJKNum=0
	.s:MecALIAmt="" MecALIAmt=0
	.s:MecALINum="" MecALINum=0
	.s:MecWEIAmt="" MecWEIAmt=0
	.s:MecWEINum="" MecWEINum=0
	.d BuildTarCatepatnum
    k ^TMPwcwcAutoPayamt
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCatepatnum    
	set Data=$lb(ind,MecName,MecCashAmt,MecCashNum,MecYJKAmt,MecYJKNum,RMB,rcptno,MecALIAmt,MecALINum,MecWEIAmt,MecWEINum,MNCash,MNYHK,MNALI,MNWEI,AutoCash,AutoYHK,AutoALI,AutoWEI)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InAutoDespoitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InAutoDespoitExecute ]
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

Query InAutoDespoit(SDate, EDate) As %Query(ROWSPEC = "ind,MecName,MecCashAmt,MecCashNum,MecYJKAmt,MecYJKNum,RMB,rcptno,MecALIAmt,MecALINum,MecWEIAmt,MecWEINum,MNCash,MNYHK,MNALI,MNWEI,AutoCash,AutoYHK,AutoALI,AutoWEI") [ SqlProc ]
{
}

ClassMethod GetStarEnd(s) As %String
{
	k ^TMPLenstr
	s len=$L(s,"^")
	f i=1:1:len d
	.s start=$p(s,"^",i)
	.;w !,start
	.q:start=""
	.s cur=$p(s,"^",i+1)
	.i +start+1=+cur d
	..
	.e  d
	..s:i'=len ^TMPLenstr($j)=$g(^TMPLenstr($j))_"^"_i
	s retstring=""

	i $d(^TMPLenstr($j)) d
	.s Len=$L(^TMPLenstr($j),"^")
	.f i=1:1:Len  d
	..q:$p(^TMPLenstr($j),"^",i)=""
	..s zdz=$p(^TMPLenstr($j),"^",i)
	..s retstring=retstring_"--"_$p(s,"^",zdz)_","_$p(s,"^",zdz+1)
	.s retstring=$p(s,"^",2)_retstring_"--"_$p(s,"^",len)
	e  d
	.s:$p(s,"^",1)="" YjjNumS=$p(s,"^",2)
	.s:$p(s,"^",1)'="" YjjNumS=$p(s,"^",1)
	.s:$p(s,"^",len)="" YjjNumE=$p(s,"^",len-1)
	.s:$p(s,"^",len)'="" YjjNumE=$p(s,"^",len)
	.s retstring=YjjNumS_"--"_YjjNumE
	
	q retstring
}

// w ##class(web.RoutineworkC).JCDepartments()

ClassMethod JCDepartments() As %GlobalCharacterStream
{
	s Departmentid=""
	s Obj=##class(web.DHCQY.Model.JCDepartReturn).%New()
	s ObjInsert=##class(web.DHCQY.Model.JCDepartMents).%New()
	f  s Departmentid=$O(^CTLOC(Departmentid))  q:Departmentid=""  d
	.s DepartDesc=$p(^CTLOC(Departmentid),"^",1)
	.s ObjInsert=##class(web.DHCQY.Model.JCDepartMents).%New()
	.s ObjInsert.FOFFN=Departmentid
	.s ObjInsert.FDESC=DepartDesc
	.Do Obj.DepartMentList.Insert(ObjInsert)
	.Do Obj.%Close()
	
	
	
	set RtStream=##class(%GlobalCharacterStream).%New()
	do Obj.XMLExportToStream(.RpStream,"Response")
 	q RpStream
}

ClassMethod JCWard() As %GlobalCharacterStream
{
	s Departmentid=""
	s Obj=##class(web.DHCQY.Model.JCDepartReturn).%New()
	s ObjInsert=##class(web.DHCQY.Model.JCDepartMents).%New()
	f  s Departmentid=$O(^PAWARD(Departmentid))  q:Departmentid=""  d
	
	.q:+Departmentid=0
	.s DepartDesc=$p(^PAWARD(Departmentid),"^",1)
	.s ObjInsert=##class(web.DHCQY.Model.JCDepartMents).%New()
	.s ObjInsert.FOFFN=Departmentid
	.s ObjInsert.FDESC=DepartDesc
	.Do Obj.DepartMentList.Insert(ObjInsert)
	.Do Obj.%Close()
	
	
	
	set RtStream=##class(%GlobalCharacterStream).%New()
	do Obj.XMLExportToStream(.RpStream,"Response")
 	q RpStream
}

// w ##class(web.RoutineworkC).JCCareProv()

ClassMethod JCCareProv() As %GlobalCharacterStream
{
	
	s CareID=""
	s careLoc="",RBResID="",TpdrDesc=""
	
	s ObjResp=##class(web.DHCQY.Model.JCCareProvResponse).%New()
	f  s CareID=$O(^CTPCP(CareID))  q:CareID=""  d
	.q:CareID=0
	.s Caredesc=$p($g(^CTPCP(CareID,1)),"^",2) //姓名
	.s Carecode=$p($g(^CTPCP(CareID,1)),"^",1) //工号
	.s Tpdr=$p($g(^CTPCP(CareID,1)),"^",4) //职称
	.s:Tpdr'="" TpdrDesc=$p($g(^CT("CPT",Tpdr)),"^",1)
	.s ObjCare=##class(web.DHCQY.Model.JCCareProv).%New()
	.s ObjCare.FEMPN=Carecode
	.s ObjCare.FNAME=Caredesc
	.s ObjCare.FTYPE=TpdrDesc
	.DO ObjResp.CareProvList.Insert(ObjCare)
	.s CareLoc=""
	.f  s CareLoc=$o(^RB("RES",0,"CTPCP",CareID,CareLoc))  q:CareLoc=""  d
	..s ObjLoc=##class(web.DHCQY.Model.JCCareProvLoc).%New()
	..s CTLoc=$p(^CTLOC(CareLoc),"^",1)
	..s ObjLoc.FDEPTN=CTLoc
	..Do ObjCare.DepartList.Insert(ObjLoc)
	..Do ObjCare.%Close()
	set RtStream=##class(%GlobalCharacterStream).%New()
	do ObjResp.XMLExportToStream(.RpStream,"Response")
 	q RpStream
}

// w ##class(web.RoutineworkC).DischargeRecord("949417")

// w ##class(web.RoutineworkC).DischargeRecord("<Request><MedicalNo>276632</MedicalNo><InPatNum>1</InPatNum></Request>")

ClassMethod DischargeRecord(Input) As %GlobalCharacterStream
{
	Set reader=##class(%XML.Reader).%New()
	
	Set sc=reader.OpenString(Input)
	Do reader.Correlate("Request","web.DHCQY.Model.JCDisRecInput")
    set objInputRt=##class(web.DHCQY.Model.JCDisRecInput).%New()
	While reader.Next(.Obj,.sc) {
		 set objInputRt=Obj
	}
	if (objInputRt.MedicalNo="")||(objInputRt.InPatNum="")
	{
		q "<ResultCode>-1</ResultCode><ResultContent>必要参数为空</ResultContent>"
		
		}
	S Papmi=##Class(web.DHCWMRService).IGetPatientIDByMrNo(objInputRt.MedicalNo)
	if Papmi="" {
		
		
		q "<ResultCode>-2</ResultCode><ResultContent>未查到此病人住院信息</ResultContent>"
		
		}
	
	s Paadmid=""
	s ReqObj=##class(web.DHCQY.Model.JCDisRecordRet).%New()
	f  s Paadmid=$o(^PAPERdr(Papmi,"ADM","I",Paadmid))  q:Paadmid=""  d
	.s InpatNo=$p(^PAADM(Paadmid),"^",29)
	.q:InpatNo'=objInputRt.InPatNum
	.s arr = ##class(%ArrayOfDataTypes).%New()
	.s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(Paadmid,"HDSD00.11")
	.set s1=arr.GetAt("HDSD00.11.1232")
	.set s2=arr.GetAt("HDSD00.11.1233")
	.set s3=arr.GetAt("HDSD00.11.1234")
	.set s4=arr.GetAt("HDSD00.11.1235")
	.s ReqObj.ryqk=s1
	.s ReqObj.zyjg=s2
	.s ReqObj.cyqk=s3
	.s ReqObj.cyyz=s4
	set RtStream=##class(%GlobalCharacterStream).%New()
	do ReqObj.XMLExportToStream(.RpStream,"Response")
 	q RpStream
}

// w ##class(web.RoutineworkC).GetDischarRecord("949417")

ClassMethod GetDischarRecord(Input) As %String
{
	
	s arr = ##class(%ArrayOfDataTypes).%New()
	s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(Input,"HDSD00.11")
	;s arr=##Class(DHC.EPR.FPInterface.ExportTable).GetDataByGlossaryCategory(Input,"HDSD00.11")
	// 取病案首页病人基本信息
	s rtn=""
	
	set s1=arr.GetAt("HDSD00.11.1232")
	set s2=arr.GetAt("HDSD00.11.1233")
	set s3=arr.GetAt("HDSD00.11.1234")
	set s4=arr.GetAt("HDSD00.11.1235")
	
	q s1_"^"_s2_"^"_s3_"^"_s4
}

ClassMethod CheckOrdType(parref) As %String
{
	
	s ordid="",sub1="",sub2="",rtn=""
	s ordid=$p(parref,"||",1)
	s sub1=$p(parref,"||",2)
	f  s sub2=$o(^OEORD(ordid,"I",sub1,"X",sub2))  q:sub2=""  d
	.q:sub2=0
	.s Date=$p(^OEORD(ordid,"I",sub1,"X",sub2),"^",1)
	.q:Date'=+$h
	.s rtn=sub2
	if rtn=""{
	q rtn
	}
	else
	{
		q parref_"||"_rtn
		
		}
}

// w ##class(web.RoutineworkC).WMPayNew("1144202||11^1144202||12^1144202||13^1144202||14^1144202||15^1144202||16^1144202||17^1144202||18^1144202||19","2846953","2847962","")

// 微脉补退费

ClassMethod WMPayNew(StopOrderStr, OldInvPrtID, NewInvPrtID, MyPRTRowID) As %String
{
	
	//"web.Wm.Method.GetRefundFeeStr","GetStopOrderstr",StopOrdStr,ReceipRowid,returnvalue,myPRTRowID)  //取串
	
	s string="",rtn="",string2=""
	
	s string=##class(web.Wm.Method.GetRefundFeeStr).GetStopOrderstr(StopOrderStr, OldInvPrtID, NewInvPrtID, MyPRTRowID)
	b ;2017 string
	s string2="71^5^1^^^2125^退费^"_string  //收费员需要取一下
	s rtn=##class(DHCWMAIPay.ChargeInterface.WMAIPayLogic).WMAIPay("OP",MyPRTRowID,StopOrderStr,NewInvPrtID, OldInvPrtID, "", "D", string2)
	q rtn
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","SendItemPrice","" )

/// 发送收费项目和药品价格至自助机表
ClassMethod SendItemPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SendItemPriceExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// call web.RoutineworkC_SendItemPrice("","")
ClassMethod SendItemPriceExecute(ByRef qHandle As %Binary, MedAlias) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    &sql( declare Aliascur1 cursor for  
          select inca_inci_dr,inca_text from inc_Alias
      where %ALPHAUP(inca_Text) %STARTSWITH %ALPHAUP(:MedAlias))
    &sql(open Aliascur1)
    f  &sql(fetch Aliascur1 into :incidr,:AliasName) q:SQLCODE  d
    .w !,incidr_"^"_AliasName
    .s arcim=$p($g(^INCI(incidr,1)),"^",3)
    .q:arcim=""
    .s subcatid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
    .q:subcatid=""
    .s subdesc=$p($g(^ARC("IC",subcatid)),"^",2)
    .s subdesc=$$ALPHAUP^SSUTIL4(subdesc)
    .q:subdesc="HIDE"
    .s subcattype=$p($g(^ARC("IC",subcatid)),"^",7)
    .q:(subcattype'="R")
    .s arcto=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),7)),"^",1)
    .q:(arcto'="")&(arcto<+$h)
    .s ^TMPtext($j,incidr)=""
    .s ret=..GetNameInfo(incidr)
    .q:ret=""
    .s price=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,"","","","","","2","")
    .s price=$p(price,"^",1)
    .q:$j(price,3,4)="0.0000"
    .s phcid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",12)
    .s tarid=$o(^DHCOLT(0,"ARTTA",arcim,""),-1)
    .s:tarid'="" ExternalCode=$p($g(^DHCTARI(tarid)),"^",13)  ;外部编码 ;TARI_ExternalCode
    .s ExtendCode=$p($g(^DHCTARI(tarid)),"^",22)	;物价编码 TARI_ExtendCode
    .s:tarid'="" ExtendCode=##class(web.Routinework).GetTaritmtur(tarid)
    .s:tarid'="" YBCode=##class(web.Routinework).GetInsuItemByTarRowID(tarid,"2")
    .s:tarid'="" spec=##class(web.DHCSTCOMMONSRV).getBarcode(incidr) //规格incidr
    .s tarcode=""
    .s:(tarid'="")&&($d(^DHCTARI(tarid))) tarcode=$p($g(^DHCTARI(tarid)),"^",1),chargebasis=$p($g(^DHCTARI(tarid)),"^",20) //等级
    .s:(phcid'="")&&($d(^PHCD(+phcid,"DF",$p(phcid,"||",2)))) dfid=$p($g(^PHCD(+phcid,"DF",$p(phcid,"||",2),1)),"^",1)
    .s:(dfid'="")&&($d(^PHCF(dfid))) dfdes=$p($g(^PHCF(dfid)),"^",2)
    .s arcimdesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
    .s medname=arcimdesc
    .s comname=##class(web.DHCIPBillTouchFee).GetDrugCommonNameByArcimId(arcim)
    .i $g(comname)'="" s medname=comname
    .s ExtendCode=""
    .s:ExtendCode'="" ExtendCode1=$p(ExtendCode,",",1)
    .s XMLB="1"
    .Do OutputRow3
    &sql(close Aliascur1)
   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb($g(tarcode),XMLB,medname,spec,ExtendCode1,$j(price*convqty,3,4),$g(puom),ARCDESC,$g(dfdes),$g(manf),YBCode,$g(bmname),$G(chargebasis))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SendItemPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SendItemPriceExecute ]
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

Query SendItemPrice(MedAlias) As %Query(ROWSPEC = "code,xmlb,xmmc,spec,szm,price,uom,yongfa,jixing,chandi,yibao") [ SqlProc ]
{
}

ClassMethod GetNameInfo(initmdr)
{
    s P1=""
    q:initmdr="" ""_"^"_""_"^"_""_"^"_""
    ;^INASP(0,"INCI",{INASP_INCI_DR},{INASP_ExecuteDate},{INASP_Rowid})
    s maxdate=0
    s exdate="" f  s exdate=$O(^INASP(0,"INCI",initmdr,exdate)) q:exdate=""  d
    .i exdate>maxdate s maxdate=exdate
    i maxdate'=0  d
    .s adjrow=$O(^INASP(0,"INCI",initmdr,maxdate,"")) ;IN_AdjSalePrice
    .s price=$p(^INASP(adjrow),"^",7)
    .s medname=$P(^INCI(initmdr,1),"^",2) ;INC_Itm
    .s itmcode=$P(^INCI(initmdr,1),"^",1)
    .;s aliasrowid=..GEtalia(initmdr)
    .;s bmname=$p(^INCALIAS(+aliasrowid),"^",4)
    .s manf1=..GetManfName1(itmcode)
    .s manf=manf1 
    .s:$l(manf1,"-")>1 manf=$p(manf1,"-",2) 
    .s uomdr=$P(^INCI(initmdr,1),"^",10)
    .s puomdr=$P(^INCI(initmdr,3),"^",6)
    .s MedUom=$P(^CT("UOM",uomdr),"^",2)
    .s puom=$P(^CT("UOM",puomdr),"^",2)
    .s convqty=+$$ConvFac^ST02(puomdr,uomdr)
    .i convqty=0 s convqty=1
    .s incrowid=$p(^INASP(adjrow),"^",4)        
    .S ARCrowid=$P(^INCI(incrowid,1),"^",3)      
    .S ARCrowid1=$P(^ARCIM($p(ARCrowid,"||",1),1,1),"^",10)
    .s ARCDESC=$P(^ARC("IC",ARCrowid1),"^",2)
    .s P1=medname_"^"_MedUom_"^"_ARCDESC_"^"_manf  ;_"^"_bmname
    e  s P1=""
    q P1
}

ClassMethod GetManfName1(itmcode)
{
    n manf
    &sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phmnf_dr->phmnf_name
         into :manf from inc_itm where inci_code = :itmcode)
    q $g(manf)
}

/// 通过收费项id获取物资厂商  
/// by sh 2022-01-14
/// w ##class(web.RoutineworkC).Getincdrbytar(3873)  //3873、6139
ClassMethod Getincdrbytar(tar)
{
	q:tar="" ""
	//^DHCOLT(0,"TAR",{OLT_Tariff_DR},{OLT_StartDate},{OLT_RowId})
	s startdate="" ,pbmanfdesc=""
	f  s startdate=$o(^DHCOLT(0,"TAR",tar,startdate))  q:startdate=""  d
	.s oltid=""
	.f  s oltid=$o(^DHCOLT(0,"TAR",tar,startdate,oltid))  q:oltid=""  d
	..s enddate=$p(^DHCOLT(oltid),"^",5)
	..q:enddate'=""
	..s arcim=$p(^DHCOLT(oltid),"^",1)  //针对物资都是1对1  不走循环
	..b ;01
	..s inc=""
	..s inc=$o(^INCI(0,"Code",arcim,inc))
	..b ;02
	..q:inc=""
	..s info=""
	..s info=$o(^DHCITMINFO(0,"INCI",inc,info))
    ..s pbmanf=$p(^DHCITMINFO(info),"^",25)
    ..i pbmanf'="" s pbmanfdesc=$p(^PHMNF(pbmanf),"^",2)
	q pbmanfdesc
}

ClassMethod SendTaritemPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SendTaritemPriceExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","SendTaritemPrice","" )
/// call web.RoutineworkC_SendTaritemPrice("")
ClassMethod SendTaritemPriceExecute(ByRef qHandle As %Binary, ctcareprov) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s Tarid=""
	f  s Tarid=$O(^DHCTARI(Tarid))  q:Tarid=""  d
	.q:Tarid=0
	.s TarCate=$p($g(^DHCTARI(Tarid)),"^",5)
	.q:(TarCate=11)||(TarCate=12)||(TarCate=13)||(TarCate=14)
	.s XMLB="0"
	.;q:TarCate=9
	.s:TarCate="9" XMLB="3"
	.s TARICode=$p($g(^DHCTARI(Tarid)),"^",1)
	.s TARIDesc=$p($g(^DHCTARI(Tarid)),"^",2)
	.s Flag=$p($g(^DHCTARI(Tarid)),"^",7)
	.q:Flag'="Y"
	.s UomID=$p($g(^DHCTARI(Tarid)),"^",3)
	.&sql(SELECT TOP 1 TP_Price into:price FROM DHC_TarItemPrice WHERE TP_TARI_ParRef=:Tarid ORDER BY TP_ChildSub desc)
	.;s price=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim,+$h,"","","","")
	.q:UomID=""
	.s Uomdesc=$p($g(^CT("UOM",UomID)),"^",2)
	.s YBBM=##class(web.Routinework).GetInsuItemByTarRowID(Tarid,"2")
	.;I TarCate="9" 
	.s SZM=##class(web.Routinework).GetTaritmtur(Tarid)
	.s shuoming=""
	.s TARICode1=$tr(TARICode,"-","")
	.s:(TARICode1="120631")||(TARICode1="120632")||(TARICode1="120635")||(TARICode1="120636")||(TARICode1="120637")||(TARICode1="1500000051")||(TARICode1="15000000513")||(TARICode1="1500000052")||(TARICode1="1500000053")||(TARICode1="1500000055") shuoming="病人自主选择"
	.s:(TARICode1="1500000056")||(TARICode1="150000012")||(TARICode1="1500000121")||(TARICode1="3310")||(TARICode1="33101")||(TARICode1="3314")||(TARICode1="339") shuoming="病人自主选择"
	.s:(TARICode1="33p1") shuoming="由病人自愿选择"
    .d BuildTarCatepatnum2
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCatepatnum2   
	set Data=$lb(TARICode,XMLB,TARIDesc,SZM,price,Uomdesc,cs,PBFee,cs,YBBM,shuoming)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SendTaritemPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SendTaritemPriceExecute ]
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

Query SendTaritemPrice(ctcareprov) As %Query(ROWSPEC = "code,xmlb,xmmc,szm,price,uom,yongfa,jixing,chandi,yibao,shuoming") [ SqlProc ]
{
}

// w ##class(web.Routinework).GetAdmType("318794")

ClassMethod GetAdmType(Adm) As %String
{
	
	s Adminfoid=""
	s AdmType="",AdmFlag=""
	f  s Adminfoid=$O(^DHCINADM("0","ADM",Adm,Adminfoid))  q:Adminfoid=""  d
	.s AdmFlag=$p(^DHCINADM(Adminfoid),"^",11)
	.q:AdmFlag'="A"
	.s AdmType=$p(^DHCINADM(Adminfoid),"^",14)
	q AdmType
}

/// 2017徐州单病种病人结算信息d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","DBZDivInfo","2022-02-01","2022-02-05","职工","徐州市")
ClassMethod DBZDivInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DBZDivInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod DBZDivInfoExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov As %String = "", patCenter) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	Set ind=1
 	Quit:(EDate="") $$$OK
	s DivID="",PB=""
	s:EDate="" EDate=$h
	s:SDate="" SDate=$h
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	;b ;02
	k ^tmpdbzcount
	s count=0
	f idate=SDate:1:EDate  d
	.f  s DivID=$O(^DHCINDIV("0","IDate",idate,DivID))   q:DivID=""   d
	..;q:DivID'="2261887"
	..s PB=$p(^DHCINDIV(DivID),"^",3)
	..q:PB=""
	..s Flag=$p(^DHCINDIV(DivID),"^",5)
	..q:Flag'="I"
	..s Adminfoid=$P(^DHCINDIV(DivID),"^",2)
	..s Insuno=$p(^DHCINADM(Adminfoid),"^",2)
	..s Admreason=$p(^DHCINADM(Adminfoid),"^",18)
	..q:(Admreason'="XZFYA")&&(Admreason'="00A")
	..s Admtype=$p(^DHCINADM(Adminfoid),"^",14)
	..;i Admtype=26 b ;01
	..q:(Admtype'="35")&&(Admtype'="26")&&(Admtype'="28")
	..s Center=""
	..i Admreason="XZFYA" s Center=$p(^DHCINADM(Adminfoid),"^",8)
	..i Admreason="00A" s Center=$p(^DHCINADM(Adminfoid),"^",7)
	..s Center=$p($$QueryByCode^DHCINSUDicData("XZFYAAddress",Center),"^",4) 
	..q:(Center'=patCenter)&(patCenter'="NULL")
	..;b ;04
	..s Diagid=$p(^DHCINADM(Adminfoid),"^",26)
	
	..s Diagdesc=$p(^DHCINADM(Adminfoid),"^",27)
	..S PATType=""
	..I Admreason="00A" d
	...s PATType=$p(^DHCINADM(Adminfoid),"^",4)
	...s PATType=##class(web.RoutineworkD).getlx(PATType)
	...;q:(ctcareprov'="")&&(PATType'=ctcareprov)
	...;s PATType=##class(web.DHCINSUPort).mwthfmnew(PATType)
	..I Admreason="XZFYA"  d
	...s PATType=$p(^DHCINADM(Adminfoid),"^",29)
	...i PATType="ZG"  S PATType="职工"
	...i PATType="JM"  S PATType="居民"
	..q:(ctcareprov'="")&&(PATType'=ctcareprov)
	..s Adm=$p(^DHCINADM(Adminfoid),"^",1)
	..;q:Adm'="3897757"
	..s IDNO=$p(^DHCINADM(Adminfoid),"^",34)
	..s Patname=$p(^DHCINADM(Adminfoid),"^",35)
	..i Patname["|" s Patname=$p(Patname,"|",1)
	..s Admdate=$p(^PAADM(Adm),"^",6)
	..s Disdate=$p(^PAADM(Adm),"^",17)
	..s ZYDay=Disdate-Admdate
	..s Admdate=$zd(Admdate,3)
	..s Disdate=$zd(Disdate,3)
	..s BedNo=""
	..s zyno=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Adm)
	..s Bed=$p($g(^PAADM(Adm)),"^",73)
	..s BedSub=$p(Bed,"||",2)
	..s BedNo=""
	..s:BedSub'="" BedNo=$p($g(^PAWARD(+Bed,"BED",BedSub)),"^",1)
	..s ZFY=$p( ^DHCINDIV(DivID),"^",7)
	..s TCJZ=$p( ^DHCINDIV(DivID),"^",31)
	..s DBJZ=$p( ^DHCINDIV(DivID),"^",32)  ;大病
	..s GWY=$p( ^DHCINDIV(DivID),"^",33)  ;公务员
	..s GRZH=$p( ^DHCINDIV(DivID),"^",28)  ;账户
	..s XJ=$p( ^DHCINDIV(DivID),"^",15)  ;现金
	..s yljz=""
	..i Admreason="00A" s yljz=$p( ^DHCINDIV(DivID),"^",34)  ;医疗救助
	..;s YYDF=$p( ^DHCINDIV(DivID),"^",67) ;医院垫付
	..i Admreason="00A" s YYDF=$p( ^DHCINDIV(DivID),"^",49)
	..i Admreason="XZFYA" s YYDF=$p( ^DHCINDIV(DivID),"^",67)
	..s ZDFY="" ;$p(^DHCINDID(DIcid),"^",5)
	..s:PATType="ZG" PATType="职工"
	..s:PATType="JM" PATType="居民"
	..s LCLJinfo=##class(DHCCPW.IO.ForIInfoSrv).GetCPWInfoByAdm(Adm)
	..s LCLJ=$p(LCLJinfo,"^",3)
	..if '$d(^tmpdbzcount(Insuno))  d
	...s ^tmpdbzcount(Insuno)=""
	...s count=count+1
	..;s:LCLJ="" LCLJ="未入"
    ..d BuildDBZ
    
	
	Quit $$$OK
BuildDBZ    
	set Data=$lb(ind,Patname,IDNO,Admdate,Disdate,ZYDay,Diagid,Diagdesc,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,PATType,ZDFY,zyno,BedNo,LCLJ,count,PATType,Center,yljz)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DBZDivInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DBZDivInfoExecute ]
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

Query DBZDivInfo(SDate, EDate, ctcareprov As %String = "", patCenter) As %Query(ROWSPEC = "ind,Patname,IDNO,Admdate,Disdate,ZYDay,Diagid,Diagdesc,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,PATType,ZDFY,zyno,BedNo,LCLJ,count,PATType,Center,yljz") [ SqlProc ]
{
}

// 2017徐州单病种病人结算信息d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","DBZDivInfoTWO","2021-11-01","2021-11-01","" )

ClassMethod DBZDivInfoTWOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DBZDivInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod DBZDivInfoTWOExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov As %String, patCenter) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	Set ind=1
	s DivID="",PB=""
	s:EDate="" EDate=$h
	s:SDate="" SDate=$h
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	;q:ctcareprov="" $$$OK
	k ^TMPDBZ
	s i=0
	f idate=SDate:1:EDate  d
	.f  s DivID=$O(^DHCINDIV("0","IDate",idate,DivID))   q:DivID=""   d
	..;q:DivID=""
	..s PB=$p(^DHCINDIV(DivID),"^",3)
	..q:PB=""
	..s Flag=$p(^DHCINDIV(DivID),"^",5)
	..q:Flag'="I"
	..s Adminfoid=$P(^DHCINDIV(DivID),"^",2)
	..s Admreason=$p(^DHCINADM(Adminfoid),"^",18)
	..q:(Admreason'="XZFYA")&&(Admreason'="00A")
	..s Admtype=$p(^DHCINADM(Adminfoid),"^",14)
	..;b ;03
	..q:(Admtype'="35")&&(Admtype'="26")&&(Admtype'="28")
	..;b ;04
	..s Diagid=$p(^DHCINADM(Adminfoid),"^",26)
	..s Diagdesc=$p(^DHCINADM(Adminfoid),"^",27)
	..s PATType=$p(^DHCINADM(Adminfoid),"^",29)
	..;b ;01
	..S PATType=""
	..I Admreason="00A" d
	...s PATType=$p(^DHCINADM(Adminfoid),"^",4)
	...s PATType=..getlx(PATType)
	..I Admreason="XZFYA" d 
	...s PATType=$p(^DHCINADM(Adminfoid),"^",29)    //ZG 职工  JM 居民
	...i PATType="ZG" s PATType="职工"
	...i PATType="JM" s PATType="居民"
	..q:(ctcareprov'="")&&(PATType'=ctcareprov)
	..;b ;02
	..;s Center=$p(^DHCINADM(Adminfoid),"^",7)
	..;s Center=$p($$QueryByCode^DHCINSUDicData("XZFYAAddress",Center),"^",4)
	..I Admreason="00A" d
	...s Center=$p(^DHCINADM(Adminfoid),"^",7)
	...s Center=$p($$QueryByCode^DHCINSUDicData("XZFYAAddress",Center),"^",4)
	..I Admreason="XZFYA" d
	...s Center=$p(^DHCINADM(Adminfoid),"^",8)
	...s Center=$p($$QueryByCode^DHCINSUDicData("XZFYAAddress",Center),"^",4)
	..q:(Center'=patCenter)&(patCenter'="NULL")
	..s Adm=$p(^DHCINADM(Adminfoid),"^",1)
	..s IDNO=$p(^DHCINADM(Adminfoid),"^",34)
	..s Patname=$p(^DHCINADM(Adminfoid),"^",35)
	..s Admdate=$p(^PAADM(Adm),"^",6)
	..s Disdate=$p(^PAADM(Adm),"^",17)
	..s ZYDay=Disdate-Admdate
	..s Admdate=$zd(Admdate,3)
	..s Disdate=$zd(Disdate,3)
	..s ZFY=$p( ^DHCINDIV(DivID),"^",7)
	..s TCJZ=$p( ^DHCINDIV(DivID),"^",31)
	..s DBJZ=$p( ^DHCINDIV(DivID),"^",32)  ;大病
	..s yljz=""
	..i Admreason="00A" s yljz=$p( ^DHCINDIV(DivID),"^",34)  ;医疗救助
	..s GWY=$p( ^DHCINDIV(DivID),"^",33)  ;公务员
	..s GRZH=$p( ^DHCINDIV(DivID),"^",28)  ;账户
	..s XJ=$p( ^DHCINDIV(DivID),"^",15)  ;现金
	..s YYDF="" ;医院垫付
	..i Admreason="00A" s YYDF=$p( ^DHCINDIV(DivID),"^",49)
	..i Admreason="XZFYA" s YYDF=$p( ^DHCINDIV(DivID),"^",67)
	..s DIcid=""
	..s DIcid=$O(^DHCINDID("0","ITypeCode","HKC516-XZA",Diagid,DIcid))
	..s DiagidN=Diagid_","_Diagdesc
	..s ^TMPDBZ($j,DiagidN,"ZFY")=$g(^TMPDBZ($j,DiagidN,"ZFY"))+ZFY
	..s ^TMPDBZ($j,DiagidN,"TCJZ")=$g(^TMPDBZ($j,DiagidN,"TCJZ"))+TCJZ
	..s ^TMPDBZ($j,DiagidN,"DBJZ")=$g(^TMPDBZ($j,DiagidN,"DBJZ"))+DBJZ
	..s ^TMPDBZ($j,DiagidN,"GWY")=$g(^TMPDBZ($j,DiagidN,"GWY"))+GWY
	..s ^TMPDBZ($j,DiagidN,"GRZH")=$g(^TMPDBZ($j,DiagidN,"GRZH"))+GRZH
	..s ^TMPDBZ($j,DiagidN,"XJ")=$g(^TMPDBZ($j,DiagidN,"XJ"))+XJ
	..s ^TMPDBZ($j,DiagidN,"YYDF")=$g(^TMPDBZ($j,DiagidN,"YYDF"))+YYDF
	..s ^TMPDBZ($j,DiagidN,"yljz")=$g(^TMPDBZ($j,DiagidN,"yljz"))+yljz
	..s ^TMPDBZ($j,DiagidN,"Count")=$g(^TMPDBZ($j,DiagidN,"Count"))+1
	..i DIcid'="" s ZDFY=$p(^DHCINDID(DIcid),"^",5)
	..s:ctcareprov="ZG" PATType="职工"
	..s:ctcareprov="JM" PATType="居民"
	..s:(ctcareprov="")&(PATType="ZG") PATType="职工、居民"
	..s:(ctcareprov="")&(PATType="JM") PATType="职工、居民"
	
	s a=""
	
	f  s a=$O(^TMPDBZ($j,a))  q:a=""  d
	.s Diagid=$p(a,",",1)
	.s Diagdesc=$p(a,",",2)
	.s ZFY=$g(^TMPDBZ($j,a,"ZFY"))
	.s TCJZ=$g(^TMPDBZ($j,a,"TCJZ"))
	.s DBJZ=$g(^TMPDBZ($j,a,"DBJZ"))
	.s GWY=$g(^TMPDBZ($j,a,"GWY"))
	.s GRZH=$g(^TMPDBZ($j,a,"GRZH"))
	.s XJ=$g(^TMPDBZ($j,a,"XJ"))
	.s YYDF=$g(^TMPDBZ($j,a,"YYDF"))
	.s yljz=$g(^TMPDBZ($j,a,"yljz"))
	.s Count=$g(^TMPDBZ($j,a,"Count"))
	
    .d BuildDBZTT
    
	
	Quit $$$OK
BuildDBZTT   
	set Data=$lb(ind,Diagid,Diagdesc,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,PATType,ZDFY,yljz,Count)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod getlx(pattypedr) As %String
{
	s pattype="职工"
	s:(pattypedr=14)||(pattypedr=15)||(pattypedr=16)||(pattypedr=1401)||(pattypedr=1402)||(pattypedr=1403)||(pattypedr=1404) pattype="居民"
	s:(pattypedr=1405)||(pattypedr=1460)||(pattypedr=1501)||(pattypedr=1560) pattype="居民"
	;s:(pattypedr=116014)||(pattypedr=126015) pattype="伤残"
	q pattype
}

ClassMethod DBZDivInfoTWOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DBZDivInfoExecute ]
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

Query DBZDivInfoTWO(SDate, EDate, ctcareprov As %String, patCenter) As %Query(ROWSPEC = "ind,Diagid,Diagdesc,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,PATType,ZDFY,yljz,Count") [ SqlProc ]
{
}

// 2017徐州单病种病人结算信息d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","DBZDivInfoTWO","2017-03-01","2017-04-30","" )

ClassMethod DBZDivInfoThrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DBZDivInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod DBZDivInfoThrExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov, patCenter) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	s DivID="",PB=""
	s:EDate="" EDate=$h
	s:SDate="" SDate=$h
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	k ^TMPDBZSQB
	s i=0
	f idate=SDate:1:EDate  d
	.f  s DivID=$O(^DHCINDIV("0","IDate",idate,DivID))   q:DivID=""   d
	..s PB=$p(^DHCINDIV(DivID),"^",3)
	..q:PB=""
	..s Flag=$p(^DHCINDIV(DivID),"^",5)
	..q:Flag'="I"
	..s Adminfoid=$P(^DHCINDIV(DivID),"^",2)
	..s Admreason=$p(^DHCINADM(Adminfoid),"^",18)
	..q:(Admreason'="XZFYA")&&(Admreason'="00A")
	..s Admtype=$p(^DHCINADM(Adminfoid),"^",14)
	..q:(Admtype'="35")&&(Admtype'="26")&&(Admtype'="28")
	..s Center=$p(^DHCINADM(Adminfoid),"^",7)
	..s Center=$p($$QueryByCode^DHCINSUDicData("XZFYAAddress",Center),"^",4) 
	..q:(Center'=patCenter)&(patCenter'="NULL")
	..s Diagid=$p(^DHCINADM(Adminfoid),"^",26)
	..s Diagdesc=$p(^DHCINADM(Adminfoid),"^",27)
	..s PATType=$p(^DHCINADM(Adminfoid),"^",29)
	..I Admreason="00A" d
	...s PATType=$p(^DHCINADM(Adminfoid),"^",4)
	...s PATType=##class(web.DHCINSUPort).mwthfmnew(PATType)
	..I Admreason="XZFYA" s PATType=$p(^DHCINADM(Adminfoid),"^",29)
	..q:(ctcareprov'="")&&(PATType'=ctcareprov)
	..s Adm=$p(^DHCINADM(Adminfoid),"^",1)
	..s IDNO=$p(^DHCINADM(Adminfoid),"^",34)
	..s Patname=$p(^DHCINADM(Adminfoid),"^",35)
	..s Admdate=$p(^PAADM(Adm),"^",6)
	..s Disdate=$p(^PAADM(Adm),"^",17)
	..s ZYDay=Disdate-Admdate
	..s Admdate=$zd(Admdate,3)
	..s Disdate=$zd(Disdate,3)
	..s ZFY=$p( ^DHCINDIV(DivID),"^",7)
	..s TCJZ=$p( ^DHCINDIV(DivID),"^",31)
	..s DBJZ=$p( ^DHCINDIV(DivID),"^",32)  ;大病
	..s GWY=$p( ^DHCINDIV(DivID),"^",33)  ;公务员
	..s GRZH=$p( ^DHCINDIV(DivID),"^",28)  ;账户
	..s XJ=$p( ^DHCINDIV(DivID),"^",15)  ;现金
	..s YYDF="" ;医院垫付
	..i Admreason="00A" s YYDF=$p( ^DHCINDIV(DivID),"^",49)
	..i Admreason="XZFYA" s YYDF=$p( ^DHCINDIV(DivID),"^",67)
	..s DIcid=""
	..s DIcid=$O(^DHCINDID("0","ITypeCode","HKC516-XZA",Diagid,DIcid))
	..s DiagidN=Diagid_","_Diagdesc
	..s ^TMPDBZSQB($j,"ZFY")=$g(^TMPDBZSQB($j,"ZFY"))+ZFY
	..s ^TMPDBZSQB($j,"TCJZ")=$g(^TMPDBZSQB($j,"TCJZ"))+TCJZ
	..s ^TMPDBZSQB($j,"DBJZ")=$g(^TMPDBZSQB($j,"DBJZ"))+DBJZ
	..s ^TMPDBZSQB($j,"GWY")=$g(^TMPDBZSQB($j,"GWY"))+GWY
	..s ^TMPDBZSQB($j,"GRZH")=$g(^TMPDBZSQB($j,"GRZH"))+GRZH
	..s ^TMPDBZSQB($j,"XJ")=$g(^TMPDBZSQB($j,"XJ"))+XJ
	..s ^TMPDBZSQB($j,"YYDF")=$g(^TMPDBZSQB($j,"YYDF"))+YYDF
	..s ^TMPDBZSQB($j,"Count")=$g(^TMPDBZSQB($j,"Count"))+1
	..i DIcid'="" s ZDFY=$p(^DHCINDID(DIcid),"^",5)
	..s:ctcareprov="ZG" PATType="职工"
	..s:ctcareprov="JM" PATType="居民"
	..s:(ctcareprov="")&(PATType="ZG") PATType="职工、居民"
	..s:(ctcareprov="")&(PATType="JM") PATType="职工、居民"
	

	

	s ZFY=$g(^TMPDBZSQB($j,"ZFY"))
	s TCJZ=$g(^TMPDBZSQB($j,"TCJZ"))
	s DBJZ=$g(^TMPDBZSQB($j,"DBJZ"))
	s GWY=$g(^TMPDBZSQB($j,"GWY"))
	s GRZH=$g(^TMPDBZSQB($j,"GRZH"))
	s XJ=$g(^TMPDBZSQB($j,"XJ"))
	s YYDF=$g(^TMPDBZSQB($j,"YYDF"))
	s Count=$g(^TMPDBZSQB($j,"Count"))
	
    d BuildDBZTTr
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDBZTTr   
	set Data=$lb(ind,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,ZDFY,$zd(SDate,3),$zd(EDate,3),Count,PATType)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DBZDivInfoThrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DBZDivInfoExecute ]
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

Query DBZDivInfoThr(SDate, EDate, ctcareprov, patCenter) As %Query(ROWSPEC = "ind,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,ZDFY,SDate,EDate,Count,PATType") [ SqlProc ]
{
}

// 2017当前在院病人信息院长查询用  d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","NowInpatInfo")

ClassMethod NowInpatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NowInpatInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod NowInpatInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	s DivID="",PB=""
	;s:EDate="" EDate=$h
	;s:SDate="" SDate=$h
	;s:SDate["-" SDate=$zdh(SDate,3)
	;s:EDate["-" EDate=$zdh(EDate,3)
	s ctid="",Date="",Time="",Admid=""
	k ^tmppatinfo
	f  s ctid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid))  q:ctid=""  d
	.f  s Date=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date)) q:Date=""  d
	..f  s Time=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time)) q:Time=""  d
	...f  s Admid=$O(^PAADMi("AdmTypeCurrLoc","I",ctid,Date,Time,Admid)) q:Admid=""  d
	....s Monthid=$p(^PAADM(Admid),"^",75)
	....s wardid=$p(^PAADM(Admid),"^",70)
	....s ctloc=$P(^PAWARD(wardid),"^",2)
	....s Bed=$p(^PAADM(Admid),"^",73)
	....s BWFlag=##class(web.Routinework).GetPatBWBZ(Admid)
	....;i BWFlag="1" w !,Admid 
	....;w !,Admid_"  "_BWFlag
	....s:Monthid="" ^tmppatinfo($j,ctloc)=$g(^tmppatinfo($j,ctloc))+1
	....s:(Monthid="")&(Bed'="") ^tmppatinfo($j,ctloc,"Bed")=$g(^tmppatinfo($j,ctloc,"Bed"))+1
	....s:BWFlag=1 ^tmppatinfo($j,ctloc,"BW")=$g(^tmppatinfo($j,ctloc,"BW"))+1
	....s:BWFlag=2 ^tmppatinfo($j,ctloc,"BZ")=$g(^tmppatinfo($j,ctloc,"BZ"))+1
	....s:BWFlag=3 ^tmppatinfo($j,ctloc,"WZ")=$g(^tmppatinfo($j,ctloc,"WZ"))+1
	....s:Monthid'="" ^tmppatinfo($j,ctloc,"Newborn")=$g(^tmppatinfo($j,ctloc,"Newborn"))+1
	....s:(Date=+$h)&(Monthid="") ^tmppatinfo($j,ctloc,"NewPat")=$g(^tmppatinfo($j,ctloc,"NewPat"))+1
	
	s Adm=""
	
	f  s Adm=$O(^PAADMi("DischDate",+$h,Adm))  q:Adm=""  d
	.s Monthid=$p(^PAADM(Adm),"^",75)
	.q:Monthid'=""
	.s wardid=$p(^PAADM(Adm),"^",70)
	.s ctloc=$P(^PAWARD(wardid),"^",2)
	.s Admdate=$p(^PAADM(Adm),"^",6)
	.s:Admdate=+$h ^tmppatinfo($j,ctloc,"NewPat")=$g(^tmppatinfo($j,ctloc,"NewPat"))+1
	.s ^tmppatinfo($j,ctloc,"Disc")=$g(^tmppatinfo($j,ctloc,"Disc"))+1
	
	
	
	
	
	
	
	s a="",b=0,c=0,d=0,e=0,f=0,g=0,h=0
	f  s a=$O(^tmppatinfo($j,a))  q:a=""   d
	.s b=$g(^tmppatinfo($j,a))
	.s c=$g(^tmppatinfo($j,a,"NewPat"))
	.s d=$g(^tmppatinfo($j,a,"Newborn"))
	.s e=$g(^tmppatinfo($j,a,"Disc"))
	.s f=$g(^tmppatinfo($j,a,"BW"))
	.s g=$g(^tmppatinfo($j,a,"BZ"))
	.s h=$g(^tmppatinfo($j,a,"WZ"))
	.s i=$g(^tmppatinfo($j,a,"Bed"))
	.s:b="" b=0   //当前在院
	.s:c="" c=0	  //新入院
	.s:d="" d=0   //新出生
	.s:e="" e=0  // 出院病人
	.s:f="" f=0  // 病危
	.s:g="" g=0  //病重
	.s:h="" h=0  //危重
	.s:i="" i=0  //在床病人
    .d BuildPatinfo
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildPatinfo   
	set Data=$lb(ind,a,b,c,d,e,f,g,h,i)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod NowInpatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NowInpatInfoExecute ]
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

Query NowInpatInfo() As %Query(ROWSPEC = "ind,a,b,c,d,e,f,g,h,i") [ SqlProc ]
{
}

// w ##class(web.RoutineworkC).GetDiagnosICDandDesc("1972994")

ClassMethod GetDiagnosICDandDesc(adm) As %String
{
	//取诊断 如果有代码的优先取带代码的不带的好像没法搞
	q:adm="" ""
	s MRAdmRowid=$p($g(^PAADM(adm)),"^",61)
	q:MRAdmRowid="" ""
	s dia="",sub="",dign1="",dign2=""
	s MRDiagnoseDesc=""
	f  s sub=$O(^MR(MRAdmRowid,"DIA",sub))  q:sub=""   d
	.q:sub=0
	.s dign=$g(^MR(MRAdmRowid,"DIA",sub,"DES",1))
	.i (dign="")  d
	..s dign1=^MR(MRAdmRowid,"DIA",sub)
	..s dign1=$p(dign1,"^",1)
	..s dign2=$p(^MRC("ID",dign1),"^",2)
	..s dign=dign2
	.s dia=dia_" "_dign
	q dia
}

ClassMethod GetDiagnosICDandDescWithID(adm) As %String
{
	//取诊断 如果有代码的优先取带代码的不带的好像没法搞
	s DiagICD="",OutDiagICD="",DiagICD2=""
	q:adm="" ""
	s MRAdmRowid=$p($g(^PAADM(adm)),"^",61)
	q:MRAdmRowid="" ""
	s dia="",sub="",dign1="",dign2=""
	s MRDiagnoseDesc=""
	f  s sub=$O(^MR(MRAdmRowid,"DIA",sub))  q:sub=""   d
	.q:sub=0
	.s dign=$g(^MR(MRAdmRowid,"DIA",sub,"DES",1))
	.i (dign="")  d
	..s dign1=^MR(MRAdmRowid,"DIA",sub)
	..s dign1=$p(dign1,"^",1)
	..s dign2=$p(^MRC("ID",dign1),"^",2)
	..s DiagICD=$p(^MRC("ID",dign1),"^",4)
	..s dign=dign2
	.if dia="" d
	..s dia=dign
	.else  d
	..s dia=dia_" "_dign
	.if OutDiagICD=""  d
	..s OutDiagICD=DiagICD
	.else  d
	..s OutDiagICD=OutDiagICD_" "_DiagICD
	
	
	q OutDiagICD_"^"_dia
}

// d ##class(%ResultSet).RunQuery("web.RoutineworkC","GetYDJFee","2017-05-09","2017-05-09")

/// 阴道镜计费
Query GetYDJFee(SDate, EDate) As %Query(ROWSPEC = "ExecUser,papminame,ExecArcItmID,ExecDT,Number:%Integer,TotalPrice:%Float") [ SqlProc ]
{
}

ClassMethod GetYDJFeeExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	k ^tempWYH($j)
	Set repid=$I(^CacheTemp)
  	Set ind=1
  	
	Set qHandle=$lb(0,repid,0)
  	q:SDate="" $$$OK
	q:EDate="" $$$OK
	s SDate=$zdh(SDate,3)
	s EDate=$zdh(EDate,3)
	s (YDJRowId,ExecArcItmID,ExecStatue,ExecOrdAmt,ExecUser,papmi)=""
	f Date=SDate:1:EDate d
	.f  s YDJRowId=$o(^DHCLGYExecDate("date",Date,YDJRowId))  q:YDJRowId=""  d
	..;w !,YDJRowId
	..s ExecArcItmID=$p(^DHCLGYExec(YDJRowId),"^",9)
	..s ExecStatue=$p(^DHCLGYExec(YDJRowId),"^",5)
	..s ExecOrdAmt=$p(^DHCLGYExec(YDJRowId),"^",3)
	..s ExecDate=$p(^DHCLGYExec(YDJRowId),"^",2)
	..s ExecDate=$zd(ExecDate,3)
	..s ExecTime=$p(^DHCLGYExec(YDJRowId),"^",6)
	..s ExecTime=$zt(ExecTime,2)
	..s ExecDT=ExecDate_" "_ExecTime
	..s Number=1
	..s:ExecStatue="C" Number=-1
	..s Userid=$p(^DHCLGYExec(YDJRowId),"^",7)
	..s ExecUser=$p(^SSU("SSUSR",Userid),"^",2)
	..s ExecAdm=$p(^DHCLGYExec(YDJRowId),"^",1)
	..s papmi=$p(^PAADM(ExecAdm),"^",1)
	..s papminame=$p(^PAPER(papmi,"ALL"),"^",1)
	..d OutputRow00
	Quit $$$OK
OutputRow00 
	set Data=$lb(ExecUser,papminame,ExecArcItmID,ExecDT,Number,ExecOrdAmt) //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetYDJFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYDJFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetYDJFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYDJFeeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else    {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##class(web.RoutineworkC).GetOperation("1166741")

ClassMethod GetOperation(AdmDr) As %String
{
	
	s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AdmDr,"HDSD00.11")
	s TEST=arr.GetAt("HDSD00.11.090")	 //手术操作及名称
	w !,TEST
}

// w ##class(web.RoutineworkC).GetPatOrdItemStr("5677211")

// w ##class(web.RoutineworkC).GetPatOrdItemStr("5678987")

ClassMethod GetPatOrdItemStr(Adm) As %String
{
	s oeordid="",sub=0,ItmStr=""
	q:Adm="" ""
	s RegNo=##Class(web.DHCNurConsultationYJ).GetRegNobyEpisodeID(Adm)
	s papmiId=+^PAADM(Adm)
	
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s Sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s Age=##class(web.DHCCLCom).CalAge(birth,+$h)
    s Age=$p(Age,"Y",1)_"岁"  //_$p(Age,"Y",2)
	s admTypef=$p($G(^PAADM(Adm)),"^",2)

	f  s oeordid=$o(^OEORD(0,"Adm",Adm,oeordid)) q:oeordid=""  d 

	.f  s sub=$O(^OEORD(oeordid,"I",sub))  q:sub=""  d

	
	..s RecLoc=$P(^OEORD(oeordid,"I",sub,3),"^",6)

	..q:RecLoc'="28"

	..s ItmMast=$p(^OEORD(oeordid,"I",sub,1),"^",2)
	..s ArcimDR=ItmMast
	..s Fir=+ItmMast
	..s Sec=$p(ItmMast,"||",2)
	..s OrcatDR=$P(^ARCIM(Fir,Sec,1),"^",10)
	..s OrcatDesc=$P(^ARC("IC",OrcatDR),"^",2)	
	..s OrdStatDR=$P($G(^OEORD(oeordid,"I",sub,1)),"^",13)
	..i OrdStatDR'="" s OrdStatDesc=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	..e  s OrdStatDesc=""
	..s OrdDate1=$p($g(^OEORD(oeordid,"I",sub,3)),"^",7)   //OEORI_Date
    ..s OrdTime1=$p($g(^OEORD(oeordid,"I",sub,1)),"^",17)  //OEORI_TimeOrd
	..s OrdDateTime=$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	..s oeoriPrice=$p($g(^OEORD(oeordid,"I",sub,3)),"^",25)
	..w !,oeoriPrice
	..s OrdDate1=$p($g(^OEORD(oeordid,"I",sub,3)),"^",7)   //OEORI_Date
	..s OrdCost=0 // EH variable reset
	..s OrdQty=$p($g(^OEORD(oeordid,"I",sub,1)),"^",12)
    ..s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	..;q:OrdUnitCost=0    add by zz 0费用医嘱信息显示在门诊手术室信息中 2023-03-30
	..s OrdCost=OrdUnitCost*OrdQty
	..s Itmdesc=$p(^ARCIM(Fir,Sec,1),"^",2)
	..s OrdBilled=$p($g(^OEORD(oeordid,"I",sub,3)),"^",5)
	..i admTypef="I" s OrdBilled=$p($g(^OEORD(oeordid,"I",sub,"X",1)),"^",6)
	..s OrdBilled=$S(OrdBilled="P":"已收费",OrdBilled="B":"已账单",OrdBilled="TB":"未计费",1:"")
	..s Itmdesc=RegNo_"^"_PatName_"^"_Sex_"^"_Age_"^"_OrdDateTime_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_oeordid_"||"_sub_"^"_Itmdesc_"^"_OrdBilled_"^"_OrdUnitCost_"^"_OrdQty_"^"_OrdCost
	..if ItmStr="" d
	...s ItmStr=Itmdesc
	..else  d
	...s ItmStr=ItmStr_"#"_Itmdesc
	
	
	q ItmStr
}

ClassMethod GetSSSQueueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSSQueueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.RoutineworkC","GetSSSQueue","2023-07-08","2023-07-08")
/// call web.RoutineworkC_GetSSSQueue("2023-03-30","2023-03-30")
ClassMethod GetSSSQueueExecute(ByRef qHandle As %Binary, SDate, EDate) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	k ^tmpSSSQUEUE($j)
	s ^tmpinputdate=SDate_"  "_EDate
	s CardNo="",visid=""
	s:EDate="" EDate=$h
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	/*
	f idate=SDate:1:EDate  d
	.f  s CardNo=$O(^DHCVISOPi(0,"DateCardNo",idate,CardNo))  q:CardNo=""  d
	..f  s visid=$O(^DHCVISOPi(0,"DateCardNo",idate,CardNo,visid))  q:visid=""  d
	...s EpisodeID=$p(^DHCVISOP(visid),"^",2)
	...s CreatTime=$p(^DHCVISOP(visid),"^",6)
	...s OrdStr=..GetPatOrdItemStr(EpisodeID)
	...s CallState=$p(^DHCVISOP(visid),"^",11)
	...f i=1:1:$L(OrdStr,"#") d
	....s Str=$p(OrdStr,"#",i)
	....s ArcItm=$p(Str,"^",9)
	....s OrdID=$p(Str,"^",8)
	....s Qsta=$p(^DHCVISOP(visid),"^",11)
	....s ^tmpSSSQUEUE($j,CreatTime,ArcItm,OrdID)=Str_"^"_Qsta_"^"_CardNo
	*/
	//---------------

	s ArcItm="",OrdID="" ,oeoribilled="",orderstatus=""
	f idate=SDate:1:EDate  d
	.f  S visid=$O(^DHCVISOPi(0,"DateCallState",idate,"W",visid))  q:visid=""  d
	..s ArcItm=""
	..s EpisodeID=$p(^DHCVISOP(visid),"^",2)
	..s CreatTime=$p(^DHCVISOP(visid),"^",6)
	..s OrdStr=..GetPatOrdItemStr(EpisodeID)
	..s CallState=$p(^DHCVISOP(visid),"^",11)
	..s CardNo=$p(^DHCVISOP(visid),"^",1)
	..s Regno=$p(^DHCVISOP(visid),"^",3)
	..f i=1:1:$L(OrdStr,"#") d
	...s Str=$p(OrdStr,"#",i)
	...;b ;Str1
	...//s ArcItm=ArcItm_" "_$p(Str,"^",9)
	...s OrdID=OrdID_" "_$p(Str,"^",8)
	...s patname=$p(Str,"^",2)
	...s Sex=$p(Str,"^",3)
	...s Age=$p(Str,"^",4)
	...s OrdDate=$p(Str,"^",5)
	...//b:patname="张方" ;003
	...s ArcItmOne= $p(Str,"^",9)
	...s oeoribilled=$p(Str,"^",10)
	...i oeoribilled="未计费" s ArcItmOne=ArcItmOne_"-未计费"
	...i oeoribilled="已账单" s ArcItmOne=ArcItmOne_"-已账单"
	...s orderstatus=$p(Str,"^",6)
	...i orderstatus="作废" s ArcItmOne=ArcItmOne_"-作废"
	...i $g(ArcItm)="" s ArcItm=ArcItmOne
	...e  s ArcItm=ArcItm_","_ArcItmOne
	..s Time=$zt($p(^DHCVISOP(visid),"^",6),1)
	..s Qsta=$p(^DHCVISOP(visid),"^",11)
	..s Qstatue="等候"
	..i EpisodeID=5850336  b
	..s AdmID=EpisodeID
	..s PapmiNO=Regno
	..d OutputSSSQUEUE
		
	f idate=SDate:1:EDate  d
	.f  S visid=$O(^DHCVISOPi(0,"DateCallState",idate,"R",visid))  q:visid=""  d
	..s ArcItm=""
	..s EpisodeID=$p(^DHCVISOP(visid),"^",2)
	..s CreatTime=$p(^DHCVISOP(visid),"^",6)
	..s OrdStr=..GetPatOrdItemStr(EpisodeID)
	..s CallState=$p(^DHCVISOP(visid),"^",11)
	..s CardNo=$p(^DHCVISOP(visid),"^",1)
	..s Regno=$p(^DHCVISOP(visid),"^",3)
	..f i=1:1:$L(OrdStr,"#") d
	...s Str=$p(OrdStr,"#",i)
	...;b ;Str2
	...//s ArcItm=ArcItm_" "_$p(Str,"^",9)
	...s OrdID=OrdID_" "_$p(Str,"^",8)
	...s patname=$p(Str,"^",2)
	...s Sex=$p(Str,"^",3)
	...s Age=$p(Str,"^",4)
	...s OrdDate=$p(Str,"^",5)
	...//b:patname="张方" ;002
	...s ArcItmOne= $p(Str,"^",9)
	...s oeoribilled=$p(Str,"^",10)
	...i oeoribilled="未计费" s ArcItmOne=ArcItmOne_"-未计费"
	...i oeoribilled="已账单" s ArcItmOne=ArcItmOne_"-已账单"
	...s orderstatus=$p(Str,"^",6)
	...i orderstatus="作废" s ArcItmOne=ArcItmOne_"-作废"
	...i $g(ArcItm)="" s ArcItm=ArcItmOne
	...e  s ArcItm=ArcItm_","_ArcItmOne
	..s Time=$zt($p(^DHCVISOP(visid),"^",6),1)
	..s Qsta=$p(^DHCVISOP(visid),"^",11)
	..s Qstatue="预约"
	..i EpisodeID=5850336  b
	..s AdmID=EpisodeID
	..s PapmiNO=Regno
	..d OutputSSSQUEUE
	
	d OutputSSSQUEUE2
	f idate=SDate:1:EDate  d
	.f  S visid=$O(^DHCVISOPi(0,"DateCallState",idate,"C",visid))  q:visid=""  d
	..s ArcItm=""
	..s EpisodeID=$p(^DHCVISOP(visid),"^",2)
	..s CreatTime=$p(^DHCVISOP(visid),"^",6)
	..s OrdStr=..GetPatOrdItemStr(EpisodeID)
	..s CallState=$p(^DHCVISOP(visid),"^",11)
	..s CardNo=$p(^DHCVISOP(visid),"^",1)
	..s Regno=$p(^DHCVISOP(visid),"^",3)
	..f i=1:1:$L(OrdStr,"#") d
	...s Str=$p(OrdStr,"#",i)
	...;b ;Str3
	...//s ArcItm=ArcItm_" "_$p(Str,"^",9)
	...s OrdID=OrdID_" "_$p(Str,"^",8)
	...s patname=$p(Str,"^",2)
	...s Sex=$p(Str,"^",3)
	...s Age=$p(Str,"^",4)
	...s OrdDate=$p(Str,"^",5)
	...//s ArcItm= $p(Str,"^",9)
	...s ArcItmOne= $p(Str,"^",9)
	...s oeoribilled=$p(Str,"^",10)
	...i oeoribilled="未计费" s ArcItmOne=ArcItmOne_"-未计费"
	...i oeoribilled="已账单" s ArcItmOne=ArcItmOne_"-已账单"
	...s orderstatus=$p(Str,"^",6)
	...i orderstatus="作废" s ArcItmOne=ArcItmOne_"-作废"
	...//w:patname="张方" ArcItmOne,!
	...//w:patname="张方" ArcItm,!
	...i $g(ArcItm)="" s ArcItm=ArcItmOne
	...e  s ArcItm=ArcItm_","_ArcItmOne
	...//b:patname="张方" ;001
	..s Time=$zt($p(^DHCVISOP(visid),"^",6),1)
	..s Qsta=$p(^DHCVISOP(visid),"^",11)
	..s Qstatue="已叫号"
	..i EpisodeID=5850336  b
	..s AdmID=EpisodeID
	..s PapmiNO=Regno
	..d OutputSSSQUEUE
	
	
	
	
	//---------------
	
	
	
	
	
	
	
	/*s a="",b="",c=""
	
	f  s a=$O(^tmpSSSQUEUE($j,a))  q:a=""  d
	.f  s b=$O(^tmpSSSQUEUE($j,a,b))  q:b=""  d
	..f  s c=$O(^tmpSSSQUEUE($j,a,b,c))  q:c=""  d
	...s Str=$g(^tmpSSSQUEUE($j,a,b,c))
	...s Regno=$p(Str,"^",1)
	...s patname=$p(Str,"^",2)  ;0000008406^李梅^女^34岁^2017-05-15  09:26:06^核实^计生科手术^1152439||4^造影[计生科]^已收费^187.2^1^187.2
	...s Sex=$p(Str,"^",3)
	...s Age=$p(Str,"^",4)
	...s OrdDate=$p(Str,"^",5)
	...s OrdSta=$p(Str,"^",6)
	...s OrdCate=$p(Str,"^",7)
	...s OrdID=$p(Str,"^",8)
	...s ArcItm=$p(Str,"^",9)
	...s Qstatue=$p(Str,"^",14)
	...s:Qstatue="R" Qstatue="准备"
	...s:Qstatue="W" Qstatue="等待"
	...s:Qstatue="C" Qstatue="已呼叫"
	...s CardNo=$p(Str,"^",15)
	...s Time=$zt(a,1)
	
	
	
	...d OutputSSSQUEUE
	;k ^tmpSSSQUEUE($j) */
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputSSSQUEUE    
	set Data=$lb(ind,Regno,patname,Sex,Age,OrdDate,ArcItm,Time,Qstatue,CardNo,AdmID,PapmiNO)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
 
OutputSSSQUEUE2    
	set Data=$lb("如需重复呼叫继续点姓名","","","","已下患者已叫号","","","","","")   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetSSSQueueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSSQueueExecute ]
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

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","GetSSSQueue","2021-05-15","2021-05-15")

Query GetSSSQueue(SDate, EDate) As %Query(ROWSPEC = "ind,Regno,patname,Sex,Age,OrdDate,ArcItm,CreatTime,Qstatue,PatCardNo,AdmID,PapmiNO") [ SqlProc ]
{
}

// 2017萧县医保结算数据表d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","XXInsuDivInfo","2017-03-01","2017-04-30","" )

ClassMethod XXInsuDivInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DBZDivInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod XXInsuDivInfoExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	s:SDate["-" SDate=$zdh(SDate,3)
	s:EDate["-" EDate=$zdh(EDate,3)
	s DivId=""
	f idate=SDate:1:EDate  d
	.s DivId=$O(^DHCINDIV("0","IDate",idate,DivId))  q:DivId=""  d
	..s Flag=$p(^DHCINDIV(DivId),"^",5)
	..q:Flag="D"
	..s Adminfo=$p(^DHCINDIV(DivId),"^",2)
	..s bcbxf0=$p(^DHCINDIV(DivId),"^",7)
	..s insupay1=$p(^DHCINDIV(DivId),"^",31)
	..;s 
	..w !,DivId
	
	
	
    d BuildDBZTTrr
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDBZTTrr
	set Data=$lb(ind,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,ZDFY,$zd(SDate,3),$zd(EDate,3),Count)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod XXInsuDivInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DBZDivInfoExecute ]
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

Query XXInsuDivInfo(SDate, EDate, ctcareprov) As %Query(ROWSPEC = "ind,ZFY,TCJZ,DBJZ,GWY,GRZH,XJ,YYDF,ZDFY,SDate,EDate,Count") [ SqlProc ]
{
}

// w ##class(RoutineworkC).GetPatAdmType("1217045")

ClassMethod GetPatAdmType(Adm) As %String
{
	
	s AdmInfoid=""
	s Admtype=""
	
	f  s AdmInfoid=$O(^DHCINADM("0","ADM",Adm,AdmInfoid))  q:AdmInfoid=""  d
	.s Admflag=$p(^DHCINADM(AdmInfoid),"^",11)
	.q:Admflag="B"
	.q:Admflag="S"
	.s Admtype=$p(^DHCINADM(AdmInfoid),"^",14)
	
	q Admtype
}

// d ##class(web.RoutineworkC).LCLJ("2017-05-01","2017-05-01")

ClassMethod LCLJ(StDate, EndDate) As %String
{
	s StDate=$zdh(StDate,3)
	s EndDate=$zdh(EndDate,3)
	s Adm=""
	f idate=StDate:1:EndDate  d
	.f  s Adm=$O(^PAADMi("DischDate",idate,Adm))  q:Adm=""  d
	..s rtn=##class(DHCCPW.IO.ForIInfoSrv).GetCPWInfoByAdm(Adm)
	..if rtn'="" d 
	...w !,Adm_"@"_rtn
}

// w ##class(web.RoutineworkC).FindDepositDet("<Request><AdmID>1242995</AdmID><UserCode></UserCode></Request>")

ClassMethod FindDepositDet(Input As %String) As %String
{
	
	set $zt="ErrorDep"
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(web.DHCQY.Model.DHCDepositDetRequest).%New()
	set OutputObj=##class(web.DHCQY.Model.DHCDepositDetResponse).%New() //输出
	
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    set OutputObj.ResultCode="-1"
	set OutputObj.ResultDesc="无预交明细"
    Set Adm=inputObj.AdmID
    Set Usercode=inputObj.UserCode
    set deposittype="住院押金"
    set rowid="",sum="",prttime=""
    s AdmSta=$p(^PAADM(Adm),"^",20)
    if AdmSta="D" 
    {
	   set OutputObj.AdmStatue="出院"
	    }
	 if AdmSta="A" 
	 {
		 set OutputObj.AdmStatue="在院"
		 
		 }
    s FeeSum=0
    s FeeStr=##class(web.DHCBillInterface).IGetTarItemCate(Adm,"","TIC","^^^^")
    s Len=$L(FeeStr,"!")
    f cou=1:1:Len  d
    .s String=$p(FeeStr,"!",cou)
    .s Fee=$P(String,"^",4)
    .s FeeSum=FeeSum+Fee
    s InsuFee=""
    s InsuFee=##class(web.DHCINSUPort).GetDividePreByAdmDr(Adm)
    f  s rowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,rowid)) q:rowid=""  d
 	.s tmp=$g(^DHCSFPRINTDETAIL(rowid))
 	.s Type=$p(tmp,"^",13),Type=$p(^ARC("ARCDT",Type),"^",2)
	.q:(deposittype'="")&(Type'=deposittype)
 	.s rcptno=$p(tmp,"^",1)
 	.s title=$p(tmp,"^",29)
 	.s rcptno=title_rcptno
 	.s prtdate=$p(tmp,"^",2)
 	.i prtdate'="" s prtdate=$zd(prtdate,3)
 	.s prttime=$p(tmp,"^",3)
 	.i prttime'="" s prttime=$zt(prttime,1)
 	.s payamt=$p(tmp,"^",6)
 	.s paymode=$p(tmp,"^",9)
 	.i paymode'="" d
 	..s paymode=$p(^CT("CTPM",paymode),"^",2)
 	.s prtstatus=$p(tmp,"^",8)
 	.i prtstatus'=2 s sum=sum+payamt
 	.i prtstatus="1" s prtstatus="正常"
 	.i prtstatus="2" s prtstatus="作废"
 	.i prtstatus="3" s prtstatus="冲红"
 	.i prtstatus="4" s prtstatus="已冲红"
 	.i prtstatus="5" s prtstatus="打印"
 	.s cardno=$p(tmp,"^",11)   ;银行卡号
 	.s company=$p(tmp,"^",12)
 	.s bank=$p(tmp,"^",10)
 	.s bankdesc="",bankdesc1=""
 	.i bank'="" d
 	..i $d(^CMC("CMCBM",bank)) d
 	...s bankdesc1=$p(^CMC("CMCBM",bank),"^",2)
 	.s banksub=$p(tmp,"^",35)
 	.s bankdesc=bankdesc1_" "_banksub
 	.s adduser=$p(tmp,"^",14)
 	.s comment=$p(tmp,"^",33)
 	.i adduser'="" d
 	..s adduser=$p($g(^SSU("SSUSR",adduser)),"^",2)
 	.s rcptdr=$p(tmp,"^",5)
 	.;s adm=$p(tmp,"^",4)
 	.i rcptdr'="" d
 	..s arpbl=$p(^ARRCP(rcptdr,"RAL",1),"^",18)
	.e  s arpbl=""
	.s authno=$p(^ARRCP(rcptdr,"PAYM",1),"^",5)
	.s arpbl=$g(arpbl)
	.i arpbl="" s arpbl=" "
	.s jkflag=$p(tmp,"^",23)
	.s select="1"
	.s paystatus=" "
	.i arpbl'=" "  s paystatus="已结"
	.;bbackflag,bbackdate,bbacktime,bbackuser,refreason 
	.s bbackdr=""
	.s bbackdr=$o(^DHCJFBankBack(0,"Yjrowid",rowid,bbackdr),-1)
	.i bbackdr=""  d
	..s bbackflag="",bbackdate="",bbacktime="",bbackuser=""
	.e  d
	..s bbackflag1=$p(^DHCJFBankBack(bbackdr),"^",4)
	..i bbackflag1="0"  d
	...s bbackflag="到帐"
	..e  d
	...s bbackflag="未到帐"
	..s bbackdate=$p(^DHCJFBankBack(bbackdr),"^",6)
	..i bbackdate'=""  s bbackdate=$zd(bbackdate,3)
	..s bbacktime=$p(^DHCJFBankBack(bbackdr),"^",7)
	..i bbacktime'=""  s bbacktime=$zt(bbacktime,1)
	..s bbackuser1=$p(^DHCJFBankBack(bbackdr),"^",5)
	..i bbackuser1=""  d
	...s bbackuser=""
	..e  d
	...i $d(^SSU("SSUSR",bbackuser1))=0  d
	....s bbackuser=""
	...e  d
	....s bbackuser1=$p(^SSU("SSUSR",bbackuser1),"^",2)
	.s yjrefdr=""
	.s yjrefdr=$p(tmp,"^",31)
	.i yjrefdr=""  d
	..s refreason=""
	.e  d
	..i $d(^DHCJFYJRREASON(yjrefdr))=0  d
	...s refreason=""
	..e  d
	...s refreason=$p(^DHCJFYJRREASON(yjrefdr),"^",2)
	.s retrcptno=$p(tmp,"^",7)
	.set OutputObjDet=##class(web.DHCQY.Model.DHCDepositDetails).%New()  //明细
	.s OutputObjDet.RcptNo=rcptno
	.s OutputObjDet.PrintDate=prtdate
	.s OutputObjDet.PrintTime=prttime
	.s OutputObjDet.Amount=payamt
	.s OutputObjDet.PayMode=paymode
	.s OutputObjDet.Statue=prtstatus
	.s OutputObjDet.BankCard=cardno
	.s OutputObjDet.UserName=adduser
	.Do OutputObj.DepositDet.Insert(OutputObjDet)
	.Do OutputObj.%Close()
	set OutputObj.ResultCode="0"
	set OutputObj.ResultDesc="成功"
	set OutputObj.DepSum=sum
	set OutputObj.FeeSum=FeeSum
	set OutputObj.InsuFeeSum=InsuFee
	;Do OutputObj.XMLExportToString(.OutputXML,"Response")
 	;q OutputXML
 	
 	
 	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
ErrorDep
	set OutputObj=##class(web.DHCQY.Model.DHCDepositDetResponse).%New() //输出
	set OutputObj.ResultCode="-2"
	set OutputObj.ResultDesc=$ze
	set tStatus=OutputObj.XMLExportToString(.xml)
	q xml
}

/// w ##class(web.RoutineworkC).FindPatFeeDepInsu("<Request><AdmID>1242995</AdmID><UserCode></UserCode></Request>")
ClassMethod FindPatFeeDepInsu(Input As %String) As %String
{
	
	set $zt="FindPatFeeDepInsu"
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(web.DHCQY.Model.DHCDepositDetRequest).%New()
	set OutputObj=##class(web.DHCQY.Model.DHCDepositDetResponse).%New() //输出
	
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    set OutputObj.ResultCode="-1"
	set OutputObj.ResultDesc="无预交明细"
    Set Adm=inputObj.AdmID
    Set Usercode=inputObj.UserCode
    set deposittype="住院押金"
    set rowid="",sum="",prttime=""
    s AdmSta=$p(^PAADM(Adm),"^",20)
    if AdmSta="D" 
    {
	   set OutputObj.AdmStatue="出院"
	    }
	 if AdmSta="A" 
	 {
		 set OutputObj.AdmStatue="在院"
		 
		 }
    s FeeSum=0
    s FeeStr=##class(web.DHCBillInterface).IGetTarItemCate(Adm,"","TIC","^^^^")
    s Len=$L(FeeStr,"!")
    f cou=1:1:Len  d
    .s String=$p(FeeStr,"!",cou)
    .s Fee=$P(String,"^",4)
    .s FeeSum=FeeSum+Fee
    s InsuFee=""
    s InsuFee=##class(web.DHCINSUPort).GetDividePreByAdmDr(Adm)
    f  s rowid=$o(^DHCSFPRINTDETAIL(0,"adm",Adm,rowid)) q:rowid=""  d
 	.s tmp=$g(^DHCSFPRINTDETAIL(rowid))
 	.s Type=$p(tmp,"^",13),Type=$p(^ARC("ARCDT",Type),"^",2)
	.q:(deposittype'="")&(Type'=deposittype)
 	.s rcptno=$p(tmp,"^",1)
 	.s title=$p(tmp,"^",29)
 	.s rcptno=title_rcptno
 	.s prtdate=$p(tmp,"^",2)
 	.i prtdate'="" s prtdate=$zd(prtdate,3)
 	.s prttime=$p(tmp,"^",3)
 	.i prttime'="" s prttime=$zt(prttime,1)
 	.s payamt=$p(tmp,"^",6)
 	.s paymode=$p(tmp,"^",9)
 	.i paymode'="" d
 	..s paymode=$p(^CT("CTPM",paymode),"^",2)
 	.s prtstatus=$p(tmp,"^",8)
 	.i prtstatus'=2 s sum=sum+payamt
	set OutputObj.ResultCode="0"
	set OutputObj.ResultDesc="成功"
	set OutputObj.DepSum=sum
	set OutputObj.FeeSum=FeeSum
	set OutputObj.InsuFeeSum=InsuFee
	set OutputObj.Balence=(sum-FeeSum+InsuFee)
 	
 	
 	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
FindPatFeeDepInsu
	set OutputObj=##class(web.DHCQY.Model.DHCDepositDetResponse).%New() //输出
	set OutputObj.ResultCode="-2"
	set OutputObj.ResultDesc=$ze
	set tStatus=OutputObj.XMLExportToString(.xml)
	q xml
}

/// /病案示踪出院病人信息
/// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","InpatNumforJCSZ","2017-12-19","2017-12-19","NULL")
ClassMethod InpatNumforJCSZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InpatNumforJCSZExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod InpatNumforJCSZExecute(ByRef qHandle As %Binary, SDate, EDate, ctcareprov) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;n (SDate,EDate)
	s jzksID="",jzks="",jzbqID="",jzbq="",jsys="",jsysID="",patmasrow="",cs="",DischgDate="",date1="",date2="",iDate=""
	k ^TMPwangSZ("JZks")
	;Set repid=$I(^CacheTemp)

	s admrowid=""
	if SDate["-" d
	.s SDate=$zdh(SDate,3)
	e  d
	.s SDate=+$h-1
	if EDate["-" d
	.s EDate=$zdh(EDate,3)
	e  d
	.s EDate=+$h-1
 
	;s:SDate["-" SDate=$zdh(SDate,3)
	;s:EDate["-" EDate=$zdh(EDate,3)
	F iDate=SDate:1:EDate D
	.;w !,iDate
	.f  s admrowid=$o(^PAADMi("DischDate",iDate,admrowid))  q:admrowid=""  d 
	..;w !, admrowid
	..s brtype=$P(^PAADM(admrowid),"^",2)
	..q:brtype'="I"    

	..;q:((DischgDate<SDate)||(DischgDate>EDate))

	..s jzksID=$P(^PAADM(admrowid),"^",4)       ;就诊科室
	..s jzks=$p(^CTLOC(jzksID),"^",1)
	..Set ^TMPwangSZ("JZks",$j,jzks)=$g(^TMPwangSZ("JZks",$j,jzks))_"^"_admrowid
	 ;zw ^TMPwang
	s paadm="",ksid="",int="",adm=""
	F  S ksid=$O(^TMPwangSZ("JZks",$j,ksid))  Quit:ksid=""  Do
    .;w !,"科室名称节点"_ksid
    .q:(ksid'=ctcareprov)&&(ctcareprov'="NULL")&&(ctcareprov'="")
    .s Len=$l(^TMPwangSZ("JZks",$j,ksid),"^")
    .;w !,Len_"长度"
    .f int=1:1:Len d
    ..S adm=$p(^TMPwangSZ("JZks",$j,ksid),"^",int)
    ..;w !,adm_"#"_"adm"
    ..q:adm=""
    ..s Zyno=##class(web.DHCWMRService).IGetMrNoByEpisodeID(adm)   
    ..q:((Zyno["A")||(Zyno["B")||(Zyno["C")||(Zyno["D")||(Zyno["E"))
    ..s patmasrow=$p(^PAADM(adm),"^",1)
	..s patname=$p(^PAPER((patmasrow),"ALL"),"^",1)
	..s Sex=$p(^PAPER((patmasrow),"ALL"),"^",7)
	..s Dob=$p($g(^PAPER(patmasrow,"ALL")),"^",6)
	..s Birthday=$zd(Dob,3)
	..s IDNO=$p($g(^PAPER(patmasrow,"ALL")),"^",9)
	..s jzdate=$P(^PAADM(adm),"^",6)     ;就诊日期
	..s DischgDate=$P(^PAADM(adm),"^",17)   ;出院日期
	..s Doc="",DocName=""
	..s Doc=$p(^PAADM(adm),"^",9)
	..s:Doc'="" DocName=$p(^CTPCP(Doc,1),"^",2)
	..s Bed=$p($g(^PAADM(adm)),"^",73)
	..s BedSub=$p(Bed,"||",2)
	..s BedNo=""
	..s:BedSub'="" BedNo=$p($g(^PAWARD(+Bed,"BED",BedSub)),"^",1)
	..s curWardId=$p($g(^PAADM(adm)),"^",70)
	..s wardDesc=$p($g(^PAWARD(+curWardId)),"^",1)
	..q:DischgDate=""
	..s date1=$zd(jzdate,3)
	..;w !,jzdate_"  "_date1
	..s date2=$zd(DischgDate,3)
	..s cs=$p($g(^PAADM(adm)),"^",29)
	..;s PBFee=##class(web.RoutineworkC).GetPBfeeByAdm(adm)
    ..d BuildTarCatepatnumSZ
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildTarCatepatnumSZ    
	set Data=$lb(Zyno,cs,Zyno,patname,Sex,Birthday,IDNO,date2,date1,ksid,ksid,DocName,DocName,BedNo,wardDesc)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InpatNumforJCSZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InpatNumforJCSZExecute ]
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

Query InpatNumforJCSZ(SDate, EDate, ctcareprov) As %Query(ROWSPEC = "FBIHID,FBINCU,FMRDID,FNAME,FSEX,FBDATE,FIDCD,FODATE,FIDATE,FODEPT,FIDEPT,FZRYS,FZYYS,FBED,FWDEPT") [ SqlProc ]
{
}

// d ##CLASS(%ResultSet).RunQuery("web.RoutineworkC","YDJSD","3421711" )

/// /异地结算单打印数据提取
ClassMethod YDJSDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = YDJSDExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod YDJSDExecute(ByRef qHandle As %Binary, PatBill) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s InsuDivID=""
	
	f  s InsuDivID=$O(^DHCINDIV("0","DHCPB",PatBill,InsuDivID))  q:InsuDivID=""  D
	.s InPayFlag=$p(^DHCINDIV(InsuDivID),"^",5)
	.q:InPayFlag'="I"
	.s Amt=$p(^DHCINDIV(InsuDivID),"^",7)
	.s Adm=$p(^DHCINDIV(InsuDivID),"^",1)
	.s AdmInfoID=$p(^DHCINDIV(InsuDivID),"^",2)
	.s CardNo=$p(^DHCINDIV(InsuDivID),"^",12)
	.s papmi=$p(^PAADM(Adm),"^",1)
	.s PatObj=##class(web.DHCENS.Method.PatInfo).PatInfo(papmi)
	.s AdmObj=##class(web.DHCENS.Method.AdmInfo).AdmInfo(Adm)
	.s Insuid=$P(^DHCINADM(AdmInfoID),"^",2)
	.s Name=PatObj.PatientName
	.s Sex=$p(^PAPER(papmi,"ALL"),"^",7)
	.s:Sex="1" Sex="男"
	.s:Sex="2" Sex="女"
	.s Age=PatObj.Age
	.s AdmDate=AdmObj.AdmDate
	.s OutDate=AdmObj.DisDateMR
	.s Days=AdmObj.ResidentDays
	.s DiagICD=$P(^DHCINADM(AdmInfoID),"^",26)
	.s DiagDesc=$P(^DHCINADM(AdmInfoID),"^",27)
	.s MainDiag=DiagICD_" "_DiagDesc
	.s zyno=##class(web.DHCWMRService).IGetMrNoByEpisodeID(Adm)
	.s OutLoc=AdmObj.CurrentDetpCode 
	.s Grzf=$p(^DHCINDIV(InsuDivID),"^",15)
	.s PatType=$P(^DHCINADM(AdmInfoID),"^",4)
	.s BRPat=##class(web.DHCINSUPort).mwthfm(AdmInfoID)
	.s QFBZ=$p(^DHCINDIV(InsuDivID),"^",44)
	.s TCNFY=$p(^DHCINDIV(InsuDivID),"^",52)
	.s FDzf=$p(^DHCINDIV(InsuDivID),"^",45)
	.s TCZF=$p(^DHCINDIV(InsuDivID),"^",31)
	.s DBZF=$p(^DHCINDIV(InsuDivID),"^",32)
	.s GWY=$p(^DHCINDIV(InsuDivID),"^",33)
	.s ZHZF=$p(^DHCINDIV(InsuDivID),"^",28)
    .d OutPutYDJS
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutYDJS    
	set Data=$lb(ind,Name,Sex,Age,AdmDate,OutDate,Days,Amt,Grzf,MainDiag,OutLoc,zyno,BRPat,CardNo,Insuid,QFBZ,TCNFY,FDzf,TCZF,DBZF,GWY,ZHZF)   //出参值
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod YDJSDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = YDJSDExecute ]
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

Query YDJSD(PatBill) As %Query(ROWSPEC = "ind,Name,Sex,Age,AdmDate,OutDate,Days,Amt,Grzf,MainDiag,OutLoc,zyno,BRPat,CardNo,Insuid,QFBZ,TCNFY,FDzf,TCZF,DBZF,GWY,ZHZ") [ SqlProc ]
{
}

// 当时在院病人费用

/// Creator：     yx
/// CreatDate：   2015-7-15
/// Description:  通过在院病人数据取出出院未结算病人的详细信息
/// Table：       DHCWL_Account.Period、DHCWL_Account.DayDetail
/// Input：       
///               
/// Return：      
/// d ##class(%ResultSet).RunQuery("web.RoutineworkC","GetNoPaidDisPat","2014-03-01")
Query GetNoPaidDisPat(Qday As %String) As %Query(ROWSPEC = "adm:%String,PatNo:%String,PatMedNo:%String,PatName:%String,PatAge:%String,PatSex:%String,PatReason:%String,admdate:%String,admdisdate:%String,Fee:%Float,yjj:%Float,Tel,Ward,Add,IDNO") [ SqlProc ]
{
}

ClassMethod GetNoPaidDisPatExecute(ByRef qHandle As %Binary, Qday As %String) As %Status
{
 k ^TEMPDHCWL($j)
 n (qHandle,Qday)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s sumpre=0
 s Flag=0
 s prtRowid=""
 q:Qday="" $$$OK
 s day=$zdh(Qday,3)
 s AccPeriodID=0 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",day,AccPeriodID))  q:AccPeriodID=""  d
 .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",AccPeriodID," C",accDataDr)) q:accDataDr=""  d
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) ;q:adm'=1446799
 ..s disdate=$p(^PAADM(adm),"^",17)
 ..//w !,"disdate"_$zd(disdate,3)_"adm"_adm
 ..s Flag=0
 ..s:(disdate="")!(disdate>day) Flag="1"  ;出院日期为空 并且出院日期大于查询日期
 ..//q:disdate>=day
 ..;s:disdate="" disdate=(+day+11)
 ..;q:(disdate<day)
 ..q:Flag'="1"
 ..s Accfee=$fn($li($g(^DHCWL.Account.DayDetailD(accDataDr)),5),"",2)
 ..s ^TEMPDHCWL($j,adm)=$g(^TEMPDHCWL($j,adm))+Accfee
 s adm="" f  s adm=$o(^TEMPDHCWL($j,adm)) q:adm=""  d
 .s papmi=$p(^PAADM(adm),"^",1)
 .s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
 .s PatMedNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(adm)  ;$$GetPapmiMedtare^DHCWLCommon(papmi)
 .s PatName=$$GetPapmiName^DHCWLCommon(papmi)
 .s PatAge=$$GetAge^DHCWLCommon(papmi)
 .s PatSex=$$GetSex^DHCWLCommon(papmi)
 .s PatReason=$$GetReason^DHCWLCommon(adm)
 .s curWardId=$p($g(^PAADM(adm)),"^",70)  
 .s pacwarddesc=$p($p(^PAWARD(curWardId),"^",2),"-",2)
 .;s PatName=$p(^PAPER(papmidr,"ALL"),"^",1)
 .s tel=$p(^PAPER((papmi),"PER",1),"^",11)
 .s admdate=$zd($p(^PAADM(adm),"^",6),3)
 .s admdisdate=$zd($p(^PAADM(adm),"^",17),3)
 .s Add=$$GetDetailAddress^DHCWLCommon(papmi)
 .s IDNO=$p(^PAPER((papmi),"ALL"),"^",9)
 .s Fee=$g(^TEMPDHCWL($j,adm))
 .q:Fee=0
 .s yjj=0
 .f  s prtRowid=$o(^DHCSFPRINTDETAIL(0,"adm",adm,prtRowid))  q:prtRowid=""  d
 ..s sumpre=$p(^DHCSFPRINTDETAIL(prtRowid),"^",6)
 ..s yjj=sumpre+yjj
 
 .s ^CacheTemp(repid,ind)=$lb(adm,PatNo,PatMedNo,PatName,PatAge,PatSex,PatReason,admdate,admdisdate,Fee,yjj,tel,pacwarddesc,Add,IDNO)
 .s ind=ind+1
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
}

ClassMethod GetNoPaidDisPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNoPaidDisPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNoPaidDisPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNoPaidDisPatExecute ]
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

// 1396323

// w ##class(web.RoutineworkC).GetPatPasswayinfo("1343907")

// 逻辑是 居民医保病人如果入临床路径 但是没有走单病种 需要提示一下 

// 所以要判断 走了临床路径 且没走单病种的 

// w ##class(DHCCPW.IO.ForIInfoSrv).GetCPWInfoByAdm("1370991")

ClassMethod GetPatPasswayinfo(Input) As %String
{
	
	s arr = ##class(%ArrayOfDataTypes).%New()
	s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(Input,"HDSD00.11")
	;s arr=##Class(DHC.EPR.FPInterface.ExportTable).GetDataByGlossaryCategory(Input,"HDSD00.11")
	// 取病案首页病人基本信息
	s rtn="",patdiag="",outway=""
	s Admtype=##class(web.DHCINSUPort).GetPatylTypewc(Input)
	set s1=arr.GetAt("HDSD00.11.1243")
	s Pasway=##class(DHCCPW.IO.ForIInfoSrv).GetCPWInfoByAdm(Input)  //临床路径
	s:Pasway'="" patdiag=$p(Pasway,"^",3),outway=$p(Pasway,"^",7)
	
	s patType=..GetAdmType(Input) //取病人是否是单病种病人
	if patType'="35" {
	if (s1="")&&(patdiag'="")&&(Admtype["居民")&&(outway="")
	{
		b ;2
		s rtn=""
		if patdiag="宫颈癌" d
		.s rtn=patdiag
		if patdiag="卵巢良性肿瘤手术治疗" d
		.s rtn=patdiag		
		if patdiag="新生儿感染性肺炎" d
		.s rtn=patdiag
		if patdiag="新生高胆红素血症" d
		.s rtn=patdiag	
		if patdiag="支原体肺炎" d
		.s rtn=patdiag
		if patdiag="子宫平滑肌瘤" d
		.s rtn=patdiag		
		if patdiag="子宫腺肌病" d
		.s rtn=patdiag
	
		
		}
	}
	else
	{
		
		s rtn=""
		
		}
	 q rtn
	//##class(DHCCPW.IO.ForIInfoSrv).GetCPWInfoByAdm("")  //临床路径
	
	/*var rtn=tkMakeServerCall("web.RoutineworkC","GetPatPasswayinfo",Adm)
   if (rtn!=""){
	   
	   alert("此病人已入临床路径"+rtn+",但未走单病种,如需走单病种流程请医生填写单病种协议书,并在申请界面申请。")
	   }*/
}

ClassMethod GetpatYBtype(Adm) As %String
{
}

// w ##class(web.RoutineworkC).xtytest("1613930")

ClassMethod xtytest(AdmID As %String) As %GlobalCharacterStream
{
	q:AdmID="" "-1"
	s Input=##class(web.DHCWMRService).IGetMrNoByEpisodeID(AdmID)
	;b ;Input
	s AdmDate=$p(^PAADM(AdmID),"^",6)
    set obj=##class(xtyinterFin.GlucoseDataServiceSoap).%New()
    set Param=obj.QueryGlucoseData(Input)
    ;w !,Param
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("ROWS","web.DHCQY.Model.xtyresponserows")
    s Name="",rtn=""
	While reader.Next(.request,.sc)
	{	
	
		s:Name="" Name=request.BRXM
		s XTDate=$tr($p(request.XTSJ," ",1),"/","-")
		s XTdate=$zdh(XTDate,3)
		if (XTdate>AdmDate) {
			
		s xtbz=request.XTBZ
		s xtsz=request.XTSZ
		s:(xtbz="拒测")||(xtbz="外出") xtsz=xtbz
		s string1=request.XTBH_"^"_xtsz_"^"_request.XTSJ_"^"_request.CZHS_"^"_request.SJD0
		
			
		if rtn="" 
		{
			s rtn=string1
			
			}
		else
		{
			
		s rtn=rtn_"!"_string1
		
			} 
		}
}
   q rtn
}

// w ##class(web.RoutineworkC).xtytestnew("3427071","1820","DHCNURBG_XTJC","住院护士","")

ClassMethod xtytestnew(AdmID, Userid, RecTyp, Group, WardID) As %String
{
		s $zt="xtytestnew"
	 	s Dataid=""
	 	s UpdateCount=0
	 	
		s nur=$O(^SSU("SSUSR",0,"SSUSR_Name",Userid,""))
	    //ts
	    s InserCount=0
	    f  s Dataid=$O(^XZZXGetGluCoseDataAdmi("Adm",AdmID,Dataid))    q:Dataid=""  d
	    .s InsertFlag=$P(^XZZXGetGluCoseDataD(Dataid),"^",13) ////护理记录单取第17个字段
	    .q:InsertFlag="Y"
	    .s Updateflag=..UpdatedataFlag(Dataid,RecTyp)
	    .s Date=$zd($P(^XZZXGetGluCoseDataD(Dataid),"^",4),3)
	    .s Time=$zt($P(^XZZXGetGluCoseDataD(Dataid),"^",5),1)
	    .s Inserdata=$P(^XZZXGetGluCoseDataD(Dataid),"^",10)
	    .s Statue=$P(^XZZXGetGluCoseDataD(Dataid),"^",3)
	    .s XtUserCode=""
	    .s XtUserCode=$P(^XZZXGetGluCoseDataD(Dataid),"^",9)
	    .if XtUserCode'="" d
	    ..if ($d(^SSU("SSUSR",0,"SSUSR_Initials",XtUserCode))) d
	    ...s xtUserid=""
	    ...s xtUserid=$O(^SSU("SSUSR",0,"SSUSR_Initials",XtUserCode,xtUserid))
	    ...s Userid=xtUserid
	    .;w !,Statue_"  "_Inserdata
	    .s parr="CareDate|"_Date_"^CareTime|"_Time_"^Item1|"_Inserdata_"^Item2|"_Statue_"^DiagnosDr|^CaseMeasureID|"
	    .s Mdate=$zdh(Date,3)
	    .s Mtime=$zth(Time,3)
	    .s UpdateFlag=..UpdateAlreadyData(AdmID, Userid, RecTyp, Mdate, Mtime, Inserdata)
	    .;w !,UpdateFlag_"^"_Inserdata_"^"_$zd(Mdate,3)_"^"_$zt(Mtime,1)
	    .;s ^tmprecord(parr)=UpdateFlag
	    .s:UpdateFlag'=0 UpdateCount=UpdateCount+1
	    .s:UpdateFlag=0 InserCount=InserCount+1
	    .if (UpdateFlag=0) d //不等于100 则新增
	 	..;s ^tmpsave=$lb(AdmID,parr,Userid, RecTyp, Group)
	 	..b ;11
	    ..s rtn=##class(Nur.DHCNurseRecSub).Save(AdmID,parr,Userid, RecTyp, Group)
	    ..b ;1
	    
	    q 0
xtytestnew
	q 0
}

ClassMethod UpdateAlreadyData(AdmID, Userid, RecTyp, xtdate, xttime, xtsz) As %String
{
	s par=##class(Nur.DHCNurseRecParent).getparentid(AdmID,Userid)
	s rw=""
	s AlreadyData=""
	s Alcoount=0
	s response=0
	f  s rw=$O(^Nur.DHCNurseRecSubD(par,rw))  q:rw=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(par_"||"_rw)
	.s Type=a.RecTyp
	.q:Type'=RecTyp
	.
	.s CreateDate=a.CareDate
	.q:CreateDate'=xtdate
	.s CreateTime=a.CareTime
	.s CancleDate=a.RecCancelDate
	.q:CancleDate'=""
	.s GetTimesle=..GetAlwaysInt(CreateTime,xttime)
	.q:GetTimesle>1700
	.;w !,par_"||"_rw_"^"_a.Item8_"^"_a.Item11_"^"_a.Item12
	.s AlreadyData=a.Item1
	.if (GetTimesle<1700)&(AlreadyData'="")  d
	..s response=101
	..s Alcoount=Alcoount+1
	.if (GetTimesle<1700)&(AlreadyData="")&(+Alcoount=0)  d  //附近时间点已经记录过 则不再过问
	..s a.Item1=xtsz
	..d a.%Save()
	..s response=100
	..s Alcoount=Alcoount+1
	
	q response
}

ClassMethod UpdatedataFlag(Dataid, Type) As %String
{
	
	&SQL(update SQLUser.savextdata set xtdata_XTJLD="Y" where xtdata_Rowid=:Dataid)
	q SQLCODE
}

ClassMethod GetAlwaysInt(a, b) As %String
{
	s rtn=a-b
	if rtn<0 s rtn=-1*rtn
	q rtn
}

/// w ##class(web.Routinework).GetDepositStatue("<Request><SerialNum>fdsfds1324</SerialNum></Request>")
ClassMethod GetDepositStatue(Input As %String) As %String
{
	
	set $zt="GetDepositStatue"   //fdsfds1324 <Request><SerialNum>fdsfds1324</SerialNum></Request>
    Set streamObj=##class(%GlobalCharacterStream).%New()
	Set inputObj=##class(web.DHCQY.Model.GetDepositStatueRq).%New()
	set OutputObj=##class(web.DHCQY.Model.GetDepositStaResponse).%New() //输出
	
    Do inputObj.XMLNodeDeserialize(.inputObj,"Request",Input)
    set OutputObj.ResultCode="-1"
	set OutputObj.ResultDesc="无预交明细"
    Set SerialNum=inputObj.SerialNum //流水号
    s Flag=""
    s Flag=$g(^BankFlow(SerialNum))
    b ;123
    if Flag'="" {
	    
	 set OutputObj.ResultCode="0"
	set OutputObj.ResultDesc="成功"
	set OutputObj.HISTradeNum=Flag
	set OutputObj.prtrcptno=$p(^DHCSFPRINTDETAIL(Flag),"^",1)
	
	    }
	    
	    else
	    {
	set OutputObj.ResultCode="-1"
	set OutputObj.ResultDesc="无此流水号对应充值记录"
	set OutputObj.HISTradeNum=""
	set OutputObj.prtrcptno=""
		    
		    
		    }
    
	
 	
 	
 	Do OutputObj.XMLExportToString(.OutputXML,"Response") 
 	Do OutputObj.%Close()
	Quit OutputXML
	;
GetDepositStatue
	set OutputObj=##class(web.DHCQY.Model.GetDepositStaResponse).%New() //输出
	set OutputObj.ResultCode="-2"
	set OutputObj.ResultDesc=$ze
	set tStatus=OutputObj.XMLExportToString(.xml)
	q xml
}

Query ApplyQuery(StartDate As %String, EndDate As %String, LocID As %String) As %Query(ROWSPEC = "TAntiSRowID:%String,TPatientNo:%String,TMedicareNo:%String,TPatName:%String,TPatAge:%String,TPatSex:%String,TApplyLoc:%String,TApplyWard:%String,TApplyBed:%String,TPatDiag:%String,TApplyReason:%String,TApplyARCIM:%String,TApplyUser:%String,TApplyStatus:%String")
{
}

/// 申请记录查询
/// d ##class(%ResultSet).RunQuery("web.DHCDocAntiSvr","ApplyQuery","64527","64549","")
ClassMethod ApplyQueryExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Userid=%session.Data("LOGON.USERID")
	s LocID=%session.Data("LOGON.CTLOCID")
	i StartDate="" s StartDate=+$h
	i EndDate="" s EndDate=+$h
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	i StartDate["/" s StartDate=$zdh(StartDate,4)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	i EndDate["/" s EndDate=$zdh(EndDate,4)
	s ^lj("ApplyQueryCCC")=StartDate_","_EndDate_","_Userid_","_LocID
	s FindDate=StartDate-1 f  s FindDate=$o(^ANTIS(0,"Date",FindDate)) q:(FindDate="")||(FindDate>EndDate)  d
	.s ANTISRowID=0 f  s ANTISRowID=$o(^ANTIS(0,"Date",FindDate,ANTISRowID)) q:ANTISRowID=""  d
	..s PatientID=$p($g(^ANTIS(ANTISRowID)),"^",1)
	..q:PatientID=""
	..s TPatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s TMedicareNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
	..s TPatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s PatDob=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	..s TPatAge=##class(web.DHCDTHealthCommon).GetAgeDesc(PatDob,+$h)
	..s TPatSex=""
	..s PatSexDr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	..i PatSexDr'="" s TPatSex=$p($g(^CT("SEX",PatSexDr)),"^",2)
	..s EpisodeID=$p($g(^ANTIS(ANTISRowID)),"^",2)
	..q:EpisodeID=""
	..s TPatDiag=..GetPatDiag(EpisodeID)
	..s TApplyLoc="",TApplyWard="",TApplyBed="",TApplyARCIM="",TApplyUser="",TApplyStatus=""
	..s TApplyLocDr=$p($g(^ANTIS(ANTISRowID)),"^",3)
	..i TApplyLocDr'="" s TApplyLoc=$p($g(^CTLOC(TApplyLocDr)),"^",2)
	..i TApplyLoc["-" s TApplyLoc=$p(TApplyLoc,"-",2)
	..s TApplyBedDr=$p($g(^ANTIS(ANTISRowID)),"^",4)
	..i TApplyBedDr'="" d
	...s TApplyWard=$p($g(^PAWARD(+TApplyBedDr)),"^",2)
	...s TApplyBed=$p($g(^PAWARD(+TApplyBedDr,"BED",$p(TApplyBedDr,"||",2))),"^",1)
	..s TApplyARCIMDr=$p($g(^ANTIS(ANTISRowID)),"^",5)
	..i TApplyARCIMDr'="" s TApplyARCIM=$p($g(^ARCIM(+TApplyARCIMDr,$p(TApplyARCIMDr,"||",2),1)),"^",2)
	..s TApplyReason=$p($g(^ANTIS(ANTISRowID)),"^",9)
	..s TApplyUserDr=$p($g(^ANTIS(ANTISRowID)),"^",6)
	..q:(TApplyUserDr'=Userid)
	..i TApplyUserDr'="" s TApplyUser=$p($g(^SSU("SSUSR",TApplyUserDr)),"^",2)
	..s TApplyStatusDr=$p($g(^ANTIS(ANTISRowID)),"^",10)
	..i TApplyStatusDr="" s TApplyStatus="待审核"
	..i TApplyStatusDr="C" s TApplyStatus="通过"
	..i TApplyStatusDr="R" s TApplyStatus="拒绝"
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ANTISRowID,TPatientNo,TMedicareNo,TPatName,TPatAge,TPatSex,TApplyLoc,TApplyWard,TApplyBed,TPatDiag,TApplyReason,TApplyARCIM,TApplyUser,TApplyStatus)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ApplyQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ApplyQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ApplyQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ApplyQueryExecute ]
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

ClassMethod GetPatDiag(AdmRowID) As %String
{
	s DiagStr=##class(web.DHCENS.Method.AdmInfo).GetDiagnoses(AdmRowID)
	s AdmDiagCounts=$Length(DiagStr,"!")
	s AdmDiagnose="",DiagStr=""
	s INDiag="",OutDiag="",OPDiag=""
	f j=1:1:AdmDiagCounts  d
	.s diagnoseStr=$p(DiagStr,"!",j)
	.q:diagnoseStr=""
	.s Diagtype=$p(diagnoseStr,"^",2)
	.s diagnose=$p(diagnoseStr,"^",5)
	.if DiagStr="" d
	..s DiagStr=diagnose
	.else  d
	..s DiagStr=DiagStr_","_diagnose
	q DiagStr
}

ClassMethod GetRegFee(RBASRowId, AdmReason, PatientID) As %String
{
	s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(RBASRowId,AdmReason,PatientID)
	s RegFeeDr=0,CheckFee=0,ReCheckFee=0,OtherFee=0,HoliFeeDr=0,AppFeeDr=0,MRFee=0,CardFee=0
	s RegFee=+$p(DocResValue,"^",12)
	s CheckFee=+$p(DocResValue,"^",14)
	s HoliFee=+$p(DocResValue,"^",16)
	s AppFee=+$p(DocResValue,"^",18)
	;s RegFeeDr=+$p(DocResValue,"^",13)
	s ReCheckFee=+$p(DocResValue,"^",15)
	;s HoliFeeDr=+$p(DocResValue,"^",17)
	;s AppFeeDr=+$p(DocResValue,"^",19)
	s OtherFee=+$p(DocResValue,"^",20)
	s TotalAmount=+(RegFee+CheckFee+HoliFee+AppFee+ReCheckFee+OtherFee)
	q TotalAmount
}

ClassMethod TransFreq(HisFreq) As %String
{
	s rtn="99"
	
	if HisFreq["qd" d
	.s rtn="01"
	if HisFreq["bid" d
	.s rtn="02"
	if HisFreq["tid" d
	.s rtn="03"
	if HisFreq["qid" d
	.s rtn="04"
	if HisFreq["qn" d
	.s rtn="05"
	if HisFreq["st" d
	.s rtn="14"
	if HisFreq["q1h" d
	.s rtn="15"
	if HisFreq["q2h" d
	.s rtn="16"
	if HisFreq["q3h" d
	.s rtn="17"
	if HisFreq["prn" d
	.s rtn="09"
	if HisFreq["q1d" d
	.s rtn="24"
	if HisFreq["qw" d
	.s rtn="06"
	q rtn
}

ClassMethod SavePatThreeFree(Adm, ThreeFeeFlag, Userid) As %String
{
	
	q:Adm="" "0"
	s Date=+$h
	s Time=$P($h,",",2)
	s ^tmpThreeFreeFlag(Date,Userid)=Adm_"^"_ThreeFeeFlag_"^"_Time
	
	q 0
}

// w ##class(web.RoutineworkC).GetThreeFreeNum("64617","64617","2447")

ClassMethod GetThreeFreeNum(SDate, EDate, User) As %String
{
	s tmpdate="",Userid="",count=0
	f idate=SDate:1:EDate  d
	.f  s Userid=$o(^tmpThreeFreeFlag(idate,Userid)) q:Userid=""  d
	..q:Userid'=User
	..s count=count+1
	
	q count
}

ClassMethod GetWard(CurrentWardCode) As %String
{
	s ward=""
	s ward=$O(^PAWARD(0,"WARD_Code",CurrentWardCode,"")) 
	q ward
}

ClassMethod getcardcode(CardNo) As %String
{
	
	q ##class(web.UDHCAccEnrypt).Decrypt(CardNo)
}

ClassMethod GetpatientInfo(AdmID) As %String
{
	
	s patname="",Address="",Adminfoid="",YBH=""
	s Patid=$p(^PAADM(AdmID),"^",1)
	s AdmDate=$tr($zd($p(^PAADM(AdmID),"^",6),3),"-","")
	s MZH=$p(^PAPER(Patid,"PAT",1),"^",1)
	if ($d(^DHCINADM("0","ADM",AdmID))) {
		
	s Adminfoid=$O(^DHCINADM("0","ADM",AdmID,Adminfoid))
	s YBH=$p(^DHCINADM(Adminfoid),"^",2)
		}
	
	s patname=$p(^PAPER(Patid,"ALL"),"^",1)
	s Address=$g(^PAPER(Patid,"PER","ADD",1))
	s Tel=$p(^PAPER(Patid,"PER",1),"^",11)
	s IDNO=$p(^PAPER(Patid,"ALL"),"^",9)
	q patname_"^"_Address_"^"_AdmDate_"^"_Tel_"^"_IDNO_"^"_MZH_"^"_YBH
}

// w ##class(web.RoutineworkC).GetDiagDescByMRid("2")

ClassMethod GetDiagDescByMRid(MRID) As %String
{
	s ^GetDiagDescByMRid=MRID
	q:MRID="" ""
	s rtn=""
	s rtn=$P(^MRC("ID",MRID),"^",2)
	q rtn
}

// w ##class(web.RoutineworkC).CheckStringMethod("2018-03-30")

ClassMethod CheckStringMethod(InDate) As %String
{
	s Date=$zd(+$h,3)
	if (InDate=Date) 
	{
		q 0
		}
	else
	{
		q -1
		}
}

// w ##class(web.RoutineworkC).GetAliWeiPaySum("843162^843163","35")

ClassMethod GetAliWeiPaySum(MyInvStr, myPayMode) As %String
{
	
	if $d(^xzfytmpgetpaymode(+$h-7)) d
	.k ^xzfytmpgetpaymode(+$h-7)
	set retAmt=0
	set Len=$L(MyInvStr,"^")
	set Invprtid=""
	set sub=0
	for i=1:1:Len  d
	.set Invprtid=$P(MyInvStr,"^",i)
	.q:Invprtid=""
	.set sub=0  for  set sub=$O(^DHCINVPRT(Invprtid,"P",sub))  q:sub=""  d
	..q:(+sub)=0
	..set payMode=$p(^DHCINVPRT(Invprtid,"P",sub),"^",1)
	..set Amt=$p(^DHCINVPRT(Invprtid,"P",sub),"^",3)
	..q:(payMode'="36")&((payMode'="37"))
	..set retAmt=retAmt+Amt
	s ^xzfytmpgetpaymode(+$h,"Amt",MyInvStr)=retAmt
	q retAmt
}

ClassMethod GetWMPaySum(MyInvStr, myPayMode) As %String
{
	set retAmt=0
	set Len=$L(MyInvStr,"^")
	set Invprtid=""
	set sub=0
	for i=1:1:Len  d
	.set Invprtid=$P(MyInvStr,"^",i)
	.q:Invprtid=""
	.set sub=0  for  set sub=$O(^DHCINVPRT(Invprtid,"P",sub))  q:sub=""  d
	..q:(+sub)=0
	..set payMode=$p(^DHCINVPRT(Invprtid,"P",sub),"^",1)
	..set Amt=$p(^DHCINVPRT(Invprtid,"P",sub),"^",3)
	..q:(payMode'="35")
	..set retAmt=retAmt+Amt
	
	q retAmt
}

// w ##class(web.RoutineworkC).GetAliWeiPaySum("843162^843163","35")

ClassMethod GetAliWeiPaySumNew(MyInvStr, myPayMode) As %String
{
	set retAmt=0
	set Len=$L(MyInvStr,"^")
	set Invprtid=""
	set sub=0
	for i=1:1:Len  d
	.set Invprtid=$P(MyInvStr,"^",i)
	.q:Invprtid=""
	.set sub=0  for  set sub=$O(^DHCINVPRT(Invprtid,"P",sub))  q:sub=""  d
	..q:(+sub)=0
	..set payMode=$p(^DHCINVPRT(Invprtid,"P",sub),"^",1)
	..set Amt=$p(^DHCINVPRT(Invprtid,"P",sub),"^",3)
	..q:(payMode'=myPayMode)
	..set retAmt=retAmt+Amt
	
	q retAmt
}

// w ##class(web.RoutineworkC).GetAliWeiPaySum("843162")

ClassMethod GetAliWeiPaySumAuto(MyInvStr) As %String
{
	set retAmt=0
	set Len=$L(MyInvStr,"^")
	set Invprtid=""
	set sub=0
	for i=1:1:Len  d
	.set Invprtid=$P(MyInvStr,"^",i)
	.q:Invprtid=""
	.set sub=0  for  set sub=$O(^DHCINVPRT(Invprtid,"P",sub))  q:sub=""  d
	..q:(+sub)=0
	..set payMode=$p(^DHCINVPRT(Invprtid,"P",sub),"^",1)
	..set Amt=$p(^DHCINVPRT(Invprtid,"P",sub),"^",3)
	..q:(payMode'="36")&(payMode'="37")
	..set retAmt=retAmt+Amt
	
	q retAmt
}

ClassMethod CheckZFCS(INVPrtB, INVPrtN) As %String
{
	set count1=$p(^DHCINVPRT(INVPrtB),"^",1)
	set count2=$p(^DHCINVPRT(INVPrtN),"^",1)
	q (count1-count2)
}

ClassMethod GetInvAccount(INVPrt) As %String
{
	set count=$p(^DHCINVPRT(INVPrt),"^",1)
	q count
}

// w ##class(web.RoutineworkC).GetAliWeiPayMode("4956337")

ClassMethod GetAliWeiPayMode(Invprtid) As %String
{
	q:Invprtid=""
	s rtn=""
	set sub=0  for  set sub=$O(^DHCINVPRT(Invprtid,"P",sub))  q:sub=""  d
	.q:(+sub)=0
	.set payMode=$p(^DHCINVPRT(Invprtid,"P",sub),"^",1)
	.set Amt=$p(^DHCINVPRT(Invprtid,"P",sub),"^",3)
	.q:(payMode'="36")&(payMode'="37")
	.s rtn=payMode
	
	q rtn
}

// d ##class(web.RoutineworkC).FirstTest("2051567")

ClassMethod FirstTest(Input) As %String
{
	s arr = ##class(%ArrayOfDataTypes).%New()
	s arr=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(Input,"HDSD00.11")
	;w !, arr.GetAt("HDSD00.11.306")	
	w !, arr.GetAt("HDSD00.11.655")
}

}
