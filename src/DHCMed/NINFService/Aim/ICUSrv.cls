/// 名称: DHCMed.NINFService.Aim.ICUSrv
/// 描述: ICU相关报告信息查询
/// 编写者：lyh
/// 编写日期: 2012-04-19
Class DHCMed.NINFService.Aim.ICUSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.ICUSrv","QueryPatientInfo","A","","","","","","","","","I","59/60/61/62/63/64/65/66/67/68/69/","13","N")
Query QueryPatientInfo(InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, argCtrls As %String, argSubjectID As %String, HDMFlag As %String, IsReport As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,MrNo:%String:病案号,DoctorName:%String:主管医生,AdmitDate:%String:住院日期,Department:%String:就诊科室,Ward:%String:病区,Room:%String:病室,Bed:%String:病床,DisDate:%String:出院日期,DepartmentID:%String,WardID:%String,ScoreCount:%String,DataDetail:%String")
{
}

ClassMethod QueryPatientInfoExecute(ByRef qHandle As %Binary, InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, argCtrls As %String, argSubjectID As %String, HDMFlag As %String, IsReport As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1

	k ^CacheTemp("DHCMedInfCtlNew")
	q:$g(InHospital)="" $$$OK
	s TypeCode=1,flg=1 
	q:TypeCode="" $$$OK
	s:CurrentAdmType="" CurrentAdmType="I"
	s Singleflag=0,AdmitDate=0
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	
	i argCtrls'="" d
	.s %ZIndex=$zn,%JIndex=$j
	.k ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	.s flg=##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList("",argCtrls)
	q:flg<1 $$$OK
	
	i HDMFlag=1 d
	.i Loc="" d
	..s paadm=""
	..f  s paadm=$o(^DHCMed.NINF.Aim.PatientAdmToHDMI("IndexEpisodeID",paadm)) q:paadm=""  d
	...s HDMRepFlag=..IsHDMReport(paadm)
	...q:((IsReport="Y")&(HDMRepFlag=1))	//过滤横断面已报患者
	...s ret=$$GetPatInfo()
    ...s ret=$$OutputRow()
    .e  d
    ..q:'$d(^DHCMed.NINF.Aim.PatientAdmToHDMI("IndexPaadmLoc",Loc))
    ..s paadm=""
    ..f  s paadm=$o(^DHCMed.NINF.Aim.PatientAdmToHDMI("IndexPaadmLoc",Loc,paadm)) q:paadm=""  d
    ...s HDMRepFlag=..IsHDMReport(paadm)
   
	...q:((IsReport="Y")&(HDMRepFlag=1))	//过滤横断面已报患者
	...s ret=$$GetPatInfo()
    ...s ret=$$OutputRow()
    
    q:HDMFlag=1 $$$OK
		
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
	.//upadte by pylian 2016-02-18 修改入院时间取值方式
	.s tmpSTR=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()
	.//s tmpSTR="PAADM_AdmDate"  
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
   s Data=$lb(objAdm.AdmRowID)
   s ^CacheTemp("DHCMedInfCtlNew",+objAdm.AdmRowID)=""
   s Data=Data_$lb(objAdm.PatientID)
   s Data=Data_$lb(objPatient.PapmiNo)
   s Data=Data_$lb(objPatient.PatientName)
   s Data=Data_$lb(objPatient.Sex)
   s Data=Data_$lb(objPatient.Age)
   s Data=Data_$lb(objPatient.InPatientMrNo)
   s Data=Data_$lb(objAdm.DoctorName)
   s Data=Data_$lb(objAdm.AdmitDate)  
   s Data=Data_$lb(objAdm.Department)
   s Data=Data_$lb(objAdm.Ward)
   s Data=Data_$lb(objAdm.Room)
   s Data=Data_$lb(objAdm.Bed)
   s Data=Data_$lb(objAdm.DisDate)
   s Data=Data_"" //$lb(##class(DHCMed.NINFService.Aim.InterfaceIn).GetReportInfo(TypeCode,objAdm.AdmRowID))
   s Data=Data_$lb(objAdm.DepartmentID)
   s Data=Data_$lb(objAdm.WardID)
   
   q 1
OutputRow()
   i argCtrls'=""  d
   .s ctrlDtl=##class(DHCMed.CCService.Sys.CtrlProcess).Main(paadm)
   .q:ctrlDtl=""
   .s DataDetail=##class(DHCMed.CCService.Ctrl.Infection).BuildCtrlDtl(ctrlDtl)
   .s Data=Data_DataDetail
   .s ^CacheTemp(repid,ind)=Data
   .s ind=ind+1
   .i $IsObject(objAdm) d 
   ..d objAdm.%Close()
   .i $IsObject(objPatient) d
   ..d objPatient.%Close()
   e  d
   .s DataDetail="" ;..GetAdmDiagnosInfoHX(paadm)
   .s Data=Data_DataDetail
   .s ^CacheTemp(repid,ind)=Data
   .s ind=ind+1
   .i $IsObject(objAdm) d 
   ..d objAdm.%Close()
   .i $IsObject(objPatient) d
   ..d objPatient.%Close()
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

/// 华西医院入院诊断信息
ClassMethod GetAdmDiagnosInfoHX(EpisodeID As %String) As %String
{
	s ret=$lb("",""),res=""
	s AdmDiagnosOne= "",AdmDiagnosTwo= "",AdmDiagnosThree= "",AdmDiagnosFour= ""
	s AdmDiagnosFive= "",AdmDiagnosSix= "",AdmDiagnosSeven= "",AdmDiagnosEight= ""
	
	s ds = ##class(%Library.ResultSet).%New("EPRservice.SpecialData:GetAdmDiagnosInfoHX")
	d ds.Execute(EpisodeID)
	
	while(ds.Next())
	{
		s:ds.Data("AdmDiagnosOne")'="^" AdmDiagnosOne="入院诊断："_ds.Data("AdmDiagnosOne")
		s:ds.Data("AdmDiagnosTwo")'="^" AdmDiagnosTwo="入院诊断："_ds.Data("AdmDiagnosTwo")
		s:ds.Data("AdmDiagnosThree")'="^" AdmDiagnosThree="入院诊断："_ds.Data("AdmDiagnosThree")
		s:ds.Data("AdmDiagnosFour")'="^" AdmDiagnosFour="入院诊断："_ds.Data("AdmDiagnosFour")
		s:ds.Data("AdmDiagnosFive")'="^" AdmDiagnosFive="入院诊断："_ds.Data("AdmDiagnosFive")
		s:ds.Data("AdmDiagnosSix")'="^" AdmDiagnosSix="入院诊断："_ds.Data("AdmDiagnosSix")
		s:ds.Data("AdmDiagnosSeven")'="^" AdmDiagnosSeven="入院诊断："_ds.Data("AdmDiagnosSeven")
		s:ds.Data("AdmDiagnosEight")'="^" AdmDiagnosEight="入院诊断："_ds.Data("AdmDiagnosEight")
	}
	
	s ds = ##class(%Library.ResultSet).%New("EPRservice.SpecialData:GetModAdmDiagnosInfoHX")
	d ds.Execute(EpisodeID)
	
	while(ds.Next())
	{
		s:ds.Data("ModAdmDiagnosOne")'="^" AdmDiagnosOne="修正诊断："_ds.Data("ModAdmDiagnosOne")
		s:ds.Data("ModAdmDiagnosTwo")'="^" AdmDiagnosTwo="修正诊断："_ds.Data("ModAdmDiagnosTwo")
		s:ds.Data("ModAdmDiagnosThree")'="^" AdmDiagnosThree="修正诊断："_ds.Data("ModAdmDiagnosThree")
		s:ds.Data("ModAdmDiagnosFour")'="^" AdmDiagnosFour="修正诊断："_ds.Data("ModAdmDiagnosFour")
		s:ds.Data("ModAdmDiagnosFive")'="^" AdmDiagnosFive="修正诊断："_ds.Data("ModAdmDiagnosFive")
		s:ds.Data("ModAdmDiagnosSix")'="^" AdmDiagnosSix="修正诊断："_ds.Data("ModAdmDiagnosSix")
		s:ds.Data("ModAdmDiagnosSeven")'="^" AdmDiagnosSeven="修正诊断："_ds.Data("ModAdmDiagnosSeven")
		s:ds.Data("ModAdmDiagnosEight")'="^" AdmDiagnosEight="修正诊断："_ds.Data("ModAdmDiagnosEight")
	}
	
	s:(AdmDiagnosOne'="")&(AdmDiagnosOne'="^") res=res_AdmDiagnosOne_"</br>"
	s:(AdmDiagnosTwo'="")&(AdmDiagnosTwo'="^") res=res_AdmDiagnosTwo_"</br>"
	s:(AdmDiagnosThree'="")&(AdmDiagnosThree'="^") res=res_AdmDiagnosThree_"</br>"
	s:(AdmDiagnosFour'="")&(AdmDiagnosFour'="^") res=res_AdmDiagnosFour_"</br>"
	s:(AdmDiagnosFive'="")&(AdmDiagnosFive'="^") res=res_AdmDiagnosFive_"</br>"
	s:(AdmDiagnosSix'="")&(AdmDiagnosSix'="^") res=res_AdmDiagnosSix_"</br>"
	s:(AdmDiagnosSeven'="")&(AdmDiagnosSeven'="^") res=res_AdmDiagnosSeven_"</br>"
	s:(AdmDiagnosEight'="")&(AdmDiagnosEight'="^") res=res_AdmDiagnosEight_"</br>"
	
	s ret=$lb("",res)
	
	q ret
}

/// 通过就诊号查询临床上报报告信息
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.ICUSrv","QueryEPRByEpisodeID","76734")
Query QueryEPRByEpisodeID(EpisodeID As %String) As %Query(ROWSPEC = "rowid:%String,EpisodeID:%String,InstanceID,RepStatus:%String,RepDoc:%String,RepCtloc:%String,RepDate:%String,CheckDate:%String,CheckUser:%String,PrintDocID:%String,TemplateDocID:%String,Description:%String")
{
}

ClassMethod QueryEPRByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s ret=""
	q:(EpisodeID="") ret

	//同步电子病历与临床上报数据
	s flg=##class(DHCMed.NINFService.Aim.Interface).SyncDataEPRByEpisodeID("",EpisodeID)
	q:flg<0 $$$OK
	
	q:'$d(^DHCMed.CR.ReportI("EpisodeID"," "_EpisodeID)) ret
	
	s rowid=""
	f  s rowid=$o(^DHCMed.CR.ReportI("EpisodeID"," "_EpisodeID,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CR.Report).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s InstanceID=obj.InstanceID
	.s RepStatus=obj.RepStatus
	.s:RepStatus="D" RepStatus="待审"
	.s:RepStatus="Y" RepStatus="已审"
	.s:RepStatus="R" RepStatus="退回"
	.s:RepStatus="S" RepStatus="删除"
	.s RepDoc=obj.RepDoc
	.i RepDoc'=""  d
	..s objUser=##class(DHCMed.Base.SSUser).GetObjById(RepDoc)
	..q:'$IsObject(objUser)
	..s RepDoc=objUser.Name
	.s RepCtloc=obj.RepCtloc
	.i +RepCtloc=0 d
	..s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	..q:'$IsObject(objAdm)
	..s RepCtloc=objAdm.Department	//如报告科室为空，则取就诊科室
	.s RepDate=obj.RepDate
	.s:RepDate'="" RepDate=$zd(RepDate,3)
	.s CheckDate=obj.CheckDate
	.s:CheckDate'="" CheckDate=$zd(CheckDate,3)
	.s CheckUser=obj.CheckUser
	.i CheckUser'=""  d
	..s objUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	..q:'$IsObject(objUser)
	..s CheckUser=objUser.Name
	.s ProjectID=obj.ProjectID
	.q:ProjectID=""
	.s objPrj=##Class(DHCMed.CR.Project).%OpenId(ProjectID)
	.q:'$IsObject(objPrj)
	.s PrintDocID=objPrj.TemplateID
	.s TemplateDocID=objPrj.Resume
	.s Description=objPrj.Description
	.s $li(data,1)=rowid
	.s $li(data,2)=EpisodeID
	.s $li(data,3)=InstanceID
	.s $li(data,4)=RepStatus
	.s $li(data,5)=RepDoc
	.s $li(data,6)=RepCtloc
	.s $li(data,7)=RepDate
	.s $li(data,8)=CheckDate
	.s $li(data,9)=CheckUser
	.s $li(data,10)=PrintDocID
	.s $li(data,11)=TemplateDocID
	.s $li(data,12)=Description
	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryEPRByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEPRByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEPRByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEPRByEpisodeIDExecute ]
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

/// Type: N 表示护士填报 D 表示医生填报
/// w ##class(DHCMed.NINFService.Aim.ICUSrv).GetCRReportInfo("N")
ClassMethod GetCRReportInfo(PrjCodes As %String) As %String
{
	s ret=""
	s rowid=""
	q:PrjCodes="" ret
	s ret="obj.objSelContextMenu = new Ext.menu.Menu({items:["
	
	f  s rowid=$o(^DHCMed.CR.ProjectD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CR.Project).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s Active=obj.Active
	.s Description=obj.Description
	.s PrintDocID=obj.TemplateID
	.s TemplateDocID=obj.Resume
	.s Code=obj.Code
	.s flag=0
	.f i=1:1:$l(PrjCodes,"|") d
	..s PrjCode=$p(PrjCodes,"|",i)
	..s:PrjCode=Code flag=1
	.q:flag=0
	.q:Active'="Y"
	.s:ret["text:" ret=ret_",{text:'"
	.s:ret'["text:" ret=ret_"{text:'"
	.s ret=ret_Description
	.s ret=ret_"',icon:'../scripts/dhcmed/img/new.gif',"
	.s ret=ret_"handler:function()"
	.s ret=ret_"{"
	.s ret=ret_"ReportClickHeader("_"'"_PrintDocID_"','"_TemplateDocID_"','ML"_PrintDocID_"','"_Description_"'"
	.s ret=ret_");"
	.s ret=ret_"}}"
	
	s ret=ret_",new Ext.menu.Separator({})"
	
	s:ret["text:" ret=ret_",{text:'查看电子病历',"
	s:ret'["text:" ret=ret_"{text:'查看电子病历',"
	s ret=ret_"icon:'../scripts/dhcmed/img/find.gif',"
	s ret=ret_"handler:function(){ShowEPRReport()}}"
	
	s:ret["text:" ret=ret_",{text:'查看检验报告',"
	s:ret'["text:" ret=ret_"{text:'查看检验报告',"
	s ret=ret_"icon:'../scripts/dhcmed/img/find.gif',"
	s ret=ret_"handler:function(){ShowLibReport()}}"
	
	s ret=ret_"]});"
	
	q ret
}

/// w ##class(DHCMed.NINFService.Aim.ICUSrv).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp 
    d Config.%Close()
    s s=WebServerAppURL
	q s
}

/// 通过就诊号判断是否存在横断面调查报告
ClassMethod IsHDMReport(EpisodeID As %String) As %String
{
	s rets=-1
	q:'$d(^DHCMed.CR.ReportI("EpisodeID"," "_EpisodeID)) rets
	s INFHDMCRReportID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFHDMCRReportID","")
	q:INFHDMCRReportID="" rets
	s RepID=""
	f  s RepID=$o(^DHCMed.CR.ReportI("EpisodeID"," "_EpisodeID,RepID)) q:RepID=""  d
	.s objStr=##Class(DHCMed.CR.Report).GetById(RepID)
	.q:objStr=""
	.s PrjID=$p(objStr,"^",3)
	.s:PrjID=INFHDMCRReportID rets=1	
	
	q rets
}

/// 导出床旁调查信息表
ClassMethod ExportHDMResPat(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	
	s Arg1=$p(strArguments,"^",1)
	s Arg2=$p(strArguments,"^",2)
	s Arg3=$p(strArguments,"^",3)
	s Arg4=$p(strArguments,"^",4)
	s Arg5=$p(strArguments,"^",5)
	s Arg6=$p(strArguments,"^",6)
	s Arg7=$p(strArguments,"^",7)
	s Arg8=$p(strArguments,"^",8)
	s Arg9=$p(strArguments,"^",9)
	s Arg10=$p(strArguments,"^",10)
	s Arg11=$p(strArguments,"^",11)
	s Arg12=$p(strArguments,"^",12)
	s Arg13=$p(strArguments,"^",13)
	s Arg14=$p(strArguments,"^",14)
	
	s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Aim.ICUSrv:QueryPatientInfo")
	d ds.Execute(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12,Arg13,Arg14)
	
	s StartRow=5
	
	while(ds.Next())
	{
		s PatientName=ds.Data("PatientName")
		s Bed=ds.Data("Bed")
		s MrNo=ds.Data("MrNo")
		
		s valCells=PatientName_$c(1)_Bed_$c(1)_MrNo
		s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	s LocDesc=""
	i Arg6'="" d
	.s LocObj=##class(DHCMed.Base.Ctloc).GetObjById(Arg6)
	.q:'$IsObject(LocObj)
	.s LocDesc=LocObj.Descs
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(LocDesc,"O","JS")_"',"_2_",15);"
	&javascript<#(retval)#>
    
    s retval=itmjs_"(xlSheet,'"_$ZCVT(Count,"O","JS")_"',"_3_",4);"
	&javascript<#(retval)#>
	
	d ds.Close()
	
	q Count
}

/// 同步数据
/// w ##class(DHCMed.NINFService.Aim.ICUSrv).UpdateInfReport(26)
ClassMethod UpdateInfReport(CRReportID As %String) As %String
{
	n (CRReportID)
	s ret=""

	q:CRReportID="" ret

	s obj=##class(DHCMed.CR.Report).%OpenId(CRReportID)
	q:'$IsObject(obj) ret
	
	s ProjectID=obj.ProjectID
	q:ProjectID="" ret
	
	s PrjStr=##class(DHCMed.CR.Project).GetById(ProjectID)
	q:PrjStr="" ret
	
	s TemplateID=$p(PrjStr,"^",4)
	s EPRICUReportTemplateID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EPRICUReportTemplateID","")
	
	s EPRSSIReportTemplateID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EPRSSIReportTemplateID","")

	//s EPRUTIReportTemplateID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EPRUTIReportTemplateID","")

	//s EPRIvcCheckReportTemplateID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EPRIvcCheckReportTemplateID","")

	//s EPRCVDPReportTemplateID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EPRCVDPReportTemplateID","")

	//s EPRCheck72ReportTemplateID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EPRCheck72ReportTemplateID","")
	
	s EPRHDMTemplateID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EPRHDMReportTemplateID","")

	i (TemplateID=EPRICUReportTemplateID) d
	.s ret=##Class(DHCMed.NINF.Aim.ICUReport).UpdateDataFromEPR(CRReportID)
	e  i (TemplateID=EPRSSIReportTemplateID) d
	.s ret=##Class(DHCMed.NINF.Aim.SSI).UpdateDataFromEPR(CRReportID)
	e  i (TemplateID=EPRHDMTemplateID) d
	.s ret=##Class(DHCMed.NINF.Aim.HDM).UpdateDataFromEPR(CRReportID)
	
	/*
	i (TemplateID=EPRUTIReportTemplateID) d
	.s ret=##Class(DHCMed.NINF.Aim.UTI).UpdateDataFromEPR(CRReportID)
	i (TemplateID=EPRIvcCheckReportTemplateID) d
	.s ret=##Class(DHCMed.NINF.Aim.IvcCheck).UpdateDataFromEPR(CRReportID)
	i (TemplateID=EPRCVDPReportTemplateID) d
	.s ret=##Class(DHCMed.NINF.Aim.CVDP).UpdateDataFromEPR(CRReportID)
	i (TemplateID=EPRCheck72ReportTemplateID) d
	.s ret=##Class(DHCMed.NINF.Aim.Check72).UpdateDataFromEPR(CRReportID)
	*/
	q ret
}

/// 取该患者本次就诊最后一次ICU医院感染病例监测报告数据
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.ICUSrv","QueryLastICURepInfo",3012579)
Query QueryLastICURepInfo(EpisodeID As %String, CategoryID As %String = "") As %Query(ROWSPEC = "InICUDate:%String,OutICUDate:%String,OutICUPlace:%String,OutHosptial:%String,InICUDiag1:%String,InICUDiag2:%String,InICUDiag3:%String,ICUDiag1:%String,ICUDiag2:%String,ICUDiag3:%String,Infection:%String,InfPos:%String,InfDate:%String,InfReason:%String,Operation:%String,OperationDate:%String,OperationDocDR:%String,OperationName:%String,OutICUPipe:%String,OutICUPipeType:%String,ICUInfType:%String,ICUInfDate:%String,InPipeDate:%String,OutPipeDate:%String,PipeDay:%String,symptom:%String,PathDate1:%String,Sample1:%String,Result1:%String,PathDate2:%String,Sample2:%String,Result2:%String,Treatment:%String")
{
}

ClassMethod QueryLastICURepInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String, CategoryID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:CategoryID="" CategoryID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFICUCategoryID","")
	Quit:(EpisodeID="")||(CategoryID="") $$$OK
	Quit:'$d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID)) $$$OK
	Quit:'$d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," "_CategoryID)) $$$OK
	
	
	Set ECRecordId = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," "_CategoryID,""))
	;取最后一次报告
 	Set InstanceDataID=ECRecordId_"||"_$tr($o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordId,""),-1)," ","")
	
	Quit:InstanceDataID="" $$$OK

	Set TIDValue=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFICUTIDValue","")
	Quit:TIDValue="" $$$OK
	
	Set InICUDate = ..GetDataFromEPR(EpisodeID,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	Set OutICUDate = ..GetDataFromEPR(EpisodeID,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	Set OutICUPlace = ..GetDataFromEPR(EpisodeID,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	Set OutHosptial = ..GetDataFromEPR(EpisodeID,"出院M0009#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:M0009#VTYPE:V",InstanceDataID)
	
	Set InICUDiag1 = ..GetDataFromEPR(EpisodeID,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	Set InICUDiag2 = ..GetDataFromEPR(EpisodeID,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	Set InICUDiag3 = ..GetDataFromEPR(EpisodeID,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	Set ICUDiag1 = ..GetDataFromEPR(EpisodeID,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	Set ICUDiag2 = ..GetDataFromEPR(EpisodeID,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	Set ICUDiag3 = ..GetDataFromEPR(EpisodeID,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	Set Infection = ..GetDataFromEPR(EpisodeID,"医院感染O0016#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0016#VTYPE:V",InstanceDataID)
	Set InfPos = ..GetDataFromEPR(EpisodeID,"感染部位.O0064#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0064#VTYPE:V",InstanceDataID)
	
	Set InfDate = ..GetDataFromEPR(EpisodeID,"感染日期D0018#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0018#VTYPE:V",InstanceDataID)
	Set InfReason = ..GetDataFromEPR(EpisodeID,"危险因素S0019#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0019#VTYPE:V",InstanceDataID)
	Set Operation = ..GetDataFromEPR(EpisodeID,"手术O0020#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0020#VTYPE:V",InstanceDataID)
	Set OperationDate = ..GetDataFromEPR(EpisodeID,"手术时间D0021#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0021#VTYPE:V",InstanceDataID)
	Set OperationDocDR = ..GetDataFromEPR(EpisodeID,"手术医生S0022#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0022#VTYPE:V",InstanceDataID)
	Set OperationName = ..GetDataFromEPR(EpisodeID,"手术名称S0024#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0024#VTYPE:V",InstanceDataID)
	
	Set OutICUPipe = ..GetDataFromEPR(EpisodeID,"转出ICU带管情况O0040#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0040#VTYPE:V",InstanceDataID)
	Set OutICUPipeType = ..GetDataFromEPR(EpisodeID,"带管类型.O0063#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0063#VTYPE:V",InstanceDataID)
	
	Set ICUInfType = ..GetDataFromEPR(EpisodeID,"ICU导管相关性感染类型.O0062#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0062#VTYPE:V",InstanceDataID)
	Set ICUInfDate = ..GetDataFromEPR(EpisodeID,"ICU导管相关性感染日期D0043#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0043#VTYPE:V",InstanceDataID)
	Set InPipeDate = ..GetDataFromEPR(EpisodeID,"插管日期D0044#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0044#VTYPE:V",InstanceDataID)
	Set OutPipeDate = ..GetDataFromEPR(EpisodeID,"拔管日期D0056#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0056#VTYPE:V",InstanceDataID)
	Set PipeDay = ..GetDataFromEPR(EpisodeID,"导管使用日S0045#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0045#VTYPE:V",InstanceDataID)
	Set symptom = ..GetDataFromEPR(EpisodeID,"症状体征G0046#TYPE:Segment#TID:"_TIDValue_"#TVER:0#GCODE:G0046",InstanceDataID)
	Set PathDate1 = ..GetDataFromEPR(EpisodeID,"送检日期1D0049#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0049#VTYPE:V",InstanceDataID)
	Set Sample1 = ..GetDataFromEPR(EpisodeID,"标本名称1S0050#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0050#VTYPE:V",InstanceDataID)
	Set Result1 = ..GetDataFromEPR(EpisodeID,"药敏结果1G0051#TYPE:Segment#TID:"_TIDValue_"#TVER:0#GCODE:G0051",InstanceDataID)
	Set PathDate2 = ..GetDataFromEPR(EpisodeID,"送检日期2D0052#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0052#VTYPE:V",InstanceDataID)
	Set Sample2 = ..GetDataFromEPR(EpisodeID,"标本名称2S0053#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:S0053#VTYPE:V",InstanceDataID)
	Set Result2 = ..GetDataFromEPR(EpisodeID,"药敏结果2G0054#TYPE:Segment#TID:"_TIDValue_"#TVER:0#GCODE:G0054",InstanceDataID)
	Set Treatment = ..GetDataFromEPR(EpisodeID,"治疗G0055#TYPE:Segment#TID:"_TIDValue_"#TVER:0#GCODE:G0055",InstanceDataID)

	Set InICUDate=..FormatDate(InICUDate)
	Set OutICUDate=..FormatDate(OutICUDate)
	Set InfDate=..FormatDate(InfDate)
	Set OperationDate=..FormatDate(OperationDate)
	Set ICUInfDate=..FormatDate(ICUInfDate)
	
	Set InPipeDate=..FormatDate(InPipeDate)
	Set OutPipeDate=..FormatDate(OutPipeDate)
	Set PathDate1=..FormatDate(PathDate1)
	Set PathDate2=..FormatDate(PathDate2)
	
	Set PlaceCode=""
	If OutICUPlace'="" Do
	.Quit:'$d(^CTLOC(0,"Desc",OutICUPlace))
	.Set LocID=$o(^CTLOC(0,"Desc",OutICUPlace,""),-1)
	.Quit:LocID=""
	.Set PlaceCode=$p($g(^CTLOC(LocID)),"^",1)
	.Set OutICUPlace=PlaceCode_"^"_OutICUPlace
	
	Set InICUDiag1=..GetICDCodeByDesc(InICUDiag1)
	Set InICUDiag2=..GetICDCodeByDesc(InICUDiag2)
	Set InICUDiag3=..GetICDCodeByDesc(InICUDiag3)
	Set ICUDiag1=..GetICDCodeByDesc(ICUDiag1)
	Set ICUDiag2=..GetICDCodeByDesc(ICUDiag2)
	Set ICUDiag3=..GetICDCodeByDesc(ICUDiag3)
	
	Set Data=$lb(InICUDate,OutICUDate,OutICUPlace,OutHosptial,InICUDiag1,InICUDiag2,InICUDiag3,ICUDiag1,ICUDiag2,ICUDiag3,Infection,InfPos,InfDate,InfReason,Operation,OperationDate,OperationDocDR,OperationName,OutICUPipe,OutICUPipeType,ICUInfType,ICUInfDate,InPipeDate,OutPipeDate,PipeDay,symptom,PathDate1,Sample1,Result1,PathDate2,Sample2,Result2,Treatment)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1

	Quit $$$OK
}

ClassMethod QueryLastICURepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLastICURepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLastICURepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLastICURepInfoExecute ]
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

ClassMethod FormatDate(Dates As %String) As %String
{
	New (Dates)
	
	Set Dates=$tr(Dates,"年","-")
	Set Dates=$tr(Dates,"月","-")
	Set Dates=$tr(Dates,"日","")
	
	Set:$l($p(Dates,"-",2))=1 $p(Dates,"-",2)=0_$p(Dates,"-",2)
	Set:$l($p(Dates,"-",3))=1 $p(Dates,"-",3)=0_$p(Dates,"-",3)
	
	Quit Dates
}

/// 通过诊断描述取诊断代码^诊断描述
/// 电子病历自动加载诊断
ClassMethod GetICDCodeByDesc(ICDDesc As %String) As %String
{
	New (ICDDesc)
	
	Set ret=""
	
	Quit:ICDDesc="" ret
	
	Quit:'$d(^MRC("ID",0,"Desc",ICDDesc)) ret
	
	Set ICDID=$o(^MRC("ID",0,"Desc",ICDDesc,""),-1)
	Quit:ICDID="" ret
	Set ICDCode=$p($g(^MRC("ID",ICDID)),"^",1)
	
	Quit ICDCode_"^"_ICDDesc
}

ClassMethod GetDataFromEPR(EpisodeID As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	n (EpisodeID, ItemPara ,InstanceDataID)
	
	s ret=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, ItemPara ,InstanceDataID)
	
	q ret
}

/// 电子病历获取目标性监测手术名称信息
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.ICUSrv","QueryAimOperationName")
Query QueryAimOperationName() As %Query(ROWSPEC = "Code:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod QueryAimOperationNameExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aType="AimOperationName"
 	Set aIsActive="1"
 	
 	Set aType=$ZCVT($g(aType),"U")
 	Set RowID=0
 	For {
	 	Set RowID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aType,RowID))
	 	Quit:RowID=""
	 	Set objDic=##class(DHCMed.SS.Dictionary).%OpenId(RowID)
		If $IsObject(objDic){
		 	Set Code=objDic.Code
			Set Description=objDic.Description
			Set Type=objDic.Type
			Continue:(aType'="")&&(aType'=$ZCVT($g(Type),"U"))
			Set Active=objDic.Active
			Continue:(aIsActive'="")&&(aIsActive'=Active)
			If (Active="1"){
				Set Active="Yes"  
			}Else{
			  	Set Active="No"
			}
			Set HospitalDr=objDic.HospitalDr
			Set HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
			Set DateFrom=objDic.DateFrom
			Set DateTo=objDic.DateTo
			If (DateFrom'=""){
				Set DateFrom=$zd(DateFrom,1)
			}
			If (DateTo'=""){
		    	Set DateTo=$zd(DateTo,1)
			}
			
			set Data=$lb(Code,Description)
	        Set ^CacheTemp(repid,ind)=Data
	        Set ind=ind+1
		}
		If objDic'="" Do objDic.%Close()
	}
	
	Quit $$$OK
}

ClassMethod QueryAimOperationNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAimOperationNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAimOperationNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAimOperationNameExecute ]
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
/// CreatDate：   2012-08-15
/// Description:  查询一段时间内出院患者的器械相关感染发病率
/// Table：       DHCMed.NINF.Aim.ICUReport
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.ICUSrv","QryICUInfRate","2012-01-01","2012-10-10")
Query QryICUInfRate(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "LocDesc:%String,DisPatNum:%Integer,VeinInfNum:%String,VeinPipeDate:%String,VeinInfRate:%String,VenInfNum:%String,VenPipeDate:%String,VenInfRate:%String,CathInfNum:%String,CathPipeDate:%String,CathInfRate:%String") [ SqlProc ]
{
}

ClassMethod QryICUInfRateExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:DateFrom="" $$$OK
	q:DateTo="" $$$OK
	
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,1)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,1)
	
	s ICUEPRProjectID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("ICUEPRProjectID","")
	q:ICUEPRProjectID="" $$$OK
	
	k ^CacheTemp("DHCMedQryICUInfRate")
	
	s InfPatNum=0,InfIOpeNum=0,InfWJNum=0

    Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
	f DischDate=DateFrom:1:DateTo d
    .s Paadm=0
	.f  s Paadm=$o(^PAADMi(DischDateIndex,DischDate,Paadm)) q:Paadm=""  d
	..s AdmInfo=$g(^PAADM(Paadm))
	..q:$p(AdmInfo,"^",2)'="I"  //就诊类型过滤
	..q:$p(AdmInfo,"^",20)="C"  //就诊状态过滤
	..//Continue:$d(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",Paadm))  //招回病人不算出院
	..s DepartmentID=$p(AdmInfo,"^",4)
	..q:DepartmentID=""
	..s ^CacheTemp("DHCMedQryICUInfRate",DepartmentID,"PAADM",Paadm)=""
	..q:'$d(^DHCMed.CR.ReportI("EpisodeID"," "_Paadm))
	..s RepID=""
	..f  s RepID=$o(^DHCMed.CR.ReportI("EpisodeID"," "_Paadm,RepID)) q:RepID=""  d
	...s PrjID=$li(^DHCMed.CR.ReportD(RepID),3)
	...s RepStatus=$li(^DHCMed.CR.ReportD(RepID),5)
	...q:PrjID'=ICUEPRProjectID		//该报告不是ICU医院感染病例监测报告
	...q:(RepStatus="R")||(RepStatus="S")	//删除或退回报告数据不计算
	...q:'$d(^DHCMed.NINF.Aim.ICUReportI("CRReportDR"," "_RepID))
	...s ICURepID=$o(^DHCMed.NINF.Aim.ICUReportI("CRReportDR"," "_RepID,""),-1)
	...q:ICURepID=""
	...s obj=##class(DHCMed.NINF.Aim.ICUReport).GetObjById(ICURepID)
	...q:'$IsObject(obj)
	...//静脉置管
	...s VeinPipeDate1=obj.VeinPipeDate1
	...s VeinPipeDate2=obj.VeinPipeDate2
	...s VeinPipeDate3=obj.VeinPipeDate3
	...s VeinOutPipeDate1=obj.VeinOutPipeDate1
	...s VeinOutPipeDate2=obj.VeinOutPipeDate2
	...s VeinOutPipeDate3=obj.VeinOutPipeDate3
	...d ..GetPipeDaysInfo(VeinPipeDate1,VeinOutPipeDate1,DepartmentID,Paadm,"VEIN")
	...d ..GetPipeDaysInfo(VeinPipeDate2,VeinOutPipeDate2,DepartmentID,Paadm,"VEIN")
	...d ..GetPipeDaysInfo(VeinPipeDate3,VeinOutPipeDate3,DepartmentID,Paadm,"VEIN")
	
	...//呼吸机置管
	...s VenPipeDate1=obj.VenPipeDate1
	...s VenPipeDate2=obj.VenPipeDate2
	...s VenPipeDate3=obj.VenPipeDate3
	...s VenOutPipeDate1=obj.VenOutPipeDate1
	...s VenOutPipeDate2=obj.VenOutPipeDate2
	...s VenOutPipeDate3=obj.VenOutPipeDate3
	...d ..GetPipeDaysInfo(VenPipeDate1,VenOutPipeDate1,DepartmentID,Paadm,"VEN")
	...d ..GetPipeDaysInfo(VenPipeDate2,VenOutPipeDate2,DepartmentID,Paadm,"VEN")
	...d ..GetPipeDaysInfo(VenPipeDate3,VenOutPipeDate3,DepartmentID,Paadm,"VEN")
	
	...//尿管置管
	...s CathPipeDate1=obj.CathPipeDate1
	...s CathPipeDate2=obj.CathPipeDate2
	...s CathPipeDate3=obj.CathPipeDate3
	...s CathOutPipeDate1=obj.CathOutPipeDate1
	...s CathOutPipeDate2=obj.CathOutPipeDate2
	...s CathOutPipeDate3=obj.CathOutPipeDate3
	...d ..GetPipeDaysInfo(CathPipeDate1,CathOutPipeDate1,DepartmentID,Paadm,"CATH")
	...d ..GetPipeDaysInfo(CathPipeDate2,CathOutPipeDate2,DepartmentID,Paadm,"CATH")
	...d ..GetPipeDaysInfo(CathPipeDate3,CathOutPipeDate3,DepartmentID,Paadm,"CATH")
	
	.s (TDisPatNum,TVeinPipeDays,TVenPipeDays,TCathPipeDays,TVeinInfNum,TVenInfNum,TCathInfNum)=0
	.s (TVeinInfRate,TVenInfRate,TCathInfRate)=""
	s LocID=""
	f  s LocID=$o(^CacheTemp("DHCMedQryICUInfRate",LocID)) q:LocID=""  d
	.s (DisPatNum,VeinPipeDays,VenPipeDays,CathPipeDays,VeinInfNum,VenInfNum,CathInfNum)=0
	.s (VeinInfRate,VenInfRate,CathInfRate)=""
	.s Paadm=""
	.f  s Paadm=$o(^CacheTemp("DHCMedQryICUInfRate",LocID,"PAADM",Paadm)) q:Paadm=""  d
	..s DisPatNum=DisPatNum+1
	..s VeinPipeDate="",flg=0
	..f  s VeinPipeDate=$o(^CacheTemp("DHCMedQryICUInfRate",LocID,"PAADM",Paadm,"VEIN",VeinPipeDate)) q:VeinPipeDate=""  d
	...s VeinPipeDays=VeinPipeDays+1
	...s ret=..GetPipeInfByPaadm(Paadm,"血管相关性感染")
	...i (ret>0)&(flg=0) d
	....s VeinInfNum=VeinInfNum+1
	....s flg=1
	
	..s VenPipeDate="",flg=0
	..f  s VenPipeDate=$o(^CacheTemp("DHCMedQryICUInfRate",LocID,"PAADM",Paadm,"VEN",VenPipeDate)) q:VenPipeDate=""  d
	...s VenPipeDays=VenPipeDays+1
	...s ret=..GetPipeInfByPaadm(Paadm,"下呼吸道感染")
	...i (ret>0)&(flg=0) d
	....s VenInfNum=VenInfNum+1
	....s flg=1
	
	..s CathPipeDate="",flg=0
	..f  s CathPipeDate=$o(^CacheTemp("DHCMedQryICUInfRate",LocID,"PAADM",Paadm,"CATH",CathPipeDate)) q:CathPipeDate=""  d
	...s CathPipeDays=CathPipeDays+1
	...s ret=..GetPipeInfByPaadm(Paadm,"泌尿系统感染")
	...s:ret>0 CathInfNum=CathInfNum+1
	...i (ret>0)&(flg=0) d
	....s CathInfNum=CathInfNum+1
	....s flg=1
	
	.s:(VeinPipeDays>0)&(VeinInfNum>0) VeinInfRate=$fn((VeinInfNum/VeinPipeDays)*100,"",2)_"%" //血管相关
	.s:(VenPipeDays>0)&(VenInfNum>0) VenInfRate=$fn((VenInfNum/VenPipeDays)*100,"",2)_"%" //呼吸机相关
	.s:(CathPipeDays>0)&(CathInfNum>0) CathInfRate=$fn((CathInfNum/CathPipeDays)*100,"",2)_"%" //尿道相关
	
	.s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
    .s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)	//科室
	
	.s TDisPatNum=TDisPatNum+DisPatNum
	.s TVeinInfNum=TVeinInfNum+VeinInfNum
	.s TVeinPipeDays=TVeinPipeDays+VeinPipeDays
	.s TVeinInfRate=TVeinInfRate+VeinInfRate
	
	.s TVenInfNum=TVenInfNum+VenInfNum
	.s TVenPipeDays=TVenPipeDays+VenPipeDays
	.s TVenInfRate=TVenInfRate+VenInfRate
	
	.s TCathInfNum=TCathInfNum+CathInfNum
	.s TCathPipeDays=TCathPipeDays+CathPipeDays
	.s TCathInfRate=TCathInfRate+CathInfRate
	
	.s Data=$lb(LocDesc,DisPatNum,VeinInfNum,VeinPipeDays,VeinInfRate,VenInfNum,VenPipeDays,VenInfRate,CathInfNum,CathPipeDays,CathInfRate)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	/*s:(TVeinPipeDays>0)&(TVeinInfNum>0) TVeinInfRate=$fn((TVeinInfNum/TVeinPipeDays)*100,"",2)_"%" //血管相关
	s:(TVenPipeDays>0)&(TVenInfNum>0) TVenInfRate=$fn((TVenInfNum/TVenPipeDays)*100,"",2)_"%" //呼吸机相关
	s:(TCathPipeDays>0)&(TCathInfNum>0) TCathInfRate=$fn((TCathInfNum/TCathPipeDays)*100,"",2)_"%" //尿道相关
	
	s Data=$lb("合计",TDisPatNum,TVeinInfNum,TVeinPipeDays,TVeinInfRate,TVenInfNum,TVenPipeDays,TVenInfRate,TCathInfNum,TCathPipeDays,TCathInfRate)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1*/
	
	Quit $$$OK
}

ClassMethod QryICUInfRateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUInfRateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICUInfRateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUInfRateExecute ]
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

ClassMethod GetPipeDaysInfo(sDate As %String, eDate As %String, LocID As %String, EpisodeID As %String, PipeType As %String) As %String
{
	n (sDate,eDate,LocID,EpisodeID,PipeType)
	
	s ret=""

	q:(sDate="")||(eDate="") ret
	
	s sDate=$p(sDate," ",1)
	s eDate=$p(eDate," ",1)
	s sDate=$zdh(sDate,3)
	s eDate=$zdh(eDate,3)
	
	f i=sDate:1:eDate d
	.s ^CacheTemp("DHCMedQryICUInfRate",LocID,"PAADM",EpisodeID,PipeType,i)=""
	
	q ret
}

/// w ##class(DHCMed.NINFService.Aim.ICUSrv).GetPipeInfByPaadm(218,"下呼吸道感染")
ClassMethod GetPipeInfByPaadm(EpisodeID As %String, DiagnoseDesc) As %String
{
	n (EpisodeID,DiagnoseDesc)
	
	s ret=-1
	q:EpisodeID="" ret
	q:'$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID)) ret
	s RepID=""
	f  s RepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,RepID)) q:RepID=""  d
	.q:'$d(^DHCMed.NINF("InfRep",RepID))
	.s obj=##class(DHCMed.NINF.Rep.InfReport).GetObjById(RepID)
	.q:'$IsObject(obj)
	.s ReportStatus=obj.ReportStatus
	.q:'$IsObject(ReportStatus)
	.s ReportStatusCode=ReportStatus.Code
	.s SubID=""
	.f  s SubID=$o(^DHCMed.NINF("InfRep",RepID,"InfPos",SubID)) q:SubID=""  d
	..s SubObj=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(RepID_"||"_SubID)
	..q:'$IsObject(SubObj)
	..s InfDiag=SubObj.InfDiag
	..q:'$IsObject(InfDiag)
	..s DiagDesc=InfDiag.IDDesc
	..i DiagDesc[DiagnoseDesc d
	...s ret=1
	
	q ret
}

}
