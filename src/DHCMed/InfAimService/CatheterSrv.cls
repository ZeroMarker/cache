/// 名称: DHCMed.InfAimService.CatheterSrv
/// 描述: 尿管相关报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-20
Class DHCMed.InfAimService.CatheterSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-10-21
/// Description:  查询尿管相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.CatheterSrv","QueryCatheterInfo","1")
Query QueryCatheterInfo(paadm As %String, tTransSubID As %String) As %Query(ROWSPEC = "ind:%String,RepID:%String,rowid:%String,CatDate:%String,CatType:%String,CatTypeDesc:%String,CatPlace:%String,CatPlaceDesc:%String,CatUserType:%String,CatUserTypeDesc:%String,OutCatDate:%String,DeathFlag:%String,OutLocPlace:%String,InfFlag:%String,RepUser:%String,RepUserDesc:%String,RepStatus:%String,RepStatusDesc:%String,FirstDate:%String,InfDate:%String,Pathogenic:%String")
{
}

ClassMethod QueryCatheterInfoExecute(ByRef qHandle As %Binary, paadm As %String, tTransSubID As %String) As %Status
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
	..q:'$d(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID))
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Catheter).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s CatDate=obj.CatDate
	...s:CatDate'="" CatDate=$zd(CatDate,3)
	...s CatType=obj.CatType
	...s CatPlace=obj.CatPlace
	...s CatUserType=obj.CatUserType
	...s OutCatDate=obj.OutCatDate
	...s:OutCatDate'="" OutCatDate=$zd(OutCatDate,3)
	...s DeathFlag=obj.DeathFlag
	...s OutLocPlace=obj.OutLocPlace
	...s InfFlag=obj.InfFlag
	...s RepUser=obj.RepUser
	...s RepStatus=obj.RepStatus
	...q:RepStatus=0
	...s FirstDate=obj.FirstDate
	...s:FirstDate'="" FirstDate=$zd(FirstDate,3)
	...s InfDate=obj.InfDate
	...s:InfDate'="" InfDate=$zd(InfDate,3)
	...s Pathogenic=obj.Pathogenic
	
	...s (CatTypeDesc,CatPlaceDesc,CatUserTypeDesc,RepUserDesc,RepStatusDesc)=""
	...s (CatTypeDR,CatPlaceDR,CatUserTypeDR,RepStatusDR)=""
	
	...s:CatType'="" CatTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CatType,"CatType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CatTypeDR)
    ...s:$IsObject(objDic) CatTypeDesc=objDic.Description
    
    ...s:CatPlace'="" CatPlaceDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CatPlace,"CatPlace")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CatPlaceDR)
    ...s:$IsObject(objDic) CatPlaceDesc=objDic.Description
    
    ...s:CatUserType'="" CatUserTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CatUserType,"CatUserType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CatUserTypeDR)
    ...s:$IsObject(objDic) CatUserTypeDesc=objDic.Description
    ...i RepUser'="" d
    ....q:'$d(^SSU("SSUSR",RepUser))
    ....s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ...s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ...s:$IsObject(objDic) RepStatusDesc=objDic.Description
    
	...s Data=$lb(ind,RepID,rowid,CatDate,CatType,CatTypeDesc,CatPlace,CatPlaceDesc,CatUserType,CatUserTypeDesc,OutCatDate,DeathFlag,OutLocPlace,InfFlag,RepUser,RepUserDesc,RepStatus,RepStatusDesc,FirstDate,InfDate,Pathogenic)
 	...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryCatheterInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCatheterInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCatheterInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCatheterInfoExecute ]
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

/// 保存 尿管相关报告表 信息
/// w ##class(DHCMed.InfAimService.CatheterSrv).SaveCatheterInfo("")
ClassMethod SaveCatheterInfo(str As %String) As %String
{
	n (str)
	s ret=-1,tmp=0
	q:str="" ret
	s paadm=$p(str,"^",1)
	s TransSubID=$p(str,"^",2)
	s CatheterID=$p(str,"^",3)
	s CatDate=$p(str,"^",4)
	s:CatDate["-" CatDate=$zdh(CatDate,3)
	s CatType=$p(str,"^",5)
	s CatPlace=$p(str,"^",6)
	s CatUserType=$p(str,"^",7)
	s OutCatDate=$P(str,"^",8)
	s:OutCatDate["-" OutCatDate=$zdh(OutCatDate,3)
	s DeathFlag=$p(str,"^",9)
	s OutLocPlace=$p(str,"^",10)
	s InfFlag=$p(str,"^",11)
	s RepUser=$p(str,"^",12)
	s RepStatus=$p(str,"^",13)
	s FirstDate=$p(str,"^",14)
	s:FirstDate["-" FirstDate=$zdh(FirstDate,3)
	s:FirstDate="" FirstDate=+$h
	s InfDate=$p(str,"^",15)
	s:InfDate["-" InfDate=$zdh(InfDate,3)
	s Pathogenic=$p(str,"^",16)
	q:+paadm=0 ret
	q:+TransSubID=0 ret
	
	set $ZT="Error"
	TStart
	
	s ReportID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,""),-1)
	i '$d(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) d
	.s ReportID=##class(DHCMed.InfAim.Report).Update("^"_+paadm_"^"_+TransSubID)
	
	i ReportID<0  TRollback
	s CatInfo=CatheterID_"^"_ReportID_"^"_CatDate_"^"_CatType_"^"_CatPlace_"^"_CatUserType_"^"_OutCatDate
	s CatInfo=CatInfo_"^"_DeathFlag_"^"_OutLocPlace_"^"_InfFlag_"^"_RepUser_"^"_RepStatus_"^"_FirstDate_"^"_InfDate_"^"_Pathogenic
	s CatheterID=##class(DHCMed.InfAim.Catheter).Update(CatInfo)
	i CatheterID<0 TRollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// w ##class(DHCMed.InfAimService.CatheterSrv).DeleteRep(1)
ClassMethod DeleteRep(RepID As %String) As %String
{
	n (RepID)	
	
	s ret=-1
	q:RepID="" ret
	q:'$d(^DHCMed.InfAim.CatheterD(RepID)) ret
	&sql(update  DHCMed_InfAim.Catheter set RepStatus=0  where ID=:RepID)
	
	s:'SQLCODE ret=1
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2011-10-29
/// Description:  查询尿管相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.CatheterSrv","QueryCatheterByDateLoc","","","")
Query QueryCatheterByDateLoc(DateFrom As %String, DateTo As %String, LocID As %String, DateType As %String) As %Query(ROWSPEC = "ind:%String,PatientName:%String,InPatMrNo:%String,Sex:%String,Age:%String,CatDate:%String,CatTypeDesc:%String,CatPlaceDesc:%String,CatUserTypeDesc:%String,OutCatDate:%String,DeathFlagDesc:%String,InICUDay:%String,OutLocPlace:%String,InfFlagDesc:%String,InfDate:%String:%String,Pathogenic:%String")
{
}

ClassMethod QueryCatheterByDateLocExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, LocID As %String, DateType As %String) As %Status
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
	.q:'$d(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID)) //不存在尿管报告
	.s rowid=0
	.f  s rowid=$o(^DHCMed.InfAim.CatheterI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.InfAim.Catheter).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s CatDate=obj.CatDate
	..s CatType=obj.CatType
	..s CatPlace=obj.CatPlace
	..s CatUserType=obj.CatUserType
	..s OutCatDate=obj.OutCatDate
	
	..s DeathFlag=obj.DeathFlag
	..s OutLocPlace="" //obj.OutLocPlace
	..s InfFlag=obj.InfFlag
	..s RepUser=obj.RepUser
	..s RepStatus=obj.RepStatus
	..s FirstDate=obj.FirstDate
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
	..q:(LocID'="")&(LocID'=DepartmentID)
	
	..s:AdmitDate["-" AdmitDate=$zdh(AdmitDate,3)
	..s:DisDate["-" DisDate=$zdh(DisDate,3)
	..q:(DateType=1)&((DateFrom>CatDate)||(DateTo<CatDate))			//按置管日期查询
	..q:(DateType=2)&((DateFrom>OutCatDate)||(DateTo<OutCatDate))	//按拔管日期查询
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
	..i (CatDate'="")&(OutCatDate'="") d
	...s InICUDay=OutCatDate+1-CatDate
	..e  i (CatDate'="")&(DisDate'="") d
	...s InICUDay=DisDate+1-CatDate	//拔管日期为空，用出院日期代替拔管日期
	
	..s:CatDate'="" CatDate=$zd(CatDate,3)
	..s:OutCatDate'="" OutCatDate=$zd(OutCatDate,3)
	
	..s (CatTypeDesc,CatPlaceDesc,CatUserTypeDesc,RepUserDesc,RepStatusDesc)=""
	..s (CatTypeDR,CatPlaceDR,CatUserTypeDR,RepStatusDR)=""
	
	..s DeathFlagDesc="否"
	..s:DeathFlag=1 DeathFlagDesc="是"
	
	..s InfFlagDesc="否"
	..s:InfFlag=1 InfFlagDesc="是"
	
	..s:CatType'="" CatTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CatType,"CatType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CatTypeDR)
    ..s:$IsObject(objDic) CatTypeDesc=objDic.Description
    
    ..s:CatPlace'="" CatPlaceDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CatPlace,"CatPlace")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CatPlaceDR)
    ..s:$IsObject(objDic) CatPlaceDesc=objDic.Description
    
    ..s:CatUserType'="" CatUserTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CatUserType,"CatUserType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CatUserTypeDR)
    ..s:$IsObject(objDic) CatUserTypeDesc=objDic.Description
    ..i RepUser'="" d
    ...q:'$d(^SSU("SSUSR",RepUser))
    ...s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ..s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ..s:$IsObject(objDic) RepStatusDesc=objDic.Description
	
	..s Data=$lb(ind,PatientName,InPatMrNo,Sex,Age,CatDate,CatTypeDesc,CatPlaceDesc,CatUserTypeDesc,OutCatDate,DeathFlagDesc,InICUDay,OutLocPlace,InfFlagDesc,InfDate,Pathogenic)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryCatheterByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCatheterByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCatheterByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCatheterByDateLocExecute ]
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

/// w ##Class(DHCMed.InfAimService.CatheterSrv).GetCatheterByDateLoc("fillxlSheet","^^^^")
ClassMethod GetCatheterByDateLoc(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)
	s DateType =$p(strArguments,"^",4)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.InfAimService.CatheterSrv:QueryCatheterByDateLoc")
	d ds.Execute(DateFrom,DateTo,CtlocID,DateType)
	s StartRow=5
	while(ds.Next())
	{
		s PatientName=ds.Data("PatientName")
		s InPatMrNo=ds.Data("InPatMrNo")
		s Sex=ds.Data("Sex")
		s Age=ds.Data("Age")
		s CatDate=ds.Data("CatDate")
		s CatTypeDesc=ds.Data("CatTypeDesc")
		s CatPlaceDesc=ds.Data("CatPlaceDesc")
		s CatUserTypeDesc=ds.Data("CatUserTypeDesc")
		s OutCatDate=ds.Data("OutCatDate")
		s DeathFlagDesc=ds.Data("DeathFlagDesc")
		s InICUDay=ds.Data("InICUDay")
		s OutLocPlace=ds.Data("OutLocPlace")
		s InfFlagDesc=ds.Data("InfFlagDesc")
		s InfDate=ds.Data("InfDate")
		s Pathogenic=ds.Data("Pathogenic")
		s valCells=PatientName_$c(1)_InPatMrNo_$c(1)_Sex_$c(1)_Age_$c(1)_CatDate_$c(1)_CatTypeDesc_$c(1)_CatPlaceDesc_$c(1)_CatUserTypeDesc_$c(1)_OutCatDate_$c(1)_InfFlagDesc_$c(1)_InfDate_$c(1)_OutLocPlace_$c(1)_Pathogenic
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	s valCells="日期："_DateFrom_" 至 "_DateTo
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_2_",1);"
	&javascript<#(retval)#>
	
	
	d ds.Close()
	
	q Count
}

Storage Default
{
<Data name="CatheterSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAimSe718.CatheterSrvD</DataLocation>
<DefaultData>CatheterSrvDefaultData</DefaultData>
<IdLocation>^DHCMed.InfAimSe718.CatheterSrvD</IdLocation>
<IndexLocation>^DHCMed.InfAimSe718.CatheterSrvI</IndexLocation>
<StreamLocation>^DHCMed.InfAimSe718.CatheterSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
