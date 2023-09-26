/// 名称:DHCMed.EPDService.CtlResultSrv
/// 描述: 
/// 编写者：zhufei
/// 编写日期: 2013-12-06
Class DHCMed.EPDService.CtlResultSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  就诊号取监控列表数据
/// Return:       $lb() 或 ""
ClassMethod BuildData(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="BuildDataErr"
	Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,PersonalID,EncryptLevel,PatLevel)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc,AdmWard,AdmRoom,AdmBed,AdmDoc,AdmDays)=""
	Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(argPaadm)
	Quit:'$IsObject(objPaadm) return
	Set PatientID=objPaadm.PatientID
	Set objPatient=##Class(DHCMed.Base.Patient).GetObjById(PatientID)
	Set PapmiNo=objPatient.PapmiNo
	Set PatName=objPatient.PatientName
	Set Sex=objPatient.Sex
	Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,argPaadm,"","")	//返回“*岁*月*天”
	Set PersonalID=objPatient.PersonalID
	
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
    //Set AdmitDate=objPaadm.PAADMAdmDate
    //Set AdmitTime=objPaadm.PAADMAdmTime
    //upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(argPaadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
    //Set DisDate=objPaadm.PAADMDischgDate
    //Set DisTime=objPaadm.PAADMDischgTime
    //Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(argPaadm)
	Set DisDate=$p(DischDateTime,"^",1)
	Set DisTime=$p(DischDateTime,"^",2)
    If DisDate'="" {
	    Set AdmDays=DisDate-AdmitDate
    } Else {
		Set AdmDays=+$h-AdmitDate
	}
    Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
    Set:DisDate'="" DisDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DisDate)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
	Set AdmLoc=objPaadm.Department
	Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	Set AdmWard=objPaadm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	Set AdmRoom=objPaadm.Room
	Set AdmBed=objPaadm.Bed
	Set AdmDoc=objPaadm.DoctorName
	
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
/// D ##class(%ResultSet).RunQuery("DHCMed.EPDService.CtlResultSrv","QryCtlPaadm","2","2014-01-01","2014-01-30","1/2/","","","","I,O,E")
Query QryCtlPaadm(aDateType As %String, aDateFrom As %String, aDateTo As %String, aCtrls As %String, aLocID As %String, aWardID As %String, aHospID As %String = "", aAdmType As %String = "") As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,AdmType:%String,EncryptLevel:%String,PatLevel:%String,CtrlCont:%String,CtrlDtl:%String,IsFirst:%String,HisReportInfo:%String,IsRepEpdDesc:%String")
{
}

ClassMethod QryCtlPaadmExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aCtrls As %String, aLocID As %String, aWardID As %String, aHospID As %String = "", aAdmType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	//Set ^ZF=$LB(aDateType,aDateFrom,aDateTo,aCtrls,aLocID,aWardID,aHospID,aAdmType)
	
 	Quit:(aDateFrom="")||(aDateTo="")||(aCtrls="")||(aDateType="") $$$OK
 	
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="")||(aAdmType="") $$$OK
 	
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
 			Set AdmType=$p(AdmInfo,"^",2)                   //就诊类型过滤
 			Continue:aAdmType'[AdmType
			Continue:$p(AdmInfo,"^",20)="C"                 //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:AdmLoc=""
			//Set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
			//Continue:(aHospID'="")&&(aHospID'=CTHospID)
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(AdmLoc,aHospID)
				continue:flg<1
			}
			
			Set CtrlDtl="",CtrlCont="",ItemCount=0
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

						//add by mxp 过滤传染病筛查处置已排除 						
 						set ExtraFlg=..CheckIsExtaCasex("EPDCC",xEpisodeID,xResultID)
 						Continue:ExtraFlg=1
 						
 						If (aLocID'="")||(aWardID'="") {
				 			Set OccurDate=objResult.OccurDate
				 			Set OccurTime=objResult.OccurTime
							Set EpisodeID=objResult.EpisodeID
							set tmpLocWard=..GetAdmitLocWard(EpisodeID,OccurDate,OccurTime)
							
				 			Set LocID=$p(tmpLocWard,",",1)
				 			Set WardID=$p(tmpLocWard,",",3)
				 			Continue:(aLocID'="")&&(aLocID'=LocID)
				 			Continue:(aWardID'="")&&(aWardID'=WardID)
 						}
						Set CtrlDtl=CtrlDtl_","_xResultID
						
						Set ItemID=objResult.ItemId
						Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
						Continue:'$IsObject(objItem)
						Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(objItem.ItemDic)
						Continue:'$IsObject(objItemDic)
						Set ItemDesc=objItemDic.IDDesc
						Set ItemSubCatID=objItemDic.IDSubCatDr
						Set objItemSubCat= ##class(DHCMed.CC.ItemSubCat).GetObjById(ItemSubCatID)
						Continue:'$IsObject(objItemSubCat)
						Set ItemSubCatDesc=objItemSubCat.ISCDesc
						Set ItemCatID=objItemSubCat.ISCCatDr
						Set objItemCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatID)
						Continue:'$IsObject(objItemCat)
						Set ItemCatDesc=objItemCat.ICDesc
						
						If ItemCatDesc["诊断" {
							Set tmp1=$e(objResult.DataValue,1,1)
							Set tmp2=$e(objResult.DataValue,4,4)
							Set tmp3="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
							If (tmp3[$zcvt(tmp1,"U"))&&(tmp2=".")&&(objResult.DataValue[" ") {
								Set tmpEpdICD=$p(objResult.DataValue," ",2)
							} Else {
								Set tmpEpdICD=objResult.DataValue
							}
						} Else {
							Set tmpEpdICD=ItemSubCatDesc
						}
						Continue:tmpEpdICD=""
						Continue:$listfind(CtrlCont,tmpEpdICD)>0
						Set CtrlCont=CtrlCont_$lb(tmpEpdICD)
					}
				}
			}
			Continue:CtrlDtl=""
			Set:CtrlDtl'="" CtrlDtl=$e(CtrlDtl,2,$l(CtrlDtl))
			
			Set tmpCtrlCont=""
			For indC=1:1:$listlength(CtrlCont) {
				Set tmpContent=$list(CtrlCont,indC)
				Continue:tmpContent=""
				Set tmpCtrlCont=tmpCtrlCont_";"_tmpContent
			}
			Set CtrlCont=tmpCtrlCont
			Set:CtrlCont'="" CtrlCont=$e(CtrlCont,2,$l(CtrlCont))
			
			Set IsRepEpd=##class(DHCMed.EPD.Epidemic).CheckIsRepEpd(EpisodeID,CtrlCont)	
			Set IsRepEpdDesc=$s(IsRepEpd=1:"已报",1:"未报")
			Continue:(ItemDesc["未报")&&(IsRepEpd=1)

			Set Data=..BuildData(EpisodeID)
			Continue:Data=""
			Set Data=Data_$lb(CtrlCont,CtrlDtl)
			//add by cpj 2015-08-31
			//增加显示是否初复诊、历次报告信息
			Set IsFirst="初诊"
			Set FirstOrReadm=$p(^PAADM(EpisodeID),"^",72)
			Set:FirstOrReadm="R" IsFirst="复诊"
			Set HisReportInfo=##class(DHCMed.EPDService.Service).getEpdInfoByAdm(EpisodeID)
			
			Set Data=Data_$lb(IsFirst,HisReportInfo,IsRepEpdDesc)
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
/// D ##class(%ResultSet).RunQuery("DHCMed.EPDService.CtlResultSrv","QryCtrlDtlByAdm","1985323")
Query QryCtrlDtlByAdm(aResultIDs As %String) As %Query(ROWSPEC = "ResultID:%String,ItemID:%String,ItemDesc:%String,ItemGroup:%String,ItemCatID:%String,ItemCatDesc:%String,Summary:%String,ActDate:%String,ActTime:%String,ActUser:%String,ActLoc:%String,ActWard:%String,OccurDate:%String,OccurTime:%String,DataValue:%String,ObjectID:%String")
{
}

ClassMethod QryCtrlDtlByAdmExecute(ByRef qHandle As %Binary, aResultIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aResultIDs="" $$$OK
 	
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
		Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set ActUser=objResult.UserID
		Set ActUser=$p($g(^SSU("SSUSR",+ActUser)),"^",2)
		
		Set OccurDate= objResult.OccurDate
		Set OccurTime= objResult.OccurTime
		Set EpisodeID=objResult.EpisodeID
		set tmpLocWard=..GetAdmitLocWard(EpisodeID,OccurDate,OccurTime)
		set ActLoc=$p(tmpLocWard,",",1)
		set ActWard=$p(tmpLocWard,",",3)
		Set ActLoc=+ActLoc
	 	Set ActWard=+ActWard
	 	Set ActLoc=$p($g(^CTLOC(+ActLoc)),"^",2)
		Set:$p(ActLoc,"-",2)'="" ActLoc=$p(ActLoc,"-",2)
		//add by pylian 2015-06-24 fix bug 112211 传染病监控-点击门诊患者加号展开的记录中不显示科室
		Set LocID=+$p(^PAADM(EpisodeID),"^",4)
     	Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
  		Set LocDesc=objLoc.Descs
  		If ActLoc="" Set ActLoc=LocDesc
  		
	 	Set ActWard=$p($g(^CTLOC(+ActWard)),"^",2)
		Set:$p(ActWard,"-",2)'="" ActWard=$p(ActWard,"-",2)
		
		Set:OccurDate'="" OccurDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OccurDate)
		Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
		
		Set Data=$lb(ResultID,ItemID,ItemDesc,ItemGroup,ItemCatID,ItemCatDesc,Summary,ActDate,ActTime,ActUser,ActLoc,ActWard,OccurDate,OccurTime,DataValue,ObjectID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
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

ClassMethod GetAdmitLocWard(aEpisodeID As %String, aActDate As %String, aActTime As %String) As %String
{
	New (aEpisodeID,aActDate,aActTime)
	Set return=""
	
	Quit:(aEpisodeID="")||(aActDate="")||(aActTime="") return
	
	Set aActDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aActDate)	
	Set:aActTime[":" aActTime=$zth(aActTime,1)
	Set:aActTime'="" aActTime=+aActTime
	
	//Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
	//Set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	If (AdmDate>aActDate)||((AdmDate=aActDate)&&(AdmTime>aActTime)) {
		Set aActDate=AdmDate
		Set aActTime=AdmTime
	}
	
	Set LocID="",LocDesc="",WardID="",WardDesc=""
	Set LocID=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set tWardID=+$P($G(^PAADM(+aEpisodeID)),"^",70)
	Set Ward=$g(^PAWARD(+tWardID))
	Set WardCtlocID=$P(Ward,"^",5)
	Set WardID=WardCtlocID
	
	Set xTransID=0
	For {
		Set xTransID=$o(^PAADM(aEpisodeID,"TRANS",xTransID))
		Quit:xTransID=""
		
		Set tmpTrans=$g(^PAADM(aEpisodeID,"TRANS",xTransID))
		Continue:tmpTrans=""
		Set TransDate=$p(tmpTrans,"^",1)
		Set TransTime=$P(tmpTrans,"^",2)
		Quit:(TransDate>aActDate)
		Quit:(TransDate=aActDate)&&(TransTime>aActTime)
		
		Set TransLoc=$p(tmpTrans,"^",6)
		If (TransLoc'="") {
			Set LocID=TransLoc
		}
		Set TransWard=$p($p(tmpTrans,"^",8),"||",1)
		If (TransWard'="") {
			Set TransWard=$p($g(^PAWARD(+TransWard)),"^",5)
			Set WardID=TransWard
		}
	}
	Set LocDesc=$p($g(^CTLOC(+LocID)),"^",2)
	sET:$P(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	Set LocDesc=$tr(LocDesc,",","")
	
	Set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
	Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
	Set WardDesc=$tr(WardDesc,",","")
	
	Set return=LocID_","_LocDesc_","_WardID_","_WardDesc
	Quit return
}

/// add by mxp 检查传染病监控结果是否已在传染病筛查处置中排除
/// w ##class(DHCMed.EPDService.CtlResultSrv).CheckIsExtaCasex("EPDCC",132,132)
ClassMethod CheckIsExtaCasex(aSubjectCode As %String, aEpisodeID As %String, aCtlResultID As %String) As %String
{
	New (aSubjectCode,aEpisodeID,aCtlResultID)

	Set return=0
	Quit:(aEpisodeID="")||(aCtlResultID="") return
	
	Set:aSubjectCode="" aSubjectCode="EPDCC"
	Set aCtlResultID=","_aCtlResultID_","
	
	Set xCasesXID=""
 	For {
 		Set xCasesXID=$o(^DHCMed.EPDi("CasesX","IndexSubjectPaadm",aSubjectCode,aEpisodeID,xCasesXID))
 		Quit:xCasesXID=""
 		
 		Set objCasesX=##class(DHCMed.EPD.CasesX).GetObjById(xCasesXID)
		Continue:'$IsObject(objCasesX)
		Set IsActive=objCasesX.CXIsActive
		Continue:IsActive'=1
		Set CXLnkResults=objCasesX.CXLnkResults
		Set temCXLnkResults=","_CXLnkResults_","
		Continue:temCXLnkResults'[aCtlResultID
		
		Set EpdStatus=objCasesX.CXEpdStatus
		Continue:EpdStatus'=0 
		Set return=1
 	}
    
	Quit return
}

}
