/// 名称: DHCMed.INFService.CJBTest
/// 描述: 查询患者填报 类
/// 编写者：ChenJB
/// 编写日期: 2010-11-21
Class DHCMed.INFService.InfRepPatSearch Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-11-15
/// Description:  查询病人信息
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.BasePatInfoQuery","QueryPatientInfo","A","","0000000301","","","","","","")
Query QueryPatientInfo(InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, TypeCode As %String = "") As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,DoctorName:%String:主管医生,AdmitDate:%String:住院日期,Department:%String:就诊科室,Ward:%String:病区,Room:%String:病室,Bed:%String:病床,DisDate:%String:出院日期,RepInfo:%String:报告信息")
{
}

ClassMethod QueryPatientInfoExecute(ByRef qHandle As %Binary, InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, TypeCode As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	k ^CacheTemp("DHCMedInfCtlNew")
	q:$g(InHospital)="" $$$OK
	q:TypeCode="" $$$OK
	s:CurrentAdmType="" CurrentAdmType="I"
	s Singleflag=0,AdmitDate=0
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
		
	i CardNo'=""  d    // 卡号不为空
	.s Singleflag=1
	.s CardRefRowid=0
	.f  s CardRefRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRefRowid)) q:CardRefRowid=""  d
	..s tmp=$g(^DHCCARD("CF",+CardRefRowid))
	..q:tmp=""
	..s PAPMI=$p(tmp,"^",4)
	..q:PAPMI=""
	..s ret=$$GetInfoFromPAPMI()
	s:Singleflag=1 ^CacheTemp("DHCMedInfCtlNew",0)=ind-1
	q:Singleflag=1 $$$OK
	
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
   s $li(data,10)=objAdm.Ward
   //s $li(data,9)=objPatient.PapmiNo
   //s $li(data,10)=objPatient.PatientName
   //s $li(data,11)=objPatient.Sex
   //s $li(data,12)=objPatient.Age
   s $li(data,11)=objAdm.Room
   s $li(data,12)=objAdm.Bed
   s $li(data,13)=objAdm.DisDate
   s:$li(data,13)="1840-12-31" $li(data,13)=""
   s $li(data,14)=##class(DHCMed.INFService.InterfaceIn).GetReportInfo(TypeCode,objAdm.AdmRowID)
   
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

}
