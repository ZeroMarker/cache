Import SQLUser

/// 病案卷查询
Class web.DHCWMRCircul.VolumeQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 295;

ClassMethod QryVolumeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolumeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVolumeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit $$$OK
}

ClassMethod QryVolumeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolumeExecute ]
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

/// 空查询,有用,不能删除
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRICDQry","QryVolume")
Query QryVolume() As %Query(ROWSPEC = "Rowid:%String,Desc:%String")
{
}

/// 出院病案回收查询
/// w ##Class(web.DHCWMRCircul.VolumeQry).QryDischVol(7,2,20,"Y","","","","","","")
ClassMethod QryDischVol(MrType, WorkFlow, WorkItem, IsFinish, Loc, Ward, MrNo, BarCode, RegNo, DateFrom, DateTo)
{
	n (MrType, WorkFlow, WorkItem, IsFinish, Loc, Ward, MrNo, BarCode,RegNo,DateFrom,DateTo)
	s JInd=$j,Count=0,ret=JInd_"^"_Count
	
	k ^CacheTemp("MRVol",JInd)
	k ^CacheTemp("MRVolTmp",JInd)
	q:(MrType="")||(WorkFlow="")||(WorkItem="") ret
	
	s IsFinish=$s(IsFinish["Y":"Y",1:"N")
	s QryItem=""
	i IsFinish="N" d
	.s SubId=$o(^DHCWMRWFLOW(+WorkFlow,"S",0,"ItemDr",+WorkItem,""),-1)
	.q:(+SubId)<1
	.s PrevSubId=$o(^DHCWMRWFLOW(WorkFlow,"S",SubId),-1)
	.q:(+PrevSubId)<1
	.s PrevWorkItem=$p($g(^DHCWMRWFLOW(WorkFlow,"S",PrevSubId)),"^",2)
	.s QryItem=PrevWorkItem
	.s StaItem=PrevWorkItem
	e  d
	.s QryItem=WorkItem
	.s StaItem=WorkItem
	.s sFlow=##class(web.DHCWMRCircul.WorkFlow).GetWorkItemsByFlow(WorkFlow)
	.s sItem=##class(web.DHCWMRWorkItemCtl).GetDataById(WorkItem)
	.s IsOrderItem=$s($p($g(^DHCWMRDIC(+$p(sItem,"^",2))),"^",3)["顺序":"Y",1:"N")
	.s IsLastItem=##class(web.DHCWMRCircul.Operation).CheckItemIsLast(WorkItem,sFlow)
	.s:(IsOrderItem="N")&&(IsLastItem="Y") QryItem=$p($p(sFlow,$c(1),1),"^",3)
	q:QryItem="" ret
	
	s IPNo=""
	s Hosp=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
	s HospCode=$p(Hosp,"/",4)
	i HospCode="ChengDu_HX" d
	.s IPNo=MrNo
	.s MrNo=""
	
	//查询有效病案卷
	i RegNo'="" d          //通过登记号查询
	.s RegNo=##Class(web.DHCWMRCommon.Base01).RegNoCon(RegNo)
	.q:RegNo=""
	.;取病案类型设置
	.s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	.q:strMrType=""
	.s MrNoField=$p($p(strMrType,"^",5),"/",2)
	.q:MrNoField=""
	.;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	.q:'$d(^PAPERi("PAPMI_PatNo",RegNo))
	.s Papmi=0
	.f  s Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,Papmi)) q:Papmi=""  d
	..q:'$d(^PAPER(Papmi))
	..;paperson.paper_governcardno
	..s:MrNoField="A" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(Papmi)
	..;PA_PatMas.PAPMI_Medicare
	..s:MrNoField="B" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(Papmi)
	..;User.DHCPerson.PAPERFCMedicareCode1
	..s:MrNoField="C" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(Papmi)
	..;User.DHCPerson.PAPERFCMedicareCode2
	..s:MrNoField="D" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(Papmi)
	..q:tmpMrNo=""
	..;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	..q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,tmpMrNo))
	..s MainId=0
	..f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,tmpMrNo,MainId)) q:MainId=""  d
	...s tmpMain=$g(^DHCWMRMAIN(MainId))
	...q:tmpMain=""
	...q:$p(tmpMain,"^",6)'="Y"
	...;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
	...s VolId=0
	...f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
	....s tmpVol=$g(^DHCWMRVOL(VolId))
	....q:tmpVol=""
	....q:$p(tmpVol,"^",7)'="Y"
	....s VolWorkItem=$p(tmpVol,"^",6)
	....q:VolWorkItem'=QryItem
	....s ^CacheTemp("MRVolTmp",JInd,VolId)=""
	
	i MrNo'="" d           //通过病案查询
	.;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	.q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo))
	.s MainId=0
	.f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,MainId)) q:MainId=""  d
	..s tmpMain=$g(^DHCWMRMAIN(MainId))
	..q:tmpMain=""
	..q:$p(tmpMain,"^",6)'="Y"
	..;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
	..s VolId=0
	..f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
	...s tmpVol=$g(^DHCWMRVOL(VolId))
	...q:tmpVol=""
	...q:$p(tmpVol,"^",7)'="Y"
	...s VolWorkItem=$p(tmpVol,"^",6)
	...q:VolWorkItem'=QryItem
	...s ^CacheTemp("MRVolTmp",JInd,VolId)=""
	
	i IPNo'="" d             //通过就诊IP号查询
	.;^PAADMi("No",$$ALPHAUP({PAADM_ADMNo}),{PAADM_RowID})
	.q:'$d(^PAADMi("No",IPNo))
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("No",IPNo,Paadm)) q:Paadm=""  d
	..;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	..q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm))
	..s VolId=0
	..f  s VolId=$o(^DHCWMRVOL(0,"VolAdm",Paadm,VolId)) q:VolId=""  d
	...s tmpVol=$g(^DHCWMRVOL(VolId))
	...q:tmpVol=""
	...q:$p(tmpVol,"^",7)'="Y"
	...s VolWorkItem=$p(tmpVol,"^",6)
	...q:VolWorkItem'=QryItem
	...s tmpMain=$g(^DHCWMRMAIN(+$p(tmpVol,"^",1)))
	...q:tmpMain=""
	...q:$p(tmpMain,"^",6)'="Y"   //病案无效
	...s MrTypeId=$p(tmpMain,"^",1)
    ...q:(MrType'="")&&(MrType'=MrTypeId)
	...s ^CacheTemp("MRVolTmp",JInd,VolId)=""
	
	i (BarCode'="")&&($e(BarCode,1,2)="01") d             //通过病案条码查询
	.s MainId=+$e(BarCode,3,$l(BarCode))
	.q:MainId=0
	.s tmpMain=$g(^DHCWMRMAIN(MainId))
	.q:tmpMain=""
	.q:$p(tmpMain,"^",6)'="Y"
	.;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
	.s VolId=0
	.f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
	..s tmpVol=$g(^DHCWMRVOL(VolId))
	..q:tmpVol=""
	..q:$p(tmpVol,"^",7)'="Y"
	..s VolWorkItem=$p(tmpVol,"^",6)
	..q:VolWorkItem'=QryItem
	..s ^CacheTemp("MRVolTmp",JInd,VolId)=""
	
	i (BarCode'="")&&($e(BarCode,1,2)="02") d             //通过卷条码查询
	.s VolId=+$e(BarCode,3,$l(BarCode))
	.q:VolId=0
	.s tmpVol=$g(^DHCWMRVOL(VolId))
	.q:tmpVol=""
	.q:$p(tmpVol,"^",7)'="Y"
	.s VolWorkItem=$p(tmpVol,"^",6)
	.q:VolWorkItem'=QryItem
	.s tmpMain=$g(^DHCWMRMAIN(+$p(tmpVol,"^",1)))
	.q:tmpMain=""
	.q:$p(tmpMain,"^",6)'="Y"   //病案无效
	.s MrTypeId=$p(tmpMain,"^",1)
    .q:(MrType'="")&&(MrType'=MrTypeId)
	.s ^CacheTemp("MRVolTmp",JInd,VolId)=""
	
	//通过状态查询
	s iCount=0
	i (RegNo="")&&(MrNo="")&&(IPNo="")&&(BarCode="") d //通过科室病区查询
	.i IsFinish="Y" d
	..s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	..s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	..s DateFrom=+DateFrom
	..s:DateTo["-" DateTo=$zdh(DateTo,3)
	..s:DateTo["/" DateTo=$zdh(DateTo,4)
	..s DateTo=+DateTo
	..q:(DateFrom=0)||(DateTo=0)
	..f tmpDate=DateFrom:1:DateTo d
	...;^DHCWMRVOL(0,"VSDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	...q:'$d(^DHCWMRVOL(0,"VSDateStatus",+tmpDate,+StaItem))
	...s VolId=0
	...f  s VolId=$o(^DHCWMRVOL(0,"VSDateStatus",+tmpDate,+StaItem,VolId)) q:(VolId="")||(iCount>1000)  d
	....s tmpVol=$g(^DHCWMRVOL(VolId))
	....q:tmpVol=""
	....q:$p(tmpVol,"^",7)'="Y"
	....s VolWorkItem=$p(tmpVol,"^",6)
	....q:VolWorkItem'=QryItem
	....s tmpMain=$g(^DHCWMRMAIN(+$p(tmpVol,"^",1)))
	....q:tmpMain=""
	....q:$p(tmpMain,"^",6)'="Y"        //病案无效
	....s MrTypeId=$p(tmpMain,"^",1)
    ....q:(MrType'="")&&(MrType'=MrTypeId)
	....s Paadm=$p(tmpVol,"^",2)
	....s tmpADM=$g(^PAADM(+Paadm))
	....q:$p(tmpADM,"^",20)'="D"        //只查询出院病人
	....s LocId=$p(tmpADM,"^",4)
	....q:(Loc'="")&&(Loc'=LocId)
	....s WardId=$p(tmpADM,"^",70)
	....q:(Ward'="")&&(Ward'=WardId)
	....s ^CacheTemp("MRVolTmp",JInd,VolId)=""
	....s iCount=iCount+1
	.i IsFinish="N" d
	..;^DHCWMRVOL(0,"VolAFS",{IsActive},{InFlow},{Status_Dr},{DHC_WMR_MainVolume.Rowid})
	..s InFlow=""
	..f  s InFlow=$o(^DHCWMRVOL(0,"VolAFS","Y",InFlow)) q:InFlow=""  d
	...s VolId=0
	...f  s VolId=$o(^DHCWMRVOL(0,"VolAFS","Y",InFlow,+QryItem,VolId)) q:(VolId="")||(iCount>1000)  d
	....s tmpVol=$g(^DHCWMRVOL(VolId))
	....q:tmpVol=""
	....q:$p(tmpVol,"^",7)'="Y"
	....s VolWorkItem=$p(tmpVol,"^",6)
	....q:VolWorkItem'=QryItem
	....s tmpMain=$g(^DHCWMRMAIN(+$p(tmpVol,"^",1)))
	....q:tmpMain=""
	....q:$p(tmpMain,"^",6)'="Y"        //病案无效
	....s MrTypeId=$p(tmpMain,"^",1)
    ....q:(MrType'="")&&(MrType'=MrTypeId)
	....s Paadm=$p(tmpVol,"^",2)
	....s tmpADM=$g(^PAADM(+Paadm))
	....q:$p(tmpADM,"^",20)'="D"        //只查询出院病人
	....s LocId=$p(tmpADM,"^",4)
	....q:(Loc'="")&&(Loc'=LocId)
	....s WardId=$p(tmpADM,"^",70)
	....q:(Ward'="")&&(Ward'=WardId)
	....s ^CacheTemp("MRVolTmp",JInd,VolId)=""
	....s iCount=iCount+1
	
	//取病案卷的详细信息
	k ^CacheTemp("MRVolTmp1",JInd)
	s VolId=0
	f  s VolId=$o(^CacheTemp("MRVolTmp",JInd,VolId)) q:(VolId="")||(Count>500)  d
	.s tmpVol=$g(^DHCWMRVOL(VolId))
	.s VolStaId=$p(tmpVol,"^",6)
	.s VolStaDesc=$p($g(^DHCWMRWITM(+VolStaId)),"^",2)
	.s MainId=+$p(tmpVol,"^",1)
	.s tmpMain=$g(^DHCWMRMAIN(MainId))
	.s Paadm=$p(tmpVol,"^",2)
	.s tmpADM=$g(^PAADM(+Paadm))
	.q:$p(tmpADM,"^",20)'="D"        //只查询出院病人
	.s Papmi=$p(tmpADM,"^",1)
	.s IsDeath=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
	.s LocId=$p(tmpADM,"^",4)
	.;q:(Loc'="")&&(Loc'=LocId)
	.s LocDesc=$s(LocId'="":$p($g(^CTLOC(+LocId)),"^",2),1:"")
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s WardId=$p(tmpADM,"^",70)
	.;q:(Ward'="")&&(Ward'=WardId)
	.s WardDesc=$s(WardId'="":$p($g(^PAWARD(+WardId)),"^",2),1:"")
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s AdmDate=$zd($p(tmpADM,"^",6),3)
	.s AdmTime=$zt($p(tmpADM,"^",7),2)
    .s DischDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+Paadm)
    .s DischDate=$p(DischDateTime," ",1),DischTime=$p(DischDateTime," ",2)
    .q:DischDate=""
    .s LateDays=(+$h)-$zdh(DischDate,3)
    .s:IsDeath'="Y" LateDays=$s((LateDays-5)>0:(LateDays-5),1:0)
    .s:IsDeath="Y" LateDays=$s((LateDays-7)>0:(LateDays-7),1:0)
    .s IsDeath=$s(IsDeath="Y":"已故",1:"")
	.s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
    .s PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
    .s MrTypeId=$p(tmpMain,"^",1)
    .s MrTypeDesc=$s(MrTypeId'="":$p($g(^DHCWMRDIC(+MrTypeId)),"^",3),1:"")
    .s MrNo=$p(tmpMain,"^",2)
    .s IPNo=$p(tmpADM,"^",81)
    .s:HospCode="ChengDu_HX" MrNo=IPNo
    .s TMP=MrTypeId_"^"_MrTypeDesc_"^"_MrNo_"^"_IPNo_"^"_RegNo
    .s TMP=TMP_"^"_PatName_"^"_Paadm_"^"_Papmi_"^"_LocId_"^"_LocDesc
    .s TMP=TMP_"^"_WardId_"^"_WardDesc_"^"_AdmDate_"^"_AdmTime_"^"_DischDate
    .s TMP=TMP_"^"_DischTime_"^"_VolId_"^"_MainId_"^"_IsDeath_"^"_LateDays
    .s TMP=TMP_"^"_VolStaId_"^"_VolStaDesc
    .s ^CacheTemp("MRVolTmp1",JInd,MrNo,DischDate_DischTime)=TMP
	k ^CacheTemp("MRVolTmp",JInd)
	
	//按列排序
	s tmp1=""
	f  s tmp1=$o(^CacheTemp("MRVolTmp1",JInd,tmp1)) q:tmp1=""  d
	.s tmp2=""
	.f  s tmp2=$o(^CacheTemp("MRVolTmp1",JInd,tmp1,tmp2)) q:tmp2=""  d
	..s Count=Count+1
	..s ^CacheTemp("MRVol",JInd,Count)=$g(^CacheTemp("MRVolTmp1",JInd,tmp1,tmp2))
	k ^CacheTemp("MRVolTmp1",JInd)
	
	s ret=JInd_"^"_Count
	q ret
}

ClassMethod GetDischVol(JInd, Ind)
{
	n (JInd,Ind)
	s ret=""
	s ret=$g(^CacheTemp("MRVol",JInd,Ind))
	k ^CacheTemp("MRVol",JInd,Ind)
	q ret
}

ClassMethod GetVolInfo(VolId)
{
	n (VolId)
	s ret=$lb()
	
	s (MrTypeId,MrTypeDesc,MrNo,RegNo,PatName,IsDeath,Papmi,Paadm,LocId,LocDesc,WardId,WardDesc,AdmDate,AdmTime,DischDate,DischTime,CurrStatusId,CurrStatusDesc)=""
	s tmpVol=$g(^DHCWMRVOL(+VolId))
	q:tmpVol="" ret
	s MainId=$p(tmpVol,"^",1)
	s tmpMain=$g(^DHCWMRMAIN(+MainId))
	s Paadm=$p(tmpVol,"^",2)
	s tmpADM=$g(^PAADM(+Paadm))
	s Papmi=$p(tmpADM,"^",1)
	s CurrStatusId=$p(tmpVol,"^",6)
	s CurrStatusDesc=$p($g(^DHCWMRWITM(+CurrStatusId)),"^",2)
	s LocId=$p(tmpADM,"^",4)
	s LocDesc=$s(LocId'="":$p($g(^CTLOC(+LocId)),"^",2),1:"")
	s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	s WardId=$p(tmpADM,"^",70)
	s WardDesc=$s(WardId'="":$p($g(^PAWARD(+WardId)),"^",2),1:"")
	s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	s AdmDate=$zd($p(tmpADM,"^",6),3)
	s AdmTime=$zt($p(tmpADM,"^",7),2)
    s DischDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+Paadm)
    s DischDate=$p(DischDateTime," ",1),DischTime=$p(DischDateTime," ",2)
	s IsDeath=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
    s IsDeath=$s(IsDeath="Y":"已故",1:"")
	s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
    s PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
    s MrTypeId=$p(tmpMain,"^",1)
    s MrTypeDesc=$s(MrTypeId'="":$p($g(^DHCWMRDIC(+MrTypeId)),"^",3),1:"")
    s MrNo=$p(tmpMain,"^",2)
    s IPNo=$p(tmpADM,"^",81)
	s Hosp=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
	s:$p(Hosp,"/",4)="ChengDu_HX" MrNo=IPNo
    s ret=$lb(MainId,VolId,MrTypeId,MrTypeDesc,MrNo,RegNo,PatName,IsDeath,Papmi,Paadm,LocId,LocDesc,WardId,WardDesc,AdmDate,AdmTime,DischDate,DischTime,CurrStatusId,CurrStatusDesc)
    
    q ret
}

ClassMethod QryVolumeByNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolumeByNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVolumeByNoExecute(ByRef qHandle As %Binary, MrType As %String, RegNo As %String, MrNo As %String, BarCode As %String, IPNo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s IPNo=""
	s Hosp=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
	s HospCode=$p(Hosp,"/",4)
	i HospCode="ChengDu_HX" d
	.s IPNo=MrNo
	.s MrNo=""
	
	i RegNo'="" d          //通过登记号查询
	.s RegNo=##Class(web.DHCWMRCommon.Base01).RegNoCon(RegNo)
	.q:RegNo=""
	.s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	.q:strMrType=""
	.s MrNoField=$p($p(strMrType,"^",5),"/",2)
	.q:MrNoField=""
	.q:'$d(^PAPERi("PAPMI_PatNo",RegNo))
	.s Papmi=0
	.f  s Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,Papmi)) q:Papmi=""  d
	..q:'$d(^PAPER(Papmi))
	..s:MrNoField="A" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(Papmi)
	..s:MrNoField="B" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(Papmi)
	..s:MrNoField="C" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(Papmi)
	..s:MrNoField="D" tmpMrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(Papmi)
	..q:tmpMrNo=""
	..q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,tmpMrNo))
	..s MainId=0
	..f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,tmpMrNo,MainId)) q:MainId=""  d
	...s tmpMain=$g(^DHCWMRMAIN(MainId))
	...q:tmpMain=""
	...q:$p(tmpMain,"^",6)'="Y"
	...s VolId=0
	...f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
	....s tmpVol=$g(^DHCWMRVOL(VolId))
	....q:tmpVol=""
	....q:$p(tmpVol,"^",7)'="Y"
	....s Data=..GetVolInfo(VolId)
	....s ^CacheTemp(repid,ind)=Data
	....s ind=ind+1
	
	i MrNo'="" d           //通过病案查询
	.q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo))
	.s MainId=0
	.f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,MainId)) q:MainId=""  d
	..s tmpMain=$g(^DHCWMRMAIN(MainId))
	..q:tmpMain=""
	..q:$p(tmpMain,"^",6)'="Y"
	..s VolId=0
	..f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
	...s tmpVol=$g(^DHCWMRVOL(VolId))
	...q:tmpVol=""
	...q:$p(tmpVol,"^",7)'="Y"
	...s Data=..GetVolInfo(VolId)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	i IPNo'="" d             //通过就诊IP号查询
	.q:'$d(^PAADMi("No",IPNo))
	.s Paadm=0
	.f  s Paadm=$o(^PAADMi("No",IPNo,Paadm)) q:Paadm=""  d
	..q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm))
	..s VolId=0
	..f  s VolId=$o(^DHCWMRVOL(0,"VolAdm",Paadm,VolId)) q:VolId=""  d
	...s tmpVol=$g(^DHCWMRVOL(VolId))
	...q:tmpVol=""
	...q:$p(tmpVol,"^",7)'="Y"
	...s tmpMain=$g(^DHCWMRMAIN(+$p(tmpVol,"^",1)))
	...q:tmpMain=""
	...q:$p(tmpMain,"^",6)'="Y"   //病案无效
	...s MrTypeId=$p(tmpMain,"^",1)
    ...q:(MrType'="")&&(MrType'=MrTypeId)
	...s Data=..GetVolInfo(VolId)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	i (BarCode'="")&&($e(BarCode,1,2)="01") d             //通过病案条码查询
	.s MainId=+$e(BarCode,3,$l(BarCode))
	.q:MainId=0
	.s tmpMain=$g(^DHCWMRMAIN(MainId))
	.q:tmpMain=""
	.q:$p(tmpMain,"^",6)'="Y"
	.s MrTypeId=$p(tmpMain,"^",1)
    .q:(MrType'="")&&(MrType'=MrTypeId)
	.s VolId=0
	.f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
	..s tmpVol=$g(^DHCWMRVOL(VolId))
	..q:tmpVol=""
	..q:$p(tmpVol,"^",7)'="Y"
	..s Data=..GetVolInfo(VolId)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	i (BarCode'="")&&($e(BarCode,1,2)="02") d             //通过卷条码查询
	.s VolId=+$e(BarCode,3,$l(BarCode))
	.q:VolId=0
	.s tmpVol=$g(^DHCWMRVOL(VolId))
	.q:tmpVol=""
	.q:$p(tmpVol,"^",7)'="Y"
	.s tmpMain=$g(^DHCWMRMAIN(+$p(tmpVol,"^",1)))
	.q:tmpMain=""
	.q:$p(tmpMain,"^",6)'="Y"   //病案无效
	.s MrTypeId=$p(tmpMain,"^",1)
    .q:(MrType'="")&&(MrType'=MrTypeId)
	.s Data=..GetVolInfo(VolId)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryVolumeByNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolumeByNoExecute ]
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

/// *****************************************************
/// 说明          : 通过号码查询病案卷
/// 参数          : 
/// MrType        : 病案类型
/// RegNo         : 操作项ID
/// MrNo          : 开始日期
/// BarCode       : 结束日期
/// IPNo          : 就诊IP号
/// 调试          : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.VolumeQry","QryVolumeByNo","7","","","","")
/// ******************************************************
Query QryVolumeByNo(MrType As %String, RegNo As %String, MrNo As %String, BarCode As %String, IPNo As %String) As %Query(ROWSPEC = "MainId:%String,VolId:%String, MrTypeId:%String, MrTypeDesc:%String,MrNo:%String,RegNo:%String,PatName:%String,IsDeath:%String,Papmi:%String,Paadm:%String,LocId:%String,LocDesc:%String,WardId:%String,WardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,CurrStatusId:%String,CurrStatusDesc:%String")
{
}

ClassMethod QryLateBackClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLateBackExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLateBackExecute(ByRef qHandle As %Binary, MrType, ItemId, CDays, DDays, cLoc, cWard) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;^DHCWMRVOL(0,"Status",{Status_Dr},{Rowid})
	q:(MrType="")||(ItemId="")||(CDays="")||(DDays="") $$$OK
	q:'$d(^DHCWMRVOL(0,"Status",ItemId)) $$$OK
	s VolId=0,Count=0
	f  s VolId=$o(^DHCWMRVOL(0,"Status",ItemId,VolId)) q:(VolId="")||(Count>5000)  d
	.s tmpVol=$g(^DHCWMRVOL(VolId))
	.q:tmpVol=""
	.q:$p(tmpVol,"^",7)'="Y"
	.s tmpMain=$g(^DHCWMRMAIN(+$p(tmpVol,"^",1)))
	.q:tmpMain=""
	.q:$p(tmpMain,"^",6)'="Y"
	.s MrTypeId=$p(tmpMain,"^",1)
    .q:(MrType'="")&&(MrType'=MrTypeId)
    .s Paadm=+$p(tmpVol,"^",2)
    .q:Paadm=""
    .s tmpPaadm=$g(^PAADM(+Paadm))
	.q:tmpPaadm=""
	.s AdmStatus=$p(tmpPaadm,"^",20)
	.q:AdmStatus'="D"                //是否出院
	.s Papmi=$p(tmpPaadm,"^",1)
	.s AdmLoc=$p(tmpPaadm,"^",4)
	.s AdmWard=$p(tmpPaadm,"^",70)
	.q:(cLoc'="")&&(AdmLoc'=cLoc)
	.q:(cWard'="")&&(AdmWard'=cWard)
	.s DischDateTime=##Class(web.DHCWMRBasePaadm).GetDisAdmDate(+Paadm)
    .s DischDate=$p(DischDateTime," ",1),DischTime=$p(DischDateTime," ",2)
    .q:DischDate=""
	.s IsDeath=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
	.s LateDays=(+$h)-$zdh(DischDate,3)
	.q:(IsDeath'="Y")&&(LateDays<(+CDays))
	.q:(IsDeath="Y")&&(LateDays<(+DDays))
	.s Count=Count+1
	.s Data1=..GetVolInfo(VolId)
	.s Data2=$lb(+LateDays)
	.s Data=Data1_Data2
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryLateBackFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLateBackExecute ]
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

/// *****************************************************
/// 说明          : 迟归病案查询（住院病案,正常病人5天未收回,死亡病人7天未收回）
/// 参数          : 
/// MrType        : 病案类型
/// CDays         : 正常病人迟归天数
/// DDays         : 死亡病人迟归天数
/// 调试          : d ##Class(%ResultSet).RunQuery("web.DHCWMRCircul.VolumeQry","QryLateBackVol","7","4","5","7","5","9")
/// ******************************************************
Query QryLateBack(MrType, ItemId, CDays, DDays, cLoc, cWard) As %Query(ROWSPEC = "MainId:%String,VolId:%String,MrTypeId:%String,MrTypeDesc:%String,MrNo:%String,RegNo:%String,PatName:%String,IsDeath:%String,Papmi:%String,Paadm:%String,LocId:%String,LocDesc:%String,WardId:%String,WardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,DischTime:%String,CurrStatusId:%String,CurrStatusDesc:%String,LateDays:%String")
{
}

}
