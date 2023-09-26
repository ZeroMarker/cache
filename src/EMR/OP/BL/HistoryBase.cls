/// 名称:	EMR.OP.BL.HistoryBase
/// 描述:	门诊病历-历史就诊(基类)
/// 编写者：yejian
/// 编写日期: 2022-6-22
/// 产品组：电子病历产品组
Class EMR.OP.BL.HistoryBase Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取历史就诊
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_OPHISTORY","params":{"patientID":"20","flag":"0","lastEpisodeID":"","admType":"O","userCode":"YS01","userLocID":"6","hospitalID":"2","ssgroupID":"28"},"product":"OP"}
/// 			patientID 住院号，flag 标识（0 本医师,1 本科室,2 全院），lastEpisodeID 就诊号，admType 就诊类型，pageType 页面类型
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOPHistory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.OPHistory).%New()
	s objItem.Product = argInJson.product
	s objItem.PatientID = argInJson.params.patientID
	s objItem.Flag = argInJson.params.flag
	s objItem.LastEpisodeID = argInJson.params.lastEpisodeID
	s objItem.AdmType = argInJson.params.admType
	s objItem.UserCode = argInJson.params.userCode
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.HospitalID = argInJson.params.hospitalID
	s objItem.SSGroupId = argInJson.params.ssgroupID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.History).GetOPHistoryJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR",$zerror)
}

/// Desc:       获取历史就诊
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aItem:参数对象
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.History).GetUserDataJson("10209",.obj)
ClassMethod GetOPHistoryJson(aItem As EMR.OP.DTO.OPHistory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.PatientID="") "-1^住院号不能为空"
	q:(aItem.LastEpisodeID="") "-1^就诊号不能为空"
	s Stream = ##Class(%GlobalBinaryStream).%New()
	s opHistoryCount=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("opHistoryCount",aItem.Product,3)
	//是否过滤掉未写门诊病历的记录
	s aItem.FilterOPHistoryEmr=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isFilterOPHistoryEmr",aItem.Product,"N")	
	s aItem.IncludeOeordHistory=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isIncludeOeordHistory",aItem.Product,"N")	
	
	s count=0, sum=0
	if (0=aItem.Flag) { s aItem.FlagArg=aItem.UserCode}
	elseif (1=aItem.Flag) { s aItem.FlagArg=aItem.UserLocID }
	
	if ("O"=aItem.AdmType) { d getO }
	elseif ("I"=aItem.AdmType) { d getI }
	elseif ("E"=aItem.AdmType) { d getE }
	else { d getAll }
 	
    d argOutData.Write("{""total"":"_count_",""count"":"_sum_",""rows"":[")
	d argOutData.CopyFrom(Stream)
	d argOutData.Write("]}")
	q "1"
		
getAll
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	s episodeID=""
	s admType = "O"
 	for {	
	 	s episodeID = $O(^PAPERdr(aItem.PatientID,"ADM",admType,episodeID),-1)
	 	if (episodeID="") 
	 	{
		 	if (admType = "O") 
		 	{ 
		 		s admType = "I"
		 		s episodeID=""
		 		continue
		 	} elseif (admType = "I") 
		 	{ 
		 		s admType = "E"
		 		s episodeID=""
		 		continue
		 	} else { q }
		}
		s key = ##class(EMR.OP.BL.History).GetHistoryKey(episodeID)
	 	d episodeIDs.SetAt(episodeID, key)
	}	

	s key = ##class(EMR.OP.BL.History).GetHistoryKey(aItem.LastEpisodeID)
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")

		s episodeID=episodeIDs.GetAt(key)
		s aItem.CurEpisodeID= episodeID
		i (count<opHistoryCount) {
			d getDetails
		}
		d getSum
	}
	q	
	
getO   // 门诊 取所有的门诊记录排序,再按指定就诊的日期，取该日期之前的
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	s episodeID=""
 	for {	
	 	s episodeID = $O(^PAPERdr(aItem.PatientID,"ADM",aItem.AdmType,episodeID),-1)
	 	q:(episodeID="")
	 	s key =##class(EMR.OP.BL.History).GetHistoryKey(episodeID)
	 	d episodeIDs.SetAt(episodeID, key)
	}	

	s key = ##class(EMR.OP.BL.History).GetHistoryKey(aItem.LastEpisodeID)
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeID=episodeIDs.GetAt(key)
		s aItem.CurEpisodeID= episodeID
		i (count<opHistoryCount) {
			d getDetails
		}
		d getSum
	}
	q	
	
getI     // 住院
    s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	if (aItem.AdmType=$p($g(^PAADM(aItem.LastEpisodeID)),"^",2)) {
		s episodeID=aItem.LastEpisodeID
 		for {
		 	s episodeID = $O(^PAPERdr(aItem.PatientID,"ADM",aItem.AdmType,episodeID),-1)
		 	q:(episodeID="")
            s key = ##class(EMR.OP.BL.History).GetHistoryKey(episodeID)
            d episodeIDs.SetAt(episodeID, key)
 		}	
	} else {
		s episodeID=""
 		for {
		 	s episodeID = $O(^PAPERdr(aItem.PatientID,"ADM",aItem.AdmType,episodeID),-1)
		 	q:(episodeID="")
            s key = ##class(EMR.OP.BL.History).GetHistoryKey(episodeID)
            d episodeIDs.SetAt(episodeID, key)
 		}
	}
    s lastAdmDT=""
    s:(aItem.LastEpisodeID'="") lastAdmDT=##class(EMR.OP.BL.History).GetHistoryKey(aItem.LastEpisodeID)
    s key = ""
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeID=episodeIDs.GetAt(key)
		s aItem.CurEpisodeID= episodeID
        continue:(key>=lastAdmDT)&&(lastAdmDT'="")
		
	 	i (count<opHistoryCount) {
			d getDetails
		}
		d getSum
	}

	q
	
getE   // 急诊
	if (aItem.AdmType=$p($g(^PAADM(aItem.LastEpisodeID)),"^",2)) {
		s episodeID=aItem.LastEpisodeID
 		for {
		 	s episodeID = $O(^PAPERdr(aItem.PatientID,"ADM",aItem.AdmType,episodeID),-1)
		 	q:(episodeID="")
		 	s aItem.CurEpisodeID= episodeID
            i (count<opHistoryCount) {
                d getDetails
            }
            d getSum
 		}	
	} else {
		s lastAdmdate=$P($G(^PAADM(aItem.LastEpisodeID)),"^",6), lastAdmtime=$P($G(^PAADM(aItem.LastEpisodeID)),"^",7)
		s episodeID=""
 		for {
		 	s episodeID = $O(^PAPERdr(aItem.PatientID,"ADM",aItem.AdmType,episodeID),-1)
		 	q:(episodeID="")
		 	s aItem.CurEpisodeID= episodeID
		 	s admdate=$P($G(^PAADM(episodeID)),"^",6), admtime=$P($G(^PAADM(episodeID)),"^",7)
		 	continue:(admdate>lastAdmdate)&&(admtime>lastAdmdate)
            i (count<opHistoryCount) {
                d getDetails
            }
            d getSum
 		}
	}
	q		
 
getDetails //根据flag，过滤不符合条件的,获取详细的就诊信息
	s ret =##class(EMR.OP.BL.History).GetHistoryDetails(aItem)
	if (ret'="")
	{
		if (Stream.Size=0) {
			d Stream.Write("{""record"":"""_ret_"""}")
		}else{		
			d Stream.Write(","_"{""record"":"""_ret_"""}")	
		}
		s count=count+1
	}
	q
    
getSum
	s ret = ##class(EMR.OP.BL.History).GetHistoryDetails(aItem)
	if (ret'="")
	{
		s sum = sum+1
	}
	q
}

/// Desc:       获取历史就诊
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_ALLOPHISTORY","params":{"patientID":"20","flag":"0","lastEpisodeID":"","admType":"O","userCode":"YS01","userLocID":"6","hospitalID":"2","ssgroupID":"28"},"product":"OP"}
/// 			patientID 住院号，flag 标识（0 本医师,1 本科室,2 全院），lastEpisodeID 就诊号，admType 就诊类型，pageType 页面类型
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllOPHistory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.OP.DTO.OPHistory).%New()
	s objItem.Product = argInJson.product
	s objItem.PatientID = argInJson.params.patientID
	s objItem.Flag = argInJson.params.flag
	s objItem.LastEpisodeID = argInJson.params.lastEpisodeID
	s objItem.AdmType = argInJson.params.admType
	s objItem.UserCode = argInJson.params.userCode
	s objItem.UserLocID = argInJson.params.userLocID
	s objItem.HospitalID = argInJson.params.hospitalID
	s objItem.SSGroupId = argInJson.params.ssgroupID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.History).GetAllOPHistoryJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR",$zerror)
}

/// Desc:       获取历史就诊
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aItem:参数对象
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.History).GetUserDataJson("10209",.obj)
ClassMethod GetAllOPHistoryJson(aItem As EMR.OP.DTO.OPHistory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.PatientID="") "-1^住院号不能为空"
    ;s jsonItem  = ##class(%DynamicObject).%New()
	s Stream = ##Class(%GlobalBinaryStream).%New()
	s opHistoryCount=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("opHistoryCount",aItem.Product,3)
	//是否过滤掉未写门诊病历的记录
	s aItem.FilterOPHistoryEmr=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isFilterOPHistoryEmr",aItem.Product,"N")	
	s aItem.IncludeOeordHistory=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("isIncludeOeordHistory",aItem.Product,"N")	
	
	s count=0, sum=0
	if (0=aItem.Flag) { s aItem.FlagArg=aItem.UserCode}
	elseif (1=aItem.Flag) { s aItem.FlagArg=aItem.UserLocID }
	
	d getAll
 	
    d argOutData.Write("{""total"":"_count_",""count"":"_sum_",""rows"":[")
	d argOutData.CopyFrom(Stream)
	d argOutData.Write("]}")
	q "1"
	
getAll
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	s episodeID=""
	s admtypeidx = "O"
 	for {	
	 	s episodeID = $O(^PAPERdr(aItem.PatientID,"ADM",admtypeidx,episodeID),-1)
	 	if (episodeID="") 
	 	{
		 	if (admtypeidx = "O") 
		 	{ 
		 		s admtypeidx = "I"
		 		continue
		 	}
		 	elseif (admtypeidx = "I") 
		 	{ 
		 		s admtypeidx = "E"
		 		continue
		 	} 
		 	else { q }
		}
	 	s key = ##class(EMR.OP.BL.History).GetHistoryKey(episodeID)
	 	d episodeIDs.SetAt(episodeID, key)
	}	

	s lastAdmDT=""
	s:(aItem.LastEpisodeID'="") lastAdmDT=##class(EMR.OP.BL.History).GetHistoryKey(aItem.LastEpisodeID)
	s key=""
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeID=episodeIDs.GetAt(key)
		continue:(aItem.AdmType'=$p($g(^PAADM(episodeID)),"^",2))&&(aItem.AdmType'="")
		continue:(key>=lastAdmDT)&&(lastAdmDT'="")
		s aItem.CurEpisodeID = episodeID
        i (count<opHistoryCount) {
            d getDetails
        }
        d getSum
	}
	q	
		
getDetails //根据flag，过滤不符合条件的,获取详细的就诊信息
	s ret = ##class(EMR.OP.BL.History).GetHistoryDetails(aItem)
	if (ret'="")
	{
		if (Stream.Size=0) {
			d Stream.Write("{""record"":"""_ret_"""}")
		}else{		
			d Stream.Write(","_"{""record"":"""_ret_"""}")	
		}
		s count=count+1
	}
	q
    
getSum
	s ret = ##class(EMR.OP.BL.History).GetHistoryDetails(aItem)
	if (ret'="")
	{
		s sum = sum+1
	}
	q
}

/// Desc:       获取Key值
/// Creator:    yejian
/// CreateDate: 2022-10-21
/// Input:      aEpisodeID 就诊号
/// OutPut:     
/// Return:		成功 1 失败 -1^失败信息
/// Debug: w ##class(EMR.OP.BL.History).GetHistoryKey()
ClassMethod GetHistoryKey(aEpisodeID As %String) As %String
{
 	s d = $P($G(^PAADM(aEpisodeID)),"^",6)
 	s t = "0000"_($P($G(^PAADM(aEpisodeID)),"^",7))
 	s e = "000000000"_aEpisodeID
 	
    s key = d_$E(t,$L(t)-4,$L(t))_$E(e,$L(e)-9,$L(e))
    q key
}

/// Desc:       获取明细
/// Creator:    yejian
/// CreateDate: 2022-10-21
/// Input:      aItem 参数对象
/// OutPut:     
/// Return:		成功 1 失败 -1^失败信息
/// Debug: w ##class(EMR.OP.BL.History).GetHistoryDetails()
ClassMethod GetHistoryDetails(aItem As EMR.OP.DTO.OPHistory) As %String
{
    q:(##class(EMR.OP.BL.History).FilterHistory(aItem)="1") ""
	s ret = ##class(EMR.OP.BL.History).getHistoryDetail(aItem)

	q ret
}

/// Desc:       是否需要被过滤掉
/// Creator:    yejian
/// CreateDate: 2022-10-21
/// Input:      aItem 参数对象
/// OutPut:     
/// Return:		成功 1 失败 -1^失败信息
/// Debug: w ##class(EMR.OP.BL.History).FilterHistory()
ClassMethod FilterHistory(aItem As EMR.OP.DTO.OPHistory) As %String
{
    //过滤退号就诊
    s admStatus = $p($g(^PAADM(aItem.CurEpisodeID)),"^",20)
	q:(admStatus = "C") "1"
    
    //院区共库判断
	s hospitalId =aItem.HospitalID
    
    if (hospitalId '= "")
    {
        s showShareHospital= ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ShowShareHospital",aItem.Product,"N")
        //根据就诊号取患者所在的科室ID
        s currentDept = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(aItem.CurEpisodeID)
        s currentDeptId = $P(currentDept,"^",1)
        s locHospitalId = $p($g(^CTLOC(currentDeptId)),"^",22)
        q:((locHospitalId '= hospitalId)&&(showShareHospital="N")) "1"
    }

	if ("0"=aItem.Flag)
	{
		s doc=##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDoctor(aItem.CurEpisodeID)
		q:($zcvt(aItem.FlagArg,"D")'=$zcvt($P($G(doc),"^",2),"D")) "1"		
	} 
	elseif ("1"=aItem.Flag)
	{
		s dept = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(aItem.CurEpisodeID)
		q:(aItem.FlagArg'=$P($G(dept),"^",1)) "1"
	}	
	q "0"
}

/// Desc:       获取明细
/// Creator:    yejian
/// CreateDate: 2022-10-21
/// Input:      aItem 参数对象
/// OutPut:     
/// Return:		成功 1 失败 -1^失败信息
/// Debug: w ##class(EMR.OP.BL.History).getHistoryDetail(1291, "N", "Y" , "")
/// 
ClassMethod getHistoryDetail(aItem As EMR.OP.DTO.OPHistory) As %String
{
	s hasInstance = ##class(EMR.DOC.BL.DocumentData).IsHasInstance(aItem.CurEpisodeID)
	s:(hasInstance="0") hasInstance=""
	q:((hasInstance="")&&(aItem.FilterOPHistoryEmr="Y")) ""
	s admDate = $P($G(^PAADM(aItem.CurEpisodeID)),"^",6)
	s admTime = $P($G(^PAADM(aItem.CurEpisodeID)),"^",7)
	s curDept = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(aItem.CurEpisodeID)
	s curDept = $P(curDept,"^",3)
	s diagnosis = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DiagnosInfo(aItem.CurEpisodeID)
	s diagnosis = $P(diagnosis,"^",3)
	//对诊断中的特殊字符处理
	s diagnosis = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(diagnosis)
	s doc=##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDoctor(aItem.CurEpisodeID,"")
	s doc = $P($G(doc),"^",3)
	s doc = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("User.SSUser","SSUSRName",doc,aItem.LangID)
	s admType = $p($g(^PAADM(aItem.CurEpisodeID)),"^",2)
	//体检报告接口
	s hasHealthReport=""
	s hasHealthReportArg=##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCHflTest||IfHealthReport")
	s:(hasHealthReportArg'=0) hasHealthReport=##class(web.DHCHflTest).IfHealthReport(aItem.CurEpisodeID)
	//add by lina 2017-09-08
	s admDate=##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(admDate,3))
	s admTime=##class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(admTime,1))
	s recordDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans","病历内容")
	s oeordDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans","医嘱内容")
    s records = "" // 当前就诊书写病历实例集合
    //是否过滤掉未写门诊病历的记录
    s isShowOPHistoryTitlebtn = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("IsShowOPHistoryTitlebtn",aItem.Product,"N")
    s:(hasInstance'="")&&(isShowOPHistoryTitlebtn="Y")&&($zcvt(admType,"U")="O") records = ##Class(EMR.OP.BL.History).GetInstanceByEpisodeID(aItem,admType)
	
    //华西要求增加就诊类型显示
    s admTypeDesc = ""
    s:(admType = "I") admTypeDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans","住院")
    s:(admType = "O") admTypeDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans","门诊")
    s:(admType = "E") admTypeDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans","急诊")
    s:(admType = "H") admTypeDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans","体检")
    s:(admType = "N") admTypeDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans","新生儿")
    
    s:(hasInstance'="") hasInstance="&nbsp&nbsp<a class='emrdoc' href='#' admID='"_aItem.CurEpisodeID_"' admType='"_admType_"' index="_0_">"_recordDesc_"</a>"
    s ret = "<div>"
	s ret = ret_"<span style='float:left;'><div class='detailleft'>"
	s ret = ret_"<div class='admdate'>"_admDate_"&nbsp&nbsp"_admTime_"&nbsp&nbsp"_admTypeDesc_"</div>"
    s docInfo = curDept_"&nbsp&nbsp"_doc
    s ret = ret_"<div class='admloc' title='"_docInfo_"'>"_docInfo_"</div>"
	s ret = ret_"<div class='docandoeord'>"
	
	s:(aItem.IncludeOeordHistory="Y") ret = ret_"<a class='oeord' href='#' admID='"_aItem.CurEpisodeID_"'>"_oeordDesc_"</a>"
	s ret = ret_hasInstance
	s ret = ret_"</div>"
	s ret = ret_"</div></span>"
	
	s ret = ret_"<span><div class='detailright'>"
	s ret = ret_"<div class='diag' admID='"_aItem.CurEpisodeID_"'>"_diagnosis_"</div>"
    s:(records'="") ret = ret_"<div class='insTitle'>"_records_"</div>"
	s ret = ret_"</div></span>"
	s ret = ret_"</div>"
	

    q ret
}

/// Desc:       获取记录信息
/// Creator:    yejian
/// CreateDate: 2022-10-21
/// Input:      aItem 参数对象
/// OutPut:     
/// Return:		成功 1 失败 -1^失败信息
/// w ##Class(EMR.OP.BL.HistoryBase).GetInstanceByEpisodeID("222","O")
ClassMethod GetInstanceByEpisodeID(aItem As EMR.OP.DTO.OPHistory, AdmType As %String) As %String
{
    s ret = "", count = 0
    q:(aItem.CurEpisodeID = "")||(AdmType = "") ret
    q:(aItem.UserLocID = "")||(aItem.SSGroupId = "") ret
    s ArrCate = ##Class(%ArrayOfDataTypes).%New()
    s TILDocument = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(aItem.CurEpisodeID)
    s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(aItem.UserLocID, aItem.SSGroupId, aItem.CurEpisodeID,aItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		//设置业务活动记录分类ID，以及分类编码
		;s dtoItem.ParentID = strDocCID
		s strDOCCategoryCode =$zcvt(strDOCCategoryCode,"U")
		s hasListNo = $O(@TILDocument@("IdxMain",aItem.CurEpisodeID," "_strDOCCategoryCode, ""))
		continue:(""=hasListNo)
		s flag="0"
		s listNo = ""
		for
		{
			s listNo = $O(@TILDocument@("IdxMain",aItem.CurEpisodeID," "_strDOCCategoryCode, listNo))
			q:(listNo="")
			s docID = $O(@TILDocument@("IdxMain",aItem.CurEpisodeID," "_strDOCCategoryCode, listNo,""))
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
			continue:(objDocument="")
			//删除状态排除
			continue:("Save" '= objDocument.Status)
			s objTem = objDocument.TemplateID
			continue:(objTem="")
            if (ret '= "") {
                s ret=ret_"&nbsp&nbsp"
            }
            s recordDesc = ##class(EMR.DOC.COM.Translation).Get("EMRTrans",objDocument.DOCName)
            s ret = ret_"<a class='emrdoc' href='#' admID='"_aItem.CurEpisodeID_"' admType='"_AdmType_"' index="_count_" insID='"_docID_"'>"_recordDesc_"</a>"
            s count = count + 1
        }
    }       
    
	q ret
}

/// Desc:       获取有门(急)病历记录的就诊列表
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_OEPEPISODELISTBYPID","params":{"patientID":"8"}}
/// 			patientID 住院号 	
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOEPEpisodeListByPID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s product=argInJson.product
    s patientID=argInJson.params.patientID
	
    s strRes = ##Class(EMR.OP.BL.History).GetOEPEpisodeListByPIDJson(product,patientID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取有门(急)病历记录的就诊列表
/// Creator:    yejian
/// CreateDate: 2022-10-13
/// Input:      aProduct 项目标识
///             aPatientID 住院号
/// OutPut:    	argOutData    返回数据
/// Retrun: 	失败 -1^错误信息，成功 就诊列表
/// debug:     	d ##Class(EMR.OP.BL.History).GetOEPEpisodeListByPIDJson()
ClassMethod GetOEPEpisodeListByPIDJson(aProduct As %String, aPatientID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s strRes = ""
	q:(aPatientID = "") "-1^住院号不能为空"
	s resJson = ##class(%DynamicArray).%New()
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
    s episodeID = ""
    s admtypeidx = "O"
    for {   
        s episodeID = $O(^PAPERdr(aPatientID,"ADM",admtypeidx,episodeID),-1)
        if (episodeID = "") 
        {
            if (admtypeidx = "O") 
            {  
                s admtypeidx = "E"
                continue
            } else { q }
        }
        //过滤掉已退号的就诊信息 
        s VisitStatus = $p($g(^PAADM(episodeID)),"^",20)
        continue:(VisitStatus = "C")

        s key = ##Class(EMR.OP.BL.History).GetHistoryKey(episodeID)
        d episodeIDs.SetAt(episodeID, key)
    }   

    s key = ""
    while (1)
    {
        s key = episodeIDs.Previous(key)
        q:(key = "")
        s episodeID = episodeIDs.GetAt(key)
        //过滤掉未写门(急)诊病历的就诊记录
        s hasInstance = ##class(EMR.DOC.BL.DocumentData).IsHasInstance(episodeID)
        continue:(hasInstance = "0")
        d resJson.%Push(episodeID)
    }
	d resJson.%ToJSON(argOutData)
	q "1"
Error 
    d argOutData.Write(..#NONE)
	q "-1^Err:"_$zerror
}

}
