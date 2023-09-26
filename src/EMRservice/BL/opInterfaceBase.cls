/// 方法来源 EMRservice.Ajax.opInterface , EMRservice.Ajax.opHISInterface
Class EMRservice.BL.opInterfaceBase Extends %RegisteredObject
{

ClassMethod GetHistoryKey(episodeID As %String) As %String
{
 	s d = $P($G(^PAADM(episodeID)),"^",6)
 	s t = "0000"_($P($G(^PAADM(episodeID)),"^",7))
 	s e = "000000000"_episodeID
 	
    s key = d_$E(t,$L(t)-4,$L(t))_$E(e,$L(e)-9,$L(e))
    q key
}

/// ///////////////	GetOPHistory  //////////////////
/// w ##Class(EMRservice.BL.opInterfaceBase).GetOPHistory(6586, 2, "" , "")
ClassMethod GetOPHistory(patientID, flag, lastEpisodeID, admType As %String, pageType As %String = "", userInfoJson As %String = "") As %Stream
{
	s Stream = ##Class(%GlobalCharacterStream).%New()
	s Json = ##Class(%GlobalCharacterStream).%New()
	s opHistoryCount=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("opHistoryCount",3)
	//是否过滤掉未写门诊病历的记录
	s isFilterOPHistoryEmr=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isFilterOPHistoryEmr","N")	
	s isIncludeOeordHistory=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isIncludeOeordHistory","N")	
	
	s count=0, result="", flagArg="", sum=0
	
	if (0=flag) { s flagArg=%session.Get("LOGON.USERCODE") }
	elseif (1=flag) { s flagArg=%session.Get("LOGON.CTLOCID") }
	
	if ("O"=admType) { d getO }
	elseif ("I"=admType) { d getI }
	elseif ("E"=admType) { d getE }
	else { d getAll }

    d Json.Write("{""total"":"_count_",""count"":"_sum_",""rows"":[")
	d Json.CopyFrom(Stream)
	d Json.Write("]}")
	q Json
	
getAll
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	s episodeID=""
	s admType = "O"
 	for {	
	 	s episodeID = $O(^PAPERdr(patientID,"ADM",admType,episodeID),-1)
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
		s key = ..GetHistoryKey(episodeID)
	 	d episodeIDs.SetAt(episodeID, key)
	}	

	s key = ..GetHistoryKey(lastEpisodeID)
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")

		s episodeID=episodeIDs.GetAt(key)
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
	 	s episodeID = $O(^PAPERdr(patientID,"ADM",admType,episodeID),-1)
	 	q:(episodeID="")
	 	s key = ..GetHistoryKey(episodeID)
	 	d episodeIDs.SetAt(episodeID, key)
	}	

	s key = ..GetHistoryKey(lastEpisodeID)
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeID=episodeIDs.GetAt(key)
		i (count<opHistoryCount) {
			d getDetails
		}
		d getSum
	}
	q	
	
getI     // 住院
    s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	if (admType=$p($g(^PAADM(lastEpisodeID)),"^",2)) {
		s episodeID=lastEpisodeID
 		for {
		 	s episodeID = $O(^PAPERdr(patientID,"ADM",admType,episodeID),-1)
		 	q:(episodeID="")
            s key = ..GetHistoryKey(episodeID)
            d episodeIDs.SetAt(episodeID, key)
 		}	
	} else {
		s episodeID=""
 		for {
		 	s episodeID = $O(^PAPERdr(patientID,"ADM",admType,episodeID),-1)
		 	q:(episodeID="")
            s key = ..GetHistoryKey(episodeID)
            d episodeIDs.SetAt(episodeID, key)
 		}
	}
    s lastAdmDT=""
    s:(lastEpisodeID'="") lastAdmDT=..GetHistoryKey(lastEpisodeID)
    s key = ""
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeID=episodeIDs.GetAt(key)
        continue:(key>=lastAdmDT)&&(lastAdmDT'="")
		
	 	i (count<opHistoryCount) {
			d getDetails
		}
		d getSum
	}

	q
	
getE   // 急诊
	if (admType=$p($g(^PAADM(lastEpisodeID)),"^",2)) {
		s episodeID=lastEpisodeID
 		for {
		 	s episodeID = $O(^PAPERdr(patientID,"ADM",admType,episodeID),-1)
		 	q:(episodeID="")
            i (count<opHistoryCount) {
                d getDetails
            }
            d getSum
 		}	
	} else {
		s lastAdmdate=$P($G(^PAADM(lastEpisodeID)),"^",6), lastAdmtime=$P($G(^PAADM(lastEpisodeID)),"^",7)
		s episodeID=""
 		for {
		 	s episodeID = $O(^PAPERdr(patientID,"ADM",admType,episodeID),-1)
		 	q:(episodeID="")
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
	s ret = ..GetHistoryDetails(flag, flagArg, episodeID, isFilterOPHistoryEmr, isIncludeOeordHistory, pageType,userInfoJson)
	if (ret.Size > 0)
	{
		if (Stream.Size=0) {
			d Stream.Write("{""record"":""")
			d Stream.CopyFrom(ret)
			d Stream.Write("""}")
		}else{	
			d Stream.Write(","_"{""record"":""")
			d Stream.CopyFrom(ret)
			d Stream.Write("""}")
		}
		s count=count+1
	}
	q
    
getSum
	s ret = ..GetHistoryDetails(flag, flagArg, episodeID, isFilterOPHistoryEmr, isIncludeOeordHistory,"",userInfoJson)
	if (ret.Size > 0)
	{
		s sum = sum+1
	}
	q
}

/// w ##Class(EMRservice.BL.opInterface).GetOPHistory(6586, 2, "" , "")
ClassMethod GetOPHistoryAll(patientID, flag, lastEpisodeID, admType As %String, pageType As %String = "", userInfoJson As %String = "") As %Stream
{
	//s ^CacheTemp("GetOPHistory")=patientID_", "_flag_", "_lastEpisodeID_", "_admType
	s Stream = ##Class(%GlobalCharacterStream).%New()
	s Json = ##Class(%GlobalCharacterStream).%New()
	s opHistoryCount=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("opHistoryCount",3)
	//是否过滤掉未写门诊病历的记录
	s isFilterOPHistoryEmr=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isFilterOPHistoryEmr","N")	
	s isIncludeOeordHistory=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isIncludeOeordHistory","N")	
	
	s count=0, result="", flagArg="", sum=0
	
	if (0=flag) { s flagArg=%session.Get("LOGON.USERCODE") }
	elseif (1=flag) { s flagArg=%session.Get("LOGON.CTLOCID") }
	
	d getAll
 	
    d Json.Write("{""total"":"_count_",""count"":"_sum_",""rows"":[")
	d Json.CopyFrom(Stream)
	d Json.Write("]}")
	q Json
	
getAll
	s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
	s episodeID=""
	s admtypeidx = "O"
 	for {	
	 	s episodeID = $O(^PAPERdr(patientID,"ADM",admtypeidx,episodeID),-1)
	 	if (episodeID="") 
	 	{
		 	if (admtypeidx = "O") 
		 	{ 
		 		s admtypeidx = "I"
		 		continue
		 	} elseif (admtypeidx = "I") 
		 	{ 
		 		s admtypeidx = "E"
		 		continue
		 	} else { q }
		}
	 	s key = ..GetHistoryKey(episodeID)
	 	d episodeIDs.SetAt(episodeID, key)
	}	

	s lastAdmDT=""
	s:(lastEpisodeID'="") lastAdmDT=..GetHistoryKey(lastEpisodeID)
	s key=""
	while (1)
	{
		s key = episodeIDs.Previous(key)
		q:(key="")
		s episodeID=episodeIDs.GetAt(key)
		continue:(admType'=$p($g(^PAADM(episodeID)),"^",2))&&(admType'="")
		continue:(key>=lastAdmDT)&&(lastAdmDT'="")

        i (count<opHistoryCount) {
            d getDetails
        }
        d getSum
	}

	q	
		
 
getDetails //根据flag，过滤不符合条件的,获取详细的就诊信息
	s ret = ..GetHistoryDetails(flag, flagArg, episodeID, isFilterOPHistoryEmr, isIncludeOeordHistory, pageType,userInfoJson)
	if (ret.Size > 0)
	{
		if (Stream.Size=0) {
			d Stream.Write("{""record"":""")
			d Stream.CopyFrom(ret)
			d Stream.Write("""}")
			//d Stream.Write("{""record"":"""_ret_"""}")
		}else{		
			d Stream.Write(","_"{""record"":""")
			d Stream.CopyFrom(ret)
			d Stream.Write("""}")
			//d Stream.Write(","_"{""record"":"""_ret_"""}")	
		}
		s count=count+1
	}
	q
    
getSum
	s ret = ..GetHistoryDetails(flag, flagArg, episodeID, isFilterOPHistoryEmr, isIncludeOeordHistory,"",userInfoJson)
	if (ret.Size > 0 )
	{
		s sum = sum+1
	}
	q
}

/// 需要被过滤掉，返回 1
ClassMethod FilterHistory(flag, flagArg, episodeID As %String) As %String
{
    //过滤退号就诊
    s admStatus = $p($g(^PAADM(episodeID)),"^",20)
	q:(admStatus = "C") "1"
    
    //院区共库判断
    s hospitalId = $Get(%session.Data("LOGON.HOSPID"))
    if (hospitalId '= "")
    {
        s showShareHospital= ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","N")
        //根据就诊号取患者所在的科室ID
        s currentDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
        s currentDeptId = $P(currentDept,"^",1)
        s locHospitalId = $p($g(^CTLOC(currentDeptId)),"^",22)
        q:((locHospitalId '= hospitalId)&&(showShareHospital="N")) "1"
    }

	if ("0"=flag)
	{
		s doc=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(episodeID)
		q:($zcvt(flagArg,"D")'=$zcvt($P($G(doc),"^",2),"D")) "1"		
	} 
	elseif ("1"=flag)
	{
		s dept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
		q:(flagArg'=$P($G(dept),"^",1)) "1"
	}	
	q "0"
}

ClassMethod getHistoryDetailTest() As %String
{
	s isIncludeOeordHistory=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isCludeOeordHistory","Y")	
	s ret = "{""total"":3,""rows"":[{""record"":""<div class='admdate'>2016-01-05<span>14:21:29</span></div>"
	s ret = ret_"<div class='diag' admID='11411'><H3></H3><br><H4>病历未书写<div class='admloc'>"
	s ret = ret_"<span>针灸科门诊 医师:</span>&nbsp&nbsp<span id='doctor'></span><br/>"
	s:(isIncludeOeordHistory="Y") ret = ret_"<a class='oeord' admID='11411'>医嘱内容...</a>"
	s ret = ret_"<a class='emrdoc' admID='8651'>病历内容1...</a></div>"
	s ret = ret_"</H4></div>""},{""record"":""<div class='admdate'>2016-01-05<span>14:21:23</span></div>"
	s ret = ret_"<div class='diag' admID='11411'><H3></H3><br><H4>初诊病历<div class='admloc'>"
	s ret = ret_"<span>针灸科门诊 医师:doctor</span>&nbsp&nbsp<span id='doctor'>蒋某某</span><br/><a class='emrdoc' admID='11411' admType='I'>详细内容...</a></div><br/><br/><br/><span class='content'><label class='chapter'>【主诉】</label><div class='text'>左侧口眼歪斜  天。</div><br/><label class='chapter'>【现病史】</label><div class='text'>缘患者  天前因吹风致左侧口眼歪斜， 左眼闭合不全，迎风流泪，噘嘴、鼓腮、吹气等动作受限，伴左耳后乳突部疼痛，左侧头痛，舌麻，左耳听觉过敏，未见疱疹，四肢活动正常。未予治疗。在本市某医院诊治，诊断为面神经麻痹，予激素、甲钴胺等治疗，疗效不显。</div><br/><label class='chapter'>【其他病史】</label><div class='text'>既往体健。{或病史描述}</div><br/><label class='chapter'>【体格检查】</label><div class='text'>左侧不完全性周围性面瘫面容。左侧贝尔氏征（＋）、吹气试验（＋）、左侧额纹、鼻唇沟变浅，左侧耳后乳突部压痛，未见疱疹。伸舌居中，四肢肌力正常，病理征（＋）。</div><br/><label class='chapter'>【辅助检查】</label><div class='text'>左侧不完全性周围性面瘫面容。左侧贝尔氏征（＋）、吹气试验（＋）、左侧额纹、鼻唇沟变浅，左侧耳后乳突部压痛，未见疱疹。伸舌居中，四肢肌力正常，病理征（＋）。</div></span><br/></H4></div>""},{""record"":""<div class='admdate'>2016-01-05<span>14:21:20</span></div><div class='diag' adm='10368448'><H3></H3><br><H4>病历未书写<div class='admloc'><span>简易门诊 医师:</span>&nbsp&nbsp<span id='doctor'></span><br/><a class='emrdoc'  admID='11411'>详细内容...</a></div></H4></div>""}]}"
	q ret
}

// 根据flag，过滤不符合条件的,获取详细的就诊信息

ClassMethod GetHistoryDetails(flag, flagArg, episodeID As %String, isFilterOPHistoryEmr As %String = "", isIncludeOeordHistory As %String = "", pageType As %String = "", userInfoJson As %String = "") As %Stream
{
	s ret = ##Class(%GlobalCharacterStream).%New()
    q:(..FilterHistory(flag, flagArg, episodeID)="1") ret
    
    ///根据传参判断是新的历史病历页面(直接展示病历内容)还是之前的历史就诊页面
    if (userInfoJson = "")
    {
		s result = ..getHistoryDetail(episodeID, isFilterOPHistoryEmr, isIncludeOeordHistory, pageType)
		d ret.Write(result)
	}
	else
	{
		s ret = ..getHistoryDetailToHistoryRecord(episodeID, isFilterOPHistoryEmr, isIncludeOeordHistory, pageType, userInfoJson)
	}
	q ret
}

/// w ##class(EMRservice.BL.opInterfaceBase).hasEPRInstance("4429154")
ClassMethod hasEPRInstance(episodeID As %String) As %String
{
	s rtn = ""
	q:(episodeID = "") rtn
	s chartItemId = ""
	for {
		s chartItemId = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",episodeID, chartItemId))
		q:(chartItemId = "")
		s id = ""
		for {
			s id =  $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",episodeID, chartItemId, id))
			q:(id = "")
			s rowId = ""
			for {
				s rowId = $o(^DHCEPRI.InstanceDataI("IdxECRecord", id, rowId))
				q:(rowId = "")
				s obj = ##class(EPRinstance.InstanceData).%OpenId(id_"||"_rowId)
				q:(obj = "")
				s:($zcvt(obj.Status,"U") = "SAVE") rtn = "1"
				q:(rtn = "1")
			}
			q:(rtn = "1")
		}
		q:(rtn = "1")	
	}
	q rtn
}

/// w ##class(EMRservice.BL.opInterfaceBase).getHistoryDetail(1291, "N", "Y" , "")
ClassMethod getHistoryDetail(episodeID As %String, isFilterOPHistoryEmr As %String = "", isIncludeOeordHistory As %String = "", pageType As %String = "") As %String
{
	//判断就诊写的是二版病历还是三版
	s IsEMR = ($d(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",episodeID))>0)
	if (IsEMR = 1) {
		s hasInstance=##Class(EMRservice.Ajax.opInterface).getFirstInstance(episodeID)
		//过滤掉未写门诊病历的记录
		q:((hasInstance="")&&(isFilterOPHistoryEmr="Y")) ""
	}else {
		s hasInstance = ..hasEPRInstance(episodeID)
		q:((hasInstance="")&&(isFilterOPHistoryEmr="Y")) ""
	}
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}	
	s admDate = $P($G(^PAADM(episodeID)),"^",6)
	s admTime = $P($G(^PAADM(episodeID)),"^",7)
	s curDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
	s curDept = $P(curDept,"^",3)
	//翻译
	s curDept = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",curDept)
	s diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
	s diagnosis = $P(diagnosis,"^",3)
	//对诊断中的特殊字符处理
	s diagnosis = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(diagnosis)
	//翻译
	s diagnosis = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",diagnosis)
	s doc=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(episodeID,"")
	s doc = $P($G(doc),"^",3)
	s doc = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",doc,langid)
		//翻译
	s doc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",doc)
	s admType = $p($g(^PAADM(episodeID)),"^",2)
	//体检报告接口
	s hasHealthReport=""
	s hasHealthReportArg=##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCHflTest||IfHealthReport")
	s:(hasHealthReportArg'=0) hasHealthReport=##class(web.DHCHflTest).IfHealthReport(episodeID)
	//add by lina 2017-09-08
	s admDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(admDate,3))
	s admTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(admTime,1))
	s recordDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","病历内容")
	s oeordDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","医嘱内容")
    s records = "" // 当前就诊书写病历实例集合
    //是否过滤掉未写门诊病历的记录
    s isShowOPHistoryTitlebtn = ##Class(EMRservice.SystemParameter).IsShowOPHistoryTitlebtn()
    s:(hasInstance'="")&&(isShowOPHistoryTitlebtn="Y")&&($zcvt(admType,"U")="O") records = ##Class(EMRservice.BL.opInterface).getInstanceByEpisodeID(episodeID,admType)
	if ("HISUI"=pageType) {
        //华西要求增加就诊类型显示
        s admTypeDesc = ""
        s:(admType = "I") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","住院")
        s:(admType = "O") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","门诊")
        s:(admType = "E") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","急诊")
        s:(admType = "H") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","体检")
        s:(admType = "N") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","新生儿")
        
        s:(hasInstance'="") hasInstance="&nbsp&nbsp<a class='emrdoc' href='#' admID='"_episodeID_"' admType='"_admType_"' index="_0_">"_recordDesc_"</a>"
        s ret = "<div>"
		s ret = ret_"<span style='float:left;'><div class='detailleft'>"
		s ret = ret_"<div class='admdate'>"_admDate_"&nbsp&nbsp"_admTime_"&nbsp&nbsp"_admTypeDesc_"</div>"
        s docInfo = curDept_"&nbsp&nbsp"_doc
        s ret = ret_"<div class='admloc' title='"_docInfo_"'>"_docInfo_"</div>"
		s ret = ret_"<div class='docandoeord'>"
		
		s oeordDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",oeordDesc)
		s:(isIncludeOeordHistory="Y") ret = ret_"<a class='oeord' href='#' admID='"_episodeID_"'>"_oeordDesc_"</a>"
		s ret = ret_hasInstance
		s ret = ret_"</div>"
		s ret = ret_"</div></span>"
		
		s ret = ret_"<span><div class='detailright'>"
		s ret = ret_"<div class='diag' admID='"_episodeID_"'>"_diagnosis_"</div>"
        s:(records'="") ret = ret_"<div class='insTitle'>"_records_"</div>"
		s ret = ret_"</div></span>"
		s ret = ret_"</div>"
	}else{
		s:(hasInstance'="") hasInstance="<a class='emrdoc' admID='"_episodeID_"' admType='"_admType_"' isEMR="_IsEMR_">"_recordDesc_"...</a>"
		s ret = "<div class='admdate'>"_admDate_"<span>"_admTime_"</span></div>"
		s ret = ret_"<div class='diag' admID='"_episodeID_"'>"
		s ret = ret_"<H4><div class='diagInfo' title='"_diagnosis_"'>"_diagnosis_"</div>"
		s ret = ret_"<div class='admloc'>"
		s ret = ret_"<span>"_curDept_"</span>&nbsp&nbsp<span name='doctor'>"_doc_"</span><br/>"
		s bodyDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","体检报告")
		s:(hasHealthReport="Y") ret=ret_"<a class='healthReport' href='#' admID='"_episodeID_"'>"_bodyDesc_"</a>"
		s:(isIncludeOeordHistory="Y") ret = ret_"<a class='oeord' admID='"_episodeID_"'>"_oeordDesc_"...</a>"
		s ret = ret_hasInstance_"</div>"
		s ret = ret_"</H4></div>"
	}

    q ret
}

/// w ##class(EMRservice.BL.opInterfaceBase).getHistoryDetail(1291, "N", "Y" , "")
ClassMethod getHistoryDetailToHistoryRecord(episodeID As %String, isFilterOPHistoryEmr As %String = "", isIncludeOeordHistory As %String = "", pageType As %String = "", userInfoJson As %String = "") As %Stream
{
	s ret2 = ##Class(%GlobalCharacterStream).%New()
	s hasInstance=##Class(EMRservice.Ajax.opInterface).getFirstInstance(episodeID)
	//过滤掉未写门诊病历的记录
	q:((hasInstance="")&&(isFilterOPHistoryEmr="Y")) ret2

	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}	
	s admDate = $P($G(^PAADM(episodeID)),"^",6)
	s admTime = $P($G(^PAADM(episodeID)),"^",7)
	s curDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
	s curDept = $P(curDept,"^",3)
	//翻译
	s curDept = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",curDept)
	s diagnosis = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
	s diagnosis = $P(diagnosis,"^",3)
	s:(diagnosis '= "") diagnosis = "诊断："_diagnosis
	//对诊断中的特殊字符处理
	s diagnosis = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(diagnosis)
	//翻译
	s diagnosis = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",diagnosis)
	s doc=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(episodeID,"")
	s doc = $P($G(doc),"^",3)
	s doc = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",doc,langid)
	//翻译
	s doc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",doc)
	s admType = $p($g(^PAADM(episodeID)),"^",2)

	//add by lina 2017-09-08
	s admDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(admDate,3))
	s admTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(admTime,1))
    s records = "" // 当前就诊书写病历实例集合
    //是否过滤掉未写门诊病历的记录
    s isShowOPHistoryTitlebtn = ##Class(EMRservice.SystemParameter).IsShowOPHistoryTitlebtn()
    s:(hasInstance'="")&&(isShowOPHistoryTitlebtn="Y")&&($zcvt(admType,"U")="O") records = ##Class(EMRservice.BL.opInterface).getInstanceByEpisodeIDToHistoryRecord(episodeID,admType,userInfoJson)

    //华西要求增加就诊类型显示
    s admTypeDesc = ""
    s:(admType = "I") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","住院")
    s:(admType = "O") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","门诊")
    s:(admType = "E") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","急诊")
    s:(admType = "H") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","体检")
    s:(admType = "N") admTypeDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","新生儿")
    
    
    s ret = "<div>"
	s ret = ret_"<span style='float:left;'><div class='detailleft'>"
	s ret = ret_"<div class='admdate'>"_admDate_"&nbsp&nbsp"_admTime_"&nbsp&nbsp"_admTypeDesc_"</div>"
    s docInfo = curDept_"&nbsp&nbsp"_doc
    s ret = ret_"<div class='admloc' title='"_docInfo_"'>"_docInfo_"</div>"
	s ret = ret_"<div class='diag' admID='"_episodeID_"'>"_diagnosis_"</div>"
	s ret = ret_"</div></span>"
	
	d ret2.Write(ret)
	d ret2.Write("<span><div class='detailright'>")
    d ret2.Write("<div class='recordInfo'>")
    d ret2.Write("<span>")
    d ret2.CopyFrom(records)
    d ret2.Write("</span>")
    d ret2.Write("</div>")
	d ret2.Write("</div></span>")
	d ret2.Write("</div>")

    q ret2
}

/// DESC:获取患者指定就诊书写病历记录
/// w ##Class(EMRservice.BL.opInterface).getInstanceByEpisodeID("222","O")
ClassMethod getInstanceByEpisodeID(AEpisodeID As %String, AdmType As %String) As %String
{
    s ret = "", count = 0
    q:(AEpisodeID = "")||(AdmType = "")||('$d(%session)) ret
    s userLocID = %session.Get("LOGON.CTLOCID")
    s ssgroupID = %session.Get("LOGON.GROUPID")
    
    s ArrCate = ##Class(%ArrayOfDataTypes).%New()
    s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
    d result.Execute(userLocID, ssgroupID, AEpisodeID)
    while result.%Next()
    {
        s ItemType = result.Data("ItemType")
        continue:(ItemType = "HIS")
        s categoryId = result.Data("ItemCategoryID")
        d ArrCate.SetAt(categoryId, categoryId)
    }

    s CategoryID = ""
    for {
        s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
        q:(CategoryID="")
            
        s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, ""))
        s id = "" 
        for {
            s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_CategoryID, id))
            q:(id="")
            
            
            s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
            
            s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
            s ecID = $tr(ecRecordID," ","")
         
            s insID = ""
            for {
                s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID),-1)
                q:("" = insID)
				s chapter = ""
                s chapter=##Class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
				continue:(chapter="")
                s cate=##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
                continue:("" = ArrCate.GetAt(cate.ParentCategoryID))
                if (ret '= "") {
                    s ret=ret_"&nbsp&nbsp"
                }
                s recordDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",cate.CategoryName)
                s ret = ret_"<a class='emrdoc' href='#' admID='"_AEpisodeID_"' admType='"_AdmType_"' index="_count_" insID='"_ecID_"||"_insID_"'>"_recordDesc_"</a>"
                s count = count + 1
            }
        }       
    }
    
	q ret
}

/// DESC:获取患者指定就诊书写病历记录
/// w ##Class(EMRservice.BL.opInterface).getInstanceByEpisodeIDToHistoryRecord("222","O").Read()
ClassMethod getInstanceByEpisodeIDToHistoryRecord(AEpisodeID As %String, AdmType As %String, userInfoJson As %String) As %Stream
{
	s ret = ##Class(%GlobalCharacterStream).%New()
	
	///未配置参数直接q空      ///176:S001^Header^Footer|351|234:Header^Footer
	s historyRecordShowDetail = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OPHistoryRecordShowDetail","")
	q:(historyRecordShowDetail = "") ret
	
	
	///数组，docID做key，章节code做value
	s historyRecordShowDocID = ""
	s arr = ##Class(%ArrayOfDataTypes).%New()
	s historyRecordShowDetailCount = $l(historyRecordShowDetail,"|")
	for i=1:1:historyRecordShowDetailCount
	{
		s historyRecordShowInfo = $p(historyRecordShowDetail,"|",i)
		s docID = $p(historyRecordShowInfo,":",1)
		s sectionCode = $p(historyRecordShowInfo,":",2)
		//章节如果未配置，默认给个-用于后面判断
		s:(sectionCode = "") sectionCode = "-"
		d arr.SetAt(sectionCode, docID)
	}
    q:(AEpisodeID = "")||(AdmType = "")||(userInfoJson = "") ret
    s userInfo = ##class(EMRservice.Util.Json).FromJson(userInfoJson)
    
    s userLocID = userInfo.GetAt("userLocID")   //%session.Get("LOGON.CTLOCID")
    s ssgroupID = userInfo.GetAt("ssgroupID")   //%session.Get("LOGON.GROUPID")
    s userID = userInfo.GetAt("userID")
    s patientID = $p($g(^PAADM(AEpisodeID)),"^",1)
    
    s ArrCate = ##Class(%ArrayOfDataTypes).%New()
    s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
    d result.Execute(userLocID, ssgroupID, AEpisodeID)
    while result.%Next()
    {
        s ItemType = result.Data("ItemType")
        continue:(ItemType = "HIS")
        s categoryId = result.Data("ItemCategoryID")
        d ArrCate.SetAt(categoryId, categoryId)
    }

    s ChartItemID = ""
    for {
        s ChartItemID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ChartItemID))
        q:(ChartItemID="")
        
        //过滤掉未配置的DocID
        s filterSectionCode = arr.GetAt(ChartItemID)
        continue:(filterSectionCode = "")
        
        s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ChartItemID, ""))
        s id = "" 
        for {
            s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_ChartItemID, id))
            q:(id="")
                    
            s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
            
            s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
            s ecID = $tr(ecRecordID," ","")
         
            s insID = ""
            for {
                s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID),-1)
                q:("" = insID)
				s chapter = ""
                s chapter=##Class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
				continue:(chapter="")
                s cate=##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
                continue:("" = ArrCate.GetAt(cate.ParentCategoryID))
                //展示BS浏览页面
                /*if (ret.Size > 0) {
                    d ret.Write("&nbsp&nbsp")
                }
                s recordDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",cate.CategoryName)
                
                s html = ##Class(EMRservice.BLBSParseXML).GetEMRHtmlData(ecID_"||"_insID,"EMR")
                s newHtml = ##Class(%GlobalCharacterStream).%New()
                while (html.AtEnd = 0)
				{
					s tmp = $tr(html.Read(32000),"""","'")
					d newHtml.Write(tmp)
				}*/
				
				if (ret.Size > 0) {
                    d ret.Write("<hr style='height:1px;border:none;border-top:1px solid #555555;'/>")
                }
                
                s instanceID = ecID_"||"_insID
                s instanceObj = ##class(EMRinstance.InstanceData).%OpenId(instanceID,0)
                s title = instanceObj.Title
                s browsePrivilege = ##class(EMRservice.Ajax.privilege).GetBrowsePrivilege(userID,userLocID,ssgroupID,AEpisodeID,patientID,instanceID)
                s browsePrivilegeObj = ##class(EMRservice.Util.Json).FromJson(browsePrivilege)
                s canView = browsePrivilegeObj.GetAt("canView")
                s cantViewReason = browsePrivilegeObj.GetAt("cantViewReason")
				if (canView '= "1")
				{
					s content = ##Class(%GlobalCharacterStream).%New()
					d content.Write("<"_title_">无浏览权限："_cantViewReason)
				}
				else
				{
					s content = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent(instanceID,filterSectionCode)
				}
				
                s newContent = ##Class(%GlobalCharacterStream).%New()
                while (content.AtEnd = 0)
				{
					s tmp = $replace(content.Read(32000),$c(10,13),"<br/>")
					d newContent.Write(tmp)
				}

                d ret.CopyFrom(newContent)
            }
        }       
    }
	q ret
}

/// DESC:根据患者的patientID获取其所有门(急)诊的就诊记录(过滤掉未写门(急)诊病历的就诊记录)
/// w ##Class(EMRservice.BL.opInterface).GetOEPEpisodeListByPID(20).OutputToDevice()
ClassMethod GetOEPEpisodeListByPID(patientID As %String) As %Stream
{
    s Json = ##Class(%GlobalCharacterStream).%New()
    q:(patientID = "") Json
    
    s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
    s episodeID = ""
    s admtypeidx = "O"
    for {   
        s episodeID = $O(^PAPERdr(patientID,"ADM",admtypeidx,episodeID),-1)
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

        s key = ..GetHistoryKey(episodeID)
        d episodeIDs.SetAt(episodeID, key)
    }   

    s key = ""
    while (1)
    {
        s key = episodeIDs.Previous(key)
        q:(key = "")
        s episodeID = episodeIDs.GetAt(key)
        //过滤掉未写门(急)诊病历的就诊记录
        s hasInstance = ##Class(EMRservice.Ajax.opInterface).getFirstInstance(episodeID)
        continue:(hasInstance = "")
        
        if (Json.Size = 0) {
            d Json.Write(episodeID)
        }else{      
            d Json.Write(","_episodeID)  
        }
    }
    
    q Json
}

/// ///////////////	GetOPHistory END  //////////////////
/// w ##Class(EMRservice.BL.opInterfaceBase).getAllInstance(1, 32, 11411, 2062)
ClassMethod getAllInstance(ACTLocId, ASSGroupID, AEpisodeID, AUserID As %String) As %String
{
	s json = "",count = 0
	q:(AEpisodeID = "") json
	
	s ArrCate = ##Class(%ArrayOfDataTypes).%New()
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetAllCategory")
	d result.Execute(AEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		d ArrCate.SetAt(categoryId, categoryId)
	}

	s ret=""
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
		q:(CategoryID="")
			
		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, ""))
		s id = "" 
		for {
            		s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_CategoryID, id))
			q:(id="")
			
			
			s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
			
			s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
			s ecID = $tr(ecRecordID," ","")
		 
		 	s insID = ""
		 	for {
				s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID),-1)
		 		q:(""=insID)
		 	
		 		s chapter=##Class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
		 		s cate=##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
		 		continue:(""=ArrCate.GetAt(cate.ParentCategoryID))
		
                s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(ecID_"||"_insID)
				s item="{""id"":"""_ecID_"||"_insID_""","
				s item=item_"""actionType"":""LOAD"","
				s item=item_"""categoryId"":"""_cate.ParentCategoryID_""","
				s item=item_"""chartItemType"":"""_tmpl.ChartItemType_""","
				s item=item_"""closable"":true,"
				s item=item_"""emrDocId"":"""_emrTmpl.CategoryID_""","
                s item=item_"""isLeadframe"":"""_chapter.IsLeadframe_""","
				s item=item_"""isMutex"":"""_chapter.IsMutex_""","
				s item=item_"""pluginType"":"""_tmpl.DocumentType_""","
				s item=item_"""status"":""NORMAL"","
				s item=item_"""templateId"":"""_emrTmpl.BindTemplateID_""","
                s item=item_"""titleCode"":"""_objInstance.TitleCode_""","
				//s item=item_"""text"":"""_emrTmpl.TemplateName_"""}"
				//s item=item_"""text"":"""_objInstance.Title_"""}"
				s item=item_"""text"":"""_cate.CategoryName_"""}"
			
			if (ret="") { s ret=item} else { s ret=ret_","_item }
			}
		}	 	
	}
	
	q "["_ret_"]"
}

/// ///////////////	证明书审核  //////////////////
/// 河南省人民医院 在三级医生审核之外有特殊业务审核的要求
/// w ##class(EMRservice.BL.opInterface).InsertAudit("75||3","4380","4380")
ClassMethod InsertAudit(instanceId, auditUsr, usrId As %String) As %String
{
	s obj=##Class(EMRinstance.ExtAuditLog).%New()
	s obj.InstanceId=instanceId
	s obj.Operator=usrId
	s obj.AuditUser=auditUsr
	s obj.AuditDate=$P($h,",",1)
	s obj.AuditTime=$P($h,",",2)
	s obj.Action="checked"
	s obj.Status="1"
	d obj.%Save()
	q 1
}

/// 	desc：	审核拒绝
/// w ##class(EMRservice.BL.opInterface).InsertRefuse("75||3","4380","4380")
ClassMethod InsertRefuse(instanceId, auditUsr, usrId As %String) As %String
{
	s obj=##Class(EMRinstance.ExtAuditLog).%New()
	s obj.InstanceId=instanceId
	s obj.Operator=usrId
	s obj.AuditUser=auditUsr
	s obj.AuditDate=$P($h,",",1)
	s obj.AuditTime=$P($h,",",2)
	s obj.Action="refused"
	s obj.Status="1"
	d obj.%Save()
	q 1
}

/// w ##Class(EMRservice.BL.opInterface).GetOPPatList("","张晓晨","")
/// w ##Class(EMRservice.BL.opInterface).GetOPPatList("0000000335","","","","2020-09-04","2020-09-04","")
/// w ##Class(EMRservice.BL.opInterface).GetOPPatList("","","0805806519")
ClassMethod GetOPPatList(APapmiNo As %String = "", AName As %String = "", ACardID As %String = "", AExpectedLocId As %String = "", AStartDate As %String = "", AEndDate As %String = "", ACheckStatus As %String = "", ADocIDType As %String = "") As %GlobalCharacterStream
{
    s Json = ##Class(%GlobalCharacterStream).%New()
    s Stream = ##Class(%GlobalCharacterStream).%New()
    s count = 0, cjson = "" , countflag = 1
    
    // 新建一个队列，为了按照就诊日期和就诊时间排序		默认查询3天内数据，如果只给了开始或者结束时间，也是给定时间的后三天后者前三天数据
    s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
    if (AEndDate="")&&(AStartDate="")
    {
		s AEndDate = $p($h,",",1)
		if (AStartDate="")
		{
			s AStartDate = AEndDate- 2
		}
	}
    s sysStdate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AStartDate)
    s sysEnddate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",AEndDate)
    if (sysStdate="")&&(sysEnddate'="")
    {
		s sysStdate = sysEnddate - 2
	}
	if (sysStdate'="")&&(sysEnddate="")
    {
		s sysEnddate = sysStdate + 2
	}
	//从系统参数获取模板docid
    s DiagnoseProofDocID = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("DiagnoseProofDocID")
    if (ADocIDType="")||(ADocIDType="ALL"){
        s DiagnoseProofDocID = $p(DiagnoseProofDocID,"|",1)
    }else{
        s DiagnoseProofDocID = ADocIDType
    }
    //获取是否显示所有就诊记录
    s getAllDataFlag = ##Class(EMRservice.SystemParameter).IsGetAllDataInAudit()
    
    // 登记号不为空，按照登记号查所有就诊记录
    if (APapmiNo'=""){
        
        s PapmiNo = $O(^PAPERi("PAPMI_PatNo",APapmiNo,""))
        q:(PapmiNo="") "{""total"":0,""rows"":[]}"
        
        d GetAllEpisodeID
    }
    // 卡号不为空就按照卡号查
    elseif (ACardID'=""){
        
        s CFRowID = ""
        for {
            s CFRowID = $O(^DHCCARDi("CF",0,"CardNo",ACardID,CFRowID),-1)
            q:(CFRowID="")
            s PapmiNo = $P(^DHCCARD("CF",CFRowID),"^",4)
            q:(PapmiNo="")
            
            d GetAllEpisodeID
        }
    }
    // 姓名不为空就按照姓名查
    elseif (AName'=""){
        
        s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
        s PapmiNo = ""
        for {
            
            s PapmiNo = $O(^PAPERi("PAPER_PatName",$zstrip(AName,"*p"),PapmiNo),-1)
            q:(PapmiNo = "")
            
            d GetAllEpisodeID
        }
    }
    elseif (AExpectedLocId '= ""){
        s admDate = ""
        for
        {
            s admDate = $o(^PAADMi("CurrLoc",AExpectedLocId,admDate),-1)
            q:(admDate = "")
            continue:((sysStdate '= "")&&(sysEnddate '="")&&((admDate>sysEnddate)||(admDate<sysStdate)))
            s admTime = ""
            for
            {
                s admTime = $o(^PAADMi("CurrLoc",AExpectedLocId,admDate,admTime),-1)
                q:(admTime = "")
                s episodeid = ""
                for
                {
                    s episodeid = $o(^PAADMi("CurrLoc",AExpectedLocId,admDate,admTime,episodeid),-1)
                    q:(episodeid = "")
                    s admType = $p($g(^PAADM(episodeid)),"^",2)
                    if ((admType = "O")||(admType = "E"))
                    {
						if (getAllDataFlag '= "Y")
						{
							s episodeIdFlag = 0
							for i=1:1:$l(DiagnoseProofDocID,"^")
							{
								s docId = $p(DiagnoseProofDocID,"^",i)
								s ecId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",episodeid,docId,""))
								if (ecId '= "")
								{
									s episodeIdFlag = 1
									q
								}
							}
							continue:(episodeIdFlag=0)
						}
						d EpisodeIDsArray
					}
                }
            }
        }
    }elseif (sysStdate '= "")&(sysEnddate '= ""){
        for admDate = sysStdate:1:sysEnddate {
            s episodeid = ""
            for {
                s episodeid = $o(^PAADMi("PAADM_AdmDate",admDate,episodeid))
                q:(episodeid = "")
                s admType = $p($g(^PAADM(episodeid)),"^",2)
				if ((admType = "O")||(admType = "E"))
				{
					if (getAllDataFlag '= "Y")	//如果不是查询全部数据，就只把有诊断证明书的就诊号存起来
					{
						s episodeIdFlag = 0
						for i=1:1:$l(DiagnoseProofDocID,"^")
						{
							s docId = $p(DiagnoseProofDocID,"^",i)
							s ecId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",episodeid,docId,""))
							if (ecId '= "")
							{
								s episodeIdFlag = 1
								q
							}
						}
						continue:(episodeIdFlag=0)
					}
					d EpisodeIDsArray
				}
            }
       }
    }
    
    d GetSortEpisode

    d Json.Write("{""total"":"_count_",""rows"":[")
    d Json.CopyFrom(Stream)
    d Json.Write("]}")
    q Json

GetAllEpisodeID       
    s AdmType = "O" , episodeid = ""
    for {
        s episodeid = $O(^PAPERdr(PapmiNo,"ADM",AdmType,episodeid),-1)
        if (episodeid="") {
            if (AdmType = "O"){ 
                s AdmType = "E"
                s episodeid=""
                continue
            } 
            else { q }
        }
        // 按照时间倒叙
        d EpisodeIDsArray
    }
    
    q

EpisodeIDsArray
    s d = $P($G(^PAADM(episodeid)),"^",6)
    s t = "0000"_($P($G(^PAADM(episodeid)),"^",7))
    s e = "000000000"_episodeid
    s key = d_$E(t,$L(t)-4,$L(t))_$E(e,$L(e)-9,$L(e))
    d episodeIDs.SetAt(episodeid, key)
    q
        
GetSortEpisode        
    s key=""
    while (1){
        s key = episodeIDs.Previous(key)
        q:(key = "")
        s episodeid = episodeIDs.GetAt(key)
        //q:(countflag=1000)
        d outputrow(episodeid)
    }
    q
        
outputrow(episodeid)

    s (EpisodeID,PapmiDR,Name,GenderDesc,Age,DeptDesc,AdmDocDesc,MainDiag,CardNo) = ""
    
    s EpisodeID = episodeid
    
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
    
    s instanceId = "", chartItemType = "", pluginType = "", status = "未创建", title = "", auditStatus = "未审核",auditDate = "",auditTime = ""
    //诊断证明书DocId 299
    s result = ##Class(%Library.ResultSet).%New("EMRservice.BL.opInterfaceBase:GetDataByDocID")
	
	d result.Execute(EpisodeID,DiagnoseProofDocID)
    While (result.Next()) {
	    s instanceId = "", chartItemType = "", pluginType = "", status = "未创建", title = "", auditStatus = "未审核",auditDate = "",auditTime = ""
        s instanceId = $g(result.Data("ID"))
        s chartItemType = $g(result.Data("ChartItemType"))
        s pluginType = $g(result.Data("DocumentType"))
        s status = $Case($zcvt($g(result.Data("Status")),"U"),"UNSAVE":"未保存","DELETE":"已删除","SAVE":"已保存")
        // 过滤未保存的病历记录
        continue:((getAllDataFlag '= "Y")&&(status = "未保存"))
        s tmpDocId = $g(result.Data("DocId"))
        s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(result.Data("Title"))
        
        s singFlag = ##Class(EMRservice.BOPrivAssist).HasValidSign(instanceId)
        if (status = "已删除") {
            s auditStatus = "作废"
        } 
        else {
	        if (singFlag = 1)
	        {
		    	s status = "已签名"
		    }
            s auditRowID = $O(^DHCEMRI.ExtAuditLogI("IdxInsId"," "_instanceId,""),-1)
            if (auditRowID '= "") {
                s objExtAudit = ##class(EMRinstance.ExtAuditLog).%OpenId(auditRowID)
                s:((objExtAudit.Action = "checked")&&(objExtAudit.Status = "1")) auditStatus = "已审核"
				s:((objExtAudit.Action = "refused")&&(objExtAudit.Status = "1")) auditStatus = "拒绝"
                s auditDate = $ZD(objExtAudit.AuditDate,3)
                s auditTime = $ZT(objExtAudit.AuditTime)
            }
        }
        continue:((ACheckStatus '= "")&&(ACheckStatus '= "全部")&&(ACheckStatus '= auditStatus))

        d json
    }
    if (result.%ROWCOUNT = 0)||(result.%ROWCOUNT = "") {
	    q:(getAllDataFlag '= "Y")
		q:((ACheckStatus '= "")&&(ACheckStatus '= "全部")&&(ACheckStatus '= auditStatus))
        d json
    }
    s countflag = countflag + 1
    q
json
	//卡号
    s CardNo = "" //##class(EMRservice.HISInterface.PatientInfoAssist).GetCardNo(PapmiDR)
    s CFRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDR,""))
    if (CFRowId '= "") {
        s CardNo = $p($g(^DHCCARD("CF",CFRowId)),"^",2)
    }
    
    //姓名
    s Name = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
    
    //身份证号
    s IDCard = ##Class(EMRservice.HISInterface.PatientInfoAssist).IDCard(PapmiDR)
    
    //性别
    s Gender = ##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
    s:(Gender'="") GenderDesc = $P(Gender,"^",3)
    
    //年龄
    s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
    s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID, "")
    s admDate = $P(admDate, ",", 1)
    s Age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(EpisodeID,birthday,admDate,1)
    
    //就诊日期,时间
    s AdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
    s AdmDate = $P(AdmDateTime,",",1)
    q:((sysStdate '= "")&&(sysEnddate '="")&&((AdmDate>sysEnddate)||(AdmDate<sysStdate)))
    s AdmDate = $zd(AdmDate,3)
    
    s AdmDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",AdmDate)

    s AdmTime = $P(AdmDateTime,",",2)
    s AdmTime = $ZT(AdmTime)
    s AdmTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",AdmTime)

    //科室
    s tmpDisDept=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(EpisodeID,"")
    s DeptId = $P(tmpDisDept,"^",1)
    q:((AExpectedLocId '= "")&&(DeptId '= AExpectedLocId))
    s DeptDesc = $P(tmpDisDept,"^",3)
    
    //主管医师
    s AdmDocDesc = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(EpisodeID,"")
    s AdmDocDesc = $P(AdmDocDesc,"^",3)
    
    //门诊诊断
    s OPDiagStringH = ""
    s MRadm = $P($G(^PAADM(EpisodeID)),"^",61)
    /*s tmpOPDiagDict = ##class(web.DHCDocDiagnosNew).GetMRDiagnoseList(MRadm,"","") 
    i tmpOPDiagDict'="" {
        s OPDiagLength = $L(tmpOPDiagDict,$C(1))
        f i = 1:1:OPDiagLength
        {
            s:(OPDiagStringH '= "") OPDiagStringH = OPDiagStringH_","
            s OPDiagStringH = OPDiagStringH_$P($P(tmpOPDiagDict,$C(1),i),"^",1)
        }
        
    }*/
	//备注
    s OPDiagStringR =""
    //前缀 prefix
    s OPDiagStringP =""
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")	
	d obj.Execute(MRadm,"","")
	s sum = 0
	s OPDiagString = ""
	While (obj.Next())
	{
		s OPDiagStringH = obj.Data("DiagnosDesc")
		s OPDiagStringR = obj.Data("DiagnosMRDesc")
		s OPDiagStringP = obj.Data("DiagnosPrefix")
		
		s:(sum '=0) OPDiagString =OPDiagString_","
		s OPDiagString = OPDiagString_OPDiagStringP_OPDiagStringH_"("_OPDiagStringR_")"
		s sum = sum + 1
	}
	
    s cjson = "{"
    s cjson = cjson_ """PatientID"":"""_PapmiDR_""""
    s cjson = cjson_ ",""EpisodeID"":"""_EpisodeID_""""
    s cjson = cjson_ ",""mradm"":"""_EpisodeID_""""
    s cjson = cjson_ ",""PAPMIName"":"""_Name_""""
    s cjson = cjson_ ",""PAPMISex"":"""_GenderDesc_""""
    s cjson = cjson_ ",""PAPMIIDCard"":"""_IDCard_""""
    s cjson = cjson_ ",""PAPMIAge"":"""_Age_""""
    s cjson = cjson_ ",""PAAdmDate"":"""_AdmDate_""""
    s cjson = cjson_ ",""PAAdmTime"":"""_AdmTime_""""
    s cjson = cjson_ ",""PAAdmLoc"":"""_DeptDesc_""""
    s cjson = cjson_ ",""PAAdmDoc"":"""_AdmDocDesc_""""
    s cjson = cjson_ ",""Diagnosis"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(OPDiagStringH)_""""
    s cjson = cjson_ ",""InstanceID"":"""_instanceId_""""
    s cjson = cjson_ ",""ChartItemType"":"""_chartItemType_""""
    s cjson = cjson_ ",""PluginType"":"""_pluginType_""""
    s statusTrans = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",status)
    s cjson = cjson_ ",""Status"":"""_statusTrans_""""
    s titleTrans = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",title)
    s cjson = cjson_ ",""Title"":"""_titleTrans_""""
    s auditStatusTrans = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",auditStatus)
    s cjson = cjson_ ",""AuditStatus"":"""_auditStatusTrans_""""
    s cjson = cjson_ ",""AuditDate"":"""_auditDate_""""
    s cjson = cjson_ ",""AuditTime"":"""_auditTime_""""
	s cjson = cjson_ ",""DocId"":"""_+$g(tmpDocId)_""""
    s cjson = cjson_ "}"
    d:(count '= 0) Stream.Write(",")
    d Stream.Write($ZSTRIP(cjson,"*C"))
    s count = count + 1
    q
}

/// desc:	根据就诊号和docId获取ECRecord表和instanceData表中的数据
/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.opInterface","GetDataByDocID",1587,299)
Query GetDataByDocID(AEpisodeID As %String, AEMRDocID As %String) As %Query(ROWSPEC = "ID,Status,Title,ChartItemType,DocumentType,DocId")
{
}

ClassMethod GetDataByDocIDExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AEMRDocID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	
	for i=1:1:$l(AEMRDocID,"^")
	{
		s docId = $p(AEMRDocID,"^",i)
		s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId,""))
		s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecrecordId)
		continue:(objECRecord="")
		s subId = ""
		for
		{
			s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
			s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(ecrecordId_"||"_subId)
			q:(objInstanceData="")
            		continue:(objInstanceData.RealEpisodeID '= AEpisodeID)
			s ID = ecrecordId_"||"_subId
			s Status = objInstanceData.Status
			s Title = objInstanceData.Title
			s ChartItemType = objECRecord.ChartItemType
			s DocumentType = objECRecord.DocumentType
			d OutPut
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
    set Data=$lb(ID,Status,Title,ChartItemType,DocumentType,docId)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataByDocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataByDocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.opInterface","SelectDataByEMRDocID",1823,299)
Query SelectDataByEMRDocID(AEpisodeID As %String, AEMRDocID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Status,Title,ChartItemType,DocumentType", SELECTMODE = "RUNTIME") [ SqlName = SelectDataByEMRDocID, SqlProc ]
{
    SELECT a.ID,a.Status,a.Title,b.ChartItemType,b.DocumentType FROM EMRinstance.InstanceData AS a JOIN EMRinstance.ECRecord AS b ON a.EpisodeID=b.EpisodeID WHERE b.EpisodeID=:AEpisodeID AND b.ChartItemID->ID=:AEMRDocID AND a.TheECRecord IN (b.ID) ORDER BY a.Status DESC
    --SELECT ID,Status,Title,b.ChartItemType,b.DocumentType FROM EMRinstance.InstanceData WHERE TheECRecord IN (SELECT ID FROM EMRinstance.ECRecord AS b WHERE ChartItemID=:AEMRDocID) AND EpisodeID=:AEpisodeID ORDER BY Status DESC
}

/// w ##Class(EMRservice.BL.opInterface).GetSSUserByLocID(335)
ClassMethod GetSSUserByLocID(ALocID As %String) As %String
{
	s cjson = ""
	q:(ALocID="") cjson

	// 从科室的编号开始查询所有相关的用户
	s ctloc=^CTLOC(ALocID)
	q:ctloc="" "0"
	s ctlocName=$p(ctloc, "^", 1)
    
	s RowID = 0
	for {
		s RowID = $o(^SSU("SSUSR",RowID))
		
		q:(RowID = "")
		s user = $g(^SSU("SSUSR",+RowID))
		s usrName = $p(user,"^",1)
		s Name = $p(user,"^",2)
		s Initials = $p(user,"^",1)
		
		s CTPCPID = $p(user,"^",14)
		//根据资源表来判断用户科室  RB_Resource
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowID})
		;b ;1
		if ($d(^RB("RES",0,"CTPCP",+CTPCPID,ALocID)))
			{
				s:(cjson'="") cjson=cjson_","
				s cjson = cjson_"{"
				s cjson = cjson_ """ID"":"""_RowID_""""
				s cjson = cjson_ ",""Name"":"""_Initials_" - "_Name_""""
				s cjson = cjson_ "}"
			}
	
		}
		
	s cjson = $ZSTRIP(cjson,"*C")
	q "["_cjson_"]"
}

/// desc:   根据系统参数DiagnoseProofDocID获取为json结构数据,格式：{"DocID":"ALL","Desc":"全部"},{"DocID":"102","Desc":"假条"}......
/// w ##class(EMRservice.BL.opInterface).GetDocIDTypeData()
ClassMethod GetDocIDTypeData() As %String
{
    s json = ""
    //从系统参数获取模板docid
    s DiagnoseProofDocID = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("DiagnoseProofDocID")
    q:(DiagnoseProofDocID="") json
    s allDesc = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans","全部")
    s json = "{""DocID"":""ALL"",""Desc"":"""_allDesc_""",""selected"":""true""}"
    s DocIDs = $p(DiagnoseProofDocID,"|",1)
    s Descs = $p(DiagnoseProofDocID,"|",2)
    s length = $l(DocIDs,"^")
    for i=1:1:length
    {
        s docID = $p(DocIDs,"^",i)
        s desc = $p(Descs,"^",i)
        s:(json'="") json = json_","
        s descTrans = ##class(EMRservice.HISInterface.Translation).Get("EMRTrans",desc)
        s json = json_"{"
        s json = json_ """DocID"":"""_docID_""""
        s json = json_ ",""Desc"":"""_descTrans_""""
        s json = json_ "}"
    }
    s json = $ZSTRIP(json,"*C")
    q "["_json_"]"
}

/// Desc:       获取诊断证明书操作日志，包括审核和病历的操作
/// Creator:    liuyunfei
/// CreateDate: 2021-08-20
/// Table:		
/// Input:      AEpisodeID:AEpisodeID, ADocID:ADocID, AInstanceID:AInstanceID
/// Output:     日志信息
/// return:		
/// Debug:      w ##class(EMRservice.BL.opInterfaceBase).GetAuditAndPrintLog(4269,299,"697||1")
ClassMethod GetAuditAndPrintLog(AEpisodeID As %String, ADocID As %String, AInstanceID As %String) As %String
{
	//##Class(EMRservice.Ajax.logdetailrecord).GetDetailLog(441,56,1)
	q:(AInstanceID="")||(AEpisodeID="")||(ADocID="")
	
	s EMRNum = $p(AInstanceID,"||",2)
	s json = ""
	s count = 0
	k ^TempAuditLogSort
	s ds = ##class(%ResultSet).%New("EMRservice.BL.BLEMRLogs:GetDetialLog")
	d ds.Execute(AEpisodeID,ADocID,EMRNum)
	While (ds.Next())
	{
		s json = ""
		s json = json_"{"
		s json = json_"""OrderID"":"""_"#count#"_""","
		s json = json_"""LoginUserName"":"""_ds.Data("LoginUser")_""","
		s json = json_"""OperUserName"":"""_ds.Data("OperUser")_""","
		s json = json_"""OperDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OperDate"))_""","
		s json = json_"""OperTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OperTime"))_""","
		s json = json_"""MachineIP"":"""_ds.Data("MachineIP")_""","
		if (ds.Data("Action") = "打印")
		{
			s actionName = ##Class(EMRservice.BL.BLOperationNameBasedProduct).GetOperationName("print",ds.Data("ProductSourceCode"))
			s:(actionName = "") actionName = "已打印"
			s json = json_"""Action"":"""_actionName_""","
		}else{
			s json = json_"""Action"":"""_ds.Data("Action")_""","
		}
		s json = json_"""ProductSource"":"""_ds.Data("ProductSource")_""""
		s json = json_"}"
		s key =  $ZDH(ds.Data("OperDate"),3)_$ZTH(ds.Data("OperTime"),1)
		s ^TempAuditLogSort(key) = json
	}
	s AuditRowID = ""
	for
	{
		s AuditRowID = $O(^DHCEMRI.ExtAuditLogI("IdxInsId"," "_AInstanceID,AuditRowID))
		q:(AuditRowID="")
		s objInstance = ##Class(EMRinstance.ExtAuditLog).%OpenId(AuditRowID)
		q:(objInstance="")
		s json = ""
		s json = json_"{"
		s json = json_"""OrderID"":"""_"#count#"_""","
		s json = json_"""LoginUserName"":"""_$p($g(^SSU("SSUSR",objInstance.Operator)),"^",2)_""","
		s json = json_"""OperUserName"":"""_$p($g(^SSU("SSUSR",objInstance.AuditUser)),"^",2)_""","
		s json = json_"""OperDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objInstance.AuditDate)_""","
		s json = json_"""OperTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objInstance.AuditTime)_""","
		s json = json_"""MachineIP"":"""","
		if (objInstance.Action = "checked")
		{
			s actionName = "已审核"
		}else{
			s actionName = "已拒绝"
		}
		s json = json_"""Action"":"""_actionName_""","
		s json = json_"""ProductSource"":""门诊诊断证明书"""
		s json = json_"}"
        s key = objInstance.AuditDate_objInstance.AuditTime
		s ^TempAuditLogSort(key) = json
	}
	s key = "",json = ""
	for
	{
		s key =$o(^TempAuditLogSort(key))
		q:(key="")
		s count = count +1
		s:(json'="") json = json_","
		s jsonData = ^TempAuditLogSort(key)
		s jsonData = $REPLACE(jsonData,"#count#",count)
		s json = json _jsonData
	}
	k ^TempAuditLogSort
	s json = "["_json_"]"
	q json
}

/// ///////////////	证明书审核 END  //////////////////
/// w ##Class(EMRservice.BL.opInterface).GetAuditLog("226||22")
ClassMethod GetAuditLog(AInstanceID As %String) As %String
{
	
	q:(AInstanceID = "") ""
	
	s AuditRowID = "",String = ""
	
	for {
		
		s AuditRowID = $O(^DHCEMRI.ExtAuditLogI("IdxInsId"," "_AInstanceID,AuditRowID))
		q:(AuditRowID="")
		
		s objInstance = ##Class(EMRinstance.ExtAuditLog).%OpenId(AuditRowID)
		if (objInstance.Action = "checked")&&(objInstance.Status = "1")
		{
			s AuditUser = objInstance.AuditUser
			s:(AuditUser'="") AuditUser =  $P(^SSU("SSUSR",AuditUser),"^",2)
			
			s AuditDate = objInstance.AuditDate
			s AuditTime = objInstance.AuditTime
			
			s:(AuditDate'="") AuditDate = $ZD(AuditDate,3)
			s:(AuditTime'="") AuditTime = $ZT(AuditTime)
					
			s:(String'="") String = String_"^"
			s String = String_"审核日期:"_AuditDate_" "_AuditTime_"  审核人:"_AuditUser
		}
		else
		{
			continue
		}
 
	}
	
	q String
}

/// w ##Class(EMRservice.BL.opInterfaceBase).GetPatientInfo("","")
ClassMethod GetPatientInfo(patientID As %String, episodeID As %String) As %String
{
	s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName(episodeID)
	
	s patientInfo = ""
	s papmiNo = ""		//登记号
	s name = ""			//姓名
	s age = ""			//年龄
	s gender = ""		//性别
	s disBed = ""		//出院床位
	s payType = ""		//付费类型
	s admDate = ""		//入院日期
	s mainDiagnos = ""	//主要诊断
	s ipRecordNo = "" 	//病案号
	s Num= ""           //余额
	s dept = ""
	s birthday = ""
	
	//取就诊信息
	if (episodeID '= "")&&(episodeID '= $C(0))
	{
		//取患者指针
		s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
		
		//年龄
		s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientID)
		s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID, "")
		s admDate = $P(admDate, ",", 1)
		s age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(episodeID,birthday,admDate,1)
		s birthday = $ZD(birthday, 3)
		
		//出院床位
		s disBed = ##class(EMRservice.HISInterface.PatientInfoAssist).DisBed(episodeID)
		
		//付费类型
		s payType =  ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(episodeID)
		s Num=##class(web.DHCDocOrderCommon).GetCurrentDeposit(episodeID)
		
		//入院日期
		s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
		s admDate = $P(admDateTime, ",", 1)
		if (admDate '= "") s admDate = $zd(admDate,3)
		
		//主要诊断
		s mainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
		if (mainDiagnos '= "")
		{	
			s mainDiagnos = $P(mainDiagnos,"^",3)
			s mainDiagnos = $tr(mainDiagnos,"'","\'")
		}
		
		s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName()
		s ipRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(episodeID, hospital)
		s dept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID,hospital)
	    s dept = $p(dept,"^",3)
	}
			
	//用patientID取病人信息
	if (patientID '= "")&&(patientID '= $C(0))
	{
		//登记号
		s papmiNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		//姓名
		s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
		//性别
		s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
	}
		
	//s patientInfo = """papmiNo"":"""_papmiNo_""",""name"":"""_name_""",""gender"":"""_gender_""",""disBed"":"""_disBed_""",""age"":"""_age_""",""mainDiagnos"":"""_mainDiagnos_""",""payType"":"""_payType_""",""admDate"":"""_admDate_""",""ipRecordNo"":"""_$g(ipRecordNo)_""",""birthday"":"""_$zd(birthday,3)_""",""dept"":"""_dept_""",""Num"":"""_Num_""""  
	s splitor = "&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
	s htmlStr = "&nbsp"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">病人ID：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px"">"
	s htmlStr=htmlStr_papmiNo_"</span>"
	
	s htmlStr=htmlStr_splitor
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">姓名：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px"">"
	s htmlStr=htmlStr_name_"</span>"

	s htmlStr=htmlStr_splitor
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">性别：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px;"">"_gender_"</span>"

	s htmlStr=htmlStr_splitor
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">出生日期：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px;"">"_birthday_"</span>"

	s htmlStr=htmlStr_splitor
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">年龄：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px;"">"_age_"</span>"

	s htmlStr=htmlStr_splitor
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">余额：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px;"">"_Num_"</span>"


	s htmlStr=htmlStr_splitor
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">就诊科室：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px;"">"_dept_"</span>"

	s htmlStr=htmlStr_splitor
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;font-size:16px;"">付费方式：</span>"
	s htmlStr=htmlStr_"<span style=""font-family:微软雅黑;color:#008b8b;font-size:16px;"">"_payType_"</span>"
	//转换特殊字符
	s htmlStr = $ZSTRIP(htmlStr,"*C")
	q htmlStr
}

/// w ##Class(EMRservice.BL.opInterfaceBase).getOPEmrButtons()
ClassMethod getOPEmrButtons(ACTLocId As %String = "")
{
	s ret="btnSave:保  存;btnPrint:打  印;btnDelete:删  除;btnTemplateclassify:模板选择;btnSpechars:特殊符号;btnScaleEditor:放大;btnTest:测试;btnExportDocument:导出;btnUndo:撤销;btnTooth:牙位"
	s ret = "btnSave:保存:icon-save;btnPrint:打印:icon-print;btnDelete:删除:icon-cancel;btnTemplateclassify:模板:icon-resort;btnManagePersonal:管理个人模板:icon-paper-save;btnSpechars:符号:icon-omega;btnExportDocument:导出:icon-export;btnPreview:预览:icon-eye;btnRevisionVisible:显示痕迹:icon-eye;btnLogFlagInfo:操作日志:icon-paper-cfg;btnAuthRequest:权限申请:icon-stamp;btnAutoApply:自动授权:icon-paper-pen;btnImage:图库:icon-img;btnEye:前房深度公式:icon-eye-deepgrade;btnTooth:牙位图:icon-tooth:^115^"
	s ret=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OPEmrButtons",ret)
	
	s newBtnStr = ""
	s btnCount = $L(ret,";")
	for i=1:1:btnCount
	{
		s btnStr = $p(ret,";",i)
		continue:(btnStr = "")   //有时系统参数OPEmrButtons值最后是分号";"
		//维护了科室字段判断当前科室是否可以显示此按钮
		if ((ACTLocId '= "")&&($p(btnStr,":",4) '= ""))
		{
			continue:("^"_ACTLocId_"^" '[ $p(btnStr,":",4))
		}
		
		if (newBtnStr = "")
		{
			s newBtnStr = btnStr
		}
		else
		{
			s newBtnStr = newBtnStr_";"_btnStr
		}
		
	}
	q newBtnStr
	
	/*
	if ((ACTLocId'="")&&(""'=$p($p($p(ret,"btnTooth",2),";",1),":",4))) {
		//非口腔科室不加载牙位图按钮btnTooth
		if (0=$f(ret,"^"_ACTLocId_"^"))&&(0'=$f(ret,"btnTooth")) {
			s ret=$p(ret,";btnTooth",1)_";"_$p($p(ret,";btnTooth",2),";",2)
		}
	}
	q ret
	*/
}

/// w ##Class(EMRservice.BL.opInterfaceBase).getEMRTemplatePrint("25||583")
ClassMethod getEMRTemplatePrint(episodeID As %String, instanceId As %String = "") As %String
{
	s ins=##Class(EMRinstance.InstanceData).%OpenId(instanceId)
    	s tmplId = ins.RealTemplateID
	s emrTmplId = $O(^DHCEMRM.EMRTemplateI("IdxBindTemplateID", " "_tmplId, ""))
	s emrTmpl=##Class(EMRmeta.EMRTemplate).%OpenId(emrTmplId)
	s id =$O(^DHCEMRM.EMRTemplatePrintI("IdxEMRTemplateId", " "_emrTmpl.CategoryID, ""))
	q:(id="") ""
	s obj = ##Class(EMRmeta.EMRTemplatePrint).%OpenId(id)
	q obj.EMRTemplateIdPrint
}

/// w ##Class(EMRservice.BL.opInterfaceBase).getOeordForGrd(8651, 32)
ClassMethod getOeordForGrd(episodeID, ssGroup As %String) As %String
{
	s blankspace = "    "
	s separate = "\r\n"
	s rows=""
	s count=0
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(episodeID,ssGroup,"","","",""," I E V ", "Y")
	s caoyao="", split="", caoyaoCount =0
	s pascData = "" //检查
	s lisData = "" //检验
	s medData = "" //西药
	s otherData = "" //其他
	s lastDrugRow = "" //上一条医嘱记录 
	s lastDrugName = ""
	s lastDrugInfo = ""  //用法
	While (rset.Next()) {
		if ("检查"=rset.Get("TypeClass")) {
			if (pascData="") {
				s pascData =  ..FilterIlleaglChar(rset.Get("OrderName"))
			}else {
				s pasc = ..FilterIlleaglChar(rset.Get("OrderName"))				
                s pascData = pascData_","_ pasc
            }
		} elseif ("检验"=rset.Get("TypeClass")) {
			if (lisData="") {
				s lisData =  ..FilterIlleaglChar(rset.Get("OrderName"))
			}else {
				s lis = ..FilterIlleaglChar(rset.Get("OrderName"))				
                s lisData = lisData_","_ lis
            }
		} elseif ("西药"=rset.Get("TypeClass")) {
			if (rset.Get("OrderSeqNo")[".") {
				if (lastDrugRow = "") {
					s medData = medData_separate_blankspace_rset.Get("OrderName")
				} else {
					s row = lastDrugName_" "_lastDrugInfo_separate_blankspace_rset.Get("OrderName")
					if (medData="") { s medData = row }
					else { s medData = medData_","_row }
					s lastDrugRow = ""
				}
			} else {
				if (lastDrugRow'="") {
					if (medData="") { s medData = lastDrugRow }
					else { s medData = medData_","_lastDrugRow }
				}
			 
				s lastDrugRow = rset.Get("OrderName")
				s lastDrugRow = lastDrugRow_" "_rset.Get("OrderDoseQty")
				s lastDrugRow = lastDrugRow_" "_rset.Get("OrderDoseUOM")
				s lastDrugRow = lastDrugRow_" "_$Case(rset.Get("OrderInstr")["-",1:$P($P(rset.Get("OrderInstr"),"-",2),"(",1),:rset.Get("OrderInstr")) //用法
				s lastDrugRow = lastDrugRow_" "_..convertOrderFreq(rset.Get("OrderFreq")) //频次
				s lastDrugRow = lastDrugRow_" × "_rset.Get("OrderDur") //疗程
				
				s lastDrugName = rset.Get("OrderName")
				s lastDrugInfo = $Case(rset.Get("OrderInstr")["-",1:$P($P(rset.Get("OrderInstr"),"-",2),"(",1),:rset.Get("OrderInstr")) //用法
				s lastDrugInfo = lastDrugInfo_" "_..convertOrderFreq(rset.Get("OrderFreq"))_" × "_rset.Get("OrderDur")
			}	
		} elseif ("草药"=rset.Get("TypeClass")) {
			if (caoyao="") {
				s caoyao =  ..FilterIlleaglChar(rset.Get("OrderName"))
			}else {
				s zoeord = ..FilterIlleaglChar(rset.Get("OrderName"))				
                s caoyao = caoyao_","_ zoeord
            }
		}	
		else {
			if (otherData="") {
				s otherData = ..FilterIlleaglChar(rset.Get("OrderName"))
			}else {
				s oeord = ..FilterIlleaglChar(rset.Get("OrderName"))				
                s otherData = otherData_","_ oeord
            }	
		}
	}
	Do rset.Close()
	
	if (""'=pascData) {
		s length = $Length(pascData,",")
		for I = 1:1:length {
			s:(rows'="") rows=rows_","
			s rows = rows_"{""oeord"":"""_$p(pascData,",",I)_""",""oeordType"":""检查""}"	
			s count = count + 1
			s length = length + 1
		}
	}
	
	if (""'=lisData) {
		s:(rows'="") rows=rows_","
		s rows = rows_"{""oeord"":"""_lisData_""",""oeordType"":""检验""}"	
		s count = count + 1
	}	
	
	if (lastDrugRow'="") {
		if (medData="") { s medData = lastDrugRow }
		else { s medData = medData_","_lastDrugRow }	
	}

	if (""'=medData) {
		s length = $Length(medData,",")
		for I = 1:1:length {
			s:(rows'="") rows=rows_"," 
			s rows = rows_"{""oeord"":"""_$p(medData,",",I)_""",""oeordType"":""西药""}"
			s count = count + 1
			s length = length+1	
		}		
	}
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	d result.Execute(episodeID,"","","","","","","","Z")
	while result.%Next() 
	{ 
		s:(rows'="") rows=rows_"," 
		s rows = rows_"{""oeord"":"""_..ReplaceEnterChar(result.Data("ArcimDesc")_" "_$P(result.Data("Instr"),"-",2))_""",""oeordType"":""草药""}"	
		s count = count + 1
	}	
	
	if (""'=otherData) {
		s length = $Length(otherData,",")
		for I = 1:1:length {
			s:(rows'="") rows=rows_"," 
			s rows = rows_"{""oeord"":"""_$p(otherData,",",I)_""",""oeordType"":""其他""}"
			s count = count + 1
			s length = length+1	
		}		
	}		
	
	s ret = "{""total"":"_count_",""rows"":["_rows_"]}"

	q ret
}

ClassMethod convertOrderFreq(OrderFreq As %String) As %String
{
	q:("ONCE"=$zcvt(OrderFreq,"U")) "一次"
	q:("BID"=$zcvt(OrderFreq,"U")) "每日两次"
	q:("TID"=$zcvt(OrderFreq,"U")) "每日三次"
	q:("QD"=$zcvt(OrderFreq,"U")) "每日一次"
	q:("QOD"=$zcvt(OrderFreq,"U")) "隔日一次"
	q:("TIDAC"=$zcvt(OrderFreq,"U")) "每日三次,餐前服用"
	q OrderFreq
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	q txt
}

/// Desc:	替换掉json串中的回车换行符号
ClassMethod ReplaceEnterChar(inputStr As %String) As %String
{
	s fromStr = $c(13)
	s toStr = "\r\n"
	set count = $Length(inputStr, fromStr)
    quit:(count <= 1) inputStr
    
    set outStr = $p(inputStr,fromStr,1)
	for i = 2:1:count
	{
		set outStr = outStr_toStr_$p(inputStr,fromStr,i)
	}
	
	q outStr
}

ClassMethod GetTemplateID(AinstanceID As %String) As %String
{
	q:(AinstanceID = "") ""
	s obj = ##class(EMRinstance.InstanceData).%OpenId(AinstanceID)
	q:(obj = "") ""
    	s TemplateID = obj.RealTemplateID
	if TemplateID'="" {s TemplateID = "^"_TemplateID_"^"}
	q TemplateID
}

/// 根据登记号获取当日门诊病历的打印记录
/// 返回 insID  科室  日期时间 打印状态 （json）
/// w ##Class(EMRservice.BL.opInterface).GetTodayPrintListStream("40000888")
ClassMethod GetTodayPrintListStream(argPapmiNo As %String, argEpisodeID As %String = "") As %Stream
{
    //获取查询天数，默认1天
    s SelfPrintSearchDays = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SelfPrintSearchDays","1")
	s ret = ##Class(%GlobalCharacterStream).%New()
	d ret.Write("[")
	s today=+$P($H,",",1)
	s papmiRowid=""
	for 
	{
		s papmiRowid=$o(^PAPERi("PAPMI_PatNo",argPapmiNo,papmiRowid))
		q:(papmiRowid="")
		s paadm=""
		for 
		{
			s paadm=$o(^PAPERdr(papmiRowid,"ADM","O",paadm))
			q:(paadm="")
			s admdate=$P($G(^PAADM(paadm)),"^",6)
            if ((admdate+SelfPrintSearchDays)> today) 
			{ 
			
				s CategoryID = ""
				for {
					s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",paadm, CategoryID))
					q:(CategoryID="")
		
					s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",paadm, CategoryID, ""))
		
					s id = "" 
					for {
						s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_CategoryID, id))
						q:(id="")
			
						s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
						s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
						s ecID = $tr(ecRecordID," ","")

                        s insID = ""
                        for
                        {
						    s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID),-1)
		 				    q:(""=insID)

							s ctloc=""
							s value=$P($g(^PAADM(paadm)),"^",4)
							if (value'="")
							{
								s value=^CTLOC(value)
								s ctloc=$p($p(value, "^", 2), "-",2)
							}
							s doc=""
							s value=$P($g(^PAADM(paadm)),"^",9)
							if (value'="")
							{
								s value = $g(^SSU("SSUSR",+value))
								s doc = $p(value,"^",2)
							}
							s date=""
							s value=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(paadm)
							if (value'="")
							{
								s date=$zd($P($G(value),",",1),3)_" "_$zt($P($G(value),",",2),1)
							}			    
					    	s status=""
					    	s value=$O(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," "_ecID_"||"_insID, ""), -1)
					    	if (value'="") 
					    	{ 
					    		s obj=##Class(EMRinstance.Custom.SelfPrintLog).%OpenId(value)
					    		s status=$zd(obj.PrintDate,3)_" "_$zt(obj.PrintTime,1)
					    	}
                            
                            //过滤掉未签名的病历
                            s havasign=##Class(EMRservice.BOPrivAssist).HasValidSign(ecID_"||"_insID)
                            continue:(havasign="0")
                            
							s item="{""id"":"""_ecID_"||"_insID
							s item=item_""",""ctloc"":"""_ctloc
							s item=item_""",""doc"":"""_doc
							s item=item_""",""date"":"""_date
							s item=item_""",""status"":"""_status
							s item=item_""",""pluginType"":"""_tmpl.DocumentType
							s item=item_""",""text"":"""_tmpl.Name
							s item=item_""",""chartItemType"":"""_tmpl.ChartItemType
							s item=item_"""}"
						
							if (ret.Size > 1) {d ret.Write(",")} 
							d ret.Write(item)
						}
					}	 	
				}
			}
		}
	}
	d ret.Write("]")
	q ret
}

/// 根据登记号获取当日门诊病历的打印记录
/// 返回 insID  科室  日期时间 打印状态 （json）
/// w ##Class(EMRservice.BL.opInterface).GetTodayPrintList("40000888")
ClassMethod GetTodayPrintList(argPapmiNo As %String, argEpisodeID As %String = "") As %String
{
	s ret=""
	s today=+$P($H,",",1)
	s papmiRowid=""
	for 
	{
		s papmiRowid=$o(^PAPERi("PAPMI_PatNo",argPapmiNo,papmiRowid))
		q:(papmiRowid="")
		s paadm=""
		for 
		{
			s paadm=$o(^PAPERdr(papmiRowid,"ADM","O",paadm))
			//w "paadm:"_paadm,!
			q:(paadm="")
			s admdate=$P($G(^PAADM(paadm)),"^",6)
			if (admdate=today) 
			{ 
			
				s CategoryID = ""
				for {
					s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",paadm, CategoryID))
					q:(CategoryID="")
		
					s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",paadm, CategoryID, ""))
		
					s id = "" 
					for {
						s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_CategoryID, id))
						q:(id="")
			
						s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
						s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
						s ecID = $tr(ecRecordID," ","")
                        s insID = ""
                        for
                        {
                            s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID),-1)
                            q:(""=insID)

							//2
							s ctloc=""
							s value=$P($g(^PAADM(paadm)),"^",4)
							if (value'="")
							{
								s value=^CTLOC(value)
								s ctloc=$p($p(value, "^", 2), "-",2)
							}
							//3
							s doc=""
							s value=$P($g(^PAADM(paadm)),"^",9)
							if (value'="")
							{
								s value = $g(^SSU("SSUSR",+value))
								s doc = $p(value,"^",2)
							}
							//4
							s date=""
							s value=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(paadm)
							if (value'="")
							{
								s date=$zd($P($G(value),",",1),3)_" "_$zt($P($G(value),",",2),1)
							}			    
					    	s status=""
					    	s value=$O(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," "_ecID_"||"_insID, ""), -1)
					    	//b
					    	if (value'="") 
					    	{ 
					    		s obj=##Class(EMRinstance.Custom.SelfPrintLog).%OpenId(value)
					    		s status=$zd(obj.PrintDate,3)_" "_$zt(obj.PrintTime,1)
					    	}
                            
                            //过滤掉未签名的病历
                            s havasign=##Class(EMRservice.BOPrivAssist).HasValidSign(ecID_"||"_insID)
                            continue:(havasign="0")
                            
							s item="{""id"":"""_ecID_"||"_insID
							s item=item_""",""ctloc"":"""_ctloc
							s item=item_""",""doc"":"""_doc
							s item=item_""",""date"":"""_date
							s item=item_""",""status"":"""_status
							s item=item_""",""pluginType"":"""_tmpl.DocumentType
							s item=item_""",""text"":"""_tmpl.Name
							s item=item_""",""chartItemType"":"""_tmpl.ChartItemType
							s item=item_"""}"
						
							if (ret="") { s ret= item }
							else { s ret = ret_","_item }
						}
					}	 	
				}
			}
		}
	}
	q "["_ret_"]"
}

/// 返回自助打印设备的打印参数
ClassMethod GetSelfPrintParam(argInstanceId As %String) As %String
{
	q "csp/emr.op.print.csp?IsWithTemplate=N&AutoPrint=Y&InstanceId="_argInstanceId
}

/// 返回main2界面要套打实现的自助打印设备的打印参数
/// 套打 连云港  南方医院(argInstanceId传入空，自助机需增加 argExt:&AP=Y)
ClassMethod GetSelfPrintParam2(argEpisodeID As %String, argInstanceId As %String = "", argExt As %String = "") As %String
{
	s url = "csp/emr.op.print.csp?IsWithTemplate=Y&AutoPrint=Y&EpisodeID="_argEpisodeID_"&InstanceId="_argInstanceId
	q:(argExt'="") url_"&"_argExt
	
	q url
}

/// w ##Class(EMRservice.BL.opInterface).GetHisTools()
ClassMethod GetHisTools() As %String
{
	s ret = ""
	&sql(declare curHisTool cursor for 
		select Name,Position,Text,ColSpan,Link,Background,Color,FormWidth,FormHeight,FnNameAfterClose
		from EMRmeta.OPHisTools where Visible='Y' order by Position)  //1=2

	&sql(open curHisTool)
	for {
		&sql(fetch curHisTool into :Name,:Position,:Text,:ColSpan,:Link,:Background,:Color,:FormWidth,:FormHeight,:FnNameAfterClose)
        quit:SQLCODE  
        s:(Color="") Color="#FFFFFF"
        s item="{'Name':'"_Name_"','Position':"_Position_",'Text':'"_Text_"','ColSpan':"_ColSpan_",'Link':'"_Link_"','Background':'"_Background_"','Color':'"_Color_"','FormWidth':'"_FormWidth_"','FormHeight':'"_FormHeight_"','FnNameAfterClose':'"_FnNameAfterClose_"'}"
		if (ret'="") { s ret = ret_","_item }
		else { s ret = item }	
	}
	&sql(close curHisTool)	
	if (ret'="") { s ret = "["_ret_"]" }
	q ret
}

/// w ##Class(EMRservice.BL.opInterface).GetOPResource("Panel")
ClassMethod GetOPResource(visibleType As %String = "Panel", tag As %String = "main") As %String
{
	s ret = ""
	
	if ("main2"=tag) {
		&sql(declare curOPResource2 cursor for 
			select Name,Title,Frame,Content,Href,Zoom,Scrolling,RefreshOnSelect
			from EMRmeta.OPResource2 where Visible=:visibleType order by Position)	
		&sql(open curOPResource2)
		for {
			&sql(fetch curOPResource2 into :Name,:Title,:Frame,:Content,:Href,:Zoom,:Scrolling,:RefreshOnSelect)
   	     	quit:SQLCODE
   	    	s item="{'Name':'"_Name_"','Title':'"_Title_"','Frame':'"_Frame_"','Content':'"_Content
   	    	s item=item_"','Href':'"_Href_"','Zoom':'"_Zoom_"','Scrolling':'"_Scrolling_"','RefreshOnSelect':'"_RefreshOnSelect_"'}"
			if (ret'="") { s ret = ret_","_item }
			else { s ret = item }	
		}
		&sql(close curOPResource2)						
	}
	else {
		&sql(declare curOPResource cursor for 
			select Name,Title,Frame,Content,Href,Zoom,Scrolling,RefreshOnSelect
			from EMRmeta.OPResource where Visible=:visibleType order by Position)	
		&sql(open curOPResource)
		for {
			&sql(fetch curOPResource into :Name,:Title,:Frame,:Content,:Href,:Zoom,:Scrolling,:RefreshOnSelect)
   	     	quit:SQLCODE
   	     	s item="{'Name':'"_Name_"','Title':'"_Title_"','Frame':'"_Frame_"','Content':'"_Content
   	     	s item=item_"','Href':'"_Href_"','Zoom':'"_Zoom_"','Scrolling':'"_Scrolling_"','RefreshOnSelect':'"_RefreshOnSelect_"'}"
			if (ret'="") { s ret = ret_","_item }
			else { s ret = item }	
		}
		&sql(close curOPResource)					
	}	
	
	if (ret'="") { s ret = "["_ret_"]" }
	q ret
}

/// w ##Class(EMRservice.BL.opInterface).GetOPSectionRes("25||84","S008")
ClassMethod GetOPSectionRes(insId, sectionCode) As %String
{
	q:(""=insId)||(""=sectionCode) ""

	s ins=##Class(EMRinstance.InstanceData).%OpenId(insId)
    	s templateId=ins.RealTemplateID
	
	s id = $O(^DHCEMRM.OPSectionResI("IdxSec"," "_$zcvt(templateId,"U")," "_$zcvt(sectionCode,"U"),""))
	q:(""=id) ""
	
	s obj = ##Class(EMRmeta.OPSectionRes).%OpenId(id)
	s id = $O(^DHCEMRM.OPResourceI("IdxName"," "_$zcvt(obj.Resource,"U"),""))
	q:(""=id) ""
	s obj = ##Class(EMRmeta.OPResource).%OpenId(id)
	q "{""Title"":"""_obj.Title_""",""Name"":"""_obj.Name_"""}"
}

/// w ##Class(EMRservice.BL.opInterface).getAdmType("8651")
ClassMethod getAdmType(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	s admType = $p($g(^PAADM(AEpisodeID)),"^",2)
	q admType
}

/// w ##Class(EMRservice.Ajax.opInterface).LogFlagInfo("4366||1")
ClassMethod LogFlagInfo(instanceId As %String = "") As %String
{
    s result=""
    q:(instanceId="") result
    s ECRecord=$p(instanceId,"||",1)
    s Num=$p(instanceId,"||",2)
    s arr=##Class(EMRinstance.ECRecord).%OpenId(ECRecord)
	q:(arr="") result
    s ChartItemID=arr.RealChartItemID

    s result=ChartItemID_"^"_Num
    q result
}

/// w ##Class(EMRservice.BL.opInterfaceBase).getSavedFirstMultiRecord("8651", "3||4")
ClassMethod getSavedFirstMultiRecord(AEpisodeID As %String, AInstanceId As %String) As %String
{
    s ret = ""
	s $zt = "ErrorHandler"	
	s instance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	q:(instance="") ""
    s emrTmplId = $O(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_instance.RealTemplateID, ""))
	s emrTmpl=##Class(EMRmeta.EMRTemplate).%OpenId(emrTmplId)
	//s tmplid = emrTmpl.BindTemplateID	
	//s emrTmplCate = emrTmpl.ChartItemID
	
	s ecRecord = instance.TheECRecord
    s tempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(ecRecord.RealChartItemID)
    s emrTmplId = $O(^DHCEMRM.EMRTemplateI("IdxBindTemplateCategoryID"," "_ecRecord.RealCategoryID, " "_ecRecord.RealChartItemID, ""))
	s emrTmpl=##Class(EMRmeta.EMRTemplate).%OpenId(emrTmplId)
	s tmplid = emrTmpl.BindTemplateID	
	s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
	s tempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
	s cateChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(tempCate.ParentCategoryID)
	Set key = ""
	do
	{
		s objInstanceData = ecRecord.Instances.GetNext(.key)
		if (objInstanceData '= "")
		{ 
			if (objInstanceData.Status="Save")
			{
				s insId = objInstanceData.%Id()
				
				s ret="{""id"":"""_insId_""","
				s ret=ret_"""actionType"":""LOAD"","
				s ret=ret_"""categoryId"":"""_cateChapter.ParentCategoryID_""","
				s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
				s ret=ret_"""closable"":true,"
				s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","
				s ret=ret_"""isLeadframe"":"""_tempCate.IsLeadframe_""","
				s ret=ret_"""isMutex"":"""_cateChapter.IsMutex_""","
				s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
				s ret=ret_"""status"":""NORMAL"","			
				s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","			
				s ret=ret_"""text"":"""_cateChapter.CategoryName_"""}"			
					
				q 
			}
		} 
	} while (key '="" )
	
	q ret
ErrorHandler
    q ret
}

/// w ##class(EMRservice.BL.opInterfaceBase).IsAllowMuteCreate(146,116)
/// 是否允许此模板创建，允许返回1，不允许返回0
ClassMethod IsAllowMuteCreate(EpisodeID As %String, EMRTemplateID As %String) As %String
{
	q:((EpisodeID="")||(EMRTemplateID="")) ""
	
	//通过展现结构蓝色一级ID获取到EMRmeta.EMRTemplate表ID
	s yyTemplate=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_EMRTemplateID,""))
	
	//通过EMRmeta.EMRTemplate表ID获取到模板ID
	s yyEMRTMPObj=##class(EMRmeta.EMRTemplate).%OpenId(yyTemplate)
	s Template=yyEMRTMPObj.BindTemplateID
	
	s IsSaveTemplateJson = "", MutexTemplateJson = "",count="",Flag="1"
	//获取已保存的实例模板集合
	s IsSaveTemplateJson = ##class(EMRservice.BL.opInterfaceBase).CreateTemplate(EpisodeID)
	s EMRtemplatetableID=""
	for
	{
		//通过模板ID获取到EMRmeta.EMRTemplate表的主ID
		s EMRtemplatetableID=$o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_Template,EMRtemplatetableID))
		q:(EMRtemplatetableID = "")
		
		s EMRTemplateobj=##class(EMRmeta.EMRTemplate).%OpenId(EMRtemplatetableID)
		q:(EMRTemplateobj="")
		
		//获取到展现结构倒数第二级ID，蓝色条一级ID
		s EMRtemplateBlueID=EMRTemplateobj.CategoryID
		
		//通过展现结构倒数第二级ID向上查找，获取到白色一级的ID，进而获取到是否互斥
		s TempCate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(EMRtemplateBlueID)
		s Chapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(TempCate.ParentCategoryID)
		s IsMutex = Chapter.IsMutex
		
		//要创建的模板是非互斥的，所以直接退出
		q:(IsMutex '= 1)
		
		//获取到黄色一级目录一级的ID
		s EMRtemplateID = Chapter.ParentCategoryID
		s seq = ""
		for
		{
			s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_EMRtemplateID,seq))
			q:(seq = "")
			s curCategoryId = ""
			for
			{
				//获取到展现结构白色一级ID
				s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_EMRtemplateID,seq,curCategoryId))
				q:(curCategoryId = "")

				//判断是否为白色一级，即CategoryType字段是否为CategoryChapter
				s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
				continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")	
				/*
				//然后通过白色一级ID获取到蓝色一级ID,即展现结构倒数第二级ID
				s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_curCategoryId,""))
				q:(curDocId="")	
				
				//通过蓝色一级ID获取到EMRmeta.EMRTemplate表的主ID
				s EMRTMPID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_curDocId,""))
				
				//通过EMRmeta.EMRTemplate表ID获取到模板ID
				s EMRTMPObj=##class(EMRmeta.EMRTemplate).%OpenId(EMRTMPID)
				s MutexTemplateID=EMRTMPObj.BindTemplateID
				
				//判断是否为互斥模板
				s curIsMutex = objEMRTemplateCategory.IsMutex
				
				//将互斥模板ID存入MutexTemplateJson中
				if (curIsMutex = 1)
				{
					s:(MutexTemplateJson = "") MutexTemplateJson = MutexTemplateID
					s:(MutexTemplateJson '= "") MutexTemplateJson = MutexTemplateJson_"^"_MutexTemplateID
				}*/
				s curDocId = ""
				for
				{
					//然后通过白色一级ID获取到蓝色一级ID,即展现结构倒数第二级ID
					s curDocId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,curDocId))
					q:(curDocId="")	
					
					//通过蓝色一级ID获取到EMRmeta.EMRTemplate表的主ID
					s EMRTMPID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID",curDocId,""))
					
					//通过EMRmeta.EMRTemplate表ID获取到模板ID
					s EMRTMPObj=##class(EMRmeta.EMRTemplate).%OpenId(EMRTMPID)
					s MutexTemplateID=EMRTMPObj.BindTemplateID
					
					//判断是否为互斥模板
					s curIsMutex = objEMRTemplateCategory.IsMutex
					
					//将互斥模板ID存入MutexTemplateJson中
					if (curIsMutex = 1)
					{
						s:(MutexTemplateJson = "") MutexTemplateJson = MutexTemplateID
						s:(MutexTemplateJson '= "") MutexTemplateJson = MutexTemplateJson_"^"_MutexTemplateID
					}	
				}
			}
		}
	}
	//循环判断下是否允许互斥模板创建，允许创建返回1，不创建返回0
	s count = $l(MutexTemplateJson,"^")
	for i=1:1:count
	{
		i (IsSaveTemplateJson[("^"_$p(MutexTemplateJson,"^",i)_"^")) s Flag="0"
		}
	//q Flag
	//q "0"
	q "1"
}

/// w ##class(EMRservice.BL.opInterfaceBase).CreateTemplate(693)
/// 通过就诊号获取已创建的模板串，供IsAllowMuteCreate方法调用
ClassMethod CreateTemplate(AEpisodeId As %String) As %String
{
	s json = ""
	q:(AEpisodeId = "") json
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
                    			s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date,time,parentId,subId))
					q:(subId = "")
					s obj=##Class(EMRinstance.InstanceData).%OpenId(parentId_"||"_subId)
					q:(obj="")
                    			s TemplateID = obj.RealTemplateID
					s:(json="") json = "^"_TemplateID_"^"
					s:((json'="")&&(json'[("^"_TemplateID_"^"))) json = json_TemplateID_"^"
				}
			}
		}
	}
	q json
}

/// w ##Class(EMRservice.BL.opInterface).getOeord(942,28)
ClassMethod getOeord(episodeID, ssGroup As %String) As %String
{
	s liner = "\r\n"
	
	s pascData = ""
	s lisData = ""
	s medData = ""
	s lastDrugRow = "" //上一条医嘱记录 
	s lastDrugName = ""
	s lastDrugInfo = ""  //用法
	s ret=""
	Set rset = ##Class(%ResultSet).%New("EMRservice.BL.BLOrderData:FindAdmOrderItems")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(episodeID,ssGroup,"","","",""," I E V ")
	While (rset.Next()) {
		if ("检查"=rset.Get("TypeClass")) { 
			if (pascData="") { s pascData =  rset.OrderName }
			else { s pascData = pascData_","_ rset.OrderName }		
		} elseif ("检验"=rset.Get("TypeClass")) {
			if (lisData="") { s lisData =  rset.OrderName }
			else { s lisData = lisData_","_ rset.OrderName }				
		} elseif ("西药"=rset.Get("TypeClass")) {  // 特殊处理子医嘱	

			if (rset.Get("OrderSeqNo")[".") {
				if (lastDrugRow = "") {
					s medData=medData_" "_lastDrugName_" + "_rset.OrderName
				} else {	 
					s row=lastDrugName_" + "_rset.OrderName_" "_lastDrugInfo
					if (medData="") { s medData = row }
					else { s medData = medData_","_row }
					s lastDrugRow = ""
				}
			} else {
				if (lastDrugRow'="") {
					if (medData="") { s medData = lastDrugRow }
					else { s medData = medData_","_lastDrugRow }
				}
			 
				s lastDrugRow = rset.OrderName
				s lastDrugRow = lastDrugRow_" "_rset.Get("OrderDoseQty")
				s lastDrugRow = lastDrugRow_" "_rset.Get("OrderDoseUOM")
				s lastDrugRow = lastDrugRow_" "_$P($P(rset.Get("OrderInstr"),"-",2),"(",1)
				s lastDrugRow = lastDrugRow_" "_..convertOrderFreq(rset.Get("OrderFreq"))
				s lastDrugRow = lastDrugRow_" × "_rset.Get("OrderDur")
				
				s lastDrugName = rset.OrderName
				s lastDrugInfo = $P($P(rset.Get("OrderInstr"),"-",2),"(",1)_" "_..convertOrderFreq(rset.Get("OrderFreq"))_" × "_rset.Get("OrderDur")
			}	 
		}
	}
 
	Do rset.Close()
	
	if (lastDrugRow'="") {
		if (medData="") { s medData = lastDrugRow }
		else { s medData = medData_","_lastDrugRow }	
	}
 
	s idx=0
	if (""'=pascData) {
		s count = $Length(pascData,",")
		for I = 1:1:count {
			s idx=idx+1
			s ret = ret_liner_idx_"."_$p(pascData,",",I)
		}
	}
	if (""'=lisData) {
		s idx=idx+1
		s ret = ret_liner_idx_"."_lisData
	}
	
	if (""'=medData) {
		s count = $Length(medData,",")
		for I = 1:1:count {
			s idx=idx+1
			s ret = ret_liner_idx_"."_$p(medData,",",I)
		}		
	}
	
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
	d result.Execute(episodeID,"","","","","",""," E V ","Z")
	while result.%Next() 
	{ 		
		s idx=idx+1
		s ret = ret_liner_idx_"."_..ReplaceEnterChar(result.Data("ArcimDesc")_" "_$P(result.Data("Instr"),"-",2))    //_""",""oeordType"":""草药""}"
	}	
	
	q "{""Value"":"""_ret_"""}"
}

/// w ##Class(EMRservice.BL.opInterface).getDiag(942,"\r\n")
ClassMethod getDiag(EpisodeID, ssgroup As %String, DelimStr As %String = "\r\n") As %String
{
	s retval=""
	s i=0
	q:(EpisodeID="") "{""Value"":"""_retval_"""}"
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.s MRStatus=""
	.s MRStatusRowid=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2))),"^",9)
	.i MRStatusRowid'="" s MRStatus=$p($g(^MRC("DSTAT",MRStatusRowid)),"^",2)
 	.if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.i Desc="" s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.i Desc'="" s Desc=Desc   ;_"  "_MRStatus
	.s i=i+1
	.s status=""
	.s st=(MRStatus'="")&&(1'=(MRStatus["确诊"))
	.i st s status=" ("_MRStatus_")"
	.s diagnosPrefix=..SetDiagnosLeavel(Rowid)
	.if retval="" s retval=Desc_status
	.e  s retval=retval_DelimStr_diagnosPrefix_Desc_status
	d obj.Close()
	q "{""Value"":"""_retval_"""}"
}

/// ///////////////	医嘱 诊断  //////////////////
/// CreatDate:    2018.03.20
/// Description:  获取本次就诊医嘱记录
/// Input:        入参：就诊号，是否草药标识(CHMED 为草药,空 为非草药)
/// Return:       出参：医嘱名称 X 数量 数量单位 
///                     用法：剂量 剂量单位 频次 用法 疗程 医嘱项目备注
/// Others:       w ##Class(EMRservice.BL.opInterface).getOeordXH("11150666")
/// Others:       w ##Class(EMRservice.BL.opInterface).getOeordXH("11150666","CHMED")
ClassMethod getOeordXH(episodeID, CHMEDFlag As %String = "", liner As %String = "") As %String
{
	
	//判断新版全局图表是否包含就诊，如果包含走四版接口
	if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.GB.GlobalData") '= "0")
	{
		s HasData = $o(^EMR.GB.GlobalDataI("IdxMain",episodeID,""))
		if (HasData'="")
		{
			s objRes = ##class(%GlobalBinaryStream).%New()
			if (CHMEDFlag = "CHMED")
			{
				s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetOeordCN(episodeID,.objRes)
			}
			else
			{
				s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetOeord(episodeID,.objRes)
			}
			q objRes.Read()
		}
	}
	s:liner="" liner = "@"
	s ret = ""
	
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems","2149","","SaveOrder")
	s rset = ##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:FindEMROPItems")
	s sc = rset.Execute(episodeID,CHMEDFlag,"SaveOrder")
	if (CHMEDFlag = "CHMED") {
		s chmedData = ..SortChmedData(episodeID,"CHMED")
		q:(chmedData = "") ret
		for i = 1:1:$L(chmedData,"^^^")
		{
			s:(ret '="") ret = ret_liner
			s chmedDataResult = $P($P(chmedData,"^^^",i),"!",2)
			for j = 1:1:$L(chmedDataResult,"@")
			{
				if (ret="") 
				{
					s ret = $P(chmedDataResult,"@",j)
				}
				else 
				{
					if (j-1#4=0) 
					{
						s:(j = 1) ret = ret_$P(chmedDataResult,"@",j)
						s:(j '=1) ret = ret_liner_$P(chmedDataResult,"@",j)
					}
					else 
					{
						s ret = ret_"    "_$P(chmedDataResult,"@",j)
					}
				}
			}
			s ret = ret_liner_$P($P(chmedData,"^^^",i),"!",1)
		}
		s flag = ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsExist(episodeID, "")
		s:(flag = 1)&&(ret '= "") ret = liner_ret
	}else {
		s pascData = ""
		s lisData = ""
		s medData = ""
		s ortherData = "" //其他

		Set columns = rset.GetColumnCount()
		While rset.Next() 
		{
			if ("检查"=rset.Get("TypeClass")) { 
				if (pascData="") { s pascData=" "_rset.OrderName }
				else { s pascData = pascData_"^^ "_rset.OrderName }		
			} elseif ("检验"=rset.Get("TypeClass")) {
				if (lisData="") { s lisData=" "_rset.OrderName }
				else { s lisData = lisData_"^^ "_rset.OrderName }				
			} elseif ("西药"=rset.Get("TypeClass")) {  // 特殊处理子医嘱	
				s drugInfo = "" 
				if (rset.Get("OrderSeqNo")[".") {
					s drugInfo="@."_$P(rset.Get("OrderSeqNo"),".",2)_" "_rset.OrderName
				} else {
					s drugInfo=" "_rset.OrderName
				}
						
				//s drugInfo = drugInfo_" "_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
				s drugInfo = drugInfo_" X "_rset.Get("OrderPackQty")_rset.Get("OrderPackUOM")
				s drugInfo = drugInfo_"#   用法："
				s drugInfo = drugInfo_"每次"_rset.Get("OrderDoseQty")_rset.Get("OrderDoseUOM")
				s drugInfo = drugInfo_"  "_..convertOrderFreq(rset.Get("OrderFreq"))
				//OrderInstr 用法 OrderDur 疗程 OrderDepProcNote 备注
				if (rset.Get("OrderDepProcNote") '= "") {
					s drugInfo = drugInfo_"  "_rset.Get("OrderInstr")_"  "_rset.Get("OrderDur")_"  "_rset.Get("OrderDepProcNote")
				}else {
					s drugInfo = drugInfo_"  "_rset.Get("OrderInstr")_"  "_rset.Get("OrderDur")
				}
					
				if (medData="") { s medData=drugInfo }
				else { s medData = medData_"^^"_drugInfo }	 	 
			}/*elseif ("其他"=rset.Get("TypeClass")) {
				//医嘱名称 频次 疗程 数量 单位 备注
				s oeord = ..FilterIlleaglChar(rset.OrderName)
                if (rset.Get("OrderSeqNo")[".") {
                    s oeord = "@."_$P(rset.Get("OrderSeqNo"),".",2)_" "_oeord
                }
				s:(rset.Get("OrderFreq") '= "") oeord = oeord_"  "_..convertOrderFreq($ZCVT(rset.Get("OrderFreq"),"U"))
				s:(rset.Get("OrderDur") '= "") oeord = oeord_"  "_rset.Get("OrderDur")
				s oeord = oeord_"  "_rset.Get("OrderPackQty")_rset.Get("OrderPackUOM")
				s:(rset.Get("OrderDepProcNote") '= "") oeord = oeord_"  "_rset.Get("OrderDepProcNote")
				if (ortherData="") { s ortherData = oeord }
				else { s ortherData = ortherData_"^^"_oeord}		
			}*/
		}
	 
		
		s idx=0
		if (""'=pascData) {
			s count = $Length(pascData,"^^")
			for I = 1:1:count {
				s idx=idx+1
				s:(ret'="") ret = ret_liner_idx_"."_$p(pascData,"^^",I)
				s:(ret="") ret = ret_idx_"."_$p(pascData,"^^",I)
			}
		}
		if (""'=lisData) {
			s count = $Length(lisData,"^^")
			for I = 1:1:count {
				s idx=idx+1
				s:(ret'="") ret = ret_liner_idx_"."_$p(lisData,"^^",I)
				s:(ret="") ret = ret_idx_"."_$p(lisData,"^^",I)
			}
		}
		
		if (""'=medData) {
			s count = $Length(medData,"^^")
			for I = 1:1:count {
				s dragInfo=$p(medData,"^^",I)
				if (dragInfo["@") {
					s ret = ret_liner_$replace(dragInfo,"@",idx)
				} else {
					s idx=idx+1
					s:(ret'="") ret = ret_liner_idx_"."_dragInfo
					s:(ret="") ret = ret_idx_"."_dragInfo
				}
				
			}	
		}
		if (""'=ortherData) {
			s count = $Length(ortherData,"^^")
			for I = 1:1:count {
                s orther = $p(ortherData,"^^",I)
                if (orther["@") {
                    s ret = ret_liner_$replace(orther,"@",idx)
                } else {
                    s idx=idx+1
                    s:(ret'="") ret = ret_liner_idx_"."_orther
                    s:(ret="") ret = ret_idx_"."_orther
                }
            }
        }
		s flag = ##class(DHCDoc.Interface.Inside.Service).CheckOrdIsExist(episodeID, "CHMED")
		s:(flag = 1)&&(ret '= "") ret = ret_liner
	}
	d rset.Close()
	
	if (ret["#")
	{
		s ret = $replace(ret,"#",liner)
	}

	q ret
	//q "{""Value"":"""_ret_"""}"
}

///  d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems","23085959","CHMED","")
///  w ##Class(EMRservice.BL.opInterface).SortChmedData("23085959","CHMED")
ClassMethod SortChmedData(episodeID, CHMEDFlag As %String = "") As %String
{
	s rset = ##Class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:FindEMROPItems")
	s sc = rset.Execute(episodeID,CHMEDFlag,"SaveOrder")
	if (CHMEDFlag = "CHMED") {
		s idx=0
		s TOrderPrescNo = ""
		s CHMEDNotes = ""
		s Result = ""
		while rset.%Next() 
		{ 	
			i (TOrderPrescNo '= rset.Data("OrderPrescNo"))
			{
				s CHMEDNotes = ..ReplaceEnterChar(rset.Data("CHMEDNotes")) //备注
				s TOrderPrescNo = rset.Data("OrderPrescNo")
				s:(Result '="") Result = Result_"^^^"
				s Result = Result_ CHMEDNotes_"!"_..ReplaceEnterChar($replace(rset.Data("OrderName")," ","")_""_rset.Data("OrderDoseQty")_rset.Data("OrderDoseUOM"))
			}
			else 
			{	
				s Result = Result_"@"_..ReplaceEnterChar($replace(rset.Data("OrderName")," ","")_""_rset.Data("OrderDoseQty")_rset.Data("OrderDoseUOM"))
			}
		}
	}
	d rset.Close()
	q Result
}

/// CreatDate:    2018.03.20
/// Description:  获取本次就诊诊断记录
/// Input:        入参：EpisodeID 是就诊号，liner 换行符(默认"\r\n",医生站等外组调用"@")，ICDType 是否获取中医诊断(1 中医,空或0 西医)
/// Return:       出参：ICD诊断描述
/// Others:       w ##Class(EMRservice.BL.opInterface).getDiagDataXH("11150666","@")
ClassMethod getDiagDataXH(EpisodeID As %String, liner As %String = "\r\n", ICDType As %String = "") As %String
{
	// 根据诊断级别，设置诊断前的空格
	// 医生站返回值，缩进量通过&nbsp体现。未使用diagLeavelPreFix
	//s diagLeavelPreFix = ""
	//判断新版全局图表是否包含就诊，如果包含走四版接口
	if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.GB.GlobalData") '= "0")
	{
		s HasData = $o(^EMR.GB.GlobalDataI("IdxMain",EpisodeID,""))
		if (HasData'="")
		{
			s objRes = ##class(%GlobalBinaryStream).%New()
			s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetDiag(EpisodeID,ICDType,.objRes)
			q objRes.Read()
		}
	}
	s ret = ""
	s i = 0
	q:(EpisodeID="") ret
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","DiagnosList","2146")
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:DiagnosList")
	d obj.Execute(MRAdmRowid,ICDType)
	while obj.%Next()
	{
		s diagDesc = obj.Data("DiagnosDesc")
		s diagValue = obj.Data("DiagnosValue")
		s diagCodeRowId = obj.Data("DiagnosCodeRowid")
		s diagMRDesc = obj.Data("DiagnosMRDesc")
		s diagStatus = obj.Data("DiagStat")
		s diagLeavel = obj.Data("DiagnosLeavel")
		s diagPrefix = $g(obj.Data("DiagnosPrefix"))
		//s:(diagMRDesc '= "") diagMRDesc = $LIST(diagMRDesc,1)
		if (diagDesc = "") {
			s diagDesc = diagPrefix_diagMRDesc
		}elseif ($tr(diagDesc,"&nbsp","") = "") {
			s diagDesc = $tr(diagDesc,"&nbsp"," ")
			s diagDesc = diagPrefix_diagDesc_diagMRDesc
		}else {
			s diagDesc = $tr(diagDesc,"&nbsp"," ")
			if (diagMRDesc '= "") {
				s diagDesc = diagPrefix_diagDesc_"("_diagMRDesc_")"
			}
		}
		s i = i + 1
		//s diagDesc = i_"."_diagDesc
		//s status = "",diagnosePrefix = ""
		//s:((diagStatus '= "") && (diagStatus [ "确诊")) status = " ("_diagStatus_")"
		//s:(diagLeavel '= "") diagnosePrefix = ..SetDiagnosLeavel(diagLeavel)
		s status = ""
		s:((diagStatus '= "") && (diagStatus '= "确诊")) status = "("_diagStatus_")"
		if (ret = "") {
			s ret = diagDesc_status
		}else{
			//s ret = ret_liner_diagnosePrefix_diagDesc_status
			s ret = ret_liner_diagDesc_status
		}
	}
	d obj.Close()
	
	q ret
}

// 根据诊断级别，设置诊断前的空格

ClassMethod SetDiagnosLeavel(MRAdmRowid As %String) As %String
{
	s DiagnosLeavel=$P($G(^MR($P(MRAdmRowid,"||",1),"DIA",$P(MRAdmRowid,"||",2),"EPR")),"^",1) 
	q:(""=DiagnosLeavel) ""
	s prefix = "    "
	s ret=""
	for i = 2:1:DiagnosLeavel
	{
		s ret = ret_prefix
	}
	q ret
}

///  w ##Class(EMRservice.BL.opInterface).getOPKbTreeAutoExpand(11411)
ClassMethod getOPKbTreeAutoExpand(usrID As %String) As %String
{
	q "N"
}

ClassMethod doBeforePageLoad(adm As %String)
{
}

/// 将JSON不识别字符做
/// w ##Class(EMRservice.BL.opInterface).JsonEscape()
ClassMethod JsonEscape(AValue As %String)
{
	s result = AValue
	s result = $Replace(result,"\","\\")
	s result = $Replace(result,"""","\""")
	s result = $Replace(result,"<","&lt")
	s result = $Replace(result,">","&gt")
	q result
}

ClassMethod GetFirstTmpl(ACTLocId, ASSGroupID, AEpisodeID, AUserID As %String) As %String
{
	s docId = "",flag = ""
	//OPTmplDocId "CTLocID^ALL!DocID^102" 或 "CTLocID^6!DocID^102|CTLocId^5!DocID^104"
	s tmpl = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("OPTmplDocId","")
	if ("" '= tmpl) {
		s HospitalName = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		//山东菏泽中医
		if (HospitalName = "ShanDongHZZY" ) {
			s patientID = $p($g(^PAADM(AEpisodeID)),"^",1)
			s flag = ##class(web.wangkai).GetOPEmrHistorynew(patientID,ACTLocId,AUserID)
			//flag "Y":为复诊患者
			if ("Y" = flag) {
				d getFlag
			}
		} elseif (HospitalName = "BeiHaiRMYY") { //北海人民医院
			s flag = ##class(web.DHCCardReportQuery).GetInfoEMRFlag(AEpisodeID)
			//flag "F":为初诊患者,"R":为复诊患者
			if ("R" = flag) {
				d getFlag
			}
		} //elseif {}
	}
	q ##Class(EMRservice.Ajax.opInterface).GetFirstTmpl(ACTLocId, ASSGroupID, AEpisodeID, AUserID, docId)
getFlag
    s count = $l(tmpl,"|")
    for i=1:1:count
    {
        s recordName = "",recordData = ""
        s recordList = ##class(EMRservice.BL.BLPrivRule).ParseEnvInfo($p(tmpl,"|",i),.recordName,.recordData)
        s ctlocId = $lg(recordData,$lf(recordName,"CTLocID"))
        if ("ALL" = ctlocId) {
            s docId = $lg(recordData,$lf(recordName,"DocID"))
        }else {
            continue:(ACTLocId '= ctlocId)
            s docId = $lg(recordData,$lf(recordName,"DocID"))
            q:(docId '= "")
        }
    }
    q
}

/// 门诊病历页面加锁
ClassMethod emrEntryLock(AEpisodeId As %String, ASessionId As %String = "") As %String
{
	s locker = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("EnableOPLock","")
	q:(locker'="Y") ""
	d ..emrEntryLockClear()
	
	i ASessionId="" s ASessionId=%session.SessionId
    s userID = %session.Get("LOGON.USERID")
    s userLocID = %session.Get("LOGON.CTLOCID")
    
	s warning=""
	s LockRet=##Class(websys.Lock).Lock($lb(AEpisodeId,"User.EMROP"),ASessionId,userID,.warning,userLocID)
	i LockRet=1 s warning=""

	q warning
}

ClassMethod emrEntryLockClear() As %String
{
	d ##Class(websys.Lock).LockClearSession(%session.SessionId)
	q 1
}

/// w ##Class(EMRservice.BL.opInterface).getSavedRecordsForAudit(11411,1,2062,32)
ClassMethod getSavedRecordsForAudit(AEpisodeID, AUserLocID, userId, ASSGroupID As %String, arrResult As %ArrayOfDataTypes)
{
	s result = ""
	s arrResult = ##Class(%ArrayOfDataTypes).%New()
	
	//d ..getSavedRecord(11411,1,2062,32, .arrResult)
	//d ..getSavedRecord(8651,1,2062,32, .arrResult)
	d ##class(EMRservice.BL.opInterface).getSavedRecord(AEpisodeID, AUserLocID, ASSGroupID, .arrResult)
	s key = 0
	while (1)
	{
		s key = arrResult.Next(key)
		q:(key="")
		s item=arrResult.GetAt(key)
		if (result="") { s result=item }
		else { s result=result_","_item }
	}
	
	q "["_result_"]"
}

ClassMethod getSavedRecord(AEpisodeID, AUserLocID, ASSGroupID As %String, arrResult As %ArrayOfDataTypes)
{
	s result=""
	s CategoryID = ""

	s ArrCate = ##Class(%ArrayOfDataTypes).%New()
	s retCategory = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d retCategory.Execute(AUserLocID, ASSGroupID, AEpisodeID)
	while retCategory.%Next()
	{
		s ItemType = retCategory.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = retCategory.Data("ItemCategoryID")
		d ArrCate.SetAt(categoryId, categoryId)
	}

	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
		q:(CategoryID="")
		//continue:(""=ArrTemplate.GetAt($tr(CategoryID," ","")))
		
		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, ""))
		
		s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecRecordID)
		s count = objECRecord.InstanceCount
		q:(0=count)
		
		s emrTmplId = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID", CategoryID, ""))
		s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(emrTmplId)
		s tempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
		s cateChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(tempCate.ParentCategoryID)
		//s cate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(cateChapter.ParentCategoryID)
		continue:(""=ArrCate.GetAt(cateChapter.ParentCategoryID))
		s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)		
		
		s idx = 1
		for 
		{
			q:(idx>count)
			s objInstance = objECRecord.Instances.GetAt(idx)
			if ("Save" = objInstance.Status)
			{
				s ret="{""id"":"""_objInstance.%Id()_""","
				s ret=ret_"""actionType"":""LOAD"","
				s ret=ret_"""categoryId"":"""_cateChapter.ParentCategoryID_""","
				s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
				s ret=ret_"""closable"":true,"
				s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","   //emrTmpl.%Id()
				s ret=ret_"""isLeadframe"":"""_tempCate.IsLeadframe_""","
				s ret=ret_"""isMutex"":"""_cateChapter.IsMutex_""","
				s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
				s ret=ret_"""status"":""NORMAL"","			
				s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","			
				s ret=ret_"""text"":"""_cateChapter.CategoryName_"""}"
				//s ret=ret_"""text"":"""_emrTmpl.TemplateName_"""}"

				s item = arrResult.GetAt(cateChapter.CategorySeq)
				if (item="") { s item = ret }
				else { s item = item_","_ret }
				d arrResult.SetAt(item, cateChapter.CategorySeq)
				//可重复不换页，有引导窗的模板加载第一个
				q:(("Multiple"=tmpl.ChartItemType) && ("1"=tempCate.IsLeadframe))
			}
			s idx = idx + 1
		} 	
	}
}

/// 调用医生站完成就诊方法 ##Class(web.DHCDocOutPatientList).SetComplate(162,5,1259)
/// w ##Class(EMRservice.BL.opInterfaceBase).SetComplate(162,5,1259)
ClassMethod SetComplate(Adm As %String, LocId As %String, UserId As %String) As %String
{
	q ##class(web.DHCDocOutPatientList).SetComplate(Adm,LocId,UserId)
}

/// edit   : yan 2016-12-9
/// Desc   : 取病历实例ID集合
/// input  : 就诊号，模板展现结构第二级(蓝色条纹)ID集合,以"^"分割(放在方法内写死)
/// output : 返回保存状态的实例集合
/// w ##class(EMRservice.BL.opInterface).GetSaveInstanceIDCount("486","116")
ClassMethod GetSaveInstanceIDCount(AEpisodeID As %String) As %String
{
    s result = ""
    s ACategoryIDCount = "116^117"    ///注意修改要打印的模板的展现结构第二级(蓝色条纹)ID
    q:((AEpisodeID = "")||(ACategoryIDCount = "")) result
    for i = 1:1:$l(ACategoryIDCount,"^")
    {
        s CategoryID = $p(ACategoryIDCount,"^",i)
        s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,CategoryID, ""))

        s id = ""
        for {
            s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_CategoryID, id))
            q:(id = "")

            s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
            s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
            s chapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(emrTmpl.CategoryID)
            s cate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapter.ParentCategoryID)
            s ecID = $tr(ecRecordID," ","")
            q:(ecID = "")
            s insID = ""
            for{
                s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", insID))
                q:("" = insID)

                s intobj = ##class(EMRinstance.InstanceData).%OpenId(ecID_"||"_insID)
                continue:(intobj = "")
                s intstatus = intobj.Status
                continue:(intstatus '= "Save")
                if (result = "") {s result = ecID_"||"_insID}
                else {s result = result_"^"_ecID_"||"_insID}
            }
        }         
    }
    q result
}

/// edit   : yan 2018-5-17
/// Desc   : 判断是否允许多选打印
/// input  : 实例ID
/// output : 1允许  0不允许
/// w ##class(EMRservice.BL.opInterface).IsAllowCheckPrint("2477||1")
ClassMethod IsAllowCheckPrint(AInstanceID As %String) As %String
{
	q 1
	/*s flag = "1"
	q:(AInstanceID = "") flag
	s InsObj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(InsObj = "") flag
	s TmplID = InsObj.TemplateID
	q:(TmplID = "") flag
	if (TmplID '= "33") {
		s flag = "0"
		}
	q flag*/
}

/// edit   : yan 2018-5-29
/// Desc   : 获取浏览所用Url
/// input  : 实例ID
/// w ##class(EMRservice.BL.opInterface).GetBrowseUrl("2477","1")
ClassMethod GetBrowseUrl(EcRecordID As %String, InsID As %String) As %String
{
	s result = ""
	q:((EcRecordID = "")||(InsID = "")) result
	
	s insobj = ##class(EMRinstance.InstanceData).%OpenId(EcRecordID_"||"_InsID)
	q:(insobj = "") result
	
    	s TmplateID = insobj.RealTemplateID
	q:(TmplateID = "") result
	
	s Tmpobj = ##class(EMRmeta.Template).%OpenId(TmplateID)
	q:(Tmpobj = "") result
	
	s ChartItemType = Tmpobj.ChartItemType
	q:(ChartItemType = "") result
	
	s pluginType = Tmpobj.DocumentType
	q:(pluginType = "") result
	
	s result = "emr.record.browse.browsform.editor.csp?visitType=OP&chartItemType="_ChartItemType_"&pluginType="_pluginType_"&id="_EcRecordID_"||"_InsID
	q result
}

/// w ##Class(EMRservice.BL.opInterfaceBase).getSignUnitPath("25||583")
ClassMethod getSignUnitPath(instanceId As %String) As %String
{
	q:(instanceId = "") ""

	s Code = ..getSignUnitPathByLog(instanceId)
	q:(Code '= "") Code
	
	s InstanceObj=##Class(EMRinstance.InstanceData).%OpenId(instanceId)
	q:(InstanceObj = "") ""
    	s TemplateID = InstanceObj.RealTemplateID
	q:(TemplateID = "") ""
	s id = $O(^DHCEMRM.OPSignUnitI("IdxTemplateID"," "_TemplateID ,""))
	q:(id = "") ""
	s obj = ##Class(EMRmeta.OPSignUnit).%OpenId(id)
	q:(obj = "") ""
	s Path = obj.UnitPath
	q Path
}

ClassMethod getSignUnitPathByLog(instanceId As %String) As %String
{
	s Code = ""
	s SignID = $o(^DHCEMRCA.EMRSignLogI("IdxInstance"," "_instanceId,""),-1)
	q:(SignID = "") ""
	s Signobj = ##Class(EMRinstance.EMRSignLog).%OpenId(SignID)
	q:(Signobj = "") ""
	s Code = Signobj.Code
	q Code
}

/// 调用医生站获取历次就诊方法 ##class(DHCDoc.OPDoc.AjaxInterface).GetOPInfoJosn(684)
/// w ##Class(EMRservice.BL.opInterfaceBase).GetOPInfoJosn(684)
ClassMethod GetOPInfoJosn(AEpisodeID As %String) As %String
{
	s result = ""
	q:("" = AEpisodeID) result
	try {
		s result = ##class(DHCDoc.OPDoc.AjaxInterface).GetOPInfoJosn(AEpisodeID)
	}catch{
		}
	q result
}

/// 调用医生站接口在引用病历的同时把历史诊断引用至当次就诊
/// w ##Class(EMRservice.BL.opInterface).copyOPInfo(495,18845522,19077945,49)
ClassMethod copyOPInfo(usrId As %String, episodeId As %String, curEpisodId As %String, userLocID As %String) As %String
{
    s ret = """diag"":""0"""
    q "{"_ret_"}"
    
	/*s $zt = "ErrorHandler"
	s ret = ""

	s retDiag = ##class(web.DHCDocDiagnosEntryV8).copyDiagnose(curEpisodId,episodeId,usrId,userLocID)
	if (0=retDiag) { s ret = """diag"":""诊断复制完成！""" }
	else { s ret = """diag"":""诊断复制失败！""" }
	 
	q "{"_ret_"}"
ErrorHandler
    q "{""Err"":"""_$zerror_"""}"*/
}

/// Edit   : Lina 2019-3-7
/// Desc   : 医生在电子病历界面点击完成接诊的时候给第三方推送当前患者的信息
/// Input  : AEpisodeID就诊号,AUserLocID科室ID,AUserID用户ID,AIPAddress科室地址,standby "N",WaitEpisodeID "",Status 2
/// d ##class(EMRservice.BL.opInterface).AddHisDHStatInfo(602,33,8048,"10.80.84.20")
ClassMethod AddHisDHStatInfo(AEpisodeID As %String, AUserLocID As %String, AUserID As %String, AIPAddress As %String) As %String
{
	//福建厦门翔安 项目提供的接口方法（非公共方法），放在类EMRservice.BL.opInterface中
	//s rtn = ##Class(DHCVISService.DHCVisInfoJF).AddHisDHStatInfo(AEpisodeID,AUserLocID,AUserID,AIPAddress,"N","","2")
	//k rtn
}

/// CreatDate:    2019.08.22
/// Description:  获取该患者所有过敏记录
/// Input:        入参：APatientID 患者ID，AQueryAllergiesList过滤需要展示的过敏记录ID串（为空时展示所有）
/// Return:       出参：过敏记录
/// Others:       w ##Class(EMRservice.BL.opInterface).getAllergic("962","")
ClassMethod getAllergic(AEpisodeID As %String, AQueryAllergiesList As %String = "") As %String
{
	//判断新版全局图表是否包含就诊，如果包含走四版接口
	if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.GB.GlobalData") '= "0")
	{
		s HasData = $o(^EMR.GB.GlobalDataI("IdxMain",AEpisodeID,""))
		if (HasData'="")
		{
			s objRes = ##class(%GlobalBinaryStream).%New()
			s strRes = ##Class(EMR.OP.HISInterface.LinkSrv).GetAllergic(AEpisodeID,AQueryAllergiesList,.objRes)
			q objRes.Read()
		}
	}
	s ret = ""
	s i = 0
	q:(AEpisodeID="") ret
	s patientID=$P(^PAADM(AEpisodeID),"^",1)
	q:(patientID = "") ret
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:Allergies")
	d obj.Execute(patientID,AQueryAllergiesList)
	while obj.%Next()
	{
		//过敏源
		s allergen = obj.Data("Allergen")
		//过敏项目
		s aLGItem = obj.Data("ALGItem")
		//注释
		s comments = obj.Data("Comments")
		
		//未实现换行，修改为@,js代码进行\r\n替换。
		s:(i'=0) ret = ret_"、"
		s i = i + 1
		
		s:(allergen'="") ret = ret_allergen_"过敏"
		s:(aLGItem'="")&&(allergen'="") ret = ret_","_aLGItem
		s:(aLGItem'="")&&(allergen="") ret = ret_aLGItem
		s:(comments'="") ret = ret_"("_comments_")"
		
	}
	d obj.Close()
	
	s:(ret="") ret = "否认药物或食物过敏史"
	q ret
}

/// Desc:       查询患者就诊记录(默认查询30条就诊记录)
/// CreateDate: 2020-4-21
/// Input:      APapmiNo  患者ID
///             AMedNo    病案号
///             AName     患者姓名
///             ACardID   卡号
/// Debug:      w ##Class(EMRservice.BL.opInterface).GetBrowsePatList("","","","0805806519")
ClassMethod GetBrowsePatList(APapmiNo As %String, AMedNo As %String, AName As %String, ACardID As %String) As %GlobalCharacterStream
{
    s Json = ##Class(%GlobalCharacterStream).%New()
    q:(APapmiNo="")&&(AMedNo="")&&(ACardID="")&&(AName="") Json
    
    s Stream = ##Class(%GlobalCharacterStream).%New()
    s count = 0, cjson = "", countflag=1
    
    // 新建一个队列，为了按照就诊日期和就诊时间排序
    s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
    
    // 登记号不为空，按照登记号查所有就诊记录
    if (APapmiNo'=""){
        
        s PapmiNo = $O(^PAPERi("PAPMI_PatNo",APapmiNo,""))
        q:(PapmiNo="") "{""total"":0,""rows"":[]}"
        
        d GetAllEpisodeID
    }
    elseif (AMedNo '= "") {
	
        s PapmiNo = ##class(EMRservice.HISinterface.PatientInfoAssist).GetPatientIDByMRNo(AMedNo)
        q:(PapmiNo = "")
		d GetAllEpisodeID

    }
    // 卡号不为空就按照卡号查
    elseif (ACardID'=""){
        
        s CFRowID = ""
        for {
            s CFRowID = $O(^DHCCARDi("CF",0,"CardNo",ACardID,CFRowID),-1)
            q:(CFRowID="")
            s PapmiNo = $P(^DHCCARD("CF",CFRowID),"^",4)
            q:(PapmiNo="")
            
            d GetAllEpisodeID
        }
    }
    // 姓名不为空就按照卡号查
    elseif (AName'=""){
        
        s episodeIDs = ##Class(%ArrayOfDataTypes).%New()
        s PapmiNo = ""
        for {
            
            s PapmiNo = $O(^PAPERi("PAPER_PatName",AName,PapmiNo),-1)
            q:(PapmiNo = "")
            
            d GetAllEpisodeID
        }
    }
    
    d GetSortEpisode

    d Json.Write("{""total"":"_count_",""rows"":[")
    d Json.CopyFrom(Stream)
    d Json.Write("]}")
    q Json

GetAllEpisodeID
    s AdmType = "O" , episodeid = ""
    for {
        s episodeid = $O(^PAPERdr(PapmiNo,"ADM",AdmType,episodeid),-1)
        if (episodeid="") {
            if (AdmType = "O"){
                s AdmType = "E"
                s episodeid=""
                continue
            } 
            else { q }
        }
        // 按照时间倒叙
        s Time = "000000"_$P($G(^PAADM(episodeid)),"^",7)
        s Time = $E(Time,$L(Time)-5,$L(Time))
        //s key=$P($G(^PAADM(episodeid)),"^",6)_Time
        s key = ..GetHistoryKey(episodeid)
        d episodeIDs.SetAt(episodeid, key)
    }
    
    q
        
GetSortEpisode
    s key=""
    while (1){
        s key = episodeIDs.Previous(key)
        q:(key = "")
        s episodeid = episodeIDs.GetAt(key)
        q:(countflag = 31)
        d outputrow(episodeid)
    }
    
    q
        
outputrow(episodeid)

    s (EpisodeID,PapmiDR,Name,GenderDesc,Age,DeptDesc,AdmDocDesc,MainDiag,CardNo) = ""
    
    s EpisodeID=episodeid
    
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
    
    //卡号
    s CardNo = "" //##class(EMRservice.HISInterface.PatientInfoAssist).GetCardNo(PapmiDR)
    
    //姓名
    s Name=##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
    
    //性别
    s Gender=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
    s:(Gender'="") GenderDesc = $P(Gender,"^",3)
    
    //年龄
    s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
    s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID, "")
    s admDate = $P(admDate, ",", 1)
    s Age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(EpisodeID,birthday,admDate,1)
    
    //就诊日期,时间
    s AdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
    s AdmDate = $P(AdmDateTime,",",1)
    s AdmDate = $zd(AdmDate,3)
    
    s AdmTime = $P(AdmDateTime,",",2)
    s AdmTime = $ZT(AdmTime)
    
    //就诊类型
    s AdmType = $p(^PAADM(EpisodeID),"^",2)
    
    //科室
    s tmpDisDept=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(EpisodeID,"")
    s DeptDesc = $P(tmpDisDept,"^",3)
    
    //主管医师
    s AdmDocDesc = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(EpisodeID,"")
    s AdmDocDesc = $P(AdmDocDesc,"^",3)
    
    //门诊诊断
    s OPDiagStringH = ""
    s tmpOPDiagDict = ##class(web.DHCDocDiagnosNew).GetMRDiagnoseList(EpisodeID,2,"OP")
    i tmpOPDiagDict'="" {
        s OPDiagLength = $L(tmpOPDiagDict,$C(1))
        f i = 1:1:OPDiagLength
        {
            s:(OPDiagStringH'="") OPDiagStringH = OPDiagStringH_","
            s OPDiagStringH = OPDiagStringH_$P($P(tmpOPDiagDict,$C(1),i),"^",1)
        }
        
    }
    
    s HasComplete = ""
    s HasComplete = ##Class(EMRservice.BL.opInterface).GetEMRRecordStatus(EpisodeID)
    
    s cjson = "{"
    s cjson = cjson_ """PatientID"":"""_PapmiDR_""""
    s cjson = cjson_ ",""EpisodeID"":"""_EpisodeID_""""
    s cjson = cjson_ ",""AdmType"":"""_AdmType_""""
    s cjson = cjson_ ",""mradm"":"""_EpisodeID_""""
    s cjson = cjson_ ",""HasComplete"":"""_$Case(HasComplete,"1":"已签","0":"未签","":"")_""""
    s cjson = cjson_ ",""PAPMIName"":"""_Name_""""
    s cjson = cjson_ ",""PAPMISex"":"""_GenderDesc_""""
    s cjson = cjson_ ",""PAPMIAge"":"""_Age_""""
    s cjson = cjson_ ",""PAAdmDate"":"""_AdmDate_""""
    s cjson = cjson_ ",""PAAdmTime"":"""_AdmTime_""""
    s cjson = cjson_ ",""PAAdmLoc"":"""_DeptDesc_""""
    s cjson = cjson_ ",""PAAdmDoc"":"""_AdmDocDesc_""""
    s cjson = cjson_ ",""Diagnosis"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(OPDiagStringH)_""""
    s cjson = cjson_ "}"
    d:(count '= 0) Stream.Write(",")
    d Stream.Write($ZSTRIP(cjson,"*C"))
    s count = count + 1
    s countflag = countflag + 1
}

/// Desc:       判断该指定就诊书写病历是否完成医生和患者签名
/// CreateDate: 2020-4-21
/// Input:      AEpisodeID  就诊号
/// Output:     "":没有书写相关病历;"1":已签;"0":未签;
/// Debug:      w ##class(EMRservice.BL.opInterface).GetEMRRecordStatus(6)
ClassMethod GetEMRRecordStatus(AEpisodeID As %String) As %String
{
    s statue = ""
    q:(AEpisodeID = "") statue
    s categoryID = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("VerificalCategoryID","")
    q:(categoryID = "") statue
    s docIDs = ##class(EMRservice.BL.BLClientCategory).GetDocIdsByParent(categoryID)
    s length = $l(docIDs,",")
    for i=1:1:length
    {
        s emrDocID = $p(docIDs,",",i)
        s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, emrDocID, ""))
        s ecRecordID = $tr(ecRecordID," ","")
        continue:(ecRecordID = "")
        s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecRecordID)
        continue:(objECRecord = "")
        s instanceCount = objECRecord.InstanceCount
        for idx = 1:1:instanceCount 
        {
            s objInstance = objECRecord.Instances.GetAt(idx)
            q:(objInstance = "") 
            continue:(objInstance.Status '= "Save")
            s statue = "0"
            s instanceID = objInstance.%Id()
            s isCASign = "0", isAnySign = "0"
            s signID = ""
            for
            {
                s signID = $O(^DHCEMRI.EMRSignI("IdxInstance", " "_instanceID, signID),-1)
                q:(signID = "")
                s sign = ##Class(EMRinstance.EMRSign).%OpenId(signID)
                continue:(sign.SignID = "")||(sign.SignID = $c(0))
                if (sign.isSignValid = "1"){
                    if (sign.Type = "CA") {
                        s isCASign = "1"
                    }elseif (sign.Type = "AnySign") {
                        s isAnySign = "1"
                    }
                }
                if (isCASign = "1")&&(isAnySign = "1") {
                    s statue = "1"
                }
                q:(statue = "1")
            }
            q:(statue = "0")
         }
         q:(statue = "0")
    }
    
    q statue
}

/// CreatDate:    2020.12.01
/// Description:  创建门(急)诊-复诊病历时，判断该患者当前科室半年内是否书写过初诊病历
/// Input:        入参：APatientID 患者ID
///                     ACTlocID 患者当前登录科室ID
///                     ADocIDs 初诊病历DocIDs
///                     ADateGap 指定就诊起始时间间隔，单位按天计算，默认180天
/// Return:       出参："":入参为空 "0":没有书写过初诊病历 "1":书写过初诊病历
/// Others:       w ##Class(EMRservice.BL.opInterface).IsAllowCreateByConfig("2","24","1527^1533^1538^1540","180")
ClassMethod IsAllowCreateByConfig(APatientID As %String, ACTlocID As %String, ADocIDs As %String, ADateGap As %String = "180") As %String
{
	s result = "0"
	q:(APatientID = "")||(ACTlocID = "")||(ADocIDs = "")||(ADateGap = "") ""
	
	//取指定起止日期
	s Systemdateint = $p($h,",",1)
	s StartDate = Systemdateint + 1 - ADateGap
	s EndDate = Systemdateint
	
	s typeRowID = "0" 
	for {
	 	s typeRowID = $o(^PAPERdr(APatientID,"ADM",typeRowID))
	 	q:(typeRowID = "")
	 	
	 	s episodeID = ""
	 	for {
		 	s episodeID = $o(^PAPERdr(APatientID,"ADM",typeRowID,episodeID),-1)
		 	q:(episodeID = "")
		 	if (episodeID="") 
		 	{
			 	if (typeRowID = "O") 
			 	{ 
			 		s typeRowID = "E"
			 		s episodeID = ""
			 		continue
			 	} else
			 	{
				 	q
				}
			}
		 	s VisitStatus = $p($g(^PAADM(episodeID)),"^",20)
		 	continue:(VisitStatus = "C")    //过滤掉已退号的就诊信息
		 	
		 	s curDept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
			s curDept = $P(curDept,"^",1)
			
			//过滤掉非当前就诊科室
			continue:(ACTlocID '= curDept)
			
			s admDate = $P($G(^PAADM(episodeID)),"^",6)
			continue:(admDate < StartDate)||(admDate > EndDate)
			s tmpresult = ##Class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(episodeID, ADocIDs)
		 	s:(tmpresult = "1") result = "1"
		 	q:(result = "1")
	 	}
	 	q:(result = "1")
	}
	
	q result
}

/// Desc:       南方医院由无页眉页脚模板过渡为有页眉页脚模板-根据当前登陆科室ID，获取非HISUI版门诊病历-资源区-历史就诊页签-"创建为指定病历"按钮所用病历模板的emrDocID
/// Input:      当前登陆科室ID
/// Output:     当前登陆科室可创建病历模板的emrDocID
/// Debug:      w ##Class(EMRservice.BL.opInterface).GetRefEmrLastDocID("6")
ClassMethod GetrefEmrLastDocID(ALocID As %String = "") As %String
{
    s emrDocID = "" //所用病历模板的emrDocID
    /*if (ALocID = "6") //根据科室指定不同而进行条件判断
    {
        s emrDocID = "104"
    }
    elseif (ALocID = ...){....}*/
    q emrDocID
}

/// Desc:       南方医院病历打印-根据当前病历实例ID的DocID是否为非HISUI版门诊病历-资源区-历史就诊页签-"创建为指定病历"按钮所用病历模板的refEmrLastDocID
/// Input:      AUserLocID 当前登陆科室ID
///             AInstanceId 当前病历实例ID
/// Output:     "" 当前病历实例ID的DocID与refEmrLastDocID相同; "1" 当前病历实例ID的DocID与refEmrLastDocID不相同;
/// Debug:      w ##Class(EMRservice.BL.opInterface).isRefDocID("6","1||1")
ClassMethod isRefDocID(AUserLocID As %String, AInstanceId As %String) As %String
{
    q:(AInstanceId="") ""
    s refEmrLastDocID = ##Class(EMRservice.BL.opInterface).GetrefEmrLastDocID(AUserLocID)
    s obj=##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
    q:(obj="")||($zcvt(obj.Status,"U")'="SAVE") ""
    q:(obj.TheECRecord.RealChartItemID = refEmrLastDocID) "1"
    q ""
}

/// Desc:       前端请求后台数据库测试方法
/// Output:     "true" 连接数据库成功标识
/// Debug:      w ##class(EMRservice.BL.opInterface).requestCACHE()
ClassMethod requestCACHE() As %String
{
    q "true"
}

/// Desc:       按病历时间顺序返回结合病历目录列表
/// CreateDate: 2021-1-26
/// Output:     json
/// debug:      w ##Class(EMRservice.BL.opInterface).GetPhthsisRecordCatalogByHappenDate().OutputToDevice()
ClassMethod GetPhthsisRecordCatalogByHappenDate(AEpisodeID As %String) As %GlobalCharacterStream
{
    s json = ##Class(%GlobalCharacterStream).%New()
    q:(AEpisodeID = "") json
    //接口获取结核病就诊列表(按照就诊时间升序)就诊号串,以","分隔
    s episodeIDs = ##class(EMRservice.BL.opInterface).getPhthisisRecordAdm(AEpisodeID)
    q:(episodeIDs = "") json
    for k=1:1:$l(episodeIDs,",")
    {
        s tempAEpisodeID = $p(episodeIDs,",",k)
        s tempJson = ##Class(EMRservice.BL.BLClientCategory).GetRecordCatalogByHappenDate(tempAEpisodeID,"save")
        d:(json.Size > 0 && tempJson.Size > 0) json.Write(",")
        d:(tempJson.Size > 0) json.CopyFrom(tempJson)       
    }
    
    q json
}

/// Desc:       获取结合病历目录就诊序列
/// Output:     episodeIDs 获取结核病就诊列表(按照就诊时间升序)就诊号串,以","分隔
/// debug:      w ##class(EMRservice.BL.opInterface).getPhthisisRecordAdm("555")
ClassMethod getPhthisisRecordAdm(AEpisodeID As %String) As %String
{
    s episodeIDs = ""
    q:(AEpisodeID = "") episodeIDs
    //接口获取结核病就诊列表(按照就诊时间升序)就诊号串,以","分隔
    q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCDoc.OPDoc.AjaxInterface") = "0") episodeIDs
    q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCDoc.OPDoc.AjaxInterface||GetTBAdmInfoByEpisodeID") = "0") episodeIDs
    s episodeIDs = ##class(DHCDoc.OPDoc.AjaxInterface).GetTBAdmInfoByEpisodeID(AEpisodeID)
    q episodeIDs
}

/// CreatDate:    2019.08.22
/// Description:  获取该患者所有过敏记录
/// Input:        入参：APatientID 患者ID，AQueryAllergiesList过滤需要展示的过敏记录ID串（为空时展示所有）
/// Return:       出参：过敏记录
/// Others:       w ##Class(EMRservice.BL.opInterfaceBase).getAllergic("962","")
ClassMethod getAllergicForFirstPage(AEpisodeID As %String, AQueryAllergiesList As %String = "") As %String
{
	s ret = ""
	s i = 0
	q:(AEpisodeID="") ret
	s patientID=$P(^PAADM(AEpisodeID),"^",1)
	q:(patientID = "") ret
	Set obj=##class(%ResultSet).%New("DHCDoc.Interface.Inside.Service:Allergies")
	d obj.Execute(patientID,AQueryAllergiesList)
	while obj.%Next()
	{
		//过敏类型
		s Category = obj.Data("Category")
		continue:(Category'="")&&(Category'="药物")
		//过敏源
		s allergen = obj.Data("Allergen")
		//过敏项目
		s aLGItem = obj.Data("ALGItem")
		//注释
		s comments = obj.Data("Comments")
		//未实现换行，修改为@,js代码进行\r\n替换。
		s:(i'=0) ret = ret_"、"
		s i = i + 1
		s:(allergen'="") ret = ret_allergen_"过敏"
		s:(aLGItem'="")&&(allergen'="") ret = ret_","_aLGItem
		s:(aLGItem'="")&&(allergen="") ret = ret_aLGItem
		s:(comments'="") ret = ret_"("_comments_")"
	}
	d obj.Close()
	q ret
}

/// CreatDate:    2023-03-21
/// Description:  获取该患者检查检验申请单内容
/// Input:        入参：AEpisodeID 就诊号
/// Return:       出参：检查检验申请单内容
/// Others:       w ##Class(EMRservice.BL.opInterfaceBase).GetPatTotalExamResult("718909")
ClassMethod GetPatTotalExamResult(AEpisodeID As %String, SsgroupID As %String = "") As %String
{
    s ret = ""
    q:(AEpisodeID="") ret
    q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCDocOrderCommon") = "0") ret
    q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCDocOrderCommon||GetPatTotalExamResult") = "0") ret
    s ret = ##class(web.DHCDocOrderCommon).GetPatTotalExamResult(AEpisodeID)
    q "{""Value"":"""_ret_"""}"
}

/// CreatDate:    2023-03-21
/// Description:  获取该患者会诊原因
/// Input:        入参：AEpisodeID 就诊号
/// Return:       出参：会诊原因
/// Others:       w ##Class(EMRservice.BL.opInterfaceBase).GetDocHuiZhengLY("718909")
ClassMethod GetDocHuiZhengLY(AEpisodeID As %String, SsgroupID As %String = "") As %String
{
    s ret = ""
    q:(AEpisodeID="") ret
    q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCEMConsultQuery") = "0") ret
    q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCEMConsultQuery||JsEPGetCstNoObj") = "0") ret
    s ret = ##Class(web.DHCEMConsultQuery).JsEPGetCstNoObj(AEpisodeID)
    q "{""Value"":"""_ret_"""}"
}

/// CreatDate:    2023-03-21
/// Description:  获取该患者住院证内容
/// Input:        入参：AEpisodeID 就诊号
/// Return:       出参：住院证内容
/// Others:       w ##Class(EMRservice.BL.opInterfaceBase).GetIPBookInfo("")
ClassMethod GetIPBookInfo(AEpisodeID As %String, SsgroupID As %String = "") As %String
{
    s ret = ""
    q:(AEpisodeID="") ret
    q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCDocIPBookNew") = "0") ret
    q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCDocIPBookNew||GetIPBookInfo") = "0") ret
    s ret = ##class(web.DHCDocIPBookNew).GetIPBookInfo(AEpisodeID)
    q "{""Value"":"""_ret_"""}"
}

}
