Class web.DHCEMKeptPatAna Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 当前床位使用情况.
/// w ##class(web.DHCEMKeptPatAna).JsonBedTable(2)
ClassMethod JsonBedTable(HospID)
{
	n (HospID,%session)
	s Pid = ##Class(web.DHCEMInterfaceCom).NewPid()
	k ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid)
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s WardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",WardDesc) //hxy 2022-12-14
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s AllBedNum=0,HasPatNum=0
	.s BedSub=0
	.f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	..q:$p(^PAWARD(WardID,"BED",BedSub),"^",4)'="Y" //hxy 2020-04-13 st
	..s BedStDate = $p(^PAWARD(WardID,"BED",BedSub),"^",21) 
	..s BedEndDate = $p(^PAWARD(WardID,"BED",BedSub),"^",22)
	..q:(BedStDate'="")&&(BedStDate>+$h)
	..q:(BedEndDate'="")&&(BedEndDate<+$h) 
	..q:($p($g(^PAWARD(WardID,"BED",BedSub)),"^",18)="") //没维护宽度 //ed
	..s AllBedNum=AllBedNum+1
	..s BedAdmSub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	..i BedAdmSub'="" d
	...s HasPatNum=HasPatNum+1
	...s PaAdm = $p(^PAWARDA(WardID,"BED",BedSub,"ADM",BedAdmSub),"^",1)
	...q:'$d(^PAADM(PaAdm))
	...s ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid,"ADM",WardDesc,PaAdm)=""   // 记录下每个留观室下面正在留观的Adm
	.s ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid,"WardDesc",WardDesc) = HasPatNum_"/"_AllBedNum
	b ;data
	W ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	s Count=0,Del=""""
	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("field1^field2",##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","病区")_"^"_##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","床位使用率")) //"病区^床位使用率") hxy 2022-12-14
	s Count=Count+1
	s WardDesc="" 
	f  s WardDesc = $o(^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid,"WardDesc",WardDesc)) q:WardDesc=""  d
	.s Data = WardDesc_"^"_^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid,"WardDesc",WardDesc)
	.w ","
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("field1^field2",Data)
	.s Count=Count+1
	w "],"
	w Del_"total"_Del_":"_Count_","
	w Del_"imgData"_Del_":"
	d ##class(web.DHCEMKeptPatAna).GetTableImg(Pid,"")  //界面图像数据
	w "}"
	
	k ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid)
	
	;W ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// w ##class(web.DHCEMKeptPatAna).GetTableImg("134466","")
ClassMethod GetTableImg(Pid, InWardDesc)
{
	n (Pid,InWardDesc,%session)
	s Del=""""
	s AllNum=0,IsCheckLevNum=0,NoCheckLevNum=0,ManNum=0,WoManNum=0,NoSexNum=0
	s WardDesc=""
	f  s WardDesc = $o(^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid,"ADM",WardDesc)) q:WardDesc=""  d
	.q:(InWardDesc'="")&&(WardDesc'=InWardDesc)
	.s PaAdm="" 
	.f  s PaAdm  = $o(^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",Pid,"ADM",WardDesc,PaAdm)) q:PaAdm=""  d
	..s AllNum=AllNum+1   //所有数量
	..s PatCheckLevInfo = ##Class(web.DHCEMECheck).GetEmPatCheckLevGrade(PaAdm)
	..s PatCheckLev = $p(PatCheckLevInfo,"^",2)
	..s:PatCheckLev="" PatCheckLev = +PatCheckLevInfo
	..s:+PatCheckLev'=0 IsCheckLevNum=IsCheckLevNum+1
	..s:+PatCheckLev=0 NoCheckLevNum=NoCheckLevNum+1
	..;s:+PatCheckLevInfo=0 ^qqa("3344") =$g(^qqa("3344"))_"^"_PaAdm
	..s PatientID = $p(^PAADM(PaAdm),"^",1)
	..s SexDesc=""
	..s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 性别
	..i SexId'="" s SexDesc=$p(^CT("SEX",SexId),"^",2)
	..;w SexDesc,!
	..s:SexDesc["男" ManNum=ManNum+1
	..s:SexDesc["女" WoManNum=WoManNum+1
	..s:SexDesc["未" NoSexNum=NoSexNum+1
	
	s YLev=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","已分级") //hxy 2022-12-14 st
	s NLev=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","未分级")
	s Lev=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","预检分级")
	s Man=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","男")
	s Wom=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","女")
	s UnK=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","未知")
	s Sex=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","性别") //ed

	w "{"
	w Del_"DataCheck"_Del_":"
	w "["
	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",YLev_"^"_+IsCheckLevNum_"^"_Lev) //"已分级^"_+IsCheckLevNum_"^预检分级")
	w ","
	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",NLev_"^"_+NoCheckLevNum_"^"_Lev) //"未分级^"_+NoCheckLevNum_"^预检分级")
	w "]"
	w ","
	w Del_"DataSex"_Del_":"
	w "["
	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",Man_"^"_+ManNum_"^"_Sex) //"男^"_+ManNum_"^性别")
	w ","
	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",Wom_"^"_+WoManNum_"^"_Sex) //"女^"_+WoManNum_"^性别")
	w ","
	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",UnK_"^"_+NoSexNum_"^"_Sex) //"未知^"_+NoSexNum_"^性别")
	w "]"
	w "}"
	q ""
}

/// w ##class(web.DHCEMKeptPatAna).GetObsAreaAnaData("2^06/01/2020^03/04/2020")
ClassMethod GetObsAreaAnaData(Params)
{
	n (Params,%session)
	s HospID = $p(Params,"^",1)
	s StDate = $p(Params,"^",2)
	s EndDate = $p(Params,"^",3)
	s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s Pid = ##Class(web.DHCEMInterfaceCom).NewPid() //hxy 2020-04-03
	k ^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid)
	f Date=StDate:1:EndDate  d 
  	.s Time=""
 	.f  s Time=$o(^PAADMi("TransDateTime",Date,Time))   Q:Time=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TransDateTime",Date,Time,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录:这个是在安排床位的时候插入的表格
 	...q:$p(^PAADM(EpisodeID),"^",2)'="E"
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)              //用来判断病人是否留观
 	...q:+PatWarDr=0                            			//为空代表没有留观
 	...s PatWarDesc = $p(^PAWARD(PatWarDr),"^",2)
 	...s PatWarDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWarDesc) //hxy 2022-12-14
 	...s:PatWarDesc["-" PatWarDesc = $p(PatWarDesc,"-",2)
	...s LocID = $p(^PAWARD(PatWarDr),"^",5)				//病区所所属的科室
	...s LocHospID = $p(^CTLOC(LocID),"^",22)
	...q:(HospID'="")&&(HospID'=LocHospID)                  //
	...Q:$p(^CTLOC(LocID),"^",13)'="EM"
    ...Q:'$o(^PAWARD(PatWarDr,"ROOM",0))
	...s ^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)=""    //获取时间段内办理留观的就诊
	...;以上是用来获取历史进入留观室的人
	
	s WardID=0
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s PatWarDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s PatWarDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWarDesc) //hxy 2022-12-14
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
	...s HasPatNum=HasPatNum+1
	...s EpisodeID = $p(^PAWARDA(WardID,"BED",BedSub,"ADM",BedAdmSub),"^",1)
	...q:'$d(^PAADM(EpisodeID))
	...s ^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)=""  
	...;当前在留观室的病人
	.s ^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc) = HasPatNum
	b ;data
	s Del=""""
	w "{"
	w Del_"ObsPatNum"_Del_":"
	w Del_##class(web.DHCEMKeptPatAna).ObsPatNum(Pid)_Del
	w ","
	w Del_"QsPatNum"_Del_":"
	d ##class(web.DHCEMKeptPatAna).PatCheckLevNum(Pid)
	w ","
	w Del_"ParseInPatNum"_Del_":"
	d ##class(web.DHCEMKeptPatAna).ParseInPatNum(Pid)
	w ","
	w Del_"KeyDiseasePatNum"_Del_":"
	d ##class(web.DHCEMKeptPatAna).KeyDiseasePatNum(Pid)
	w ","
	w Del_"InLocPatNum"_Del_":"
	d ##class(web.DHCEMKeptPatAna).InLocPatNum(Pid)
	w "}"
	k ^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid)
	q ""
}

ClassMethod KeyDiseasePatNum(Pid)
{
	n (Pid,%session)
	
	s NPid = ##Class(web.DHCEMInterfaceCom).NewPid()
	
	s PatWarDesc=""
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
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
	.s SPDDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmSpecDise","SDIDesc","",SPDDesc) //hxy 2022-12-14
	.s Tmp = SPDDesc_"^"_TMPData(NPid,SPDDesc)
	.w $case(Count,0:"",Count:",")
	.s Count =Count+1
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",Tmp)
	w "]"
}

/// Descript:获取PAADM状态改变中包含转入院状态的PAADM
/// d ##class(web.DHCEMKeptPatAna).ParseInPatNum("139390")
ClassMethod ParseInPatNum(Pid)
{
	n (Pid,%session)
	s NewPid = ##Class(web.DHCEMInterfaceCom).NewPid()
	k ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable")
	s UnInPat=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","未入院") //hxy 2022-12-14
	s InPatWard=##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","入院病区") //hxy 2022-12-14
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s InWardDesc=""
	..s NextAdm = ##class(web.DHCEMPatCheckLevStat).GetNextAdm(EpisodeID)
	..s AdmType=""
	..s:NextAdm'="" AdmType= $p(^PAADM(NextAdm),"^",2)
	..s:AdmType'="I" InWardDesc=UnInPat //"未入院"
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
	...s InWardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",InWardDesc) //hxy 2022-12-14
	..s:InWardDesc="" InWardDesc=UnInPat //"未入院"
	..s:$d(^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid,InWardDesc)) ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid,InWardDesc)=^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid,InWardDesc)+1
	..s:'$d(^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid,InWardDesc)) ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid,InWardDesc)=1
	b ;data
	w "["
	s InWardDesc="",Count=0
	f  s InWardDesc = $o(^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid,InWardDesc)) q:InWardDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid,InWardDesc)
	.s Data  = InWardDesc_"^"_Num_"^"_InPatWard //"入院病区"
	.w $case(Count,0:"",Count:",")
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",Data)
	.s Count =Count+1
	w "]"
	k ^TMP("DHCEM","web.DHCEMKeptPatAna","JsonBedTable",NewPid)
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
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s AllNum=0
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s AllNum = AllNum+1
	.s Data = PatWarDesc_"^"_AllNum
	.s:Ret'="" Ret=Ret_":"_Data
	.s:Ret="" Ret=Data
	q Ret
}

ClassMethod PatCheckLevNum(Pid)
{
	n (Pid,%session)
	s NoCheckPatNum=0,RedAreaPatNum=0,YellowAreaPatNum=0,GreenAreaPatNum=0,OrangeAreaPatNum=0 //hxy 2020-02-21
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
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
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","未分级")_"^"_NoCheckPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","红区")_"^"_RedAreaPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","橙区")_"^"_OrangeAreaPatNum) //hxy 2020-02-21
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","黄区")_"^"_YellowAreaPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",##class(web.DHCEMCommonUtil).GetTrans("dhcem.keptpatana.csp","绿区")_"^"_GreenAreaPatNum)
 	w "]"
	q ""
}

ClassMethod InLocPatNum(Pid)
{
	n (Pid)
	w "["
	s Count=0
	s PatWarDesc =""
	f  s PatWarDesc = $o(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s WarDescNum = $g(^TMP("DHCEM","web.DHCEMKeptPatAna","GetObsAreaAnaData",Pid,PatWarDesc)) 
	.q:+WarDescNum=0
	.s Count =Count+1
	.w $case(Count,1:"",:",")
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",PatWarDesc_"^"_WarDescNum_"^")
	w "]"
	q ""
}

/// w ##class(web.DHCEMKeptPatAna).GetHtmlTable(2)
ClassMethod GetHtmlTable(HospID)
{
	n (HospID,%session)
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
 	.s WardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",WardDesc)
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
/// w ##class(web.DHCEMKeptPatAna).GetIsCheckLevPat("1461")
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
