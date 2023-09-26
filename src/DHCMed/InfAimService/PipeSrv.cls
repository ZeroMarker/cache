/// 名称: DHCMed.InfAimService.PipeSrv
/// 描述: 导管相关报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-20
Class DHCMed.InfAimService.PipeSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-10-21
/// Description:  查询导管相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.PipeSrv","QueryPipeInfo","1")
Query QueryPipeInfo(paadm As %String, tTransSubID As %String) As %Query(ROWSPEC = "ind:%String,RepID:%String,rowid:%String,InICUDiag:%String,PipeDate:%String,OutPipeDate:%String,PipePos:%String,PipePosDesc:%String,PipeType:%String,PipeTypeDesc:%String,PipeRegion:%String,PipeRegionDesc:%String,PipeSize:%String,PipeSizeDesc:%String,PipeNum:%String,PipeNumDesc:%String,PipePlace:%String,PipePlaceDesc:%String,OutPipeReason:%String,InfFlag:%String,RepUser:%String,RepUserDesc:%String,RepStatus:%String,RepStatusDesc:%String,FirstDate:%String,InfDate:%String,PipeUser:%String,PipeUserDesc:%String,OutPipeReasonDesc:%String,Pathogenic:%String")
{
}

ClassMethod QueryPipeInfoExecute(ByRef qHandle As %Binary, paadm As %String, tTransSubID As %String) As %Status
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
	..q:'$d(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID))
	..s rowid=0
	..f  s rowid=$o(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID,rowid)) q:rowid=""  d
	...s obj=##class(DHCMed.InfAim.Pipe).GetObjById(rowid)
	...q:'$IsObject(obj)
	...s InICUDiag=obj.InICUDiag
	...s PipeDate=obj.PipeDate
	...s:PipeDate'="" PipeDate=$zd(PipeDate,3)
	...s OutPipeDate=obj.OutPipeDate
	...s:OutPipeDate'="" OutPipeDate=$zd(OutPipeDate,3)
	...s PipePos=obj.PipePos
	...s PipeType=obj.PipeType
	...s PipeRegion=obj.PipeRegion
	...s PipeSize=obj.PipeSize
	...s PipeNum=obj.PipeNum
	...s PipePlace=obj.PipePlace
	...s OutPipeReason=obj.OutPipeReason
	...s InfFlag=obj.InfFlag
	...s RepUser=obj.RepUser
	...s RepStatus=obj.RepStatus
	...q:RepStatus=0
	...s FirstDate=obj.FirstDate
	...s:FirstDate'="" FirstDate=$zd(FirstDate,3)
	...s InfDate=obj.InfDate
	...s:InfDate'="" InfDate=$zd(InfDate,3)
	...s PipeUser=obj.PipeUser
	...s Pathogenic=obj.Pathogenic
	
	...s (PipePosDesc,PipeTypeDesc,PipeRegionDesc,PipeRegionDesc,PipeSizeDesc,PipeNumDesc,PipePlaceDesc,RepUserDesc,PipeUserDesc,OutPipeReasonDesc)=""
	...s (PipePosDR,PipeTypeDR,PipeRegionDR,PipeRegionDR,PipeSizeDR,PipeNumDR,PipePlaceDR,PipeUserDR,OutPipeReasonDR)=""
	
	...s:PipePos'="" PipePosDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipePos,"PipePos")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipePosDR)
    ...s:$IsObject(objDic) PipePosDesc=objDic.Description
    
    ...s:PipeType'="" PipeTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeType,"PipeType")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeTypeDR)
    ...s:$IsObject(objDic) PipeTypeDesc=objDic.Description
    
    ...s:PipeRegion'="" PipeRegionDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeRegion,"PipeRegion")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeRegionDR)
    ...s:$IsObject(objDic) PipeRegionDesc=objDic.Description
    
    ...s:PipeSize'="" PipeSizeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeSize,"PipeSize")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeSizeDR)
    ...s:$IsObject(objDic) PipeSizeDesc=objDic.Description
    
    ...s:PipeNum'="" PipeNumDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeNum,"PipeNum")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeNumDR)
    ...s:$IsObject(objDic) PipeNumDesc=objDic.Description
    
    ...s:PipePlace'="" PipePlaceDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipePlace,"PipePlace")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipePlaceDR)
    ...s:$IsObject(objDic) PipePlaceDesc=objDic.Description
    
    ...i RepUser'="" d
    ....q:'$d(^SSU("SSUSR",RepUser))
    ....s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ...s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ...s:$IsObject(objDic) RepStatusDesc=objDic.Description
    
    ...s:PipeUser'="" PipeUserDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeUser,"PipeUser")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeUserDR)
    ...s:$IsObject(objDic) PipeUserDesc=objDic.Description
    
    ...s:OutPipeReason'="" OutPipeReasonDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OutPipeReason,"OutPipeReason")
    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(OutPipeReasonDR)
    ...s:$IsObject(objDic) OutPipeReasonDesc=objDic.Description
     
	...s Data=$lb(ind,RepID,rowid,InICUDiag,PipeDate,OutPipeDate,PipePos,PipePosDesc,PipeType,PipeTypeDesc,PipeRegion,PipeRegionDesc,PipeSize,PipeSizeDesc,PipeNum,PipeNumDesc,PipePlace,PipePlaceDesc,OutPipeReason,InfFlag,RepUser,RepUserDesc,RepStatus,RepStatusDesc,FirstDate,InfDate,PipeUser,PipeUserDesc,OutPipeReasonDesc,Pathogenic)
 	...s ^CacheTemp(repid,ind)=Data
 	...s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryPipeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPipeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPipeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPipeInfoExecute ]
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

/// 保存 导管相关报告表 信息
/// w ##class(DHCMed.InfAimService.PipeSrv).SavePipeInfo("")
ClassMethod SavePipeInfo(str As %String) As %String
{
	s ret=-1,tmp=0
	//s str=$tr(str,"undefined","")
	q:str="" ret
	s paadm=$p(str,"^",1)
	s TransSubID=$p(str,"^",2)
	s PipeID=$p(str,"^",3)
	s InICUDiag=$p(str,"^",4)
	s PipeDate=$p(str,"^",5)
	s:PipeDate["-" PipeDate=$zdh(PipeDate,3)
	s OutPipeDate=$p(str,"^",6)
	s:OutPipeDate["-" OutPipeDate=$zdh(OutPipeDate,3)
	s PipePos=$p(str,"^",7)
	s PipeType=$p(str,"^",8)
	s PipeRegion=$P(str,"^",9)
	s PipeSize=$p(str,"^",10)
	s PipeNum=$p(str,"^",11)
	s PipePlace=$p(str,"^",12)
	s OutPipeReason=$p(str,"^",13)
	s InfFlag=$p(str,"^",14)
	s RepUser=$p(str,"^",15)
	s RepStatus=$p(str,"^",16)
	s FirstDate=$p(str,"^",17)
	s:FirstDate["-" FirstDate=$zdh(FirstDate,3)
	s:FirstDate="" FirstDate=+$h
	s InfDate=$p(str,"^",18)
	s:InfDate["-" InfDate=$zdh(InfDate,3)
	s PipeUser=$p(str,"^",19)
	s Pathogenic=$p(str,"^",20)
	q:+paadm=0 ret
	q:+TransSubID=0 ret
	
	set $ZT="Error"
	TStart
	
	s ReportID=$o(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID,""),-1)
	i '$d(^DHCMed.InfAim.ReportI("TransSubID",paadm,TransSubID)) d
	.s ReportID=##class(DHCMed.InfAim.Report).Update("^"_+paadm_"^"_+TransSubID)
	
	i ReportID<0  TRollback
	s PipeInfo=PipeID_"^"_ReportID_"^"_InICUDiag_"^"_PipeDate_"^"_OutPipeDate_"^"_PipePos_"^"_PipeType
	s PipeInfo=PipeInfo_"^"_PipeRegion_"^"_PipeSize_"^"_PipeNum_"^"_PipePlace_"^"_OutPipeReason_"^"_InfFlag_"^"_RepUser
	s PipeInfo=PipeInfo_"^"_RepStatus_"^"_FirstDate_"^"_InfDate_"^"_PipeUser_"^"_Pathogenic

	s PipeID=##class(DHCMed.InfAim.Pipe).Update(PipeInfo)
	i PipeID<0 TRollback
	
	TCommit
	set ret=1
	quit ret

Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// w ##class(DHCMed.InfAimService.PipeSrv).DeleteRep(1)
ClassMethod DeleteRep(RepID As %String) As %String
{
	n (RepID)	
	
	s ret=-1
	q:RepID="" ret
	q:'$d(^DHCMed.InfAim.PipeD(RepID)) ret
	&sql(update  DHCMed_InfAim.Pipe set RepStatus=0  where ID=:RepID)
	
	s:'SQLCODE ret=1
	
	q ret
}

/// Creator：     liuyh
/// CreatDate：   2011-10-29
/// Description:  查询置管相关报告表信息
/// d ##class(%ResultSet).RunQuery("DHCMed.InfAimService.PipeSrv","QueryPipeByDateLoc","2011-10-01","2011-10-30","","1")
Query QueryPipeByDateLoc(DateFrom As %String, DateTo As %String, CtLocID As %String, DateType As %String) As %Query(ROWSPEC = "ind:%String,PatientName:%String,InPatMrNo:%String,Sex:%String,Age:%String,InICUDate:%String,OutICUDate:%String,InICUDiag:%String,InICULocDesc:%String,OutICULocDesc:%String,PipeDate:%String,OutPipeDate:%String,PipePos:%String,PipeType:%String,PipeRegion:%String,PipeSize:%String,PipeNum:%String,PipePlace:%String,OutPipeReason:%String,OutPipeReasonDesc:%String,Pathogenic:%String")
{
}

ClassMethod QueryPipeByDateLocExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtLocID As %String, DateType As %String) As %Status
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
	.q:'$d(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID)) //不存在尿管报告
	.s PipeID=0
	.f  s PipeID=$o(^DHCMed.InfAim.PipeI("InfAimRepDR",RepID,PipeID)) q:PipeID=""  d
	..s obj=##class(DHCMed.InfAim.Pipe).GetObjById(PipeID)
	..q:'$IsObject(obj)
	..s InICUDiag=""	//obj.InICUDiag
	..s PipeDate=obj.PipeDate
	..s OutPipeDate=obj.OutPipeDate
	..s PipePos=obj.PipePos
	..s PipeType=obj.PipeType	
	..s PipeRegion=obj.PipeRegion
	..s PipeSize=obj.PipeSize
	..s PipeNum=obj.PipeNum
	..s PipePlace=obj.PipePlace
	..s OutPipeReason=obj.OutPipeReason
	..s InfFlag=obj.InfFlag
	..s RepUser=obj.RepUser
	..s RepStatus=obj.RepStatus
	..s FirstDate=obj.FirstDate
	..q:RepStatus=0	//删除
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
	..q:(DateType=1)&((DateFrom>PipeDate)||(DateTo<PipeDate))		//按置管日期查询
	..q:(DateType=2)&((DateFrom>OutPipeDate)||(DateTo<OutPipeDate))	//按拔管日期查询
	..q:((DateType=3)||(DateType=""))&((DateFrom>FirstDate)||(DateTo<FirstDate))	//按报告日期查询
	
	..s:PipeDate'="" PipeDate=$zd(PipeDate,3)
	..s:OutPipeDate'="" OutPipeDate=$zd(OutPipeDate,3)
	
	..s InICUDiag=##class(EPRmeta.FPInterface.ExportTable).GetItemDataValueV2ForStat(paadm,"#TYPE:Segment#TID:17#TVER:0#GCODE:G0044",1)
	
	..s ret=##class(DHCMed.InfAimService.BaseSrv).GetTranByPaadmSubID(paadm,TransSubID) //获取转入前及转出后的记录
	..q:ret=-1
	..s BeforeSubID=$p(ret,"^",1)
	..s LaterSubID=$p(ret,"^",2)
	..s (OutICUDate,InICULocID,OutICULocID)=""
	..s InICUDate=$p($g(^PAADM(paadm,"TRANS",TransSubID)),"^",1)	//入ICU日期
	..s:LaterSubID'="" OutICUDate=$p($g(^PAADM(paadm,"TRANS",LaterSubID)),"^",1)	//出ICU日期
	..s:BeforeSubID'="" InICULocID=$p($g(^PAADM(paadm,"TRANS",BeforeSubID)),"^",6)	//入ICU科室
	..s:LaterSubID'="" OutICULocID=$p($g(^PAADM(paadm,"TRANS",LaterSubID)),"^",6)	//出ICU科室
	..s:InICUDate'="" InICUDate=$zd(InICUDate,3)
	..s:OutICUDate'="" OutICUDate=$zd(OutICUDate,3)
	..s (InICULocDesc,OutICULocDesc)=""
	..s:InICULocID'="" InICULocDesc=$p($g(^CTLOC(InICULocID)),"^",2)
	..s:OutICULocID'="" OutICULocDesc=$p($g(^CTLOC(OutICULocID)),"^",2)
	..s (PipePosDesc,PipeTypeDesc,PipeRegionDesc,PipeRegionDesc,PipeSizeDesc,PipeNumDesc,PipePlaceDesc,RepUserDesc,OutPipeReasonDesc)=""
	..s (PipePosDR,PipeTypeDR,PipeRegionDR,PipeRegionDR,PipeSizeDR,PipeNumDR,PipePlaceDR,OutPipeReasonDR)=""
	
	..s:PipePos'="" PipePosDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipePos,"PipePos")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipePosDR)
    ..s:$IsObject(objDic) PipePosDesc=objDic.Description
    
    ..s:OutPipeReason'="" OutPipeReasonDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(OutPipeReason,"OutPipeReason")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(OutPipeReasonDR)
    ..s:$IsObject(objDic) OutPipeReasonDesc=objDic.Description
    
    ..s:PipeType'="" PipeTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeType,"PipeType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeTypeDR)
    ..s:$IsObject(objDic) PipeTypeDesc=objDic.Description
    
    ..s:PipeRegion'="" PipeRegionDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeRegion,"PipeRegion")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeRegionDR)
    ..s:$IsObject(objDic) PipeRegionDesc=objDic.Description
    
    ..s:PipeSize'="" PipeSizeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeSize,"PipeSize")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeSizeDR)
    ..s:$IsObject(objDic) PipeSizeDesc=objDic.Description
    
    ..s:PipeNum'="" PipeNumDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipeNum,"PipeNum")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipeNumDR)
    ..s:$IsObject(objDic) PipeNumDesc=objDic.Description
    
    ..s:PipePlace'="" PipePlaceDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(PipePlace,"PipePlace")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(PipePlaceDR)
    ..s:$IsObject(objDic) PipePlaceDesc=objDic.Description
    
    ..i RepUser'="" d
    ...q:'$d(^SSU("SSUSR",RepUser))
    ...s RepUserDesc=$p(^SSU("SSUSR",RepUser),"^",2) 
   
    ..s:RepStatus'="" RepStatusDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"RepStatus")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusDR)
    ..s:$IsObject(objDic) RepStatusDesc=objDic.Description
	
	..s Data=$lb(ind,PatientName,InPatMrNo,Sex,Age,InICUDate,OutICUDate,InICUDiag,InICULocDesc,OutICULocDesc,PipeDate,OutPipeDate,PipePosDesc,PipeTypeDesc,PipeRegionDesc,PipeSizeDesc,PipeNumDesc,PipePlaceDesc,OutPipeReason,OutPipeReasonDesc,Pathogenic)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryPipeByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPipeByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPipeByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPipeByDateLocExecute ]
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

/// w ##Class(DHCMed.InfAimService.PipeSrv).GetPipeByDateLoc("fillxlSheet","2011-11-01^2011-12-01^^^")
ClassMethod GetPipeByDateLoc(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 s ^LYH=strArguments
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)
	s DateType =$p(strArguments,"^",4)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.InfAimService.PipeSrv:QueryPipeByDateLoc")
	d ds.Execute(DateFrom,DateTo,CtlocID,DateType)
	s StartRow=4
	while(ds.Next())
	{
		s PatientName=ds.Data("PatientName")
		s InPatMrNo=ds.Data("InPatMrNo")
		s Sex=ds.Data("Sex")
		s Age=ds.Data("Age")
		s InICUDate=ds.Data("InICUDate")
		s OutICUDate=ds.Data("OutICUDate")
		s InICUDiag=ds.Data("InICUDiag")
		s InICULocDesc=ds.Data("InICULocDesc")
		s OutICULocDesc=ds.Data("OutICULocDesc")
		s PipeDate=ds.Data("PipeDate")
		s OutPipeDate=ds.Data("OutPipeDate")
		s PipePosDesc=ds.Data("PipePos")
		s PipeTypeDesc=ds.Data("PipeType")
		s PipeRegionDesc=ds.Data("PipeRegion")
		s PipeSizeDesc=ds.Data("PipeSize")
		s PipeNumDesc=ds.Data("PipeNum")
		s PipePlaceDesc=ds.Data("PipePlace")
		s OutPipeReason=ds.Data("OutPipeReasonDesc")
		s Pathogenic=ds.Data("Pathogenic")
		s valCells=PatientName_$c(1)_InPatMrNo_$c(1)_Sex_$c(1)_Age_$c(1)_InICUDate_$c(1)_OutICUDate_$c(1)_InICUDiag_$c(1)_InICULocDesc_$c(1)_OutICULocDesc_$c(1)_PipeDate_$c(1)_OutPipeDate_$c(1)_PipePosDesc_$c(1)_PipeTypeDesc_$c(1)_PipeRegionDesc_$c(1)_PipeSizeDesc_$c(1)_PipeNumDesc_$c(1)_PipePlaceDesc_$c(1)_OutPipeReason
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	
	s valCells=DateFrom_" 至 "_DateTo
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_1_",13);"
	&javascript<#(retval)#>
	
	
	d ds.Close()
	
	q Count
}

}
