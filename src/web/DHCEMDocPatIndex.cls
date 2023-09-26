Class web.DHCEMDocPatIndex Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMDocPatIndex).GetObsAreaAnaData("2^2022-11-10^2022-11-10")
ClassMethod GetObsAreaAnaData(LgParam = "")
{
	
	s UserID=$p(LgParam,"^",1)
	s lgLocId=$p(LgParam,"^",2)
	s GroupID=$p(LgParam,"^",3)
	s HospID=$p(LgParam,"^",4)
	s:HospID="" HospID=2
	s:lgLocId="" lgLocId="39"
	s StDate = +$h ;$p(Params,"^",2)
	s EndDate = +$h ;$p(Params,"^",3)
	;s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	;s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s Pid = ##Class(web.DHCEMInterfaceCom).NewPid() //hxy 2020-04-03
	k ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData")
	f Date=StDate:1:EndDate  d 
  	.s Time="",Num=0
 	.f  s Time=$o(^PAADMi("TransDateTime",Date,Time))   Q:Time=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TransDateTime",Date,Time,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录:这个是在安排床位的时候插入的表格
 	...q:$p(^PAADM(EpisodeID),"^",2)'="E"
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)              //用来判断病人是否留观
 	...q:+PatWarDr=0                            			//为空代表没有留观
 	...s PatWarDesc = $p(^PAWARD(PatWarDr),"^",2)
 	...s:PatWarDesc["-" PatWarDesc = $p(PatWarDesc,"-",2)
	...s LocID = $p(^PAWARD(PatWarDr),"^",5)				//病区所所属的科室
	...s LocHospID = $p(^CTLOC(LocID),"^",22)
	...q:(HospID'="")&&(HospID'=LocHospID)                  //
	...Q:$p(^CTLOC(LocID),"^",13)'="EM"
    ...Q:'$o(^PAWARD(PatWarDr,"ROOM",0))
	...Q:$d(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc,EpisodeID))
	...i $d(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc))  d
	....S ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc)=^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc)+1
	...E  d
	....S ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc)=1
	...S ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc,EpisodeID)=""
	...;以上是用来获取时间段内进入留观室的人

	///离院患者
	s DischargeDr = $o(^DHCPACVisitStatus(0,"Desc","离院",""))  
	For Date=+$H:1:+$H Do
	.Set AVSRowId=""
	.For  s AVSRowId=$o(^DHCADMVisitStatus(0,"DateStatus",Date,DischargeDr,AVSRowId)) Quit:AVSRowId=""  Do
	..Set EpisodeID = $p(^DHCADMVisitStatus(AVSRowId),"^",1)
	..Set ADMVisitStatusDr = $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	..Set PACVisitStatusDr=$p(^DHCADMVisitStatus(ADMVisitStatusDr),"^",2)
	..Set CurStatusDesc = $p(^DHCPACVisitStatus(PACVisitStatusDr),"^",2)
	..Quit:PACVisitStatusDr'=DischargeDr 
	..Set AdmWardId=$p(^PAADM(EpisodeID),"^",70)
	..Quit:+AdmWardId=0
	..s AdmHospId=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	..q:(HospID'="")&&(HospID'=AdmHospId)
	..Q:$d(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc,EpisodeID))
	..i $d(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc))  d
	...S ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc)=^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc)+1
	..E  d
	...S ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc)=1
	..S ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc,EpisodeID)=""
	
	
	s WardID=0
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s PatWarDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<StDate)&&(StDate'=""))!((+$h>EndDate)&&(EndDate'=""))
	.s:PatWarDesc["-" PatWarDesc=$p(PatWarDesc,"-",2)
	.S HasPatNum=0   //用来记录当前床位使用情况
	.s BedSub=0
	.f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	..s BedAdmSub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	..i BedAdmSub'="" d
	...s EpisodeID = $p(^PAWARDA(WardID,"BED",BedSub,"ADM",BedAdmSub),"^",1)
	...q:'$d(^PAADM(EpisodeID))
	...s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
	...q:lgLocId'=AdmLocID	;只看就诊科室是本科室的离院患者
	...s HasPatNum=HasPatNum+1
	...s ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Ward",Pid,PatWarDesc,EpisodeID)=""  
	...;当前在留观室的病人
	.Set CH=0
	.For  Set CH=$O(^PAWARDA(WardID,"WADM",CH)) Quit:CH=""  Do
	..Set EpisodeID=$P(^PAWARDA(WardID,"WADM",CH),"^",1)
	..s PAAdmWard=""
	..s PAAdmWard=$P($g(^PAWARD(WardID)),"^",2)                       /// 病区
	..s:PAAdmWard["-" PAAdmWard=$p(PAAdmWard,"-",2)
	..s AdmLocID=$p(^PAADM(EpisodeID),"^",4) 	/// 科室
	..q:lgLocId'=AdmLocID	;只看就诊科室是本科室的离院患者
	..s AdmVisit=$p(^PAADM(EpisodeID),"^",20)
	..q:AdmVisit'="A"
	..q:$d(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Ward",Pid,PAAdmWard,EpisodeID))
	..s HasPatNum=HasPatNum+1
	..s ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Ward",Pid,PAAdmWard,EpisodeID)=""
	.s ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Ward",Pid,PatWarDesc) = HasPatNum
	
	
	b ;data
	s Del=""""
	w "{"
	w Del_"ObsPatNum"_Del_":"
	w Del_##class(web.DHCEMDocPatIndex).ObsPatNum(Pid)_Del
	w ","
	w Del_"DisHospPatNum"_Del_":"
	w ##class(web.DHCEMDocPatIndex).DisHospPatNum(Pid)
	w ","
	w Del_"InLocPatNum"_Del_":"
	w ##class(web.DHCEMDocPatIndex).InLocPatNum(Pid)
	w "}"
	k ^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData")
	q ""
}

ClassMethod KeyDiseasePatNum(Pid)
{
	n (Pid)
	
	s NPid = ##Class(web.DHCEMInterfaceCom).NewPid()
	
	s PatWarDesc=""
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s PatCheckLevID = $O(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))    //分级ID
	..q:PatCheckLevID=""
	..s PCSPId=""
	..f  s PCSPId=$o(^DHCEMPCSP(0,"PatCheckLev",PatCheckLevID,PCSPId)) q:PCSPId=""  d
	...s SPDId = $p(^DHCEMPCSP(PCSPId),"^",2)
	...s SPDDesc = $p($g(^DHCEMSPD(SPDId)),"^",2)
	...q:SPDDesc="" 
	...s TMPData(NPid,SPDDesc) = +$g(TMPData(NPid,SPDDesc))+1
	
	s Count=0
	w "["
	s SPDDesc=""
	f  s SPDDesc = $o(TMPData(NPid,SPDDesc)) q:SPDDesc=""  d
	.s Tmp = SPDDesc_"^"_TMPData(NPid,SPDDesc)
	.w $case(Count,0:"",Count:",")
	.s Count =Count+1
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",Tmp)
	w "]"
}

/// Descript:获取PAADM状态改变中包含转入院状态的PAADM
/// d ##class(web.DHCEMDocPatIndex).ParseInPatNum("139390")
ClassMethod ParseInPatNum(Pid)
{
	n (Pid)
	s NewPid = ##Class(web.DHCEMInterfaceCom).NewPid()
	k ^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable")
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s InWardDesc=""
	..s NextAdm = ##class(web.DHCEMPatCheckLevStat).GetNextAdm(EpisodeID)
	..s AdmType=""
	..s:NextAdm'="" AdmType= $p(^PAADM(NextAdm),"^",2)
	..s:AdmType'="I" InWardDesc="未入院"
	..;s PatCurStatusDr=""
	..;f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,PatCurStatusDr),-1) q:(PatCurStatusDr="")||(InWardDesc'="")  d
	...;s StatusDr = $p(^DHCADMVisitStatus(PatCurStatusDr),"^",2)
	...;s StatusDesc = $p(^DHCPACVisitStatus(StatusDr),"^",2)
	...;q:StatusDesc'["入院" 
	...;s InWardID = $p(^DHCADMVisitStatus(StatusDr),"^",10)
	...;Q:InWardID=""
	...;s InWardDesc = $p(^PAWARD(InWardID),"^",2)   // 这个就是入院病区
	..i AdmType="I" d
	...s InWardID = $p(^PAADM(NextAdm),"^",70)
	...s InWardDesc = $p(^PAWARD(InWardID),"^",2)   // 这个就是入院病区
	..s:InWardDesc="" InWardDesc="未入院"
	..s:$d(^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid,InWardDesc)) ^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid,InWardDesc)=^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid,InWardDesc)+1
	..s:'$d(^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid,InWardDesc)) ^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid,InWardDesc)=1
	b ;data
	w "["
	s InWardDesc="",Count=0
	f  s InWardDesc = $o(^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid,InWardDesc)) q:InWardDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid,InWardDesc)
	.s Data  = InWardDesc_"^"_Num_"^"_"入院病区"
	.w $case(Count,0:"",Count:",")
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",Data)
	.s Count =Count+1
	w "]"
	k ^TMP("DHCEM","web.DHCEMDocPatIndex","JsonBedTable",NewPid)
	q ""
}

ClassMethod GetInLocDesc(PaAdm)
{
	n (PaAdm)
	s AdmTranSub = $o(^PAADM(PaAdm,"TRANS",""))
	q:+AdmTranSub=0 ""
	s LocDr = $p(^PAADM(PaAdm,"TRANS",AdmTranSub),6)
	s LocDesc = $p(^CTLOC(LocDr),"^",2)
	s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	q LocDesc
}

/// 获取留观室人数
ClassMethod ObsPatNum(Pid)
{
	n (Pid)
	s Ret=""
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Ward",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s AllNum=0
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Ward",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s AllNum = AllNum+1
	.s Data = PatWarDesc_"^"_AllNum
	.s:Ret'="" Ret=Ret_":"_Data
	.s:Ret="" Ret=Data
	q Ret
}

ClassMethod PatCheckLevNum(Pid)
{
	n (Pid)
	s NoCheckPatNum=0,RedAreaPatNum=0,YellowAreaPatNum=0,GreenAreaPatNum=0,OrangeAreaPatNum=0 //hxy 2020-02-21
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s PatCheckLevInfo = ##Class(web.DHCEMECheck).GetEmPatCheckLevGrade(EpisodeID)
	..s NurCheckLev = $p(PatCheckLevInfo,"^",2)
	..s:+NurCheckLev=0 NoCheckPatNum=NoCheckPatNum+1
	..i +NurCheckLev'=0 d
 	...;s:(NurCheckLev=1)!(NurCheckLev=2) RedAreaPatNum=RedAreaPatNum+1 //hxy 2020-02-21 st
 	...;s:(NurCheckLev=3) YellowAreaPatNum=YellowAreaPatNum+1
 	...;s:(NurCheckLev=4) GreenAreaPatNum=GreenAreaPatNum+1
 	...s NurCheckLev=+NurCheckLev
 	...s:(NurCheckLev=1) RedAreaPatNum=RedAreaPatNum+1
 	...s:(NurCheckLev=2) OrangeAreaPatNum=OrangeAreaPatNum+1
 	...s:(NurCheckLev=3) YellowAreaPatNum=YellowAreaPatNum+1
 	...s:(NurCheckLev=4)!(NurCheckLev=5) GreenAreaPatNum=GreenAreaPatNum+1 //ed
 	w "["
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","未分级^"_NoCheckPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","红区^"_RedAreaPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","橙区^"_OrangeAreaPatNum) //hxy 2020-02-21
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","黄区^"_YellowAreaPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","绿区^"_GreenAreaPatNum)
 	w "]"
	q ""
}

ClassMethod InLocPatNum(Pid)
{
	n (Pid)
	;w "["
	s Count=0
	s PatWarDesc ="",num=0
	f  s PatWarDesc = $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s WarDescNum = $g(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","Date",Pid,PatWarDesc)) 
	.q:+WarDescNum=0
	.s Count =Count+1
	.s num=num+WarDescNum
	.s Count =Count+1
	.;w $case(Count,1:"",:",")
	;W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("value",num)


	;.w $case(Count,1:"",:",")
	;.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",PatWarDesc_"^"_WarDescNum_"^")
	;w "]"
	q num
}

ClassMethod DisHospPatNum(Pid)
{
	n (Pid)
	b ;c12
	;w "["
	s Count=0
	s PatWarDesc ="",num=0
	f  s PatWarDesc = $o(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s WarDescNum = $g(^TMP("DHCEM","web.DHCEMDocPatIndex","GetObsAreaAnaData","DisHosp",Pid,PatWarDesc)) 
	.q:+WarDescNum=0
	.s num=num+WarDescNum
	.s Count =Count+1
	.;w $case(Count,1:"",:",")
	;W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("value",num)
	;w "]"
	q num
}

/// w ##class(web.DHCEMDocPatIndex).GetHtmlTable(2)
ClassMethod GetHtmlTable(HospID)
{
	n (HospID)
	s Ret=""
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s Ret = Ret_"<td>"
	.s Ret = Ret_"	<div class='tdDiv' data-type='ZSDO' style='background:url(../scripts/dhcnewpro/images/nosel.png)'>"
	.s Ret = Ret_"		<div class='floatLeft tdLeftDiv'>"
	.s Ret = Ret_"			<img src='../scripts/dhcnewpro/images/checkAllNum.png'/>"
	.s Ret = Ret_"		</div>"
	.s Ret = Ret_"		<div class='floatLeft tdRightDiv'>"
	.s Ret = Ret_"			<div class='tdRightDivTop'>"
	.s Ret = Ret_"				<span class='tdRightDivTopSpan'>"_WardDesc_"</span>"
	.s Ret = Ret_"			</div>"
	.s Ret = Ret_"			<div class='tdRightDivBottom'>"
	.s Ret = Ret_"				<span name='"_WardDesc_"' class='tdRightDivBottomSpan'>0</span>"
	.s Ret = Ret_"			</div>"
	.s Ret = Ret_"		</div>"
	.s Ret = Ret_"	</div>"
	.s Ret = Ret_"</td>"
	q Ret
}

/// Description: 获取某个就诊的下次就诊ID
/// Creator:     qqa
/// CreateDate:  2017-09-05
/// Input:  	 PaAdm
/// Return: 	 Adm
/// w ##class(web.DHCEMDocPatIndex).GetIsCheckLevPat("1461")
ClassMethod GetIsCheckLevPat(Adm)
{
	n (Adm)
	q:+Adm=0
	s repid=$I(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat")
	s PatDr = $p(^PAADM(Adm),"^",1)
	s AdmType=""
 	f  s AdmType = $o(^PAPERdr(PatDr,"ADM",AdmType)) q:AdmType=""  d
 	.s AdmDr = ""
 	.f  s AdmDr = $o(^PAPERdr(PatDr,"ADM",AdmType,AdmDr))  q:AdmDr=""  d
 	..s AdmDate = $p(^PAADM(AdmDr),"^",6)
 	..s AdmTime = $p(^PAADM(AdmDr),"^",7)
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime)=AdmDr
 	
 	s AdmDate="",EmAdm=""
 	f  s AdmDate = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate),-1) q:AdmDate=""  d
 	.s AdmTime=""
 	.f  s AdmTime = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime),-1) q:AdmTime=""  d
 	..s PaAdm = ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","date",AdmDate,AdmTime)
 	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","adm",PaAdm)=""
 	
 	s RetAdm = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStat","GetIsCheckLevPat","adm",Adm))
 	;q:+RetAdm=0 0
 	;s Ret = ($p(^PAADM(RetAdm),"^",2)="I")
 	q RetAdm
}

}
