/// 名称: DHCMed.InfAimService.BaseSrv
/// 描述: 目标性监测的基本操作
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAimService.BaseSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  查询科室
/// Table：       CTLOC
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryCtloc","E")
Query QueryCtloc(InlocType As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryCtlocExecute(ByRef qHandle As %Binary, InlocType As %String) As %Status
{

	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:InlocType=""
	s Rowid=0
	f  s Rowid=$o(^CTLOC(Rowid)) q:Rowid=""  d
	.s LocDesc=$p($g(^CTLOC(Rowid)),"^",2)
	.s LocType=$p($g(^CTLOC(Rowid)),"^",13)
	.q:InlocType'[LocType
	.s Data=$lb(Rowid,LocDesc)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCtlocExecute ]
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
}

/// 查询所有病区
/// d ##Class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryAllWard","","")
Query QueryAllWard(Desc As %String = "", Loc As %String = "") As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryAllWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllWardExecute(ByRef qHandle As %Binary, Desc As %String = "", Loc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)  
	s Desc=$$ALPHAUP^SSUTIL4(Desc) 
	//^PAWARD({WARD_RowID})
	//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})			
	s wardID=0 f  s wardID=$o(^PAWARD(wardID)) q:wardID=""  d
	.s objWard=##class(DHCMed.Base.PacWard).GetObjById(wardID)
	.q:'$IsObject(objWard)
	.//s:objWard.Descs["-" objWard.Descs=$p(objWard.Descs,"-",2)
	.q:(Desc'="")&&($$ALPHAUP^SSUTIL4(objWard.Descs)'[Desc)
	.q:(Loc'="")&&('$d(^CTLOC(Loc,"LINK",0,"Loc",+objWard.CtlocDr)))   //根据科室关联科室表判断病区是否属于Loc科室  CT_LocLinkLocation
    .s $li(data,1)=objWard.Rowid
    .s $li(data,2)=objWard.Descs
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d objWard.%Close()
    .k objWard
	Quit $$$OK
}

ClassMethod QueryAllWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllWardExecute ]
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

/// Creator：     ChenJB
/// CreatDate：   2010-10-15
/// Description:  查询病人信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryPatientInfo","A","","0000000301","","","","","","")
Query QueryPatientInfo(InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CurrentAdmType As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,DoctorName:%String:主管医生,AdmitDate:%String:住院日期,Department:%String:就诊科室,Ward:%String:病区,Room:%String:病室,Bed:%String:病床,DisDate:%String:出院日期")
{
}

ClassMethod QueryPatientInfoExecute(ByRef qHandle As %Binary, InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CurrentAdmType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	k ^CacheTemp("DHCMedInfCtlNew")
	q:$g(InHospital)="" $$$OK
	s:CurrentAdmType="" CurrentAdmType="I"
	s Singleflag=0,AdmitDate=0
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
		
	i ($g(RegNo)'="") d   //登记号不为空
	.s RegNo=+RegNo
	.s Singleflag=1
	.s len=10
	.s PATCFid=$o(^CF("PATCF",""))
	.i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	.i $l(RegNo)<len d
	..s prelen=len-$l(RegNo)
	..f i=1:1:prelen s RegNo="0"_RegNo
	.s PAPMI=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	.q:$g(PAPMI)=""
	.s ret=$$GetInfoFromPAPMI()
	s:Singleflag=1 ^CacheTemp("DHCMedInfCtlNew",0)=ind-1
	q:Singleflag=1 $$$OK
	
	i PatName'=""  d    // 病人姓名不为空
	.s Singleflag=1
    .s PAPMI=0
	.f  s PAPMI=$o(^PAPERi("PAPER_PatName",PatName,PAPMI)) q:+PAPMI=0  d
	..s ret=$$GetInfoFromPAPMI()
	.s tmpPatName=PatName
	.f  s tmpPatName=$o(^PAPERi("PAPER_PatName",tmpPatName)) q:(tmpPatName="")!(tmpPatName'[PatName)  d
	..s PAPMI=0
	..f  s PAPMI=$o(^PAPERi("PAPER_PatName",tmpPatName,PAPMI)) q:+PAPMI=0  d
	...s ret=$$GetInfoFromPAPMI()
	s:Singleflag=1 ^CacheTemp("DHCMedInfCtlNew",0)=ind-1
	q:Singleflag=1 $$$OK
	
	//病案系统接口调用：病案号取病人ID接口
	i MrNo'="" d   // 病案号不为空
	.s Singleflag=1
	.s PatientIDs=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MrNo,"I","","")
	.q:PatientIDs'=""
	.f indPat=1:1:$l(PatientIDs,",") d
	..s PAPMI=$p(PatientIDs,",",indPat)
	..q:PAPMI=""
	..s ret=$$GetInfoFromPAPMI()
	s:Singleflag=1 ^CacheTemp("DHCMedInfCtlNew",0)=ind-1
	q:Singleflag=1 $$$OK
	
	i InHospital="A" d   // 在院
	.i +Ward>0 d   // 病区不为空
	..s Singleflag=1
    ..q:'$d(^PAADMi("CurrWard",+Ward))
    ..s Room="" f  s Room=$o(^PAADMi("CurrWard",+Ward,Room)) q:Room=""  d
    ...s paadm="" f  s paadm=$o(^PAADMi("CurrWard",+Ward,Room,paadm)) q:paadm=""  d
    ....s ret=$$GetPatInfo()
    ....q:((Loc'="")&(Loc'=objAdm.DepartmentID))
    ....s:objAdm.AdmitDate["-" AdmitDate=$zdh(objAdm.AdmitDate,3)
    ....q:((+DateFrom>0)&(AdmitDate<DateFrom))
    ....q:((+DateTo>0)&(AdmitDate>DateTo))
    ....;q:((PatName'="")&(objPatient.PatientName'[PatName))
    ....s ret=$$OutputRow()
    .e  i ((+Loc>0)&(+Ward=0)) d   // 科室不为空，病区为空
    ..s Singleflag=1
    ..s DeptItem=Loc
    ..s:DateFrom'="" Date=DateFrom-1
    ..f i=1:1:$l(CurrentAdmType,"/")  d
    ...s cAdmType=$p(CurrentAdmType,"/",i) 
    ...s Date=""
    ...f  s Date=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date)) q:((Date="")||((DateTo'="")&(Date>DateTo)))  d
    ....s Time=""
    ....f  s Time=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date,Time)) q:(Time="")  d
    .....s paadm=""
    .....f  s paadm=$o(^PAADMi("AdmTypeCurrLoc",cAdmType,DeptItem,Date,Time,paadm)) q:(paadm="")  d
    ......s ret=$$GetPatInfo()
    ......s:objAdm.AdmitDate["-" AdmitDate=$zdh(objAdm.AdmitDate,3)
    ......q:((+DateFrom>0)&(AdmitDate<DateFrom))
    ......q:((+DateTo>0)&(AdmitDate>DateTo))
	......s ret=$$OutputRow()
	.e  d   //查询全院在院患者
	..s DeptItem=""
	..f  s DeptItem=$o(^CTLOC(DeptItem)) q:DeptItem=""  d
	...s LocType=$p($g(^CTLOC(DeptItem)),"^",13)
	...q:LocType'="E"
	...s Date=""
    ...f  s Date=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date)) q:(Date="")  d
    ....s Time=""
    ....f  s Time=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date,Time)) q:(Time="")  d
    .....s paadm=""
    .....f  s paadm=$o(^PAADMi("AdmTypeCurrLoc","I",DeptItem,Date,Time,paadm)) q:(paadm="")  d
    ......s ret=$$GetPatInfo()
    ......s AdmitDate=0
    ......s:objAdm.AdmitDate["-" AdmitDate=$zdh(objAdm.AdmitDate,3)
    ......s:objAdm.AdmitDate["/" AdmitDate=$zdh(objAdm.AdmitDate,4)
    ......q:((+DateFrom>0)&(AdmitDate<DateFrom))
    ......q:((+DateTo>0)&(AdmitDate>DateTo))
    ......s ret=$$OutputRow()
    s:Singleflag=1 ^CacheTemp("DHCMedInfCtlNew",0)=ind-1
    q:Singleflag=1 $$$OK
	
	e  i InHospital="D" d   // 出院
	.//时间段按入院或者出院时间
	.s tmpSTR="PAADM_AdmDate"  
	.// s tmpSTR="DischDate"
	.i ((DateFrom'="")&(DateTo'="")) d     
	..s Singleflag=1
	..s Date=DateFrom
	..f Date=DateFrom:1:DateTo  d
	...s paadm=""
	...q:'$d(^PAADMi(tmpSTR,Date))
	...f  s paadm=$o(^PAADMi(tmpSTR,Date,paadm)) q:paadm=""  d
	....q:'$d(^PAADMi("PAADM_Type","I",+paadm))
	....s ret=$$GetPatInfo()
	....q:((Loc'="")&(Loc'=objAdm.DepartmentID))
	....q:((Ward'="")&(Ward'=objAdm.WardID))
	....s ret=$$OutputRow()
	.e  i ((DateFrom'="")!(DateTo'=""))  d    //查询某天的患者
	..s Date=""
	..i DateFrom'="" d
	...s Date=DateFrom
	..e  d
	...s Date=DateTo
	..s paadm=""
	..f  s paadm=$o(^PAADMi(tmpSTR,Date,paadm)) q:paadm=""  d
	...s ret=$$GetPatInfo()
	...q:((Loc'="")&(Loc'=objAdm.DepartmentID))
	...q:((Ward'="")&(Ward'=objAdm.WardID))
	...s ret=$$OutputRow()
	s:Singleflag=1 ^CacheTemp("DHCMedInfCtlNew",0)=ind-1
	q:Singleflag=1 $$$OK
	s ^CacheTemp("DHCMedInfCtlNew",0)=ind-1
	q $$$OK
	
GetInfoFromPAPMI()
	f FromPAPMIi=1:1:$l(CurrentAdmType,"/")  d
	.s cAdmType=$p(CurrentAdmType,"/",FromPAPMIi) 
	.s paadm=""
	.f  s paadm=$o(^PAPERdr(PAPMI,"ADM",cAdmType,paadm)) q:paadm=""  d
	..s PaadmStatus=$p($g(^PAADM(paadm)),"^",20)
	..q:(PaadmStatus'=InHospital)&(Singleflag'=1)
	..s ret=$$GetPatInfo()
	..s ret=$$OutputRow()
	q 1
GetPatInfo()
   s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
   q:$IsObject(objAdm)=0
   s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
   q:$IsObject(objPatient)=0
   s $li(data,1)=objAdm.AdmRowID
   s ^CacheTemp("DHCMedInfCtlNew",+objAdm.AdmRowID)=""
   s $li(data,2)=objAdm.PatientID
   s $li(data,3)=objPatient.PapmiNo
   s $li(data,4)=objPatient.PatientName
   s $li(data,5)=objPatient.Sex
   s $li(data,6)=objPatient.Age
   s $li(data,7)=objAdm.DoctorName
   s $li(data,8)=objAdm.AdmitDate  
   s $li(data,9)=objAdm.Department
   s:$li(data,9)["-" $li(data,9)=$p($li(data,9),"-",2)
   s $li(data,10)=objAdm.Ward
   //s $li(data,9)=objPatient.PapmiNo
   //s $li(data,10)=objPatient.PatientName
   //s $li(data,11)=objPatient.Sex
   //s $li(data,12)=objPatient.Age
   s $li(data,11)=objAdm.Room
   s $li(data,12)=objAdm.Bed
   s $li(data,13)=objAdm.DisDate
   s:$li(data,13)="1840-12-31" $li(data,13)=""
   
   q 1
OutputRow()
   s ^CacheTemp(repid,ind)=data
   s ind=ind+1
   i $IsObject(objAdm) d 
   .d objAdm.%Close()
   i $IsObject(objPatient) d
   .d objPatient.%Close()
   q 1
}

ClassMethod QueryPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatientInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatientInfoExecute ]
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
}

/// Creator：     liuyh
/// CreatDate：   2011-10-19
/// w ##class(DHCMed.InfAimService.BaseSrv).BuildPatSubJson(31,"")
ClassMethod BuildPatSubJson(LocID As %String, childJson As %String) As %String
{
	new (LocID,childJson)
	set json=""
	set retFlag=0
 	quit:'$d(^PAADMi("CurrLoc",LocID)) "[]"
 	s AdmDate=""
 	f  s AdmDate=$o(^PAADMi("CurrLoc",LocID,AdmDate)) q:AdmDate=""  d
 	.s AdmTime=""
 	.f  s AdmTime=$o(^PAADMi("CurrLoc",LocID,AdmDate,AdmTime)) q:AdmTime=""  d
 	..s paadm=""
 	..f  s paadm=$o(^PAADMi("CurrLoc",LocID,AdmDate,AdmTime,paadm)) q:paadm=""  d
 	...s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
 	...q:'$IsObject(objAdm)
 	...s AdmitDate=objAdm.AdmitDate
 	...s Department=objAdm.Department
 	...s:Department["-" Department=$p(Department,"-",2)
 	...s PatientID=objAdm.PatientID
 	...q:PatientID=""
 	...s Ward=objAdm.Ward
 	...s:Ward["-" Ward=$p(Ward,"-",2)
 	...s Bed=objAdm.Bed
 	...s objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
 	...q:'$IsObject(objPat)
 	...s PatientName=objPat.PatientName
 	...s PapmiNo=objPat.PapmiNo
 	...s Sex=objPat.Sex
 	...s:json'="" json=json_","
	...s json=json_"{"_"""id"":"""_paadm_""",""text"":"""_PapmiNo_" "_PatientName_" 床号："_Bed_" "","
	...;s json=json_"""iconCls"":""icon-pro"","
	...s:Sex="男" json=json_"""iconCls"":""icon-man"","
	...s:Sex="女" json=json_"""iconCls"":""icon-woman"","
	...s json=json_"""leaf"":true"
	...s json=json_"}"
	
	s childJson="["_json_"]"
	q childJson
}

/// Creator：     liuyh
/// CreatDate：   2011-10-19
/// w ##class(DHCMed.InfAimService.BaseSrv).BuildLocPatJson("")
ClassMethod BuildLocPatJson(LocID As %String) As %String
{
	set json="",ind=1
	
	q:'$d(^CTLOC(LocID)) json
	s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	s LocType=$p($g(^CTLOC(LocID)),"^",13)
	s LocDepDR=$p($g(^CTLOC(LocID)),"^",19)
	i LocType="W" d
	.s LocID=$o(^CTLOC(LocID,"LINK",0,"Loc",""),-1)
	
	s CtLocID=0	
	f  s CtLocID=$o(^CTLOC(CtLocID))  q:CtLocID=""  d
	.q:(LocID'="")&(CtLocID'=LocID)
	.s LocDesc=$p($g(^CTLOC(CtLocID)),"^",2)
	.s LocType=$p($g(^CTLOC(CtLocID)),"^",13)
	.q:LocType'="E"
	.s:json'="" json=json_","
	.s itemJson="{"_"""id"":"""_CtLocID_"P"",""text"":"""_LocDesc_""","
	.s:ind=1 itemJson=itemJson_"""expanded"":true,"
	.s:ind'=1 itemJson=itemJson_"""expanded"":false,"
	.s secFlag=0,childJson="[]"
	.b //001
	.d ..BuildPatSubJson(CtLocID,.childJson)
	.s itemJson=itemJson_"""children"":"_childJson_"}"
	.s json=json_itemJson
	.s ind=ind+1
	
	quit "["_json_"]"
}

/// w ##class(DHCMed.InfAimService.BaseSrv).GetPatInfoByPaadm(1)
ClassMethod GetPatInfoByPaadm(paadm As %String) As %String
{
	n (paadm)
	
	s ret=""
	q:paadm="" ret
	
	s AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	q:'$IsObject(AdmObj) ret
	s AdmDate=AdmObj.AdmitDate	
	s Ward=AdmObj.Ward
	s:Ward["-" Ward=$p(Ward,"-",2)
	s Bed=AdmObj.Bed
	s PatientID=AdmObj.PatientID
	
	q:PatientID="" ret
	s PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	q:'$IsObject(PatObj)
	s PatientName=PatObj.PatientName
	s Sex=PatObj.Sex
	s Age=PatObj.Age
	s PapmiNo=PatObj.PapmiNo
	
	s ret="姓名："_PatientName_" 登记号："_PapmiNo_" 就诊日期："_AdmDate_" 病区："_Ward_" 床号："_Bed
	
	q ret
}

/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryAdmTran",1)
Query QueryAdmTran(paadm As %String) As %Query(ROWSPEC = "rowid:%String,LocDesc:%String")
{
}

ClassMethod QueryAdmTranExecute(ByRef qHandle As %Binary, paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	q:paadm="" $$$OK
	
	s rowid=0,Num=""
	f  s rowid=$o(^PAADM(paadm,"TRANS",rowid)) q:rowid=""  d
	.s LocID=$p(^PAADM(paadm,"TRANS",rowid),"^",6)
	.q:LocID=""
	.q:LocID=Num
	.s Num=LocID		//科室相同
	.s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
	.q:'$IsObject(LocObj)
	.s LocDesc=LocObj.Descs
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s StartDate=$p(^PAADM(paadm,"TRANS",rowid),"^",1)
	.s:StartDate'="" StartDate=$zd(StartDate,3)
	.s StartTime=$p(^PAADM(paadm,"TRANS",rowid),"^",2)
	.s:StartTime'="" StartTime=$zt(StartTime,3)
	.s SubID=paadm_"||"_rowid
	.s Data=$lb(SubID,LocDesc_"  转入时间："_StartDate_" "_StartTime)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryAdmTranClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmTranExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAdmTranFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmTranExecute ]
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
}

/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryUserInfo","刘")
Query QueryUserInfo(alias As %String) As %Query(ROWSPEC = "tmpid:%String,Name:%String")
{
}

ClassMethod QueryUserInfoExecute(ByRef qHandle As %Binary, alias As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s alias=$ZCVT(alias,"u")
	s tmpid=$o(^SSU("SSUSR",""))
	f  s tmpid=$o(^SSU("SSUSR",tmpid)) q:tmpid=""  d
	.s flag=0
	.s code=$p($g(^SSU("SSUSR",+tmpid)),"^",1)
	.s name=$p($g(^SSU("SSUSR",+tmpid)),"^",2)
	.s mailName=$p($g(^SSU("SSUSR",+tmpid)),"^",11)
	.s:$ZCVT(code,"u")[alias flag=1
    .s:$ZCVT(name,"u")[alias flag=1
	.s:$ZCVT(mailName,"u")[alias flag=1
	.s SSUSRCareProvDR=$p($g(^SSU("SSUSR",+tmpid)),"^",14)
	.q:SSUSRCareProvDR=""
	.s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)
	.q:CTPCPCarPrvTpDR=""
	.s UserType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
	.q:(UserType'="DOCTOR")&&(UserType'="NURSE")
	.s CTPCP=##class(User.CTCareProv).%OpenId(SSUSRCareProvDR)
	.q:'$IsObject(CTPCP)
	.s OtherName=CTPCP.CTPCPOtherName
	.s:(OtherName'="")&($ZCVT(OtherName,"u")[alias) flag=1
	.q:flag'=1
	.d CTPCP.%Close()
	.s obj=##class(DHCMed.Base.SSUser).GetObjById(tmpid)
	.q:'$IsObject(obj)
	.s Name=obj.Name
	.s Data=$lb(tmpid,Name)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserInfoExecute ]
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
}

/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryDocUserInfo","刘")
Query QueryDocUserInfo(alias As %String) As %Query(ROWSPEC = "tmpid:%String,Name:%String")
{
}

ClassMethod QueryDocUserInfoExecute(ByRef qHandle As %Binary, alias As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s alias=$ZCVT(alias,"u")
	s tmpid=$o(^SSU("SSUSR",""))
	f  s tmpid=$o(^SSU("SSUSR",tmpid)) q:tmpid=""  d
	.s flag=0
	.s code=$p($g(^SSU("SSUSR",+tmpid)),"^",1)
	.s name=$p($g(^SSU("SSUSR",+tmpid)),"^",2)
	.s mailName=$p($g(^SSU("SSUSR",+tmpid)),"^",11)
	.s:$ZCVT(code,"u")[alias flag=1
    .s:$ZCVT(name,"u")[alias flag=1
	.s:$ZCVT(mailName,"u")[alias flag=1
	.s SSUSRCareProvDR=$p($g(^SSU("SSUSR",+tmpid)),"^",14)
	.q:SSUSRCareProvDR=""
	.s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)
	.q:CTPCPCarPrvTpDR=""
	.q:$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)'="DOCTOR"
	.s CTPCP=##class(User.CTCareProv).%OpenId(SSUSRCareProvDR)
	.q:'$IsObject(CTPCP)
	.s OtherName=CTPCP.CTPCPOtherName
	.s:(OtherName'="")&($ZCVT(OtherName,"u")[alias) flag=1
	.d CTPCP.%Close()
	.q:flag'=1
	.s SSUSRCareProvDR=$p($g(^SSU("SSUSR",+tmpid)),"^",14)
	.q:SSUSRCareProvDR=""
	.s CTPCPCarPrvTpDR=$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4)
	.q:CTPCPCarPrvTpDR=""
	.q:$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)'="DOCTOR"
	.s obj=##class(DHCMed.Base.SSUser).GetObjById(tmpid)
	.q:'$IsObject(obj)
	.s Name=obj.Name
	.s Data=$lb(tmpid,Name)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryDocUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDocUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocUserInfoExecute ]
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
}

/// 入参 AdmTranID:paadm||TransSubID
/// 描述 通过就诊ID、转科表ID 判断改病人是否有未完成报告
/// w ##class(DHCMed.InfAimService.BaseSrv).GetInfAimRepInfo("||")
ClassMethod GetInfAimRepInfo(AdmTranID As %String) As %String
{
	n (AdmTranID)
	
	s ret=-1,s="",val=""
	s paadm=$p(AdmTranID,"||",1)
	s TransSubID=$p(AdmTranID,"||",2)
	
	q:(paadm="")||(TransSubID="") ret
	q:'$d(^DHCMed.InfAim.ReportI("TransSubID",paadm)) ret
	q:'$d(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) ret
	
	s RepID=""
	f  s RepID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,RepID)) q:RepID=""  d
	.i $d(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID)) d
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Catheter).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s RepStatus=obj.RepStatus
	...i RepStatus=1	d    //1-保存 2-提交 0-删除
	....q:$l(s,"Catheter")>1
	....s:s'="" s=s_"^"_"Catheter"
	....s:s="" s="Catheter"
	
	.i $d(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID)) d
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.NICU).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s RepStatus=obj.RepStatus
	...i RepStatus=1	d    //1-保存 2-提交 0-删除
	....q:$l(s,"NICU")>1
	....s:s'="" s=s_"^"_"NICU"
	....s:s="" s="NICU"
	
	.i $d(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID)) d
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Pipe).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s RepStatus=obj.RepStatus
	...i RepStatus=1	d    //1-保存 2-提交 0-删除
	....q:$l(s,"Pipe")>1
	....s:s'="" s=s_"^"_"Pipe"
	....s:s="" s="Pipe"
	
	.i $d(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID)) d
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Ventilator).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s RepStatus=obj.RepStatus
	...i RepStatus=1	d    //1-保存 2-提交 0-删除
	....q:$l(s,"Ventilator")>1
	....s:s'="" s=s_"^"_"Ventilator"
	....s:s="" s="Ventilator"
	
	.i $d(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID)) d
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Operation).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s RepStatus=obj.RepStatus
	...i RepStatus=1	d    //1-保存 2-提交 0-删除
	....q:$l(s,"Operation")>1
	....s:s'="" s=s_"^"_"Operation"
	....s:s="" s="Operation"
	
	q s
}

/// Creator：     liuyh
/// CreatDate：   2011-10-26
ClassMethod BuildNotFinishPatSubJson(LocID As %String, childJson As %String) As %String
{
	new (LocID,childJson)
	set json=""
	set retFlag=0
	
	k ^TEMP("InfAim")
	s RepID=""
	f  s RepID=$o(^DHCMed.InfAim.ReportD(RepID),-1) q:RepID=""  d
	.s obj=##class(DHCMed.InfAim.Report).GetObjById(RepID)
	.q:'$IsObject(obj)
	.s paadm=obj.PaadmDR
	.s TransSubID=obj.TransSubID
	.q:'$d(^PAADM(paadm,"TRANS",TransSubID))
	.s CtlocDR=$p(^PAADM(paadm,"TRANS",TransSubID),"^",6)
	.q:(LocID'="")&(LocID'=CtlocDR)
	.s ret=..GetNotFinishRepByPaadm(paadm)
	.q:ret<0
	.q:$d(^TEMP("InfAim",paadm))
	.s ^TEMP("InfAim",paadm)=""
 	.s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
 	.q:'$IsObject(objAdm)
 	.s AdmitDate=objAdm.AdmitDate
 	.s Department=objAdm.Department
 	.s:Department["-" Department=$p(Department,"-",2)
 	.s PatientID=objAdm.PatientID
 	.q:PatientID=""
 	.s Ward=objAdm.Ward
 	.s:Ward["-" Ward=$p(Ward,"-",2)
 	.s Bed=objAdm.Bed
 	.s objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
 	.q:'$IsObject(objPat)
 	.s PatientName=objPat.PatientName
 	.s PapmiNo=objPat.PapmiNo
 	.s Sex=objPat.Sex
 	.s:json'="" json=json_","
	.s json=json_"{"_"""id"":"""_paadm_""",""text"":"""_PapmiNo_" "_PatientName_" 床号："_Bed_" "","
	.;s json=json_"""iconCls"":""icon-pro"","
	.s:Sex="男" json=json_"""iconCls"":""icon-man"","
	.s:Sex="女" json=json_"""iconCls"":""icon-woman"","
	.s json=json_"""leaf"":true"
	.s json=json_"}"
 	
	s childJson="["_json_"]"
	q childJson
}

/// Creator：     liuyh
/// CreatDate：   2011-10-26
/// w ##class(DHCMed.InfAimService.BaseSrv).BuildLocNotFinishPatJson("")
ClassMethod BuildLocNotFinishPatJson(LocID As %String) As %String
{
	n (LocID)
	
	q:'$d(^CTLOC(LocID)) json
	s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	s LocType=$p($g(^CTLOC(LocID)),"^",13)
	i LocType="W" d
	.s LocID=$o(^CTLOC(LocID,"LINK",0,"Loc",""),-1)
	set json="",ind=1
	s CtLocID=0	
	f  s CtLocID=$o(^CTLOC(CtLocID))  q:CtLocID=""  d
	.q:(LocID'="")&(CtLocID'=LocID)
	.s LocDesc=$p($g(^CTLOC(CtLocID)),"^",2)
	.s LocType=$p($g(^CTLOC(CtLocID)),"^",13)
	.q:LocType'="E"
	.s:json'="" json=json_","
	.s itemJson="{"_"""id"":"""_CtLocID_"P"",""text"":"""_LocDesc_""","
	.s:ind=1 itemJson=itemJson_"""expanded"":true,"
	.s:ind'=1 itemJson=itemJson_"""expanded"":false,"
	.s secFlag=0,childJson="[]"
	.d ..BuildNotFinishPatSubJson(CtLocID,.childJson)
	.s itemJson=itemJson_"""children"":"_childJson_"}"
	.s json=json_itemJson
	.s ind=ind+1
	
	quit "["_json_"]"
}

/// w ##class(DHCMed.InfAimService.BaseSrv).GetNotFinishRepByPaadm()
ClassMethod GetNotFinishRepByPaadm(paadm As %String) As %String
{
	n (paadm)	
	
	s ret=-1
	q:'$d(^DHCMed.InfAim.ReportI("TransSubID",paadm)) ret
	s TransSubID=0
	f  s TransSubID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) q:TransSubID=""  d
	.s RepID=0
	.f  s RepID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,RepID)) q:RepID=""  d
	..i $d(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID)) d
	...s rowid=0
	...f  s rowid=$o(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	....s obj=##class(DHCMed.InfAim.Catheter).GetObjById(rowid)
	....q:'$IsObject(obj)
	....s RepStatus=obj.RepStatus
	....i RepStatus=1	d    //1-保存 2-提交 0-删除
	.....s ret=1
	
	..e  i $d(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID)) d
	...s rowid=0
	...f  s rowid=$o(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	....s obj=##class(DHCMed.InfAim.NICU).GetObjById(rowid)
	....q:'$IsObject(obj)
	....s RepStatus=obj.RepStatus
	....i RepStatus=1	d    //1-保存 2-提交 0-删除
	.....s ret=1
	
	..e  i $d(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID)) d
	...s rowid=0
	...f  s rowid=$o(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	....s obj=##class(DHCMed.InfAim.Pipe).GetObjById(rowid)
	....q:'$IsObject(obj)
	....s RepStatus=obj.RepStatus
	....i RepStatus=1	d    //1-保存 2-提交 0-删除
	.....s ret=1
	
	..e  i $d(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID)) d
	...s rowid=0
	...f  s rowid=$o(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	....s obj=##class(DHCMed.InfAim.Ventilator).GetObjById(rowid)
	....q:'$IsObject(obj)
	....s RepStatus=obj.RepStatus
	....i RepStatus=1	d    //1-保存 2-提交 0-删除
	.....s ret=1
	
	..e  i $d(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID)) d
	...s rowid=0
	...f  s rowid=$o(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	....s obj=##class(DHCMed.InfAim.Operation).GetObjById(rowid)
	....q:'$IsObject(obj)
	....s RepStatus=obj.RepStatus
	....i RepStatus=1	d    //1-保存 2-提交 0-删除
	.....s ret=1
	
	q ret
}

/// 描述：通过paadm、转科记录表ID查询转入本科室、转出本科室记录表ID
/// w ##class(DHCMed.InfAimService.BaseSrv).GetTranByPaadmSubID("","")
ClassMethod GetTranByPaadmSubID(paadm As %String, SubID As %String)
{
	n (paadm,SubID)
	s ret=-1,BeforeSubID="",LaterSubID=""
	q:(paadm="")||(SubID="") ret
	
	q:'$d(^PAADM(paadm,"TRANS",SubID)) ret
	s LocDR=$p(^PAADM(paadm,"TRANS",SubID),"^",6)
	q:LocDR="" ret
	
	s rowid=SubID
	f  s rowid=$o(^PAADM(paadm,"TRANS",rowid),-1) q:(rowid="")||(SubID<rowid)||(BeforeSubID'="")  d
	.s LocID=$p($g(^PAADM(paadm,"TRANS",rowid)),"^",6)
	.q:LocID=""
	.q:LocID=LocDR	//科室未发生变化
	.s BeforeSubID=LocID
	
	s rowid=SubID
	f  s rowid=$o(^PAADM(paadm,"TRANS",rowid)) q:(rowid="")||(SubID>rowid)||(LaterSubID'="")  d
	.s LocID=$p($g(^PAADM(paadm,"TRANS",rowid)),"^",6)
	.q:LocID=""
	.q:LocID=LocDR	//科室未发生变化
	.s LaterSubID=LocID
	
	q BeforeSubID_"^"_LaterSubID
}

/// Creator：     liuyh
/// CreatDate：   2011-11-02
/// Description:  查询病人抗生素的信息
/// Table：       DHCMed.Base.OrdItem
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// D ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QryArcimByPaadm","2390","Y")
Query QryArcimByPaadm(Paadm As %String = "", DrugFlag As %String = "Yes") As %Query(ROWSPEC = "Rowid:%String,DrugInfo:%String")
{
}

ClassMethod QryArcimByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String = "", DrugFlag As %String = "Yes") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	s num=0,s=""
 	q:+Paadm=0 $$$OK
    q:'$d(^OEORD(0,"Adm",+Paadm)) $$$OK
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:arcim=""  d
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s Type=objCls.ARCICOrderType
    .q:Type'="R" 
    .s objPhc=##class(DHCMed.Base.PHC).GetObjById(objCls.ARCIMPHCDFDR)
    .;q:(DrugFlag'="")&((objPhc.PHCCDesc'["抗感染")&(objPhc.PHCCDesc'["抗生素")&(objPhc.PHCCDesc'["抗微生物"))
    .q:(DrugFlag'="")&((objPhc.PHCSCDesc'["抗感染")&(objPhc.PHCSCDesc'["抗生素")&(objPhc.PHCSCDesc'["抗微生物"))  //ChengDu_HX ZheJiang_QZ
 	.s sttDate="",endDate="",Days=0,TMP="",AricmSumInfo=""
 	.k ^TMP($j,"arcItmDt",arcim)
 	.s xInstrID="" //药品用法/给药途径
 	.s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
 	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
 	...s oeori=oeord_"||"_oeoriSub
 	...s objOeorICls=##class(DHCMed.Base.OrdItem).GetObjById(oeori)
 	...s TsttDate=objOeorICls.OEORISttDat
 	...s InstrID=$p($g(^OEORD(+oeord,"I",oeoriSub,2)),"^",7)
 	...s InstrDesc=$p($g(^PHCIN(+InstrID)),"^",2)
 	...s:(xInstrID="")&&(InstrDesc'["皮试") xInstrID=InstrID
 	...s:AricmSumInfo="" AricmSumInfo=objOeorICls.OEORIDoseQty_"/"_objOeorICls.CTUOMDesc_";"_objOeorICls.PHCFRDesc1_";"_objOeorICls.PHCDUDesc1_";"_objOeorICls.PHCINDesc1
    ...q:TsttDate=0
    ...s ^TMP($j,"arcItmDt",arcim,TsttDate)=""
    .s sttDate=$o(^TMP($j,"arcItmDt",arcim,0))
    .s endDate=$o(^TMP($j,"arcItmDt",arcim,""),-1)
    .s Dt=0
    .f  s Dt=$o(^TMP($j,"arcItmDt",arcim,Dt)) q:Dt=""  d
    ..s Days=Days+1
    .s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
    .s Data=$lb("")
    .s $li(Data,1)=arcim
    .s $li(Data,2)=objCls.ARCIMDesc_"^"_sttDate
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    .k ^TMP($j,"arcItmDt",arcim)
	Quit $$$OK
}

ClassMethod QryArcimByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByPaadmExecute ]
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

/// w ##class(DHCMed.InfAimService.BaseSrv).GetOrdItemInfoByPaadmARCIM()
ClassMethod GetOrdItemInfoByPaadmARCIM(Paadm As %String, ARCIMID As %String) As %String
{
	n (Paadm,ARCIMID)
	q:+Paadm=0 $$$OK
    q:'$d(^OEORD(0,"Adm",+Paadm)) $$$OK
    s ARCIMDesc=""
    s oeord=$o(^OEORD(0,"Adm",+Paadm,"")) 
    s arcim=""
    f  s arcim=$o(^OEORDi(0,"ARCIM",+oeord,arcim)) q:(arcim="")||(ARCIMDesc'="")  d
    .q:(ARCIMID'="")&(ARCIMID'=arcim)
    .s objCls=##class(DHCMed.Base.Arcim).GetObjById(arcim)
    .q:'$IsObject(objCls)
    .s Type=objCls.ARCICOrderType
    .q:Type'="R" 
    .s objPhc=##class(DHCMed.Base.PHC).GetObjById(objCls.ARCIMPHCDFDR)
   	.s sttDate="",endDate="",Days=0,TMP="",AricmSumInfo=""
 	.k ^TMP($j,"arcItmDt",arcim)
 	.s ordDate="" f  s ordDate=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate)) q:ordDate=""  d
 	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",+oeord,arcim,ordDate,oeoriSub)) q:oeoriSub=""  d
 	...s oeori=oeord_"||"_oeoriSub
 	...s objOeorICls=##class(DHCMed.Base.OrdItem).GetObjById(oeori)
 	...s TsttDate=objOeorICls.OEORISttDat
    ...q:TsttDate=0
    ...s ^TMP($j,"arcItmDt",arcim,TsttDate)=""
    .s sttDate=$o(^TMP($j,"arcItmDt",arcim,0))
    .s endDate=$o(^TMP($j,"arcItmDt",arcim,""),-1)
    .s sttDate=$zd(sttDate,3),endDate=$zd(endDate,3)
    .s ARCIMDesc=ARCIMID_$c(1)_objCls.ARCIMDesc_$c(1)_sttDate
	
	q ARCIMDesc
}

/// Creator：     liuyh
/// CreatDate：   2011-11-08
/// Description:  查询目标性监测报告          
/// D ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryNFInfAimRep","")
Query QueryNFInfAimRep(CtLocID As %String) As %Query(ROWSPEC = "ind:%String,paadm:%String,PapmiNo:%String,AdmitDate:%String,PatientName:%String,Age:%String,Sex:%String")
{
}

ClassMethod QueryNFInfAimRepExecute(ByRef qHandle As %Binary, CtLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:'$d(^CTLOC(CtLocID)) $$$OK
 	s LocDesc=$p($g(^CTLOC(CtLocID)),"^",2)
	s LocType=$p($g(^CTLOC(CtLocID)),"^",13)
	s LocDepDR=$p($g(^CTLOC(CtLocID)),"^",19)
	i LocType="W" d
	.s CtLocID=$o(^CTLOC(CtLocID,"LINK",0,"Loc",""),-1)
	
 	s rowid=""
 	
 	f  s rowid=$o(^DHCMed.InfAim.ReportD(rowid),-1) q:(rowid="")||(ind>50)  d
 	.s RepObj=##class(DHCMed.InfAim.Report).GetObjById(rowid)
	.q:'$IsObject(RepObj)
	.s paadm=RepObj.PaadmDR
	.q:paadm=""
	.s TransSubID=RepObj.TransSubID 
 	.s LocID=$p($g(^PAADM(paadm,"TRANS",TransSubID)),"^",6)
 	.q:(CtLocID'="")&(CtLocID'=LocID)
 	.s PaadmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	.q:'$IsObject(PaadmObj)
	.s AdmitDate=PaadmObj.AdmitDate
	.s DisDate=PaadmObj.DisDate
	.s PatientID=PaadmObj.PatientID
	.s PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	.q:'$IsObject(PatObj)
	.s PatientName=PatObj.PatientName
	.s Sex=PatObj.Sex
	.s InPatMrNo=PatObj.InPatientMrNo
	.s Age=PatObj.Age
	.s PapmiNo=PatObj.PapmiNo
 	.s Data=$lb(ind,paadm,PapmiNo,AdmitDate,PatientName,Age,Sex)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryNFInfAimRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNFInfAimRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryNFInfAimRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNFInfAimRepExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2011-11-11
/// Description:  查询目标性监测报告          
/// D ##class(%ResultSet).RunQuery("DHCMed.InfAimService.BaseSrv","QueryInfAimTotalInfo","2011","","")
Query QueryInfAimTotalInfo(Year As %String, Month As %String, CtLocID As %String) As %Query(ROWSPEC = "ind:%String,Month:%String,LocDesc:%String,CatNum:%String,PipeNum:%String,VenNum:%String,CatInfNum:%String,PIPEInfNum:%String,VenInfNum:%String,CatPer:%String,PipePer:%String,VenPer:%String,CatInfPer:%String,PipeInfPer:%String,VenInfPer:%String,CatInf:%String,PipeInf:%String,VenInf:%String")
{
}

ClassMethod QueryInfAimTotalInfoExecute(ByRef qHandle As %Binary, Year As %String, Month As %String, CtLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:Year="" $$$OK
 	k ^TEMP("DHCMedAim")
 	f i=1:1:12 d
 	.q:(Month'="")&(Month'=i)
 	.s rowid=""
 	.f  s rowid=$o(^DHCMed.InfAim.ReportD(rowid)) q:rowid=""  d
 	..s RepObj=##class(DHCMed.InfAim.Report).GetObjById(rowid)
	..q:'$IsObject(RepObj)
	..s paadm=RepObj.PaadmDR
	..q:paadm=""
	..s TransSubID=RepObj.TransSubID 
 	..s LocID=$p($g(^PAADM(paadm,"TRANS",TransSubID)),"^",6)
 	..q:LocID=""
 	..q:(CtLocID'="")&(CtLocID'=LocID)
 	..i $d(^DHCMed.InfAim.CatheterI("InfAimRepDR",rowid)) d
 	...s CatID=0
 	...f  s CatID=$o(^DHCMed.InfAim.CatheterI("InfAimRepDR",rowid,CatID)) q:CatID=""  d
 	....s CatObj=##class(DHCMed.InfAim.Catheter).GetObjById(CatID)
 	....q:'$IsObject(CatObj)
 	....s CatDate=CatObj.CatDate
 	....s OutCatDate=CatObj.OutCatDate
 	....s InfFlag=CatObj.InfFlag
 	....s InfDate=CatObj.InfDate
 	....i InfFlag  d
 	.....q:InfDate=""
 	.....s InfMonth=$p($zd(InfDate,3),"-",2)
 	.....q:InfMonth'=i
 	.....s ^TEMP("DHCMedAim",LocID,"CATINF",i)=+$g(^TEMP("DHCMedAim",LocID,"CATINF",i))+1
 	.....s ^TEMP("DHCMedAim",LocID,"CatInfPat",i,paadm)=""
 	....s days=..GetDaysByDate(Year,i,CatDate,OutCatDate)
 	....s ^TEMP("DHCMedAim",LocID,"CAT",i)=+$g(^TEMP("DHCMedAim",LocID,"CAT",i))+days
 	
 	..i $d(^DHCMed.InfAim.PipeI("InfAimRepDR",rowid)) d
 	...s PipeID=0
 	...f  s PipeID=$o(^DHCMed.InfAim.PipeI("InfAimRepDR",rowid,PipeID)) q:PipeID=""  d
 	....s PipeObj=##class(DHCMed.InfAim.Pipe).GetObjById(PipeID)
 	....q:'$IsObject(PipeObj)
 	....s PipeDate=PipeObj.PipeDate
 	....s OutPipeDate=PipeObj.OutPipeDate
 	....s InfFlag=PipeObj.InfFlag
 	....s InfDate=PipeObj.InfDate
 	....i InfFlag  d
 	.....q:InfDate=""
 	.....s InfMonth=$p($zd(InfDate,3),"-",2)
 	.....q:InfMonth'=i
 	.....s ^TEMP("DHCMedAim",LocID,"PIPEINF",i)=+$g(^TEMP("DHCMedAim",LocID,"PIPEINF",i))+1
 	.....s ^TEMP("DHCMedAim",LocID,"PipeInfPat",i,paadm)=""
 	....s days=..GetDaysByDate(Year,i,PipeDate,OutPipeDate)
 	....s ^TEMP("DHCMedAim",LocID,"PIPE",i)=+$g(^TEMP("DHCMedAim",LocID,"PIPE",i))+days
 	
 	..i $d(^DHCMed.InfAim.VentilatorI("InfAimRepDR",rowid)) d
 	...s VenID=0
 	...f  s VenID=$o(^DHCMed.InfAim.VentilatorI("InfAimRepDR",rowid,VenID)) q:VenID=""  d
 	....s VenObj=##class(DHCMed.InfAim.Ventilator).GetObjById(VenID)
 	....q:'$IsObject(VenObj)
 	....s VenDate=VenObj.VenDate
 	....s OutVenDate=VenObj.OutVenDate
 	....s InfFlag=VenObj.InfFlag
 	....s InfDate=VenObj.InfDate
 	....i InfFlag  d
 	.....q:InfDate=""
 	.....s InfMonth=$p($zd(InfDate,3),"-",2)
 	.....q:InfMonth'=i
 	.....s ^TEMP("DHCMedAim",LocID,"VENINF",i)=+$g(^TEMP("DHCMedAim",LocID,"VENINF",i))+1
 	.....s ^TEMP("DHCMedAim",LocID,"VenInfPat",i,paadm)=""
 	....s days=..GetDaysByDate(Year,i,VenDate,OutVenDate)
 	....s ^TEMP("DHCMedAim",LocID,"VEN",i)=+$g(^TEMP("DHCMedAim",LocID,"VEN",i))+days

 	s LocID=0
 	f  s LocID=$o(^TEMP("DHCMedAim",LocID)) q:LocID=""  d
 	.f i=1:1:12 d
 	..;s PatInHospDays=..GetPatInHospDaysByLoc(LocID,Year,i) //科室ID，年，月
 	..s PatInHospDays=1000
 
 
 	..s (CatPer,PipePer,VenPer,CatInfPer,PipeInfPer,VenInfPer,CatInf,PipeInf,VenInf)=""
 
 	..q:(Month'="")&(Month'=i)
 	..s CatNum=+$g(^TEMP("DHCMedAim",LocID,"CAT",i))
 	..s PipeNum=+$g(^TEMP("DHCMedAim",LocID,"PIPE",i))
 	..s VenNum=+$g(^TEMP("DHCMedAim",LocID,"VEN",i))
 	..s CatPer=$fn(CatNum/PatInHospDays,"",3)
 	..s PipePer=$fn(PipeNum/PatInHospDays,"",3)
 	..s VenPer=$fn(VenNum/PatInHospDays,"",3)
 	..s CatInfNum=+$g(^TEMP("DHCMedAim",LocID,"CATINF",i))
 	..s PipeInfNum=+$g(^TEMP("DHCMedAim",LocID,"PIPEINF",i))
 	..s VenInfNum=+$g(^TEMP("DHCMedAim",LocID,"VENINF",i))
 	..s:CatNum'=0 CatInfPer=$fn(CatInfNum/CatNum,"",4)*1000
 	..s:PipeNum'=0 PipeInfPer=$fn(PipeInfNum/PipeNum,"",4)*1000
 	..s:VenNum'=0 VenInfPer=$fn(VenInfNum/VenNum,"",4)*1000
 	..s CatInf=..GetPatInfoByTypePaadm("Cat",LocID,i)
 	..s PipeInf=..GetPatInfoByTypePaadm("Pipe",LocID,i)
 	..s VenInf=..GetPatInfoByTypePaadm("Ven",LocID,i)
 	..s LocDesc=""
 	..s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
 	..i $IsObject(LocObj) d
 	...s LocDesc=LocObj.Descs
 	...s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
 	..s Months=Year_"年"_i_"月"
 	..s Data=$lb(ind,Months,LocDesc,CatNum,PipeNum,VenNum,CatInfNum,PipeInfNum,VenInfNum,CatPer,PipePer,VenPer,CatInfPer,PipeInfPer,VenInfPer,CatInf,PipeInf,VenInf)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryInfAimTotalInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInfAimTotalInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryInfAimTotalInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInfAimTotalInfoExecute ]
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

/// w ##Class(DHCMed.InfAimService.BaseSrv).GetInfAimTotalInfo("fillxlSheet","2011^^")
ClassMethod GetInfAimTotalInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.InfAimService.BaseSrv:QueryInfAimTotalInfo")
	d ds.Execute(DateFrom,DateTo,CtlocID)
	s StartRow=2
	while(ds.Next())
	{
		s Months=ds.Data("Month")
		s LocDesc=ds.Data("LocDesc")
		
		s CatNum=ds.Data("CatNum")
		s PipeNum=ds.Data("PipeNum")
		s VenNum=ds.Data("VenNum")
		
		s CatInfNum=ds.Data("CatInfNum")
		s PIPEInfNum=ds.Data("PIPEInfNum")
		s VenInfNum=ds.Data("VenInfNum")
		
		s CatPer=ds.Data("CatPer")
		s PipePer=ds.Data("PipePer")
		s VenPer=ds.Data("VenPer")
		
		s CatInfPer=ds.Data("CatInfPer")
		s PipeInfPer=ds.Data("PipeInfPer")
		s VenInfPer=ds.Data("VenInfPer")
		
		s CatInf=ds.Data("CatInf")
		s PipeInf=ds.Data("PipeInf")
		s VenInf=ds.Data("VenInf")
		
		s valCells=LocDesc_$c(1)_Months_$c(1)_$c(1)_CatNum_$c(1)_CatPer_$c(1)_CatInfNum_$c(1)_CatInfPer_$c(1)_CatInf_$c(1)_PipeNum_$c(1)_PipePer_$c(1)_PIPEInfNum_$c(1)_PipeInfPer_$c(1)_PipeInf
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s valCells=VenNum_$c(1)_VenPer_$c(1)_VenInfNum_$c(1)_VenInfPer_$c(1)_VenInf
		s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",14);"
		&javascript<#(retval)#>
		;_$c(1)_VenNum_$c(1)_VenPer_$c(1)_VenInfNum_$c(1)_VenInfPer_$c(1)_VenInf
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	d ds.Close()
	
	q Count
}

ClassMethod GetPatInfoByTypePaadm(type As %String, LocID As %String, month As %String) As %String
{
	n (type,LocID,month)
	
	s ret=""
	q:'$d(^TEMP("DHCMedAim",LocID)) ret
	i type="Cat" d
	.s paadm=0
	.q:'$d(^TEMP("DHCMedAim",LocID,"CatInfPat",month))
	.f  s paadm=$o(^TEMP("DHCMedAim",LocID,"CatInfPat",month,paadm)) q:paadm=""  d
	..s AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..q:'$IsObject(AdmObj)
	..s PatientID=AdmObj.PatientID
	..q:PatientID=""
	..s PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	..q:'$IsObject(PatObj)
	..s PapmiNo=PatObj.PapmiNo
	..s PatientName=PatObj.PatientName
	..s:ret'="" ret=ret_";"_PatientName_","_PapmiNo
	..s:ret="" ret=PatientName_","_PapmiNo		
	
	i type="Pipe" d
	.s paadm=0
	.q:'$d(^TEMP("DHCMedAim",LocID,"PipeInfPat",month))
	.f  s paadm=$o(^TEMP("DHCMedAim",LocID,"PipeInfPat",month,paadm)) q:paadm=""  d
	..s AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..q:'$IsObject(AdmObj)
	..s PatientID=AdmObj.PatientID
	..q:PatientID=""
	..s PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	..q:'$IsObject(PatObj)
	..s PapmiNo=PatObj.PapmiNo
	..s PatientName=PatObj.PatientName
	..s:ret'="" ret=ret_";"_PatientName_","_PapmiNo
	..s:ret="" ret=PatientName_","_PapmiNo
	
	i type="Ven" d
	.s paadm=0
	.q:'$d(^TEMP("DHCMedAim",LocID,"VenInfPat",month))
	.f  s paadm=$o(^TEMP("DHCMedAim",LocID,"VenInfPat",month,paadm)) q:paadm=""  d
	..s AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..q:'$IsObject(AdmObj)
	..s PatientID=AdmObj.PatientID
	..q:PatientID=""
	..s PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	..q:'$IsObject(PatObj)
	..s PapmiNo=PatObj.PapmiNo
	..s PatientName=PatObj.PatientName
	..s:ret'="" ret=ret_";"_PatientName_","_PapmiNo
	..s:ret="" ret=PatientName_","_PapmiNo
	
	q ret
}

/// w ##class(DHCMed.InfAimService.BaseSrv).GetDaysByDate(2011,1,62397,62432)
ClassMethod GetDaysByDate(Year As %String, Month As %String, sDate As %String, eDate As %String) As %String
{
	n (Year,Month,sDate,eDate)
	
	s rets=0
	q:sDate="" rets
	s LastDay=##class(DHCMed.InfAimService.NICUSrv).GetDayByYearMonth(Year,Month)
	s sDay=Year_"-"_Month_"-"_1
	s eDay=Year_"-"_Month_"-"_LastDay
	s sMonthDay=$zdh(sDay,3)	//月开始日期
	s eMonthDay=$zdh(eDay,3)		//月结束日期
	s:eDate="" eDate=eMonthDay
	q:eDate<sMonthDay rets
	q:sDate>eMonthDay rets
	
	i (sDate<=sMonthDay)&(eDate<eMonthDay) d
	.s rets=eDate+1-sMonthDay
	e  i (sDate>=sMonthDay)&(eDate<=eMonthDay) d
	.s rets=eDate+1-sDate
	e  i (sDate>=sMonthDay)&(sDate<=eMonthDay)&(eDate>=eMonthDay)  d
	.s rets=eMonthDay+1-sDate
	e  d
	.s rets=LastDay
	q rets
}

Storage Default
{
<Data name="BaseSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAimService.BaseSrvD</DataLocation>
<DefaultData>BaseSrvDefaultData</DefaultData>
<IdLocation>^DHCMed.InfAimService.BaseSrvD</IdLocation>
<IndexLocation>^DHCMed.InfAimService.BaseSrvI</IndexLocation>
<StreamLocation>^DHCMed.InfAimService.BaseSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
