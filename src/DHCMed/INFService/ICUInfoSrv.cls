/// 名称: DHCMed.INFService.ICUInfoSrv
/// 描述: 感染的常用基本操作
/// 编写者：ChenJB
/// 编写日期: 2010-07-01
Class DHCMed.INFService.ICUInfoSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     陈剑波
/// CreatDate：   2010-05-28
/// Description:  查询所有的感染相关项目
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.ICUInfoSrv","QryICUDevByICUID","1")
Query QryICUDevByICUID(ICUID As %String) As %Query(ROWSPEC = "DeviceType:%String,DeviceTypeDesc:%String,PipeType:%String,PipeTypeDesc:%String,CavityType:%String,CavityTypeDesc:%String,PipeBody:%String,PipeBodyDesc:%String,PipePlace:%String,PipePlaceDesc:%String,DoPipeDate:%String,DoPipeTime:%String,UnPipeDate:%String,UnPipeTime:%String,WholeSyptom:%String,WholeSyptomDesc:%String,PartSyptom:%String,PartSyptomDesc:%String,UserType:%String,UserTypeDesc:%String,DoUserDr:%String,DoUserDrDesc:%String,InfectionPos:%String,InfectionPosDesc:%String,ICUInfDate:%String,InfICUType:%String,InfICUTypeDesc:%String,rowid:%String")
{
}

ClassMethod QryICUDevByICUIDExecute(ByRef qHandle As %Binary, ICUID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1	
    q:ICUID="" $$$OK
    s ICUIDIdx=" "_$ZCVT(ICUID,"U")
    s rowid=""
    f  s rowid=$o(^DHCMed.INF.ICUDeviceInfoI("InfRepICU",ICUID,rowid)) q:rowid=""  d
    .s objCls=##class(DHCMed.INF.ICUDeviceInfo).%OpenId(rowid)
	.q:'$IsObject(objCls)
	.s (DeviceType,DeviceTypeDesc,PipeType,PipeTypeDesc,CavityType,CavityTypeDesc,PipeBody,PipeBodyDesc)=""
	.s (PipePlace,PipePlaceDesc,DoPipeDate,DoPipeTime,UnPipeDate,UnPipeTime,WholeSyptom,WholeSyptomDesc)=""
	.s (PartSyptom,PartSyptomDesc,UserType,UserTypeDesc,DoUserDr,DoUserDrDesc,InfectionPos,InfectionPosDesc,ICUInfDate,InfICUType,InfICUTypeDesc)=""
	.s DeviceType=objCls.DeviceType
	.s PipeType=objCls.PipeType
	.s CavityType=objCls.CavityType
	.s PipeBody=objCls.PipeBody
	.s PipePlace=objCls.PipePlace
	.s DoPipeDate=objCls.DoPipeDate
	.s DoPipeTime=objCls.DoPipeTime
	.s UnPipeDate=objCls.UnPipeDate
	.s UnPipeTime=objCls.UnPipeTime
	.s WholeSyptom=objCls.WholeSyptom
	.s PartSyptom=objCls.PartSyptom
	.s UserType=objCls.UserType
	.s DoUserDr=objCls.DoUserDr
	.s InfectionPos=objCls.InfectionPos
	.s ICUInfDate=objCls.ICUInfDate
	.s InfICUType=objCls.InfICUType
	.s:+DoPipeDate'=0 DoPipeDate=$zd(DoPipeDate,3)
	.s:+DoPipeTime'=0 DoPipeTime=$zt(DoPipeTime,1)
	.s:+UnPipeDate'=0 UnPipeDate=$zd(UnPipeDate,3)
	.s:+UnPipeTime'=0 UnPipeTime=$zt(UnPipeTime,1)
	.s:+ICUInfDate'=0 ICUInfDate=$zd(ICUInfDate,3)
	.i InfectionPos'="" d
    ..s objPos=##class(DHCMed.INF.InfPosition).GetObjById(InfectionPos)
    ..q:'$IsObject(objPos)
    ..s InfectionPosDesc=objPos.InfPosition
    ..k objPos
	.i DoUserDr'="" d
    ..s objUser=##class(DHCMed.Base.SSUser).GetObjById(DoUserDr)
    ..q:'$IsObject(objUser)
    ..s DoUserDrDesc=objUser.Name
    ..k objUser
	.i DeviceType'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DeviceType,"DeviceType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s DeviceTypeDesc=objDic.Description
    ..k objDic
    .i PipeType'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeType,"PipeType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s PipeTypeDesc=objDic.Description
    ..k objDic
    .i PipeBody'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeBody,"PipeBody")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s PipeBodyDesc=objDic.Description
    ..k objDic
    .i CavityType'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CavityType,"CavityType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s CavityTypeDesc=objDic.Description
    ..k objDic
    .i PipePlace'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipePlace,"PipePlace")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s PipePlaceDesc=objDic.Description
    ..k objDic
    .i WholeSyptom'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(WholeSyptom,"WholeSyptom")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s WholeSyptomDesc=objDic.Description
    ..k objDic
    .i PartSyptom'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PartSyptom,"PartSyptom")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s PartSyptomDesc=objDic.Description
    ..k objDic
    .i UserType'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(UserType,"UserType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s UserTypeDesc=objDic.Description
    ..k objDic
    .i InfICUType'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfICUType,"InfICUType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s InfICUTypeDesc=objDic.Description
    ..k objDic
    .s Data=$lb("")
    .s $li(Data,1)=DeviceType
    .s $li(Data,2)=DeviceTypeDesc
    .s $li(Data,3)=PipeType
    .s $li(Data,4)=PipeTypeDesc
    .s $li(Data,5)=CavityType
    .s $li(Data,6)=CavityTypeDesc
    .s $li(Data,7)=PipeBody
    .s $li(Data,8)=PipeBodyDesc
    .s $li(Data,9)=PipePlace
    .s $li(Data,10)=PipePlaceDesc
    .s $li(Data,11)=DoPipeDate
    .s $li(Data,12)=DoPipeTime
    .s $li(Data,13)=UnPipeDate
    .s $li(Data,14)=UnPipeTime
    .s $li(Data,15)=WholeSyptom
    .s $li(Data,16)=WholeSyptomDesc
    .s $li(Data,17)=PartSyptom
    .s $li(Data,18)=PartSyptomDesc
    .s $li(Data,19)=UserType
    .s $li(Data,20)=UserTypeDesc
    .s $li(Data,21)=DoUserDr
    .s $li(Data,22)=DoUserDrDesc
    .s $li(Data,23)=InfectionPos
    .s $li(Data,24)=InfectionPosDesc
    .s $li(Data,25)=ICUInfDate
    .s $li(Data,26)=InfICUType
    .s $li(Data,27)=InfICUTypeDesc
    .s $li(Data,28)=rowid
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QryICUDevByICUIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUDevByICUIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	;Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUDevByICUIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUDevByICUIDExecute ]
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
/// CreatDate：   2010-07-02
/// Description:  查询病人感染ICU的信息
/// Table：       DHCMed.Base.OrdItem
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.ICUInfoSrv","QryInfICUByPaadm","51104","2")
Query QryInfICUByPaadm(Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Query(ROWSPEC = "Rowid:%String,InfBeICUCode:%String,InBeICUDate:%String,InfICUCode:%String,InICUDate:%String,InICUTime:%String,InICULoc:%String,OutICUDate:%String,OutICUTime:%String,OutICULoc:%String,OutStatus:%String,OutHStatus:%String,OutDeviceCode:%String,ResumeText:%String,InfBeICUCodeDesc:%String,InfICUCodeDesc:%String,InICULocDesc:%String,OutDeviceCodeDesc:%String,OutICULocDesc:%String")
{
}

ClassMethod QryInfICUByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String = "", TypeCode As %String = "", InfRepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	q:Paadm="" $$$OK
 	q:TypeCode="" $$$OK
 	s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
 	//^DHCMed.INF.ReportI("TypePaadm",{Type},{Paadm_DR}
    q:'$d(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx)) $$$OK
    s RepRowid=""
    //s RepRowid=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm,RepRowid))
    s RepRowid=InfRepDr
    q:RepRowid="" $$$OK
    // ^DHCMed.INF.SummaryI("InfRepDr"
    q:'$d(^DHCMed.INF.ICUInfoI("InfRepDr",RepRowid)) $$$OK
    //^DHCMed.INF.RepPosI("InfRepDr"   该处是关联到最顶层的表 
    s tmpRowid=""
    f  s tmpRowid=$o(^DHCMed.INF.ICUInfoI("InfRepDr",RepRowid,tmpRowid)) q:tmpRowid=""  d
    .s objCls=##class(DHCMed.INF.ICUInfo).GetObjById(tmpRowid)
    .q:'$IsObject(objCls)
    .s InfBeICUCode=objCls.InfBeICUCode
    .s InBeICUDate=objCls.InBeICUDate
    .s InfICUCode=objCls.InfICUCode
    .s InICUDate=objCls.InICUDate
    .s InICUTime=objCls.InICUTime
    .s InICULoc=objCls.InICULoc
    .s OutICUDate=objCls.OutICUDate
    .s OutICUTime=objCls.OutICUTime
    .s OutICULoc=objCls.OutICULoc
    .s OutStatus=objCls.OutStatus
    .s OutHStatus=objCls.OutHStatus
    .s OutDeviceCode=objCls.OutDeviceCode
    .s ResumeText=objCls.ResumeText
    .s:+InBeICUDate'=0 InBeICUDate=$zd(+InBeICUDate,3)
    .s:+InICUDate'=0 InICUDate=$zd(+InICUDate,3)
    .s:+InICUTime'=0 InICUTime=$zt(+InICUTime,1)
    .s:+OutICUDate'=0 OutICUDate=$zd(+OutICUDate,3)
    .s:+OutICUTime'=0 OutICUTime=$zt(+OutICUTime,1)
    .s (InfBeICUCodeDesc,InfICUCodeDesc,InICULocDesc,OutDeviceCodeDesc,OutICULocDesc)=""
    .i InICULoc'="" d
    ..s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(InICULoc)
    ..q:'$IsObject(objTmp)
    ..s InICULocDesc=objTmp.Descs
    .i OutICULoc'="" d
    ..s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(OutICULoc)
    ..q:'$IsObject(objTmp)
    ..s OutICULocDesc=objTmp.Descs
    .i InfBeICUCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfBeICUCode,"InfICUCode")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s InfBeICUCodeDesc=objDic.Description
    ..k objDic
    .i InfICUCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfICUCode,"InfICUCode")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s InfICUCodeDesc=objDic.Description
    ..k objDic
    .i OutDeviceCode'="" d
    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OutDeviceCode,"OutDeviceCode")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
    ..q:'$IsObject(objDic)
    ..s OutDeviceCodeDesc=objDic.Description
    ..k objDic
    .s Data=$lb("")
    .s $li(Data,1)=tmpRowid
    .s $li(Data,2)=InfBeICUCode
    .s $li(Data,3)=InBeICUDate
    .s $li(Data,4)=InfICUCode
    .s $li(Data,5)=InICUDate  
    .s $li(Data,6)=InICUTime
    .s $li(Data,7)=InICULoc
    .s $li(Data,8)=OutICUDate
    .s $li(Data,9)=OutICUTime
    .s $li(Data,10)=OutICULoc
    .s $li(Data,11)=OutStatus
    .s $li(Data,12)=OutHStatus
    .s $li(Data,13)=OutDeviceCode
    .s $li(Data,14)=ResumeText
    .s $li(Data,15)=InfBeICUCodeDesc
    .s $li(Data,16)=InfICUCodeDesc
    .s $li(Data,17)=InICULocDesc
    .s $li(Data,18)=OutDeviceCodeDesc
    .s $li(Data,19)=OutICULocDesc
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QryInfICUByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfICUByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	;Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfICUByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfICUByPaadmExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-08-04
/// Description:  查询所有日常记录信息
/// Table：       
/// Input：       报告类型 , 时间 , 科室 
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.ICUInfoSrv","QryTypePatInfo","1")
Query QryTypePatInfo(TypeCode As %String, SurgDate As %String = "", Ctloc As %String = "") As %Query(ROWSPEC = "ID:%String,TypeCode:%String,SurgDt:%String,Ctloc:%String,CtlocDesc:%String,Count1:%String,Count2:%String,Count3:%String,Count4:%String,Count5:%String,Count6:%String,Count7:%String,Count8:%String")
{
}

ClassMethod QryTypePatInfoExecute(ByRef qHandle As %Binary, TypeCode As %String, SurgDate As %String = "", Ctloc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1	
    q:TypeCode="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:SurgDate["-" SurgDate=$zdh(SurgDate,3)
	s:SurgDate["/" SurgDate=$zdh(SurgDate,4)
	//^DHCMed.INF.ICUPatientInfoI("TypeMainIdx"
	i SurgDate="" d
    .f  s SurgDate=$o(^DHCMed.INF.ICUPatientInfoI("TypeMainIdx",TypeCodeIdx,SurgDate)) q:SurgDate=""  d
    ..s ID=""
 	..f  s ID=$o(^DHCMed.INF.ICUPatientInfoI("TypeMainIdx",TypeCodeIdx,SurgDate,ID)) q:+ID=0  d
 	...s objDic=##class(DHCMed.INF.ICUPatientInfo).%OpenId(ID)
	...q:'$IsObject(objDic)
	...s tmpCtloc=objDic.CtLoc
	...s tmpCtlocDesc=""
	...q:(Ctloc'="")&(Ctloc'=tmpCtloc)
	...//s TypeDesc=""
	...//s dicIDN=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(TypeCode,"InfectionType")
	...//s objDicN=##class(DHCMed.SS.Dictionary).GetObjById(dicIDN)
	...//i $IsObject(objDicN)  d
	...//.s TypeDesc=objDicN.Description
	...//.k objDicN
	...s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(tmpCtloc)
	...s:$IsObject(objTmp) tmpCtlocDesc=objTmp.Descs
	...s tmpSurgDt=objDic.SurveryDate
	...s tmpSurgDt=$zd(+tmpSurgDt,3)
	...s count1=objDic.Count1
	...s count2=objDic.Count2
	...s count3=objDic.Count3
	...s count4=objDic.Count4
	...s count5=objDic.Count5
	...s count6=objDic.Count6
	...s count7=objDic.Count7
	...s count8=objDic.Count8
	...s Data=$lb(ID,TypeCode,tmpSurgDt,tmpCtloc,tmpCtlocDesc,count1,count2,count3,count4,count5,count6,count7,count8)
    ...s ^CacheTemp(repid,ind)=Data
    ...s ind=ind+1
    e  d
    .s ID=""
    .f  s ID=$o(^DHCMed.INF.ICUPatientInfoI("TypeMainIdx",TypeCodeIdx,SurgDate,ID)) q:+ID=0  d
	..s objDic=##class(DHCMed.INF.ICUPatientInfo).%OpenId(ID)
	..q:'$IsObject(objDic)
	..s tmpCtloc=objDic.CtLoc
	..s tmpCtlocDesc=""
	..q:(Ctloc'="")&(Ctloc'=tmpCtloc)
	..//s TypeDesc=""
	..//s dicIDN=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(TypeCode,"InfectionType")
	..//s objDicN=##class(DHCMed.SS.Dictionary).GetObjById(dicIDN)
	..//i $IsObject(objDicN)  d
	..//.s TypeDesc=objDicN.Description
	..//.k objDicN
	..s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(tmpCtloc)
	..s:$IsObject(objTmp) tmpCtlocDesc=objTmp.Descs
	..s tmpSurgDt=objDic.SurveryDate
	..s tmpSurgDt=$zd(+tmpSurgDt,3)
	..s count1=objDic.Count1
	..s count2=objDic.Count2
	..s count3=objDic.Count3
	..s count4=objDic.Count4
	..s count5=objDic.Count5
	..s count6=objDic.Count6
	..s count7=objDic.Count7
	..s count8=objDic.Count8
	..s Data=$lb(ID,TypeCode,tmpSurgDt,tmpCtloc,tmpCtlocDesc,count1,count2,count3,count4,count5,count6,count7,count8)
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
	Quit $$$OK
}

ClassMethod QryTypePatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypePatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTypePatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypePatInfoExecute ]
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

/// Creator：     Lyh
/// CreatDate：   2011-08-16
/// Description:  通过日期查询ICU报告信息
/// Table：       
/// Input：       
/// output:          
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.ICUInfoSrv","QryICUInfoByDate","icu",2011,8)
Query QryICUInfoByDate(TypeCode As %String, Year As %String, Month As %String) As %Query(ROWSPEC = "ind:%String,Count1:%String,Count2:%String,Count3:%String,Count4:%String,Count5:%String,Count6:%String,Count7:%String,Count8:%String,CtLoc:%String,SurveryDate:%String")
{
}

ClassMethod QryICUInfoByDateExecute(ByRef qHandle As %Binary, TypeCode As %String, Year As %String, Month As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:(TypeCode="")||(Year="")||(Month="") $$$OK
	s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
	i Month<12 d
	.s sMonth=Month+1
	.s LastDate=$zdh(Year_"-"_sMonth_"-"_1,3)-1
	.s days=$p($zd(LastDate,3),"-",3)
	i Month>11 d
	.s Month=12
	.s days=31

	f i=1:1:days d
	.s (Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,CtLoc,SurveryDate)=""
	.s ReportDate=+$zdh(+Year_"-"_Month_"-"_i,3)
	.s rowid=$o(^DHCMed.INF.ICUPatientInfoI("TypeMainIdx",TypeCodeIdx,ReportDate,""))
	.i rowid'="" d
	..s obj=##Class(DHCMed.INF.ICUPatientInfo).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s Count1=obj.Count1
	..s Count2=obj.Count2
	..s Count3=obj.Count3
	..s Count4=obj.Count4
	..s Count5=obj.Count5
	..s Count6=obj.Count6
	..s Count7=obj.Count7
	..s Count8=obj.Count8
	..s CtLoc=obj.CtLoc
	..s SurveryDate=obj.SurveryDate
	..s:SurveryDate'="" SurveryDate=$zd(+SurveryDate,3)
	..s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(CtLoc)
	..s:$IsObject(objTmp) CtLoc=CtLoc_"/"_objTmp.Descs
	.s Data=$lb(ind,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,CtLoc,SurveryDate)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryICUInfoByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUInfoByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUInfoByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUInfoByDateExecute ]
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

/// w ##Class(DHCMed.INFService.ICUInfoSrv).QryICUInfoByDateToExport("fillxlSheet","icu^2011^8")
ClassMethod QryICUInfoByDateToExport(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	s TypeCode=$p(strArguments,"^",1)
	s year=$p(strArguments,"^",2)
	s month=$p(strArguments,"^",3)
	
	q:(TypeCode="")||(year="")||(month="") ""
	s ds = ##class(%Library.ResultSet).%New("DHCMed.INFService.ICUInfoSrv:QryICUInfoByDate")
	d ds.Execute(TypeCode,year,month)
	
	s StartRow=6
	while(ds.Next())
	{
	s ind=ds.Data("ind")
	s Count1=ds.Data("Count1")
	s Count2=ds.Data("Count2")
	s Count3=ds.Data("Count3")
	s Count4=ds.Data("Count4")
	s Count5=ds.Data("Count5")

	s valCells=ind_$c(1)_Count1_$c(1)_Count2_$c(1)_Count3_$c(1)_Count4_$c(1)_Count5
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
	&javascript<#(retval)#>
	
	s StartRow=StartRow+1
	}
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(year_ "年"_month_" 月","O","JS")_"',"_3_",2);"
	&javascript<#(retval)#>
	
	s dates=$zd($h,3)
	s retval=itmjs_"(xlSheet,'"_$ZCVT($p(dates,"-",1)_ "年"_$p(dates,"-",2)_" 月"_$p(dates,"-",3)_" 日","O","JS")_"',"_3_",5);"
	&javascript<#(retval)#>
	
	d ds.Close()
	q Count
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.INFService.BorthWeightSrv).GetServerInfo()
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
