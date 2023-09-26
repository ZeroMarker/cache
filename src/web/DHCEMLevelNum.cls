/// Descript:   各级分级病人统计
/// Creator:    huaxiaoying
/// CreateDate: 2017-07-19
Class web.DHCEMLevelNum Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID, HOSParams = "") As %Query(ROWSPEC = "Level:%String,Num:%String,nums:%Integer") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID, HOSParams = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","admNumQuery","2017-04-04","2017-08-04")
 	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (stDate="")||(edDate="" ) Quit $$$OK
	s IsVisit=$p(HOSParams,"^",1)
    set ind=1
	
  	//编码开始
  	
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
  	k ^TMP("DHCEM","web.DHCEMLevelNum","admNumQuery")  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))            ///QQA 2017-08-22 过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..q:+PCLNurseLevel=0
    ..s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-27
	..s PCARowID = $o(^DHCEMPCA(0,"PatCheckLev",PCLDr,""),-1) //hxy 2019-09-25 st
	..s EpisodeID="",AdmVisit="",IsWaitPat="",WalkStatus=""
	..s:PCARowID'="" EpisodeID = $p(^DHCEMPCA(PCARowID),"^",2)
	..s AdmVisit=$p(^PAADM(EpisodeID),"^",20)
	..s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)       /// 当前状态
	..i WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	..i WalkStatus="" s WalkStatus="等候"
	..s IsWaitPat = ((WalkStatus="等候")||(WalkStatus["复诊"))
	..q:(IsVisit'="")&&((AdmVisit'="A")||(IsWaitPat))
	..s ^TMP("DHCEM","web.DHCEMLevelNum","admNumQuery",repid,PCLNurseLevel,PatientID)=""	
	s PCLNurseLevel = 0
	f  s PCLNurseLevel = $o(^TMP("DHCEM","web.DHCEMLevelNum","admNumQuery",repid,PCLNurseLevel)) q:PCLNurseLevel=""  d
	.s PatientID="",num=0
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMLevelNum","admNumQuery",repid,PCLNurseLevel,PatientID)) q:PatientID=""  d
    ..s num=num+1
    .s nums = num
    .d OutputRow1
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(PCLNurseLevel,num,nums)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admNumQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admNumQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod admNumQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admNumtQueryExecute ]
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
	Quit $$$OK
}

Query admNumInfoQuery(stDate, edDate, checkLev, HOSPID) As %Query(ROWSPEC = "curregno:%String,name:%String,sexId:%String,age:%String,PatCardNo:%String,symptom:%String,PCSTemp:%String,PCSHeart:%String,PCSPCSPulse:%String,PCSBP:%String,PCSR:%String,EmRecLevel:%String,NurseLevel:%String,pclDate:%String,pclTime:%String") [ SqlProc ]
{
}

ClassMethod admNumInfoQueryExecute(ByRef qHandle As %Binary, stDate, edDate, checkLev, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","admNumInfoQuery","2017-01-04","2017-08-04","1")
	
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (stDate="")||(edDate="" ) Quit $$$OK
    set ind=1

  	//编码开始
  	;s:stDate="" stDate=+$h
  	;s:edDate="" edDate=+$h
  	i (stDate="")||(edDate="" ) Quit $$$OK
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	
  	k ^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery")  
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))            ///QQA 2017-08-22 过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLCreateDate=$p(^DHCEMPCL(PCLDr),"^",4)  ///分诊日期
    ..s PCLCreateTime=$p(^DHCEMPCL(PCLDr),"^",5)  ///分诊时间
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..s PCLNurseLevel=##class(web.DHCEMCommonUtil).LevFormat(PCLNurseLevel) //hxy 2020-02-27
    ..q:(PCLNurseLevel'=checkLev)&(checkLev'="")
    ..;q:(+PCLNurseLevel'=checkLev)&(checkLev'="") //ed
	..i $d(^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery",repid,PatientID)) d
	...s ^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery",repid,PatientID) = ^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery",repid,PatientID)_":"_PCLDr
	..e  d
	...s ^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery",repid,PatientID) = PCLDr
	
	.s PatientID=""
	.f  s PatientID = $o(^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery",repid,PatientID)) q:PatientID=""  d
    ..
    
    s PatDr=0
	f  s PatDr = $o(^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery",repid,PatDr)) q:PatDr=""  d
	.s PatInfo =##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr,HOSPID) //hxy 2020-06-11
	.s PclRowStr = ^TMP("DHCEM","web.DHCEMLevelNum","admNumInfoQuery",repid,PatDr)
	.s name = $p(PatInfo,"^",2)
	.s curregno = $p(PatInfo,"^",1)
	.s PatCardNo = $p(PatInfo,"^",12)
	.s sexId = $p(PatInfo,"^",3)
	.s age = $p(PatInfo,"^",4)
	.f i=1:1:$l(PclRowStr,":") d
	..s PclDr = $p(PclRowStr,":",i)
	..s pclData=##class(web.DHCEMRegister).getPatMessageByPclID(PclDr)
	..s pclDate = $p(pclData,"^",2)			//日期
	..s pclTime = $p(pclData,"^",3)			//时间
	..s symptom = $p(pclData,"^",4)			//症状
	..s PCSTemp = $p(pclData,"^",11)      	//预检生命体时间
	..s PCSHeart = $p(pclData,"^",12)		 	//心率HR
	..s PCSPCSPulse = $p(pclData,"^",13)	 	//脉搏R
	..s PCSBP = $p($p(pclData,"^",14),":",1)  //血压(BP)收缩压
	..s PCSR =$p($p(pclData,"^",14),":",2)    //呼吸频率
	..s EmRecLevel=$p(pclData,"^",15)      	//推荐分级
	..s NurseLevel=$p(pclData,"^",16)      	//护士分级
	..s EmRecLevel=$s(EmRecLevel=1:"1级",EmRecLevel=2:"2级",EmRecLevel=3:"3级",EmRecLevel=4:"4级",EmRecLevel=5:"5级",1:"") //hxy 2020-02-27 st
	..s NurseLevel=$s(NurseLevel=1:"1级",NurseLevel=2:"2级",NurseLevel=3:"3级",NurseLevel=4:"4级",NurseLevel=5:"5级",1:"")
	..s EmRecLevel=##class(web.DHCEMCommonUtil).LevFormat(EmRecLevel) 
	..s NurseLevel=##class(web.DHCEMCommonUtil).LevFormat(NurseLevel) //ed
    ..d OutputRow999
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow999
	s Data=$lb(curregno,name,sexId,age,PatCardNo,symptom,PCSTemp,PCSHeart,PCSPCSPulse,PCSBP,PCSR,EmRecLevel,NurseLevel,pclDate,pclTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admNumInfoQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admNumInfoQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod admNumInfoQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admNumtQueryExecute ]
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
	Quit $$$OK
}

/// 2022-06-24
/// w ##class(web.DHCEMLevelNum).PatAdmNum(66224,66331,2)
ClassMethod PatAdmNum(stDate, edDate, HOSPID)
{
	s ret=0
	f AdmDate=stDate:1:edDate  d 
  	.s AdmRowID=""
  	.f  s AdmRowID=$o(^PAADMi("AdmDateCurr",AdmDate,AdmRowID))  q:AdmRowID=""  d
  	..s AdmType=$p(^PAADM(AdmRowID),"^",2)
  	..q:AdmType'="E"
  	..s PatLocID=$p(^PAADM(AdmRowID),"^",4) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
  	..s ret=ret+1
	q ret
}

/// 急诊科医患比
Query docRatioQuery(stDate, edDate, emDocNumber = "", HOSPID) As %Query(ROWSPEC = "DocNum:%String,AdmNum:%Integer,Ratio:%String") [ SqlProc ]
{
}

ClassMethod docRatioQueryExecute(ByRef qHandle As %Binary, stDate, edDate, emDocNumber = "", HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","docRatioQuery","2022-08-01","2022-08-10","","2")
	;tro
	
	;s ^qqa("data")=$lb(stDate, edDate, emDocNumber, HOSPID)
	
    Set repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    set ind=1
    i (stDate="")||(edDate="") Quit $$$OK
	
  	//编码开始
  	s stDate= $zdh(stDate,3)
  	s edDate=$zdh(edDate,3)
  	
  	s Ratio=""
  	s AdmNum=..PatAdmNum(stDate,edDate,HOSPID)
  	
  	s DocNum=0
  	i +emDocNumber=0 d
  	.s GroupID=$O(^SSU("SSGRP",0,"Desc","急诊医师",""))
  	.s UserNomal=""
	.f  s UserNomal=$O(^SSU("SSUSR",0,"Group",GroupID,UserNomal)) q:UserNomal=""  d
	..q:(HOSPID'="")&&($p(^SSU("SSUSR",UserNomal),"^",98)'=HOSPID)
	
	..S UserNomalActive=$p(^SSU("SSUSR",UserNomal),"^",19)
	..Q:(UserNomalActive'="")&&(UserNomalActive="N") 
	..S UserNomalDateFrom=$p(^SSU("SSUSR",UserNomal),"^",96) ;生效日期
	..S UserNomalDateTo=$p(^SSU("SSUSR",UserNomal),"^",97) ;截止日期
	..Q:(UserNomalDateFrom'="")&&(UserNomalDateFrom>+$h) 
	..Q:(UserNomalDateTo'="")&&(UserNomalDateTo<+$h) 
	
	..s DocNum=DocNum+1
	.s UserId=""
	.f  s UserId = $O(^SSU("SSUSR",UserId)) q:UserId=""  d
	..q:(HOSPID'="")&&($p(^SSU("SSUSR",UserId),"^",98)'=HOSPID)
	..q:$p(^SSU("SSUSR",UserId),"^",5)=GroupID
	..S UserActive=$p(^SSU("SSUSR",UserId),"^",19)
	..Q:(UserActive'="")&&(UserActive="N") 
	..S UserDateFrom=$p(^SSU("SSUSR",UserId),"^",96) ;生效日期
	..S UserDateTo=$p(^SSU("SSUSR",UserId),"^",97) ;截止日期
	..Q:(UserDateFrom'="")&&(UserDateFrom>+$h) 
	..Q:(UserDateTo'="")&&(UserDateTo<+$h) 
	..s ChildSub=0,Flag=""
	..f  s ChildSub = $O(^SSU("SSUSR",UserId,"OTHLL",ChildSub)) q:(ChildSub="")!(Flag'="")  d
	...s othllInfo=$g(^SSU("SSUSR",UserId,"OTHLL",ChildSub))
	...s GroupDr=$p(othllInfo,"^",2)
	...s:GroupDr=GroupID Flag=1
	..s:Flag=1 DocNum=DocNum+1
	
	s:+emDocNumber'=0 DocNum=emDocNumber
	


	s:AdmNum'=0 Ratio=$j(DocNum/AdmNum*100,2,2)_"%"
	
	s DocNums="医生数"
	s AdmNums=DocNum
	
	d OutputRow1

	S DocNums = "患者就诊数"
	s AdmNums=AdmNum
	d OutputRow1

    //编码结束
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DocNums,AdmNums,Ratio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod docRatioQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = docRatioQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod docRatioQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = docRatioQueryExecute ]
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
	Quit $$$OK
}

/// 急诊科护患比
Query nurRatioQuery(stDate, edDate, emNurNumber = "", HOSPID) As %Query(ROWSPEC = "DocNum:%String,AdmNum:%Integer,Ratio:%String") [ SqlProc ]
{
}

ClassMethod nurRatioQueryExecute(ByRef qHandle As %Binary, stDate, edDate, emNurNumber = "", HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","nurRatioQuery","2022-04-04","2022-06-04",2)
    Set repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    set ind=1
    i (stDate="")||(edDate="") Quit $$$OK
	
  	//编码开始
  	s stDate= $zdh(stDate,3)
  	s edDate=$zdh(edDate,3)
  	
  	s Ratio=""
  	s DocNum=0
  	s AdmNum=..PatAdmNum(stDate,edDate,HOSPID)
	
  	i +emNurNumber=0 d
  	.s GroupID=$O(^SSU("SSGRP",0,"Desc","急诊留观抢救护士",""))
  	.s:GroupID="" GroupID=$O(^SSU("SSGRP",0,"Desc","急诊留观护士",""))
  	.s UserNomal=""
	.f  s UserNomal=$O(^SSU("SSUSR",0,"Group",GroupID,UserNomal)) q:UserNomal=""  d
	..s DocNum=DocNum+1
	.s UserId=""
	.f  s UserId = $O(^SSU("SSUSR",UserId)) q:UserId=""  d
	..q:$p(^SSU("SSUSR",UserId),"^",5)=GroupID
	..s ChildSub=0,Flag=""
	..f  s ChildSub = $O(^SSU("SSUSR",UserId,"OTHLL",ChildSub)) q:(ChildSub="")!(Flag'="")  d
	...s othllInfo=$g(^SSU("SSUSR",UserId,"OTHLL",ChildSub))
	...s GroupDr=$p(othllInfo,"^",2)
	...s:GroupDr=GroupID Flag=1
	..s:Flag=1 DocNum=DocNum+1

	s:+emNurNumber'=0 DocNum=emNurNumber


	s:AdmNum'=0 Ratio=$j(DocNum/AdmNum*100,2,2)_"%"
	s name="护士数"
	s num=DocNum
	d OutputRow2
    
    s name="患者就诊数"
	s num=AdmNum
	d OutputRow2
	
	;s name="比例"
	;s num=Ratio
	;d OutputRow2
    
    //编码结束
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(name,num,Ratio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod nurRatioQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = nurRatioQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod nurRatioQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = nurRatioQueryExecute ]
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
	Quit $$$OK
}

/// Description: 急诊手术患者死亡率 报表
/// Creator:     hxy
/// CreateDate:  2022-06-28
/// Input:  	 开始时间(stDate),结束时间(edDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","SurDeathData","2022-06-01","2022-06-03","2")
Query SurDeathData(stDate As %String, edDate As %String, HOSPID = "") As %Query(ROWSPEC = "DeathNum,AllNum:%Integer,DeathRatio") [ SqlProc ]
{
}

ClassMethod SurDeathDataExecute(ByRef qHandle As %Binary, stDate As %String, edDate As %String, HOSPID = "") As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =edDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","SURGPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	s AllNum=0,DeathNum=0,DeathRatio="0%"
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AllNum=AllNum+1
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..s:IsDeath="Y" DeathNum=DeathNum+1
   	s:AllNum'=0 DeathRatio=$j(DeathNum/AllNum*100,2,2)_"%"
   	
   	s DeathNums="手术死亡数"
   	s AllNums=DeathNum
	d OutPutData
	
	s DeathNums="手术数"
   	s AllNums=AllNum
	d OutPutData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutData
	set Data=$lb(DeathNums,AllNums,DeathRatio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SurDeathDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SurDeathDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SurDeathDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SurDeathDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急性心肌梗死患者平均门球时间及门球时间达标率 报表
/// Creator:     hxy
/// CreateDate:  2022-06-29
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","EmPatMioInfData","2022-04-01","2022-06-29","2")
Query EmPatMioInfData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,OpenOrdDate,OpenOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,LimitDateTime,MiAvg,Ratio") [ SqlProc ]
{
}

ClassMethod EmPatMioInfDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","MIOINFPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	s DrugData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","MIOINFPATDRUGBALL",+$g(HOSPID),"","","")
 	s DrugData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(DrugData)
 	s DrugData = $p(DrugData,"^",2)
 	
 	k ^TMP("DHCEM","web.DHCEMLevelNum","EmPatMioInfData")
 	s MiAll=0,count=0,MiPass=0
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
    ..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
    ..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s PatientID=+^PAADM(EpisodeID)
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s MrNo="",WardDesc="",Doctor="",ILoc="",IPaAdmDate="",IPaAdmTime=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
    ...s IPaAdmDate = $p(^PAADM(ToAdmID),"^",6) 				;就诊日期
	...s IPaAdmTime = $p(^PAADM(ToAdmID),"^",7) 				;就诊时间
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
   	..s HasOrdIDs=""
   	..i DrugData'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,DrugData)
   	..s OrdItmID=$p(HasOrdIDs,"^",1) //ed
   	..q:OrdItmID=""
   	..s OpenOrdDate="",OpenOrdTime="",LimitDateTime=0
   	..i OrdItmID'="" d
   	...s Ord=+OrdItmID
   	...s Itm=$p(OrdItmID,"||",2)
   	...s OpenOrdDate=$p($g(^OEORD(Ord,"I",Itm,1)),"^",9) 
   	...s OpenOrdTime=$p($g(^OEORD(Ord,"I",Itm,1)),"^",10) 
   	...s LimitDateTime=##class(web.DHCEMPatCheckLevStatis).GetLimitDateDescSql(PaAdmDate,PaAdmTime,OpenOrdDate,OpenOrdTime)
   	..s MiAll=MiAll+LimitDateTime
   	..s:(LimitDateTime'=0)&&(LimitDateTime<30) MiPass=MiPass+1
	..s:OpenOrdDate'="" OpenOrdDate=$zd(OpenOrdDate,3)
	..s:OpenOrdTime'="" OpenOrdTime=$zt(OpenOrdTime,2)
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s count=count+1
	..s ^TMP("DHCEM","web.DHCEMLevelNum","EmPatMioInfData",repid,EpisodeID)=PAAdmDoc_"^"_PaAdmDate_"^"_PaAdmTime_"^"_OpenOrdDate_"^"_OpenOrdTime_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDiag_"^"_PatNo_"^"_MrNo_"^"_ILoc_"^"_WardDesc_"^"_Doctor_"^"_LimitDateTime
	
	s MiAvg="",Ratio=""
	s:count'=0 MiAvg=$j(MiAll/count,2,2)
	s:count'=0 Ratio=$j(MiPass/count*100,2,2)_"%"
	s Adm = 0
	f  s Adm = $o(^TMP("DHCEM","web.DHCEMLevelNum","EmPatMioInfData",repid,Adm)) q:Adm=""  d
	.s Str=^TMP("DHCEM","web.DHCEMLevelNum","EmPatMioInfData",repid,Adm)
	.s PAAdmDoc=$p(Str,"^",1)
	.s PaAdmDate=$p(Str,"^",2)
	.s PaAdmTime=$p(Str,"^",3)
	.s OpenOrdDate=$p(Str,"^",4)
	.s OpenOrdTime=$p(Str,"^",5)
	.s PatName=$p(Str,"^",6)
	.s PatSex=$p(Str,"^",7)
	.s PatAge=$p(Str,"^",8)
	.s PatDiag=$p(Str,"^",9)
	.s PatNo=$p(Str,"^",10)
	.s MrNo=$p(Str,"^",11)
	.s ILoc=$p(Str,"^",12)
	.s WardDesc=$p(Str,"^",13)
	.s Doctor=$p(Str,"^",14)
	.s LimitDateTime=$p(Str,"^",15)
	.d OutPutEmPatMioInfData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatMioInfData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,OpenOrdDate,OpenOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,LimitDateTime,MiAvg,Ratio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatMioInfDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatMioInfDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatMioInfDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatMioInfDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

}
