Import SQLUser

/// 对病案卷的查询
/// Modify by ChenJianBo 2009-02-06 为DHC.WMR.CurrVol.List组件添加显示字段：操作日期，操作时间，转交人，接收人
/// by wuqk 2007－03
/// Modify by 2007-05-22  for Structure Rebuild
/// Modify by Liuxuefeng 2008-09-08 替换原来Query：QueryCurrStatus为QueryCurrStatusByDate
Class web.DHCWMRVolumeQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 286;

//*********************************************

ClassMethod GetVolume(VolRowid)
{
    n (VolRowid)
    
    ;s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid,$p(VolRowid,"||",2))
    ;s sVolume=VolRowid_"||"_sVolume
    s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
    s VolAdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolRowid)
    s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+VolRowid)
    s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    s s=BaseInfo_$c(1)_sVolume_$c(1)_VolAdmInfo_$c(1)_VolInfo
    
	q s
}

ClassMethod BuildVolData(repid, ind, VolRowid)
{
	n (repid,ind,VolRowid)
	
	//病案卷信息
    s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
    s MainRowid=+$p(sVolume,"^",2)
    //卷就诊信息
    s VolAdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolRowid)
    //病人(病案)基本信息
    //s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+VolRowid)
    s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    //病人(卷)基本信息
    s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    //病人主信息
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
   
	Set Data=$lb("")
	s LenBase=$l(BaseInfo,"^")     ;27
	s LenVolAdm=$l(VolAdmInfo,"^") ;12;Len=13   Last is paadm,isn't required
	s LenVol=$l(VolInfo,"^")       ;26
	//s LenVolume=$l(sVolume,"^")    ;9
	s LenVolume=$l(sVolume,"^")    ;10   by 2007-05-22
	
	/*
	w !,LenBase_"/"_LenVolAdm_"/"_LenVol_"/"_LenVolume
 	For iBuild=1:1:LenBase Do
 	.Set $li(Data,iBuild)=$p(BaseInfo,"^",iBuild)
 	
 	For iBuild=1:1:LenVolAdm Do
 	.Set $li(Data,iBuild+LenBase)=$p(VolAdmInfo,"^",iBuild)
 	
 	For iBuild=1:1:VolInfo Do
 	.Set $li(Data,iBuild+LenBase+LenVolAdm)=$p(VolInfo,"^",iBuild)
 	
 	For iBuild=1:1:LenVolume Do
 	.Set $li(Data,iBuild+LenBase+LenVolAdm+VolInfo)=$p(sVolume,"^",iBuild)
 	*/
 	;w !,LenBase_"/"_LenVolAdm_"/"_LenVol_"/"_LenVolume
 	For iBuild=1:1:27 Do
 	.Set $li(Data,iBuild)=$p(BaseInfo,"^",iBuild)
 	
 	For iBuild=1:1:12 Do
 	.Set $li(Data,iBuild+27)=$p(VolAdmInfo,"^",iBuild)
 	
 	For iBuild=1:1:26 Do
 	.Set $li(Data,iBuild+39)=$p(VolInfo,"^",iBuild)
 	
 	For iBuild=1:1:10 Do    //For iBuild=1:1:9 Do by 2007-05-22
 	.Set $li(Data,iBuild+65)=$p(sVolume,"^",iBuild)
 	set StatusDr=$p(sVolume,"^",7)
 	set StatusInfo=##class(web.DHCWMRWorkItemCtl).GetDataById(StatusDr)
 	set $li(Data,72)=$p(StatusInfo,"^",3)
 	
 	//增加病案号
 	set $li(Data,76)=$p(sMain,"^",3) //病案号
 	set $li(Data,77)=MainRowid		 //病案Rowid
 	//增加卷号 2010-06-22
 	set $li(Data,78)=$p(sVolume,"^",11)	
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryVolByIdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVolByIdListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryVolByIdListExecute(ByRef qHandle As %Binary, VolRowidList As %String, StatusDr As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:VolRowidList="" $$$OK
	
	f index=1:1:$l(VolRowidList,"^") d
	.s VolRowid=$p(VolRowidList,"^",index)
	.q:VolRowid=""
	.;s TempStatus=$p(##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid,$p(VolRowid,"||",2)),"^",5)
	.;q:(StatusDr'="")&(TempStatus'=StatusDr)
	.s ret=..BuildVolData(repid, ind, VolRowid)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryVolByIdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVolByIdListExecute ]
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

/// 按照卷rowid列表和需要的状态来查询卷信息列表
/// 用于扫描卷条码来得到卷信息列表
Query QueryVolByIdList(VolRowidList As %String, StatusDr As %String) As %Query(ROWSPEC = "HistoryRowid:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,HisIsActive:%String,HisResumeText:%String,Papmi:%String,PatitneNO:%String,HistoryAdmRowid:%String,HistoryDr:%String,AdmitDate:%String,AdmitTime:%String,AdmitDep:%String,AdmitStatus:%String,DischargeDate:%String,DischargeTime:%String,DischargeDep:%String,Diagnose:%String,HAdmIsActive:%String,HAdmResumeText:%String,VolInfoRowid:%String,VolPatientName:%String,VolNameSpell:%String,VolSex:%String,VolBirthday:%String,VolAge:%String,VolWedlock:%String,VolOccupation:%String,VolCity:%String,VolCounty:%String,VolNation:%String,VolNationality:%String,VolIdentityCode:%String,VolCompany:%String,VolCompanyTel:%String,VolCompanyZip:%String,VolHomeAddress:%String,VolHomeTel:%String,VolHomeZip:%String,VolRelationDesc:%String,VolRelativeName:%String,VolRelativeTel:%String,VolRelativeAddress:%String,VolIsActive:%String,VolResumeText:%String,VolVolumeDr:%String,VolRowid:%String,MainRowid:%String,VolumePaadm:%String,HistroyAdmDr:%String,IsReprography:%String,IsSeal:%String,StatusDr:%String,VolumeIsActive:%String,InFlow:%String,VolumeResumeText:%String")
{
}

/// ClassMethod：根据VolRowid查询病案卷状态信息
ClassMethod VSGetDataByVolId(VolId)
{
	n (VolId)
	s ret=""
	
	q:'$d(^DHCWMRVOL(+VolId,"S")) $$$OK
	s ChildSub=0
	f  s ChildSub=$o(^DHCWMRVOL(+VolId,"S",ChildSub)) q:ChildSub=""  d
	.s VolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,ChildSub)
	.s:ret'="" ret=ret_$c(1)_VolStatus
	.s:ret="" ret=VolStatus
	q ret
}

ClassMethod VSBuildData(repid, ind, VolId, ChildSub)
{
	n (repid, ind, VolId,ChildSub)
	s VolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolId,ChildSub)
	;s VolStatus=VolId_"||"_ChildId_"^"_VolStatus
	
	s WorkItem=$p(VolStatus,"^",2)
	s UserFrom=$p(VolStatus,"^",3)
	s UserTo=$p(VolStatus,"^",6)
	
	s $p(VolStatus,"^",2)=$p(WorkItem,"/",1)
	s $p(VolStatus,"^",3)=$p(UserFrom,"/",1)
	s $p(VolStatus,"^",6)=$p(UserTo,"/",1)
	
	Set Data=$lb("")
 	For iBuild=1:1:$l(VolStatus,"^") Do
 	.Set $li(Data,iBuild)=$p(VolStatus,"^",iBuild)
 	
 	set $li(Data,7)=$p(UserFrom,"/",3)      ;UserFromDesc
 	set $li(Data,8)=$p(UserTo,"/",3)        ;UserToDesc
 	Set $li(Data,9)=$p(WorkItem,"/",2)      ;ItemTypeDr
 	set ItemTypeDesc=""
 	set ItemTypeId=+$p(WorkItem,"/",2)
 	Set:ItemTypeId'=0 ItemTypeDesc=$p($g(^DHCWMRDIC(ItemTypeId)),"^",3)
 	Set $li(Data,10)=ItemTypeDesc           ;ItemTypeDesc
 	Set $li(Data,11)=$p(WorkItem,"/",3)     ;ItemDesc
 	Set $li(Data,12)=$p(WorkItem,"/",4)     ;ItemActive
 	Set $li(Data,13)=$p(WorkItem,"/",5)     ;ItemResume
 	Set $li(Data,14)=$p(WorkItem,"/",6)     ;SysOperDr
 	set ItemTypeDesc=""
 	set ItemTypeId=+$p(WorkItem,"/",2)
 	Set:ItemTypeId'=0 ItemTypeDesc=$p($g(^DHCWMRDIC(ItemTypeId)),"^",3)
 	Set $li(Data,15)=ItemTypeDesc           ;SysOperDesc
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod VSQueryByVolIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VSQueryByVolIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod VSQueryByVolIdExecute(ByRef qHandle As %Binary, VolId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	q:'$d(^DHCWMRVOL(+VolId,"S")) $$$OK
	s ChildSub=0
	f  s ChildSub=$o(^DHCWMRVOL(+VolId,"S",ChildSub)) q:ChildSub=""  d
	.d ..VSBuildData(repid, ind, VolId, ChildSub)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod VSQueryByVolIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VSQueryByVolIdExecute ]
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

/// Query：根据VolRowid查询病案卷状态信息
Query VSQueryByVolId(VolId As %String) As %Query(ROWSPEC = "VolStaId:%String,WorkItemId:%String,UserFromId:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserFromDesc:%String,UserToDesc:%String,ItemTypeId:%String,ItemTypeDesc:%String,WorkItemDesc:%String,WorkItemActive:%String,WorkItemResume:%String,SysOperDr:%String,SysOperDesc:%String")
{
}

/// ClassMethod：根据VolStaId查询病案卷附加项目信息
ClassMethod VSDGetDataByVolStaId(VolStaId)
{
	n (VolStaId)
	s ret=""
	
	s VolRowid=+VolStaId
	s StatusSub=$p(VolStaId,"||",2)
	q:'$d(^DHCWMRVOL(VolRowid,"S",StatusSub,"D")) $$$OK
	
	s DtlSub=0
	f  s DtlSub=$o(^DHCWMRVOL(VolRowid,"S",StatusSub,"D",DtlSub)) q:DtlSub=""  d
	.s VolStaDtl=##class(web.DHCWMRVolumeCtl).GetVolStatusDtl(VolStaId,DtlSub)
	.s WorkDtl=$p(VolStaDtl,"^",2)
	.s:WorkDtl'="" WorkDtl= ##class(web.DHCWMRWorkDetailCtl).GetDataById(WorkDtl)
	.s WorkDtl=$tr(WorkDtl,"^","/")
	.s $p(VolStaDtl,"^",2)=WorkDtl
	.s WorkItemList=$p(VolStaDtl,"^",5)
	.s:WorkItemList'="" WorkItemList=##class(web.DHCWMRWorkItemCtl).SLGetDataById(WorkItemList)
	.s WorkItemList=$tr(WorkItemList,"^","/")
	.s $p(VolStaDtl,"^",5)=WorkItemList
	.s:ret'="" ret=ret_$c(1)_VolStaDtl
	.s:ret="" ret=VolStaDtl
	q ret
}

ClassMethod VSDBuildData(repid, ind, VolStaId, SubChildId)
{
	n (repid, ind, VolStaId,SubChildId)
	s VolStaDtl=##class(web.DHCWMRVolumeCtl).GetVolStatusDtl(VolStaId,SubChildId)
	;s VolStaDtl=VolStaId_"||"_SubChildId_"^"_VolStaDtl
	
	s WorkDtl=$p(VolStaDtl,"^",2)
	s WorkItemList=$p(VolStaDtl,"^",5)
	
	Set Data=$lb("")
 	For iBuild=1:1:$l(VolStaDtl,"^") Do
 	.Set $li(Data,iBuild)=$p(VolStaDtl,"^",iBuild)
 	
 	//工作项目附加项描述
	s:WorkDtl'="" WorkDtl=##class(web.DHCWMRWorkDetailCtl).GetDataById(WorkDtl)
 	Set $li(Data,6)=$p(WorkDtl,"^",2)     ;WDCode
 	Set $li(Data,7)=$p(WorkDtl,"^",3)     ;WDDesc
 	Set $li(Data,8)=$p(WorkDtl,"^",4)     ;WDDataType
 	Set $li(Data,9)=$p(WorkDtl,"^",5)     ;WDActive
 	Set $li(Data,10)=$p(WorkDtl,"^",6)    ;WDResume
 	Set $li(Data,11)=$p(WorkDtl,"^",7)    ;WDDicCode
 	
 	;Add by wuqk 2008-04-07 字典类型的附加项目取值
 	;if $p(WorkDetail,"^",4)="Dictionary" d
 	;.s ValueDr=$p(StatusDtl,"^",3)
 	;update by zf 2008-09-02   Bug
 	if $p(WorkDtl,"^",4)="Dictionary" d
 	.s ValueDr=$p(VolStaDtl,"^",3)
 	.s sDic=##class(web.DHCWMRDictionaryCtl).GetDataById(ValueDr)
 	.s $li(Data,3)=$p(sDic,"^",4)
 	
	//操作项目列表
	s:WorkItemList'="" WorkItemList=##class(web.DHCWMRWorkItemCtl).SLGetDataById(WorkItemList)
 	set $li(Data,12)=$p(WorkItemList,"^",3)  ;WILListIndex
 	Set $li(Data,13)=$p(WorkItemList,"^",4)  ;WILActive
 	Set $li(Data,14)=$p(WorkItemList,"^",5)  ;WILIsneed
 	set $li(Data,15)=$p(WorkItemList,"^",6)  ;WILResume
 	set $li(Data,16)=$p(WorkItemList,"^",7)  ;WILDefaultValue
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod VSDQueryByVolStaIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VSDQueryByVolStaIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod VSDQueryByVolStaIdExecute(ByRef qHandle As %Binary, VolStaId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s VolRowid=+VolStaId
	s StatusSub=$p(VolStaId,"||",2)
	q:'$d(^DHCWMRVOL(VolRowid,"S",StatusSub,"D")) $$$OK
	
	s DtlSub=0
	f  s DtlSub=$o(^DHCWMRVOL(VolRowid,"S",StatusSub,"D",DtlSub)) q:DtlSub=""  d
	.d ..VSDBuildData(repid, ind,VolStaId,DtlSub)
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod VSDQueryByVolStaIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VSDQueryByVolStaIdExecute ]
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

/// Query：根据VolStaId查询病案卷附加项信息
Query VSDQueryByVolStaId(VolStaId As %String) As %Query(ROWSPEC = "VolStaDtlId:%String,WorkDtlId:%String,ItemValue:%String,Resume:%String,WorkItemListId:%String,WorkDtlCode:%String,WorkDtlDesc:%String,WorkDtlDataType:%String,WorkDtlActive:%String,WorkDtlResume:%String,WorkDtlDicCode:%String,WILIndex:%String,WILActive:%String,WILIsneed:%String,WILResume:%String,WILDefVal:%String")
{
}

/// ClassMethod：根据VolStaId查询病案卷状态评价列表
ClassMethod VSEGetDataByVolStaId(VolStaId)
{
	n (VolStaId)
	s ret=""
	
	s VolRowid=+VolStaId
	s StatusSub=$p(VolStaId,"||",2)
	q:'$d(^DHCWMRVOL(VolRowid,"S",StatusSub,"E")) $$$OK
	
	s EvaSub=0
	f  s EvaSub=$o(^DHCWMRVOL(VolRowid,"S",StatusSub,"E",EvaSub)) q:EvaSub=""  d
	.s VolStaEva=##class(web.DHCWMRVolumeCtl).GetVolStatusEva(VolStaId,EvaSub)
	.s WorkItemRule=$p(VolStaEva,"^",2)
	.s:WorkItemRule'="" WorkItemRule=##class(web.DHCWMRWorkItemCtl).SRGetDataById(WorkItemRule)
	.s WorkItemRule=$tr(WorkItemRule,"^","/")
	.s $p(VolStaEva,"^",2)=WorkItemRule
	.s EvaUser=$p(VolStaEva,"^",3)
	.s:EvaUser'="" EvaUser=##class(web.DHCWMRMedBaseCtl).GetUsrStr(EvaUser)
	.s EvaUser=$tr(EvaUser,"^","/")
	.s $p(VolStaEva,"^",3)=EvaUser
	.s:ret'="" ret=ret_$c(1)_VolStaEva
	.s:ret="" ret=VolStaEva
	
	q ret
}

ClassMethod VSEBuildData(repid, ind, VolStaId, SubChildId)
{
	n (repid, ind, VolStaId,SubChildId)
	s VolStaEva=##class(web.DHCWMRVolumeCtl).GetVolStatusEva(VolStaId,SubChildId)
	;s VolStaEva=VolStaId_"||"_SubChildId_"^"_VolStaEva
	
	s WorkItemRule=$p(VolStaEva,"^",2)
	s EvaUser=$p(VolStaEva,"^",3)
	
	Set Data=$lb("")
 	For iBuild=1:1:$l(VolStaEva,"^") Do
 	.Set $li(Data,iBuild)=$p(VolStaEva,"^",iBuild)
 	
 	//操作项目评价列表
	s:WorkItemRule'="" WorkItemRule=##class(web.DHCWMRWorkItemCtl).SRGetDataById(WorkItemRule)
 	Set $li(Data,7)=$p(WorkItemRule,"^",2)     ;WIRuleDesc
 	Set $li(Data,8)=$p(WorkItemRule,"^",3)     ;WIRuleActive
 	Set $li(Data,9)=$p(WorkItemRule,"^",4)     ;WIRuleResume

 	
	//评价人信息
	s:EvaUser'="" EvaUser=##class(web.DHCWMRMedBaseCtl).GetUsrStr(EvaUser)
 	Set $li(Data,10)=$p(EvaUser,"/",2)       ;UserCode
 	Set $li(Data,11)=$p(EvaUser,"/",3)       ;UserDesc
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod VSEQueryByVolStaIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VSEQueryByVolStaIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod VSEQueryByVolStaIdExecute(ByRef qHandle As %Binary, VolStaId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s VolRowid=+VolStaId
	s StatusSub=$p(VolStaId,"||",2)
	q:'$d(^DHCWMRVOL(VolRowid,"S",StatusSub,"E")) $$$OK
	
	s EvaSub=0
	f  s EvaSub=$o(^DHCWMRVOL(VolRowid,"S",StatusSub,"E",EvaSub)) q:EvaSub=""  d
	.d ..VSEBuildData(repid, ind,VolStaId,EvaSub)
	.s ind=ind+1
		
	Quit $$$OK
}

ClassMethod VSEQueryByVolStaIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VSEQueryByVolStaIdExecute ]
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

/// Query：根据VolStaId查询病案卷状态信息评价列表信息
Query VSEQueryByVolStaId(VolStaId As %String) As %Query(ROWSPEC = "VolStaEvaId:%String,WIRuleId:%String,EvaUserId:%String,EvaDate:%String,EvaTime:%String,Resume:%String,WIRuleDesc:%String,WIRuleActive:%String,WIRuleResume:%String,UserCode:%String,UserDesc:%String")
{
}

/// ClassMethod：根据VolRowid查询病案卷就诊列表
ClassMethod VAGetDataByVolId(VolId)
{
	n (VolId)		
	s ret=""
	q:'$d(^DHCWMRVOL(+VolId,"ADM")) ret
	
	s ChildSub=0
	f  s ChildSub=$o(^DHCWMRVOL(+VolId,"ADM",ChildSub)) q:ChildSub=""  d
	.s sVolADM=##class(web.DHCWMRVolumeCtl).GetVolAdm(VolId,ChildSub)
	.s Paadm=$p(sVolADM,"^",2)
	.q:Paadm=""
	.s sADM=##class(web.DHCWMRBasePaadm).GetAdmInfo(+Paadm)
	.s sADM=$tr(sADM,"^","/")
	.s $p(sVolADM,"^",2)=sADM
	.s:ret'="" ret=ret_$c(1)_sVolADM
	.s:ret="" ret=sVolADM
	q ret
}

ClassMethod VABuildData(repid, ind, VolId, ChildId)
{
	n (repid, ind, VolId,ChildId)
	s VolADM=##class(web.DHCWMRVolumeCtl).GetVolAdm(VolId,ChildId)
	;s VolADM=VolId_"||"_ChildId_"^"_VolADM
	
	S Paadm=$p(VolADM,"^",2)
	
	Set Data=$lb("")
 	//病案卷就诊列表
 	s ADM=""
	s:Paadm'="" ADM=##class(web.DHCWMRBasePaadm).GetAdmInfo(Paadm)
	
 	Set $li(Data,1)=$p(VolADM,"^",1)      ;DHC_WMR_VolAdm.Rowid
 	Set $li(Data,2)=Paadm                 ;Paadm
 	Set $li(Data,3)=$p(ADM,"^",2)         ;AdmType
 	Set $li(Data,4)=$p(ADM,"^",3)         ;AdmNo
 	Set $li(Data,5)=$p(ADM,"^",4)         ;AdmDate
 	Set $li(Data,6)=$p(ADM,"^",5)         ;AdmTime
 	Set $li(Data,7)=$p(ADM,"^",6)         ;papmi
 	Set LocStr=$p(ADM,"^",7)
 	Set $li(Data,8)=$p(LocStr,"/",1)      ;LocId
 	Set $li(Data,9)=$p(LocStr,"/",2)      ;LocDesc
 	Set DocStr=$p(ADM,"^",8)
 	Set $li(Data,10)=$p(DocStr,"/",1)     ;DocId
 	Set $li(Data,11)=$p(DocStr,"/",2)     ;DocCode
 	Set $li(Data,12)=$p(DocStr,"/",3)     ;DocDesc
 	Set $li(Data,13)=$p(ADM,"^",9)        ;WardDesc
 	Set $li(Data,14)=$p(ADM,"^",10)       ;RoomDesc
 	Set $li(Data,15)=$p(ADM,"^",11)       ;BedDesc
 	Set $li(Data,16)=$p(ADM,"^",12)       ;DischgDate
 	Set $li(Data,17)=$p(ADM,"^",13)       ;DischgTime
 	Set $li(Data,18)=$p(ADM,"^",14)       ;VisitStatus
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod VAQueryByVolIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VAQueryByVolIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod VAQueryByVolIdExecute(ByRef qHandle As %Binary, VolId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:'$d(^DHCWMRVOL(+VolId,"ADM")) $$$OK
	
	s ChildSub=0
	f  s ChildSub=$o(^DHCWMRVOL(+VolId,"ADM",ChildSub)) q:ChildSub=""  d
	.d ..VABuildData(repid, ind,VolId,ChildSub)
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod VAQueryByVolIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VAQueryByVolIdExecute ]
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

/// Query：根据VolRowid查询病案卷就诊列表
Query VAQueryByVolId(VolId As %String) As %Query(ROWSPEC = "VolADMId:%String,PAADM:%String,AdmType:%String,AdmNo:%String,AdmDate:%String,AdmTime:%String,papmi:%String,LocId:%String,LocDesc:%String,DocId:%String,DocCode:%String,DocDesc:%String,WardDesc:%String,RoomDesc:%String,BedDesc:%String,DischgDate:%String,DischgTime:%String,VisitStatus:%String")
{
}

/// ClassMethod: 根据病案Rowid或MrNo查询病案卷列表
ClassMethod QueryVolListByMainInfo(MainId, MrType, MrNo)
{
	n (MainId,MrType,MrNo)
	
	s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))    //add by zf 2008-04-14
	s VolListInfo=""
	i MainId="" d
	.q:((MrType="")&&(MrNo=""))
	.
	.s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""),-1)
	q:MainId="" VolListInfo
	q:'$d(^DHCWMRVOL(0,"Main",MainId)) VolListInfo
	
	//update by zf 20090508
	//改成倒叙排序,最新就诊在最前
	s VolRowid=""
	f  s VolRowid=$o(^DHCWMRVOL(0,"Main",MainId,VolRowid),-1) q:(+VolRowid)=0  d
	.s VolInfo=$g(^DHCWMRVOL(VolRowid))
	.s VolActiveFlg=$p(VolInfo,"^",7)
	.q:(VolActiveFlg="N")
	.s VolInfo=##Class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
	.q:VolInfo=""
	.s:VolListInfo'="" VolListInfo=VolListInfo_$c(2)_VolInfo
	.s:VolListInfo="" VolListInfo=VolInfo
	q VolListInfo
}

ClassMethod QueryVolListByMainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVolListByMainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryVolListByMainExecute(ByRef qHandle As %Binary, MainId As %String, MrType As %String, MrNo As %String, VolNo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//add by liuxuefeng 2010-06-22 增加根据卷号查询程序
	s VolNo=$tr(VolNo," ","")
	i VolNo'=""{
		;^DHCWMRVOL(0,"VolNo",{VolNo},{IsActive},{Rowid})  
		s VolRowid=$o(^DHCWMRVOL(0,"VolNo",VolNo,"Y",""),-1)
		q:VolRowid="" $$$OK
		d ..BuildVolData(repid, ind,VolRowid)
	}else{
		s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))    //add by zf 2008-04-14
		i MainId="" d
		.q:((MrType="")&&(MrNo=""))
		.s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""),-1)
		q:MainId="" $$$OK
		
		q:'$d(^DHCWMRVOL(0,"Main",MainId)) $$$OK
		s VolRowid=""
		f  s VolRowid=$O(^DHCWMRVOL(0,"Main",MainId,VolRowid)) q:VolRowid=""  d
		.s VolInfo=$g(^DHCWMRVOL(VolRowid))
		.s VolActiveFlg=$p(VolInfo,"^",7)
		.q:(VolActiveFlg="N")
		.d ..BuildVolData(repid, ind,VolRowid)
		.s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryVolListByMainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVolListByMainExecute ]
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

/// Query：根据病案Rowid/MrNo查询病案卷列表
/// Modify by liuxuefeng 2010-06-22 增加参数VolNo
Query QueryVolListByMain(MainId As %String, MrType As %String, MrNo As %String, VolNo As %String = "") As %Query(ROWSPEC = "HistoryRowid:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,HisIsActive:%String,HisResumeText:%String,Papmi:%String,PatitneNO:%String,HistoryAdmRowid:%String,HistoryDr:%String,AdmitDate:%String,AdmitTime:%String,AdmitDep:%String,AdmitStatus:%String,DischargeDate:%String,DischargeTime:%String,DischargeDep:%String,Diagnose:%String,HAdmIsActive:%String,HAdmResumeText:%String,VolInfoRowid:%String,VolPatientName:%String,VolNameSpell:%String,VolSex:%String,VolBirthday:%String,VolAge:%String,VolWedlock:%String,VolOccupation:%String,VolCity:%String,VolCounty:%String,VolNation:%String,VolNationality:%String,VolIdentityCode:%String,VolCompany:%String,VolCompanyTel:%String,VolCompanyZip:%String,VolHomeAddress:%String,VolHomeTel:%String,VolHomeZip:%String,VolRelationDesc:%String,VolRelativeName:%String,VolRelativeTel:%String,VolRelativeAddress:%String,VolIsActive:%String,VolResumeText:%String,VolVolumeDr:%String,VolRowid:%String,MainRowid:%String,VolumePaadm:%String,HistroyAdmDr:%String,IsReprography:%String,IsSeal:%String,StatusDr:%String,VolumeIsActive:%String,InFlow:%String,VolumeResumeText:%String,MrNo:%String,MainRowid:%String,VolNo:%String")
{
}

/// delete by Liuxuefeng 2008-09-08
ClassMethod QueryCurrStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCurrStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCurrStatusExecute(ByRef qHandle As %Binary, MrTypeDr As %String, StatusDr As %String, OperStartDate As %String, OperEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:MrTypeDr="" $$$OK
	q:StatusDr="" $$$OK
	;q:OperStartDate="" $$$OK
	;q:OperEndDate="" $$$OK
	
	s Count=0
	q:'$d(^DHCWMRVOL(0,"Status",StatusDr)) $$$OK
	s VolRowid=""
	f  s VolRowid=$O(^DHCWMRVOL(0,"Status",StatusDr,VolRowid)) q:(VolRowid="")||(Count>2000)  d
	.s MainRowid=$p($g(^DHCWMRVOL(VolRowid)),"^",1)
	.s IsActive=$p($g(^DHCWMRVOL(VolRowid)),"^",7)
	.q:IsActive'="Y"
	.q:'$d(^DHCWMRMAIN(MainRowid))
	.s MainType=$p($g(^DHCWMRMAIN(MainRowid)),"^",1)
	.s IsMainActive=$p($g(^DHCWMRMAIN(MainRowid)),"^",6)
	.q:IsMainActive'="Y"
	.q:MainType'=MrTypeDr
	.;// by cjb 2009-02-06 for 添加显示字段：操作日期，操作时间，转交人，接收人
	.q:'$d(^DHCWMRVOL(VolRowid,"S",0,"Status",StatusDr))
	.s SChildSub=""
	.s SChildSub=$o(^DHCWMRVOL(VolRowid,"S",0,"Status",StatusDr,SChildSub),-1)
	.;s CurrDate=+$p(^DHCWMRVOL(VolRowid,"S",SChildSub),"^",3)  //取操作日期
	.;q:(CurrDate<+OperStartDate)!(CurrDate>+OperEndDate)
	.d ..BuildVolDataStatus(repid, ind,VolRowid,SChildSub)
	.s ind=ind+1
	.s Count=Count+1
	s Cnt=ind-1						;add by liuxuefeng 2009-07-17 页面输出列表总数
	w !,"数量:"_Cnt					;add by liuxuefeng 2009-07-17 页面输出列表总数
	Quit $$$OK
}

ClassMethod QueryCurrStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCurrStatusExecute ]
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

/// 查询当前状态为指定状态的卷
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRVolumeQry","QueryCurrStatus","7","2","","")
Query QueryCurrStatus(MrTypeDr As %String, StatusDr As %String, OperStartDate As %String, OperEndDate As %String) As %Query(ROWSPEC = "HistoryRowid:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,HisIsActive:%String,HisResumeText:%String,Papmi:%String,PatitneNO:%String,HistoryAdmRowid:%String,HistoryDr:%String,AdmitDate:%String,AdmitTime:%String,AdmitDep:%String,AdmitStatus:%String,DischargeDate:%String,DischargeTime:%String,DischargeDep:%String,Diagnose:%String,HAdmIsActive:%String,HAdmResumeText:%String,VolInfoRowid:%String,VolPatientName:%String,VolNameSpell:%String,VolSex:%String,VolBirthday:%String,VolAge:%String,VolWedlock:%String,VolOccupation:%String,VolCity:%String,VolCounty:%String,VolNation:%String,VolNationality:%String,VolIdentityCode:%String,VolCompany:%String,VolCompanyTel:%String,VolCompanyZip:%String,VolHomeAddress:%String,VolHomeTel:%String,VolHomeZip:%String,VolRelationDesc:%String,VolRelativeName:%String,VolRelativeTel:%String,VolRelativeAddress:%String,VolIsActive:%String,VolResumeText:%String,VolVolumeDr:%String,VolRowid:%String,MainRowid:%String,VolumePaadm:%String,HistroyAdmDr:%String,IsReprography:%String,IsSeal:%String,StatusDr:%String,VolumeIsActive:%String,InFlow:%String,VolumeResumeText:%String,MrNo:%String,MainRowid:%String,CurrDate:%String,CurrTime:%String,UserFromDesc:%String,UserToDesc:%String")
{
}

/// ------end
ClassMethod QueryCurrStatusByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCurrStatusByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryCurrStatusByDateExecute(ByRef qHandle As %Binary, MrTypeDr, StatusDr, OperStartDate, OperEndDate, argLocRowid, argWardRowid, PrintFlag, Recipient As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:MrTypeDr="" $$$OK
	q:StatusDr="" $$$OK
	q:OperStartDate="" $$$OK
	q:OperEndDate="" $$$OK
	;w !,"OperStartDate="_OperStartDate_";OperEndDate="_OperEndDate
	s:OperStartDate["-" OperStartDate=$zdh(OperStartDate,3)
	s:OperEndDate["-" OperEndDate=$zdh(OperEndDate,3)
	s:OperStartDate["/" OperStartDate=$zdh(OperStartDate,4)
	s:OperEndDate["/" OperEndDate=$zdh(OperEndDate,4)
	
	f CurrDate=OperStartDate:1:OperEndDate  d
	.;^DHCWMRVOL(0,"VSDateStatus",{CurrDate},{Status_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	.s VolRowid=0
	.f  s VolRowid=$o(^DHCWMRVOL(0,"VSDateStatus",CurrDate,StatusDr,VolRowid)) q:VolRowid=""  d
	..q:'$d(^DHCWMRVOL(VolRowid))
	..s WMRVOLString=$g(^DHCWMRVOL(VolRowid))
	..s CurrSta=$p(WMRVOLString,"^",6)
	..q:(CurrSta'="")&&(CurrSta'=StatusDr)
	..//add by lxf 2010-12-08 增加科室病区过滤
	..s EpisodeID=+$p(WMRVOLString,"^",2)
	..s Ward=+$p($g(^PAADM(EpisodeID)),"^",70)		;表PAC_Ward的RowId
	..s Loc=+$p($g(^PAADM(EpisodeID)),"^",4)			;表CT_Loc的RowId
	..q:((Loc'=argLocRowid)&&(argLocRowid'=""))
	..q:((Ward'=argWardRowid)&&(argWardRowid'=""))
	..;cjb：为了添加显示字段
	..s SChildSub=$o(^DHCWMRVOL(0,"VSDateStatus",CurrDate,StatusDr,VolRowid,""),-1)
	..s MainRowid=$p(WMRVOLString,"^",1)
	..s IsActive=$p(WMRVOLString,"^",7)
	..q:IsActive'="Y"
	..q:'$d(^DHCWMRMAIN(MainRowid))
	..s MainType=$p($g(^DHCWMRMAIN(MainRowid)),"^",1)
	..s IsMainActive=$p($g(^DHCWMRMAIN(MainRowid)),"^",6)
	..q:IsMainActive'="Y"
	..q:MainType'=MrTypeDr
    ..s VolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolRowid,SChildSub) //卷状态信息 
    ..s UserFrom=$p(VolStatus,"^",3)
	..s UserTo=$p(VolStatus,"^",6)
	..q:(Recipient'="")&(UserTo'[Recipient)
	..d ..BuildVolDataStatus(repid, ind,VolRowid,SChildSub)
	..s ind=ind+1	
	
	s Cnt=ind-1						;add by liuxuefeng 2009-12-01 页面输出列表总数
	w:PrintFlag'="Y" "<span style='font-size:medium; font-weight:bold;color:Red;'>数量:"_Cnt_"</span>"					;add by liuxuefeng 2009-12-01 页面输出列表总数
	Quit $$$OK
}

ClassMethod QueryCurrStatusByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCurrStatusByDateExecute ]
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

/// Modify by ChenJianBo 2009-02-06 添加显示字段：操作日期，操作时间，转交人，接收人
/// Add by Liuxuefeng 2008-09-08 替换原来Query：QueryCurrStatus,增加查询参数 OperStartDate, OperEndDate
/// 根据操作开始日期、操作结束日期、病案类型、病案状态查询卷列表
/// Modified By LiYang 2009-2-17 为返回数据集添加用户显示标题
/// Modify by liuxuefeng 2010-12-08 增加科室和病区过滤,返回数据增加病区描述WardDesc
/// 增加按照接收人查询过滤 Modify by wangCS 2011-07-05 
Query QueryCurrStatusByDate(MrTypeDr, StatusDr, OperStartDate, OperEndDate, argLocRowid, argWardRowid, PrintFlag, Recipient) As %Query(ROWSPEC = "HistoryRowid:%String,PatientName:%String:患者姓名,NameSpell:%String:拼音,Sex:%String:性别,Birthday:%String:生日,Age:%String:年龄,Wedlock:%String:婚姻,Occupation:%String:职业,City:%String:市,County:%String:县,Nation:%String:民族,Nationality:%String:国籍,IdentityCode:%String:身份证号,Company:%String:工作单位,CompanyTel:%String:单位电话,CompanyZip:%String:单位邮编,HomeAddress:%String:家庭住址,HomeTel:%String:家庭电话,HomeZip:%String:家庭邮编,RelationDesc:%String:联系人关系,RelativeName:%String:联系人,RelativeTel:%String:联系人,RelativeAddress:%String:联系人地址,HisIsActive:%String,HisResumeText:%String,Papmi:%String,PatitneNO:%String:登记号,HistoryAdmRowid:%String,HistoryDr:%String,AdmitDate:%String:就诊日期,AdmitTime:%String:就诊时间,AdmitDep:%String:就诊科室,AdmitStatus:%String:就诊状态,DischargeDate:%String:出院日期,DischargeTime:%String:出院时间,DischargeDep:%String:出院科室,Diagnose:%String:诊断,HAdmIsActive:%String,HAdmResumeText:%String,VolInfoRowid:%String,VolPatientName:%String:卷病人姓名,VolNameSpell:%String:卷病人拼音,VolSex:%String:卷性别,VolBirthday:%String:卷生日,VolAge:%String:卷年龄,VolWedlock:%String:卷婚姻,VolOccupation:%String:卷职业,VolCity:%String:卷市,VolCounty:%String:卷县,VolNation:%String:卷民族,VolNationality:%String:卷国籍,VolIdentityCode:%String:卷身份证号,VolCompany:%String:卷单位,VolCompanyTel:%String:卷单位电话,VolCompanyZip:%String:卷单位邮编,VolHomeAddress:%String:卷家庭住址,VolHomeTel:%String:卷家庭电话,VolHomeZip:%String:卷家庭邮编,VolRelationDesc:%String:卷联系人关系,VolRelativeName:%String:卷联系人姓名,VolRelativeTel:%String:卷联系人电话,VolRelativeAddress:%String:卷联系人地质,VolIsActive:%String,VolResumeText:%String,VolVolumeDr:%String,VolRowid:%String,MainRowid:%String,VolumePaadm:%String,HistroyAdmDr:%String,IsReprography:%String:是否复印,IsSeal:%String:是否封存,StatusDr:%String,VolumeIsActive:%String,InFlow:%String,VolumeResumeText:%String,MrNo:%String:病案号,MainRowid1:%String,CurrDate:%String:操作日期,CurrTime:%String:卷操作时间,UserFromDesc:%String:操作员,UserToDesc:%String:接收用户,WardDesc:%String:病区")
{
}

/// Add by ChenJianBo 2009-02-06 DHC.WMR.CurrVol.List组件添加显示字段：操作日期，操作时间，转交人，接收人
ClassMethod BuildVolDataStatus(repid, ind, VolRowid, SChildSub)
{
	n (repid,ind,VolRowid,SChildSub)
	
	//病案卷信息
    s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
    s MainRowid=+$p(sVolume,"^",2)
    //卷就诊信息
    s VolAdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolRowid)
    //病人(病案)基本信息
    //s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+VolRowid)
    s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    //病人(卷)基本信息
    s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    //病人主信息
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    //卷状态信息  cjb:为了添加显示字段
    s VolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolRowid,SChildSub)
    
	Set Data=$lb("")
	s LenBase=$l(BaseInfo,"^")     ;27
	s LenVolAdm=$l(VolAdmInfo,"^") ;12;Len=13   Last is paadm,isn't required
	s LenVol=$l(VolInfo,"^")       ;26
	//s LenVolume=$l(sVolume,"^")    ;9
	s LenVolume=$l(sVolume,"^")    ;10   by 2007-05-22
	
	/*
	w !,LenBase_"/"_LenVolAdm_"/"_LenVol_"/"_LenVolume
 	For iBuild=1:1:LenBase Do
 	.Set $li(Data,iBuild)=$p(BaseInfo,"^",iBuild)
 	
 	For iBuild=1:1:LenVolAdm Do
 	.Set $li(Data,iBuild+LenBase)=$p(VolAdmInfo,"^",iBuild)
 	
 	For iBuild=1:1:VolInfo Do
 	.Set $li(Data,iBuild+LenBase+LenVolAdm)=$p(VolInfo,"^",iBuild)
 	
 	For iBuild=1:1:LenVolume Do
 	.Set $li(Data,iBuild+LenBase+LenVolAdm+VolInfo)=$p(sVolume,"^",iBuild)
 	*/
 	;w !,LenBase_"/"_LenVolAdm_"/"_LenVol_"/"_LenVolume
 	For iBuild=1:1:27 Do
 	.Set $li(Data,iBuild)=$p(BaseInfo,"^",iBuild)
 	
 	For iBuild=1:1:12 Do
 	.Set $li(Data,iBuild+27)=$p(VolAdmInfo,"^",iBuild)
 	
 	For iBuild=1:1:26 Do
 	.Set $li(Data,iBuild+39)=$p(VolInfo,"^",iBuild)
 	
 	For iBuild=1:1:10 Do    //For iBuild=1:1:9 Do by 2007-05-22
 	.Set $li(Data,iBuild+65)=$p(sVolume,"^",iBuild)
 	set StatusDr=$p(sVolume,"^",7)
 	set StatusInfo=##class(web.DHCWMRWorkItemCtl).GetDataById(StatusDr)
 	set $li(Data,72)=$p(StatusInfo,"^",3)
 	
 	//增加病案号
 	s MrNo=$p(sMain,"^",3)
 	s Hosp=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
	s:$p(Hosp,"/",4)="ChengDu_HX" MrNo=$p($g(^PAADM(+$p(sVolume,"^",3))),"^",81)
 	set $li(Data,76)=MrNo
 	set $li(Data,77)=MainRowid
 	//cjb 添加显示项
 	set $li(Data,78)=$p(VolStatus,"^",4)  ;CurrDate
 	set $li(Data,79)=$p(VolStatus,"^",5)  ;CurrTime
 	s UserFrom=$p(VolStatus,"^",3)
	s UserTo=$p(VolStatus,"^",6)
	
	set $li(Data,80)=$p(UserFrom,"/",3)   ;UserFromDesc
 	set $li(Data,81)=$p(UserTo,"/",3)     ;UserToDesc
 	//add 2010-12-08 如果不为历史病人，显示病区
 	s EpisodeID=+$p(sVolume,"^",3)
 	s WardID=+$p($g(^PAADM(EpisodeID)),"^",70)		;表PAC_Ward的RowId
 	q:WardID=""!WardID=0!'$d(^PAWARD(WardID))               //wangcs 2011-06-12
 	s WardDesc=$p(^PAWARD(WardID),"^",2)
 	s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
 	set $li(Data,82)=WardDesc     ;WardDesc
 	///End
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod BuildVolDataStatusByRecipient(repid, ind, VolRowid, SChildSub, Recipient)
{
	n (repid,ind,VolRowid,SChildSub,Recipient)
	
	//病案卷信息
    s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
    s MainRowid=+$p(sVolume,"^",2)
    //卷就诊信息
    s VolAdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolRowid)
    //病人(病案)基本信息
    //s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+VolRowid)
    s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    //病人(卷)基本信息
    s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolRowid)
    //病人主信息
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    //卷状态信息  cjb:为了添加显示字段
    s VolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolRowid,SChildSub)
    
	Set Data=$lb("")
	s LenBase=$l(BaseInfo,"^")     ;27
	s LenVolAdm=$l(VolAdmInfo,"^") ;12;Len=13   Last is paadm,isn't required
	s LenVol=$l(VolInfo,"^")       ;26
	//s LenVolume=$l(sVolume,"^")    ;9
	s LenVolume=$l(sVolume,"^")    ;10   by 2007-05-22
	
	/*
	w !,LenBase_"/"_LenVolAdm_"/"_LenVol_"/"_LenVolume
 	For iBuild=1:1:LenBase Do
 	.Set $li(Data,iBuild)=$p(BaseInfo,"^",iBuild)
 	
 	For iBuild=1:1:LenVolAdm Do
 	.Set $li(Data,iBuild+LenBase)=$p(VolAdmInfo,"^",iBuild)
 	
 	For iBuild=1:1:VolInfo Do
 	.Set $li(Data,iBuild+LenBase+LenVolAdm)=$p(VolInfo,"^",iBuild)
 	
 	For iBuild=1:1:LenVolume Do
 	.Set $li(Data,iBuild+LenBase+LenVolAdm+VolInfo)=$p(sVolume,"^",iBuild)
 	*/
 	;w !,LenBase_"/"_LenVolAdm_"/"_LenVol_"/"_LenVolume
 	For iBuild=1:1:27 Do
 	.Set $li(Data,iBuild)=$p(BaseInfo,"^",iBuild)
 	
 	For iBuild=1:1:12 Do
 	.Set $li(Data,iBuild+27)=$p(VolAdmInfo,"^",iBuild)
 	
 	For iBuild=1:1:26 Do
 	.Set $li(Data,iBuild+39)=$p(VolInfo,"^",iBuild)
 	
 	For iBuild=1:1:10 Do    //For iBuild=1:1:9 Do by 2007-05-22
 	.Set $li(Data,iBuild+65)=$p(sVolume,"^",iBuild)
 	set StatusDr=$p(sVolume,"^",7)
 	set StatusInfo=##class(web.DHCWMRWorkItemCtl).GetDataById(StatusDr)
 	set $li(Data,72)=$p(StatusInfo,"^",3)
 	
 	//增加病案号
 	s MrNo=$p(sMain,"^",3)
 	s Hosp=##Class(web.DHCWMRMedBase01).GetDefaultHosp()
	s:$p(Hosp,"/",4)="ChengDu_HX" MrNo=$p($g(^PAADM(+$p(sVolume,"^",3))),"^",81)
 	set $li(Data,76)=MrNo
 	set $li(Data,77)=MainRowid
 	//cjb 添加显示项
 	set $li(Data,78)=$p(VolStatus,"^",4)  ;CurrDate
 	set $li(Data,79)=$p(VolStatus,"^",5)  ;CurrTime
 	s UserFrom=$p(VolStatus,"^",3)
	s UserTo=$p(VolStatus,"^",6)
	
	set $li(Data,80)=$p(UserFrom,"/",3)   ;UserFromDesc
 	set $li(Data,81)=$p(UserTo,"/",3)     ;UserToDesc
 	//add 2010-12-08 如果不为历史病人，显示病区
 	s EpisodeID=+$p(sVolume,"^",3)
 	s WardID=+$p($g(^PAADM(EpisodeID)),"^",70)		;表PAC_Ward的RowId
 	q:WardID=""!WardID=0!'$d(^PAWARD(WardID))               //wangcs 2011-06-12
 	s WardDesc=$p(^PAWARD(WardID),"^",2)
 	s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
 	set $li(Data,82)=WardDesc     ;WardDesc
 	///End
 	if (Recipient'="")
 	.if (UserTo[Recipient)!(UserTo=Recipient)
 	..Set ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	q Data
}

ClassMethod QueryMissVolumeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMissVolumeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMissVolumeExecute(ByRef qHandle As %Binary, FromDate As %String, MrType As %String, PaadmType As %String, ToDate As %String, Status As %String, PrintFlag As %String, argLocRowid As %String, argWardRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:MrType="" $$$OK
	q:PaadmType="" $$$OK
	q:FromDate="" $$$OK
	q:ToDate="" $$$OK
	q:Status="" $$$OK
		
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	;s ^CacheTemp("liyang")=MrType_"^"_PaadmType_"^"_FromDate_"^"_ToDate_"^"_Status
	q:PaadmType=""!Status="" $$$OK
	
	//add by liuxuefeng 修改出院查询索引
	s DisIndex=##Class(web.DHCWMRBasePaadm).GetDisDateIndex()	
	f tmpDate=FromDate:1:ToDate	 d
	.s tmpPaadmID=""  
	.f  s tmpPaadmID=$o(^PAADMi(DisIndex,tmpDate,tmpPaadmID))  q:tmpPaadmID=""  d
	..s AdmType=$p($g(^PAADM(+tmpPaadmID)),"^",2) 		//add
	..q:AdmType'="I"								//add
	..//add by lxf 2011-03-09 增加科室病区过滤
	..s Ward=+$p($g(^PAADM(+tmpPaadmID)),"^",70)		;表PAC_Ward的RowId
	..q:((Ward'=argWardRowid)&&(argWardRowid'=""))
	..s Loc=+$p($g(^PAADM(+tmpPaadmID)),"^",4)			;表CT_Loc的RowId
	..q:((Loc'=argLocRowid)&&(argLocRowid'=""))
	..s VisitStatus=$p($g(^PAADM(+tmpPaadmID)),"^",20)	//add
	..q:(VisitStatus'="A")&&(VisitStatus'="D")		//add
	..s volID=$o(^DHCWMRVOL(0,"VolAdm",tmpPaadmID,""))
	..i volID'=""  d
	...s volInfo=$g(^DHCWMRVOL(volID))
	...s VolIsActive=$p(volInfo,"^",7)			
	...q:VolIsActive'="Y"						
	...s MainID=$p(volInfo,"^",1)
	...s MainInfo=$g(^DHCWMRMAIN(+MainID))
	...s MainIsActive=$p(MainInfo,"^",6) 		
	...q:MainIsActive'="Y"						
	...q:$p(MainInfo,"^",1)'=MrType
	...s VolStatusID= $o(^DHCWMRVOL(volID,"S",0,"Status",Status,""))
	...i VolStatusID=""  d
	....s tmp=$$BuildQueryMissVolumeResult(repid,ind,volID)
	....s ind=ind+1
	
	s Cnt=ind-1						
	w:PrintFlag'="Y" !,"数量:"_Cnt					
	
	Quit $$$OK
BuildQueryMissVolumeResult(repid,ind,VolID)
	n (repid,ind,VolID)
	s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(+VolID)
	s volStatus=$p(sVolume,"^",7)
	s SChildSub=$o(^DHCWMRVOL(VolID,"S",0,"Status",volStatus,""))
	
    s MainRowid=+$p(sVolume,"^",2)
    //卷就诊信息
    s VolAdmInfo=##class(web.DHCWMRBaseInfoCtl).GetAdmInfoByVol(VolID)
    //病人(病案)基本信息
    //s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+VolRowid)
    s BaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
    //病人(卷)基本信息
    s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfoByVol(VolID)
    //病人主信息
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
    //卷状态信息  cjb:为了添加显示字段
    s VolStatus=##class(web.DHCWMRVolumeCtl).GetVolStatus(VolID,SChildSub)
    
	Set Data=$lb("")
	s $li(Data,1)=MainRowid   //MainID
	s $li(Data,2)=VolID   //VolID
	s $li(Data,3)=$p(sMain,"^",3)   //病案号
	s $li(Data,4)=$p(BaseInfo,"^",2)   //姓名
	s $li(Data,5)=$p(BaseInfo,"^",4)   //性别
	s $li(Data,6)=$p(BaseInfo,"^",6)   //年龄
	s $li(Data,7)=$p(VolAdmInfo,"^",3)  //就诊日期
	s $li(Data,8)=$p(VolAdmInfo,"^",5)  //就诊科室
	s $li(Data,9)=$p(VolAdmInfo,"^",7)  //出院日期
	s $li(Data,10)=$p(VolAdmInfo,"^",9)  //出院科室
	s $li(Data,11)=$p($p(VolStatus,"^",2),"/",3)   //当前状态
	s $li(Data,12)=$p(VolStatus,"^",4)   //当前状态日期
	s $li(Data,13)=$p(VolStatus,"^",5)   //当前状态时间
	s User=$p(VolStatus,"^",3)
	s $li(Data,14)=$p(User,"/",2)_"  "_$p(User,"/",3)   //操作人
	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryMissVolumeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMissVolumeExecute ]
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

/// 查询某段出院时间内没有经过某种操作状态的病案卷
/// modify 2011-03-09 增加科室argLocRowid、病区argWardRowid
Query QueryMissVolume(FromDate As %String, MrType As %String, PaadmType As %String, ToDate As %String, Status As %String, PrintFlag As %String, argLocRowid As %String, argWardRowid As %String) As %Query(ROWSPEC = "MainID:%String,VolumeID:%String,MrNo:%String:病案号,PatientName:%String:姓名,Sex:%String:性别,Age:%String:年龄,AdmitDate:%String:住院日期,AdmitDep:%String:住院科室,DischargeDate:%String:出院日期,DischargeDep:%String:出院科室,CurrStatus:%String:当前状态,CurrStatusDate:%String:当前状态操作日期,CurrStatusTime:%String:当前状态操作时间,CurrStatusFromUser:%String:操作人")
{
}

/// Creator：    刘学峰
/// CreatDate：  2009-12-05
/// Description：构造卷当前状态打印列表数据
/// Query：      QueryCurrStatusByDate
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔。MrTypeDr+"^"+StatusDr+"^"+OperStartDate+"^"+OperEndDate
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRVolumeQry).QueryCurrStatusByDateToPrint(itmjs,strArguments)
ClassMethod QueryCurrStatusByDateToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	
	s MrTypeDr=$p(strArguments,"^",1)
	s StatusDr=$p(strArguments,"^",2)
	s OperStartDate=$p(strArguments,"^",3)
	s OperEndDate=$p(strArguments,"^",4)
	//add 2010-12-08
	s argLocRowid=$p(strArguments,"^",5)
	s argWardRowid=$p(strArguments,"^",6)
	s PrintFlag=$p(strArguments,"^",7)

	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRVolumeQry:QueryCurrStatusByDate")
	d ds.Execute(MrTypeDr,StatusDr,OperStartDate,OperEndDate,argLocRowid,argWardRowid,PrintFlag)
	s StartRow=4
	while(ds.Next())
	{
		s MrNo=ds.Data("MrNo")						//病案号
		s PapmiNo=ds.Data("PatitneNO")				//登记号
		s PatientName=ds.Data("PatientName") 		//姓名
		s DischargeDate=ds.Data("DischargeDate")	//出院日期
		s DischargeDep=ds.Data("DischargeDep")		//出院科室
		s CurrDate=ds.Data("CurrDate")				//操作日期
		s CurrTime=ds.Data("CurrTime")				//卷操作时间

		//病案号,登记号,姓名,出院日期,出院科室,操作日期
		s valCells=MrNo_$c(1)_PapmiNo_$c(1)_PatientName_$c(1)_DischargeDate_$c(1)_DischargeDep_$c(1)_CurrDate
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	s DefaultHospStr=##class(web.DHCWMRMedBase01).GetDefaultHosp()
	s HospDesc=$p(DefaultHospStr,"^",3)
	s WorkItemDesc=$p($g(^DHCWMRWITM(StatusDr)),"^",2)
	s valCells=HospDesc_"“"_WorkItemDesc_"”明细"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="操作日期："_$zd($zdh(OperStartDate,4),3)_" 至 "_$zd($zdh(OperEndDate,4),3)_"    合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

/// Creator：    刘学峰
/// CreatDate：  2010-09-03
/// Description：通过卷号获取病案号
/// Input：      病案类型argMrType；卷号argVolNo
/// Return：     病案号
/// Debug:       w ##Class(web.DHCWMRVolumeQry).GetMrNoByVolNo(argMrType, argVolNo)
ClassMethod GetMrNoByVolNo(argMrType, argVolNo)
{
	n (argMrType,argVolNo)
	;^DHCWMRVOL(0,"VolNo",{VolNo},{IsActive},{Rowid})
	s ret=-1
	q:argMrType="" ret
	s ret=-2
	s argVolNo=$tr(argVolNo," ","")
	q:argVolNo="" ret 
	s argVolNo=$zcvt(argVolNo,"U")
	s ret=-3
	s VolRowid=$o(^DHCWMRVOL(0,"VolNo",argVolNo,"Y",""),-1)
	q:VolRowid="" ret
	s ret=-4
	s MainDr=$p($g(^DHCWMRVOL(+VolRowid)),"^",1)
	s MainString=$g(^DHCWMRMAIN(+MainDr))
	s MrType=$p(MainString,"^",1)
	s MrNo=$p(MainString,"^",2)
	q:MrType'=argMrType ret
	q MrNo
}

/// Creator：    刘学峰
/// CreatDate：  2010-10-19
/// Description：构造未完成操作打印列表数据
/// Query：      QueryMissVolume
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔。FromDate+"^"+MrType+"^"+PaadmType+"^"+ToDate+"^"+Status
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRVolumeQry).QueryMissVolumeToPrint(itmjs,strArguments)
ClassMethod QueryMissVolumeToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	
	s FromDate=$p(strArguments,"^",1)
	s MrType=$p(strArguments,"^",2)
	s PaadmType=$p(strArguments,"^",3)
	s ToDate=$p(strArguments,"^",4)
	s Status=$p(strArguments,"^",5)
	s PrintFlag=$p(strArguments,"^",6)
	s argLocRowid=$p(strArguments,"^",7)
	s argWardRowid=$p(strArguments,"^",8)


	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRVolumeQry:QueryMissVolume")
	d ds.Execute(FromDate, MrType, PaadmType, ToDate, Status, PrintFlag , argLocRowid , argWardRowid)
	s StartRow=4
	while(ds.Next())
	{	
		s MainID=ds.Data("MainID")							//MainID
		s VolumeID=ds.Data("VolumeID")						//VolumeID
		s MrNo=ds.Data("MrNo") 								//病案号
		s PatientName=ds.Data("PatientName")				//姓名
		s Sex=ds.Data("Sex")								//性别
		s Age=ds.Data("Age")								//年龄
		s AdmitDate=ds.Data("AdmitDate")					//住院日期
		s AdmitDep=ds.Data("AdmitDep")						//住院科室

		s DischargeDate=ds.Data("DischargeDate")			//出院日期
		s DischargeDep=ds.Data("DischargeDep")				//出院科室
		s CurrStatus=ds.Data("CurrStatus")					//当前状态
		s CurrStatusDate=ds.Data("CurrStatusDate")			//当前状态操作日期
		s CurrStatusTime=ds.Data("CurrStatusTime")			//当前状态操作时间
		s CurrStatusFromUser=ds.Data("CurrStatusFromUser")	//操作人


		//病案号,登记号,姓名,出院日期,出院科室,操作日期
		s valCells=MrNo_$c(1)_PatientName_$c(1)_Sex_$c(1)_AdmitDate_$c(1)_DischargeDate_$c(1)_DischargeDep_$c(1)_CurrStatus_$c(1)_CurrStatusDate_$c(1)_CurrStatusTime_$c(1)_CurrStatusFromUser
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	s DefaultHospStr=##class(web.DHCWMRMedBase01).GetDefaultHosp()
	s HospDesc=$p(DefaultHospStr,"^",3)
	s WorkItemDesc=$p($g(^DHCWMRWITM(Status)),"^",2)
	s valCells=HospDesc_" 未完成“"_WorkItemDesc_"”明细"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	s valCells="出院日期："_$zd($zdh(FromDate,4),3)_" 至 "_$zd($zdh(ToDate,4),3)_"    合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

}
