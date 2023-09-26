Import SQLUser

/// 门诊卡消费医保接口存取数据
/// Write by wuqk 2006-03-29
Class web.DHCINSUOPBill Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 169;

// w ##class(web.DHCINSUOPBill).GetOPInvInfo("252","ZZB")

// s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05

ClassMethod GetOPInvInfo(JustThread As %String, InsuType As %String) As %String
{
	n (JustThread,InsuType)
	;s GetOPInvInfo="993"_$c(1)_"1"_$c(2)_"881"_$c(2)_"883"_$c(2)_"885"
	;s GetOPInvInfo=GetOPInvInfo_$c(1)_"2"_$c(2)_"871"_$c(2)_"873"_$c(2)_"875"
	;q GetOPInvInfo
	;^DHCTMPACCColPRT=^TMPColPrt   2006 06 06 modify
	s GetOPInvInfo=""
	s OutFlag="N"    ;是否有数据返回  N  Y ：有
	s AdmReasonId=""
	;q:instype="" GetOPInvInfo
	;q:('$d(^DHCTMPACCColPRT("IP",JustThread,11)))&('$d(^DHCTMPACCColPRT("IP",JustThread,13))) GetOPInvInfo
	;^DHCTMPACCColPRT("IP",$j,tmpinstype, myIdx,"PrtRowID",tmpPrtRowID)=tmpPrtRowID
    ;w !,"------"
    s HospDr=##class(web.DHCINSUBase).GetHOSPID(JustThread,"JustThread") //+ DingSH 20200602
    
    s BillFlag="",InvStr=""
    f  s AdmReasonId=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId))     q:AdmReasonId=""    d
    .;w !,instype
    .s DicInsuType=$p($$QueryByCode^DHCINSUDicData("AdmReasonDrToDLLType",AdmReasonId,HospDr),"^",6)
    .b
    .q:DicInsuType'=InsuType
    .;q:(instype'="11")&(instype'="12")&(InsuType="LFA")
    .;q:(instype'="13")&(instype'="14")&(InsuType="LFB")
    .s OutFlag="Y"
    .;w !,instype,"OutFlag=",OutFlag
    .s myIdx="",ConStr="",TmpInvRowid="",TmpFlag=""
    .f  s myIdx=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx)) q:myIdx=""  d
    ..s billStr="" ;myIdx
    ..;w !,"myIdx="_myIdx
    ..s PRTAcount=^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx,"PatPaySum")    //单张发票总费用
    ..s tmpPrtRowID="",TmpInvRowid=""
    ..f  s tmpPrtRowID=$o(^DHCTMPACCColPRT("IP",JustThread,AdmReasonId,myIdx,"PrtRowID",tmpPrtRowID)) q:tmpPrtRowID=""  d
    ...;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid}) 
    ...w !," tmpPrtRowID="_tmpPrtRowID
    ...q:'$d(^DHCBCI(0,"INV",tmpPrtRowID))
    ...s:TmpInvRowid'="" TmpInvRowid=TmpInvRowid_"!"_tmpPrtRowID       ;InvPrtRowid 组串传出
    ...s:TmpInvRowid="" TmpInvRowid=tmpPrtRowID
    ...;w !,"1",myIdx,"tmpPrtRowID",tmpPrtRowID
    ...s BillConInvRowid=""
    ...f  s BillConInvRowid=$o(^DHCBCI(0,"INV",tmpPrtRowID,BillConInvRowid)) q:BillConInvRowid=""  d
    ....;w !,"        BillConInvRowid="_BillConInvRowid
    ....s ConStr=$g(^DHCBCI(BillConInvRowid))
    ....;w !,"            ConStr"_ConStr
    ....s Bill=$p(ConStr,"^",2)
    ....s paadm=$p(ConStr,"^",3)
    ....s billStr=billStr_$c(3)_Bill
    ..s billStr=myIdx_$c(2)_billStr_$c(2)_paadm_$c(2)_TmpInvRowid_$c(2)_AdmReasonId_$c(2)_PRTAcount
    ..s TmpFlag=..CheckInv(paadm,TmpInvRowid)
    ..s:TmpFlag="Y" BillFlag="Y"
    ..s InvStr=InvStr_$c(1)_billStr
    ;s paadm=$p(ConStr,"^",3)
    i OutFlag="Y" d
    .s GetOPInvInfo=paadm_InvStr_$c(1)_BillFlag
    ;w !,GetOPInvInfo
    b ;2233
    q GetOPInvInfo
}

ClassMethod CheckInv(paadm, TmpInvRowid)
{
	;paadm 的最后一笔结算成功，中间几笔数据已经结果，这个函数会结算第二次函数有漏洞。
	;n (paadm, TmpInvRowid)
	;w !,TmpInvRowid
    n (paadm, TmpInvRowid)
	s CheckInv="N"
	;^DHCINDIV(0,"Paadm",1017,2
	q:'$d(^DHCINDIV(0,"Paadm",paadm)) CheckInv
	s indiv=""
	f  s indiv=$o(^DHCINDIV(0,"Paadm",paadm,indiv))  q:(indiv="")!(CheckInv="Y")  d
	.s DivFlag=$p($g(^DHCINDIV(indiv)),"^",5)
	.s divTmpInv=$p($g(^DHCINDIV(indiv)),"^",4)
	.;w !,indiv_"//"_DivFlag_"//"_divTmpInv,!
	.q:DivFlag'="I"
	.s CheckInv=$$Check(divTmpInv,TmpInvRowid)	
	q CheckInv
	
Check(divTmpInv,TmpInvRowid)
   n (divTmpInv,TmpInvRowid)
   s iDivCount=$l(divTmpInv,"!")
   s iTmpCount=$l(TmpInvRowid,"!")
   ;w iDivCount_"//"_iTmpCount
   s Flag=""
   f i=1:1:iDivCount  d
   .s divTmp=$p(divTmpInv,"!",i)
   .q:divTmp=""
   .f j=1:1:iTmpCount d
   ..s TmpInv=$p(TmpInvRowid,"!",j)
   ..q:TmpInv=""
   ..;w !,"  divTmp=TmpInv "_divTmp_"---"_TmpInv
   ..s:divTmp=TmpInv Flag="Y"
   q Flag
}

ClassMethod SetOPBillInfo(JustThread As %String, instype As %String, BackString As %String) As %String
{
	n (JustThread,instype,BackString)
	q:BackString="" "-1"
	;s instype=""
	;s:InsuType="HF" instype="31"                ;;HF医保病人
	q:instype="" "-2"
	s InvprtIndex=$p(BackString,"^",1)
	s InsuDivide=$p(BackString,"^",2)
	;BackString="InvIndex^Insudiv^Amount1^Amount2"	
	;^TMPColPrt("IP",$j,tmpinstype, myIdx,”YBPM”, PayMode_DR)= 12.01
    ;^TMPColPrt("IP",$j,tmpinstype, myIdx,”YBRowID”, DHC_InsuDivideRowID)= DHC_InsuDivideRowID
    ;^TMPColPrt("IP",$j,tmpinstype, myIdx,”PatShare”)= 12.01
    
    ;医保结算信息表rowid
    s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBRowID",InsuDivide)=InsuDivide
    
    ;个人自付金额
    s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"PatShare")=+$p(BackString,"^",3)
    
    ;统筹基金支付金额
    ;s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM","YBTCPay")=+$p(BackString,"^",4)
    s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",6)=+$p(BackString,"^",4)
    s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",33)=+$p(BackString,"^",5)
    ;救助基金支付金额
    ;s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM","YBDBPay")=+$p(BackString,"^",5)
    ;s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",5)=+$p(BackString,"^",5)
    
     ;公务员基金支付金额
    ;s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM","YBDBPay")=+$p(BackString,"^",5)
    ;s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",6)=+$p(BackString,"^",6)
    
    
    ;个人帐户支付金额
    ;s ^TMPColPrt("IP",JustThread,instype,InvprtIndex,"YBPM","YBAccPay")=+$p(BackString,"^",6)
    ;s ^DHCTMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",7)=+$p(BackString,"^",7)
	
	s SetOPBillInfo="0"
	q SetOPBillInfo
}

ClassMethod GetDivStrik(InsuNo As %String, Backstring As %String) As %String
{
 ;s Backstring=InsuNo
 s Backstring=""
 s ID=0
 f  s ID=$o(^DHCINDIV("0","ID0000",InsuNo,ID))            q:ID=""    d
 .s bcbxf0=$P(^DHCINDIV(ID),"^",7)            ;总金额
 .s Flag=$P(^DHCINDIV(ID),"^",5)              ;结算状态
 .q:Flag="S"
 .;q:$d(^DHCINVPRTAPi(0,"InsDR",ID))
 .s admdr=$P(^DHCINDIV(ID),"^",1)
 .s papmidr=$p(^PAADM(admdr),"^",1)
 .s PAPMINO=$p(^PAPER(papmidr,"PAT",1),"^",1)
 .;w !,PAPMINO
 .s IDATE=$zt($P(^DHCINDIV(ID),"^",16)) ;操作日期
 .s ITIME=$zt($P(^DHCINDIV(ID),"^",17)) ;操作时间
 .s djlsh0=$p(^DHCINDIV(ID),"^",8) ;单据流水号
 .s grzfe0=$p(^DHCINDIV(ID),"^",15)  ;个人自负金额
 .s zhzfe0=$p(^DHCINDIV(ID),"^",28)  ;账户支付额
 .s InsuPay1=$p(^DHCINDIV(ID),"^",31) ;本次个人自费金额(非医保费用)
 .s InsuPay2=$p(^DHCINDIV(ID),"^",32) ;本次个人帐户支付普通门诊金额
 .s InsuPay3=$p(^DHCINDIV(ID),"^",33) ;本次个人帐户支付自付段金额
 .s InsuPay4=$p(^DHCINDIV(ID),"^",34) ;本次个人现金支付自付段金额
 .s InsuPay5=$p(^DHCINDIV(ID),"^",35) ;本次个人帐户代付 统筹段个人支付部分 金额
 .s Backstring=Backstring_"!"_PAPMINO_"^"_InsuNo_"^"_bcbxf0_"^"_Flag_"^"_IDATE_"^"_ITIME_"^"_djlsh0_"^"_grzfe0_"^"_zhzfe0_"^"_InsuPay1_"^"_InsuPay2_"^"_InsuPay3_"^"_InsuPay4_"^"_InsuPay5
 ;w !,Backstring
 s GetDivStrik=Backstring
}

// 判断此医保发票就诊登记是否超过二天，医保中心要求挂号不能超过二天

ClassMethod JudDivStrik(DivID As %String, Backstring As %String) As %String
{
 n (DivID)
 q:DivID="" -1
 q:$d(^DHCINDIV(DivID))=0 -1
 s adminfodr=$p(^DHCINDIV(DivID),"^",2)
 q:adminfodr="" -1
 q:$d(^DHCINADM(adminfodr))=0 -1
 s fundate=$p(^DHCINADM(adminfodr),"^",24)
 s datenum=$p($H,",",1)-fundate             ;天数差
 s TimeNum2=datenum*24                      ;时间差
 ;w !,datenum
 s funtime=$p(^DHCINADM(adminfodr),"^",25)   ;登记时间
 ;w !,$p($H,",",2) ,funtime
 ;w !,$zt($p($H,",",2)) ,$zt(funtime)
 s TimeNum1=$p($H,",",2)-funtime              ;登记时间差
 i TimeNum1>0    d
 .s TimeNum1=TimeNum2+$p($zt(TimeNum1),":",1)+1   ;时间加1
 e               d
 .s TimeNum1=TimeNum2-$p($zt(-TimeNum1),":",1)    ;  
 ;w !,TimeNum1
 i TimeNum1>48   d
 .s Flag=-1
 e               d
 .s Flag=0
 w !,Flag
 ;s Flag=0
 s JudDivStrik=Flag
 ;q 0
}

ClassMethod GetOPInvInfobak(JustThread As %String, InsuType As %String) As %String
{
	;n (JustThread,InsuType)
	;s GetOPInvInfo="993"_$c(1)_"1"_$c(2)_"881"_$c(2)_"883"_$c(2)_"885"
	;s GetOPInvInfo=GetOPInvInfo_$c(1)_"2"_$c(2)_"871"_$c(2)_"873"_$c(2)_"875"
	;q GetOPInvInfo
	;^DHCTMPACCColPRT=^TMPColPrt   2006 06 06 modify
	s GetOPInvInfo=""
	s instype=""
	s:InsuType="HF" instype="31"
	q:instype="" GetOPInvInfo
	q:'$d(^TMPACCColPRT("IP",JustThread,instype)) GetOPInvInfo
	;^TMPACCColPRT("IP",$j,tmpinstype, myIdx,"PrtRowID",tmpPrtRowID)=tmpPrtRowID
    ;w !,"------"
    s myIdx="",InvStr="",ConStr="",TmpInvRowid="",BillFlag="",TmpFlag=""
    f  s myIdx=$o(^TMPACCColPRT("IP",JustThread,instype,myIdx)) q:myIdx=""  d
    .s billStr="" ;myIdx
    .;w !,"myIdx="_myIdx
    .s tmpPrtRowID="",TmpInvRowid=""
    .f  s tmpPrtRowID=$o(^TMPACCColPRT("IP",JustThread,instype,myIdx,"PrtRowID",tmpPrtRowID)) q:tmpPrtRowID=""  d
    ..;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid}) 
    ..;w !,"   tmpPrtRowID="_tmpPrtRowID
    ..q:'$d(^DHCBCI(0,"INV",tmpPrtRowID))
    ..s TmpInvRowid=TmpInvRowid_"!"_tmpPrtRowID       ;InvPrtRowid 组串传出
    ..w !,"1",myIdx,"tmpPrtRowID",tmpPrtRowID
    ..s BillConInvRowid=""
    ..f  s BillConInvRowid=$o(^DHCBCI(0,"INV",tmpPrtRowID,BillConInvRowid)) q:BillConInvRowid=""  d
    ...;w !,"        BillConInvRowid="_BillConInvRowid
    ...s ConStr=$g(^DHCBCI(BillConInvRowid))
    ...;w !,"            ConStr"_ConStr
    ...s Bill=$p(ConStr,"^",2)
    ...s paadm=$p(ConStr,"^",3)
    ...s billStr=billStr_$c(3)_Bill
    .s billStr=myIdx_$c(2)_billStr_$c(2)_paadm_$c(2)_TmpInvRowid
    .s TmpFlag=..CheckInv(paadm,TmpInvRowid)
    .s:TmpFlag="Y" BillFlag="Y"
    .s InvStr=InvStr_$c(1)_billStr
    ;s paadm=$p(ConStr,"^",3)
    s GetOPInvInfo=paadm_InvStr_$c(1)_BillFlag
    q GetOPInvInfo
}

ClassMethod SetOPBillInfobak(JustThread As %String, InsuType As %String, BackString As %String) As %String
{
	n (JustThread,InsuType,BackString)
	q:BackString="" "-1"
	s instype=""
	s:InsuType="HF" instype="31"                ;;HF医保病人
	q:instype="" "-2"
	s InvprtIndex=$p(BackString,"^",1)
	s InsuDivide=$p(BackString,"^",2)
	;BackString="InvIndex^Insudiv^Amount1^Amount2"	
	;^TMPColPrt("IP",$j,tmpinstype, myIdx,”YBPM”, PayMode_DR)= 12.01
    ;^TMPColPrt("IP",$j,tmpinstype, myIdx,”YBRowID”, DHC_InsuDivideRowID)= DHC_InsuDivideRowID
    ;^TMPColPrt("IP",$j,tmpinstype, myIdx,”PatShare”)= 12.01
    
    ;医保结算信息表rowid
    s ^TMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBRowID",InsuDivide)=InsuDivide
    
    ;个人自付金额
    s ^TMPACCColPRT("IP",JustThread,instype,InvprtIndex,"PatShare")=+$p(BackString,"^",3)
    
    ;统筹基金支付金额
    ;s ^TMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM","YBTCPay")=+$p(BackString,"^",4)
    s ^TMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",4)=+$p(BackString,"^",4)
    
    ;救助基金支付金额
    ;s ^TMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM","YBDBPay")=+$p(BackString,"^",5)
    s ^TMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",5)=+$p(BackString,"^",5)
    
    ;个人帐户支付金额
    ;s ^TMPColPrt("IP",JustThread,instype,InvprtIndex,"YBPM","YBAccPay")=+$p(BackString,"^",6)
    s ^TMPACCColPRT("IP",JustThread,instype,InvprtIndex,"YBPM",6)=+$p(BackString,"^",6)
	
	s SetOPBillInfo="0"
	q SetOPBillInfo
}

/// w ##class(web.DHCINSUOPBill).GetOPInvInfoByStrInvDr("18213","WHA")
ClassMethod GetOPInvInfoByStrInvDr(StrInvDr As %String, InsuType As %String) As %String
{
	s GetOPInvInfoByStrInvDr=""
	s instype=""
	;s InsuType="SH"
	;s:InsuType="SH" instype="14"
	;s instype="10"
	;q:instype="" GetOPInvInfoByStrInvDr
    s BillFlag="",InvStr="",paadm=""
    s InvDrNum=$l(StrInvDr,"^")    
    s myIdx="",ConStr="",TmpInvRowid="",TmpFlag=""
    f i=1:1:InvDrNum     d   
    .s billStr="" ;myIdx
    .s myIdx=1
    .s tmpPrtRowID=$p(StrInvDr,"^",i)
    .q:tmpPrtRowID=""
    .;w tmpPrtRowID,!
    .q:$d(^DHCINVPRT(tmpPrtRowID))=0

    .s InvPrt=$p(^DHCINVPRT(tmpPrtRowID),"^",14)
    .q:'$d(^DHCBCI(0,"INV",tmpPrtRowID))
    .s TmpInvRowid=tmpPrtRowID
    .;s PRTAcount=$p($g(^DHCINVPRT(tmpPrtRowID)),"^",1)
    .s PRTAcount=$p($g(^DHCINVPRT(tmpPrtRowID)),"^",16) ;PRTPatientShare
    
    .s instype=$p($g(^DHCINVPRT(tmpPrtRowID)),"^",9)
    .;潍坊不拼医保发票rowid ,单张发票处理 
    .;i TmpInvRowid=""  d
    ..;s TmpInvRowid=tmpPrtRowID       ;InvPrtRowid 组串传出
    .;e                 d
    ..;s TmpInvRowid=TmpInvRowid_"!"_tmpPrtRowID       ;InvPrtRowid 组串传出
    .s BillConInvRowid=""
    .f  s BillConInvRowid=$o(^DHCBCI(0,"INV",tmpPrtRowID,BillConInvRowid)) q:BillConInvRowid=""  d
    ..s ConStr=$g(^DHCBCI(BillConInvRowid))
    ..s Bill=$p(ConStr,"^",2)
    ..s paadm=$p(ConStr,"^",3)
    ..s billStr=billStr_$c(3)_Bill
    .;s billStr=myIdx_$c(2)_billStr_$c(2)_paadm_$c(2)_TmpInvRowid_$c(2)_instype
    .s billStr=InvPrt_$c(2)_billStr_$c(2)_paadm_$c(2)_TmpInvRowid_$c(2)_instype_$c(2)_PRTAcount
    .s TmpFlag=""
    .s TmpFlag=..CheckInv(paadm,TmpInvRowid)
    .s:TmpFlag="Y" BillFlag="Y"
    .s InvStr=InvStr_$c(1)_billStr 
    q:paadm="" ""
    s GetOPInvInfoByStrInvDr=paadm_InvStr_$c(1)_BillFlag
    q GetOPInvInfoByStrInvDr
}

/// Creator:liusf
/// CreateTime:2011-05-11
/// 删除计费组发票表
/// IN：发票串，成功的发票串，安全组id
/// OUT:0成功
/// w ##class(web.DHCINSUOPBill).DelINVPRTForYB("12","1")
ClassMethod DelINVPRTForYB(INVStr As %String, GroupDr As %String) As %String
{
	n (INVStr,GroupDr)
	s ^Test("Del")=INVStr_"^"_GroupDr
	s ^DHCINSULog("DelINVPRTForYB",INVStr)=INVStr_"!"_GroupDr_"!"_+$h
	s rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(INVStr,GroupDr)
	s ^DHCINSULog("DelINVPRTForYB",INVStr,"Rtn")=rtn
	q rtn
}

/// Creator:LouLina
/// CreateTime:2011-03-07
/// 更新计费组发票支付方式表
/// IN：结算分解串，空
/// OUT:0成功
ClassMethod UpdateINVPRTYBInfo(YBInfo As %String, ExpStr As %String) As %String
{
	n (YBInfo,ExpStr)
	s rtn="-1"
	s rtn=##class(web.DHCBillConsIF).UpdateINVPRTYBInfo(YBInfo,ExpStr)
	if $p(rtn,$c(4),1)="0" d
	.s rtn="0"
	q rtn
}

/// 体检====start
/// w ##class(web.DHCINSUOPBill).GetPEInvInfoByStrInvDr(72,"WHA")
ClassMethod GetPEInvInfoByStrInvDr(PEStrInvDr As %String, InsuType As %String) As %String
{
	;^DHCPEOEITEM(72) = "1527.86^51644002^269238" 
	s GetPEInvInfoByStrInvDr=""
	s PEInvInfo=$g(^DHCPEOEITEM(PEStrInvDr))
	;totalFee_"^"_invNo_"^"_paadm
	s totalFee=$p(PEInvInfo,"^",1)
	s invNo=$p(PEInvInfo,"^",2)
	s paadm=$p(PEInvInfo,"^",3)
	q totalFee_"^"_invNo_"^"_paadm
}

/*ClassMethod GxPEZffs(PEStrInvDr As %String, Instring As %String) As %String
{
	n (PEStrInvDr,Instring)
	q:PEStrInvDr="" "-3"
    s rtn="-1"
    s rtn=##class(web.DHCPE.DHCPEBillCharge).UpdatePayMode(PEStrInvDr,Instring)
    q rtn
}*/
/// w ##class(web.DHCINSUOPBill).GxPEZffs("2216","0^340685^11.88^2216"_$C(2)_"6^35"_$C(2)_"4^0")
/// 更改后请调用用--w ##class(web.DHCINSUOPBill).UpatePEINVPRTYBInfo
/// Creator:DingSH
/// CreateTime:2022-02-22
/// 更新体检组发票表医保支付方式
/// IN：体检发票Dr,医保支付方式信息:
///                0^医保结算表指针^个人自付^体检发票Rowid^个人自付支付方式$C(2)支付方式Rowid^支付金额...$C(2)支付方式Rowid^支付金额
/// OUT:0成功
/// w ##class(web.DHCINSUOPBill).UpatePEINVPRTYBInfo("2216","0^340685^11.88^2216"_$C(2)_"6^35"_$C(2)_"4^0")
ClassMethod UpatePEINVPRTYBInfo(PEStrInvDr As %String, InsuStr As %String) As %String
{
	n (PEStrInvDr,InsuStr)
	q:PEStrInvDr="" "-3"
    s rtn="-1"
    s rtn=##class(web.DHCPE.DHCPEBillCharge).UpdatePayMode(PEStrInvDr,InsuStr)
    q rtn
}

///      体检====end

}
