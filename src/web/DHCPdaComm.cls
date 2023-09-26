Import SQLUser

Class web.DHCPdaComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetLocUser(LogLoc As %String) As %Query(ROWSPEC = "DocDes,DocDr,SSUsrId,SSID")
{
}

ClassMethod GetOrdType(ArcItemDr) As %String
{
  //求医嘱类别  R 药，L 检验
 s OrdType=""
 //s arcid="" s arcid=$O(^ARC("IC",0,"OrdCat",OrdCat,arcid))
 if ArcItemDr'=""  s OrdType=$P(^ARC("IC",ArcItemDr),"^",7)
 q OrdType
}

ClassMethod GetPhRefuseFlag(ord, sub) As %String
{
  //求是否被拒绝发药
   q 1
   s oldnamespace=$ZNSPACE
   s datanamespace=$LIST(^websys.ConfigurationD(1),12)
   zn datanamespace
   s flag=$$RefusePhFlag^DHCPdaNurComm(ord,sub)
   zn oldnamespace
   q $G(flag)
}

ClassMethod BedOccupy(BedDr As %String, User As %String, StDate As %String, StTime As %String, ToDate As %String, ToTime As %String, ReasonDr As %String) As %String
{
  //求是否被拒绝发药
   s oldnamespace=$ZNSPACE
   s datanamespace=$LIST(^websys.ConfigurationD(1),12)
   zn datanamespace
   s flag=$$BedOccupy^DHCPdaNurComm(BedDr, User, StDate, StTime, ToDate, ToTime, ReasonDr)
   zn oldnamespace
   q $G(flag)
}

ClassMethod UpdateBed(Adm As %String, BedDr As %String, PreBedDr As %String, User As %String) As %String
{
  //求是否被拒绝发药
   s oldnamespace=$ZNSPACE
   s datanamespace=$LIST(^websys.ConfigurationD(1),12)
   zn datanamespace
   s flag=$$UpdateBed^DHCPdaNurComm(Adm, BedDr, PreBedDr, User)
   zn oldnamespace
   q $G(flag)
}

ClassMethod GetDisconFlag(ord, sub) As %String
{
  //求护士停止处理标记
   s oldnamespace=$ZNSPACE
   s datanamespace=$LIST(^websys.ConfigurationD(1),12)
   zn datanamespace
   s Ret=$$GetDiscon^DHCPdaNurComm(ord_"||"_sub)
   zn oldnamespace
   q $G(Ret)
}

ClassMethod SetDisconFlag(ord, sub, User) As %String
{
  //求护士停止处理标记
   s oldnamespace=$ZNSPACE
   s datanamespace=$LIST(^websys.ConfigurationD(1),12)
   zn datanamespace
   s Ret=$$setOrdDiscon^DHCPdaNurComm(ord_"||"_sub,User)
   zn oldnamespace
   q $G(Ret)
}

ClassMethod GetOrdStat(Oew, OrdSub)
{

	s OrdStatusDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)
	s OrdStat=$P(^OEC("OSTAT",OrdStatusDR),"^",1)
	q OrdStat
}

ClassMethod UnDoDisconFlag(ord, sub) As %String
{
  //求护士停止处理标记
   s oldnamespace=$ZNSPACE
   s datanamespace=$LIST(^websys.ConfigurationD(1),12)
   zn datanamespace
   s Ret=$$UnDiscon^DHCPdaNurComm(ord_"||"_sub)
   zn oldnamespace
   q $G(Ret)
}

ClassMethod EvalPatInfo(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
   // n (curId)
   // 
    s admId=curId
    s admdate=$P(^PAADM(admId),"^",6)
    s admdate=$zd(admdate,3)
    s admtime=$P(^PAADM(admId),"^",7)
    s admtime=$zt(admtime)
    s papmiId=+^PAADM(admId)
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",1)	
	
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P(^CTPCP(doc,1),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s workdr=$P(^PAPER(papmiId,"PAT",1),"^",8)     ;职业 PAPMI_PatCategory_DR
    ;PAC_PatientCategory ^PAC("PCAT",{PCAT_RowId})
    i workdr'="" d
    .s work=$P(^PAC("PCAT",workdr),"^",2)           ;
    e  d
    .s work=""
    s mzudr=$P(^PAPER(papmiId,"PER",2),"^",1)       ;民族
     ;^CT("NAT",{CTNAT_RowId}) ct_nation
    i mzudr'="" d
    .s mzu=$P(^CT("NAT",mzudr),"^",2)
    e  d
    .s mzu=""
     s marrDr=$P(^PAPER(papmiId,"PER",2),"^",3) 
     ;CT_Marital  ^CT("MAR",{CTMAR_RowId})
     i marrDr'="" d
     .s marry=$P(^CT("MAR",marrDr),"^",2)             ;婚姻
     e  d
     .s marry=""
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sexdr=$p($g(^PAPER(papmiId,"ALL")),"^",7)
    if sexdr'="" s sex=$p($g(^CT("SEX",sexdr)),"^",2)
    e  s sex=""
   
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s agestr=..CalAge(birth,+$h)
    s age=$p(agestr,"Y",1)
    if age'<14 s age=age_"岁"        //5Y5M5D
    if age<14 s age=age_"岁"_$P($P(agestr,"M"),"Y",2)_"月"
    if age<1 s age=$P($P(agestr,"M"),"Y",2)_"月"_$P($P(agestr,"M",2),"D",1)_"天"
    //ctlocDesc未取后半部分 ypz 060522
    s basinf=regNo_"^"_$g(patName)_"^"_$g(age)_"^"_ sexdr_"|"_sex_"^"_ctlocId_"|"_ctlocDesc_"^"_bedCode_"^"_marrDr_"|"_marry_"^"_mzudr_"|"_$P(mzu,"-",2)_"^"_workdr_"|"_work_"^"_admdate_" "_admtime

    q basinf
}

ClassMethod PatInfo(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
   // n (curId)
   // 
    s admId=curId
    s admdate=$P(^PAADM(admId),"^",6)
    s admdate=$zd(admdate,3)
    s admtime=$P(^PAADM(admId),"^",7)
    s admtime=$zt(admtime,3)
    s papmiId=+^PAADM(admId)
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P(^CTPCP(doc,1),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=..CalAge(birth,+$h)
    s age=$p(age,"Y",1)
    //ctlocDesc未取后半部分 ypz 060522
    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo
    q retStr
}

ClassMethod NurPatInfo(EpisodeID As %String) As %String
{
  //病人基本信息及费用
  //病人基本信息及费用
	//n (EpisodeID)
	//if EpisodeID="" s EpisodeID=%request.Get("EpisodeID",1)
	//s ^T(0)=EpisodeID
	if $P(EpisodeID,"||",2)'="" s EpisodeID=$p($g(^OEORD( $P(EpisodeID,"||",1))),"^",1)
	s Res=..PatInfo(EpisodeID)
	s PatName=$P(Res,"^",5)
	s Sex=$P(Res,"^",4)
	s Age=$P(Res,"^",8)
	s AdmDate=$ZD($P(^PAADM(EpisodeID),"^",6),3)_" "_$ZT($P(^PAADM(EpisodeID),"^",7))
	s BedCode=$P(Res,"^",7)
	s RegNo=$P(Res,"^",1)
	s ctloc=$P(Res,"^",2)
	s docdes=$P(Res,"^",12)
	s homeaddres=$P(Res,"^",10)
	s hometel=$P(Res,"^",11)
	s MedCareNo=$P(Res,"^",13)
	if $d(^DHCINADM("0","ADM",EpisodeID))'=0 d
	.s InfoId="",flag=""
	.s InfoId=$o(^DHCINADM("0","ADM",EpisodeID,InfoId),-1)
	.i $d(^DHCINADM(InfoId))=0  s CardNo=""
	.e  d
	..s s=$g(^DHCINADM(InfoId))
    ..s AdmDr=$p(s,"^",1)         ///指向PAADM的指针
    ..s InsuId=$p(s,"^",2)        ///医疗保险号
    ..s CardNo=$p(s,"^",3)        ///医保卡号
    //xiachunrong 20120724祁工要求注释，解决PDA速度慢的问题
    //s total=##class(web.UDHCJFCKD).totalamount(EpisodeID)
    //s depos=##class(web.UDHCJFCKD).deposit(EpisodeID)
    //s warrant=##class(web.UDHCJFCKD).getwarrantamt(EpisodeID)
    s admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    if admreasondr'="" s admreason=$P(^PAC("ADMREA",admreasondr),"^",2)
   //s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel_"^"_$G(docdes)
   q $G(PatName)_"^"_$G(Sex)_"^"_$G(Age)_"^"_$G(BedCode)_"^"_$G(RegNo)_"^"_$G(AdmDate)_"^"_$G(total)_"^"_$G(depos)_"^"_$G(warrant)_"^"_$G(admreason)_"^"_$G(ctloc)_"^"_$G(docdes)_"^"_$G(InsuId)_"^"_homeaddres_"^"_hometel_"^"_MedCareNo
}

ClassMethod GetLocUserExecute(ByRef qHandle As %Binary, LogLoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",LogLoc,rw)) q:rw=""  d
    .s DocDr=$P(^RB("RES",rw),"^",2)
    .q:DocDr="" 
    .s DocDes=$P(^RB("RES",rw),"^",17)
    .s flag=0
    .s SSUsrId=""  f  s SSUsrId=$O(^SSU("SSUSR",0,"CTPCP",DocDr,SSUsrId)) q:(SSUsrId="")!(flag=1)  d
    ..s SSName=$P(^SSU("SSUSR",SSUsrId),"^",2)
    ..if SSName=DocDes d
    ...s flag=1
    ...s UserCode=$P(^SSU("SSUSR",SSUsrId),"^",1)
    ...d OutRowtyp

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DocDes,DocDr,SSUsrId,UserCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLocUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocUserExecute ]
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

ClassMethod GetLocUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod OrdColorSet(Para As %String) As %String
{
 //颜色设置
   s ^TMP(9)=Para
	s Para=^TMP(0)
	s ln=$l(Para,"!")
	for i=1:1:ln-1
	{
	  s str=$P(Para,"!",i)
	  s item=$P(str,"^")
	  s index=$P(str,"^",2)
	  s ^DHCPdaOrdItemColor("ItemColor" ,i,item)=index
	}
	q 0
}

ClassMethod GetOrdColor() As %String
{
 //取得颜色设置
	s ret=""
	s i="" f  s i=$O(^DHCPdaOrdItemColor("ItemColor",i)) q:i=""  d
	.s item=""  f  s item=$O(^DHCPdaOrdItemColor("ItemColor",i,item)) q:item=""  d
	..s ret=ret_item_"^"_^DHCPdaOrdItemColor("ItemColor",i,item)_"!"
	q ret
}

ClassMethod GetWardPat(wardloc As %String) As %String
{
    s ret=""
    s ward=""  s ward=$O(^PAWARD(0,"WARD_LocationDR",wardloc,ward))
    if ward="" q ""
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
    ..s ret=ret_$G(patName)_""_$G(bedCode)_","_regno_"^"_Adm_"!"
    q ret
}

ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetObservationItm(Grp = "") As %String
{
   if (Grp="-1"){
   d ##class(web.DHCPdaComm).GetObserItm(.itm)
   }else{
   d ##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
	   }
	//s CDate=$ZD(CDate,3)
	//s CTime=$ZT(CTime,3)
	s Ret=""
	s num=""  f  s num=$O(itm(num)) q:num=""  d
	.s Ret=Ret_itm(num)_"$"
	q Ret
}

ClassMethod GetObInOutTime(Adm, CDate, Grp) As %String
{
  //^MR({MR_Adm.MRADM_RowId},"OBS",0,"Date",{OBS_Date},{OBS_Item_DR}, x
  //x           {OBS_Childsub})
  //取录入数据的时间
  s timstr=""
  s MRADMROWId=$P(^PAADM(Adm),"^",61) 
  s CDate=$ZDH(CDate,4)  
  s itmstr=##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
  s itmstr="^"_itmstr
  s itm=""  f  s itm=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm)) q:itm=""  d
  .q:itmstr'[itm
  .s chl=0  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm,chl)) q:chl=""  d
  ..s Ctim=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
  ..s Ctim=$ZT(Ctim,1)
  ..q:(timstr[Ctim)&(timstr'="")
  ..s timstr=timstr_Ctim_"^"
  q timstr_"^"
}

ClassMethod GetObserItm(itm) As %String
{
	s color("体温")="blue"
	s color("脉搏")="red"
	s color("呼吸")=""
	s color("心率")="red"
	s color("收缩压")=""
	s color("舒张压")=""
	s color("物理降温")="blue"
	s lyztstr="搀扶~担架~自来"
	s rw=0  f  s rw=$O(^MRC("OBITM",rw)) q:rw=""  d
	.s typ="",des=""
	.s des=$p(^MRC("OBITM",rw),"^",2)
	.s typ=$p(^MRC("OBITM",rw),"^",3)
	.s sort=$p(^MRC("OBITM",rw),"^",15)
	.q:sort=""
	.s itm(sort)=des_"^"_typ_"^"_$g(color(des))_"^"_rw
	.if des="来院状态" s itm(sort)=itm(sort)_"^"_lyztstr
	//s itm(14)="物理降温"_"^"_"N"_"^"_$g(color(des))_"^"_$P(itm(1),"^",4)
	b
	q 0
}

ClassMethod GetOBInOutItm(Grp As %String, itm) As %String
{
  //取出入量项目 //Grp="OutIn"
	//MRC_ObservationGroup
	//MRC_ObservationGroupItems
	//^MRC("OBGRP",0,"Code",$$ALPHAUP({GRP_Code}),{GRP_RowId})
	s color("体温")="blue"
	s color("脉搏")="red"
	s color("呼吸")=""
	s color("心率")="red"
	s color("收缩压")=""
	s color("舒张压")=""
	s color("物理降温")="blue"
	s lyztstr="搀扶~担架~自来"
	s str=""
	s n=1
	s GrpRow="" s GrpRow=$O(^MRC("OBGRP",0,"Code",$ZConvert(Grp,"U"),GrpRow))
	if (GrpRow'=""){
		 s chl=0 f  s chl=$O(^MRC("OBGRP",GrpRow,"ITM",chl)) q:chl=""  d
		 .s itmrw=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",1) 
		 .s sort=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",2)
	     .s des=$p(^MRC("OBITM",itmrw),"^",2)
	     .s typ=$p(^MRC("OBITM",itmrw),"^",3)
	     .if sort="" s sort=n
	     .s itm(sort)=des_"^"_typ_"^"_$G(color(des))_"^"_itmrw
	     .s n=n+1
	     .s str=$G(str)_itmrw_"^"
		}
 q "^"_str
}

ClassMethod CreatOrdExecIndex(Oew, stdate, enddata)
{
  //创建索引
    s stdate=stdate-1
    f Date=stdate:1:enddata d
    .s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"StDt",Date,Oew,OrdSub)) q:OrdSub=""  d
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2) 
	..s seqno=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority 
	..q:PriorDR=""
    ..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)  
	..s PriorDes="^"_PriorDes_"^"
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
    ..s OrdTyp=..GetOrdType(ItemCatDR)
    ..q:OrdTyp'="R"
    ..s ExSub=0 f  s ExSub=$O(^OEORD(Oew,"I",OrdSub,"X",ExSub)) q:ExSub=""  d
    ...s ExDate=$P(^OEORD(Oew,"I",OrdSub,"X",ExSub),"^",1) 
    ...s ExTime=$P(^OEORD(Oew,"I",OrdSub,"X",ExSub),"^",2)
    ...//w !,"ExDate--",ExDate,"St--",Date,"&",OrdSub,"--"
    ...if ^DHCOEOrdPrintSet("OrdTyp")[PriorDes  s ExDate=Date
    ...if ExTime="" s ExTime=32400  //
    ...if $D(OrdExdate(ExDate,ExTime,seqno)) d
    ....s ExDate=ExDate+1  //同一天医嘱推到第二天执行
    ....s $P(^OEORD(Oew,"I",OrdSub,"X",ExSub),"^")=ExDate
    ...s OrdExdate(ExDate,ExTime,seqno)=""
    ...
    ...i $D(^OEORDi(0,"NotExecE",Oew,ExDate,ExTime,OrdSub,ExSub)) q
    ...s ^OEORDi(0,"NotExecE",Oew,ExDate,ExTime,OrdSub,ExSub)=""
    ...//w !,OrdSub,"-",ExDate
    q
}

ClassMethod GetPatValue(Adm As %String, StDate As %String, EndDate As %String) As %String
{
   //生命体征数据查询
	//n (Adm,StDate,EndDate)
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s num=0
	//s nuitGridTim=86400/6
	//s gridw=UnitW/240  //(4小时)
	//s gridh=UnitH  //(每小格0.2度，4次)
    s Pulses="",Tw="",Breath=""
	f Date=StDate:1:EndDate
	{
		s num=num+1
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.s Name=$P(^MRC("OBITM",ItmDr),"^",2)
		.s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..s TimPos=(OBST/14400)
		..i ((Name["体温"))&(Value'="")  d
		...  //时间方向位置 
		...s Value=$FN(((Value)),"",2)
		...i Desc'="" s Tw(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_Desc_"#"    ;不是物理降温
		...e  s Tw(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_"#"
		..i Name["脉搏"&(Value'="") d
		...s Value=$FN(((Value)),"",2)
		...s Pulses(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_"#"  
		..i Name["呼吸"&(Value'="") d
    	...s Value=$FN(((Value)),"",2)
    	...s Breath(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_"#" 
	}
	s d="" f  s d=$O(Tw(d)) q:d=""  d
    .s t=""  f  s t=$O(Tw(d,t)) q:t=""  d
    ..s Tw=$G(Tw)_Tw(d,t)
    
    s d="" f  s d=$O(Pulses(d)) q:d=""  d
    .s t=""  f  s t=$O(Pulses(d,t)) q:t=""  d
    ..s Pulses=$G(Pulses)_Pulses(d,t)
    
    s d="" f  s d=$O(Breath(d)) q:d=""  d
    .s t=""  f  s t=$O(Breath(d,t)) q:t=""  d
    ..s Breath=$G(Breath)_Breath(d,t)
    
    s Data=$G(Tw)_"&"_$G(Pulses)_"&"_$G(Breath)
	q Data
}

ClassMethod Init(UserId As %String) As %String
{

	k ^DHCPdaNurSCHSet("schSet","OrdStat",UserId)
    k ^DHCPdaNurSCHSet("schSet","Prior",UserId)
    k ^DHCPdaNurSCHSet("schSet","OrdCat",UserId)
    k ^DHCPdaNurSCHSet("schSet","PhcIn",UserId)
    k ^DHCPdaNurSCHSet("schSet","StDatTim",UserId)
    k ^DHCPdaNurSCHSet("schSet","EndDatTim",UserId)
    q 0
}

ClassMethod GetTimePointExecute(ByRef qHandle As %Binary, Adm As %String, CDate As %String, Grp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s timstr=""
    s MRADMROWId=$P(^PAADM(Adm),"^",61) 
    s CDate=$ZDH(CDate,3)  
    s itmstr=##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
    s itmstr="^"_itmstr
    s itm=""  f  s itm=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm)) q:itm=""  d
    .s itmdr="^"_itm_"^"
    .q:itmstr'[itmdr
    .s chl=0  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm,chl)) q:chl=""  d
    ..s Ctim=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ..s Ctim=$ZT(Ctim,1)
    ..q:(timstr[Ctim)&(timstr'="")
    ..s timstr=timstr_Ctim_"^"
    ..s id=ind, des=Ctim
    ..d out1
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
	
out1
	set Data=$lb(id,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTimePointFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimePointExecute ]
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

ClassMethod GetTimePointClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimePointExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTimePoint(Adm, CDate, Grp) As %Query(ROWSPEC = "id,des")
{
}

ClassMethod GetObserTime(Adm As %String, CDate As %String, Grp As %String) As %String
{
   s QueryName="web.DHCPdaComm:GetTimePoint"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Adm,CDate,Grp)

   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>500  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod SetDisconOrder(oeoriId As %String, userId As %String)
{
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	s curDate=+$h,curTime=$p($h,",",2)
	//i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DisconUser_Dr,DHCORI_DisconDate,DHCORI_DisconTime) values(:oeoriId,:userId,:curDate,:curTime))
	//e  &sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:userId,DHCORI_DisconDate=:curDate,DHCORI_DisconTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
    //s ^DHCCLNurseExec("DISCON","OrdItem",oeoriId)=+$h_"^"_$p($h,",",2)_"^"_userId
    s oeordId=+oeoriId
	s oeoriSub=$p(oeoriId,"||",2)
    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
        .s curOeoriId=oeordId_"||"_curOriSub
        .s dhcoriId=$o(^DHCORDItem(0,curOeoriId,""))
		.s curDate=+$h,curTime=$p($h,",",2)
		.//i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_DisconUser_Dr,DHCORI_DisconDate,DHCORI_DisconTime) values(:curOeoriId,:userId,:curDate,:curTime))
		.//e  &sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:userId,DHCORI_DisconDate=:curDate,DHCORI_DisconTime=:curTime where DHCORI_OEORI_Dr=:curOeoriId)
    q +$h_"^"_$p($h,",",2)
}

ClassMethod UndoDisconOrder(oeoriId As %String, userId As %String)
{

    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" q 0
	s nullStr=""
	//&sql(update DHC_OE_OrdItem set DHCORI_DisconUser_Dr=:nullStr,DHCORI_DisconDate=:nullStr,DHCORI_DisconTime=:nullStr where DHCORI_OEORI_Dr=:oeoriId)
    //k ^DHCCLNurseExec("DISCON","OrdItem",oeoriId)
    q 0
}

ClassMethod GetEPARCIMDetail(EpisodeID As %String, InsType As %String, OrderDepRowid As %String, ArcimRowid As %String) As %String
{
	s ArcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(EpisodeID, "", "", ArcimRowid )
	//s ^TMP("ArcDetail")=ArcDetail
	q ArcDetail
}

ClassMethod CheckStockEnough(ArcimRowid As %String, Qty As %String, RecLoc As %String) As %String
{
 //查库存
  s ret=##class(web.DHCDocOrderCommon).CheckStockEnough(ArcimRowid,Qty,RecLoc)
  q ret
}

ClassMethod GetBlRecord(recId As %String) As %String
{
 //取电子病历记录
  ///CharItemId=124
   //CateGoryId 29	typ Normal	itemid--124	 itemtyp ---Multi

   s ret=""
   s chl="" f  s chl=$O(^DHCEPRI.ECRecordD(recId,"Instances",chl)) q:chl=""  d
   .s rec=^DHCEPRI.ECRecordD(recId,"Instances",chl)
   .s creatdate=$List(rec,25)
   .s creatTime=$List(rec,26)
   .s grpname=$List(rec,29)
   .s creatuser=$List(rec,3)
   .s username=$P(^SSU("SSUSR",creatuser),"^",2)
   .if grpname="" s grpname="病程"
   .s ret=ret_$ZD(creatdate,3)_"|"_$ZT(creatTime)_"|"_username_"|"_grpname_"|"_chl_"^"
   q ret
}

/// w ##class(web.DHCPdaComm).GetNextPatRegNo(RegNo)
ClassMethod GetNextPatRegNo(RegNo As %String = "") As %String
{
	///取相邻的下一个病人的登记号
	///RegNo   RegNo_"^"_NextFlag   NextFlag=-1  前一个   NextFlag=0  下一个
	k ^DHCPDATemp
	s NextFlag=0
	i $P(RegNo,"^",2)'="" s NextFlag=$P(RegNo,"^",2)
	s RegNo=$P(RegNo,"^",1)
	q:RegNo="" ""
	s admId=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo)
	q:admId="" ""
	s curWardId=$p($g(^PAADM(admId)),"^",70)
	s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
	q:((curWardId="")||(bedSub="")) ""
	s curBedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	s roomId=""  f  s roomId=$O(^PAADMi("CurrWard",curWardId,roomId)) q:roomId=""  d
    .s admId=""  f  s admId=$O(^PAADMi("CurrWard",curWardId,roomId,admId)) q:admId=""  d
    ..s dischgDate=$P(^PAADM(admId),"^",17)
    ..q:dischgDate'=""
    ..s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    ..q:bedSub=""
    ..s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    ..s papmiId=+^PAADM(admId)
    ..q:papmiId=""
    ..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    ..q:regNo=""
    ..s ^DHCPDATemp(bedCode)=regNo
    i NextFlag=0 s nextBedCode=$O(^DHCPDATemp(curBedCode))
    e  s nextBedCode=$O(^DHCPDATemp(curBedCode),-1)
	q:nextBedCode="" ""
	s nextRegNo=$G(^DHCPDATemp(nextBedCode))
	//k ^DHCPDATemp
	q nextRegNo
}

/// Description: 查询本病区的病人
/// Table：PA_Adm,PA_PatMas,PA_Person,PAC_Ward,PAC_Bed
/// Input：WardID: 病区指针
/// Return：输出登记号regNo,病人姓名patName,病人床位bedCode,病人就诊IDEpisodeID
Query FindCurWardPat(WardID As %String) As %Query(ROWSPEC = "patRegNo:%String,patName:%String,bedCode:%String,EpisodeID:%String,BedID:%String")
{
}

ClassMethod FindCurWardPatExecute(ByRef qHandle As %Binary, WardID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	i WardID="" d
 	.s logonLocId=%session.Data("LOGON.CTLOCID")
 	.s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	.i logonLocType="W" d
	..s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,""))
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	
	s WardID=$o(^PAWARD(0,"WARD_LocationDR",WardID,""))
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
 	..q:bedCode=""
 	..s bedCode=bedCode_"床"
	..s ^TMP(repid,"tempbedcode",bedCode,EpisodeID)=patRegNo_"^"_patName_"^"_bedSub
	..;d OutRowReg
	;i $g(^TMP(repid,"tempbedcode"))'="" d
	
	s bedCode=0 f  s bedCode=$o(^TMP(repid,"tempbedcode",bedCode)) q:bedCode=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^TMP(repid,"tempbedcode",bedCode,EpisodeID)) q:EpisodeID=""  d
	..s patRegNo=$p($g(^TMP(repid,"tempbedcode",bedCode,EpisodeID)),"^",1)
	..s patName=$p($g(^TMP(repid,"tempbedcode",bedCode,EpisodeID)),"^",2)
	..s bedSub=$p($g(^TMP(repid,"tempbedcode",bedCode,EpisodeID)),"^",3)
	..d OutRowReg
	k ^TMP(repid,"tempbedcode")
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowReg
	s Data=$lb(patRegNo,patName,bedCode,EpisodeID,bedSub)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

Storage Default
{
<Data name="DHCPdaCommDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPdaCommD</DataLocation>
<DefaultData>DHCPdaCommDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPdaCommD</IdLocation>
<IndexLocation>^web.DHCPdaCommI</IndexLocation>
<StreamLocation>^web.DHCPdaCommS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
