/// 名称: DHCMed.INFService.InfControlsSrv
/// 描述: 监控常用函数
/// 编写者：ChenJB
/// 编写日期: 2010-10-15
Class DHCMed.INFService.InfControlsSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-10-15
/// Description:  为监控院内感染组织患者 数据
/// bug           w ##class(DHCMed.INFService.InfControlsSrv).GetPatPaadmInfo("A","","","","","","","","","I")
ClassMethod GetPatPaadmInfo(InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String)
{
	n (InHospital, MrNo, RegNo, DateFrom, DateTo, Loc, Ward, PatName, CardNo, CurrentAdmType)
	s storeID=$I(^CacheTemp)
	s Pind=1
	q:$g(InHospital)="" storeID
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
	//s:Singleflag=1 ^CacheTemp(storeID,0)=Pind-1
	q:Singleflag=1 storeID
	
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
	//s:Singleflag=1 ^CacheTemp(storeID,0)=Pind-1
	q:Singleflag=1 storeID
	
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
	//s:Singleflag=1 ^CacheTemp(storeID,0)=Pind-1
	q:Singleflag=1 storeID
	
	//病案系统接口调用：病案号取病人ID接口
	i MrNo'="" d   // 病案号不为空
	.s Singleflag=1
	.s PatientIDs=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MrNo,"I","","")
	.q:PatientIDs'=""
	.f indPat=1:1:$l(PatientIDs,",") d
	..s PAPMI=$p(PatientIDs,",",indPat)
	..q:PAPMI=""
	..s ret=$$GetInfoFromPAPMI()
	//s:Singleflag=1 ^CacheTemp(storeID,0)=Pind-1
	q:Singleflag=1 storeID
	
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
    //s:Singleflag=1 ^CacheTemp(storeID,0)=Pind-1
    q:Singleflag=1 storeID
	
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
	//s:Singleflag=1 ^CacheTemp(storeID,0)=Pind-1
	q:Singleflag=1 storeID
	//s:Singleflag=1 ^CacheTemp(storeID,0)=Pind-1
	q storeID
	
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
   q 1
OutputRow()
   s ^CacheTemp(storeID,Pind)=objAdm.AdmRowID
   s Pind=Pind+1
   i $IsObject(objAdm) d 
   .d objAdm.%Close()
   i $IsObject(objPatient) d
   .d objPatient.%Close()
   q 1
}

/// Creator：     ChenJB
/// CreatDate：   2010-10-15
/// Description:  监控院内感染患者 数据
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfControlsSrv","QueryPatientInfo","A","","","","","","","","","I",1,"")
Query QueryPatientInfo(InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, SubId As %String = "", SubListStr As %String = "") As %Query(ROWSPEC = "PatientID:%String,Paadm:%String,AppCnt:%String:评价次数,RegNo:%String:登记号,PatientName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,DoctorName:%String:主管医生,AdmitDate:%String:住院日期,Department:%String:就诊科室,DisDate:%String:出院日期,TotalScore:%String:总分数,FiredItemCnt:%String:项目数量,FiredTypeCnt:%String:类型数量,CtlSum:%String,Detail:%String")
{
}

ClassMethod QueryPatientInfoExecute(ByRef qHandle As %Binary, InHospital As %String, MrNo As %String, RegNo As %String, DateFrom As %String, DateTo As %String, Loc As %String, Ward As %String, PatName As %String, CardNo As %String, CurrentAdmType As %String, SubId As %String = "", SubListStr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	q:(SubId="")&(SubListStr="") $$$OK
	s PaadmStoreID=..GetPatPaadmInfo(InHospital, MrNo, RegNo, DateFrom, DateTo, Loc, Ward, PatName, CardNo, CurrentAdmType)
	s PaadmCnt=+$o(^CacheTemp(PaadmStoreID,""),-1)
	q:PaadmCnt<1 $$$OK
	//1S^1/1I^1/1D^1/2D^1/
	s subListId=""
	set rows=$l(SubListStr,"/")
	f row=1:1:rows {
		s rowString=$p(SubListStr,"/",row)
		s IdString=$p(rowString,"^",1)
		s Authority=+$p(rowString,"^",2)
		i (IdString["D")&(Authority=1) {
			s:subListId'="" subListId=subListId_"*"_(+IdString)
			s:subListId="" subListId=(+IdString)
		}
	}
	s ret=##class(DHCMed.CCService.System.VM).Process(SubId,PaadmStoreID,subListId)
	q:$li(ret,1)'="OK" $$$OK
	s handle=$li(ret,2)	
	///PatientID:%String,Paadm:%String,TotalScore:%String:总分数,FiredItemCnt:%String:触发项目数量,FiredTypeCnt:%String:触发类型数量,
	///FiredType:%String:触发的类别,ItemDic:%String:监控条目,Detail:%String:详情
	s paadm="" f  s paadm=$o(^CacheTemp(handle,"Paadm",paadm)) q:paadm=""  d
	.s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	.s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
	.s summaryInfo=$g(^CacheTemp(handle,"Paadm",paadm))
	.q:+$p(summaryInfo,"^",2)<1
	.s data=$$EmptyList(14)
	.s $li(data,1)=objAdm.PatientID //patientID
	.s $li(data,2)=paadm //paadm
	.s $li(data,3)=..GetCtlAppCnt(paadm) //报告反馈次数
	.s $li(data,4)=objPatient.PapmiNo //regNo
	.s $li(data,5)=objPatient.PatientName //
	.s $li(data,6)=objPatient.Sex //
	.s $li(data,7)=objPatient.Age //
	.s $li(data,8)=objAdm.DoctorName
	.s $li(data,9)=objAdm.AdmitDate    //住院日期
	.s $li(data,10)=objAdm.Department   //就诊科室
	.s $li(data,11)=objAdm.DisDate   
	.s $li(data,12)=$p(summaryInfo,"^",1) //总分
	.s $li(data,13)=$p(summaryInfo,"^",2) //触发数量
	.s $li(data,14)=$p(summaryInfo,"^",3) //触发类型数量
	.s tmpAll=..GetInfCtlDetails(handle,paadm)
	.s $li(data,15)=$p(tmpAll,$c(3),1)
	.s $li(data,16)=$p(tmpAll,$c(3),2)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	/*
	.s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	..s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	..d itemDic.%Close()
	..s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	..d itemSubCat.%Close()
	..s intCounter="" f  s intCounter=$o(^CacheTemp(handle,"Paadm",paadm,"Detail",itemDicRowID,intCounter)) q:intCounter=""  d
	...s data=$$EmptyList(16)
	...s $li(data,14)=itemSubCat.ISCDesc
	...s $li(data,15)=itemDic.IDDesc
	...s $li(data,16)=$g(^CacheTemp(handle,"Paadm",paadm,"Detail",itemDicRowID,intCounter))
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	..s itemDic=""
	..s itemSubCat=""
	..k itemDic
	..k itemSubCat
	..k objAdm
	*/
	k ^CacheTemp(handle)
	Quit $$$OK
EmptyList(num)
	n (num)
	s data=$lb("")
	f i=1:1:num  d
	.s $li(data,i)=""
	q data
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

ClassMethod GetInfCtlSum(handle As %Integer, Paadm As %String) As %String
{
   n (handle ,Paadm)
   s ret=""
   s itsDicStr=""
   s idx=0
   f  s idx=$o(^CacheTemp(handle,"Paadm",Paadm,idx)) q:+idx=0  d
   .s:itsDicStr'="" itsDicStr=itsDicStr_";"_$g(^CacheTemp(handle,"Paadm",Paadm,idx))
   .s:itsDicStr="" itsDicStr=$g(^CacheTemp(handle,"Paadm",Paadm,idx))
   s ret=itsDicStr
   q ret
}

/// ,CtlSum,Detail
ClassMethod GetInfCtlDetails(handle As %Integer, Paadm As %String) As %String
{
   n (handle ,Paadm)
   s ret=""
   s itsDicStr=""
   s DtlStr=""
   s idx=0
   f  s idx=$o(^CacheTemp(handle,"Paadm",Paadm,idx)) q:+idx=0  d
   .s:itsDicStr'="" itsDicStr=itsDicStr_";"_$g(^CacheTemp(handle,"Paadm",Paadm,idx))
   .s:itsDicStr="" itsDicStr=$g(^CacheTemp(handle,"Paadm",Paadm,idx))
   .s DtlIdx=0
   .s eachStr=""
   .f  s DtlIdx=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",idx,DtlIdx)) q:+DtlIdx=0  d
   ..s tmpStr=$g(^CacheTemp(handle,"Paadm",Paadm,"Detail",idx,DtlIdx))
   ..s typeF=$p(tmpStr,$C(1),1)
   ..s resultStr=$p(tmpStr,$C(1),2)
   ..//检验
   ..s:typeF="L" resultStr=##class(DHCMed.CCService.Lib.LabTestLib).GetDetails(resultStr)
   ..//医嘱
   ..s:typeF="O" resultStr=##class(DHCMed.CCService.Lib.OrderTestLib).GetDetails(resultStr)
   ..//诊断
   ..s:typeF="D" resultStr=##class(DHCMed.CCService.Lib.MRDiagnoseTestLib).GetDetails(resultStr)
   ..//影像
   ..s:typeF="R" resultStr=##class(DHCMed.CCService.Lib.RisExamLib).GetDetails(resultStr)
   ..//体温
   ..s:typeF="T" resultStr=##class(DHCMed.CCService.Lib.PatCompareLib).GetTempDetails(resultStr)
   ..//报告
   ..s:typeF="I" resultStr=##class(DHCMed.CCService.Lib.GetInfReportInfo).GetDetails(resultStr)
   ..s:eachStr'="" eachStr=eachStr_"</br>"_resultStr
   ..s:eachStr="" eachStr=resultStr
   .s:DtlStr'="" DtlStr=DtlStr_"</br><b>"_$g(^CacheTemp(handle,"Paadm",Paadm,idx))_"</b></br>"_eachStr
   .s:DtlStr="" DtlStr="<b>"_$g(^CacheTemp(handle,"Paadm",Paadm,idx))_"</b></br>"_eachStr
   s ret=itsDicStr_$c(3)_DtlStr
   q ret
}

ClassMethod GetInfCtlDetailsOld(handle As %Integer, Paadm As %String) As %String
{
   n (handle ,Paadm)
   s ret=""
   s itsDicStr=""
   s DtlStr=""
   s idx=0
   f  s idx=$o(^CacheTemp(handle,"Paadm",Paadm,idx)) q:+idx=0  d
   .s:itsDicStr'="" itsDicStr=itsDicStr_";"_$g(^CacheTemp(handle,"Paadm",Paadm,idx))
   .s:itsDicStr="" itsDicStr=$g(^CacheTemp(handle,"Paadm",Paadm,idx))
   .s DtlIdx=0
   .s eachStr=""
   .f  s DtlIdx=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",idx,DtlIdx)) q:+DtlIdx=0  d
   ..s tmpStr=$g(^CacheTemp(handle,"Paadm",Paadm,"Detail",idx,DtlIdx))
   ..s typeF=$p(tmpStr,$C(1),1)
   ..s resultStr=$p(tmpStr,$C(1),2)
   ..//检验
   ..s:typeF="L" resultStr=##class(DHCMed.CCService.Lib.LabTestLib).GetDetails(resultStr)
   ..//医嘱
   ..s:typeF="O" resultStr=##class(DHCMed.CCService.Lib.OrderTestLib).GetDetails(resultStr)
   ..//诊断
   ..s:typeF="D" resultStr=##class(DHCMed.CCService.Lib.MRDiagnoseTestLib).GetDetails(resultStr)
   ..//影像
   ..s:typeF="R" resultStr=##class(DHCMed.CCService.Lib.RisExamLib).GetDetails(resultStr)
   ..//体温
   ..s:typeF="T" resultStr=##class(DHCMed.CCService.Lib.TempLib).GetDetails(resultStr)
   ..//报告
   ..s:typeF="I" resultStr=##class(DHCMed.CCService.Lib.GetInfReportInfo).GetDetails(resultStr)
   ..s:eachStr'="" eachStr=eachStr_"</br>"_resultStr
   ..s:eachStr="" eachStr=resultStr
   .s:DtlStr'="" DtlStr=DtlStr_"</br><b>"_$g(^CacheTemp(handle,"Paadm",Paadm,idx))_"</b></br>"_eachStr
   .s:DtlStr="" DtlStr="<b>"_$g(^CacheTemp(handle,"Paadm",Paadm,idx))_"</b></br>"_eachStr
   s ret=ret_"<p><b>触发项目:</b>"_itsDicStr_"</p>"_$c(13)_$c(10)
   s ret=ret_"<p><b>触发明细:</b></p>"_$c(13)_$c(10)
   //s ret=ret_"<p>"_itsDicStr_"</p>"_$c(13)_$c(10)
   s ret=ret_DtlStr
   q ret
}

ClassMethod GetCtlAppCnt(Paadm As %String = "") As %String
{
   n (Paadm)
   s ret=0
   q:Paadm="" ""
   s Rowid=0
   f  s Rowid=$o(^DHCMed.INF.RepCtlAppI("Paadm",Paadm,Rowid)) q:+Rowid=0  d
   .s objApp=##class(DHCMed.INF.RepCtlApp).GetObjById(Rowid)
   .q:'$IsObject(objApp)
   .s ret=ret+1
   s:ret=0 ret=""
   q ret
}

/// 描述：通过监控主题ID获取监控主题颜色信息
/// w ##Class(DHCMed.INFService.InfControlsSrv).GetSubColorById(1)
ClassMethod GetSubColorById(SubjectID As %String) As %String
{
	n (SubjectID)
	s ret=""
	q:SubjectID="" ret
	q:'$d(^DHCMed.CC.SubjectColorI("SubjectIndex",SubjectID)) ret
	
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.SubjectColorI("SubjectIndex",SubjectID,rowid)) q:rowid=""  d
	.s obj=##Class(DHCMed.CC.SubjectColor).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s:ret'="" ret=ret_$c(1)_obj.Score_"^"_obj.ColorRGB
	.s:ret="" ret=obj.Score_"^"_obj.ColorRGB
	
	q ret
}

}
