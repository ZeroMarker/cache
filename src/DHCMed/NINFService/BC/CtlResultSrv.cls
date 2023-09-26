/// 名称:DHCMed.NINFService.BC.CtlResultSrv
/// 描述: 
/// 编写者：zhufei
/// 编写日期: 2013-12-06
Class DHCMed.NINFService.BC.CtlResultSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  就诊号取监控列表数据
/// Return:       $lb() 或 ""
ClassMethod BuildData(argPaadm As %String, aAdmLocID As %String = "") As %List
{
	New (argPaadm,aAdmLocID)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="BuildDataErr"
	Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,PersonalID,EncryptLevel,PatLevel)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc,AdmWard,AdmRoom,AdmBed,AdmDoc,AdmDays)=""

	Set objPaadm=##Class(User.PAAdm).%OpenId(argPaadm)
	Quit:'$IsObject(objPaadm) return
	Do objPaadm.%Close()
    If $IsObject(objPaadm.PAADMPAPMIDR)
    {
	    Set objPatient=objPaadm.PAADMPAPMIDR
	    Set PatientID=objPatient.%Id()
	    //Set PapmiNo=objPatient.PAPMINo
	    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	    Set PatName=objPatient.PAPMIName
	    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
	    Set Birthday=objPatient.PAPMIDOB
	    //update by zf 20150228 统一调用年龄计算方法
	    Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,argPaadm,"","")	//返回“*岁*月*天”
	    ;Set:Birthday'="" Birthday=$zd(Birthday,3)
	    Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	    Set PersonalID=objPatient.PAPMIID
	}
	
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
    //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(argPaadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
    //Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(argPaadm)
	Set DisDate=$p(DischDateTime,"^",1)
	Set DisTime=$p(DischDateTime,"^",2)
    If DisDate'="" {
	    Set AdmDays=DisDate-AdmitDate
    } Else {
		Set AdmDays=+$h-AdmitDate
	}
    ;Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
    Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
    ;Set:DisDate'="" DisDate=$zd(DisDate,3)
    Set:DisDate'="" DisDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DisDate)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
    If $IsObject(objPaadm.PAADMDepCodeDR)
    {
	    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
	    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	}
	If aAdmLocID'="" { // add by zhoubo 2014-12-24
   		set AdmLoc=$p($g(^CTLOC(+aAdmLocID)),"^",2)
		set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
    }
    If $IsObject(objPaadm.PAADMCurrentWardDR)
    {
	    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
	    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	}
	If $IsObject(objPaadm.PAADMCurrentRoomDR)
	{
		Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
	}
	If $IsObject(objPaadm.PAADMCurrentBedDR)
	{
		Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
	}
	If $IsObject(objPaadm.PAADMAdmDocCodeDR)
	{
		Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
	}
	
	Set AdmInfo=$g(^PAADM(argPaadm))
	Set AdmType=$p(AdmInfo,"^",2)
	Set AdmType=$s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",1:"其他")
	
	//就诊信息
	Set Data=$lb(argPaadm)
    Set Data=Data_$lb(PatientID)
    Set Data=Data_$lb(PapmiNo)
    Set Data=Data_$lb(PatName)
    Set Data=Data_$lb(Sex)
    Set Data=Data_$lb(Birthday)
    Set Data=Data_$lb(Age)
    Set Data=Data_$lb(PersonalID)
	Set Data=Data_$lb(AdmitDate)
	Set Data=Data_$lb(AdmitTime)
	Set Data=Data_$lb(DisDate)
	Set Data=Data_$lb(DisTime)
	Set Data=Data_$lb(AdmLoc)
	Set Data=Data_$lb(AdmWard)
	Set Data=Data_$lb(AdmRoom)
	Set Data=Data_$lb(AdmBed)
	Set Data=Data_$lb(AdmDoc)
	Set Data=Data_$lb(AdmDays)
	Set Data=Data_$lb(AdmType)
    Set Data=Data_$lb(EncryptLevel)
	Set Data=Data_$lb(PatLevel)
    
    Set return=Data
	Quit return
	
BuildDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2014-03-02
/// Description:  查询综合监测就诊列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CtlResultSrv","QryCtlPaadm","2","2016-04-01","2016-04-26","7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36/37/","","","")
Query QryCtlPaadm(aDateType As %String, aDateFrom As %String, aDateTo As %String, aCtrls As %String, aLocID As %String, aWardID As %String, aHospID As %String = "") As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,AdmType:%String,EncryptLevel:%String,PatLevel:%String,CtrlDtl:%String,Ind:%String")
{
}

ClassMethod QryCtlPaadmExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aCtrls As %String, aLocID As %String, aWardID As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^ZF=$lb(aDateType,aDateFrom,aDateTo,aCtrls,aLocID,aWardID,aHospID)
 	
 	Quit:(aDateFrom="")||(aDateTo="")||(aCtrls="")||(aDateType="") $$$OK
 	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
 	Set %ZIndex=$zn,%JIndex=$j
	Kill ^TMP(%ZIndex,%JIndex,"QryCtlPaadm")
	
 	Set:aDateType=1 IndexCode="IndexOccurDateEpisodeID"  //发生日期
 	Set:aDateType=2 IndexCode="IndexActDateEpisodeID"    //结果日期
	For xDate=aDateFrom:1:aDateTo {
 		Set xEpisodeID=""
 		For {
 			Set xEpisodeID=$o(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID))
 			Quit:xEpisodeID=""
 			
 			Set EpisodeID=xEpisodeID
 			Set AdmInfo=$g(^PAADM(EpisodeID))
 			Set AdmType=$p(AdmInfo,"^",2)
 			Continue:(AdmType'="I")&&(AdmType'="E")	//就诊类型过滤
 			Continue:$p(AdmInfo,"^",20)="C"         //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:AdmLoc=""
			
 			//Set HospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
			//Continue:(aHospID'="")&&(aHospID'=HospID)
			If aHospID'="" {
				Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
				Continue:flg<1
			}
			Set DtlInfo="",ItemCount=0
			For indItem=1:1:$l(aCtrls,"/") {
				Set ItemID=$p(aCtrls,"/",indItem)
				Continue:ItemID=""
				
				Continue:'$d(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID,ItemID))
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
				Continue:'$IsObject(objItemDic)
				Set ItemDesc=objItemDic.IDDesc
				Set Score=objItem.Score
				Set ItemGroup=""
				Set:(Score>0)&&(Score<=50) ItemGroup="一级"
				Set:(Score>50)&&(Score<=100) ItemGroup="二级"
				Set:Score>100 ItemGroup="三级"
				Continue:ItemGroup=""
				
				Set ItemCount=ItemCount+1
				//Set DtlInfo=DtlInfo_"<b style=margin:40px'>"_"项目"_ItemCount_"：["_ItemGroup_"]"_ItemDesc_"</b><br>"
				
				Set ResultCount=0
				Set xObjectID=""
				For {
					Set xObjectID=$o(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID,ItemID,xObjectID))
 					Quit:xObjectID=""
					
 					Set xResultID=""
 					For {
	 					Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail",IndexCode,xDate,xEpisodeID,ItemID,xObjectID,xResultID))
 						Quit:xResultID=""
						
 						Set objResult=##Class(DHCMed.CC.CtlResult).GetObjById(xResultID)
 						Continue:'$IsObject(objResult)
						
 						If (aLocID'="")||(aWardID'="") {
				 			Set OccurDate=objResult.OccurDate
				 			Set OccurTime=objResult.OccurTime
				 			Set LocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetAdmitLocWard(xEpisodeID,OccurDate,OccurTime)
				 			Set LocID=$p(LocWard,",",1)
				 			Set:LocID'="" AdmLoc=LocID //add by zhoubo 2014-12-24
				 			Set WardID=$p(LocWard,",",3)
				 			Continue:(aLocID'="")&&(aLocID'=LocID)
				 			Continue:(aWardID'="")&&(aWardID'=WardID)
 						}
						Set DtlInfo=DtlInfo_","_xResultID
						//Set ResultCount=ResultCount+1
						//Set DtlInfo=DtlInfo_"<a style=margin:80px'>"_ResultCount_"："_objResult.Summary_"</a><br>"
	 				}
				}
			}
			Continue:DtlInfo=""
			Set:DtlInfo'="" DtlInfo=$e(DtlInfo,2,$l(DtlInfo))
			//Set DtlInfo="<b style=margin:20px'>触发项目：列出此次就诊触发的项目明细。</b><br>"_DtlInfo
			
			Set Data=..BuildData(EpisodeID,AdmLoc) //update by zhoubo 2014-12-25
			Continue:Data=""
			Set Data=Data_$lb(DtlInfo)_$lb(ind)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
	}
	
	Quit $$$OK
}

ClassMethod QryCtlPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlPaadmExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-03-02
/// Description:  查询综合监测项目列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CtlResultSrv","QryCtrlDtlByAdm","1162,1163")
Query QryCtrlDtlByAdm(aResultIDs As %String) As %Query(ROWSPEC = "ResultID:%String,ItemID:%String,ItemDesc:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,DataTime:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActLoc:%String,ActWard:%String,OccurDate:%String,OccurTime:%String,DataValue:%String,ObjectID:%String")
{
}

ClassMethod QryCtrlDtlByAdmExecute(ByRef qHandle As %Binary, aResultIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aResultIDs="" $$$OK
 	
 	Set JIndex=$j,ZIndex=$zn
 	Kill ^TMP(JIndex,ZIndex,"QryCtrlDtlByAdm")
 	
 	For indRst=1:1:$l(aResultIDs,",") {
		Set ResultID=$p(aResultIDs,",",indRst)
		Continue:ResultID=""
		
		Set (ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime)=""
		Set (ActUser,OccurDate,OccurTime,DataValue,ObjectID)=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
		Continue:'$IsObject(objResult)
		
		Set ItemID=objResult.ItemId
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set ItemCatID=objItemDic.IDSubCatDr
		Set objItemCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objItemCat)
		Set ItemCatDesc=objItemCat.ISCDesc
		
		Set Score=objItem.Score
		Set ItemGroup=""
		Set:(Score>0)&&(Score<=50) ItemGroup="一级"
		Set:(Score>50)&&(Score<=100) ItemGroup="二级"
		Set:Score>100 ItemGroup="三级"
		Continue:ItemGroup=""
		
		Set Summary=objResult.Summary
		Set DataValue=objResult.DataValue
		Set ObjectID=objResult.ObjectID
		
		Set ActDate=objResult.ActDate
		Set ActTime=objResult.ActTime
		Set ActUser=objResult.UserID
		//Set ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		Set:ActUser="" ActUser=objResult.UserName
		
		Set OccurDate=objResult.OccurDate
		Set OccurTime=objResult.OccurTime
		Set EpisodeID=objResult.EpisodeID
		set tmpLocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetAdmitLocWard(EpisodeID,OccurDate,OccurTime)
		set ActLoc=$p(tmpLocWard,",",1)
		set ActWard=$p(tmpLocWard,",",3)
		Set ActLoc=+ActLoc
	 	Set ActWard=+ActWard
	 	Set ActLoc=$p($g(^CTLOC(+ActLoc)),"^",2)
		Set:$p(ActLoc,"-",2)'="" ActLoc=$p(ActLoc,"-",2)
	 	Set ActWard=$p($g(^CTLOC(+ActWard)),"^",2)
		Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
		
		Set SttDate=objResult.ObjSttDate
		Set SttTime=objResult.ObjSttTime
		Set EndDate=objResult.ObjEndDate
		Set EndTime=objResult.ObjEndTime
		Set:SttDate["-" SttDate=$zdh(SttDate,3)
		Set:SttTime[":" SttTime=$zth(SttTime,2)
		Set:EndDate["-" EndDate=$zdh(EndDate,3)
		Set:EndTime[":" EndTime=$zth(EndTime,2)
		
		;Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		;Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
		Set:OccurDate'="" OccurDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OccurDate)
		Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
		
		;Set:SttDate'="" SttDate=$zd(SttDate,3)
		Set:SttDate'="" SttDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SttDate)
		Set:SttTime'="" SttTime=$zt(SttTime,2)
		;Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EndDate)	
		Set:EndTime'="" EndTime=$zt(EndTime,2)
		
		If (ActDate_" "_ActTime)'=(OccurDate_" "_OccurTime){
			Set DateTime=OccurDate_" "_OccurTime_"—"_ActDate_" "_ActTime
		} Else {
			Set DateTime=ActDate_" "_ActTime
		}
		
		Set ObjCategory=objResult.ObjCategory
		If ObjCategory="OE" {
			Set OrdID=$p(ObjectID,"||",1)
			Set SubID=$p(ObjectID,"||",2)
			Set FillerNo=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",12)
			Set:FillerNo="" FillerNo=ObjectID
			
			Set OEPriority=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",8)
			Set OEPriorityDesc=$p($g(^OECPR(+OEPriority)),"^",2)
			If OEPriorityDesc["长期" {
				Set DateTime=SttDate_" "_SttTime_"～"_EndDate_" "_EndTime
			}
		} Else {
			Set FillerNo=ObjectID
		}
		
		Set Data=$lb(ResultID,ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,DateTime,ActDate,ActTime,ActUser,ActLoc,ActWard,OccurDate,OccurTime,DataValue,ObjectID)
		Set ^TMP(JIndex,ZIndex,"QryCtrlDtlByAdm",+ItemCatID,FillerNo)=Data
	}
 	
 	Set xItemCat=""
 	For {
	 	Set xItemCat=$o(^TMP(JIndex,ZIndex,"QryCtrlDtlByAdm",xItemCat))
	 	Quit:xItemCat=""
	 	Set xFillerNo=""
		For {
			Set xFillerNo=$o(^TMP(JIndex,ZIndex,"QryCtrlDtlByAdm",xItemCat,xFillerNo))
			Quit:xFillerNo=""
			
			Set Data=$g(^TMP(JIndex,ZIndex,"QryCtrlDtlByAdm",xItemCat,xFillerNo))
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(JIndex,ZIndex,"QryCtrlDtlByAdm")
	
	Quit $$$OK
}

ClassMethod QryCtrlDtlByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtrlDtlByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtrlDtlByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtrlDtlByAdmExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-03-05
/// Description:  查询监控明细列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CtlResultSrv","QryCtlResultDtl","593786","INTCCS","2016-04-26","2016-04-29")
Query QryCtlResultDtl(aEpisodeID As %String, aSubjectCode As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ResultID:%String,ItemID:%String,ItemDesc:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,ActDate:%String,ActTime:%String,ActUser:%String,OccurDate:%String,OccurTime:%String,ObjEndDate:%String,ObjEndTime:%String,DataValue:%String,ObjectID:%String")
{
}

ClassMethod QryCtlResultDtlExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aSubjectCode As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aEpisodeID="")||(aSubjectCode="") $$$OK
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) return
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	Quit:SubjectID="" $$$OK
	
	;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
		
	Set xResultID=""
	For {
		Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",aEpisodeID,SubjectID,xResultID))
		Quit:xResultID=""
 		
		Set (ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime)=""
		Set (ActUser,OccurDate,OccurTime,DataValue,ObjectID)=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
		Continue:'$IsObject(objResult)
		Set ActDate=objResult.ActDate
		Set ActTime=objResult.ActTime
		Continue:(aDateFrom'="")&&(ActDate<aDateFrom)
		Continue:(aDateTo'="")&&(ActDate>aDateTo)
		
		Set ItemID=objResult.ItemId
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set ItemCatID=objItemDic.IDSubCatDr
		Continue:ItemCatID=""
		Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,ItemCatID))
		Set objItemCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objItemCat)
		Set ItemCatDesc=objItemCat.ISCDesc
		
		Set Score=objItem.Score
		Set ItemGroup=""
		Set:(Score>0)&&(Score<=50) ItemGroup="一级"
		Set:(Score>50)&&(Score<=100) ItemGroup="二级"
		Set:Score>100 ItemGroup="三级"
		Continue:ItemGroup=""
		
		Set Summary=objResult.Summary
		Set DataValue=objResult.DataValue
		Set ObjectID=objResult.ObjectID
		
		;Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set ActUser=objResult.UserID
		//Set ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		Set:ActUser="" ActUser=objResult.UserName

		Set OccurDate=objResult.OccurDate
		Set OccurTime=objResult.OccurTime
		;Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
		Set:OccurDate'="" OccurDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OccurDate)
		Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
		
		Set ObjEndDate=objResult.ObjEndDate
		Set ObjEndTime=objResult.ObjEndTime
		;Set:ObjEndDate'="" ObjEndDate=$zd(ObjEndDate,3)
		Set:ObjEndDate'="" ObjEndDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ObjEndDate)
		Set:ObjEndTime'="" ObjEndTime=$zt(ObjEndTime,2)
		
		Set Data=$lb(xResultID,ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime,ActUser,OccurDate,OccurTime,ObjEndDate,ObjEndTime,DataValue,ObjectID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCtlResultDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlResultDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCtlResultDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlResultDtlExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-03-21
/// Description:  通过监控结果查询耐药信息
/// Table：       DHCMed.CC.CtlResult
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CtlResultSrv","QryMRBResult","INTCCS","2016-04-21","2016-04-27","",0,"","")
Query QryMRBResult(aSubjectCode As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aMRBFlag As %String, aMRBAlias As %String, aHospID As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,AdmType:%String,EncryptLevel:%String,PatLevel:%String,ResultID:%String,ItemID:%String,ItemDesc:%String,Score:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,ActDate:%String,ActTime:%String,ActUser:%String,OccurDate:%String,OccurTime:%String,DataValue:%String,ObjectID:%String,TestSetRow:%String:%String,OEItemID:%String,SpecimenCode:%String,SpecimenDesc:%String,SubmisDocCode:%String,SubmisDocDesc:%String,ActLoc:%String,ActWard:%String,MRBFlag:%String,MRSDesc:%String") [ SqlProc ]
{
}

ClassMethod QryMRBResultExecute(ByRef qHandle As %Binary, aSubjectCode As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, aMRBFlag As %String, aMRBAlias As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set aLocID=$g(aLocID)
	Set aMRBFlag=$g(aMRBFlag)
	Set aMRBAlias=$g(aMRBAlias)
	Set:aMRBAlias="-" aMRBAlias=""
	
	;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) return
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	Quit:SubjectID="" $$$OK
	
	Set JIndex=$j,ZIndex=$zn
	Kill ^TMP(JIndex,ZIndex,"QryMRBResult")
	
	For xDate=aDateFrom:1:aDateTo {
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID))
			Quit:xEpisodeID=""
			
			Set xResultID=""
			For {
				Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xEpisodeID,SubjectID,xResultID))
				Quit:xResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
				Continue:'$IsObject(objResult)
				Set ActDate=objResult.ActDate
				Set ActTime=objResult.ActTime
				Continue:(aDateFrom'="")&&(ActDate<aDateFrom)
				Continue:(aDateTo'="")&&(ActDate>aDateTo)
				
				Set ItemID=objResult.ItemId
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
				Continue:'$IsObject(objItemDic)
				Set ItemDesc=objItemDic.IDDesc
				Set ItemCatID=objItemDic.IDSubCatDr
				Continue:ItemCatID=""
				Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,ItemCatID))
				Set objItemCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemCatID)
				Continue:'$IsObject(objItemCat)
				Set ItemCatDesc=objItemCat.ISCDesc
				
				//多重耐药菌查询
				Set KeyWordID=objItemCat.ISCKeywordID
				Continue:KeyWordID=""
				Set objKeyWord=##class(DHCMed.CC.KeyWord).GetObjById(KeyWordID)
				Continue:'$IsObject(objKeyWord)
				Set KeyWordCode=objKeyWord.Code
				Set MRBFlag=0
				Set:KeyWordCode="MRB" MRBFlag=1
				Continue:(aMRBFlag=1)&&(MRBFlag=0)
				
				Set Score=objItem.Score
				Set ItemGroup=""
				Set:(Score>0)&&(Score<=50) ItemGroup="一级"
				Set:(Score>50)&&(Score<=100) ItemGroup="二级"
				Set:Score>100 ItemGroup="三级"
				Continue:ItemGroup=""
				
				Set Summary=objResult.Summary
				Continue:(aMRBAlias'="")&&(Summary'[aMRBAlias) //多重耐药菌过滤
				
				Set DataValue=objResult.DataValue
				Continue:(DataValue["支原体")||(DataValue["衣原体")
				
				Set ObjectID=objResult.ObjectID
				Set EpisodeID=objResult.EpisodeID
				
				If $d(^TMP(JIndex,ZIndex,"QryMRBResult",EpisodeID,ObjectID)) {
					Set tmpData=$g(^TMP(JIndex,ZIndex,"QryMRBResult",EpisodeID,ObjectID))
					Set tmpScore=$list(tmpData,4)
					Continue:Score<tmpScore
				}
				
				/*Set Epis=$p(ObjectID,"||",1)
				Set TS=$p(ObjectID,"||",2)
				Set TSCount=$p(ObjectID,"||",3)
				Continue:(Epis="")||(TS="")||(TSCount="")
				Set TestSetRow=Epis_"||"_TS_"||"_TSCount
				
				//通过检验号取医嘱ID
				Set OrdID=$o(^OEORD(0,"EpisNo",Epis,0))
				Set SubID=$o(^OEORD(0,"EpisNo",Epis,+OrdID,0))
				//Set SubID=$o(^OEORDi(0,"LabTS",+OrdID,TestSetRow,0))
				*/
				Set OrdID=$p(ObjectID,"||",1)
				Set SubID=$p(ObjectID,"||",2)
				Set TSCode=$p(ObjectID,"||",3)
				Continue:(OrdID="")||(SubID="")
				Set TestSetRow=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",35)
				Set OEItemID=OrdID_"||"_SubID
				
				//通过医嘱取送检标本
				Set SpecimenCode="",SpecimenDesc=""
				/* update by zf 修改检验医嘱标本取值方法
				Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
				Set:SpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
				If SpecimenDesc="" {
					Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
					Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
				}
				*/
				Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(OrdID_"||"_SubID)
				Set SpecDr=$p(tSpecimenInfo,"^",1)
				Set SpecimenCode=$p(tSpecimenInfo,"^",2)
				Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
				
				//送检医生,即开医嘱医生，转换为SSUser表数据
				Set SubmisDocCode="",SubmisDocDesc=""
				Set CareProvID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",11)
				If CareProvID'="" {
					Set SubmisDocCode=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,0))
					Set:SubmisDocCode'="" SubmisDocDesc=$p($g(^SSU("SSUSR",SubmisDocCode)),"^",2)
				}
				
				;Set:ActDate'="" ActDate=$zd(ActDate,3)
				Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
				Set:ActTime'="" ActTime=$zt(ActTime,2)
				Set ActUser=objResult.UserID
				//Set ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
				Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
				Set:ActUser="" ActUser=objResult.UserName
				
				Set OccurDate=objResult.OccurDate
				Set OccurTime=objResult.OccurTime
				Set LocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetAdmitLocWard(EpisodeID,OccurDate,OccurTime)
	 			Set ActLocID=$p(LocWard,",",1)
	 			Continue:(aLocID'="")&&(aLocID'=ActLocID)
	 			
	 			if aHospID'="" {
					set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(ActLocID,aHospID)
					continue:flg<1
				}
	 			Set ActLocDesc=$p(LocWard,",",2)
	 			Set ActWardID=$p(LocWard,",",3)
	 			Set ActWardDesc=$p(LocWard,",",4)
	 			;Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
	 			Set:OccurDate'="" OccurDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OccurDate)
				Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
				
				Set Data=$lb(xResultID,ItemID,ItemDesc,Score,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime,ActUser,OccurDate,OccurTime,DataValue,ObjectID,TestSetRow,OEItemID,SpecimenCode,SpecimenDesc,SubmisDocCode,SubmisDocDesc,ActLocDesc,ActWardDesc,MRBFlag)
				Set ^TMP(JIndex,ZIndex,"QryMRBResult",EpisodeID,ObjectID)=Data
			}
		}
	}
	
	Set xEpisodeID=""
	For {
		Set xEpisodeID=$o(^TMP(JIndex,ZIndex,"QryMRBResult",xEpisodeID))
		Quit:xEpisodeID=""
		Set xObjectID=""
		For {
			Set xObjectID=$o(^TMP(JIndex,ZIndex,"QryMRBResult",xEpisodeID,xObjectID))
			Quit:xObjectID=""
			
			Set Data=..BuildData(xEpisodeID)
			Continue:Data=""
			Set DataLab=$g(^TMP(JIndex,ZIndex,"QryMRBResult",xEpisodeID,xObjectID))
			Set Data=Data_DataLab
			Set tDataValue=$li(DataLab,14)
			 //需根据医院的监控条件进行修改
			Set MRSDesc=""
			If (tDataValue["金黄色葡萄球菌") 
			{
				Set MRSDesc="耐甲氧西林金黄色葡萄球菌"	
			}ElseIf (tDataValue["耐万古霉素肠球菌")
			{
				Set MRSDesc="耐万古霉素肠球菌"
			}ElseIf (tDataValue["CRE")
			{
				Set MRSDesc="耐碳青霉烯类抗菌药物肠杆菌科细菌"
			}ElseIf (tDataValue["PDR-AB")
			{
				Set MRSDesc="泛耐药鲍曼不动杆菌"
			}
			ElseIf (tDataValue["鲍曼不动杆菌")
			{
				Set MRSDesc="耐碳青霉烯鲍曼不动杆菌"
			}ElseIf (tDataValue["CR-PA")
			{
				Set MRSDesc="耐碳青霉烯类抗菌药物铜绿假单胞菌"
			}
			ElseIf (tDataValue["铜绿假单胞菌")	
			{
				Set MRSDesc="多重耐药/泛耐药铜绿假单胞菌"
			}ElseIf (tDataValue["ESBL")
			{
				Set MRSDesc="超广谱β-内酰胺酶（ESBLs）细菌"
			}
			
			Set Data=Data_$lb(MRSDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(JIndex,ZIndex,"QryMRBResult")
	
	Quit $$$OK
}

ClassMethod QryMRBResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMRBResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBResultExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-03-02
/// Description:  查询综合监测项目列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CtlResultSrv","QryMRBDtlByAdm","490928")
Query QryMRBDtlByAdm(aResultIDs As %String) As %Query(ROWSPEC = "ResultID:%String,ItemID:%String,ItemDesc:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,DataTime:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActLoc:%String,ActWard:%String,OccurDate:%String,OccurTime:%String,DataValue:%String,ObjectID:%String,SubmisDate:%String,SpecimenDesc:%String,Pathogeny:%String,SubmisDoc:%String,EpisodeID:%String,MRBRepFlag:%String,MRBRepID:%String")
{
}

ClassMethod QryMRBDtlByAdmExecute(ByRef qHandle As %Binary, aResultIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aResultIDs="" $$$OK
 	
 	Set JIndex=$j,ZIndex=$zn
 	Kill ^TMP(JIndex,ZIndex,"QryMRBDtlByAdm")
 	
 	For indRst=1:1:$l(aResultIDs,",") {
		Set ResultID=$p(aResultIDs,",",indRst)
		Continue:ResultID=""
		
		Set (ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime)=""
		Set (ActUser,OccurDate,OccurTime,DataValue,ObjectID)=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
		Continue:'$IsObject(objResult)
		
		Set ItemID=objResult.ItemId
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set ItemCatID=objItemDic.IDSubCatDr
		Set objItemCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objItemCat)
		Set ItemCatDesc=objItemCat.ISCDesc
		Set ISCKeyID=objItemCat.ISCKeywordID
		Set KeyWordCode=""
		If ISCKeyID'="" {
			Set objKeyWord=##class(DHCMed.CC.KeyWord).GetObjById(ISCKeyID)
			If $IsObject(objKeyWord){
				Set KeyWordCode=objKeyWord.Code
			}
		}
		
		Set Score=objItem.Score
		Set ItemGroup=""
		Set:(Score>0)&&(Score<=50) ItemGroup="一级"
		Set:(Score>50)&&(Score<=100) ItemGroup="二级"
		Set:Score>100 ItemGroup="三级"
		Continue:ItemGroup=""
		
		Set Summary=objResult.Summary
		Set DataValue=objResult.DataValue
		Set ObjectID=objResult.ObjectID
		
		Set ActDate=objResult.ActDate
		Set ActTime=objResult.ActTime
		Set ActUser=objResult.UserID
		//Set ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		Set:ActUser="" ActUser=objResult.UserName
		
		Set OccurDate=objResult.OccurDate
		Set OccurTime=objResult.OccurTime
		Set EpisodeID=objResult.EpisodeID
		set tmpLocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetAdmitLocWard(EpisodeID,OccurDate,OccurTime)
		set ActLoc=$p(tmpLocWard,",",1)
		set ActWard=$p(tmpLocWard,",",3)
		Set ActLoc=+ActLoc
	 	Set ActWard=+ActWard
	 	Set ActLoc=$p($g(^CTLOC(+ActLoc)),"^",2)
		Set:$p(ActLoc,"-",2)'="" ActLoc=$p(ActLoc,"-",2)
	 	Set ActWard=$p($g(^CTLOC(+ActWard)),"^",2)
		Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
		
		Set SttDate=objResult.ObjSttDate
		Set SttTime=objResult.ObjSttTime
		Set EndDate=objResult.ObjEndDate
		Set EndTime=objResult.ObjEndTime
		Set:SttDate["-" SttDate=$zd(SttDate,3)
		Set:SttTime[":" SttTime=$zt(SttTime,2)
		Set:EndDate["-" EndDate=$zd(EndDate,3)
		Set:EndTime[":" EndTime=$zt(EndTime,2)
		
		Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
		Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
		
		Set:SttDate'="" SttDate=$zd(SttDate,3)
		Set:SttTime'="" SttTime=$zt(SttTime,2)
		Set:EndDate'="" EndDate=$zd(EndDate,3)
		Set:EndTime'="" EndTime=$zt(EndTime,2)
		
		If (ActDate_" "_ActTime)'=(OccurDate_" "_OccurTime){
			Set DateTime=OccurDate_" "_OccurTime_"—"_ActDate_" "_ActTime
		} Else {
			Set DateTime=ActDate_" "_ActTime
		}
		
		Set ObjCategory=objResult.ObjCategory
		If ObjCategory="OE" {
			Set OrdID=$p(ObjectID,"||",1)
			Set SubID=$p(ObjectID,"||",2)
			Set FillerNo=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",12)
			Set:FillerNo="" FillerNo=ObjectID
			
			Set OEPriority=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",8)
			Set OEPriorityDesc=$p($g(^OECPR(+OEPriority)),"^",2)
			If OEPriorityDesc["长期" {
				Set DateTime=SttDate_" "_SttTime_"～"_EndDate_" "_EndTime
			}
		} Else {
			Set FillerNo=ObjectID
		}
		
		//送检日期、标本、病原菌
		Set Pathogeny=objResult.DataValue   //病原菌
		
		/*Set Epis=$p(ObjectID,"||",1)
		Set TS=$p(ObjectID,"||",2)
		Set TSCount=$p(ObjectID,"||",3)
		Continue:(Epis="")||(TS="")||(TSCount="")
		Set TestSetRow=Epis_"||"_TS_"||"_TSCount
		
		//通过检验号取医嘱ID
		Set OrdID=$o(^OEORD(0,"EpisNo",Epis,0))
		Set SubID=$o(^OEORD(0,"EpisNo",Epis,+OrdID,0))
		//Set SubID=$o(^OEORDi(0,"LabTS",+OrdID,TestSetRow,0))
		*/
		Set OrdID=$p(ObjectID,"||",1)
		Set SubID=$p(ObjectID,"||",2)
		Set TSCode=$p(ObjectID,"||",3)
		Continue:(OrdID="")||(SubID="")
		Set TestSetRow=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",35)

		Set OEItemID=OrdID_"||"_SubID
		
		//通过医嘱取送检标本
		Set SpecimenCode="",SpecimenDesc=""
		/* update by zf 修改检验医嘱标本取值方法
		Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
		Set:SpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
		If SpecimenDesc="" {
			Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
			Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
		}
		*/
		Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(OrdID_"||"_SubID)
		Set SpecDr=$p(tSpecimenInfo,"^",1)
		Set SpecimenCode=$p(tSpecimenInfo,"^",2)
		Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
		
		//送检医生,即开医嘱医生，转换为SSUser表数据
		Set SubmisDocCode="",SubmisDocDesc=""
		Set CareProvID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",11)
		If CareProvID'="" {
			Set SubmisDocCode=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,0))
			Set:SubmisDocCode'="" SubmisDocDesc=$p($g(^SSU("SSUSR",SubmisDocCode)),"^",2)
		}
		
		Set SubmisDate=OccurDate  //发生时间即时送检日期
		
		Set MRBRepFlag="",MRBRepID=""
		If KeyWordCode="MRB" {
			Set MRBRepFlag=KeyWordCode
			Set MRBRepID=##Class(DHCMed.NINFService.BC.CtlMRBSrv).GetMRBRepID(EpisodeID,ObjectID)
		}
		
		Set Data=$lb(ResultID,ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,DateTime,ActDate,ActTime,ActUser,ActLoc,ActWard,OccurDate,OccurTime,DataValue,ObjectID)
		Set Data=Data_$lb(SubmisDate,SpecimenDesc,Pathogeny,SubmisDocDesc,EpisodeID,MRBRepFlag,MRBRepID)
		Set ^TMP(JIndex,ZIndex,"QryMRBDtlByAdm",+ItemCatID,FillerNo)=Data
	}
 	
 	Set xItemCat=""
 	For {
	 	Set xItemCat=$o(^TMP(JIndex,ZIndex,"QryMRBDtlByAdm",xItemCat))
	 	Quit:xItemCat=""
	 	Set xFillerNo=""
		For {
			Set xFillerNo=$o(^TMP(JIndex,ZIndex,"QryMRBDtlByAdm",xItemCat,xFillerNo))
			Quit:xFillerNo=""
			
			Set Data=$g(^TMP(JIndex,ZIndex,"QryMRBDtlByAdm",xItemCat,xFillerNo))
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(JIndex,ZIndex,"QryMRBDtlByAdm")
	
	Quit $$$OK
}

ClassMethod QryMRBDtlByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRBDtlByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRBDtlByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRBDtlByAdmExecute ]
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

}
