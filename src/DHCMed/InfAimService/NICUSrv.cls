/// 名称: DHCMed.InfAimService.NICUSrv
/// 描述: NICU相关报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-20
Class DHCMed.InfAimService.NICUSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-10-21
/// Description:  查询NICU相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.NICUSrv","QueryNICUInfo","1")
Query QueryNICUInfo(paadm As %String, tTransSubID As %String) As %Query(ROWSPEC = "ind:%String,RepID:%String,rowid:%String,BornWeight:%String,CatDateFrom:%String,CatDateTo:%String,PipeDateFrom:%String,PipeDateTo:%String,VenDateFrom:%String,VenDateTo:%String,InfFlag:%String,RepUser:%String,RepUserDesc:%String,RepStatus:%String,RepStatusDesc:%String,FirstDate:%String,InfDate:%String,Pathogenic:%String,PipeInfFlag:%String,PipeInfDate:%String,PipePathogenic:%String,VenInfFlag:%String,VenInfDate:%String,VenPathogenic:%String")
{
}

ClassMethod QueryNICUInfoExecute(ByRef qHandle As %Binary, paadm As %String, tTransSubID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:paadm="" $$$OK
	s paadm=+paadm
	q:'$d(^DHCMed.InfAim.ReportI("TransSubID",paadm)) $$$OK
	s TransSubID=0
	f  s TransSubID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) q:TransSubID=""  d
	.q:(tTransSubID'="")&(tTransSubID'=TransSubID)
	.s RepID=0
	.f  s RepID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,RepID)) q:RepID=""  d
	..q:'$d(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID))
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.NICU).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s BornWeight=obj.BornWeight
	...s CatDateFrom=obj.CatDateFrom
	...s:CatDateFrom'="" CatDateFrom=$zd(CatDateFrom,3)
	...s CatDateTo=obj.CatDateTo
	...s:CatDateTo'="" CatDateTo=$zd(CatDateTo,3)
	...s PipeDateFrom=obj.PipeDateFrom
	...s:PipeDateFrom'="" PipeDateFrom=$zd(PipeDateFrom,3)
	...s PipeDateTo=obj.PipeDateTo
	...s:PipeDateTo'="" PipeDateTo=$zd(PipeDateTo,3)
	...s VenDateFrom=obj.VenDateFrom
	...s:VenDateFrom'="" VenDateFrom=$zd(VenDateFrom,3)
	...s VenDateTo=obj.VenDateTo
	...s:VenDateTo'="" VenDateTo=$zd(VenDateTo,3)
	...s InfFlag=obj.InfFlag
	...s RepUser=obj.RepUser
	...s RepStatus=obj.RepStatus
	...q:RepStatus=0
	...s FirstDate=obj.FirstDate
	...s:FirstDate'="" FirstDate=$zd(FirstDate,3)
	...s InfDate=obj.InfDate
	...s:InfDate'="" InfDate=$zd(InfDate,3)
	...s Pathogenic=obj.Pathogenic
	
	...s PipeInfFlag=obj.PipeInfFlag
	...s PipeInfDate=obj.PipeInfDate
	...s PipePathogenic=obj.PipePathogenic
	...s VenInfFlag=obj.VenInfFlag
	...s VenInfDate=obj.VenInfDate
	...s VenPathogenic=obj.VenPathogenic
	
	...s:PipeInfDate'="" PipeInfDate=$zd(PipeInfDate,3)
	...s:VenInfDate'="" VenInfDate=$zd(VenInfDate,3)
	
	...s (RepUserDesc,RepStatusDesc)=""
	...s (RepStatusDR)=""
	
    ...i RepUser'="" d
    ....q:'$d(^SSU("SSUSR",RepUser))
    ....s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ...s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ...s:$IsObject(objDic) RepStatusDesc=objDic.Description
    
	...s Data=$lb(ind,RepID,rowid,BornWeight,CatDateFrom,CatDateTo,PipeDateFrom,PipeDateTo,VenDateFrom,VenDateTo,InfFlag,RepUser,RepUserDesc,RepStatus,RepStatusDesc,FirstDate,InfDate,Pathogenic,PipeInfFlag,PipeInfDate,PipePathogenic,VenInfFlag,VenInfDate,VenPathogenic)
 	...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryNICUInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNICUInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryNICUInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNICUInfoExecute ]
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

/// 保存 NICU相关报告表 信息
/// w ##class(DHCMed.InfAimService.NICUSrv).SaveNICUInfo("")
ClassMethod SaveNICUInfo(str As %String) As %String
{
	n (str)
	s ret=-1,tmp=0
	q:str="" ret
	s paadm=$p(str,"^",1)
	s TransSubID=$p(str,"^",2)
	s NICUID=$p(str,"^",3)
	s BornWeight=$p(str,"^",4)
	s CatDateFrom=$p(str,"^",5)
	s:CatDateFrom["-" CatDateFrom=$zdh(CatDateFrom,3)
	s CatDateTo=$p(str,"^",6)
	s:CatDateTo["-" CatDateTo=$zdh(CatDateTo,3)
	s PipeDateFrom=$p(str,"^",7)
	s:PipeDateFrom["-" PipeDateFrom=$zdh(PipeDateFrom,3)
	s PipeDateTo=$p(str,"^",8)
	s:PipeDateTo["-" PipeDateTo=$zdh(PipeDateTo,3)
	s VenDateFrom=$P(str,"^",9)
	s:VenDateFrom["-" VenDateFrom=$zdh(VenDateFrom,3)
	s VenDateTo=$p(str,"^",10)
	s:VenDateTo["-" VenDateTo=$zdh(VenDateTo,3)
	s InfFlag=$p(str,"^",11)
	s RepUser=$p(str,"^",12)
	s RepStatus=$p(str,"^",13)
	s FirstDate=$p(str,"^",14)
	s:FirstDate["-" FirstDate=$zdh(FirstDate,3)
	s:FirstDate="" FirstDate=+$h
	s InfDate=$p(str,"^",15)
	s Pathogenic=$p(str,"^",16)
	
	
	s PipeInfFlag=$p(str,"^",17)
	s PipeInfDate=$p(str,"^",18)
	s PipePathogenic=$p(str,"^",19)
	s VenInfFlag=$p(str,"^",20)
	s VenInfDate=$p(str,"^",21)
	s VenPathogenic=$p(str,"^",22)
	
	
	s:InfDate["-" InfDate=$zdh(InfDate,3)
	s:PipeInfDate["-" PipeInfDate=$zdh(PipeInfDate,3)
	s:VenInfDate["-" VenInfDate=$zdh(VenInfDate,3)
	q:+paadm=0 ret
	q:+TransSubID=0 ret
	
	set $ZT="Error"
	TStart
	
	s ReportID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,""),-1)
	i '$d(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) d
	.s ReportID=##class(DHCMed.InfAim.Report).Update("^"_+paadm_"^"_+TransSubID)
	
	i ReportID<0  TRollback
	s CatInfo=NICUID_"^"_ReportID_"^"_BornWeight_"^"_CatDateFrom_"^"_CatDateTo_"^"_PipeDateFrom_"^"_PipeDateTo
	s CatInfo=CatInfo_"^"_VenDateFrom_"^"_VenDateTo_"^"_InfFlag_"^"_RepUser_"^"_RepStatus_"^"_FirstDate_"^"_InfDate_"^"_Pathogenic
	s CatInfo=CatInfo_"^"_PipeInfFlag_"^"_PipeInfDate_"^"_PipePathogenic_"^"_VenInfFlag_"^"_VenInfDate_"^"_VenPathogenic
	
	s NICUID=##class(DHCMed.InfAim.NICU).Update(CatInfo)
	i NICUID<0 TRollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// w ##class(DHCMed.InfAimService.NICUSrv).DeleteRep(1)
ClassMethod DeleteRep(RepID As %String) As %String
{
	n (RepID)	
	
	s ret=-1
	q:RepID="" ret
	q:'$d(^DHCMed.InfAim.NICUD(RepID)) ret
	&sql(update  DHCMed_InfAim.NICU set RepStatus=0  where ID=:RepID)
	
	s:'SQLCODE ret=1
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2011-10-31
/// Description:  查询NICU相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.NICUSrv","QueryNICUByDateLoc","2011-10-01","2011-10-30","","1")
Query QueryNICUByDateLoc(DateFrom As %String, DateTo As %String, CtLocID As %String, DateType As %String) As %Query(ROWSPEC = "ind:%String,AdmitDate:%String,PatientName:%String,InPatMrNo:%String,BornWeight:%String,DisDate:%String,CatDateFrom:%String,CatDateTo:%String,CatDay:%String,PipeDateFrom:%String,PipeDateTo:%String,PipeDay:%String,VenDateFrom:%String,VenDateTo:%String,VenDay:%String,InfFlag:%String,InfFlagDesc:%String,InfDate:%String,Pathogenic:%String,NICUDiag:%String,PipeInfFlag:%String,PipeInfDate:%String,PipePathogenic:%String,VenInfFlag:%String,VenInfDate:%String,VenPathogenic:%String,PipeInfFlagDesc:%String,VenInfFlagDesc:%String")
{
}

ClassMethod QueryNICUByDateLocExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtLocID As %String, DateType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,1)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,1)
	q:(DateFrom="")||(DateTo="")||(DateFrom>DateTo) $$$OK
	s RepID=0
	f  s RepID=$o(^DHCMed.InfAim.ReportD(RepID)) q:RepID=""  d
	.s RepObj=##class(DHCMed.InfAim.Report).GetObjById(RepID)
	.q:'$IsObject(RepObj)
	.s paadm=RepObj.PaadmDR
	.q:paadm=""
	.s TransSubID=RepObj.TransSubID
	.q:'$d(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID)) //不存在尿管报告
	.s NICUID=0
	.f  s NICUID=$o(^DHCMed.InfAim.NICUI("InfAimRepDR",RepID,NICUID)) q:NICUID=""  d
	..s obj=##class(DHCMed.InfAim.NICU).GetObjById(NICUID)
	..q:'$IsObject(obj)
	..s BornWeight=obj.BornWeight
	..s CatDateFrom=obj.CatDateFrom
	..s CatDateTo=obj.CatDateTo
	..s PipeDateFrom=obj.PipeDateFrom
	..s PipeDateTo=obj.PipeDateTo	
	..s VenDateFrom=obj.VenDateFrom
	..s VenDateTo=obj.VenDateTo
	..s InfFlag=obj.InfFlag
	..s RepUser=obj.RepUser
	..s RepStatus=obj.RepStatus
	..s FirstDate=obj.FirstDate
	..q:RepStatus=0	//删除
	..s InfDate=obj.InfDate
	..s:InfDate'="" InfDate=$zd(InfDate,3)
	..s Pathogenic=obj.Pathogenic
	
	..s PipeInfFlag=obj.PipeInfFlag
	..s PipeInfDate=obj.PipeInfDate
	..s PipePathogenic=obj.PipePathogenic
	..s VenInfFlag=obj.VenInfFlag
	..s VenInfDate=obj.VenInfDate
	..s VenPathogenic=obj.VenPathogenic
	
	..s:PipeInfDate'="" PipeInfDate=$zd(PipeInfDate,3)
	..s:VenInfDate'="" VenInfDate=$zd(VenInfDate,3)
	
	..s PaadmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..q:'$IsObject(PaadmObj)
	..s AdmitDate=PaadmObj.AdmitDate
	..s DisDate=PaadmObj.DisDate
	..s PatientID=PaadmObj.PatientID
	..s PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	..q:'$IsObject(PatObj)
	..s PatientName=PatObj.PatientName
	..s Sex=PatObj.Sex
	..s InPatMrNo=PatObj.InPatientMrNo
	..s Age=PatObj.Age
	..s DepartmentID=PaadmObj.DepartmentID
	..q:(CtLocID'="")&(CtLocID'=DepartmentID)
	..s:AdmitDate["-" AdmitDate=$zdh(AdmitDate,3)
	..s:DisDate["-" DisDate=$zdh(DisDate,3)
	..q:(DateType=1)&((DateFrom>FirstDate)||(DateTo<FirstDate))	//按报告日期查询
	..q:(DateType=2)&((DateFrom>DisDate)||(DateTo<DisDate))	//按出院日期查询
	..q:((DateType=3)||(DateType=""))&((DateFrom>AdmitDate)||(DateTo<AdmitDate))	//按就诊日期查询
	
	..s (CatDay,PipeDay,VenDay)=""
	..s:(CatDateFrom'="")&(CatDateTo'="") CatDay=CatDateTo+1-CatDateFrom
	..s:(PipeDateFrom'="")&(PipeDateTo'="") PipeDay=PipeDateTo+1-PipeDateFrom
	..s:(VenDateFrom'="")&(VenDateTo'="") VenDay=VenDateTo+1-VenDateFrom
	
	..s:CatDateFrom'="" CatDateFrom=$zd(CatDateFrom,3)
	..s:CatDateTo'="" CatDateTo=$zd(CatDateTo,3)
	..s:PipeDateFrom'="" PipeDateFrom=$zd(PipeDateFrom,3)
	..s:PipeDateTo'="" PipeDateTo=$zd(PipeDateTo,3)
	..s:VenDateFrom'="" VenDateFrom=$zd(VenDateFrom,3)
	..s:VenDateTo'="" VenDateTo=$zd(VenDateTo,3)
	
	..s:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	..s:DisDate'="" DisDate=$zd(DisDate,3)
	
	..s (RepUserDesc,RepStatusDesc)=""
	..s (RepStatusDR)=""
	
    ..i RepUser'="" d
    ...q:'$d(^SSU("SSUSR",RepUser))
    ...s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2)
    
    ..s NICUDiag=##class(EPRmeta.FPInterface.ExportTable).GetItemDataValueV2ForStat(paadm,"#TYPE:Simple#TID:17#TVER:0#SCODE:I0076#VTYPE:V",1) 
   
    ..s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ..s:$IsObject(objDic) RepStatusDesc=objDic.Description
	
	..s InfFlagDesc="否"
	..s:InfFlag=1 InfFlagDesc="是"
	
	..s PipeInfFlagDesc="否"
	..s:PipeInfFlag=1 PipeInfFlagDesc="是"
	
	..s VenInfFlagDesc="否"
	..s:VenInfFlag=1 VenInfFlagDesc="是"
	
	..s Data=$lb(ind,AdmitDate,PatientName,InPatMrNo,BornWeight,DisDate,CatDateFrom,CatDateTo,CatDay,PipeDateFrom,PipeDateTo,PipeDay,VenDateFrom,VenDateTo,VenDay,InfFlag,InfFlagDesc,InfDate,Pathogenic,NICUDiag,PipeInfFlag,PipeInfDate,PipePathogenic,VenInfFlag,VenInfDate,VenPathogenic,PipeInfFlagDesc,VenInfFlagDesc)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryNICUByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNICUByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryNICUByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNICUByDateLocExecute ]
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

/// w ##Class(DHCMed.InfAimService.NICUSrv).GetNICUByDateLoc("fillxlSheet","^^^^")
ClassMethod GetNICUByDateLoc(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)
	s DateType =$p(strArguments,"^",4)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.InfAimService.NICUSrv:QueryNICUByDateLoc")
	d ds.Execute(DateFrom,DateTo,CtlocID,DateType)
	s StartRow=3
	while(ds.Next())
	{
		s AdmitDate=ds.Data("AdmitDate")
		s PatientName=ds.Data("PatientName")
		s InPatMrNo=ds.Data("InPatMrNo")
		s BornWeight=ds.Data("BornWeight")
		s DisDate=ds.Data("DisDate")
		s CatDateFrom=ds.Data("CatDateFrom")
		s CatDateTo=ds.Data("CatDateTo")
		s CatDay=ds.Data("CatDay")
		s PipeDateFrom=ds.Data("PipeDateFrom")
		s PipeDateTo=ds.Data("PipeDateTo")
		s PipeDay=ds.Data("PipeDay")
		s VenDateFrom=ds.Data("VenDateFrom")
		s VenDateTo=ds.Data("VenDateTo")
		s VenDay=ds.Data("VenDay")
		s InfFlagDesc=ds.Data("InfFlagDesc")
		s InfDate=ds.Data("InfDate")
		s Pathogenic=ds.Data("Pathogenic")
		s PipeInfFlagDesc=ds.Data("PipeInfFlagDesc")
		s PipeInfDate=ds.Data("PipeInfDate")
		s PipePathogenic=ds.Data("PipePathogenic")
		s VenInfFlagDesc=ds.Data("VenInfFlagDesc")
		s VenInfDate=ds.Data("VenInfDate")
		s VenPathogenic=ds.Data("VenPathogenic")
		s valCells=AdmitDate_$c(1)_PatientName_$c(1)_InPatMrNo_$c(1)_BornWeight_$c(1)_DisDate_$c(1)_CatDateFrom_$c(1)_CatDateTo_$c(1)_CatDay_$c(1)_InfFlagDesc_$c(1)_InfDate_$c(1)_Pathogenic_$c(1)_PipeDateFrom_$c(1)_PipeDateTo_$c(1)_PipeDay_$c(1)_PipeInfFlagDesc_$c(1)_PipeInfDate_$c(1)_PipePathogenic_$c(1)_VenDateFrom_$c(1)_VenDateTo_$c(1)_VenDay_$c(1)_VenInfFlagDesc_$c(1)_VenInfDate_$c(1)_VenPathogenic
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	s valCells="查询日期："_DateFrom_" 至 "_DateTo
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_1_",1);"
	&javascript<#(retval)#>
	
	d ds.Close()
	
	q Count
}

/// Creator：     liuyh
/// CreatDate：   2011-11-10
/// Description:  查询NICU相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.NICUSrv","QueryNICUMonthInfo","2011","12")
Query QueryNICUMonthInfo(Year As %String, Month As %String) As %Query(ROWSPEC = "ind:%String,i:%String,BW1Num:%String,BW2Num:%String,BW3Num:%String,BW4Num:%String,BWC1:%String,BWP1:%String,BWV1:%String,BWC2:%String,BWP2:%String,BWV2:%String,BWC3:%String,BWP3:%String,BWV3:%String,BWC4:%String,BWP4:%String,BWV4:%String,TotalNum:%String")
{
}

ClassMethod QueryNICUMonthInfoExecute(ByRef qHandle As %Binary, Year As %String, Month As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	k ^TEMP("DHCMedNICU")
	q:+$g(Year)=0 $$$OK
	q:+$g(Month)=0 $$$OK
	
	s LastDay=..GetDayByYearMonth(Year,Month)
	q:LastDay=-1 $$$OK
	
	f i=1:1:LastDay  d
	.s rowid=0
	.s date=$zdh(Year_"-"_Month_"-"_i,3)
	.f  s rowid=$o(^DHCMed.InfAim.NICUD(rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.InfAim.NICU).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s BornWeight=obj.BornWeight
	..s CatDateFrom=obj.CatDateFrom
	..s CatDateTo=obj.CatDateTo
	..s PipeDateFrom=obj.PipeDateFrom
	..s PipeDateTo=obj.PipeDateTo
	..s VenDateFrom=obj.VenDateFrom
	..s VenDateTo=obj.VenDateTo
	..i BornWeight<=1000 d
	...s:..CompareDate(CatDateFrom,CatDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWC1",i))
	...s:..CompareDate(PipeDateFrom,PipeDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWP1",i))
	...s:..CompareDate(VenDateFrom,VenDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWV1",i))
	..i (BornWeight>=1001)&(BornWeight<=1500) d
	...s:..CompareDate(CatDateFrom,CatDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWC2",i))
	...s:..CompareDate(PipeDateFrom,PipeDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWP2",i))
	...s:..CompareDate(VenDateFrom,VenDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWV2",i))
	..i (BornWeight>=1501)&(BornWeight<=2500) d
	...s:..CompareDate(CatDateFrom,CatDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWC3",i))
	...s:..CompareDate(PipeDateFrom,PipeDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWP3",i))
	...s:..CompareDate(VenDateFrom,VenDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWV3",i))
	..i BornWeight>2500 d
	...s:..CompareDate(CatDateFrom,CatDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWC4",i))
	...s:..CompareDate(PipeDateFrom,PipeDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWP4",i))
	...s:..CompareDate(VenDateFrom,VenDateTo,date)>0 num=$i(^TEMP("DHCMedNICU","BWV4",i))
	
	.s (BW1Num,BW2Num,BW3Num,BW4Num,BWC1,BWP1,BWV1,BWC2,BWP2,BWV2,BWC3,BWP3,BWV3,BWC4,BWP4,BWV4,TotalNum)=0
	.s BW1Num=$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s BW2Num=$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s BW3Num=$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s BW4Num=$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	.s BWC1=+$g(^TEMP("DHCMedNICU","BWC1",i))
	.s BWP1=+$g(^TEMP("DHCMedNICU","BWP1",i))
	.s BWV1=+$g(^TEMP("DHCMedNICU","BWV1",i))
	
	.s BWC2=+$g(^TEMP("DHCMedNICU","BWC2",i))
	.s BWP2=+$g(^TEMP("DHCMedNICU","BWP2",i))
	.s BWV2=+$g(^TEMP("DHCMedNICU","BWV2",i))
	
	.s BWC3=+$g(^TEMP("DHCMedNICU","BWC3",i))
	.s BWP3=+$g(^TEMP("DHCMedNICU","BWP3",i))
	.s BWV3=+$g(^TEMP("DHCMedNICU","BWV3",i))
	
	.s BWC4=+$g(^TEMP("DHCMedNICU","BWC4",i))
	.s BWP4=+$g(^TEMP("DHCMedNICU","BWP4",i))
	.s BWV4=+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	.s TotalNum=BW1Num+BW2Num+BW3Num+BW4Num
	
	.s Data=$lb(ind,i,BW1Num,BW2Num,BW3Num,BW4Num,BWC1,BWP1,BWV1,BWC2,BWP2,BWV2,BWC3,BWP3,BWV3,BWC4,BWP4,BWV4,TotalNum)
 	.s ret=$$OutputRow()
	
	s desc="总"
	s ret=$$GetTotalNum()	//总计
	
	s desc="床日数"
	s ret=$$GetTotalNum()	//床日数
	
	s desc="脐静脉日数"
	s TotalBWCNum=TotalBWC1+TotalBWC2+TotalBWC3+TotalBWC4
	s Data=$lb(ind,desc,TotalBWC1,TotalBWC2,TotalBWC3,TotalBWC4,"","","","","","","","","","","","",TotalBWCNum)
 	s ret=$$OutputRow()

	s desc="PICC日数"
	s TotalBWPNum=TotalBWP1+TotalBWP2+TotalBWP3+TotalBWP4
	s Data=$lb(ind,desc,TotalBWP1,TotalBWP2,TotalBWP3,TotalBWP4,"","","","","","","","","","","","",TotalBWPNum)
 	s ret=$$OutputRow()
	
	s desc="有创通气日数"
	s TotalBWVNum=TotalBWV1+TotalBWV2+TotalBWV3+TotalBWV4
	s Data=$lb(ind,desc,TotalBWV1,TotalBWV2,TotalBWV3,TotalBWV4,"","","","","","","","","","","","",TotalBWVNum)
 	s ret=$$OutputRow()
 	
 	s desc="VAP感染率"
	s ret=$$GetVAPInfTotalNum()
 	
 	s desc="UC使用率"
 	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalBWC1/TotalBW1,"",3)
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalBWC2/TotalBW2,"",3)
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalBWC3/TotalBW3,"",3)
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalBWC4/TotalBW4,"",3)
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalBWCNum/TotalBWNum,"",3)
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	
 	s desc="picc使用率"
 	s (TotalPICC1,TotalPICC2,TotalPICC3,TotalPICC4,TotalPICC)=""
	i TotalBW1>0 d
	.s TotalPICC1=$fn(TotalBWP1/TotalBW1,"",3)
	i TotalBW2>0 d
	.s TotalPICC2=$fn(TotalBWP2/TotalBW2,"",3)
	i TotalBW3>0 d
	.s TotalPICC3=$fn(TotalBWP3/TotalBW3,"",3)
	i TotalBW4>0 d
	.s TotalPICC4=$fn(TotalBWP4/TotalBW4,"",3)
	i TotalBWNum>0 d
	.s TotalPICC=$fn(TotalBWPNum/TotalBWNum,"",3)
	s Data=$lb(ind,desc,TotalPICC1,TotalPICC2,TotalPICC3,TotalPICC4,"","","","","","","","","","","","",TotalPICC)
 	s ret=$$OutputRow()
 	
 	s desc="呼吸机使用率"
 	s (TotalVNT1,TotalVNT2,TotalVNT3,TotalVNT4,TotalVNT)=""
	i TotalBW1>0 d
	.s TotalVNT1=$fn(TotalBWV1/TotalBW1,"",3)
	i TotalBW2>0 d
	.s TotalVNT2=$fn(TotalBWV2/TotalBW2,"",3)
	i TotalBW3>0 d
	.s TotalVNT3=$fn(TotalBWV3/TotalBW3,"",3)
	i TotalBW4>0 d
	.s TotalVNT4=$fn(TotalBWV4/TotalBW4,"",3)
	i TotalBWNum>0 d
	.s TotalVNT=$fn(TotalBWVNum/TotalBWNum,"",3)
	s Data=$lb(ind,desc,TotalVNT1,TotalVNT2,TotalVNT3,TotalVNT4,"","","","","","","","","","","","",TotalVNT)
 	s ret=$$OutputRow()
 		
	s desc="实验室确证血流感染(非导管相关)"
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,4,1)	//诊断代码为4
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,4,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,4,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,4,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	s Data=$lb(ind,desc,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	s ret=$$OutputRow()
 	
 	s desc="临床脓毒症"
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,1,1)	//诊断代码为1
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,1,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,1,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,1,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	s Data=$lb(ind,desc,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	s ret=$$OutputRow()
 	
 	s desc="CRBSI感染率-PICC"
 	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBWP1>0 d
	.s TotalUC1=$fn(TotalLab1/TotalBWP1,"",3)*1000
	i TotalBWP2>0 d
	.s TotalUC2=$fn(TotalLab2/TotalBWP2,"",3)*1000
	i TotalBWP3>0 d
	.s TotalUC3=$fn(TotalLab3/TotalBWP3,"",3)*1000
	i TotalBWP4>0 d
	.s TotalUC4=$fn(TotalLab4/TotalBWP4,"",3)*1000
	i TotalBWPNum>0 d
	.s TotalUC=$fn(TotalLabNum/TotalBWPNum,"",3)*1000
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	
 	s desc="脐静脉置管相关性血流感染"
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,2,1)	//诊断代码为2
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,2,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,2,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,2,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	s Data=$lb(ind,desc,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	s ret=$$OutputRow()
 	
 	s desc="CRBSI感染率-UC"
 	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBWC1>0 d
	.s TotalUC1=$fn(TotalLab1/TotalBWC1,"",3)*1000
	i TotalBWC2>0 d
	.s TotalUC2=$fn(TotalLab2/TotalBWC2,"",3)*1000
	i TotalBWC3>0 d
	.s TotalUC3=$fn(TotalLab3/TotalBWC3,"",3)*1000
	i TotalBWC4>0 d
	.s TotalUC4=$fn(TotalLab4/TotalBWC4,"",3)*1000
	i TotalBWCNum>0 d
	.s TotalUC=$fn(TotalLabNum/TotalBWCNum,"",3)*1000
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	
 	s desc="PICC置管相关性血流感染"
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,3,1)	//诊断代码为3
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,3,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,3,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,3,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	s Data=$lb(ind,desc,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	s ret=$$OutputRow()
 	
 	s desc="新生儿感染"
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,8,1)	//诊断代码为8
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,8,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,8,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,8,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	s Data=$lb(ind,desc,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	s ret=$$OutputRow()
 	
 	s desc="新生儿肺炎"
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,5,1)	//诊断代码为5
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,5,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,5,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,5,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	s Data=$lb(ind,desc,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	s ret=$$OutputRow()

	s desc="呼吸机相关性感染"
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,6,1)	//诊断代码为6
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,6,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,6,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,6,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	s Data=$lb(ind,desc,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	s ret=$$OutputRow()

	s desc="每千个住院日感染率(例次感染率)"
	s ret=$$GetInHospInfTotalNum()
	
	s desc="每千个住院日血流感染率(例次感染率，包括临床脓毒症)"
	s ret=$$GetInHospBloodInfTotalNum()
	
	s desc="每千个住院日LCBI感染率(例次感染率)"
	s ret=$$GetInHospLCBIInfTotalNum()
	
	s desc="每千个住院日肺炎发生率(例次感染率)"
	s ret=$$GetInHospFYInfTotalNum()
	
	s desc="UC使用率"
	s ret=$$GetUCTotalNum()
	
	s desc="picc使用率"
	s ret=$$GetPipeTotalNum()
	
	s desc="呼吸机使用率"
	s ret=$$GetVenTotalNum()
	
	
	Quit $$$OK
	
GetTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	.s TotalBWC1=TotalBWC1+$g(^TEMP("DHCMedNICU","BWC1",i))
	.s TotalBWP1=TotalBWP1+$g(^TEMP("DHCMedNICU","BWP1",i))
	.s TotalBWV1=TotalBWV1+$g(^TEMP("DHCMedNICU","BWV1",i))
	
	.s TotalBWC2=TotalBWC2+$g(^TEMP("DHCMedNICU","BWC2",i))
	.s TotalBWP2=TotalBWP2+$g(^TEMP("DHCMedNICU","BWP2",i))
	.s TotalBWV2=TotalBWV2+$g(^TEMP("DHCMedNICU","BWV2",i))
	
	.s TotalBWC3=TotalBWC3+$g(^TEMP("DHCMedNICU","BWC3",i))
	.s TotalBWP3=TotalBWP3+$g(^TEMP("DHCMedNICU","BWP3",i))
	.s TotalBWV3=TotalBWV3+$g(^TEMP("DHCMedNICU","BWV3",i))
	
	.s TotalBWC4=TotalBWC4+$g(^TEMP("DHCMedNICU","BWC4",i))
	.s TotalBWP4=TotalBWP4+$g(^TEMP("DHCMedNICU","BWP4",i))
	.s TotalBWV4=TotalBWV4+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	s Data=$lb(ind,desc,TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4,TotalBWNum)
 	s ret=$$OutputRow()
 	q 1
 	
GetInHospInfTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,"",1)
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,"",2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,"",3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,"",4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1
 	
GetInHospBloodInfTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,4,1)+..GetNICUInfRepDiagNum(Year,Month,1,1)+..GetNICUInfRepDiagNum(Year,Month,2,1)+..GetNICUInfRepDiagNum(Year,Month,3,1)
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,4,2)+..GetNICUInfRepDiagNum(Year,Month,1,2)+..GetNICUInfRepDiagNum(Year,Month,2,2)+..GetNICUInfRepDiagNum(Year,Month,3,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,4,3)+..GetNICUInfRepDiagNum(Year,Month,1,3)+..GetNICUInfRepDiagNum(Year,Month,2,3)+..GetNICUInfRepDiagNum(Year,Month,3,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,4,4)+..GetNICUInfRepDiagNum(Year,Month,1,4)+..GetNICUInfRepDiagNum(Year,Month,2,4)+..GetNICUInfRepDiagNum(Year,Month,3,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1
 	
GetInHospLCBIInfTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,4,1)+..GetNICUInfRepDiagNum(Year,Month,2,1)+..GetNICUInfRepDiagNum(Year,Month,3,1)
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,4,2)+..GetNICUInfRepDiagNum(Year,Month,2,2)+..GetNICUInfRepDiagNum(Year,Month,3,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,4,3)+..GetNICUInfRepDiagNum(Year,Month,2,3)+..GetNICUInfRepDiagNum(Year,Month,3,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,4,4)+..GetNICUInfRepDiagNum(Year,Month,2,4)+..GetNICUInfRepDiagNum(Year,Month,3,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1
 	
GetVAPInfTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWV4",i))
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,6,1)
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,6,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,6,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,6,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1
 	
GetInHospFYInfTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	
	s TotalLab1=..GetNICUInfRepDiagNum(Year,Month,4,1)+..GetNICUInfRepDiagNum(Year,Month,8,1)
	s TotalLab2=..GetNICUInfRepDiagNum(Year,Month,4,2)+..GetNICUInfRepDiagNum(Year,Month,8,2)
	s TotalLab3=..GetNICUInfRepDiagNum(Year,Month,4,3)+..GetNICUInfRepDiagNum(Year,Month,8,3)
	s TotalLab4=..GetNICUInfRepDiagNum(Year,Month,4,4)+..GetNICUInfRepDiagNum(Year,Month,8,4)
	s TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1	
 	
 
GetUCTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	.s TotalBWC1=TotalBWC1+$g(^TEMP("DHCMedNICU","BWC1",i))
	.s TotalBWC2=TotalBWC2+$g(^TEMP("DHCMedNICU","BWC2",i))
	.s TotalBWC3=TotalBWC3+$g(^TEMP("DHCMedNICU","BWC3",i))	
	.s TotalBWC4=TotalBWC4+$g(^TEMP("DHCMedNICU","BWC4",i))
	
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	s TotalBWC=TotalBWC1+TotalBWC2+TotalBWC3+TotalBWC4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalBWC1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalBWC2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalBWC3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalBWC4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalBWC/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1
 	
GetPipeTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	.s TotalBWC1=TotalBWC1+$g(^TEMP("DHCMedNICU","BWP1",i))
	.s TotalBWC2=TotalBWC2+$g(^TEMP("DHCMedNICU","BWP2",i))
	.s TotalBWC3=TotalBWC3+$g(^TEMP("DHCMedNICU","BWP3",i))	
	.s TotalBWC4=TotalBWC4+$g(^TEMP("DHCMedNICU","BWP4",i))
	
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	s TotalBWC=TotalBWC1+TotalBWC2+TotalBWC3+TotalBWC4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalBWC1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalBWC2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalBWC3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalBWC4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalBWC/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1
 	
GetVenTotalNum()
	s (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWC1,TotalBWP1,TotalBWV1,TotalBWC2,TotalBWP2,TotalBWV2,TotalBWC3,TotalBWP3,TotalBWV3,TotalBWC4,TotalBWP4,TotalBWV4)=0
	f i=1:1:LastDay  d
	.s TotalBW1=TotalBW1+$g(^TEMP("DHCMedNICU","BWC1",i))+$g(^TEMP("DHCMedNICU","BWP1",i))+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBW2=TotalBW2+$g(^TEMP("DHCMedNICU","BWC2",i))+$g(^TEMP("DHCMedNICU","BWP2",i))+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBW3=TotalBW3+$g(^TEMP("DHCMedNICU","BWC3",i))+$g(^TEMP("DHCMedNICU","BWP3",i))+$g(^TEMP("DHCMedNICU","BWV3",i))
	.s TotalBW4=TotalBW4+$g(^TEMP("DHCMedNICU","BWC4",i))+$g(^TEMP("DHCMedNICU","BWP4",i))+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	.s TotalBWC1=TotalBWC1+$g(^TEMP("DHCMedNICU","BWV1",i))
	.s TotalBWC2=TotalBWC2+$g(^TEMP("DHCMedNICU","BWV2",i))
	.s TotalBWC3=TotalBWC3+$g(^TEMP("DHCMedNICU","BWV3",i))	
	.s TotalBWC4=TotalBWC4+$g(^TEMP("DHCMedNICU","BWV4",i))
	
	s TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	s TotalBWC=TotalBWC1+TotalBWC2+TotalBWC3+TotalBWC4
	
	s (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	i TotalBW1>0 d
	.s TotalUC1=$fn(TotalBWC1/TotalBW1,"",3)*1000
	i TotalBW2>0 d
	.s TotalUC2=$fn(TotalBWC2/TotalBW2,"",3)*1000
	i TotalBW3>0 d
	.s TotalUC3=$fn(TotalBWC3/TotalBW3,"",3)*1000
	i TotalBW4>0 d
	.s TotalUC4=$fn(TotalBWC4/TotalBW4,"",3)*1000
	i TotalBWNum>0 d
	.s TotalUC=$fn(TotalBWC/TotalBWNum,"",3)*1000
	
	s Data=$lb(ind,desc,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	s ret=$$OutputRow()
 	q 1
 		
OutputRow()
   s ^CacheTemp(repid,ind)=Data
   s ind=ind+1

   q 1
}

ClassMethod QueryNICUMonthInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNICUMonthInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryNICUMonthInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNICUMonthInfoExecute ]
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

ClassMethod CompareDate(sDate As %String, eDate As %String, date As %String) As %String
{
	n (sDate,eDate,date)
	
	s ret=-1
	
	q:sDate="" ret
	q:eDate<sDate ret
	
	s:(sDate<=date)&(eDate>=date) ret=1
	s:(sDate<=date)&(eDate="") ret=1
	
	q ret
}

/// 通过报告年、月、诊断Code、体重Code获取NICU院感报告相应诊断的数量
/// w ##class(DHCMed.InfAimService.NICUSrv).GetNICUInfRepDiagNum(2011,12,1,1)
ClassMethod GetNICUInfRepDiagNum(Year As %String, Month As %String, DiagCode As %String, BorthWeightCode As %String) As %String
{
	n (Year,Month,DiagCode,BorthWeightCode)
	
	s ret=0
	q:(Year="")||(Month="") ret
	
	s rowid=""
	f  s rowid=$o(^DHCMed.INF.ReportI("Type"," 8",rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.Report).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s StatusDr=obj.StatusDr
	.q:StatusDr=0 	//删除报告
	.s RepDate=obj.RepDate
	.q:RepDate=""
	.s RepDate=$zd(RepDate,3)
	.q:($p(RepDate,"-",1)'=Year)||($p(RepDate,"-",2)'=Month)
	.q:'$d(^DHCMed.INF.SummaryI("InfRepDr",rowid))
	.s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,""),-1)
	.q:SumID=""
	.s SumObj=##Class(DHCMed.INF.Summary).GetObjById(SumID)
	.q:'$IsObject(SumObj)
	.s BorthWeight=SumObj.BorthWeight
	.q:(BorthWeightCode'="")&&(BorthWeight'=BorthWeightCode)		//体重范围
	.s PosID=""
	.f  s PosID=$o(^DHCMed.INF.RepPosI("InfRepDr",rowid,PosID)) q:PosID=""  d
	..s PosObj=##class(DHCMed.INF.RepPos).GetObjById(PosID)
	..q:'$IsObject(PosObj)
	..s InfDiagDR=PosObj.InfDiagDR
	..q:(DiagCode'="")&(DiagCode'=InfDiagDR)
	..s ret=ret+1
	
	q ret
}

/// w ##Class(DHCMed.InfAimService.NICUSrv).GetNICUMonthInfo("fillxlSheet","^^^^")
ClassMethod GetNICUMonthInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.InfAimService.NICUSrv:QueryNICUMonthInfo")
	d ds.Execute(DateFrom,DateTo)
	s StartRow=7
	while(ds.Next())
	{
		s days=ds.Data("i")
		s BW1Num=ds.Data("BW1Num")
		s BW2Num=ds.Data("BW2Num")
		s BW3Num=ds.Data("BW3Num")
		s BW4Num=ds.Data("BW4Num")
		s BWC1=ds.Data("BWC1")
		s BWP1=ds.Data("BWP1")
		s BWV1=ds.Data("BWV1")
		s BWC2=ds.Data("BWC2")
		s BWP2=ds.Data("BWP2")
		s BWV2=ds.Data("BWV2")
		s BWC3=ds.Data("BWC3")
		s BWP3=ds.Data("BWP3")
		s BWV3=ds.Data("BWV3")
		s BWC4=ds.Data("BWC4")
		s BWP4=ds.Data("BWP4")
		s BWV4=ds.Data("BWV4")
		s TotalNum=ds.Data("TotalNum")
		s valCells=days_$c(1)_BW1Num_$c(1)_BWC1_$c(1)_BWP1_$c(1)_BWV1_$c(1)_BW2Num_$c(1)_BWC2_$c(1)_BWP2_$c(1)_BWV2_$c(1)_BW3Num_$c(1)_BWC3_$c(1)_BWP3_$c(1)_BWV3_$c(1)_BW4Num_$c(1)_BWC4_$c(1)_BWP4_$c(1)_BWV4_$c(1)_TotalNum
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	s valCells="年："_DateFrom_"       月： "_DateTo
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_2_",2);"
	&javascript<#(retval)#>
	
	d ds.Close()
	
	q Count
}

/// w ##class(DHCMed.InfAimService.NICUSrv).GetDayByYearMonth(2011,11)
ClassMethod GetDayByYearMonth(Year As %String, Month As %String) As %String
{
	;n (Year,Month)
	
	s ret=-1
	
	q:(Year="")||(Month="") ret	
	q:(Month>12)||(Month<1) ret
	q:Year<2000 ret
	
	i Month<12 d
	.s Months=Month+1
	.s str=Year_"-"_Months_"-"_1
	.s Days=$zdh(str,3)
	e  d
	.s str=Year+1_"-"_1_"-"_1
	.s Days=$zdh(str,3)
	s Days=Days-1
	
	s ret=$p($zd(Days,3),"-",3)
	
	q ret
}

}
