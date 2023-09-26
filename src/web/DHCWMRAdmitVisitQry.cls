Import SQLUser

Class web.DHCWMRAdmitVisitQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 117;

/// 住院病人信息明细查询
/// 查询条件 DateFrom     开始日期
///          DateTo       结束日期
///          DateType     日期类型（1--入院日期/2--出院日期）
///          RegNo        登记号
///          Name         姓名
///          Dep          住院科室
///          Ward         住院病区
ClassMethod GetAdmitVisitDetail(JIndex, DateFrom, DateTo, DateType, RegNo, PatName, Dep, Ward)
{
	n (JIndex,DateFrom,DateTo,DateType,RegNo,PatName,Dep,Ward)
	s ret=-1
	q:((DateFrom="")||(DateTo="")) ret   ;系统日期表示形式
	s:PatName'="" PatName=$zcvt(PatName,"U")
	
	;按登记号查询
	i RegNo'="" d
	.;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	.s Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	.;w !,"Condition01:",JIndex,"---",Papmi,"---",DateFrom,"---", DateTo,"---", DateType,"---",Dep,"---", Ward
	.s ret=$$ProcGetDetail01(JIndex,Papmi,DateFrom, DateTo, DateType,Dep, Ward)
	q:RegNo'="" ret
	
	;按姓名查询
	i PatName'="" d
	.s tmpPapmi=0
	.f  s tmpPapmi=$o(^PAPERi("PAPER_PatName",PatName,tmpPapmi)) q:tmpPapmi=""  d
	..;w !,"Condition02:",JIndex,"---",tmpPapmi,"---",DateFrom,"---", DateTo,"---", DateType,"---",Dep,"---", Ward
	..s ret=$$ProcGetDetail01(JIndex,tmpPapmi,DateFrom, DateTo, DateType,Dep, Ward)
	.q:ret>0
	.s tmpPatName=PatName
	.f  s tmpPatName=$o(^PAPERi("PAPER_PatName",tmpPatName)) q:(tmpPatName="")||(tmpPatName'[PatName)  d
	..s tmpPapmi=0
	..f  s tmpPapmi=$o(^PAPERi("PAPER_PatName",PatName,tmpPapmi)) q:tmpPapmi=""  d
	...;w !,"Condition02:",JIndex,"---",Papmi,"---",DateFrom,"---", DateTo,"---", DateType,"---",Dep,"---", Ward
	...s ret=$$ProcGetDetail01(JIndex,Papmi,DateFrom, DateTo, DateType,Dep, Ward)
	q:PatName'="" ret
	
	i DateType=1 d
	.;w !,"Conditions03:",JIndex,"---",DateFrom,"---",DateTo,"---",DateType,"---",Dep,"---",Ward
	.s ret=$$ProcGetDetail02(JIndex,DateFrom, DateTo, DateType,Dep, Ward)
	q:ret>0 ret
	
    i DateType=2 d
    .;w !,"Conditions04:",JIndex,"---",DateFrom,"---",DateTo,"---",DateType,"---",Dep,"---",Ward
    .s ret=$$ProcGetDetail02(JIndex,DateFrom, DateTo, DateType,Dep, Ward)
	q:ret>0 ret
	
	q ret
	
ProcGetDetail01(JIndex,Papmi,DateFrom, DateTo, DateType,Dep, Ward)
    n (JIndex,Papmi,DateFrom, DateTo, DateType,Dep, Ward)
    s ret=-1
    q:Papmi="" ret
	;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	s tmpRowid=""
	f  s tmpRowid=$o(^PAPERdr(Papmi,"ADM","I",tmpRowid)) q:tmpRowid=""  d
	.;^PAADMi("PAADM_Type",{PAADM_Type},{PAADM_RowID})
	.q:'$d(^PAADMi("PAADM_Type","I",+tmpRowid))
	.;^PAADMi("PAADM_VisitStatus",{PAADM_VisitStatus},{PAADM_RowID})
	.q:('$d(^PAADMi("PAADM_VisitStatus","A",+tmpRowid))&&('$d(^PAADMi("PAADM_VisitStatus","D",+tmpRowid))))
	.s tmpPaadm=$g(^PAADM(+tmpRowid))
	.s:DateType=1 tmpDate=+$p(tmpPaadm,"^",6)
	.s:DateType=2 tmpDate=+$p(tmpPaadm,"^",17)
	.s tmpDep=$p(tmpPaadm,"^",4)
	.s tmpWard=$p(tmpPaadm,"^",70)
	.s tmpWard=$p($g(^PAWARD(+tmpWard)),"^",5)
	.q:(tmpDate<DateFrom)||(tmpDate>DateTo)
	.q:((Dep'="")&&(Dep'=tmpDep))
	.q:((Ward'="")&&(Ward'=tmpWard))
    .s AVisitRowid=""                                              ;AVisitRowid
    .s BregRowid=""                                                ;BregRowid
    .s tmpRowid1=0
    .;^DHCWMRAV(0,"ADMDr",{WAV_IsActive},{WAV_ADM_Dr},{WAV_Rowid})
    .f  s tmpRowid1=$o(^DHCWMRAV(0,"ADMDr","Y",+tmpRowid,tmpRowid1)) q:tmpRowid1=""  d
    ..q:'$d(^DHCWMRAV(tmpRowid1))
    ..s AVisitRowid=tmpRowid1
    ..s BregRowid=$p($g(^DHCWMRAV(tmpRowid1)),"^",1)
	.s Index=+$g(^CacheTemp(JIndex,"AdmitVisit",0))
	.s Index=Index+1
	.;w !,"Results01:",tmpRowid_"---"_Papmi_"---"_AVisitRowid_"---"_BregRowid
	.s ^CacheTemp(JIndex,"AdmitVisit",Index)=tmpRowid_"^"_Papmi_"^"_AVisitRowid_"^"_BregRowid
	.s ^CacheTemp(JIndex,"AdmitVisit",0)=Index
	s ret=1
	q ret
ProcGetDetail02(JIndex,DateFrom, DateTo, DateType,Dep, Ward)
    n (JIndex,DateFrom, DateTo, DateType,Dep, Ward)
    
    s:DateType=1 tmpSTR="PAADM_AdmDate"
    s:DateType=2 tmpSTR="DischDate"
    
    s ret=-1
	f tmpDate=DateFrom:1:DateTo d
	.q:'$d(^PAADMi(tmpSTR,tmpDate))
	.s tmpRowid=0
	.;^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	.;^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	.f  s tmpRowid=$o(^PAADMi(tmpSTR,tmpDate,tmpRowid)) q:tmpRowid=""  d
	..;^PAADMi("PAADM_Type",{PAADM_Type},{PAADM_RowID})
	..q:'$d(^PAADMi("PAADM_Type","I",+tmpRowid))
	..;^PAADMi("PAADM_VisitStatus",{PAADM_VisitStatus},{PAADM_RowID})
	..q:('$d(^PAADMi("PAADM_VisitStatus","A",+tmpRowid))&&('$d(^PAADMi("PAADM_VisitStatus","D",+tmpRowid))))
	..s tmpPaadm=$g(^PAADM(+tmpRowid))
	..s tmpPapmi=+$p(tmpPaadm,"^",1)
	..s Paadm=+tmpRowid                                             ;Paadm
	..s Papmi=tmpPapmi                                              ;Papmi
    ..s tmpDep=$p(tmpPaadm,"^",4)
    ..q:((Dep'="")&&(Dep'=tmpDep))
    ..s tmpWard=$p(tmpPaadm,"^",70)
    ..s tmpWard=$p($g(^PAWARD(+tmpWard)),"^",5)
    ..q:((Ward'="")&&(Ward'=tmpWard))
    ..s AVisitRowid=""                                              ;AVisitRowid
    ..s BregRowid=""                                                ;BregRowid
    ..s tmpRowid1=0
    ..;^DHCWMRAV(0,"ADMDr",{WAV_IsActive},{WAV_ADM_Dr},{WAV_Rowid})
    ..f  s tmpRowid1=$o(^DHCWMRAV(0,"ADMDr","Y",Paadm,tmpRowid1)) q:tmpRowid1=""  d
    ...q:'$d(^DHCWMRAV(tmpRowid1))
    ...s AVisitRowid=tmpRowid1
    ...s BregRowid=$p($g(^DHCWMRAV(tmpRowid1)),"^",1)
	..s Index=+$g(^CacheTemp(JIndex,"AdmitVisit",0))
	..s Index=Index+1
	..;w !,"Results02:",tmpRowid_"---"_Papmi_"---"_AVisitRowid_"---"_BregRowid
	..s ^CacheTemp(JIndex,"AdmitVisit",Index)=tmpRowid_"^"_Papmi_"^"_AVisitRowid_"^"_BregRowid
	..s ^CacheTemp(JIndex,"AdmitVisit",0)=Index
    s ret=1
    q ret
}

ClassMethod BuildData(repid, ind, Paadm, Papmi, AdmitVisitRowid, BregRowid)
{
	n (repid, ind, Paadm,Papmi,AdmitVisitRowid,BregRowid)
	
	//set tmpPatInfo=##class(web.DHCMedBaseCtl).GetPatInfo(Papmi)
	set tmpPatInfo=##class(web.DHCMedBaseCtl).GetPatInfoTMP(Papmi)
	set:tmpPatInfo'="" tmpPatInfo=$tr(tmpPatInfo,$c(2),"^")
	set tmpPaadm=##Class(web.DHCWMRBasePaadm).GetAdmInfo(Paadm)
	set tmpAdmitVisit=##Class(web.DHCWMRAdmitVisitCtl).GetAdmitVisit(AdmitVisitRowid)
	set tmpAdmitNursingList=##Class(web.DHCWMRAdmitVisitCtl).GetAdmitNursingList(AdmitVisitRowid)
	s tmpAdmitNursing=""
	f i=1:1:$l(tmpAdmitNursingList,"^") d
	.s tmp=$p(tmpAdmitNursingList,"^",i)
	.s tmp=$p(tmp,"/",3)
	.q:tmp=""
	.i tmpAdmitNursing'="" d
	..s tmpAdmitNursing=tmpAdmitNursing_" "_tmp
	.e  d
	..s tmpAdmitNursing=tmp
	set tmpAdmitCaseList=##Class(web.DHCWMRAdmitVisitCtl).GetAdmitCaseList(AdmitVisitRowid)
	s tmpAdmitCase=""
	f i=1:1:$l(tmpAdmitCaseList,"^") d
	.s tmp=$p(tmpAdmitCaseList,"^",i)
	.s tmp=$p(tmp,"/",3)
	.s:tmpAdmitCase'="" tmpAdmitCase=tmpAdmitCase_" "_tmp
	.s:tmpAdmitCase="" tmpAdmitCase=tmp
	set tmpBreg=##Class(web.DHCWMRAdmitVisitCtl).GetBregInfo(BregRowid)
	
	Set Data=$lb("")
	
	;病人基本信息
	set $li(Data,1)=$p(tmpPatInfo,"^",22)      ;Papmi
	set $li(Data,2)=$p(tmpPatInfo,"^",23)      ;RegNo
	set $li(Data,3)=$p(tmpPatInfo,"^",1)       ;PatName
	set $li(Data,4)=$p(tmpPatInfo,"^",2)       ;Sex
	set $li(Data,5)=$p(tmpPatInfo,"^",3)       ;Birthdate
	set tmp=$p(tmpPatInfo,"^",4)
	set:tmp["岁" tmp=$p(tmp,"岁",1)
	set $li(Data,6)=tmp                        ;Age
	set $li(Data,7)=$p(tmpPatInfo,"^",6)       ;ProvinceCity
	set $li(Data,8)=$p(tmpPatInfo,"^",7)       ;MaritalDesc
	set $li(Data,9)=$p(tmpPatInfo,"^",8)       ;NationDesc
	set $li(Data,10)=$p(tmpPatInfo,"^",9)      ;Telphone
	set $li(Data,11)=$p(tmpPatInfo,"^",10)     ;EducationDesc
	set $li(Data,12)=$p(tmpPatInfo,"^",11)     ;WorkAddress
	set $li(Data,13)=$p(tmpPatInfo,"^",19)     ;CountryDesc
	set $li(Data,14)=$p(tmpPatInfo,"^",20)     ;MrNo  病案号
	set $li(Data,15)=$p(tmpPatInfo,"^",21)     ;SocialDesc
	
	;就诊信息
	set $li(Data,16)=$p(tmpPaadm,"^",1)       ;Paadm
	set $li(Data,17)=$p(tmpPaadm,"^",2)       ;AdmType
	set $li(Data,18)=$p(tmpPaadm,"^",3)       ;AdmNo
	set $li(Data,19)=$p(tmpPaadm,"^",4)       ;AdmDate
	set $li(Data,20)=$p(tmpPaadm,"^",5)       ;AdmTime
	set $li(Data,21)=$p(tmpPaadm,"^",6)       ;AdmPapmi
	set tmp=$p(tmpPaadm,"^",7)
	set:$p(tmp,"/",2)'="" tmp=$p(tmp,"/",2)
	set $li(Data,22)=tmp                      ;DepDesc
	set tmp=$p(tmpPaadm,"^",9)
	set:tmp["-" tmp=$p(tmp,"-",2)
	set $li(Data,23)=tmp                      ;WardDesc
	set tmp=$p(tmpPaadm,"^",10)
	set:tmp["病" tmp=$p(tmp,"病",2)
	set $li(Data,24)=tmp                      ;RoomDesc
	set $li(Data,25)=$p(tmpPaadm,"^",11)      ;BedDesc
	set tmp=$p(tmpPaadm,"^",8)
	set:$p(tmp,"/",3)'="" tmp=$p(tmp,"/",3)
	set $li(Data,26)=tmp                      ;DocDesc
	set $li(Data,27)=$p(tmpPaadm,"^",12)      ;DischgDate
	set $li(Data,28)=$p(tmpPaadm,"^",13)      ;DischgTime
	set $li(Data,29)=$p(tmpPaadm,"^",14)      ;VisitStatus
	
	;电子住院证信息
	set $li(Data,30)=$p(tmpBreg,"^",1)        ;BregRowid
	set tmp=$p($p(tmpBreg,"^",27),"/",2)
	set $li(Data,31)=tmp                      ;BregType
	set $li(Data,32)=$p(tmpBreg,"^",5)        ;BregDate  登记日期
	set tmp=$p($p(tmpBreg,"^",6),"/",2)
	set $li(Data,33)=tmp                      ;BregDep   接收科室
	set tmp=$p($p(tmpBreg,"^",16),"/",2)
	set $li(Data,34)=tmp                      ;BregWard  接收病区
	set tmp=$p($p(tmpBreg,"^",8),"/",2)
	set tmp=tmp_" "_$p(tmpBreg,"^",4)
	set $li(Data,35)=tmp                      ;BregDiagnose
	set $li(Data,36)=$p(tmpBreg,"^",7)        ;BregDeposit   押金
	set tmp=$p($p(tmpBreg,"^",12),"/",2)
	set $li(Data,37)=tmp                      ;BregUrgent   患者病情
	set $li(Data,38)=$p(tmpBreg,"^",25)       ;BregCarryType
	set $li(Data,39)=$p(tmpBreg,"^",28)       ;BregJob  在职/非在职
	set tmp=$p($p(tmpBreg,"^",17),"/",2)
	set $li(Data,40)=tmp                      ;BregHos  曾否住院
	set $li(Data,41)=$p(tmpBreg,"^",20)       ;BregTDate
	set tmp=$p($p(tmpBreg,"^",21),"/",2)
	set $li(Data,42)=tmp                      ;BregTUser
	set $li(Data,43)=$p(tmpBreg,"^",18)       ;BregDDate
	set tmp=$p($p(tmpBreg,"^",19),"/",2)
	set $li(Data,44)=tmp                      ;BregDUser
	
	;接诊信息
	set $li(Data,45)=$p(tmpAdmitVisit,"^",1)      ;AdmitVisitRowid
	set tmp=$p(tmpAdmitVisit,"^",4)
	set:$p(tmp,"/",3)'="" tmp=$p(tmp,"/",3)
	set $li(Data,46)=tmp                          ;AdmitUser
	set $li(Data,47)=$p(tmpAdmitVisit,"^",5)      ;AdmitDate
	set $li(Data,48)=$p(tmpAdmitVisit,"^",6)      ;AdmitTime
	set tmp=$p(tmpAdmitVisit,"^",7)
	set:$p(tmp,"/",3)'="" tmp=$p(tmp,"/",3)
	set $li(Data,49)=tmp                          ;EscortUser
	set $li(Data,50)=$p(tmpAdmitVisit,"^",8)      ;EscortDate
	set $li(Data,51)=$p(tmpAdmitVisit,"^",9)      ;EscortTime
	set $li(Data,52)=$p(tmpAdmitVisit,"^",10)     ;AdmitResume
	set tmp=$p(tmpAdmitVisit,"^",12)
	set:$p(tmp,"/",3)'="" tmp=$p(tmp,"/",3)
	set $li(Data,53)=tmp                          ;AdmitStatus
	
	;接诊护理
	set $li(Data,54)=tmpAdmitNursing              ;AdmitNursing   
	
	;接诊住院病历
	set $li(Data,55)=tmpAdmitCase                 ;AdmitCase
	
	set $li(Data,56)=ind                          ;iRow
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryAdmitVisitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmitVisitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAdmitVisitExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, DateType As %String, RegNo As %String, PatName As %String, Dep As %String, Ward As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s JIndex=$j
	q:(DateFrom="")||(DateTo="") $$$OK
	q:DateType="" $$$OK
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	i +RegNo'=0 d
	.s RegNo=+RegNo
	.f i=1:1:(8-$l(RegNo)) d
	..s RegNo="0"_RegNo
	
	;执行查询操作
	k ^CacheTemp(JIndex,"AdmitVisit")
	s ret=..GetAdmitVisitDetail(JIndex,DateFrom, DateTo, DateType, RegNo, PatName, Dep, Ward)
	q:ret<0 $$$OK
	s Paadm=$p(ret,"^",1)
	s Papmi=$p(ret,"^",2)
	s AdmitVisitRowid=$p(ret,"^",3)
	s BregRowid=$p(ret,"^",4)
	
	s Index=0
	f  s Index=$o(^CacheTemp(JIndex,"AdmitVisit",Index)) q:Index=""  d
    .s tmp=$g(^CacheTemp(JIndex,"AdmitVisit",Index))
    .s Paadm=$p(tmp,"^",1)
    .s Papmi=$p(tmp,"^",2)
    .s AdmitVisitRowid=$p(tmp,"^",3)
    .s BregRowid=$p(tmp,"^",4)
    .//w !,"CacheTemp:"_Paadm_"---"_Papmi_"---"_AdmitVisitRowid_"---"_BregRowid
    .d ..BuildData(repid, ind,Paadm, Papmi, AdmitVisitRowid, BregRowid)
    .s ind=ind+1
    
    k ^CacheTemp(JIndex,"AdmitVisit")
    q $$$OK
}

ClassMethod QueryAdmitVisitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmitVisitExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCWMRAdmitVisitQry","QueryAdmitVisit","2008-01-01","2007-07-30",1,"","","",2261)
Query QueryAdmitVisit(DateFrom As %String, DateTo As %String, DateType As %String, RegNo As %String, PatName As %String, Dep As %String, Ward As %String) As %Query(ROWSPEC = "Papmi:%String,RegNo:%String,PatName:%String,Sex:%String,Birthdate:%String,Age:%String,ProvinceCity:%String,MaritalDesc:%String,NationDesc:%String,Telphone:%String,EducationDesc:%String,WorkAddress:%String,CountryDesc:%String,MrNo:%String,SocialDesc:%String,Paadm:%String,AdmType:%String,AdmNo:%String,AdmDate:%String,AdmTime:%String,AdmPapmi:%String,DepDesc:%String,WardDesc:%String,RoomDesc:%String,BedDesc:%String,DocDesc:%String,DischgeDate:%String,DischgTime:%String,VisitStatus:%String,BregRowid:%String,BregType:%String,BregDate:%String,BregDep:%String,BregWard:%String,BregDiagnose:%String,BregDeposit:%String,BregUrgent:%String,BregCarryType:%String,BregJob:%String,BregHos:%String,BregTDate:%String,BregTUser:%String,BregDDate:%String,BregDUser:%String,AdmitVisitRowid:%String,AdmitUser:%String,AdmitDate:%String,AdmitTime:%String,EscortUser:%String,EscortDate:%String,EscortTime:%String,AdmitResume:%String,AdmitStatus:%String,AdmitNursing:%String,AdmitCase:%String,iRow:%String")
{
}

ClassMethod QueryIPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryIPListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryIPListExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, RegNo As %String, IsAdmit As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s JIndex=$j
	q:(DateFrom="")||(DateTo="") $$$OK
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s DateFrom=+DateFrom
	s DateTo=+DateTo
	s:IsAdmit'="" IsAdmit=$s(IsAdmit["Y":"Y",1:"N")
	i +RegNo'=0 d
	.s RegNo=+RegNo
	.f i=1:1:(8-$l(RegNo)) d
	..s RegNo="0"_RegNo
	e  d
	.s RegNo=""
	
	;^dhczybreg(0,"DDATE",{zyb_ddate},{zyb_dep_dr},{zyb_rowid})
	f DDate=DateFrom:1:DateTo d
	.q:'$d(^dhczybreg(0,"DDATE",DDate))
	.s DepId=0
	.f  s DepId=$o(^dhczybreg(0,"DDATE",DDate,DepId)) q:DepId=""  d
	..s Id=0
	..f  s Id=$o(^dhczybreg(0,"DDATE",DDate,DepId,Id)) q:Id=""  d
    ...s Papmi=+$p($g(^dhczybreg(Id)),"^",1)
    ...s BregStatus=$p($g(^dhczybreg(Id)),"^",9)
    ...q:BregStatus'=5   //5-到达状态
    ...s xPapmi=""
    ...s:RegNo'="" xPapmi=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
    ...q:(xPapmi'="")&&(Papmi'=xPapmi)
    ...;^DHCWMRAV(0,"BregDr",{WAV_IsActive},{WAV_Breg_Dr},{WAV_Rowid})
    ...s AdmitId=$o(^DHCWMRAV(0,"BregDr","Y",Id,0))
    ...s tmpIsAdmit=$s(AdmitId="":"N",1:"Y")
    ...q:(IsAdmit'="")&&(IsAdmit'=tmpIsAdmit)
    ...d ..BuildData(repid, ind,"", Papmi, AdmitId, Id)
    ...s ind=ind+1
    
    q $$$OK
}

ClassMethod QueryIPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIPListExecute ]
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

/// 查询办完住院登记病人列表
/// 参数：
/// DateFrom   起始日期
/// DateTo     截止日期
/// RegNo      登记号
/// IsAdmit    是否显示接诊过的病人
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRAdmitVisitQry","QueryIPList","2008-07-01","2008-07-30","","Y")
Query QueryIPList(DateFrom As %String, DateTo As %String, RegNo As %String, IsAdmit As %String) As %Query(ROWSPEC = "Papmi:%String,RegNo:%String,PatName:%String,Sex:%String,Birthdate:%String,Age:%String,ProvinceCity:%String,MaritalDesc:%String,NationDesc:%String,Telphone:%String,EducationDesc:%String,WorkAddress:%String,CountryDesc:%String,MrNo:%String,SocialDesc:%String,Paadm:%String,AdmType:%String,AdmNo:%String,AdmDate:%String,AdmTime:%String,AdmPapmi:%String,DepDesc:%String,WardDesc:%String,RoomDesc:%String,BedDesc:%String,DocDesc:%String,DischgeDate:%String,DischgTime:%String,VisitStatus:%String,BregRowid:%String,BregType:%String,BregDate:%String,BregDep:%String,BregWard:%String,BregDiagnose:%String,BregDeposit:%String,BregUrgent:%String,BregCarryType:%String,BregJob:%String,BregHos:%String,BregTDate:%String,BregTUser:%String,BregDDate:%String,BregDUser:%String,AdmitVisitRowid:%String,AdmitUser:%String,AdmitDate:%String,AdmitTime:%String,EscortUser:%String,EscortDate:%String,EscortTime:%String,AdmitResume:%String,AdmitStatus:%String,AdmitNursing:%String,AdmitCase:%String,iRow:%String")
{
}

}
