Class EPRservice.BOGetPaAdmDetail Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// craater:  yanghuiying
/// Debug:    d ##class(%ResultSet).RunQuery("EPRservice.BOGetPaAdmDetail","GetPaAdmList","2016-05-01","2016-05-05","INITIALIZED","940103","1411")
Query GetPaAdmList(Stdate As %Date, Enddate As %Date, APAAdmStatus As %String, AMedicareNo As %String, ctlocid As %String) As %Query(ROWSPEC = "PAPMIDR:%String,MedicareNo:%String,PAADMRowID:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmWard:%String,PAADMReason:%String,PADischgeDate:%String,PADischgeTime:%String,Warddesc:%String,EprDocStatusDesc:%String,EprNurStatusDesc:%String,EprPdfStatusDesc:%String,AdmDate:%String,DisDate:%String,mrEpisodeID:%String,MRVerItemsIDs:%String,StatusDesc:%String")
{
}

ClassMethod GetPaAdmListExecute(ByRef qHandle As %Binary, Stdate As %Date, Enddate As %Date, APAAdmStatus As %String, AMedicareNo As %String, ctlocid As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s MedicareNo = ""
	s PAADMRowID = ""
	//s ^tempyhy("1")=MedicareNo_","_APAAdmStatus_","_ctlocid
	if (AMedicareNo '="")
	{
		s PAPMIDR = $o(^PAPERi("Medicare1",AMedicareNo,""))
		//b "s"
		//s PAAdmType = "O"
		//d GetPAADMRowID
		s PAAdmType = "I"
		d GetPAADMRowID
		//s PAAdmType = "E"
		//d GetPAADMRowID
	}
	elseif (Stdate '= "")&(Enddate '= "")
	{
		s StDate = $zdh(Stdate,3),EndDate=$zdh(Enddate,3)
		for AdmDate = StDate:1:EndDate {
			s PAADMRowID = ""
			//w "按时间段查询",!
			for {	
				s PAADMRowID = $o(^PAADMi("DischDate",AdmDate,PAADMRowID))
				q:(PAADMRowID = "")
				s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
				continue:(AdmStatus '= "D")
				s StatusDescCode = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed(PAADMRowID)
				continue:(APAAdmStatus '= StatusDescCode)
				d IsArrivedQue
			}
		}			
	}
	
	Quit $$$OK
GetPAADMRowID
    for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM",PAAdmType,PAADMRowID))
		q:(PAADMRowID = "")
		s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)

		//不为D则就诊取消,A为在院
		continue:(AdmStatus '= "D")
		s StatusDescCode = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed(PAADMRowID)
		
		continue:(APAAdmStatus '= StatusDescCode)
		if (Stdate '= "")
		{
			s StDate = $zdh(Stdate,3)
			s AdmStdate = $P($g(^PAADM(PAADMRowID)),"^",17)
			
			continue:(AdmStdate < StDate)
		}
		if (Enddate '= "")
		{
			s EndDate=$zdh(Enddate,3)
			s AdmEndDate = $P($g(^PAADM(PAADMRowID)),"^",17)
			
			continue:(AdmEndDate > EndDate)
			
		}
		
		d IsArrivedQue
		
	}
	Quit	
IsArrivedQue
	//b "s"
	s mCurrRow = $g(^PAADM(PAADMRowID))
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	s isLocReview = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("LocReview")
	if (isLocReview = "Y")
	{
		q:(PAADMDepCode'=ctlocid)
	}
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	d outputrow
	Quit
	
outputrow

	s PAPMIDR = $p($g(mCurrRow),"^",1)
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	s MedicareNo = $P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
	//日期时间处理
	s PAPMIDOB = $p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	if (PAPMIDOB '= "")
	{
		s PAPMIDOB = $zd(PAPMIDOB,3)
	}
	s PAAdmTime = $p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "")
	{
		s PAAdmTime = $zt(PAAdmTime,3)
	}
	s PAAdmDate = $p($g(mCurrRow),"^",6)
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
	}
	s OutputAdmDate = PAAdmDate_" "_PAAdmTime
	
	s PADischgeDate=$P($g(^PAADM(PAADMRowID)),"^",17)
	if (PADischgeDate '= "")
	{
		s PADischgeDate = $zd(PADischgeDate,3)
	}
	s PADischgeTime=$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PADischgeTime '= "")
	{
		s PADischgeTime = $zt(PADischgeTime,3)
	}
	
	s PAADMReasonDR = $p($g(^PAADM(PAADMRowID,1)),"^",7)
	if (PAADMReasonDR '= "")
	{
		s PAADMReason = $p($g(^PAC("ADMREA",PAADMReasonDR)),"^",2)
	}
	else
	{
		s PAADMReason = "无"
	}
	s PAADMDocCode=$p($g(mCurrRow),"^",9)
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	
	//以下是获取患者当前病区
	s disWardDR = $P($g(^PAADM(PAADMRowID)),"^",70)
	if (disWardDR '= "")
	{
		s Wardcode =$p($g(^PAWARD(disWardDR)),"^",1)
		s Warddesc =$p($g(^PAWARD(disWardDR)),"^",2) 
	}
	else
	{
		s Wardcode = "无"
		s Warddesc = "无"
	}
	s EprStatus=##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(PAADMRowID)
	
	s EprDocStatus=+$p(EprStatus,"^",2)
	s EprDocStatusDesc=$s(EprDocStatus=1:"是",1:"否")
	s EprNurStatus=+$p(EprStatus,"^",1)
	s EprNurStatusDesc=$s(EprNurStatus=1:"是",1:"否")
	s EprPdfStatus=+$p(EprStatus,"^",3)
	//[['0','未审核'],['DEPTREVIEWED','审核通过'],['INITIALIZED','科室审核退回'],['2','病案室审核退回']]
	if ((APAAdmStatus = "INITIALIZED") || (APAAdmStatus = "2"))
	{
		s ret1 = ##class(DHCEPRFS.BL.BLMRLog).CheckActionAndStatus(PAADMRowID,"QCBACK")
	
	
		//s ret2 = ##class(DHCEPRFS.BL.BLMRLog).CheckActionAndStatus(PAADMRowID,"DEPTQCBACK")
		//判断科室质控退回后是否有医生提交
		//取最后一次科室质控退回
		s tmpRowID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxAction"," DHC"," "_PAADMRowID," DOCTOR", " BACK",""),-1)
		//没有科室质控退回，那么是否退回走病案室退回的判断
		if ((tmpRowID = "") &&($p(ret1,"^",3) = "0"))
		{
			s EprDocStatus= 0
			s EprDocStatusDesc = "否"
		}
		else
		{
			//有科室质控退回
			
			s objAdmMRStatusLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(tmpRowID)
			s backDate = objAdmMRStatusLog.ChangeDate
			s backTime = objAdmMRStatusLog.ChangeTime
			
			//医生最后一次提交
			s admMRStatusID = ""
			s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_PAADMRowID,admMRStatusID))
			//存在说明有提交过
			if (admMRStatusID '= "") 
			{
				//存在，取医生是否提交
				s objAdmMRStatus = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMRStatusID)
				s flagMRCompletion = objAdmMRStatus.FlagMRCompletion
				if ((flagMRCompletion '= "0") && (flagMRCompletion '= "") && (flagMRCompletion '= $c(0)))
				{
					//医生提交过
					//检查质控退回是否在医生提交之后
			
					
					//医生提交日期时间
					s commitDate = objAdmMRStatus.FlagMRCompletionDate
					s commitTime = objAdmMRStatus.FlagMRCompletionTime	
		
					s:(backDate > commitDate) ret3 = "0"
					s:((backDate = commitDate) && (backTime > commitTime)) ret3 = "0"
					s ret3 = "1"
				}	
			}
		
			//只要最后一个科室退回或者最后一个病案室退回后没有医生提交，则医生提交为否
			if (($p(ret1,"^",3) = "0") || (ret3 = "0")) 
			{
				s EprDocStatus= 0
				s EprDocStatusDesc = "否"
			}
		}
	}
	s DisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(PAADMRowID)
	s DisDate = $p(DisDateTime,",",1)
	s DisTime = $p(DisDateTime,",",2)
	s DisDate=$zd(DisDate,3)_" "_$zt(DisTime,3)
	
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAADMRowID, "DHC")
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"0")
	//s MRVerItemsIDs = ##class(DHCEPRFS.BL.BLMRVerItem).GetAllByVersionString(mrVersionID)
	s SchemeID = ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDByDefault("VIEW")
    s MRVerItemsIDs = ##class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeIDString(SchemeID,mrVersionID)
    
    //医生未提交 或 护士未提交 未 “否”
    if ((EprDocStatus = 0) || (EprNurStatus = 0))
    {
		s EprPdfStatusDesc="否"
	}
	else
	{
		//医生提交、护士提交、PDF未生成
		if ((EprDocStatus = 1) && (EprNurStatus = 1) && (EprPdfStatus '= 1))
		{
			s EprPdfStatusDesc="正在生成"
		}
		else	//((EprDocStatus = 1) && (EprNurStatus = 1) && (EprPdfStatus = 1)). EprPdfStatus = 1 时需要判断
		{
			s DocStatusDT=0	//护士提交时间
			s NurStatusDT=0	//护士提交时间
			s CommitDT=0	//提交时间
			s PdfStatusDT=0	//pdf生成时间
			s BackStatusDT=0	//退回时间
			s entity = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusEntity(PAADMRowID, "DHC")
			if (entity = "")
			{
				s EprPdfStatusDesc = "否"
			}
			else
			{
				
				s DocStatusDT=entity.FlagMRCompletionDate*100000+entity.FlagMRCompletionTime	//取医生完成时间
				s NurStatusDT=entity.FlagFinalAccountDate*100000+entity.FlagFinalAccountTime	//取护士完成时间
				
				s mrLogID = ##Class(DHCEPRFS.BL.BLMRLog).GetMRLogID(mrEpisodeID)
				if (mrLogID="")
				{
					s EprPdfStatusDesc = "否"
				}
				else
				{
					s QCBackDT=0
					s DEPTQCBack=0
					
					s mrLogDetailID=..GetLastActionID(mrLogID,"CREATE")
					if (mrLogDetailID="")
					{ 	s PdfStatusDT=0 }
					else
					{	s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDetailID)
						s PdfStatusDT=objMRLogDetail.ActDate*100000+objMRLogDetail.ActTime	
					}
					
					s mrLogDetailID=..GetLastActionID(mrLogID,"QCBACK")
					if (mrLogDetailID="")
					{ 	s QCBackDT=0 }
					else
					{	
						s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDetailID)
						s QCBackDT=objMRLogDetail.ActDate*100000+objMRLogDetail.ActTime	
					}
					
					s mrLogDetailID=..GetLastActionID(mrLogID,"DEPTQCBACK")
					if (mrLogDetailID="")
					{ 	s DEPTQCBack=0 }
					else
					{	s objMRLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_mrLogDetailID)
						s DEPTQCBack=objMRLogDetail.ActDate*100000+objMRLogDetail.ActTime	
					}
					//退回时间
					if (QCBackDT>DEPTQCBack)
					{	s BackStatusDT=QCBackDT }
					else
					{	s BackStatusDT=DEPTQCBack }
					
					//取提交时间
					if (DocStatusDT>NurStatusDT)
					{	s CommitDT=DocStatusDT }
					else
					{	s CommitDT=NurStatusDT }
					
					if (BackStatusDT>PdfStatusDT)	//退回状态
					{
						if (CommitDT>BackStatusDT)
						{	s EprPdfStatusDesc= "正在生成" }
						else
						{	s EprPdfStatusDesc= "否" }
					}
					else
					{
						if (CommitDT>PdfStatusDT)
						{	s EprPdfStatusDesc= "正在生成" }
						else
						{	s EprPdfStatusDesc= "是" }
					}
				}
			}
		}
	}

	s StatusDescCode = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed(PAADMRowID)
	
	if (StatusDescCode="0") {s StatusDesc = "未审核"}
	if (StatusDescCode="DEPTREVIEWED") {s StatusDesc = "审核通过"}
	if (StatusDescCode="INITIALIZED") {s StatusDesc = "科室审核退回"}
	if (StatusDescCode="2") {s StatusDesc = "病案室审核退回"}

	
	set ^CacheTemp(repid,ind) = $LB(PAPMIDR,MedicareNo,PAADMRowID,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmWard,PAADMReason,PADischgeDate,PADischgeTime,Warddesc,EprDocStatusDesc,EprNurStatusDesc,EprPdfStatusDesc,OutputAdmDate,DisDate,mrEpisodeID,MRVerItemsIDs,StatusDesc)
	set ind = ind + 1
	Quit
}

ClassMethod GetPaAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

//取最后一次Action对应的MRLogID

ClassMethod GetLastActionID(AMRLogID As %String, AAction As %String) As %String
{
	//b "s"
	s mrLogDetailID=""
	s mrLogDetailID=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMainAction",AMRLogID," "_AAction,mrLogDetailID),-1)
	q mrLogDetailID
}

}
