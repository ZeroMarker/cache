Import sqluser

/// 描述：	ICU前瞻性调查报告
Class web.DHCMedICUInfRes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 547;

/// 作用：		查询病区
/// 编写日期：	2010-03-01
/// 编写者：		lyh
Query FindWardInfo(Ward As %String) As %Query(ROWSPEC = "WardDesc:%String,rowid:%String")
{
}

ClassMethod FindWardInfoExecute(ByRef qHandle As %Binary, Ward As %String) As %Status
{
    S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	s ind=1
	s rowid=0
	s Ward=$$ALPHAUP^SSUTIL4(Ward)
	
	f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
	.s WardDesc=$p($g(^PAWARD(rowid)),"^",2)
	.q:(Ward'="")&&(WardDesc'[Ward)
	.s Data=$lb(WardDesc,rowid)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod FindWardInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod FindWardInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardInfoExecute ]
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

/// 作用:		通过病区找床位
/// 编写日期:	2010-03-01
/// 编写者:		lyh
Query FindBedInfo(WardId As %String) As %Query(ROWSPEC = "BedCode:%String,rowid:%String")
{
}

ClassMethod FindBedInfoExecute(ByRef qHandle As %Binary, WardId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s rowid=""
	q:WardId="" $$$OK
	
	f  s rowid=$o(^PAWARD(WardId,"BED",rowid)) q:rowid=""  d
	.s BedCode=$p($g(^PAWARD(WardId,"BED",rowid)),"^",1)
	.s Data=$lb(BedCode,rowid)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod FindBedInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod FindBedInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedInfoExecute ]
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

/// 作用:	通过床号BedCode,调查日期ResDate查询病人基本信息
/// 日期：	2010-02-26
/// 编写者:	lyh
ClassMethod FindPatBaseInfo(BedDr As %String, ResDate As %String)
{
	n (BedDr,ResDate)

	q:BedDr="" $$$OK
	q:ResDate="" $$$OK
	
	s:ResDate["/" ResDate=$zdh(ResDate,4)
	
	//^PAADMi("TransBed",{TRANS_Bed_DR},{PA_Adm.PAADM_RowID},{TRANS_Childsub})
    
    s PRowid=0,SDate="",EDate="",Paadm="",MRowid="",MrNo="",WardDr="",Ward="",cBedDr="",cBedNo="",ret=-1
    s TSDate="",TSTime="",TChildsub="",WId="",BId="",BedCode="",TBedDr="",TCtlocDr="",FCtloc=""
    
    f  s PRowid=$o(^PAADMi("TransBed",BedDr,PRowid)) q:PRowid=""  d
    .s Childsub=0
    .f  s Childsub=$o(^PAADMi("TransBed",BedDr,PRowid,Childsub)) q:(Childsub="")||(Paadm'="")  d
    ..s SDate=$p($g(^PAADM(PRowid,Childsub)),"^",1)
    ..s EDate=$p($g(^PAADM(PRowid,Childsub)),"^",3)
    ..i (EDate="")||((SDate<=ResDate)&(ResDate<=EDate)) d    //当调查日期在开始日期和结束日期之内
    ...s Paadm=PRowid
    ...s WardDr=$p($g(^PAADM(PRowid,Childsub)),"^",9)
    ...s cBedDr=$p($g(^PAADM(PRowid,Childsub)),"^",8)
    
    q:Paadm="" $$$OK
    s ret=..FindPatInfoFromPaadm(Paadm,WardDr,cBedDr)
    
    s TSDate=$o(^PAADMi("TransDateTime1",Paadm,ResDate),-1)
    s:TSDate'="" TSTime=$o(^PAADMi("TransDateTime1",Paadm,TSDate,""),-1)
    s:TSTime'="" TChildsub=$o(^PAADMi("TransDateTime1",Paadm,TSDate,TSTime,""),-1)
    
    s:TChildsub'="" TBedDr=$p($g(^PAADM(Paadm,"TRANS",TChildsub)),"^",8)
    s:TChildsub'="" TCtlocDr=$p($g(^PAADM(Paadm,"TRANS",TChildsub)),"^",6)
    s:TBedDr'="" WId=$p(TBedDr,"||",1)
    s:TBedDr'="" BId=$p(TBedDr,"||",2)
    s:((WId'="")&(BId'="")) BedCode=$p($g(^PAWARD(WId,"BED",BId)),"^",1)
    s TBed=TBedDr_"~"_BedCode
	
	s:TCtlocDr'="" FCtloc=$p($g(^CTLOC(TCtlocDr)),"^",2)
	s FCtloc=TCtlocDr_"~"_FCtloc
	
	s ret=ret_"^"_FCtloc_"^"_TBed
	s ^lyh=ret
    q ret
}

ClassMethod FindPatInfoFromPaadm(Paadm, WardDr, cBedDr)
{
	n (Paadm,WardDr,cBedDr)
	q:Paadm="" $$$OK
	s MrNo="",Ward="",MRowid="",cBedNo=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	d Config.%Close()
	zn MEDDATA
    s s=$$GetPaadmBaseInfo^DHCMedBasePaadm(Paadm)
	zn CurrentNS
	
	//update by zf 病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set MrNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(Paadm,"I","")
	} else {
		s PapmiDr=$p(^PAADM(Paadm),"^",1)
		s:PapmiDr'="" MRowid=$o(^DHCWMRMAIN(0,"PAPMI",PapmiDr,""),-1)
		s:MRowid'="" MrNo=$p($g(^DHCWMRMAIN(MRowid)),"^",2)
	}
	
	s:WardDr'="" Ward=$p($g(^PAWARD(WardDr)),"^",2)
	s:cBedDr'="" cBedNo=$p($g(^PAWARD(cBedDr)),"^",1)
	s s=s_"^"_MrNo_"^"_Ward_"^"_cBedNo
	
	
	//s=GetAdmInfo_"^"_papmino_"^"_name_"^"_sex_"^"_birthdate_"^"_age
	//GetAdmInfo=paadm_"^"_AdmType_"^"_AdmNo_"^"_AdmDate_"^"_AdmTime_"^"_papmi_"^"_LocDesc_"^"_DocDesc_"^"_WardDesc_"^"_RoomDesc_"^"_BedDesc_"^"_DischgDate_"^"_DischgTime_"^"_MrNo
	
	q s
}

/// 作用:		通过字典类型找到Rowid和描述
/// 编写日期:	2010-03-01
/// 编写者:		lyh
Query QueryListName(MDicType As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

ClassMethod QueryListNameExecute(ByRef qHandle As %Binary, MDicType As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s MDicCode=""
	
	q:MDicType="" $$$OK
	//^DHCMDIC("0","TypeCode",{MDIC_Type},{MDIC_Code},{MDIC_Rowid}) 
	f  s MDicCode=$o(^DHCMDIC(0,"TypeCode",MDicType,MDicCode)) q:MDicCode=""  d
	.s rowid=""
	.f  s rowid=$o(^DHCMDIC(0,"TypeCode",MDicType,MDicCode,rowid)) q:rowid=""  d
	..s MDicDesc=$P($g(^DHCMDIC(rowid)),"^",2)
	..s Data=$lb(rowid,MDicDesc)
	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryListNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryListNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryListNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryListNameExecute ]
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

/// 作用:		往User.DHCMedICURes里面插数据
/// 编写日期：	2010-02-27
/// 编写者:		lyh
ClassMethod InsertDataDet(Str)
{
    n (Str)
    s ret=-1
    q:Str="" ret

	s PLIST(2)=$p(Str,"^",1)
	s PLIST(3)=$p(Str,"^",2)
	s PLIST(4)=$p(Str,"^",3) 
	s PLIST(5)=$p(Str,"^",4)
	s PLIST(6)=$p(Str,"^",5)
	s PLIST(7)=$p(Str,"^",6)
	s PLIST(8)=$p(Str,"^",7)
	s PLIST(9)=$p(Str,"^",8)
	s PLIST(10)=$p(Str,"^",9)
	s PLIST(11)=$p(Str,"^",10)
	s PLIST(12)=$p(Str,"^",11)
	s PLIST(13)=$p(Str,"^",12)
	s PLIST(14)=$p(Str,"^",13)
	s PLIST(15)=$p(Str,"^",14)
	s PLIST(16)=$p(Str,"^",15)
	s PLIST(17)=$p(Str,"^",16)
	s PLIST(18)=$p(Str,"^",17)
	s PLIST(19)=$p(Str,"^",18)
	s PLIST(20)=$p(Str,"^",19)
	s PLIST(21)=$p(Str,"^",20)
	s:$p(Str,"^",21)["/" PLIST(22)=$zdh($p(Str,"^",21),4)
	s PLIST(23)=$p(Str,"^",22)
	s PLIST(24)=$p(Str,"^",23)
	s:$p(Str,"^",24)["/" PLIST(25)=$zdh($p(Str,"^",24),4)
	s:$p(Str,"^",25)[":" PLIST(26)=$zth($p(Str,"^",25),2)
	s PLIST(27)=$p(Str,"^",26)
	s PLIST(28)=$p(Str,"^",27)
	s PLIST(29)=$p(Str,"^",28)  

    if ($o(^User.DHCMedICUResI("ResDate"," "_PLIST(22)," "_PLIST(4)," "_PLIST(5),""))="")
    {
		s obj=##class(User.DHCMedICURes).%New()
		s obj.IsActive="Y"
		s obj.ResPaadm=PLIST(2)
    	s obj.ResCurrentWard=PLIST(4)
  		s obj.ResCurrentBed=PLIST(5)
   		s obj.ResCtlocNum =PLIST(6)
    	s obj.ResDeepVeinPipe=PLIST(7)
    	s obj.ResUrinePipe=PLIST(8)
    	s obj.ResWindPipeOrCut=PLIST(9)
    	s obj.ResTopTemp =PLIST(10)
    	s obj.ResBloodInf=PLIST(11)
    	s obj.ResUrinaryInf =PLIST(12)
    	s obj.ResPneuInf =PLIST(13)
    	s obj.ResInfNum=PLIST(14)
    	s obj.ResInfBacilliNum1 =PLIST(15)
    	s obj.ResCulResNum11 =PLIST(16)
    	s obj.ResCulResNum12=PLIST(17)
    	s obj.ResPrognosisRes =PLIST(18)
    	s obj.ResResNo=PLIST(19)
    	s obj.ResTraLoc=PLIST(20)
    	s obj.ResForBed =PLIST(21)
    	s obj.ResResDate=PLIST(22)
    	s obj.ResBesesetDiag =PLIST(23)
    	s obj.ResRecNo =PLIST(24)
    	s obj.ResRecDate =PLIST(25)
    	s obj.ResRecTime =PLIST(26)
    	s obj.ResInfBacilliNum2 =PLIST(27)
		s obj.ResCulResNum21 =PLIST(28)
    	s obj.ResCulResNum22 =PLIST(29)
		set rt=obj.%Save()
		If ($$$ISERR(rt)) {
			;w !,"Error="_rt
			s id="-1"_rt
		}
		else
		{
			s id=obj.%Id()
		}
	
		d obj.%Close()
    }
 
    else 
    {
	    s rowid=$o(^User.DHCMedICUResI("ResDate"," "_PLIST(22)," "_PLIST(4)," "_PLIST(5),""))
    	s obj=##class(User.DHCMedICURes).%OpenId(+rowid)
		s obj.ResPaadm=PLIST(2)
    	s obj.ResCurrentWard=PLIST(4)
  		s obj.ResCurrentBed=PLIST(5)
   		s obj.ResCtlocNum =PLIST(6)
    	s obj.ResDeepVeinPipe=PLIST(7)
    	s obj.ResUrinePipe=PLIST(8)
    	s obj.ResWindPipeOrCut=PLIST(9)
    	s obj.ResTopTemp =PLIST(10)
    	s obj.ResBloodInf=PLIST(11)
    	s obj.ResUrinaryInf =PLIST(12)
    	s obj.ResPneuInf =PLIST(13)
    	s obj.ResInfNum=PLIST(14)
    	s obj.ResInfBacilliNum1 =PLIST(15)
    	s obj.ResCulResNum11 =PLIST(16)
    	s obj.ResCulResNum12=PLIST(17)
    	s obj.ResPrognosisRes =PLIST(18)
    	s obj.ResResNo=PLIST(19)
    	s obj.ResTraLoc=PLIST(20)
    	s obj.ResForBed =PLIST(21)
    	s obj.ResResDate=PLIST(22)
    	s obj.ResBesesetDiag =PLIST(23)
    	s obj.ResRecNo =PLIST(24)
    	s obj.ResRecDate =PLIST(25)
    	s obj.ResRecTime =PLIST(26)
    	s obj.ResInfBacilliNum2 =PLIST(27)
		s obj.ResCulResNum21 =PLIST(28)
    	s obj.ResCulResNum22 =PLIST(29)
	    
		set rt=obj.%Save()
	
		If ($$$ISERR(rt)) {
			;w !,"Error="_rt
			s id="-1"_rt
		}
		else
		{
			s id=obj.%Id()
		}
	
		d obj.%Close()
    }
	q id
}

/// 作用:		通过年、月、床号查询ICU前瞻性调查报告信息
/// 编写日期:	2010-03-01
/// 编写者:		lyh
Query FindICUResData(cResYear As %String, cResMonth As %String, cBedNo As %String, cCurrentWard As %String) As %Query(ROWSPEC = "ResDate:%String,ResAge:%String,ResBloodInf:%String,ResCtlocNum:%String,ResInfBacilliNum1:%String,ResInfBacilliNum2:%String,ResDeepVeinPipe:%String,ResForBed:%String,ResIPNo:%String,ResInfNum:%String,ResPatientName:%String,ResPneuInf:%String,ResPrognosisRes:%String,ResSex:%String,ResTopTemp:%String,ResTraLoc:%String,ResUrinaryInf:%String,ResUrinePipe:%String,ResWeek:%String,ResWindPipeOrCut:%String,ResCurrentBed:%String,ResNo:%String,ResBasesetDiag:%String,ResCulResNum11:%String,ResCulResNum12:%String,ResCulResNum21:%String,ResCulResNum22:%String")
{
}

ClassMethod FindICUResDataExecute(ByRef qHandle As %Binary, cResYear As %String, cResMonth As %String, cBedNo As %String, cCurrentWard As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s rowid="",sDate="",eDate="",CurrentDate="",s=""

	q:cResYear="" $$$OK
	q:cResMonth="" $$$OK
	q:cBedNo="" $$$OK
	q:cCurrentWard="" $$$OK
	s cResMonth=+cResMonth
	s cResYear=+cResYear
	s sDate=cResMonth_"/"_1_"/"_cResYear

	s sDate=$zdh(sDate)
	
	s:cResMonth=12 eDate=$zdh(1_"/"_1_"/"_cResYear+1)
	s:cResMonth'=12 eDate=$zdh(cResMonth+1_"/"_1_"/"_cResYear)-1
	
	q:sDate>eDate $$$OK
	
	f CurrentDate=sDate:1:eDate d
	.s ResAge="",ResBloodInf="",ResCtlocNum="",ResCulResNumFive="",ResCulResNumFour=""
	.s ResCulResNumOne="",ResCulResNumSix="",ResCulResNumThree="",ResCulResNumTwo=""
	.s ResDate="",ResDeepVienPipe="",ResForBed="",ResIPNo="",ResInfBaciliNum="",ResInfNum=""
	.s ResNo="",ResPatientName="",ResPneuInf="",ResPrognosisRes="",ResSex="",ResTopTemp=""
	.s ResTraLoc="",ResUrinaryInf="",ResUrinePipe="",ResWeek="",ResWindPipeOrCut="",ResCulResNumSix="",ResNo=""
	.s ResCurrentBed="",ResCurrentWard="",s="",rowid="",ResBasesetDiag=""
	.s rowid=$o(^User.DHCMedICUResI("ResDate"," "_CurrentDate," "_cCurrentWard," "_cBedNo,""))
	.s:rowid'="" s=$g(^User.DHCMedICUResD(rowid))
	.i s'="" d
	..;s IsActive=$li(s,2)
	..s ResBesesetDiag=$li(s,3)
	..s ResBloodInf=$li(s,4)
	..s ResCtlocNum=$li(s,5)
	..s ResCulResNum11=$li(s,6)
	..s ResCulResNum12=$li(s,7)
	..s ResCulResNum21=$li(s,8)
	..s ResCulResNum22=$li(s,9)
	..s ResCurrentBed=$li(s,10)
	..s ResDeepVeinPipe=$li(s,11)
	..s ResForBed=$li(s,12)
	..s ResInfBacilliNum1=$li(s,13)
	..s ResInfBacilliNum2=$li(s,14)
	..s ResInfNum=$li(s,15)
	..s ResPaadm=$li(s,16)
	..s ResPneuInf=$li(s,17)
	..s ResPrognosisRes=$li(s,18)
	..s ResRecDate=$li(s,19)
	..s ResRecNo=$li(s,20)
	..s ResRecTime=$li(s,21)
	..s ResResDate=$li(s,22)
	..s ResResNo=$li(s,23)
	..s ResResTime=$li(s,24)
	..s ResTopTemp=$li(s,25)
	..s ResTraLoc=$li(s,26)
	..s ResUrinaryInf=$li(s,27)
	..s ResUrinePipe=$li(s,28)
	..s ResWindPipeOrCut=$li(s,29)
	..s Resume=$li(s,30)
	..s ResCurrentWard=$li(s,31)
	..s ResPaadm=..FindPatInfoFromPaadm(ResPaadm,ResCurrentWard,ResCurrentBed)
    ..d OutputRow
 	.e  d
 	..s Data=$lb(ind)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	
 	Quit $$$OK
OutputRow
    s ResAge=+$p(ResPaadm,"^",18)
    s ResIPNo=+$p(ResPaadm,"^",19)
    s ResPatientName=$p(ResPaadm,"^",15)
    s ResSex=$p(ResPaadm,"^",16)
    s:ResBloodInf'="" ResBloodInf=..GetCodeInfoFromId(ResBloodInf)
    s:ResCtlocNum'="" ResCtlocNum=..GetCodeInfoFromId(ResCtlocNum)
	
	s:ResTraLoc'="" ResTraLoc=$p($p($g(^CTLOC(ResTraLoc)),"^",2),"-",2)
	
    s:ResInfBacilliNum1'="" ResInfBacilliNum1=..GetCodeInfoFromId(ResInfBacilliNum1)
    s:ResInfBacilliNum2'="" ResInfBacilliNum2=..GetCodeInfoFromId(ResInfBacilliNum2)
    s:ResDeepVeinPipe'="" ResDeepVeinPipe=..GetCodeInfoFromId(ResDeepVeinPipe)
  
    s:ResPneuInf'="" ResPneuInf=..GetCodeInfoFromId(ResPneuInf)
    s:ResPrognosisRes'="" ResPrognosisRes=..GetCodeInfoFromId(ResPrognosisRes)
    s:ResUrinaryInf'="" ResUrinaryInf=..GetCodeInfoFromId(ResUrinaryInf)
    s:ResUrinePipe'="" ResUrinePipe=..GetCodeInfoFromId(ResUrinePipe)
    s:ResWindPipeOrCut'="" ResWindPipeOrCut=..GetCodeInfoFromId(ResWindPipeOrCut)
    s:ResCulResNum11'="" ResCulResNum11=..GetCodeInfoFromId(ResCulResNum11)
    s:ResCulResNum12'="" ResCulResNum12=..GetCodeInfoFromId(ResCulResNum12)
    s:ResCulResNum21'="" ResCulResNum21=..GetCodeInfoFromId(ResCulResNum21)
    s:ResCulResNum22'="" ResCulResNum22=..GetCodeInfoFromId(ResCulResNum22)    

    s cWeek=$zd(ResResDate,10)
    s ResWeek=$s(cWeek=1:"星期一",cWeek=2:"星期二",cWeek=3:"星期三",cWeek=4:"星期四",cWeek=5:"星期五",cWeek=6:"星期六",cWeek=0:"星期天",1:"")

	s Data=$lb(ind,ResAge,ResBloodInf,ResCtlocNum,ResInfBacilliNum1,ResInfBacilliNum2,ResDeepVeinPipe,ResForBed,ResIPNo,ResInfNum,ResPatientName,ResPneuInf,ResPrognosisRes,ResSex,ResTopTemp,ResTraLoc,ResUrinaryInf,ResUrinePipe,ResWeek,ResWindPipeOrCut,ResCurrentBed,ResResNo,ResBesesetDiag,ResCulResNum11,ResCulResNum12,ResCulResNum21,ResCulResNum22)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUResDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUResDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod FindICUResDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUResDataExecute ]
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

/// 作用：		导出ICU前瞻性调查报告数据
/// 编写日期:	2010-03-01
/// 编写者：		lyh
ClassMethod QryDataToPrint(itmjs, strArguments)
{
	n (itmjs,strArguments)
	s Count=0
	s ResYear=+$p(strArguments,"^",1)
	s ResMonth=+$p(strArguments,"^",2)
	s BedNo=$p(strArguments,"^",3)
	s CurrentWard=$p(strArguments,"^",4)

    s ds = ##class(%Library.ResultSet).%New("web.DHCMedICUInfRes:FindICUResData")
	d ds.Execute(ResYear,ResMonth,BedNo,CurrentWard)	
	s StartRow=2

    while(ds.Next())
	{
		s ResDate=ds.Data("ResDate")
		s ResAge=ds.Data("ResAge")
		s ResBloodInf=ds.Data("ResBloodInf")
		s ResCtlocNum=ds.Data("ResCtlocNum")
		s ResInfBacilliNum1=ds.Data("ResInfBacilliNum1")
		s ResInfBacilliNum2=ds.Data("ResInfBacilliNum2")
		s ResDeepVeinPipe=ds.Data("ResDeepVeinPipe")
		s ResForBed=ds.Data("ResForBed")
		s ResIPNo=ds.Data("ResIPNo")
		s ResInfNum=ds.Data("ResInfNum")
		s ResPatientName=ds.Data("ResPatientName")
		s ResPneuInf=ds.Data("ResPneuInf")
		s ResPrognosisRes=ds.Data("ResPrognosisRes")
		s ResSex=ds.Data("ResSex")
		s ResTopTemp=ds.Data("ResTopTemp")
		s ResTraLoc=ds.Data("ResTraLoc")
		s ResUrinaryInf=ds.Data("ResUrinaryInf")
		s ResUrinePipe=ds.Data("ResUrinePipe")
		s ResWeek=ds.Data("ResWeek")
		s ResWindPipeOrCut=ds.Data("ResWindPipeOrCut")
		s ResCurrentBed=ds.Data("ResCurrentBed")
		s ResNo=ds.Data("ResNo")
		s ResBasesetDiag=ds.Data("ResBasesetDiag")
		s ResCulResNum11=ds.Data("ResCulResNum11")
		s ResCulResNum12=ds.Data("ResCulResNum12")
		s ResCulResNum21=ds.Data("ResCulResNum21")
		s ResCulResNum22=ds.Data("ResCulResNum22")
        s:((ResInfBacilliNum1="")||(ResInfBacilliNum2="")) ResInfBacilliNum1=ResInfBacilliNum1_ResInfBacilliNum2
		s:((ResInfBacilliNum1'="")&(ResInfBacilliNum2'="")) ResInfBacilliNum1=ResInfBacilliNum1_"/"_ResInfBacilliNum2
		
		s:((ResCulResNum11="")||(ResCulResNum12="")) ResCulResNum11=ResCulResNum11_ResCulResNum12
		s:((ResCulResNum11'="")&(ResCulResNum12'="")) ResCulResNum11=ResCulResNum11_","_ResCulResNum12
		
		s:((ResCulResNum21="")||(ResCulResNum22="")) ResCulResNum21=ResCulResNum21_ResCulResNum22
		s:((ResCulResNum21'="")&(ResCulResNum22'="")) ResCulResNum21=ResCulResNum21_","_ResCulResNum22
		
		
		
		s valCells=ResDate_$c(1)_ResWeek_$c(1)_ResPatientName_$c(1)_ResIPNo_$c(1)_ResSex_$c(1)_ResAge_$c(1)_ResBasesetDiag_$c(1)_ResCtlocNum_$c(1)_ResDeepVeinPipe_$c(1)_ResUrinePipe_$c(1)_ResWindPipeOrCut_$c(1)_ResTopTemp_$c(1)_ResBloodInf_$c(1)_ResUrinaryInf_$c(1)_ResPneuInf_$c(1)_ResInfNum_$c(1)_ResInfBacilliNum1_$c(1)_ResCulResNum11_$c(1)_ResCulResNum21_$c(1)_ResPrognosisRes_$c(1)_ResNo_$c(1)_ResTraLoc_$c(1)_ResForBed
	 	f i=1:1:$l(valCells,$c(1)) 
	 	{
		 	s Cells=$p(valCells,$c(1),i)
		 	s LineNum=i+3
	 		s retval=itmjs_"(xlSheet,'"_$ZCVT(Cells,"O","JS")_"',"_LineNum_","_StartRow_");"
			&javascript<#(retval)#>
	 	}
	 	s Count=Count+1
	  	s StartRow=StartRow+1
	}
	s valCells=ResYear_"年"_ResMonth_"月"_"01日"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,17);"
	&javascript<#(retval)#>
	s cBed=$p($g(^PAWARD(CurrentWard,"BED",BedNo)),"^",1)
	s valCells=cBed
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,22);"
	&javascript<#(retval)#>

    q Count
}

Query FindCtlocInfo(CtlocId As %String) As %Query(ROWSPEC = "CtlocDesc:%String:科室,rowid:%String")
{
}

ClassMethod FindCtlocInfoExecute(ByRef qHandle As %Binary, CtlocId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s CtlocId=$$ALPHAUP^SSUTIL4(CtlocId)
	
 	s ctlocRowid=0 f  s ctlocRowid=$o(^CTLOC(ctlocRowid)) q:ctlocRowid=""  d
    .s ctlocRowid=+ctlocRowid
    .s ctlctype=$p(^CTLOC(ctlocRowid),"^",13)
    .;q:(ctlctype="E")
    .s ctlcDesc=$p(^CTLOC(ctlocRowid),"^",2)
    .q:((CtlocId'="")&&(ctlcDesc'[CtlocId))
	.s Data=$lb(ctlcDesc,ctlocRowid)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod FindCtlocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtlocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod FindCtlocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtlocInfoExecute ]
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

/// 作用：		通过字典类型查询数据
/// 编写日期：	2010-03-11
/// 编写者：	lyh
Query QueryDataFromName(MDicType As %String, Flag As %String, BacNum As %String, cDesc As %String) As %Query(ROWSPEC = "Desc:%String,Rowid:%String")
{
}

ClassMethod QueryDataFromNameExecute(ByRef qHandle As %Binary, MDicType As %String, Flag As %String, BacNum As %String, cDesc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s MDicCode=""
	q:MDicType="" $$$OK
	q:((Flag=1)&(+BacNum'>0)) $$$OK
	
	//^DHCMDIC("0","TypeCode",{MDIC_Type},{MDIC_Code},{MDIC_Rowid}) 
	f  s MDicCode=$o(^DHCMDIC(0,"TypeCode",MDicType,MDicCode)) q:MDicCode=""  d
	.s rowid=""
	.f  s rowid=$o(^DHCMDIC(0,"TypeCode",MDicType,MDicCode,rowid)) q:rowid=""  d
	..s MDicDesc=$P($g(^DHCMDIC(rowid)),"^",2)
	..q:((cDesc'="")&(MDicDesc'[cDesc))
	..s Data=$lb(MDicDesc,rowid)
	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryDataFromNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDataFromNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryDataFromNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryListNameExecute ]
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

/// 作用:		通过报告日期、病区、床位查询该床位是否已经上报
/// 编写日期：	2010-03-11
/// 编写者：	lyh
ClassMethod CheckRepDet(Str)
{
    n (Str)
    s ret=-1

	s ResDate=$p(Str,"^",1)
    s:ResDate["/" ResDate=$zdh(ResDate,4)
    s WardId=$p(Str,"^",2)
    s BedId=$p(Str,"^",3)
    
    q:ResDate="" ret
    q:WardId="" ret
    q:BedId="" ret
    
    s rowid=$o(^User.DHCMedICUResI("ResDate"," "_ResDate," "_WardId," "_BedId,""))
    q:rowid="" ret
	s s=$g(^User.DHCMedICUResD(rowid))
	q:s="" ret
	
	s IsActive=$li(s,2)
	s ResBesesetDiag=$li(s,3)
	s ResBloodInf=$li(s,4)
	s ResCtlocNum=$li(s,5)
	s ResCulResNum11=$li(s,6)
	s ResCulResNum12=$li(s,7)
	s ResCulResNum21=$li(s,8)
	s ResCulResNum22=$li(s,9)
	s ResCurrentBed=$li(s,10)
	s ResDeepVeinPipe=$li(s,11)
	s ResForBed=$li(s,12)
	s ResInfBacilliNum1=$li(s,13)
	s ResInfBacilliNum2=$li(s,14)
	s ResInfNum=$li(s,15)
	s ResPaadm=$li(s,16)
	s ResPneuInf=$li(s,17)
	s ResPrognosisRes=$li(s,18)
	s ResRecDate=$li(s,19)
	s ResRecNo=$li(s,20)
	s ResRecTime=$li(s,21)
	s ResResDate=$li(s,22)
	s ResResNo=$li(s,23)
	s ResResTime=$li(s,24)
	s ResTopTemp=$li(s,25)
	s ResTraLoc=$li(s,26)
	s ResUrinaryInf=$li(s,27)
	s ResUrinePipe=$li(s,28)
	s ResWindPipeOrCut=$li(s,29)
	s Resume=$li(s,30)
	s ResCurrentWard=$li(s,31)
	
	s ResRecDate=$zd(+ResRecDate,4)
	s ResRecTime=$zt(+ResRecTime,2)
	s ResCulResNum11=..GetDicInfoFromId(ResCulResNum11)
	s ResCulResNum12=..GetDicInfoFromId(ResCulResNum12)
	s ResCulResNum21=..GetDicInfoFromId(ResCulResNum21)
	s ResCulResNum22=..GetDicInfoFromId(ResCulResNum22)
	s ResInfBacilliNum1=..GetDicInfoFromId(ResInfBacilliNum1)
	s ResInfBacilliNum2=..GetDicInfoFromId(ResInfBacilliNum2)
	
	s:ResTraLoc'="" ResTraLoc=ResTraLoc_"~"_$p(^CTLOC($g(ResTraLoc)),"^",2)
	
	s ResPaadm=..FindPatInfoFromPaadm(ResPaadm,ResCurrentWard,ResCurrentBed)
	s ResCurrentBed=ResCurrentBed_"~"_$p($g(^PAWARD(ResCurrentWard,"BED",ResCurrentBed)),"^",1)
	s ResCurrentWard=ResCurrentWard_"~"_$p($g(^PAWARD(ResCurrentWard)),"^",2)
	
	s ret=ResBesesetDiag_"^"_ResBloodInf_"^"_ResCtlocNum_"^"_ResCulResNum11_"^"_ResCulResNum12_"^"_ResCulResNum21_"^"_ResCulResNum22_"^"_ResCurrentBed_"^"_ResCurrentWard_"^"_ResDeepVeinPipe
	s ret=ret_"^"_ResForBed_"^"_ResInfBacilliNum1_"^"_ResInfBacilliNum2_"^"_ResInfNum_"^"_ResPneuInf_"^"_ResPrognosisRes_"^"_ResRecDate_"^"_ResRecNo_"^"_ResRecTime
	s ret=ret_"^"_ResTopTemp_"^"_ResTraLoc_"^"_ResUrinaryInf_"^"_ResUrinePipe_"^"_ResWindPipeOrCut_"^"_Resume_"^"_ResPaadm
	
	q ret
}

/// 作用：		删除报告
/// 编写日期：	2010-03-11
/// 编写者:		lyh
ClassMethod DeleteRep(Str)
{
	n (Str)
	s ret=-1

	s ResDate=$p(Str,"^",1)
    s:ResDate["/" ResDate=$zdh(ResDate,4)
    s WardId=$p(Str,"^",2)
    s BedId=$p(Str,"^",3)
    
    q:ResDate="" ret
    q:WardId="" ret
    q:BedId="" ret
	
	s rowid=$o(^User.DHCMedICUResI("ResDate"," "_ResDate," "_WardId," "_BedId,""))
    q:rowid="" ret
	s s=$g(^User.DHCMedICUResD(rowid))
	q:s="" ret
	
	&SQL(delete from DHCMedICURes where ID=:rowid )
	q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetDicInfoFromId(Str)
{
	n (Str)
	q:Str="" "~"
	
	s cDesc=$p($g(^DHCMDIC(Str)),"^",2)
	s ret=Str_"~"_cDesc
	
	q ret
}

ClassMethod GetCodeInfoFromId(Str)
{
	n (Str)
	q:Str="" "~"
	
	s cCode=$p($g(^DHCMDIC(Str)),"^",1)
	s ret=cCode
	
	q ret
}

/// 作用:		通过报告表rowid查询报告
/// 编写日期:	2010-03-11
/// 编写者:		lyh
Query QueryRepInfo(SDate As %String, EDate As %String, Ward As %String, Bed As %String) As %Query(ROWSPEC = "rowid:%String,PatName:%String,ResCurrentWard:%String,ResCurrentBed:%String,ResResNo:%String,ResRecNo:%String,Str:%String")
{
}

ClassMethod QueryRepInfoExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, Ward As %String, Bed As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s rowid=0
    q:SDate="" $$$OK
    s:SDate["/" SDate=$zdh(SDate,4)
    s:EDate["/" EDate=$zdh(EDate,4)
    q:((EDate'="")&(EDate<SDate)) $$$OK
    s ^lyh=EDate_"^"_SDate
	f  s rowid=$o(^User.DHCMedICUResD(rowid)) q:rowid=""  d
	.s s=$g(^User.DHCMedICUResD(rowid))
	.i s="" q 
	.e  d 
	..s ResResDate=$li(s,22)
	..s ^aa=ResResDate_"&&"
	..q:((EDate="")&&(SDate'=ResResDate))
	..q:ResResDate>EDate
	..q:ResResDate<SDate
	..s ResPaadm=$li(s,16)
	..s ResResNo=$li(s,23)
	..s ResRecNo=$li(s,20)
	..s ResCurrentBedId=$li(s,10)
	..s ResCurrentWardId=$li(s,31)
	..q:((Ward'="")&&(Ward'=ResCurrentWardId))
	..q:((Bed'="")&&(Bed'=ResCurrentBedId))
	..s:ResPaadm'="" ResPaadm=..FindPatInfoFromPaadm(ResPaadm,ResCurrentWardId,ResCurrentBedId)
	..s PatName=$p($g(ResPaadm),"^",15)
	..s ResCurrentBed=$p($g(^PAWARD(ResCurrentWardId,"BED",ResCurrentBedId)),"^",1)
	..s ResCurrentWard=$p($g(^PAWARD(ResCurrentWardId)),"^",2)
	..s Str=ResResDate_"^"_ResCurrentWardId_"^"_ResCurrentBedId_"^"_$zd(ResResDate,4)
	..s Data=$lb(rowid,PatName,ResCurrentWard,ResCurrentBed,ResResNo,ResRecNo,Str)
	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRepInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRepInfoExecute ]
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

}
