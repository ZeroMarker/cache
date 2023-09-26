///  名称：		EMRservice.BL.BLPrintToolService
///  描述：		批量打印BL层
///  编写者：	yejian
///  编写时间：	2018-4-3
///  配置：
/// 			(01)不打印的门诊病历DocID、不打印的急诊病历DocID
/// 			(02)科室属于哪个院区
Class EMRservice.BL.BLPrintToolService Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

ClassMethod IsEnableAdmType(AdmType, AEpisodeID) As %String
{
	q:(AdmType = "O") "1"
	q:(AdmType = "E")&&(..IsEPDisch(AEpisodeID) = "1") "1"
	q "0"
}

ClassMethod IsEPDisch(AEpisodeID As %String) As %String
{
	
	//b "s"
	q:(AEpisodeID = "0") "0"
	
	//User.DHCADMVisitStatus
	s statusID  =$O(^DHCADMVisitStatus("0","PAADM",AEpisodeID,""),-1)
	q:(statusID = "") "0"
	
	s scID = $p($g(^DHCADMVisitStatus(statusID)),"^",2)
	q:(scID= "") "0"
	
	s statusCode = $p($g(^DHCPACVisitStatus(scID)),"^",1)
	q:(statusCode = "Discharge") "1"
	
	q "0"
}

ClassMethod NeedPrint(ADocID As %String) As %String
{
	q:(ADocID = "302") "0"	//病假证明 病案室不归档
	q:(ADocID = "307") "0"  //诊断证明 病案室不归档
	q:(ADocID = "635") "0"  //药学咨询 病案室不归档
	q "1"
}

ClassMethod GetPrintDescByRoleCode(AUserRoleCode As %String) As %String
{
	q:(AUserRoleCode = "MRPRINT") "病案室已打印"
	q:(AUserRoleCode = "INSUPRINT") "商保已打印"
	q "已打印"
}

ClassMethod GetUnPrintDescByRoleCode(AUserRoleCode As %String) As %String
{
	q:(AUserRoleCode = "MRPRINT") "病案室未打印"
	q:(AUserRoleCode = "INSUPRINT") "商保未打印"
	q "未打印"
}

/// w ##Class(EMRservice.BL.BLPrintToolService).HasCASignRecord(23086306)
ClassMethod HasCASignRecord(AEpisodeID As %String) As %String
{
	s hasSignRecord = 0
	
	s ADocID = ""
	for {
		s ADocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID))
		q:(ADocID = "")
		
		s docID = $e(ADocID,2,$L(ADocID))
		
		s needPrint = ..NeedPrint(docID)
		continue:(needPrint = "0")
		
		s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID,""))
		continue:(rowId = "")
		
		s instDataID = "", instTitle = "", instObj = ""
		s isAllCASign = "1"
		
		s happenDate = ""
		for {
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate))
			q:(happenDate = "")
			
			s happenTime = ""
			for {	
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime))
				q:(happenTime = "")	
				
				s childsub = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime,""))
				q:(childsub = "")
				
				s instID = rowId_"||"_childsub
				
				s instObj = ##Class(EMRinstance.InstanceData).%OpenId(instID)
				continue:(instObj = "")
				
				s signID="",isCASign = "0"
				for {
				    //过滤无有效签名或无签名病历
      				s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_instID, signID))
      				q:(signID="")
     				s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
     				continue:(sign.isSignValid '= "1")
     				continue:(sign.Type '= "CA")
     				continue:(sign.SignID = "")||(sign.SignID = $c(0))
     				
     				s isCASign = "1"
     				quit
				}
				
				if (isCASign '= "1")
				{
					s isAllCASign = "0"
				}
				
				q:(isAllCASign = "0")
				
				s instDataID = instID
			}
			
			q:(isAllCASign = "0")
		}
		continue:(isAllCASign = "0")||(instDataID = "")
		
		s hasSignRecord = "1"
	}
	
	q hasSignRecord
}

/// w ##Class(EMRservice.BL.BLPrintToolService).HasUnprintCASignRecord(23086306)
/// w ##Class(EMRservice.BL.BLPrintToolService).HasUnprintCASignRecord(23085077)
ClassMethod HasUnprintCASignRecord(AEpisodeID As %String) As %String
{
	s hasUnprintSignRecord = 0
	
	s ADocID = ""
	for {
		s ADocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID))
		q:(ADocID = "")
		
		s docID = $e(ADocID,2,$L(ADocID))
		
		s needPrint = ..NeedPrint(docID)
		continue:(needPrint = "0")
		
		s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID,""))
		continue:(rowId = "")
		
		s instDataID = "", instTitle = "", instObj = ""
		s isAllCASign = "1", hasPrinted = "1"
		
		s happenDate = ""
		for {
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate))
			q:(happenDate = "")
			
			s happenTime = ""
			for {	
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime))
				q:(happenTime = "")	
				
				s childsub = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime,""))
				q:(childsub = "")
				
				s instID = rowId_"||"_childsub
				
				s instObj = ##Class(EMRinstance.InstanceData).%OpenId(instID)
				continue:(instObj = "")
				
				s signID="",isCASign = "0"
				for {
				    //过滤无有效签名或无签名病历
      				s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_instID, signID))
      				q:(signID="")
     				s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
     				continue:(sign.isSignValid '= "1")
     				continue:(sign.Type '= "CA")
     				continue:(sign.SignID = "")||(sign.SignID = $c(0))
     				
     				s isCASign = "1"
     				quit
				}
				
				if (isCASign '= "1")
				{
					s isAllCASign = "0"
				}
				
				q:(isAllCASign = "0")
				
				s instDataID = instID
			}
			
			q:(isAllCASign = "0")
		}
		continue:(isAllCASign = "0")||(instDataID = "")
		
		s printRowID = ""
		s printRowID = $o(^DHCEMRI.PrintToolRecordI("IdxInstanceDataID"," "_instDataID,printRowID))
		if (printRowID = "")
		{
			s hasPrinted = "0"
			s hasUnprintSignRecord = "1"
		}
		
		q:(hasUnprintSignRecord = "1")
	}
	
	q hasUnprintSignRecord
	
	/*
	s ADocID = ""
	for {
		s ADocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID, ADocID))
		q:(ADocID = "")
		
		s docID = $e(ADocID,2,$L(ADocID))
		
		s needPrint = ..NeedPrint(docID)
		continue:(needPrint = "0")
		
		s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID, ADocID,""))
		continue:(rowId = "")
		
		s happenDate = ""
		for {
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate))
			q:(happenDate = "")
			s happenTime = ""
			for {	
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime))
				q:(happenTime = "")	
				s num = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime,""))
				q:(num = "")
				s instanceid = rowId_"||"_num
				
				//b "s"
				s status = ##Class(EMRservice.BL.BLEMRLogs).GetEMRStatus(AEpisodeID,docID,num)	
				s hasSign = ($zcvt(status,"U") [ "CHECKED")
				if hasSign {
					s printRowID = $o(^DHCEMRI.PrintToolRecordI("IdxInstanceDataID"," "_instanceid,""))
					if (printRowID = "")
					{
						s hasUnprintSignRecord = "1"
					}
				}
				
				q:(hasUnprintSignRecord = "1")
			}
			
			q:(hasUnprintSignRecord = "1")
		}
		
		q:(hasUnprintSignRecord = "1")
	}
	
	q hasUnprintSignRecord
	*/
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetOPPatList","2019-03-27","2019-03-28","","","","","MRPRINT")
Query GetOPPatList(AStartDate As %String, AEndDate As %String, ALocID As %String, AHospitalID, APatTypeID, AHasRecordNo, AUserRoleCode, AInsuranceTypeID As %String = "") As %Query(ROWSPEC = "PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate")
{
}

ClassMethod GetOPPatListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String, AHospitalID, APatTypeID, AHasRecordNo, AUserRoleCode, AInsuranceTypeID As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s repid2 = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	set amdateStart = $zdh(AStartDate,3)
	set amdateEnd = $zdh(AEndDate,3)
	
	for paadmdate = amdateStart:1:amdateEnd
	{
		set admrowid =""
		for {
			set admrowid = $o(^PAADMi("PAADM_AdmDate",paadmdate,admrowid))
			quit:(admrowid="")

			s AdmType=$p(^PAADM(admrowid),"^",2)
			//continue:(AdmType '= "O")
			continue:(..IsEnableAdmType(AdmType,admrowid) = "0")
			
			s AdmStatus=$P($g(^PAADM(admrowid)),"^",20)
			continue:(AdmStatus = "C")	
			
			s AdmDate = $P($G(^PAADM(admrowid)),"^",6)
			
			//处理特殊就诊
			s IsNeedModifyPat=##class(EMRinstance.FirstPage.PatientModifyData).IsNeedModifyPat(admrowid)
			continue:(IsNeedModifyPat=1)
			
			s AdmDeptID = $P($g(^PAADM(admrowid)),"^",4)
			if (ALocID '= "")
			{
				continue:(ALocID '= AdmDeptID)
			}
			
			if (AHospitalID '= "")
			{
				s isBelong = ##class(EMRmeta.MRHospLoc).IsBelongTo(AHospitalID, AdmDeptID)
				continue:(isBelong = "0")
			}
			
			if (APatTypeID '= "")
			{
				s admResonDR = $p($g(^PAADM(admrowid,1)),"^",7)
				continue:(APatTypeID '= admResonDR)
			}
			
			//校验病案号
			s Papmi = $p($g(^PAADM(admrowid)),"^",1)
			s MedicareNo = $p($g(^PAPER(Papmi,"PAT",1)),"^",22)
			if (AHasRecordNo = "1")
			{
				continue:(MedicareNo = "")||($L(MedicareNo) '= 7)
			}
			
			//校验保险类型
			if (AInsuranceTypeID '= "")
			{
				s isInsuOK = 0
				s childSub = ""
				for {
					s childSub = $O(^PAPER(Papmi,"INS",childSub))
					q:(childSub = "")
					
					s data = $g(^PAPER(Papmi,"INS",childSub))
					s dateFrom = $p(data,"^",1)
					continue:(AdmDate < dateFrom)
					s dateTo = $p(data,"^",2)
					continue:(dateTo '= "")&&(AdmDate )
					s insuDR = $p(date,"^",3)
					continue:(AInsuranceTypeID '= insuDR)
					
					s isInsuOK = 1
					quit
				}
				
				continue:(isInsuOK = 0)
			}
			
			//检验是否有未签名病历
			s hasSignRecord = ..HasCASignRecord(admrowid)
			continue:(hasSignRecord = "0")
			
			s (PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate) = ""
			
			s adminfo = ..GetAdmInfo(admrowid)
			
			s MedicareNo = $lg(adminfo,3)
			if (MedicareNo = "")||($L(MedicareNo) '= 7)
			{
				s MedicareNo = "YYYYYYY"
			}
			s one = $e(MedicareNo,1,3)
			s two = $e(MedicareNo,4,5)
			s thr = $e(MedicareNo,6,7)
			
			s ^CacheTemp(repid2,thr,two,one,admrowid) = adminfo	//$LB(EpisodeID,RegNo,RecordNo,PatName,AdmDate,DisDate,DeptDesc,ChargeDoc,PrintDoc01Stat,PrintDoc02Stat,PrintDoc03Stat,PrintDoc04Stat,PrintDoc05Stat)
		}
	}
	
	
	
	s thr = ""
	for {
		s thr = $O(^CacheTemp(repid2,thr))
		q:(thr = "")
		
		s two = ""
		for {
			s two = $O(^CacheTemp(repid2,thr,two))
			q:(two = "")
		
			s one = ""
			for {
				s one = $O(^CacheTemp(repid2,thr,two,one))
				q:(one = "")
				
				s admrowid = ""
				for {
					s admrowid = $O(^CacheTemp(repid2,thr,two,one,admrowid))
					q:(admrowid = "")
				
					s ^CacheTemp(repid,ind) = $g(^CacheTemp(repid2,thr,two,one,admrowid))
					s ind = ind +1
				}
			}
		}	
	}
	
	Quit $$$OK
}

ClassMethod GetOPPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPPatListExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOPPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPPatListExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetOPPatListByCondition","刘静","","","")
/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetOPPatListByCondition","","","42459295","")
Query GetOPPatListByCondition(APatientName, AMedicareNo, ARegNo, ACardNo, AUserRoleCode) As %Query(ROWSPEC = "PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate")
{
}

ClassMethod GetOPPatListByConditionExecute(ByRef qHandle As %Binary, APatientName, AMedicareNo, ARegNo, ACardNo, AUserRoleCode) As %Status
{
	s repid = $i(^CacheTemp)
	s repid2 = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s patList = ""
	if (AMedicareNo '= "")
	{
		s patList = ..GetPapmiListByRecordNo(AMedicareNo)
	}
	elseif (ARegNo '= "")
	{
		s patList = ..GetPapmiListByPapmiNo(ARegNo)
	}
	elseif (ACardNo '= "")
	{
		s patList = ..GetPapmiListByCardNo(ACardNo)
	}
	elseif (APatientName '= "")
	{
		s patList = ..GetPapmiListByName(APatientName)
	}
	q:(patList = "") $$$OK
	
	//b
	s patCount = $LL(patList)
	for idxPat = 1:1:patCount
	{
		s patID = $lg(patList,idxPat)
		continue:(patID = "")
		
		//w !,idxPat_","_patID
		
		s APapmiDR = patID
		
		s type = ""
		for {
			s type = $O(^PAPERdr(APapmiDR,"ADM",type))
			q:(type = "")
		
			continue:(type = "I")
			
			s admID = ""
			for {
				s admID = $O(^PAPERdr(APapmiDR,"ADM",type,admID))
				q:(admID = "")
			
				s admrowid = admID
				
				s AdmType=$p(^PAADM(admrowid),"^",2)
				//continue:(AdmType '= "O")
				continue:(..IsEnableAdmType(AdmType, admrowid) = "0")
			
				s AdmStatus=$P($g(^PAADM(admrowid)),"^",20)
				continue:(AdmStatus = "C")	
			
				//处理特殊就诊
				
				s IsNeedModifyPat=##class(EMRinstance.FirstPage.PatientModifyData).IsNeedModifyPat(admrowid)
				continue:(IsNeedModifyPat=1)
			
				//校验病案号
				s Papmi = $p($g(^PAADM(admrowid)),"^",1)
				s MedicareNo = $p($g(^PAPER(Papmi,"PAT",1)),"^",22)
				//continue:(MedicareNo = "")||($L(MedicareNo) '= 7)
			
				//检验是否有未签名病历
				s hasSignRecord = ..HasCASignRecord(admrowid)
				continue:(hasSignRecord = "0")
			
				s (PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate) = ""
			
				s adminfo = ..GetAdmInfo(admrowid)
			
				s MedicareNo = $lg(adminfo,3)
				if (MedicareNo = "")||($L(MedicareNo) '= 7)
				{
					s MedicareNo = "YYYYYYY"
				}
				s one = $e(MedicareNo,1,3)
				s two = $e(MedicareNo,4,5)
				s thr = $e(MedicareNo,6,7)
			
				s ^CacheTemp(repid2,thr,two,one,admrowid) = adminfo	//$LB(EpisodeID,RegNo,RecordNo,PatName,AdmDate,DisDate,DeptDesc,ChargeDoc,PrintDoc01Stat,PrintDoc02Stat,PrintDoc03Stat,PrintDoc04Stat,PrintDoc05Stat)
			}
		}
	}
	
	
	s thr = ""
	for {
		s thr = $O(^CacheTemp(repid2,thr))
		q:(thr = "")
		
		s two = ""
		for {
			s two = $O(^CacheTemp(repid2,thr,two))
			q:(two = "")
		
			s one = ""
			for {
				s one = $O(^CacheTemp(repid2,thr,two,one))
				q:(one = "")
				
				s admrowid = ""
				for {
					s admrowid = $O(^CacheTemp(repid2,thr,two,one,admrowid))
					q:(admrowid = "")
				
					s ^CacheTemp(repid,ind) = $g(^CacheTemp(repid2,thr,two,one,admrowid))
					s ind = ind +1
				}
			}
		}	
	}
	
	Quit $$$OK
}

ClassMethod GetOPPatListByConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPPatListByConditionExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOPPatListByConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPPatListByConditionExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAdmInfo(argEpisodeID As %String) As %String
{
	//PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate
	
	q:(argEpisodeID = "") ""
	
	s data = $g(^PAADM(argEpisodeID))
	
	s Papmi = $p(data,"^",1)
	s RegNo = $p($g(^PAPER(Papmi,"PAT",1)),"^",1)
	//s MedicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(argEpisodeID)
	s MedicareNo = $p($g(^PAPER(Papmi,"PAT",1)),"^",22)
	s PAPMIName = $p($g(^PAPER(Papmi,"ALL")),"^",1)	
	s PAPMIGender = ""
	
	s PatientID = Papmi
	s EpisodeID = argEpisodeID  
	
	s PAAdmDate = $p(data,"^",6)
	if (PAAdmDate '= "") 
	{	s PAAdmDate = $zd(PAAdmDate,3) }
	else
	{	s PAAdmDate = " "}
	
	s deptName = ""
	s admdeptid =$p($g(data),"^",4)
	if (admdeptid '= "")
	{
		s PAAdmDept = $p($g(^CTLOC(admdeptid)),"^",2)
	}
	
	s docCode = "", docName = ""
	s admdocdr = $P(data,"^",9)
	if (admdocdr '= "") 
	{	
		s docCode=$p($g(^CTPCP(admdocdr,1)),"^",1)
		s docName=$p($g(^CTPCP(admdocdr,1)),"^",2)
	}
	
	q $lb(PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate)
}

/// Desc:	根据姓名获取登记rowid列表
/// Debug:	s list = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByName("田永温")
ClassMethod GetPapmiListByName(AName As %String) As %List
{
	s retList = ""
	
	q:(AName = "") retList
	
	s upName = $zcvt(AName,"u")
	
	s papmiID = ""
	for {
		s papmiID = $O(^PAPERi("PAPER_PatName",upName,papmiID))
		q:(papmiID = "")
		
		s retList = retList_$lb(papmiID)
	}
	
	q retList
}

/// Desc:	根据登记号获取登记rowid列表
/// Debug:	s list = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByPapmiNo("00000005")
ClassMethod GetPapmiListByPapmiNo(APapmiNo As %String) As %List
{
	s retList = ""
	
	q:(APapmiNo = "") retList
	
	s upPapmiNo = $zcvt(APapmiNo,"u")
	
	s papmiID = ""
	for {
		s papmiID = $O(^PAPERi("PAPMI_PatNo",upPapmiNo,papmiID))
		q:(papmiID = "")
		
		s retList = retList_$lb(papmiID)
	}
	
	q retList
}

/// Desc:	根据登记号获取登记rowid列表
/// Debug:	s list = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByPapmiNo("00000005")
ClassMethod GetPapmiListByRecordNo(ARecordNo As %String) As %List
{
	s retList = ""
	
	q:(ARecordNo = "") retList
	
	s ARecordNo = $zcvt(ARecordNo,"u")
	
	s papmiID = ""
	for {
		s papmiID = $O(^PAPERi("Medicare1",ARecordNo,papmiID))
		q:(papmiID = "")
		
		s retList = retList_$lb(papmiID)
	}
	
	q retList
}

/// Desc:	根据登记号获取登记rowid列表
/// Debug:	s list = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiListByCardNo("00000005")
ClassMethod GetPapmiListByCardNo(ACardNo As %String) As %List
{
	s retList = ""
	
	q:(ACardNo = "") retList
	
	s upCardNo = $zcvt(ACardNo,"u")
	
	s CFRowId = ""
	for {
		s CFRowId = $o(^DHCCARDi("CF",0,"CardNo",upCardNo,CFRowId),-1)
		q:(CFRowId = "")
		s papmiID = $p($g(^DHCCARD("CF",CFRowId)),"^",4)
		q:(papmiID = "")
		//s CardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
		//continue:(CardNo '= ACardNo)
		s retList = retList_$lb(papmiID)
	}
		
		q retList
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetUnprintOPAdmByInbound","2018-07-26","2018-07-26","bingan0001")
Query GetUnprintOPAdmByInbound(AStartDate As %String, AEndDate As %String, AClientGuid As %String, AUserRoleCode) As %Query(ROWSPEC = "PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate")
{
}

ClassMethod GetUnprintOPAdmByInboundExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AClientGuid As %String, AUserRoleCode) As %Status
{
	s repid = $i(^CacheTemp)
	s repid2 = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	set admDateStart = $zdh(AStartDate,3)
	set admDateEnd = $zdh(AEndDate,3)
	set clientGUID = $zcvt(AClientGuid,"u")
	set printStatus = "1"
	
	for paadmdate = admDateStart:1:admDateEnd
	{
		set mrboundID =""
		for 
		{
			set mrboundID = $o(^DHCEMRI.MRInboundI("IdxClientGUID"," "_clientGUID,paadmdate," "_printStatus, mrboundID))
			q:(mrboundID = "")

			s obj = ##Class(EMRinstance.MRInbound).%OpenId(mrboundID)
			continue:(obj = "")
			
			continue:(obj.PrintStatus '= "1")
			
			//b "s"
			
			s obj.PrintStatus = "2"
			d obj.%Save()
			
			continue:(obj.MRRecordNo = "")
			
			s patID = $O(^PAPERi("Medicare1",$zcvt(obj.MRRecordNo,"u"),""))
			continue:(patID = "")
			
			s tMedicareNo = $p($g(^PAPER(patID,"PAT",1)),"^",22)
			continue:(tMedicareNo = "")||($L(tMedicareNo) '= 7)
			
			s admList = ..GetUnprintOPAdm(patID)
			continue:(admList = "")
			
			s count = $LL(admList)
			for i = 1:1:count
			{
				s admrowid = $lg(admList,i)
				
				s (PatientID,EpisodeID,MedicareNo,RegNo,PAPMIName,PAPMIGender,PAAdmDept,PAAdmDate) = ""
				s adminfo = ..GetAdmInfo(admrowid)
				s one = $e(tMedicareNo,1,3)
				s two = $e(tMedicareNo,4,5)
				s thr = $e(tMedicareNo,6,7)		
				s ^CacheTemp(repid2,thr,two,one,admrowid) = adminfo	//$LB(EpisodeID,RegNo,RecordNo,PatName,AdmDate,DisDate,DeptDesc,ChargeDoc,PrintDoc01Stat,PrintDoc02Stat,PrintDoc03Stat,PrintDoc04Stat,PrintDoc05Stat)
			}
		}
	}
	
	
	
	s thr = ""
	for {
		s thr = $O(^CacheTemp(repid2,thr))
		q:(thr = "")
		
		s two = ""
		for {
			s two = $O(^CacheTemp(repid2,thr,two))
			q:(two = "")
		
			s one = ""
			for {
				s one = $O(^CacheTemp(repid2,thr,two,one))
				q:(one = "")
				
				s admrowid = ""
				for {
					s admrowid = $O(^CacheTemp(repid2,thr,two,one,admrowid))
					q:(admrowid = "")
				
					s ^CacheTemp(repid,ind) = $g(^CacheTemp(repid2,thr,two,one,admrowid))
					s ind = ind +1
				}
			}
		}	
	}
	
	Quit $$$OK
}

ClassMethod GetUnprintOPAdmByInboundClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnprintOPAdmByInboundExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnprintOPAdmByInboundFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnprintOPAdmByInboundExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(EMRservice.BL.BLPrintToolService).GetUnprintOPAdm("7589164")
/// w ##Class(EMRservice.BL.BLPrintToolService).GetUnprintOPAdm("483140")
ClassMethod GetUnprintOPAdm(patID As %String) As %List
{
	//b "s"
	
	q:(patID = "") ""
	
	s MedicareNo = $p($g(^PAPER(patID,"PAT",1)),"^",22)
	q:(MedicareNo = "")||($L(MedicareNo) '= 7) ""
	
	s ret = ""
	
	s admrowid = ""
	for {
		//b "s"
		s admrowid = $O(^PAPERdr(patID,"ADM","O",admrowid))
		q:(admrowid = "")
		
		if (admrowid = "23085077") b "s"
		
		s AdmType = $p(^PAADM(admrowid),"^",2)
		//continue:(AdmType '= "O")
		continue:(..IsEnableAdmType(AdmType, admrowid)="0")
		s AdmStatus=$P($g(^PAADM(admrowid)),"^",20)
		continue:(AdmStatus = "C")	
		
		//检验是否有未签名病历
		s hasSignRecord = ..HasUnprintCASignRecord(admrowid)
		continue:(hasSignRecord = "0")
		
		s ret = ret_$lb(admrowid)
	}
	
	q ret
}

/// Desc:	通过日期获取已书写门诊病历的患者列表
/// Debug:	d ##class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetAllInstIDByEpisodeID","23086520^23086466^23086500","1")
Query GetAllInstIDByEpisodeID(AEpisodeIDList As %String, AUserRoleCode) As %Query(ROWSPEC = "EpisodeID:%String,InstanceID:%String,DocumentType:%String,Title:%String,ChartItemType:%String,SPageNum:%String,EPageNum:%String,PrintType:%String")
{
}

ClassMethod GetAllInstIDByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeIDList As %String, AUserRoleCode) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s admCount = $L(AEpisodeIDList,"^")
 	for admIndex = 1:1:admCount
 	{
	 	s AEpisodeID = $p(AEpisodeIDList,"^",admIndex)
	 	continue:(AEpisodeID = "")
	 	
	 	s ADocID = ""
		for {
			s ADocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID))
			q:(ADocID = "")
		
			s docID = $e(ADocID,2,$L(ADocID))
		
			s needPrint = ..NeedPrint(docID)
			continue:(needPrint = "0")
		
			s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID,""))
			continue:(rowId = "")
		
			s instDataID = "", instTitle = "", instObj = ""
			s isAllCASign = "1"
		
			s happenDate = ""
			for {
				s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate))
				q:(happenDate = "")
			
				s happenTime = ""
				for {	
					s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime))
					q:(happenTime = "")	
				
					s childsub = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime,""))
					q:(childsub = "")
				
					s instID = rowId_"||"_childsub
				
					s instObj = ##Class(EMRinstance.InstanceData).%OpenId(instID)
					continue:(instObj = "")
				
					s signID="",isCASign = "0"
					for {
					    //过滤无有效签名或无签名病历
	      				s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_instID, signID))
	      				q:(signID="")
	     				s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
	     				continue:(sign.isSignValid '= "1")
	     				continue:(sign.Type '= "CA")
	     				continue:(sign.SignID = "")||(sign.SignID = $c(0))
     				
	     				s isCASign = "1"
	     				quit
					}
				
					if (isCASign '= "1")
					{
						s isAllCASign = "0"
					}
				
					q:(isAllCASign = "0")
				
					s instDataID = instID
					if (instTitle = "")
					{	s instTitle = instObj.Title}
					else
					{	s instTitle = instTitle_"+"_instObj.Title}
				}
			
				q:(isAllCASign = "0")
			}
			continue:(isAllCASign = "0")||(instDataID = "")
		
			s DocumentType = instObj.TheECRecord.DocumentType 
	        s ChartItemType = instObj.TheECRecord.ChartItemType
	        s Title = instTitle
	        s SPageNum = instObj.StartPageNum
	        s EPageNum = instObj.EndPageNum
	        s PrintType = ..GetUnPrintDescByRoleCode(AUserRoleCode)
	        s printRowID = ..GetPrintRecordIDByRoleCode(instDataID, AUserRoleCode)
			if printRowID '= ""
			{
				s PrintType = ..GetPrintDescByRoleCode(AUserRoleCode)
			}
			
        
		    s ^CacheTemp(repid,ind) = $lb(AEpisodeID,instDataID,DocumentType,Title,ChartItemType,SPageNum,EPageNum,PrintType)
	        s ind=ind+1	
		}
 	}
 	
	q $$$OK
}

ClassMethod GetAllInstIDByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllInstIDByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllInstIDByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllInstIDByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetUnprintInstance","11151174")
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetUnprintInstance","23086306")
Query GetUnprintInstance(AEpisodeID As %String, AUserRoleCode) As %Query(ROWSPEC = "InstanceID:%String,DocumentType:%String,Title:%String,ChartItemType:%String,SPageNum:%String,EPageNum:%String,PrintType:%String")
{
}

ClassMethod GetUnprintInstanceExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AUserRoleCode) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s ADocID = ""
	for {
		s ADocID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID))
		q:(ADocID = "")
		
		s docID = $e(ADocID,2,$L(ADocID))
		
		s needPrint = ..NeedPrint(docID)
		continue:(needPrint = "0")
		
		s rowId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ADocID,""))
		continue:(rowId = "")
		
		s instDataID = "", instTitle = "", instObj = ""
		s isAllCASign = "1"
		
		s happenDate = ""
		for {
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate))
			q:(happenDate = "")
			
			s happenTime = ""
			for {	
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime))
				q:(happenTime = "")	
				
				s childsub = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",rowId," SAVE",happenDate,happenTime,""))
				q:(childsub = "")
				
				s instID = rowId_"||"_childsub
				
				s instObj = ##Class(EMRinstance.InstanceData).%OpenId(instID)
				continue:(instObj = "")
				
				s signID="",isCASign = "0"
				for {
				    //过滤无有效签名或无签名病历
      				s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_instID, signID))
      				q:(signID="")
     				s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
     				continue:(sign.isSignValid '= "1")
     				continue:(sign.Type '= "CA")
     				continue:(sign.SignID = "")||(sign.SignID = $c(0))
     				
     				s isCASign = "1"
     				quit
				}
				
				if (isCASign '= "1")
				{
					s isAllCASign = "0"
				}
				
				q:(isAllCASign = "0")
				
				s instDataID = instID
				if (instTitle = "")
				{	s instTitle = instObj.Title}
				else
				{	s instTitle = instTitle_"+"_instObj.Title}
			}
			
			q:(isAllCASign = "0")
		}
		continue:(isAllCASign = "0")||(instDataID = "")
		
		s DocumentType = instObj.TheECRecord.DocumentType 
        s ChartItemType = instObj.TheECRecord.ChartItemType
        s Title = instTitle
        s SPageNum = instObj.StartPageNum
        s EPageNum = instObj.EndPageNum
        s PrintType = ..GetUnPrintDescByRoleCode(AUserRoleCode)
        s printRowID =""
        s printRowID = ..GetPrintRecordIDByRoleCode(instDataID,AUserRoleCode)
		continue:(printRowID '= "")
		
        
	    s ^CacheTemp(repid,ind) = $lb(instDataID,DocumentType,Title,ChartItemType,SPageNum,EPageNum,PrintType)
        s ind=ind+1	
	}
	
	q $$$OK
}

ClassMethod GetUnprintInstanceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnprintInstanceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnprintInstanceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnprintInstanceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetAllCTLoc","E","","") 
Query GetAllCTLoc(pType As %String, pText As %String, AUserRoleCode) As %Query(ROWSPEC = "CTLOC_RowID,CTLOC_Desc,CTLoc_Alias,CTLoc_Remark")
{
}

ClassMethod GetAllCTLocExecute(ByRef qHandle As %Binary, pType As %String, pText As %String, AUserRoleCode) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	if (pType = "")
 	{
	 	s tmpType = ""
	 	for
	 	{
		 	s tmpType = $o(^CTLOC(0,"LocType",tmpType))
		 	q:(tmpType = "")
		 	d getData
		}
	}
	else
	{
	 	for i=1:1:$l(pType,",")
	 	{
		 	s tmpType = $p(pType,",",i)
		 	d getData
	 	}
	}
	Quit $$$OK
getData
 	s rowId = ""
	for
	{
		s rowId = $o(^CTLOC(0,"LocType",$zcvt(tmpType,"U"),rowId))
		q:(rowId = "")
		
		s code = $p(^CTLOC(rowId),"^",1)
		s descall = $p(^CTLOC(rowId),"^",2)
		s desc = descall
		s alias = descall
		/*
		if ($L(descall,"-") = 2)
		{
			s desc = $p(descall,"-",2)
			s alias = $p(descall,"-",1)
		}
		else
		{
			s desc = descall
			s alias = descall
		}
		*/
		s dateActivefr = $p(^CTLOC(rowId),"^",24)
		s dateActiveto = $p(^CTLOC(rowId),"^",25)
		s dateNow = $p($h,",",1)
		
		continue:((dateActivefr '= "")&&(dateNow < dateActivefr))
		continue:((dateActiveto '= "")&&(dateNow > dateActiveto))
		continue:((pText '= "")&&($zcvt(desc,"U")'[ $zcvt(pText,"U")))
		
		s hospitalID= ##Class(EMRmeta.MRHospLoc).GetHospitalID(rowId)
		s remark = hospitalID
		s ^CacheTemp(repid,ind) = $lb(rowId,desc,alias,remark)
		
		s ind=ind+1
	}
}

ClassMethod GetAllCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllCTLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetHospitalList","") 
Query GetHospitalList(hospitalDesc As %String, AUserRoleCode) As %Query(ROWSPEC = "HospitalRowID,HospitalDesc")
{
}

ClassMethod GetHospitalListExecute(ByRef qHandle As %Binary, hospitalDesc As %String, AUserRoleCode) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	s no = ""
 	for {
	 	s no = $O(^DHCEMRM.MRHospitalI("IdxOrderNo",no))
	 	q:(no = "")
	 	
	 	s id = ""
	 	for {
		 	s id = $O(^DHCEMRM.MRHospitalI("IdxOrderNo",no,id))
		 	q:(id = "")
		 	
		 	s obj = ##Class(EMRmeta.MRHospital).%OpenId(id)
		 	s rowId = id
		 	s desc  = obj.MRHospitalDesc
		 	s ^CacheTemp(repid,ind) = $lb(rowId,desc)
		 	s ind=ind+1
	 	}
 	}
 	
	Quit $$$OK
}

ClassMethod GetHospitalListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHospitalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetPatTypeList","") 
Query GetPatTypeList(patTypeDesc As %String, AUserRoleCode) As %Query(ROWSPEC = "PatTypeID,PatTypeDesc")
{
}

ClassMethod GetPatTypeListExecute(ByRef qHandle As %Binary, patTypeDesc As %String, AUserRoleCode) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	s desc = ""
 	for {
	 	s desc = $O(^PAC("ADMREA",0,"Desc",desc))
	 	q:(desc = "")
	 	
	 	s id = ""
	 	for {
			s id = $O(^PAC("ADMREA",0,"Desc",desc,id))
	 		q:(id = "")
	 	 	
	 	 	s tmpDesc = $p($g(^PAC("ADMREA",id)),"^",2)
	 	 	//s:(tmpDesc = "") tmpDesc = "空白类型"
	 	 	
	 	 	if (AUserRoleCode = "INSUPRINT")
	 	 	{
		 	 	s isok =(tmpDesc = "自费")||(tmpDesc = "商业保险")||(tmpDesc = "签约企业(药费自付)")
	 	 		continue:('isok)
	 	 	}
	 	 	
	 	 	s ^CacheTemp(repid,ind) = $lb(id,tmpDesc)
			s ind=ind+1
	 	} 
 	}
 	
	
	Quit $$$OK
}

ClassMethod GetPatTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLPrintToolService","GetInsuranceTypeList","","") 
Query GetInsuranceTypeList(InsuranceTypeDesc As %String, AUserRoleCode) As %Query(ROWSPEC = "InsuranceTypeID,InsuranceTypeDesc")
{
}

ClassMethod GetInsuranceTypeListExecute(ByRef qHandle As %Binary, InsuranceTypeDesc As %String, AUserRoleCode) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	
 	s today = $p($h,",",1)
 	
 	s desc = ""
 	for {
	 	s desc = $o(^ARC("INST",0,"Desc",desc))
	 	q:(desc = "")
	 	
	 	s id = ""
	 	for {
			s id = $O(^ARC("INST",0,"Desc",desc,id))
	 		q:(id = "")
	 	 	
	 	 	s dateFrom = $p($g(^ARC("INST",id)),"^",13)
	 	 	continue:(today < dateFrom)
	 	 	s dateTo = $p($g(^ARC("INST",id)),"^",14)
	 	 	continue:(dateTo '= "")&&(today > dateTo)
	 	 	
	 	 	s tmpDesc = $p($g(^ARC("INST",id)),"^",2)
	 	 	//s:(tmpDesc = "") tmpDesc = "空白类型"
	 	 	if (InsuranceTypeDesc '= "")
	 	 	{
		 	 	continue:($f(tmpDesc,InsuranceTypeDesc)=0)
	 	 	}
	 	 	
	 	 	//处理商保需要的类型
	 	 	/*
	 	 	if (AUserRoleCode = "INSUPRINT")
	 	 	{
		 	 	s isok =(tmpDesc = "自费")||(tmpDesc = "商业保险")||(tmpDesc = "签约企业(药费自付)")
	 	 		continue:('isok)
	 	 	}
	 	 	*/
	 	 	
	 	 	s ^CacheTemp(repid,ind) = $lb(id,tmpDesc)
			s ind=ind+1
	 	} 
 	}
 	
	
	Quit $$$OK
}

ClassMethod GetInsuranceTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInsuranceTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInsuranceTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInsuranceTypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Createdate: 2018-4-10
/// Desc:       创建通过工具打印病历记录 
/// Input：	    pIntanceId:实例ID
/// 		    pStartPageNum:起始页
/// 		    pStartRowNum:起始行号
/// 		    pEndPageNum:结束页
/// 		    pEndRowNum:结束行号
/// Return：    result 0:失败  成功:rowID
/// Debug：     w ##class(EMRservice.BL.BLPrintToolService).CreatePrintRecord("24||2","1","1","1","45")
ClassMethod CreatePrintRecord(userID As %String, pIntanceId As %String, pStartPageNum As %String, pStartRowNum As %String, pEndPageNum As %String, pEndRowNum As %String, AUserRoleCode) As %String
{
	s result = 0
	q:(pIntanceId = "") result
	
	if (userID '= "")
	{
		s userID = $O(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(userID,"u"),""))
	}
	
	s now = $h
	s date = $p(now,",",1)
	s time = $p(now,",",2)
	
	s ecrecordId = $p(pIntanceId,"||",1)
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(pIntanceId)
	q:(objInstanceData = "") result
	s instancePrintRecord = ##class(EMRinstance.PrintToolRecord).%New()
	//ContinuePrint,是否续打
	s instancePrintRecord.ContinuePrint = ""
	s instancePrintRecord.CreateDate = date
	s instancePrintRecord.CreateTime = time
	s instancePrintRecord.CreateUserID = userID
	s instancePrintRecord.ECRecordID = ecrecordId
	s instancePrintRecord.ECRSeq = objInstanceData.ListNo
	s instancePrintRecord.EndPageNum = +objInstanceData.EndPageNum
	s instancePrintRecord.EndRowNum = +objInstanceData.EndRowNum
	s instancePrintRecord.InstanceDataID = pIntanceId
	//LastRowProperty,末行属性
	s instancePrintRecord.LastRowProperty = ""
	s instancePrintRecord.PrintStatus = "Printed"
	s instancePrintRecord.PrintTemplateID = objInstanceData.RealTemplateID
	s instancePrintRecord.PrintTemplateVersion = objInstanceData.TemplateVersion
	s instancePrintRecord.PrintType = objEcrecord.CategoryType
	s instancePrintRecord.StartPageNum = +objInstanceData.StartPageNum
	s instancePrintRecord.StartRowNum = +objInstanceData.StartRowNum
	s instancePrintRecord.UpdateDate = date
	s instancePrintRecord.UpdateTime = time
	s instancePrintRecord.UpdateUserID = userID
	s instancePrintRecord.UserRoleCode = AUserRoleCode
	s $zt = "PrintRecordErrorHandler"
	s sc = instancePrintRecord.%Save()
	if ($$$ISOK(sc))
	{
		s result = instancePrintRecord.%Id()
	}
	k instancePrintRecord
	quit result
	 
PrintRecordErrorHandler
    quit result
}

ClassMethod GetPrintRecordIDByRoleCode(AInstanceDataID As %String, AUserRoleCode As %String) As %String
{
	s AUserRoleCode = $tr(AUserRoleCode,$c(0),"")
	
	s printRowID ="",id = ""
	for {
    	s id = $o(^DHCEMRI.PrintToolRecordI("IdxInstanceDataID"," "_AInstanceDataID,id))
		q:(id = "")
		
		if (AUserRoleCode = "")
		{
			s printRowID = id
			quit
		}
		else
		{
			s obj = ##Class(EMRinstance.PrintToolRecord).%OpenId(id)
			continue:(obj = "")
			if (obj.UserRoleCode = AUserRoleCode)
			{
				s printRowID = id
				quit
			}
		}
	}
	
	q printRowID
}

}
