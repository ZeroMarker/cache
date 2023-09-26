Import sqluser

/// Descript: 住院病人
/// d ##Class(web.DHCSTPHCMMONITORSYSTASK).CurDayInHosPat()
/// Descript: 住院病人主题监控函数
/// w ##Class(web.DHCSTPHCMMONITORSYSTASK).InHosPatMonitor()
/// Descript:临床药学服务平台系统任务类
Class web.DHCSTPHCMMONITORSYSTASK Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:统计当前所有在院病人
/// w ##Class(web.DHCSTPHCMMONITORSYSTASK).QueryCurInHosPat()
ClassMethod QueryCurInHosPat() As %String
{
	s wardID="",num=0
	f  s wardID=$o(^PAADMi("CurrWard",wardID)) q:wardID=""  d
	.s curRoomDr=""
	.f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
	..s admDr=""
	..f  s admDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,admDr)) q:admDr=""  d
	...s patVisit=$p($g(^PAADM(admDr)),"^",20)
    ...q:patVisit'="A"
    ...q:$d(^DHCPHAE(0,"IndexAdm",admDr))
    ...s admDate=$p(^PAADM(admDr),"^",6)
    ...s AdmType=$p(^PAADM(admDr),"^",2)
	...q:AdmType'="I"
	...d ..InsPhAdmExt(admDr,AdmType,"Y")  
	...s num=num+1
    Q num
}

/// Descript:提取当天入院或者出院病人
/// W ##Class(web.DHCSTPHCMMONITORSYSTASK).CurDayInHosPat()
ClassMethod CurDayInHosPat() As %String
{
	///入院
	s admDr=""
	f  s admDr=$o(^PAADMi("PAADM_AdmDate",+($h-1),admDr)) q:admDr=""  d
	.s AdmType=$p(^PAADM(admDr),"^",2)
	.q:AdmType'="I"
	.q:$d(^DHCPHAE(0,"IndexAdm",admDr))
	.d ..InsPhAdmExt(admDr,AdmType,"Y")
	.

    
    ///出院
    s admDr=""
    f  s admDr=$o(^PAADMi("DischDate",+$h-1,admDr)) q:admDr=""  d
    .s AdmType=$p(^PAADM(admDr),"^",2)
	.q:AdmType'="I"
	.d ..UpdPhAdmExt(admDr)
    Q ""
}

/// Descript:插入患者就诊扩展表[药房用]
ClassMethod InsPhAdmExt(admDr As %String, AdmType As %String, patVisit As %String) As %String
{
	n (admDr,AdmType,patVisit)
	s curDate=+$h
	s curTime=$p($h,",",2)
	&SQL(Insert DHC_PHAdmExt(PHA_Adm_Dr,PHA_AdmType,PHA_AdmVisStatus,PHA_Date,PHA_Time)
		Values(:admDr,:AdmType,:patVisit,:curDate,:curTime))
	q SQLCODE
}

/// Descript:更新患者就诊扩展表[药房用]
ClassMethod UpdPhAdmExt(admDr As %String) As %String
{
	n (admDr)
	s patVisit="N"
	&SQL(Update DHC_PHAdmExt Set PHA_AdmVisStatus=:patVisit Where PHA_Adm_Dr=:admDr)
	q SQLCODE
}

/// Descript:插入监控主表
ClassMethod InsMonitor(AdmDr As %String, FunTheItmDr As %String) As %String
{
	n (AdmDr,FunTheItmDr)
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	&SQL(Insert DHC_PHMonitor(PHM_Adm_Dr,PHM_FunTheItem_Dr,PHM_Date,PHM_Time,PHM_UpdDate,PHM_UpdTime)
		Values(:AdmDr,:FunTheItmDr,:CurDate,:CurTime,:CurDate,:CurTime))
	q:SQLCODE'=0 SQLCODE
	q +%ROWID
}

/// Descript:更新监控主表
ClassMethod UpdMonitor(phAdmExtID As %String) As %String
{
	n (phAdmExtID)
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	&SQL(Update DHC_PHMonitor Set PHM_UpdDate=:CurDate,PHM_UpdTime=:CurTime Where PHM_RowID=:phAdmExtID)
	q SQLCODE
}

/// Descript:插入监控主表
ClassMethod InsMonitorItm(parref As %String, MonitorItmList As %String) As %String
{
	n (parref,MonitorItmList)
	s CurDate=+$h
	s curTime=$p($h,",",2)
	s Len=$L(MonitorItmList,"!!")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s MonitorItm=$p(MonitorItmList,"!!",i)
	.q:MonitorItm=""
	.s Type=$p(MonitorItm,"^",1)        //类型
	.s ItmMastDR=$p(MonitorItm,"^",2)   //医嘱项
	.s AbnVal="" //$p(MonitorItm,"^",3) //异常值
	.s AbnDesc=$p(MonitorItm,"^",4)     //异常指标相关描述
	.s OrdItem=$p(MonitorItm,"^",5) 	//医嘱id	//qunianpeng 2017/9/20 增加医嘱id
	.s monItmID = ""
	.&sql(select PHMI_RowID into :monItmID from DHC_PHMonitorItm where PHMI_PHM_Parref=:parref and PHMI_Type=:Type and PHMI_OrdItem=:OrdItem)	
	.q:(monItmID'="")
	.s childSub=$o(^DHCPHM(parref,"I",""),-1)+1
	.&SQL(Insert DHC_PHMonitorItm(PHMI_PHM_Parref,PHMI_ChildSub,PHMI_Type,PHMI_ARCIM_DR,PHMI_AbnVal,PHMI_AbnDesc,PHMI_OrdItem)
		Values(:parref,:childSub,:Type,:ItmMastDR,:AbnVal,:AbnDesc,:OrdItem))
	.i SQLCODE'=0 s quitflag="1"
	.
	q quitflag
}

/// Descript:保存监控记录
ClassMethod Insert(AdmDr As %String, FunTheItmDr As %String, MonitorItmList As %String) As %String
{
	n (AdmDr,FunTheItmDr,MonitorItmList)
	ts
	s phAdmExtID=..InsMonitor(AdmDr,FunTheItmDr)
	q:+phAdmExtID<0 phAdmExtID
	s ret=..InsMonitorItm(phAdmExtID,MonitorItmList)
	i ret'=0 tro
	q:ret'=0 ret
	tc
	q ret
}

/// Descript:更新监控记录
ClassMethod update(phAdmExtID As %String, MonitorItmList As %String) As %String
{
	n (phAdmExtID,MonitorItmList)
	ts
	s ret=..UpdMonitor(phAdmExtID)
	q:ret'=0 ret
	s ret=..InsMonitorItm(phAdmExtID,MonitorItmList)
	i ret'=0 tro
	q:ret'=0 ret
	tc
	q ret
}

/// Descript:保存监控记录
ClassMethod save(phAdmExtID As %String, AdmDr As %String, FunTheItmDr As %String, MonitorItmList As %String) As %String
{
	n (phAdmExtID,AdmDr,FunTheItmDr,MonitorItmList)
	i phAdmExtID="" d
	.s ret=..Insert(AdmDr,FunTheItmDr,MonitorItmList)
	e  d
	.s ret=..update(phAdmExtID,MonitorItmList)
	q ret
}

/// Descript:检查医嘱项是否存在
ClassMethod GetNumByArcID(argInput As %String) As %String
{
	N (argInput,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	s argStDate=%argStDate
	s argEndDate=%argEndDate
	s argArcitmStr=argInput  
	s OrderID=$o(^OEORD(0,"Adm",%EpisodeID,""))
	s MonitorItmList=""
	s %ExtraData=""
	Quit:OrderID="" 0
	f date=argStDate:1:argEndDate d
	.s cnt=$l(argArcitmStr,",")
	.f x=1:1:cnt d
	..s drgdr=$p(argArcitmStr,",",x)
	..s code=$p(^PHCD(+drgdr,1),"^",1)
	..s arc=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	..q:arc=""
	..s sub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),arc,""))
	..q:sub=""
	..s arcitm=arc_"||"_sub
    ..s chl=$o(^OEORDi(0,"ARCIM",OrderID,arcitm,date,""))
    ..q:chl=""
    ..
    ..i MonitorItmList'="" d
    ...s MonitorItmList="D"_"^"_arcitm_"^^^"
    ..e  s MonitorItmList=MonitorItmList_"!!"_"D"_"^"_arcitm_"^^^"
   
    q MonitorItmList
}

/// Descript:监测项目并执行函数  bianshuai 2014-09-22
/// w ##class(web.DHCSTPHCMFUNLIBITM).ExecMonitorLibFun(thri)
ClassMethod ExecMonitorLibFun(thri) As %String
{
	n (thri,%argStDate,%argEndDate,%EpisodeID,%ExtraData)
	s ListData=""
	s ret=""
	s itmr=""
	F  s itmr=$o(^DHCPHFULITM(0,"Theme",thri,itmr)) Q:itmr=""  D
	.s activeflag=$p(^DHCPHFULITM(itmr),"^",6)
	.Q:activeflag'="Y"   //是否激活
	.s fundr=+$p(^DHCPHFULITM(itmr),"^",3)
	.Q:fundr=0           //函数是否为空
	.s functions=$p($g(^DHCPHFULIB(fundr)),"^",3)
	.s fun=$p(functions,"(",1)_"("_$p(functions,"(",2)
	.s ch=""
	.f  s ch=$o(^DHCPHFULITM(itmr,"I",ch)) q:ch=""  d
	..s itmid=$p(^DHCPHFULITM(itmr,"I",ch),"^",1)
	..s itmminval=$p(^DHCPHFULITM(itmr,"I",ch),"^",2)
	..s itmmaxval=$p(^DHCPHFULITM(itmr,"I",ch),"^",3)
	..s arguments=itmid_"^"_itmminval_"^"_itmmaxval
	..s x="s ret="_fun_"("""_arguments_""")"
    ..x x
    ..Q:(ret="")||(ret="0")
	..i ListData="" s ListData=ret
	..E  s ListData=ListData_"!!"_ret
	Q ListData
}

/// Descript:根据主题生成监测数据
ClassMethod CheckThemeItm() As %String
{
	n (%EpisodeID,%argStDate,%argEndDate)
	s ThemeID=""
	f  s ThemeID=$o(^DHCPHFUTHE(ThemeID)) Q:ThemeID=""  D
	.s ch=""
	.f  s ch=$o(^DHCPHFUTHE(ThemeID,"I",ch)) Q:ch=""  D
	..s ThemeItm=ThemeID_"||"_ch
	..//是否已经存在相同主题检查项目的病人
	..S phAdmExtID=..CheckPatIfExit(%EpisodeID,ThemeItm)
	..//根据主题函数检查数据
	..s MonitorItmList=##class(web.DHCSTPHCMMONITORSYSTASK).ExecMonitorLibFun(ThemeItm)
    ..q:(MonitorItmList="")||(MonitorItmList="0")
    ..//记录监测信息
    ..d ##class(web.DHCSTPHCMMONITORSYSTASK).save(phAdmExtID,%EpisodeID,ThemeItm,MonitorItmList)
    Q 0
}

/// Descript:判断病人是否存在
ClassMethod CheckPatIfExit(EpisodeID, FunTheItmDr) As %String
{
	n (EpisodeID,FunTheItmDr)
	s quitflag=""
	s phAdmExtID=""
	f  s phAdmExtID=$o(^DHCPHM(0,"IndexAdm",EpisodeID,phAdmExtID)) q:(phAdmExtID="")||(quitflag'="")  d
	.s phAdmExtTheItmDr=$p(^DHCPHM(phAdmExtID),"^",2)
	.q:phAdmExtTheItmDr'=FunTheItmDr
	.s phAdmExtDate=$p(^DHCPHM(phAdmExtID),"^",3)
	.//q:phAdmExtDate'=+$H
	.s quitflag=phAdmExtID
	q quitflag
}

/// Descript:住院病人主题监控函数
/// w ##Class(web.DHCSTPHCMMONITORSYSTASK).InHosPatMonitor()
ClassMethod InHosPatMonitor() As %String
{
	///住院病人
	d ##Class(web.DHCSTPHCMMONITORSYSTASK).CurDayInHosPat()
	///监控函数
	s phAdmExtID=""
	f  s phAdmExtID=$o(^DHCPHAE(0,"VisStatusAdmType","Y","I",phAdmExtID)) q:phAdmExtID=""  d
	.s EpisodeID=$p(^DHCPHAE(phAdmExtID),"^",1)
	.s %EpisodeID=EpisodeID
	.s %argStDate=+$h-1
    .s %argEndDate=+$h
	.d ..CheckThemeItm()
	q ""
}

/// Descript:门诊病人
ClassMethod OutHosPatMonitor() As %String
{
	s AdmDr=""
	f  s AdmDr=$o(^PAADMi("PAADM_AdmDate",+$H,AdmDr)) q:AdmDr=""  d
	.s AdmType=$p(^PAADM(AdmDr),"^",2)
	.q:AdmType'="O"
	.s EpisodeID=$p(^PAADM(AdmDr),"^",6)
	.s %EpisodeID=EpisodeID
	.s %argStDate=+$h-1
    .s %argEndDate=+$h
	.d ..CheckThemeItm()
	q ""
}

/// Descript:监测病人是否在院
/// w ##Class(web.DHCSTPHCMMONITORSYSTASK).CheckIfPatInHos()
ClassMethod CheckIfPatInHos() As %String
{
	s num=0
	s phAdmExtID=""
	f  s phAdmExtID=$o(^DHCPHAE(0,"VisStatusAdmType","Y","I",phAdmExtID)) q:phAdmExtID=""  d
	.s EpisodeID=$p(^DHCPHAE(phAdmExtID),"^",1)
	.s AdmType=$p(^PAADM(EpisodeID),"^",2)
	.s patVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .q:(patVisit="A")&(AdmType="I")
    .//d ..UpdPhAdmExt(EpisodeID)
    .W phAdmExtID,!
    .s num=num+1
    q num
}

}
