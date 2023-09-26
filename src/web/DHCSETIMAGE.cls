Class web.DHCSETIMAGE Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 661;

ClassMethod IfMeasure(EpisodeID, Amount) As %String
{
	;w ##Class(web.DHCSETIMAGE).IfMeasure("5898712","")
    n (EpisodeID,Amount)
    s ret=0 //发热标志 0正常 1发热 2低于35摄氏度
    s Mradm=""
    s Mradm=$p(^PAADM(EpisodeID),"^",61)  //就诊号
    s StartDate=$p(^PAADM(EpisodeID),"^",6)  //入院时间
    s Papmi=$p(^PAADM(EpisodeID),"^",1) 
    //s BirthDay=$p(^PAPER(Papmi,"ALL"),"^",6) //出生日期
    //s Age=$p($zd(+$h,3),"-",1)-$p($zd(BirthDay,3),"-",1) //年龄
    //s Ageflag=0
    //i Age<10 s Ageflag=1 //10岁以下 
    if $g(Mradm) ="" q $g(ret)
    s num=0,num1=0 //需测量次数
    s total=0 //已测量次数
    s TempMax="" //最高体温
    s Operflag=0
    s rw=0 f  s rw=$o(^DHCADMQTREC("adm",EpisodeID,rw))  q:rw=""  d
    .s Typdr=$p(^DHCADMQTREC("QTREC",rw),"^",4)
    .s Typ=$p(^DHCQTRECTYP("typ",Typdr),"^",2)
    .i (Typ="手术")||(Typ="转入")  d
    ..s OperDate=$p(^DHCADMQTREC("QTREC",rw),"^",2)
    ..i (+OperDate<=+$h)&&((+OperDate+3)>=+$h) d    //手术、转科患者连测三天
    ...s Operflag=1  
    s chl=0 f   s chl=$o(^MR(Mradm,"OBS",chl)) q:$g(chl)=""  d
    .s OBSDate=$p(^MR(Mradm,"OBS",chl),"^",3) 
    .s itemdr=$p(^MR(Mradm,"OBS",chl),"^",1)
    .s itemDesc=$p(^MRC("OBITM",itemdr),"^",2)
    .q:itemDesc'["体温"
    .//w !,$p(^MR(Mradm,"OBS",chl),"^",2),"-",$ZD(OBSDate,3)
    .b
    .i (+OBSDate'<(+$h-3))&&(+OBSDate'>+$h) d  //不正常连测三天
    ..s OBSValue=$p(^MR(Mradm,"OBS",chl),"^",2)
    ..i (+OBSValue>=37.5) d
    ...s ret=1
    ..i (+OBSValue<=35) d
    ...s ret=2
    .if (+OBSDate>=(+$h-3))&&(+OBSDate<=+$h) d 
    ..s Temp=OBSValue
    ..if TempMax<=Temp s TempMax=Temp     //两天内最高体温
    ..if +OBSDate=+$h s total=total+1  //当天已经测量次数
    ..b //w !,TempMax
    if ret=0 d  //正常
    .if Operflag=1 d  //转科患者连续三天，每天测量4次
    ..s num=4,num1=4
    ..s num=num-total
    .else  if (+StartDate<=+$h)&&(+StartDate>=(+$h-3)) d ////新入院病人每天4次，连续三天
    ..s num=4,num1=4  
    ..s num=num-total
    .else  d //正常人，每日一次
    ..s num=2,num1=2
    ..s num=num-total 
    else  if ret=2 d //低温
    .s num=4,num1=4 
    .s num=num-total
    else  d  //发热
    .if (TempMax>=37.5) d  //37.5以上
    ..s num=4,num1=4
    ..s num=num-total
    .else  if Operflag=1 d  //手术、转科3天内，每天测量3次
    ..s num=4,num1=4
    ..s num=num-total
    .else  d  //恢复正常每天测两次，连续测两天
    ..s num=2,num1=2
    ..if total<3 s num=num-total
    ..else  s num=0 
    if (num>0)&(($g(Amount)=(num+total))||($g(Amount)="")) d
    .s ret=1
    else  s ret=0
    b
    q ret_"^"_num1_"^"_total
}

ClassMethod ifNeedSeeOrder(EpisodeId)
{
    

	s ifNewTempOrdFlag=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeId),2,1)
    s ifNewLongOrdFlag=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeId),3,1)
    q:(ifNewTempOrdFlag=0)&(ifNewLongOrdFlag=0) 0
	q 1
}

// 患者是否有检查预约

ClassMethod GetOrdType(ArcItemDr) As %String
{
  //求医嘱类别  R 药，L 检验
 s OrdType=""
 //s arcid="" s arcid=$O(^ARC("IC",0,"OrdCat",OrdCat,arcid))
 if +ArcItemDr'=0  s OrdType=$P($G(^ARC("IC",ArcItemDr)),"^",7)
 q OrdType
}

ClassMethod GetOrdItemTyp(Oew, OrdSub) As %String
{
    n (Oew,OrdSub)
	s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	s ARCIMRowid=$P(ArcimDR,"||",1)
	s ARCIMSub=$P(ArcimDR,"||",2) 
	s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
    s OrdTyp=..GetOrdType(ItemCatDR)
    q OrdTyp
}

ClassMethod IfRisAppointment(EpisodeID) As %String
{
   
  S ret =0
  s row1="" 
  s row2=""
  s row3=""
  s AppRowID=""
  f  s row1 =$o(^RBAS("ADM",EpisodeID,row1)) q:row1=""  d
  .f  s row2 = $o(^RBAS("ADM",EpisodeID,row1,row2)) q:row2=""  d
  ..f  s row3 = $o(^RBAS("ADM",EpisodeID,row1,row2,row3)) q:row3=""  d
  ...s AppRowID=row1_"||"_row2_"||"_row3
  ...//w !,AppRowID
  ...S AppDate1 = $p(^RBAS(row1,row2,"APPT",row3),"^",17)
  ...q:AppDate1<+$h 
  ...s AppDate=$zd(AppDate1,3)
  ...S AppTime1 = $p(^RBAS(row1,row2,"APPT",row3),"^",6)
  ...s AppTime=$zt(AppTime1,3)
  ...S AppNote ="" 
  ...d GetAppointInfo 
  
 
  quit ret 
  
GetAppointInfo
 ;^OEORDi(0,"Appt","1976||685||1",20,1)
 s oeordrowid=""
 s subrowid =""
 f  s oeordrowid = $o(^OEORDi(0,"Appt",AppRowID,oeordrowid)) q:oeordrowid=""  d 
 .f  s subrowid = $o(^OEORDi(0,"Appt",AppRowID,oeordrowid,subrowid)) q:subrowid=""  d  
 ..s orderItmRowid= oeordrowid_"||"_subrowid
 ..//w !,orderItmRowid
 ..s itmmastdr=$p($g(^OEORD(oeordrowid,"I",subrowid,1)),"^",2) ;OEORI_ItmMast_DR  oe_orditem   
 ..s itemcatdr=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1)),"^",10)  ;ARCIM_ItemCat_DR ARC_ItmMast
 ..s arcicordcat=$p($g(^ARC("IC",itemcatdr)),"^",8)  ;ARCIC_OrdCat_DR ARC_ItemCat
 ..s orcatcode=$p($g(^OEC("ORCAT",arcicordcat)),"^",1)  ;ORCAT_Code OEC_OrderCategory 
 ..//w !,orcatcode
 ..q:orcatcode'="07"   ;  医嘱不是检查大类则退出
 ..s ItemStatDR=$p(^OEORD(oeordrowid,"I",subrowid,1),"^",13) ; 医嘱状态
 ..q:ItemStatDR=""
 ..s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
 ..//w !,ItemStatusCode
 ..q:ItemStatusCode'="V"
 ..s ret=1 
 quit
}

// 不同的医嘱据今天的时间显示不同的图标

// 

// ArcimCodes表示术后医嘱的医嘱代码

// OP="0"：按照等于比较

// op="1"；按照大于比较

// op="2": 按照小于比较

// dataNum :表示天数

ClassMethod IFOPERATION(EpisodeID, ArcimCodes, OP, DataNum) As %String
{
    n (EpisodeID,ArcimCodes,OP,DataNum)
    //s ^EH("IFOPERATION")=$lb(EpisodeID,ArcimCodes,OP,DataNum)
    quit:EpisodeID="" 0
    s adm=EpisodeID
    s currentOrdSub=""
    s currentOew=""
	s ret=0	
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:(Oew="")   d 
	.;w !,Oew
	.s OrdSub=0 f   s OrdSub=$O(^OEORD(Oew,"I",OrdSub))   q:OrdSub=""  d
	..;w !,OrdSub
	..q:$d(^OEORD(Oew,"I",OrdSub,1))'=1
	..s arcic=$p((^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..;w !,arcic
	..s ordStat=$p(^OEORD(Oew,"I",OrdSub,1),"^",13)
	..s ordStatDesc=$p(^OEC("OSTAT",ordStat),"^",1)
	..q:(ordStatDesc'="V")&&(ordStatDesc'="E")
	..q:(+arcic=0)
	..S ARCIMCODE=$P(^ARCIM($P(arcic,"||",1),$P(arcic,"||",2),1),"^",1)
	..q:ARCIMCODE'=ArcimCodes
	..s currentOrdSub=OrdSub
	..s currentOew=Oew
	...;w Oew_"@"_OrdSub
	i (currentOew'="")&& (currentOrdSub'="") d
	.s OrdDate=$P($G(^OEORD(currentOew,"I",currentOrdSub,3)),"^",7)
	.s currentarcic=$p((^OEORD(currentOew,"I",currentOrdSub,1)),"^",2)
	.s ARCIMCODE=$P(^ARCIM($P(currentarcic,"||",1),$P(currentarcic,"||",2),1),"^",1)
	.i (ARCIMCODE'="") && (ARCIMCODE=ArcimCodes) && (OP="0") d
	..i (+$H-OrdDate)=DataNum s ret=1
	.i (ARCIMCODE'="") && (ARCIMCODE=ArcimCodes) && (OP="1") d
	..i (+$H-OrdDate)>=DataNum s ret=1
	.i (ARCIMCODE'="") && (ARCIMCODE=ArcimCodes) && (OP="2") d
	..i (+$H-OrdDate)<DataNum s ret=1
	;w !,ret
	q ret
}

/// 20150209 新停医嘱索引^OEORDi(0,"XDate",XDate,+OrdItmRowId,$p(OrdItmRowId,"||",2))
/// 如果老一点的库没有这个索引就不能用这个方法
ClassMethod IfStopOrd(EpisodeID) As %String
{
 n (EpisodeID)
 q:$g(EpisodeID)="" 0
 s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
 q:oeordId="" 0
 s ret=0
 s oeordSub=0
 f  s oeordSub=$o(^OEORDi(0,"XDate",+$h,oeordId,oeordSub)) q:(oeordSub="")!(ret=1)  d
 .s cptype=""
 .i $d(^OEORD(oeordId,"I",oeordSub,7)) d
 ..s adduser=$p(^OEORD(oeordId,"I",oeordSub,7),"^",1)
 ..q:adduser=""
 ..s OerdQty=$P($G(^OEORD(oeordId,"I",oeordSub,1)),"^",18) //首次
 ..q:(OerdQty=0)&&('$d(^OEORD(oeordId,"I",oeordSub,"X",1)))
 ..i $d(^SSU("SSUSR",adduser)) s cpdr=$p(^SSU("SSUSR",adduser),"^",14) 
 ..q:$g(cpdr)=""
 ..i $d(^CTPCP(cpdr,1)) s cptypedr=$p(^CTPCP(cpdr,1),"^",4)
 ..q:$g(cptypedr)=""
 ..i $d(^CT("CPT",cptypedr)) s cptype=$p(^CT("CPT",cptypedr),"^",4)
 ..q:cptype="NURSE"
 ..s result=..getloc(oeordId,oeordSub)
 ..q:result=""
 ..s OrdExecStatus=##Class(web.DHCLCNUREXCUTE).GetXOrdInfo(oeordId,oeordSub) //医嘱执行状态
 ..s OrdStatDR=$P($G(^OEORD(oeordId,"I",oeordSub,1)),"^",13) 
 ..s OrdStatCode=$p(^OEC("OSTAT",OrdStatDR),"^",1)   //医嘱状态
 ..i (OrdStatCode="D")&(OrdExecStatus="^^") s ret=1 b ;009
 q ret
}

ClassMethod IfStopOrd20150209(AdmNo) As %String
{
 n (AdmNo)
 q:$g(AdmNo)="" 0
 s ord=$o(^OEORD(0,"Adm",AdmNo,""))
 q:ord="" 0
 s ret=0
 s chl=0
 s fl=0
 f  s chl=$O(^OEORD(ord,"I",chl)) q:(chl="")!(chl="0")!(ret=1)  d
 .;f date=(+$h):1:(+$h+1) d
 .;s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,date,ordSttTime)) q:(ordSttTime="")!(ret=1)  d
 ..;s chl=0 f  s chl=$o(^OEORDi(0,"Date",ord,date,ordSttTime,chl)) q:(chl="")!(ret=1)  d
 .s cptype=""
 .i $d(^OEORD(ord,"I",chl,7)) d
 ..s adduser=$p(^OEORD(ord,"I",chl,7),"^",1)
 ..q:adduser=""
 ..s Xdate=$p($g(^OEORD(ord,"I",chl,3)),"^",34)
 ..q:(Xdate="")||(Xdate'=+$h)
 ..s OerdQty=$P($G(^OEORD(ord,"I",chl,1)),"^",18) //首次
 ..q:(OerdQty=0)&&('$d(^OEORD(ord,"I",chl,"X",1)))
 ..i $d(^SSU("SSUSR",adduser)) s cpdr=$p(^SSU("SSUSR",adduser),"^",14) 
 ..q:$g(cpdr)=""
 ..i $d(^CTPCP(cpdr,1)) s cptypedr=$p(^CTPCP(cpdr,1),"^",4)
 ..q:$g(cptypedr)=""
 ..i $d(^CT("CPT",cptypedr)) s cptype=$p(^CT("CPT",cptypedr),"^",4)
 ..q:cptype="NURSE"
 ..s retul=..getloc(ord,chl)
 ..q:retul=""
 ..s OrdExecStatus=##Class(web.DHCLCNUREXCUTE).GetXOrdInfo(ord,chl) //医嘱执行状态
 ..s OrdStatDR=$P($G(^OEORD(ord,"I",chl,1)),"^",13) 
 ..s OrdStatCode=$p(^OEC("OSTAT",OrdStatDR),"^",1)   //医嘱状态
 ..i (OrdStatCode="D")&(OrdExecStatus="^^") s ret=1 b ;009
 /*
 ..s OreSub=0 f  s OreSub=$o(^OEORD(ord,"I",chl,"X",OreSub)) q:(OreSub="")!(ret=1)  d
 ...s cptype=""
 ...i $d(^OEORD(ord,"I",chl,7)) d
 ....s adduser=$p(^OEORD(ord,"I",chl,7),"^",1)
 ....q:adduser=""
 ....i $d(^SSU("SSUSR",adduser)) s cpdr=$p(^SSU("SSUSR",adduser),"^",14) 
 ....q:$g(cpdr)=""
 ....i $d(^CTPCP(cpdr,1)) s cptypedr=$p(^CTPCP(cpdr,1),"^",4)
 ....q:$g(cptypedr)="NURSE"
 ....i $d(^CT("CPT",cptypedr)) s cptype=$p(^CT("CPT",cptypedr),"^",4)
 ...q:cptype="NURSE"
 ...s retul=..getloc(ord,chl)
 ...q:retul=""
 ...s ordStatusId=$p($g(^OEORD(ord,"I",chl,"X",OreSub,"BILL")),"^",1)  
 ...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ...s xOrdExecStr=##Class(web.DHCNurCom).GetXOrdExecInfo(ord_"||"_chl_"||"_OreSub) //if ItemStatDR=4 w !, ^DHCCLNurseExec("DISCON","OrdItem",ord_"||"_chl)

 ...if (ordStat="D")&(xOrdExecStr="^^") d
 ....s fl=1, ret=1 b ;010
 */
 q ret
}

ClassMethod IFOP(EpisodeID) As %String
{
	n (EpisodeID)
	s adm=EpisodeID
	s ret=0
  	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:(Oew="")!($G(ret)=1)  d 
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
	..e  q
	..s PriorDes="^"_PriorDes_"^"
	..q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)
	..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	..q:user=""
	..q:'$D(^SSU("SSUSR",user))
	..s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	..q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
	..i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",3) ;write doctor oeori_doctor_dr
	..e  s Doctor=""
    ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	..s truedoc=0
	..s Loc="" 
	..f  s Loc=$O(^RB("RES",0,"CTPCP",DoctorDr,Loc)) q:(Loc="")!($G(ret)=1)  d
	...s ret=..ifloc(Loc)
	...//w !,Loc
	..
	.
	q $G(ret)
}

// -----------------------------------------------------------------------

// 当天是否开过今日出院医嘱，是返回0 否则返回1-------------------gsb

ClassMethod IfOPItmCat(Adm, ARCIMItmCat) As %String
{
    s ret=0,temp=""
    s OEItemDate=+$h
    If Adm="" q
    Set OEOrderId=""
    f  Set OEOrderId= $o(^OEORD(0,"Adm",Adm,OEOrderId))  q:OEOrderId=""   d
    .s OEOrderSub=""
    .f  s OEOrderSub=$o(^OEORDi(0,"ItemDate",OEItemDate,OEOrderId,OEOrderSub)) q:OEOrderSub=""   d
    ..q:'$d(^OEORD(OEOrderId,"I",OEOrderSub,1))
    ..s temp=^OEORD(OEOrderId,"I",OEOrderSub,1)
    ..s ItemStat=$p(temp,"^",13) 
    ..q:ItemStat=4
    ..s ARCITRowid=+$P(temp,"^",2)
    ..s ARCIMTemp=^ARCIM(ARCITRowid,1,1)
    ..s ItmCat=$p(ARCIMTemp,"^",10)
    ..if ItmCat=ARCIMItmCat d
    ...set ret=1
    q ret
}

// ------------------------------------------------------------------------

ClassMethod IFNurseRefuseExecuteOrder(EpisodeID) As %String
{
	n (EpisodeID)
	s adm=EpisodeID
	s ret=0
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:(Oew="")  d 
	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",Oew,+$h,ordSttTime)) q:(ordSttTime="")!(ret=1)  d
 	.s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",Oew,+$h,ordSttTime,OrdSub)) q:(OrdSub="")!(ret=1)  d
	..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",Oew,+$h,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(ret=1)  d
	...s ordStatusId=$p($g(^OEORD(Oew,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
	...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
	...q:ordStat'="V"
	...s execStatusId=$p($g(^OEORD(Oew,"I",OrdSub,"X",OreSub)),"^",16) 
	...q:execStatusId=""
	...s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)
	...q:execStatusCode'="R" 
	...s ret=1
	q $G(ret)
}

ClassMethod IFRefuseDispDrug(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ret=0
	If EpisodeID="" q 0
    Set OEOrderRowID=""
    Set OEOrderRowID = $o(^OEORD(0,"Adm",EpisodeID,OEOrderRowID))  
    If $g(OEOrderRowID)="" q 0
    Set RefuseOEOrderDr=""
    Set RefuseId=""
    For  set RefuseId=$o(^STDF("DATE",+$h,RefuseId)) q:$g(RefuseId)=""  d
    .Set RefuseOEOrderDr=$p(^STDF(RefuseId),"||",1)
    .Set ordSubDr=+$p(^STDF(RefuseId),"||",2)
    .s ordstatus=""
    .s sub="" f  s sub=$o(^OEORDi(0,"OrdItem",RefuseOEOrderDr,ordSubDr,+$h,sub)) q:(sub="")!(ordstatus="D")  d
 	..s orestatusdr=$p(^OEORD(RefuseOEOrderDr,"I",ordSubDr,"X",sub,"BILL"),"^",1)  ;医嘱状态
 	..i orestatusdr'="" d
 	...s ordstatus=$p(^OEC("OSTAT",orestatusdr),"^",1) 	
    .q:ordstatus="D"
    .If RefuseOEOrderDr=OEOrderRowID  d
    ..Set ret=1
    
    q ret
}

/// 判定患者三天内是否曾经发过烧
/// ##Class(web.DHCSETIMAGE).IfFeverInThreeDay(50219)
ClassMethod IfFeverInThreeDay(EpisodeID As %String, NormalTemp = 37.5) As %String
{
	n (EpisodeID,NormalTemp)
	s retValue=0 
	s admLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	q:admLoc="" retValue
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s defHosp=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_MRCObservationItem",hospital)
	s adm=EpisodeID
	s Mradm=""
	s Mradm=$P(^PAADM(adm),"^",61) 
	if $g(Mradm) ="" q $G(retValue)
	;s temperatureDr=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4("temperature"),""))
	s temperatureDr=$o(^MRC("OBITM",0,"HOSPCode",defHosp,$$ALPHAUP^SSUTIL4("temperature"),""))
	s Childsub=0  
	f  s Childsub=$o(^MR(Mradm,"OBS",Childsub)) q:$g(Childsub)=""  d
	.s OBSDate = $p(^MR(Mradm,"OBS",Childsub),"^",3)
	.i (+OBSDate > (+$h-3)) & (+OBSDate <= +$h) d 
	..s itemdr = $p(^MR(Mradm,"OBS",Childsub),"^",1)
	..s OBSvalue= $p(^MR(Mradm,"OBS",Childsub),"^",2)
	..i (+itemdr =temperatureDr) &( +OBSvalue > NormalTemp) d
	...s retValue =1
	q $G(retValue)
}

// 判定患者是否有传染病

// MedEpidemicType="Y":如果返回的字符串不是空，且其中没有“N”,就表示还有传染全部上报

// MedEpidemicType="N":如果返回的字符串不是空，且其中有“N”,就表示还有传染并没有上报

ClassMethod IfMedEpidemic(EpisodeID, MedEpidemicType) As %String
{
 //S ^weiguoxinIfMedEpidemic=	EpisodeID
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set sMeddata=Config.DataNamespace
 Set sLabData=Config.LabDataNamespace
 S current = $ZNSPACE
 //S ^weiguoxinTest=EpisodeID
 zn sMeddata
 s rvalue =$$XPaadm^DHCMedEpidemicCtl(sMeddata,sLabData,EpisodeID)
 zn current
 //S ^weiguoxinTest=$g(^weiguoxinTest)_":"_"**********"_MedEpidemicType_"*********"_sMeddata_"^"_sLabData_"^"_EpisodeID_"^"_rvalue_"^"
 s ret =0
 S ret1=0
 if $g(rvalue) '= "" D
 .if (($FIND(rvalue,"N")>0)&&(MedEpidemicType="N")) D
 ..s ret =1 
 .if (($FIND(rvalue,"N")=0)&&(MedEpidemicType="Y") ) D
 ..s ret =1 
 q ret
}

ClassMethod ifloc(Loc) As %String
{
	n (Loc)
	 s ret=0
	 s curHospId=$p(^CTLOC(Loc),"^",22)
	 s num=$L($G(^DHCANOPSET(curHospId,"oploc")),"^")
	 f i=1:1:num
	 { 
	   s str=$P(^DHCANOPSET(curHospId,"oploc"),"^",i)
	   s id=$P(str,"|")
	   i id=Loc s ret=1
	 }
	 q ret
}

ClassMethod IFArrea(adm) As %String
{
 //欠费
 n (adm)
 s ret=0

 s ret=##class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(adm,"A","预警")
 i ret=0 do
 .s ret=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel($g(adm),"A","部分控制")
 i ret=0 do
 .s ret=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel($g(adm),"A","完全控制")
 
 q $G(ret)
}

ClassMethod IfNewPatient(EpisodeID, days = 1) As %String
{
 s ret=0
 s EpisodeID=$g(EpisodeID)
 q:EpisodeID="" 0

 q:'$d(^PAADM(EpisodeID)) 0
 q:$p(^PAADM(EpisodeID),"^",2)="E" 0
 q:$p(^PAADM(EpisodeID),"^",2)="O" 0
 s admInHospDate=$p(^PAADM(EpisodeID,"DHC"),"^",31)
 if (admInHospDate+days-1)>= +$h s ret=1 
 if (+admInHospDate > (+$h-days)) & (+admInHospDate <= +$h)
 //if $p(^PAADM(EpisodeID,"DHC"),"^",31)=+$h s ret=1
 q ret
}

ClassMethod ifoverdue(EpisodeID) As %String
{
  //医保病人90出院
 s ret=0
 s EpisodeID=$g(EpisodeID)
 q:EpisodeID="" 0
 q:'$d(^PAADM(EpisodeID)) 0
 s instyp=$P(^PAADM(EpisodeID,1),"^",7)
 q:instyp="" 0
 s instyp="^"_instyp_"^"
 q:"^3^17^15^"'[instyp
 s admdate=$p(^PAADM(EpisodeID),"^",6)
 s daynum=(+$h)-admdate
 if daynum'<80 s ret=1
 e  s ret=0
 q ret
}

// 得到患者当天某些医嘱是否存在，存在返回１，不存在返回０

// ＡｄｍＮｏ患者的ＡＤＭ号

// ArcimCodes  医嘱的代码的组合,如:"c001^003"

ClassMethod IfOrddailyExist(EpisodeID, ArcimCodes, type = "") As %String
{
 n (EpisodeID, ArcimCodes,type)
 
 s num=$l(ArcimCodes,"^")
 s ret=0
 for i=1:1:num d
 .q:ret=1
 .s code=$p(ArcimCodes,"^",i)
 .q:code=""
 .s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
 .q:rowidm=""
 .s rowid=rowidm_"||"_"1"
 .;w !,rowid
 .i type="ByOrd" s ret=..GetCareTypeByOrd(EpisodeID, rowid)
 .e  s ret=..GetCareType(EpisodeID, rowid)
 q ret
}

/// Creator: 		SongChao
/// CreatDate: 		2019.1.24
/// Description: 	
/// Input：			
/// Return：		
/// Other 
ClassMethod GetCareTypeByOrd(EpisodeID, ArcimID)
{
	n (EpisodeID,ArcimID)
	s ^tempsc("GetCareTypeByOrd")=$lb(EpisodeID,ArcimID)
	s ret=0
	s oeord=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeord="" ret
	s OEORISttDat="" 
	f  s OEORISttDat=$o(^OEORDi(0,"ARCIM",+oeord,ArcimID,OEORISttDat),-1) q:(OEORISttDat="")!(ret=1)  d
	.q:OEORISttDat>+$h
	.s oeordSub="" f  s oeordSub=$o(^OEORDi(0,"ARCIM",+oeord,ArcimID,OEORISttDat,oeordSub),-1) q:(oeordSub="")!(ret=1)  d
	..s ordStatId=$p(^OEORD(+oeord,"I",oeordSub,1),"^",13)
	..s ordStat=$p($g(^OEC("OSTAT",ordStatId)),"^",1)
	..q:ordStat'="V"
	..s longOrdFlag=##class(DHCDoc.Order.Common).IsLongOrdItem(+oeord_"||"_oeordSub)
	..s validExecFlag=0
	..i longOrdFlag=1 d
	...s OEOREChildsub=""
	...f  s OEOREChildsub=$o(^OEORDi(0,"OrdItem",+oeord,oeordSub,+$h,OEOREChildsub)) q:(OEOREChildsub="")||(validExecFlag)  d
	....s ExecStateDR= $p($g(^OEORD(+oeord,"I",oeordSub,"X",OEOREChildsub)),"^",16)
	....s ExecStateCode=""
	....i ExecStateDR'="" s ExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)
	....q:$g(ExecStateCode)="D"
	....s validExecFlag=1
	..//过滤长期医嘱当天不存在有效执行记录
	..q:('validExecFlag)&&(longOrdFlag)
	..//过滤开始日期非当天的非长期医嘱
	..q:(OEORISttDat'=+$h)&&('longOrdFlag)
	..s ret=1
	q ret
}

ClassMethod IfCareLevelN(EpisodeID, Code)
{
	s rs=0
	s careLevel=##class(Nur.NIS.Service.Base.Patient).GetCareLevel(EpisodeID)
	s:careLevel=##class(CT.NUR.NIS.DataRelationConfig).GetTranByDesc("DRCDesc",Code) rs=1
	q rs
}

ClassMethod IfOrddailyExistByConfig(EpisodeID, Code) As %String
{
 n (EpisodeID, Code,%session)
 s epLoc=$P(^PAADM(EpisodeID),"^",4)
 s:epLoc'="" hospID=$P(^CTLOC(epLoc),"^",22)
 s arcimCodes=##class(Nur.NIS.Service.Base.DataRelationConfig).GetArcCode(Code,hospID) //HospId
 q:arcimCodes="" 0
 i (Code["CARE")!(Code="SERIOUSLY")!(Code="CRITICALLY") s type="ByOrd"
 q ##class(web.DHCSETIMAGE).IfOrddailyExist(EpisodeID,arcimCodes,$g(type))
}

// StrArcRowIds　医嘱需要查的医嘱的rowid串，　如"130||1^132||1^567||1"

ClassMethod GetCareType(AdmNo, StrArcRowIds) As %String
{
 //
 n (AdmNo,StrArcRowIds)
 
 s AdmNo=$g(AdmNo)
 s StrArcRowIds=$g(StrArcRowIds) 
 set retno=0
 q:AdmNo="" 0
 q:StrArcRowIds="" 0
 set ord=$o(^OEORD(0,"Adm",AdmNo,""))
 q:ord="" 0
 s num=$l(StrArcRowIds,"^")
 s flag=0
 s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) q:(ordSttTime="")!(retno=1)  d
 .s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) q:(OrdSub="")!(retno=1)  d
 ..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(retno=1)  d
 ...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 ...q:ordStatusId=""
 ...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ...q:(ordStat'="V")&(ordStat'="E")
    ...i ord=245,OrdSub=34,OreSub=3 
 ...q:StrArcRowIds'=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 ...s retno=1
 q retno
}

// 得到患者是否离院的信息. 如果离院,返回1; 否则,返回0

// 是否做了医疗结算

ClassMethod IfMedDisch(AdmNo) As %String
{
 n (AdmNo)
  s MedDischDoc=$P(^PAADM(AdmNo),"^",59) //PAADM_MedDischDoc_  _______________  79
  q:MedDischDoc'="" 1
  q:MedDischDoc="" 0
}

ClassMethod IfADMLeave(AdmNo) As %String
{
 //
 n (AdmNo)
 q:$g(AdmNo)="" 0
 s ret=0
 s chl=""
 s flag=0
 f  s chl=$o(^PAADM(AdmNo,"LEA",chl)) q:(chl="")!(flag=1)  d
 .q:'$d(^PAADM(AdmNo,"LEA",chl))
 .s Gdate=$p(^PAADM(AdmNo,"LEA",chl),"^",2)
 .s Rdate=$p(^PAADM(AdmNo,"LEA",chl),"^",9)
 .i (Gdate'="")&(Rdate="") d
 .. s ret=1
 .. s flag=1
 q ret
}

ClassMethod getprintflag(oew, chl, sub) As %String
{
	/*s oeorew=##class(web.DHCNurCom).GetFirstOeoreId(oew_"||"_chl,"Query")
	if oeorew'="" 
	{
		s rw=0 s rw=$O(^DHCOrdExec(0,"OEOREDR",oeorew,rw))
		if rw'="" s flag=$P(^DHCOrdExec(rw),"^",3)
	}
	q $G(flag) */
	s printFlag=$p($g(^OEORD(oew,"I",chl,"X",sub,"NUR")),"^",1)
	q printFlag
}

// 判断是否有新医嘱

// OrdPriorityFlag=1:表示当有[即刻医嘱]未执行返回 1 ，有其他优先级医嘱返回为0

// OrdPriorityFlag=2:表示当有除[即刻医嘱]未执行返回 1 ，有[即刻医嘱]未执行返回 0

// 检验医嘱打印过就不提示,其他医嘱执行过不提示

// OEC_Priority:表中 rowid=1 表示即刻医嘱

ClassMethod IfNewOrdItem(AdmNo, OrdPriorityFlag, Flag = 0) As %String
{
 n (AdmNo,OrdPriorityFlag,Flag)
 s ^TMP("aa")=$LB(AdmNo, OrdPriorityFlag)
 q:$g(AdmNo)="" 0
 s amdType=$p($G(^PAADM(AdmNo)),"^",2)
 q:$g(amdType)'="I" 0
 s oeordId=$o(^OEORD(0,"Adm",AdmNo,""))
 q:oeordId="" 0
 s ret=0
 s fl=0
 s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime)) q:(ordSttTime="")!(fl=1)  d
 .s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub)) q:(oeoriSub="")!(fl=1)  d
 ..q:'$d(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub,1))
 ..q:'$d(^OEORD(oeordId,"I",oeoriSub,"X",1))
 ..s ItemStatDR=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
 ..s ordtyp=..GetOrdItemTyp(oeordId,oeoriSub)
 ..s printflag=""
 ..;if ordtyp="L" d
 ..s printflag=..getprintflag(oeordId,oeoriSub,1)
 ..;q:$G(printflag)'=""
 ..s PriorDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)     ;OEC_Priority
 ..q:ItemStatDR'=1
 ..s catdesc=..GetOrdCat(oeordId, oeoriSub)
 ..;q:(catdesc="材料(收费)")!(catdesc="普通项目")
 ..s arcimDr=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) 
 ..s ItemCatDR=$P($G(^ARCIM(+arcimDr,1,1)),"^",10)
 ..s ItemCatDRStr="^"_ItemCatDR_"^" 
 ..q:$G(^DHCOEOrdPrintSet("NotSordCat"))[ItemCatDRStr&($G(^DHCOEOrdPrintSet("NotSordCat"))'="")
 ..s cptype=""
 ..i $d(^OEORD(oeordId,"I",oeoriSub,7)) d
 ... s adduser=$p(^OEORD(oeordId,"I",oeoriSub,7),"^",1)
 ... q:adduser=""
 ... i $d(^SSU("SSUSR",adduser)) s cpdr=$p(^SSU("SSUSR",adduser),"^",14) 
 ... q:$g(cpdr)=""
 ... i $d(^CTPCP(cpdr,1)) s cptypedr=$p(^CTPCP(cpdr,1),"^",4)
 ... i $d(^CT("CPT",cptypedr)) s cptype=$p(^CT("CPT",cptypedr),"^",4)
 ..q:cptype="NURSE"
 ..s retul=..getloc(oeordId,oeoriSub)
 ..q:retul=""
 ..s seeInfo=##class(web.DHCLCNUREXCUTE).GetSeeOrdInfo(oeordId,oeoriSub)
 ..q:(seeInfo'="^^")&($g(Flag)=1)
 ..s ech="" 
 ..s thisexec=0       ;先定此医嘱未被执行
 ..s flag=0
 ..s execdate=$p(^OEORD(oeordId,"I",oeoriSub,"X",1),"^",19)   ;执行日期
 ..s execcp=$p(^OEORD(oeordId,"I",oeoriSub,"X",1),"^",15)     ;执行人
 ..s phcfrCode=##class(Nur.OrderStaticInfo).getPhcfrCode(oeordId,oeoriSub)
 ..i (execdate'="")&(execcp'="") d
 ...s thisexec=1   ;此医嘱已经被执行  
 ..i ( (thisexec=0) &&($g(PriorDR)=1)&& (OrdPriorityFlag=1))  d
 ... s ret=1
 ..i ( (thisexec=0) &&(($g(PriorDR)=5)||($g(PriorDR)=8))&& (OrdPriorityFlag=3))  d
 ... s ret=1
 ..i ( (thisexec=0) &&(($g(PriorDR)'=1)&&($g(PriorDR)'=5)&&($g(PriorDR)'=8))&& (OrdPriorityFlag=2))  d
 ... s ret=1 
 ..i ( (thisexec=0) &&($zcvt($g(phcfrCode),"U")="ST")&& (OrdPriorityFlag=4))  d
 ... s ret=1
 ..;i ( (thisexec=0) &&($g(PriorDR)=1)&& ((OrdPriorityFlag=2)||(OrdPriorityFlag=3)))  d
 ...; s ret=0
 ...; s fl=1
 q ret
}

/// Description:	获取新开医嘱
/// Input:			AdmNo：病人就诊号，Priority：优先级（L:长期、T:临时）
/// Return:		  	1：存在
/// Other:			w ##class(web.DHCSETIMAGE).IfNewOrder("499","L")
ClassMethod IfNewOrder(AdmNo, Priority = "L") As %String
{
	n (AdmNo, Priority, %session)
	// S核对：需处理处理后消失,E执行：护士执行过后消失,P打印：护士进行打印单据后消失
	s type="E"
	q:$g(AdmNo)="" 0
	s oeordID=$o(^OEORD(0,"Adm",AdmNo,""))
	q:oeordID="" 0
	
	s ctLocID=$p(^PAADM(AdmNo),"^",4)
	i ctLocID'="" s hospID= $p(^CTLOC(ctLocID),"^",22)
	e  s hospID=$get(%session.Data("LOGON.HOSPID"))
	s hospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Nur_IP_BedSettings",hospID,"")
	i hospID'="" {
		s rowID=$o(^CF.NUR.NIS.BedSettingsI("HospId",hospID,""))
		i rowID'="" {
			s data=$g(^CF.NUR.NIS.BedSettingsD(rowID))
			i Priority="L" s type=$lg(data,12)
			i Priority="T" s type=$lg(data,13)
		}
	}
	s ret=0
		s ordSttTime=""
		for
		{
			s ordSttTime=$o(^OEORDi(0,"Date",oeordID,+$h,ordSttTime))
			q:(ordSttTime="")||(ret=1)
			s oeoriSub=0
			for
			{
				s oeoriSub=$o(^OEORDi(0,"Date",oeordID,+$h,ordSttTime,oeoriSub))	
				q:(oeoriSub="")!(ret=1)
				continue:'$d(^OEORDi(0,"Date",oeordID,+$h,ordSttTime,oeoriSub,1))
				continue:'$d(^OEORD(oeordID,"I",oeoriSub,"X",1))
				s ordStatID=$p($g(^OEORD(oeordID,"I",oeoriSub,1)),"^",13)
				continue:ordStatID=""
				// 过滤非当日新开
				s createDate=$p($g(^OEORD(oeordID,"I",oeoriSub,3)),"^",7)
				continue:createDate'=+$h
				// 过滤作废 撤销 停止状态的医嘱
				s statcode=""
				s Stat=$P($G(^OEORD(+oeordID,"I",oeoriSub,1)),"^",13)
				s:Stat'="" statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
				continue:(statcode="U")||(statcode="C")||(statcode="D")
				s oecprID=$p($g(^OEORD(oeordID,"I",oeoriSub,1)),"^",8)
				s ifShortOrderPrior=##class(appcom.OEOrdItem).ISShortOrderPrior(oecprID)
				continue:(Priority="L")&&(ifShortOrderPrior=1)
				continue:(Priority="T")&&(ifShortOrderPrior=0)
				s ArcimRowId=$p($g(^OEORD(+oeordID,"I",oeoriSub,1)),"^",2)
				s ArcimDesc=$P(^ARCIM(+ArcimRowId,$P(ArcimRowId,"||",2),1),"^",2)
				s catdesc=..GetOrdCat(oeordID, oeoriSub)
				continue:((catdesc["其他")&&(ArcimDesc'["会诊"))!(catdesc["材料")!(catdesc["护理")
				s userDr=$p(^OEORD(oeordID,"I",oeoriSub,7),"^",1)
				continue:userDr=""
				s cpdr=$p(^SSU("SSUSR",userDr),"^",14)
				continue:cpdr=""
				s ctcptId=$p($g(^CTPCP(cpdr,1)),"^",4)
				continue:ctcptId=""
				s cptype=$p($g(^CT("CPT",ctcptId)),"^",4)
				continue:cptype="NURSE"
				s depLoc=..getloc(oeordID,oeoriSub)
				continue:(depLoc="")&&(ArcimDesc'["会诊")	
				if (type="S") {
					// 核实
#;					s seeType=$P($G(^OEORD(oeordID,"I",oeoriSub,"NUR")),"^",7)
#;					continue:(seeType'="A")&(seeType'="F")
					s seeUserdr=$p($g(^OEORD(oeordID,"I",oeoriSub,"NUR")),"^",4)
					s seeDate=$p($g(^OEORD(oeordID,"I",oeoriSub,"NUR")),"^",5)
					continue:(seeUserdr'="")&&(seeDate'="")
					s ret=1
				}elseif (type="E") {
					// 执行
					s execdate=$p(^OEORD(oeordID,"I",oeoriSub,"X",1),"^",19) 
					s execcp=$p(^OEORD(oeordID,"I",oeoriSub,"X",1),"^",15)
					s execStatusID=$p($g(^OEORD(oeordID,"I",oeoriSub,"X",1)),"^",16) //执行状态
					continue:(execdate'="")&&(execcp'="")&&(execStatusID=1)
					s ret=1
				}elseif (type="P"){
					// 打印标记
					s printFlag=$p($g(^OEORD(oeordID,"I",oeoriSub,"X",1,"NUR")),"^",1)
					continue:printFlag'=""
					s ret=1
				} 
			}
		}
#;	}
	q ret
}

ClassMethod IfNewOrdItem0321(AdmNo, OrdPriorityFlag) As %String
{
 n (AdmNo,OrdPriorityFlag)
 s ^TMP("aa")=$LB(AdmNo, OrdPriorityFlag)
 q:$g(AdmNo)="" 0
 s oeordId=$o(^OEORD(0,"Adm",AdmNo,""))
 q:oeordId="" 0
 s ret=0
 s fl=0
 s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime)) q:(ordSttTime="")!(fl=1)  d
 .s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub)) q:(oeoriSub="")!(fl=1)  d
 ..q:'$d(^OEORDi(0,"Date",oeordId,+$h,ordSttTime,oeoriSub,1))
 ..q:'$d(^OEORD(oeordId,"I",oeoriSub,"X",1))
 ..//w !,oeoriSub
 ..s ItemStatDR=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",13)
 ..s ordtyp=..GetOrdItemTyp(oeordId,oeoriSub)
 ..s printflag=""
 ..if ordtyp="L" d
 ...s printflag=..getprintflag(oeordId,oeoriSub,1)
 ..q:$G(printflag)="Y"
 ..s PriorDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)     ;OEC_Priority
 ..q:ItemStatDR'=1
 ..s catdesc=..GetOrdCat(oeordId, oeoriSub)
 ..q:(catdesc="消耗材料")!(catdesc="普通项目")
 ..s cptype=""
 ..//w !,catdesc,"--",oeoriSub
 ..i $d(^OEORD(oeordId,"I",oeoriSub,7)) d
 ... s adduser=$p(^OEORD(oeordId,"I",oeoriSub,7),"^",1)
 ... q:adduser=""
 ... i $d(^SSU("SSUSR",adduser)) s cpdr=$p(^SSU("SSUSR",adduser),"^",14) 
 ... q:$g(cpdr)=""
 ... i $d(^CTPCP(cpdr,1)) s cptypedr=$p(^CTPCP(cpdr,1),"^",4)
 ... i $d(^CT("CPT",cptypedr)) s cptype=$p(^CT("CPT",cptypedr),"^",4)
 ..q:cptype="NURSE"
 ..s retul=..getloc(oeordId,oeoriSub)
 ..q:retul=""
 ..s ech="" 
 ..s thisexec=0       ;先定此医嘱未被执行
 ..s flag=0
 ..s execdate=$p(^OEORD(oeordId,"I",oeoriSub,"X",1),"^",19)   ;执行日期
 ..s execcp=$p(^OEORD(oeordId,"I",oeoriSub,"X",1),"^",15)     ;执行人
 ..i (execdate'="")&(execcp'="") d
 ...s thisexec=1   ;此医嘱已经被执行  
 ..i ( (thisexec=0) &&($g(PriorDR)=1)&& (OrdPriorityFlag=1))  d
 ... s ret=1
 ..i ( (thisexec=0) &&(($g(PriorDR)=5)||($g(PriorDR)=8))&& (OrdPriorityFlag=3))  d
 ... s ret=1
 ..i ( (thisexec=0) &&(($g(PriorDR)'=1))&& (OrdPriorityFlag=2))  d
 ... s ret=1 
 ..;i ( (thisexec=0) &&($g(PriorDR)=1)&& ((OrdPriorityFlag=2)||(OrdPriorityFlag=3)))  d
 ...; s ret=0
 ...; s fl=1 
 q ret
}

// 医嘱的大类

ClassMethod getloc(oeord, ordsub)
{
	 n (oeord,ordsub)
    s admId=$p($g(^OEORD(oeord)),"^",1)
	s ctlocdr=$P(^PAADM(admId),"^",4)
	 s user=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",1)
    ;w !,user
	 q:user="" ""
	 q:'$D(^SSU("SSUSR",user)) ""
	 s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	 q:DoctorDr="" "" ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))

	 q:'$D(^CTPCP(DoctorDr,1)) ""
	 s typdr=$P(^CTPCP(DoctorDr,1),"^",4)
	 s typ=$P(^CT("CPT",typdr),"^",4)
	 q:typ="NURSE" ""
	 s loc="" f  s loc=$O(^RB("RES",0,"CTPCP",DoctorDr,loc)) q:(loc="")!(loc=ctlocdr)  d
	 q:loc="" ""
	 q 1
}

ClassMethod GetOrdCat(ord, chl) As %String
{
 n (ord,chl)
 q:'$d(^OEORD(ord,"I",chl,1)) ""
 s arcimdr=$p(^OEORD(ord,"I",chl,1),"^",2)
 q:(+arcimdr=0) ""
 s schl=$p(arcimdr,"||",2)
 q:'$d(^ARCIM(+arcimdr,schl,1)) 
 s subcat=$p(^ARCIM(+arcimdr,schl,1),"^",10)
 q:subcat="" ""
 q:'$d(^ARC("IC",subcat)) ""
 s catdr=$p(^ARC("IC",subcat),"^",8)
 q:catdr="" ""
 q:'$d(^OEC("ORCAT",catdr)) ""
 s catdesc=$p(^OEC("ORCAT",catdr),"^",2)
 q catdesc
}

ClassMethod try() As %String
{
 s adm="" f  s adm=$o(^PAADMi("AdmTypeCurr","I",adm)) q:adm=""  d
 .//w ..IfNewOrdItem(adm)
 q 0
}

ClassMethod ifAdmit(EpisodeId) As %String
{
  //在院
   n (EpisodeId)
   quit:EpisodeId="" 0  //ad by wuqk 2011-07-09
   s stat=$P(^PAADM(EpisodeId),"^",20)
   s ret=1
   //if stat="A" s ret=1
   //else  s stat=0
   //else  s ret=0
   
 q ret
}

ClassMethod getmedrefuse(EpisodeId) As %String
{
  //是否有拒发的药品DHC_STDRUGREFUSE
  n (EpisodeId)
  s dat=+$H
  s flag=0
  s rw=""  f  s rw=$O(^STDF("DATE",dat,rw)) q:(rw="")!(flag=1)  d
  .s ordrowid=$P(^STDF(rw),"^",1)
  .s Ord=+ordrowid
  .s Adm=$P(^OEORD(Ord),"^",1)
  .if Adm=EpisodeId s flag=1
  q flag
}

ClassMethod getIfRejectSp(EpisodeID) As %String
{
  //是否有拒收标本  add by wkz 080229  w ##Class(web.DHCSETIMAGE).getIfRejectSp(3)
  n (EpisodeID)
  s flag=0
  q:$g(EpisodeID)="" flag
  q:'$d(^PAADM(EpisodeID)) flag
  s PaitentID=$p(^PAADM(EpisodeID),"^",1)
  s admType=$p(^PAADM(EpisodeID),"^",2)
  q:$g(PaitentID)="" flag
  q:'$D(^PAPER(PaitentID,"PAT",1)) flag
  q:admType'="I" flag
  s RegNo=$p($G(^PAPER(PaitentID,"PAT",1)),"^",1)
  s Config=##Class(websys.Configuration).%OpenId(1)
  s LABDATA=Config.LabDataNamespace
  s labNo=""
  s Status=0
  f  s labNo=$o(^[LABDATA]DHCRSi(1,Status,labNo)) q:labNo=""  d
  .s cttsCode=""
  .f  s cttsCode=$o(^[LABDATA]DHCRSi(1,Status,labNo,cttsCode)) q:cttsCode=""  d
  ..s drsId=""
  ..f  s drsId=$o(^[LABDATA]DHCRSi(1,Status,labNo,cttsCode,drsId)) q:drsId=""  d
  ...s drsStr=^[LABDATA]DHCRS(labNo,cttsCode,drsId)
  ...s labRegNo=$p(drsStr,"\",1)
  ...s Status=$p(drsStr,"\",10)
  ...q:(Status'=0)&(Status'="")
  ...if (RegNo=labRegNo)&(labRegNo'="") s flag=1
  q flag
}

ClassMethod updateRejectStat(EpisodeID) As %String
{
  //护士预览更新拒收标本的状态  add by wkz 080229  w ##Class(web.DHCSETIMAGE).updateRejectStat(3)
  n (EpisodeID)
  s flag=-1
  q:$g(EpisodeID)="" flag
  q:'$d(^PAADM(EpisodeID)) flag
  s PaitentID=$p(^PAADM(EpisodeID),"^",1)
  s admType=$p(^PAADM(EpisodeID),"^",2)
  q:$g(PaitentID)="" flag
  q:'$D(^PAPER(PaitentID,"PAT",1)) flag
  q:admType'="I" flag
  s RegNo=$p($G(^PAPER(PaitentID,"PAT",1)),"^",1)
  s Config=##Class(websys.Configuration).%OpenId(1)
  s LABDATA=Config.LabDataNamespace
  s labNo=""
  s Status=0
  f  s labNo=$o(^[LABDATA]DHCRSi(1,Status,labNo)) q:labNo=""  d
  .s cttsCode=""
  .f  s cttsCode=$o(^[LABDATA]DHCRSi(1,Status,labNo,cttsCode)) q:cttsCode=""  d
  ..s drsId=""
  ..f  s drsId=$o(^[LABDATA]DHCRSi(1,Status,labNo,cttsCode,drsId)) q:drsId=""  d
  ...s drsStr=^[LABDATA]DHCRS(labNo,cttsCode,drsId)
  ...s labRegNo=$p(drsStr,"\",1)
  ...s Status=$p(drsStr,"\",10)
  ...if (RegNo=labRegNo)&(labRegNo'="") d
  ....s RowID=labNo_"||"_cttsCode_"||"_drsId
  ....s Stat=2
  ....zn LABDATA
  ....s Sq=$$updateRejectStat^DHCNurUpdateRejectSpecimen(Stat,RowID)
  ....zn "DHC-APP"
  q "OK"
}

ClassMethod DocDisch(EpisodeID) As %String
{
 n (EpisodeID)
 s ret=0
 s EpisodeID=$g(EpisodeID)
 q:EpisodeID="" 0
 ;q:'$d(^PAADM(EpisodeID)) 0
 s stat=$p(^PAADM(EpisodeID),"^",20)
 s paperId=+^PAADM(EpisodeID)
 s deadDate=$p(^PAPER(paperId,"ALL"),"^",13)
 q:deadDate'="" ret
 q:stat'="A" ret
 i $p(^PAADM(EpisodeID),"^",60)'="" s ret=1 
 q ret
}

// 医生开病危医嘱

ClassMethod bingwei(EpisodeID) As %String
{
 s ret=0
 n (EpisodeID)
 s EpisodeID=$g(EpisodeID)
 q:EpisodeID="" 0
 s orderid=0
 s ret=0
 f  s orderid=$o(^OEORD(0,"Adm",EpisodeID,orderid)) q:orderid=""  d
 .s ordchildid=0
 .f  s ordchildid=$o(^OEORD(orderid,"I",ordchildid)) q:ordchildid=""  d
 ..s orderitem=$p(^OEORD(orderid,"I",ordchildid,1),"^",2)
 ..s orderstat=$p(^OEORD(orderid,"I",ordchildid,1),"^",13)
 ..i (orderitem="26386||1")&(orderstat'="4") d
 ...s ret=ret+1 
 q ret
}

ClassMethod GetACU(EpisodeID As %String) As %String
{
	q:($g(EpisodeID)="") 0
	s ACUDR=$P(^PAADM(EpisodeID),"^",33)
	i ACUDR="" q 0
	s ACUDESC=$P(^CT("ACU",ACUDR),"^",2)
	q ACUDESC
}

/// 所有有未执行医嘱的病人
ClassMethod GetAllNewOrdPat(wardID As %String = "") As %String
{
	n (wardID)
	s retStr=""
	q:wardID="" retStr
	s inPatientNum=0
	s patRoomId=""
    f  s patRoomId=$o(^PAADMi("CurrWard",wardID,patRoomId)) q:patRoomId=""  d
    .s EpisodeId=0
    .f  s EpisodeId=$o(^PAADMi("CurrWard",wardID,patRoomId,EpisodeId)) q:EpisodeId=""  d
    ..s patVisit=$p($g(^PAADM(EpisodeId)),"^",20)
    ..q:patVisit'="A"
    ..s paPmiId=$p($g(^PAADM(EpisodeId)),"^",1)
    ..s regNo=$p($g(^PAPER(paPmiId,"PAT",1)),"^",1)
    ..s patName=$p($g(^PAPER(paPmiId,"ALL")),"^",1)
    ..s sex=$p($g(^CT("SEX",$p($g(^PAPER(paPmiId,"ALL")),"^",7))),"^",2)
    ..s bedSub=$p($p($g(^PAADM(EpisodeId)),"^",73),"||",2)
    ..s inPatientNum=inPatientNum+1
    ..q:bedSub=""
    ..s bedDr=wardID_"||"_bedSub
    ..s bedCode=$p($g(^PAWARD(wardID,"BED",bedSub)),"^",1)
    ..q:bedCode=""
    ..s ifNewOrdFlag=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeId),2)
    ..s ifNewCQOrdFlag=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeId),3)
    ..q:(ifNewOrdFlag=0)&(ifNewCQOrdFlag=0)
    ..;q:ifNewOrdFlag=0
    ..i bedCode'["床" s bedCode=bedCode_"床"
    ..s patStr=" <A href='#' onClick='selectPatient("""_bedDr_""")',false,'top=40,left=40,width=640,height=480'), title="_regNo_","_patName_","_sex_","_bedDr_" border=0>"_bedCode_",</A>"
    ..i retStr="" d
    ...s retStr=patStr
    ..e  s retStr=retStr_" "_patStr

    i retStr'="" s retStr="有新医嘱病人:"_retStr
	i inPatientNum'=0 s retStr=retStr_"当前在院人数:"_inPatientNum

	q retStr  //_"<br>"_" <A href='#' onClick='openWindow(""BINZ"")'> 病重:"_critiSum_",</A>"
}

Query FindRefDispDrug(EpisodeID As %String) As %Query(ROWSPEC = "date:%String,time:%String,userName:%String,arcitmDesc:%String,locDesc:%String")
{
}

ClassMethod FindRefDispDrugExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	i EpisodeID="" s qHandle=$lb(0,repid,0) q $$$OK
    s oeordId=""
    s oeordId = $o(^OEORD(0,"Adm",EpisodeID,oeordId))  
    i $g(oeordId)="" q
    s RefuseOEOrderDr=""
    s RefuseId=""
    f  s RefuseId=$o(^STDF("DATE",+$h,RefuseId)) q:$g(RefuseId)=""  d
    .s refOeordId=$p(^STDF(RefuseId),"^",1)
    .q:oeordId'=+refOeordId
    .s date=$p(^STDF(RefuseId),"^",4)
    .i date'="" s date=$zd(date,3)
    .s time=$p(^STDF(RefuseId),"^",5)
    .i time'="" s time=$zt(time)
    .e  s time=""
    .s userID=$p(^STDF(RefuseId),"^",6)
    .i userID'="" s userName=$p(^SSU("SSUSR",+userID),"^",2 )
    .e  s userName=""
    .s oeoriId=$P(refOeordId,"||",1)
    .q:oeoriId=""
    .s oeoriSub=$P(refOeordId,"||",2)
    .q:oeoriSub=""
    .s arcitmDr=$P($G(^OEORD(oeoriId,"I",oeoriSub,1)),"^",2)
    .i arcitmDr'="" s arcitmDesc=$P($G(^ARCIM(+arcitmDr,$P(arcitmDr,"||",2),1)),"^",2)
    .e  s arcitmDesc=""
    .s locDr=$p(^STDF(RefuseId),"^",2)
    .i locDr'="" s locDesc=$P($G(^CTLOC(locDr)),"^",2)
    .e  s locDesc=""
	.d OutputRow4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow4
	s Data=$lb(date,time,userName,arcitmDesc,locDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindRefDispDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRefDispDrugExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {	
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindRefDispDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRefDispDrugExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod IfDischargePat(EpisodeID, needDhcadmStatus)
{
	//dhcadmStatus D 出院病人，R 招回病人
	q:EpisodeID="" 0
	q:needDhcadmStatus="" 0
	s dhcadmId=$O(^DHCPAAdm(0,"PAAdm",EpisodeID,""))
	i dhcadmId="" q 0
	s dhcadmStatus=$p(^DHCPAAdm(dhcadmId),"^",3)
	q:dhcadmStatus="" 0
	q:needDhcadmStatus[dhcadmStatus 1
	q 0
}

/// Creator：      huhm
/// CreatDate：    20090504
/// Description:： 判断是否有未阅读过包含警戒值或荒诞值结果的报告
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有Others：       
ClassMethod ReportWarn(AdmNo As %String) As %String
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	s RtnValue=0
	s OEOrdId=""	
	f {	s OEOrdId=$o(^OEORD(0,"Adm",AdmNo,OEOrdId))		q:OEOrdId=""  
		s OEOrdSub="0"		
		f {	
			s OEOrdSub=$o(^OEORD(OEOrdId,"I",OEOrdSub))	
			q:OEOrdSub=""	
			i RtnValue=1 q	
			s TestSetRow=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,3)),"^",35)
			i $l(TestSetRow){
				//w !,TestSetRow	
				Set WebNS=$ZUTIL(5)	
				s RepStus=..ReportStatus(TestSetRow,LabData)
				//w ",",RepStus
				zn WebNS
				i RepStus=0{
					b		
					i ..ReportViewLog(OEOrdId_"||"_OEOrdSub)=100{	
					//w !,"oeord",OEOrdId_"||"_OEOrdSub	
					s RtnValue=1	
					}
				}
			}
		}
	} 
	s ^TMPREPORT($G(AdmNo))=RtnValue
	Quit RtnValue
}

// 结果查看记录

ClassMethod ReportViewLog(requestId As %String) As %String
{
	&sql(select * from websys.Log where requestID=:requestId)	Quit SQLCODE
}

// 报告状态

ClassMethod ReportStatus(TSRowId As %String, LabNS As %String) As %String
{
	//new (TSRowId)	//	zn LabNS
		Set LabNo=$p(TSRowId,"||",1)
		Set TS=$p(TSRowId,"||",2)
		Set TSCnt=$p(TSRowId,"||",3)
		If '$l(LabNo) Quit 100
		If '$l(TS) Quit 100
		i '$d(^TEPI(LabNo,1,TS,TSCnt)) Quit 100
		Set ResStus=$p(^TEPI(LabNo,1,TS,TSCnt),"\",31)
		i ResStus'="A" Quit 100	
		s TransDate=$o(^DHCTSTrans(LabNo,TS,TSCnt,""),-1)	
		i '$l(TransDate) Quit 100	
		s TransTime=$o(^DHCTSTrans(LabNo,TS,TSCnt,TransDate,""),-1)	
		i '$l(TransTime) Quit 100	
		s TransStr=$g(^DHCTSTrans(LabNo,TS,TSCnt,TransDate,TransTime))	
		i '$l(TransStr) Quit 100	
		s RetValue=100	
		s Status=$p(TransStr,"\",2)	//警戒报告	
		i Status="PNC" s RetValue=0	//荒诞报告	
		i Status="RU" s RetValue=0	
		Quit RetValue
}

// 根据病区ID,床位ID，找包床患者

ClassMethod FindStatPat(BedID As %String)
{
	//w ##class(web.DHCSETIMAGE).FindStatPat("10||18")
	q:BedID="" ""
	q:$l(BedID,"||")<2 ""
	s patName=""
	s STATWardId=$p(BedID,"||")
	s STATBedChildsub=$P(BedID,"||",2)
	s STATChildsub=$O(^PAWARDA(STATWardId,"BED",STATBedChildsub,"STAT",""),-1)
	s sdate = +$h, stime = $p($h,",",2)
	s ind=0 f  s ind=$O(^PAWARDA(STATWardId,"BED",STATBedChildsub,"STAT",ind)) q:ind=""  d
	.s data=$g(^PAWARDA(STATWardId,"BED",STATBedChildsub,"STAT",ind))
	.s sd=$p(data,"^",1),st=$p(data,"^",2)
	.s td=$p(data,"^",5),tt=$p(data,"^",6)
	.q:(sd'="")&&(sd>sdate)
	.q:(sd'="")&&(st'="")&&(sd=sdate)&&(st>stime)
	.q:(td'="")&&(td<sdate)
	.q:(td'="")&&(tt'="")&&(td=sdate)&&(tt<stime)
	.s bedStatusDR=$p(data,"^",3)
	.s bedStatus=$s(bedStatusDR'="":$p($g(^PAC("BSTAT",bedStatusDR)),"^",1),1:"")
	.if bedStatus="U" d
	..s unavail=1
	..s AdmId=$p($G(^PAWARDA(STATWardId,"BED",STATBedChildsub,"STAT",ind,"DHC")),"^",1)
	..q:AdmId=""
	..s papmiId=$p($g(^PAADM(AdmId)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	
	
	
	q patName
}

ClassMethod IfWeightInWeek(EpisodeID) As %String
{
	n (EpisodeID)
	s ret=1
	//s week=$ZD(date,10) 取星期几
	s Mradm=""
	s Mradm=$p(^PAADM(EpisodeID),"^",61)  
	s StartDate=$p(^PAADM(EpisodeID),"^",6)
	
	s chl=0
	f  s chl=$o(^MR(Mradm,"OBS",chl)) q:($g(chl)="")!(ret=0)  d
	.s itemdr=$p(^MR(Mradm,"OBS",chl),"^",1)
	.s OBSDate=$p(^MR(Mradm,"OBS",chl),"^",3)
	.i (+itemdr =35) d
    ..s weekNo=(+$h-StartDate)\7
    ..s weekNum=(+$h-StartDate+1)-(7*weekNo)
    ..b ;01
	..i (OBSDate>=+$h-weekNum+1)&(OBSDate<+$h) d
	...s ret=0        
	q ret
}

/// Creator:      SongChao
/// CreateDate:   2017.9.4
/// Description:  当天新转入的病人
/// Input:
/// Return:
/// Other:        ##class(web.DHCSETIMAGE).IfNewTransferInPat()
ClassMethod IfNewTransferInPat(EpisodeID) As %String
{
	n (EpisodeID)
	s ret=0
	s transSub=""
	f  s transSub = $O(^PAADM(EpisodeID,"TRANS",transSub),-1) q:(transSub="")!(ret=1)  d
	.s transStartDate=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",1)
	.s transTypeDr = $p(^PAADM(EpisodeID,"TRANS",transSub),"^",21)
	.s:transTypeDr'="" transType= $p($g(^PAC("TRANSTYP",transTypeDr)),"^",2)
	.i ($g(transType)="Transfer")&&(transStartDate=+$h) s ret=1
	q ret
}

/// Creator:      SongChao
/// CreateDate:   2017.9.22
/// Description:  添加取消转科流程后,转科判断(转入)
/// Input:
/// Return:
/// Other:        ##class(web.DHCSETIMAGE).IsTransInPat()
ClassMethod IsTransInPat(EpisodeId, WardIdD, days = 1)
{
	n (EpisodeId, WardIdD,days)
	;s ^tempsc("IsTransInPat",$h)=$lb(EpisodeId, WardIdD)
	q:EpisodeId="" 0
	i $g(WardIdD)="" s WardIdD=""
	;q:WardId="" 0
	;q:EpisodeId="411538" 0
	s curDate=+$h
	s ret=0
	s preLoc=""
	s ChildSub=0
	f  s ChildSub=$o(^PAADM(EpisodeId,"TRANS",ChildSub)) q:(ChildSub="")!(ret=1)  d
	.s TransInfo=^PAADM(EpisodeId,"TRANS",ChildSub)
	.;s Loc=$p(TransInfo,"^",6)  //以科室不同算转科
	.s Loc=$p(TransInfo,"^",9)  //以病区不同算转科
	.q:Loc=1
	.q:Loc=""
	.s TransDate=$p(TransInfo,"^",1)
	.i preLoc'=Loc d
	..//i (preLoc'="")&(TransDate=curDate) s ret=1
	..i (preLoc'="")&(+TransDate > (+$h-days))&(+TransDate <= +$h) s ret=1
	..s preLoc=Loc

	i ret=0 d
	.s rw=$o(^Nur.DHCNurTransAuditI("AdmStatus"," "_EpisodeId," S",""))
	.q:rw=""
	.s obj=##Class(Nur.DHCNurTransAudit).%OpenId(rw)
	.//q:obj.TranDate'=+$h
	.q:obj.CurWard=WardIdD
	.i (+obj.TranDate > (+$h-days))&(+obj.TranDate <= +$h) s ret=1
	q ret
}

/// Creator:      SongChao
/// CreateDate:   2017.9.22
/// Description:  添加取消转科流程后,转科判断(转出)
/// Input:
/// Return:
/// Other:        ##class(web.DHCSETIMAGE).IsTransInPat()
ClassMethod IsTransOutPat(EpisodeId, WardId)
{
	n (EpisodeId, WardId)
	s ^tempsc("IsTransOutPat")=$lb(EpisodeId, WardId)
	q:EpisodeId="" 0
	s curDate=+$h
	s ret=0
	b
	
	i ret=0 d
	.s rw=$o(^Nur.DHCNurTransAuditI("AdmStatus"," "_EpisodeId," A",""))
	.b
	.q:rw=""
	.s obj=##Class(Nur.DHCNurTransAudit).%OpenId(rw)
	.b
	.q:obj.TranDate'=+$h
	.q:obj.CurWard'=WardId
	.q:obj.TranWard=WardId
	.s ret=1
	q ret
}

/// Creator:      songchao
/// CreateDate:   2018.12.
/// Description:  
/// Input:       
/// Return:       
/// Other:        ##Class(web.DHCSETIMAGE).IfSpecRefuse(5,"P")
ClassMethod IfSpecRefuse(EpisodeId, SpecTeam)
{
	n (EpisodeId,SpecTeam)
	s ^tempsc("IfPisRefuse")=$lb(EpisodeId)
	s ret=0
	s carryDetailID=""
	f  s carryDetailID=$o(^Nur.NurseCarryDetailI("EpisodeID"," "_EpisodeId," F",carryDetailID)) q:((carryDetailID="")!(ret=1))  d
	.s detailGol=^Nur.NurseCarryDetailD(carryDetailID)
	.s labNo=$LG(detailGol,12)
	.s carryDr=$LG(detailGol,2)
	.s team=$LG(^Nur.NurseCarryD(carryDr),31)
	.q:team'=SpecTeam
	.s ordStat=##Class(Nur.HISUI.SpecManage).getSpecOrdState(labNo)
	.q:ordStat'="V"
	.s carryDetailDr=$o(^Nur.NurseCarryDetailI("LabNo"," "_labNo,""),-1) 
	.s transStat=$LG(^Nur.NurseCarryDetailD(carryDetailDr),39)
	.i transStat="F" s ret=1
	q ret
}

/// Creator:      
/// CreateDate:		2020.12.4
/// Description:	判断是否为纠纷患者
/// Input:     	  	就诊号
/// Return:       	
/// Other:        	##Class(web.DHCSETIMAGE).IfisputePat()
ClassMethod IfisputePat(EpisodeId)
{
	n (EpisodeId)
	q:EpisodeId="" 0
	s papmiID=+$g(^PAADM(+EpisodeId))
	s flag=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDisputePatFlag",papmiID)
	q:flag="Y" 1
	q 0
}

/// CreateDate:   2022.05.17
/// Description:  是否术后三日内
/// Input:        EpisodeID:就诊号
/// Return:       1:是 0：否
/// s img=##class(web.DHCSETIMAGE).ifOperationEndDay($g(EpisodeID),3) //术后三天
ClassMethod ifOperationEndDay(EpisodeID, opEndDay)
{
	n (EpisodeID,opEndDay,%session)
	s ret=0
	Set $ZTrap = "ErrorHandle1"
	s objList= ##class(CIS.AN.SRV.OperService).GetOperInfoByEpisode(EpisodeID,"")
	s num = objList.Count()
	for j=1:1:num
	{
		s sinOpObj = objList.GetAt(+j)
		s opEndDate = sinOpObj.OperFinishDT
		s opEndDate=$p(opEndDate," ")
		continue:opEndDate=""
		q:ret=1
		s opEndDate=##class(websys.Conversions).DateHtmlToLogical(opEndDate)
		s:(opEndDate'=+$h)&&(+$h<=(opEndDate+opEndDay)) ret=1
	}
	q ret
ErrorHandle1
	q ret
}

/// CreateDate:   2022.05.17
/// Description:  当日是否存在加急医嘱(护士已处理或执行后不显示)
/// Input:        EpisodeID:就诊号
/// Return:       1:是 0：否
/// s img=##class(web.DHCSETIMAGE).IfEmrOrder($g(EpisodeId))
ClassMethod IfEmrOrder(EpisodeId)
{
	n (EpisodeId,%session)
	q:EpisodeId="" 0
	s orderId=$o(^OEORD(0,"Adm",EpisodeId,""),-1)
	q:orderId="" 0
	s sub=""
	s flag=""
	for {
		s sub=$o(^OEORDi(0,"StDt",+$h,orderId,sub)) q:(sub="")||(flag'="")
		s ordStatusId=$P($g(^OEORD(orderId,"I",sub,1)),"^",13)
	    s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
	    continue:(ordStat="C")!(ordStat="D")!(ordStat="U")
	    s ordDisposeStatCode=##class(Nur.NIS.Service.Base.Order).GetOrderDisposeStatCode(orderId,sub)
	    continue:(ordDisposeStatCode="AlreadyDeal")
		s OEORINotifyClinician = $p($G(^OEORD(orderId,"I",sub,11)),"^",55)
	    s flag=$case(OEORINotifyClinician,"Y":"急",:"")
	}
	q:flag'="" 1
	q 0
}

/// Creator: ouzilin
/// CreateDate: 20220516
/// Description: 三天未大便/三天未测大便
/// Input: episodeID,flag 1:判断三天未大便 0:判断三天未测大便（填写0也算大便）
/// Return:1 是 0不是
/// Other: ##Class(web.DHCSETIMAGE).IfThreeDayNotDef(episodeID)
ClassMethod IfThreeDayNotDef(episodeID, flag = 1)
{
	n (episodeID,flag)
	q:episodeID="" 0
	s admDate=$p(^PAADM(episodeID,"DHC"),"^",31)
	q:(admDate="")||(admDate>(+$h-3)) 0
	s admLoc=$p($g(^PAADM(episodeID)),"^",4)
	q:admLoc="" 0
	s HospitalID=$p($g(^CTLOC(admLoc)),"^",22)
	s temperatureDr=$o(^MRC("OBITM",0,"HOSPCode",HospitalID,$$ALPHAUP^SSUTIL4("defFreq"),""))
	s ret=0,reg=0,ren=0
	s mradm=$p(^PAADM(episodeID),"^",61)
	s sdate=+$h
	s edate=+$h-3
	i $d(^MR(mradm,"OBS",0,"Date",+$h,temperatureDr)) d
	.s edate=+$h-2
	i '$d(^MR(mradm,"OBS",0,"Date",+$h,temperatureDr)) d
	.s sdate=+$h-1
	f date=sdate:-1:edate d
	.s obschild="" f  s obschild=$o(^MR(mradm,"OBS",0,"Date",date,temperatureDr,obschild)) q:obschild=""  d
	..s OBSValue=$p(^MR(mradm,"OBS",obschild),"^",2)
	..s:(OBSValue'="0")&&(OBSValue'="0次")&&(OBSValue'="")&&(flag=1) reg=1
	..s ren=ren+1
	s:(reg=0)&&(flag=1) ret=1
	s:(ren=0)&&(flag=0) ret=1
	q ret
}

/// 是否手术(当日存在手术事件)
ClassMethod ifOperationByAdmQTREC(EpisodeID) As %String
{
    n (EpisodeID)
    q:EpisodeID="" 0
    s adm=EpisodeID
    s ret=0
    s rw=0
    for{  
    	s rw=$O(^DHCADMQTREC("adm",EpisodeID,rw)) q:(rw="")!(ret=1)
		s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
		s Typ=""
		i TypDr'="" s Typ=$p($G(^DHCQTRECTYP("typ",TypDr)),"^",2)
		s date=$p(^DHCADMQTREC("QTREC",rw),"^",2)
		continue:1=$p(^DHCADMQTREC("QTREC",rw),"^",9)
		i ($g(Typ)="手术")&&(date=(+$h)) s ret=1
    }
	q ret
}

/// CreateDate: 20221231
/// Description: 已制定护理计划、触发问题的数据已删除或已变更
/// Input: episodeID,flag 1:已制定护理计划 2:触发问题的数据已删除或已变更
/// Return:1 是 0不是
/// Other: w ##Class(web.DHCSETIMAGE).IfNursePlanByAdm("39",1)
ClassMethod IfNursePlanByAdm(episodeID, flag = 1)
{
	n (episodeID,flag)
	q:episodeID="" 0
	s className = "Nur.NIS.Service.NursingPlan.QuestionRecord"
    s classQuery = "GetPatientQuestionList"
    s rs=##class(%Library.ResultSet).%New(className_":"_classQuery) 
    //执行Query
    if (flag = 1){
	    ;已制定护理计划:只要制定了护理计划就显示,同时制定目标和措施 --代表制定完整的护理计划
    	d rs.Execute(episodeID, "", "", "0^1", "", "0^1", "") ;默认为入科日期 和 当天日期;	状态:未停止、已停止;	评价状态：未评价、已评价
    }elseif(flag = 2){
	    ;触发问题的数据已删除或已变更:截止当日有触发护理问题的相关因素源数据已删除或已变更，且护理问题仍为“未停止或未评价”的；
	    d rs.Execute(episodeID, "", "", "0", "", "0", "") ;默认为入科日期 和 当天日期;	状态:未停止;	评价状态：未评价
	}
	s ret=0
	s linkQueShowFlag=""
    while rs.Next()'=0
    {
	    continue:ret=1
        s columnNum=rs.GetColumnCount()
        f i=1:1:columnNum
        {
            s columnName=rs.GetColumnName(i)
            s columnValue=rs.GetDataByName(columnName) 
            if (columnName="linkQueShowFlag"){
				s linkQueShowFlag=columnValue
			}
			if (linkQueShowFlag[flag){
				s ret=1
				continue
			}			
        }
    }
    q ret
}

/// CreateDate: 20221231
/// Description: 护理计划到期提醒
/// Input: episodeID
/// Return:1 是 0不是
/// Other: w ##Class(web.DHCSETIMAGE).IfPlansAlertByAdm("39")
ClassMethod IfPlansAlertByAdm(episodeID)
{
	n (episodeID)
	q:episodeID="" 0
	s className = "Nur.NIS.Service.NursingPlan.QuestionRecord"
    s classQuery = "GetPlansAlertList"
    s rs=##class(%Library.ResultSet).%New(className_":"_classQuery) 
    //执行Query
    ;护理计划到期提醒:截止当日有护理问题到期且未开展评价或停止的；
    d rs.Execute(episodeID, "", "") ;默认为当天日期;

	s ret=0
	s playDate=""
    while rs.Next()'=0
    {
	    continue:ret=1
        s columnNum=rs.GetColumnCount()
        f i=1:1:columnNum
        {
            s columnName=rs.GetColumnName(i)
            s columnValue=rs.GetDataByName(columnName) 
            if (columnName="playDate"){
				s playDate=columnValue
			}
			if (playDate=##class(websys.Conversions).DateLogicalToHtml($p($h,",",1))){
				s ret=1
				continue
			}			
        }
    }
    q ret
}

/// 成人疼痛图标
/// s img=##class(web.DHCSETIMAGE).ifDangerTTRedCRNew(93272582)
ClassMethod ifDangerTTRedCRNew(EpisodeID)
{
	n (EpisodeID)
	s wardID=$p(^PAADM(EpisodeID),"^",70)
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s flag=0
	s ret=""
	q:hospital'=3 ""
	s EvalDate="",EvalTime=""
	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"5217486527b34649a4ea9737b0077cdc","Item86")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"5217486527b34649a4ea9737b0077cdc","Item127"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"5217486527b34649a4ea9737b0077cdc","Item128")

	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"de4c5a200ddb413e8a6903a1ee4036f9","Item60")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"de4c5a200ddb413e8a6903a1ee4036f9","Item63"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"de4c5a200ddb413e8a6903a1ee4036f9","Item64") ;中医

	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"3794b115f615431cbf3bac622eb6fc9c","Item97")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"3794b115f615431cbf3bac622eb6fc9c","Item141"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"3794b115f615431cbf3bac622eb6fc9c","Item142") ;老年
	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"0716c3bf230a4e9cac09bb5e2f30db8c","Item75")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"0716c3bf230a4e9cac09bb5e2f30db8c","Item89"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"0716c3bf230a4e9cac09bb5e2f30db8c","Item90") ;疼痛
	i (wardID="54")!(wardID="55") s scScore="" ;产科首次无疼痛
	s:Date'="" EvalDate=Date
	s:Time'="" EvalTime=Time
	;s:EvalDate'="" EvalDate=$zd(EvalDate,3)
	;s:EvalTime'="" EvalTime=$zt(EvalTime,2)
	i "^128^130^"'[("^"_wardID_"^") d
	.s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item50"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item22"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item29"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item49"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item21"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item28"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item48"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item20"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item27"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item47"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item19"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item26"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item46"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item18"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item25"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item45"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item17"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item24"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item44"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","CareDate"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","CareTime"),"^",1)
	.s:Date'="" EvalDate=$zd(Date,3)
	.s:Time'="" EvalTime=$zt(Time,2)
	.s ttScore=$p(retTT,"^",1)
	.s ttTime=$p(retTT,"^",2)
	.s retTem=..getLastItemValue(EpisodeID, "painInten")
	.s temScore=$p(retTem,"^",1)
	.s temTime=$p(retTem,"^",2)
	.i temScore'="" s ret=temScore,EvalDate=$zd($p($fn(temTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(temTime/100000,"",5),".",2),2)
	.b ;1
	.i ttScore'="" s ret=ttScore,EvalDate=$zd($p($fn(ttTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(ttTime/100000,"",5),".",2),2)
	.b ;1/1
	.i (ttScore'="")&&(temScore'="") d
	..s ret=$s(ttTime>temTime:(ttScore),1:(temScore))
	..s:ttTime>temTime EvalDate=$zd($p($fn(ttTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(ttTime/100000,"",5),".",2),2)
	..s:ttTime<temTime EvalDate=$zd($p($fn(temTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(temTime/100000,"",5),".",2),2)
	.b ;2
	i ret="" s ret=scScore
	b ;123
	q:(+ret>=7) EvalDate_" "_EvalTime_"^"_ret
	q ""
}

/// ##class(web.DHCSETIMAGE).GetLastRecord("70001210","02d31ee0074d4628b7dc35a5cfb5da7b","Item4")
ClassMethod GetLastRecord(Adm, emrcode, itemCode, range = -1)
{
	i range'=1 s range=-1
	s emrcode=$zconvert(emrcode,"U")
	s dateTime=0
	s ret=""
	s CareDate="" f  s CareDate=$o(^NurMp.DHCTempMultDataI("TypAdmDatTim"," "_emrcode," "_Adm,CareDate),range) q:(CareDate="")!(ret'="")  d
	.s CareTime="" f  s CareTime=$o(^NurMp.DHCTempMultDataI("TypAdmDatTim"," "_emrcode," "_Adm,CareDate,CareTime),range) q:(CareTime="")!(ret'="")  d
	..s id="" f  s id=$o(^NurMp.DHCTempMultDataI("TypAdmDatTim"," "_emrcode," "_Adm,CareDate,CareTime,id),range) q:(id="")!(ret'="")  d
	...s obj=##class(NurMp.DHCTempMultData).%OpenId(id)
	...q:obj.RecCancelUser'=""
	...s val=$ZOBJPROPERTY(obj,itemCode)
	...i val'="" s ret=val s dateTime=$zdh($replace(CareDate," ",""),3)*100000+$zth($replace(CareTime," ",""))
	q ret_"^"_dateTime
}

/// w ##class(web.DHCSETIMAGE).getLastItemValue("70001210","painInten")
ClassMethod getLastItemValue(episodeID, itemCode)
{
	n (episodeID, itemCode)
	s mrAdmID=$P(^PAADM(episodeID),"^",61)
	s dateTime=0
	s itemID=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(itemCode),""))
	s date="" f  s date=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date),-1) q:(date="")!($g(findFlag)=1)  d
	.s time="" f  s time=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date,time),-1) q:(time="")!($g(findFlag)=1)  d
	..s obsID=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date,time,""),-1)
	..q:obsID=""
	..s value=$P(^MR(mrAdmID,"OBS",obsID),"^",2)
	..i value="undefined" s value=""
	..q:value=""
	..s dateTime=date*100000+time
	..s findFlag=1
	q $g(value)_"^"_dateTime
}

/// 成人疼痛图标
/// s img=##class(web.DHCSETIMAGE).ifDangerTTYellowCRNew(72291388)
ClassMethod ifDangerTTYellowCRNew(EpisodeID)
{
	n (EpisodeID)
	s wardID=$p(^PAADM(EpisodeID),"^",70)
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	s hospital=$p($g(^CTLOC(admLoc)),"^",22)
	s flag=0
	s ret=""
	q:hospital'=3 ""
	s EvalDate="",EvalTime=""
	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"5217486527b34649a4ea9737b0077cdc","Item86")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"5217486527b34649a4ea9737b0077cdc","Item127"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"5217486527b34649a4ea9737b0077cdc","Item128")

	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"de4c5a200ddb413e8a6903a1ee4036f9","Item60")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"de4c5a200ddb413e8a6903a1ee4036f9","Item63"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"de4c5a200ddb413e8a6903a1ee4036f9","Item64") ;中医

	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"3794b115f615431cbf3bac622eb6fc9c","Item97")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"3794b115f615431cbf3bac622eb6fc9c","Item141"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"3794b115f615431cbf3bac622eb6fc9c","Item142") ;老年
	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"0716c3bf230a4e9cac09bb5e2f30db8c","Item75")
	i scScore'="" s Date=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"0716c3bf230a4e9cac09bb5e2f30db8c","Item89"),Time=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"0716c3bf230a4e9cac09bb5e2f30db8c","Item90") ;疼痛
	i (wardID="54")!(wardID="55") s scScore="" ;产科首次无疼痛
	s:Date'="" EvalDate=Date
	s:Time'="" EvalTime=Time
	;s:EvalDate'="" EvalDate=$zd(EvalDate,3)
	;s:EvalTime'="" EvalTime=$zt(EvalTime,2)
	i "^128^130^"'[("^"_wardID_"^") d
	.s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item50"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item22"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item29"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item49"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item21"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item28"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item48"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item20"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item27"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item47"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item19"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item26"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item46"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item18"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item25"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item45"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item17"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item24"),"^",1)
	.i $p(retTT,"^",1)="" s retTT=..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","Item44"),Date=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","CareDate"),"^",1),Time=$p(..GetLastRecord(EpisodeID,"ee0c42cbb32b43d6b013a8bb9bb1baf5","CareTime"),"^",1)
	.s:Date'="" EvalDate=$zd(Date,3)
	.s:Time'="" EvalTime=$zt(Time,2)
	.s ttScore=$p(retTT,"^",1)
	.s ttTime=$p(retTT,"^",2)
	.s retTem=..getLastItemValue(EpisodeID, "painInten")
	.s temScore=$p(retTem,"^",1)
	.s temTime=$p(retTem,"^",2)
	.i temScore'="" s ret=temScore,EvalDate=$zd($p($fn(temTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(temTime/100000,"",5),".",2),2)
	.b ;1
	.i ttScore'="" s ret=ttScore,EvalDate=$zd($p($fn(ttTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(ttTime/100000,"",5),".",2),2)
	.b ;1/1
	.i (ttScore'="")&&(temScore'="") d
	..s ret=$s(ttTime>temTime:(ttScore),1:(temScore))
	..s:ttTime>temTime EvalDate=$zd($p($fn(ttTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(ttTime/100000,"",5),".",2),2)
	..s:ttTime<temTime EvalDate=$zd($p($fn(temTime/100000,"",5),".",1),3),EvalTime= $zt($p($fn(temTime/100000,"",5),".",2),2)
	.b ;2
	i ret="" s ret=scScore
	b ;123
	q:(+ret>=4)&&(+ret<=6) EvalDate_" "_EvalTime_"^"_ret
	q ""
}

/// s img=##class(web.DHCSETIMAGE).ifDangerTTRed(70001210)
ClassMethod ifDangerTTRed(EpisodeID)
{
	n (EpisodeID)
	s wardID=$p(^PAADM(EpisodeID),"^",70)
	s flag=0
	s ret=""
	
	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"c436c0bdf5e942c1ad40bd7a5f4d3d6b","Item190")
	i "^118^128^130^"[("^"_wardID_"^") d
	.s retTT=..GetLastRecord(EpisodeID,"02d31ee0074d4628b7dc35a5cfb5da7b","Item4")
	.s ttScore=##class(Nur.JSON).Decode($p(retTT,"^",1)).GetAt(1).GetAt("Text")
	.s ttTime=$p(retTT,"^",2)
	.s retTem=..getLastItemValue(EpisodeID, "painInten")
	.s temScore=$p(retTem,"^",1)
	.s temTime=$p(retTem,"^",2)
	.i ttScore="" s ret=temScore
	.e  i temScore="" s ret=ttScore
	.e  i (ttScore'="")&&(temScore'="") d
	..s ret=$s(ttTime>temTime:(ttScore),1:(temScore))
	i ret="" s ret=scScore
	i +ret>=5 s flag=1

	q flag
}

/// 儿童疼痛图标
/// s img=##class(web.DHCSETIMAGE).ifDangerTTYellow(70001210)
ClassMethod ifDangerTTYellow(EpisodeID)
{
	n (EpisodeID)
	s wardID=$p(^PAADM(EpisodeID),"^",70)
	s flag=0
	s ret=""
	
	s scScore=##class(NurMp.DHCMGNurComm).GetLastRecord(EpisodeID,"c436c0bdf5e942c1ad40bd7a5f4d3d6b","Item190")
	//b ;123
	i "^118^128^130^"[("^"_wardID_"^") d
	.s retTT=..GetLastRecord(EpisodeID,"02d31ee0074d4628b7dc35a5cfb5da7b","Item4")
	.s ttScore=##class(Nur.JSON).Decode($p(retTT,"^",1)).GetAt(1).GetAt("Text")
	.s ttTime=$p(retTT,"^",2)
	.s retTem=..getLastItemValue(EpisodeID, "painInten")
	.s temScore=$p(retTem,"^",1)
	.s temTime=$p(retTem,"^",2)
	.i ttScore="" s ret=temScore
	.e  i temScore="" s ret=ttScore
	.e  i (ttScore'="")&&(temScore'="") d
	..s ret=$s(ttTime>temTime:(ttScore),1:(temScore))
	i ret="" s ret=scScore
	
	i (+ret>=3)&&(+ret<5) s flag=1

	q flag
}

}
