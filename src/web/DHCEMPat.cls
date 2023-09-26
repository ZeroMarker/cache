Class web.DHCEMPat Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

// w ##class(web.DHCEMPat).QueryPat("",0,20,"","","","")

ClassMethod QueryPat(EmPatNo, page = 0, rows = 20, Level = "", EmPatName = "", Loc = "", adm = "", IsAdmList = "", AdmListParams = "")
{
	n (EmPatNo,%session,page,rows,Level,EmPatName,Loc,adm,IsAdmList,AdmListParams)
	q:(IsAdmList="Y")&&(AdmListParams="") "{total:0,rows:[]}"
	
	s HospID=%session.Data("LOGON.HOSPID")
  	s CTLocID=$G(%session.Data("LOGON.CTLOCID"))
  	s UserID=%session.Data("LOGON.USERID")
  	s GrpID=%session.Data("LOGON.GROUPID")
  	s LgParams=HospID_"^"_CTLocID_"^"_GrpID_"^"_UserID
    s OrdType = ##class(web.DHCEMNurExe).GetConfigBySession("SEEORDTYPE",LgParams) 
    s:OrdType="" OrdType="OE"
    
    s ExecFormType=$p(AdmListParams,"^",1)
  	s AdmStDate=$p(AdmListParams,"^",2)
  	s AdmEndDate=$p(AdmListParams,"^",3)
  	s:AdmStDate'="" AdmStDate=##class(websys.Conversions).DateHtmlToLogical(AdmStDate)
  	s:AdmEndDate'="" AdmEndDate=##class(websys.Conversions).DateHtmlToLogical(AdmEndDate)
  	s:AdmStDate="" AdmStDate=+$H
  	s:AdmEndDate="" AdmEndDate=+$H
  	
  	s Exec = $p(AdmListParams,"^",4)
  	s UnExec = $p(AdmListParams,"^",5)
  	s SelectType=$p(AdmListParams,"^",6)
    
    s pid=##class(web.DHCAPPCommonUtil).NewPid()
   	k ^TMP("DHCST","web.DHCEMPat","GetPat",pid)
   
	s parStayFlag=##class(web.DHCEMOrdInfoVO).checkStayFlag(GrpID,UserID)													
	s total=0
	s levelOne=0
  	s levelTwo=0
  	s levelThree=0
  	s levelFour=0
  	s levelFive=0 //hxy 2020-02-20
  	s levelRed=0
  	s levelOrange=0 //hxy 2020-02-20
  	s levelYellow=0
  	s levelGreen=0
  	s locDesc=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","座位")
	
	//座位输液病人
	i (+parStayFlag=0)&&(IsAdmList'="Y") d
	.;q:+adm'=0
    .s PatSeatId=0
	.f  s PatSeatId=$o(^DHCEMPSE(PatSeatId))  q:PatSeatId=""  d
	..s SELocDr=$p(^DHCEMPSE(PatSeatId),"^",1)
	..q:SELocDr'=CTLocID
  	..s child=""
  	..f  s child=$o(^DHCEMPSE(PatSeatId,"SE",child)) quit:(child="")  d
  	...s SeatItmId=PatSeatId_"||"_child
  	...s PatRecDr = ""
  	...s PatRecDr= $p(^DHCEMPSE(PatSeatId,"SE",child),"^",4)
  	...q:+PatRecDr="0"
    ...s SeatNo=""
	...s a=^User.DHCNurSyPatRecD(PatRecDr)
	...s EpisodeID=$listget(a,3)
	...s patVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ...q:patVisit'="A"
	...//s UpdateDate=$listget(a,6)
	...//s UpdateTime=$listget(a,7)
	...s UpdateDate=$p($g(^PAADM(EpisodeID)),"^",41)
	...s UpdateTime=$p($g(^PAADM(EpisodeID)),"^",42)
	...d OutPut
    

	//急诊留观病人
	i (+parStayFlag=1)&&(IsAdmList'="Y") d
	.s:+Loc=0 Loc=CTLocID
	.s locDesc=$p(^CTLOC(Loc),"^",2)
	.s locDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",locDesc) 
	.;q:+adm'=0
	.s wardID=$o(^PAWARD(0,"WARD_LocationDR",Loc,0))
	.q:+wardID=0	
 	.s patRoomId=""
    .f  s patRoomId=$o(^PAADMi("CurrWard",wardID,patRoomId)) q:patRoomId=""  d
    ..s EpisodeID=0
    ..f  s EpisodeID=$o(^PAADMi("CurrWard",wardID,patRoomId,EpisodeID)) q:EpisodeID=""  d
    ...s patVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ...q:patVisit'="A"
    ...s UpdateDate=$p($g(^PAADM(EpisodeID)),"^",41)
	...s UpdateTime=$p($g(^PAADM(EpisodeID)),"^",42)
	...d OutPut
	
	
	i IsAdmList="Y" d
	.s OrdTypeLen=$l(OrdType)
	.f CurDate=AdmStDate:1:AdmEndDate d
	..;这里不走就诊的索引，改为走执行记录要求执行时间
	..i SelectType="Ord" d 	;按照医嘱查询
	...s Time=""
	...f  s Time=$o(^OEORDi(0,"DateExec",CurDate,Time)) q:Time=""  d
	....s Ord=0
	....f  s Ord=$o(^OEORDi(0,"DateExec",CurDate,Time,Ord)) q:Ord=""  d
	.....s EpisodeID=+^OEORD(Ord)
	.....s PatVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .....q:PatVisit'="A"
	.....s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    .....q:OrdType'[AdmType
    .....q:(AdmType="I")&&(PatVisit'="P")
	.....s PatientID=+^PAADM(+EpisodeID) 
	.....s AdmHosp = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	.....q:AdmHosp'=+LgParams
	.....s Itm=0
	.....f  s Itm=$o(^OEORDi(0,"DateExec",CurDate,Time,Ord,Itm)) q:Itm=""  d
	......s RecLocId = $p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
	......s RecHospId=""
	......s:+RecHospId'=0 RecHospId=$p(^CTLOC(RecLocId),"^",22)
	......q:(+RecHospId'=0)&&(RecHospId'=+LgParams)
	......s IsHasOrd=""
	......s Sub=0
	......f  s Sub=$o(^OEORDi(0,"DateExec",CurDate,Time,Ord,Itm,Sub))  q:(Sub="")||(IsHasOrd=1)  d
	.......s IsThisFormOrd=##class(web.DHCEMPat).IsInThisForm(LgParams,ExecFormType,Ord,Itm,Sub,Exec,UnExec)
	.......s:+IsThisFormOrd IsHasOrd=1
	......q:(ExecFormType'="")&&(IsHasOrd'=1)
	......s ^TMP("DHCEM","web.DHCEMPat","QueryPat",pid,PatientID,EpisodeID)=""
	..i SelectType="Adm" d	;按照就诊查询
	...f OrdTypeIndex=1:1:OrdTypeLen d
	....s PAADMType=$e(OrdType,OrdTypeIndex)
	....q:(PAADMType="I")
	....s EpisodeID=0
	....f  s EpisodeID=$o(^PAADMi("NNType",PAADMType,CurDate,EpisodeID)) q:EpisodeID=""  d
	.....s PatientID=+^PAADM(+EpisodeID) 
	.....s ^TMP("DHCEM","web.DHCEMPat","QueryPat",pid,PatientID,EpisodeID)=""
	.....;s ^TMP("DHCEM","web.DHCEMPat","QueryPatBak",pid,PatientID,EpisodeID)=""
	.;输出患者清单
	.s PatientID=""
	.f  s PatientID=$o(^TMP("DHCEM","web.DHCEMPat","QueryPat",pid,PatientID)) q:PatientID=""  d
	..s EpisodeID=$o(^TMP("DHCEM","web.DHCEMPat","QueryPat",pid,PatientID,""),-1)	;只显示最后一次患者的就诊
	..s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	..s UpdateDate=$p($g(^PAADM(EpisodeID)),"^",41)
	..s UpdateTime=$p($g(^PAADM(EpisodeID)),"^",42)
	..d OutPut
	
	
	//其他界面通过adm查询病人:2019-10-22 qqa 交付中心取消-让显示所有列表
	;i +adm'=0 d
	i 0 d
	.s EpisodeID=adm
	.s UpdateDate=$p($g(^PAADM(EpisodeID)),"^",41)
	.s UpdateTime=$p($g(^PAADM(EpisodeID)),"^",42)
	.s CurWard=+$p($g(^PAADM(EpisodeID)),"^",70)
	.s:CurWard'=0 locDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",$p(^PAWARD(CurWard),"^",2))
	.s:CurWard'=0 CurLoc=$p(^PAWARD(CurWard),"^",5)
	.d OutPut
	
	s:$g(CurLoc)="" CurLoc=Loc
	
	s Start=page-1*rows+1
	s End=page*rows
	s count=0

	w "{""rows"":["
	s SeatNo="" f  s SeatNo=$o(^TMP("DHCST","web.DHCEMPat","GetPat",pid,SeatNo)) q:SeatNo=""  d
	.s UpdateDate=""  f  s UpdateDate=$O(^TMP("DHCST","web.DHCEMPat","GetPat",pid,SeatNo,UpdateDate),-1) q:UpdateDate=""  d
	..s UpdateTime="" f  s UpdateTime=$O(^TMP("DHCST","web.DHCEMPat","GetPat",pid,SeatNo,UpdateDate,UpdateTime),-1)  q:UpdateTime=""  d
	...s data=^TMP("DHCST","web.DHCEMPat","GetPat",pid,SeatNo,UpdateDate,UpdateTime)
	...S count=count+1
	...Q:count<Start
	...Q:count>End
	...w $case(count,Start:"",:",")
	...s jsonObj=##class(web.DHCAPPJsonObject).%New()
	...d jsonObj.Put("SeatNo",$p(data,"^",1))
	...d jsonObj.Put("PatName",$p(data,"^",2))
	...d jsonObj.Put("CardNo",$p(data,"^",3))
	...d jsonObj.Put("EpisodeID",$p(data,"^",4))
	...d jsonObj.Put("Sex",$p(data,"^",5))
	...d jsonObj.Put("Age",$p(data,"^",6))
	...d jsonObj.Put("diagnos",$p(data,"^",7))
	...d jsonObj.Put("admreason",$p(data,"^",8))
	...d jsonObj.Put("UpdateDate",##class(websys.Conversions).DateLogicalToHtml(UpdateDate)) //$zd(UpdateDate,3)
	...d jsonObj.Put("UpdateTime",$zt(UpdateTime,1))
	...d jsonObj.Put("NurseLevel",$p(data,"^",9))
	...d jsonObj.Put("Papmidr",$p(data,"^",10))
	...d jsonObj.Put("Allgryflag",$p(data,"^",11)) ;2016-10-25 congyue
	...d jsonObj.Put("Deposit",$p(data,"^",12))
	...d jsonObj.Put("PatCardNo",$p(data,"^",13))
	...d jsonObj.Put("CardTypeNew",##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCCardTypeDef","CTDDesc","",$p(data,"^",14))) ;2023-02-24 卡类型描述
	...w jsonObj.Json()
	w "],""levelTwo"":"_levelTwo_",""levelThree"":"_levelThree_",""levelFour"":"_levelFour_",""levelOne"":"_levelOne_",""total"":"_total_",""locDesc"":"""_$g(locDesc)_""""_",""locId"":"""_$g(CurLoc)_""""
	w ",""levelRed"":"_levelRed_",""levelYellow"":"_levelYellow_",""levelGreen"":"_levelGreen_""
	w ",""levelOrange"":"_levelOrange_",""levelFive"":"_levelFive //hxy 2020-02-20
	w "}"
	k ^TMP("DHCST","web.DHCEMPat","GetPat",pid)
	k ^TMP("DHCEM","web.DHCEMPat","QueryPat",pid)
	
	q ""
OutPut
	s diagnos=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(+EpisodeID)
	s admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    s:admreasondr'="" admreason=$P(^PAC("ADMREA",admreasondr),"^",2)
	s Papmidr=$P($g(^PAADM(EpisodeID)),"^",1)
	q:Papmidr=""  
	s PatName=$P(^PAPER(Papmidr,"ALL"),"^",1)
	;q:$P(^PAPER(Papmidr,"ALL"),"^",12)="Y"
	q:($g(EmPatName)'="")&&(PatName'[$g(EmPatName))
	i parStayFlag=1 d
	.s beddr=$p(^PAADM(+EpisodeID),"^",73)
  	.s:beddr'="" PatName=PatName_"("_$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)_")"
  	e  d
  	.s PatName=PatName_..GetSeat(CTLocID,+EpisodeID)
	s age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(Papmidr,"ALL")),"^",7))),"^",2)
	s Sex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",Sex) //hxy 2022-12-20
	s admreason=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACAdmReason","READesc","",admreason) //hxy 2022-12-20
	s PatNo=$p(^PAPER(Papmidr,"PAT",1),"^",1)	/// 病人登记号
	Q:(EmPatNo'="")&(EmPatNo'=PatNo)
	s CardNoID=##Class(web.DHCEMPatCheckLevQuery).GetPatCardNoID(Papmidr)  		         /// 病人卡号ID
	s PatCardNo=$p($g(^DHCCARD("CF",+CardNoID)),"^",2) 		 /// 卡号
	s PatCardTypeID=$p($g(^DHCCARD("CF",+CardNoID)),"^",16) 	 /// 卡类型
	s:PatCardTypeID'="" PatCardTypeID=PatCardTypeID_"^"_$g(^DHCCARDTYPEDef(PatCardTypeID))
	s PatCardType=""
	s:PatCardTypeID'="" PatCardType=$p(PatCardTypeID,"^",3)
	s NurseLevel=0
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",Papmidr,""),-1)
	i EmRegID'="" d
	.s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",Papmidr,EmRegID,""))  /// 分诊ID
	.s:EmPCLvID'="" NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)
	s tmpLevel=..GetDocLevel(+EpisodeID)
	s:tmpLevel'=0 NurseLevel=tmpLevel
	s SeatNo = ##class(web.DHCEMPatientSeat).GetBedDescByEpisodeID(CTLocID,EpisodeID)
	s Allgryparref=$o(^PAPERi("PAPMI_PatNo",(PatNo),"")) ;2016-10-25 congyue
	s Allgrysub="",Allgryflag="" ;2016-10-25 congyue
	//s:Allgryparref'="" Allgrysub=$o(^PAPER(Allgryparref,"ALG",""),-1) ;2016-10-25 congyue
	i Allgryparref'="" d
	.s Allgrysub=""
	.f  s Allgrysub=$o(^PAPER(Allgryparref,"ALG",Allgrysub)) q:Allgrysub=""  d ;2016-10-25 congyue
	..s AllStatus=$p(^PAPER(Allgryparref,"ALG",Allgrysub),"^",8)
	..q:AllStatus'="A"
	..s Allgryflag=1  ;2017/08/17 lq
	s TmpLevel=""
	;s:(NurseLevel=1)||(NurseLevel=2) TmpLevel=1        ///红黄绿 //hxy 2020-02-20 st
	;s:(NurseLevel=3) TmpLevel=2
	;s:(NurseLevel=4) TmpLevel=3
	s:(NurseLevel=1) TmpLevel=1        ///红橙黄绿
	s:(NurseLevel=2) TmpLevel=2
	s:(NurseLevel=3) TmpLevel=3
	s:(NurseLevel=4)||(NurseLevel=5) TmpLevel=4 //ed
	s:NurseLevel=1 levelOne=levelOne+1,tmpLevel=1      ///各个级别的人数
  	;s:NurseLevel=2 levelOne=levelOne+1,tmpLevel=1
  	s:NurseLevel=2 levelTwo=levelTwo+1,tmpLevel=2 //hxy 2020-02-20
  	s:NurseLevel=3 levelThree=levelThree+1,tmpLevel=3
  	s:NurseLevel=4 levelFour=levelFour+1,tmpLevel=4
  	s:NurseLevel=5 levelFive=levelFive+1,tmpLevel=4 //hxy 2020-02-20
  	s:TmpLevel=1 levelRed = levelRed+1                 ///各个分区的人数
  	;s:TmpLevel=2 levelYellow = levelYellow+1 //hxy 2020-02-20 st
  	;s:TmpLevel=3 levelGreen = levelGreen+1
  	s:TmpLevel=2 levelOrange = levelOrange+1
  	s:TmpLevel=3 levelYellow = levelYellow+1
  	s:TmpLevel=4 levelGreen = levelGreen+1 //ed
  	s Deposit="" ;##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID) 
	q:(Level'="")&&(Level'=TmpLevel)
	s index=+$p(SeatNo,"号",1)
	i +index=0 d
	.s index="SeatNo"
	s total=total+1
    s ^TMP("DHCST","web.DHCEMPat","GetPat",pid,index,UpdateDate,UpdateTime)=$g(SeatNo)_"^"_$g(PatName)_"^"_PatNo_"^"_EpisodeID_"^"_$g(Sex)_"^"_$g(age)_"^"_$g(diagnos)_"^"_$g(admreason)_"^"_$g(NurseLevel)_"^"_Papmidr_"^"_Allgryflag_"^"_$g(Deposit)_"^"_PatCardNo_"^"_PatCardType
}

/// w ##class(web.DHCEMPat).QueryPatOneAdm("1687")
ClassMethod QueryPatOneAdm(EpisodeID)
{
	n (EpisodeID)
	s UpdateDate=$p($g(^PAADM(EpisodeID)),"^",41)
	s UpdateTime=$p($g(^PAADM(EpisodeID)),"^",42)
	s CurWard=+$p($g(^PAADM(EpisodeID)),"^",70)
	s:CurWard'=0 locDesc=$p(^PAWARD(CurWard),"^",2)
	s:CurWard'=0 CurLoc=$p(^PAWARD(CurWard),"^",5)
	s diagnos=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(+EpisodeID)
	s admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    s:admreasondr'="" admreason=$P(^PAC("ADMREA",admreasondr),"^",2)
	s Papmidr=$P($g(^PAADM(EpisodeID)),"^",1)
	q:Papmidr=""  
	s PatName=$P(^PAPER(Papmidr,"ALL"),"^",1)
	q:($g(EmPatName)'="")&&(PatName'[$g(EmPatName))
	s age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(Papmidr,"ALL")),"^",7))),"^",2)
	s PatNo=$p(^PAPER(Papmidr,"PAT",1),"^",1)	/// 病人登记号
	
	s NurseLevel=0
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",Papmidr,""),-1)
	i EmRegID'="" d
	.s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",Papmidr,EmRegID,""))  /// 分诊ID
	.s:EmPCLvID'="" NurseLevel=$p(^DHCEMPCL(EmPCLvID),"^",7)
	s tmpLevel=..GetDocLevel(+EpisodeID)
	s:tmpLevel'=0 NurseLevel=tmpLevel
	s SeatNo = ""
	s Allgryparref=$o(^PAPERi("PAPMI_PatNo",(PatNo),""))
	s Allgrysub="",Allgryflag="" 
	i Allgryparref'="" d
	.s Allgrysub=""
	.f  s Allgrysub=$o(^PAPER(Allgryparref,"ALG",Allgrysub)) q:Allgrysub=""  d ;2016-10-25 congyue
	..s AllStatus=$p(^PAPER(Allgryparref,"ALG",Allgrysub),"^",8)
	..q:AllStatus'="A"
	..s Allgryflag=1  ;2017/08/17 lq
	s TmpLevel=""
	s:(NurseLevel=1)||(NurseLevel=2) TmpLevel=1        ///红黄绿
	s:(NurseLevel=3) TmpLevel=2
	s:(NurseLevel=4) TmpLevel=3
  	s Deposit=##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID) 
	
	s index=+$p(SeatNo,"号",1)
	i +index=0 d
	.s index="SeatNo"
	s data=$g(SeatNo)_"^"_$g(PatName)_"^"_PatNo_"^"_EpisodeID_"^"_$g(Sex)_"^"_$g(age)_"^"_$g(diagnos)_"^"_$g(admreason)_"^"_$g(NurseLevel)_"^"_Papmidr_"^"_Allgryflag_"^"_$g(Deposit)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	d jsonObj.Put("SeatNo",$p(data,"^",1))
	d jsonObj.Put("PatName",$p(data,"^",2))
	d jsonObj.Put("CardNo",$p(data,"^",3))
	d jsonObj.Put("EpisodeID",$p(data,"^",4))
	d jsonObj.Put("Sex",$p(data,"^",5))
	d jsonObj.Put("Age",$p(data,"^",6))
	d jsonObj.Put("diagnos",$p(data,"^",7))
	d jsonObj.Put("admreason",$p(data,"^",8))
	d jsonObj.Put("UpdateDate",##class(websys.Conversions).DateLogicalToHtml(UpdateDate)) //$zd(UpdateDate,3)
	d jsonObj.Put("UpdateTime",$zt(UpdateTime,1))
	d jsonObj.Put("NurseLevel",$p(data,"^",9))
	d jsonObj.Put("Papmidr",$p(data,"^",10))
	d jsonObj.Put("Allgryflag",$p(data,"^",11)) ;2016-10-25 congyue
	d jsonObj.Put("Deposit",$p(data,"^",12))
	w jsonObj.Json()
	q ""
}

/// Creator：   zhouxin
/// CreatDate：    2016-06-29
/// Description:： ch
/// w ##class(web.DHCEMPat).GetPatInfo("","101")
ClassMethod GetPatInfo(EpisodeID, PatientID = "")
{
	n (%session,EpisodeID,PatientID)
	q:(+PatientID=0)&&(+EpisodeID=0) "{}"
	
  	s:$d(%session) loc=$G(%session.Data("LOGON.CTLOCID"))
  	s diagnos=""
  	s:+EpisodeID'=0 diagnos=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(+EpisodeID)
	s admreasondr="",admreason=""
	s:+EpisodeID'=0 admreasondr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    s:admreasondr'="" admreason=$P(^PAC("ADMREA",admreasondr),"^",2)
	s:+EpisodeID'=0 PatientID=$P($g(^PAADM(EpisodeID)),"^",1)
	q:PatientID="" ""
	s Papmidr=PatientID
	
	s PatName=$P(^PAPER(PatientID,"ALL"),"^",1)
	q:($g(EmPatName)'="")&&(PatName'[$g(EmPatName))
	s age=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	s UpdateDate="",UpdateTime=""
	s:+EpisodeID'=0 UpdateDate=$p($g(^PAADM(EpisodeID)),"^",41)
	s:+EpisodeID'=0 UpdateTime=$p($g(^PAADM(EpisodeID)),"^",42)
	s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)
	i EmRegID'="" d
	.s EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""))  /// 分诊ID
	s NurseLevel=""
	s:+EpisodeID'=0 NurseLevel=..GetDocLevel(EpisodeID)
	s Allgryparref=$o(^PAPERi("PAPMI_PatNo",(PatNo),"")) ;2016-10-25 congyue
	s Allgrysub="",Allgryflag="" ;2016-10-25 congyue
	i Allgryparref'="" d
	.s Allgrysub=""
	.f  s Allgrysub=$o(^PAPER(Allgryparref,"ALG",Allgrysub)) q:Allgrysub=""  d ;2016-10-25 congyue
	..s AllStatus=$p(^PAPER(Allgryparref,"ALG",Allgrysub),"^",8)
	..q:AllStatus'="A"
	..s Allgryflag=1  ;2017/08/17 lq
	
	s CardNoID=##Class(web.DHCEMPatCheckLevQuery).GetPatCardNoID(PatientID)  		         /// 病人卡号ID
	s PatCardNo=$p($g(^DHCCARD("CF",+CardNoID)),"^",2) 		 /// 卡号
	s PatCardTypeID=$p($g(^DHCCARD("CF",+CardNoID)),"^",16) 	 /// 卡类型
	s:PatCardTypeID'="" PatCardTypeID=PatCardTypeID_"^"_$g(^DHCCARDTYPEDef(PatCardTypeID))
	s PatCardType=""
	s:PatCardTypeID'="" PatCardType=$p(PatCardTypeID,"^",3)
	s PatCardType=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCCardTypeDef","CTDDesc","",PatCardType)
	s Deposit=""
	s:+EpisodeID'=0 Deposit=##class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)   
  	s bedcode = ""
  	s:+EpisodeID'=0 bedcode=##class(web.DHCEMPatientSeat).GetBedDescByEpisodeID(loc,EpisodeID)
  	
  	s jsonObj=##class(web.DHCAPPJsonObject).%New()
  	d jsonObj.Put("SeatNo",$g(bedcode))
  	d jsonObj.Put("UpdateDate",##class(websys.Conversions).DateLogicalToHtml(UpdateDate)) //hxy $zd(UpdateDate,3)
  	d jsonObj.Put("UpdateTime",$zt(UpdateTime))
  	d jsonObj.Put("NurseLevel",NurseLevel)
  	d jsonObj.Put("PatName",PatName)
  	d jsonObj.Put("CardNo",PatNo)   			   ///登记号
  	d jsonObj.Put("PatCardNo",PatCardNo)   ///卡号
  	d jsonObj.Put("PatCardTypeID",PatCardTypeID)   ///卡类型ID
	d jsonObj.Put("CardTypeNew",PatCardType)   ///卡类型
  	d jsonObj.Put("Sex",Sex)
  	d jsonObj.Put("Age",age)
  	d jsonObj.Put("diagnos",diagnos)
  	d jsonObj.Put("admreason",$g(admreason))
  	d jsonObj.Put("Papmidr",Papmidr)
  	d jsonObj.Put("EpisodeID",EpisodeID)
  	d jsonObj.Put("Allgryflag",Allgryflag) ;2016-10-25 congyue
  	d jsonObj.Put("Deposit",Deposit)
  	w jsonObj.Json()
  	q ""
}

ClassMethod GetDocLevel(EpisodeID)
{
	n (EpisodeID)
	s code=0
	set pri=+$p(^PAADM(EpisodeID),"^",33)
	i pri'=0 d
	.s code=+$p(^CT("ACU",pri),"^",1)
	q code
}

ClassMethod GetSeat(loc, adm)
{
	S PatSeat=""
	Q:adm="" PatSeat
	s PatRecId=$o(^User.DHCNurSyPatRecI("patseat"," "_loc," "_adm,""),-1)
	s PatFlag=""
	s:PatRecId'="" PatFlag = $lg(^User.DHCNurSyPatRecD(PatRecId),9) 
	I PatFlag="Y" D
	.S SeatId = $lg(^User.DHCNurSyPatRecD(PatRecId),5)
	.s PatSeat=" ("_$p(^DHCEMPSE($p(SeatId,"||",1),"SE",$p(SeatId,"||",2)),"^",2)_")"
	q PatSeat
}

/// 获取留观病区中床位
/// w ##class(web.DHCEMPat).GetEmPatSeat(30)
ClassMethod GetEmPatSeat(Ward)
{
	s Count=0
	s BedSub = "0"
	f  s BedSub = $o(^PAWARD(Ward,"BED",BedSub))  q:BedSub=""  d
	.s Count=Count+1
	q Count
}

/// 获取留观室床位上有人的床数
/// w ##class(web.DHCEMPat).GetHasEmPatSeat(105)
ClassMethod GetHasEmPatSeat(Ward)
{
	s Count= 0
	s PatRoomId=0
    f  s PatRoomId=$o(^PAADMi("CurrWard",Ward,PatRoomId)) q:PatRoomId=""  d
    .s EpisodeID=0
    .f  s EpisodeID=$o(^PAADMi("CurrWard",Ward,PatRoomId,EpisodeID)) q:EpisodeID=""  d	
    ..s Count = Count+1
    q Count
}

/// w ##class(web.DHCEMPat).IsInThisForm("3^100^18^12406","MZQBYZ","902","4","3","false","true","")
ClassMethod IsInThisForm(LgParams, QueryType, Ord, Itm, Sub, Exec, UnExec)
{
	n (LgParams,QueryType,Ord,Itm,Sub,Exec,UnExec)
	
	q:##class(web.DHCEMNurExe).checkExec(Ord,Itm,Sub,Exec,UnExec)=0 0
	
	s DisStatCode=##class(web.DHCEMNurExe).updateDisposeStatCode(Ord,Itm,Sub) 
	s IsThisFormOrd=##class(web.DHCEMNurExe).CheckCon(LgParams,QueryType,Ord,Itm,DisStatCode, Exec, UnExec)
	q +IsThisFormOrd
}

/// 2023-03-03 22库方法
/// w ##class(web.DHCEMPat).listEmPat(1,20,"")
ClassMethod listEmPat(page = 1, rows = 20, params)
{
	n (page,rows,params)
	s st=page-1*rows+1
	s end=page*rows
	s stDate=$p(params,"^",1)
  	s endDate=$p(params,"^",2)
  	s:stDate'="" stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
  	s:endDate'="" endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
  	s:stDate="" stDate=+$H
  	s:endDate="" endDate=+$H
  	s inChkLev=$p(params,"^",3)
  	s inPatNo=$p(params,"^",4)
  	s inCardNo=$p(params,"^",5)
  	s inAdmLoc=$p(params,"^",6)
  	s inEmWardId=$p(params,"^",7)
	s ordType=$p(params,"^",8)
	
	s ordTypeLen=$l(ordType)
	f date=stDate:1:endDate {
		f ordTypeIndex=1:1:ordTypeLen {
			s admType=$e(ordType,ordTypeIndex)
			s admId=0
			f {
				s admId=$o(^PAADMi("NNType",admType,date,admId))	
				q:admId=""
				s patVisit=$p($g(^PAADM(admId)),"^",20)
    			q:patVisit'="A"
    			s TMPData("admId",admId)=""
			}
		}
	}
	
	s count=0
	w "{""rows"":["
	s title="admId^patientId^patNo^patName^patSex^patBDay^patAge^admDate^admTime^deposit^admLoc^admDoc^admPriority^emNurLev^emPCLvArea^admWard^admBed^diagnosis"
	s title=title_"^walkStatus^regDoctor^billType^emPatGreFlag^emPCLvNurse"
	s admId=0
	f {
		s admId = $o(TMPData("admId",admId))
		q:admId=""
		
		s patientId = $p(^PAADM(admId),"^",1)
		s patName=$p(^PAPER(patientId,"ALL"),"^",1)
		s patNo=$p(^PAPER(patientId,"PAT",1),"^",1)       //登记号
		continue:(inPatNo'="")&&(patNo'[inPatNo)
		s patSex=""
		s sexId=$p(^PAPER(patientId,"ALL"),"^",7)         //姓别
		i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)
		s patBDay=$p(^PAPER(patientId,"ALL"),"^",6)       //出生日期
		i patBDay'="" s patBDay=$zd(patBDay,3)
		s patAge=##Class(web.DHCSTKUTIL).GetAge(patientId)  //年龄
		s admCacheDate=$P($g(^PAADM(admId)),"^",6)
		s admCacheTime=$P($g(^PAADM(admId)),"^",7)
		s admDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(admCacheDate)  //就诊日期
		s admTime=$ZT(admCacheTime,2)  //就诊时间
		s deposit=##class(web.UDHCJFBaseCommon).deposit(admId) // 患者未结算押金总额
		s admNo=$P($g(^PAADM(admId)),"^",81)          
		s admLocId=$P($g(^PAADM(admId)),"^",4)
		continue:(inAdmLoc'="")&&(admLocId'=inAdmLoc)
		s admLoc=$P($g(^CTLOC(admLocId)),"^",2)
		i admLoc["-" s admLoc=$p(admLoc,"-",2)
		s admDocId=$P($g(^PAADM(admId)),"^",9)
		s admDoc=$P($g(^CTPCP(+admDocId,1)),"^",2)
		s billType=$p(^PAPER(patientId,"PER",1),"^",10)                        /// 费别
		s:billType'="" billType=$p(^CT("SS",billType),"^",2)
		
		
		s admPriority=""                        /// 优先级、优先级代码、背景色
		s priority=$P($g(^PAADM(admId)),"^",33)
		s priorityColor=""
		i priority'="" s admPriority=$p($g(^CT("ACU",priority)),"^",1)
		s:priority="" priority=5                                             /// 排序字段为空设置为5
		continue:(inChkLev'="")&&(+admPriority'=inChkLev)
		s emPCLvArea=$s(admPriority="1级":"红区",admPriority="2级":"橙区",admPriority="3级":"黄区",admPriority="4级":"绿区",admPriority="5级":"绿区",1:"")
		s emNurLev=##Class(web.DHCEMDocMainOutPat).GetEmPatCheckLev(admId)
		
		s wardDr=$P($g(^PAADM(admId)),"^",70)                                    /// 
		continue:(inEmWardId'="")&&(wardDr'=inEmWardId)
		s admWard=$P($g(^PAWARD(+wardDr)),"^",2)                       /// 病区
		s:admWard["-" admWard=$p(admWard,"-",2)
		s bedId=$P($g(^PAADM(admId)),"^",73)
		s admBed=""
		I bedId'="" s admBed=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)  /// 床号
		s diagnosis=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(admId,"","")
		s walkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(admId)       /// 当前状态
		i walkStatus'="" Set walkStatus=$P(walkStatus,"^",2)
		s queRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",admId,""))
		s queObj=##Class(User.DHCQueue).%OpenId(queRowId,0)
		s regDocCode="", regDoctor=""
		s regDocDr=queObj.QueMarkDr.%Id()
		i regDocDr'="" D
		.Set regDoctor=$P($g(^CTPCP(regDocDr,1)),"^",2)
		.Set regDocCode=$P($g(^CTPCP(regDocDr,1)),"^",1)
		s emPatGreFlag=##Class(web.DHCEMDocMainOutPat).GetEmPatGreenFlag(admId) /// 绿色通道标示
		s emPCLvNurse=##Class(web.DHCEMDocMainOutPat).GetEmPCLvNurse(admId)     /// 分级护士
		
		s count=count+1
		continue:count<st
		continue:count>end
		s itm = admId_"^"_patientId_"^"_patNo_"^"_patName_"^"_patSex_"^"_patBDay_"^"_patAge_"^"_admDate_"^"_admTime_"^"_deposit_"^"_admLoc_"^"_admDoc_"^"_admPriority_"^"_emNurLev_"^"_emPCLvArea
		s itm = itm_"^"_admWard_"^"_admBed_"^"_diagnosis_"^"_walkStatus_"^"_regDoctor_"^"_billType_"^"_emPatGreFlag_"^"_emPCLvNurse
		w $case(count,st:"",:",")
		w ##class(web.DHCAPPJsonCommon).getJsonData(title,itm)
	}
	
	w "],""total"":"_count
	w "}"
	q ""
}

}
