Import SQLUSER

/// 名称:     web.DHCDocOrdRecDepPatientList
/// 描述:     医嘱接收科室病人列表
/// 编写日期: 2009.12.12
/// 适用医院: 衢州人民医院,东方医院
Class web.DHCDocOrdRecDepPatientList Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 20100227^328^0000000033^^^^^^^30
/// d ##class(%ResultSet).RunQuery("web.DHCDocOrdRecDepPatientList","FindAdmByOrdRecDep","20100227","328","0000000033","","","","","","","30")
Query FindAdmByOrdRecDep(sttDate As %String, DepRowid As %String, PAPMINoItem As %String, Name As %String, CardNo As %String, DayLimit As %String, OrdsttDate As %String, OrdendDate As %String, ShowAllOrd As %String, wardid As %String) As %Query(ROWSPEC = "ARCIMDesc:%String,OEORIRowid:%String,OEORIItmMastDR:%String,OEOREOrderstatus:%String,OEORIDate:%String,EpisodeID:%String,PatientID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmType:%String,PAAdmBed:%String,AdmReason:%String,ExecuteFlag:%String,PAAdmReason:%String,Hours:%String,PAAdmWard:%String")
{
}

ClassMethod FindAdmByOrdRecDepExecute(ByRef qHandle As %Binary, sttDate As %String, DepRowid As %String, PAPMINoItem As %String, Name As %String, CardNo As %String, DayLimit As %String, OrdsttDate As %String, OrdendDate As %String, ShowAllOrd As %String, wardid As %String) As %Status
{
	s ^RP("RecDep")=sttDate_"^"_DepRowid_"^"_PAPMINoItem_"^"_Name_"^"_CardNo_"^"_DayLimit_"^"_OrdsttDate_"^"_OrdendDate_"^"_ShowAllOrd_"^"_wardid
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s DepRowid1=DepRowid

    i DepRowid="" s DepRowid=%session.Get("LOGON.CTLOCID")
    Set (ARCIMDesc,OEORIRowid,OEORIItmMastDR,OEOREOrderstatus,PatientID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmNo,PAAdmBed,AdmReason,PAAdmReason)=""
    s OEOREOrderStatusret=""
    k ^TempRecDeptPatList
    
    ;意义为就诊日期
    s sttDatelen=$l(sttDate)
    i sttDate=""{
	    ;s PAADMAdmDateStart=..%SysDate()
	    s PAADMAdmDateStart=""
	}elseif(sttDatelen="8")
    {	
    	s PAADMAdmDateStart=..TransDate(sttDate,"Define")
    }else{
	    s PAADMAdmDateStart=..TransDate(sttDate,"")
	}
    s PAADMAdmDateEnd=PAADMAdmDateStart   


    i OrdsttDate="" s OrdsttDate=..%SysDate()    

	i OrdendDate="" s OrdendDate=..%SysDate()    

	
	
	If ($g(PAPMINoItem)'=""){
		d FindByPAPMINoItem
	}elseif(Name'=""){
		d FindByName
	}elseif(CardNo'=""){
		d FindByCardNo
	}elseif(wardid'=""){
		;产生病区病人别表,不包含医嘱
		d WardPatList
	}else{
		;d GetOrdListByRecDep
	}
    
	s paadmrowid="" f  s paadmrowid=$o(^TempRecDeptPatList($j,paadmrowid)) q:paadmrowid=""  d
	.s oeorirowid="" f  s oeorirowid=$o(^TempRecDeptPatList($j,paadmrowid,oeorirowid)) q:oeorirowid=""  d
	..d FindPatInfoByPaadm
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow10
	set Data=$lb(ARCIMDesc,OEORIRowid,OEORIItmMastDR,OEOREOrderstatus,OEORIDate,EpisodeID,PatientID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmType,PAAdmBed,AdmReason,ExecuteFlag,PAAdmReason,Hours,PAAdmWard)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	
GetOrdListByRecDep
	;索引不好用
	f OEORIDate=OrdsttDate:1:OrdendDate d
	.s OEORDRowId=0 f  s OEORDRowId=$o(^OEORDi(0,"ItemDate",OEORIDate,OEORDRowId)) q:OEORDRowId=""  d
	..s OEORIChildsub=0 f  s OEORIChildsub=$o(^OEORDi(0,"ItemDate",OEORIDate,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	...s OEORIRecDepDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
	...q:OEORIRecDepDR'=DepRowid
	...s OEOREOrderStatusret=##class(web.DHCNurCom).IfExecOrder(OEORIRowId)
	...q:(OEOREOrderStatusret="1")&(ShowAllOrd'="on")   ;0未执行
	...s OEORDAdmDR=$p($g(^OEORD(OEORDRowId)),"^",1)
	...s ^TempRecDeptPatList($j,OEORDAdmDR,OEORIRowId)=""
	quit
GetAdmListByRecDep	
    s find=0
    s OEORDRowId=0 f  s OEORDRowId=$o(^OEORD(0,"Adm",PAADMRowID,OEORDRowId)) q:(OEORDRowId="")!(find'=0)  d
	.s OEORIChildsub=0 f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	..s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	..s OEORIDate=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
	..q:((OEORIDate<OrdsttDate)!(OEORIDate>OrdendDate))&(OEORIDate'="")
	..s OEOREOrderStatusret=##class(web.DHCNurCom).IfExecOrder(OEORIRowId)
	..q:(OEOREOrderStatusret="1")&(ShowAllOrd'="on")   ;0未执行
	..s OEORIRecDepDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	..i (OEORIRecDepDR=DepRowid) s find=find+1
	..i ((PAPMINoItem'="")!(Name'="")!(CardNo'=""))&(OEORIRecDepDR'="") s find=find+1 
	


	i find>0 d
	.s OEORDRowId=0 f  s OEORDRowId=$o(^OEORD(0,"Adm",PAADMRowID,OEORDRowId)) q:(OEORDRowId="")  d
	..s OEORIChildsub=0 f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	...s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	...s OEORIDate=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",7)
	...q:((OEORIDate<OrdsttDate)!(OEORIDate>OrdendDate))&(OEORIDate'="")
	...s OEOREOrderStatusret=##class(web.DHCNurCom).IfExecOrder(OEORIRowId)
	...q:(OEOREOrderStatusret="1")&(ShowAllOrd'="on")
	...s OEORIRecDepDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...q:(OEORIRecDepDR'=DepRowid1)&&(DepRowid1'="")
	...s ^TempRecDeptPatList($j,PAADMRowID,OEORIRowId)=""
	quit

FindPatInfoByPaadm	
	s Hours=""
	i (oeorirowid'="WardPatList"){
		s OEORIRowid=oeorirowid
		s ret=##class(web.DHCNurCom).IfExecOrder(oeorirowid)
		i ret="1" s OEOREOrderstatus="已执行"
		i ret="0" s OEOREOrderstatus="未执行"
		s OEORIDatetem=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),3)),"^",7)
		i OEORIDatetem'="" s OEORIDate=..%ZD(OEORIDatetem) //$zd(OEORIDatetem,3)
		e  s OEORIDate=""
		s OEORIItmMastDR=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)),"^",2)
		i OEORIItmMastDR'="" s ARCIMDesc=$p($g(^ARCIM(+OEORIItmMastDR,$p(OEORIItmMastDR,"||",2),1)),"^",2)
		s Hours=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),9)),"^",4)
	}else{
		s OEORIRowid=""
		s OEOREOrderstatus=""
		s ARCIMDesc=""
		s OEORIDate=""
		
	}
	s EpisodeID=paadmrowid
	s ExecuteFlag=""
	Set PatientID=$P(^PAADM(paadmrowid),"^",1)	
	Set mradm=$P(^PAADM(paadmrowid),"^",61)
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	Set PAPMIDOB=..%ZD($P(^PAPER(PatientID,"ALL"),"^",6)) //$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Set PAAdmDate=..%ZD($P($g(^PAADM(paadmrowid)),"^",6)) //$ZD($P($g(^PAADM(paadmrowid)),"^",6),3)
	Set PAAdmTime=..%ZT($P($g(^PAADM(paadmrowid)),"^",7),3)
	Set PAAdmNo=$P($g(^PAADM(paadmrowid)),"^",81)
	Set Loc=$P($g(^PAADM(paadmrowid)),"^",4)
	Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	Set Doctor=$P($g(^PAADM(paadmrowid)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(paadmrowid)),"^",2)
	If PAAdmType="I" Set PAAdmType="住院"
	If PAAdmType="O" Set PAAdmType="门诊"
	If PAAdmType="E" Set PAAdmType="急诊"	
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set WardDr=$P($g(^PAADM(paadmrowid)),"^",70)
	if WardDr'="" Set PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)
	else  Set PAAdmWard=""
	Set BedId=$P($g(^PAADM(paadmrowid)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	Set PAAdmStatus=$P($g(^PAADM(paadmrowid)),"^",20)
	Set AdmReason=$P($g(^PAADM(paadmrowid,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	Do OutputRow10
	quit
FindByPAPMINoItem
	s PAPMINoItem=$ZCVT(PAPMINoItem,"U")
    s PAPMI=$o(^PAPERi("PAPMI_PatNo",PAPMINoItem,""))
    q:PAPMI=""
    d FindByPAPMI
    quit
FindByName
    Set Name=$ZCVT(Name,"U")
	Set PAPMI=0
	For  Set PAPMI=$O(^PAPERi("PAPER_PatName",Name,PAPMI)) Quit:PAPMI=""  Do
    .q:PAPMI=""
    .d FindByPAPMI
    quit
    
FindByCardNo
	s CardRowid=""
	s PAPMI=""
	s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))
	i CardRowid'="" d
    .s PAPMI=$P($g(^DHCCARD("CF",CardRowid)),"^",4)
    q:PAPMI=""
    d FindByPAPMI
    quit
FindByDate
	if (PAADMAdmDateStart="") quit
    for PAADMAdmDate=PAADMAdmDateStart:1:PAADMAdmDateEnd d
    .s find=0
	.s PAADMRowID=0 f  s PAADMRowID=$O(^PAADMi("PAADM_AdmDate",PAADMAdmDate,PAADMRowID)) Quit:PAADMRowID=""  Do
    ..Set PAAdmType=$P($g(^PAADM(paadmrowid)),"^",2)
    ..s pavisit=$p($g(^PAADM(PAADMRowID)),"^",20)
	..q:(pavisit'="A")&&(PAAdmType="I")
    ..d GetAdmListByRecDep
    quit
FindByOrdRecLoc
	
	s OEORIPRN="" f  s OEORIPRN=$o(^OEORD(0,"RecDep",DepRowid,OEORIPRN)) q:OEORIPRN=""  d
	.s PAPMI=$o(^PAPERi("PAPMI_PatNo",OEORIPRN,""))
    .q:PAPMI=""
    .d FindByPAPMI
	quit
FindByPAPMI
    s PAADMType=""
	f  s PAADMType=$o(^PAPERdr(PAPMI,"ADM",PAADMType)) q:PAADMType=""  d
    .s PAADMRowID=""
	.f  Set PAADMRowID=$O(^PAPERdr(PAPMI,"ADM",PAADMType,PAADMRowID)) Quit:PAADMRowID=""  Do

	..Set PAAdmType=$P($g(^PAADM(PAADMRowID)),"^",2)
    ..s pavisit=$p($g(^PAADM(PAADMRowID)),"^",20)
    ..q:PAAdmType'="I"
	..q:(pavisit'="A")&&(PAAdmType="I")
	..Set PAAdmDate=$P($g(^PAADM(PAADMRowID)),"^",6)
    ..;查询就诊日期前5的就诊断记录
    ..i DayLimit="" s DayLimit=5
    ..;s PAADMAdmDateStart=PAADMAdmDateEnd-DayLimit
	..;q:((PAAdmDate<PAADMAdmDateStart)!(PAAdmDate>PAADMAdmDateEnd))&(PAADMType="O")
    ..d GetAdmListByRecDep
    quit
WardPatList
	Set RoomDr=0
	s ^RP("wardid")=wardid
	For  s RoomDr=$O(^PAADMi("CurrWard",wardid,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=0
	.For  Set PAAdm=$O(^PAADMi("CurrWard",wardid,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..s pavisit=$p($g(^PAADM(PAAdm)),"^",20)
	..q:pavisit'="A"
	..;未分配床位
	..s PAADMBedDR=$p($g(^PAADM(PAAdm)),"^",73)
	..Q:PAADMBedDR=""
	..Quit:(PAADMAdmDateStart'="")&(AdmDate<PAADMAdmDateStart)
	..Quit:(PAADMAdmDateEnd'="")&(AdmDate>PAADMAdmDateEnd)
	..s ^TempRecDeptPatList($j,PAAdm,"WardPatList")=""
	Set AdmItm=0
	For  Set AdmItm=$O(^PAWARDA(wardid,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(wardid,"WADM",AdmItm),"^",1)
	.Set AdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	.s pavisit=$p($g(^PAADM(PAAdm)),"^",20)
	.q:pavisit'="A"
	.;未分配床位
	.s PAADMBedDR=$p($g(^PAADM(PAAdm)),"^",73)
	.Q:PAADMBedDR=""
	.Quit:(PAADMAdmDateStart'="")&(AdmDate<PAADMAdmDateStart)
	.Quit:(PAADMAdmDateEnd'="")&(AdmDate>PAADMAdmDateEnd)
	.s ^TempRecDeptPatList($j,PAAdm,"WardPatList")=""
	Quit
}

ClassMethod FindAdmByOrdRecDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmByOrdRecDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindAdmByOrdRecDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmByOrdRecDepExecute ]
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

/// 重写这个方法,入参做修改
ClassMethod ExcuteRecDepOrdbak(EpisodeID, OEORIRowId) As %String
{
	;s ^RP("EpisodeID")=EpisodeID
	;w ##class(web.DHCDocOrdRecDepPatientList).ExcuteRecDepOrd("108")
	;q:EpisodeID="" "NoAdm"
    S userId=%session.Get("LOGON.USERID")
    s ctlocId=%session.Get("LOGON.CTLOCID")
    ;s userId=""
	s OrderStartDate="",oreStr="",curExecStatDesc="",queryTypeCode=""
	s CurrDateTime=##class(web.DHCDocOrderCommon).GetCurrentDateTime("4","2")
	i CurrDateTime'="" d
	.s OrderStartDate=$p(CurrDateTime,"^",1)
	.s OrderStartTime=$p(CurrDateTime,"^",2)
	
	s updatefail=0
	;s EpisodeID="" f  s EpisodeID=$o(^TempRecDeptPatList($j,EpisodeID)) q:(EpisodeID="")!(updatefail=1)  d
	;s OEORIRowId="" f  s OEORIRowId=$o(^TempRecDeptPatList($j,EpisodeID,OEORIRowId)) q:OEORIRowId=""  d
	s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	
	i EpisodeType="I" {
		s curExecStatDesc="完成"
	}else{
		s curExecStatDesc=""
	}
	s oreStr=OEORIRowId_"^^"_ctlocId_"^"_curExecStatDesc_"^"_queryTypeCode_"^"_OrderStartDate_"^"_OrderStartTime
	s ret=##class(web.DHCNurCom).UpdateOrdGroup("",oreStr,userId,"1")
	if ($g(ret)'="0"){
		s updatefail="1"
	}

    i updatefail="1" q ret
	q 0
}

ClassMethod ExcuteRecDepOrd(EpisodeID) As %String
{
	;s ^RP("EpisodeID")=EpisodeID
	;w ##class(web.DHCDocOrdRecDepPatientList).ExcuteRecDepOrd("108")
	q:EpisodeID="" "NoAdm"
    S userId=%session.Get("LOGON.USERID")
    s ctlocId=%session.Get("LOGON.CTLOCID")
    ;s userId=""
	s OrderStartDate="",oreStr="",curExecStatDesc="",queryTypeCode=""
	s CurrDateTime=##class(web.DHCDocOrderCommon).GetCurrentDateTime("4","2")
	i CurrDateTime'="" d
	.s OrderStartDate=$p(CurrDateTime,"^",1)
	.s OrderStartTime=$p(CurrDateTime,"^",2)
	
	s updatefail=0
	s EpisodeID="" f  s EpisodeID=$o(^TempRecDeptPatList($j,EpisodeID)) q:(EpisodeID="")!(updatefail=1)  d
	.s OEORIRowId="" f  s OEORIRowId=$o(^TempRecDeptPatList($j,EpisodeID,OEORIRowId)) q:OEORIRowId=""  d
	..s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	
	..i EpisodeType="I" d
	...s curExecStatDesc="完成"
	..e  d
	...s curExecStatDesc=""
	..s oreStr=OEORIRowId_"^^"_ctlocId_"^"_curExecStatDesc_"^"_queryTypeCode_"^"_OrderStartDate_"^"_OrderStartTime
	..s ret=##class(web.DHCNurCom).UpdateOrdGroup("",oreStr,userId,"1")
	..if ($g(ret)'="0") d
	...s updatefail="1"

    i updatefail="1" q ret
	q 0
}

ClassMethod GetDeptStr()
{
	;w ##class(web.DHCDocOrdRecDepPatientList).GetDeptStr()
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCDocOrdRecDepPatientList:FindLoc")
	do rset.Execute("")
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		//CTDesc,CTCode,rowid,CTContactName
		set ret=rset.GetData(3)_$C(1)_rset.GetData(1)_"-"_rset.GetData(4)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

Query FindLoc(Loc As %String) As %Query(ROWSPEC = "Desc:%String,Code:%String,Hidden:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocExecute(ByRef QHandle As %Binary, Loc As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.DHCDocOrdRecDepPatientList","FindLoc","mzyf")
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s CTLOCType=$p($g(^CTLOC(rowid)),"^",13)
	.q:(CTLOCType'="D")&&(CTLOCType'="W")
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTContactNameW=""
	.i $l(CTDesc,"-")>1 s CTContactNameW=$P(CTDesc,"-",1)
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.i CTContactName="" s CTContactName=CTContactNameW
	.;w CTDesc_","_CTContactName_","_(CTContactName'[(Loc))_","_(CTDesc'[(Loc)),!
	.q:##class(web.DHCOPAdmReg).CheckLocDesc(rowid,Loc)'=1
	.//Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CTDesc,CTCode,rowid,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 公用
ClassMethod GetDeptStrCommon(type)
{
	;w ##class(web.DHCDocOrdRecDepPatientList).GetDeptStrCommon("W")
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCDocOrdRecDepPatientList:FindTypeLoc")
	do rset.Execute("",type)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		;set ret=rset.GetData(3)_$C(1)_rset.GetData(4)_"-"_rset.GetData(1)
		set ret=rset.GetData(3)_$C(1)_rset.GetData(2)_"-"_rset.GetData(4)_"-"_rset.GetData(1)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrdRecDepPatientList","FindTypeLoc","","W")
Query FindTypeLoc(Loc As %String, loctype As %String) As %Query(ROWSPEC = "Desc:%String,Code:%String,Hidden:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod FindTypeLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindTypeLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTypeLocExecute(ByRef QHandle As %Binary, Loc As %String, loctype As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.DHCDocOrdRecDepPatientList","FindLoc","mzyf")
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s CTLOCType=$p($g(^CTLOC(rowid)),"^",13)
	.q:((loctype'="")&&(CTLOCType'=loctype))
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.;w CTDesc_","_CTContactName_","_(CTContactName'[(Loc))_","_(CTDesc'[(Loc)),!
	.Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.Do OutputRow1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTDesc,CTCode,rowid,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables1
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod FindTypeLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindResDocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindResDocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TransDate(Date As %String, Format As %String)
{
	q:Date="" ""
	i (Format=""){
		i (Date["-") {
			s FormatDate=$zdh(Date,3)
		}elseif (Date["/"){
	    	s FormatDate=$zdh(Date,4)
		}else{
			s FormatDate=Date
		}
	}elseif(Format="Define"){
		s FormatDate=$e(Date,1,4)_"-"_$e(Date,5,6)_"-"_$e(Date,7,8)
		s FormatDate=$zdh(FormatDate,3)
	}else{
		s FormatDate=$zdh(Date,Format)
	}
	s ret=FormatDate
	q ret
}

/// Creator?      
/// CreatDate?    2010.02.02
/// Description:? 获取病区病人列表用于打印录入持续吸氧医嘱的小时数的表格
/// Table?        
/// Input?        wardid:病区RowId
/// Return?       病区病人基本信息串
/// Others? 
ClassMethod GetWardPatListStr(wardid As %String)
{
	;s ^RP("GetWardPatListStr")=wardid
	;w ##class(web.DHCDocOrdRecDepPatientList).GetWardPatListStr("20")
	q:wardid="" ""
	s ret=""
	s userId=%session.Get("LOGON.USERID")
	s SeqNo=0
	
	Set RoomDr=0	
	f  s RoomDr=$O(^PAADMi("CurrWard",wardid,RoomDr)) Quit:RoomDr=""  Do
	.Set PAAdm=""
	.For  Set PAAdm=$O(^PAADMi("CurrWard",wardid,RoomDr,PAAdm)) Quit:PAAdm=""  Do
	..s pavisit=$p($g(^PAADM(PAAdm)),"^",20)
	..q:pavisit'="A" 
	
	..s MedCareNo=$p($g(^PAPER(PAAdm,"PAT",1)),"^",22)
	..Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	..if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	..else  Set PAAdmBed="" 
	..Set PatientID=$P(^PAADM(PAAdm),"^",1)	
	..Set PAPMIName=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	..s Number="0.00"
	..s Time=$zd(+$h,3)_"    "_"23:59:00"
	..s HoursInput="吸氧/H     "
	..s NurseCode=$P($g(^CTPCP(userId,1)),"^",1)
	..Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	..If Doctor'="" Set PAAdmDoc=$P($g(^CTPCP(Doctor,1)),"^",2)
	..Else  Set PAAdmDoc=""
	..s SeqNo=SeqNo+1
	..i ret="" d
	...s ret=SeqNo_"^"_MedCareNo_"^"_PAAdmBed_"^"_PAPMIName_"^"_Number_"^"_Time_"^"_HoursInput_"^"_NurseCode_"^"_PAAdmDoc
	..e  s ret=ret_"!"_SeqNo_"^"_MedCareNo_"^"_PAAdmBed_"^"_PAPMIName_"^"_Number_"^"_Time_"^"_HoursInput_"^"_NurseCode_"^"_PAAdmDoc
	

	s AdmItm=0
	f  s AdmItm=$O(^PAWARDA(wardid,"WADM",AdmItm)) Quit:AdmItm=""  Do
	.Set PAAdm=$P(^PAWARDA(wardid,"WADM",AdmItm),"^",1)
	.s pavisit=$p($g(^PAADM(PAAdm)),"^",20)
	.q:pavisit'="A" 
	.s MedCareNo=$p($g(^PAPER(PAAdm,"PAT",1)),"^",22)
	.Set BedId=$P($g(^PAADM(PAAdm)),"^",73)
	.if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	.else  Set PAAdmBed="" 
	.Set PatientID=$P(^PAADM(PAAdm),"^",1)	
	.Set PAPMIName=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	.s Number="0.00"
	.s Time=$zd(+$h,3)_"    "_"23:59:00"
	.s HoursInput="吸氧/H     "
	.s NurseCode=$P($g(^CTPCP(userId,1)),"^",1)
	.Set Doctor=$P($g(^PAADM(PAAdm)),"^",9)
	.If Doctor'="" Set PAAdmDoc=$P($g(^CTPCP(Doctor,1)),"^",2)
	.Else  Set PAAdmDoc=""
	.s SeqNo=SeqNo+1
	.i ret="" d
	..s ret=SeqNo_"^"_MedCareNo_"^"_PAAdmBed_"^"_PAPMIName_"^"_Number_"^"_Time_"^"_HoursInput_"^"_NurseCode_"^"_PAAdmDoc
	.e  s ret=ret_"!"_SeqNo_"^"_MedCareNo_"^"_PAAdmBed_"^"_PAPMIName_"^"_Number_"^"_Time_"^"_HoursInput_"^"_NurseCode_"^"_PAAdmDoc
	q ret
}

/// Creator?      
/// CreatDate?    2010.02.27
/// Description:? 登陆科室取病区
/// Table?        
/// Input?        locrowid
/// Return?       病区
/// Others?
ClassMethod GetWardStr(ctlocrowid As %String)
{
	s ^RP("GetWardStr")=ctlocrowid
	;w ##class(web.DHCDocOrdRecDepPatientList).GetWardStr(328)
	q:ctlocrowid="" ""
	s wardid="",warddesc=""

	s logonLocType=$p($g(^CTLOC(ctlocrowid)),"^",13)
	i logonLocType="W" {
		s wardid=$o(^PAWARD(0,"WARD_LocationDR",ctlocrowid,""))
		s warddesc=$p($g(^PAWARD(wardid)),"^",2)
	}

	q wardid_"^"_warddesc
}

ClassMethod orderlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = orderlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod orderlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare orderc cursor  for 
	select distinct alias_arcim_dr,alias_arcim_dr->arcim_desc
    from SQLUser.arc_ALIAS 
	              WHERE (UPPER(ALIAS_text) like :desc))
	&sql(open orderc)
	f  &sql(fetch orderc into :orderrowid,:orderdesc) q:SQLCODE  d
	.q:orderdesc=""
 	.Do OutputRow3 	 	
 	&sql(close orderc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(orderdesc,orderrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod orderlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = orderlookupExecute ]
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

Query orderlookup(desc As %String) As %Query(ROWSPEC = "order:%String,orderid:%String")
{
}

}
