/// <H3>综合检测主函数</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-07-30</H4>
Class DHCMed.CCService.IntegratedCtrl.Control Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##Class(DHCMed.CCService.IntegratedCtrl.Control).Test()
ClassMethod Test()
{
	do ##Class(%ResultSet).RunQuery("DHCMed.CCService.IntegratedCtrl.Control","QryLocPatDtl","I","2013-05-01","2013-05-07","","392","8/9/10/24/15/16/19/23/","1","2")
}

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  就诊号取监控列表数据
/// Return:       $lb() 或 ""
ClassMethod BuildCtrlData(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="BuildCtrlDataErr"
	Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,PersonalID)=""
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
	    Set:Birthday'="" Birthday=$zd(Birthday,3)
	    Set PersonalID=objPatient.PAPMIID
	}
	
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
    Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
    Set:DisDate'="" DisDate=$zd(DisDate,3)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
    If $IsObject(objPaadm.PAADMDepCodeDR)
    {
	    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
	    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
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
	
	Set InfTypes=""
	//旧医院感染报告检查
	Set RepID=0,OInfCount=0
	For {
		Set RepID=$o(^DHCMedIR(0,"PAADM",argPaadm,RepID))
		Quit:RepID=""
		Set RepStatus=$p($g(^DHCMedIR(RepID)),"^",11)
		Continue:RepStatus["0"  //删除和被订报告过滤掉
		Set OInfCount=OInfCount+1
	}
	Set:OInfCount>0 InfTypes=InfTypes_"医院感染报告:"_OInfCount_"份;"_$c(1)
	//新医院感染报告检查
	Set RepID=0,NInfCount=0
	Set:NInfCount>0 InfTypes=InfTypes_"医院感染报告:"_NInfCount_"份;"_$c(1)
	//ICU监测报告检查
	Set RepID=0,ICUCount=0
	Set:ICUCount>0 InfTypes=InfTypes_"ICU监测报告:"_ICUCount_"份;"_$c(1)
	//手术切口报告检查
	Set RepID=0,OperCount=0
	Set:OperCount>0 InfTypes=InfTypes_"手术切口报告:"_OperCount_"份;"_$c(1)
	
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(argPaadm)
	
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
	Set Data=Data_$lb(InfTypes)
	Set Data=Data_$lb(MRAdm)
	Set DepID="0"
	Set:$IsObject(objPaadm.PAADMDepCodeDR) DepID=objPaadm.PAADMDepCodeDR.%Id()
	Set WardID="0"
	Set:$IsObject(objPaadm.PAADMCurrentWardDR) WardID=objPaadm.PAADMCurrentWardDR.%Id()
    Set Data=Data_$lb(DepID)
    Set Data=Data_$lb(WardID)
    Set return=Data
	Quit return
	
BuildCtrlDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  组织监控明细数据
/// Return:       字符串
ClassMethod BuildCtrlDtl(argCtrlDtls As %ListOfObjects) As %List
{
	New (argCtrlDtls)
	Set repid1=$i(^CacheTemp)
	Set return=""
	Set Count=argCtrlDtls.Count()
	For i=1:1:Count {
		Set objResult=argCtrlDtls.GetAt(i)
		Set ^CacheTemp(repid1,objResult.KeyWord,objResult.ItemId)=""
	}
	
	Set KeywordID=""
	For {
		Set KeywordID=$o(^CacheTemp(repid1,KeywordID))	
		Quit:KeywordID=""
		Set objKeyword=##class(DHCMed.CC.KeyWord).%OpenId(KeywordID)
		Continue:$IsObject(objKeyword)=0
		Set return=return_objKeyword.ToString()_$c(1)
		
		Set ItemID=0
		For {
			Set ItemID=$o(^CacheTemp(repid1,KeywordID,ItemID))
			Quit:ItemID=""
			Set num=0
			For i=1:1:Count {
				Quit:num>3
				Set objResult=argCtrlDtls.GetAt(i)
				Continue:objResult.KeyWord'=KeywordID
				Continue:objResult.ItemId'=ItemID
				
				Set num=num+1
				Set return=return_objResult.ToString()
				Set return=return_$c(1)
			}
		}
	}
	Kill ^CacheTemp(repid1)
	Quit $lb(return)
}

/// 将子类下面的SubjectItemID写到临时Global中
ClassMethod PrepareSubjectItem(SubjectID As %String, SubCateIDList As %String) As %String
{
	New (SubjectID,SubCateIDList,%ZIndex,%JIndex,%NIndex)
	Set return=0,Count=0
	Quit:(SubjectID="")||(SubCateIDList="") return
	Quit:(%ZIndex="")||(%JIndex="")||(%NIndex="") return
	
	For ind=1:1:$l(SubCateIDList,"/") {
		Set SubCatID=$p(SubCateIDList,"/",ind)
		Continue:SubCatID=""
		
		Set ItemDicID=""
		For {
			Set ItemDicID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,ItemDicID))
			Quit:ItemDicID=""
			
			Set SubjectItemID=""
			For {
				Set SubjectItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",SubjectID,ItemDicID,SubjectItemID))
				Quit:SubjectItemID=""
				
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
				Continue:'$IsObject(objSubCat)
				Set objCat=##class(DHCMed.CC.ItemCat).GetObjById(objSubCat.ISCCatDr)
				Continue:'$IsObject(objCat)
				
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",SubjectItemID)=SubCatID
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",SubjectItemID,"Icon")=objCat.ICCode_"-"_objSubCat.ISCCode
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID)=objCat.ICCode_"-"_objSubCat.ISCCode
			}
		}
		Set Count=Count+1
	}
	
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  住院患者监控(包括:在院、出院)
/// Input：       Status(在院/出院),DateFrom(开始日期),DateTo(结束日期),LocID(科室),WardID(病区),Ctrls(监控项目列表)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.IntegratedCtrl.Control","QryByPaadm","I","2013-04-23","2013-04-23","","228","24","1","2")
Query QryByPaadm(argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String, argEpisodeID As %String = "") As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,InfTypes:%String,MRAdm:%String,DepID:%String,WardID:%String,Score:%String,CtrlDtl:%String,EvalInfo:%String,FeedbackTimes:%String,AcceptTimes:%String,RejectTimes:%String,NoReponseTimes:%String,LastSummaryID:%String,SubCatList:%String,FireCatCnt:%String,FireCatFlag:%String") [ SqlProc ]
{
}

ClassMethod QryByPaadmExecute(ByRef qHandle As %Binary, argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String, argEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argCtrls="" $$$OK
	Quit:(argStatus="") $$$OK
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:((argDateFrom="")||(argDateTo="")) $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryByPaadm"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set SubCatCnt=..PrepareSubjectItem(argSubjectID,argCtrls)
	Quit:SubCatCnt=0 $$$OK
	
	For tmpDate=argDateFrom:1:argDateTo {
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID))
			Quit:EpisodeID=""
			Continue:(argEpisodeID'="")&&(argEpisodeID'=EpisodeID)
			
			Set AdmInfo=$g(^PAADM(EpisodeID))
			Continue:$p(AdmInfo,"^",2)'="I"  //过滤非住院患者
			Continue:$p(AdmInfo,"^",20)="C" //过滤取消就诊
			Continue:((argStatus="I")&&($p(AdmInfo,"^",20)="D"))				//就诊状态过滤
			Continue:((argStatus="O")&&($p(AdmInfo,"^",20)'="D"))				//就诊状态过滤
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objAdm)
			Do objAdm.%Close()
			Continue:((objAdm.DepartmentID'=argLocID)&&(argLocID'="")) //过滤科室
			Continue:((objAdm.WardID'=argWardID)&&(argWardID'="")) //过滤病区
			Continue:objAdm.AdmType=""
			
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeIDType",objAdm.AdmType,EpisodeID)=""
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID)=0
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeIDStatus",objAdm.Status,EpisodeID)=""
			
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID,argSubjectID,ResultID))
				Quit:ResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
			}
		}
	}
	
	Set EpisodeID=""
	For {
		Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
		Quit:EpisodeID=""
		Continue:(argEpisodeID'="")&&(argEpisodeID'=EpisodeID)
		
		Set WardID=+$p($g(^PAADM(EpisodeID)),"^",70)
		Set RoomID=+$p($g(^PAADM(EpisodeID)),"^",69)
    	Set RoomDesc=$p($g(^PAROOM(+RoomID)),"^",2)
    	Set:$p(RoomDesc,"-",2)'="" RoomDesc=+$p(RoomDesc,"-",2)
    	Set BedID=$p($g(^PAADM(EpisodeID)),"^",73)
		Set BedDesc=$p($g(^PAWARD(+BedID,"BED",+$p(BedID,"||",2))),"^",1)
    	
    	Set RoomDesc=""
    	Set tmpRoomDesc=$p(BedDesc,"-",1)
    	Set $p(RoomDesc,"0",10-$l(tmpRoomDesc))=tmpRoomDesc
    	
		Set ^TMP(%ZIndex,%JIndex,%NIndex,"IndBedAdm",WardID_","_RoomDesc_","_BedDesc,EpisodeID)=""
		
		Set SubCatID=""
		For {
			Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
			Quit:SubCatID=""
			Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
		}
	}
	
	Set xBedDesc=""
	For {
		Set xBedDesc=$o(^TMP(%ZIndex,%JIndex,%NIndex,"IndBedAdm",xBedDesc))
		Quit:xBedDesc=""
		
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"IndBedAdm",xBedDesc,EpisodeID))
			Quit:EpisodeID=""
			
			Set FireCatCnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
			Continue:FireCatCnt=0
			Continue:((FireCatCnt<SubCatCnt)&&(Relation=1)) //没达到选择的子类数量--Relation=1时
			
			Set Data=..BuildCtrlData(EpisodeID)
			Continue:Data=""
			
			Set EvalInfo=##Class(DHCMed.CCService.Ctrl.Evaluation).GetEvalInfo(argSubjectID,EpisodeID)
			Set strFeedbackTimes=##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(EpisodeID,argSubjectID)
			Set TotalTimes=$p(strFeedbackTimes,"^",1)
			Set AcceptTimes=$p(strFeedbackTimes,"^",2)
			Set RejectTimes=$p(strFeedbackTimes,"^",3)
			Set NoResponseTimes=$p(strFeedbackTimes,"^",4)
			Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",EpisodeID,argSubjectID,""),-1)
			
			//触发项目
			Set FireItem=""
			Set SubCatID=""
			For {
				Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
				Quit:SubCatID=""
				
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
				Set SubCatDesc=objSubCat.ISCDesc
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID,"SubCat",SubCatID))
				Set IconCode=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID))
				Set:FireItem'="" FireItem=FireItem_$c(1)
				Set FireItem=FireItem_SubCatID_"^"_SubCatDesc_"^"_Cnt_"^"_IconCode
			}
			
			Set FireCatFlag=""
			If FireCatCnt>0 {
				Set $p(FireCatFlag,"★",FireCatCnt+1)=""
			}
			
			Set Data=Data_$lb(Score,"",EvalInfo,TotalTimes,AcceptTimes,RejectTimes,NoResponseTimes,LastSummaryID,FireItem,FireCatCnt,FireCatFlag)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByPaadmExecute ]
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

Query QryDepSubtotal(argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String) As %Query(ROWSPEC = "WardID:%String,Ward:%String:病房,Number:%String:数量")
{
}

ClassMethod QryDepSubtotalExecute(ByRef qHandle As %Binary, argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String) As %Status
{
	Set repid1=$I(^CacheTemp)
	Set ind1=1
	Set qHandle=$LB(0,repid1,0)
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryDepSubtotal"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set objResultSet=##class(%ResultSet).%New("DHCMed.CCService.IntegratedCtrl.Control"_":"_"QryByPaadm")
	Set ret=objResultSet.Execute(argStatus,argDateFrom,argDateTo,argLocID,argWardID,argCtrls,argSubjectID,Relation)
	Set %sc1=""
	For {
		Quit:objResultSet.Next(.%sc1)=0
		
		Set WardID=objResultSet.Get("WardID")
		Set EpisodeID=objResultSet.Get("Paadm")
		Set ^TMP(ZIndex,JIndex,NIndex,"WardID",+WardID,"EpisodeID",EpisodeID)=""
	}
	Do objResultSet.%Close()
	
	Set WardID=""
	For {
		Set WardID=$o(^TMP(ZIndex,JIndex,NIndex,"WardID",WardID))
		Quit:WardID=""
		
		Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
		Set:'$IsObject(objWard) objWard=##class(DHCMed.Base.PacWard).%New()
		Do objWard.%Close()
		
		Set EpisodeID="",Cnt=0
		For {
			Set EpisodeID=$o(^TMP(ZIndex,JIndex,NIndex,"WardID",WardID,"EpisodeID",EpisodeID))
			Quit:EpisodeID=""
			Set Cnt=Cnt+1
		}
		
		Set data=$lb("")
		Set $li(data,1)=WardID
		Set $li(data,2)=objWard.Descs
		Set:$li(data,2)="" $li(data,2)="其他"
		Set:$li(data,2)["-" $li(data,2)=$p($li(data,2),"-",2)
		Set $li(data,3)=Cnt
		Set ^CacheTemp(repid1,ind1)=data
		Set ind1=ind1+1
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
}

ClassMethod QryDepSubtotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDepSubtotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDepSubtotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDepSubtotalExecute ]
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
/// CreatDate：   2011-03-13
/// Description:  住院患者监控(包括:在院、出院)
/// Input：       Status(在院/出院),DateFrom(开始日期),DateTo(结束日期),WardID(病区),Ctrls(监控项目列表)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.IntegratedCtrl.Control","QryLocPatDtl","I","2013-05-01","2013-05-01","","8/9/10/24/15/16/19/23/","1","2")
Query QryLocPatDtl(argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String, argEpisodeID As %String = "") As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,InfTypes:%String,MRAdm:%String,DepID:%String,WardID:%String,Score:%String,CtrlDtl:%String,EvalInfo:%String,FeedbackTimes:%String,AcceptTimes:%String,RejectTimes:%String,NoReponseTimes:%String,LastSummaryID:%String,SubCatList:%String,FireCatCnt:%String,FireCatFlag:%String,RepLocID:%String,RepLocDesc:%String")
{
}

ClassMethod QryLocPatDtlExecute(ByRef qHandle As %Binary, argStatus As %String, argDateFrom As %String, argDateTo As %String, argLocID As %String, argWardID As %String, argCtrls As %String, argSubjectID As %String, Relation As %String, argEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argCtrls="" $$$OK
	Quit:(argStatus="") $$$OK
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:((argDateFrom="")||(argDateTo="")) $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryLocPatDtl"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set SubCatCnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItemBySubCatList(argSubjectID,argCtrls)
	Quit:SubCatCnt=0 $$$OK
	
	Set SubCatCnt=0
	For indList=1:1:$l(argCtrls,"/") {
		Set SubCatID=$p(argCtrls,"/",indList)
		Continue:SubCatID=""
		Set SubCatCnt=SubCatCnt+1
	}
	
	For xTransDate=argDateFrom:1:(argDateTo+10) {
		Set xWardID=0
		For {
			Set xWardID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xTransDate,xWardID))
			Quit:xWardID=""
			
			//病区过滤
			Set LocType=$p($g(^CTLOC(xWardID)),"^",13)
			Continue:LocType'="W"
			Continue:(argWardID'="")&&(argWardID'=xWardID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xTransDate,xWardID,xPaadm))
				Quit:xPaadm=""
				Continue:(argEpisodeID'="")&&(argEpisodeID'=xPaadm)
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"  //过滤非住院患者
				Continue:$p(AdmInfo,"^",20)="C"  //过滤取消就诊
				Continue:((argStatus="I")&&($p(AdmInfo,"^",20)="D"))	//就诊状态过滤
				Continue:((argStatus="O")&&($p(AdmInfo,"^",20)'="D"))	//就诊状态过滤
				
				//筛查监控结果
				Set xAimTransID=0
				For {
					Set xAimTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xTransDate,xWardID,xPaadm,xAimTransID))
					Quit:xAimTransID=""
					
					Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAimTransID)
					Continue:'$IsObject(objAimTrans)
					If objAimTrans.LinkID'="" {
						Set tmpAimTransID=objAimTrans.LinkID
						Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(tmpAimTransID)
						Continue:'$IsObject(objAimTrans)
					} Else {
						Set tmpAimTransID=objAimTrans.%Id()
					}
					Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID))
					Set ^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID)=""
					
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>argDateTo
					Continue:TransOutDate<argDateFrom
					
					For xActDate=TransInDate:1:TransOutDate {
						Continue:xActDate<argDateFrom
						Continue:xActDate>argDateTo
						Set xResultID=""
						For {
							Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xActDate,xPaadm,argSubjectID,xResultID))
							Quit:xResultID=""
							
							Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
							Continue:'$IsObject(objResult)
							Set ItemID=objResult.ItemId
							Continue:ItemID=""
							Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",ItemID))
							Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",ItemID))
							Set ^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID,"SubjectItemID",ItemID)=""
						}
					}
				}
			}
		}
	}
	
	Set xWardID=""
	For {
		Set xWardID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID))
		Quit:xWardID=""
		
		Set WardDesc=$p($g(^CTLOC(xWardID)),"^",2)
		Set:WardDesc="" WardDesc="其它"
		Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
		
		Set xPaadm=0
		For {
			Set xPaadm=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm))
			Quit:xPaadm=""
			
			//检查并与或的关系
			Set SubCatID=""
			For {
				Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID))
				Quit:SubCatID=""
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm))
				Set ItemID=0
				For {
					Set ItemID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID,"SubjectItemID",ItemID))
					Quit:ItemID=""
					Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat"))
				}
			}
			Set FireCatCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm))
			Continue:FireCatCnt<1
			Continue:((FireCatCnt<SubCatCnt)&&(Relation=1)) //没达到选择的子类数量--Relation=1时
			
			Set FireCatFlag=""
			If FireCatCnt>0 {
				Set $p(FireCatFlag,"★",FireCatCnt+1)=""
			}
			
			Set Data=..BuildCtrlData(xPaadm)
			Continue:Data=""
			
			Set EvalInfo=##Class(DHCMed.CCService.Ctrl.Evaluation).GetEvalInfo(argSubjectID,xPaadm)
			Set strFeedbackTimes=##class(DHCMed.CCService.Feedback.FeedBackService).GetFeedBackTimes(xPaadm,argSubjectID)
			Set TotalTimes=$p(strFeedbackTimes,"^",1)
			Set AcceptTimes=$p(strFeedbackTimes,"^",2)
			Set RejectTimes=$p(strFeedbackTimes,"^",3)
			Set NoResponseTimes=$p(strFeedbackTimes,"^",4)
			Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",xPaadm,argSubjectID,""),-1)
			
			//触发项目
			Set FireItem=""
			Set SubCatID=""
			For {
				Set SubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID))
				Quit:SubCatID=""
				
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
				Set SubCatDesc=objSubCat.ISCDesc
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Ward",xWardID,"EpisodeID",xPaadm,"SubCat",SubCatID))
				Set IconCode=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubCatIconCode",SubCatID))
				Set:FireItem'="" FireItem=FireItem_$c(1)
				Set FireItem=FireItem_SubCatID_"^"_SubCatDesc_"^"_Cnt_"^"_IconCode
			}
			
			Set Data=Data_$lb(Score,"",EvalInfo,TotalTimes,AcceptTimes,RejectTimes,NoResponseTimes,LastSummaryID,FireItem,FireCatCnt,FireCatFlag,xWardID,WardDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryLocPatDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocPatDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocPatDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocPatDtlExecute ]
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
