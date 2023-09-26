/// 名称: DHCMed.InfAimService.VentilatorSrv
/// 描述: 呼吸机相关报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-20
Class DHCMed.InfAimService.VentilatorSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-10-24
/// Description:  查询呼吸机相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.VentilatorSrv","QueryVentilatorInfo","1")
Query QueryVentilatorInfo(paadm As %String, tTransSubID As %String) As %Query(ROWSPEC = "ind:%String,RepID:%String,rowid:%String,VenDate:%String,VenType:%String,VenTypeDesc:%String,VenPlace:%String,VenPlaceDesc:%String,VenUserType:%String,VenUserTypeDesc:%String,OutVenDate:%String,DeathFlag:%String,OutLocPlace:%String,InfFlag:%String,RepUser:%String,RepUserDesc:%String,RepStatus:%String,RepStatusDesc:%String,FirstDate:%String,VenHour:%String,InfDate:%String,Pathogenic:%String")
{
}

ClassMethod QueryVentilatorInfoExecute(ByRef qHandle As %Binary, paadm As %String, tTransSubID As %String) As %Status
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
	..q:'$d(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID))
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Ventilator).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s VenDate=obj.VenDate
	...s:VenDate'="" VenDate=$zd(VenDate,3)
	...s VenType=obj.VenType
	...s VenPlace=obj.VenPlace
	...s VenUserType=obj.VenUserType
	...s OutVenDate=obj.OutVenDate
	...s:OutVenDate'="" OutVenDate=$zd(OutVenDate,3)
	...s DeathFlag=obj.DeathFlag
	...s OutLocPlace=obj.OutLocPlace
	...s InfFlag=obj.InfFlag
	...s RepUser=obj.RepUser
	...s RepStatus=obj.RepStatus
	...q:RepStatus=0
	...s FirstDate=obj.FirstDate
	...s:FirstDate'="" FirstDate=$zd(FirstDate,3)
	...s VenHour=obj.VenHour
	...s InfDate=obj.InfDate
	...s:InfDate'="" InfDate=$zd(InfDate,3)
	...s Pathogenic=obj.Pathogenic
	...s (VenTypeDesc,VenPlaceDesc,VenUserTypeDesc,RepUserDesc,RepStatusDesc)=""
	...s (VenTypeDR,VenPlaceDR,VenUserTypeDR,RepStatusDR)=""
	
	...s:VenType'="" VenTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(VenType,"VenType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(VenTypeDR)
    ...s:$IsObject(objDic) VenTypeDesc=objDic.Description
    
    ...s:VenPlace'="" VenPlaceDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(VenPlace,"VenPlace")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(VenPlaceDR)
    ...s:$IsObject(objDic) VenPlaceDesc=objDic.Description
    
    ...s:VenUserType'="" VenUserTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(VenUserType,"VenUserType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(VenUserTypeDR)
    ...s:$IsObject(objDic) VenUserTypeDesc=objDic.Description
    
    ...i RepUser'="" d
    ....q:'$d(^SSU("SSUSR",RepUser))
    ....s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ...s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ...s:$IsObject(objDic) RepStatusDesc=objDic.Description
    
	...s Data=$lb(ind,RepID,rowid,VenDate,VenType,VenTypeDesc,VenPlace,VenPlaceDesc,VenUserType,VenUserTypeDesc,OutVenDate,DeathFlag,OutLocPlace,InfFlag,RepUser,RepUserDesc,RepStatus,RepStatusDesc,FirstDate,VenHour,InfDate,Pathogenic)
 	...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryVentilatorInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVentilatorInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryVentilatorInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVentilatorInfoExecute ]
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

/// 保存 呼吸机相关报告表 信息
/// w ##class(DHCMed.InfAimService.VentilatorSrv).SaveVentilatorInfo("")
ClassMethod SaveVentilatorInfo(str As %String) As %String
{
	n (str)
	s ret=-1,tmp=0
	q:str="" ret
	s paadm=$p(str,"^",1)
	s TransSubID=$p(str,"^",2)
	s VentilatorID=$p(str,"^",3)
	s VenDate=$p(str,"^",4)
	s:VenDate["-" VenDate=$zdh(VenDate,3)
	s VenType=$p(str,"^",5)
	s VenPlace=$p(str,"^",6)
	s VenUserType=$p(str,"^",7)
	s OutVenDate=$P(str,"^",8)
	s:OutVenDate["-" OutVenDate=$zdh(OutVenDate,3)
	s DeathFlag=$p(str,"^",9)
	s OutLocPlace=$p(str,"^",10)
	s InfFlag=$p(str,"^",11)
	s RepUser=$p(str,"^",12)
	s RepStatus=$p(str,"^",13)
	s FirstDate=$p(str,"^",14)
	s:FirstDate["-" FirstDate=$zdh(FirstDate,3)
	s:FirstDate="" FirstDate=+$h
	s VenHour=$p(str,"^",15)
	s InfDate=$p(str,"^",16)
	s:InfDate["-" InfDate=$zdh(InfDate,3)
	s Pathogenic=$p(str,"^",17)
	q:+paadm=0 ret
	q:+TransSubID=0 ret
	
	set $ZT="Error"
	TStart
	
	s ReportID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,""),-1)
	i '$d(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) d
	.s ReportID=##class(DHCMed.InfAim.Report).Update("^"_+paadm_"^"_+TransSubID)
	
	i ReportID<0  TRollback
	s VenInfo=VentilatorID_"^"_ReportID_"^"_VenDate_"^"_VenType_"^"_VenPlace_"^"_VenUserType_"^"_OutVenDate
	s VenInfo=VenInfo_"^"_DeathFlag_"^"_OutLocPlace_"^"_InfFlag_"^"_RepUser_"^"_RepStatus_"^"_FirstDate_"^"_VenHour_"^"_InfDate_"^"_Pathogenic
	s VentilatorID=##class(DHCMed.InfAim.Ventilator).Update(VenInfo)
	i VentilatorID<0 TRollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// w ##class(DHCMed.InfAimService.VentilatorSrv).DeleteRep(1)
ClassMethod DeleteRep(RepID As %String) As %String
{
	n (RepID)	
	
	s ret=-1
	q:RepID="" ret
	q:'$d(^DHCMed.InfAim.VentilatorD(RepID)) ret
	&sql(update  DHCMed_InfAim.Ventilator set RepStatus=0  where ID=:RepID)
	
	s:'SQLCODE ret=1
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2011-10-31
/// Description:  查询呼吸机相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.VentilatorSrv","QueryVentilatorByDateLoc","2011-10-01","2011-10-30","","1")
Query QueryVentilatorByDateLoc(DateFrom As %String, DateTo As %String, CtLocID As %String, DateType As %String) As %Query(ROWSPEC = "ind:%String,PatientName:%String,InPatMrNo:%String,Sex:%String,Age:%String,VenDate:%String,VenTypeDesc:%String,VenPlaceDesc:%String,VenUserTypeDesc:%String,OutVenDate:%String,DeathFlagDesc:%String,InICUDay:%String,OutLocPlace:%String,InfFlag:%String,InfFlagDesc:%String,InfDate:%String,Pathogenic:%String")
{
}

ClassMethod QueryVentilatorByDateLocExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtLocID As %String, DateType As %String) As %Status
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
	.q:'$d(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID)) //不存在呼吸机报告
	.s VentilatorID=0
	.f  s VentilatorID=$o(^DHCMed.InfAim.VentilatorI("InfAimRepDR",RepID,VentilatorID)) q:VentilatorID=""  d
	..s obj=##class(DHCMed.InfAim.Ventilator).GetObjById(VentilatorID)
	..q:'$IsObject(obj)
	..s VenDate=obj.VenDate
	..s VenType=obj.VenType
	..s VenPlace=obj.VenPlace
	..s VenUserType=obj.VenUserType	
	..s OutVenDate=obj.OutVenDate
	..s InfFlag=obj.InfFlag
	..s RepUser=obj.RepUser
	..s RepStatus=obj.RepStatus
	..s FirstDate=obj.FirstDate
	..s OutLocPlace= "" //obj.OutLocPlace
	..s DeathFlag=obj.DeathFlag
	..q:RepStatus=0	//删除
	..s InfDate=obj.InfDate
	..s:InfDate'="" InfDate=$zd(InfDate,3)
	..s Pathogenic=obj.Pathogenic

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
	..q:(DateType=1)&((DateFrom>VenDate)||(DateTo<VenDate))	//按置管日期查询
	..q:(DateType=2)&((DateFrom>OutVenDate)||(DateTo<OutVenDate))	//按拔管日期查询
	..q:((DateType=3)||(DateType=""))&((DateFrom>FirstDate)||(DateTo<FirstDate))	//按报告日期查询
	
	..s retInfo=##class(DHCMed.InfAimService.BaseSrv).GetTranByPaadmSubID(paadm,TransSubID) //获取转入前及转出后的记录
	..i (retInfo'=-1)&(retInfo'="^") d
	...s LaterSubID=$p(retInfo,"^",2)
	...s OutICULocID=""
	...q:LaterSubID=""
	...s:LaterSubID'="" OutICULocID=$p($g(^PAADM(paadm,"TRANS",LaterSubID)),"^",6)	//出ICU科室
	...s:OutICULocID'="" OutLocPlace=$p($g(^CTLOC(OutICULocID)),"^",2)
	..i OutLocPlace="" d
	...s OutLocPlace="出院"
	...s:DisDate'="" OutLocPlace="在院"
	
	..s InICUDay=""
	..i (VenDate'="")&(OutVenDate'="") d
	...s InICUDay=OutVenDate+1-VenDate
	..e  i (VenDate'="")&(DisDate'="") d
	...s InICUDay=DisDate+1-VenDate	//拔管日期为空，用出院日期代替拔管日期
	
	..s:VenDate'="" VenDate=$zd(VenDate,3)
	..s:OutVenDate'="" OutVenDate=$zd(OutVenDate,3)
	
	..s (VenTypeDesc,VenPlaceDesc,VenUserTypeDesc,RepUserDesc,RepStatusDesc)=""
	..s (VenTypeDR,VenPlaceDR,VenUserTypeDR,RepStatusDR)=""
	
	..s:VenType'="" VenTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(VenType,"VenType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(VenTypeDR)
    ..s:$IsObject(objDic) VenTypeDesc=objDic.Description
    
    ..s:VenPlace'="" VenPlaceDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(VenPlace,"VenPlace")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(VenPlaceDR)
    ..s:$IsObject(objDic) VenPlaceDesc=objDic.Description
    
    ..s:VenUserType'="" VenUserTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(VenUserType,"VenUserType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(VenUserTypeDR)
    ..s:$IsObject(objDic) VenUserTypeDesc=objDic.Description
    
    ..i RepUser'="" d
    ...q:'$d(^SSU("SSUSR",RepUser))
    ...s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ..s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ..s:$IsObject(objDic) RepStatusDesc=objDic.Description
    
    ..s DeathFlagDesc="否"
	..s:DeathFlag=1 DeathFlagDesc="是"
	
	..s InfFlagDesc="否"
	..s:InfFlag=1 InfFlagDesc="是"
    
	..s Data=$lb(ind,PatientName,InPatMrNo,Sex,Age,VenDate,VenTypeDesc,VenPlaceDesc,VenUserTypeDesc,OutVenDate,DeathFlagDesc,InICUDay,OutLocPlace,InfFlag,InfFlagDesc,InfDate,Pathogenic)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryVentilatorByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryVentilatorByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryVentilatorByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryVentilatorByDateLocExecute ]
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

/// w ##Class(DHCMed.InfAimService.VentilatorSrv).GetVentilatorByDateLoc("fillxlSheet","^^^^")
ClassMethod GetVentilatorByDateLoc(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)
	s DateType =$p(strArguments,"^",4)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.InfAimService.VentilatorSrv:QueryVentilatorByDateLoc")
	d ds.Execute(DateFrom,DateTo,CtlocID,DateType)
	s StartRow=5
	while(ds.Next())
	{
		s PatientName=ds.Data("PatientName")
		s InPatMrNo=ds.Data("InPatMrNo")
		s Sex=ds.Data("Sex")
		s Age=ds.Data("Age")
		s VenDate=ds.Data("VenDate")
		s VenTypeDesc=ds.Data("VenTypeDesc")
		s VenPlaceDesc=ds.Data("VenPlaceDesc")
		s VenUserTypeDesc=ds.Data("VenUserTypeDesc")
		s OutVenDate=ds.Data("OutVenDate")
		s InfFlagDesc=ds.Data("InfFlagDesc")
		s InfDate=ds.Data("InfDate")
		s InICUDay=ds.Data("InICUDay")
		s OutLocPlace=ds.Data("OutLocPlace")
		s Pathogenic=ds.Data("Pathogenic")
		s valCells=PatientName_$c(1)_InPatMrNo_$c(1)_Sex_$c(1)_Age_$c(1)_VenDate_$c(1)_VenTypeDesc_$c(1)_VenPlaceDesc_$c(1)_VenUserTypeDesc_$c(1)_OutVenDate_$c(1)_InfFlagDesc_$c(1)_InfDate_$c(1)_InICUDay_$c(1)_OutLocPlace_$c(1)_Pathogenic
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	s valCells="查询日期："_DateFrom_" 至 "_DateTo
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_2_",8);"
	&javascript<#(retval)#>
	
	
	d ds.Close()
	
	q Count
}

Storage Default
{
<Data name="VentilatorSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim718.VentilatorSrvD</DataLocation>
<DefaultData>VentilatorSrvDefaultData</DefaultData>
<IdLocation>^DHCMed.InfAim718.VentilatorSrvD</IdLocation>
<IndexLocation>^DHCMed.InfAim718.VentilatorSrvI</IndexLocation>
<StreamLocation>^DHCMed.InfAim718.VentilatorSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
