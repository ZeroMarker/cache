Import sqluser

Class web.DHCEMEmeraPatient Extends %Persistent
{

/// Description: 急诊病人
/// Creator:     nisijia
/// CreateDate:  2016-11-16
/// Input:  	 开始、结束日期
/// w ##class(web.DHCEMEmeraPatient).GetDataInfo("67","600","222.132.155.197","","","","2016-12-01","2017-02-01","","","","","2","104")
ClassMethod GetDataInfo(LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %String, EndDate As %String, ArrivedQue As %String, RegQue As %String, isDiag As %String, LocHao As %String, HospID As %String, GropID As %String)
{

	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If UserID="" Set UserID=%session.Get("LOGON.USERID")
	If LocID="" Quit $$$OK
	If UserID="" Quit $$$OK
 	i StartDate="" s StartDate=+$h
 	i StartDate'="" s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate) //hxy 2017-03-02
	i EndDate=""  s EndDate=+$h
	i EndDate'="" s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate) //hxy 2017-03-02
 	Set DocId=$p($g(^SSU("SSUSR",UserID)),"^",14) //医生ID  
 	If $g(DocId)="" Quit $$$OK

	Set CurrentAdmType="E"
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=2
	Set Singleflag=0
	//非留观本科病人
	if (AllPatient="")&&(ArrivedQue="")&&(RegQue="") s RegQue="on"
	Set AllPatientFlag=1
	If RegQue="on"	Do 
	.d SetNoArrivePatList	  //统计已经未诊断的病人
	.d SetArrivePatList       //统计已经诊断的病人
	
	//留观室病人
	If AllPatient="on"	Do
	.Do StayInWard
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Kill ^TMP("DHCDocWorkBench",$j)
	
	//留观室本科病人
	If ArrivedQue="on"	Do 
	.Do StayInWardLoc
	.Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	..Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	...Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	...Set ind=ind+1 
	.Kill ^TMP("DHCDocWorkBench",$j)
	
	
	//按照领导安排，来个排序(唉，难受),排序
	Kill ^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo")
	s flag = 0    //flag用来确认是已经就诊还是未就诊
	s i=0
	f  s i=$o(^CacheTemp(repid,i)) q:i=""  d
	.s DataList=^CacheTemp(repid,i)
	.s PatTypeDesc=$p(DataList,"^",3)
	.s AdmDr = $p(DataList,"^",2)   //就诊id
	.s AdmDate = $p(DataList,"^",8)  //按照时间过滤
	.s PatCheckLev = $p(DataList,"^",29)  //护士分级,没有分级为0
	.s:PatCheckLev="" PatCheckLev="5" 
	.s:PatCheckLev="一级" PatCheckLev="1"
	.s:PatCheckLev="二级" PatCheckLev="2"
	.s:PatCheckLev="三级" PatCheckLev="3"
	.s:PatCheckLev="四级" PatCheckLev="4"
	.s:AdmDr="" AdmDr="0"
	.s:AdmDate="" AdmDate="0"
	.i +AdmDate="0" d
	..s flag =flag+1   
	..s ^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo",repid,flag,AdmDate,PatCheckLev,AdmDr)=DataList //存未就诊已就诊最上面那条特殊数据
	.i +AdmDate'="0" d
	..s ^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo",repid,flag,AdmDate,PatCheckLev,AdmDr)=DataList  //临时globle排序
	//开始输出json数据
	s (num,i)=0
	w "{""rows"":["
	s StrList = "PatientID^EpisodeID^mradm^PAPMINO^PAPMIName^PAPMIDOB^PAPMISex^PAAdmDate^PAAdmTime^PAAdmNo^PAAdmDepCodeDR^PAAdmDocCodeDR^PAAdmType^Hospital^PAAdmWard^PAAdmBed^FinancialDischargeFlag^MedicalDischargeFlag^FinalDischargeFlag^PAAdmReason^DischargeDate^RegDoctor^Diagnosis^ArrivedDate^ArrivedTime^LeavedDate^LeavedTime^LocSeqNo^PAAdmPriority^WalkStatus^ConsultRoom^ConsultArea^PAAdmReasonCode^StatusCode^PAPMIAge^PriorityCode^Called^RegDocDr^TPoliticalLevel^TSecretLevel^RegRangeTime^persName^StatusName^ArriveCount^NoArriveCount^EmPCLvID^Num"
	s DataList=""
	s flag=""
	f  s flag=$o(^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo",repid,flag)) q:flag=""  d
	.s AdmDate=""
	.f  s AdmDate=$o(^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo",repid,flag,AdmDate)) q:AdmDate=""  d
	..s PatCheckLev=""
	..f  s PatCheckLev=$o(^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo",repid,flag,AdmDate,PatCheckLev)) q:PatCheckLev=""  d
	...s AdmDr=""
	...f  s AdmDr=$o(^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo",repid,flag,AdmDate,PatCheckLev,AdmDr)) q:AdmDr=""  d
	....s num=num+1
	....s DataList=^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo",repid,flag,AdmDate,PatCheckLev,AdmDr)
	....i (num=1) d
	.....W ##class(web.DHCAPPJsonCommon).getJsonData(StrList,DataList_"^"_num)
	....else  d
	.....w ","
	.....w ##class(web.DHCAPPJsonCommon).getJsonData(StrList,DataList_"^"_num)
	w "],""total"":"_num_"}"
	
	Kill ^TMP("DHCEM","web.DHCEMEmeraPatient","GetDataInfo")
	Kill ^TMP("DHCDocWorkBench",$j)
	Kill ^CacheTemp(repid)
	Quit ""
	//
OutputRow
	Do ResetVariables
	s (StatusCode,PriorityCode,Called)=""
	s persStr = ..GetPatientState(PAAdm)   
	q:persStr=","    //
	s persDr = $p(persStr,",",1)     //NSJ  2016-11-17
	s persName = $p(persStr,",",2)   //NSJ  2016-11-17   //状态
	Set PatientID=$P(^PAADM(PAAdm),"^",1)
	Set EpisodeID=PAAdm
	Set mradm=$P(^PAADM(PAAdm),"^",61)
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Q:(PatientNo'="")&(PAPMINO'=PatientNo)               //QQA 过滤登记号
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set PAPMIDOB=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P(^PAPER(PatientID,"ALL"),"^",6)) //hxy $ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	//
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s TPoliticalLevel=$p(PatEncryptLevel,"^",2)
		s TSecretLevel=$p(PatEncryptLevel,"^",1)
	}
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Set PAPMIDOB="",PAPMIAge=""
	s PAPMIAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(PAAdm)
	
	Set PAAdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
	Set PAAdmTime=$ZT($P($g(^PAADM(PAAdm)),"^",7),1)
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdm)),"^",4)
	Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdm)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(PAAdm)),"^",70)
	if WardDr'="" Set PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set FinancialDischargeFlag=$P($g(^PAADM(PAAdm)),"^",45)
	Set MedicalDischargeFlag=$P($g(^PAADM(PAAdm)),"^",63)
	Set PAAdmStatus=$P($g(^PAADM(PAAdm)),"^",20)
	Set FinalDischargeFlag=$S($g(PAAdmStatus)="D":"Y",1:"N")
	Set AdmReason=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdm)),"^",17)
	If mradm'="" Set Diagnosis=##class(web.DHCDocEmergencyPatientList).GetMRAdmDiagnosis(mradm) 
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	//----zhaolj update 2006-10-19
	set RegId=0
	&SQL(SELECT ID into :RegId FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:PAAdm)
	if +RegId'=0 d
	.set LocSeqNo=$list(^User.DHCRegistrationFeeD(RegId),8)
	.set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegId),21)
	.i $g(RegRangeTimeDr)'="" set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
	//----
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2) //获取到达
	
	
	If QueRowId'="" Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	.Set StatusName=QueObj.QueStateDr.PersName   //状态2
	//*分级显示*
	Set Priority=$P($g(^PAADM(PAAdm)),"^",33)
	s EmRegDate=""
	s EmRegTime=""
	s EmRegID=""
	f  s EmRegID=$o(^DOCEMREG("EM",EmRegID)) q:EmRegID=""  d
    .s EmRegDate=$p(^DOCEMREG("EM",EmRegID),"^",4)  /// 登记日期
    .s EmRegTime=$p(^DOCEMREG("EM",EmRegID),"^",7)
    s AdmDate=$p(^PAADM(PAAdm),"^",6)
    s AdmTime=$p(^PAADM(PAAdm),"^",7)
	s papmidr=$p(^PAADM(PAAdm),"^",1)
	s EmPCLvID="" 
    Set PAAdmPriority=""
	&sql(select PCL_RowID into :EmPCLvID from DHC_EmPatCheckLev where PCL_Adm_Dr=:PAAdm)
	s:EmPCLvID="" EmPCLvID =##Class(web.DHCEMPatCheckLevCom).GetPatLevIdByAdm(PAAdm,$p(^PAADM(PAAdm),"^",1),HospID,LocID,UserID,GropID)
	i EmPCLvID'=""  d
	.s PAAdmPriority=$p($g(^DHCEMPCL(EmPCLvID)),"^",7)   /// 护士分级
	.s PAAdmPriority=..GetNurCheckDesc(PAAdmPriority)
	//上面是加的
	If QueRowId'="" Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	.Set Doc=QueObj.QueDocDr
	.set StatusName=QueObj.QueStateDr.PersName  //状态2
	
	.Set RegDocCode=""                 
	.Set RegDocDr=QueObj.QueMarkDr.%Id()
	.If RegDocDr'="" Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2),RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)   //号别
	.Else  Set RegDoctor=""
	.Do QueObj.%Close()
	Else  Do
	.Set StatusCode="XX"
	.Set PriorityCode="XX"
	.Set SeqNo="999"
	.Set RegDocCode=""
	.Set Called=""
	.Set RegDocDr=""
	//
	Set Count=Count+1
	q:(isDiag'="")&(isDiag="N")&(WalkStatus="到达")		//NSJ  2016-11-17  待诊
	q:(isDiag'="")&(isDiag="Y")&(WalkStatus'="到达")    //NSJ  2016-11-17  已诊
	
	s Locflag=0								//取出号别,过滤号别  
	i LocHao'="" d
	.s len=$L(LocHao,"$c(1)")
	.f i=1:1:len d
	..S TmpStr=$p(LocHao,"$c(1)",i)
	..S:TmpStr=RegDocDr Locflag=1 
	q:(LocHao'="")&(Locflag=0)

	Set:RegQue="on" NoArriveCount=NoArriveCount+1   //未就诊	
	Set:RegQue="on" ArriveCount=ArriveCount+1      	//已经就诊    
	Set Seq=$G(RegDocCode)_$G(SortCalled)_$G(PriorityCode)_$G(StatusCode)_$G(RegRangeTimeDr)_$G(SeqNo)
	
 	Set Data = PatientID_"^"_EpisodeID_"^"_mradm_"^"_PAPMINO_"^"_PAPMIName_"^"_PAPMIDOB_"^"_PAPMISex_"^"_PAAdmDate_"^"_PAAdmTime_"^"_PAAdmNo_"^"_PAAdmDepCodeDR_"^"_PAAdmDocCodeDR_"^"_PAAdmType_"^"_Hospital_"^"_PAAdmWard_"^"_PAAdmBed_"^"_FinancialDischargeFlag_"^"_MedicalDischargeFlag_"^"_FinalDischargeFlag_"^"_PAAdmReason_"^"_DischargeDate_"^"_RegDoctor_"^"_Diagnosis_"^"_ArrivedDate_"^"_ArrivedTime_"^"_LeavedDate_"^"_LeavedTime_"^"_LocSeqNo_"^"_PAAdmPriority_"^"_WalkStatus_"^"_ConsultRoom_"^"_ConsultArea_"^"_PAAdmReasonCode_"^"_StatusCode_"^"_PAPMIAge_"^"_PriorityCode_"^"_Called_"^"_RegDocDr_"^"_TPoliticalLevel_"^"_TSecretLevel_"^"_RegRangeTime_"^"_persName_"^"_StatusName_"^"_$g(ArriveCount)_"^"_$g(NoArriveCount)_"^"_EmPCLvID //号别
	
 	Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
 	
	Quit
ResetVariables

	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis,RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,TPoliticalLevel,TSecretLevel,RegRangeTime)=""
	Quit
NotStayInWard
	If StartDate="" Set FromDate=+$H-1,Time=$P($H,",",2)
	Else  Set FromDate=StartDate,Time=0
	If EndDate="" Set ToDate=+$H
	Else  Set ToDate=EndDate
	If FromDate>ToDate Quit
	//	
	s NoArriveCount=0
	For Date=FromDate:1:ToDate Do
	.For  Set Time=$O(^PAADMi("CurrLoc",LocID,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("CurrLoc",LocID,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	...if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	...s StateDesc=""
	...if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	...Q:StateDesc="报到"
	
	...//医生号别对照
	...Set QueMarkId=$List(^User.DHCQueueD(QueRowId),8)
	...Set Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	...Quit:Include=""
	
	...Set PatPMI=$P($g(^PAADM(PAAdm)),"^",1)
	...Set PatAdmWard=$P($g(^PAADM(PAAdm)),"^",70)
	...Quit:PatPMI=""
	...Quit:(PatAdmWard'="")
	...Set CurStat=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	...If CurStat'="" Set CurStat=$P(CurStat,"^",1)
	...Quit:($G(CurStat)'="")&(AllPatientFlag=0)
	...//Set DeptAdmArry(PatPMI)=PAAdm
	...;到达病人不显示
	...Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	...If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...Quit:WalkStatus="到达"
	...Do OutputRow
	.Set Time=0 
	Quit
StayInWard
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.Quit:LocEmerType'="EM"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.//Quit:EmerWard=""
		.If WardStr="" Set WardStr=EmerWard
		.Else  Set WardStr=WardStr_$C(1)_EmerWard
	If WardStr'="" DO
		.Set WardLst=$L(WardStr,$C(1))
		.For I=1:1:WardLst Do
		..Set WardItem=$P(WardStr,$C(1),I)
		..Do WardPatList
	Quit
StayInWardLoc
	Set WardStr=""
	Set LocLink=""
	For  Set LocLink=$O(^CTLOC(LocID,"LINK",LocLink)) Quit:LocLink=""  Do
		.Set LocItem=$P($G(^CTLOC(LocID,"LINK",LocLink)),"^",1)
		.Set LocEmerType=$P($G(^CTLOC(LocItem)),"^",13)
		.Quit:LocEmerType'="EM"
		.Set EmerWard=$O(^PAWARD(0,"WARD_LocationDR",LocItem,""))
		.Quit:EmerWard=""
		.If WardStr="" Set WardStr=EmerWard
		.Else  Set WardStr=WardStr_$C(1)_EmerWard
	If WardStr'="" DO
		.Set WardLst=$L(WardStr,$C(1))
		.For I=1:1:WardLst Do
		..Set WardItem=$P(WardStr,$C(1),I)
		..Do WLDPatList
	Quit
OutPAPMI
	//
	If StartDate="" Set FromDate=+$H-6
	Else  Set FromDate=StartDate
	If EndDate="" Set ToDate=+$H
	Else  Set ToDate=EndDate
	If FromDate>ToDate Quit
	Set AdmStr=##class(web.DHCDocEmergencyPatientList).GetEmergencyEpisode(PAPMI,FromDate,ToDate)  //就诊ID串
	Set LstCnt=$L(AdmStr,"^")
	For I=1:1:LstCnt Do
	.Set PAAdm=$P(AdmStr,"^",I)
	.Quit:PAAdm=""
	.Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)  //队列的Id
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14) 
	.s StateDesc=""
	.if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	.Q:StateDesc="报到"
	.Do OutputRow
	Quit
DeptPatList
	Quit:DeptItem=""
	If StartDate'="" Set Date=StartDate-1
	Else  Set Date=""
	
	For  Set Date=$O(^PAADMi("CurrLoc",DeptItem,Date)) Quit:(Date="")!(Date>EndDate)  Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("CurrLoc",DeptItem,Date,Time)) Quit:(Time="")  Do
	..Set PAAdm=""
	..For  Set PAAdm=$O(^PAADMi("CurrLoc",DeptItem,Date,Time,PAAdm)) Quit:(PAAdm="")  Do
	...Set PatPMI=$P($g(^PAADM(PAAdm)),"^",1)
	...Set PatAdmWard=$P($g(^PAADM(PAAdm)),"^",70)
	...Quit:PatPMI=""
	...Quit:(PatAdmWard="")&(ArrivedQue="on")
	...Quit:(PatAdmWard'="")&(RegQue="on")
	...Do OutputRow
	
	Quit
WLDPatList
	Quit:WardItem=""
	Set RoomDr=0
	For RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	..if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	..s StateDesc=""
	..if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	..Q:StateDesc="报到"
	..Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	..Quit:(PatLoc'=LocID)
	..//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.s StateDesc=""
	.if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	.Q:StateDesc="报到"
	.Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	.Quit:(PatLoc'=LocID)
	.//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	.Do OutputRow
	Quit
	//
WardPatList
	Set RoomDr=0
	For RoomDr=$O(^PAADMi("CurrWard",WardItem,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",WardItem,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	..if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	..s StateDesc=""
	..if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	..Q:StateDesc="报到"
	..//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	..Do OutputRow
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(WardItem,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(WardItem,"WADM",AdmItm),"^",1)
	.Set QueRowId=##class(web.DHCDocOutPatientList).GetQueRowidByMore(PAAdm,DocId)
	.if QueRowId'="" Set QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.s StateDesc=""
	.if QueStateDr'="" Set StateDesc=$List(^User.DHCPerStateD(QueStateDr),4)
	.Q:StateDesc="报到"
	.//Quit:..CheckAdm24Hour(PAAdm,StartDate,EndDate)
	.Do OutputRow
	Quit
SetDefaultPara
	If (StartDate="")&(%request.Get("WIPDateFromToday")="on") Set StartDate=+$H
	If (StartDate="")&(%request.Get("WIPDtFromOffset")'="") Set StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(%request.Get("WIPDtFromOffset")) //hxy $ZDH(%request.Get("WIPDtFromOffset"),5)
	//
	If (EndDate="")&(%request.Get("WIPDateToToday")="on") Set EndDate=+$H
	If (EndDate="")&(%request.Get("WIPDtToOffset")'="") Set EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(%request.Get("WIPDtToOffset")) //hxy $ZDH(%request.Get("WIPDtToOffset"),5)
	//
	If $g(CurrentDept)="" Do
	.Set LocStr=%request.Get("WIPLocList")
	.Set Loclen=$L(LocStr,$C(1))
	.For I=1:1:Loclen Do
	..If CurrentDept="" Set CurrentDept=$P($P(LocStr,$C(1),I),$C(2),3)
	..Else  Set CurrentDept=CurrentDept_$C(1)_$P($P(LocStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentDoctor)="" Do
	.Set DocStr=%request.Get("WIPCPList")
	.Set Doclen=$L(DocStr,$C(1))
	.For I=1:1:Doclen Do
	..Set DoctCode=$P($P(DocStr,$C(1),I),$C(2),1)
	..Quit:DoctCode=""
	..Set DocRowId=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(DoctCode),""))
	..Quit:DocRowId=""
	..If CurrentDoctor="" Set CurrentDoctor=DocRowId
	..Else  Set CurrentDoctor=CurrentDoctor_$C(1)_DocRowId
	//
	If $g(CurrentWard)="" Do
	.Set WardStr=%request.Get("WIPWardList")
	.Set Wardlen=$L(WardStr,$C(1))
	.For I=1:1:Wardlen Do
	..If CurrentWard="" Set CurrentWard=$P($P(WardStr,$C(1),I),$C(2),3)
	..Else  Set CurrentWard=CurrentWard_$C(1)_$P($P(WardStr,$C(1),I),$C(2),3)
	//
	If $g(CurrentAdmType)="" Do
	.Set AdmStr=%request.Get("WIPEpisodeTypeList")
	.If $L(AdmStr)>0 Set CurrentAdmType=$E(AdmStr,1)
	Quit
SetDefaultDate
	if StartDate="" Set StartDate=+$H-6
	If EndDate="" Set EndDate=+$H
	Quit
OutOPArrived
	s ArriveCount=0
	If StartDate="" Set StartDate=+$H
	If EndDate="" Set EndDate=+$H
	For Date=StartDate:1:EndDate Do
	.Set Time=""
	.For  Set Time=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time),-1) Quit:Time=""  Do
	..Set PAAdm=0
	..For  Set PAAdm=$O(^PAADMi("AdmTypeCurrLoc","E",LocID,Date,Time,PAAdm)) Quit:PAAdm=""  Do
	...Set AdmDoctor=$P($g(^PAADM(PAAdm)),"^",9)
	...Set AdmSeenDate=$P($g(^PAADM(PAAdm),1),"^",10)
	...Set AdmSeenTime=$P($g(^PAADM(PAAdm),1),"^",11)
	...Set WalkStatus=##Class(web.DHCADMVisitStat).GetPatCurStat(PAAdm)
	...If WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)  //到达
	...Set PatQueState=""
	...Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdm,""))
	...If QueRowId'="" Do
	....Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	....Set StatusName=QueObj.QueStateDr.PersName   //状态2
	....Set QueDocId=QueObj.QueDocDrGetObjectId()
	....Set QueMarkId=QueObj.QueMarkDrGetObjectId()
	....Set Include=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocId,QueMarkId,""))
	....Quit:Include=""
	....Quit:(QueDocId'=DocId)
	....If WalkStatus["到达" Set PatQueState="A"

	....Do QueObj.%Close()
	...Quit:(PatQueState="")
	...;w "aaa,"_PatQueState,!
	...Do OutputRow
	...;Set ArriveCount=ArriveCount+1    //在outPutRow中过滤

	Quit

SetArrivePatList
    s (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,persName,StatusName,ArriveCount,NoArriveCount)=""
	s PAPMINO="已诊:"
	s ArriveFlagRowInd=ind
	;Set ^CacheTemp(repid,ind)=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,persName,StatusName)   //NSJ 2016-11-18
 	Set ^CacheTemp(repid,ind)=PatientID_"^"_EpisodeID_"^"_mradm_"^"_PAPMINO_"^"_PAPMIName_"^"_PAPMIDOB_"^"_PAPMISex_"^"_PAAdmDate_"^"_PAAdmTime_"^"_PAAdmNo_"^"_PAAdmDepCodeDR_"^"_PAAdmDocCodeDR_"^"_PAAdmType_"^"_Hospital_"^"_PAAdmWard_"^"_PAAdmBed_"^"_FinancialDischargeFlag_"^"_MedicalDischargeFlag_"^"_FinalDischargeFlag_"^"_PAAdmReason_"^"_DischargeDate_"^"_RegDoctor_"^"_Diagnosis_"^"_ArrivedDate_"^"_ArrivedTime_"^"_LeavedDate_"^"_LeavedTime_"^"_LocSeqNo_"^"_PAAdmPriority_"^"_WalkStatus_"^"_ConsultRoom_"^"_ConsultArea_"^"_PAAdmReasonCode_"^"_StatusCode_"^"_PAPMIAge_"^"_PriorityCode_"^"_Called_"^"_RegDocDr_"^"_TPoliticalLevel_"^"_TSecretLevel_"^"_RegRangeTime_"^"_persName_"^"_StatusName_"^"_ArriveCount_"^"_NoArriveCount_"^"

 	set ind=ind+1
	Do OutOPArrived
	
	
	Set $p(^CacheTemp(repid,ArriveFlagRowInd),"^",4)=$p(^CacheTemp(repid,ArriveFlagRowInd),"^",4)_ArriveCount_"人"
	Set $p(^CacheTemp(repid,ArriveFlagRowInd),"^",5)=ArriveCount
	Set $p(^CacheTemp(repid,ArriveFlagRowInd),"^",30)="已诊:"
	i isDiag="N" k ^CacheTemp(repid,ArriveFlagRowInd)
	i ArriveCount="0" k ^CacheTemp(repid,ArriveFlagRowInd)
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	quit
SetNoArrivePatList
	s (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr,TPoliticalLevel,TSecretLevel,RegRangeTime,persName,StatusName,ArriveCount,NoArriveCount)=""
	s PAPMINO="未诊:"
	s NoArriveFlagRowInd=ind
	Set ^CacheTemp(repid,ind)=PatientID_"^"_EpisodeID_"^"_mradm_"^"_PAPMINO_"^"_PAPMIName_"^"_PAPMIDOB_"^"_PAPMISex_"^"_PAAdmDate_"^"_PAAdmTime_"^"_PAAdmNo_"^"_PAAdmDepCodeDR_"^"_PAAdmDocCodeDR_"^"_PAAdmType_"^"_Hospital_"^"_PAAdmWard_"^"_PAAdmBed_"^"_FinancialDischargeFlag_"^"_MedicalDischargeFlag_"^"_FinalDischargeFlag_"^"_PAAdmReason_"^"_DischargeDate_"^"_RegDoctor_"^"_Diagnosis_"^"_ArrivedDate_"^"_ArrivedTime_"^"_LeavedDate_"^"_LeavedTime_"^"_LocSeqNo_"^"_PAAdmPriority_"^"_WalkStatus_"^"_ConsultRoom_"^"_ConsultArea_"^"_PAAdmReasonCode_"^"_StatusCode_"^"_PAPMIAge_"^"_PriorityCode_"^"_Called_"^"_RegDocDr_"^"_TPoliticalLevel_"^"_TSecretLevel_"^"_RegRangeTime_"^"_persName_"^"_StatusName_"^"_ArriveCount_"^"_NoArriveCount_"^"

	set ind=ind+1
	Do NotStayInWard     //统计未就诊的病人
	
	Set $p(^CacheTemp(repid,NoArriveFlagRowInd),"^",4)="未诊"_NoArriveCount_"人"
	set $p(^CacheTemp(repid,NoArriveFlagRowInd),"^",5)=NoArriveCount
	Set $p(^CacheTemp(repid,NoArriveFlagRowInd),"^",30)="未诊"

	i (isDiag="Y") k ^CacheTemp(repid,NoArriveFlagRowInd)
	i NoArriveCount="0" k ^CacheTemp(repid,NoArriveFlagRowInd)
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)   
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	quit
}

/// Description: 急诊病人
/// Creator:     nisijia
/// CreateDate:  2016-11-16
/// Input:  	 开始、结束日期
/// 查找病人状态
ClassMethod GetPatientState(PaAdmDr As %String)
{
	S ID=""
	S (QueStateDr,PersName)=""
	s count=""
	f  s ID=$o(^User.DHCQueueI("QuePaadmDrIndex",PaAdmDr,ID)) q:ID=""  d
	.s QueStateDr=$l(^User.DHCQueueD(ID),14)
	.s PersName=$lg(^User.DHCPerStateD(QueStateDr),4)
	q QueStateDr_","_PersName
}

/// Description: 急诊病人 获取号别
/// Creator:     倪思佳
/// CreateDate:  2016-11-21
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCEMEmeraPatient).GetPatientHao("")
ClassMethod GetPatientHao() As %String
{
	
	w "["
		w ##class(web.DHCAPPJsonCommon).getJsonData("id^text","1468^外科急诊号")
		W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","876^内科急诊号")
	w "]"
	q ""
}

ClassMethod GetPatientxing() As %String
{
	
	w "["
		w ##class(web.DHCAPPJsonCommon).getJsonData("id^text","1468^外科急诊号")
		W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","876^内科急诊号")
	w "]"
	q ""
}

ClassMethod getEmeNumInfo()
{
	s result = ##class(%Library.ResultSet).%New()
	s LocStr = ##Class(web.DHCEMRegister).textGetEmPatLoc("")
	s sqlStr = "SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR FROM SQLUser.RB_RESOURCE WHERE RES_CTLOC_DR in ("_LocStr_") And (res_schedulerequired='Yes' or res_schedulerequired='Y')"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("RES_CTPCP_DR")
		s Desc = result.Data("CTPCP_Desc")
		Continue:$d(^SSU("SSUSR",0,"CTPCP",ID))
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	}
	w "]"
	q ""
}

ClassMethod GetPatInfoByCardOrRegNo(CardNo As %String = "", RegNo As %String = "")
{
	s PatInfo=""
	if (CardNo'=""){
		s ind=$O(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
		q:+ind="0" "-10"
		q:'$d(^DHCCARD("CF",ind)) "-10"         				//没有卡信息
		q:$p($g(^DHCCARD("CF",ind)),"^",10)'="N" "-11" 		    //卡没有启用
		s PatDr=$p($g(^DHCCARD("CF",ind)),"^",4)                //通过卡号取出病人ID
		s PatInfo=##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr)
		q PatInfo
	}
	
	if (RegNo'=""){
		s patConfig=##class(web.DHCCLCom).GetPatConfig()  //系统配置，登记号长度
		s RegNoLong=$p(patConfig,"^")  
		q:$l(RegNo)>RegNoLong "-13"                        //登记号长度错误
		s nvar=""
		s ln=$L(RegNo)
		s le=RegNoLong+1-ln  							  //11-$L(RegNo)
		s $P(nvar,"0",le)=RegNo
		s nvar=$$ALPHAUP^SSUTIL4(nvar)
		s RegNo=nvar
		s PatDr=""
		s PatDr=$O(^PAPERi("PAPMI_PatNo",nvar,PatDr),-1)
		q:+PatDr="0" "-14"								  //未找到病人信息
		s PatInfo=##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr)
		q PatInfo
	}
	q ""
}

/// Creator:      qiaoqingao
/// Description:  根据用户ID和登录科室ID获取用户所对应的号别
/// Input:		  UserID用户ID,LocID科室ID         
/// Return:       返回MarkDocDesc_"^"_MarkDocID 对应号别的描述和ID
/// w ##class(web.DHCEMEmeraPatient).FindDocMarkStr(600,63)
ClassMethod FindDocMarkStr(UserID As %String, LocID As %String) As %String
{
	Q:((UserID="")||(LocID="")) ""
	s DocID=$P(^SSU("SSUSR",UserID),"^",14)
	Q:DocID="" ""
	s Ret=""
	s DHCMarkRowID=0 
	f  s DHCMarkRowID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID))  Q:DHCMarkRowID=""  d
	.s FindFlag=0
	.s ID="" f  s ID=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",DocID,DHCMarkRowID,ID)) Q:(ID="")||(FindFlag=1)  d
	..s MarkDepId=$list(^User.DHCMarkDocD(ID),4)
	..i MarkDepId=LocID s FindFlag=1
	.Q:FindFlag=0
	.s ResRowID=$O(^RB("RES",0,"CTPCP",DHCMarkRowID,LocID,0))
	.Q:ResRowID=""
	.s ScheSt=$p(^RB("RES",ResRowID),"^",6)
	.Q:ScheSt'="Y"
	.s MarkDesc=$p($g(^CTPCP(DHCMarkRowID,1)),"^",2)
	
	.if Ret=""  s Ret=DHCMarkRowID_"^"_MarkDesc
	.else  s Ret=Ret_"!"_DHCMarkRowID_"^"_MarkDesc
	Q Ret
}

/// Description: 获取护士分级描述
/// Creator:     QQA
/// CreateDate:  2017-03-17
/// Input:  	 1级、2级
/// w ##class(web.DHCEMEmeraPatient).GetNurCheckDesc(1)
ClassMethod GetNurCheckDesc(NurCheck)
{
	q:NurCheck="" ""
	s NurCheck=NurCheck_"级"	
	s EmLvID=$o(^CT("ACU",0,"Code",$$ALPHAUP^SSUTIL4(NurCheck),""))
	Q:EmLvID="" NurCheck
	s NurCheckDesc=NurCheck_"("
	s NurCheckDesc = NurCheckDesc_$p(^CT("ACU",EmLvID),"^",2)
	s NurCheckDesc = NurCheckDesc_")"
	q NurCheckDesc
	//$s(PAAdmPriority=1:"1级",PAAdmPriority=2:"2级",PAAdmPriority=3:"3级",PAAdmPriority=4:"4级",1:"")
}

Storage Default
{
<Data name="DHCEMEmeraPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMEmeraPatientD</DataLocation>
<DefaultData>DHCEMEmeraPatientDefaultData</DefaultData>
<IdLocation>^web.DHCEMEmeraPatientD</IdLocation>
<IndexLocation>^web.DHCEMEmeraPatientI</IndexLocation>
<StreamLocation>^web.DHCEMEmeraPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
