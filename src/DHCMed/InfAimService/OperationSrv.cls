/// 名称: DHCMed.InfAimService.OperationSrv
/// 描述: 手术相关报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-25
Class DHCMed.InfAimService.OperationSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-10-25
/// Description:  查询手术相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.OperationSrv","QueryOperationInfo","1")
Query QueryOperationInfo(paadm As %String, tTransSubID As %String) As %Query(ROWSPEC = "ind:%String,RepID:%String,rowid:%String,OpeDate:%String,OpeName:%String,OpeLastTime:%String,CutType:%String,CutTypeDesc:%String,ASAScore:%String,EmerOprFlag:%String,EmerOprFlagDesc:%String,Injury:%String,InjuryDesc:%String,Endoscopic:%String,EndoscopicDesc:%String,FirstOpe:%String,FirstOpeDesc:%String,AssistantDr1:%String,AssistantDr1Desc:%String,NarcosisDrug1:%String,NarcosisNum1:%String,NarcosisDrug2:%String,NarcosisNum2:%String,AftDrug1:%String,AftNum1:%String,AftDays1:%String,AftDrug2:%String,AftNum2:%String,AftDays2:%String,InfFlag:%String,Pathogenic:%String,RepUser:%String,RepUserDesc:%String,RepStatus:%String,RepStatusDesc:%String,FirstDate:%String,InfDate:%String,NarcosisDrug:%String,AftDrug:%String,NarcosisDrugDesc:%String,AftDrugDesc:%String,NarcosisType:%String,NarcosisTypeDesc:%String,OpeInfType:%String,OpeInfTypeDesc:%String,ResumeText:%String")
{
}

ClassMethod QueryOperationInfoExecute(ByRef qHandle As %Binary, paadm As %String, tTransSubID As %String) As %Status
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
	..q:'$d(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID))
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Operation).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s OpeDate=obj.OpeDate
	...s:OpeDate'="" OpeDate=$zd(OpeDate,3)
	...s OpeName=obj.OpeName
	...s OpeLastTime=obj.OpeLastTime
	...s CutType=obj.CutType
	...s ASAScore=obj.ASAScore
	...s EmerOprFlag=obj.EmerOprFlag
	...s Injury=obj.Injury
	...s Endoscopic=obj.Endoscopic
	...s FirstOpe=obj.FirstOpe
	...s AssistantDr1=obj.AssistantDr1
	...s NarcosisDrug1=obj.NarcosisDrug1
	...s NarcosisNum1=obj.NarcosisNum1
	...s NarcosisDrug2=obj.NarcosisDrug2
	...s NarcosisNum2=obj.NarcosisNum2
	...s AftDrug1=obj.AftDrug1
	...s AftNum1=obj.AftNum1
	...s AftDays1=obj.AftDays1
	...s AftDrug2=obj.AftDrug2
	...s AftNum2=obj.AftNum2
	...s AftDays2=obj.AftDays2	
	...s InfFlag=obj.InfFlag
	...s Pathogenic=obj.Pathogenic
	...s RepUser=obj.RepUser
	...s RepStatus=obj.RepStatus
	...q:RepStatus=0
	...s FirstDate=obj.FirstDate
	...s:FirstDate'="" FirstDate=$zd(FirstDate,3)
	...s InfDate=obj.InfDate
	...s:InfDate'="" InfDate=$zd(InfDate,3)
	...s NarcosisDrug=obj.NarcosisDrug
	...s AftDrug=obj.AftDrug
	...s NarcosisType=obj.NarcosisType
	...s OpeInfType=obj.OpeInfType
	...s ResumeText=obj.ResumeText
	
	...s (CutTypeDesc,EmerOprFlagDesc,InjuryDesc,EndoscopicDesc,RepUserDesc,RepStatusDesc,FirstOpeDesc,AssistantDr1Desc,NarcosisDrugDesc,AftDrugDesc,NarcosisTypeDesc,OpeInfTypeDesc)=""
	...s (CutTypeDR,EmerOprFlagDR,InjuryDR,EndoscopicDR,RepStatusDR,NarcosisDrugDR,AftDrugDR,NarcosisTypeDR,OpeInfTypeDR)=""
	
	
	...s:NarcosisType'="" NarcosisTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(NarcosisType,"NarcosisType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(NarcosisTypeDR)
    ...s:$IsObject(objDic) NarcosisTypeDesc=objDic.Description
    
    ...s:OpeInfType'="" OpeInfTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OpeInfType,"OpeInfType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(OpeInfTypeDR)
    ...s:$IsObject(objDic) OpeInfTypeDesc=objDic.Description
    
	...s:CutType'="" CutTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CutType,"CutType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CutTypeDR)
    ...s:$IsObject(objDic) CutTypeDesc=objDic.Description
    
    ...s:EmerOprFlag'="" EmerOprFlagDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EmerOprFlag,"YesNo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(EmerOprFlagDR)
    ...s:$IsObject(objDic) EmerOprFlagDesc=objDic.Description
    
    ...s:Injury'="" InjuryDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Injury,"YesNo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(InjuryDR)
    ...s:$IsObject(objDic) InjuryDesc=objDic.Description
   
    ...s:Endoscopic'="" EndoscopicDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Endoscopic,"YesNo")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(EndoscopicDR)
    ...s:$IsObject(objDic) EndoscopicDesc=objDic.Description
   
   	...i FirstOpe'="" d
    ....q:'$d(^SSU("SSUSR",FirstOpe))
    ....s FirstOpeDesc=$p(^SSU("SSUSR",FirstOpe),"^",2) 
      
    ...i AssistantDr1'="" d
    ....q:'$d(^SSU("SSUSR",AssistantDr1))
    ....s AssistantDr1Desc=$p(^SSU("SSUSR",AssistantDr1),"^",2) 
    
    ...i RepUser'="" d
    ....q:'$d(^SSU("SSUSR",RepUser))
    ....s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ...s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ...s:$IsObject(objDic) RepStatusDesc=objDic.Description
    
	...i NarcosisDrug'="" d
	....s LenNarc=$l(NarcosisDrug,$c(1))
	....f i=1:1:LenNarc  d
	.....s ARCIMID=$p(NarcosisDrug,$c(1),i)
	.....q:ARCIMID=""
	.....s desc=##class(DHCMed.InfAimService.BaseSrv).GetOrdItemInfoByPaadmARCIM(paadm,ARCIMID)
	.....q:desc=""
	.....s:NarcosisDrugDesc'="" NarcosisDrugDesc=NarcosisDrugDesc_"^"_desc
	.....s:NarcosisDrugDesc="" NarcosisDrugDesc=desc
	
	...i AftDrug'="" d
	....s LenNarc=$l(AftDrug,$c(1))
	....f i=1:1:LenNarc  d
	.....s ARCIMID=$p(AftDrug,$c(1),i)
	.....q:ARCIMID=""
	.....s desc=##class(DHCMed.InfAimService.BaseSrv).GetOrdItemInfoByPaadmARCIM(paadm,ARCIMID)
	.....q:desc=""
	.....s:AftDrugDesc'="" AftDrugDesc=AftDrugDesc_"^"_desc
	.....s:AftDrugDesc="" AftDrugDesc=desc
	
	...s Data=$lb(ind,RepID,rowid,OpeDate,OpeName,OpeLastTime,CutType,CutTypeDesc,ASAScore,EmerOprFlag,EmerOprFlagDesc,Injury,InjuryDesc,Endoscopic,EndoscopicDesc,FirstOpe,FirstOpeDesc,AssistantDr1,AssistantDr1Desc,NarcosisDrug1,NarcosisNum1,NarcosisDrug2,NarcosisNum2,AftDrug1,AftNum1,AftDays1,AftDrug2,AftNum2,AftDays2,InfFlag,Pathogenic,RepUser,RepUserDesc,RepStatus,RepStatusDesc,FirstDate,InfDate,NarcosisDrug,AftDrug,NarcosisDrugDesc,AftDrugDesc,NarcosisType,NarcosisTypeDesc,OpeInfType,OpeInfTypeDesc,ResumeText)
 	...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryOperationInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOperationInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOperationInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOperationInfoExecute ]
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

/// 保存 手术相关报告表 信息
/// w ##class(DHCMed.InfAimService.OperationSrv).SaveOperationInfo("")
ClassMethod SaveOperationInfo(str As %String) As %String
{
	n (str)
	s ret=-1,tmp=0
	q:str="" ret
	s paadm=$p(str,"^",1)
	s TransSubID=$p(str,"^",2)
	s OperationID=$p(str,"^",3)
	s OpeDate=$p(str,"^",4)
	s:OpeDate["-" OpeDate=$zdh(OpeDate,3)
	s OpeName=$p(str,"^",5)
	s OpeLastTime=$p(str,"^",6)
	s CutType=$p(str,"^",7)
	s ASAScore=$P(str,"^",8)
	s EmerOprFlag=$p(str,"^",9)
	s Injury=$p(str,"^",10)
	s Endoscopic=$p(str,"^",11)
	s FirstOpe=$p(str,"^",12)
	s AssistantDr1=$p(str,"^",13)
	s NarcosisDrug1=$p(str,"^",14)
	s NarcosisNum1=$p(str,"^",15)
	s NarcosisDrug2=$P(str,"^",16)
	s NarcosisNum2=$p(str,"^",17)
	s AftDrug1=$p(str,"^",18)
	s AftNum1=$p(str,"^",19)
	s AftDays1=$p(str,"^",20)
	s AftDrug2=$p(str,"^",21)
	s AftNum2=$p(str,"^",22)
	s AftDays2=$p(str,"^",23)
	s InfFlag=$p(str,"^",24)
	s Pathogenic=$p(str,"^",25)
	s RepUser=$p(str,"^",26)
	s RepStatus=$p(str,"^",27)
	s FirstDate=$p(str,"^",28)
	s:FirstDate="" FirstDate=+$h
	s:FirstDate["-" FirstDate=$zdh(FirstDate,3)	
	s InfDate=$p(str,"^",29)
	s:InfDate'="" InfDate=$zdh(InfDate,3)
	s NarcosisDrug=$p(str,"^",30)
	s AftDrug=$p(str,"^",31)
	s NarcosisType=$p(str,"^",32)
	s OpeInfType=$p(str,"^",33)
	s ResumeText=$p(str,"^",34)
	q:+paadm=0 ret
	q:+TransSubID=0 ret
	
	set $ZT="Error"
	TStart
	
	s ReportID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,""),-1)
	i '$d(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) d
	.s ReportID=##class(DHCMed.InfAim.Report).Update("^"_+paadm_"^"_+TransSubID)
	
	i ReportID<0  TRollback
	s CatInfo=OperationID_"^"_ReportID_"^"_OpeDate_"^"_OpeName_"^"_OpeLastTime_"^"_CutType_"^"_ASAScore
	s CatInfo=CatInfo_"^"_EmerOprFlag_"^"_Injury_"^"_Endoscopic_"^"_FirstOpe_"^"_AssistantDr1_"^"_NarcosisDrug1
	s CatInfo=CatInfo_"^"_NarcosisNum1_"^"_NarcosisDrug2_"^"_NarcosisNum2_"^"_AftDrug1_"^"_AftNum1_"^"_AftDays1
	s CatInfo=CatInfo_"^"_AftDrug2_"^"_AftNum2_"^"_AftDays2_"^"_InfFlag_"^"_Pathogenic_"^"_RepUser_"^"_RepStatus_"^"_FirstDate
	s CatInfo=CatInfo_"^"_InfDate_"^"_NarcosisDrug_"^"_AftDrug_"^"_NarcosisType_"^"_OpeInfType_"^"_ResumeText
	s OperationID=##class(DHCMed.InfAim.Operation).Update(CatInfo)
	i OperationID<0 TRollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// w ##class(DHCMed.InfAimService.OperationSrv).DeleteRep(1)
ClassMethod DeleteRep(RepID As %String) As %String
{
	n (RepID)	
	
	s ret=-1
	q:RepID="" ret
	q:'$d(^DHCMed.InfAim.OperationD(RepID)) ret
	&sql(update  DHCMed_InfAim.Operation set RepStatus=0  where ID=:RepID)
	
	s:'SQLCODE ret=1
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2011-10-31
/// Description:  查询手术相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.OperationSrv","QueryOperationByDateLoc","2011-10-01","2011-10-31","",1)
Query QueryOperationByDateLoc(DateFrom As %String, DateTo As %String, LocID As %String, DateType As %String) As %Query(ROWSPEC = "ind:%String,AdmitDate:%String,PatientName:%String,InPatMrNo:%String,Age:%String,Sex:%String,OpeDate:%String,OpeName:%String,OpeLastTime:%String,CutType:%String,ASAScore:%String,EmerOprFlag:%String,Injury:%String,Endoscopic:%String,FirstOpe:%String,AssistantDr1:%String,NarcosisDrug1:%String,NarcosisNum1:%String,NarcosisDrug2:%String,NarcosisNum2:%String,AftDrug1:%String,AftNum1:%String,AftDays1:%String,AftDrug2:%String,AftNum2:%String,AftDays2:%String,InfFlag:%String,Pathogenic:%String,RepUser:%String,RepStatus:%String,FirstDate:%String,AssistantDr1Desc:%String,InfDate:%String,ResumeText:%String")
{
}

ClassMethod QueryOperationByDateLocExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, LocID As %String, DateType As %String) As %Status
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
	.q:'$d(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID)) //不存在尿管报告
	.s rowid=0
	.f  s rowid=$o(^DHCMed.InfAim.OperationI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.InfAim.Operation).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s OpeDate=obj.OpeDate
	..s:OpeDate'="" OpeDate=$zd(OpeDate,3)
	..s OpeName=obj.OpeName
	..s OpeLastTime=obj.OpeLastTime
	..s CutType=obj.CutType
	..s ASAScore=obj.ASAScore
	..s EmerOprFlag=obj.EmerOprFlag
	..s Injury=obj.Injury
	..s Endoscopic=obj.Endoscopic
	..s FirstOpe=obj.FirstOpe
	..s AssistantDr1=obj.AssistantDr1
	..s NarcosisDrug1=obj.NarcosisDrug1	
	..s NarcosisNum1=obj.NarcosisNum1
	..s NarcosisDrug2=obj.NarcosisDrug2
	..s NarcosisNum2=obj.NarcosisNum2
	..s AftDrug1=obj.AftDrug1
	..s AftNum1=obj.AftNum1	
	..s AftDays1=obj.AftDays1
	..s AftDrug2=obj.AftDrug2
	..s AftNum2=obj.AftNum2
	..s AftDays2=obj.AftDays2
	..s InfFlag=obj.InfFlag	
	..s Pathogenic=obj.Pathogenic	
	..s RepUser=obj.RepUser
	..s RepStatus=obj.RepStatus
	..s FirstDate=obj.FirstDate
	..q:RepStatus=0	//删除
	..s InfDate=obj.InfDate
	..s:InfDate'="" InfDate=$zd(InfDate,3)	
	..s ResumeText=obj.ResumeText
	
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
	..q:(DateType=1)&((DateFrom>FirstDate)||(DateTo<FirstDate))	//按报告日期查询
	..q:(DateType=2)&((DateFrom>DisDate)||(DateTo<DisDate))	//按出院日期查询
	..q:((DateType=3)||(DateType=""))&((DateFrom>AdmitDate)||(DateTo<AdmitDate))	//按就诊日期查询

	..s (CutTypeDesc,EmerOprFlagDesc,InjuryDesc,EndoscopicDesc,RepUserDesc,RepStatusDesc,FirstOpeDesc,AssistantDr1Desc)=""
	..s (CutTypeDR,EmerOprFlagDR,InjuryDR,EndoscopicDR,RepStatusDR)=""
	
	
	..s:CutType'="" CutTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CutType,"CutType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CutTypeDR)
    ..s:$IsObject(objDic) CutTypeDesc=objDic.Description
    
    ..s:EmerOprFlag'="" EmerOprFlagDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EmerOprFlag,"YesNo")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(EmerOprFlagDR)
    ..s:$IsObject(objDic) EmerOprFlagDesc=objDic.Description
    
    ..s:Injury'="" InjuryDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Injury,"YesNo")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(InjuryDR)
    ..s:$IsObject(objDic) InjuryDesc=objDic.Description
   
    ..s:Endoscopic'="" EndoscopicDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Endoscopic,"YesNo")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(EndoscopicDR)
    ..s:$IsObject(objDic) EndoscopicDesc=objDic.Description
   	..i FirstOpe'="" d
    ...q:'$d(^SSU("SSUSR",FirstOpe))
    ...s FirstOpeDesc=$p(^SSU("SSUSR",FirstOpe),"^",2) 
      
    ..i AssistantDr1'="" d
    ...q:'$d(^SSU("SSUSR",AssistantDr1))
    ...s AssistantDr1Desc=$p(^SSU("SSUSR",AssistantDr1),"^",2) 
    
    ..s InfFlagDesc="否"
	..s:InfFlag=1 InfFlagDesc="是"
	
    ..i RepUser'="" d
    ...q:'$d(^SSU("SSUSR",RepUser))
    ...s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ..s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ..s:$IsObject(objDic) RepStatusDesc=objDic.Description
    
	..s Data=$lb(ind,AdmitDate,PatientName,InPatMrNo,Age,Sex,OpeDate,OpeName,OpeLastTime,CutTypeDesc,ASAScore,EmerOprFlagDesc,InjuryDesc,EndoscopicDesc,FirstOpeDesc,AssistantDr1,NarcosisDrug1,NarcosisNum1,NarcosisDrug2,NarcosisNum2,AftDrug1,AftNum1,AftDays1,AftDrug2,AftNum2,AftDays2,InfFlagDesc,Pathogenic,RepUserDesc,RepStatusDesc,FirstDate,AssistantDr1Desc,InfDate,ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryOperationByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOperationByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOperationByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOperationByDateLocExecute ]
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

/// w ##Class(DHCMed.InfAimService.OperationSrv).GetOperationByDateLoc("fillxlSheet","^^^^")
ClassMethod GetOperationByDateLoc(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)
	s DateType =$p(strArguments,"^",4)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.InfAimService.OperationSrv:QueryOperationByDateLoc")
	d ds.Execute(DateFrom,DateTo,CtlocID,DateType)
	s StartRow=4
	while(ds.Next())
	{
		s AdmitDate=ds.Data("AdmitDate")
		s PatientName=ds.Data("PatientName")
		s InPatMrNo=ds.Data("InPatMrNo")
		s Age=ds.Data("Age")
		s Sex=ds.Data("Sex")
		s OpeDate=ds.Data("OpeDate")
		s OpeName=ds.Data("OpeName")
		s OpeLastTime=ds.Data("OpeLastTime")
		s CutType=ds.Data("CutType")
		s ASAScore=ds.Data("ASAScore")
		s EmerOprFlag=ds.Data("EmerOprFlag")
		s Injury=ds.Data("Injury")
		s Endoscopic=ds.Data("Endoscopic")
		s FirstOpe=ds.Data("FirstOpe")
		s AssistantDr1=ds.Data("AssistantDr1")
		s NarcosisDrug1=ds.Data("NarcosisDrug1")
		s NarcosisNum1=ds.Data("NarcosisNum1")
		s NarcosisDrug2=ds.Data("NarcosisDrug2")
		s NarcosisNum2=ds.Data("NarcosisNum2")
		s AftDrug1=ds.Data("AftDrug1")
		s AftNum1=ds.Data("AftNum1")
		s AftDays1=ds.Data("AftDays1")
		s AftDrug2=ds.Data("AftDrug2")
		s AftNum2=ds.Data("AftNum2")
		s AftDays2=ds.Data("AftDays2")
		s InfFlag=ds.Data("InfFlag")
		s Pathogenic=ds.Data("Pathogenic")
		
		s valCells=AdmitDate_$c(1)_PatientName_$c(1)_InPatMrNo_$c(1)_Age_$c(1)_Sex_$c(1)_OpeDate
		_$c(1)_OpeName_$c(1)_OpeLastTime_$c(1)_CutType_$c(1)_ASAScore_$c(1)_EmerOprFlag_$c(1)_Injury
	 	_$c(1)_Endoscopic_$c(1)_FirstOpe_$c(1)_AssistantDr1_$c(1)_NarcosisDrug1_$c(1)_NarcosisNum1_$c(1)_NarcosisDrug2
	 	_$c(1)_NarcosisNum2_$c(1)_AftDrug1_$c(1)_AftNum1_$c(1)_AftDays1_$c(1)_AftDrug2_$c(1)_AftNum2
	 	_$c(1)_AftDays2_$c(1)_InfFlag_$c(1)_Pathogenic
	 	
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	s valCells="日期："_DateFrom_" 至 "_DateTo
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_1_",1);"
	&javascript<#(retval)#>
	
	
	d ds.Close()
	
	q Count
}

}
