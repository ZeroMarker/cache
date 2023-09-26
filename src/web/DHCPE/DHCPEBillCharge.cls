Import SQLUser

Class web.DHCPE.DHCPEBillCharge Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 112;

ClassMethod PEBillCharge(InvNo, InvID, Adm, BillOrdItmID, OrdItmStr, PayModeStr, DepositStr, PayAmount, UserID, LocID, OrdSetStr, PlusOrdStr, Str, HospitalID)
{
 //体检结算主程序
  //OrdItmID	体检费医嘱rowid
  //OrdItmStr	体检医嘱Rowid字符串
  //PayModeStr	支付方式字符串
  //DepositStr	结算的预交金字符串
  //	
    
	n (InvNo,InvID,Adm,BillOrdItmID,OrdItmStr,PayModeStr,DepositStr,PayAmount,UserID,LocID,OrdSetStr, PlusOrdStr,Str,HospitalID)
	s rtn=..MakeBill(Adm,UserID,BillOrdItmID,OrdSetStr, PlusOrdStr,Str)
	s ^DHCPETemp("BillNo","a")=rtn
	q:$p(rtn,"^")'=0 rtn
	s BillNo=$p(rtn,"^",2)
	
	&SQL(Update Sqluser.DHC_PatientBill set PB_TotalAmount=:PayAmount,PB_PatientShare=:PayAmount,PB_AmountPaid=:PayAmount,PB_AmountToPay=:PayAmount where PB_RowID=:BillNo)
	
	s rtn=..BillCharge(BillNo, PayModeStr, DepositStr, PayAmount, UserID, LocID)
	q:+rtn=0 rtn_"^"_"结算账单失败"
	s Arrcp=rtn
	///一下判断如果是体检预缴金不操作发票记录
	/*s PayModeID=+$P(PayModeStr,"&",3)
	s PayCode=$P($G(^CT("CTPM",PayModeID)),"^",1)
	s AccID=$P(PayModeStr,"#",2) 					//add by zhouli	
	s NoPrintInv=$P(InvNo,"^",2)
	s InvNo=$P(InvNo,"^",1)
	s NeedInvFlag=##class(web.DHCPE.CashierEx).NeedPrintInv(PayModeStr)
	i (+NeedInvFlag=1)&&(NoPrintInv'="1") d
	.s rtn=..SaveReceipt(InvNo, UserID, BillNo, "N", InvID, "Y",AccID,HospitalID)
	e  d
	.s DHCPayMode=$P(NeedInvFlag,"^",2)
	.i DHCPayMode="TJYJJ" d
	..s InvNo="DHC"_$I(^DHCPEDataEx("YJJInvID"))
	.e  i DHCPayMode="TJGBK"  d
	..s InvNo="DHCGBK"_$I(^DHCPEDataEx("GBKInvID"))
	.e  i DHCPayMode="TJZKK"  d
	..s InvNo="DHCZKK"_$I(^DHCPEDataEx("ZKKInvID"))
	.e  i DHCPayMode="TJDJK"  d
	..s InvNo="DHCDJK"_$I(^DHCPEDataEx("DJKInvID"))
	.e  i DHCPayMode="TJSSP"  d
	..s InvNo="DHCSSP"_$I(^DHCPEDataEx("SSPInvID"))
	.e  i DHCPayMode="TJYHK"  d
	..s InvNo="DHCYHK"_$I(^DHCPEDataEx("YHKInvID"))
	.i NoPrintInv="1" d
	..s InvNo="DHCSSP"_$I(^DHCPEDataEx("SSPInvID"))*/
	s InvNo="DHCPEYJS"_UserID  //体检预结算发票
	s rtn=..SavePEReceipt(InvNo, UserID,BillNo,"N",InvID,"Y","",HospitalID,LocID)
	s rtn=rtn_"^"_BillNo

	q rtn
}

ClassMethod MakeBill(Adm, UserID, BillOrdItmID, OrdSetStr, PlusOrdStr, Str)
{
 //产生结算账单
	n (Adm,UserID,BillOrdItmID,OrdSetStr, PlusOrdStr,Str)
	s rtn="^"
	s ^DHCPETemp("BillOrdItmID","a")=BillOrdItmID_"###"_Str
	i BillOrdItmID'="" s rtn=..MakeBillYY(Adm, UserID, BillOrdItmID, Str)
	e  s rtn=..MakeBillNB(Adm, UserID, OrdSetStr, PlusOrdStr, Str)
	;s rtn=..MakeBillYY(Adm, UserID, BillOrdItmID, Str)
	 // Description: 提供给其他组调用的门诊重新账单接口
     // Input: bill: DHC_PatientBill.RowId(原账单Id), ordItemStr:OEOrdItem.RowId串,多个医嘱Id以"^"分隔
     // userId:SS_User.RowId, sFlag:收费/退费标识(=0收费，=1退费)
    // Return: rtn:(err^newBill: err=0成功,<>0失败; newBill:新账单Id)
	s rtn=##class(web.DHCBillInterface).IReBill($p(rtn,"^",2),BillOrdItmID,UserID,0)

	q rtn
}

ClassMethod MakeBillYY(Adm, UserID, BillOrdItmID, Str)
{
 //产生结算账单--体检费
 
	n (Adm,UserID,BillOrdItmID,Str)
	s Bill=""
	s MEDDATA=..getMEDDATA()
    S CurrentNS=$ZNSPACE
    //s err=##Class(web.UDHCJFBILL).BILL(Adm,UserID)
    //q:err'="" "1001^"
    //s OldBill=..GetBillNoByAdm(Adm)
    //q:OldBill="" "1002^"
    //s rtn=##Class(web.UDHCJFIntBill).RINBILLCOM(OldBill, "", BillOrdItmID, UserID, "", "", "", "", "")
	//q:rtn=0 "1003^"
	
	//s rtn=##Class(web.UDHCJFBILL).BILLH(Adm, UserID, "", BillOrdItmID, "", "", "", "Y", "")
	Set HospitalCode=$g(^DHCPESetting("DHCPE","HospitalCode"))
	If (HospitalCode="NBMZ")||(HospitalCode="SHHS") Do
	.s rtn=##Class(web.UDHCJFBILL).BILLH(Adm, UserID, "", BillOrdItmID, "", "", "", "Y", "")  //Modify 20080707
	else  if (HospitalCode="FX")||(HospitalCode="XM") Do
	.s rtn=##Class(web.UDHCJFBILL).BILL(Adm, UserID, BillOrdItmID, 1, "Y")   //Modify 2008070
	else  Do 
	.s rtn=##Class(web.UDHCJFBILL).BILL(Adm, UserID, BillOrdItmID, 1)
	b ;222__"DDD"
	s err=$p(rtn,"^",1)
	q:err'=0 "1004^"
	s Bill=$p(rtn,"^",2)
	q 0_"^"_Bill
}

ClassMethod MakeBillNB(Adm, UserID, OrdSetStr, PlusOrdStr, Str)
{
 //产生结算账单--体检项目明细
	n (Adm,UserID,OrdSetStr, PlusOrdStr,Str)
	s Bill=""
	s MEDDATA=..getMEDDATA()
    S CurrentNS=$ZNSPACE
    //s err=##Class(web.UDHCJFBILL).BILL(Adm,UserID)
    //q:err'="" "1001^"
    //s OldBill=..GetBillNoByAdm(Adm)
    //q:OldBill="" "1002^"
    //s rtn=##Class(web.UDHCJFIntBill).RINBILLCOM(OldBill, "", BillOrdItmID, UserID, "", "", "", "", "")
	s rtn=##Class(web.UDHCJFBILL).BILLH(Adm, UserID, "", "", "", OrdSetStr, PlusOrdStr, "Y", "")
	q:rtn=0 "1003^"
	s err=$p(rtn,"^",1)
	q:err'=0 "1004^"
	s Bill=$p(rtn,"^",2)
	q 0_"^"_Bill
}

ClassMethod BillCharge(BillNo, PayModeStr, DepositStr, PayAmount, UserID, LocID)
{
 //结算账单
	n (BillNo,PayModeStr,DepositStr,PayAmount,UserID,LocID)
	s MEDDATA=..getMEDDATA()
    S CurrentNS=$ZNSPACE
    s rtn=##Class(web.DHCPE.DHCPEPAY).paybill(BillNo, UserID, LocID, PayModeStr, DepositStr, 0, PayAmount)
	q rtn
}

ClassMethod SaveReceipt(InvNo, UserID, BillNo, Cat, InvID, InvFlag, AccID, HospitalID)
{
 //保存发票记录
	n (InvNo, UserID, BillNo, Cat, InvID, InvFlag,AccID,HospitalID)
	s MEDDATA=..getMEDDATA()
    S CurrentNS=$ZNSPACE

    s rtn=##Class(web.DHCPE.DHCPEPAY).savetoinvprt(InvNo, UserID,BillNo,Cat,InvID,InvFlag,"",AccID, HospitalID)
	q rtn
}

/// ///////////////////////////////////////////////////////////
ClassMethod CancelPEBillCharge(InvprtID, InvFlag, UserID, RefuntInfo, HospitalID)
{
 //取消体检结算主程序
	n (InvprtID, InvFlag, UserID,RefuntInfo,HospitalID)
	s ^zltmp("0403",2)=RefuntInfo
    s InvprtID=$g(InvprtID),InvFlag=$g(InvFlag),UserID=$g(UserID),HospitalID=$g(HospitalID)
    q:InvprtID="" "1005^发票为空"
    q:'$d(^DHCPEINVPRT(InvprtID)) "1006^发票不存在"
    s prtinvflag=$p(^DHCPEINVPRT(InvprtID),"^",8)
    q:prtinvflag'="N" "1007^非正常发票"
    q:UserID="" "1008^用户ID为空"
    i (InvFlag'="Y")&&(InvFlag'="N") s InvFlag="N"     
    s Adm=$p(^DHCPEINVPRT(InvprtID),"^",2),BillNo=$p(^DHCPEINVPRT(InvprtID),"^",3)
    q:BillNo="" "1009^账单为空"
    q:$p(^DHCPB(BillNo),"^",16)'="P" "1010^账单没有结算"
	q:$p(^DHCPB(BillNo),"^",17)'="" "1011^账单已经红冲"
    s rtn=..CancelBillCharge(Adm, BillNo, UserID,InvFlag,InvprtID,RefuntInfo,HospitalID)
    q:$p(rtn,"^",1)="null" "1012^没有可用发票"
    q:$p(rtn,"^",1)'="0" "1013^结算红冲失败"
    //s redbill=$p(rtn,"^",2),newbill=$p(rtn,"^",3)	
	q rtn
}

ClassMethod CancelBillCharge(Adm, BillNo, UserID, InvFlag, InvprtID, RefuntInfo, HospitalID)
{
 //红冲结算的账单
	n (Adm,BillNo,UserID,InvFlag,InvprtID,RefuntInfo,HospitalID)
	s ^zltmp("0403",3)=RefuntInfo
	s MEDDATA=..getMEDDATA()
    S CurrentNS=$ZNSPACE
    s rtn=##Class(web.DHCPE.DHCPEPAY).PBCancel(Adm, BillNo, UserID, InvFlag,InvprtID,RefuntInfo,HospitalID)
	q rtn
}

ClassMethod getMEDDATA()
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    q MEDDATA
}

ClassMethod GetBillNoByAdm(adm)
{
	n (adm)
	s adm=$g(adm)
	s billrowid=""
	q:adm="" billrowid
	s admbill=0 f  s admbill=$o(^DHCPB(0,"ADM",adm,admbill),-1) q:(admbill="")!(billrowid'="")  d
	.q:$p(^DHCPB(admbill),"^",16)="P"
	.s billrowid=admbill
	q billrowid
}

ClassMethod SavePEReceipt(invno, usr, bill, cat, rid, invflag, InvprtID, HospitalID, LocID As %String = "")
{
	;记录发票打印
	n (invno,usr,bill,cat,rid,invflag,InvprtID,HospitalID,LocID)
	s finalflag=##class(web.DHCPE.DHCPEPAY).GetFinalFlag(LocID)
	s err=##class(web.UDHCJFPB).SELECT(bill)
	s invdat=PLIST(20),invtim=PLIST(21),adm=PLIST(2),amount=PLIST(9)
	;
	;&sql(select pb_updatedate,pb_updatetime,pb_adm_dr,pb_totalamount into :invdat,:invtim,:adm,:amount from dhc_patientbill where pb_rowid=:bill)
	;&sql(select paadm_type into:type from paadm where paadm_rowid=:adm)
	
 	Set MEDDATA=##Class(web.DHCPE.DHCPEBillCharge).getMEDDATA()
 	Set CurrentNS=$ZNSPACE
 	ZN MEDDATA
	s err=$$select^MVBPAADM(adm),type=PLIST(9),visst=$g(PLIST(25))
	ZN CurrentNS
	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\yyx
	s deposit=0
	s arrcp=""
	s rcpt=""
	i cat="S"  s tmpbill=$p(^DHCPB(bill),"^",18)
	e  s tmpbill=bill
	f  s rcpt=$o(^ARRCP("ARPBL",tmpbill,rcpt)) q:rcpt=""  d 
	.s childsub=""
	.f  s childsub=$o(^ARRCP("ARPBL",tmpbill,rcpt,childsub))  q:childsub=""  d
	..s depositlx=$p(^ARRCP(rcpt,"RAL",childsub),"^",9)
	..i depositlx'="" s deposit=deposit+$p(^ARRCP(rcpt,"RAL",childsub),"^",2)
	..e  s arrcp=rcpt
	;\\\\\\\\\１３５３０６５３３９５\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\yyx
	;
	s sign=cat
	
	s amount=$p(amount,$c(1)),invdat=+$h,invtim=$p($h,",",2),type=$P(type,$c(1),2)
	set patId = $P(^PAADM(adm),"^",1)
	k PLIST
	s PLIST(2)=invno,PLIST(3)=adm,PLIST(4)=bill,PLIST(5)=arrcp,PLIST(6)=patId,PLIST(12)=invdat,PLIST(13)=invtim
	s PLIST(8)=amount,PLIST(11)=usr,PLIST(9)=sign,PLIST(7)=deposit
	//i sign="S" s PLIST(8)=-amount,PLIST(10)=$P(..getiniinv(bill),"^",1),PLIST(7)=-$P(..getiniinv(bill),"^",2)  ;取押金
	i sign="S" s PLIST(8)=-amount,PLIST(10)=InvprtID,PLIST(7)=0-(+$p(^DHCPEINVPRT(InvprtID),"^",6))  ;取押金
	i sign="S" s PLIST(4)=$p(^DHCPB(bill),"^",18),bill=PLIST(4)
	s PLIST(25)="N",PLIST(26)="N"
	s PLIST(27)=HospitalID
	//s $ZT="ERROR^SSERR" s ttt=..tb()
	
	s err=0
	&sql(INSERT INTO sqluser.DHC_PE_INVPRT VALUES :PLIST())
	
	s PRTRowid=$p(%ROWID,$c(1))
	s err=err+SQLCODE
	
	;添加发票号到AR_RECEIPTS中
	;k PLIST 
	s arrcp=""   ;recnum->ar_receipts.arrcp_number
	s arrcp=$o(^ARRCP("ARPBL",+bill,""),-1) 
	i (arrcp'="")&(invno'="") d
	.;s err=$$select^MVBARREC(arrcp)
	.;s PLIST(4)=invno
	.;s err=$$update^MVBARREC(arrcp)
	.&sql(update sqluser.AR_Receipts set ARRCP_Number=:invno where ARRCP_ROWID=:arrcp)
	.s err=err+SQLCODE
	//s ttt=..tc()
	s rtn=err_"^"_PRTRowid
	q rtn
}

// w ##class(web.DHCPE.DHCPEBillCharge).CancelCashier("79","5")

ClassMethod CancelCashier(InvID, userID)
{
	n (InvID,userID)
	s errs=""
	s SQLCODE=0
	
	s pbID=$P(^DHCPEINVPRT(InvID),"^",3)
	s arrcpID=$P(^DHCPEINVPRT(InvID),"^",4)
	s invNo=$P(^DHCPEINVPRT(InvID),"^",1)
	//add by rxb 20121113
	/*s title=""
	&sql(select INV_title into :title from dhc_invoice where inv_usr=:userID and inv_finalflag='Y' and inv_type='O')
	s:title'="" invNo=$P(invNo,title,2)*/
	//
	//更新审核记录以及对应项目状态
	//OE_OrdItem 收费对应的状态  TB Or P
	//DHC_PE_PreAudit  审核记录表
	//DHC_PE_CRMOrder  体检项目和医嘱项目对照表
	TSTART
	s SQLCODE=0
	s papbRelateID=0
	f  s papbRelateID=$O(^DHCPEPAPBR(0,"PBDR",pbID,papbRelateID)) q:(papbRelateID="")||(SQLCODE'=0)  d
	.s paID=$P(^DHCPEPAPBR(papbRelateID),"^",1)
	.&SQL(Update sqluser.DHC_PE_PreAudit set PA_ChargedStatus='UNCHARGED' where PA_RowId=:paID)
	i SQLCODE'=0{
		TROLLBACK
		q "作废发票时,更改医嘱付费状态失败:"_SQLCODE
	}
	//停止OE_OrdItem  体检收费总金额对应的医嘱，可以从DHC_PatientBill中找到DHC_PatBillOrder
	s pbOrderSub=0
	f  s pbOrderSub=$O(^DHCPB(pbID,"O",pbOrderSub)) q:(pbOrderSub="")||(SQLCODE'=0)  d
	.s oeordItemID=$P(^DHCPB(pbID,"O",pbOrderSub),"^",4)
	.&sql(update sqluser.OE_OrdItem set OEORI_ItemStat_DR='4' where OEORI_RowId =:oeordItemID)
	i SQLCODE'=0{
		TROLLBACK
		q "停止账单对应的医嘱明细失败"_SQLCODE
	}
	//删除账单以及对应的子表
	//DHC_PatientBill  账单表
	//DHC_PatBillOrder   账单关联的医嘱表
	//DHC_PatBillDetails  账单对应的收费项目
	&sql(delete from sqluser.DHC_PatientBill where PB_RowId=:pbID)
	i SQLCODE'=0{
		TROLLBACK
		q "删除账单记录失败"_SQLCODE
	}
	//删除以下表
	//AR_Receipts  以及对应的子表
	//AR_RcptPayMode  对应的支付方式表
	//AR_Rcptalloc
	&sql(delete from sqluser.AR_Receipts where ARRCP_RowId=:arrcpID)
	i SQLCODE'=0{
		TROLLBACK
		q "删除AR_Receipts记录失败"_SQLCODE
	}
	//删除DHC_PE_InvPrt
	&sql(delete from sqluser.DHC_PE_InvPrt where PRT_ROWID=:InvID)
	i SQLCODE'=0{
		TROLLBACK
		q "删除体检发票记录失败"_SQLCODE
	}
	s OriInv=$G(^DHCPEPRT(InvID,"RefInvID"))
	i OriInv'=""
	{
		k ^DHCPEPRT(InvID,"RefInvID")
		k ^DHCPEPRT(OriInv,"NewRefInvID")
	}
	//删除DHC_PE_PAPBRelate
	&sql(delete from sqluser.DHC_PE_PAPBRelate where PAPB_PB_DR=:pbID)
	i SQLCODE'=0{
		TROLLBACK
		q "删除体检账单和审核记录对照失败"_SQLCODE
	}
	/*
	//修改发票表DHC_Invoice,发票号减少1，如果是最后的标志更新为正常
	//暂时没有考虑发票号前面有前缀的情况
	s increInvNo=##class(web.DHCPE.DHCPEPAY).incre(invNo)
	s Flag=""
	&sql(select INV_Finalflag into :Flag from sqluser.DHC_Invoice where INV_Usr=:userID and INV_LastNum=:increInvNo and inv_type='O')
	//如果是最后一张发票
	i SQLCODE=100{
		&sql(select INV_Finalflag into :Flag from sqluser.DHC_Invoice where INV_Usr=:userID and INV_LastNum=:invNo and inv_type='O')
		i SQLCODE=0{
			i Flag="Y" d
			.s Flag="N"
			e  d
			.s Flag="Y"
			&sql(update sqluser.DHC_Invoice set INV_Finalflag=:Flag where INV_Usr=:userID and INV_LastNum=:invNo and inv_type='O')
		}
	
	}else{ //如果不是最后一张发票
		&sql(update sqluser.DHC_Invoice set INV_LastNum=:invNo where INV_Usr=:userID and INV_LastNum=:increInvNo and inv_type='O')
	}
	i SQLCODE'=0{
		TROLLBACK
		q "发票号回滚更新失败"_SQLCODE
	}*/
	 s OPInvID=$G(^DHCPEDataEx("DHCPEINVPRT","H2O",InvID)) 
	 i OPInvID'="" { 
	 	s ret=##class(web.DHCBillCons3).DelINVPRTForYB(OPInvID,"")
	  	i ret'=0{
		  	 TROLLBACK 
	  		q "删除门诊发票错误:"_ret } 
	  	}

	TCOMMIT
	q errs
}

// w ##class(web.DHCPE.DHCPEBillCharge).UpdatePayMode(65,"0^123^100^65"_$C(2)_"2^55"_$C(2)_"3^45")

// rtn^DHC_InsuDivideRowID^PatShareSum^DHCINVRowID_ZFPayModeDR$c(2)_PayMode_DR^12.01_$c(2)_PayMode_DR ^20

ClassMethod UpdatePayMode(invID, strInfo)
{
	q:$P(strInfo,"^",1)'=0 strInfo
	s PatShareSum=$P(strInfo,"^",3)
	s InsuDivideID=$P(strInfo,"^",2)
	s ARReceiptsID=$P(^DHCPEINVPRT(invID),"^",4)
	s sub=$O(^ARRCP(ARReceiptsID,"PAYM",0))
	s PAYMRowID=ARReceiptsID_"||"_sub
	s oldAmount=$P(^ARRCP(ARReceiptsID,"PAYM",sub),"^",3)
	s NewPayMode = $P($P(strInfo,$C(2),1),"^",5)
	s:NewPayMode="" NewPayMode = $P(^ARRCP(ARReceiptsID,"PAYM",sub),"^",1)
	s i=2
	s j=$L(strInfo,$c(2))
	s SQLCODE=0
	s amountSum=0
	TSTART
	f k=i:1:j
	{
		s oneInfo=$P(strInfo,$c(2),k)
		s payModeID=$p(oneInfo,"^",1)
		s amount=$p(oneInfo,"^",2)
		s PLIST(0)=ARReceiptsID
		s PLIST(3)=payModeID
		s PLIST(5)=amount
		s amountSum=amountSum+amount
		&sql(insert into AR_RcptPayMode values :PLIST())
		q:SQLCODE'=0
	}
	i SQLCODE'=0 d
	.TROLLBACK
	.s ^DHCPEOEITEMErr(invID)=strInfo //体检自己这边出错了，记录下医保信息，方便再次插入体检信息
	.s $P(strInfo,"^",1)=-4
	q:SQLCODE'=0 SQLCODE
	&SQL(update AR_RcptPayMode set PAYM_Amt=PAYM_Amt-:amountSum,PAYM_PayMode_DR=:NewPayMode where PAYM_RowId=:PAYMRowID)
	i SQLCODE'=0 d
	.TROLLBACK
	.s ^DHCPEOEITEMErr(invID)=strInfo
	.s $P(strInfo,"^",1)=-4
	s $P(^DHCPEOEITEM(invID),"^",4)=InsuDivideID
	s $P(^DHCPEOEITEM(invID),"^",5)=amountSum
	k ^DHCPEOEITEMErr(invID)
	//s SQLCODE2=##class(web.DHCPE.Cashier).UpdateSswrAmount(invID)
	
	s OldPayModeID=$P($G(^ARRCP(ARReceiptsID,"PAYM",sub)),"^",1)
	s OldPayModeCode=$P(^CT("CTPM",OldPayModeID),"^",1)
	i OldPayModeCode="CPP" d
	.s UserID=$P(^DHCPEINVPRT(invID),"^",10)
	.s AdmId=$P(^DHCPEINVPRT(invID),"^",2)
	.s papmi=$P(^PAADM(AdmId),"^",1)
	.s DeplocDR=$P(^PAADM(AdmId),"^",4)
	.s CardNo=$P(^ARRCP(ARReceiptsID,"PAYM",sub),"^",20)  ;账户ID
	.s OneAmt=-amountSum
	.s SQLCODE=##class(web.DHCPE.DHCQseXmComm).ReduDepos(UserID,papmi,CardNo,OneAmt,invID,DeplocDR)
	.s:+SQLCODE=0 SQLCODE=0
	TCOMMIT
	q SQLCODE
	//q "0^"_(oldAmount-amountSum)
}

// 医保结算成功了，体检修改支付方式出错后的操作

// w ##class(web.DHCPE.DHCPEBillCharge).ReUpdatePayMode("65")

ClassMethod ReUpdatePayMode(invID)
{
	s strInfo=$G(^DHCPEOEITEMErr(invID))
	q:strInfo="" "没有修改支付方式失败的信息"
	d ..UpdatePayMode(invID, .strInfo)
	i +strInfo=0 q "更新成功"
	q "更新失败"
}

// ##class(web.DHCPE.DHCPEBillCharge).GetInsuID("65")

ClassMethod GetInsuID(invID, type As %String = "0")
{
	s ret=""
	q:invID="" ""
	s ret=$P($G(^DHCPEOEITEM(invID)),"^",4)
	q:type=0 ret
	i ret'="" s ret=1
	q ret
}

ClassMethod GetGFInfoByIADM(IADM)
{
	;w ##class(web.DHCPE.DHCPEBillCharge).GetGFInfoByIADM(741)
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s SocialStatus=obj.PAADMPAPMIDR.PAPMIRowId.PAPERSocialStatusDRGetObjectId()
	s PACADM=$O(^DHCPACADM(0,"Social",SocialStatus,0))
	q:PACADM="" "-1^没有对应的费别"
	s AdmReason=$P(^DHCPACADM(PACADM),"^",2)
	q:AdmReason="" "-1^没有对应的费别"
	s YBType=$P(^PAC("ADMREA",AdmReason),"^",9)
	q:(YBType'="1")&&(YBType'="2") "-1^对应的费别不是医保费别"
	s InsuNo=obj.PAADMPAPMIDR.PAPMIMedicareCode
	q "0^"_YBType_"^"_AdmReason_"^"_SocialStatus_"^"_InsuNo
	
	q:SocialStatus'="8" "1^不是公费按普通医保"   ;写死了公费病人ct_socialstatus 
	s InsuNo=obj.PAADMPAPMIDR.PAPMIMedicareCode
	q:InsuNo="" "-1^医保号不存在"
	s GFID=$O(^DHCINLOC(0,"YLZBH",InsuNo,""))
	q:InsuNo="" "-1^没有维护公费信息"
	s AdmReason=$P(^DHCINLOC(GFID),"^",32)
	q:AdmReason="" "-1^没有维护对应的费别"
	q "0^"_InsuNo_"^"_AdmReason
}

ClassMethod GetGFInfoByInsuID(InsuID)
{
	s obj=##class(User.INSUDivide).%OpenId(InsuID)
	s ReasonCode=obj.INPAYZstr23
	s ReasonID=##class(web.DHCINSUPort).RtnDicCodeStrByDicBill1("AdmReasonDrToDLLType",ReasonCode)
	if ReasonID'=""{
		s InsuNo=obj.INPAYid0000
		s YBType=$P(^PAC("ADMREA",ReasonID),"^",9)
		i YBType="2"{
			q "0^"_InsuNo_"^"_ReasonID
		}
	}
	q "1^"
}

/// w ##class(web.DHCPE.DHCPEBillCharge).GetAmountByInv()
ClassMethod GetAmountByInv(InvID)
{
	q:InvID="" 0
	s sswr=$p($G(^DHCPEINVPRT(InvID)),"^",21)
	s TotalAmount=+$P($G(^DHCPEINVPRT(InvID)),"^",7)
	i sswr'="" s TotalAmount=TotalAmount+sswr
	q TotalAmount
}

}
