Import SQLUser

/// 病案首页疾病统计
/// Creator  李阳
/// Description 病案首页统计
Class web.DHCWMRFPDisSta Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

ClassMethod GetAdmitInfoString(VolID)
{
	n (VolID)
	set VolInfo = $g(^DHCWMRVOL(VolID))

	quit:VolInfo="" ""
	set PaadmID = $p(VolInfo, "^", 2)
	set HisAdmID = $p(VolInfo, "^", 3)	
	set VolAdmID = ""
	set LastAdmID = ""
	if (PaadmID '= "")
	{
		set strAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(PaadmID)
		set LastChildSub = $o(^DHCWMRVOL(VolID, "ADM", ""),-1)
		set LastAdmID =  +$g(^DHCWMRVOL(VolID, "ADM", LastChildSub))
		set strLastAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(LastAdmID)
		set AdmitDate = $p(strAdm, "^", 4)
		set AdmitDep =  $p($p(strAdm, "^", 7),"/",2)
		set DisDate = $p(strLastAdm, "^", 12)
		set DisDep = $p($p(strLastAdm, "^", 7),"/",2)
	}
	else
	{
		set strAdm = $g(^DHCWMRHISADM(HisAdmID))
		set AdmitDate = $p(strAdm, "^", 2)
		set AdmitDep = $p(strAdm, "^", 4)
		set DisDate = $p(strAdm, "^", 6)
		set DisDep = $p(strAdm, "^", 8)	
		set:AdmitDate'="" AdmitDate	= $zd(AdmitDate, 3)
		set:DisDate'="" DisDate = $zd(DisDate, 3)
	}

	if (AdmitDate'="")&(DisDate'="")
	{
		set Days = $zdh(DisDate, 3) - $zdh(AdmitDate, 3)
	}
	else
	{
		set Days = 0
	}
	quit AdmitDate_"^"_AdmitDep_"^"_DisDate_"^"_DisDep_"^"_Days
}

ClassMethod DisStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DisStaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DisStaExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Department As %String, PrimaryDia As %String) As %Status
{
	n (qHandle,FromDate,ToDate,Department,PrimaryDia)
	kill ^CacheTemp("DisSta")
	
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	set PrimaryDiaDicRowID = $o(^DHCWMRDIC(0,"DicNameCode","FPICDType","1",""))
	
	
	set:FromDate["-" FromDate=$zdh(FromDate,3)
	set:ToDate["-" ToDate=$zdh(ToDate,3)
	set Type=47
	set PrimaryDicID = ""
	
	set intTotal = 0
	for intCounter=FromDate:1:ToDate
	{
		set flag = ..Process(intCounter, Type, PrimaryDia, PrimaryDiaDicRowID)
	}
	set rowid = ""
	while 1
	{
		set rowid = $o(^CacheTemp("DisSta",$j,0,rowid))
		quit:rowid=""
		set intTotal = intTotal + 1
	}
	w !,"Total:"_intTotal
	set ICDDr = 0
	set DepName = 0
	while 1
	{
		set DepName = $o(^CacheTemp("DisSta",$j,DepName))
		quit:DepName=""
		while 1
		{
			set ICDDr = $o(^CacheTemp("DisSta",$j,DepName,ICDDr))
			quit:ICDDr=""	
			set ^CacheTemp(repid, ind)=$$BuildDisStaResult(DepName, ICDDr)	
			set ind = ind + 1
		}		
	}

	Quit $$$OK
	
BuildDisStaResult(DepName, ICDDr)
	n (DepName, ICDDr, Total)
	set strData = $g(^CacheTemp("DisSta",$j,DepName, ICDDr))
	set data = $lb("")
	set ICDDic = $g(^DHCWMRICD(ICDDr))
	set Total = +$g(^CacheTemp("DisSta",$j,DepName))
	set $li(data,1)=DepName
	set $li(data,2)=$p(ICDDic,"^",1)
	set $li(data,3)=$p(ICDDic,"^",3)
	set $li(data,4)=$p(strData,"^",1)
	set:Total'=0 $li(data,5)=$number($p(strData,"^",1)/Total*100,2)_"%"
	set:Total=0 $li(data,5)=""
	
	quit data
}

ClassMethod Process(Date, Type, IsPrimary, PriDiaDicRowID)
{
	n (Date, Type, IsPrimary, PriDiaDicRowID)
	quit:(Date="")!(Type="") 0
	set ICDDr = ""
	set intTotal = 0
	w !,"Processing "_$zd(Date,3)
	while 1
	{
		set ICDDr = $o(^DHCWMRFPICD(0,"OutDate",Date,Type,ICDDr))
		quit:ICDDr=""
		set intCount = 0
		set rowid=""
		while 1
		{
			set rowid=$o(^DHCWMRFPICD(0,"OutDate",Date,Type,ICDDr,rowid))
			quit:rowid=""
			set ICDData = $g(^DHCWMRFPICD(rowid))
			set FpRowID = $p(ICDData,"^",1)			
			if (FpRowID'="")
			{
				set ^CacheTemp("DisSta",$j,0, FpRowID)="" //纪录首页数量，即出院人数
			}			
			continue:($p(ICDData,"^",14)'=PriDiaDicRowID)&&(IsPrimary="Y")
			//b
			
			set FpData = $g(^DHCWMRFP(FpRowID))
			set AdmitInfo = ..GetAdmitInfoString(+$p(FpData,"^",1))
			set DisDep = $p(AdmitInfo,"^",4)
			set:DisDep="" DisDep="其他"
			set strData = $g(^CacheTemp("DisSta",$j,DisDep,ICDDr))
			set intCounter = $p(strData,"^",1)
			set intCounter=intCounter+1
			set intTotal = intTotal + 1
			set $p(strData,"^",1)=intCounter
			set ^CacheTemp("DisSta",$j,DisDep,ICDDr)=strData
			set ^CacheTemp("DisSta",$j,DisDep)= +$g(^CacheTemp("DisSta",$j,DisDep))+1
		}
	}
	//b
	quit intTotal
}

ClassMethod DisStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DisStaExecute ]
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

/// 发病统计
/// 
Query DisSta(FromDate As %String, ToDate As %String, Department As %String, PrimaryDia As %String) As %Query(ROWSPEC = "DepName:%String:科室,ICD:%String:ICD,DiseaseName:%String:疾病名称,Number:%String:数量,Percent:%String:患病率")
{
}

/// w ##Class(web.DHCWMRFPDisSta).FCDisStaTemp(FromDate,ToDate,CtLoc)
ClassMethod FCDisStaTemp(FromDate As %String, ToDate As %String, CtLoc As %String) As %String
{
	n (FromDate,ToDate,CtLoc)
	k ^CacheTemp("FC","DisSta")
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	;^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	f tmpDate=FromDate:1:ToDate d
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAADMi("DischDate",tmpDate,EpisodeID)) q:EpisodeID=""  d
	..s tmpAdmString=$g(^PAADM(EpisodeID))
	..s PAADMType=$p(tmpAdmString,"^",2)
	..q:PAADMType'="I"
	..;s VisitStatus=$p(tmpAdmString,"^",2)
	..;q:VisitStatus'="D"
	..s CurrentWard=$p(tmpAdmString,"^",70) ;PAADM_CurrentWard
	..s CtLocWardID=..GetWardIndex(CurrentWard)
	..q:(CtLocWardID'=1447)&&(CtLocWardID'=1448)&&(CtLocWardID'=1449)&&(CtLocWardID'=1450)&&(CtLocWardID'=1451)&&(CtLocWardID'=1452)&&(CtLocWardID'=1453)
	..;^DHCWMRVOL(0,"PaadmDr",{Paadm_Dr},{Rowid})
	..s VolRowid=$o(^DHCWMRVOL(0,"PaadmDr",EpisodeID,""))
	..;w !,"VolRowid="_VolRowid,!
	..q:VolRowid=""
	..;^DHCWMRFP(0,"VolumeDr",{VolumeDr},{RowId})
	..q:'$d(^DHCWMRFP(0,"VolumeDr",VolRowid))
	..s FrontPageRowid=$o(^DHCWMRFP(0,"VolumeDr",VolRowid,""))
	..;w !,"FrontPageRowid="_FrontPageRowid,!
	..;^DHCWMRFPICD(0,"FP",{FrontPageDr},{RowId})
	..s FPICDRowid=""
	..f  s FPICDRowid=$o(^DHCWMRFPICD(0,"FP",FrontPageRowid,FPICDRowid)) q:FPICDRowid=""  d
	...s FPICDString=$g(^DHCWMRFPICD(FPICDRowid))
	...s ItemTypeDr=$p(FPICDString,"^",10) ;ICD类型
	...;w "EpisodeID="_EpisodeID_";ItemTypeDr="_ItemTypeDr,!
	...q:ItemTypeDr'=47
	...s ICDDr=$p(FPICDString,"^",2)
	...s Result=$p(FPICDString,"^",3)
	...s:Result="" Result=86
	...;w "EpisodeID="_EpisodeID_";ICDDr="_ICDDr,!
	...i '$d(^CacheTemp("FC","DisSta",ICDDr)) d
	....s ^CacheTemp("FC","DisSta",ICDDr,Result)=1
	....s ^CacheTemp("FC","DisSta",ICDDr)=1
	...else  d
	....s EachCnt=$g(^CacheTemp("FC","DisSta",ICDDr,Result))
	....s EachCnt=EachCnt+1
	....s ^CacheTemp("FC","DisSta",ICDDr,Result)=EachCnt
	....s Cnt=$g(^CacheTemp("FC","DisSta",ICDDr))
	....s Cnt=Cnt+1
	....s ^CacheTemp("FC","DisSta",ICDDr)=Cnt
	;k ^CacheTemp("FC","DisSta")
	s ICDDr=""
	f  s ICDDr=$o(^CacheTemp("FC","DisSta",ICDDr)) q:ICDDr=""  d
	.s Cnt=$g(^CacheTemp("FC","DisSta",ICDDr))
	.s ICDSring=$g(^DHCWMRICD(ICDDr))
	.s ICD=$p(ICDSring,"^",1)
	.s ICDDesc=$p(ICDSring,"^",3)
	.w ICD_";;"_ICDDesc_";;总计:"_Cnt
	.;s Result=""
	.f Result=81:1:86  d
	..s EachResultCnt=+$g(^CacheTemp("FC","DisSta",ICDDr,Result))
	..i Result=86 d
	...s Desc="空"
	..else  d
	...s DicString=$g(^DHCWMRDIC(Result))
	...s Desc=$p(DicString,"^",3)
	..w ";;"_Desc_":"_EachResultCnt
	.w !
	q "完成"
}

ClassMethod GetWardIndex(Ward)
{
	n (Ward)		;表PAC_Ward的RowId
	s PAWARDStr=$g(^PAWARD(Ward))
	s WARDLocationDR=$p(PAWARDStr,"^",5)		;字段WARD_LocationDR，指向表CT_Loc
	q WARDLocationDR
}

}
