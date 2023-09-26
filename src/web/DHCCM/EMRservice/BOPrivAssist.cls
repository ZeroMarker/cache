/// get info from Trak for privilege management
Class web.DHCCM.EMRservice.BOPrivAssist Extends (%RegisteredObject, %SOAP.WebService) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PrivAssist";

/// Creator：      Jiangew
/// CreatDate：    2012-11-14
/// Description:   加载查询科室
/// Test:          d ##Class(EMRservice.BOPrivAssist).GetCTLoc("S07","",0,12,0,"","","")
ClassMethod GetCTLocDS(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ByRef AResultCount As %String, ByRef ASessionId As %String, AConditionCode As %String, ACondition As %String) As EMRservice.dataset.EPrivCTLocDataset [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLPrivCTLoc).GetCTLocList(ADicCode,AItem,AStartRow,ARowCount,AResultCount,ASessionId,AConditionCode,ACondition)
}

/// added by Jiangew on 2012-11-16
ClassMethod GetCTLoc(CTLocName As %String) As %XML.DataSet [ WebMethod ]
{
   s result=##Class(%XML.DataSet).%New()
   
   if ($D(CTLocName)=0)||(CTLocName="")
  	{
	  	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLoc:GetAllCTLoc")
	  	Do result.SetArgs()
	}
	else 
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLoc:GetCTLocByName")
		Do result.SetArgs(CTLocName)
	}
	
	Quit result
}

ClassMethod getSSGroup(argGroupName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	
	//注：Select出这两个字段的顺序不允许修改
	if ($d(argGroupName)=0)||(argGroupName="") {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrivAssist:GetAllSSGroup")
		Do result.SetArgs()
	}
	else 
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrivAssist:GetSSGroupByName")
		Do result.SetArgs(argGroupName)
	}
	
	Quit result
}

/// get locations of Trak to config privilege
/// Trak table: CT_Loc. Pay attention to the CTLOC_DateActiveFrom and CTLOC_DateActiveTo
ClassMethod GetLocations(argLocationName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	Set nowDate=$zd($p($h,",",1),1)
	
	if ($d(argLocationName)=0)||(argLocationName="") {
		Set result=##class(%XML.DataSet).%New("EMRservice.BOPrivAssist:SelectLoctations")
		Do result.SetArgs(nowDate)
	}
	else
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.BOPrivAssist:SelectLoctationsByName")
		Do result.SetArgs(argLocationName,nowDate)
	}
	Quit result
}

Query SelectLoctations(aNowDate As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc,CTLOC_Code", SELECTMODE = "RUNTIME") [ SqlName = SelectLocations, SqlProc ]
{
	select CTLOC_RowID,CTLOC_Desc,CTLOC_Code from SQLUser.CT_Loc where CTLOC_DateActiveFrom<=:aNowDate and (CTLOC_DateActiveTo is null or CTLOC_DateActiveTo>=:aNowDate)
}

Query SelectLoctationsByName(aLocationName As %String, aNowDate As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc", SELECTMODE = "RUNTIME") [ SqlName = SelectLocationsByName, SqlProc ]
{
	select CTLOC_RowID,CTLOC_Desc from SQLUser.CT_Loc where CTLOC_Desc like :aLocationName and CTLOC_DateActiveFrom<=:aNowDate and (CTLOC_DateActiveTo is null or CTLOC_DateActiveTo>=:aNowDate)
}

/// get Sex
ClassMethod GetSexDic() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	Set result=##class(%XML.DataSet).%New("EMRservice.BOPrivAssist:SelectSexDic")
	Do result.SetArgs()
	Quit result
}

Query SelectSexDic() As %SQLQuery(CONTAINID = 0, ROWSPEC = "CTSEX_Code,CTSEX_Desc", SELECTMODE = "RUNTIME") [ SqlName = SelectSexDic, SqlProc ]
{
	select CTSEX_Code,CTSEX_Desc from SQLUser.CT_Sex
}

/// Desc: 	获得安全组名及用户名称
/// Modify: Candy
/// Input: 	argUserID 用户ID
/// Output: groupname^username
ClassMethod GetSSGroupAndNameByUserID(argUserID As %String) As %String [ WebMethod ]
{
	q:(($d(argUserID)=0)||(argUserID="")) ""
	s user="",result="",groupName="",userName=""
	s user=##class(User.SSUser).%OpenId(argUserID)
	q:(user="") ""
	
	s groupName=user.SSUSRGroup.SSGRPDesc, userName=user.SSUSRName
	s user=""
	q groupName_"^"_userName
}

/// Desc: 	用户是否为患者主管医生(BelongToMe)
/// Modify: Candy
/// Input: 	argPatEpisodeID 就诊号
/// 			argDocID 用户UerID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsPatBelongDoc(76,105)
ClassMethod IsPatBelongDoc(argPatEpisodeID As %String, argDocID As %String) As %String
{
	q:($d(argPatEpisodeID)=0)||($d(argDocID)=0)||(argPatEpisodeID="")||(argDocID="") "0"
	s maindoc = ""
	s maindoc = ##class(EMRservice.HISInterface.PatientInfoAssist).SSUsrInCharge(argPatEpisodeID)
	q:(maindoc="") "0"
	q:(argDocID = maindoc) "1"
	q "0"
}

/// Desc:	用户是否为指定患者主管医生的上级医生(BelongToSubdoc)
/// Modify: Candy
/// Input 	argPatEpisodeID 就诊号
/// 			argDocID 用户ID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsPatBelongSubDocs(76,105)
ClassMethod IsPatBelongSubDocs(argPatEpisodeID As %String, argDocID As %String) As %String
{
	q:($d(argPatEpisodeID)=0)||($d(argDocID)=0)||(argPatEpisodeID="")||(argDocID="") "0"
	s doc = "",maindoc = ""		
	s doc = ##class(EMRservice.BOPowerUser).GetById(argDocID)
	q:(doc = "") "0"
	s maindoc = ##class(EMRservice.HISInterface.PatientInfoAssist).SSUsrInCharge(argPatEpisodeID)
	q:(maindoc = "") "0"
	q:($f("^"_doc.ChildUsers_"^","^"_maindoc_"^")>1) "1"
	q "0"
}

/// Desc: 	病人是否属于某科室(BelongToLoc)
/// Modify: Candy
/// Input: 	argPatEpisodeID 就诊号
/// 			argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).IsPatBelongToLoc(76,6)
ClassMethod IsPatBelongToLoc(argPatEpisodeID As %String, argLocID As %String) As %String
{
	s currentLoc = ""
	s currentLoc = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
	q:(currentLoc = "") "0"
	q:($p(currentLoc,"^",1)=argLocID) "1"
	
	//病历转移科室应该也是当前科室
	s getappointdept = ""
	s getappointdept = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argPatEpisodeID)
	q:(getappointdept=argLocID) "1"	
	q "0"
}

/// Desc: 	病人属于相关科室(BelongToLinkLoc)
/// Modify: Candy
/// Input: 	argPatEpisodeID 就诊号
/// 	    argLocID 科室ID
/// OutPut: 1是,0否
ClassMethod IsPatBelongToLinkLoc(argPatEpisodeID As %String, argLocID As %String) As %String
{
	s locType = ""
	s locType = $p($g(^CTLOC(argLocID)),"^",13)
	
	if (locType = "W")||(locType = "E")
	{
		s currentLinkLocString = ""
		s currentLinkLocString = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDeptLinkLoc(argPatEpisodeID)
		q:(currentLinkLocString="") "0"
		q:($f(currentLinkLocString,"^"_argLocID_"^")'=0) "1"
		
		//20110624 WANGWENTAO UPDATE - 病历转移科室应该也是当前科室
		s getappointdept = ""
		s getappointdept = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argPatEpisodeID)
		q:(getappointdept = argLocID) "1"
		//20110624 WANGWENTAO UPDATE END
		q "0"
	}
	else
	{
		s currentLoc = ""
		s currentLoc = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
		q:(currentLoc = "") "0"
		q:($p(currentLoc,"^",1)=argLocID) "1"
		q "0"
	}
}

/// Desc: 		检查病人是否已被病历转移到指定科室(BelongTransLoc)
/// Input：		argPatEpisodeID：病人就诊rowid，argLocID：病历转移的科室
/// Output：	1--是, 0--否
/// Return：	0：住院病人，1：门诊或急诊病人
/// Createor：	gaojb
/// CreateTime：2009-12-09
/// Debug: 		w ##class(EMRservice.BOPrivAssist).IsPatBelongTransLoc(50729,6) 
ClassMethod IsPatBelongTransLoc(argPatEpisodeID As %String, argLocID As %String) As %String
{
	s $zt="errhandle"
	q:(($d(argPatEpisodeID)=0)||(argPatEpisodeID="")||($d(argLocID)=0)||(argLocID="")) "0"
	s transLoc=""
	s transLoc=##class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argPatEpisodeID)
	q:(transLoc="") "0"
	q:(transLoc=argLocID) "1"
	q "0"
errhandle
	q "0"
}

/// Desc: 	用户是否属于病区[BelongToWard]
/// Modify: Candy
/// Input: 	argPatEpisodeID 就诊号
/// 			argLocID 科室ID
/// OutPut: 1是,0否
ClassMethod IsPatBelongToWard(argPatEpisodeID As %String, argLocID As %String) As %String
{
	s currentWard = ""
	s currentWard = ##class(EMRservice.HISInterface.PatientInfoAssist).CareUnit(argPatEpisodeID)
	q:(currentWard = "") "0"

	// 这里不能直接比较rowid，护士登陆时其argLocID是CT_Loc中的科室rowid
	// 需要比较病区的code
	s locCode = $p($g(^CTLOC(argLocID)),"^",1)
	q:($p(currentWard,"^",2) = locCode) "1"
	q "0"
}

/// Desc: 	病人是否已出院 [IsDisCharge]
/// Modify: Candy
/// Input: 	argEpisodeID 就诊号
/// OutPut: 1是,0否
ClassMethod IsDisCharge(argEpisodeID As %String) As %String
{
	s disDate = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDatePriv(argEpisodeID)
	Q:(disDate'="") "1"
	Q "0"
}

/// Desc: 		用于判断这个患者是否需要写病历,如果是住院患者返回1，如果是门诊患者或退院患者返回0(不可以写病历)
/// 			这个需求是给沈阳做的，因为他们有的时候把患者门诊的记录写了首页，而住院的记录没有写[PatNeedDoc]
/// CreateUser：liaowanpeng
/// Modify: 	Candy
/// Input: 		argEpisodeID 就诊号
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).PatNeedDoc("76")
ClassMethod PatNeedDoc(argEpisodeID As %String) As %String
{
	q:(argEpisodeID="") "0"
	s PatType = ""
	s VisistStatus = ""
	s PatType = $P($G(^PAADM(argEpisodeID)),"^",2)
	s VisistStatus = $P($G(^PAADM(argEpisodeID)),"^",20)
	if ((PatType="I")&&((VisistStatus="A")||(VisistStatus="D")))
	{
		q "1"
	}
	q "0"
}

/// Desc:		用户是否为医生[UserIsDoc]
/// Modify: 	Candy
/// Input: 		argDocID 用户ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).UserIsDoc("76")
ClassMethod UserIsDoc(argDocID As %String) As %String
{
	q:($d(argDocID)=0)||(argDocID="") "0" 
	s LinkId="",CareProvId="",Degree="",TemplateUse=""
	s LinkId=$p($G(^SSU("SSUSR",argDocID)),"^",14)
	q:(LinkId="") "0"
	s CareProvId=$p($G(^CTPCP(LinkId,"1")),"^",4)
	q:(CareProvId="") "0"
	s Degree=$p($G(^CT("CPT",CareProvId)),"^",4)
	q:(Degree="DOCTOR") "1"
	q "0"
}

/// Desc: 		是否门诊病人, 用于门诊医生权限
/// Input：		argPatEpisodeID：病人就诊rowid
/// Output：	0：住院病人，1：门诊或急诊病人
/// CreateUser：HouJ， suggested by XueFL for HuaXiYiYuan
/// CreateTime：2009-08-03 
ClassMethod IsOutPatient(argPatEpisodeID As %String) As %String
{
	s RetType = ""
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s RetType = $case(PatientType="I",1:0,:1)
	q RetType
}

/// Desc:		病历是否保存(HasSaved)
/// Creator:	Candy
/// CreateDate:	2014-10-13
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsRecordInstanceSaved("1||1")
ClassMethod IsRecordInstanceSaved(argInstanceID As %String) As %String
{
	s result = 0
	q:(argInstanceID = "") result
	s instance = ##class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(instance = "") result
	s status = instance.Status
	s:(status = "Save") result = 1
	q result
}

/// Desc:		病历作者是否是指定用户，处理三种情况
/// 			1)病历创建者是指定用户，返回1
/// 			2)病历创建者不是指定用户，返回0
/// 			3)病历未保存，创建者为空，返回0
/// Creator:	Candy
/// CreateDate: 2014-10-13
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecBelongDoc(76,"1||1",105)
ClassMethod IsRecBelongDoc(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s:(objInstance.CreateUser = argUserID) result = 1
	q result
errhandle
	q "0"
}

/// Desc: 		病历是否完成某操作 
/// Creator: 	Candy
/// CreateDate: 2014-10-14
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
ClassMethod IsRecordActioned(argEpisodeID As %String, argInstanceID As %String, argAction As %String) As %String
{
	q ##class(web.DHCCM.EMRservice.BL.BLEMRLogs).RecHasAction(argEpisodeID,argInstanceID,argAction)
}

/// Desc:       是否住院医师审核
/// Creator:　  Candy
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
///             argInstanceID 病历号
/// Output:     result 0 未审核 1 审核
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsResidentChecked(76,"1||1")
ClassMethod IsResidentChecked(argEpisodeID As %String, argInstanceID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	
	s currentLog = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
	q:(currentLog = "") result
	q:(currentLog.EMRStatus = "unfinished") result
	q:(currentLog.EMRStatus = "finished") result
	s result = "1"
	q result
}

/// Desc:       是否主治医师审核
/// Creator:　  Candy
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
///             argInstanceID 病历号
/// Output:     result 0 未审核 1 审核
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsAttendingChecked(76,"1||1")
ClassMethod IsAttendingChecked(argEpisodeID As %String, argInstanceID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	
	s currentLog = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
	q:(currentLog = "") result
	q:(currentLog.EMRStatus = "unfinished") result
	q:(currentLog.EMRStatus = "finished") result
	q:(currentLog.EMRStatus = "residentChecked") result
	s result = "1"
	q result
}

/// Desc:       是否主任医师审核
/// Creator:　  Candy
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
///             argInstanceID 病历号
/// Output:     result 0 未审核 1 审核
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsChiefChecked(76,"1||1")	
ClassMethod IsChiefChecked(argEpisodeID As %String, argInstanceID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	
	s currentLog = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
	q:(currentLog = "") result
	q:(currentLog.EMRStatus = "unfinished") result
	q:(currentLog.EMRStatus = "finished") result
	q:(currentLog.EMRStatus = "residentChecked") result
	q:(currentLog.EMRStatus = "attendingChecked") result
	s result = "1"
	q result
}

/// Desc: 		指定用户是否为病历创建人的上级医生
/// Createor: 	Candy
/// CreateDate: 2014-10-14
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID	
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsUpUser(76,"1||1",105)
ClassMethod IsUpUser(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s authorId = objInstance.CreateUser
	s docInfo = ##class(EMRservice.BOPowerUser).GetById(argUserID)
	q:(docInfo = "") "0"
	s:($f("^"_docInfo.ChildUsers_"^","^"_authorId_"^")>1) result = "1"
	q result
}

/// Desc: 		指定用户是否为病历状态操作者的上级医生
/// Createor:	candy
/// CreateDate: 2014-10-14
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsUpLevelUser(76,"1||1",105)
ClassMethod IsUpLevelUser(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	//没有维护医生级别，则没有上级医生
	s docInfo = ##class(EMRservice.BOPowerUser).GetById(argUserID)
	q:(docInfo = "") "0"
	s docLevel = docInfo.UserLevel
	
	//日志不存在，说明是新建病历，所有医生都是"空"医生的上级医生
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") "0"
	
	s logId = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetLogID(argEpisodeID,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
	s objLogs = ##Class(User.DHCPHEMRLogs).%OpenId(logId)
	q:(objLogs = "") "1"
	
	s status = objLogs.EMRStatus
	
	//住院医师审核过，上级医师为主治或主任
	if (status = "residentChecked")   
	{
		q:((docLevel = "Attending")||(docLevel = "Chief")) "1"
	}
	//主治审核过，只有主任医师是其上级医师
	elseif (status = "attendingChecked")   
	{
		q:(docLevel = "Chief") "1"
	}
	//主任审核过，只有其本人才是其上级医师
	elseif (status = "chiefChecked")
	{
		
		s objInstanceLog = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetFirstLogByFinalStatus(argEpisodeID,argInstanceID,status)
		q:(objInstanceLog = "") "0"
		q:(docLevel = "Chief")&&(objInstanceLog.OperateUserID = argUserID) "1"
	}
	elseif (status = "archieved")
	{
		//已归档，谁也不能修改
		q "0"
	}
	else
	{
		//其他情况取创建者，比较创建者与当前用户的级别关系
		s authorId = objLogs.CreateUserID
		s author = ##class(EMRservice.BOPowerUser).GetById(authorId)
		q:(author = "") "0"
		s authorLevel = author.UserLevel
		
		//当前用户级别高于创建者级别
		q:(authorLevel = "Resident")&&((docLevel = "Attending")||(docLevel = "Chief")) "1"
		q:(authorLevel = "Attending")&&(docLevel = "Chief") "1"
		//创建者为主任，只有其自己为其上级医师
		q:(authorLevel = "Chief")&&(authorId = argUserID) "1"
	}
	q "0"
}

/// Desc:		用户是否为病历创建者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
/// Creator: 	Candy
/// CreateDate:	2014-10-31
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Deubg:      w ##Class(EMRservice.BOPrivAssist).IsCreatorUpUserByGroup(76,"1||1",105)
ClassMethod IsCreatorUpUserByGroup(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s objLog = ##class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
	q:(objLog = "") result
	s authorId = objLog.CreateUserID
	s authorGroupID = $p($g(^SSU("SSUSR",authorId)), "^",5)
	s userGroupID = $p($g(^SSU("SSUSR",argUserID)), "^",5)
	q:(authorGroupID '= userGroupID) result
	s authorLevel = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(authorId)
	s userLevel = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(argUserID)
	if (authorLevel = "Chief")
	{
		q result	
	}
	elseif (authorLevel = "Attending")
	{
		s:(userLevel = "Chief") result = 1
	}
	elseif (authorLevel = "Resident") 
	{
		s:((userLevel = "Chief")||(userLevel = "Attending")) result = 1
	}
	q result
}

/// Desc:		用户是否为病历操作者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
/// Creator: 	Candy
/// CreateDate:	2014-11-04
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsOperateorUpUserByGroup(76,"1||1",105)
ClassMethod IsOperateorUpUserByGroup(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
    s objCurrentInstanLog = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetCurrentInstanceLog(argEpisodeID,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
	q:(objCurrentInstanLog = "") result
	s operaterId = objCurrentInstanLog.OperateUserID
	s operaterGroupID = $p($g(^SSU("SSUSR",operaterId)), "^",5)
	s userGroupID = $p($g(^SSU("SSUSR",argUserID)), "^",5)
	q:(operaterGroupID '= userGroupID) result
	s operaterLevel = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(operaterId)
	s userLevel = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(argUserID)
	if (operaterLevel = "Chief")
	{
		q result	
	}
	elseif (operaterLevel = "Attending")
	{
		s:(userLevel = "Chief") result = 1
	}
	elseif (operaterLevel = "Resident") 
	{
		s:((userLevel = "Chief")||(userLevel = "Attending")) result = 1
	}
	q result
}

/// w ##class(EMRservice.BOPrivAssist).GetTemplateIDByInstanceID("2244||54")
ClassMethod GetTemplateIDByInstanceID(ArgInstanceID As %String = "") As %String
{
	s ret="-1"
	q:(ArgInstanceID="") ret
	s instanceobj=##Class(User.DHCPHInstanceData).%OpenId(ArgInstanceID)
	q:(instanceobj="") ret
	s ret=instanceobj.TemplateID
	s instanceobj=""
	q ret
}

/// /w ##class(EMRservice.BOPrivAssist).GetTitleCodeByInstanceID("2244||54")
ClassMethod GetTitleCodeByInstanceID(ArgInstanceID As %String = "") As %String
{
	s ret="-1"
	q:(ArgInstanceID="") ret
	s instanceobj=##Class(User.DHCPHInstanceData).%OpenId(ArgInstanceID)
	q:(instanceobj="") ret
	s ret=instanceobj.TitleCode
	s instanceobj=""
	q ret
}

/// Desc:		是否出院超过N小时
/// Creator: 	Candy
/// CreateDate:	2015-3-11
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsDischargedNHours(76,72)
ClassMethod IsDischargedNHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	s dischDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
	q:(dischDateTime = "") result
	s disDate = $p(dischDateTime,",",1)
	s disTime = $p(dischDateTime,",",2)
	q:(disDate = "")||(disTime = "") result
	s currDate = +$h
	s currTime = $p($h,",",2)
	s cDay = 0
	s cSecond = 0
	s cDay = currDate - disDate
	s cSecond = (currTime - disTime)\3600
	s retd = cDay*24+cSecond
	s:(retd > argHours) result = "1"
	q result
}

/// Desc:       病案室是否病历回收
/// Creator:    Candy
/// CreateDate: 2015-3-11
/// InPut:      argEpisodeID 就诊号
/// OutPut:     1已回收, 0未回收
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecordRetrieve(76)
ClassMethod IsRecordRetrieve(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	s status = ##Class(web.DHCWMRService).IGetMrRetrieveStatus(argEpisodeID)
	s:(status = "1") result = 1
	q result
}

/// Desc:       病案室是否已经归档
/// Creator:    Candy
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
/// Output:     result: 1--归档, 0--未归档
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecordArchived(76)
ClassMethod IsRecordArchived(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s status = ##Class(web.DHCWMRService).IGetMrArchiveStatus(argEpisodeID)
	s:(status = 1) result = "1"
	q result
}

/// Desc:    出院日期 根据类型取出出院日期
/// InPut:   argEpisodeID 就诊日期
///          argType 出院日期类型 "ByDoctor"医生医疗结算，"ByNurse"护士最终结算
/// Output： result "" 没出院,YYYY-MM-DD出院日期格式
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetDisDate(2)
ClassMethod GetDisDate(argEpisodeID As %String, argType As %String) As %String
{
	s result = ""
	q:((argEpisodeID = "")||(argType = "")) result
	q:(($d(^PAADM(argEpisodeID)) '= 1)&&($d(^PAADM(argEpisodeID)) '= 11)) result
	s dischgdate = ""
	//护士最终结算
	if (argType = "ByNurse")
	{
		s dischgdate = $P($G(^PAADM(argEpisodeID)),"^",17)
	}
	//医生医疗结算
	elseif (argType = "ByDoctor")
	{
		s dischgdate = $P($G(^PAADM(argEpisodeID)),"^",59)
	}
	s:(dischgdate '= "") result = $zd(dischgdate,3)
	q result
}

/// Desc:      入院时间间隔, 时间单位为小时
/// Creator:   Candy
/// CreatDate: 2015-3-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##Class(EMRservice.BOPrivAssist).GetAdmTimeSpan("89")
ClassMethod GetAdmTimeGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID)
 	q:((admDateTime) = "") result
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) result
 	s result = ..GetGapNow(admDate, admTime)	
 	q result
}

/// Desc:      出院时间间隔, 时间单位为小时
/// Creator:   Candy
/// CreatDate: 2015-3-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##(EMRservice.BOPrivAssist).GetDisTimeSpan("89")
ClassMethod GetDisTimeGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s dischDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
 	q:((dischDateTime) = "") result
 	s disDate = $p(dischDateTime,",",1)
 	s disTime = $p(dischDateTime,",",2)
 	q:((disDate = "")||(disTime = "")) result
  	s result = ..GetGapNow(disDate, disTime)	
 	q result
}

/// Desc:      入院时间间隔, 时间单位为小时
/// Creator:   Candy
/// CreatDate: 2015-3-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##class(EMRservice.BOPrivAssist).GetAdmTimeInBedSpan("89")
ClassMethod GetAdmTimeInBedGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(argEpisodeID)
 	q:((admDateTime) = "") result
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) result
 	s result = ..GetGapNow(admDate, admTime) 	
 	q result
}

/// Desc:      入院时间间隔, 时间单位为小时
/// Creator:   Candy
/// CreatDate: 2015-3-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##class(EMRservice.BOPrivAssist).GetInshAdmTimeSpan("89")
ClassMethod GetInhsAdmTimeGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).InhsAdmDateTime(argEpisodeID)
 	q:((admDateTime) = "") result
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) result
  	s result = ..GetGapNow(admDate, admTime)
  	q result
}

/// Desc:      取时间和当前间隔
/// Creator:   Candy
/// CreatDate: 2015-3-11
/// Input:     date 日期
///            time 时间
/// Output:    间隔小时
ClassMethod GetGapNow(date As %String, time As %String) As %String
{
	s now = $h
 	s currDate = $p(now,",",1)
 	s currTime = $p(now,",",2)
 	
 	s dayToHour = (currDate - date ) * 24
 	s secondToHour = (currTime - time)\3600
 	s gap = dayToHour + secondToHour
 	
 	q gap
}

/// Desc:      根据病人的任一就诊号,判断当前病人是否已出院
/// Creator:   Candy
/// CreatDate: 2015-03-11
/// Input:     APatientID 病人号
/// Output:    1-已经出院 0-目前在院
/// Others:    返回值根据episodeID取得的多个cateCharpter之间用@区分,最后加上!
/// Debug:     d ##class(EMRservice.BOPrivAssist).IsPatientDischarge(48)
ClassMethod IsPatientDischarge(APatientID As %String) As %String
{
	s result = "1"
	s episodeID = ""
	s paAdmType = ""
	for {
		s paAdmType =  $o(^PAPERdr(APatientID, "ADM", paAdmType))
		q:(paAdmType = "")

		s tmpEpisodeID = $o( ^PAPERdr(APatientID, "ADM", paAdmType, ""),-1)
		if (episodeID = "")
		{
			s episodeID = tmpEpisodeID
		}
		else
		{
			s:(episodeID < tmpEpisodeID) episodeID = tmpEpisodeID
		}
	}
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
	s:(disDateTime = "") result = "0"
	q result
}

/// Desc:       取创建者的ssgroupID
/// Creator:    Candy
/// CreateDate: 2015-3-11
/// Input:      argInstanceID
/// Output:     result ssgroupID
ClassMethod GetCreaterGroupID(argInstanceID As %String) As %String
{
    s result = ""
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s createUser = objInstance.CreateUser
	s:(createUser '= "") result = $p($g(^SSU("SSUSR",createUser)), "^",5)
	q result
}

/// Desc:       取最后修改者的ssgroupID
/// Creator:    Candy
/// CreateDate: 2015-3-11
/// Input:      argInstanceID
/// Output:     result ssgroupID 空为未取到
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetLastModifierGroupID("1||1")
ClassMethod GetLastModifierGroupID(argInstanceID As %String) As %String
{
    s result = ""
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s user = objInstance.ModifyUser
	s:(user '= "") result = $p($g(^SSU("SSUSR",user)), "^",5)
	q result
}

/// Desc:	是否已出院5个工作日（死亡患者为10个工作日）
/// Input:	argEpisodeID : 就诊指针
/// Return:	1 ：是， 0 ：否
/// Debug:	w ##Class(EMRservice.BOPrivAssist).IsDisFiveWorkingDay("76")
ClassMethod IsDisFiveWorkingDay(argEpisodeID As %String) As %Boolean
{
	s isOverSpan = "0"
	
	s dateTime = ..GetDeathDateTimeInAdm(argEpisodeID)
 	if (dateTime = "")
 	{
	 	s dateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
 		s span = 120		//正常出院患者：120小时
 	}
 	else
 	{
	 	s span = 240		//死亡患者：240小时
 	}
 	
 	s date = $p(dateTime,",",1)
 	s time = $p(dateTime,",",2)
 	q:((date = "")||(time = "")) isOverSpan
 	
 	s realSpan = ..WorkingTimeSpanToNow(date, time)
 	if (realSpan > span)
 	{	s isOverSpan = "1"}
 	
 	q isOverSpan
}

/// Desc:	指定日期时间到当前日期时间的工作时间间隔（单位：小时）
/// Input：	AStartDate : 指定日期
/// 		AEndDate : 指定时间
/// Return：时间间隔（单位：小时），保留两位有效数字
ClassMethod WorkingTimeSpanToNow(AStartDate As %Integer, AStartTime As %Integer) As %String
{
	s timeSpan = 0.00
	
	q:(AStartDate = "")||(AStartTime = "") timeSpan
	
	s now = $h
 	s currDate = $p(now,",",1)
 	s currTime = $p(now,",",2)
 	
 	s dayCount = currDate - AStartDate
 	q:(dayCount < 0) timeSpan
 	
 	if (dayCount = 0)
 	{
	 	//当前日期与起始日期为同一天，只需计算时间部分
	 	s seconds = currTime - AStartTime
	 	if (seconds > 0)&&(..IsWorkingDay(AStartDate)) 
	 	{
		 	s timeSpan = seconds/3600
		 	s timeSpan = $fn(timeSpan,"",2)
	 	}
	}
 	else
 	{
	 	s seconds = 0
	 	if (..IsWorkingDay(AStartDate))
	 	{
		 	//首日时间部分：起始时间至首日24点时间间隔
		 	s seconds = 86400 - AStartTime	//86400为24小时的秒数
	 	}
	 	if (..IsWorkingDay(currDate))
	 	{
		 	//末日时间部分：00点至当前时间点时间间隔
		 	s seconds = seconds + currTime
	 	}
	 	
	 	//其他日期为整天
	 	s days = 0
	 	s startDate = AStartDate + 1
	 	s endDate = currDate - 1
	 	for date = startDate:1:endDate
	 	{
		 	if (..IsWorkingDay(date))
		 	{
			 	s days =  days + 1
		 	}
	 	}
	 	
	 	s timeSpan = (days * 24) + (seconds / 3600)
	 	s timeSpan = $fn(timeSpan,"",2) 	
	}
	
	q timeSpan
}

/// Desc:	指定日期是否为工作日
/// 		判断过程使用了自定义字典的日历相关定义：EPRmeta.CustomDictionary
/// 				CtmDictType：	字典类型，	如 DHCEPRCalendar
/// 				CtmDictID：	    字典标识号，如 Holiday 和 Working
/// 				CtmDictCode：	字典代码，	如 2012-04-19 （也可考虑日期为Cache内部格式）
/// 				CtmDictDesc：	字典描述，	如 调休休息日 或 调休工作日 或 法定节假日 等。、
/// 	Input：	指定日期，Cache内部格式
/// 	Return：1 工作日，0 非工作日
/// Debug：	w ##Class(EMRservice.BOPrivAssist).IsWorkingDay(62557)
ClassMethod IsWorkingDay(argdate As %String) As %Boolean
{

	s id=""
	s mdate=$zd(argdate,3)
	&SQL(SELECT TOP 1 ID INTO :id FROM EPRmeta.CustomDictionary WHERE CtmDictType='DHCEPRCalendar' AND CtmDictCode=:mdate)
	//&SQL(SELECT TOP 1 CtmDictId INTO :ctid FROM EPRmeta.CustomDictionary WHERE CtmDictType='DHCEPRCalendar' AND CtmDictCode=:mdate)
	if (id'="")
	{
		s obj=##Class(EPRmeta.CustomDictionary).%OpenId(id)
		
		if (obj.CtmDictID="Holiday")
		{
			q "0"
		}
		elseif (obj.CtmDictID="Working")
		{
			q "1"
		}
	}
	
	if (id="")
	{
		if ($ZDATE(argdate,10)=0)||($ZDATE(argdate,10)=6)
		{
			q "0"
		}
		else
		{
			q "1"
		}
	}
}

/// Desc:	死亡日期时间或者出院日期时间
/// Input:	argEpisodeID : 就诊指针
/// Return:	死亡日期时间或者出院日期时间，格式为  日期,时间
/// Debug:	w ##Class(EMRservice.BOPrivAssist).GetDeathDateTimeInAdm("201764")
ClassMethod GetDeathDateTimeInAdm(argEpisodeID As %String) As %String
{
	s deathDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(argEpisodeID)
 	s deathDate = $p(deathDateTime,",",1)
 	s deathTime = $p(deathDateTime,",",2)
 	q:(deathDate="")||(deathTime="") ""
 	
 	s isDisOK = "0"
 	s dischDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
 	s disDate = $p(dischDateTime,",",1)
 	s disTime = $p(dischDateTime,",",2)
 	if (disDate = "")||(disTime = "")
 	{	s isDisOK = "1"	}
 	else
 	{
	 	if (deathDate < disDate)||((deathDate = disDate)&&(deathTime <= disTime))
	 	{	s isDisOK = "1"}
 	}
 	q:(isDisOK = "0") ""
 	
 	s isAdmOK = "0"
 	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID)
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	if (deathDate > admDate)||((deathDate = admDate)&&(deathTime > admTime))
 	{	s isAdmOK = "1"	}
 	q:(isAdmOK = "0") ""
 	
 	q deathDateTime
}

/// Description:获得病历授权功能赋予的操作授权
/// Input:AEpisodeID-病人就诊号,AUserID-用户ID,AUserLoc-用户所在部门,AInstanceID(病历id)
/// Others:返回一个字符串,格式如:"set browse=1,print=1"
/// Debug:w ##class(EMRservice.BOPrivAssist).GetAppiont("51","105","6","12||1")
/// 		  w ##class(EMRservice.BOPrivAssist).GetAppiont("1","154","9","210||44","")
/// Modify LIUZHONGWAN 增加一个入参DocID
ClassMethod GetAppiont(AEpisodeID As %String, AUserID As %String, AUserLoc As %String, AInstanceID As %String, ADocID As %String) As %String
{
	s str = ##class(EMRservice.Ajax.Appoint).GetAllActiveAppoint(AEpisodeID,AUserID,AUserLoc,AInstanceID,ADocID)
	q str
}

/// Desc:取患者当前就诊科室id
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetCurrentDept("53")
ClassMethod GetCurrentDept(argEpisodeID As %String)
{
	
	s currentLocID = ""
	s currentLoc = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(argEpisodeID)
	if (currentLoc '= "")
	{
		s currentLocID = $p(currentLoc,"^",1)
	}
	else
	{
		s currentLocID = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argEpisodeID)
	}
	q currentLocID
}

/// Desc:取患登录用户的医疗单元信息
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetUserUnit("6","180")
ClassMethod GetUserUnit(argUserLoc As %String, argUserID As %String)
{
	s DocId=$p($g(^SSU("SSUSR",argUserID)),"^",14)
	s UserUnit = ""
	s UserUnit = ..GetUintByDocCode(argUserLoc,DocId)
	q UserUnit
}

/// Desc:取（ICU患者转入ICU之前科室的主管医生）医疗小组（医疗单元）信息
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetBefTransToICUMainDocUnit("44")
ClassMethod GetBefTransToICUMainDocUnit(argEpisodeID As %String)
{
	s UserUnit = ""
	s count = 0
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argEpisodeID,"TRANS",childSub),-1)
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argEpisodeID,"TRANS",childSub)),"^",12)
		continue:(transStatusDR=2)
		
		s transCtlocDR = $p($g(^PAADM(argEpisodeID,"TRANS",childSub)),"^",6)
		continue:(transCtlocDR="")
		
		s count = count+1
		
		if (count = 2)
		{
			s DocID = $p($g(^PAADM(argEpisodeID,"TRANS",childSub)),"^",5)
			s UserUnit = ..GetUintByDocCode(transCtlocDR,DocID)
			q 
		}
	}
	q UserUnit
}

/// Desc: 取用户所在医疗单元信息
/// Debug:  w ##class(EMRservice.BOPrivAssist).GetUintByDocCode("6","180") 
ClassMethod GetUintByDocCode(DepID, DocID)
{
    s myrtn=""
    s UnitInfo=""
    Q:(DocID="") myrtn
    if DepID'="" {
        s MURowid=0
        for {
            s MURowid=$O(^CTLOC(DepID,"MU",MURowid))
            Q:MURowid=""
            s MUCode=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",1)
            s MUDesc=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",2)
            s MUActiveFlag=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",3)
            s MUDateFrom=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",4)
            s MUDateTo=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",5)
            
            if MUActiveFlag'="Y" continue
            if (MUDateFrom'="")&&(MUDateFrom>+$H) continue
            if (MUDateTo'="")&&(MUDateTo<+$H) continue
            
            s MUCRowid=0
            for {
                s MUCRowid=$O(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid))
                Q:MUCRowid=""
                s MUCDocDr=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",1)
                s MUCDateFrom=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",5)
                s MUCDateTo=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",6)
                
                if (MUCDateFrom'="")&&(MUCDateFrom>+$H) continue
                if (MUCDateTo'="")&&(MUCDateTo<+$H) continue
                if MUCDocDr=DocID {
                    s myrtn=DepID_"||"_MURowid_"||"_MUCRowid_"^"_MUDesc_"^"_MUCode
                }
                Q:myrtn'=""
            }
        }
    }else{
        ;此处应该改成索引
        s DepID=0
        for {
            s DepID=$O(^CTLOC(DepID)) Q:DepID=""
            s MURowid=0
            for {
                s MURowid=$O(^CTLOC(DepID,"MU",MURowid))
                Q:MURowid=""
                s MUCode=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",1)
                s MUDesc=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",2)
                s MUActiveFlag=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",3)
                s MUDateFrom=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",4)
                s MUDateTo=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",5)
                
                if MUActiveFlag'="Y" continue
                if (MUDateFrom'="")&&(MUDateFrom>+$H) continue
                if (MUDateTo'="")&&(MUDateTo<+$H) continue
                
                s MUCRowid=0
                for {
                    s MUCRowid=$O(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid))
                    Q:MUCRowid=""
                    s MUCDocDr=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",1)
                    s MUCDateFrom=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",5)
                    s MUCDateTo=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",6)
                    
                    if (MUCDateFrom'="")&&(MUCDateFrom>+$H) continue
                    if (MUCDateTo'="")&&(MUCDateTo<+$H) continue
                    if MUCDocDr=DocID {
                        s myrtn=DepID_"||"_MURowid_"||"_MUCRowid_"^"_MUDesc_"^"_MUCode
                    }
                    Q:myrtn'=""
                }
            }
        }
    }
    if myrtn'="" s UnitInfo=$p(myrtn,"^",3)    //////胡云超修改成取医疗组Code    2016-01-13
    
    Q UnitInfo
}

/// Desc:取ICU患者转入ICU之前的科室信息
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetLocBefTransToICU("53")
ClassMethod GetLocBefTransToICU(argEpisodeID As %String)
{
	s LocBefTransToICU = ""
	s count = 0
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argEpisodeID,"TRANS",childSub),-1)
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argEpisodeID,"TRANS",childSub)),"^",12)
		continue:(transStatusDR=2)
		
		s transCtlocDR = $p($g(^PAADM(argEpisodeID,"TRANS",childSub)),"^",6)
		continue:(transCtlocDR="")
		
		s count = count+1
		
		if (count = 2)
		{
			s LocBefTransToICU = transCtlocDR
			q 
		}
	}
	q LocBefTransToICU
}

}
