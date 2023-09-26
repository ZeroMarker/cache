Class EPRservice.BLL.BLSelfPrint Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	通过卡号获取登记号
/// w ##Class(EPRservice.BLL.BLSelfPrint).GetRegNoByCardNo("","")
ClassMethod GetRegNoByCardNo(ACardNo, ACardType) As %String
{
	s regNo = ""
	
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	if (Hospital = "DYSDERMYY")
	{	
		//东营市第二人民医院：返回的直接就是登记号，不是PatientID
		s regNo = ##Class(web.DHCOPAdmReg).GetPatIDByCardInfo(ACardNo)
	}
	elseif (Hospital = "WFSRMYY")
	{
		//潍坊市人民医院
		s patID = ##Class(web.DHCOPAdmReg).GetPatientIDByCardNo(ACardNo)
		if (patID '= "") 
		{
			s regNo = $P($g(^PAPER(patID,"PAT",1)),"^",1)
		}
	}
	else
	{
		s patID = ##Class(web.DHCOPAdmReg).GetPatientIDByCardNo(ACardNo)
		if (patID '= "") 
		{
			s regNo = $P($g(^PAPER(patID,"PAT",1)),"^",1)
		}
	}
	
	q regNo
}

/// Desc: 	通过登记号获取就诊列表
/// d ##Class(%ResultSet).RunQuery("EPRservice.BLL.BLSelfPrint","GetAdmListByRegNo","0000000013","O^E^I","11","OutPatientSelfPrint")
Query GetAdmListByRegNo(ARegNo, AAdmType, AUserID, ASelfPrintSchemeName) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,PatName:%String,Gender:%String,AdmDate:%String,AdmTime:%String,AdmDept:%String,PrintStatus:%String,RecordStatus:%String")
{
}

ClassMethod GetAdmListByRegNoExecute(ByRef qHandle As %Binary, ARegNo, AAdmType, AUserID, ASelfPrintSchemeName) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s PAPMI = $O(^PAPERi("PAPMI_PatNo",ARegNo,""))
 	q:(PAPMI = "") $$$OK
 	
	s count = $L(AAdmType,"^")
    for i = 1:1:count
    {
    	s AdmType = $p(AAdmType,"^",i)
    	
    	s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm),-1)
		     q:(PAAdm = "")
		     
		     
		     d OutPutRow(PAAdm)
		}
    }
    
	q $$$OK
	
OutPutRow(PAAdm)
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s EpisodeID = PAAdm
	
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)   //就诊类型
	if PAAdmType = "I"
	{
		s PAAdmType = "住院"
	}elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	
	s PatName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  //病人姓名
		
	s Gender = $P($g(^PAPER(PatientID,"ALL")),"^",7)  //性别
	if (Gender '= "")
	{	
		s Gender = $P($g(^CT("SEX",Gender)),"^",2)
	}
	
	s AdmDate = $P($g(^PAADM(PAAdm)),"^",6) //入院日期
	s AdmTime = $P($g(^PAADM(PAAdm)),"^",7)  //入院时间
	if (AdmDate '= "")
	{
		s AdmDate = $zd(AdmDate,3)
	}
	if (AdmTime '= "")
	{
		s AdmTime = $zt(AdmTime,1)
	}
	
	s AdmDept = ""    //当前科室
	s AdmDept = $P($g(^PAADM(PAAdm)),"^",4)  
	if (AdmDept '= "")
	{
		s AdmDept = $P($g(^CTLOC(AdmDept)),"^",1)
	}
	
	s PrintStatus = "未打印"
	//s hasPrint = ##Class(EPRservice.BLL.BLSelfPrintRecord).IsPrintRecordExisted(EpisodeID,ASelfPrintSchemeName)
	//if (hasPrint = "1")
	//{
	//	s PrintStatus = "已打印"
	//}
	s printCount = ##Class(EPRservice.BLL.BLSelfPrintRecord).GetPrintCount(EpisodeID,ASelfPrintSchemeName)
	if (printCount > 0 )
	{
		s printCountLimitOption = "OutPrintCountLimit"
		s printCountLimit = ##Class(EPRmeta.SelfPrintOption).GetOptionValue(printCountLimitOption)
		s printCountLimit = +printCountLimit
		s:(printCountLimit = "0") printCountLimit = "1"
		
		if (printCount >= printCountLimit)
		{	s PrintStatus = "已打印"}
		else
		{	s PrintStatus = "还可打印"_(printCountLimit-printCount)_"次"}
	}
	
	s RecordStatus = "无病历"
	s hasRecord = ..HasItemToBePrint(EpisodeID,AUserID,ASelfPrintSchemeName)
	if (hasRecord = "1")
	{
		s RecordStatus = "有病历"
	}
	
 	s data = $lb(PatientID,EpisodeID,PatName,Gender,AdmDate,AdmTime,AdmDept,PrintStatus,RecordStatus)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1

	q
}

ClassMethod GetAdmListByRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmListByRegNoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmListByRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmListByRegNoExecute ]
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

/// Desc:	获取指定就诊指定打印方案下的可打印项目
/// 	AInput:	ASelfPrintSchemeName 自助打印方案名称，门诊自助打印方案名称为:OutPatientSelfPrint
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.BLL.BLSelfPrint","GetPrintItem","15","11","OutPatientSelfPrint")
Query GetPrintItem(AEpisodeID, AUserID, ASelfPrintSchemeName) As %Query(ROWSPEC = "EPRDocID,PrintItemDetail,DocDesc,PrintStatus")
{
}

ClassMethod GetPrintItemExecute(ByRef qHandle As %Binary, AEpisodeID, AUserID, ASelfPrintSchemeName) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s PageInfoID = ""
 	
    //s printItems = ##Class(EPRservice.BOSysOption).GetValueByName(ASelfPrintSchemeName)
    s printItems = ##class(EPRservice.BLL.BLSelfPrintScheme).GetPrintItems(ASelfPrintSchemeName)
    q:(printItems="")||(printItems="NULL") $$$OK
    
    s patientID = $P($g(^PAADM(AEpisodeID)),"^",1)
    q:(patientID="") $$$OK
    
    s count = $l(printItems,"^")
    for i = 1:1:count
    {
	    s item = $P(printItems,"^",i)
	    continue:(item="")
	    
	    s detailInfo = ..GetDetailInfo(item, patientID, AEpisodeID, AUserID)
	    continue:(detailInfo = "")
    	
    	s docDesc = ..GetDocDesc(item)
    	
    	s printStatus = ..GetDocPrintStatus(AEpisodeID,ASelfPrintSchemeName,item)
    	
    	s data = $lb(item,detailInfo,docDesc,printStatus)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1 
    }
    
	q $$$OK
}

ClassMethod GetPrintItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintItemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrintItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintItemExecute ]
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

/// Desc:	获取就诊信息
ClassMethod GetAdmInfo(AEpisodeID As %String) As %String
{
	s nullAdmInfo = "未找到相关就诊记录"
	
	q:(AEpisodeID = "") nullAdmInfo
	q:$g(^PAADM(AEpisodeID))="" nullAdmInfo
	
	s PAAdm = AEpisodeID
	s PatientID = $p($g(^PAADM(AEpisodeID)),"^",1)
	q:(PatientID="") nullAdmInfo
	
	
	s PatName = $p($g(^PAPER(PatientID,"ALL")),"^",1)  //病人姓名
		
	s Gender = $P($g(^PAPER(PatientID,"ALL")),"^",7)  //性别
	if (Gender '= "")
	{	
		s Gender = $P($g(^CT("SEX",Gender)),"^",2)
	}
	
	s AdmDate = $P($g(^PAADM(PAAdm)),"^",6) //入院日期
	s AdmTime = $P($g(^PAADM(PAAdm)),"^",7)  //入院时间
	if (AdmDate '= "")
	{
		s AdmDate = $zd(AdmDate,3)
	}
	if (AdmTime '= "")
	{
		s AdmTime = $zt(AdmTime,1)
	}
	
	s AdmDept = ""    //当前科室
	s AdmDept = $P($g(^PAADM(PAAdm)),"^",4)  
	if (AdmDept '= "")
	{
		s AdmDept = $P($g(^CTLOC(AdmDept)),"^",1)
	}
	
	s retInfo = "姓名:"_PatName_", 性别:"_Gender_", 就诊日期:"_AdmDate_" "_AdmTime_", 就诊科室:"_AdmDept
	q retInfo
}

/// Desc:	07病历文书下的节点打印信息
/// Input：	ACategoryChapterDocID - 模板目录ID
/// 		APatientID - 病人ID	
/// 		AEpisodeID - 就诊号
/// 		AUserID - 操作用户
/// Output: printType^APatientID^AEpisodeID^AUserID^printTemplateID^APrintTemplateDocID^instanceDataIDs
ClassMethod GetDetailInfo(APrintTemplateDocID As %String, APatientID, AEpisodeID, AUserID) As %String
{
	//b "s"
	s (printType, patientID, episodeID,userID) = ""
	s (printTemplateID, printDocID, instanceDataIDs) = ""

	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTemplateID)
	q:(objPrintTemplate = "") ""
	s printType = objPrintTemplate.ChartItemType
	
	if (printType = "Multiple")
	{
		s instanceDataIDs = ..GetInstanceData(AEpisodeID, APrintTemplateDocID)
		q:(instanceDataIDs = "") "" 
	}
	else
	{
		s eprStatus = ##Class(EPRinstance.EPRLogs).GetEPRStatus(AEpisodeID,APrintTemplateDocID,"1")
		q:(eprStatus="")||(eprStatus="created")||(eprStatus="unfinished")||(eprStatus="finished") ""
	}
	
	q printType_"^"_APatientID_"^"_AEpisodeID_"^"_AUserID_"^"_printTemplateID_"^"_APrintTemplateDocID_"^"_instanceDataIDs
}

ClassMethod GetInstanceData(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s instanceDataIDs = ""
	Set rset = ##class(%ResultSet).%New("web.DHCEPRExt:MultipleReportList")
 	Set sc = rset.Execute(AEpisodeID, APrintTemplateDocID)
 	While (rset.Next()){
 		if (instanceDataIDs = "")
		{	s instanceDataIDs = rset.Data("ID")}
		else
		{	s instanceDataIDs = instanceDataIDs_","_rset.Data("ID")}
 	}
 	
 	q instanceDataIDs
}

ClassMethod HasItemToBePrint(AEpisodeID, AUserID, ASelfPrintSchemeName) As %String
{
	s count = 0
	
	s rs = ##class(%ResultSet).%New("EPRservice.BLL.BLSelfPrint:GetPrintItem")
	s sc = rs.Execute(AEpisodeID,AUserID,ASelfPrintSchemeName)
	while (rs.Next()) {
		s count = count + 1
	}
	
	if (count = "0")
	{
		q "0"
	}
	else
	{
		q "1"
	}
}

ClassMethod GetDocDesc(APrintTemplateDocID As %String) As %String
{
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
	q:(objEPRTemplateCategory="") ""
	
	s desc = objEPRTemplateCategory.CategoryName
	
	s parentID = objEPRTemplateCategory.ParentCategoryID
	s objParentCategory =  ##Class(EPRmeta.EPRTemplateCategory).%OpenId(parentID)
	q:(objParentCategory = "") desc
	
	s descParent = objParentCategory.CategoryName
	
	q descParent
}

ClassMethod GetDocPrintStatus(AEpisodeID, ASelfPrintSchemeName, APrintTemplateDocID As %String) As %String
{
	
	s status = ##Class(EPRservice.BLL.BLSelfPrintRecord).IsDocPrinted(AEpisodeID,ASelfPrintSchemeName,APrintTemplateDocID)
	if (status = "0")
	{
		q "未打印"
	}
	else
	{
		q "已打印"
	}
}

}
