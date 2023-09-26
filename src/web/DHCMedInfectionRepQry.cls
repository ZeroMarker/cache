Import SQLUser

Class web.DHCMedInfectionRepQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

ClassMethod BuildRepList(RepRowid)
{
	n (RepRowid)
	s ret=""
	s sReport=##class(web.DHCMedInfectionRepCtl).GetInfRep(RepRowid)
	q:sReport="" ret
	s paadm=$p(sReport,"^",2)
	q:paadm="" ret
	s sPaadm=##class(web.DHCMedBasePaadmCtl).GetAdmInfo(paadm)
	q:sPaadm="" ret
	s papmi=$p(sPaadm,"^",6)
	q:papmi="" ret
	s sPatient=##class(web.DHCMedBaseCtl).GetPatInfo(papmi)
	q:sPatient="" ret
	
	s Data=$lb("")
	s $li(Data,1)=$p(sReport,"^",1)                  //RepRowId         
	s $li(Data,2)=papmi                     //Papmi            
	s $li(Data,3)=paadm                     //paadm            
	s $li(Data,4)=$p(sPatient,$c(2),23)                     //PatNo            
	s $li(Data,5)=$p(sPatient,$c(2),1)                   //PatName          
	s $li(Data,6)=""               //RepExcerpta      
	s $li(Data,7)=$p(sPaadm,"^",7)                 //CtLocDesc        
	s $li(Data,8)=$p(sPaadm,"^",9)                  //WardDesc         
	s $li(Data,9)=$p(sReport,"^",12)               //RepStatusCode      
	s $li(Data,10)=##class(web.DHCMedDictoryCtl).GetByTypeCode("InfectionReportStatus",$p(sReport,"^",12))  //RepStatusDesc    
	s $li(Data,11)=$p($p(sReport,"^",11),"/",1)   //RepUser          
	s $li(Data,12)=$p($p(sReport,"^",11),"/",3)   //RepUserName      
	s $li(Data,13)=$p(sReport,"^",9)                   //RepDate          
	s $li(Data,14)=$p(sReport,"^",10)                   //RepTime          
	s $li(Data,15)=$p($p(sReport,"^",13),"/",1)     //CheckUser        
	s $li(Data,16)=$p($p(sReport,"^",13),"/",3)    //CheckUserName    
	s $li(Data,17)=$p(sReport,"^",14)                 //CheckDate        
	s $li(Data,18)=$p(sReport,"^",15)                 //CheckTime        
	s $li(Data,19)=$p(sReport,"^",16)                   //RepDemo      
	
	s $li(Data,20)=$p(sReport,"^",17)  //mody by cjb 20090411 社区感染字典
    s $li(Data,21)=##class(web.DHCMedDictoryCtl).GetByTypeCode("InfectionRepPlace",$p(sReport,"^",17))
	
	q Data
}

ClassMethod QueryByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:EpisodeID="" $$$OK
	Quit:'$d(^DHCMedIR(0,"PAADM",EpisodeID)) $$$OK
	
	;^DHCMedIR(0,"PAADM",{MIR_Paadm_DR},{MIR_Rowid})
	Set RepRowid=""
	f  s RepRowid=$o(^DHCMedIR(0,"PAADM",EpisodeID,RepRowid)) q:RepRowid=""  d
	.s Status=$p($g(^DHCMedIR(RepRowid)),"^",11)
	.q:Status=0
	.//在医生站不显示删除报告 by cjb  2010-03-10
	.s ret=..BuildRepList(RepRowid)
	.q:ret=""
	.s ^CacheTemp(repid,ind)=ret
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query QueryByAdm(EpisodeID As %String) As %Query(ROWSPEC = "RepRowId:%String,Papmi:%String,paadm:%String,PatNo:%String,PatName:%String,RepExcerpta:%String,CtLocDesc:%String,WardDesc:%String,RepStatusCode:%String,RepStatusDesc:%String,RepUser:%String,RepUserName:%String,RepDate:%String,RepTime:%String,CheckUser:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String,RepDemo:%String,RepPlace:%String,RepPlaceDesc:%String")
{
}

ClassMethod QueryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByDateExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, Dep As %String, Loc As %String, Status As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:DateFrom["/" DateFrom=$zdh(DateFrom)
	s:DateTo["/" DateTo=$zdh(DateTo)
	q:(DateFrom="")!(DateTo="") $$$OK
	
    s defHosp=$g(^DHCMedHosptial(0))
    s LocMode=+$p(defHosp,"/",2)
    s:(LocMode=1)&&(Loc="")&&(Dep'="") Loc=Dep,Dep=""
	
	;^DHCMedIR(0,"Date",{MIR_Date},{MIR_Rowid})
	;DateFrom, DateTo, Dep, CtLoc, Status
	Set tmpDate=DateFrom-1
	f  s tmpDate=$o(^DHCMedIR(0,"Date",tmpDate)) q:(tmpDate="")!(tmpDate>DateTo)  d
	.s RepRowid=""
    .f  s RepRowid=$o(^DHCMedIR(0,"Date",tmpDate,RepRowid)) q:RepRowid=""  d
	..;w !,RepRowid
	..s sReport=##class(web.DHCMedInfectionRepCtl).GetInfRep(RepRowid)
	..s repStatus=$p(sReport,"^",12)
	..q:Status'[repStatus
	..s paadm=$p(sReport,"^",2)
	..q:paadm=""
	..s AdmLocId="",AdmDepId=""
	..s AdmLocId=$p($g(^PAADM(+paadm)),"^",4)
	..s AdmWardId=$p($g(^PAADM(+paadm)),"^",70)
	..s:AdmLocId'="" AdmDepId=$p($g(^CTLOC(+AdmLocId)),"^",19)
	..q:(Loc'="")&&(Loc'=AdmLocId)
	..;q:(Loc'="")&&(Loc'=AdmWardId)
	..q:(Dep'="")&&(Dep'=AdmDepId)
	..s sPaadm=##class(web.DHCMedBasePaadmCtl).GetAdmInfo(paadm)
	..s ret=..BuildRepList(RepRowid)
	..q:ret=""
	..s ^CacheTemp(repid,ind)=ret
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query QueryByDate(DateFrom As %String, DateTo As %String, Dep As %String, Loc As %String, Status As %String) As %Query(ROWSPEC = "RepRowId:%String,Papmi:%String,paadm:%String,PatNo:%String,PatName:%String,RepExcerpta:%String,CtLocDesc:%String,WardDesc:%String,RepStatusCode:%String,RepStatusDesc:%String,RepUser:%String,RepUserName:%String,RepDate:%String,RepTime:%String,CheckUser:%String,CheckUserName:%String,CheckDate:%String,CheckTime:%String,RepDemo:%String,RepPlace:%String,RepPlaceDesc:%String")
{
}

ClassMethod QueryInfAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInfAppExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, Dep As %String, Loc As %String, Status As %String, Place As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	q:(DateFrom="")!(DateTo="") $$$OK
	
	s defHosp=$g(^DHCMedHosptial(0))
    s LocMode=+$p(defHosp,"/",2)
    s:(LocMode=1)&&(Loc="")&&(Dep'="") Loc=Dep,Dep=""
	
	;^DHCMedIA(0,"Date1",{MIFA_Date1},{MIFA_Rowid})
	;DateFrom,DateTo,Dep,Loc,Status,Place
	S tmpDate=DateFrom-1
    f  s tmpDate=$o(^DHCMedIA(0,"Date1",tmpDate)) q:(tmpDate="")||(tmpDate>DateTo)  d
	.s TmpRowid=""
	.f  s TmpRowid=$o(^DHCMedIA(0,"Date1",tmpDate,TmpRowid)) q:(TmpRowid="")  d
	..s s=$g(^DHCMedIA(+TmpRowid))
	..q:s=""
	..q:..CheckOption(s,Dep,Loc,Status,Place)'=1
	..d ..BuildDataInfApp(repid,ind,TmpRowid)
	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryInfAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfAppExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// d ##Class(%ResultSet).RunQuery("web.DHCMedInfectionRepQry","QueryInfApp",DateFrom,DateTo,Dep,Loc,Status,Place)
Query QueryInfApp(DateFrom As %String, DateTo As %String, Dep As %String, Loc As %String, Status As %String, Place As %String) As %Query(ROWSPEC = "AppRowid:%String,Paadm:%String,Points:%String,InfDesc1Dr:%String,Diagnose:%String,Report:%String,Nature:%String,User1:%String,Date1:%String,Time1:%String,InfDesc2Dr:%String,User2:%String,Date2:%String,Time2:%String,Demo:%String,AppStatus:%String,Width:%String,DIARowid1:%String,DIAICD1:%String,DIAName1:%String,DIAType1:%String,DIAActive1:%String,DIADemo1:%String,DIAAlias1:%String,DIARowid2:%String,DIAICD2:%String,DIAName2:%String,DIAType2:%String,DIAActive2:%String,DIADemo2:%String,DIAAlias2:%String,Paadm:%String,AdmType:%String,AdmNo:%String,AdmDate:%String,AdmTime:%String,Papmi:%String,LocDesc:%String,DocDesc:%String,WardDesc:%String,RoomDesc:%String,BedDesc:%String,DischgDate:%String,DischgTime:%String,PapmiNo:%String,Name:%String,Sex:%String,BirthDate:%String,Age:%String,ReportId:%String")
{
}

ClassMethod CheckOption(s, cDep, cLoc, cStatus, cPlace)
{
	n (s,cDep,cLoc,cStatus,cPlace)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$CheckOption^DHCMedInfectionApp(s,cDep,cLoc,cStatus,cPlace)
	zn CurrentNS
	q ret
}

ClassMethod BuildDataInfApp(repid, ind, InfAppId)
{
	n (repid,ind,InfAppId)
	s tmpApp=..GetApp(InfAppId)
	s AppInfo=$p(tmpApp,$c(2),1)
	s Dia1=$p(tmpApp,$c(2),2)
	s Dia2=$p(tmpApp,$c(2),3)
	s PaadmInfo=$p(tmpApp,$c(2),4)
	
	Set Data=$lb("")
	
	//评价信息
	Set $li(Data,1)=$p(AppInfo,"^",1)   // AppRowid/ID
	Set $li(Data,2)=$p(AppInfo,"^",2)   // Paadm/Adm
	Set $li(Data,3)=$p(AppInfo,"^",3)   // Points/Points
	Set $li(Data,4)=$p(AppInfo,"^",4)   // InfDesc1Dr/初评感染
	Set $li(Data,5)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("InfectionDiagnoseEvaluation",$p(AppInfo,"^",5))     // Diagnose/诊断评价
	Set $li(Data,6)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("InfectionReportQuality",$p(AppInfo,"^",6))     // Report/报告评价
	Set $li(Data,7)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("InfectionReportEvaluation",$p(AppInfo,"^",7))     // Nature/评价性质
	Set $li(Data,8)=$p(AppInfo,"^",8)   // User1/初评人员
	Set $li(Data,9)=$p(AppInfo,"^",9)  // Date1/初评日期
	Set $li(Data,10)=$p(AppInfo,"^",10) // Time1/初评时间
	Set $li(Data,11)=$p(AppInfo,"^",11) // InfDesc2Dr/终评感染
	Set $li(Data,12)=$p(AppInfo,"^",12) // User2/终评人员
	Set $li(Data,13)=$p(AppInfo,"^",13) // Date2/终评日期
	Set $li(Data,14)=$p(AppInfo,"^",14) // Time2/终评时间
	Set $li(Data,15)=$p(AppInfo,"^",15) // Demo/备注
	Set $li(Data,16)=##Class(web.DHCMedDictoryCtl).GetByTypeCode("InfectionEvaluationStatus",$p(AppInfo,"^",16))     // AppStatus/评价状态
	Set $li(Data,17)=$p(AppInfo,"^",17) // Width/严重程度
 	
 	//初评诊断
 	Set $li(Data,18)=$p(Dia1,"^",1)     // DIARowid1/ID
	Set $li(Data,19)=$p(Dia1,"^",2)     // DIAICD1/ICD
	Set $li(Data,20)=$p(Dia1,"^",3)     // DIAName1/疾病名称
	Set $li(Data,21)=$p(Dia1,"^",4)     // DIAType1/类型
	Set $li(Data,22)=$p(Dia1,"^",5)     // DIAActive1/有效状态
	Set $li(Data,23)=$p(Dia1,"^",6)     // DIADemo1/备注
	Set $li(Data,24)=$p(Dia1,"^",7)     // DIAAlias1/拼音
	
 	//终评诊断
 	Set $li(Data,25)=$p(Dia2,"^",1)     // DIARowid2/ID
	Set $li(Data,26)=$p(Dia2,"^",2)     // DIAICD2/ICD
	Set $li(Data,27)=$p(Dia2,"^",3)     // DIAName2/疾病名称
	Set $li(Data,28)=$p(Dia2,"^",4)     // DIAType2/类型
	Set $li(Data,29)=$p(Dia2,"^",5)     // DIAActive2/有效状态
	Set $li(Data,30)=$p(Dia2,"^",6)     // DIADemo2/备注
	Set $li(Data,31)=$p(Dia2,"^",7)     // DIAAlias2/拼音
	
	//就诊信息和病人基本信息
 	//TMP=paadm_"^"_AdmType_"^"_AdmNo_"^"_AdmDate_"^"_AdmTime_"^"_papmi_"^"_LocDesc_"^"_DocDesc_"^"_WardDesc_"^"_RoomDesc_"^"_BedDesc_"^"_DischgDate_"^"_DischgTime
 	//PaadmInfo=TMP_"^"_papmino_"^"_name_"^"_sex_"^"_birthdate_"^"_age
	Set $li(Data,32)=$p(PaadmInfo,"^",1)   // Paadm
	Set $li(Data,33)=$p(PaadmInfo,"^",2)   // AdmType
	Set $li(Data,34)=$p(PaadmInfo,"^",3)   // AdmNo
	Set $li(Data,35)=$p(PaadmInfo,"^",4)   // AdmDate
	Set $li(Data,36)=$p(PaadmInfo,"^",5)   // AdmTime
	Set $li(Data,37)=$p(PaadmInfo,"^",6)   // Papmi
	Set $li(Data,38)=$p(PaadmInfo,"^",7)   // LocDesc
	Set $li(Data,39)=$p(PaadmInfo,"^",8)   // DocDesc
	Set $li(Data,40)=$p(PaadmInfo,"^",9)   // WardDesc
	Set $li(Data,41)=$p(PaadmInfo,"^",10)  // RoomDesc
	Set $li(Data,42)=$p(PaadmInfo,"^",11)  // BedDesc
	Set $li(Data,43)=$p(PaadmInfo,"^",12)  // DischgDate
	Set $li(Data,44)=$p(PaadmInfo,"^",13)  // DischgTime
	Set $li(Data,45)=$p(PaadmInfo,"^",14)  // PapmiNo
	Set $li(Data,46)=$p(PaadmInfo,"^",15)  // Name
	Set $li(Data,47)=$p(PaadmInfo,"^",16)  // Sex
	Set $li(Data,48)=$p(PaadmInfo,"^",17)  // BirthDate
	Set $li(Data,49)=$p(PaadmInfo,"^",18)  // Age
	
	;^DHCMedIR(0,"PAADM",{MIR_Paadm_DR},{MIR_Rowid})
	Set Paadm=+$p(AppInfo,"^",2)
	Set ReportId=$o(^DHCMedIR(0,"PAADM",+Paadm,""),-1)
	Set $li(Data,50)=ReportId              // ReportId/院感报告ID
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod GetApp(AppRowid)
{
	n (AppRowid)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s ret=$$GetApp^DHCMedInfectionApp(AppRowid)
	zn CurrentNS
	q ret
}

}
