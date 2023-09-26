/// 名称: DHCMed.NINFService.Aim.InfBaseSrv
/// 描述: 感染的常用基本操作
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.NINFService.Aim.InfBaseSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  查询的信息
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       Alias ： 别名
/// output:       符合条件的项            
/// Return： 1: Papmi 2: Paadm 3: PatName 4: AdmType 5: Age 6: AdmLoc 7: AdmDoc 8: AdmDate 9: CurrStatus
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.InfBaseSrv","QryPaAdmByRegNo","112588")
Query QryPaAdmByRegNo(RegNo As %String = "") As %Query(ROWSPEC = "Papmi:%String,Paadm:%String,PatName:%String,AdmType:%String,Age:%String,AdmLoc:%String,AdmDoc:%String,AdmDate:%String,CurrStatus:%String,LocID:%String")
{
}

ClassMethod QryPaAdmByRegNoExecute(ByRef qHandle As %Binary, RegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//^DHCMed.INF.InfPathogenDicD
 	//^DHCMed.INF.InfPathogenDicI("Code",{Code},{RowID})
 	//1:Rowid 2: ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
 	s RegNo=$$ALPHAUP^SSUTIL4(RegNo)
 	q:RegNo="" $$$OK
 	s objPatient=##class(DHCMed.Base.Patient).GetPatientByRegNo(RegNo)
 	q:'$IsObject(objPatient) $$$OK
 	s Papmi=objPatient.Papmi   //基本信息 id
 	s tmpAdmType=""  //,tmpRowid 就诊类型
 	f  s tmpAdmType=$o(^PAPERdr(Papmi,"ADM",tmpAdmType)) q:tmpAdmType=""  d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^PAPERdr(Papmi,"ADM",tmpAdmType,tmpRowid)) q:tmpRowid=""  d
 	..s objPatAdm=##class(DHCMed.Base.PatientAdm).GetObjById(tmpRowid)
 	..q:'$IsObject(objPatAdm)
 	..s admType=objPatAdm.AdmType
 	..s:admType["I" admType="住院"
 	..s:admType["O" admType="门诊"
 	..s:admType["E" admType="急诊" 
 	..s admStatus=objPatAdm.Status
 	..s:admStatus["A" admStatus="在院"
 	..s:admStatus["C" admStatus="取消"
 	..s:admStatus["D" admStatus="出院"
 	..s Data=$lb(objPatient.Papmi, objPatAdm.AdmRowID, objPatient.PatientName, admType, objPatient.Age,objPatAdm.Department,objPatAdm.DoctorName,objPatAdm.AdmitDate,admStatus,objPatAdm.DepartmentID)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	Quit $$$OK
}

ClassMethod QryPaAdmByRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPaAdmByRegNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPaAdmByRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPaAdmByRegNoExecute ]
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
/// CreatDate：   2010-05-19
/// Description:  查询病人所有诊断的信息
/// Table：       DHCMed.INF.InfDiagnose
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// Return：      1: Rowid 2: ICDCodeDr 3: DocCodeDr 4: CTPCPCode 5: CTPCPDesc 6: CTCPTDesc
/// 			  7: CTCPTInternalType 8: DiaDate 9: DiaTime 10: IsActive 11: SignSymDr 12: AliasDiagText 13: ICD9CMCode 14: ICDDesc
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.InfBaseSrv","QryDiasByPaadm","58008")
Query QryDiasByPaadm(Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Query(ROWSPEC = "Rowid:%String,ICDCodeDr:%String,DocCodeDr:%String,CTPCPCode:%String,CTPCPDesc:%String,CTCPTDesc:%String,CTCPTInternalType:%String,DiaDate:%String,DiaTime:%String,IsActive:%String,SignSymDr:%String,AliasDiagText:%String,ICD9CMCode:%String,ICDDesc:%String,DiagType:%String,checked:%String")
{
}

ClassMethod QryDiasByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//^DHCMed.INF.InfPathogenDicD
 	//^DHCMed.INF.InfPathogenDicI("Code",{Code},{RowID})
 	//1:Rowid 2: ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
 	s Paadm=$$ALPHAUP^SSUTIL4(Paadm)
 	s TypeCode=$$ALPHAUP^SSUTIL4(TypeCode)
 	q:(Paadm="")!(TypeCode="") $$$OK
 	//读取取电子病历配置信息
    //默认取医生站诊断
 	//s RepID=##class(DHCMed.NINFService.Aim.InfReportSrv).GetReportID(Paadm,TypeCode)
 	s RepID=InfRepDr
 	s DiasFlag=+##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DHCMedBaseGetDias","")
 	//取 医生站诊断信息
 	s DiasStr=""
 	s:(DiasFlag=0)!(DiasFlag=2) DiasStr=##class(DHCMed.Base.MRDiagnose).GetByPaadm(Paadm)
 	d BulidPatientDiag
 	//取 电子病历诊断信息
 	s:(DiasFlag=1)!(DiasFlag=2) DiasStr=..GetEPRDiagByPaadm(Paadm)
 	d BulidPatientDiag
 	Quit $$$OK	
BulidPatientDiag   
 	q:DiasStr=""
 	f i=1:1:($l(DiasStr,$c(1))-1) d
 	.s Data=$lb("")
 	.s DiaStr=$p(DiasStr,$c(1),i)
 	.f iBuild=1:1:$l(DiaStr,"^") d
 	..s $li(Data,iBuild)=$p(DiaStr,"^",iBuild)
 	.//s Data=$lb(objPatient.Papmi, objPatAdm.AdmRowID, objPatient.PatientName, objPatAdm.AdmType, objPatient.Age,objPatAdm.Department,objPatAdm.DoctorName,objPatAdm.AdmitDate,objPatAdm.Status)
 	.s:$li(Data,8)'="" $li(Data,8)=$zd(+$li(Data,8),4)
 	.s:$li(Data,9)'="" $li(Data,9)=$zt(+$li(Data,9),1)
 	.s $li(Data,15)=""  //诊断类型 checked
 	.s checked=""
 	.s flagTmp=##class(DHCMed.INF.RepDiagRel).HaveRel(TypeCode,RepID,$li(Data,2))
 	.s:flagTmp=1 checked="1"
 	.s $li(Data,16)=checked  //选择 checked
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
}

ClassMethod QryDiasByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiasByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiasByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiasByPaadmExecute ]
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
/// CreatDate：   2010-05-19
/// Description:  查询病人所有诊断的信息
/// Table：       DHCMed.INF.InfDiagnose
/// Input：       Alias ： 别名
/// output:       符合条件的项            
/// Return：      1:Rowid 2:Code 3:Name 4:CtlocDr 5:CtlocDesc 6:SSGroupDr 7:SSGroupDesc 8:CtpcpDr
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.InfBaseSrv","QryUserByAlias","58008")
Query QryUserByAlias(Alias As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Name:%String,CtlocDr:%String,CtlocDesc:%String,SSGroupDr:%String,SSGroupDesc:%String,CtpcpDr:%String")
{
}

ClassMethod QryUserByAliasExecute(ByRef qHandle As %Binary, Alias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//##class(DHCMed.Base.SSUser).GetByAlias("d")
 	//^DHCMed.INF.InfPathogenDicI("Code",{Code},{RowID})
 	//1:Rowid 2: ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
 	s Alias=$$ALPHAUP^SSUTIL4(Alias)
 	q:Alias="" $$$OK
 	s UsrInfos=##class(DHCMed.Base.SSUser).GetByAlias(Alias)
 	f i=1:1:($l(UsrInfos,$c(1))-1) d
 	.s Data=$lb("")
 	.s UsrInfo=$p(UsrInfos,$c(1),i)
 	.f iBuild=1:1:$l(UsrInfo,"^") d
 	..s $li(Data,iBuild)=$p(UsrInfo,"^",iBuild)
 	.//s Data=$lb(1:Rowid 2:Code 3:Name 4:CtlocDr 5:CtlocDesc 6:SSGroupDr 7:SSGroupDesc 8:CtpcpDr)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

ClassMethod QryUserByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUserByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserByAliasExecute ]
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

ClassMethod admdeplookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admdeplookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admdeplookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s desc=$$ALPHAUP^SSUTIL4(desc)   //$$ALPHAUP^SSUTIL4(desc)
	s rowid=0
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    .q:$p($g(^CTLOC(rowid)),"^",13)'="E"
    .s Desc=$p($g(^CTLOC(rowid)),"^",2)
    .q:(desc'="")&&(Desc'[desc)
    .s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    .s:ContactName["-" ContactName=$p(ContactName,"-",1)
    .d OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,Desc,ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admdeplookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admdeplookupExecute ]
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

/// Creator：    cjb
/// CreatDate：  2010-02-24
/// Description：查询科室Query
/// Table：      
/// Input：  	 desc：科室描述  
/// Output：     dep,depid,ContactName
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.InfBaseSrv","admdeplookup","")
Query admdeplookup(desc As %String) As %Query(ROWSPEC = "depid:%String,dep:%String,ContactName:%String")
{
}

ClassMethod QueryLoctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLoctionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryLoctionExecute(ByRef qHandle As %Binary, Desc, Dep, Loc, Type) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	;;^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s Rowid=0
	f  s Rowid=$o(^CTLOC(Rowid)) q:Rowid=""  d
	.s tmpLoc=$g(^CTLOC(+Rowid))
    .s LocDesc=$p(tmpLoc,"^",2)
    .s LocDep=$p(tmpLoc,"^",19)
    .s LocType=$p(tmpLoc,"^",13)
    .q:(Desc'="")&&($$ALPHAUP^SSUTIL4(LocDesc)'[Desc)
    .q:(Dep'="")&&(LocDep'=Dep)    //判断科室是否属于Dep部门组
	.q:(Loc'="")&&('$d(^CTLOC(Loc,"LINK",0,"Loc",+Rowid)))   //根据科室关联科室表判断科室是否属于Loc科室  CT_LocLinkLocation
    .q:(Type'="")&&(LocType'=Type)  //判断科室类型 E--执行科室  W--病区  
    .s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)	//add by liuxuefeng 2009-12-05
    .s Data=$lb(Rowid,LocDesc)
    .s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryLoctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLoctionExecute ]
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

/// 查询科室列表
/// Desc--科室名称  Dep--部门组  Loc--科室  Type--科室类型
/// d ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.InfBaseSrv","QueryLoction","","","","")
Query QueryLoction(Desc, Dep, Loc, Type) As %Query(ROWSPEC = "LocId:%String,LocDesc:%String")
{
}

/// Creator：     陈剑波
/// CreatDate：   2010-09-17
/// Description:  根据paadm取诊断信息
/// Table：       
/// Input：       paadm    
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Aim.InfBaseSrv).GetEPRDiagByPaadm(51104)
ClassMethod GetEPRDiagByPaadm(Paadm) As %String
{
	n (Paadm)
    s ret=""
    s PaadmType=$p($g(^PAADM(Paadm)),"^",2)
    s CTLoc=$p($g(^PAADM(Paadm)),"^",4)
    s LocDesc=CTLoc_"/"_$p($g(^CTLOC(+CTLoc)),"^",2)
    s DiagType=""
    f  s DiagType=$o(^DHCMedEPR("诊断名称",DiagType)) q:DiagType=""  d
    .s DiagTMP="",Flag=0
    .f  s DiagTMP=$o(^DHCMedEPR("诊断名称",DiagType,DiagTMP)) q:(DiagTMP="")||(Flag=1)  d
    ..s (MRDiagDR,ICDDR,ICDDoctorDR,ICDType,ICDDate,ICDTime)=""
    ..s EleCode=$g(^DHCMedEPR("诊断名称",DiagType,DiagTMP))
    ..q:EleCode=""
    ..s DiagDesc=##class(DHCMed.Base.EPR).GetEPRElementData(Paadm,EleCode,0)
    ..q:DiagDesc=""
    ..s EleCode=$g(^DHCMedEPR("诊断ICD",DiagType,DiagTMP))
    ..s DiagCode=##class(DHCMed.Base.EPR).GetEPRElementData(Paadm,EleCode,0)
    ..s MRDiagDR=Paadm_"||"_"EPR$"_Paadm_"$"_DiagType_"$"_DiagTMP
    ..s ICDDR=Paadm_"/EPR/"_DiagCode
    ..s ICDType="//"_DiagType
    ..s Flag=1
    ..//                                                        
    ..s ret=ret_Paadm_"^"_ICDDR_"^"_ICDDoctorDR_"^"_""_"^"_""_"^"_""_"^"_""_"^"_ICDDate_"^"_ICDTime_"^"_"Y"_"^"_""_"^"_""_"^"_DiagCode_"^"_DiagDesc_"^"_DiagType_$c(1)
    //s:ret'="" ret=$e(ret,1,$l(ret)-1)
    q ret
}

ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

ClassMethod GetDictionaryByType(type As %String) As %String
{
	s ret=""
	q:type="" ret
    s type=$ZCVT($g(type),"U")
 	/*
 	if (type="")
 	{
 		s type="SYS"
 	}
 	*/
    s type=" "_type
 	s myid=$o(^DHCMed.SS.DictionaryI("IdxofType",type,""))
 	
 	//s myid=$o(^DHCMed.SS.DictionaryD(""))
 	while (myid'="")
 	{
	s mydictionary=##class(DHCMed.SS.Dictionary).%OpenId(myid)
	if ($IsObject(mydictionary))
	{    
	    
		s Code=mydictionary.Code
		s Description=mydictionary.Description
		s TypeV=mydictionary.Type
		s Active=mydictionary.Active
		if (Active="1")
		{
			s Active="YES"  
			}
	    else
	    {
		  	s Active="NO"  
		    }
			    
		s HospitalDr=mydictionary.HospitalDr
		s HispsDescs=$p($g(^CT("HOSP",+HospitalDr)),"^",2)
		
		s DateFrom=mydictionary.DateFrom
		s DateTo=mydictionary.DateTo
		if (DateFrom'="")
		{
		s DateFrom=$zd(DateFrom,1)
		}
		if (DateTo'="")
		{
	    s DateTo=$zd(DateTo,1)
		}
		//set Data=$lb(myid,Code,Description,Type,Active,HispsDescs,DateFrom,DateTo,HospitalDr)
        set:ret'="" ret=ret_$c(1)_myid_"^"_Code_"^"_Description_"^"_TypeV_"^^^^^^^^^^^"
        set:ret="" ret=myid_"^"_Code_"^"_Description_"^"_TypeV_"^^^^^^^^^^^"
		  } 	
	   //  s myid=$o(^DHCMed.SS.DictionaryD(myid))
	   s myid=$o(^DHCMed.SS.DictionaryI("IdxofType",type,myid))
	 	}
	 	q ret
}

/// Creator：     LYH
/// CreatDate：   2011-05-03
/// Description:  通过报告类型、时间、科室取医院感染人次
/// Table：          
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Aim.InfBaseSrv).GetInfPatNo(1,"2010-01-01","2012-01-01","")
ClassMethod GetInfPatNo(type As %String, sDate As %String, eDate As %String, CtlocDR As %String) As %String
{
	k ^CacheTemp($zn,$j,"INFPatNo")
	s ret=0,num=0
	q:sDate="" ret
	q:eDate="" ret
	q:type="" ret
	
	s:sDate["-" sDate=$zdh(sDate,3)
	s:sDate["/" sDate=$zdh(sDate,1)
	s:eDate["-" eDate=$zdh(eDate,3)
	s:eDate["/" eDate=$zdh(eDate,1)
	q:sDate>eDate ret
	
	s tDate=sDate-1
	f  s tDate=$o(^DHCMed.INF.ReportI("TypeDate"," "_type,tDate)) q:(tDate="")||(tDate>eDate)  d
	.s rowid=""
	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate"," "_type,tDate,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.INF.Report).%OpenId(rowid)
	..q:((CtlocDR'="")&(CtlocDR'=obj.CtLoc))
	..s paadm=obj.PaadmDR
	..q:paadm=""
	..s papmi=$p($g(^PAADM(paadm)),"^",1)
	..q:papmi=""
	..i '$d(^CacheTemp($zn,$j,"INFPatNo",papmi)) d
	...s ^CacheTemp($zn,$j,"INFPatNo",papmi)=""
	...s num=num+1
	
	q num
}

/// Creator：     LYH
/// CreatDate：   2011-05-03
/// Description:  通过报告类型、时间、科室取医院感染例次
/// Table：          
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Aim.InfBaseSrv).GetInfPerNo(1,"2010-01-01","2012-01-01","")
ClassMethod GetInfPerNo(type As %String, sDate As %String, eDate As %String, CtlocDR As %String) As %String
{
	k ^CacheTemp($zn,$j,"PerNo")
	s ret=0,num=0
	q:sDate="" ret
	q:eDate="" ret
	q:type="" ret
	
	s:sDate["-" sDate=$zdh(sDate,3)
	s:sDate["/" sDate=$zdh(sDate,1)
	s:eDate["-" eDate=$zdh(eDate,3)
	s:eDate["/" eDate=$zdh(eDate,1)
	q:sDate>eDate ret
	
	s tDate=sDate-1
	f  s tDate=$o(^DHCMed.INF.ReportI("TypeDate"," "_type,tDate)) q:(tDate="")||(tDate>eDate)  d
	.s rowid=""
	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate"," "_type,tDate,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.INF.Report).%OpenId(rowid)
	..q:((CtlocDR'="")&(CtlocDR'=obj.CtLoc))
	..s num=num+1
	
	q num
}

/// Creator：     LYH
/// CreatDate：   2011-05-05
/// Description:  通过报告类型、时间、科室取感染部位例次
/// Table：          
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Aim.InfBaseSrv).GetInfPosition(1,"2010-01-01","2012-01-01","","")
ClassMethod GetInfPosition(type As %String, sDate As %String, eDate As %String, CtlocDR As %String, posDR As %String) As %String
{
	s ret=0,num=0
	q:sDate="" ret
	q:eDate="" ret
	q:type="" ret
	
	s:sDate["-" sDate=$zdh(sDate,3)
	s:sDate["/" sDate=$zdh(sDate,1)
	s:eDate["-" eDate=$zdh(eDate,3)
	s:eDate["/" eDate=$zdh(eDate,1)
	q:sDate>eDate ret
	
	s tDate=sDate-1
	f  s tDate=$o(^DHCMed.INF.ReportI("TypeDate"," "_type,tDate)) q:(tDate="")||(tDate>eDate)  d
	.s rowid=""
	.f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate"," "_type,tDate,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.INF.Report).%OpenId(rowid)
	..q:((CtlocDR'="")&(CtlocDR'=obj.CtLoc))
	..s sumID=""
	..f  s sumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,sumID)) q:sumID=""  d
	...s posID=""
	...f  s posID=$o(^DHCMed.INF.RepPosI("InfRepDr",sumID,posID)) q:posID=""  d
	....s posObj=##class(DHCMed.INF.RepPos).%OpenId(posID)
	....s InfPos=posObj.InfPosCode		//感染部位
	....q:((posDR'="")&(posDR'=InfPos))
	....s num=num+1
	
	q num
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.NINFService.Aim.InfBaseSrv).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

}
