Import SQLUser

Include Nur.DateFormat

/// 程序名DHCLCNUREXCUTE,护士执行
Class web.DHCNurIpComm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 356;

ClassMethod SetDisconOrder(oeoriId As %String, userId As %String)
{
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	s curDate=+$h,curTime=$p($h,",",2)
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DisconUser_Dr,DHCORI_DisconDate,DHCORI_DisconTime) values(:oeoriId,:userId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:userId,DHCORI_DisconDate=:curDate,DHCORI_DisconTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
    //s ^DHCCLNurseExec("DISCON","OrdItem",oeoriId)=+$h_"^"_$p($h,",",2)_"^"_userId
    q +$h_"^"_$p($h,",",2)
}

ClassMethod UndoDisconOrder(oeoriId As %String, userId As %String)
{
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" q 0
	s nullStr=""
	&sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:nullStr,DHCORI_DisconDate=:nullStr,DHCORI_DisconTime=:nullStr where DHCORI_OEORI_Dr=:oeoriId)
    //k ^DHCCLNurseExec("DISCON","OrdItem",oeoriId)
    q 0
}

ClassMethod PHASTAT(Ord, OrdSub)
{
 
   n (Ord,OrdSub)
     s i=0
	
	 s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:(OrdEx="")!(i=1)  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:(OrdDsp="")!(i=1)  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s i=i+1
    ..s Stat=$P(Dsp,"^",6)  
    ..b
 q $G(Stat)
}

ClassMethod exeordset(ExDateTime, oeoridseatno, userId, flag)
{
  //执行关联医嘱	param="Y^"+basedose+"^"+curExecStatDesc+"^"+userId+"^"+oeoriId+"^"+arcicId;
 //^OEORDi(0,"NotExecE",{OE_Order.OEORD_RowId},{OEORE_ExStDate},     x
 //   +{OEORE_ExStTime},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
	n (ExDateTime,oeoridseatno, userId,flag)
	//s ExDateTime="2006-03-27 08:00"
	//s oeoridseatno="51||8||^333"
	//s userId=1
	s oeorid=$P(oeoridseatno,"^",1)
	s seatNo=$P(oeoridseatno,"^",2)
	s oew=$P(oeorid,"||")
	s oewsub=$P(oeorid,"||",2)
	s oewexsub=$P(oeorid,"||",3)
	if (ExDateTime'="")
	{ 
	s ExDate=$ZDH($P(ExDateTime," "),3)
	s ExTime=$ZTH($P(ExDateTime," ",2))
	}
	else
	{
	s ExDate=0
	s ExTime=0
	}
	s oeoridr=oew_"||"_oewsub
    s arcimStr=##class(web.DHCNurCom).GetArcim(oew_"||"_oewsub)
    s dose=$P(arcimStr,"^",2)
    //s oecprId=$p($g(^OEORD(oew,"I",oewsub,1)),"^",8)
    s oecprDesc=$P(arcimStr,"^",3)
    //s oecprDesc=$P(sr,"^",2)
    s para="Y^"_dose_"^完成^"_userId_"^"_oeorid_"^"_""_"^"_seatNo
    if flag="1"
    {
    s res=##class(web.DHCLCNUREXCUTE).UpdateExecStat("","",para,"")
    }
    else
    {
	set res=##class(web.DHCLCNUREXCUTE).UndoUpdateExecStat(oeorid, "", oecprDesc, userId)
	}
	s chl="" f  s chl=$O(^OEORDi(0,"OEORI",oew,oeoridr,chl)) q:chl=""  d
	.s arcimStr=##class(web.DHCNurCom).GetArcim(oew_"||"_oewsub)
    .s dose=$P(arcimStr,"^",2)
    .s oecprDesc=$P(arcimStr,"^",3)
	.s oeoresub=""  s oeoresub=$O(^OEORDi(0,"NotExecE",oew,ExDate,ExTime,chl,0))
	.s oeorid=oew_"||"_chl_"||"_oeoresub  //s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
	.s para="Y^"_dose_"^完成^"_userId_"^"_oeorid_"^"_""_"^"_seatNo
    .if flag="1"  d
    ..s res=##class(web.DHCLCNUREXCUTE).UpdateExecStat("","",para,"")
    .else  d
	..set res=##class(web.DHCLCNUREXCUTE).UndoUpdateExecStat(oeorid, "", oecprDesc, userId)
    q 0
}

ClassMethod SendMsg(WardId, Ward, userId, Process) As %String
{
	s Date=$P($H,",")
	s Time=$P($H,",",2)
	s loc=""  f  s loc=$O(^TMP(WardId,Process,"RecLocMed",loc))  q:loc=""  d
    .s cat=""  f  s cat=$O(^TMP(WardId,Process,"RecLocMed",loc,cat)) q:cat=""  d
    ..s ^DHCCLNurseExec("SendMedic",loc,$P($H,","),WardId,cat)=Ward_"^"_userId_"^"_Date_"^"_Time
	q 0
}

ClassMethod AuditMed(locId As %String, std As %String, edd As %String, typ As %String = "", userId As %String, Process As %String = "", dep = "", tempOrdFlag = "") As %String
{
	//audit all
 	n (locId , std, edd, typ,userId,Process,dep,tempOrdFlag)
  	//ypz 061109 begin
  	s ^ypzTmp(340)=userId_"/"_locId
 	s qHandle=$lb(0,repid,0)
 	i (userId="")!(locId="") q "用户或登录科室有误!"
 	s wardStr=##Class(web.DHCLCNUREXCUTE).GetUserWardId(userId,locId)
 	i wardStr="" q "请以病区护士身份操作!"
 	s ward=$p($p(wardStr,"|"),"^",2)
 	q:ward="" "请以病区护士身份操作!"
 	s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
    i ctcpId'="" s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	i $G(ctcptId)'="" s ctcpType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
    i ($G(ctcpType)'="NURSE")  q "请以护士身份操作!"
    s dep=""
    s curHospId=$p(^CTLOC(locId),"^",22)
    s anStr="^"_^DHCANOPSET(curHospId,"anloc")
    i anStr[("^"_locId_"|") s dep=locId
	s opStr=^DHCANOPSET(curHospId,"oploc")
	i opStr[("^"_locId_"|") s dep=locId
 	//ypz 061109
 	i std'="" s std=$ZDH(std,4)
 	i edd'="" s edd=$ZDH(edd,4)
 	i std="" s std=+$h
 	i edd="" s edd=+$h

 	//w !,$ZD(std,4),"|",edd
 	 if typ="on"  s typ="C"
     e  s typ="P"
 	 s Room=""  f  s Room=$O(^PAADMi("CurrWard",ward,Room)) q:Room=""  d
    .s Adm=""  f  s Adm=$O(^PAADMi("CurrWard",ward,Room,Adm)) q:Adm=""  d
    ..s DischgDate=$P(^PAADM(Adm),"^",17)
    ..q:DischgDate'=""
    ..s Ord="" f  s Ord=$O(^OEORD(0,"Adm",Adm,Ord)) q:Ord=""  d
    ...s OrdSub=0  f  s OrdSub=$O(^OEORD(Ord,"I",OrdSub)) q:OrdSub=""  d
    ....s ^ypzTmp("audit",Ord,OrdSub)="/1"
    ....s PriorDR=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	....i PriorDR="" q
	....s PriorDes=$P(^OECPR(PriorDR),"^",2) 
	....s Prior="^"_PriorDR_"^" 
	....q:"^6^7^"[Prior
	....//s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/2"
	....i (tempOrdFlag'="on")&(PriorDes'["长期") q  //ypz 091001
	....i (tempOrdFlag="on")&(PriorDes["长期") q  //ypz 091001
	....//s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/3prior"
    ....s OrdStat=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",13)
    ....q:(OrdStat=11)!(OrdStat=4)
    ....s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/4ordstat"
	....s OrdDate=$P($G(^OEORD(Ord,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
	....s OrdDate=+OrdDate
	....q:((OrdDate<std)!(OrdDate>edd))&((std'="")&(edd'=""))
	....//s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/5dt"
	....s OrdTime=$P($G(^OEORD(Ord,"I",OrdSub,1)),"^",17)
    ....s user=$P($G(^OEORD(Ord,"I",OrdSub,7)),"^",1)
    ....q:user=""
    ....//s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/6user"
    ....s res=##class(web.DHCLCNUREXCUTE).Getdocloc(Adm,Ord,OrdSub)  //只要本科室
    ....q:(res="N")&(dep="")
    ....//s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/7localLoc"
    ....s ArcRow=$P(^OEORD(Ord,"I",OrdSub,1),"^",2)
    ....q:$D(^TMP("NurExec",userId,"UnAudit",ArcRow))
    ....//s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/8unaudit"
    ....s ItemCatDR=$P($G(^ARCIM($P(ArcRow,"||",1),$P(ArcRow,"||",2),1)),"^",10)
    ....s Cat="^"_ItemCatDR_"^"
    ....s OrdCat=$P(^ARC("IC",ItemCatDR),"^",8)
    ....s ret="N"
    ....if dep'=""  s ret=##class(web.DHCNurIpComm).getDep(dep,Ord,OrdSub)
    ....q:(dep'="")&($G(ret)="N")  //手术室审核
    ....q:^DHCNURSEITEMCAT("FaYao")'[Cat
    ....//s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/9"
    ....//q:(OrdCat=22)!(OrdCat=21) //宁波 消耗材料
    ....s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:OrdEx=""  d
    .....s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:OrdDsp=""  d
    ......s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ......s IncLb=$P(Dsp,"^",2)
    ......s Stat=$P(Dsp,"^",6)  
    ......q:Stat=typ
    ......s Qty=$P(Dsp,"^",1)
    ......//s ^ypzTmp("a",Ord,OrdSub)=$g(^DHCCLNurseExec("Audit",Ord,OrdSub))
    ......if '$D(^DHCCLNurseExec("Audit",Ord,OrdSub)) d
    .......s a=..PhAudit(Ord_"|"_OrdSub,userId)
    .......//ypz 070129 begin
    .......s ^ypzTmp("audit",Ord,OrdSub)=^ypzTmp("audit",Ord,OrdSub)_"/10"_a
    .......s RecLoc=$P(^OEORD(Ord,"I",OrdSub,3),"^",6)
	.......s MedTyp=##class(web.DHCNurIpComm).GetDispCatCode(Ord_"||"_OrdSub)
	.......s admId=+^OEORD(Ord)
	.......s wardId=$p($g(^PAADM(admId)),"^",70)
	.......s oeoriSttDate=$p($g(^OEORD(Ord,"I",OrdSub,1)),"^",9) //ypz 070129
	.......s ^DHCCLNurseExec("SendMedic",RecLoc,oeoriSttDate,wardId,MedTyp,Ord_"||"_OrdSub)=ward_"^"_userId_"^"_$P($H,",")_"^"_$P($H,",",2) //ypz 070129
	.......//ypz 070129

  //删除标记
   if $D(^TMP("NurExec",userId,"UnAudit")) k ^TMP("NurExec",userId,"UnAudit")
   //s a=..SendMsg(ward,ward,userId,Process)  //发送消息  //ypz 070129
   q 0
}

ClassMethod GetArcCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcCatExecute ]
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

ClassMethod GetArcCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetArcCatExecute(ByRef qHandle As %Binary, OrdCatId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s rw=""
 	s ^TT=OrdCatId
 	f  s rw=$O(^ARC("IC",rw)) q:rw=""  d
 	.s desc=$P(^ARC("IC",rw),"^",2)
 	.s ordid=$P(^ARC("IC",rw),"^",8)
 	.q:(ordid'=OrdCatId)&(OrdCatId'="")
	.Do Outputcat2

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetArcCat(OrdCatId As %String) As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetArcItemCat(OrdCatId) As %String
{
	n (OrdCatId)
	s rw=""
	f  s rw=$O(^ARC("IC",rw)) q:rw=""  d
 	.s desc=$P(^ARC("IC",rw),"^",2)
 	.s ordid=$P(^ARC("IC",rw),"^",8)
 	.q:(ordid'=OrdCatId)&(OrdCatId'="")
 	.s CatStr=$G(CatStr)_rw_"!"_desc_"^"
 	q $G(CatStr)
}

ClassMethod SaveFayao(Str)
{
  //保存发药子类;
	s ^DHCCLNurseExec("fayaocat")=Str
	s num=$L(^DHCCLNurseExec("fayaocat"),"^")
	for i=1:1:num
	{
		s str=$P(^DHCCLNurseExec("fayaocat"),"^",i)
		s id=$P(str,"|",1)
		s fayaostr=$G(fayaostr)_id_"^"
	}
	s fayaostr="^"_$g(fayaostr)
	s ^DHCNURSEITEMCAT("FaYao")=fayaostr
	//s ^TT=$L(^DHCNURSEITEMCAT("FaYao"),"^")
	q 0
}

ClassMethod GetFayaoCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFayaoCatExecute ]
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

ClassMethod GetFayaoCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFayaoCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetFayaoCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if '$D(^DHCCLNurseExec("fayaocat")) Set qHandle=$lb(0,repid,0)	Quit $$$OK

 	s num=$L(^DHCCLNurseExec("fayaocat"),"^")
 	f i=1:1:num
 	{   s prior=$P(^DHCCLNurseExec("fayaocat"),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetFayaoCat() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetHospitalName() As %String
{
  ///医院名称
   s rw="" f  s rw=$O(^CF("SM",rw)) q:rw=""  d
   .s HosName=$P(^CF("SM",rw),"^",5)
   q $g(HosName)
}

ClassMethod getDep(Dep, Oew, OrdSub) As %String
{
    n (Dep,Oew,OrdSub)
	s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	q:user="" "N"
	q:'$D(^SSU("SSUSR",user)) "N"
	s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	q:DoctorDr="" "N"  
	s truedoc=0
	s Loc="" 
	f  s Loc=$O(^RB("RES",0,"CTPCP",DoctorDr,Loc)) q:Loc=""  d
	.if Dep=Loc  s truedoc=1
	q:truedoc=0 "N"
	q:truedoc=1 "Y"
}

ClassMethod GetWardBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardBedExecute ]
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

ClassMethod GetWardBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWardBedExecute(ByRef qHandle As %Binary, wardrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s wardrowid=$G(%session.Data("LOGON.CTLOCID")) 
 	if wardrowid=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s wardloc=wardrowid
    s ward=""  s ward=$O(^PAWARD(0,"WARD_LocationDR",wardloc,ward))
    if ward=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s Room=""  f  s Room=$O(^PAADMi("CurrWard",ward,Room)) q:Room=""  d
    .s Adm=""  f  s Adm=$O(^PAADMi("CurrWard",ward,Room,Adm)) q:Adm=""  d
    ..s DischgDate=$P(^PAADM(Adm),"^",17)
    ..q:DischgDate'=""
    ..s roomdr=$P(^PAADM(Adm),"^",69)
    ..s papmiId=+^PAADM(Adm)
    ..if (roomdr'="") s room=$P(^PAROOM(roomdr),"^",2)
    ..s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    ..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    ..s bedSub=$p($p($g(^PAADM(Adm)),"^",73),"||",2)
    ..s curWardId=$p($g(^PAADM(Adm)),"^",70)  
    ..if curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
    ..if (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    ..e  s bedCode=""
    ..d OutPutWardBed
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutWardBed
	set Data=$lb($G(bedCode),regno,patName_" "_$G(room),Adm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetWardBed(wardrowid As %String) As %Query(ROWSPEC = "PatBedNo,RegNo,PatName,Adm")
{
}

ClassMethod GetDispCatCode(oeori As %String) As %String
{
 n (oeori)
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:ord="" "" q:itm="" "" q:'$d(^OEORD(ord,"I",itm,1)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
 q:sub="" "" q:ver="" "" q:'$d(^ARCIM(sub,ver,1))
 s arcic=$p(^ARCIM(sub,ver,1),"^",10) q:arcic="" ""
 //s ^ypzTmp(101)=$g(^ypzTmp(101))_"/"_oeori_"/"_sub_"/"_arcic
 &sql(select sdgi_sdg_parref->sdg_code into :sdgcode 
	 From DHCStkDrugGrpitm where sdgi_ordercat_dr=:arcic)
 //s ^ypzTmp(101)=$g(^ypzTmp(101))_"/"_$g(sdgcode)
 q $g(sdgcode)
}

ClassMethod PhAudit(OrdStr, userId, ArcRow = "") As %String
{
 //药品审核
   n (OrdStr,userId,ArcRow)

  //select OEORI_HICClaimNo from oe_orditem where oeori_rowid="5||330"
  //s OrdStr="23|34^3|4^45|23"
  s orlno=$L(OrdStr,"^")
  if (OrdStr'="")
  {
    f i=1:1:orlno
    {
	  s ord=$P(OrdStr,"^",i)
	 // s ord=$TR(ord,"|","||")
	  s oew=$P(ord,"|")
	  s chl=$P(ord,"|",2)
	  s str=$H_"|"_userId
	  s ^DHCCLNurseExec("Audit",oew,chl)=str
	 //s $P(^OEORD(oew,"I",chl,8),"^",9)=str
	  //&sql(update oe_orditem set OEORI_HICClaimNo=:str where oeori_rowid=:ord )
    }
  }
	 if (ArcRow'="")
	 {
	  s ^TMP("NurExec",userId,"UnAudit",ArcRow)=""
	  //记住不审核的药品
	 }
  q "0"
}

ClassMethod NurPatInfo(EpisodeID) As %String
{
   //病人基本信息及费用
	n (EpisodeID)
	if EpisodeID="" s EpisodeID=%request.Get("EpisodeID",1)
	//s ^T(0)=EpisodeID
	s Res=##class(web.DHCCLCom).PatInfo(""_"^"_EpisodeID)  //WKZ 071119
	s PatName=$P(Res,"^",5)
	s PatCardNo=$P(Res,"^",20)
	s Sex=$P(Res,"^",4)
	s Age=$P(Res,"^",8)
	s AdmDate=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	s admDate=$p(AdmDate,"^",1)
	s admTime=$p(AdmDate,"^",2)
	i admDate'="" s admDate=$$$ZD(admDate,3)
	i admTime'="" s admTime=$ZT(admTime)
	s AdmDate=admDate_" "_admTime
	s BedCode=$P(Res,"^",7)
	s RegNo=$P(Res,"^",1)
	s ctloc=$P(Res,"^",2)
	s docdes=$P(Res,"^",12)
	s homeaddres=$P(Res,"^",10)
	s hometel=$P(Res,"^",11)
	s MedCareNo=$P(Res,"^",13)
	s Nation=$P(Res,"^",15)
	s paersonLX=$P(Res,"^",16)
	s IDNumber=$P(Res,"^",20)
	i $P($G(Nation),"-",2)'=""  s Nation=$P($G(Nation),"-",2)
	if $d(^DHCINADM("0","ADM",EpisodeID))'=0 d
	.s InfoId="",flag=""
	.s InfoId=$o(^DHCINADM("0","ADM",EpisodeID,InfoId),-1)
	.i $d(^DHCINADM(InfoId))=0  s CardNo=""
	.e  d
	..s s=$g(^DHCINADM(InfoId))
    ..s AdmDr=$p(s,"^",1)         ///指向PAADM的指针
    ..s InsuId=$p(s,"^",3)        ///医疗保险号
    ..s CardNo=$p(s,"^",3)        ///医保卡号
   
    s InsuId=##class(web.DHCINSUPort).GetInsuCardByAdm(EpisodeID)
    //i +InsuId=0 d
    if (InsuId="")||(InsuId=0) d
    .s papmiId=+^PAADM(+EpisodeID)
    .;s InsuId=$p($g(^PAPER(papmiId,"ALL")),"^",19)
    .s InsuId=$p($g(^PAPER(papmiId,"PAT",3)),"^",12)
    s userId = $p(^PAADM(+EpisodeID),"^",43)
    s FeeInfo=##Class(web.DHCBillInterface).IGetDepAndBalnace(EpisodeID)
    ;s FeeInfo = ##Class(web.DHCBillInterface).IGetpatFeeInfo(EpisodeID,userId)
    ;s total=+$p(FeeInfo,"^",1) ;+##class(web.UDHCJFORDCHK).getpatshare(EpisodeID)
    ;s depos=##class(web.UDHCJFCKD).deposit(EpisodeID)
    ;
    s total=+$p(FeeInfo,"^",3)
    s depos=+$p(FeeInfo,"^",1)
    s balance=(+$G(depos))-(+$G(total))
    s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
    s warrant=##class(web.DHCBillInterface).IGetWarramt(EpisodeID,PAADMType) //##class(web.UDHCJFCKD).getwarrantamt(EpisodeID)
    ;s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID) ///获取留观状态
    ;i (StayStatus=1)!(StayStatus=2) d
    ;.s depos=##class(web.DHCBillInterface).IGetStayDeposit(EpisodeID)
    ;.s balance=##class(web.DHCBillInterface).IGetStayBalance(EpisodeID)
    ;.Set StayFeeInfo=##Class(web.DHCBillInterface).IGetStayTotalAmt(EpisodeID,"")
	;.Set total=+$p(StayFeeInfo,"^",1)
    s admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    if admreasondr'="" s admreason=$P(^PAC("ADMREA",admreasondr),"^",2)
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    Set PatLevel=$p(PatEncryptLevel,"^",2) 
   //s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel_"^"_$G(docdes)
  // q $G(PatName)_"^"_$G(Sex)_"^"_$G(Age)_"^"_$G(BedCode)_"^"_$G(RegNo)_"^"_$G(AdmDate)_"^"_$G(total)_"^"_$G(depos)_"^"_$G(warrant)_"^"_$G(admreason)_"^"_$G(ctloc)_"^"_$G(docdes)_"^"_$G(InsuId)_"^"_homeaddres_"^"_hometel_"^"_MedCareNo_"^"_$G(Nation)_"^"_$G(paersonLX)
  s ret=$G(PatName)_"^"_$G(Sex)_"^"_$G(Age)_"^"_$G(BedCode)_"^"_$G(RegNo)_"^"_$G(AdmDate)_"^"_$G(total)_"^"_$G(depos)_"^"_$G(warrant)_"^"_$G(admreason)_"^"_$G(ctloc)_"^"_$G(docdes)_"^"_$G(InsuId)_"^"_homeaddres_"^"_hometel_"^"_MedCareNo_"^"_$G(Nation)_"^"_$G(paersonLX)_"^"_$g(PatCardNo)_"^"_$g(balance)
  s ret=ret_"^"_PatLevel_"^"_EncryptLevel_"^"_IDNumber
  q ret
}

ClassMethod AddWardLoc(wardId, LocId) As %String
{
	n (wardId,LocId)
	s i=$i(^DHCNURWARDLOC("wardloc"))
	s ^DHCNURWARDLOC("wardloc",i,wardId,LocId)=wardId_"^"_LocId
	q 0
}

ClassMethod DelWardLoc(rw) As %String
{
	n (wardId,LocId)
	k ^DHCNURWARDLOC("wardloc",rw)
	q 0
}

ClassMethod UpWardLoc(rw, wardId, LocId) As %String
{
	n (wardId,LocId)
	s ^DHCNURWARDLOC("wardloc",rw)=wardId_"^"_LocId
	q 0
}

Query LookUpWard(code As %String) As %Query(ROWSPEC = "wardDesc:%String,wardId:%String")
{
}

ClassMethod LookUpWardExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s loguser=%session.Data("LOGON.USERID")
 	s logLoc=%session.Data("LOGON.CTLOCID")
 	s loctyp=$P(^CTLOC(logLoc),"^",13)
    //q:loctyp'="W" ""  //ward
    if loctyp="W"
    {
       s sub=$O(^PAWARD(0,"WARD_LocationDR",logLoc,""),-1)
       s desc=$P(^PAWARD(sub),"^",2)
       Do OutwardRow
	}
	if loctyp="W" Set qHandle=$lb(0,repid,0) Quit $$$OK

 	s sub=0 f  s sub=$O(^PAWARD(sub)) q:(sub="")!(sub="BED_BedType_DR")  d
    .q:$P(^PAWARD(sub),"^",6)'="Y"
    .s desc=$P(^PAWARD(sub),"^",2)
    .q:((desc'[code)&(code'=""))
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(desc,sub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWardExecute ]
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

ClassMethod LookUpWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query LookUpCtloc(admType As %String, desc As %String) As %Query(ROWSPEC = "ctlocDesc:%String,ctlocId:%String")
{
}

ClassMethod LookUpCtlocExecute(ByRef qHandle As %Binary, admType As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s loguser=%session.Data("LOGON.USERID")
 	s logLoc=%session.Data("LOGON.CTLOCID")
 	s loctyp=$P(^CTLOC(logLoc),"^",13)
    if loctyp="W"
    {
       s wardId=$O(^PAWARD(0,"WARD_LocationDR",logLoc,""),-1)
	   s ctlocId=""  f  s ctlocId=$O(^DHCNURWARDLOC("wardlocI",wardId,ctlocId)) q:ctlocId=""  d
	   .s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
       .d OutputRow4
	}
	if loctyp="W" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s admlocId=0
	f  s admlocId=$o(^PAC("ADMLOC",admlocId)) q:admlocId=""  d
	    .i admType'=$p(^PAC("ADMLOC",admlocId),"^") q
	    .s ctlocId=$p(^PAC("ADMLOC",admlocId),"^",2)
	    .s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	    .//w "desc="_desc_$p(ctlocDesc,desc,1)," ",$l(ctlocDesc,desc),!
	    .i (desc'="")&($p(ctlocDesc,desc,1)'="") q
	    .d OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	//set Data=$lb(ctlocdesc,ctlocrowid)
	set Data=$lb(ctlocDesc,ctlocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCtlocExecute ]
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

ClassMethod LookUpCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Ctloc(desc As %String) As %Query(ROWSPEC = "ctlocDesc:%String,ctlocId:%String")
{
}

ClassMethod CtlocExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ctlocId=0 f  s ctlocId=$O(^CTLOC(ctlocId)) q:ctlocId=""  d
	.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	.q:(ctlocDesc'[desc)&(desc'="")
	.i ctlocDesc["-" s ctlocDesc=$p(ctlocDesc,"-",2)
    .d OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	//set Data=$lb(ctlocdesc,ctlocrowid)
	set Data=$lb(ctlocDesc,ctlocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CtlocExecute ]
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

ClassMethod CtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAdmCurrentLoc(Adm) As %String
{
 //获取病人当前科室
	n (Adm)
	s ctlocdr=$P(^PAADM(Adm),"^",4)
	s ctlocDes=$p(^CTLOC(ctlocdr),"^",2)
	q ctlocdr_"^"_ctlocDes
}

Query GetRpTyp(userid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetRpTypExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s type=0
	s userid=$G(%session.Data("LOGON.USERID"))
	//w !,userid
	if (userid'="")
	{
	 s ssgrp=$P(^SSU("SSUSR",userid),"^",5)
	}
	if $G(^DHCCLNurseExec("UserGroupAccess","Type",ssgrp))'="" s Type=$G(^DHCCLNurseExec("UserGroupAccess","Type",ssgrp))
	if $G(Type)="" s num=0
	else  s num=$L($G(Type),"^")
	
	for i=1:1:num
	{
		s str=$P(Type,"^",i)
		s type=$P(str,"|")
		s typeStr=$P(str,"|",2)
		d OutRowtyp
		
	}

	s type=0
	if (userid="")
	{
	  f  s type=$o(^DHCCLNurseExec("VarDef",type)) q:type=""  d
	    .s typeStr=$P(^DHCCLNurseExec("VarDef",type),"^",1)
        .Do OutRowtyp
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(typeStr,type)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRpTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRpTypExecute ]
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

ClassMethod GetRpTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRpTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLogWard() As %String
{
	s logLoc=%session.Data("LOGON.CTLOCID")
 	s loctyp=$P(^CTLOC(logLoc),"^",13)
    //q:loctyp'="W" ""  //ward
    if loctyp="W"
    {
       s wardId=$O(^PAWARD(0,"WARD_LocationDR",logLoc,""),-1)
       s ctlocDesc=$p(^CTLOC(logLoc),"^",2)
       q wardId_"^"_ctlocDesc
    }
 q ""
}

ClassMethod LabOrditem(Ordrow, labno) As %String
{
  //按标本号查询医嘱
  n (Ordrow,labno)
    s Ord=$P(Ordrow,"||")
	s chl=""  f  s chl=$O(^OEORD(0,"EpisNo",labno,Ord,chl))  q:chl=""  d
    .s arcim=$p(^OEORD(Ord,"I",chl,1),"^",2) 
    .s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
    .s desc=$P(^ARCIM(sub,ver,1),"^",2)
    .s OrdItem=$G(OrdItem)_desc_"^"
    q OrdItem
}

ClassMethod UndoUpdateExecStat(oeoriId, arcicId, oecprDesc, userId) As %String
{
	//k PLIST
	//s name=$p(user,"^"),password=$p(user,"^",2)
	//s val=$$select^MVBSSUSR(name,password) ;验证用户身份
	//i val'=0 s P5=100  ;如果用户验证错误?设置标记
	//&js<alert("oeoriId="+"#(oeoriId)#"+" arcicId"+"#(arcicId)#");>
	s ctcpName=""
	//s oeoriId="876953||985||2"
	//s userId=10374
	&sql(select ssusr_careprov_dr->ctpcp_desc into :ctcpName from ss_user where ssusr_RowId=:userId)
	k PLIST
	s resStr=0
	i 1 d  //(oecprDesc["即刻")!(oecprDesc["临时")!(oecprDesc["长期")
	    .//&js<alert("arcicId="+"#(arcicId)#");>
	    .i arcicId=-90 d   //;待改!!!!????(arcicId=90)!(arcicId=228)  d   ;查询是否为即刻执行医嘱?删除记录
	    ..&sql(select oeore_rowid,oeore_ctpcp_dr->ctpcp_desc into :oeoreId,:ctcpDesc from oe_ordexec where oeore_oeori_parref=:oeoriId)
	    ..i $g(ctcpDesc)'[ctcpName d
	    ...s resStr=-2
	    ..e  d
	    ...//d delete^MVBOEEXE(oeoreId)
	    .i 1 d  //;目前程序
	        ..//s oeoreId=oeoriId_"||"_1
	        ..s oeordId=+oeoriId //oeoriId为医嘱或医嘱执行的RowId
	        ..s oeoriSub=$p($g(oeoriId),"||",2)
	        ..s oeoreSub=$p($g(oeoriId),"||",3) //ypz 060308
	        ..//s oeoriId=+oeoriId_"||"_oeoriSub //ypz 060308
	        ..
	        ..i oeoreSub="" s oeoreSub=$o(^OEORD(+oeoriId,"I",oeoriSub,"X",0)) //ypz
	        ..i oeoreSub="" s resStr=-1 q
	        ..s oeoreSub="" f  s oeoreSub=$o(^OEORD(+oeoriId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	        ...q:oeoreSub=0
	        ...s oeoreId=oeoriId_"||"_oeoreSub
	        ...&sql(select oeore_ctpcp_dr->ctpcp_desc into :ctcpDesc from oe_ordexec where oeore_rowid=:oeoreId)
	        ...&sql(select * into PLIST() from SQLUSER.Oe_OrdEXEC where oeore_rowid=:oeoreId)
	        ...i $g(ctcpDesc)="" d //
	        ....s resStr=-2
	        ...e  d
	        ....//&js<alert("#(oeoreId)#"+" ok ");>
	        ....s PLIST(25)=""      ;停止日期
	        ....s PLIST(36)=""      ;停止时间
	        ....s PLIST(37)=""      ;执行人
	        ....s PLIST(40)=""      ;状态
	        ....s PLIST(42)=""      ;剂量
	        ....s PLIST(43)="I"  ;帐单状态
	        ....s PLIST(44)=""      ;单位
	        ....s PLIST(46)=""      ;日期 
	        ....s PLIST(47)=""      ;时间
	        ....s billFlag="I",tmpStr=""
	        ....&sql(UPDATE OE_OrdExec VALUES PLIST() WHERE OEORE_RowId=:oeoreId)
	        ....//&sql(update Oe_ordexec set OEORE_CTPCP_DR=:tmpStr,OEORE_Order_Status_DR=:tmpStr,OEORE_QtyAdmin=:tmpStr,OEORE_CTUOM_DR=:tmpStr,OEORE_DateExecuted=:tmpStr,OEORE_TimeExecuted=:tmpStr,OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	        ....s resStr=SQLCODE
	        ....//s ok=$$update^MVBOEEXE(oeoreId)     ;更新数据
	        ....//&js<alert("SQLCode="+"#(SQLCODE)#");>
	q resStr
}

ClassMethod UpdateExecStat(param As %String)
{
    n oeordId,oeoriSub,ok,arcicId,oeoriId,unit,num,uom,uomid,stat,statid,usr,ssusr,ctpcpId,dat,tim,ret ;xuqy 2005-04-20
    n newid
    s newid=""
    s ok=1
   // s param=^TMP(0)
    s exeMark=$p(param,"^",1)  ;标记:Y/S/X 
    s oeoriId=$p(param,"^",5)    ;Oeori_rowid
    s arcicId=$p(param,"^",6)   ;判断是否为输血类或其它处置/治疗类 
    s now=$zt($p($h,",",2))
    b
    i exeMark="X" d            ;如果是停止医嘱
        .s oeordId=$p($g(oeoriId),"||",1)
        .s oeoriSub=$p($g(oeoriId),"||",2)
        .s oeoreSub=$p($g(oeoriId),"||",3)  //ypz 060308
        .//s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
        .s usrId=$p(param,"^",4)  //,usr=$g(usr)   ;执行人姓名和ctpcpId码
        .s ctpcpId=$p(^SSU("SSUSR",usrId),"^",14) //SSUSR_CareProv_DR
        .i ctpcpId="" s ok="请以医护人员的身份操作!" q //ypz 060430 用户不是医护人员时提示 //ypz 070105
        .if oeoreSub'="" d
        ..k PLIST
        ..&sql(select * into PLIST() from SQLUSER.Oe_OrdEXEC where oeore_rowid=:oeoriId)
        ..s PLIST(25)=+$H
        ..s PLIST(36)=$P($H,",",2)
        ..s PLIST(37)=ctpcpId
        ..&sql(update oe_ordexec values PLIST() where oeore_rowid=:oeoriId)
        ..s ok=SQLCODE
        .e  d
        ..k PLIST
        ..s PLIST(0)=oeordId_"||"_oeoriSub
            ..s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            ..s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            ..;s PLIST(35)=$h   ;OEORE_StDateTime
            ..s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
            ..s PLIST(25)=+$H
            ..s PLIST(36)=$P($H,",",2)
            ..//s ok=$$insert^MVBOEEXE(oeoriId) ;
            ..&sql(insert into OE_OrdExec Values PLIST())
            ..s ok=SQLCODE
    i exeMark="S" d            ;如果是长期医嘱或处置/治疗类 
        .i 1 d  ;如果是输血类或其它处置/治疗类?在此执行
            ..s statid=7    ;完成状态设为完成(7为完成)
            ..s usr=$p(param,"^",3)   ;执行人姓名和ctpcpId码
            ..&sql(select SSUSR_CareProv_DR,SSUSR_Name into :ctpcpId,:userName from ss_user where ssusr_initials=:usr)
            ..s dat=+$h,tim=$p($h,",",2)   ;执行的日期和时间
            ..s PLIST(26)=dat,PLIST(26)=dat,PLIST(27)=tim,PLIST(35)=$h,PLIST(37)=ctpcpId,PLIST(40)=7
            ..s PLIST(41)=0,PLIST(42)=0,PLIST(43)="TB"_$c(1)_"To Bill",PLIST(46)=dat,PLIST(47)=tim
            ..s ok=$$insert^MVBOEEXE(oeoriId)
        .e  d
            ..s men=$p(param,"^",3)
            ..&sql(select ssusr_name into :per from ss_user where ssusr_initials=:men)
            ..s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
            ..s PLIST(122)=per_"^"_now   ;添加记录到字段oeori_userauthorise
            ..s ok=$$update^MVBOEITM(oeoriId)   ;添加记录完成
    
    ;如果是即刻医嘱或处置/治疗类    ;Y^1^完成^777^8412||395^49
    i exeMark="Y" d 
        .s ok=1
        .s arcicId=$p(param,"^",6)
        .s oeoriId=$p(param,"^",5)         ;医嘱ROWID或医嘱执行RowId
        .s seatNo="" 
        .s userid=$p(param,"^",4) 
        .s skinflag=$p(param,"^",7)
        .if skinflag'="" d
        ..s res=..SetSkinTestResult(oeoriId,userid,skinflag)
        ..i res'=0  s ok=res  q
        .s oeordId=$p($g(oeoriId),"||",1)
        .s oeoriSub=$p($g(oeoriId),"||",2)
        .s oeoreSub=$p($g(oeoriId),"||",3)  //ypz 060308
        .s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
        .q:($g(oeordId)="")!($g(oeoriSub)="")
        .
        .//ypz 070105 begin
        .//s arcicOrdType=$p(^ARC("IC",arcicId),"^",7)
        .s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
        .s admId=+^OEORD(oeordId),feeRetStr=""
        .//ypz 070105 end
        .s unit=$p(param,"^",2)
        .s num=$p(unit," ",1)
        .s uom=$p(unit," ",2)
        .i (num[".")&(num<1) s num="."_$p($g(num),".",2)
        .;&sql(select ctuom_rowid into :uomid from ct_uom where ctuom_desc=:uom)
        .;s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .;s uomid=$o(^CT("UOM",0,"Desc",uom,"")) ,uomid=$g(uomid)
        .i uom="" d
            ..s uomid=""
        .e  d
            ..s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .s stat=$p(param,"^",3),stat=$g(stat) ;完成状态
        .;&sql(select stat_rowid into :statid from OEC_Order_AdminStatus where stat_desc=:stat)
        .if stat="" s stat="完成"
        .s statid=$o(^OEC("STAT",0,"Desc",$$ALPHAUP^SSUTIL4(stat),"")),statid=$g(statid)
        .s usrId=$p(param,"^",4)  //,usr=$g(usr)   ;执行人姓名和ctpcpId码
        .
        .s ctpcpId=$p(^SSU("SSUSR",usrId),"^",14) //SSUSR_CareProv_DR
        .i ctpcpId="" s ok="请以医护人员的身份操作!" q //ypz 060430 用户不是医护人员时提示 //ypz 070105
        .//b ;s userName=$p(^SSU("SSUSR",ssusr),"^",2)
        .s curDate=+$h,curTime=$p($h,",",2)   ;执行的日期和时间
        .b
        .i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d
            ..b //&js<alert("come in oeore if "+"#(oeordId)#"+"/"+"#(oeoriSub)#");>
            ..s PLIST(0)=oeoriId
            ..s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            ..s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            ..;s PLIST(35)=$h   ;OEORE_StDateTime
            ..s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
            ..s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
            ..s PLIST(41)=0    ;OEORE_PhQtyIss
            ..s PLIST(42)=num      ;剂量OEORE_QtyAdmin
            ..s PLIST(43)="TB"  ;_$c(1)_"To Bill"  ;OEORE_Billed
            ..s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
            ..s PLIST(46)=curDate      ;日期OEORE_DateExecuted
            ..s PLIST(47)=curTime      ;时间OEORE_TimeExecuted
            ..s PLIST(50)=seatNo   ;x OEORE_SignFile 座位号
            ..//s ok=$$insert^MVBOEEXE(oeoriId) ;
            ..&sql(insert into OE_OrdExec Values PLIST())
            ..s ok=SQLCODE
            ..b
        .e  d
            ..b  ;d
            ..s oreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
            ..s oeoreId=oeoriId_"||"_oeoreSub  //不是1了
            ..//s ret=$$select^MVBOEEXE(oeoreId)  ;取出原有数据
            ..s curPLIST37=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)   ;//1 changed to oreSub !! OEORE_CTPCP_DR
            ..//&js<alert("come in oeore else "+"#(oeordId)#"+"/"+"#(oeoriSub)#"+"/"+"#(curPLIST37)#"+"/");>
            ..b ;i $g(PLIST(37))="" d
            ..i $g(curPLIST37)="" d
                ...;i (num[".")&(num<1) s num="."_$p($g(num),".",3)
                ...s PLIST(37)=ctpcpId      ;pin 码 执行人OEORE_CTPCP_DR
                ...s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
                ...s PLIST(42)=num      ;剂量OEORE_QtyAdmin
                ...s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
                ...s PLIST(43)="TB"  ;_$c(1)_"To Bill"  ;OEORE_Billed
                ...s PLIST(46)=curDate      ;日期OEORE_DateExecuted 
                ...s PLIST(47)=curTime      ;时间OEORE_TimeExecuted
                ...//&js<alert("come in oeori else "+"#(num)#"+"/"+"#(pin)#"+"/"+"#(statid_" "_uomid_" "_dat_"-"_tim)#"+"/");>
            ...////ypz add .
            ...//s ok=$$update^MVBOEEXE(oeoreId)     ;更新数据
            ...&sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,OEORE_Order_Status_DR=:statid,
                   OEORE_QtyAdmin=:num,OEORE_CTUOM_DR=:uomid,
                   OEORE_DateExecuted=:curDate,
                   OEORE_TimeExecuted=:curTime,
                   OEORE_SignFile=:seatNo
                    where oeore_rowid=:oeoreId)
            ...s ok=SQLCODE
    q ok
}

Query ctloctyp(Typ As %String = "D") As %SQLQuery(CONTAINID = 1, ROWSPEC = "LocDesc,rowid")
{
 select ctloc_desc ,ctloc_rowid from ct_loc where ctloc_type='D'
}

/// 取医嘱大类
Query GetOrcat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ORCAT_Rowid:%Integer,ORCAT_Desc:%String,Sel")
{
    select ORCAT_RowId,ORCAT_Desc,0 from OEC_OrderCategory
}

/// 取医嘱子类
Query GetArcic() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ARCIC_RowId:%Integer,ARCIC_Desc:%String")
{
	select ARCIC_RowId,ARCIC_Desc from ARC_ItemCat
}

/// 取医嘱优先级
Query GetOecpr() As %SQLQuery(CONTAINID = 1, ROWSPEC = "oecpr_rowid:%Integer,oecpr_Desc:%String,Sel")
{
	select oecpr_rowId,oecpr_desc,0 from OEC_Priority
}

Query GetFreq() As %SQLQuery(CONTAINID = 1, ROWSPEC = "PHCFR_rowid:%Integer,PHCFR_Desc1:%String")
{
	select PHCFR_RowId,PHCFR_Desc1 from PHC_Freq
}

/// 取医嘱状态
Query GetOrdStat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "OStat_rowid:%Integer,OStat_Desc:%String,Sel")
{
	select OStat_rowId,OStat_desc,0 from OEC_OrderStatus
}

/// 取医嘱执行状态
Query GetExecStat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Stat_rowid:%Integer,Stat_Desc:%String")
{
	select Stat_rowId,Stat_desc from OEC_Order_AdminStatus
}

/// 取用药途径状态
Query GetPhcin() As %SQLQuery(CONTAINID = 1, ROWSPEC = "phcin_rowid:%Integer,phcin_Desc1:%String,Sel:%String")
{
	select Phcin_rowId,Phcin_desc1,0 from PHC_Instruc
}

ClassMethod SetSkinTestResult(oriOreId, userId, flag) As %String
{
    //皮试处理
    n (oriOreId,userId,flag)
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
 	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
	i ordStatCode="D" q "停止医嘱不能置皮试结果!"
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
    s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	////多次置结果的控制?//同一次
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestCtcp_Dr,DHCORI_SkinTestDate,DHCORI_SkinTestTime) values(:oeoriId,:ctcpId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_SkinTestCtcp_Dr=:ctcpId,DHCORI_SkinTestDate=:curDate,DHCORI_SkinTestTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)

 	s $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)=flag
 	s OrdTyp=..GetOrdType(oeordId,oeoriSub)
 	if (OrdTyp="R")
    {
	  s resStr=##class(web.DHCCLCom).UpdatePatAllergy(oeoriId,userId,flag)
    }
    else
    {
	 q 0
	}
	i resStr'=0 q resStr
	q 0
}

ClassMethod GetOrdType(Oew, OrdSub, Flag) As %String
{
	  n (Oew,OrdSub,Flag)
	   s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   s ARCIMRowid=$P(ArcimDR,"||",1)
	   s ARCIMSub=$P(ArcimDR,"||",2)  
	   s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	   s OrdType=$P(^ARC("IC",ItemCatDR),"^",7)
	   q OrdType
}

ClassMethod UpdatePatAllergy(oeoriId, userId, allergyFlag) As %String
{
   //无当前药品则插入
	n (oeoriId,userId,allergyFlag)
	q:(allergyFlag'="Y")&(allergyFlag'="N") 0
	
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	q:dhcoriId="" "置皮试信息失败!"
	s curDate=+$h,curTime=$p($h,",",2)
	
	s algId=$p(^DHCORDItem(dhcoriId),"^",5)
	s papmiId=+algId,algSub=+$p(algId,"||",2)
	i allergyFlag="N" d
	    .i (algId'="") d
	        ..s $p(^PAPER(papmiId,"ALG",algSub),"^",19)="Y"
	        ..s $p(^PAPER(papmiId,"ALG",algSub),"^",8)="I"
	        ..s $p(^PAPER(papmiId,"ALG",algSub),"^",16)=userId
	        ..s $p(^PAPER(papmiId,"ALG",algSub),"^",23)=curDate
	        ..s $p(^PAPER(papmiId,"ALG",algSub),"^",24)=curTime
	        ..s $p(^DHCORDItem(dhcoriId),"^",5)=""
	i allergyFlag="N" q 0
	//i (allergyFlag="Y")&(algId'="")&($p($g(^PAPER(papmiId,"ALG",algSub)),"^",19)="N") q 0
	
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" "无药品指针!"
    k PLIST
    s PLIST(0)=+^PAADM(+^OEORD(oeordId)) //ALG_PAPMI_ParRef
    s PLIST(3)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",11) //ALG_CTPCP_DR暂用下医嘱医生
    s PLIST(8)="" //ALG_Type_DR 取不到
    s PLIST(11)="A" //ALG_Status
    s PLIST(12)=curDate //ALG_Date
    s PLIST(13)=curDate //ALG_OnsetDate
    s PLIST(18)=curTime //ALG_Time
    s PLIST(19)=userId //ALG_UpdateUser_DR
    s PLIST(22)="N" //ALG_InActive
    s PLIST(23)=1 //ALG_LastUpdateHospital_DR
    s PLIST(24)="" //ALG_Severity_DR
    s PLIST(26)=curDate //ALG_LastUpdateDate
    s PLIST(27)=curTime //ALG_LastUpdateTime
    s PLIST(31)=+phcdfId //ALG_PHCDM_DR
    s PLIST(33)=$o(^MRC("AT",0,"MRCAA_Desc","药物","")) //ALG_MRCAllType_DR
    //w !,PLIST(0)_","_PLIST(3)_","_PLIST(8)_","_PLIST(11)_","_PLIST(12)_","_PLIST(13)_","_PLIST(18)_","_PLIST(19)_","_PLIST(22)_","_PLIST(23)_","_PLIST(26)_","_PLIST(27)_","_PLIST(31)_","_PLIST(33)
    &sql(Insert into PA_Allergy Values PLIST())
    i SQLCODE q "过敏记录插入有误!"
    s $p(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2)),"^",30)=PLIST(0)_"ALG"_$p(%ROWID,"||",2)
    s $p(^DHCORDItem(dhcoriId),"^",5)=%ROWID
    q 0
}

ClassMethod DeletePatAllergy(oeoriId, userId, skinTestDate, skinTestTime)
{
    //按药品和皮试走
    n (oeoriId, userId, skinTestDate, skinTestTime)
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" "未找到药物!"
    s papmiId=+^PAADM(+^OEORD(oeordId))
	//////s skinTestDate=PLIST(46)
	//////s skinTestTime=PLIST(47)
	s algSub=0
	f  s algSub=$o(^PAPER(papmiId,"ALG",algSub)) q:algSub=""  d
	    .s algStr=^PAPER(papmiId,"ALG",algSub) //注意,过敏按类别走时要更新
	    .i ($p(algStr,"^",10)=skinTestDate)&($p(algStr,"^",15)=skinTestTime)&($p(algStr,"^",27)=+phcdfId) d
	        ..s algId=papmiId_"||"_algSub
	        ..&sql(delete from PA_Allergy where ALG_RowId=:algId)
	        ..////s setRet=..SetSkinTestResult(oeordId_"||"_oeoriSub,"")
	q 0
}

ClassMethod Logon(userid, pinnumber) As %String
{
    s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
  	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(userid,"U"),""),-1)
  	if User=""{
	  	 zn oldnamespace
         q "-3"
	  	} 
  	s pin=$$ENCR^SSUTIL2(pinnumber)
  	if pin=""{
	  	 zn oldnamespace
         q "-4"
	  	} 
	i pin'=$p(^SSU("SSUSR",User),"^",15) {
	  	 zn oldnamespace
		q "-4"
	}
	s DefLoc=$p(^SSU("SSUSR",User),"^",4)
	zn oldnamespace    
	s LogonDep=##class(web.DHCNURPDAQUEXCUTE).Getlogonctloc(User)
	q User_"^"_DefLoc_"@"_LogonDep
}

Query logonctloc(userid As %String) As %Query(ROWSPEC = "LocDesc:%String,rowid:%String")
{
}

ClassMethod logonctlocExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=""  f  s chl=$O(^SSU("SSUSR",userid,"OTHLL",chl)) q:chl=""  d
    .s loc=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",1)
    .s locdes=$p($G(^CTLOC(loc)),"^",2)
    .q:locdes=""
    .s tm(loc)=locdes
    s loc=""  f  s loc=$O(tm(loc)) q:loc=""  d
    .s locdes=tm(loc)
    .d OutRowtyp1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp1
	set Data=$lb(locdes,loc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod logonctlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = logonctlocExecute ]
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

ClassMethod logonctlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = logonctlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDiag(Adm) As %String
{
	n (Adm)
	s mradm=$P(^PAADM(Adm),"^",61)    

	s Diag=""
	s dc=0 f  s dc=$o(^MR(mradm,"DIA",dc)) q:dc=""  d
	       .s (mrdesc,mcdes)=""
	       .f de=1:1:$g(^MR(mradm,"DIA",dc,"DES",0)) d
	       ..s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",dc,"DES",de)) ;
	       .s mcdiadate=$P(^MR(mradm,"DIA",dc),"^",7)
	       .s mcicd=$P(^MR(mradm,"DIA",dc),"^",1)
	       .if mcicd'="" s mcdes=$P($G(^MRC("ID",mcicd)),"^",2)
	       .s Diag=Diag_$G(mcdes)_" "_$G(mrdesc)_"|"
	q Diag
}

}
