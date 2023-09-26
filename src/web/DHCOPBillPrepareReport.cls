Class web.DHCOPBillPrepareReport Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod FindInfo(date) As %Status
{
  s date=$zdh(date,3)
  s rs=0
  s leftSum=0,prtSum=0,rePrtSum=0,cardPaySum=0,thisSum=0
  s accPFRowId=0
  f  s accPFRowId=$o(^DHCACDi("AccPF",0,"CurDateT",date,accPFRowId)) q:accPFRowId=""  d 
  .s leftSum=leftSum+$p(^DHCACD("AccPF",accPFRowId),"^",6)  //上次余额
  .s prtSum=prtSum+$p(^DHCACD("AccPF",accPFRowId),"^",7)  //本次收预交金
  .s rePrtSum=rePrtSum+$p(^DHCACD("AccPF",accPFRowId),"^",10)  //本次退预交金
  .s cardPaySum=cardPaySum+$p(^DHCACD("AccPF",accPFRowId),"^",8)  //卡消费
  s thisSum=leftSum+prtSum-rePrtSum-cardPaySum            //本日实现卡余额
  
  s prtLeftSum=0
  s accmRowId=0
  f  s accmRowId=$o(^DHCACDi("AccM",0,"PayDate",date,accmRowId)) q:accmRowId=""  d
  .s accplSub=0,handinDate=""
  .f  s accplSub=$o(^DHCACDi("AccM",0,"PayDate",date,accmRowId,"AccPL",accplSub)) q:accplSub=""  d
  ..s invRowId=""
  ..s invRowId=$p(^DHCACD("AccM",accmRowId,"AccPL",accplSub),"^",2)
  ..s handinDate=$p(^DHCINVPRT(invRowId),"^",11)   
  ..i ((handinDate="")||(handinDate>date))  d
  ...s prtLeftSum=prtLeftSum+$p(^DHCACD("AccM",accmRowId,"AccPL",accplSub),"^",8)  //本日未结算的卡消费
  
  s preNoFootSum=0
  s dhcAccMRowId=0
  f  s dhcAccMRowId=$o(^DHCACDi("AccM",0,"APDDate",date,dhcAccMRowId)) q:dhcAccMRowId=""  d
  .s accPDSub=0
  .f  s accPDSub=$o(^DHCACDi("AccM",0,"APDDate",date,dhcAccMRowId,"AccPD",accPDSub)) q:accPDSub=""  d
  ..q:$p(^DHCACD("AccM",dhcAccMRowId,"AccPD",accPDSub),"^",1)="F"
  ..s preNoFootSum=preNoFootSum+$p(^DHCACD("AccM",dhcAccMRowId,"AccPD",accPDSub),"^",2)   //本次未结算的卡收入
  
  s thisNoFootDiff=preNoFootSum-prtLeftSum     //本日未结算时间差异数
  s thisNoFootCardLeft=thisSum-thisNoFootDiff   //本次未结算的卡余额 
  s thisPreSum=prtSum-rePrtSum-thisNoFootDiff                //本日预交金合计
  
  s empoyeeTallySum=0,kySum=0
  s prtRowid=0
  f  s prtRowid=$o(^DHCINVPRT(0,"Date",date,prtRowid)) q:prtRowid=""  d
  .s admReasonRowId="",admType=""
  .s admReasonRowId=$p(^DHCINVPRT(prtRowid),"^",9)
  .s admType=$p(^PAC("ADMREA",admReasonRowId),"^",2)
  .i admType="本院职工" d
  ..s empoyeeTallySum=empoyeeTallySum+$p(^DHCINVPRT(prtRowid),"^",18)
  .i admType="科研" d
  ..s kySum=kySum+$p(^DHCINVPRT(prtRowid),"^",18)
  s rs=leftSum_"^"_prtSum_"^"_rePrtSum_"^"_cardPaySum_"^"_thisSum_"^"_prtLeftSum_"^"_preNoFootSum_"^"_thisNoFootDiff_"^"_thisNoFootCardLeft_"^"_thisPreSum_"^"_empoyeeTallySum_"^"_kySum
  q rs
}

}
