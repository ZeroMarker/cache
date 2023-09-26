Class web.DHCMGNurWorkLoad Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 136;

ClassMethod GetMainPat(ward, Date)
{
 //重点关注数据
 //s a=##class(web.DHCMGNurWorkLoad).GetMainPat()
 //
 //
 ///////////////////////////
  //s Date=$ZD(Date,3)
  s pacward=$O(^PAWARD(0,"WARD_LocationDR",ward,""))
  s PatArr="",PatNum=""
  q:pacward="" 
 ///////////////////////////////////////////////
  s room=""  f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
  .s adm=""  f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d   
  ..s ord=""  f  s ord=$O(^OEORD(0,"Adm",adm,ord)) q:ord=""  d
  ...d ..GetAttenPat("A",ord,adm,.PatArr,.PatNum,Date)
  s typ="A"
  s itm=""  f  s itm=$O(PatArr(typ,itm)) q:itm=""  d
  .s num=PatNum(itm)
  .d ##class(Nur.DHCMGCurrDayAttenNum).Save(ward, itm,num,Date)
  .s adm=""  f  s adm=$O(PatArr(typ,itm,adm)) q:adm=""  d  
  ..d ##class(Nur.DHCMGCurrDayAttenPat).Save(ward, itm,adm,Date)
}

ClassMethod MakeAdmData(Date) As %String
{
 //s a=##class(web.DHCMGNurWorkLoad).MakeAdmData()
  ///////////////////////////////////////////////
  ///////////////////////////////////////////////
  ////门诊，急诊，留观 //MZADM,EZADM,JZLG,EnertHs,DischHs,DeathHs,TranIn,TranOut
 if Date=""  s Date=+$H
 e  s Date=$ZDH(Date,3)
 s (MZADM,EZADM,JZLG,EnertHs,DischHs,DeathHs,TranIn,TranOut,PatArr)=""
  s adm=""  f  s adm=$O(^PAADMi("PAADM_AdmDate",Date,adm)) q:adm=""  d
  .s pattyp=$P(^PAADM(adm),"^",2)
  .s stat=$P(^PAADM(adm),"^",20)
  .q:pattyp="I"
  .q:stat="C"  //取消
  .s loc=$P(^PAADM(adm),"^",4)
  .if loc="326" s EZADM(loc,adm)=""
  .e  s MZADM(loc,adm)=""
  .//if $D(^PAC("ADMLOC",0,"AdmType","O",loc)) d
  .//.s MZADM(loc,adm)=""
  .//if $D(^PAC("ADMLOC",0,"AdmType","E",loc)) d
  .//.s EZADM(loc,adm)=""
  s sdate=Date-30, edate=Date //留观
  // PAC_AdmTypeLocation
  f date=sdate:1:edate
  {
   s stat=""  f  s stat=$O(^DHCADMVisitStatus(0,"DateStatus",date,stat)) q:stat=""  d
   .s statdes=$P(^DHCPACVisitStatus(stat),"^",1)
   .q:"^Discharge^Inhospital^Displace^SalDeath^"[statdes
   .//w !,statdes
   .s rw=""  f  s rw=$O(^DHCADMVisitStatus(0,"DateStatus",date,stat,rw)) q:rw=""  d
   ..s adm=$P(^DHCADMVisitStatus(rw),"^",1)
   ..s loc=$P(^PAADM(adm),"^",4)
   ..s flag=..getflag(adm)
   ..if flag="Y" s JZLG(loc,adm)=""
  }
 // b //
 ////入院，出院，死亡
     s depitm=##class(web.DHCMGPERSON).GetSortDep("NUR")
     s l=$L(depitm,"^")
     for i=1:1:l
     {
	   s aa=$P(depitm,"^",i)
	   if aa="" continue
	   s dep=$P(aa,"|"),depdes=$P(aa,"|",2)
       s pacward=$O(^PAWARD(0,"WARD_LocationDR",dep,""))
       if pacward="" continue
       s room=""  f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	   .s adm=""  f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d   
	   ..s admdate=$P(^PAADM(adm),"^",6)
	   ..s dischdate=$P(^PAADM(adm),"^",17)
	   ..s mradm=$P(^PAADM(adm),"^",61)
	   ..s disReasondr=$P(^MR(mradm,"PRO",1),"^",10)
	   ..if disReasondr'=""  s deathflag=$P(^PAC("DISCON",disReasondr),"^",3)   
	   ..if admdate=Date s EnertHs(dep,adm)=""
	   ..if dischdate=Date s DischHs(dep,adm)=""
	   ..if (dischdate=Date)&($G(deathflag)="D") s DeathHs(dep,adm)=""
      }

 ///转入，转出
   d ..TranRec(Date,.TranIn,.TranOut)  
 ////////////////////////////////////////////////////////
 // b //MZADM,EZADM,JZLG,EnertHs,DischHs,DeathHs,TranIn,TranOut

 s Typ="O"
 d ..GetOutInPat(Typ,.PatArr)
 s itm="" f  s itm=$O(PatArr(Typ,itm)) q:itm=""  d
 .s itmname=PatArr(Typ,itm)
 .if (itmname["入院") d ..InsertOutIn(itm,.EnertHs,Date)
 .if (itmname["出院") d ..InsertOutIn(itm,.DischHs,Date)
 .if (itmname["死亡") d ..InsertOutIn(itm,.DeathHs,Date)
 .if (itmname["门诊") d ..InsertOutIn(itm,.MZADM,Date)
 .if (itmname["急诊") d ..InsertOutIn(itm,.EZADM,Date)
 .if (itmname["转入") d ..InsertOutIn(itm,.TranIn,Date)
 .if (itmname["转出") d ..InsertOutIn(itm,.TranOut,Date)
 .if (itmname["留观") d ..InsertOutIn(itm,.JZLG,Date)
 //b //99
 q 0
}

ClassMethod InsertOutIn(itm, arrpat, Date)
{
  s num=0
  s a=^User.DHCMGNurWorkItmD(itm)
  s Name=$listget(a,4)
 s loc=""  f  s loc=$O(arrpat(loc)) q:loc=""  d
  .s num=0
  .s adm=""  f  s adm=$O(arrpat(loc,adm)) q:adm=""  d
  ..//d ##class(Nur.DHCMGCurrDayAttenNum).Save(ward, itm,num,Date)
  ..s num=num+1
  ..if Name["门诊" q
  ..if Name["急诊" q
  ..d ##class(Nur.DHCMGCurrDayAttenPat).Save(loc, itm,adm,Date)
  .d ##class(Nur.DHCMGCurrDayAttenNum).Save(loc, itm,num,Date)
}

ClassMethod getAdmTran(date, adm) As %String
{
 //s a=##class(web.DHCMGNurWorkLoad).getAdmTran()
   s prev=""
   s chl=""  f  s chl=$O(^PAADM(adm,"TRANS",chl)) q:chl=""  d
   .s stdate=$P(^PAADM(adm,"TRANS",chl),"^",1)
   .s sttime=$P(^PAADM(adm,"TRANS",chl),"^",2)
   .s enddate=$P(^PAADM(adm,"TRANS",chl),"^",3)
   .s endtime=$P(^PAADM(adm,"TRANS",chl),"^",4)
   .q:stdate=enddate
   .s pward=$P(^PAADM(adm,"TRANS",chl),"^",9)
   .q:pward=""
   .if (pward'=prev) d
   ..s locward=$P(^PAWARD(pward),"^",5)
   ..s zkjl(chl)=locward_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime
   ..//w !,$ZD(stdate,3),"^",$ZT(sttime),"^",$ZD(enddate,3),"^",$ZT(endtime)
   .s prev=pward
   b ///00
   s zrstr=""
   s chl="" f  s chl=$O(zkjl(chl)) q:(chl="")!(zrstr'="")  d
   .s str=zkjl(chl)
   .s stdate=$P(str,"^",2)
   .if stdate=date s zrstr=str_"^"_chl
   s zcstr=""
   s ret=""
   
   if zrstr'=""  
   {
      s curchl=$P(zrstr,"^",6)
      s outchl=$O(zkjl(curchl),-1)
      if outchl'=""
      {
	      s zcstr=zkjl(outchl)
	      s ret=$P(zrstr,"^",1)_"|"_$P(zcstr,"^",1)
	  }
   }
   
   q ret
}

ClassMethod TranRec(Date, TranIn, TranOut)
{
  //s a=##class(web.DHCMGNurWorkLoad).TranRec()
   s st=""  f  s st=$O(^PAADMi("TransDateTime",Date,st)) q:st=""  d
   .s adm="" f  s adm=$O(^PAADMi("TransDateTime",Date,st,adm)) q:adm=""  d
   ..b //000
   ..s ret=..getAdmTran(Date,adm)
   ..//s locward=$P(^PAWARD(pward),"^",5)
   ..if ret'="" d
   ...s zrloc=$P(ret,"|",1),zcloc=$P(ret,"|",2)
   ...s TranIn(zrloc,adm)=""
   ...s TranOut(zcloc,adm)=""
 q
}

ClassMethod GetOutInPat(Typ, PatArr)
{
 //
   s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI("TYP"," "_Typ,rw)) q:rw=""  d
   .s a=^User.DHCMGNurWorkItmD(rw)
   .s Name=$List(a,4)
   .s PatArr(Typ,rw)=Name
}

ClassMethod getflag(adm) As %String
{
 //取留观状态
 
  s flag="Y"
  s av=""  f  s av=$O(^DHCADMVisitStatus(0,"PAADM",adm,av)) q:av=""  d
  .s statdr=$P(^DHCADMVisitStatus(av),"^",2)
  .s statdes=$P(^DHCPACVisitStatus(statdr),"^",1)
  .if "^Discharge^Inhospital^Displace^SalDeath^"[statdes s flag="N"
  q flag
}

ClassMethod getordstat(Oew, itm, Date)
{
 //取医嘱状态
	s flag="N"
	s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,itm,Date,OrdSub)) q:OrdSub=""  d
	.s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	.s OrdStat=""
	.i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)
	.q:OrdStat="D"
	.s flag="Y"
	q flag
}

ClassMethod GetAttenPat(Typ, ord, adm, PatArr, PatNum, Date)
{
   s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI("TYP"," "_Typ,rw)) q:rw=""  d
   .s rel=""  f  s rel=$O(^User.DHCMGNurWorkRelatItmI("WorkItm",rw,rel)) q:rel=""  d
   ..s itm=$listget(^User.DHCMGNurWorkRelatItmD(rel),3)
   ..if $D(^OEORDi(0,"ARCIM",ord,itm,Date)) d
   ...s stat=..getordstat(ord,itm,Date)
   ...q:stat="N"
   ...s PatArr(Typ,rw,adm)=""
   ...s PatNum(rw)=$G(PatNum(rw))+1
}

ClassMethod MakePernum(Date) As %String
{
	 if Date="" s Date=+$H
	 else  s Date=$ZDH(Date,3)
     s depitm=##class(web.DHCMGPERSON).GetSortDep("NUR")
     s l=$L(depitm,"^")
     for i=1:1:l
     {
	    s aa=$P(depitm,"^",i)
	    if aa="" continue
	    s dep=$P(aa,"|"),depdes=$P(aa,"|",2)
	   d ..GetMainPat(dep,Date)
	 }
	// s Date=$ZD(Date,3)
	// d ..MakeAdmData("")
	 q 0
}

ClassMethod MakeWardReportBAK(stdate As %String, enddate As %String, user = "") As %String
{
  //生成日工作量报表 s a=##class(web.DHCMGNurWorkLoad).MakeWardReport("","",""),"2009-02-02",
  // n (stdate,enddate,user)
    s stdate=$ZDH(stdate,3)
    s enddate=$ZDH(enddate,3)
   
    s Typ="W"
    //s stdate=$ZDH("2010-2-11",3)
    //s enddate=$ZDH("2010-2-11",3)
   // w !,stdate,",",enddate
   f Date=stdate:1:enddate
    {
	 s WorkLoad="",NurWork="",LoadItm=""

	  s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI("TYP"," "_Typ,rw)) q:rw=""  d
	  .s wkitmdesc=$listget(^User.DHCMGNurWorkItmD(rw),4)
	  .i wkitmdesc["入院" d ..GetNotOrderNum(Date,Date,.WorkLoad,rw) q
	  .i wkitmdesc["转入" d ..GetNotOrderNum(Date,Date,.WorkLoad,rw) q
	  .i wkitmdesc["分娩" d ..GetNotOrderNum(Date,Date,.WorkLoad,rw) q
	  .//
	  .s typphc=$listget(^User.DHCMGNurWorkItmD(rw),6)
	  .i typphc="I" d
	  ..s stringphc="",firstrel=""
	  ..s rel=""  f  s rel=$O(^User.DHCMGNurWorkRelatItmI("WorkItm",rw,rel)) q:rel=""  d
	  ...s itmphc=$listget(^User.DHCMGNurWorkRelatItmD(rel),4)
	  ...i firstrel="" s firstrel=rel
	  ...i stringphc="" s stringphc="^"_itmphc_"^"
	  ...e  s stringphc=stringphc_itmphc_"^"
	  ..i stringphc'="" d
	  ...d ..GetNurWorkInstruct(stringphc,Date,Date,.NurWork,.WorkLoad,.LoadItm,rw,firstrel)
	  .i typphc="H" d 
	  ..s rel=""  f  s rel=$O(^User.DHCMGNurWorkRelatItmI("WorkItm",rw,rel)) q:rel=""  d
      ...s itm=$listget(^User.DHCMGNurWorkRelatItmD(rel),3)
      ...d ..GetNurWorkHour(itm,Date,Date,.NurWork,.WorkLoad,.LoadItm,rw,rel)
	  .;e  d
	  .i (typphc'="I")&(typphc'="H") d
      ..s rel=""  f  s rel=$O(^User.DHCMGNurWorkRelatItmI("WorkItm",rw,rel)) q:rel=""  d
      ...s itm=$listget(^User.DHCMGNurWorkRelatItmD(rel),3)
      ...d ..GetNurWork(itm,Date,Date,.NurWork,.WorkLoad,.LoadItm,rw,rel)
   if $D(WorkLoad) d ..InsertWork(.NurWork,.WorkLoad,.LoadItm,Date,Date,user)
    }
   q ""
}

ClassMethod MakeWardReportTask() As %String
{
	//s a=##class(web.DHCMGNurWorkLoad).MakeWardReportTask()
	s sysdate=+$h-1
	s sysdate=$zd(sysdate,3)
	s sysdate2=sysdate
	s ab=##class(web.DHCMGNurWorkLoad).MakeWardReport(sysdate,sysdate2,"3901")
    q 0
}

ClassMethod MakeWardReport(stdate As %String, enddate As %String, user = "") As %String
{
  //生成日工作量报表 s a=##class(web.DHCMGNurWorkLoad).MakeWardReport("","",""),"2009-02-02",
  //s a=##class(web.DHCMGNurWorkLoad).MakeWardReport("2012-09-18","2012-09-18","")
  // n (stdate,enddate,user)
    s stdate=$ZDH(stdate,3)
    s enddate=$ZDH(enddate,3)
   
    s Typ="W"
    //s stdate=$ZDH("2010-2-11",3)
    //s enddate=$ZDH("2010-2-11",3)
   // w !,stdate,",",enddate
   f Date=stdate:1:enddate
    {
	 s WorkLoad="",NurWork="",LoadItm=""

	  s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI("TYP"," "_Typ,rw)) q:rw=""  d
	  .s wkitmdesc=$listget(^User.DHCMGNurWorkItmD(rw),4)
	  .i wkitmdesc["入院" d ..GetNotOrderNum(Date,Date,.WorkLoad,rw) q
	  .;i wkitmdesc["转入" d ..GetNotOrderNum(Date,Date,.WorkLoad,rw) q
	  .;i wkitmdesc["分娩" d ..GetNotOrderNum(Date,Date,.WorkLoad,rw) q
	  .//
	  .s typphc=$listget(^User.DHCMGNurWorkItmD(rw),6)
	  .i typphc="I" d
	  ..s stringphc="",firstrel=""
	  ..s rel=""  f  s rel=$O(^User.DHCMGNurWorkRelatItmI("WorkItm",rw,rel)) q:rel=""  d
	  ...s itmphc=$listget(^User.DHCMGNurWorkRelatItmD(rel),4)
	  ...i firstrel="" s firstrel=rel
	  ...i stringphc="" s stringphc="^"_itmphc_"^"
	  ...e  s stringphc=stringphc_itmphc_"^"
	  ..i stringphc'="" d
	  ...d ..GetNurWorkInstruct(stringphc,Date,Date,.NurWork,.WorkLoad,.LoadItm,rw,firstrel)
	  .e  d
      ..s rel=""  f  s rel=$O(^User.DHCMGNurWorkRelatItmI("WorkItm",rw,rel)) q:rel=""  d
      ...s itm=$listget(^User.DHCMGNurWorkRelatItmD(rel),3)
      ...d ..GetNurWork(itm,Date,Date,.NurWork,.WorkLoad,.LoadItm,rw,rel)
   if $D(WorkLoad) d ..InsertWork(.NurWork,.WorkLoad,.LoadItm,Date,Date,user)
    }
   q ""
}

ClassMethod GetNurWorkInstructBAK(stringphc, stdate, enddate, NurWork, WorkLoad, LoadItm, wkitm, subitm)
{
	// n (itm,stdate,enddate,NurWork,WorkLoad,LoadItm,wkitm,subitm)
    f Date=stdate:1:enddate
    {
		s Oew=""  f  s Oew=$O(^OEORDi(0,"StDt",Date,Oew)) q:Oew=""  d
		.s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"StDt",Date,Oew,OrdSub)) q:OrdSub=""  d
		..s phcinId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7) ;OEORI_Instr_DR
		..q:phcinId=""
		..s phcinId="^"_phcinId_"^"
		..q:stringphc'[phcinId
		..s mainorder=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) 
		..q:mainorder'=""
		..s ordStatId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)	//OEORI_ItemStat_DR
    	..s ordStatCode=$P($G(^OEC("OSTAT",+ordStatId)),"^")	//医嘱状态
    	..s XDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  		//停止日期
	   	..s XTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   	//停止时间
    	..s SttTim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)		//开始时间
    	..s arcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 		..s BillingUOMId=$P($G(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
 		..i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
 		..e  s BillingUOMDesc=""
 		..//(当天开当天停或当天停明天的医嘱)且计费单位不是"HOUR"的不统计
		..q:(ordStatCode="D")&(XDate<=Date)&(BillingUOMDesc'="HOUR")
		..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)   	//oeori_Phqtyord  shu liang
		..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     	//OEC_Priority    OEORI_Priority_DR
		..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		..s recdep=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)      	//接收科室
		..s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)	   	//开嘱科室
		..q:UserDep=""                                  //2012-09-04
		..s UserDepType=$P($G(^CTLOC(UserDep)),"^",13)
		..q:"^E^W^"'[UserDepType								//只统计住院科室与病区
		..s UserDepDesc=$P($G(^CTLOC(UserDep)),"^",2)
		..q:UserDepDesc["门诊"
		..s str=""
		..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
		...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
		...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
		...s str=..GetNurWard(CPTExDR)
		..s dep=UserDep,perid=$P(str,"^",3)
		..s curdep=$P(str,"^",1)            //2012-9-05
		..q:perid=""                   //2012-09-04
		..i UserDepType="W" d
		...s linkSub=0 f  s linkSub=$o(^CTLOC(UserDep,"LINK",linkSub)) q:linkSub=""  d
		....s dep=$G(^CTLOC(UserDep,"LINK",linkSub))			//护士医嘱记到科室
		..s dep=curdep      //2012-9-05
		..q:dep=""
		..s dnum=1,num=PhQtyOrd
		..if PriorDes["长" s hnum=24
		..e  s hnum=PhQtyOrd
		..//按小时收费的医嘱,结束时间-开始时间,无结束时间为0
		..i BillingUOMDesc="HOUR" d
		...i XTime'="",XTime>=SttTim s hnum=(XTime-SttTim)/3600
		...e  s hnum=0
		..d CalNum1Instruct(dnum,hnum,num,wkitm,perid,dep,subitm)
        s Oew=""  f  s Oew=$O(^OEORDi(0,"DHCXDate",Date,Oew)) q:Oew=""  d
		.s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"DHCXDate",Date,Oew,OrdSub)) q:OrdSub=""  d
		..s phcinId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7) ;OEORI_Instr_DR
		..q:phcinId=""
		..s phcinId="^"_phcinId_"^"
		..q:stringphc'[phcinId
		..s mainorder=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) 
		..q:mainorder'=""
	   	..s SttDat=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)		//开始日期
    	..s arcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 		..s BillingUOMId=$P($G(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
 		..i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
 		..e  s BillingUOMDesc=""
 		..//当天开当天停或当天停明天的医嘱或计费单位是"HOUR"的不统计
		..q:(SttDat>=Date)!(BillingUOMDesc="HOUR")
		..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)   	//oeori_Phqtyord  shu liang
		..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     	//OEC_Priority    OEORI_Priority_DR
		..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		..e  s PriorDes=""
		..s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)	   	//开嘱科室
		..s str=""
		..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
		...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
		...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
		...s str=..GetNurWard(CPTExDR)
		..s dep=UserDep,perid=$P(str,"^",3)
		..s curdep=$P(str,"^",1)            //2012-9-05
		..s dep=curdep
		..q:dep=""
		..q:perid=""                   //2012-09-04
		..s dnum=-1,num=(-1)*PhQtyOrd
		..if PriorDes["长" s hnum=-24
		..e  s hnum=(-1)*PhQtyOrd
		..d CalNum1Instruct(dnum,hnum,num,wkitm,perid,dep,subitm)	
	
    }
   q 0
CalNum1Instruct(dnum,hnum,num,witm,perid,dep,itm)
   s a=^User.DHCMGNurWorkItmD(witm)
   s styp=$List(a,3)
   s Reltyp=$List(a,6)
   s percent=$ListGet(a,5)
   s flag=$List(a,7)
   q:flag="N"  //不可用
   q:styp'="W" //
   if Reltyp="D" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+dnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+dnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+dnum
   if Reltyp="H" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+hnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+hnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+hnum
   if Reltyp="N" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
   if Reltyp="I" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
 q
}

ClassMethod GetNurWorkInstruct(stringphc, stdate, enddate, NurWork, WorkLoad, LoadItm, wkitm, subitm)
{
	// n (itm,stdate,enddate,NurWork,WorkLoad,LoadItm,wkitm,subitm)
    f Date=stdate:1:enddate
    {
		s Oew=""  f  s Oew=$O(^OEORDi(0,"StDt",Date,Oew)) q:Oew=""  d
		.s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"StDt",Date,Oew,OrdSub)) q:OrdSub=""  d
		..s phcinId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7) ;OEORI_Instr_DR
		..q:phcinId=""
		..s phcinId="^"_phcinId_"^"
		..q:stringphc'[phcinId
		..s mainorder=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) 
		..q:mainorder'=""
		..s ordStatId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)	//OEORI_ItemStat_DR
    	..s ordStatCode=$P($G(^OEC("OSTAT",+ordStatId)),"^")	//医嘱状态
    	..s XDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  		//停止日期
	   	..s XTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   	//停止时间
    	..s SttTim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)		//开始时间
    	..s arcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 		..s BillingUOMId=$P($G(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
 		..i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
 		..e  s BillingUOMDesc=""
 		..//(当天开当天停或当天停明天的医嘱)且计费单位不是"HOUR"的不统计
		..q:(ordStatCode="D")&(XDate<=Date)&(BillingUOMDesc'="HOUR")
		..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)   	//oeori_Phqtyord  shu liang
		..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     	//OEC_Priority    OEORI_Priority_DR
		..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		..s recdep=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)      	//接收科室
		..s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)	   	//开嘱科室
		..q:UserDep=""                                  //2012-09-04
		..s UserDepType=$P($G(^CTLOC(UserDep)),"^",13)
		..q:"^E^W^"'[UserDepType								//只统计住院科室与病区
		..s UserDepDesc=$P($G(^CTLOC(UserDep)),"^",2)
		..q:UserDepDesc["门诊"
		..s str=""
		..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
		...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
		...q:CPTExDR=""
		...s oeoreXdate2=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",12)
		...q:oeoreXdate2'=""
		...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
		...s str=..GetNurWard(CPTExDR)
		...s dep=UserDep,perid=$P(str,"^",3)
		...s curdep=$P(str,"^",1)            //2012-9-05
		...q:perid=""                       //2012-09-04
		...s dep=curdep                     //2012-9-05
		...q:dep=""
		...s dnum=1,num=1             //2012-9-12 修改以下的
		...;if PriorDes["长" s hnum=24
		...;e  s hnum=PhQtyOrd
		...s hnum=1
		...d CalNum2Instruct(dnum,hnum,num,wkitm,perid,dep,subitm)
    }
   q 0
CalNum2Instruct(dnum,hnum,num,witm,perid,dep,itm)
   s a=^User.DHCMGNurWorkItmD(witm)
   s styp=$List(a,3)
   s Reltyp=$List(a,6)
   s percent=$ListGet(a,5)
   s flag=$List(a,7)
   q:flag="N"  //不可用
   q:styp'="W" //
   if Reltyp="D" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+dnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+dnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+dnum
   if Reltyp="H" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+hnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+hnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+hnum
   if Reltyp="N" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
   if Reltyp="I" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
 q
}

ClassMethod GetNurWorkBAK(itm, stdate, enddate, NurWork, WorkLoad, LoadItm, wkitm, subitm)
{
	// n (itm,stdate,enddate,NurWork,WorkLoad,LoadItm,wkitm,subitm)
    f Date=stdate:1:enddate
    {
		s Oew=""  f  s Oew=$O(^OEORDi(0,"StDt",Date,Oew)) q:Oew=""  d
		.s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,itm,Date,OrdSub)) q:OrdSub=""  d
		..s ordStatId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)	//OEORI_ItemStat_DR
    	..s ordStatCode=$P($G(^OEC("OSTAT",+ordStatId)),"^")	//医嘱状态
    	..s XDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  		//停止日期
	   	..s XTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   	//停止时间
    	..s SttTim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)		//开始时间
    	..s arcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 		..s BillingUOMId=$P($G(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
 		..i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
 		..e  s BillingUOMDesc=""
 		..//(当天开当天停或当天停明天的医嘱)且计费单位不是"HOUR"的不统计
		..q:(ordStatCode="D")&(XDate<=Date)&(BillingUOMDesc'="HOUR")
		..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)   	//oeori_Phqtyord  shu liang
		..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     	//OEC_Priority    OEORI_Priority_DR
		..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		..s recdep=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)      	//接收科室
		..s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)	   	//开嘱科室
		..q:UserDep=""                                  //2012-09-04
		..s UserDepType=$P($G(^CTLOC(UserDep)),"^",13)
		..q:"^E^W^"'[UserDepType								//只统计住院科室与病区
		..s UserDepDesc=$P($G(^CTLOC(UserDep)),"^",2)
		..q:UserDepDesc["门诊"
		..s str=""
		..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
		...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
		...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
		...s str=..GetNurWard(CPTExDR)
		..s dep=UserDep,perid=$P(str,"^",3)
		..s curdep=$P(str,"^",1)            //2012-9-05
		..i UserDepType="W" d
		...s linkSub=0 f  s linkSub=$o(^CTLOC(UserDep,"LINK",linkSub)) q:linkSub=""  d
		....s dep=$G(^CTLOC(UserDep,"LINK",linkSub))			//护士医嘱记到科室
		..s dep=curdep            //2012-9-05
		..q:dep=""
		..s dnum=1,num=PhQtyOrd
		..if PriorDes["长" s hnum=24
		..e  s hnum=PhQtyOrd
		..//按小时收费的医嘱,结束时间-开始时间,无结束时间为0
		..i BillingUOMDesc="HOUR" d
		...i XTime'="",XTime>=SttTim s hnum=(XTime-SttTim)/3600
		...e  s hnum=0
		..d CalNum1(dnum,hnum,num,wkitm,perid,dep,subitm)

		s Oew=""  f  s Oew=$O(^OEORDi(0,"DHCXDate",Date,Oew)) q:Oew=""  d
		.s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,itm,Date,OrdSub)) q:OrdSub=""  d
	   	..s SttDat=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)		//开始日期
    	..s arcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 		..s BillingUOMId=$P($G(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
 		..i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
 		..e  s BillingUOMDesc=""
 		..//当天开当天停或当天停明天的医嘱或计费单位是"HOUR"的不统计
		..q:(SttDat>=Date)!(BillingUOMDesc="HOUR")
		..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)   	//oeori_Phqtyord  shu liang
		..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     	//OEC_Priority    OEORI_Priority_DR
		..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		..e  s PriorDes=""
		..s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)	   	//开嘱科室
		..s str=""
		..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
		...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
		...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
		...s str=..GetNurWard(CPTExDR)
		..s dep=UserDep,perid=$P(str,"^",3)
		..s curdep=$P(str,"^",1)            //2012-9-05
		..s dep=curdep
		..q:dep=""
		..s dnum=-1,num=(-1)*PhQtyOrd
		..if PriorDes["长" s hnum=-24
		..e  s hnum=(-1)*PhQtyOrd
		..d CalNum1(dnum,hnum,num,wkitm,perid,dep,subitm)	
    }
   q 0
CalNum1(dnum,hnum,num,witm,perid,dep,itm)
   s a=^User.DHCMGNurWorkItmD(witm)
   s styp=$List(a,3)
   s Reltyp=$List(a,6)
   s percent=$ListGet(a,5)
   s flag=$List(a,7)
   q:flag="N"  //不可用
   q:styp'="W" //
   if Reltyp="D" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+dnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+dnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+dnum
   if Reltyp="H" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+hnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+hnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+hnum
   if Reltyp="N" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
 q
}

ClassMethod GetNurWork(itm, stdate, enddate, NurWork, WorkLoad, LoadItm, wkitm, subitm)
{
	// n (itm,stdate,enddate,NurWork,WorkLoad,LoadItm,wkitm,subitm)
    f Date=stdate:1:enddate
    {
		s Oew=""  f  s Oew=$O(^OEORDi(0,"StDt",Date,Oew)) q:Oew=""  d
		.s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,itm,Date,OrdSub)) q:OrdSub=""  d
		..s ordStatId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)	//OEORI_ItemStat_DR
    	..s ordStatCode=$P($G(^OEC("OSTAT",+ordStatId)),"^")	//医嘱状态
    	..s XDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  		//停止日期
	   	..s XTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   	//停止时间
    	..s SttTim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)		//开始时间
    	..s arcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 		..s BillingUOMId=$P($G(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
 		..i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
 		..e  s BillingUOMDesc=""
 		..//(当天开当天停或当天停明天的医嘱)且计费单位不是"HOUR"的不统计
		..;q:(ordStatCode="D")&(XDate<=Date)&(BillingUOMDesc'="HOUR")
		..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)   	//oeori_Phqtyord  shu liang
		..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     	//OEC_Priority    OEORI_Priority_DR
		..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		..s recdep=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)      	//接收科室
		..s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)	   	//开嘱科室
		..q:UserDep=""                                  //2012-09-04
		..s UserDepType=$P($G(^CTLOC(UserDep)),"^",13)
		..q:"^E^W^"'[UserDepType								//只统计住院科室与病区
		..//i (Oew="29")&(OrdSub="19") b //56
		..s UserDepDesc=$P($G(^CTLOC(UserDep)),"^",2)
		..q:UserDepDesc["门诊"
		..s str=""
		..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
		...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
		...s oeoreXdate2=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",12)
		...q:oeoreXdate2'=""
		...;i (CPTExDR="1016")&(itm="25946||1") b //333
		...;i (CPTExDR="1016")&(itm="30139||1") b //555
		...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
		...s str=..GetNurWard(CPTExDR)
		...s dep=UserDep,perid=$P(str,"^",3)
		...s curdep=$P(str,"^",1)            //2012-9-05
		...q:perid=""                   //2012-09-04
		...s dep=curdep      //2012-9-05
		...q:dep=""
		...//i (Oew="29")&(OrdSub="19") b //569
		...s dnum=1,num=1             //2012-9-12 修改以下的
		...;if PriorDes["长" s hnum=24
		...;e  s hnum=PhQtyOrd
		...s hnum=1
		...d CalNum2NurWork(dnum,hnum,num,wkitm,perid,dep,subitm)

    }
   q 0
CalNum2NurWork(dnum,hnum,num,witm,perid,dep,itm)
   s a=^User.DHCMGNurWorkItmD(witm)
   s styp=$List(a,3)
   s Reltyp=$List(a,6)
   s percent=$ListGet(a,5)
   s flag=$List(a,7)
   q:flag="N"  //不可用
   q:styp'="W" //
   //i witm=13 b //12345a
   if Reltyp="D" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+dnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+dnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+dnum
   if Reltyp="H" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+hnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+hnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+hnum
   if Reltyp="N" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
 q
}

ClassMethod GetNurWorkHour(itm, stdate, enddate, NurWork, WorkLoad, LoadItm, wkitm, subitm)
{
	// n (itm,stdate,enddate,NurWork,WorkLoad,LoadItm,wkitm,subitm)
    f Date=stdate:1:enddate
    {
		s Oew=""  f  s Oew=$O(^OEORDi(0,"StDt",Date,Oew)) q:Oew=""  d
		.;s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"StDt",Date,Oew,OrdSub)) q:OrdSub=""  d
		.s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,itm,Date,OrdSub)) q:OrdSub=""  d
		..;s phcinId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7) ;OEORI_Instr_DR
		..;q:phcinId=""
		..;s phcinId="^"_phcinId_"^"
		..;q:stringphc'[phcinId
		..;s mainorder=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) 
		..;q:mainorder'=""
		..s ordStatId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)	//OEORI_ItemStat_DR
    	..s ordStatCode=$P($G(^OEC("OSTAT",+ordStatId)),"^")	//医嘱状态
    	..s XDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  		//停止日期
	   	..s XTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   	//停止时间
    	..s SttTim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)		//开始时间
    	..s arcimId=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
 		..s BillingUOMId=$P($G(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
 		..i BillingUOMId'="" s BillingUOMDesc=$P($G(^CT("UOM",BillingUOMId)),"^",2)
 		..e  s BillingUOMDesc=""
 		..//(当天开当天停或当天停明天的医嘱)且计费单位不是"HOUR"的不统计
		..q:(ordStatCode="D")&(XDate<=Date)&(BillingUOMDesc'="HOUR")
		..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)   	//oeori_Phqtyord  shu liang
		..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     	//OEC_Priority    OEORI_Priority_DR
		..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		..s recdep=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)      	//接收科室
		..s UserDep=$p($g(^OEORD(Oew,"I",OrdSub,7)),"^",2)	   	//开嘱科室
		..q:UserDep=""                                  //2012-09-04
		..s UserDepType=$P($G(^CTLOC(UserDep)),"^",13)
		..q:"^E^W^"'[UserDepType								//只统计住院科室与病区
		..s UserDepDesc=$P($G(^CTLOC(UserDep)),"^",2)
		..q:UserDepDesc["门诊"
		..s phfreq=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",4)
	    ..s phfreqFactor=""          ;要索 
	    ..i phfreq'="" d
	    ...s phfreqFactor=$p($g(^PHCFR(phfreq)),"^",2)
	    ...;s phfreq=$p($g(^PHCFR(phfreq)),"^",1)
	    ..;i phfreqFactor="" s phfreqFactor=1
	    ..;q:phfreqFactor=""
		..s str=""
		..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
		...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
		...q:CPTExDR=""
		...s oeoreXdate2=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",12)
		...q:oeoreXdate2'=""
		...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
		...s str=..GetNurWard(CPTExDR)
		...s dep=UserDep,perid=$P(str,"^",3)
		...s curdep=$P(str,"^",1)            //2012-9-05
		...q:perid=""                   //2012-09-04
		...s dep=curdep      //2012-9-05
		...q:dep=""
		...s dnum=1,num=1             //2012-9-12 修改以下的
		...;if PriorDes["长" s hnum=24
		...;e  s hnum=PhQtyOrd
		...s hnum=1
		...;s hnum=(24/phfreqFactor)
		...d CalNum2Hour(dnum,hnum,num,wkitm,perid,dep,subitm)
    }
   q 0
CalNum2Hour(dnum,hnum,num,witm,perid,dep,itm)
   s a=^User.DHCMGNurWorkItmD(witm)
   s styp=$List(a,3)
   s Reltyp=$List(a,6)
   s percent=$ListGet(a,5)
   s flag=$List(a,7)
   q:flag="N"  //不可用
   q:styp'="W" //
   if Reltyp="D" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+dnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+dnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+dnum
   if Reltyp="H" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+hnum
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+hnum
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+hnum
   if Reltyp="N" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
   if Reltyp="I" d
   .s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   .i perid'="" s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .s LoadItm(dep,witm,itm)=$G(LoadItm(dep,witm,itm))+num
 q
}

ClassMethod MakeReport(dep As %String, stdate As %String, enddate As %String, user = "")
{
  //生成工作量报表 s a=##class(web.DHCMGNurWorkLoad).MakeReport("","2009-02-02",
  // n (dep,stdate,enddate,user)
   // s stdate=$ZDH(stdate,3)
   // s enddate=$ZDH(enddate,3)
    s stdate=$ZDH("2010-1-30",3)
    s enddate=$ZDH("2010-1-30",3)
    w !,stdate,",",enddate
    s WorkLoad="",NurWork=""
    f date=stdate:1:enddate
    {
       s Oew=""  f  s Oew=$O(^OEORDi(0,"StDt",date,Oew)) q:Oew=""  d
	   .s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"StDt",date,Oew,OrdSub)) q:OrdSub=""  d
	   ..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   ..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	   ..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
       ..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	   ..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
       ..s retstr=..IFGet(ArcimDR,"")
	   ..s Meth=""
	   ..i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	   ..//w !,Meth
	   ..s flag=$P(retstr,"^"),itm=$P(retstr,"^",3),typ=$P(retstr,"^",2)
	   ..q:flag="N"
	   ..//w !,itm
	   ..s workitm=..GetWorkItm(itm)
	   ..//if Meth="iv.gtt" b
	   ..q:workitm=""
	   ..s exchl=""  f  s exchl=$O(^OEORD(Oew,"I",OrdSub,"X",exchl)) q:exchl=""  d
	   ...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",1) //i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	   ...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",2)  //i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	   ...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",exchl),"^",15)
	   ...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)  
	   ...q:CPTExDR=""
	   ...//q:(DateEx>enddate)!(DateEx<stdate)
	   ...s str=..GetNurWard(CPTExDR)
	   ...//w !,str
	   ...//b //str
	   ...q:str=""
	   ...//w !,Oew,"||",OrdSub,"CPTExDR",CPTExDR
	   ...s dep=$P(str,"^"),ssdr=$P(str,"^",2),perid=$P(str,"^",3)
	   ...q:dep=""
	   ...if itm="2569||1" s jm=$G(jm)+1 b
	   ...w !,$G(jm)
	   ...s dnum=1,num=PhQtyOrd
	   ...if PriorDes["长" s hnum=24
	   ...e  s hnum=PhQtyOrd
	   ...d CalNum(dnum,hnum,num,itm,perid,dep)
    }
   if $D(WorkLoad) d ..InsertWork(.NurWork,.WorkLoad,stdate,enddate,user)
   q 0
CalNum(dnum,hnum,num,itm,perid,dep)
   s rel="" f  s rel=$O(^User.DHCMGNurWorkRelatItmI("ItmArcimInstr"," "_itm,rel)) q:rel=""  d
   .q:rel=""  
   .s a=^User.DHCMGNurWorkRelatItmD(rel)
   .s witm=$list(a,2)
   .s a=^User.DHCMGNurWorkItmD(witm)
   .s styp=$List(a,3)
   .s Reltyp=$List(a,6)
   .s percent=$ListGet(a,5)
   .s flag=$List(a,7)
   .q:flag="Y"  //不可用
   .q:styp'="W" //
   .if Reltyp="D" d
   ..s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+dnum
   ..s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+dnum
   .if Reltyp="H" d
   ..s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+hnum
   ..s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+hnum
   .if Reltyp="N" d
   ..s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   ..s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   .if Reltyp="I" d
   ..s WorkLoad(dep,witm)=$G(WorkLoad(dep,witm))+num
   ..s NurWork(dep,perid,witm)=$G(NurWork(dep,perid,witm))+num
   ..
  q
}

ClassMethod DelRp(rp) As %String
{
 //删除月报
	    s pa=""  f  s pa=$O(^Nur.DHCMGNurWardMonRpI("WorkRp",rp,pa)) q:pa=""  d
	    .d ##class(Nur.DHCMGNurWardMonRp).%DeleteId(pa)
     	d ##class(Nur.DHCMGWorkRp).del(rp)
	    q 0
}

ClassMethod DelDayRp(date) As %String
{
 //删除日报数据
     s date=$ZDH(date,3)
     s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpI("StDate",date,rw)) q:rw=""  d
     .d ##class(Nur.DHCMGNurWorkRp).%DeleteId(rw)
     q 0
}

ClassMethod InsertWork(NurWork, WorkLoad, LoadItm, stdate, enddate, user) As %String
{
	  //if id'="" s a=##class(User.DHCMGSuckleWoman).%OpenId(id)
   // n (NurWork,WorkLoad,LoadItm,stdate,enddate,user)
   // s workRp=##class(Nur.DHCMGWorkRp).Save(stdate,enddate,"","","")
      //e  s a=##class(User.DHCMGSuckleWoman).%New()
   // s $ZT="ERROR^DHCSSERR"
    TSTART
     s ward=""  f  s ward=$O(WorkLoad(ward)) q:ward=""  d
     .s Rep=##class(Nur.DHCMGNurWorkRp).%New()
     .s Rep.WorkDepDr=ward
     .//w !,$P(^CTLOC(ward),"^",2)
     .s Rep.WorkStDate=stdate 
     .s Rep.WorkEndDate=enddate
     .//s Rep.WorkCreateUser=user
     .s Rep.WorkCreateDate=+$H
     .s Rep.WorkCreatTime=$P($H,",",2)
     .//s Rep.WorkRp=workRp
     .if $$$ISOK(Rep) d
     ..d Rep.%Save()
     ..d Rep.%Close()
     .//k Rep
     .e  d
     ..TROLLBACK 
     .s Itm="" f  s Itm=$O(WorkLoad(ward,Itm)) q:Itm=""  d
     ..s RepWard=##class(Nur.DHCMGNurWorkRpWard).%New()
     ..s RepWard.WardParref=Rep
     ..s RepWard.WardWorkItm=##class(User.DHCMGNurWorkItm).%OpenId(Itm)
     ..i $L(WorkLoad(ward,Itm),".")>1 d
     ...s RepWard.WardWorkNum=$fn(WorkLoad(ward,Itm),"",2)
     ..e  d
     ...s RepWard.WardWorkNum=WorkLoad(ward,Itm)
     ..s WorkPercent=RepWard.WardWorkItm.WorkPercent
     ..//工作量项目有对应科室,则取对应科室的分值,分值为0直接取对应科室权重
     ..s rw=""  f  s rw=$O(^User.DHCMGNurWorkRelatDepI("WorkItm",Itm,rw)) q:rw=""  d
     ...s a=^User.DHCMGNurWorkRelatDepD(rw)
     ...s curRelDep=$ListGet(a,3)
     ...s curRelDepPercent=$ListGet(a,4)
     ...i curRelDep=ward d
     ....i WorkPercent=0 s WorkPercent=curRelDepPercent
     ....e  s WorkPercent=WorkPercent*curRelDepPercent
     ..s RepWard.WardWorkCount=$fn(WorkLoad(ward,Itm)*WorkPercent,"",2)
     ..if $$$ISOK(RepWard) d
     ...d RepWard.%Save()
     ...s subitm="" f  s subitm=$O(LoadItm(ward,Itm,subitm)) q:subitm=""  d
     ....s item=##class(Nur.DHCMGNurWorkRpSubItmData).%New()
     ....s item.WorkRpWardParref=RepWard
     ....s item.SubItm=subitm
     ....i $L(LoadItm(ward,Itm,subitm),".")>1 d
     .....s item.SubItmNum=$fn(LoadItm(ward,Itm,subitm),"",2)
     ....e  d
     .....s item.SubItmNum=LoadItm(ward,Itm,subitm)
     ....d item.%Save()
     ...d RepWard.%Close()
     ..e  TROLLBACK
     .s perid=""  f  s perid=$O(NurWork(ward,perid)) q:perid=""  d
     ..s workitm=""  f  s workitm=$O(NurWork(ward,perid,workitm)) q:workitm=""  d
     ...s RepSub=##class(Nur.DHCMGNurWorkRpSub).%New()
     ...s RepSub.WorkRpParef=Rep
     ... //bWorkRpParef
     ...s RepSub.WorkRpSubItmDR=##class(User.DHCMGNurWorkItm).%OpenId(workitm)
     ... //bWorkRpSubItmDR
     ...i $L(NurWork(ward,perid,workitm),".")>1 d
     ....s RepSub.WorkRpSubNum=$fn(NurWork(ward,perid,workitm),"",2)
     ...e  d
     ....s RepSub.WorkRpSubNum=NurWork(ward,perid,workitm)
     ...s WorkPercent=RepSub.WorkRpSubItmDR.WorkPercent
     ...//工作量项目有对应科室,则取对应科室的分值,分值为0直接取对应科室权重
     ...s rw=""  f  s rw=$O(^User.DHCMGNurWorkRelatDepI("WorkItm",workitm,rw)) q:rw=""  d
     ....s a=^User.DHCMGNurWorkRelatDepD(rw)
     ....s curRelDep=$ListGet(a,3)
     ....s curRelDepPercent=$ListGet(a,4)
     ....i curRelDep=ward d
     .....i WorkPercent=0 s WorkPercent=curRelDepPercent
     .....e  s WorkPercent=WorkPercent*curRelDepPercent
     ...s RepSub.WorkRpSubCount=$fn(NurWork(ward,perid,workitm)*WorkPercent,"",2)
     ...s RepSub.WorkRpSubExNurDr=perid
     ...if $$$ISOK(RepSub) d
     ....d RepSub.%Save()
     ....d RepSub.%Close() 
     ...e  TROLLBACK
     TCOMMIT
     q 0
}

ClassMethod IFGet(ArcimDR As %String, MethDR As %String) As %String
{
  
   //n (ArcimDR ,MethDR)
	s flag="N",itm="",typ=""
	if $D(^User.DHCMGNurWorkRelatItmI("ItmArcimInstr"," "_ArcimDR)) d
	. s flag="Y"
	. s itm=ArcimDR, typ="O"
    if MethDR=""  q flag_"^"_typ_"^"_itm
    if $D(^User.DHCMGNurWorkRelatItmI("ItmArcimInstr"," "_MethDR)) d
    .s flag="Y", itm=MethDR,typ="I"
    q flag_"^"_typ_"^"_itm
}

ClassMethod GetWorkItm(arcid As %String) As %String
{
 //工作量项目id
  // n (arcid)
   s rel="" s rel=$O(^User.DHCMGNurWorkRelatItmI("ItmArcimInstr"," "_arcid,rel))
   q:rel="" ""
   s a=^User.DHCMGNurWorkRelatItmD(rel)
   s itm=$list(a,2)
   q itm
}

ClassMethod GetNurWard(NurDr As %String) As %String
{
  // n (NurDr)
    //  q "830"_"^"_"^^"
   q:NurDr="" ""
   s ssdr="" s ssdr=$O(^SSU("SSUSR",0,"CTPCP",NurDr,ssdr))
   //w !,NurDr
   q:ssdr="" ""
   s perid="" s perid=$O(^User.DHCMGPersonsI("SSDR"," "_ssdr,perid))
   q:perid="" ""
   s a=^User.DHCMGPersonsD(perid)
   s dep=$list(a,7)
   q dep_"^"_ssdr_"^"_perid
}

ClassMethod GetWorkNurRpExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 //	s ^TMP("kk")=par
   // s par="^2010-01-01^2010-01-03"
    s dep=$P(par,"^",1)
    s stdate=$P(par,"^",2)
    s eddate=$P(par,"^",3)
    s stdate=$ZDH(stdate,3)
    s eddate=$ZDH(eddate,3)
    f date=stdate:1:eddate
    {
     s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpI("StDate",date,rw)) q:rw=""  d
     .s loc=$list(^Nur.DHCMGNurWorkRpD(rw),5)
     .q:(dep'=loc)&(dep'="")
     .s depdes=$P(^CTLOC(loc),"^",2)
     .s sdate=$list(^Nur.DHCMGNurWorkRpD(rw),7)
     .s sdate=$ZD(sdate,3)
     .s edate=$list(^Nur.DHCMGNurWorkRpD(rw),6)
     .s edate=$ZD(edate,3)
     .s creatdate=$list(^Nur.DHCMGNurWorkRpD(rw),3)
     .s createdate=$ZD(creatdate,3)
     .s creattime=$list(^Nur.DHCMGNurWorkRpD(rw),2)
     .s createtime=$ZT(creattime)
     .s user=""  //$list(^Nur.DHCMGNurWorkRpD(rw),4)
     .s mem=$list(^Nur.DHCMGNurWorkRpD(rw),8)
     .d out
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out
	set Data=$lb(depdes,sdate,edate,createdate,createtime,mem,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWorkNurRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkNurRpExecute ]
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
}

ClassMethod GetWorkNurRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkNurRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWorkNurRp(parr As %String) As %Query(ROWSPEC = "depdes,sdate,edate,createdate,createtime,mem,rw")
{
}

ClassMethod GetWorkItmNumExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
   
     s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw)) q:rw=""  d
     .s itm=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw),4)
     .s a=##class(User.DHCMGNurWorkItm).%OpenId(itm)
     .s itmname=a.WorkItm
     .s num=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw),5)
     .s count=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw),3)
     .d out1
     s ^TMP("web.DHCMGNurWorkLoad:GetWorkItmNum")=ind
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out1
	set Data=$lb(itmname,num,count,itm,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWorkItmNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkItmNumExecute ]
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
}

ClassMethod GetWorkItmNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkItmNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWorkItmNum(parr As %String) As %Query(ROWSPEC = "itmname:%String,num:%String,count:%String,itm:%String,rw:%String")
{
}

ClassMethod GetWorkItmNurNumExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
   
     s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw)) q:rw=""  d
     .s itm=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),4)
     .s nur=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),3)
     .s parr=^User.DHCMGPersonsD(nur)
     .s Nurse=$list(parr, 21)
     .s a=##class(User.DHCMGNurWorkItm).%OpenId(itm)
     .s itmname=a.WorkItm
     .s num=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),5)
     .s count=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),2)
     .d out11
     s ^TMP("web.DHCMGNurWorkLoad:GetWorkItmNurNum")=ind
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out11
	set Data=$lb(Nurse,itmname,num,count,itm,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWorkItmNurNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkItmNurNumExecute ]
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
}

ClassMethod GetWorkItmNurNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkItmNurNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWorkItmNurNum(parr As %String) As %Query(ROWSPEC = "Nurse,itmname,num,count,itm,rw")
{
}

ClassMethod CreatRp(stdate, edate, user, mon, mem = "", typ) As %String
{
  //s a=##class(web.DHCMGNurWorkLoad).CreatRp()
 // n (stdate, edate, user, title, mem )
       s NurWork="", WorkLoad="", LoadItm=""
       //s stdate=$ZDH("2010-01-01",3)
       //s edate=$ZDH("2010-01-20",3)
       s stdate=$ZDH(stdate,3)
       s edate=$ZDH(edate,3)

	    f Date=stdate:1:edate
	    {
		     s par=""  f  s par=$O(^Nur.DHCMGNurWorkRpI("StDate",Date,par)) q:par=""  d
		     .s loc=$list(^Nur.DHCMGNurWorkRpD(par),5)
			 .s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw)) q:rw=""  d
			 ..s itm=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw),4)
			 ..s num=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw),5)
			 ..s count=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw),3)
			 ..s WorkLoad(loc,itm)=$G(WorkLoad(loc,itm))+num
			 ..s sub=""  f  s sub=$O(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw,"ChildItmData",sub)) q:sub=""  d
			 ...s subitm=$List(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw,"ChildItmData",sub),2)
			 ...s subnum=$List(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpWard",rw,"ChildItmData",sub),3)
			 ...s LoadItm(loc,itm,subitm)=$G(LoadItm(loc,itm,subitm))+subnum
			 .s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw)) q:rw=""  d
		     ..s itm=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),4)
		     ..s nur=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),3)
		     ..s num=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),5)
		     ..s count=$list(^Nur.DHCMGNurWorkRpD(par,"ChildDHCMGNurWorkRpSub",rw),2)
		     ..s NurWork(loc,nur,itm)=$G(NurWork(loc,nur,itm))+num
	   }
	   b //dd
	 if $D(WorkLoad) d ..InsertMonWork(.NurWork,.WorkLoad,.LoadItm,stdate,edate,user,mon,mem,typ)
 q 0
}

ClassMethod InsertMonWork(NurWork, WorkLoad, LoadItm, stdate, enddate, user, mon, mem, typ) As %String
{
	  //if id'="" s a=##class(User.DHCMGSuckleWoman).%OpenId(id)
   // n (NurWork,WorkLoad,LoadItm,stdate,enddate,user,Title)
    s workRp=##class(Nur.DHCMGWorkRp).Save(stdate,enddate,mon,mem,typ,user)
      //e  s a=##class(User.DHCMGSuckleWoman).%New()
    b
    //s $ZT="ERROR^DHCSSERR"
    TSTART
     s ward=""  f  s ward=$O(WorkLoad(ward)) q:ward=""  d
     .s Rep=##class(Nur.DHCMGNurWardMonRp).%New()
     .s Rep.WorkDepDr=ward
     .//w !,$P(^CTLOC(ward),"^",2)
     .s Rep.WorkStDate=stdate 
     .s Rep.WorkEndDate=enddate
     .//s Rep.WorkCreateUser=user
     .s Rep.WorkCreateDate=+$H
     .s Rep.WorkCreatTime=$P($H,",",2)
     .s Rep.WorkRp=workRp
     .if $$$ISOK(Rep) d
     ..d Rep.%Save()
     ..d Rep.%Close()
     .//k Rep
     .e  d
     ..TROLLBACK 
     .s Itm="" f  s Itm=$O(WorkLoad(ward,Itm)) q:Itm=""  d
     ..s RepWard=##class(Nur.DHCMGNurWardMonSub).%New()
     ..s RepWard.WardParref=Rep
     ..s RepWard.WardWorkItm=##class(User.DHCMGNurWorkItm).%OpenId(Itm)
     ..s RepWard.WardWorkNum=WorkLoad(ward,Itm)
     ..s RepWard.WardWorkCount=WorkLoad(ward,Itm)*RepWard.WardWorkItm.WorkPercent
     ..if $$$ISOK(RepWard) d
     ...d RepWard.%Save()
     ...s subitm="" f  s subitm=$O(LoadItm(ward,Itm,subitm)) q:subitm=""  d
     ....s item=##class(Nur.DHCMGNurWardMonSubItm).%New()
     ....s item.WorkRpWardParref=RepWard
     ....s item.SubItm=subitm
     ....s item.SubItmNum=LoadItm(ward,Itm,subitm)
     ....d item.%Save()
     ...d RepWard.%Close()
     ..e  TROLLBACK
     .s perid=""  f  s perid=$O(NurWork(ward,perid)) q:perid=""  d
     ..s workitm=""  f  s workitm=$O(NurWork(ward,perid,workitm)) q:workitm=""  d
     ...s RepSub=##class(Nur.DHCMGNurWardMonSubPer).%New()
     ...s RepSub.WorkRpParef=Rep
     ... //bWorkRpParef
     ...s RepSub.WorkRpSubItmDR=##class(User.DHCMGNurWorkItm).%OpenId(workitm)
     ... //bWorkRpSubItmDR
     ...s RepSub.WorkRpSubNum=NurWork(ward,perid,workitm)
     ...s RepSub.WorkRpSubCount=NurWork(ward,perid,workitm)*RepSub.WorkRpSubItmDR.WorkPercent
     ...s RepSub.WorkRpSubExNurDr=perid
     ...if $$$ISOK(RepSub) d
     ....d RepSub.%Save()
     ....d RepSub.%Close() 
     ...e  TROLLBACK
     TCOMMIT
     b //com
     q 0
}

ClassMethod GetSchWardRpExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
    s stdate=$P(par,"^",1)
    s eddate=$P(par,"^",2)
    s stdate=$ZDH(stdate,3)
    s eddate=$ZDH(eddate,3)
    k RP
    f date=stdate:1:eddate
    {
     s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpI("StDate",date,rw)) q:rw=""  d
     .q:$D(RP(date)) 
     .s sdate=$list(^Nur.DHCMGNurWorkRpD(rw),7)
     .s sdate=$ZD(sdate,3)
     .s edate=$list(^Nur.DHCMGNurWorkRpD(rw),6)
     .s edate=$ZD(edate,3)
     .s creatdate=$list(^Nur.DHCMGNurWorkRpD(rw),3)
     .s creatdate=$ZD(creatdate,3)
     .s creattime=$list(^Nur.DHCMGNurWorkRpD(rw),2)
     .s creattime=$ZT(creattime)
     .s RP(date)=creatdate_"^"_creattime
    }
    s d="" f  s d=$O(RP(d)) q:d=""  d
    .s date=$ZD(d,3)
    .s creatdate=$P(RP(d),"^",1)
    .s creattime=$P(RP(d),"^",2)
    .d out2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out2
	set Data=$lb(date,creatdate,creattime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSchWardRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchWardRpExecute ]
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
}

ClassMethod GetSchWardRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchWardRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSchWardRp(parr As %String) As %Query(ROWSPEC = "date,creatdate,creattime")
{
}

ClassMethod GetQueryData(QueryName, Parr, cols) As %String
{
  // n (QueryName,Parr,cols)//s a=##class(web.DHCMGNurWorkLoad).GetQueryData
   //s QueryName="web.DHCMGNurWorkLoad:GetWorkItmNum"
   //s cols=2
   k ^TMP(QueryName)
   Set rset = ##class(%ResultSet).%New(QueryName)
   b
   Set columns = rset.GetColumnCount()
 // Execute the query
   if $L(Parr,"^")&(Parr'="")=1
   {
    s sc = rset.Execute(Parr)
   }
   if (Parr=""){
   Set sc = rset.Execute()
   }
   s RowCount=^TMP(QueryName)
   s row=RowCount/cols

 // Now fetch the results
  s tabname=$P(QueryName,":",2)_"&"
  s i=0
  s coldata=""
  s count=1
  s head=tabname
  ///列表体第一个是表名
  b //000
  s ret=""
  While (rset.Next()) {
       if (i=0)
       {
			s j=0
			for j=0:1:(cols-1)
			{
				For col = 1:1:columns
				{
					s head=head_rset.GetColumnName(col)_j_"&"
				}
			}
	   }
       s dat=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
            //s dat=dat_"null"_"^"
            s dat=dat_""_"^"
        }
      if count=cols
      {
	     
	     s count=1
	     s ret=ret_coldata_"&"
	     s coldata=""
	  }else
	  {
        s count=count+1
	  }
        s i=i+1
      
      
 }
 //如果最后一行列数不足 要补齐
 if count>1
 {
  s bcols=cols-count+1
  b
  f i=1:1:(bcols)
   {
	   s coldata=coldata_dat
   }
   b //
   s ret=ret_coldata_"&"
 }
 s ret=head_"$"_ret
 Do rset.Close()
 q ret
}

ClassMethod GetWorkRpExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s par="28|^2|3|4|5|6"
 	//
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurWorkLoad","GetWorkRp","4|@2|10|11|12|")
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurWorkLoad","GetWorkRp","19|@@N")
 	//d ##class(%ResultSet).RunQuery("web.DHCMGNurWorkLoad","GetWorkRp","20|@13|@N")
 	s witm=$P(par,"@",2)
 	s RpIdSr=$P(par,"@",1)
 	s DepCheck=$P(par,"@",3)
 	k WorkItm
 	s l=$L(witm,"|")
 	s ret="序号|40|SeqNo|^科  室|200|Dep|^分数|100|DepWorkCount|^"
 	for i=1:1:l
 	{
	   s a=$P(witm,"|",i)
	   if a="" continue
	   s cc=##class(User.DHCMGNurWorkItm).%OpenId(a)
       s itmname=cc.WorkItm
       s WorkItm(a)=itmname
       s ret=ret_itmname_"|100|itm"_i_"|System.Double^"
	}
	s SchItm=ret
	s SumWardWorkCount=""
	k work,SumWork,WardWorkCount
    s l=$L(RpIdSr,"|")
    for i=1:1:l
    {
	   s RpId=$P(RpIdSr,"|",i)  ///添加汇总
	    if RpId="" continue
	    s pa=""  f  s pa=$O(^Nur.DHCMGNurWardMonRpI("WorkRp",RpId,pa)) q:pa=""  d
	     .s loc=$list(^Nur.DHCMGNurWardMonRpD(pa),9)
	     .s ret=""
	     .s rw=""  f  s rw=$O(^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw)) q:rw=""  d
	     ..s itm=$list(^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw),3)
	     ..q:(witm'="")&('$D(WorkItm(itm)))
	     ..//s a=##class(User.DHCMGNurWorkItm).%OpenId(itm)
	     ..//s itmname=a.WorkItm
	     ..//取数目//s num=$list(^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw),4)
	     ..//取分数
	     ..s count=$list(^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw),2)
		 ..s WardWorkCount(loc)=$G(WardWorkCount(loc))+count
		 ..s SumWardWorkCount=$G(SumWardWorkCount)+count
	     ..s work(loc,itm)=$G(work(loc,itm))+count
	     ..s SumWork(itm)=$G(SumWork(itm))+count
	     ..;b //9
	     ..//s count=$list(^Nur.DHCMGNurWorkRpWardD(par,rw),3)
	     .s ret=""
    }
    	//b //10
    	s loc=""  f  s loc=$O(work(loc)) q:loc=""  d
    	 .s ret=""
    	 .s tt="" f  s tt=$O(WorkItm(tt)) q:tt=""  d
	     ..if $D(work(loc,tt)) s ret=ret_work(loc,tt)_"^"
	     ..e  s ret=ret_"^"
	     .s WardWork(loc)=ret
	     s sumret=""
    	 s tt="" f  s tt=$O(WorkItm(tt)) q:tt=""  d
	     .if $D(SumWork(tt)) s sumret=sumret_SumWork(tt)_"^"
	     .e  s sumret=sumret_"^"
	//b //13
     //s depitm=##class(web.DHCMGPERSON).GetSortDep("D") //按开单科室显示NUR//20120914 暂时注释掉
     s depitm=##class(web.DHCMGPERSON).GetSortDep("N") //按开单科室显示NUR
     
     s l=$L(depitm,"^")
     s workstr=SchItm
     //b //15
     d out3
     //b //16
    ///按科室选项暂不用DepCheck="Y" 
	if (DepCheck="Y1"){
		k DepWorkCount,DepWork,DepartmentWork
		s loc=""  f  s loc=$O(WardWorkCount(loc)) q:loc=""  d
		.s loctyp=$P($G(^CTLOC(loc)),"^",13)
		.q:loctyp'="W"
		.s linkSub=0 f  s linkSub=$o(^CTLOC(loc,"LINK",linkSub)) q:linkSub=""  d
		..s linkDep=$G(^CTLOC(loc,"LINK",linkSub))
		..s DepWorkCount(linkDep)=$G(DepWorkCount(linkDep))+$G(WardWorkCount(loc))
		..s item="" f  s item=$O(work(loc,item)) q:item=""  d
		...s DepWork(linkDep,item)=$G(DepWork(linkDep,item))+$G(work(loc,item))
    	s dep=""  f  s dep=$O(DepWork(dep)) q:dep=""  d
		.s ret=""
		.s tt="" f  s tt=$O(WorkItm(tt)) q:tt=""  d
		..if $D(DepWork(dep,tt)) s ret=ret_DepWork(dep,tt)_"^"
		..e  s ret=ret_"^"
		.s DepartmentWork(dep)=ret
		
		s ii=0
		s loc=""  f  s loc=$O(DepWorkCount(loc)) q:loc=""  d
			.s locDesc=$P(^CTLOC(loc),"^",2)
			.i $L(locDesc,"-")>1 s locDesc=$P(locDesc,"-",2)
			.s locDesc=locDesc_"["_loc_"]"    //20121126
			.s ii=ii+1
			.s workstr=ii_"^"_locDesc_"^"_DepWorkCount(loc)_"^"_DepartmentWork(loc)
			.d out3
	}
	else {
		s ii=0
		for i=1:1:l
		{
			s aa=$P(depitm,"^",i)
			if aa="" continue
			s dep=$P(aa,"|"),depdes=$P(aa,"|",2)
			i $L(depdes,"-")>1 s depdes=$P(depdes,"-",2)
			if '$D(WardWork(dep)) continue
			s depdes=depdes_"["_dep_"]"    //20121126
			s ii=ii+1
			s workstr=ii_"^"_depdes_"^"_WardWorkCount(dep)_"^"_WardWork(dep)
			//b //22
			d out3
		}	
	}
	 //s workstr=" ^汇总^"_SumWardWorkCount_"^"_sumret
	 //d out3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
out3
	set Data=$lb(workstr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWorkRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkRpExecute ]
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
}

ClassMethod GetWorkRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWorkRp(parr As %String) As %Query(ROWSPEC = "itm")
{
}

ClassMethod getsubitmname(rw) As %String
{
	// n (rw)
    s a=$G(^User.DHCMGNurWorkRelatItmD(rw))
    q:a="" ""
    s relitm=$ListGet(a,3)
	s ARCIMRowid=$P(relitm,"||",1)
	s ARCIMSub=$P(relitm,"||",2) 
	s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name  
	q ItmName
}

ClassMethod GetWorkRpDetailExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s par="28|^2|3|4|5|6"
 	s witm=$P(par,"^",2)
 	s RpIdSr=$P(par,"^",1)
 	s l=$L(witm,"|")
 	s SchItm="科  室|200|dep|^子 项|150|subitm|^数 量|100|subnum|^"
	k WorkSub
    s l=$L(RpIdSr,"|")
    for i=1:1:l
    {
	   s RpId=$P(RpIdSr,"|",i)  ///添加汇总
	    if RpId="" continue
	    s pa=""  f  s pa=$O(^Nur.DHCMGNurWardMonRpI("WorkRp",RpId,pa)) q:pa=""  d
	     .s loc=$list(^Nur.DHCMGNurWardMonRpD(pa),9)
	     .s ret=""
	     .s rw=""  f  s rw=$O(^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw)) q:rw=""  d
	     ..s itm=$list(^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw),3)
	     ..q:itm'=witm 
	     ..s sub=""  f  s sub=$O(^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw,"ChildItmData",sub)) q:sub=""  d
	     ...s aa=^Nur.DHCMGNurWardMonRpD(pa,"ChildDHCMGNurWorkRpWard",rw,"ChildItmData",sub)
	     ...s subitm=$list(aa,2)
         ...s subnum=$list(aa,3)
         ...s WorkSub(loc,witm,subitm)=$G(WorkSub(loc,witm,subitm))+subnum
    }
     s depitm=##class(web.DHCMGPERSON).GetSortDep("DOC") //按开单科室显示NUR
     s l=$L(depitm,"^")
     s workstr=SchItm
     d out4
     for i=1:1:l
     {
	    s aa=$P(depitm,"^",i)
	    if aa="" continue
	    s dep=$P(aa,"|"),depdes=$P(aa,"|",2)
	    if '$D( WorkSub(dep)) continue
	    s subitm=""  f  s subitm=$O(WorkSub(dep,witm,subitm)) q:subitm=""  d
	    .s subitmname=..getsubitmname(subitm)
	    .s subnum=WorkSub(dep,witm,subitm)
	    .s workstr=depdes_"^"_subitmname_"^"_subnum_"^"
	    .d out4
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out4
	set Data=$lb(workstr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWorkRpDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkRpDetailExecute ]
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
}

ClassMethod GetWorkRpDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkRpDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWorkRpDetail(parr As %String) As %Query(ROWSPEC = "itm")
{
}

///   Creator: 		wxl
///   CreatDate: 	2010-06-11
///   Description:	取非医嘱项目(入院\转入\分娩)人数
///   Table：		PA_Adm,PA_AdmTransaction
///   Input：		stdate:开始日期, enddate:结束日期, WorkLoad:存工作量Global, wkitm:工作量项目ID
///   Return：	
ClassMethod GetNotOrderNum(stdate, enddate, WorkLoad, wkitm) As %String
{
 	//w ##class(web.DHCMGNurWorkLoad).GetNotOrderNum("2009-07-01","2009-07-31","","3")
	i +stdate'=stdate s stdate=$ZDH(stdate,3)
	i +enddate'=enddate s enddate=$ZDH(enddate,3)
	s wkitmname=$listget(^User.DHCMGNurWorkItmD(wkitm),4)
	;s oldNameSpace=$ZNSPACE
	;s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	k MotherAdm
	f Date=stdate:1:enddate
    {
		if wkitmname["入院"
		{
			//s depitm=##class(web.DHCMGPERSON).GetSortDep("DOC")
			s depitm=##class(web.DHCMGPERSON).GetSortDep("NUR")
			s num=0
     		s l=$L(depitm,"^")
     		for i=1:1:l d
   			.s aa=$P(depitm,"^",i)
			.if aa="" continue
			.s dep=$P(aa,"|")
			.s curDate=$zd(Date,3)
			.s pacward=$O(^PAWARD(0,"WARD_LocationDR",dep,""))
            .q:pacward=""
            .s num=0
            .s room=""  f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	        ..s adm=""  f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d   
	        ...s admdate=$P($g(^PAADM(adm)),"^",6)
	        ...i admdate=Date s num=num+1
			.i num="" s num=0
			.d CalNum2(num,wkitm,dep)
     		
		}
		/*
		if wkitmname["转入"
		{
			s depitm=##class(web.DHCMGPERSON).GetSortDep("DOC")
     		s l=$L(depitm,"^")
     		for i=1:1:l
     		{
				s aa=$P(depitm,"^",i)
				if aa="" continue
				s dep=$P(aa,"|")
				s curDate=$zd(Date,3)
				zn dataNameSpace
				s res=$$OutPutIP^DHCWLToWangHainew(curDate,curDate,dep)
				zn oldNameSpace
				s num=$P(res,"^",2)
				d CalNum2(num,wkitm,dep)
     		}
		}
		if wkitmname["分娩"
		{
			s BabyAdmId="" f  s BabyAdmId=$O(^PAADMi("PAADM_AdmDate",Date,BabyAdmId)) q:BabyAdmId=""  d
			.s MotherAdmId=$P(^PAADM(BabyAdmId),"^",75)
			.q:MotherAdmId=""
			.q:$D(MotherAdm(Date,MotherAdmId))>0
			.s AdmLoc=$P(^PAADM(+BabyAdmId),"^",4)
			.s dep=AdmLoc
			.s EnterDep=$O(^PAADMi("TransLoc",BabyAdmId,0)) 
			.i EnterDep'="" s dep=EnterDep
			.s MotherpapmiId=+$g(^PAADM(+MotherAdmId))
			.s MotherAdm(Date,MotherAdmId)=""
			.s num=1
			.//w !,num_","_wkitm_","_dep
			.d CalNum2(num,wkitm,dep)
		}
		
		*/
    }
	q 0
CalNum2(num,wkitm,dep)
	s a=^User.DHCMGNurWorkItmD(wkitm)
	s styp=$List(a,3)
	q:styp'="W" //
	s flag=$List(a,7)
	q:flag="N"  //不可用
	s WorkLoad(dep,wkitm)=$G(WorkLoad(dep,wkitm))+num
	q
}

}
