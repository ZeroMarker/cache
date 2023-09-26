/// get info from Trak for privilege management
Class EMRservice.BOPrivAssist Extends (%RegisteredObject, %SOAP.WebService) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
ClassMethod IsPatBelongToLoc(argPatEpisodeID As %String, argLocID As %String = "") As %String
{
	q:(argPatEpisodeID="")||(argLocID="") 1
	
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
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsPatBelongToLinkLoc(201871,34)
ClassMethod IsPatBelongToLinkLoc(argPatEpisodeID As %String, argLocID As %String) As %String
{
	q:(argPatEpisodeID = "")||(argLocID = "") "0"
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

/// Desc:		用户是否为护士[UserIsNur]
/// Modify: 	duan
/// Input: 		argDocID 用户ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).UserIsNur("76")
ClassMethod UserIsNur(argDocID As %String) As %String
{
	q:($d(argDocID)=0)||(argDocID="") "0" 
	s LinkId="",CareProvId="",Degree="",TemplateUse=""
	s LinkId=$p($G(^SSU("SSUSR",argDocID)),"^",14)
	q:(LinkId="") "0"
	s CareProvId=$p($G(^CTPCP(LinkId,"1")),"^",4)
	q:(CareProvId="") "0"
	s Degree=$p($G(^CT("CPT",CareProvId)),"^",4)
	q:(Degree="NURSE") "1"
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

ClassMethod IsEPatient(argPatEpisodeID As %String) As %String
{
	s RetType = ""
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s RetType = $case(PatientType="E",1:1,:0)
	q RetType
}

ClassMethod IsIPatient(argPatEpisodeID As %String) As %String
{
	s RetType = 1
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s:(PatientType'="I") RetType=0
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
	s instance = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(instance = "") result
	s status = instance.Status
	s:(status = "Save") result = 1
	q result
}

/// Desc:		病历作者是否是指定用户，处理三种情况
/// 			1)病历创建者是指定用户，返回1
/// 			2)病历创建者不是指定用户，返回0
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s:(objInstance.CreateUser = argUserID) result = 1
	s:(objInstance.Status = "UnSave" ) result = 1
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
	q ##class(EMRservice.BL.BLEMRLogs).RecHasAction(argEpisodeID,argInstanceID,argAction)
}

/// Desc: 		打印完成24小时
/// Creator: 	XH
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// w ##class(EMRservice.BOPrivAssist).IsRecordprinted(21627,"145291||1","SAVE")
ClassMethod IsRecordprinted(argEpisodeID As %String, argInstanceID As %String, argAction As %String) As %String
{
	s result=0
	q:(argEpisodeID = "")||(argInstanceID = "")||(argAction = "") result
	s PrintDateTime =..RecHasAction(argEpisodeID,argInstanceID,argAction)
	q:(PrintDateTime="")||(PrintDateTime=" ") result
	s PrintDate =$p(PrintDateTime," ",1)
	s PrintTime =$p(PrintDateTime," ",2)
	s Date=$p($h,",",1)
	s Time=$p($h,",",2)
	s ret = ((Date-PrintDate)*24)+((Time-PrintTime)/3600)
	s:(ret>24) result=1
	b 
	q result
}

/// 返回病历打印时间
/// debug:         w ##class(EMRservice.BOPrivAssist).RecHasAction(1,"24||3","SAVE")
ClassMethod RecHasAction(pEpisodeID As %String, pInstanceID As %String, pAction As %String) As %String
{
    s $zt="errhandle"
    s result = ""
    q:(pEpisodeID = "")||(pInstanceID = "")||(pAction = "") result
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(pInstanceID)
    q:(objInstance = "") result
    s EMRLogsId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_pEpisodeID," "_objInstance.TheECRecord.ChartItemID,objInstance.ListNo,""))
    q:(EMRLogsId = "") result
    s (OperateDate,OperateTime)=""
    if (($d(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(pAction,"U")))>0)) {
        s OperateDate=$o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(pAction,"U"),OperateDate))
        s OperateTime=$o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(pAction,"U"),OperateDate,OperateTime))
        }
    //s:(OperateDate'="") OperateDate=$zd(OperateDate,3)
    //s:(OperateTime'="") OperateTime=$zt(OperateTime,1)
    s:(OperateDate'="") result=OperateDate_" "_OperateTime
    q result
errhandle
    q ""
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	
	s currentLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	
	s currentLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
	q:(currentLog = "") result
	q:(currentLog.EMRStatus = "patientSigned") result
	q:(currentLog.EMRStatus = "unfinished") result
	q:(currentLog.EMRStatus = "finished") result
	q:(currentLog.EMRStatus = "residentChecked") result
	q:(currentLog.EMRStatus = "participantChecked") result
	q:(currentLog.EMRStatus = "internChecked") result
	
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	
	s currentLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
	q:(currentLog = "") result
	q:(currentLog.EMRStatus = "patientSigned") result
	q:(currentLog.EMRStatus = "unfinished") result
	q:(currentLog.EMRStatus = "finished") result
	q:(currentLog.EMRStatus = "participantChecked") result
	q:(currentLog.EMRStatus = "residentChecked") result
	q:(currentLog.EMRStatus = "attendingChecked") result
	q:(currentLog.EMRStatus = "internChecked") result
	
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
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
	q:(argEpisodeID="")||(argInstanceID="")||(argUserID="") "0"
	
	//没有维护医生级别，则没有上级医生
	s docInfo = ##class(EMRservice.BL.BLSignRole).GetUserLevel(argUserID)
	q:(docInfo = "") "0"
	s docLevel = $p(docInfo,"^",1)
	
	//日志不存在，说明是新建病历，所有医生都是"空"医生的上级医生
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") "1"
	
	s logId = ##Class(EMRservice.BL.BLEMRLogs).GetLogID(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
	s objLogs = ##Class(EMRinstance.EMRLogs).%OpenId(logId)
	q:(objLogs = "") "1"
	
	s status = objLogs.EMRStatus
	
	//住院医师审核过，上级医师为主治或主任
	if (status = "residentChecked")   
	{
		s objInstanceLog = ##Class(EMRservice.BL.BLEMRLogs).GetFirstLogByFinalStatus(argEpisodeID,argInstanceID,status)
		q:(objInstanceLog = "") "0"
		q:(objInstanceLog.OperateUserID = argUserID) "1"
		q:((docLevel = "Attending")||(docLevel = "Chief")) "1"
	}
	//主治审核过，只有主任医师是其上级医师
	elseif (status = "attendingChecked")   
	{
		s objInstanceLog = ##Class(EMRservice.BL.BLEMRLogs).GetFirstLogByFinalStatus(argEpisodeID,argInstanceID,status)
		q:(objInstanceLog = "") "0"
		q:(objInstanceLog.OperateUserID = argUserID) "1"
		q:(docLevel [ "Chief") "1"
	}
	//主任审核过，只有其本人才是其上级医师
	elseif (status = "chiefChecked")||(status = "viceChiefChecked")
	{
		
		s objInstanceLog = ##Class(EMRservice.BL.BLEMRLogs).GetFirstLogByFinalStatus(argEpisodeID,argInstanceID,status)
		q:(objInstanceLog = "") "0"
		q:(docLevel [ "Chief")&&(objInstanceLog.RRealOperateUserID = argUserID) "1"
	}
	elseif (status = "archieved")
	{
		//已归档，谁也不能修改
		q "0"
	}
	else
	{
		q "1"
		
		//未签名病历，本人可以编辑本人创建的病历！
		q:(argUserID=objLogs.CreateUserID) "1"
		
		//其他情况取创建者，比较创建者与当前用户的级别关系
		s authorId = objLogs.CreateUserID
		s author = ##class(EMRservice.BL.BLSignRole).GetUserLevel(authorId)
		s authorLevel = $P(author,"^",1)
		
		//当前用户级别高于或者等于创建者级别
		q:(authorLevel = "intern")&&((docLevel = "Resident")||(docLevel = "Attending")||(docLevel = "Chief")) "1"
		q:(authorLevel = "Resident")&&((docLevel = "Resident")||(docLevel = "Attending")||(docLevel = "Chief")) "1"
		q:(authorLevel = "Attending")&&((docLevel = "Attending")||(docLevel = "Chief")) "1"
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
/// Deubg:      w ##Class(EMRservice.BOPrivAssist).IsCreatorUpUserByGroup(63,"2505||5",18881)
ClassMethod IsCreatorUpUserByGroup(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s objLog = ##class(EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
	q:(objLog = "") result
	s authorId = objLog.CreateUserID
	s authorGroupID = $p($g(^SSU("SSUSR",authorId)), "^",5)
	s userGroupID = $p($g(^SSU("SSUSR",argUserID)), "^",5)
	q:(authorGroupID '= userGroupID) result

	s authorRoleName = $p(##class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(authorId),"^",1)
	s userRoleName = $p(##class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(argUserID),"^",1)
	s authorLevel = ##class(EMRservice.BL.BLSignRole).GetSignLevel(authorRoleName)
	s userLevel = ##class(EMRservice.BL.BLSignRole).GetSignLevel(userRoleName)
	
	q:(userLevel>authorLevel) 1

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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
    s objCurrentInstanLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentInstanceLog(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
	q:(objCurrentInstanLog = "") result
	s operaterId = objCurrentInstanLog.RRealOperateUserID
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

/// Desc:       是否为创建者的上级医师（取his的维护程序）
/// Creaotr:    Candy
/// CreateDate: 2016-8-15 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCreatorUpUserByHISGroup("1||1",105)
ClassMethod IsCreatorUpUserByHISGroup(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s creatorId = objInstance.CreateUser
    q:(creatorId = "") "1"   //创建者为空时应默认为创建者上级
	s creatorPvId = $p($g(^SSU("SSUSR",creatorId)),"^",14)
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(creatorPvId = "")||(userPvId = "") result
	s creatorUnitPar = $o(^CTLOC(0,"CTPCP",creatorPvId,0))
	q:(creatorUnitPar = "") result
	s userUnitPar = $o(^CTLOC(0,"CTPCP",userPvId,0))
	q:(creatorUnitPar '= userUnitPar) result	
	s creatorUnitSub = $o(^CTLOC(0,"CTPCP",creatorPvId,creatorUnitPar,"MU",0))
	q:(creatorUnitSub = "") result
	s userUnitSub = $o(^CTLOC(0,"CTPCP",userPvId,userUnitPar,"MU",0))
	q:(creatorUnitSub '= userUnitSub) result
	s creatorLevel = ##class(EMRservice.BL.BLPowerUser).GetHisUserLevel(creatorPvId)
	s userLevel = ##class(EMRservice.BL.BLPowerUser).GetHisUserLevel(userPvId)
	if ((creatorLevel = "231")||(creatorLevel = "232"))
	{
		q result	
	}
	elseif (userLevel = "233")
	{
		s:((creatorLevel = "231")||(creatorLevel = "232")) result = 1
	}
	elseif (userLevel = "234") 
	{
		s:((creatorLevel = "231")||(creatorLevel = "232")||(creatorLevel = "233")) result = 1
	}
	q result
}

/// Desc:       是否为操作者的上级医师（取his的维护程序）
/// Creaotr:    Candy
/// CreateDate: 2016-8-15 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsOperaterUpUserByHISGroup("1||2",105)
ClassMethod IsOperaterUpUserByHISGroup(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s operatorId = objInstance.ModifyUser
	q:(operatorId = "") result
	
	s operatorPvId = $p($g(^SSU("SSUSR",operatorId)),"^",14)
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)

	s operatorUnitPar = $o(^CTLOC(0,"CTPCP",operatorPvId,0))
	q:(operatorUnitPar = "") result
	s userUnitPar = $o(^CTLOC(0,"CTPCP",userPvId,0))
	q:(operatorUnitPar '= userUnitPar) result	
	s operatorUnitSub = $o(^CTLOC(0,"CTPCP",operatorPvId,operatorUnitPar,"MU",0))
	q:(operatorUnitSub = "") result
	s userUnitSub = $o(^CTLOC(0,"CTPCP",userPvId,userUnitPar,"MU",0))
	q:(operatorUnitSub '= userUnitSub) result
	s creatorLevel = ##class(EMRservice.BL.BLPowerUser).GetHisUserLevel(operatorPvId)
	s userLevel = ##class(EMRservice.BL.BLPowerUser).GetHisUserLevel(userPvId)
	if ((creatorLevel = "231")||(creatorLevel = "232"))
	{
		q result	
	}
	elseif (userLevel = "233")
	{
		s:((creatorLevel = "231")||(creatorLevel = "232")) result = 1
	}
	elseif (userLevel = "234") 
	{
		s:((creatorLevel = "231")||(creatorLevel = "232")||(creatorLevel = "233")) result = 1
	}	
	q result
}

/// Desc:       获取术者ID
/// Creator:    Candy
/// CreateDate: 2016-8-15
/// Input:      argInstanceID 病历ID
///            argUserID 用户
/// Output:     1 是 0 否
ClassMethod GetOperationUser(argInstanceID As %String) As %String
{
	s result = ""
	q:(argInstanceID = "") result
	s rowId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," OPERATION"," "_argInstanceID,""))
	s objDoc = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(rowId)
    q:(objDoc = "")
    s eventId = objDoc.EventsID
    s objOpeation = ##Class(EMRinstance.Events.Operation).%OpenId(eventId)
    q:(objOpeation = "") result
    s result = objOpeation.OperDocID
    q result
}

/// Desc:       获取一助ID
/// Creator:    Candy
/// CreateDate: 2016-8-15
/// Input:      argInstanceID 病历ID
///            argUserID 用户
/// Output:     1 是 0 否
ClassMethod GetOperationAssistFirst(argInstanceID As %String) As %String
{
	s result = ""
	q:(argInstanceID = "") result
	s rowId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxInstanceType"," OPERATION"," "_argInstanceID,""))
	s objDoc = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(rowId)
    q:(objDoc = "")
    s eventId = objDoc.EventsID
    s objOpeation = ##Class(EMRinstance.Events.Operation).%OpenId(eventId)
    q:(objOpeation = "") result
    s result = objOpeation.OperAssistFirstID
    q result
}

/// w ##class(EMRservice.BOPrivAssist).GetTemplateIDByInstanceID("2244||54")
ClassMethod GetTemplateIDByInstanceID(ArgInstanceID As %String = "") As %String
{
	s ret="-1"
	q:(ArgInstanceID="") ret
	s instanceobj=##Class(EMRinstance.InstanceData).%OpenId(ArgInstanceID)
	q:(instanceobj="") ret
	s ret=instanceobj.RealTemplateID
	s instanceobj=""
	q ret
}

/// /w ##class(EMRservice.BOPrivAssist).GetTitleCodeByInstanceID("2244||54")
ClassMethod GetTitleCodeByInstanceID(ArgInstanceID As %String = "") As %String
{
	s ret="-1"
	q:(ArgInstanceID="") ret
	s instanceobj=##Class(EMRinstance.InstanceData).%OpenId(ArgInstanceID)
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
	///排除周末时间
	s WeekendHours = ..WeekendHours(disDate,currDate)
	s retd = cDay*24+cSecond - WeekendHours
	s:(retd > argHours) result = "1"
	q result
}

/// w ##Class(EMRservice.BOPrivAssist).WeekendHours(65265,65267)
/// 两个日期之间的周末时间
ClassMethod WeekendHours(StartDate, EndDate)
{
    s ret = 0
    s len = EndDate - StartDate
    q:(len<0) ret
    for i=1:1:len {
	   s date = StartDate + i 
	   s week =$ZD(date,10)
	   if ((week=0)||(week=6)) {
	     s ret = ret +24
	   }
	}
	q ret
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
	//s status = ##Class(web.DHCWMRService).IGetMrRetrieveStatus(argEpisodeID)
	//s status = ##class(DHCWMR.IO.ToHistorySrv).IGetMrRetrieveStatus(argEpisodeID)
	s status =##class(MA.IPMR.IO.OutService).GetFinishStatus(argEpisodeID,"RC")
	
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
	//s status = ##Class(web.DHCWMRService).IGetMrArchiveStatus(argEpisodeID)
	s status = ##class(MA.IPMR.IO.OutService).GetFinishStatus(argEpisodeID,"FP")
	s:(status = 1) result = "1"
	q result
}

/// Desc:       病案室是否复印病历
/// Creator:    
/// CreateDate: 2016-11-8
/// Input:      argEpisodeID 就诊号
/// Output:     result: 1--已复印, 0--未复印
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCopy(76)
ClassMethod IsCopy(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s status = ##class(DHCWMR.IO.TOHistorySrv).GetIsCopyByAdm(argEpisodeID)
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
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

/// Desc:	是否已出院7个工作日
/// Input:	argEpisodeID : 就诊指针
/// Return:	1 ：是， 0 ：否
/// Debug:	w ##Class(EMRservice.BOPrivAssist).IsDisFiveWorkingDay("76")
ClassMethod IsDisSevenWorkingDay(argEpisodeID As %String) As %Boolean
{
	s isOverSpan = "0"
	
	s dateTime = ..GetDeathDateTimeInAdm(argEpisodeID)
 	if (dateTime = "")
 	{
	 	s dateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
 		s span = 168		//正常出院患者：120小时
 	}
 	else
 	{
	 	s span = 168		//死亡患者：240小时
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
	s ret = 0
	//修改为统一接口
	s dayType=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(argdate,"","")
	//dayType 0工作日 1 假日 2 节日
	s:(dayType=0) ret = 1
	
	q ret
	
  /*
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
	*/
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
	//s str = ##class(EMRservice.Ajax.Appoint).GetAllActiveAppoint(AEpisodeID,AUserID,AUserLoc,AInstanceID,ADocID)
	s str = ##class(EMRservice.Ajax.AuthAppoint).GetAllActiveAppoint(AEpisodeID,AUserID,AUserLoc,AInstanceID,ADocID)
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

/// Desc:	医嘱是否被锁定
/// 		LiXJ 2016-09-19
/// 		w ##class(EMRservice.BOPrivAssist).IsOrdHasLocked("2178",1796,425,"3ptz6TRf00")
/// 			ret=1,被锁定。ret=0,未被锁定。
ClassMethod IsOrdHasLocked(AdmID As %String, UserID As %String, LocID As %String, sessionID As %String)
{
	s OeordID="",ret=1,value="",warning="",List=""
	s OeordID=$o(^OEORD(0,"Adm",AdmID,""))
	q:(OeordID="") 0
	s List=$lb(OeordID,"User.OEOrder")
	s value=##Class(websys.Lock).Lock(List,sessionID,UserID,.warning,LocID)
	q:(warning="") 0
	q ret
}

/// Desc:		此时病历是否超过书写时间要求
/// Creator:	niucaicai
/// CreateDate:	2016-08-30
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsRecordOverRan("16||16")
ClassMethod IsRecordOverRan(argInstanceID As %String) As %String
{
	s result = 0
	q:(argInstanceID = "") result
	s instance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(instance = "") result
	s status = instance.Status
	q:(status = "Save") result
	
	s EpisodeID = instance.RealEpisodeID
	s TemplateID = instance.RealTemplateID
	s TitileCode = instance.TitleCode
	s PapmiDR = $P($g(^PAADM(EpisodeID)),"^",1)
	
	s SavedInfo = ..GetSavedInfo(EpisodeID,TemplateID,TitileCode)
	s SavedTimes = $p(SavedInfo,",",1)
	q:(SavedTimes '= 0) result
	
	s Systemdatetime = $HOROLOG
	s Systemdateint = $p(Systemdatetime,",",1)
	s Systemtimeint = $p(Systemdatetime,",",2)
	
	if (TemplateID = "16")  //此处需要维护“入院记录”的模板ID，判断“入院记录”是否超时——入院记录，应在患者入院24小时内完成
	{
		s AdmDateTime = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
		s AdmDate = $p(AdmDateTime,",",1)
		s AdmTime = $p(AdmDateTime,",",2)
		
		if ((Systemdateint-AdmDate)>=2)
		{
			s result = 1
		}
		elseif ((Systemdateint-AdmDate)=1)
		{
			s:((Systemtimeint-AdmTime)>0) result = 1
		}
	}
	elseif (TemplateID = "21")  //此处需要维护“出院记录”的模板ID，判断“出院记录”是否超时——出院记录，应在患者出院24小时内完成
	{
		s DisDateTime = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
		s DisDate = $p(DisDateTime,",",1)
		s DisTime = $p(DisDateTime,",",2)
		
		if ((Systemdateint-DisDate)>=2)
		{
			s result = 1
		}
		elseif ((Systemdateint-DisDate)=1)
		{
			s:((Systemtimeint-DisTime)>0) result = 1
		}
	}
	elseif (TemplateID = "22")  //此处需要维护“死亡记录”的模板ID，判断“死亡记录”是否超时——死亡记录，应在患者死亡24小时内完成
	{
		s DeathDateTime = ##Class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(PapmiDR)
		s DeathDate = $p(DeathDateTime,",",1)
		s DeathTime = $p(DeathDateTime,",",2)
		
		if ((Systemdateint-DeathDate)>=2)
		{
			s result = 1
		}
		elseif ((Systemdateint-DeathDate)=1)
		{
			s:((Systemtimeint-DeathTime)>0) result = 1
		}
	}
	elseif (TemplateID = "29")  //此处需要维护“死亡病历讨论记录”的模板ID，判断“死亡病历讨论记录”是否超时——死亡病历讨论记录，应在患者死亡后一周内完成
	{
		s DeathDateTime = ##Class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(PapmiDR)
		s DeathDate = $p(DeathDateTime,",",1)
		s DeathTime = $p(DeathDateTime,",",2)
		
		if ((Systemdateint-DeathDate)>=8)
		{
			s result = 1
		}
		elseif ((Systemdateint-DeathDate)=7)
		{
			s:((Systemtimeint-DeathTime)>0) result = 1
		}
	}
	elseif (TemplateID = "20")  //此处需要维护“病程记录”的模板ID，判断“病程记录”是否超时——病程记录，需要根据具体的标题来判断是否超时
	{
		s AdmDateTime = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
		s AdmDate = $p(AdmDateTime,",",1)
		s AdmTime = $p(AdmDateTime,",",2)
		
		if (TitileCode = "1")   //此处需要维护“首次病程记录”的标题Code，判断“首次病程记录”是否超时——首次病程记录，应在患者入院8小时内完成
		{
			if ((Systemdateint-AdmDate)>=2)
			{
				s result = 1
			}
			elseif ((Systemdateint-AdmDate)=1)
			{
				s:((Systemtimeint-AdmTime)/3600+24>8) result = 1
			}
			elseif ((Systemdateint-AdmDate)=0)
			{
				s:((Systemtimeint-AdmTime)/3600>8) result = 1
			}
		}
		
		elseif (TitileCode = "4")   //此处需要维护“首次主治(中)医师查房记录”的标题Code，判断“首次主治(中)医师查房记录”是否超时——首次主治(中)医师查房记录，应在患者入院48小时内完成
		{
			if ((Systemdateint-AdmDate)>=3)
			{
				s result = 1
			}
			elseif ((Systemdateint-AdmDate)=2)
			{
				s:((Systemtimeint-AdmTime)>0) result = 1
			}
		}
		elseif (TitileCode = "5")   //此处需要维护“首次主任(副主任以上)医师查房记录”的标题Code，判断“首次主任(副主任以上)医师查房记录”是否超时——首次主任(副主任以上)医师查房记录，应在患者入院72小时内完成
		{
			if ((Systemdateint-AdmDate)>=4)
			{
				s result = 1
			}
			elseif ((Systemdateint-AdmDate)=3)
			{
				s:((Systemtimeint-AdmTime)>0) result = 1
			}
		}
		elseif (TitileCode = "8")   //此处需要维护“转入记录”的标题Code，判断“转入记录”是否超时——转入记录，应在患者转科记录书写后24小时内完成
		{
			s SavedInfo = ..GetSavedInfo(EpisodeID,TemplateID,"7")  //此处需要维护“转出记录”的标题Code，作为第三个参数
			if ($p(SavedInfo,",",1) '= 0)
			{
				s TransDeptDate = $p(SavedInfo,",",2)
				s TransDeptTime = $p(SavedInfo,",",3)
				if ((Systemdateint-TransDeptDate)>=2)
				{
					s result = 1
				}
				elseif ((Systemdateint-TransDeptDate)=1)
				{
					s:((Systemtimeint-TransDeptTime)>0) result = 1
				}
			}
		}
	}
	
	q result
}

/// desc: 判断某次就诊的某个模板是否已写
/// creator: niucaicai
/// CreateDate:	2016-08-30
/// input: EpisodeID:就诊指针; TemplateID:模板ID; TitileCode:标题Code
/// output: "书写次数,最后一次的创建日期,最后一次的创建时间"
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetSavedInfo("52","20","4")
ClassMethod GetSavedInfo(argEpisodeID As %String, argTemplateID As %String, argTitileCode As %String) As %String
{
	s count = 0
	s DateTime = ","
	s HappenDate = 0
	for
	{
		s HappenDate = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",argEpisodeID," SAVE",HappenDate))
		q:(HappenDate = "")
		
		s HappenTime = ""
		for
		{
			s HappenTime = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",argEpisodeID," SAVE",HappenDate,HappenTime))
			q:(HappenTime = "")
			
			s TheECRecord = ""
			for
			{
				s TheECRecord = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord))
				q:(TheECRecord = "")
				
				s ListNo = ""
				for
				{
					s ListNo = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord,ListNo))
					q:(ListNo = "")
					
					s InstanceDataID = TheECRecord_"||"_ListNo
					s InstanceObj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
					s TemplateID = InstanceObj.RealTemplateID
					s TitleCode = InstanceObj.TitleCode
					s CreateDate = InstanceObj.CreateDate
					s CreateTime = InstanceObj.CreateTime
					if (argTitileCode = "")
					{
						if (TemplateID=argTemplateID)
						{
							s count = count+1
							s DateTime = CreateDate_","_CreateTime
						}
					}
					else
					{
						if ((TemplateID=argTemplateID)&&(TitleCode=argTitileCode))
						{
							s count = count+1
							s DateTime = CreateDate_","_CreateTime
						}
					}
				}
			}
		}
	}
	q count_","_DateTime
}

/// Desc:       取标题Code
/// Creator:    Candy
/// CreateDate: 2017-01-17
/// Input:      argInstanceID  病历ID
/// Output      result 病历titleCode 
ClassMethod GetTitleCode(argInstanceID As %String) As %String
{
	s result = ""
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.TitleCode
	q result
}

/// Desc:       青医判断是否可确认病历全部完成，即“送病案室”
/// Creator:　  Donglulu
/// CreateDate: 2017-3-29
/// Input:      argEpisodeID 就诊号
/// Output:     result 0 未结算 1 已结算
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsDocCommit(76)
ClassMethod IsDocCommit(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "") result
	s result = ##class(DHCEPRFS.BL.BLPrivilege).CheckDocCommitPrivilege(argEpisodeID)
	if (result=0)
	{
		s result =  ##class(MA.IPMR.IO.OutService).GetFinishStatus(argEpisodeID,"NI")
	}
	
	q result
}

/// Desc:       病历是否有有效签名(任何级别都可以)
/// Creator:　  yan
/// CreateDate: 2017-7-31
/// Input:      argInstanceID 病历实例ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).HasValidSign("1||1")
ClassMethod HasValidSign(argInstanceID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "") result
	s signID=""
	for {
	    s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_argInstanceID, signID),-1)
	    q:(signID="")
	    s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
	    s:(sign.isSignValid="1") result = "1"
	    q:(result = "1")
	}
	q result
}

/// Desc:      转科时间间隔, 时间单位为小时
/// Creator:   Donglulu
/// CreatDate: 2017-11-21
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时(返回-1说明没有转过科)
/// Debug:     w ##class(EMRservice.BOPrivAssist).GetTransCTLOCGap(7932)
ClassMethod GetTransCTLOCGap(argEpisodeID As %String) As %Integer
{
	s result = -1
	//接口不存在的情况下，返回-1
	s isExist =##Class(EMRservice.BOPrivAssist).IsExistMethod("Nur.Interface.OutSide.Patient","getLastTransLocHours")
	q:(isExist=0) result

  	
  	s result = ##class(Nur.Interface.OutSide.Patient).getLastTransLocHours(argEpisodeID)
  		
 	q result
}

/// Desc:       该科室是否为转科前科室
/// Creator:　  Donglulu
/// CreateDate: 2017-7-31
/// Input:      argEpisodeID:病人就诊rowid   argLocID 当前用户科室ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsTransPreviousCTLOC("7932","221")
ClassMethod IsTransPreviousCTLOC(argEpisodeID As %String, argLocID As %String) As %String
{
	s result = "0"
	q:((argEpisodeID = "")||(argLocID = "")) result
	s isExist =##Class(EMRservice.BOPrivAssist).IsExistMethod("Nur.Interface.OutSide.Patient","getPreviousLoc")
	q:(isExist=0) result
	
	s transMessage = ##class(Nur.Interface.OutSide.Patient).getPreviousLoc(argEpisodeID)
 	q:(transMessage = "") result
 	s transLoc = $p(transMessage,"^",1)
 	s:(transLoc = argLocID) result = "1"
	q result
}

/// Desc:		用户是否为病历最后操作者
/// Creator: 	Donglulu
/// CreateDate:	2018-1-10
/// Input:		argEpisodeID 就诊ID
/// 			argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsOperateor(76,"1||1",105)
ClassMethod IsOperateor(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
    s objCurrentInstanLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentInstanceLog(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
	q:(objCurrentInstanLog = "") result
	s operaterId = objCurrentInstanLog.RRealOperateUserID
	q:(operaterId = "") result
	s:(operaterId = argUserID) result = 1
	q result
}

/// Desc:       用户是否为病历操作者的HIS医疗组组长
/// Creaotr:    Donglulu
/// CreateDate: 2018-1-11 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsOperaterHISGroupLeader("1||2",105)
ClassMethod IsOperaterHISGroupLeader(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s operatorId = objInstance.ModifyUser
	q:(operatorId = "") result
	
	s operatorPvId = $p($g(^SSU("SSUSR",operatorId)),"^",14)
	q:(operatorPvId="") result
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(userPvId="") result
	s result = ##class(EMRservice.BOPrivAssist).IsCTLOCLederFlag(userPvId,operatorPvId)
	q result
}

/// 判断ctcareOneDr是不是ctcareTwoDr的医疗组组长
/// Input:医护人员表ID
/// Output:1是,0否
/// w ##class(EMRservice.BOPrivAssist).IsCTLOCLederFlag("1076","1069")
ClassMethod IsCTLOCLederFlag(ctcareOneDr, ctcareTwoDr)
{
	s ret=0
	q:ctcareOneDr="" ret
	q:ctcareTwoDr="" ret
	s MuOneRef=""
	f  s MuOneRef=$o(^CTLOC(0,"CTPCP",ctcareOneDr,MuOneRef)) q:MuOneRef=""  d
	.s MuOneRowid=""
	.f  s MuOneRowid=$o(^CTLOC(0,"CTPCP",ctcareOneDr,MuOneRef,"MU",MuOneRowid)) q:MuOneRowid=""  d
	..s MuOneFlag=$p(^CTLOC(MuOneRef,"MU",MuOneRowid),"^",3)
	..q:MuOneFlag'="Y"
	..s MuOneRowidSub="",MuOneLeadFlag=""
	..f  s MuOneRowidSub=$o(^CTLOC(0,"CTPCP",ctcareOneDr,MuOneRef,"MU",MuOneRowid,"CP",MuOneRowidSub)) q:(MuOneRowidSub="")||(MuOneLeadFlag="Y")  d
	...s MuOneFormTo=$p(^CTLOC(MuOneRef,"MU",MuOneRowid,"CP",MuOneRowidSub),"^",6)
	...q:(MuOneFormTo'="")&&(MuOneFormTo<+$h)
	...s MuOneLeadFlag=$p(^CTLOC(MuOneRef,"MU",MuOneRowid,"CP",MuOneRowidSub),"^",2)
	...q:MuOneLeadFlag'="Y"

	..i MuOneLeadFlag="Y" d
	...s MuRowidSub=""
	...f  s MuRowidSub=$o(^CTLOC(MuOneRef,"MU",MuOneRowid,"CP",MuRowidSub)) q:(MuRowidSub="")||(ret=1)  d
	....s MucareDr=$p(^CTLOC(MuOneRef,"MU",MuOneRowid,"CP",MuRowidSub),"^",1)
	....s MuFormTo=$p(^CTLOC(MuOneRef,"MU",MuOneRowid,"CP",MuRowidSub),"^",6)
	....q:(MuFormTo'="")&&(MuFormTo<+$h)
	....i MucareDr=ctcareTwoDr s ret=1
	q ret
}

/// Desc:		当前科室是否为检查检验病理医嘱接收科室
/// Creator: 	Donglulu
/// CreateDate:	2018-1-11
/// Input:		argEpisodeID 就诊号     argUserLoc 登陆科室ID    
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsAdmRecDep(76,445)
ClassMethod IsAdmRecDep(argEpisodeID As %String, argUserLoc As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argUserLoc = "") result
	s admRecDep = ##Class(EMRservice.BOPrivAssist).GetAdmRecDep(argEpisodeID)
	q:(admRecDep = "") result
	k ^TempEMRAdmRecDep("EMR")
	s count = 0
	s appointTime = ##Class(EMRservice.SystemParameter).GetAppointBrowseTime()
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s admRecDepCount=$l(admRecDep, "^")
	f i=1:1:admRecDepCount 
	{
		s locInfo = $p(admRecDep, "^", i)
		q:(locInfo = "")
		s locID = $p(locInfo, "||", 1)
		continue:(locID = "")
		s tmpordDate = $p(locInfo, "||", 2)
		continue:(tmpordDate = "")
		s tmpordTime = $p(locInfo, "||", 3)
		continue:(tmpordTime = "")
		s ^TempEMRAdmRecDep("EMR",locID,tmpordDate,tmpordTime,count) = locInfo
		s count = count + 1	
		
	}
	s ordDate = $o(^TempEMRAdmRecDep("EMR",argUserLoc,""),-1)
	q:(ordDate = "") result
	s ordTime = $o(^TempEMRAdmRecDep("EMR",argUserLoc,ordDate,""),-1)
	q:(ordTime = "") result
	s appointEndDateTime = ##class(EMRservice.Ajax.Appoint).GetEndDateTime(ordDate,ordTime,appointTime)
	q:(appointEndDateTime = "") result
	s ordEndDate = $p(appointEndDateTime, ",", 1)
	s ordEndTime = $p(appointEndDateTime, ",", 2)
	b
	///授权截止日期小于当前日期,授权已过期
	q:(ordEndDate < date) result
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(ordEndDate = date)&&(ordEndTime < time) result
	s result = "1"
	k ^TempEMRAdmRecDep("EMR")
	q result
}

/// Desc:		根据就诊号取检查检验病理医嘱接收科室
/// Input:		InputAdm 就诊ID
/// OutPut: 	科室ID，以"^"分隔
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetAdmRecDep(76)
ClassMethod GetAdmRecDep(InputAdm)
{
  
    s returnstr=""
	q:InputAdm="" ""
 	s ordId=0 f  s ordId=$o(^OEORD(0,"Adm",InputAdm,ordId)) q:ordId=""  d
 	.s ordSub=0 f  s ordSub=$o(^OEORD(ordId,"I",ordSub)) q:ordSub=""  d
 	..s ordStatus=$p($G(^OEORD(ordId,"I",ordSub,1)),"^",13)   ;医嘱状态
 	..q:ordStatus=""
 	..q:(ordStatus'=1)&&(ordStatus'=6)   ;核实  执行
 	..s ordStatusDesc=$p($G(^OEC("OSTAT",ordStatus)),"^",2)
 	..s arcimDr=$p($G(^OEORD(ordId,"I",ordSub,1)),"^",2)   ;医嘱项
 	..q:arcimDr=""
 	..s arcimSub=$p($G(arcimDr),"||",2)
 	..s itemCatDr=$p($G(^ARCIM(+arcimDr,arcimSub,1)),"^",10)   ;医嘱子类
 	..q:itemCatDr=""
 	..s ordCatDr=$p($G(^ARC("IC",itemCatDr)),"^",8)
 	..//q:(ordCatDr'=8)&&(ordCatDr'=9)   ;检查  检验
    
    ..//得到检验医嘱类型
	..s OrderType=$P(^ARC("IC",ordCatDr),"^",7)
	..//得到检查医嘱标识
	..s ServerMaterial=$p($g(^ARCIM(+arcimDr,arcimSub,7)),"^",6)
    ..//过滤非检验检查医嘱
	..q:(ServerMaterial'="Service")&&(ServerMaterial'="S")&&(OrderType'= "L")
    
 	..s recDep=$p($G(^OEORD(ordId,"I",ordSub,3)),"^",6)  ;接收科室
	..q:recDep=""
	..s stdate=$p($G(^OEORD(ordId,"I",ordSub,1)),"^",9)
	..s sttime=$p($G(^OEORD(ordId,"I",ordSub,1)),"^",10)
	..s ordstr=recDep_"||"_stdate_"||"_sttime
	..i returnstr'="" s returnstr=returnstr_"^"_ordstr
	..e  s returnstr=ordstr
	q returnstr
}

/// Creator：      
/// CreatDate：    2017-07-21
/// Description:   获取授权权限规则
/// Table：        
/// Input：        userid
/// Output：      医护人员类型code
/// Return：      
/// Others
/// Debug:w ##Class(EMRservice.BOPrivAssist).GetCTCPT(4133)
ClassMethod GetCTCPT(userid As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	q:(userid="") ""
	s SSUSRCTPCP=$p($g(^SSU("SSUSR",userid)),"^",14)
	q:(SSUSRCTPCP="") ""
	s CarPrvTp=$p($g(^CTPCP(SSUSRCTPCP,1)),"^",4)
	q CarPrvTp
}

/// Desc:	判断是否会诊医生 		
/// 		w ##class(EMRservice.BOPrivAssist).IscoustUser("2178",1796,425,"3ptz6TRf00")	
ClassMethod IscoustUser(AdmID As %String, UserID As %String)
{
	q:((AdmID="")||(UserID="")) 0
	s ret =0
	Set retconst = ##Class(%ResultSet).%New("web.DHCEMConsInterface:QryPatConsList")
	Set sc = retconst.Execute(AdmID)
	While (retconst.Next()) 
	{
		continue:(retconst.Opinion="")
		s CsUserid=retconst.CsUserID
		if (CsUserid=UserID)
		{
			s ret =1
			q
		}
	}
	q ret
}

/// Creator：      
/// CreatDate：    2018-7-9
/// Description:   京东方  患者是否有传染病未上报(未上报不能书写病历)
/// Input：        argEpisodeID
/// Output：       1是, 0否(已上报或无传染病需要上报)     
/// Debug:         w ##Class(EMRservice.BOPrivAssist).IsEpdReport(7053)
ClassMethod IsEpdReport(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	s status = ##class(DHCMed.EPDService.Service).CheckEPDRepToHis(argEpisodeID)
	s:(status = "1") result = 1
	q result
}

/// Desc:		根据就诊号和科室ID取会诊科室以及会诊时间
/// Input:		Adm 就诊ID      LocId 科室ID
/// OutPut: 	科室^日期^时间，多次会诊以"@@"分隔
///             参考护理组提供方法   ##class(web.DHCConsult).GetConsultDateTime(10313803,99)
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetConsultDateTime(10313803,99)
ClassMethod GetConsultDateTime(AdmId, LocId) As %String
{
	q:AdmId=""
	s Data=""
	s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_AdmId,id)) q:id=""  d
    .s a=^User.DHCConsultationD(id) 
    .s appdep=$listget(a,4)     					//请会诊科室
    .//q:(LocId'=appdep)
	.s appdate=$listget(a,3)   						//申请会诊日期
    .s apptime=$listget(a,6)   						//申请会诊时间
    .s conlocid=$listget(a,11)  					//会诊科室id  
	.s conloc=$p(^CTLOC(conlocid),"^",2)  			//会诊科室	
	.i Data="" s Data=conlocid_"^"_appdate_"^"_apptime
	.e  s Data=Data_"@@"_conlocid_"^"_appdate_"^"_apptime
	q Data
}

/// Desc:		当前科室是否为会诊科室
/// Creator: 	yan
/// CreateDate:	2018-7-26
/// Input:		argEpisodeID 就诊号     argUserLoc 登陆科室ID    
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsAdmConsultDep(76,445)
ClassMethod IsAdmConsultDep(argEpisodeID As %String, argUserLoc As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argUserLoc = "") result
	
	s admConsultDep = ##Class(web.DHCEMConsInterface).GetPatConsultList(argEpisodeID)
	q:(admConsultDep = "") result
	
	s UserLocDesc = $P(^CTLOC(argUserLoc),"^",2)
	s Length = $L(admConsultDep,"@")
	For i = 1:1:Length
	{
		s LocDesc = $P($P(admConsultDep,"@",i),"^",1)
		s:(LocDesc=UserLocDesc) result = 1
		q:(result=1)
	}
	
	q result
}

/// Desc:		根据就诊号和用户ID判断登陆者是否主刀医师（根据手麻接口反正值第四个为主刀医师，以#分隔）
/// Input:		Adm 就诊ID
/// OutPut: 	主刀医师ID       
/// Debug:      w ##Class(EMRservice.BOPrivAssist).isAdmOperInfoForEMR(10313803)
ClassMethod IsAdmOperInfoForEMR(AdmId, UserID As %String) As %String
{
	s isoperInfo="0"
	q:(AdmId="") isoperInfo
	s strUserID = ""
	s isExist =##Class(EMRservice.BOPrivAssist).IsExistMethod("web.DHCANAdaptor","GetANOperation")
	if (isExist="1")
	{
		set stream = ##class(web.DHCANAdaptor).GetANOperation("","",AdmId,"","","","")
		Set reader = ##class(%XML.Reader).%New()
		Set sc=reader.OpenStream(stream)
		quit:($$$ISERR(sc)) ""
		//每个PatInfo节点的信息对应一个web.DHCANInterface类
		Do reader.Correlate("PatInfo","web.DHCANInterface")
		While reader.Next(.operObj,.sc) 
		{
			s OPAStatus = operObj.OPAStatus
			continue:(OPAStatus="撤销")
			
			s ANAOPSurgeonDR = operObj.ANAOPSurgeonDR
			s:(strUserID'="") strUserID = strUserID_"#"
			s strUserID = strUserID_ANAOPSurgeonDR
		}
		
		if (strUserID [ UserID)
	    {
		    s isoperInfo = "1"
	    }
    }
    
	q isoperInfo
}

/// Desc:		护士确认病历是否完成
/// Input:		Adm 就诊ID
/// OutPut: 	完成标示：0：未完成；1：完成      
/// Debug:      w ##Class(EMRservice.BOPrivAssist).isFinalNurseFlag(10313803)
ClassMethod IsFinalNurseFlag(AdmId) As %String
{
	s isFinalFlag="0"
	q:(AdmId="") isFinalFlag
	s isExist =##Class(EMRservice.BOPrivAssist).IsExistMethod("DHCEPRFS.BI.BIAdmMRStatus","GetFinalAccountFlag")
	if (isExist="1")
	{
		s isFinalFlag =##Class(DHCEPRFS.BI.BIAdmMRStatus).GetFinalAccountFlag(AdmId)
    }
	q isFinalFlag
}

/// Desc:		判断外部接口方法是否存在
/// Input:		aClassName 类名，aMethodName 方法名
/// OutPut: 	0：不存在；1：存在      
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsExistMethod("","")
ClassMethod IsExistMethod(aClassName As %String, aMethodName As %String) As %String
{
	s strRes = "0"
	q:(##class(%Dictionary.CompiledClass).%ExistsId(aClassName) = "0") strRes
	q:(##class(%Dictionary.CompiledMethod).%ExistsId(aClassName_"||"_aMethodName) = "0") strRes
	q 1
}

/// 是否当前用户为患者历次就诊中门诊就诊的接诊医师
/// lifb
/// 20190118
/// 通过判定当前用户是否为患者所有就诊中，门诊就诊接诊医生。
/// ##Class(EMRservice.BOPrivAssist).IsOPVisitDoctor(217,863,4634)
ClassMethod IsOPVisitDoctor(argPatientID As %String, argEpisodeID As %String, argUserID As %String)
{
	s ret=0
	q:(argPatientID="") ret
	//
	//s admtype = $p(^PAADM(argEpisodeID),"^",2)
	//q:(admtype'="O")
	
	s episodeID=""
	for
	{
		s episodeID = $o(^PAPERdr(argPatientID,"ADM","O",episodeID))
		q:(episodeID="")
		
		s doctorDR = $p(^PAADM(episodeID),"^",9)
		s VisitDoctorUserID = $o(^SSU("SSUSR",0,"CTPCP",doctorDR,""))
		s:(argUserID=VisitDoctorUserID) ret =1
		
	}
	
	q ret
}

/// Desc:      门诊病历历史就诊界面，要引用的病历所属就诊，与当前时间间隔，时间单位为小时
/// Creator:   
/// CreatDate: 2019-3-27
/// Input:     argInstanceID:注意此实例ID为要引用的病历实例ID，非当前正在书写的病历实例ID
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##Class(EMRservice.BOPrivAssist).GetOpHistoryAdmTimeGap("1465||45")
ClassMethod GetOpHistoryAdmTimeGap(argInstanceID As %String) As %Integer
{
	s result = 0
	q:(argInstanceID = "") result	
	s InstanceObj = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(InstanceObj = "") result
	s EpisodeID = InstanceObj.RealEpisodeID
	q:(EpisodeID = "") result
	
	s result = ..GetAdmTimeGap(EpisodeID)
	q result
}

/// Desc:      门诊病历历史就诊界面，要引用的病历模板版本是否为当前最新版本
/// Creator:   
/// CreatDate: 2019-3-27
/// Input:     argInstanceID:注意此实例ID为要引用的病历实例ID，非当前正在书写的病历实例ID
/// Output:    1是，0否
/// Debug:     w ##Class(EMRservice.BOPrivAssist).IsLatestVersion("1465||45")
ClassMethod IsLatestVersion(argInstanceID As %String) As %String
{
	s result = 0
	q:(argInstanceID = "") result	
	s InstanceObj = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(InstanceObj = "") result
	s TemplateVersion = InstanceObj.TemplateVersion
	q:(TemplateVersion = "") result
	
	s TemplateID = InstanceObj.RealTemplateID
	q:(TemplateID = "") result
	s TemplateObj = ##class(EMRmeta.Template).%OpenId(TemplateID)
	q:(TemplateObj = "") result
	s PublishVersion = TemplateObj.PublishVersion
	s:(PublishVersion = TemplateVersion) result = 1
	q result
}

/// Desc:      门诊历史病历，要引用的病历是否为当前就诊类型
/// Creator:   Lina
/// CreatDate: 2020-3-20
/// Input:     argEpisodeID:当前就诊号
///            argInstanceID:注意此实例ID为要引用的病历实例ID，非当前正在书写的病历实例ID
/// Output:    1是,0否
/// Debug:     w ##Class(EMRservice.BOPrivAssist).IsBelongToCurrentAdmType("5","1465||45")
ClassMethod IsBelongToCurrentAdmType(argEpisodeID As %String, argInstanceID As %String) As %String
{
    s result = 0
    q:(argEpisodeID = "")||(argInstanceID = "") result
    s InstanceObj = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
    q:(InstanceObj = "") result
    s admType = $p($g(^PAADM(InstanceObj.RealEpisodeID)),"^",2)
    s currentAdmType = $p($g(^PAADM(argEpisodeID)),"^",2)
    s:(admType = currentAdmType) result = 1
    q result
}

/// Desc:		当前模板是否可以创建
/// Creator: 	Lina
/// CreateDate:	2019-4-10
/// Input:		argEpisodeID 就诊号     argDocID 目录展现结构ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).CanCreateByFisrtRecord(4,68)
ClassMethod CanCreateByFisrtRecord(argEpisodeID As %String, argDocID As %String) As %String
{
	s ret = 1
	q:(argEpisodeID = "")||(argDocID = "") ret
	//s recordConfig = "FirstDocID^68!DocID^88|FirstDocID^68!DocID^66"
	s recordConfig = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("RecordCreationConfig","")
	q:(recordConfig = "") ret
	s count = $l(recordConfig,"|")
	for i=1:1:count
	{
		s recordName = "",recordData = ""
		s recordList = ##class(EMRservice.BL.BLPrivRule).ParseEnvInfo($p(recordConfig,"|",i),.recordName,.recordData)
		s fisrtDocid = $lg(recordData,$lf(recordName,"FirstDocID"))
		s docid = $lg(recordData,$lf(recordName,"DocID"))
		continue:(argDocID '= docid)
		s tmpresult = ##Class(EMRservice.BL.BLInstanceData).IsHasInstance(argEpisodeID,"",fisrtDocid)
		s:("0" = tmpresult) ret = 0
		q:("0" = ret)
	}
	q ret
}

/// Desc:		判断是否触犯质控中的创建标准
/// Creator: 	Donglulu
/// CreateDate:	2019-9-23
/// Input:		argEpisodeID 就诊号     argTemplateID 模板ID  argTitle 模板标题
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetCreateDocQualityList(4,68,1)
ClassMethod GetCreateDocQualityList(argEpisodeID As %String, argTemplateID As %String, argTitle As %String) As %String
{
	s ret = "1"
	s ret = ##Class(EPRservice.Quality.Interface.CreateDocQuality).GetCreateDocQualityList(argEpisodeID,argTemplateID,argTitle)
	q:($p(ret,"^",1) = 1) ret
	s ret = "0|"_$p(ret,"^",2)
	q ret
}

/// Desc: 	病人最新一次就诊是否属于某科室(RecentAdmBelongToLoc)
/// Modify: Donglulu
/// Input: 	argPatientID 患者号
/// 			argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).IsPatRecentAdmBelongToLoc(32,4)
ClassMethod IsPatRecentAdmBelongToLoc(argPatientID As %String, argLocID As %String) As %String
{
	q:((argPatientID = "")||(argLocID = "")) "0"
	s type = ""
	s result = "0"
	for
	{
		s type = $o(^PAPERdr(argPatientID,"ADM",type))
		q:(type = "")
		s episodeID = ""
		for
		{
			s episodeID = $o(^PAPERdr(argPatientID,"ADM",type,episodeID))
			q:(episodeID = "")	
			
			s result = ##Class(EMRservice.BOPrivAssist).IsPatBelongToLoc(episodeID,argLocID)
			q:(result = "1")
		}
		q:(result = "1")
	}
	q result
}

/// Desc: 	患者手工质控条目是否完成（GetMessageFlagByEpisodeID）
/// Modify: Donglulu
/// Input: 	argEpisodeID 就诊号
/// OutPut: 1完成,0未完成
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).GetMessageFlagByEpisodeID(32)
ClassMethod GetMessageFlagByEpisodeID(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "") result
	
	q:(##class(%Dictionary.CompiledClass).%ExistsId("EPRservice.Quality.DataAccess.BOQualityMessage") = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("EPRservice.Quality.DataAccess.BOQualityMessage||GetMessageFlagByEpisodeIDGY") = "0") result
	//0:无消息  -1:有未处理的消息  1:消息全部处理
	s ret = ##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetMessageFlagByEpisodeIDGY(argEpisodeID)
	s:(ret '= "-1") result = "1"
	q result
}

/// Desc:		取病历创建者
/// Creator:	董璐璐
/// CreateDate: 2019-10-25
/// Input:		argInstanceID 病历ID
/// OutPut: 	病历创建者userid
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetRecCreator("1||1")
ClassMethod GetRecCreator(argInstanceID As %String) As %String
{
	s result = ""
	q:(argInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s result = objInstance.CreateUser
	q result
}

/// Creator:	病历是否本人创建
/// CreateDate: 2019-10-25
/// Input:		argInstanceID 病历ID
/// OutPut: 	病历创建者userid
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetIsCreator("1470||1","6")
ClassMethod GetIsCreator(argInstanceID As %String, argUserID As %String) As %String
{
	s result = ""
	q:(argInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	if (argUserID = objInstance.CreateUser)
	{
		s result = "1"
	}
	q result
}

/// Desc:		登录用户是否为病历的签名医师
/// Creator:	董璐璐
/// CreateDate: 2019-10-25
/// Input:		argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1 是  0 不是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecSignUser("1||1",105)
ClassMethod IsRecSignUser(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "1"
	q:(argInstanceID = "")||(argUserID = "") result
	
	s signID = ""
	for
	{
		s signID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_argInstanceID,signID))
		q:(signID = "")
		
		s objSign = ##Class(EMRinstance.EMRSign).%OpenId(signID)
		q:(objSign = "")
		if (argUserID '= objSign.UsrID)
		{
			s result = "0"
			q
		}
	}
	q result
}

/// Desc:       是否为创建者的上级医师（取his的维护程序,安医附院，不分医疗组）
/// Creaotr:    董璐璐
/// CreateDate: 2019-10-30
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCreatorUpUserByHISAY("1||1",105)
ClassMethod IsCreatorUpUserByHISAY(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s creatorId = objInstance.CreateUser
	s creatorPvId = $p($g(^SSU("SSUSR",creatorId)),"^",14)
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(creatorPvId = "")||(userPvId = "") result
	s creatorLevel = ##class(EMRservice.BL.BLPowerUser).GetHisUserLevel(creatorPvId)
	s userLevel = ##class(EMRservice.BL.BLPowerUser).GetHisUserLevel(userPvId)
	if ((creatorLevel = "主任医师")||(creatorLevel = "副主任医师"))
	{
		q result	
	}
	elseif (creatorLevel = "主治医师")
	{
		s:((userLevel = "主任医师")||(userLevel = "副主任医师")) result = 1
	}
	elseif ((creatorLevel = "住院医师")||(creatorLevel = "医师"))
	{
		s:((userLevel = "主任医师")||(userLevel = "副主任医师")||(userLevel = "主治医师")) result = 1
	}
	q result
}

/// Desc:      返回当前病历，当前医生门诊自动审批次数
/// Creator:   yan
/// CreatDate: 2019-10-23
/// Input:     argInstanceID 实例ID,argUserID 用户ID
/// Output:    0/1/2/3...
/// Debug:     w ##Class(EMRservice.BOPrivAssist).GetAutoApplyCount("235||4","10209")
/// 
ClassMethod GetAutoApplyCount(argInstanceID As %String, argUserID As %String) As %String
{
	s result = 0
	q:((argInstanceID = "")||(argUserID = "")) result
	
	s result = ##Class(EMRservice.BL.BLApplyEdit).GetApplyCount(argInstanceID,argUserID)
	q result
}

/// Desc:      返回当前病历，当前医生门诊自动审批次数
/// Creator:   
/// CreatDate: 2020-01-06
/// Input:     AUserLocID 当前登录科室ID, ASelEpisodeID 选中数据就诊号
/// Output:    0/1
/// Debug:     w ##Class(EMRservice.BOPrivAssist).IsSameUserLocTypeWithSelEpisode(95,8)
/// 说明：	1.初始化浏览权限 view=0
/// 			2.通过此函数设定如果返回值是0，view=0
/// 			3.初始化 关联科室、关联病区，view=1，将2中的误判情况进行修正（当前门诊科室就行viw=0，修正）
/// 
ClassMethod IsSameUserLocTypeWithSelEpisode(AUserLocID As %String, ASelEpisodeID As %String) As %String
{
	s result = "1"
	
	q:((AUserLocID="")||(ASelEpisodeID="")) result
	
	s userLocType="I"
	
	s UserLocName= $p($g(^CTLOC(AUserLocID)),"^",2)
	q:(UserLocName="") result
	
	//判定用户登录科室的类型 ：科室名包含关键词“门诊”：O
	if UserLocName ["门诊"
	{
		s userLocType = "O"
	}
	s selAdmType = $p($g(^PAADM(ASelEpisodeID)),"^",2)
	q:(selAdmType="") result
	
	/*
	//门诊患者病历，住院医生有权限看
	s:((selAdmType= "O")&&(userLocType="I")) result=0
	//门诊患者病历，门诊医生有无权限直接可见
	s:((selAdmType= "O")&&(userLocType="O")) result=1
	
	//住院患者病历，门诊登录医生可见
	s:((selAdmType= "I")&&(userLocType="O")) result=0
	//住院患者病历，住院科室登录医生无权限直接可见
	s:((selAdmType= "I")&&(userLocType="I")) result=1
	*/
	q:(selAdmType= userLocType) result
	
	s:(selAdmType'= userLocType) result=0
	
	q result
}

///  Desc:		获取打印日志，安全组数据
///  Creator: 	Lifengbo
///  CreateTime: 2020-01-15
///  input:		AEpisodeID 就诊号
///  			AInstanceID 
///  			AAction(需要判断的病历操作)
///  return:		"^id^id^id^id^id^"
///  debug: 		w ##class(EMRservice.BOPrivAssist).GetActionOperUserSSGroupID(76,"1||1","print")
/// 
ClassMethod GetActionOperUserSSGroupID(AEpisodeID As %String, AInstanceID As %String, AAction As %String) As %String
{
	
	s $zt="errhandle"
	s result = ""
	q:(AEpisodeID = "")||(AInstanceID = "")||(AAction = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s EMRLogsId = $o(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo,""))
	q:(EMRLogsId = "") result
	s tmpDate="",resultList=""
	for
	{
		s tmpDate =$o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(AAction,"U"),tmpDate))
		q:(tmpDate="")
		
		s tmpTime=""
		for
		{
			s tmpTime =$o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(AAction,"U"),tmpDate,tmpTime))
			q:(tmpTime="")
			
			s instanceLogNum=""
			for
			{
				s instanceLogNum =$o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(AAction,"U"),tmpDate,tmpTime,instanceLogNum))
				q:(instanceLogNum="")
				
				s instanceLogID = EMRLogsId_"||"_instanceLogNum
				s objInstanceLog = ##class(EMRinstance.InstanceLog).%OpenId(instanceLogID)
				continue:(objInstanceLog="")
				
				s operUserID = objInstanceLog.RRealOperateUserID
				
				if (operUserID '= "") 
				{
					continue:($lf(resultList,operUserID)'=0)
					
					s resultList = resultList_$lb($p($g(^SSU("SSUSR",operUserID)), "^",5))
				}
				
			}
		}
		
	}
	
	s result = "^"_$listtostring(resultList,"^")_"^"
    	q result
errhandle
	q ""
}

/// Desc:		病历是否封存(取病案管理提供的接口数据判断)
/// Creator:	niucaicai
/// CreateDate:	2019-08-16
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsRecordInstanceSealed("5","225||1")
ClassMethod IsRecordInstanceSealed(AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result = 0
	q:(AInstanceID = "")||(AEpisodeID = "") result
	if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.MO.SealRecordEpr||CheckByAdmInstance") = 1)
	{
		s Sealed = ##class(DHCWMR.MO.SealRecordEpr).CheckByAdmInstance(AEpisodeID,AInstanceID)
		s:(Sealed = 1) result = 1
	}
	q result
}

/// Desc:		病历是否与输血申请单关联
/// Creator:	donglulu
/// CreateDate:	2020-4-9
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsLinkBlood("289||1")
ClassMethod IsLinkBlood(argInstanceID As %String) As %String
{
	s result = 0
	q:(argInstanceID = "") result
	s rowid = $o(^DHCEMRI.LinkProductI("IdxInstanceID"," "_argInstanceID,""))
	s instance = ##class(EMRinstance.InstanceLinkProduct).%OpenId(rowid)
	q:(instance = "") result
	s fromType = instance.FromType
	s:(fromType = "BLOODTRANS") result = 1
	q result
}

/// Desc:		病历是否有住院及以上级别签名（EMRmeta.SignRole的RoleLevel大于0）
/// Creator:	donglulu
/// CreateDate:	2020-8-11
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).HasAboveResidentLevelSign("118||23")
ClassMethod HasAboveResidentLevelSign(argInstanceID As %String) As %String
{
	s result = 0
	q:(argInstanceID = "") result
	
	s rowID = ""
	for
	{
		s rowID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_$zcvt(argInstanceID,"U"),rowID))
		q:(rowID = "")
		s objSign = ##class(EMRinstance.EMRSign).%OpenId(rowID)
		continue:(objSign = "")
		continue:(objSign.isSignValid = "0")
		s action = objSign.Action
		continue:(action = "")
		
		s id = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(action,"U"),""))
		continue:(id = "")
		s roleObj = ##Class(EMRmeta.SignRole).%OpenId(id)
		continue:(roleObj = "")
		s level = roleObj.RoleLevel
		if (level > 0)
		{
			s result = 1
			q
		}
	}
	
	q result
}

/// Desc:       是否为创建者的上级医师（取his的维护程序，不分医疗组）
/// Creaotr:    Donglulu
/// CreateDate: 2020-11-2 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCreatorUpUserByHIS("1||1",105)
ClassMethod IsCreatorUpUserByHIS(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	q:(objInstance.Status = "UnSave") "1" 
	s creatorId = objInstance.CreateUser
    q:(creatorId = "") "1"   //创建者为空时应默认为创建者上级

	s createSignLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(creatorId)
	s createLevel = ##class(EMRservice.BL.BLSignRole).GetSignLevel($p(createSignLevel,"^",1))
	
	s userSignLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(argUserID)
	s userLevel = ##class(EMRservice.BL.BLSignRole).GetSignLevel($p(userSignLevel,"^",1))
	
	s:(userLevel>createLevel) result=1
	
	q result
}

/// Desc:       病历是否有有效的患者签名
/// CreateDate: 2020-11-11
/// Input:      argInstanceID 病历实例ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).HasValidAnySign("1||1")
ClassMethod HasValidAnySign(argInstanceID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "") result
	s signID=""
	for {
	    s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_argInstanceID, signID),-1)
	    q:(signID="")
	    s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
	    s:((sign.isSignValid="1")&&(sign.Type="AnySign")) result = "1"
	    q:(result = "1")
	}
	q result
}

/// Desc:		病历是否是提交状态
/// Creator:	donglulu
/// CreateDate:	2021-1-11
/// Input:		AEpisodeID 就诊号
/// OutPut: 	1是提交状态,0非提交状态（包括撤销、退回、未提交等）
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsRecordCompleted("")
ClassMethod IsRecordCompleted(AEpisodeID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "") result
	s ret = ##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(AEpisodeID)
	s:(ret = "1") result = "1" 
	q result
}

/// Desc:		转科患者，病历HappenDateTime时刻科室与当前登录科室是否一致。
/// Creator:	lifengbo
/// CreateDate:	2021-2-4
/// Input:		argInstanceID 病历实例ID;AUserLocID 当前登录科室
/// OutPut: 	1 一致,0不一致
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsLinkBlood("289||1")
ClassMethod IsSameLocInstanceWithUser(AInstanceID As %String, AUserLocID As %String) As %String
{
	s result=1
	
	s objInstance=##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance="") result
	q:(objInstance.Status'="Save") result
	
	s happenDate= objInstance.HappenDate
	s happenTime = objInstance.HappenTime
	s episodeId = objInstance.RealEpisodeID
	
	s InstanceFinishLocID = ..GetTransLocIDByDateTime(episodeId,happenDate,happenTime)
	
	s:((InstanceFinishLocID'="")&&(InstanceFinishLocID'=AUserLocID)) result=0

	q result
}

ClassMethod GetTransLocIDByDateTime(AEpisodeID As %String, ADate As %String, ATime As %String) As %String
{
	s result=""
	
	s TransLocInfo = ##class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(AEpisodeID,"")
	q:((TransLocInfo="")||(TransLocInfo="无")||(TransLocInfo="-")) result
	
	//创建转科相关的时间Global
	s repid=$i(^CacheTemp)
	k ^CacheTemp(repid,"EMRTrans")
	
	for i=1:1:$l(TransLocInfo,"->")
	{
		s tmpLocInfo = $p(TransLocInfo,"->",i)
		continue:((tmpLocInfo="-")||(tmpLocInfo=""))

		s transDate = $p(tmpLocInfo,"^",3)
		s transTime = $p(tmpLocInfo,"^",4)
		s transLocID = $p(tmpLocInfo,"^",1)
		
		s ^CacheTemp(repid,"EMRTrans",$zdh(transDate,3),$zth(transTime,1)) = transLocID
	
	}
	
	s TransDate = $o( ^CacheTemp(repid,"EMRTrans",(ADate+1)),-1)
	s TransDatePre = $o( ^CacheTemp(repid,"EMRTrans",ADate),-1)
	if TransDate = ADate
	{
		s TransTime = $o( ^CacheTemp(repid,"EMRTrans",TransDate,(ATime+1)),-1)
		if (TransTime="") 
		{
			s TransTime = $o( ^CacheTemp(repid,"EMRTrans",TransDatePre,""),-1)
			s TransDate = TransDatePre
		}
	}
	else
	{
		s TransTime = $o( ^CacheTemp(repid,"EMRTrans",TransDate,""),-1)
	}
	
	s result = $g(^CacheTemp(repid,"EMRTrans",TransDate,TransTime))
	k ^CacheTemp(repid,"EMRTrans")
	
	q result
}

/// Desc:		病历HappenDateTime时刻患者所在科室
/// Creator:	lifengbo
/// CreateDate:	2021-2-4
/// Input:		argInstanceID 病历实例ID;AUserLocID 当前登录科室
/// OutPut: 	"" 未找到实例； 非空 科室ID
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).GetLocIDAtInstanceFinish("289||1")
ClassMethod GetLocIDAtInstanceFinish(AInstanceID As %String) As %String
{
	s result=""
	
	s objInstance=##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance="") result
	q:(objInstance.Status'="Save") result
	s happenDate= objInstance.HappenDate
	s happenTime = objInstance.HappenTime
	s episodeId = objInstance.RealEpisodeID
	
	s InstanceFinishLocID = ..GetTransLocIDByDateTime(episodeId,happenDate,happenTime)
	
	//非转科患者，取当前科室ID
	s:(InstanceFinishLocID ="") InstanceFinishLocID=$p(##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeId,""),"^",1)

	s result = InstanceFinishLocID
	
	q result
}

/// Desc:		是否是就诊当天创建的病历
/// Creator:	lifengbo
/// CreateDate:	2022-08-01
/// Input:		AEpisodeID 就诊号 AInstanceID实例ID
/// OutPut: 	1是就诊当天创建的病历,0非就诊当天创建的病历
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsCrossDay("1296","369||1")
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsCrossDay("300","119||1")
ClassMethod IsCrossDay(AEpisodeID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AInstanceID = "")) result
	///就诊日期
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
	s admDate = +admDateTime
	q:(+admDate=0) result
	///实例创建日期
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance="") result
	
	s checkEpisodeID = objInstance.EpisodeID
	q:(checkEpisodeID'=AEpisodeID) result
	
	s createDate = objInstance.CreateDate
	s:(admDate=createDate) result = "1" 
	q result
}

/// Desc:       是否患者看过病历
/// Creator:    Candy
/// CreateDate: 2022-10-27
/// Input:      AInstanceID实例ID
/// Output:     1看过，0没看过
ClassMethod IsPatientBrowse(AInstanceID As %String) As %String
{
	q ##class(EMRservice.BL.BLHtmlDoc).GetBrowseLogs(AInstanceID)
}

/// desc：取退回病历函数
/// Debug:w ##Class(EMRservice.BOPrivAssist).GetGrantInstanceID(4133)
ClassMethod GetGrantInstanceID(AEpisodeID As %String, InstanceId As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	s result = "0"
	q:(AEpisodeID = "")||(InstanceId = "") result
	s Medicalinfo="",InstanceIdes=""
	s Medicalinfo =##class(EPRservice.Quality.SetDepDisFlag).GetGrantInstanceID(AEpisodeID)
	s InstanceIdes = Medicalinfo.ReadLine()
	if (InstanceIdes'="")
	{
		for i=1:1:$L(InstanceIdes,"^")
		{
			s:(InstanceId=$P(InstanceIdes,"^",i)) result=1
			q:(result=1)
		}
	}
	q result
}

/// Desc:    是否护士结算 取护士结算日期判定
/// Hospital：安医附院
/// InPut:   argEpisodeID 就诊日期
///          argType 出院日期类型 "ByDoctor"医生医疗结算，"ByNurse"护士最终结算
/// Output： result "" 没出院,YYYY-MM-DD出院日期格式
/// Debug: w ##Class(EMRservice.BOPrivAssist).ISDisNurse(2)
ClassMethod ISDisNurse(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "") result
	q:(($d(^PAADM(argEpisodeID)) '= 1)&&($d(^PAADM(argEpisodeID)) '= 11)) result
	s dischgdate = ""
	//护士最终结算
	s dischgdate = $P($G(^PAADM(argEpisodeID)),"^",17)
	s:(dischgdate '= "") result = "1"
	q result
}

/// Desc:		患者是否为新冠
/// Hospital：安医附院
/// Modify: 	Sun
/// Input: 		就诊号
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).CheckIsXGFluByAdm("76")
ClassMethod CheckIsXGFluByAdm(argEpisodeID As %String) As %String
{
	s result=0
	s status=0
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result 
	s status=##Class(DHCMed.EPDService.FluInterface).CheckIsXGFluByAdm(argEpisodeID)
	if (status'="")
	{
		s result=status
	}
	q result
}

/// Desc:         用户是否为病历的当前签名人
/// Hospital：安医附院
/// Createor:     ZHOU
/// CreateDate: 2017-04-01
/// Input:        argEpisodeID 就诊ID
///             argInstanceID 病历ID
///             argUserID 用户ID    
/// OutPut:     1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCreaterAndUpUser(41,"243||1",10209)
ClassMethod IsCreaterAndUpUser(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
    s result = "0",objstatus="",objSingID=""
    q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
    q:(objInstance = "") "0"
    s objstatus = objInstance.Status
    q:(objstatus = "Delete") result
    //打开最后一个签名的 表数据
    s argInstanceID=" "_argInstanceID
    s SingID="",SingIDtemp = ""
    f  s SingID=$o(^DHCEMRI.EMRSignI("IdxInstance",argInstanceID,SingID)) q:(SingID="")  d
    .  s SingIDtemp=SingID
    //当前签名的人可以更改病历
    s objSingInstance = ##Class(EMRinstance.EMRSign).%OpenId(SingIDtemp)
    q:(objSingInstance="") "1"
    s objSingID=objSingInstance.UsrID  //获取当前签名人的ID
    s objSingis=objSingInstance.isSignValid
    q:(objSingis=0) "1"
    q:((argUserID=objSingID)||(objSingis=0)) "1" //当前登陆用户 是当前签名者
    /*
    s docInfo = ##Class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(argUserID) //当前登陆用户的级别
    q:(docInfo = "") "0"
    s docLevel = $p($g(docInfo),"^",1)
    s docInfoSign = ##Class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(objSingID) //病历当前签名人的级别
    q:(docInfoSign = "") "0"
    s SignLevel = $p($g(docInfoSign),"^",1)
    //当前签名人的上级医师可以更改病历
    q:(SignLevel = "Resident")&&((docLevel = "Attending")||(docLevel = "Chief")) "1"
    q:(SignLevel = "Attending")&&((docLevel = "Chief")||(docLevel = "ViceChief")) "1"
    */
    q result
}

/// /////////////////////////////////////////////////////////////////////////////////////////////////////
/// Desc: 	病历浏览界面是否有权限查看门急诊患者病历，就诊24小时内或本科室医生可查看【根据最新一次就诊来判断】
/// 			所有就诊24小时内：患者属于当前科室可以随便看患者历次就诊
/// 			所有就诊中，判断该次就诊是否属于当前科室，属于可以看该次
/// Creaotr: YDG
/// CreateDate：2022-09-22
/// Input: 	argPatientID 患者号
/// 		argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).IsCanViewRecord(20,4)
ClassMethod IsCanViewRecord(argPatientID As %String, argLocID As %String, argEpisodeID As %String) As %String
{
	s $zt="ERROR"
	q:((argPatientID = "")||(argLocID = "")) "0"
	s type = ""
	s result = "0"
	s PatientType = $p($g(^PAADM(argEpisodeID)),"^",2) 
	q:(PatientType'="O")&&(PatientType'="E") 1		;只判断门急诊患者
	for
	{
		s type = $o(^PAPERdr(argPatientID,"ADM",type),-1)
		q:(type = "")
		s:(type="I") result= 1
		q:(result = "1")		;最新一次就诊类型为住院，不进行后续判断
		continue:(type'="O")&&(type'="E")	;只判断门急诊患者
		s episodeID = ""
		s episodeIDs = ""
		for
		{
			s episodeID = $o(^PAPERdr(argPatientID,"ADM",type,episodeID),-1)	;取最新一次就诊
			q:(episodeID = "")	
			set VisitStatus = $p($g(^PAADM(episodeID)),"^",20)
		 	continue:(VisitStatus = "C")		;过滤掉已退号的就诊信息 
		 	
		 	s:(episodeIDs'="") episodeIDs = episodeIDs_"^"_episodeID
		 	s:(episodeIDs="") episodeIDs = episodeID
		}
		for i=1:1:$l(episodeIDs,"^")
		{
			//判断所有就诊中就诊时间是否超过24小时【24小时内多次就诊，只要存在一次就诊属于本科室，允许浏览】
			s AdmTimeGap = ##Class(EMRservice.BOPrivAssist).GetAdmTimeGap($p(episodeIDs,"^",i))
			if (AdmTimeGap<=24)
			{
				//判断未超过24小时的就诊是否属于当前科室		 
				s IsBelongToLoc = ##Class(EMRservice.BOPrivAssist).IsPatBelongToLoc($p(episodeIDs,"^",i),argLocID)		
				s:(IsBelongToLoc=1) result=1
				q:(result = "1")
			}

			//判断该次就诊是否属于当前科室
			if ($p(episodeIDs,"^",i)=argEpisodeID)
			{
				s IsBelongToLoc = ##Class(EMRservice.BOPrivAssist).IsPatBelongToLoc($p(episodeIDs,"^",i),argLocID)		
				s:(IsBelongToLoc=1) result=1
				q:(result = "1")
			}

			
		}	
		q:(result = "1")
	}
	q result
ERROR
	q 1
}

/// Desc: 	判断登陆用户是否为实习医生
/// Modify: Sun
/// Input: 	argUserID 用户ID 
/// Output: groupname^username
/// Debug:  w ##Class(EMRservice.BOPrivAssist).IsPractice(25286)
ClassMethod IsPractice(argUserID As %String) As %String [ WebMethod ]
{
	s result="0"
	q:(($d(argUserID)=0)||(argUserID="")) result
	s ctcaredr=""
	s ctcaredr=$p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(ctcaredr="") result
	s userleveldr=""
	s userleveldr=$p($g(^CTPCP(ctcaredr,1)),"^",4)
	q:(userleveldr) result
	s userlevel=""
	s userlevel=$p($g(^CT("CPT",userleveldr)),"^",1)
	s:userlevel="PRACTICE" result="1"
	q result
}

/// Desc:       判断是转科前科室
/// Creator:　  Sun
/// CreateDate: 2021-09-25
/// Input:      Adm:就诊号
/// Output:     result 1:时，2：不是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).HasValidSign("1||1")
ClassMethod IsTransPreDept(Adm As %String, locid As %String) As %String
{
	s result = "0"  
	q:(Adm = "")||(locid="") result
	s TranDesc="",LocDesc=""
	s LocDesc=$P($G(^CTLOC(locid)),"^",2)
    s TransLocs=##class(EMRservice.HISInterface.PatientInfoAssist).TransDept(Adm)
    s count=$l(TransLocs,"->")
    s PreLocDesc=$p($g(TransLocs),"->",count-1)
    s:(PreLocDesc=LocDesc) result=1
	q result
}

/// Desc:       判断docid的文件夹目录id是否未知情告知
/// Creator:　  sunjinbo
/// CreateDate: 2021-09-25
/// Input:      Adm:就诊号
/// Output:     result 1:时，2：不是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsZQRecordCategory(461)
ClassMethod IsZQRecordCategory(docid As %String) As %String
{
	s result = "0"  
	q:(docid="") result
	s cateid=""
	s cateid=$listget($g(^DHCEMRM.EMRTemplateCategoryD(docid)),4)	
    q:(cateid="") result
    s ParentID=$listget($g(^DHCEMRM.EMRTemplateCategoryD(cateid)),4)
    q:(ParentID="") result
    s:(ParentID="6") result="1"
	q result
}

/// Desc         门诊病历取患者最新一次就诊的当前时间减去就诊时间是否大于24小时
/// Creator      sunjinbo
/// CreatorDate  2021-10-18  
/// return       1:是,2:否
/// w ##Class(EMRservice.BOPrivAssist).GetAdmOutStatus(20035222)
ClassMethod GetAdmOutStatus(Adm As %String) As %String
{
	s result = "0"
	q:(Adm="") result
	s num = 0,PAADMRowID=""
	s PapmiDR=""
	s PapmiDR=$p($g(^PAADM(Adm)),"^",1)
	q:(PapmiDR="") result
	s PAADMType=""
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	q:(PAADMType'="O") result
	for
	{
	  s PAADMRowID = $O(^PAPERdr(PapmiDR,"ADM","O",PAADMRowID),-1)
	  q:(PAADMRowID="")
	  //过滤状态为取消的病人
	  s VisitStatus= $P($g(^PAADM(PAADMRowID)),"^",20)
	  continue:(VisitStatus="C")
	  s num=num+1
	  q:(num="1")
	}
	s hours=""
	s hours=##Class(EMRservice.BOPrivAssist).GetAdmTimeGap(PAADMRowID)
	s:(hours>24) result="1"
	///如果该患者的历次就诊存在住院状态则放开权限
	s PatientStatus=""
	s PatientStatus=##class(EMRservice.BOPrivAssist).IsPatientDischarge(PapmiDR)
	q:(PatientStatus="0") result
	q result
}

/// Desc:		是否出院超过N小时（节假日期间不计入）
/// Creator: 	QiYH
/// CreateDate:	2021-01-22
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsDischargedNWordHours(29585555,72)
ClassMethod IsDischargedNWordHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	Q:(argEpisodeID="")||(argHours="") result
	q:($p($g(^PAADM(argEpisodeID)),"^",2)="E") result
	s dischDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
	
	q:(dischDateTime = "") result
	//s disDate = $p(dischDateTime,",",1)
	s disDate = $P($G(^PAADM(argEpisodeID)),"^",17)
	//s disTime = $p(dischDateTime,",",2)
	s disTime = $P($G(^PAADM(argEpisodeID)),"^",18)
	q:(disDate="")||(disTime="") result
	s HolidFlag =0,Holidaydays=0,Holiddays=0
	s HolidayDateFlags=##class(web.DHCBL.CT.BDPHoliday).GetHolidayDateFlags($zd(disDate,3),$zd($p($h,",",1),3),"")
	s Holidaydays = $l(HolidayDateFlags,"2")-1
	s Holiddays = $l(HolidayDateFlags,"1")-1
	s HolidFlag = (Holidaydays+Holiddays)*24
	
	q:(disDate = "")||(disTime = "") result
	s currDate = +$h
	s currTime = $p($h,",",2)
	s cDay = 0
	s cSecond = 0
	s cDay = currDate - disDate
	s cSecond = (currTime - disTime)\3600
	s retd = cDay*24+cSecond-HolidFlag
	s:(retd > argHours) result = "1"
	q result
}

/// ##Class(EMRservice.BOPrivAssist).TransApprovePass(9600004)
ClassMethod TransApprovePass(Adm As %String) As %String
{
	s result = 0,tempresult=""
	q:(Adm = "") result
	s tempresult = ##class(web.DHCDocTransHosp).TransApprovePassByAdm(Adm)
	s:(tempresult'="") tempresult = $p(tempresult,"^",1)
	s:(tempresult=0) result =1
	q result
}

/// 急诊病人是否离开了48小时
ClassMethod EPLeaveOver48Hours(AEPisodeID As %String, AHours As %String = "48")
{
  s ret = 0
  q:(AEPisodeID="") ret
  s type = $P($G(^PAADM(AEPisodeID)),"^",2)
  q:(type'="E") ret
  s EPInfo = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEPisodeID,"HDSD00.03.02")
  s LeaveDateTime = EPInfo.GetAt("HDSD00.03.070")
  q:(LeaveDateTime="") ret
  s currDate = +$h
  s currTime = $p($h,",",2)
  s LeaveDate = $ZDH($P(LeaveDateTime," ",1),3)
  s LeaveTime = $ZTH($P(LeaveDateTime," ",2))
  s cDay = currDate - LeaveDate
  s cSecond = (currTime - LeaveDate)\3600
  s retd = cDay*24+cSecond
  if (retd>48) {
     s ret = 1
  }
  q ret
}

/// 当前登录用户是否已经创建了门诊病历
ClassMethod IsCreateOPRecordByUser(Adm As %String, UserId As %String, ADocID As %String = "319")
{
	s ret = 0
	q:(Adm="")||(UserId="")||(ADocID="") ret
	s ID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_Adm," "_ADocID,""))
	q:(ID="") ret
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ID)
	q:(objECRecord="") ret
	S key = ""
	s key = objECRecord.Instances.Count()+1	
	do {
		s objInstanceData = objECRecord.Instances.GetPrevious(.key)
		continue:(objInstanceData ="")
		continue:(objInstanceData.Status'="Save")
		s CreateUserID = objInstanceData.CreateUser
		continue:(CreateUserID'=UserId)
		s ret=1
		q:(ret=1)
	}while(key'="")
	q ret
}

/// Desc:       是否死亡患者
/// Creator:　  
/// CreateDate: 2016-5-17
/// Input:      argUserID 用户ID
///             argInstanceID 病历号
/// Output:     result 0 否 ， 1 是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsPatDeath(2543)
ClassMethod IsPatDeath(argAdmID As %String) As %String
{
	
	s result = "0"
	q:(argAdmID = "") result
	
	s PapmiDR = ""
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argAdmID)
	q:(PapmiDR="") result
	s DeathDateTime=""
	s DeathDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(argAdmID,PapmiDR,"")
	q:(DeathDateTime="") result
	
	s:(DeathDateTime '="") result = "1"
	q result
}

/// 取病历创建者和创建日期时间
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetEMRCreatInfo("","4||1","")
ClassMethod GetEMRCreatInfo(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = ""
	;q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") result
	q:(argInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") ""
	s CreateUser =objInstance.CreateUser
	s:CreateUser'="" CreateUser=$p(^SSU("SSUSR",CreateUser),"^",2)
	s CreateDate =$ZD(objInstance.CreateDate,3)
	s CreateTime =$ZT(objInstance.CreateTime)
	q CreateUser_"^"_CreateDate_"^"_CreateTime
}

/// 返回模板的前两级目录ID
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetTemplate2ParentID()
ClassMethod GetTemplate2ParentID(templateid As %String) As %String
{
	s TemplateParentID=""
	q:(templateid="") ""
	s tmpl = ##class(EMRmeta.Template).%OpenId(templateid)
	q:(tmpl="") ""	
	s emrTmplCategory=##class(EMRmeta.TemplateCategory).%OpenId(tmpl.TemplateCategoryID)
	s:emrTmplCategory'="" TemplateParentID=emrTmplCategory.ParentID
	q TemplateParentID
}

/// Desc: 		是否急诊病人, 用于急诊医生权限（不包含门诊诊患者）
/// Input：		argPatEpisodeID：病人就诊rowid
/// Output：	0：不是急诊病人，1：急诊病人
/// CreateUser：HouJ， suggested by XueFL for HuaXiYiYuan
/// CreateTime：2009-08-03 广西医大新增 2019-12-23
/// w ##class(EMRservice.BOPrivAssist).IsEmerPatient("25496307")
ClassMethod IsEmerPatient(argPatEpisodeID As %String) As %String
{
	s RetType = ""
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s RetType = $case(PatientType="E",1:1,:0)
	q RetType
}

/// Desc: 		是否门诊病人, 用于门诊医生权限（不包含急诊患者）
/// Input：		argPatEpisodeID：病人就诊rowid
/// Output：	0：不是门诊病人，1：门诊病人
/// CreateUser：HouJ， suggested by XueFL for HuaXiYiYuan
/// CreateTime：2009-08-03 广西医大新增 2019-12-23
/// w ##class(EMRservice.BOPrivAssist).IsOutPatientReal("25496307")
ClassMethod IsOutPatientReal(argPatEpisodeID As %String) As %String
{
	s RetType = ""
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s RetType = $case(PatientType="O",1:1,:0)
	q RetType
}

/// /病历是否是本人CA的签名，针对急诊科修改
/// w ##class(EMRservice.BOPrivAssist).ISCurUserSign("148656||3")
ClassMethod ISCurUserSign(argInstanceID As %String) As %String
{
	s result = "1"
	q:(argInstanceID = "") "1"
	s curUserID=%session.Get("LOGON.USERID")

	///病历未保存，则全部人都可以修改
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	s Status=objInstance.Status
	q:(Status'="Save") "1"

	s signID=""
	for {
	    s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_argInstanceID, signID),-1)
	    q:(signID="")
	    s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
	    ;continue:(sign.isSignValid="0")
	    s UsrID=sign.UsrID
	    ///病历签名之后只能签名用户能修改
	    s:(sign.isSignValid="1")&(UsrID'=curUserID) result=0
	    ///病历撤销签名之后所有用户能修改
	    s:(sign.isSignValid="0") result=1
	    
	}
	q result
}

/// Desc:	用户是否为指定患者主管医生的上级医生(取护士分床界面的二线、三线医师)
/// Modify: Candy
/// Input 	argPatEpisodeID 就诊号
/// 			argDocID 用户ID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsPatBelongSubDocsNew(25904782,13,447)
ClassMethod IsPatBelongSubDocsNew(argPatEpisodeID As %String, argUserloc As %String, argDocID As %String) As %String
{
	q:($d(argPatEpisodeID)=0)||($d(argDocID)=0)||(argPatEpisodeID="")||(argDocID="") "0"
	s Updoc = ""		
	s Updoc = ##class(Nur.LevelDoc).GetDocsByAdmLoc(argPatEpisodeID,argUserloc)
	q:(Updoc = "") "0"
	s Updoc = $p($p(Updoc,"^",2),"||",1)_"^"_$p($p(Updoc,"^",3),"||",1)
	q:($f("^"_Updoc_"^","^"_argDocID_"^")>1) "1"
	q "0"
}

/// /【门诊、急诊】入院患者是否填写了【入院新冠肺炎筛查调查表】病历
/// w ##class(EMRservice.BOPrivAssist).ISEMRLXBXS(26077901)
ClassMethod ISEMRLXBXS(argPatEpisodeID As %String) As %String
{
	q:(argPatEpisodeID="") "1"
	s AdmWayStr=##Class(web.dtt2019).GetAdmWay(argPatEpisodeID)
	q:(AdmWayStr="") "1"
	s AdmWay=$p(AdmWayStr,"^",1)
	
	s EMRLXBXSStr=##Class(web.dtt2019).GetEMRLXBXS(argPatEpisodeID)
	//q:(AdmWay'=1) "1"  //非门诊途径入院患者不控制
	//q:(AdmWay=1)&&($p(EMRLXBXSStr,"^",1)'="")&&($p(EMRLXBXSStr,"^",2)'="") "1"   //【门诊】途径入院的患者控制填写人和填写时间必填
	q:($p(EMRLXBXSStr,"^",1)'="")&&($p(EMRLXBXSStr,"^",2)'="") "1"   //入院的患者控制填写人和填写时间必填
	
	q "0"
}

/// 返回模板的上级级目录ID
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetTemplate1ParentID(226)
ClassMethod GetTemplate1ParentID(templateid As %String) As %String
{
	s TemplateParentID=""
	q:(templateid="") ""
	s tmpl = ##class(EMRmeta.Template).%OpenId(templateid)
	q:(tmpl="") ""	
	s TemplateParentID=tmpl.TemplateCategoryID
	q TemplateParentID
}

/// 判断就诊记录是否结算
/// Debug: w ##Class(EMRservice.BOPrivAssist).CheckIPPay(26768811)
/// OutPut: 1是,0否
ClassMethod CheckIPPay(argPatEpisodeID As %String) As %String
{
	q:argPatEpisodeID="" 0
	s flag=""
	s flag=##class(web.LZLComm).CheckIPPay(argPatEpisodeID)
	q:(flag="Y") 1
	
	q 0
}

/// desc: 判断某次就诊是否包含初诊/复诊病历
/// creator: chenwang
/// CreateDate:	2021-06-17
/// input: EpisodeID:就诊指针; Type:类型(初诊First,复诊Follow)
/// output: Y/N 
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetOPFirstorFollowVisitTimes("29384986","First")
ClassMethod GetOPFirstorFollowVisitTimes(argEpisodeID As %String, Type As %String) As %String
{
	s ret="N"
	q:argEpisodeID="" ret
	q:Type="" ret
	s ids=""
	s TCID=""
	s:Type="First" TCID=" 27"
	s:Type="Follow" TCID=" 28"
	q:TCID="" ret
	s ids="^"
	s emrid=""  f  s emrid=$o(^DHCEMRM.TemplateI("IndexCategoryId",TCID,emrid)) q:emrid=""  d
	.s name=$lg((^DHCEMRM.TemplateD(emrid)),15)
	.q:((Type="First")&&(name'["初诊"))
	.q:((Type="Follow")&&(name'["复诊"))
	.s ids=ids_emrid_"^"
	q:ids="^" ret
	
	s time=0
	f l=1:1:$l(ids,"^") d
	.s myid=$p(ids,"^",l)
	.s mytime=+##Class(EMRservice.BOPrivAssist).GetSavedInfo(argEpisodeID,myid,"")
	.s time=time+mytime
	
	s:time>0 ret="Y"
	s:time=0 ret="N"
	
	q ret
}

///  Creator:    niucaicai
///  CreateDate: 2021-03-02
///  Desc:       获取病历是否提交过病案编目系统
///  Input:      AEpisodeID:就诊号
///  return:     result 1：提交过   
///  Debug:      w ##Class(EMRservice.BOPrivAssist).GetRecordToCatalog("230")
ClassMethod GetRecordToCatalog(AEpisodeID As %String) As %String
{
	/*
	s result = "0"
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.RecordToCatalogI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.RecordToCatalog).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	s result = AdmRecordStatus.CompletedStatus
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	*/
	
	s result = "0"
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.RecordToCatalogI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    //q:(AdmRecordStatusID = "") result
    if (AdmRecordStatusID = "")
    {
	    //病案编目和病案归档操作分离功能，过度期间进行旧数据判断，功能在2021-03-02上线
		//取当前系统时间
		s date = $p($H,",",1)
		s time = $p($H,",",2)
		
		if (date < 65905)  //功能上线100天后不再去判断旧表数据  
		{
			s OldAdmRecordStatusID = ""
			s OldAdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,OldAdmRecordStatusID))	
		    q:(OldAdmRecordStatusID = "") result
			s OldAdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(OldAdmRecordStatusID)
			q:(OldAdmRecordStatus = "") result
			
			s FinishDate = OldAdmRecordStatus.FinishDate
			if (FinishDate < 65805)  //对旧表数据只判断功能上线前的数据
			{
				s result = OldAdmRecordStatus.CompletedStatus
			}
			d OldAdmRecordStatus.%Close()
			k OldAdmRecordStatus
		}
	}
    else
    {
		s AdmRecordStatus = ##Class(EMRinstance.RecordToCatalog).%OpenId(AdmRecordStatusID)
		q:(AdmRecordStatus = "") result
		s result = AdmRecordStatus.CompletedStatus
	    d AdmRecordStatus.%Close()	
		k AdmRecordStatus
    }
	
	
	q result
}

/// /病历是否医务部要求控制不可以编辑
/// w ##class(EMRservice.BOPrivAssist).ISYWControl(30960492,"8761555||2")
ClassMethod ISYWControl(admid As %String, argInstanceID As %String) As %String
{
	s result = 0
	q:(argInstanceID = "")||(admid="") 0
	q:(admid'="30960492") 0
	
	if admid=30960492
	{	
		///病历未保存，则全部人都可以修改
		if argInstanceID'=""
		{
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
			if objInstance'=""
			{
				s CreateDate=objInstance.CreateDate
				s CreateTime=objInstance.CreateTime
				i CreateDate<$zdh("2021-11-29",3) 
				{
					s result="1"
				}
				elseif (CreateDate=$zdh("2021-11-29",3))
				{
					if CreateTime<=$zth("17:00:00",1)
					{
						s result="1"
					}
				}
			}
		}
	}
	q result
}

/// /第几次修诊断是否存在
/// / MRC_DiagnosType 
/// 0--不存在，1--存在
/// Debug:     w ##Class(EMRservice.BOPrivAssist).HasModDiagByNum(28695788,1)
ClassMethod HasModDiagByNum(AdmID As %String, AModDiaNum As %String) As %String
{
    s result="0"
    
   q:(AdmID="")||(AModDiaNum="") result
   s ADiagType="MOD"
   
   s MRAdmID=""
   s MRAdmID= $P($G(^PAADM(AdmID)),"^",61)
   q:(MRAdmID="") result
   s MRDIAChild=0,num=1,num1=1
    //s (DiagPre,DiagSuf,DiagStrSpa,DiagStrEnt,DiagStrDict,ModDiaNum,NewDiaNum,MRDIADesc,DiagStrZSK,IsCNICD)=""
    //s (NDiagStrSpa,NDiagStrEnt,NDiagStrDict,NDiagStrZSK,OrderBy)=""
    
    
    f  s MRDIAChild=$o(^MR(MRAdmID,"DIA",MRDIAChild))  q:MRDIAChild=""  d
    .s TYPChild="" ,DTYPCode="",MRDIADesc=""
    .f  s TYPChild=$o(^MR(MRAdmID,"DIA",MRDIAChild,"TYP",TYPChild))  q:TYPChild=""  d
    ..s TYPMRCDiagTypID=$p(^MR(MRAdmID,"DIA",MRDIAChild,"TYP",TYPChild),"^",1)
    ..s DTYPCode=$p(^MRC("DTYP",TYPMRCDiagTypID),"^",1)
    .q:(DTYPCode'="MOD") //只取修正诊断
    .q:((ADiagType'="")&&(DTYPCode'=ADiagType))
    .s ModDiaNum=$p(^MR(MRAdmID,"DIA",MRDIAChild,1),"^",25)    //取修正诊断次数
    .s:(ADiagType="MOD")&&(ModDiaNum=AModDiaNum) result="1"
	.q:(result="1")
    
    q result
}

/// 是否男性患者
/// w ##class(EMRservice.BOPrivAssist).IsMan("28695788")
ClassMethod IsMan(AdmID As %String) As %String
{
        s result=0
        q:(AdmID = "") result

        s PapmiDR =""
 	    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AdmID)
        q:(AdmID = "") result
        s Gender=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,"")
        s:(Gender["男") result=1
	
	q result
}

/// 病历是否被锁定
/// w ##class(EMRservice.BOPrivAssist).IsLock("28695788","226")
ClassMethod IsLock(admid As %String, tempID As %String) As %String
{
    s result=0
    q:(tempID = "")||(admid = "") result
	
	s rowid=""
	for{
		s rowid=$o(^DHCEMRI.LockI("IdxEpisodeID"," "_admid,rowid))
		b
		q:(rowid="")
		s objlock=##Class(EMRinstance.Lock).%OpenId(rowid)
		q:(objlock="")
		s lockinsid=objlock.TemplateID
		s:(lockinsid=tempID) result=1 
		q:(result=1)
	}
	q result
}

/// Desc:       是否提交首页
/// Creator:　  Lan
/// CreateDate: 2022-8-10
/// Input:      AdmID 
/// Output:     result 0 否， 1 是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCommitSY("1")
ClassMethod IsCommitSY(argAdmID As %String) As %String
{
	s result = "0"
	q:(argAdmID = "") result
	s value=""
	s value = ##class(EMRservice.BL.BLRecordToCatalog).GetRecordToCatalog(argAdmID)
	s:(value="1") result="1"
	
	q result
}

/// Desc:       病历是否有有效签名(任何级别都可以)
/// Creator:　  QiYH
/// CreateDate: 2017-7-31
/// Input:      argInstanceID 病历实例ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).HasOPPrintByZZJ("1||1")
ClassMethod HasOPPrintByZZJ(argInstanceID As %String) As %String
{
	s result = "0",tempObjCustom=""
	q:(argInstanceID = "") result
	s tempObjCustom = $o(^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," "_argInstanceID,""))

	//s ^DHCEMRI.SelfPrintLogI("IdxInstanceDataID"," 90||1",36)
	s:(tempObjCustom'="") result=1
	q result
}

/// Desc:		登录用户是否为病历的创建者的下级
/// Creator:	QiYH
/// CreateDate: 2022-01-17
/// Input:		argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1 是  0 不是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCreatorLowUserBySignRoleLevel(30,"881||6",14106)
ClassMethod IsCreatorLowUserBySignRoleLevel(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0",userLevel=""
	q:(argInstanceID = "")||(argUserID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	q:(objInstance.Status = "UnSave") result
	s creatorId = objInstance.CreateUser
    q:(creatorId = "") result   //创建者为空时应默认为创建者上级
    ;q:(creatorId=argUserID) "1" //本人为自己的上级
	s creatorPvId = $p(^SSU("SSUSR",creatorId),"^",14)
	s userPvId = $p(^SSU("SSUSR",argUserID),"^",14)
	q:(creatorPvId = "")||(userPvId = "") result
	
	s creatorLevel = ..GetUerLevelCodeByUser(creatorId)
	s userLevel = ..GetUerLevelCodeByUser(argUserID)
	
	s:(userLevel<creatorLevel) result = "1"
	q result
}

/// Desc:		根据UserID获取SignLevelCode （emrmeta.signrole表中 RoleLevel 1782以后可以使用）
/// Creator:	QiYH
/// CreateDate: 2022-01-17
/// Input:		argUserID 用户ID
/// OutPut: 	emrmeta.signrole表中 RoleLevel字段
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetUerLevelCodeByUser(13981)
ClassMethod GetUerLevelCodeByUser(argUserID As %String) As %String
{
	s result = "0",userLevel="",userLevelDesc=""
	q:(argUserID = "") result
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(userPvId = "") result
	s userLevel = ##class(EMRservice.BL.BLPowerUser).GetHisUserLevel(userPvId)
	s userLevelDesc = $o(^DHCEMRM.SignRoleLinkCarPrvTpI("IdxCarPrvTpSignRole"," "_userLevel,""))
	q:(userLevelDesc="") result
	s SignRloeRowid = $o(^DHCEMRM.SignRoleI("NameIndex",userLevelDesc,""))
	q:(SignRloeRowid="") result
	s result = $list(^DHCEMRM.SignRoleD(SignRloeRowid),8)
	
	q result
}

/// Desc:		病历是否被上级医师签名
/// Creator:	QiYH
/// CreateDate: 2022-01-17
/// Input:		argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1 是  0 不是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsHasSignByUp("881||53")
ClassMethod IsHasSignByUp(argInstanceID As %String) As %String
{
	s result = "0",userLevel="",signID=""
	q:(argInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	q:(objInstance.Status = "UnSave") "0" 
	s creatorId = objInstance.CreateUser
    q:(creatorId = "") "0"   //创建者为空时应默认为创建者上级
    ;q:(creatorId=argUserID) "1" //本人为自己的上级
	s creatorPvId = $p(^SSU("SSUSR",creatorId),"^",14)
	
	s creatorLevel = ..GetUerLevelCodeByUser(creatorId)
	
	
	for
	{
		s signID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_argInstanceID,signID),-1)
		q:(signID = "") 
		s objSign = ##Class(EMRinstance.EMRSign).%OpenId(signID)
		q:(objSign = "")
		s Signsuerid = objSign.UsrID
		;q:(Signsuerid=userid)   //最后签名者有权限修改病例
		//创建级别  签名级别
		if (creatorLevel < ..GetUerLevelCodeByUser(objSign.UsrID))
		{
			s result = "1"
			q
		}
	}
	q result
}

/// Desc:		当前登录用户级别是否小于当签病历最高级别
/// Creator:	QiYH
/// CreateDate: 2022-01-26
/// Input:		argInstanceID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1 小于  0 不是
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsSignTopLevl("","14152")
ClassMethod IsSignTopLevl(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "0",userLevel="",signID=""
	q:(argUserID = "")||(argInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	
	s UserIDLevel = ..GetUerLevelCodeByUser(argUserID)
	
	s TopLevel = 0
	for
	{
		
		s signID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_argInstanceID,signID))
		q:(signID = "")
		s objSign = ##Class(EMRinstance.EMRSign).%OpenId(signID)
		q:(objSign = "")
		if (TopLevel < ..GetUerLevelCodeByUser(objSign.UsrID))
		{
			s TopLevel = ..GetUerLevelCodeByUser(objSign.UsrID)
		}
	}
	s:(UserIDLevel<TopLevel) result = 1
	q result
}

/// Desc:		患者是否为急诊留观患者
/// Creator:	QiYH
/// CreateDate:	2022-8-1
/// Input:		Admid 就诊号
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsLinkBlood("289||1")
ClassMethod IsOStayStatus(Admid As %String) As %String
{
	s result = 0
	q:(Admid = "") result
	s FLag = ##class(web.DHCADMVisitStat).GetStayStatus(Admid)
	s:(FLag=1) result = 1
	q result
}

/// Desc:		患者是否已经首次分床
/// Creator:	SJC
/// CreateDate:	2022-9-9
/// Input:		Admid 就诊号
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsInBed("140570")
ClassMethod IsInBed(Admid As %String) As %String
{
	s result = 0
	q:(Admid = "") result
	s FLag = ##class(Nur.NIS.Service.Transaction).IfFirstDispatchBed(Admid)
	s:(FLag=0) result = 1
	q result
}

/// Desc:		病历是否与输血申请单关联
/// Creator:	donglulu
/// CreateDate:	2020-4-9
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).GetCTPCPUnit(17465)
ClassMethod GetCTPCPUnit(AUserID As %String) As %String
{
	s result = ""
	q:AUserID="" result
	
	s CTPCPRowID = $P($G(^SSU("SSUSR",AUserID)),"^",14)
	q:CTPCPRowID="" result
	
	s CTPCPUnit = $P(^CTPCP(CTPCPRowID,2),"^",8)
	
	q CTPCPUnit
}

/// Desc:		是否OA授权，且在授权有效时间内
/// Creator:	
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).HasVaildOAAppoint(20624,1633586)
ClassMethod HasVaildOAAppoint(AUSerID As %String, Adm As %String) As %String
{
	s result="0"
	q:(Adm="")||(AUSerID="") result
	
	s RowID = $O(^EMRmeta.Data.OAAppointDetailI("IdxAdm"," "_Adm,""),-1)
	q:(RowID="") result
	
	s obj = ##class(EMRmeta.Data.OAAppointDetail).%OpenId(RowID)
	q:(obj="") result
	
	s UserCode = $zcvt($P(^SSU("SSUSR",AUSerID),"^",1),"U")
	q:(UserCode="") result
	
	s ApplyUserID = $zcvt(obj.ApplyUser,"U")
	q:(ApplyUserID'=UserCode) result
	
	s appointdatetime = obj.AppointStartDateTime
	s appointdate = $zdh($P(appointdatetime," ",1),3)
	s appointtime = $zth($P(appointdatetime," ",2))
	if (+$H=appointdate)
	{
		q "1"	
	}
	if (+$H-appointdate=1)
	{
		q:($P($H,",",2)<appointtime) "1"	
	}
	q result
}

/// Desc:       是否分配床位
/// Creator:    Candy
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
/// Output:     result: 0-未分床, 1-已分床
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsAEpisodeInBed(76)
ClassMethod IsAEpisodeInBed(argEpisodeID As %String) As %String
{
	s result = "0",PaadmType="",AdmDateTimeInBed=""
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s PaadmType=$p($g(^PAADM(argEpisodeID)),"^",2)
	q:PaadmType'="I" "1"
	s AdmDateTimeInBed=##class(web.DHCDischargeHistory).GetAdminDateTime(argEpisodeID)
	s:(AdmDateTimeInBed = "^") result = "0"
	s:(AdmDateTimeInBed '= "^") result = "1"
	q result
}

/// Desc:		是否死亡超过N小时
/// Creator: 	Candy
/// CreateDate:	2015-3-11
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsDisDeadNHours(76,72)
ClassMethod IsDisDeadNHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeID)
	s tempinfo = ##class(web.DHCDischargeHistory).GetDocIfCanAutopsy(argEpisodeID)
	if tempinfo'="N"{
	s dischDateTime=$p(tempinfo,"^",2)
	q:(dischDateTime = "") result
	s disDate = $zdh($p(dischDateTime," ",1),3)
	s disTime = $zth($p(dischDateTime," ",2),3)
	q:(disDate = "")||(disTime = "") result
	s currDate = +$h
	s currTime = $p($h,",",2)
	s cDay = 0
	s cSecond = 0
	s cDay = currDate - disDate
	s cSecond = (currTime - disTime)\3600
	s retd = cDay*24+cSecond
	s:(retd > argHours) result = "1"}
	q result
}

/// 最近一条手术术后N小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).SSEndHours(1895126,72)
ClassMethod SSEndHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result=0
	s operInfo=""
	s operInfo = ##class(web.DHCANAdaptor).GetANOperation($j((+$h)-(argHours/24),0,0),+$h,argEpisodeID,"","LF")
	//如果operInfo存在数据，确定患者未最近指定小时内，有LF类型的手术。
	q:(operInfo.Size>0) 1
	q result
	/*
	s result = "0"
	s isExist =##Class(EMRservice.BOPrivAssist).IsExistMethod("web.DHCANAdaptor","GetOperEndTimeByAdm")
	q:(isExist=0) result
	
	s tempdischDateTime =##class(web.DHCANAdaptor).GetOperEndTimeByAdm(argEpisodeID)
	s dischDateTime=$p(tempdischDateTime,"\",$l(tempdischDateTime,"\"))
	q:(dischDateTime = "") result
	s disDate = $zdh(($p(dischDateTime," ",1)),3)
	s disTime = $zth(($p(dischDateTime," ",2)),3)
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
	*/
}

/// 最近一条手术术后N小时
/// OutPut: 	0 异常返回，未取到手术结束时间；其它值，手术结束到当前时间小时数
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetSSEndHours(6334)
ClassMethod GetSSEndHours(argEpisodeID As %String) As %String
{
	s result=0
	s operInfo=""
	
	s operInfo = ##class(web.DHCANAdaptor).GetANOperation("",+$h,argEpisodeID,"","LF")
	//如果operInfo存在数据，确定患者未最近指定小时内，有LF类型的手术。
	
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(operInfo)
	quit:($$$ISERR(sc)) ""
	//每个PatInfo节点的信息对应一个web.DHCANInterface类
	Do reader.Correlate("PatInfo","web.DHCANInterface")
	s operEndDateTime="" 
	
	While reader.Next(.operObj,.sc) 
	{
		
		s OPAStatus = operObj.OPAStatus
		continue:(OPAStatus'="完成")&&(OPAStatus'="术毕")
		

		s operEndDateTime = operObj.OPAEndDateTime
		
	}
	s operEndDate= $p(operEndDateTime," ",1)
	s operEndTime= $p(operEndDateTime ," ",2)
	q:((operEndDate="")&&(operEndTime="")) 0
	
	s diffsecond = ##class(EMRservice.Util.DateTimeFormat).GetDateTimeDiff(operEndDate,operEndTime,+$h,$p($h,",",2))
	s hours = $j(diffsecond/3600,0,2)
	q hours
}

/// 手术申请后N小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).SSAPPHours(76,72)
ClassMethod SSAPPHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	s opsId=""
	s flag=1
   s (enddate,endtime)=""
   s operSchedule=""
   s (ALLInstanceID,opcount)=""
   s ALLInstanceID=##Class(EMRservice.BL.opInterface).GetValidInstanceIDList(argEpisodeID,"74")
   &sql(SELECT Count(*) into :opcount FROM CIS_AN.OperSchedule WHERE Status->DESCRiption IN('术毕','完成') AND EpisodeID=:argEpisodeID )
   s:($l(ALLInstanceID,"^")<opcount) flag=-1
   if (flag=-1){
   for{
   set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_argEpisodeID,opsId),-1)
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		s enddate=operSchedule.AppDate
		s endtime=operSchedule.AppTime
   q:(enddate'="")&&(endtime'="") 
   } 	
	s dischDateTime =enddate_","_endtime
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
	
   }
	q result
}

/// 下抢救记录医嘱后N小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).QJYZHours(76,72)
ClassMethod QJYZHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	s isExist =##Class(EMRservice.BOPrivAssist).IsExistMethod("EPRservice.Quality.DataGather.OrderInfo","GetOrdItemTimeForPriv")
	q:(isExist=0) result
	
	s dischDateTime =##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemTimeForPriv(argEpisodeID,"18130||1\18354||1\18634||1\18716||1\18832||1\18833||1\18834||1\18835||1\18877||1\18878||1\18879||1\18880||1","1")
	q:(dischDateTime = "") result
	s disDate = $p(dischDateTime," ",1)
	s disTime = $p(dischDateTime," ",2)
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

/// 获取患者状态
ClassMethod GetVisitStatus(argEpisodeID As %String)
{
	q:(argEpisodeID = "") 0
	
	s VisitStatus = ""
	s VisitStatus = $P(^PAADM(argEpisodeID),"^",20)
	
	q VisitStatus
}

/// 获取授权过的医生
/// w ##Class(EMRservice.BOPrivAssist).GetPowerDoc("846054","785")
ClassMethod GetPowerDoc(argEpisodeID As %String, UserID As %String)
{
	q:((argEpisodeID = "")||(UserID = "")) 0
	
	s RowID = "", OperDoctorid = "",ret = 0
	for  s RowID = $O(^DHCDOCACCREDITi("Paadm",argEpisodeID,RowID))  q:(RowID="")  d
	.s OperDoctorCpId = $P(^DHCDOCACCREDIT(RowID),"^",4)
	.q:(OperDoctorCpId="")
	.&SQL(SELECT SSUSR_RowId into :OperDoctorid FROM SQLUser.ss_user WHERE SSUSR_CareProv_DR  = :OperDoctorCpId)
	.s:(OperDoctorid = UserID) ret = 1
	
	q ret
}

/// 获取医生级别
/// w ##Class(EMRservice.BOPrivAssist).GetDocLevelEMR("785")
ClassMethod GetDocLevelEMR(UserID As %String)
{
	q:(UserID = "") 0
	
	s UserRowID = "",DocLevel = ""
	
	s UserRowID = $O(^DHCEMRM.PowerUserI("UserIDIndex"," "_+UserID,UserRowID))
	q:(UserRowID = "") ""
	s DocLevel = $List($G(^DHCEMRM.PowerUserD(UserRowID)),7)
	
	q DocLevel
}

/// 高级别医师签名后，低级别不能修改病历。
/// w ##Class(EMRservice.BOPrivAssist).HasHighDocLevel("18236311","33215857||1","484")
ClassMethod HasHighDocLevel(argEpisodeID As %String, instanceid As %String, UserID As %String)
{
	q:(UserID = "")||(argEpisodeID = "") 0
	
	s ret = 1
	
	s IsResidentChecked = ..IsResidentChecked(argEpisodeID,instanceid)
	s IsAttendingChecked = ..IsAttendingChecked(argEpisodeID,instanceid)
	s IsChiefChecked = ..IsChiefChecked(argEpisodeID,instanceid)
	
	s DocLevel = ..GetDocLevel(UserID)
	
	// 高级别医师修改后，低级别不能再修改
	s:(DocLevel="Resident")&&((IsAttendingChecked=1)||(IsChiefChecked=1)) ret = 0
	s:(DocLevel="Attending")&&(IsChiefChecked=1) ret = 0
	s:(DocLevel="intern")&&((IsResidentChecked=1)||(IsAttendingChecked=1)||(IsChiefChecked=1)) ret = 0
	
	q ret
}

/// Debug: w ##Class(EMRservice.BOPrivAssist).HasPrint("793103","217")
/// Desc：判断某个模板是否打印过
ClassMethod HasPrint(pEpisodeID, pEMRDocID As %String) As %String
{
	s status = "0"
    q:((pEpisodeID ="")||(pEMRDocID = "")) status
    
	s pEMRNum = ""
    s pEMRNum = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,""),-1)
    q:(pEMRNum="") status
    s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,pEMRNum,""))
    q:(rowId = "") status
    
    s:($D(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",rowId," PRINT"))) status = "1"
    
    q status
}

/// Debug: w ##Class(EMRservice.BOPrivAssist).HasPrintByInstanceID(1144447,"110",20)
/// Desc：根据InstanceID判断某个模板是否打印过
ClassMethod HasPrintByInstanceID(pEpisodeID, pEMRDocID, InstanceID As %String) As %String
{
	s status = "0"
    q:((pEpisodeID ="")||(pEMRDocID = "")||(InstanceID="")) status
    
	s pEMRNum = ""
	s pEMRNum = $P(InstanceID,"||",2)
    q:(pEMRNum="") status
    
    s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,pEMRNum,""))
    q:(rowId = "") status
   
    s:($D(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",rowId," PRINT"))) status = "1"
    
    q status
}

/// Debug: w ##Class(EMRservice.BOPrivAssist).HasCommitByInstanceID(4532752,"110","7168782||1")
/// Desc：根据InstanceID判断某个模板是否签名过
ClassMethod HasCommitByInstanceID(pEpisodeID, pEMRDocID, InstanceID As %String) As %String
{
	s status = "0"
    q:((pEpisodeID ="")||(pEMRDocID = "")||(InstanceID="")) status
    
	s pEMRNum = ""
	s pEMRNum = $P(InstanceID,"||",2)
    q:(pEMRNum="") status
    
    s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,pEMRNum,""))
    q:(rowId = "") status
    
    s:($D(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",rowId," RESIDENTCHECK"))) status = "1"
    s:($D(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",rowId," ATTENDINGCHECK"))) status = "1"
    s:($D(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",rowId," CHIEFCHECK"))) status = "1"
    
    q status
}

/// Debug: w ##Class(EMRservice.BOPrivAssist).HasCompleteDthRep(2455918)
/// Desc：判断患者是否死亡并且没完成居民死亡报告卡
ClassMethod HasCompleteDthRep(pEpisodeID As %String) As %String
{
	s status = "0"
    q:(pEpisodeID ="") status
    
    // 是否完成居民死亡报告卡
    s DthRepStatus = ##Class(DHCMed.DTHService.ReportSrv).CheckDthRepByAdm(pEpisodeID)
    
    // 三天前是否下过宣告死亡医嘱
    s HasDeathOeord = ..GetOeordIDStatus(pEpisodeID,"12263||1")
    
    // 医务处要求：下过宣告死亡医嘱并且没完成居民死亡报告卡的患者，禁止书写病历！
    s:(DthRepStatus="0")&&(HasDeathOeord="1") status = 1
	
    q status
}

/// w ##Class(EMRservice.BOPrivAssist).GetOeordIDStatus(2605983,"12263||1")
ClassMethod GetOeordIDStatus(AEpisodeID As %String, AOeordID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AOeordID = "") ret
	
	s OEORDRowId = ""
	s OEORDRowId = $O(^OEORD(0,"Adm",AEpisodeID,""))
	q:(OEORDRowId = "") ret
	
	s OEORIChildsub = "0"
	for
	{
		s OEORIChildsub = $O(^OEORD(OEORDRowId,"I",OEORIChildsub))
		q:(OEORIChildsub = "")||(OEORIChildsub = "0")
		
		// 过滤已作废的医嘱
		q:('$D(^OEORD(OEORDRowId,"I",OEORIChildsub,1)))
		
		// 不是宣告死亡的过滤
		s OeordRowID = $P(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
		continue:(AOeordID '= OeordRowID)
		
		// 过滤医嘱执行状态不是A和F的
		s OeordStatus = $P(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",5)
		continue:((OeordStatus '= "A")||(OeordStatus '= "F"))
		
		// 医嘱开始日期
		s OeordStaDate = $P(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",9)
		s CurDate = $P($H,",",1)
		// 缓冲三天，下死亡医嘱三天后返回1
		continue:((CurDate - OeordStaDate)<4)
		
		s ret = 1
		q:(ret = 1)
	}
	
	q ret
}

/// Created by zhou
/// Input: AEpisodeID为患者就诊号
/// Return: ret<0 没编目
/// Debug:  w ##Class(EMRservice.BOPrivAssist).IsBianMU(2990831)
ClassMethod IsBianMU(AEpisodeID As %String) As %String
{
    s ret = 0
    q:(AEpisodeID = "") ret
	
	s IsTemp=##class(DHCWMR.SS.Volume).GetStatusByPaadm(AEpisodeID)
	s:((IsTemp["编目")||(IsTemp["装袋")) ret=1
	q ret
}

/// Desc:		判断模板是否保存过 
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).HasTemSaved(9186149)
ClassMethod HasTemSaved(adm As %String) As %String
{
    s ret=0
    q:(adm="") ret
    s temp=##Class(EMRservice.BOPrivAssist).GetSavedInfo(adm,836,"")
  
    s SaveTimes=$p(temp,",",1)
    S:(SaveTimes'="0") ret=1
    Q ret
}

/// Desc:		判断是否有执业医师证书 
/// OutPut: 	1 无,0有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRegDoctor(1704)
ClassMethod IsRegDoctor(userid As %String) As %String
{
    s ret=0
    q:(userid="") ret
    
    s temp=""
    s careid=$p($g(^SSU("SSUSR",userid)),"^",14)
    
    s:(careid'="") temp=$p($g(^CTPCP(careid,2)),"^",8)
    s:(temp="") ret=1
    s:(temp="null") ret=1
    s:(temp'="")&&(temp'="null") ret=0
    Q ret
}

/// Desc: 	门诊医师可以查看本科室及住院科室的病历	
/// Debug: 	w ##class(EMRservice.BOPrivAssist).IsHasPower(14756515,1651) 
ClassMethod IsHasPower(AEpisodeID As %String, AUserID As %String) As %String
{
	s ret = "0"
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")||($d(AUserID)=0)||(AUserID="")) "0"
	
	s AdmLoc=""
	s AdmLoc=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
	s AdmLocID = "^"_$P(AdmLoc,"^",1)_"^"
	
	s Initials = $P(^SSU("SSUSR",AUserID),"^",1)
	s UserLocStr = "^"_##Class(EMRservice.BOLogin).SSUSRInitialsLoc(Initials)_"^"
	
	s:(UserLocStr[AdmLocID) ret = 1
	
	q ret
}

/// Desc: 	门诊医师可以查看本科室及住院科室的病历	
/// Debug: 	w ##class(EMRservice.BOPrivAssist).HasConsult(14756515,1651) 
ClassMethod HasConsult(AEpisodeID As %String, AUserID As %String) As %String
{
	s ret = "0"
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")||($d(AUserID)=0)||(AUserID="")) "0"
	
	s ret = ##class(web.DHCdocAccredit).GetIsAccreditPat(AEpisodeID,AUserID)
	
	q ret
}

/// Debug: 	w ##class(EMRservice.BOPrivAssist).AdmDateTime(14756515) 
ClassMethod AdmDateTime(AEpisodeID As %String) As %String
{
	s ret = "0"
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) "0"
	
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
	i AdmDateTime'="" 
	{
		s ret = $P($G(AdmDateTime),",",1)
	}
	
	q ret
}

/// “成人/儿童营养风险筛查表”是否完成 完成返回1 未完成返回0
/// Debug: 	w ##class(EMRservice.BOPrivAssist).IsUnifyScore(14756515) 
ClassMethod IsUnifyScore(AEpisodeID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="") ret
	S SUM =##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryZ(AEpisodeID,"HDS00.32.003","0")
	S:SUM'="" ret=1
	q ret
}

/// Desc: 	是否是省直和阜外的科室
/// Modify: zhou
/// Input: 	argPatEpisodeID 就诊号
/// 			argDocID 用户UerID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsPatBelongDoc(3230)
ClassMethod IsOtherLoc(LOCID As %String) As %String
{
	q:(LOCID="") "0"
	S DESC=$p($g(^CTLOC(LOCID)),"^",2)
	q:($e(DESC,1,2)="阜外")||($e(DESC,1,2)="省直")||(DESC="内分泌科三病区")||(DESC="心血管内科三病区")||(DESC="脑血管病三病区")||(DESC="内分泌科四病区")||(DESC="AICU重症监护室病区")||(DESC="康复科二病区")||(DESC="高血压科一病区病区")||(DESC="高血压科二病区病区")||(DESC="康复科三病区")||(DESC="神经内科ICU病区")||(DESC="脑血管病五病区")||(DESC="神经外科ICU病区")||(DESC="血液内科五（造血干细胞移植）病区") "1"
	q "0"
}

/// Desc: 	门诊病历是否签名
/// Modify: zhou
/// Input: 	argPatEpisodeID 就诊号
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).HasOPRecordSigned(25526611)
ClassMethod HasOPRecordSigned(Adm As %String) As %String
{
	q:(Adm="") "0"
	
	s ret = 1
	s OPRecordSign = ##class(EMRservice.BL.BLScatterData).GetDataByGlossary(Adm,"HDSD00.03.041","0")
	s:(OPRecordSign="") ret = 0
	
	q ret
}

/// w ##class(EMRservice.BOPrivAssist).IsSigned("50920654")
/// 病历是否签名
ClassMethod IsSigned(argEpisodeID As %String, argChartItemID As %String = "380^381^1058^1111^1022^1443")
{
  q:(argEpisodeID="") "ERROR"
  s strInstancID=..GetInsIdByChartID(argEpisodeID,argChartItemID)
  q:(strInstancID="") "未完成"
  s ListNum=$p(strInstancID,"||",2)
  s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(strInstancID)
  q:(objInstance = "") "未完成"
  s ret=##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(argEpisodeID,objInstance.TheECRecord.ChartItemID,ListNum)
  q ret
}

/// 新产品组会诊科室
/// /^DHCEMCON(0,"ADM",{EC_Adm_Dr},{EC_RowID})
/// w ##Class(EMRservice.BOPrivAssist).GetConsultDateTimeNew(50099685)
ClassMethod GetConsultDateTimeNew(AdmId) As %String
{
    q:AdmId=""
    s Data=""
    s id="" f  s id=$O(^DHCEMCON(0,"ADM",AdmId,id)) q:id=""  d
    .s a=$g(^DHCEMCON(id)) 
    .s appdep=$p(a,"^",13)                      //请会诊科室
    .//q:(LocId'=appdep)
    .s appdate=$p(a,"^",10)                         //申请会诊日期
    .s apptime=$p(a,"^",11)                         //申请会诊时间
    .s conlocid=$p(a,"^",2)
    .q:(conlocid="")                    //会诊科室id  
    .s conloc=$p($g(^CTLOC(conlocid)),"^",2)            //会诊科室  
    .i Data="" s Data=conlocid_"^"_appdate_"^"_apptime
    .e  s Data=Data_"@@"_conlocid_"^"_appdate_"^"_apptime
    q Data
}

/// /##class(EMRservice.BOPrivAssist).GetRecordNumByCharItem()
/// /判断一个病历书写了几次
/// 入参：AEpisodeID  就诊ID，ACharItemID  病历展现结构的ID，ATitle 病历标题，可为空
ClassMethod GetRecordNumByCharItem(AEpisodeID As %String, ACharItemID As %String, ATitle As %String = "")
{
  s ret=0
  q:(AEpisodeID="")||(ACharItemID="") ret
  ///^DHCEMRI.ECRecordI
  s ecreocrdid=""
  s ecreocrdid=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ACharItemID,ecreocrdid))
  q:(ecreocrdid="") ret
  s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
  s strInstancID = ""
  s key = ""
  s key = objECRecord.Instances.Count()+1   
  s ret=0   
  do
    {           
        s objInstanceData = objECRecord.Instances.GetPrevious(.key)
        if (objInstanceData '= "")
        { 
          continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
          continue:(ATitle'="")&&(objInstanceData.Title'[ATitle)
          s ret=ret+1
        }
        
    }while(key'="")
 q ret
}

// /某个病历是否填写,知情同意书

/// ##class(EMRservice.BOPrivAssist).IsOPRecordPrinted1("51329059")
ClassMethod IsOPRecordPrinted1(argEpisodeID As %String, argChartItemID As %String = "424", argAction As %String = "Save") As %String
{
    q:(argEpisodeID="") "ERROR"
    s strInstancID=..GetInsIdByChartID(argEpisodeID,argChartItemID)
    q:(strInstancID="") "未完成"
    
    if (argAction="Printed") {
      s ListNum=$p(strInstancID,"||",2)
      s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(strInstancID)
      q:(objInstance = "") "未完成"
      s Is=##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(argEpisodeID,objInstance.TheECRecord.ChartItemID,ListNum)
    }else {
      s Is=..IsRecordActioned(argEpisodeID,strInstancID,argAction)
    }
    s bulid=##class(web.DHCProcess).SelectProcMRecordStatus(argEpisodeID)
    s ret="未完成"
    s:(Is=1) ret="完成"
    s:(bulid="完成") ret="完成"
    q ret
}

// /某个病历是否填写,术前讨论

/// ##class(EMRservice.BOPrivAssist).IsOPRecordPrinted2("51329059")
ClassMethod IsOPRecordPrinted2(argEpisodeID As %String, argChartItemID As %String = "436", argAction As %String = "Save") As %String
{
    q:(argEpisodeID="") "ERROR"
    s strInstancID=..GetInsIdByChartID(argEpisodeID,argChartItemID)
    q:(strInstancID="") "未完成"

    if (argAction="Printed") {
      s ListNum=$p(strInstancID,"||",2)
      s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(strInstancID)
      q:(objInstance = "") "未完成"
      s Is=##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(argEpisodeID,objInstance.TheECRecord.ChartItemID,ListNum)
    }else {
      s Is=..IsRecordActioned(argEpisodeID,strInstancID,argAction)
    }
    s bulid=##class(web.DHCProcess).SelectProcMRecordStatus(argEpisodeID)
    s ret="未完成"
    s:(Is=1) ret="完成"
    s:(bulid="完成") ret="完成"
    q ret
}

/// 病人就诊日期是否当日
/// ##class(EMRservice.BOPrivAssist).IsCurrentVisit("53529843")
ClassMethod IsCurrentVisit(AEpisodeID As %String) As %String
{
  s ret=0
  q:(AEpisodeID="") ret
  //获取就诊日期
  s AdmDate=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID,"")
  s Current=+$h
  s ret=1
  if (+AdmDate'=Current) {
    s ret=0
  }
  q ret
}

/// 获取病历模板最外层ID
/// w ##class(EMRservice.BOPrivAssist).GetTemplateCategory("534","54472883")
ClassMethod GetTemplateCategory(ATemplateID As %String, admid As %String) As %String
{
  s ret=0
  q:(ATemplateID="") ret
  s AdmType=""
  s AdmType=$P($G(^PAADM(admid)),"^",2)
  Q:AdmType'="I" 1
  //^DHCEMRM.TemplateD
  s categoryID = $g(^DHCEMRM.TemplateD(ATemplateID))
  q:(categoryID="") ret
  s categoryID  =$list(categoryID,9)
  s ret = categoryID
  s parID=""
  s int = 0
  for {
    s parID = $list($g(^DHCEMRM.TemplateCategoryD(categoryID)),6)
    q:(parID=0)||(parID="")
    s int = int+1
    q:(int=10)
    s ret = parID
  }
  s ^test1223("TemplateCategory")=ATemplateID_"^"_ret
  q ret
}

/// /病人当前就诊科室ID
ClassMethod GetCurAdmLoc(AEpisodeID As %String)
{
  s ret=""
  q:(AEpisodeID="") ret
  s admLocInfo = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID,"") 
  if (admLocInfo'="") {
    s ret = $p(admLocInfo,"^",1)
  }
  q ret
}

/// 判断病历的签名单元是否都签名了
/// output  0 没有签名单元  -1 没有签名或者没全签名  1 全签名了
/// ##Class(EMRservice.BOPrivAssist).IsSign(56030992,"7509388||7")
ClassMethod IsSign(AEpisdoeID As %String, AInstanceID As %String)
{
   s ret=0
   s obj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID,0)
   q:(obj="") 0
   s SignCode = ..GetSignCode(obj.TemplateID,obj.TemplateVersion)
   s obj = ""
 
   q:(SignCode="") 0
   s ret = ..HasValidSignL(AEpisdoeID,AInstanceID,SignCode)
   q ret
}

ClassMethod HasValidSignL(AEpisdoeID As %String, argInstanceID As %String, ASignCode As %String) As %String
{
	s result = "-1"
	q:(argInstanceID = "") result
	s signID=""
	s SignNum=0
	s SignPatientNum = 0
	s SignPatient = ""
	s patientL = 0
	for {
	    s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_argInstanceID, signID),-1)
	    q:(signID="")
	    s sign=##Class(EMRinstance.EMRSign).%OpenId(signID,0)
	    continue:(sign.isSignValid'="1") 
	    continue:(sign.Type="AnySign")
	    s Code = sign.Code
	    if (ASignCode[$p(Code,"_",4)) {
		  s SignNum = SignNum + 1
		}
		s sign = ""
	}
	//判断是否有患者签名单元
	s len = $l(ASignCode,"^")
	//医生签名单元个数
	s DoctorSignNum = 0
	for i=1:1:len {
	  s signCode = $p(ASignCode,"^",i)
	  s level = $p(signCode,":",2)
	  if (level = "patient") {
		s:(SignPatient '= "") SignPatient = SignPatient_"^"_$p(signCode,":",1)
	    s:(SignPatient = "") SignPatient = $p(signCode,":",1)
	  }
	  elseif (level="Notation") {
	  
	  }
	  else {
         s DoctorSignNum = DoctorSignNum + 1
      }
	}
	
	if (SignPatient'="") {
	  s patientL = $l(SignPatient,"^")
	}
	
	if (DoctorSignNum=SignNum) {
	   s result = 1
	}
	///判断患者签名
	q:(SignPatient="") result
	s paRet = ..IsPatientSign(AEpisdoeID,argInstanceID,SignPatient)
	
	if (result'=1)||(paRet '= 1) {
	   s result = -1
	}
	q result
}

ClassMethod IsPatientSign(AEpisodeID As %String, AInsId As %String, SignPatient As %String)
{
	///^DHCEMRI.AnySignLogI("IdxInsID")
	s ret = 0
	s ID = ""
	for {
	  s ID = $O(^DHCEMRI.EMRSignI("IdxInstance"," "_AInsId,ID))
	  q:(ID = "")
	  s Data = ##class(EMRinstance.EMRSign).%OpenId(ID,0)
	  continue:(Data="")
	  s Type = Data.Type
	  continue:(Type'="AnySign")
	  s Code = Data.Code
	  s len = $l(SignPatient,"^")
	  for i=1:1:len {
	    s PatientCode = $p(SignPatient,"^",i)
	    if (Code[PatientCode) {
		  s ret = 1
		  q
		}
	  }
	  s Data = ""
	  q:(ret = 1)
	}
	q ret
}

/// ##Class(EMRservice.BOPrivAssist).GetSignCode("1")
ClassMethod GetSignCode(ATemplateID As %String, ATemplateVersionID As %String = "")
{
    s SignCode = ""
    if (ATemplateVersionID="") {
    	s ATemplateVersionID=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_ATemplateID,""),-1)
    }
	q:(ATemplateVersionID="") SignCode
	s VersionID=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_ATemplateID,ATemplateVersionID,""))
	s VersionObj=##class(EMRmeta.TemplateVersion).%OpenId(VersionID)
	s MetaData=VersionObj.MetaData
	s SignCode = ..ParserStream(MetaData,"<MIString>","</MIString>",11,-1,"")
	q SignCode
}

ClassMethod ParserStream(argstream As %GlobalBinaryStream, argStartlable As %String, argEndlable As %String, len As %String, argEndLocation As %String = "-1", ByRef argSignCode As %String) As %String
{
	s templatestream=##Class(%GlobalBinaryStream).%New()
	d templatestream.CopyFrom(argstream)
	d templatestream.Rewind()
	s argBegLocation = templatestream.FindAt(argEndLocation,argStartlable)
	s argEndLocation = templatestream.FindAt(argBegLocation,argEndlable)
	q:(argEndLocation=-1) argSignCode
	s Readlen=argEndLocation-argBegLocation+len
	d templatestream.Rewind()
	s String = ""
	d templatestream.MoveTo(argBegLocation)
	if (Readlen > 32000) {
		s tmplen=0
		s count=+Readlen\32000
		
		for i=1:1:count
		{	
			s String = String_templatestream.Read(32000)
			s tmplen=32000*i
		}
		s lastlen=+Readlen-tmplen
		s String = String_templatestream.Read(lastlen)
	}else {
	  s String=templatestream.Read(Readlen)
	}
	s String = $ZCVT(String,"I","UTF8")
	s String = ..XmlToObj(String)
	s SignatureLevel = String.%Get("SignatureLevel")
	s Code = String.%Get("Code")_":"_SignatureLevel
	if (SignatureLevel'="NONE")&&(SignatureLevel'="") {
	   s:(argSignCode'="") argSignCode = argSignCode_"^"_Code
	   s:(argSignCode="") argSignCode = Code
	}
	d ..ParserStream(argstream,argStartlable,argEndlable,len,argEndLocation,.argSignCode)
	q argSignCode
}

ClassMethod XmlToObj(xmlRequest As %String) As %Library.DynamicObject
{
	s ret = ##Class(%Library.DynamicObject).%New()
	
	s sc = ##class(%XML.TextReader).ParseString(xmlRequest,.reader)
	q:(sc '= "1") ret
	
	while reader.Read()
	{
		if (reader.NodeType = "element")
		{
			s key = reader.Name
		}
		elseif (reader.NodeType = "chars")&&(reader.Name = "")
		{
			d ret.%Set(key,reader.Value)
		}
	}
	
	q ret
}

/// 当前登录用户是否属于这个大科
ClassMethod IsBelongPlat(AEpisodeID As %String, ALocID As %String)
{
  // SELECT * FROM HospModule_Entity.HxeyAppointPlatform
  // SELECT * FROM HospModule_Entity.HxeyAppointPlatformRelation
  s ret = 0
  q:(AEpisodeID="")||(ALocID="") ret
  //病人当前科室
  s CurDept = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID) 
  q:(CurDept="") ret 
  s CurLocID = $p(CurDept,"^",1)
  if (CurLocID=ALocID) {
    s ret = 1
    q ret
  }
  ///是否属于一个大科
  s CurPlatId = ""
  &SQL(SELECT PlatId into CurPlatId FROM HospModule_Entity.HxeyAppointPlatformRelation WHERE LocId=:CurLocID)
  q:(CurPlatId="") ret
  s LoginPlatId = ""
  &SQL(SELECT PlatId into LoginPlatId FROM HospModule_Entity.HxeyAppointPlatformRelation WHERE LocId=:ALocID)
  q:(LoginPlatId="") ret
  if (LoginPlatId=CurPlatId) {
    s ret = 1
  }
  q ret
}

/// 当前登录用户是否是总查房
ClassMethod IsWardRound(AUserID As %String, ALocID As %String)
{
   s ret = 0
   q:(AUserID="")||(ALocID="") ret
   s CTPCPRowId1 = $P($G(^SSU("SSUSR",AUserID)),"^",14)
   q:(CTPCPRowId1="") ret
   
   s CTPCPRowId1s = ##class(User.DHCVueChiefRes).getChiefRes(ALocID)
   if ("^"_CTPCPRowId1s_"^")[("^"_CTPCPRowId1_"^") {
     s ret = 1
   }
   q ret
}

/// /是否试点科室
ClassMethod IsExamplCALoc(ALocID)
{
	s ret = 0
	s ExamplCALoc = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ExamplCALoc","")
	if (ExamplCALoc[ALocID) {
      s ret = 1
    }
    q ret
}

/// 最后一次签名人的级别
ClassMethod LastSingLevel(instanceid As %String)
{
  s ret = 0
  q:(instanceid="") ret
  s signID=""
  s UsrID = ""
  for {
    s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_instanceid, signID),-1)
    q:(signID="")
    s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
    continue:(sign.isSignValid'="1") 
    s UsrID = sign.UsrID
    q
  }
  q:(UsrID="") ret
  //用户级别
  s UserLevel = ##Class(EMRservice.BL.BLSignRole).GetUserLevel(UsrID)
  q:(UserLevel = "") ret
  s UserLevel = $P(UserLevel,"^",1)
  s ret = $case(UserLevel,"Chief":3,"Attending":2,"Resident":1,:0)
  q ret
}

/// 当前的登录用户级别
ClassMethod UserLevel(userId As %String)
{
  s ret = 0
  q:(userId="") ret
  s UserLevel = ##Class(EMRservice.BL.BLSignRole).GetUserLevel(userId)
  q:(UserLevel = "") ret
  s UserLevel = $P(UserLevel,"^",1)
  s ret = $case(UserLevel,"Chief":3,"Attending":2,"Resident":1,:0)
  q ret
}

/// 是否提交
/// w ##Class(EMRservice.BOPrivAssist).IsComplate(56079643,"7509322||1")
ClassMethod IsComplate(AEpisodeID As %String, AInstanceID As %String, AAction As %String = "RECORDCOMMIT")
{
  s ret = 0
  s ret = ##class(EMRservice.BL.BLEMRLogs).RecHasAction(AEpisodeID,AInstanceID,AAction)
  q ret
}

/// ACharItem  "^1^2^3^" 病历展现结构ID 
/// /判断门诊病历是否已经保存,第二个入参空是检查所有的病历；返回1是都签名或者没保存过病历
/// w ##class(EMRservice.BOPrivAssist).IsRecordSave(56079521,"")
ClassMethod IsRecordSave(AEpisodeID As %String, ACharItem As %String = "")
{
  s ret=1
  q:(AEpisodeID="") ret
  s ChartItemID = ""
  s savenum = 0
  for {
    s ChartItemID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID,ChartItemID))
    q:(ChartItemID="")
    continue:(ACharItem'="")&&(ACharItem'[$tr(ChartItemID," ",""))
    s ID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID,ChartItemID,""))
    s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ID)
    continue:(objECRecord="")
    S key = ""
	s key = objECRecord.Instances.Count()+1	
	do {
	   s objInstanceData = objECRecord.Instances.GetPrevious(.key)
       continue:(objInstanceData ="")
	   continue:(objInstanceData.Status'="Save")
	   s savenum = savenum + 1
       s ret=##Class(EMRservice.BOPrivAssist).HasValidSign(objInstanceData.%Id())
	   q:(ret=0)
	}while(key'="")	
  }
  s:(savenum = 0) ret = 0
  q ret
}

/// Input:      Adm 就诊号
///            
/// debug   w ##Class(EMRservice.BOPrivAssist).IsCheckedAll(149929496)	
/// 是否已经签名
ClassMethod IsCheckedAll(Adm As %String)
{
  ////^DHCEMRI.ECRecordI
  s ret="未写"
  s retsult="未写"
  s ChartItemID=""
  for {
    s ChartItemID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_Adm,ChartItemID))
    q:(ChartItemID="")
    s ChartItem=$replace(ChartItemID," ","")
   
    s ret=##Class(EMRservice.BOPrivAssist).IsChecked(Adm,ChartItem)
    continue:(ret=0)
    s retsult=ret
    q:(retsult="未签")
  }
  q retsult
}

/// w ##Class(EMRservice.BOPrivAssist).IsCheckedAllT(140032123)	
ClassMethod IsCheckedAllT(Adm As %String)
{
  ////^DHCEMRI.ECRecordI
  s ret="未写"
  s retsult="未写"
  s ChartItemID=""
  for {
    s ChartItemID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_Adm,ChartItemID))
    q:(ChartItemID="")
    s ChartItem=$replace(ChartItemID," ","")
   
    s ret=##Class(EMRservice.BOPrivAssist).IsChecked(Adm,ChartItem)
    continue:(ret=0)
    s retsult=ret
    q:(retsult="保存")
  }
  q retsult
}

/// Input:      Adm 就诊号
///             ChartItemID 病历展现结构ID
/// debug   w ##Class(EMRservice.BOPrivAssist).IsChecked(76,113)	
/// 是否已经签名
ClassMethod IsChecked(Adm As %String, ChartItemID As %String)
{
  s ret=0
  q:(Adm="")||(ChartItemID="") ret
  s instanedataID=""
  s str=##class(EMRservice.Tools.DailyWorkTool).GetInstanceIdByAdm(Adm,ChartItemID) 
  if (str = "") {
    q ret
  }
  s len=$l(str,"!")
  ///只针对唯一模板
  s instanedataID=$p($p(str,"!",len),"^",1)  
  s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanedataID)
  s currentLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(Adm,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
  s ret="保存"
  s logStatus=currentLog.EMRStatus
 
  if ((logStatus="residentChecked")||(logStatus="attendingChecked")||(logStatus="chiefChecked")||(logStatus="participantChecked")) {
    s ret="提交"
  }
  q ret
}

/// 登陆医生是否是病人的术者
/// ///w ##class(EMRservice.BOPrivAssist).IsAdmOperationUser(140068350,123)
ClassMethod IsAdmOperationUser(argAdm As %String, argUserid) As %String
{
	s ret=0
	q:(argAdm="")||(argUserid="") ret
		s SDate=##class(web.DHCDischargeHistory).GetAdminDateTime(argAdm)
	s:(SDate'="^") SDate=$zd(+SDate,3)
	s EDate=$zd(+$h,3)
	//s SDate="2019-06-01"
	//s EDate="2019-07-08"
	s rset=##class(%ResultSet).%New("web.SSGL.OPMSTothersys.TotherComm.GetSMMeg")
	do rset.Execute(argAdm,SDate,EDate)
	///OperDesc(手术名称)OperType()OperStatus:OperStartDate:OperStartTime:OperEndDate:InDate:OutDate:AnesStartDate:AnesEndDate:OperHour:OperLocID:OperLocCode:OperLocDesc:Opertor（术者）:Assistant1（Ⅰ助）:Assistant2:Assistant3:IncisionCode:IncisionDesc:HealingCode:HealingDesc:AnesMethodCode（麻醉方式coed）:AnesMethodDesc:Anesthesia（麻醉医生）:SAScore:NNISGrade:WBC:IncisionNum:IsSightGlass:IsImplants:LoseBlood:GotBlood:Complication:IsActive:
	///获取工号
	s Initials = $p(^SSU("SSUSR",argUserid),"^",1)
	s count = 0
	While (rset.Next()) {
		s OperDoc1Initials  = $p(rset.Data("Opertor"),"|",2)

		if (Initials=OperDoc1Initials) {
		   s ret=1
		   q 
		}
		s count=count+1
	}
	q ret
}

/// 判断病人是否是手术病人
/// w ##class(EMRservice.BOPrivAssist).IsOperationAdm(149969596,"")
ClassMethod IsOperationAdm(EpisodeID As %String, SchOPType As %String = "")
{
    s ret=0,opFlag=0
	q:EpisodeID="" ret_"^"_opFlag

	s ipBookId=$o(^DHCMedIPBK(0,"EpisodeIDTo",EpisodeID,""),-1)
	/*
	q:ipBookId="" ret_"^"_opFlag
	i (SchOPType'=""&&$p($g(^DHCMedIPBK(ipBookId)),"^",15)[SchOPType) s opFlag=1
	i (SchOPType'=""&&$p($g(^DHCMedIPBK(ipBookId)),"^",17)[SchOPType) s opFlag=1
	q:opFlag=0 ret_"^"_opFlag
	s admId=$p($g(^DHCMedIPBK(ipBookId)),"^",2)
	q:admId="" ret_"^"_opFlag
	s recNo="" 
	f  s recNo=$o(^OPMSApplyi("Status",admId,recNo),-1) q:(recNo="")||(ret=1)  d
	.s status="" 
	.f  s status=$o(^OPMSApplyi("Status",admId,recNo,status)) q:(status="")||(ret=1)  d
	..s rowId="" 
	..f  s rowId=$o(^OPMSApplyi("Status",admId,recNo,status,rowId)) q:(rowId="")||(ret=1)  d
	...s opTypeId=$p($g(^OPMSApply(rowId)),"^",20)
	...q:opTypeId=""
	...s opTypeDesc=$p($g(^OPMSDictionaryManage(opTypeId)),"^",4)
	...q:(SchOPType'="")&&(opTypeDesc'=SchOPType)
	...q:((status'="C")&&(status'="E")&&(status'="F")&&(status'="G")&&(status'="H")&&(status'="J")) 
	...s ret=1
    */
    s:(ipBookId'="") ret=1
	q ret
}

/// 病案室是否已将病历归档平台组方法
/// Debug:w ##Class(EMRservice.BOPrivAssist).IsRecordArchivedByPlat(146540518)
ClassMethod IsRecordArchivedByPlat(argEpisodeID As %String) As %String
{
	s result = "0"
	//q:argEpisodeID'=140000121 result
	//s AdmLoc=$p($g(^PAADM(argEpisodeID)),"^",4)
	//i AdmLoc=24 q result
	s IsDisCharge=..IsDisCharge(argEpisodeID)
	//s b = $i(^gzy("IsRecordArchivedByPlat1"))
	//s ^gzy("IsRecordArchivedByPlat1",argEpisodeID,b)=$zt($p($h,",",2),1)
	
	q:IsDisCharge=0 result
	s InputStr="<Request><Adm>"_argEpisodeID_"</Adm></Request>"
	s inXmlStream=##class(%GlobalCharacterStream).%New()
	d inXmlStream.Write(InputStr)
	s znshSoap=##class(PUB0024.PUB0024Soap).%New()
	s status = znshSoap.HIPMessageServerNew("MES0149",inXmlStream).Read()

	//s:(status '= "") result = status
	//s a = $i(^gzy("IsRecordArchivedByPlat1"))
	//s ^gzy("IsRecordArchivedByPlat2",argEpisodeID)=$zt($p($h,",",2),1)

	if ((status="初始状态")||(status="病历预登记")||(status="")) {s result=0}
	else{s result=1} 
	
	q result
}

/// /
ClassMethod IsGoldCardForAdm()
{
}

/// 1467801||38
/// ##class(EMRservice.BOPrivAssist).IsSameForLoc("1467801||38","21","L0004")
/// 页眉科室是否和登录科室一致
ClassMethod IsSameForLoc(argInstanceID As %String, argLoc As %String, argL As %String) As %String
{
  s ret=1
  q:(argInstanceID="") ret
  //获取页眉科室描述
  //^DHCEMRI.ICompositeSimpleI
  s CompositeCode=""
  s CompositeCode=$o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_argInstanceID," HEADER",""))
  q:(CompositeCode="") ret
  s rowid=$o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_argInstanceID," HEADER",CompositeCode," "_argL,""))
  q:(rowid="") ret
  s headerLoc=$list($g(^DHCEMRI.ICompositeSimpleD(rowid)),15)
  //获取登录科室
  //^CTLOC(6)
  s loginLoc=$p(^CTLOC(argLoc),"^",2)
  q:(loginLoc'[headerLoc) 0
  q 1
}

/// 病历创建者科室是否包含当前登录科室
/// debug ##Class(EMRservice.BOPrivAssist).IsContainCurLoc("538||4",6)
ClassMethod IsContainCurLoc(argInstanceID As %String, argLoc As %String) As %String
{
  s ret=1
  q:(argInstanceID="")||(argLoc="") ret
  s createUser=##class(EMRinstance.InstanceData).%OpenId(argInstanceID).CreateUser
  q:(createUser="") ret
  //默认科室ID ^SSU("SSUSR",{SSUSR_RowId})
  s defaultLoc=$p($g(^SSU("SSUSR",createUser)),"^",4)
  s ret=0
  if (defaultLoc=argLoc) {
    s ret=1
    q ret
  }
  //获取其他登录科室ID
  s seq=""
  //^SSU("SSUSR","516","OTHLL")
  for  s seq=$o(^SSU("SSUSR",createUser,"OTHLL",seq)) q:seq=""  d
  .s otherLoc=$p($g(^SSU("SSUSR",createUser,"OTHLL",seq)),"^",1)
  .s:(otherLoc=argLoc) ret=1
  .q:(ret=1)
  q ret
}

/// 根据日志获取病历创建者的登录科室判断是否是当前科室
/// debug ##Class(EMRservice.BOPrivAssist).IsEqualCurLocByLog(172,"718||1","66",6)
ClassMethod IsEqualCurLocByLog(argEpisodeID As %String, argInstanceID As %String, argDocid As %String, argLoc As %String) As %String
{
	s ret=1
	q:(argEpisodeID="")||(argInstanceID="")||(argLoc="") ret
	//获取num
	s lisNo=##class(EMRinstance.InstanceData).%OpenId(argInstanceID).ListNo
	q:(lisNo="") ret
	//获取日志ID ^DHCEMRI.EMRLogsI("IdxMain"," 172"," 66") EMRinstance.EMRLogs
	s logID=""
	s logID=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_argEpisodeID," "_argDocid,lisNo,""))
	//根据logID获取实例数据操作日志的第一条数据
	//EMRinstance.InstanceLog ^DHCEMRI.InstanceLogI("IdxParRef",539,1)
	s loglisNo=""
	s loglisNo=$o(^DHCEMRI.InstanceLogI("IdxParRef",logID,""))
	q:(loglisNo="") ret
	s UserLoginLocID=##class(EMRinstance.InstanceLog).%OpenId(logID_"||"_loglisNo).UserLoginLocIDd
	q:(UserLoginLocID="") ret
	if (UserLoginLocID'=argLoc) {
	   s ret=0
	}
	q ret
}

/// 登录医师是否是病人的专科医师
/// debug ##Class(EMRservice.BOPrivAssist).IsAdmPersionalDoc()
ClassMethod IsAdmPersionalDoc(argEpisodeID As %String, argUser As %String)
{
  s ret=0
  q:(argEpisodeID="")||(argUser="") ret
  s persional=##class(Nur.DHCGoldCardMainDoctor).GetVal(argEpisodeID)
  s doctorId=$p(persional,"^",2)
  q:(doctorId="") ret
  ///User.CTCareProv
  //SSUSR_CareProv_DR
  // ^SSU("SSUSR",{SSUSR_RowId})
  s CareProvDR=$p($g(^SSU("SSUSR",argUser)),"^",14)
  if (doctorId=CareProvDR) {
    s ret=1
  }
  q ret
}

/// w ##Class(EMRservice.BOPrivAssist).GetLoginUserlevel(1322)
ClassMethod GetLoginUserlevel(argUserID As %String) As %String
{
  s ret=0
  q:(argUserID="") 999
  s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(argUserID,"")
  s userLevel=$p($g(userLevel),"^",1)
  if (userLevel="Resident") {
	  s ret=1
  }elseif (userLevel="Attending") {
      s ret=2
  }elseif ((userLevel="ViceChief")||(userLevel="Chief")) {
      s ret=3
  }else {
      s ret=0
  }
  //s:(argUserID="1325") ^test1223("LoginUserlevel")=ret
  q ret
}

/// w ##Class(EMRservice.BOPrivAssist).GetSignUserLevel("46267||5",1400054863)
ClassMethod GetSignUserLevel(argInstanceID As %String, argEpisodeID As %String) As %String
{
	s result=0
	q:(argInstanceID="") 999
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	if (argEpisodeID = "") {
		s argEpisodeID = objInstance.EpisodeID
	}
	s currentLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.ChartItemID,objInstance.ListNo)
	//s:(argEpisodeID="140250713") ^test1223("SignUserLevel")=argInstanceID
	
	q:(currentLog = "") result
	s Status=currentLog.EMRStatus
	
	if (Status="residentChecked") {
	  s result=1
	}elseif (Status="attendingChecked") {
	  s result=2
	}elseif ((Status="chiefChecked")||(Status="viceChiefChecked")) {
	  s result=3
	}else {
	  s result=-1
	}
	q result
}

// w ##Class(EMRservice.BOPrivAssist).IsSignUserUper("2938201||2",140250713)

ClassMethod IsSignUserUper(argInstanceID As %String, argEpisodeID As %String, argUserID As %String) As %String
{
  s ret=0
  q:(argInstanceID="")||(argEpisodeID="")||(argUserID="") ret
  s SignUserLevel=..GetSignUserLevel(argInstanceID,argEpisodeID)
  s LoginUserlevel=..GetLoginUserlevel(argUserID)
  if (LoginUserlevel>SignUserLevel) { 
    s ret=1
  }
  q ret
}

/// /指定病历是否保存
/// /w ##Class(EMRservice.BOPrivAssist).IsSavedRecord("146681601","24",54)
ClassMethod IsSavedRecord(argEpisodeID As %String = "", argTemplateID As %String = "", argChartItemID As %String)
{
	s ret=0
	q:(argEpisodeID="")||(argTemplateID="")||(argChartItemID="") ret
	//s:(argEpisodeID="146681601") ^test1223("IsSavedRecord")=argEpisodeID_"^"_argTemplateID_"^"_argChartItemID
	///^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_argChartItemID,"");
	s ecrecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_argChartItemID,""))

	q:(ecrecordID="") ret
	///^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus"," "_ecrecordID," "_argTemplateID," SAVE","")
	s ID=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecrecordID," "_argTemplateID," SAVE",""))

	q:(ID="") ret
	s ret=1
	q ret
}

/// /获取最后签名人的userID
ClassMethod IsLastSigner(AUserID As %String, AInstanceID As %String)
{
   s id="",usr="",ret=0
   q:(AUserID="")||(AInstanceID="") ret
   q:(AInstanceID="") usr
   for {
     s id = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_AInstanceID,id),-1)
     q:id=""
     s obj = ##class(EMRinstance.EMRSign).%OpenId(id)
     s isvalid = obj.isSignValid
     continue:(isvalid'=1)
     s usr = obj.UsrID  
   }
   if (AUserID = usr) {
     s ret = 1
   }
   q ret
}

/// 抢救医嘱执行后，才能创建抢救记录
/// w ##class(EMRservice.BOPrivAssist).CanCreateRescueRecord("140446755","13")
ClassMethod CanCreateRescueRecord(AEpisodeID As %String, ATemplateID As %String)
{
   s ret = 1
   if (ATemplateID'="13") {
	   q ret
   }
   //获取执行了几条抢救医嘱
   s Count = ##Class(EPRservice.Quality.DataGather.OrderInfo).GetOrdItemCount(AEpisodeID,"2464||1\2465||1","4")
   q:(Count = 0) 0
   //获取写了几份抢救记录
   s CountRecord = ..CountRecord(AEpisodeID)
   if (CountRecord>=Count) {
     s ret = 0
   }
   q ret
}

/// /统计某个病历的的数量
/// w ##class(EMRservice.BOPrivAssist).CountRecord("140446755","66","抢救记录")
ClassMethod CountRecord(Adm As %String, ACharItem As %String = "66", ATitle As %String = "抢救记录")
{
  s ret=0
  q:(Adm="") ret
  s ChartItemID = ""
  s ID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_Adm," "_ACharItem,""))
  q:(ID="") ret
  s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ID,0)
  q:(objECRecord="")
  S key = "" 
  s key = objECRecord.Instances.Count()+1	
  do {
	   s objInstanceData = objECRecord.Instances.GetPrevious(.key)
       continue:(objInstanceData ="")
	   continue:(objInstanceData.Status'="Save")
	   continue:(ATitle'="")&&(objInstanceData.Title'=ATitle)
       s ret=ret+1
  }while(key'="")	
  s objECRecord = ""
  q ret
}

/// 书写接班记录时，判断有写交班记录没
/// w ##class(EMRservice.BOPrivAssist).isCanCarryOn("142480623","接班记录","66")
ClassMethod isCanCarryOn(Adm As %String, ATemplateID As %String, ACharItem As %String = "66")
{
  s ret = 1
  q:(ATemplateID'="9") ret
  s Count1 = ..CountRecord(Adm,ACharItem,"交班记录")
  if (Count1 = 0) {
    s ret = 0
    q ret
  }
  s Count2 = ..CountRecord(Adm,ACharItem,"接班记录")
  if (Count2 = Count1) {
    s ret = 0
  }
  q ret
}

/// 书写接收记录时，判断是否写了转科记录
/// w ##class(EMRservice.BOPrivAssist).isReceive("142480623","接收记录","66")
ClassMethod isReceive(Adm As %String, ATemplateID As %String, ACharItem As %String = "66")
{
  s ret = 1
  q:(ATemplateID'="11") ret
  s Count1 = ..CountRecord(Adm,ACharItem,"转科记录")
  if (Count1 = 0) {
    s ret = 0
    q ret
  }
  s Count2 = ..CountRecord(Adm,ACharItem,"接收记录")
  if (Count2 = Count1) {
    s ret = 0
  }
  q ret
}

/// w ##Class(EMRservice.BOPrivAssist).BAFYStatus("88056542")
/// 获取病案状态
ClassMethod IsBAFYStatus(argEpisodeID As %String) As %Boolean
{
	s flag="0"
	Set return=""
	Set VolPaadmID=""
	&sql(SELECT ID INTO:VolPaadmID FROM MA_IPMR_SS.VolPaadm WHERE SVEpisodeID=:argEpisodeID)
	Set objVolPaadm = ##class(MA.IPMR.SS.VolPaadm).GetObjById(VolPaadmID)
	Quit:'$isobject(objVolPaadm) return
	
	Set objVol = objVolPaadm.Parref
	Quit:'$isobject(objVol) return
	Set objVolStaus 	= objVol.SVStatus
	Quit:'$isobject(objVolStaus) return
	Set VolStausCode = objVolStaus.BWCode
	Set VolStausDesc = objVolStaus.BWDesc
	s:VolStausDesc="病案复印" flag="1"
	q flag
}

/// Creator:  YK、WEP
/// Desc:     根据条件获取有效的InstanceIDList
/// Input:    就诊号Adm、病历展现结构的DocIDList（以“^”作为分隔符）
/// OutPut:   有效的病例实例ID列表，以“^”作为分割符
/// Debug:     w ##Class(EMRservice.BL.CDATools).GetValidInstanceIDList(1449,"52^460")
ClassMethod GetValidInstanceIDList(Adm As %String, DocIDList As %String) As %String
{
	q:(($d(Adm)=0)||(Adm="")||($TR(DocIDList,"^","")="")||(DocIDList="")) ""
	
	s InstanceIDList = ""
	s ValidInstanceIDList = "^"
	
    for iDocID=1:1:$Length(DocIDList,"^")
    {
        s DocID = $P(DocIDList,"^",iDocID)
        continue:(DocID="")
        s TheECRecord = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",Adm,DocID,""))
        continue:(TheECRecord="")
        
        s LisNo = ""
        For
        {
	        s InstanceID = ""
            s LisNo = $O(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",TheECRecord,LisNo))
            q:(LisNo="")
            s InstanceID = TheECRecord_"||"_LisNo
            s InstanceID = $TR(InstanceID," ","")
            s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
            continue:($IsObject(objInstance)=0)   // add by wep 20191202
            s status = objInstance.Status
            continue:(status'="Save")
			
            // 过滤因同一模板挂到两个界面展示下导致的数据重复
            s tempInstanceID = "^"_InstanceID_"^"
            continue:(ValidInstanceIDList[tempInstanceID)
            s ValidInstanceIDList = ValidInstanceIDList_"^"_tempInstanceID
            
            s:(InstanceIDList'="") InstanceIDList = InstanceIDList_"^"
            s InstanceIDList = InstanceIDList_InstanceID
            do objInstance.%Close()     // add by wep 2020/01/03
        }
    }
    
	q InstanceIDList
}

/// Desc:       门诊病历（执行保存操作的病历）是否签名
/// Creator:　  Jin
/// CreateDate: 2020-06-10
/// Input:      argEpisodeID 就诊ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetSignOPInfo(75154337)
ClassMethod GetSignOPInfo(argEpisodeID As %String) As %String
{
	s result = 0
	s HappenDate = 0
	s Type=""
	s Type=##Class(EMRservice.BOPrivAssist).IsOutPatient(argEpisodeID)
	q:(Type'="1") result
	for
	{
		s HappenDate = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate))
		q:(HappenDate = "")
		
		s HappenTime = ""
		for
		{
			s HappenTime = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime))
			q:(HappenTime = "")
			
			s TheECRecord = ""
			for
			{
				s TheECRecord = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord))
				q:(TheECRecord = "")
				
				s ListNo = ""
				for
				{
					s ListNo = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord,ListNo))
					q:(ListNo = "")
					
					s InstanceDataID = TheECRecord_"||"_ListNo
					s InstanceObj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
					s result=##Class(EMRservice.BOPrivAssist).HasValidSign(InstanceDataID)
					q:result=1
				}
				q:result=1
			}
			q:result=1
		}
		q:result=1
	}
	q result
}

/// Desc:		获取C-DRG病案首页是否上传成功
/// Creator:	donglulu
/// CreateDate:	2020-4-9
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsCDRGSubmit(70003138)
ClassMethod IsCDRGSubmit(argEpisodeID As %String) As %String
{
	s result = 0
    s result=##class(EMRservice.HISInterface.ForTransfer).SendTimesInfo(argEpisodeID)
    q result
}

/// Desc: 	病人属于相关科室(BelongToCaption)
/// Creator:	zik
/// CreateDate:	2021-2-9
/// Input: 	argPatEpisodeID 就诊号
/// 	    argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsPatBelongToCaption(201871,34)
ClassMethod IsPatBelongToCaption(argPatEpisodeID As %String, argLocID As %String) As %String
{
	q:(argPatEpisodeID = "")||(argLocID = "") "0"
	s argCategoryDr=$p(^CTLOC(argLocID),"^",88)	;CTLoc.CTLOC_CategoryDR /User.BDPCTLOCCategory
	q:(argCategoryDr = "") "0"
	s currentLoc = ""
	s currentLoc = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
	q:(currentLoc = "") "0"
	s currentLoc = $p(currentLoc,"^",1)
	s categoryDr = $p(^CTLOC(currentLoc),"^",88)	;CTLoc.CTLOC_CategoryDR /User.BDPCTLOCCategory
	q:categoryDr=argCategoryDr "1"
	
	//病历转移科室应该也是当前科室
	s getappointdept = ""
	s getappointdept = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argPatEpisodeID)
	s getappointdept = $p(getappointdept,"^",1)
	s categoryDr=$p($g(^CTLOC(+getappointdept)),"^",88)	;CTLoc.CTLOC_CategoryDR /User.BDPCTLOCCategory
	q:categoryDr=argCategoryDr "1"
	
	//请求会诊科室有查看权限
	s ecrowId="",flag="0"
	f {
		s ecrowId=$o(^DHCEMCON(0,"ADM",argPatEpisodeID,ecrowId)) q:ecrowId=""
		s status=$p(^DHCEMCON(ecrowId),"^",18)	;DHCEmConsult.EC_RStatus
		continue:",3,9,11,"'[(","_status_",")
		s itmSub=""
		f {
			s itmSub=$o(^DHCEMCON(ecrowId,"I",itmSub)) q:itmSub=""
			s clocdr=""
			s:itmSub clocdr=$p(^DHCEMCON(ecrowId,"I",itmSub),"^",1)	;DHCEmConsultItm.EC_CLoc_Dr /User.CTLoc
			q:clocdr=argLocID&&($i(flag))
		}
		q:flag
	}
	q flag
	
	q "0"
}

/// Desc: 	病人是否存在手术（麻醉科查看权限）(LinkOperation)
/// Creator:	zik
/// CreateDate:	2021-2-9
/// Input: 	argPatEpisodeID 就诊号
/// 	    argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsPatBelongToCaption(201871,34)
ClassMethod IsLinkOperation(argPatEpisodeID As %String) As %String
{
	q:(argPatEpisodeID = "") "0"
	s operId="",isLink=0
	f {
		s operId=$o(^CIS.AN.OperScheduleI("Adm"," "_argPatEpisodeID,operId)) q:operId=""
		s status=$lg(^CIS.AN.OperScheduleD(operId),9)	;OperSchedule.Status /CT.AN.OperStatus
		q:status'=8&&(status'=9)&&(status'=10)&&$i(isLink)
	}	
	q isLink
}

/// Desc: 	南山门诊权限 用户权限
/// Creator:	zik
/// CreateDate:	2021-2-9
/// Input: 	argPatEpisodeID 就诊号
/// 	    argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMRservice.BOPrivAssist).NSOutpatOver24(201871,34)
ClassMethod NSOutpatOver24(argPatEpisodeID As %String, argInstanceid As %String, argUserid As %String) As %String
{
	s flag = "0"
	/// 南山门诊病历创建24h后不允许修改
	s hospId = $p(^PAADM(argPatEpisodeID, 2), "^", 85)	;PAAdm.PAADM_Hospital_DR /User.CTHospital
	q:flag'=3 "1"
	s createDate = $lg(^DHCEMRI.ECRecordD(+argInstanceid, "Instances", +$p(argInstanceid, "||", 2)), 2)	;InstanceData.CreateDate
	s createTime = $lg(^DHCEMRI.ECRecordD(+argInstanceid, "Instances", +$p(argInstanceid, "||", 2)), 3)	;InstanceData.CreateTime
	s createDateTime = createDate_"."_$e("0000000000", 1, 10 - len(createTime))_createTime
	s curDate = +$h
	s curTime = +$p($h, ",", 2)
	s curDateTime = curDate_"."_$e("0000000000", 1, 10 - len(curTime))_curTime
	s deltaTime = (createDateTime - curDateTime)
	s:deltaTime>86400 flag = "1"
	q flag
}

/// Desc: 		获取院区
/// Input：		科室ID
/// Output：	院区dr
/// Createor：	zsy
/// CreateTime：2021-09-14
/// Debug: 		w ##class(EMRservice.BOPrivAssist).GetHosptDR(6) 
ClassMethod GetHosptDR(argLocID As %String) As %String
{
	s $zt="errhandle"
	q:(($d(argLocID)=0)||(argLocID="")) "0"
	s hosptdr=""
	s hosptdr=$P($G(^CTLOC(argLocID)),"^",22)
	q hosptdr
errhandle
	q "0"
}

/// Creator：      
/// CreatDate：    2020-7-21
/// Description:   查房记录是否缺少上级医师签名
/// Input：        argEpisodeID
/// Output：       1是, 0否    
/// Debug:         w ##Class(EMRservice.BOPrivAssist).IsAllSuperSing(46168)
ClassMethod IsAllSuperSing(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	s status = ..IsSuperSign(argEpisodeID)
	s status = $p(status,"^",1)
	s:(status = "-1") result = 1
	q result
}

/// Creator：      
/// CreatDate：    2020-7-21
/// Description:   是否护士做医疗结算
/// Input：        argEpisodeID
/// Output：       1是, 0否    
/// Debug:         w ##Class(EMRservice.BOPrivAssist).IsNurseJS(46168)
ClassMethod IsNurseJS(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	
	s status = ##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(argEpisodeID)
	
	s:(status = "F")||(status = "T") result = 1
	q result
}

/// 所有查房记录是否全部签两个以上的名字
/// w ##Class(EMRservice.BOPrivAssist).IsSuperSign(46168)
ClassMethod IsSuperSign(AEpisodeID As %String) As %String
{
	s ret=0
	s AllCheckFlag=1 , retInfo=""
	s EMRDocID=1113
	s tmpECRecordID=""
	for{
	s tmpECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_EMRDocID,tmpECRecordID))
	q:(tmpECRecordID="")
	s objECRecord=##class(EMRinstance.ECRecord).%OpenId(tmpECRecordID)
	continue:(objECRecord="")
	Set key = ""
	do
	{ 
	s objInstanceData = objECRecord.Instances.GetNext(.key)   
	continue:(objInstanceData = "")
	continue:(objInstanceData.Status '="Save")
	s objInstanceDataID=objInstanceData.%Id()
	s tmpNum=$p(objInstanceDataID,"||",2)
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(objInstanceDataID)
	continue:(objInstance.Title'["查房")
	s signNum=..GetALLSignfInfo(objInstanceDataID)
	s:(signNum<2) AllCheckFlag="-1"
	s:(AllCheckFlag=-1)&&(retInfo'="") retInfo=retInfo_" "_$zd(objInstance.HappenDate,3)_" "_objInstance.Title
	s:(AllCheckFlag=-1)&&(retInfo="") retInfo=$zd(objInstance.HappenDate,3)_" "_objInstance.Title
	  } 
	  while (key '="" )

	}
	s:(AllCheckFlag="-1") ret=-1
	q ret_"^"_retInfo_"。"
}

/// 单个病历的签名数量
/// w ##Class(EMRservice.BOPrivAssist).GetALLSignfInfo("44317||21")
ClassMethod GetALLSignfInfo(AInstanceID As %String) As %String
{
	q:(AInstanceID="") ""
	s ret=0
	s SignRowID = ""
	for
	{
		s SignRowID = $O(^DHCEMRI.EMRSignI("IdxInstance"," "_AInstanceID,SignRowID))
		q:(SignRowID="")
		s SignInfo = ^DHCEMRI.EMRSignD(SignRowID)
		s isSignValid = $List(SignInfo,13)
		continue:(isSignValid = 0)
		s ret=ret+1
		
	}
	q ret
}

/// Debug: w ##Class(EMRservice.BOPrivAssist).IsRecordOverRanOP("3484371||1")
ClassMethod IsRecordOverRanOP(argInstanceID As %String) As %String
{
	s result = 0
	q:(argInstanceID = "") result
	//s AInstanceID=##Class(EMRservice.BL.opInterface).GetValidInstanceIDList(argEpisodeID,"473")
	
	s instance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(instance = "") result

	s EpisodeID = instance.EpisodeID
	//s TemplateID = instance.TemplateID
	//s TitileCode = instance.TitleCode
	s Systemdatetime = $HOROLOG
	s Systemdateint = $p(Systemdatetime,",",1)
	s Systemtimeint = $p(Systemdatetime,",",2)
	s AdmDate = instance.ModifyDate
	s AdmTime = instance.ModifyTime
	q:(AdmDate = "") result

	
		if ((Systemdateint-AdmDate)>=3)
		{
			s result = 1
		}
		elseif ((Systemdateint-AdmDate)=2)
		{
			s:((Systemtimeint-AdmTime)>0) result = 1
		}
	/*elseif (TemplateID = "291")  //此处需要维护“病程记录”的模板ID，判断“病程记录”是否超时——病程记录，需要根据具体的标题来判断是否超时
	{
		
		if (TitileCode = "1")   //此处需要维护“首次病程记录”的标题Code，判断“首次病程记录”是否超时——首次病程记录，应在患者入院8小时内完成
		{
			if ((Systemdateint-AdmDate)>=2)
			{
				s result = 1
			}
			elseif ((Systemdateint-AdmDate)=1)
			{
				s:((Systemtimeint-AdmTime)/3600+24>8) result = 1
			}
			elseif ((Systemdateint-AdmDate)=0)
			{
				s:((Systemtimeint-AdmTime)/3600>8) result = 1
			}
		}
	}*/
	
	q result
}

/// Desc:      入院时间间隔, 时间单位为小时
/// Creator:   Candy
/// CreatDate: 2015-3-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##class(EMRservice.BOPrivAssist).GetInhsTransTimeGap("89")
ClassMethod GetInhsTransTimeGap(argEpisodeID As %String, userloc As %String) As %Integer
{
	s result = 0
	s tmpinfo= ##class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(argEpisodeID)	
	q:(tmpinfo="") result
	s admDateTime =$p($p(tmpinfo,"->",$l(tmpinfo,"->")),"^",3)_" "_$p($p(tmpinfo,"->",$l(tmpinfo,"->")),"^",4)
 	q:((admDateTime) = "") result
 	s admDate = $p(admDateTime," ",1)
 	s admDate=$zdh(admDate,3)
 	s admTime = $p(admDateTime," ",2)
 	s admTime=$zth(admTime,3)
 	q:((admDate = "")||(admTime = "")) result
  	s result = ..GetGapNow(admDate, admTime)
  	q result
}

/// Desc:		是否开立第一条医嘱超过N小时
/// Creator: 	LXX
/// CreateDate:	2022-06-09
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsoeordNHours(76,72)
ClassMethod IsoeordNHours(argEpisodeID As %String) As %String
{
	s result=0
	s dischDateTime = ##class(web.DHCDocCommon).GetPatOrdTime(argEpisodeID)
	q:(dischDateTime = "") result
	s dischDateTime=$p(dischDateTime,"^",1)
	s disDate = $zdh($p(dischDateTime," ",1),3)
	s disTime = $zth($p(dischDateTime," ",2),3)
	q:(disDate = "")||(disTime = "") result
	s currDate = +$h
	s currTime = $p($h,",",2)
	s cDay = 0
	s cSecond = 0
	s cDay = currDate - disDate
	s cSecond = (currTime - disTime)\3600
	s result = cDay*24+cSecond
	q result
}

/// Desc:		是否开立手术医嘱超过N小时
/// Creator: 	LXX
/// CreateDate:	2022-06-09
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsOperaNHours(76,72)
ClassMethod IsOperaNHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	s dischDateTime = ##class(web.DHCDocCommon).GetPatOrdTime(argEpisodeID)
	q:(dischDateTime = "") result
	s dischDateTime=$p(dischDateTime,"^",2)
	q:dischDateTime="" result
	s disDate = $zdh($p(dischDateTime," ",1),3)
	s disTime = $zth($p(dischDateTime," ",2),3)
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

/// Desc:		是否开立死亡医嘱超过N小时
/// Creator: 	LXX
/// CreateDate:	2022-06-09
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsDeadNHours(76,72)
ClassMethod IsDeadNHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	s PatientID=+$g(^PAADM(argEpisodeID))
	s dischDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(argEpisodeID,PatientID)
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

/// CreateDate: 2021.09.16
/// author: lhk
/// Description: 计算医生病历提交的截止日期，节假日周末除外(正常患者出院后3天，死亡患者7天)
/// Input:       就诊号
/// Return:		 截止日期
/// w ##class(Nur.HISUI.NurSubmitExec).getNurMpEndDateNew(20596886)
ClassMethod getNurMpEndDate(episodeID, endnum)
{
 q:episodeID="" ""
 s disDate=$p(^PAADM(episodeID),"^",17)
 s pavisit=$p($g(^PAADM(episodeID)),"^",20)
 q:pavisit="A" ""
 s disDate=disDate+1
 s endDate=disDate+20
 s paperId=+^PAADM(episodeID)
 &sql(select PAPER_Deceased_Date into :diedate from SQLUser.PA_Person where Paper_RowId=:paperId)
 q:(endnum=7)&&(diedate="") ""
 q:disDate="" ""
 s num=0,disdate=$zd(disDate,3),flag=""
 f date=disDate:1:endDate d
 .q:num>=endnum
 .s todate=$zd((date),3)
 .s ifhasdate=##class(CT.IPMR.BTS.HolidaysSrv).CheckHoliday(todate)
 .i ifhasdate=0 d
 ..s num=num+1
 ..i num=0 s endnum=endnum+1
 
 q todate
}

/// Desc:		是否出院超过N小时不包含节假日
/// Creator: 	zhoushuyang
/// CreateDate:	2022-05-09
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsDischargedNHoursUnHoliday(3,72)
ClassMethod IsDischargedNHoursUnHoliday(argEpisodeID As %String, argHours As %Integer) As %String
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
	
	s num=0
	for date=disDate:1:currDate {
		 s todate=$zd((date),3)
		 s ifhasdate=##class(CT.IPMR.BTS.HolidaysSrv).CheckHoliday(todate)
		 s:(ifhasdate="1") num=num+1
	}
	
	s currDate=currDate-num //去掉节假日
	
	s cDay = currDate - disDate
	s cSecond = (currTime - disTime)\3600
	s retd = cDay*24+cSecond
	s:(retd > argHours) result = "1"
	q result
}

/// Desc:	患者是否死亡
/// Input:	argEpisodeID : 就诊指针
/// Return:	1 ：是， 0 ：否
/// Debug:	w ##Class(EMRservice.BOPrivAssist).IsDead("76")
ClassMethod IsDead(argEpisodeID As %String) As %Boolean
{
	s ret = "0"
	
	s dateTime = ..GetDeathDateTimeInAdm(argEpisodeID)
 	if (dateTime = "")
 	{
 		s ret = 0		//正常出院患者
 	}
 	else
 	{
	 	s ret = 1		//死亡患者
 	}
 	
 	q ret
}

/// Desc:       转出科室转出时间大于48小时不允许再修改病历
/// Creator:　  ZSY 
/// CreateDate: 2022-05-14
/// Input:      argEpisodeID:病人就诊rowid   argLocID 当前用户科室ID   argHours 大于多少小时
/// Output:     result 1:小于48小时  0 大于48小时
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsTransPreviousCTLOCHoursNew("116251","28",48)
ClassMethod IsTransPreviousCTLOCHours(argEpisodeID As %String, argLocID As %String, argHours As %String) As %String
{
	s result = "0"
	q:((argEpisodeID = "")||(argLocID = "")) result
	s TransDeptDetail=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(argEpisodeID,"")
	q:(TransDeptDetail="无")||(TransDeptDetail="") result
	
	s transDept="",transDate="",transTime=""
	for iT=1:1:($l(TransDeptDetail,"->"))
	{
		s transInfo=$p(TransDeptDetail,"->",iT)
		s transOutInfo=$p(TransDeptDetail,"->",iT+1)
		q:(transOutInfo="")
		s transDate=$zdh($p(transOutInfo,"^",3),3)
		s transTime=$zth($p(transOutInfo,"^",4),3)
		
		
		s transDept=$p(transInfo,"^",1)
		s Hours=((+$H-transDate)*24)+(($P($H,",",2)-transTime)/3600)
		s:(argLocID=transDept)&&(Hours<argHours) result=1
	    Q:(result=1)
	}
	
	
	//当前登录科室  是患者目前所在科室   
	s lastdept=$p($p(TransDeptDetail,"->",$l(TransDeptDetail,"->")),"^",1)
	s:(lastdept=argLocID) result=1
	
	
	//病历转移科室应该也是当前科室
	s getappointdept = ""
	s getappointdept = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argEpisodeID)
	q:(getappointdept=argLocID) "0"		
	
	q result
}

/// Desc:       转出科室转出时间大于48小时不允许再修改病历
/// Creator:　  ZSY 
/// CreateDate: 2022-05-14
/// Input:      argEpisodeID:病人就诊rowid   argLocID 当前用户科室ID   argHours 大于多少小时
/// Output:     result 0:小于48小时  1 大于48小时
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsTransPreviousCTLOCHours("229","96",48)
ClassMethod IsTransPreviousCTLOCHoursBAK(argEpisodeID As %String, argLocID As %String, argHours As %String) As %String
{
	s result = "0"
	q:((argEpisodeID = "")||(argLocID = "")) result
	s TransDeptDetail=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(argEpisodeID,"")
	q:(TransDeptDetail="无")||(TransDeptDetail="") result
	
	s transDept="",transDate="",transTime=""
	for iT=1:1:($l(TransDeptDetail,"->")-1)
	{
		s transInfo=$p(TransDeptDetail,"->",iT)
		s transDate=$zdh($p(transInfo,"^",3),3)
		s transTime=$zth($p(transInfo,"^",4),3)
		s transDept=$p(transInfo,"^",1)
		s Hours=((+$H-transDate)*24)+(($P($H,",",2)-transTime)/3600)
		s:(argLocID=transDept)&&(Hours<argHours) result=1
	    Q:(result=1)
	}
	
	//病历转移科室应该也是当前科室
	s getappointdept = ""
	s getappointdept = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argEpisodeID)
	q:(getappointdept=argLocID) "0"		
	
	q result
}

/// Desc:       当前登录用户跟病历创建者 是否能够登录同一个科室
/// Creator:　  ZSY 
/// CreateDate: 2022-05-14
/// Input:      
/// Output:     
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsTheSameCTloc("8056||1",14359)
ClassMethod IsTheSameCTloc(argInstanceID As %String, argUserID As %String) As %String
{
	s result = "1"
	q:((argInstanceID="")||(argUserID="")) result
	
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance="") result
	s CreateUserID = objInstance.CreateUser
	q:(CreateUserID="") result
	
	s ret = 0
	// 创建者能登录的科室串
	s CreateCode = $p($g(^SSU("SSUSR",CreateUserID)),"^",1)
	s str1 = ##Class(EMRservice.BOLogin).SSUSRInitialsLoc(CreateCode)
	
	// 当前登录用户能登录的科室串
	s UserCode = $p($g(^SSU("SSUSR",argUserID)),"^",1)
	s str2 = ##Class(EMRservice.BOLogin).SSUSRInitialsLoc(UserCode)
	
	s length = $L(str1,"^")
	For i = 1:1:length
	{
		S:(str1=str2) ret=1
		s CTlocID = "^"_$P(str1,"^",i)_"^"
		
		s:(str2[CTlocID) ret = 1
		
	}
	
	q ret
}

/// Desc:       是否是会诊科室,在会诊时间内的会诊科室
/// Creator:　  ZSY 
/// CreateDate: 2022-06-15
/// Input:      
/// Output: 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsConsultDeptNew(87385,115)
ClassMethod IsConsultDept(argEpisodeID As %String, argUserLoc As %Integer) As %String
{
	s result="0"
	q:((argEpisodeID="")||(argUserLoc="")) result
	s rowid=""
	for {
		s rowid=$o(^DHCEMRI.AuthAppointI("IdxEpisode"," "_argEpisodeID,rowid))
		q:(rowid="")
		if (rowid'=""){
			s dept=$lg(^DHCEMRI.AuthAppointD(rowid),5)
			s deptEndDate=$lg(^DHCEMRI.AuthAppointD(rowid),11)
			s deptEndTime=$lg(^DHCEMRI.AuthAppointD(rowid),12)
			s date=$p($h,",",1)
			s time=$p($h,",",2)
			s:(dept=argUserLoc)&&(deptEndDate>date) result=1
			s:(dept=argUserLoc)&&((deptEndDate=date)&&(deptEndTime>time)) result=1	
			
		}
	}
	q result
}

/// Desc:       是否是会诊科室
/// Creator:　  ZSY 
/// CreateDate: 2022-06-15
/// Input:      
/// Output: 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsConsultDept("316",2)
ClassMethod IsConsultDeptBAK(argEpisodeID As %String, argUserLoc As %Integer) As %String
{
	s result="0"
	q:((argEpisodeID="")||(argUserLoc="")) result
	s rowid=""
	for {
		s rowid=$o(^DHCEMRI.AuthAppointI("IdxEpisode"," "_argEpisodeID,rowid))
		q:(rowid="")
		if (rowid'=""){
			s dept=$lg(^DHCEMRI.AuthAppointD(rowid),5)
			s:(dept=argUserLoc) result="1"
		}
	}
	q result
}

/// Desc:       病案室是否撤销回收
/// Creator:    ZSY
/// CreateDate: 2022-06-29
/// InPut:      argEpisodeID 就诊号
/// OutPut:     1已撤销, 0未撤销
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecordRetrieve(3)
ClassMethod IsCXRecordRetrieve(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	;s status = ##Class(web.DHCWMRService).IGetMrRetrieveStatus(argEpisodeID)
	s status = ##class(MA.IPMR.IO.OutService).GetRCStatus(argEpisodeID)
	s:(status<0) result = 1
	q result
}

/// Desc:       是否分床
/// Creator:    ZSY
/// CreateDate: 2022-06-29
/// InPut:      argEpisodeID 就诊号
/// OutPut:     1已分床, 0未分床
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecordRetrieve(3)
ClassMethod IsHaveBed(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	;s status = ##Class(web.DHCWMRService).IGetMrRetrieveStatus(argEpisodeID)
	s status = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmBed(argEpisodeID)
	s:(status="") result = 1
	q result
}

/// 查房是否需要上级医师签名
/// result：0不需要上级医师签名/上级医师已签名，1上级医师未签名
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsFinishChecked(464267,"1275475||2")	
ClassMethod IsFinishChecked(argEpisodeID As %String, argInstanceID As %String) As %String
{
	s result=0
	q:(argEpisodeID = "")||(argInstanceID = "") result
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:($IsObject(objInstance)=0) result  
	q:(objInstance.TemplateID'="29") result  //不是查房记录不需要上级医师签名
    q:((objInstance.Title'["主任")&&(objInstance.Title'["主治")) result  //没有包含主任主治的不需要上级医师签名
	
	if (objInstance.Title["主任")
	{
		s IsChiefChecked = ##class(EMRservice.BOPrivAssist).IsChiefChecked(argEpisodeID,argInstanceID) //主任医师审核
		s:IsChiefChecked=0 result=1
		
	}elseif (objInstance.Title["主治")
	{
		s IsAttendingChecked = ##class(EMRservice.BOPrivAssist).IsAttendingChecked(argEpisodeID,argInstanceID) //主治医师审核
		s:IsAttendingChecked=0 result=1
		
	}
	q result
}

/// Desc:       根据就诊号判断门诊病历初诊、复诊是否有有效签名(任何级别都可以)
/// Creator:　  yan
/// CreateDate: 2017-7-31
/// Input:      Adm 就诊号
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetSignNewInfo(10)
ClassMethod GetSignNewInfo(Adm As %String) As %String
{
	q:(Adm = "") "1"
	s InstanceID=##Class(EMRservice.BL.CDATools).GetValidInstanceIDList(Adm,"155^154")
	q:InstanceID="" "1"
	s HasValidSign=##Class(EMRservice.BOPrivAssist).HasValidSign(InstanceID)
	q HasValidSign
}

/// Desc:		判断当前登录科室是否病历创建者所在科室
/// Creator: 	
/// CreateDate:	
/// Input:		argEpisodeID 就诊号     
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsCreaterLoc(71808,"227738||31",66,32)
ClassMethod IsCreaterLoc(argEpisodeID As %String, argInstanceID As %String, argDocid As %String, argLoc As %String) As %String
{
	s ret=0
	q:(argEpisodeID="")||(argInstanceID="")||(argLoc="") ret
	//获取num
	s lisNo=##class(EMRinstance.InstanceData).%OpenId(argInstanceID).ListNo
	q:(lisNo="") ret
	//获取日志ID ^DHCEMRI.EMRLogsI("IdxMain"," 172"," 66") EMRinstance.EMRLogs
	s logID=""
	s logID=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_argEpisodeID," "_argDocid,lisNo,""))
	s:(logID="") ret=1 //新建病历，日志为空
	q:(logID="") ret
	//根据logID获取实例数据操作日志的第一条数据
	//EMRinstance.InstanceLog ^DHCEMRI.InstanceLogI("IdxParRef",539,1)
	s loglisNo=""
	b
	s loglisNo=$o(^DHCEMRI.InstanceLogI("IdxParRef",logID,""))
	q:(loglisNo="") ret
	s UserLoginLocID=##class(EMRinstance.InstanceLog).%OpenId(logID_"||"_loglisNo).UserLoginLocID
	q:(UserLoginLocID="") ret
	if (UserLoginLocID=argLoc) {
	   s ret=1
	}
	q ret
}

/// Desc:		判断当前时间是否是就诊当天
/// Creator: 	
/// CreateDate:	
/// Input:		argEpisodeID 就诊号     
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsToday(203376)
ClassMethod IsToday(argEpisodeID As %String) As %String
{
	s ret=0
	q:(argEpisodeID="") ret
	s admDate = $p(##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID),",",1)
	q:(admDate = "") ret
	s now = $p($h,",",1)
	if (admDate=now) {
	   s ret=1
	}else{
		s ret=0
	}
 	q ret
}

/// Desc:		判断当前时间是否超过出院时间7天
/// Creator: 	
/// CreateDate:	
/// Input:		argEpisodeID 就诊号     
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsSevenDay(194276)
ClassMethod IsSevenDay(argEpisodeID As %String) As %String
{
	s ret=0
	q:(argEpisodeID="") ret
	s admDate = $p(##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID),",",1)
	q:(admDate = "") ret
	s now = $p($h,",",1)
	if (admDate=now-8) {
	   s ret=1
	}else{
		s ret=0
	}
 	q ret
}

/// Desc:       根据就诊号、病历ID判断病历是否打印(病历ID用^拼接)
/// Creator:　  yan
/// CreateDate: 2017-7-31
/// Input:      Adm 就诊号
/// Output:     result 0 无(没有打印) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetPrintInfo(532751,"154^155")
ClassMethod GetPrintInfo(Adm As %String, DocID As %String) As %String
{
	q:(Adm = "") "1"
	s InstanceID=##Class(EMRservice.BL.CDATools).GetValidInstanceIDList(Adm,DocID)
	q:InstanceID="" "0"
	s InstanceIDLength=$L(InstanceID,"^")
	for i=1:1:InstanceIDLength
	{
		s InstanceIDi=$P(InstanceID,"^",i)
	}
	s PrintFlag=##class(EMRservice.BOPrivAssist).IsRecordActioned(Adm,InstanceIDi,"Print") //##Class(EMRservice.BOPrivAssist).HasValidSign(InstanceID)
	q PrintFlag
}

/// Desc:       根据就诊号、病历ID判断病历是否当天打印(病历ID用^拼接)
/// Creator:　  xujieduan
/// CreateDate: 20220621
/// Input:      Adm 就诊号
/// Output:     0不是当当天打印，1当天打印
/// Debug:      w ##Class(EMRservice.BOPrivAssist).isPrintSameDay(577511,"154^155")
ClassMethod isPrintSameDay(Adm As %String, DocID As %String) As %String
{
	q:(Adm = "") "0"
	s InstanceID=##Class(EMRservice.BL.CDATools).GetValidInstanceIDList(Adm,DocID)
	q:InstanceID="" "0"
	
	s AdmDate=""
	s AdmDate=$p($g(^PAADM(Adm)),"^",6)  //就诊日期
	s InstanceIDLength=$L(InstanceID,"^")
	for i=1:1:InstanceIDLength
	{
		s InstanceIDi=$P(InstanceID,"^",i)
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceIDi)
		
		s EMRLogsId=$o(^DHCEMRI.EMRLogsI("IdxMain"," "_Adm," "_objInstance.TheECRecord.ChartItemID,objInstance.ListNo,""))
		
		//^DHCEMRI.InstanceLogI("IdxParRef",ParRef,ID)
		s InstanceLogID="",Action="",Flag="0"
		for
		{
			s InstanceLogID=$O(^DHCEMRI.InstanceLogI("IdxParRef",EMRLogsId,InstanceLogID),-1)
			q:InstanceLogID=""
			s InstanceLogobj=##Class(EMRinstance.InstanceLog).%OpenId(EMRLogsId_"||"_InstanceLogID)
			s Action=InstanceLogobj.Action
			s OperateDate=InstanceLogobj.OperateDate
			if (Action="print")&&(OperateDate=AdmDate) s Flag=1
		}
	}
	
	q Flag
}

/*
/// Desc:       根据就诊号、病历ID判断病历是否打印(病历ID用^拼接)
/// Creator:　  yan
/// CreateDate: 2017-7-31
/// Input:      Adm 就诊号
/// Output:     result 0 无(没有打印) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetPrintInfo(532751,"154^155")
ClassMethod GetPrintInfo(Adm As %String, DocID As %String) As %String
{
	q:(Adm = "") "1"
	s InstanceID=##Class(EMRservice.BL.CDATools).GetValidInstanceIDList(Adm,DocID)
	q:InstanceID="" "0"
	s InstanceIDLength=$L(InstanceID,"^")
	for i=1:1:InstanceIDLength
	{
		s InstanceIDi=$P(InstanceID,"^",i)
	}
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceIDi)
	q:(objInstance = "") result
	s EMRLogsId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_pEpisodeID," "_objInstance.TheECRecord.ChartItemID,objInstance.ListNo,""))
    s Admdate="",Printdate=""
    &sql(SELECT min(OperateDate):Printdate FROM SqlUser.EMRinstance.InstanceLog WHERE ParRef='1854750' AND Action='print' )
}

*/
/// 患者是否有了入院分床时间
/// w ##Class(EMRservice.BOPrivAssist).IsGetAdmDate(547126)
ClassMethod IsGetAdmDate(AEpisodeID As %String) As %String
{
	s ret=0
	s AdmDateTimeInBed=##class(web.DHCDischargeHistory).GetAdminDateTime(AEpisodeID)
	i AdmDateTimeInBed="^" 
	{
		s AdmDateTimeInBed=""
	}
	i AdmDateTimeInBed'="" 
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),"^",1),3)
		s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed),"^",2),2)
		s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed
		s ret=1
	} 
	q ret
}

/// Desc:       根据就诊号、病历ID判断病历是否打印,是否满足切换就诊(病历ID用^拼接)
/// Creator:　  yan
/// CreateDate: 2017-7-31
/// Input:      Adm 就诊号
/// Output:     result 0 无(没有打印，不满足切换) 1 有（已打印/或者未打印，患者没有完成接诊）
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetPrintInfoTran(599665,"154^155")
ClassMethod GetPrintInfoTran(Adm As %String, DocID As %String) As %String
{
	s flag="0"
	;q:(Adm '= "") "1"
	q:(Adm = "") "1"
	
	s AdmLoc=$P(^PAADM(Adm),"^",4)  
	s AdmDoc=$P(^PAADM(Adm),"^",9) //胸外科马锴
	q:AdmLoc=241 "1"   //影像诊断科
	q:AdmLoc=128 "1"   //特需影像诊断科
	q:AdmDoc=593 "1" //胸外科门诊，两个科室同时出诊看患者，马锴过滤掉
	
	
	;s AdmIsArrive=##class(web.DHCDocService).GetAdmIsArrive(Adm)
	;q:$P(AdmIsArrive,"^",2)="N" "1"   //未就诊过滤
	
	s InstanceID=##Class(EMRservice.BL.CDATools).GetValidInstanceIDList(Adm,DocID)
	q:InstanceID="" "1"
	s InstanceIDLength=$L(InstanceID,"^")
	for i=1:1:InstanceIDLength
	{
		s InstanceIDi=$P(InstanceID,"^",i)
	}
	s flag=##class(EMRservice.BOPrivAssist).IsRecordActioned(Adm,InstanceIDi,"Print")
	q:flag="" "0"
	q flag
}

/// Desc:       取出院时间后病案首页创建时间135^435
/// Creator:　  yan
/// CreateDate: 2017-7-31
/// Input:      Adm 就诊号
/// Output:     result 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetDisCreatTime(638146)
ClassMethod GetDisCreatTime(Adm As %String) As %String
{
	q:(Adm = "") "1"
	set DisDate="",DisTime="",CreatDate="",CreatTime="",DisDateTime="",CreatDateTime=""
	set DisDate=$zd($p($g(^PAADM(Adm)),"^",17),3)
	set DisTime=$zt($p($g(^PAADM(Adm)),"^",18),1)
	q:DisDate=""
	s InstanceID=##Class(EMRservice.BL.CDATools).GetValidInstanceIDList(Adm,"135^435")
	q:InstanceID="" "未创建"
	s InstanceIDLength=$L(InstanceID,"^")
	for i=1:1:InstanceIDLength
	{
		s InstanceIDi=$P(InstanceID,"^",i)
	}
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceIDi)
	q:objInstance.Status="delete" "未创建"
	s CreatDate=$zd((objInstance.CreateDate),3)
	s CreatTime=$zt((objInstance.CreateTime),1)
	s DisDateTime=DisDate_" "_DisTime
	s CreatDateTime=CreatDate_" "_CreatTime
	s DiffValue=##class(DHCCL.BLL.DateTime).CalculateDurationS(DisDateTime,CreatDateTime)/3600
	s DiffValue=$fn(DiffValue,"",2)
	q DiffValue
}

/// Desc:	距离出院9天或者结算48小时还剩多少时间
/// Input:	argEpisodeID : 就诊指针
/// Return:	1 ：是， 0 ：否
/// Debug:	w ##Class(EMRservice.BOPrivAssist).IsDisWorkingDay("EpisodeID")
ClassMethod IsDisWorkingDay(argEpisodeID As %String) As %Boolean
{
	s isOverSpan = "0"
	s ArealSpan ="0"
    s realSpan=""
	s dateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
 	s span = 216		//正常出院患者：216小时  沈阳胸科医院改为9个自然日  BY WB

 	s date = $p(dateTime,",",1)
 	s time = $p(dateTime,",",2)
 	q:((date = "")||(time = "")) ArealSpan
 	
 	s realSpan = ..WorkingTimeSpanToNow(date, time)
 	if (realSpan < span)
 	{	s ArealSpan = span-realSpan}

 	
 	///增加判断是否财务结算48小时

 	s span1 = 48		
 	
    // 自费患者时间改为216小时
    s YBFlag="",PayType1=""
	s PayType1=##Class(EMRservice.HISInterface.PatientInfoAssist).PayType(argEpisodeID)
	s YBFlag=##Class(EMRservice.HISInterface.PatientInfoAssist).ConvertPayType2(PayType1,argEpisodeID)
    s:(YBFlag="1") span1=216
    
 	s PRTRowid="",PRTDate="",PRTTime="",PRTFlag="",realSpan1=""
	f
	{
		s PRTRowid=$o(^DHCINVPRTZY(0,"ADM",argEpisodeID,PRTRowid),-1)
		q:((PRTRowid="")||(PRTFlag="N"))
		if (PRTRowid'="")  
		{
			s PRTFlag=$P(^DHCINVPRTZY(PRTRowid),"^",8)
			continue:PRTFlag'="N"
			continue:$d(^DHCINVPRTZY(0,"InitInv",PRTRowid))
			S PRTDate=$P(^DHCINVPRTZY(PRTRowid),"^",2)
			S PRTTime=$P(^DHCINVPRTZY(PRTRowid),"^",3)	
		}
	}
 	
 	s date1 = PRTDate
 	s time1 = PRTTime
 	q:((date1 = "")||(time1 = "")) ArealSpan
 	
 	s realSpan1 = ..WorkingTimeSpanToNow(date1, time1)
 	s realSpan1 = span1-realSpan1
 	if (realSpan1 < ArealSpan)
 	{	s ArealSpan = realSpan1}
 	if (ArealSpan < 0)
 	{s ArealSpan=0}
 	

 	
 	q ArealSpan
}

/// Desc:		根据EpisodeID判断总住院是否允许修改病历
/// Input:		AEpisodeID 就诊ID
/// OutPut: 	return=1:允许修改(初始状态), return=0:不允许修改(非初始状态), return<0:其他
/// Debug:      w ##Class(EMRservice.BOPrivAssist).EnableSubmitByMrStatus(76)
ClassMethod EnableSubmitByMrStatus(AEpisodeID)
{
	//New (AEpisodeID)
	Set return=-1
	Quit:AEpisodeID="" return
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(AEpisodeID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Set WorkItemID=objVol.SVStatus.%Id()
	Set return=1
	Set:WorkItemID'=1 return=0
	Quit return
}

/// Input:		AEpisodeID 就诊ID
/// OutPut: 	return=1:允许修改(初始状态), return=0:不允许修改(非初始状态), return<0:其他
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetVteEvalSheetReport(76)
ClassMethod GetVteEvalSheetReport(AEpisodeID) As %String
{
	s result = "0"
	try{
		set FacePayObj=##class(ws.EmrRecordImplPort).%New()
		d FacePayObj.Timeout(5)
		s result = FacePayObj.GetVteEvalSheetReport(AEpisodeID)
		if (result'="")
		{ 
			s result=$p(result,"<PathCount>",2)
			s result=$p(result,"</PathCount>",1)
		}
	}catch{
		s result = "0"
	}
	q result
}

/// Debug: 		w ##Class(EMRservice.BOPrivAssist).LastIPDept("157199","213")
ClassMethod LastIPDept(argEpisodeID As %String, AUserLoc As %String) As %String
{
  	s result=0
  	s LastDeptid=""
  	s LastDeptid=##Class(EMRservice.BL.opInterface).GetLastDeptid(argEpisodeID)
  	if (LastDeptid'=""){
  	s:(LastDeptid)=AUserLoc result=1 }
  	q result
}

/// w ##class(EMRservice.BOPrivAssist).HasVaildAdmInCTLoc(177319,127)
ClassMethod HasVaildAdmInCTLoc(AEpisodeID As %String, ACTLoc As %String) As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ACTLoc="") ret
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	q:(PapmiDR="") ret
	
	// ^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	s AdmType = ""
	For
	{
		s AdmType = $O(^PAPERdr(PapmiDR,"ADM",AdmType))
		q:(AdmType="")
		
		s Adm = ""
		For
		{
			s Adm = $O(^PAPERdr(PapmiDR,"ADM",AdmType,Adm),-1)
			q:(Adm="")
			
			s DisDept = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(Adm)
			s:($P(DisDept,"^",1)=ACTLoc) ret = 1
			
			s WardCode = $p($g(^CTLOC(ACTLoc)),"^",1)
			s DisWard = ##class(EMRservice.HISInterface.PatientInfoAssist).DisWard(Adm)
			s:($P(DisWard,"^",2)=WardCode) ret = 1
			
			q:(ret=1)
		}
	}
	
	q ret
}

/// w ##class(EMRservice.BOPrivAssist).IsAdmDep(177319,127)
ClassMethod IsAdmDep(Adm As %String, ACTLoc As %String) As %String
{
	s ret = 0
	q:(Adm="")||(ACTLoc="") ret
	
	s CTDesc = $P(^CTLOC(ACTLoc),"^",2)
	
	s TransDept = ##Class(EMRservice.HISInterface.PatientInfoAssist).TransDept(Adm)
	s length = $L(TransDept,"->")
	For i = 1:1:length
	{
		s DeptDesc = $P(TransDept,"^",i)
		continue:(DeptDesc="")
		
		s:(DeptDesc=CTDesc) ret = 1	
		q:(ret=1)
	}
	
	q ret
}

/// Desc:       护士是否已移交病案室
/// Creator:    Candy
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
/// Output:     result: 1--归档, 0--未归档
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetFinishStatus(76)
ClassMethod GetFinishStatus(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s status = ##class(MA.IPMR.IO.OutService).GetFinishStatus(argEpisodeID,"NI")
	s:(status = 1) result = "1"
	q result
}

/// w ##Class(EMRservice.BL.opInterface).GetPatLocs(154102)
ClassMethod GetPatLocs(Adm)
{
	q:(Adm="") ""
	
	s json = ##class(Nur.DHCNurInterface).getPatLocs(Adm)
	s rtnjson=##class(%DynamicObject).%New()
	s rtnjson=rtnjson.%FromJSON(json)
	
	s result = ""
	For i = 0:1:10
	{
		s rtnobj = rtnjson.%Get(i)
		q:(rtnobj="")
		
		s LocId=rtnobj.%Get("LocId")
		s LocDesc=rtnobj.%Get("LocDesc")
		s EndDateTime=rtnobj.%Get("EndDate")_" "_rtnobj.%Get("EndTime")
		
		s:(result'="") result = result_"!"
		s result = result_LocId_"^"_LocDesc_"^"_EndDateTime
	}
	q result
}

/// 登录用户是否为实习医生
/// w ##class(EMRservice.BOPrivAssist).IsSXDoc(15386)
ClassMethod IsSXDoc(AUserID As %String)
{
	s result = 0
	q:AUserID="" result
	s careRowid=""
	s careRowid=$P($g(^SSU("SSUSR",AUserID)),"^",14)
	s ctpcpRowid=""
	s:(careRowid'="") ctpcpRowid=$P($g(^CTPCP(careRowid,1)),"^",4)
	s doctype=""
	s:(ctpcpRowid'="") doctype = $P($g(^CT("CPT",ctpcpRowid)),"^",2)
	s:(doctype="实习医生") result=1
	q result
}

/// Desc:       今创是否加锁
/// Creator:    Candy
/// CreateDate: 2015-3-11
/// InPut:      argEpisodeID 就诊号
/// OutPut:     1已回收, 0未回收
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecordRetrieve(76)
ClassMethod GetEmrMark(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	s status = ##class(MA.IPMR.IO.OutService).GetEmrMark(argEpisodeID)
	s:(status = "B") result = 1
	q result
}

/// Desc:       今创是否解锁
/// Creator:    Candy
/// CreateDate: 2015-3-11
/// InPut:      argEpisodeID 就诊号
/// OutPut:     1已回收, 0未回收
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecordRetrieve(76)
ClassMethod GetEmrMarkNew(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID="304188") "1"
	
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	s status = ##class(MA.IPMR.IO.OutService).GetEmrMark(argEpisodeID)
	s:(status = "A") result = 1
	q result
}

/// Desc:       病案是否封存
/// Creator:    Candy
/// CreateDate: 2015-3-11
/// Input:      aEpisodeID : 就诊
/// Return：    封存未解封: 1^日期时间 ； 未封存或已解封：0
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetSealStatus(76)
ClassMethod GetSealStatus(argEpisodeID As %String, argInsntanceID As %String) As %String
{
	s result = "0"
	q:(argInsntanceID="")||(argEpisodeID="") result
	
	s SealDateTime = ##class(MA.IPMR.IO.OutService).GetSealDateTime(argEpisodeID)
	q:($P(SealDateTime,"^",1)=0) result
	
	s SealDateTime = $P(SealDateTime,"^",2)
	if (SealDateTime'="")
	{
		s SealDate = $ZDH($P(SealDateTime," ",1),3)
		s SealTime = $ZTH($P(SealDateTime," ",2))
	}
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(argInsntanceID)
	s CreateDate = objInstance.CreateDate
	s CreateTime = objInstance.CreateTime
	q:(CreateDate<SealDate) "1"
	q:(CreateDate=SealDate)&&(CreateTime<SealTime) "1"
	
	q result
}

/// Desc:       病历是否有有效签名(任何级别都可以)
/// Creator:　  yan
/// CreateDate: 2017-7-31
/// Input:      argInstanceID 病历实例ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMRservice.BOPrivAssist).HasValidSign("444995||1")
ClassMethod HasValidSignNew(argInstanceID As %String) As %String
{
	s result = "0"
	q:(argInstanceID = "") result
	s signID=""
	for 
	{
	    s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_argInstanceID, signID),-1)
	    q:(signID="")
	    s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
	    s:(sign.isSignValid="1") result = "1"
	    
	    q:(result = "1")
	}
	
	q result
}

/// Desc:       该科室是否为转科前科室，且当前科室是复苏室
/// Creator:　  Donglulu
/// CreateDate: 2017-7-31
/// Input:      argEpisodeID:病人就诊rowid   argLocID 当前用户科室ID
/// Output:     
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsTranToFSS(332)
ClassMethod IsTranToFSS(argEpisodeID As %String, argLocID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "") result
	
	s CurDept = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(argEpisodeID)
	q:(CurDept'["复苏室") result
	
	s result = ##Class(EMRservice.BOPrivAssist).IsTransPreviousCTLOC(argEpisodeID,argLocID)
	q result
}

/// Desc:       科室模板List
/// Creator:　  
/// CreateDate: 
/// Input:      
/// Output:     
/// Debug:      w ##Class(EMRservice.BOPrivAssist).InstanceList(332)
ClassMethod InstanceList(Adm As %String, DocIDList As %String) As %String
{
	q:(($d(Adm)=0)||(Adm="")||($TR(DocIDList,"^","")="")||(DocIDList="")) ""
	
	s InstanceIDList = ""
	s ValidInstanceIDList = "^"
	
    for iDocID=1:1:$Length(DocIDList,"^")
    {
        s DocID = $P(DocIDList,"^",iDocID)
        continue:(DocID="")
        
        s TheECRecord = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_Adm," "_DocID,""))
        continue:(TheECRecord="")
        
        s LisNo = ""
        For
        {
            s LisNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",TheECRecord,LisNo))
            q:(LisNo="")
	        s InstanceID = ""
            s InstanceID = TheECRecord_"||"_LisNo
            s InstanceID = $TR(InstanceID," ","")
            s objInstance = ##class(EPRinstance.InstanceData).%OpenId(InstanceID)
            continue:($IsObject(objInstance)=0)   // add by wep 20191202
            s status = objInstance.Status
            continue:(status'="Save")
			
            // 过滤因同一模板挂到两个界面展示下导致的数据重复
            s tempInstanceID = "^"_InstanceID_"^"
            continue:(ValidInstanceIDList[tempInstanceID)
            s ValidInstanceIDList = ValidInstanceIDList_"^"_tempInstanceID
            
            s:(InstanceIDList'="") InstanceIDList = InstanceIDList_"^"
            s InstanceIDList = InstanceIDList_InstanceID
            do objInstance.%Close()     // add by wep 2020/01/03
        }
    }
    
	q InstanceIDList
}

/// Desc:       患者状态
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetAdmStatus(76)
ClassMethod GetAdmStatus(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID="") result
	
	s admstatus = $p($G(^PAADM(argEpisodeID)),"^",20)
	s:(admstatus="D") result = "1"
	
	q result
}

/// Desc:       24小时内是否存在有效的权限申请
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetAppointinfo(1228589)
ClassMethod GetAppointinfo(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID="") result
	
	s rowid = ""
	s rowid = $O(^DHCEMRI.AuthAppointI("IdxEpisode"," "_argEpisodeID,""),-1)
	q:(rowid="") result
	
	s appointdate = $ListGet(^DHCEMRI.AuthAppointD(rowid),6)
	s appointtime = $ListGet(^DHCEMRI.AuthAppointD(rowid),7)
	
	s:(+$H-appointdate<2) result = "1"
	
	q result
}

/// Desc:       患者是否保存过旧病案首页、病案附页
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetSaveStatusOld(76)
ClassMethod GetSaveStatusOld(Adm As %String) As %String
{
	s ret = 0
	q:(Adm = "") ret
	
	s InstanceIDStr = ##Class(EMRservice.BL.opInterface).GetValidInstanceIDList(Adm,"52^246")
	s:(InstanceIDStr'="") ret = 1
	
	q ret
}

/// Desc:       患者是否保存过新病案首页
/// Debug:      w ##Class(EMRservice.BOPrivAssist).GetSaveStatusNew(76)
ClassMethod GetSaveStatusNew(Adm As %String) As %String
{
	s ret = 0
	q:(Adm = "") ret
	
	s InstanceIDStr = ##Class(EMRservice.BL.opInterface).GetValidInstanceIDList(Adm,"3779")
	s:(InstanceIDStr'="") ret = 1
	
	q ret
}

/// w ##Class(EMRservice.BOPrivAssist).IsAdmDoctor()
ClassMethod IsAdmDoctor(Adm As %String, AUserID As %String) As %String
{
	s ret = 0
	q:(Adm="")||(AUserID="") ret
	
	s AdmDoctor = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(Adm)
	q:(AdmDoctor="") ret
	s AdmDoctorCode = $P(AdmDoctor,"^",2)
	
	s UserCode = $p($g(^SSU("SSUSR",AUserID)),"^",1)
	s:(AdmDoctorCode=UserCode) ret = 1
	
	q ret
}

/// w ##Class(EMRservice.BOPrivAssist).GetCategoryID(52)
ClassMethod GetCategoryID(ADocID As %String)
{
   s ret=""
   q:(ADocID="") ""
   
   s ParentCategoryID = $List(^DHCEMRM.EMRTemplateCategoryD(ADocID),4)
   q:(ParentCategoryID="") ""
   
   s CategoryID = $List(^DHCEMRM.EMRTemplateCategoryD(ParentCategoryID),4)
   
   q CategoryID
}

/// Desc:       有效签名数量
/// Creator:　  yan
/// CreateDate: 2021-12-22
/// Input:      argInstanceID 病历实例ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##class(EMRservice.BOPrivAssist).GetInstanceSignList("24027||4")
ClassMethod GetInstanceSignList(AInstanceID As %String) As %String
{
	s result=0
    q:(AInstanceID = "") "0"

	s retList=""
	s ecrecordID = +$g(AInstanceID)
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecrecordID)	
	s chartItemID = objECRecord.ChartItemID
	s EpisodeID = objECRecord.EpisodeID
	s num = $p(AInstanceID,"||",2)
	s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	
	s action = ""
	for
	{
		s action = $o(^DHCEMRI.EMRSignI("IdxMain"," "_EpisodeID," "_chartItemID," "_num,action))
		
		q:(action = "")
		if (revokeSign = "N")
		{
			//s retList=retList_$lb($e(action,2,*))
                        s result=result+1
		}
		else
		{
			s sign =""
			for 
			{
			    s sign = $o(^DHCEMRI.EMRSignI("IdxMain"," "_EpisodeID," "_chartItemID," "_num,action,sign))
			    
			    q:(sign = "")
			    s objSign = ##Class(EMRinstance.EMRSign).%OpenId(sign)
			    continue:(objSign = "")
			    continue:(objSign.isSignValid '= "1")
			    //s retList=retList_$lb($e(action,2,*))
                            s result=result+1
			}
		}
	}
	q result
}

/// Desc:	判断是否会诊医生 		
/// 		w ##class(EMRservice.BOPrivAssist).IscoustUserNew(2178,1796)	
ClassMethod IscoustUserNew(APatientID As %String, UserID As %String)
{
	q:((APatientID="")||(UserID="")) 0
    s ret="0"
	s tmpEpisodeID = $o(^PAPERdr(APatientID, "ADM", "I", ""),-1)
	q:(tmpEpisodeID = "") ret
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(tmpEpisodeID)
	Set retconst = ##Class(%ResultSet).%New("web.DHCEMConsInterface:QryPatConsList")
	Set sc = retconst.Execute(tmpEpisodeID)
	While (retconst.Next()) 
	{
		s CsUserid=retconst.CsUserID
		if (CsUserid=UserID)
		{
			s ret =1
			q
		}
	}
	q ret
}

/// Desc:    患者出院科室ID
/// InPut:   argEpisodeID 就诊日期
///          
/// Output： result "
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetDisLocID(2)
ClassMethod GetDisLocID(argEpisodeID As %String) As %String
{
	s result = ""
	q:(argEpisodeID = "") ""
	q:(($d(^PAADM(argEpisodeID)) '= 1)&&($d(^PAADM(argEpisodeID)) '= 11)) result
	
	s result=$P($g(^PAADM(argEpisodeID)),"^",4)
	
	q result
}

/// Desc:    出院日期 根据类型取出出院日期
/// InPut:   argEpisodeID 就诊日期
///          argType 出院日期类型 "ByDoctor"医生医疗结算，"ByNurse"护士最终结算
/// Output： result "" 没出院,YYYY-MM-DD出院日期格式
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetDisDate2021(30000004,"ByNurse")
ClassMethod GetDisDate2021(argEpisodeID As %String, argType As %String) As %String
{
	s result = ""
	q:((argEpisodeID = "")||(argType = "")) ""
	q:(($d(^PAADM(argEpisodeID)) '= 1)&&($d(^PAADM(argEpisodeID)) '= 11)) result
	s dischgdate = "",dischgdate1 = "",dischgdate2 = ""
	//护士最终结算
	if (argType = "ByNurse")
	{
		s dischgdate1 = $P($G(^PAADM(argEpisodeID)),"^",17)
	}
	//医生医疗结算
	elseif (argType = "ByDoctor")
	{
		s dischgdate2 = $P($G(^PAADM(argEpisodeID)),"^",59)
	}
	s:(dischgdate1 '= "") result = dischgdate1
	s:(dischgdate1 = "")&&(dischgdate2 '= "") result = dischgdate2
	//s result = dischgdate1
	q result
}

/// 判断病历是否书写（根据保存）
/// 返回值 1：是   0:否  入参 就诊号
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetSaveInfo("52","")
ClassMethod GetSaveInfo(argEpisodeID As %String, argTemplateID As %String) As %String
{
	s result = 0
	s HappenDate = 0
	for
	{
		s HappenDate = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate))
		q:(HappenDate = "")
		
		s HappenTime = ""
		for
		{
			s HappenTime = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime))
			q:(HappenTime = "")
			
			s TheECRecord = ""
			for
			{
				s TheECRecord = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord))
				q:(TheECRecord = "")
				
				s ListNo = ""
				for
				{
					s ListNo = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord,ListNo))
					q:(ListNo = "")
					
					s InstanceDataID = TheECRecord_"||"_ListNo
					s InstanceObj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
					s TemplateID = InstanceObj.TemplateID

					if (TemplateID=argTemplateID)
					{
						s result = 1
					}
				}
			}
		}
	}
	q result
}

/// Desc:用户是否是科主任
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsDepartmentHeader("2646","6")
ClassMethod IsDepartmentHeader(admid As %String, argUserID As %String)
{
	s ret=0
	q:(admid="")||(argUserID="") ret	
	s DepHeaderID=""
	s DepHeaderID=..GetDepartmentHeader(admid)	
	s:(DepHeaderID=argUserID) ret=1
	q ret
}

/// ///////////////////////////////////////////////////////////
/// 诊断绑定取值 End
/// ///////////////////////////////////////////////////////////
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetDepartmentHeader("71")
ClassMethod GetDepartmentHeader(AEpisodeID As %String) As %String
{
	s ret=""
	q:(AEpisodeID="") ret
	s temp=..DisDept(AEpisodeID)
	//获取出院科室ID
	s DischLocID= $p(temp,"^",1)
	//取出院科室的科主任
	q:(DischLocID="") ret	
	s DischLocInfo=$g(^CTLOC(DischLocID))
	s DepHeaderID=$p(DischLocInfo,"^",54)
	q DepHeaderID
}

/// Desc: 	出院科室(即当前科室)【RowId^Code^Desc】
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
/// Debug: w ##Class(EMRservice.BOPrivAssist).DisDept("1391")
ClassMethod DisDept(argAdmId As %String) As %String
{
	q:(argAdmId="") ""
	
	s DeptCode="",DeptDesc="",dischgDeptDR="",dischgDept=""
	
	s dischgDeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	if dischgDeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(dischgDeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(dischgDeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s dischgDept=dischgDeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	q dischgDept
}

/// 判断该科室转出是否超过6小时
/// 1:不超过6小时  0超过6小时
/// w ##class(EMRservice.BOPrivAssist).GetTransTimeToLoc(32784387,209)
ClassMethod GetTransTimeToLoc(adm, LocDr) As %String
{
	s ret="0"
	s timecount=""
	s ID="" f  s ID=$o(^Nur.Data.TransRecordI("TransType"," "_adm," L",ID),-1) q:((ID="")||(timecount="1"))  d
	.s OrigLocID=$list(^Nur.Data.TransRecordD(ID),4)  //转出科室
	.q:OrigLocID'=LocDr
	.s DataState=$list(^Nur.Data.TransRecordD(ID),15)  //转科状态
	.q:DataState'="N"
	.s TransDate=$list(^Nur.Data.TransRecordD(ID),12) //转科日期
	.q:TransDate=""
	.s TransTime=$list(^Nur.Data.TransRecordD(ID),13)  //转科时间
	.q:TransTime=""
	.s CurrDate=$p($h,",",1)
	.s CurrTime=$p($h,",",2)
	.s TransDateTime=TransDate*24*60*60+TransTime
	.s CurrDateTime=CurrDate*24*60*60+CurrTime
	.s countDateTime=CurrDateTime-TransDateTime
	.i ((countDateTime>="0")&&(countDateTime<=21600)) s timecount="1"
	i timecount="1" s ret="1"
	q ret
}

/// Desc:		转科6小时内自动授权
/// Creator: 	Candy
/// CreateDate:	2015-3-11
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 是 ， 0 否
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsPatBelongToZKQLoc(962512)
ClassMethod IsPatBelongToZKQLoc(argPatEpisodeID As %String, argLocID As %String) As %String
{
	s ret="0"
	s currentLoc = ""
	s currentLoc = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
	q:(currentLoc = "") "0"
	
	q:($p(currentLoc,"^",1)=argLocID) "0"
	
	s ret=..GetTransTimeToLoc(argPatEpisodeID,argLocID)
	q ret
}

/// Desc:取患者当前就诊科室id
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetUserLocType(userloc)
ClassMethod GetUserLocType(userloc As %String)
{
	s ret="0"
	s ADMLOCRowId=""
	s LocType = $p($g(^CTLOC(userloc)),"^",13) 
	s ADMLOCRowId = $o(^PAC("ADMLOC",0,"AdmType","O",userloc,ADMLOCRowId)) 
	s:ADMLOCRowId="" ADMLOCRowId = $o(^PAC("ADMLOC",0,"AdmType","E",userloc,ADMLOCRowId)) 
	i ((LocType="E")&&(ADMLOCRowId'="")) s ret="1"
	q ret
}

/// Desc:在院患者并且当前科室一致
/// Debug: w ##Class(EMRservice.BOPrivAssist).IsCurrAdm(userloc)
ClassMethod IsCurrAdm(APatientID As %String, argLocID As %String)
{
	s ret="0"
	s tmpEpisodeID = $o( ^PAPERdr(APatientID, "ADM", "I", ""),-1)
	q:(tmpEpisodeID = "") ret
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(tmpEpisodeID)
	s PAADMDepCodeDR=$p($g(^PAADM(tmpEpisodeID)),"^",4)
	s:((PAADMDepCodeDR=argLocID)&&(disDateTime = "")) ret="1"
	q ret
}

/// 判断医生提交的状态
/// Output:     
ClassMethod IsDisOut(argadmid As %String) As %String
{
    s result = "0"
    q:(argadmid = "") ""
	//s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argadmid)

	s Estimdischgdate=$P($G(^PAADM(argadmid)),"^",59)
	s Estimdischgtime=$P($G(^PAADM(argadmid)),"^",60)
	s:(Estimdischgdate '= "") result = "1"
	q result
}

/// Output:     
ClassMethod GetMRStatus(argadmid As %String) As %String
{
    s result = "0"
    q:(argadmid = "") ""
	s disDateTime = ##Class(DHCEPRFS.BL.BLMRLog).GetLastStatus(argadmid)
	s:(disDateTime = "病案复核") result = "1"
	s:(disDateTime = "质控退回") result = "2"
	q result
}

/// 根据签名判断病历是否书写(根据签名) 返回值1  0
/// Debug: w ##Class(EMRservice.BOPrivAssist).GetSignInfo("52","")
ClassMethod GetSignInfo(argEpisodeID As %String, argTemplateID As %String) As %String
{
	s result = 0
	s HappenDate = 0
	for
	{
		s HappenDate = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate))
		q:(HappenDate = "")
		
		s HappenTime = ""
		for
		{
			s HappenTime = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime))
			q:(HappenTime = "")
			
			s TheECRecord = ""
			for
			{
				s TheECRecord = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord))
				q:(TheECRecord = "")
				
				s ListNo = ""
				for
				{
					s ListNo = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_argEpisodeID," SAVE",HappenDate,HappenTime,TheECRecord,ListNo))
					q:(ListNo = "")
					
					s InstanceDataID = TheECRecord_"||"_ListNo
					s InstanceObj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
					s TemplateID = InstanceObj.TemplateID
					s signID=""

					if (TemplateID=argTemplateID)
					{
						for {
	    					s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_InstanceDataID, signID),-1)
	   					q:(signID="")
	    					s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
	    					s:(sign.isSignValid="1") result = "1"	    		
						}
					}
				}
			}
		}
	}
	q result
}

/// Desc: 	病人是否就诊过该科室
/// Modify: Candy
/// Input: 	argPatEpisodeID 就诊号
/// 			argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).IsBelongAdmToLoc(76,6)
ClassMethod IsBelongAdmToLoc(argPatientID As %String, argLocID As %String) As %String
{
	q:(argPatientID = "")||(argLocID = "") "0"

	s type = ""
	s result = "0"
	for
	{
		s type = $o(^PAPERdr(argPatientID,"ADM",type))
		q:(type = "")
		s episodeID = ""
		for
		{
			s episodeID = $o(^PAPERdr(argPatientID,"ADM",type,episodeID))
			q:(episodeID = "")	
			
			s Admloc =##class(EMRservice.BOPrivAssist).GetAdmLocID(episodeID)
			
			s:(Admloc=argLocID) result="1"
			q:(result = "1") 
		}
		q:(result = "1")
	}

	q result
}

/// Desc: 		是否住院病人
/// Input：		argPatEpisodeID：病人就诊rowid
/// Output：	0:否 1：是
/// CreateTime：2009-08-03 
ClassMethod IsInPatient(argPatEpisodeID As %String) As %String
{
	s RetType = "0"
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s:(PatientType="I") RetType="1"
	q RetType
}

/// Desc: 		是否急诊病人
/// Input：		argPatEpisodeID：病人就诊rowid
/// Output：	0:否 1：是
/// CreateTime：2009-08-03 
ClassMethod IsEnsPatient(argPatEpisodeID As %String) As %String
{
	s RetType = "0"
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s:(PatientType'="O")&&(PatientType'="I") RetType="1"
	q RetType
}

/// Desc:       病案室是否已经编目
/// Creator:    Zhou
/// CreateDate: 2021-08-19
/// Input:      argEpisodeID 就诊号
/// Output:     result: 1--归档, 0--未归档
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsRecordArchived(76)
ClassMethod IsRecordCatalogued(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s status = ##class(MA.IPMR.IO.OutService).GetFinishStatus(argEpisodeID,"FP")
	s:(status = 1) result = "1"
	q result
}

/// Desc:       病案是否上传
/// Creator:    XH
/// CreateDate: 2021-08-23
/// Input:      argEpisodeID 就诊号
/// Output:     result: 1--上传, 0--未上传
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsGetUpStatus(20273227)
ClassMethod IsGetUpStatus(argEpisodeID As %String) As %String
{
	//q "0"
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s status = ##class(MA.IPMR.IO.OutService).GetUpStatus(argEpisodeID,"")
	s:(status = 1) result = "1"
	q result
}

/// Desc:       是否为创建者的上级医师（取his的维护程序，不分医疗组）
/// Creaotr:    Donglulu
/// CreateDate: 2020-11-2 
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsUpUserChecked(846,"1849||2",17276)
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsUpUserChecked(871,"1288||1",18881)
ClassMethod IsUpUserChecked(argEpisodeID As %String, argInstanceID As %String, argUserID As %String) As %String
{
	s ret = "0",UserLevel="",currentLog="",objInstance=""
	q:(argEpisodeID = "")||(argInstanceID = "")||(argUserID = "") ret
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	
	q:(objInstance = "") ret
	s UserLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(argUserID)
	
	q:(UserLevel = "") ret
	s UserLevel = $P(UserLevel,"^",1)
	s currentLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(argEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo)
	
	q:(currentLog = "") ret
	
	q:(currentLog.EMRStatus = "") ret
	q:(currentLog.EMRStatus = "unfinished") ret
	
	q:'($zcvt(currentLog.EMRStatus,"U")[ "CHECKED") 0
	
	if (UserLevel="student") {
		s:(currentLog.EMRStatus="attendingChecked")||(currentLog.EMRStatus="residentChecked")||(currentLog.EMRStatus="chiefChecked")||(currentLog.EMRStatus="viceChiefChecked") ret=1	
	}elseif (UserLevel="Resident"){
		s:(currentLog.EMRStatus="chiefChecked")||(currentLog.EMRStatus="viceChiefChecked")||(currentLog.EMRStatus="attendingChecked") ret=1
	}elseif (UserLevel="Attending"){
		s:(currentLog.EMRStatus="chiefChecked")||(currentLog.EMRStatus="viceChiefChecked") ret=1
	}elseif (UserLevel="Chief")||(UserLevel="ViceChief"){
		s ret =0
	}else{
		s ret =0
	}
	q ret
}

/// 获取医生级别
/// w ##Class(EMRservice.BOPrivAssist).GetDocLevel(25137,74)
ClassMethod GetDocLevel(AUserid As %String, AUserloc As %String)
{
	s ret=0
	q:(AUserid="")||(AUserloc="") ret
	s Initials =$p($g(^SSU("SSUSR",AUserid)),"^",1)
	q:(Initials="") ret
	s ret = ##class(web.DHCBL.CT.RBResource).GetRESMedRecordLevel(Initials,AUserloc)
	s:(ret="") ret=0
	q ret
}

/// w ##Class(EMRservice.BOPrivAssist).GetCreatorLevel(110,"62||1")
/// 获取病历创建者医生级别
ClassMethod GetCreatorLevel(AEpisodeID As %String, AInstanceId As %String)
{
   s ret = 0
   q:(AInstanceId = "")||(AEpisodeID = "") ret
   s ecID = $p(AInstanceId,"||",1)
   s chartItem = $listget($g(^DHCEMRI.ECRecordD(ecID)),4)
   q:(chartItem="") ret
   //^DHCEMRI.EMRLogsI("IdxMain"," 110"," 58",1,32)=""
   s EMRNum=$p(AInstanceId,"||",2)
   s UserLoginLocID = ""
   s OperateUserID = ""
   s logId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_AEpisodeID," "_chartItem,EMRNum,""))
   q:(logId="") ret
   //^DHCEMRI.InstanceLogI("IdxParRef",38)
   s num=""
   for {
	   s num = $o(^DHCEMRI.InstanceLogI("IdxParRef",logId,num))
	   q:(num="")
	   s ID = logId_"||"_num
	   s obj = ##class(EMRinstance.InstanceLog).%OpenId(ID)
	   continue:(obj="")||(obj.FinalStatus'="finished")
	   s UserLoginLocID = obj.UserLoginLocID
	   s OperateUserID = obj.OperateUserID
	   q:(OperateUserID'="")
	}
   s ret = ..GetDocLevel(OperateUserID,UserLoginLocID)
   q ret
}

/// 获取最后一次签名用户的签名级别
/// w ##Class(EMRservice.BOPrivAssist).GetLastSignerLevel(20289167,"239938||1")
ClassMethod GetLastSignerLevel(AEpisodeID, AInstanceId As %String)
{
   s ret = 0
   q:(AInstanceId = "") ret
   s ecID = $p(AInstanceId,"||",1)
   s chartItem = $listget($g(^DHCEMRI.ECRecordD(ecID)),4)
   q:(chartItem="") ret
   //^DHCEMRI.EMRLogsI("IdxMain"," 110"," 58",1,32)=""
   s EMRNum=$p(AInstanceId,"||",2)
   s UserLoginLocID = ""
   s OperateUserID = ""
   s logId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_AEpisodeID," "_chartItem,EMRNum,""))
   q:(logId="") ret
   //^DHCEMRI.InstanceLogI("IdxParRef",38)
   s num=""
   for {
	   s num = $o(^DHCEMRI.InstanceLogI("IdxParRef",logId,num),-1)
	   
	   q:(num="")
	   s ID = logId_"||"_num
	  
	   s obj = ##class(EMRinstance.InstanceLog).%OpenId(ID)
	   
	   
	   
	   continue:(obj="")||(obj.FinalStatus'["Checked")
	   
	   s UserLoginLocID = obj.UserLoginLocID
	   s OperateUserID = obj.OperateUserID
	   q:(OperateUserID'="")
	}
	s num1=""
	 for {
	   s num1 = $o(^DHCEMRI.InstanceLogI("IdxParRef",logId,num1))
	   q:(num1="")
	   s ID1 = logId_"||"_num1
	   s obj1 = ##class(EMRinstance.InstanceLog).%OpenId(ID1)
	   s FinalStatus = obj1.FinalStatus

	} 
	if (FinalStatus="checkedRevision"){
		s UserLoginLocID=""
		s OperateUserID=""
	}
	
   s ret = ..GetDocLevel(OperateUserID,UserLoginLocID)
   q ret
}

/// 获取病人的就诊科室
/// w ##Class(EMRservice.BOPrivAssist).GetAdmLocID()
ClassMethod GetAdmLocID(AEpisodeID As %String) As %String
{
   s ret=""
   q:(AEpisodeID="") ret
   s tmpAdmDept = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID,"")  
   s ret = $p(tmpAdmDept,"^",1)
   q ret
}

/// Desc:      判断是否为转科前科室
/// Creator:   XH
/// CreatDate: 2020-06-16
/// Input:     argInstanceID 实例ID,argUserID 用户ID
/// Output:    0/1/2/3...
/// Debug:     w ##Class(EMRservice.BOPrivAssist).IsTransDept("20329616","245")
ClassMethod IsTransDept(argEpisodeID As %String, argLocID As %String)
{
	
	q:((argEpisodeID = "")||(argLocID = "")) "0"
	
	s result = "0"
	s TransDesc ="",LocDesc=""
	
	s LocDesc = $p($g(^CTLOC(argLocID)),"^",2)	
	s iTransDept=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDept(argEpisodeID)
	s Count=$l(iTransDept, "->")
	s i=1

	for iflag=1:1:Count{
		s TransDept = $p(iTransDept, "->",i)
		s i=i+1
		
		s:(TransDept=LocDesc) result = "1" 
		q:(TransDept=LocDesc) 
		;s:(TransDesc '="") TransDesc=TransDesc_"^"_TransDept
		;s:(TransDesc ="") TransDesc=TransDept
	}
	q result
}

/// 是否绿色通道
ClassMethod IsGreenRec(AEpisodeID As %String)
{
  s ret= 0
  q:(AEpisodeID="") ret
  s ret = ##class(web.DHCEMInterfaceCom).CheckGreenRec(AEpisodeID)
  q ret
}

/// /转科时间是否超24小时
ClassMethod IsTransOver24Hours(AEpisodeID As %String, AUserloc As %String) As %String
{
  s ret = 0
  q:(AEpisodeID="")||(AUserloc="") ret
  s TransLocInfo = ##class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(AEpisodeID,"")
  q:((TransLocInfo="")||(TransLocInfo="无")||(TransLocInfo="-")) ret
  for i=1:1:$l(TransLocInfo,"->")
  {
	s tmpLocInfo = $p(TransLocInfo,"->",i)
	continue:((tmpLocInfo="-")||(tmpLocInfo=""))
	s transDate = $p(tmpLocInfo,"^",3)
	s transTime = $p(tmpLocInfo,"^",4)
	s transLocID = $p(tmpLocInfo,"^",1)
	continue:(transLocID'=AUserloc)
	s CurDate = $p($h,",",1)
	s CurTime = $p($h,",",2)
	s day = CurDate - transDate
	s time = CurTime - transTime
	s Hours = day*24+time/3600
	if (Hours>24) {
      s ret = 1
      q
    }
  }
  q ret
}

/// /患者是否为体检患者
ClassMethod IsAdmTypeH(AEpisodeID As %String) As %String
{
  s ret = 0
  q:(AEpisodeID="") ret
  s AdmType=$p($g(^PAADM(AEpisodeID)),"^",2)
  s:(AdmType="H") ret=1
  q ret
}

/// 病历创建时间是否超24小时
/// w ##Class(EMRservice.BOPrivAssist).IsCreate24Hours()
ClassMethod IsCreate24Hours(AInstanceId As %String) As %String
{
  s ret = 0
  q:(AInstanceId="") ret
  s objinstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceId)
  
  q:(objinstance="")||(objinstance.Status'="Save") ret
  s CreateDate =objinstance.CreateDate
  s CreateTime =objinstance.CreateTime
  s CurDate = $p($h,",",1)
  s CurTime = $p($h,",",2)
  s day = CurDate - CreateDate
  s time = CurTime - CreateTime
  s Hours = (day*24)+(time/3600)
  b
  if (Hours>24) {
     s ret = 1
  }
  
  q ret
}

/// 病历创建时间是否0点
/// w ##Class(EMRservice.BOPrivAssist).IsOver0Hours()
ClassMethod IsOver0Hours(AInstanceId As %String) As %String
{
  s ret = 0
  q:(AInstanceId="") ret
  s objinstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceId)
  q:(objinstance="")||(objinstance.Status'="Save") ret
  s CreateDate =objinstance.CreateDate
  s CreateTime =objinstance.CreateTime
  s CurDate = $p($h,",",1)
  s CurTime = $p($h,",",2)
  s day = CurDate - CreateDate
  if (day>0)&&(CurTime>0){
  	s ret = 1
  }
  q ret
}

/// 当前登录用户 是否是当前签名人
/// w ##Class(EMRservice.BOPrivAssist).GetLastSignerUserid(22498541,"2034398||1","25137")
ClassMethod GetLastSignerUserid(AEpisodeID, AInstanceId As %String, userid As %String)
{
   s ret = 0
   q:(AInstanceId = "") ret
   s ecID = $p(AInstanceId,"||",1)
   s chartItem = $listget($g(^DHCEMRI.ECRecordD(ecID)),4)
   q:(chartItem="") ret
   s EMRNum=$p(AInstanceId,"||",2)
   s UserLoginLocID = ""
   s OperateUserID = ""
   s logId = $o(^DHCEMRI.EMRLogsI("IdxMain"," "_AEpisodeID," "_chartItem,EMRNum,""))
   q:(logId="") ret
   s num=""
  
   for {
	   s num = $o(^DHCEMRI.InstanceLogI("IdxParRef",logId,num),-1)
	   q:(num="")
	   s ID = logId_"||"_num
	   s obj = ##class(EMRinstance.InstanceLog).%OpenId(ID)
	   continue:(obj="")||(obj.FinalStatus'["Checked") 

	   s UserLoginLocID = obj.UserLoginLocID
	   s OperateUserID = obj.OperateUserID
	   q:(OperateUserID'="")
	}
	
	s num1=""
	 for {
	   s num1 = $o(^DHCEMRI.InstanceLogI("IdxParRef",logId,num1))
	   q:(num1="")
	   s ID1 = logId_"||"_num1
	   s obj1 = ##class(EMRinstance.InstanceLog).%OpenId(ID1)
	   s FinalStatus = obj1.FinalStatus

	} 
	
	if (FinalStatus="checkedRevision"){
		s UserLoginLocID=""
		s OperateUserID=""
	}
	q:(OperateUserID="") ret
	
	s:(OperateUserID'=userid) ret=1
	q ret
}

/// 是否存在有效未完成的会诊
ClassMethod IsHaveValidCon(AEpisodeID As %String, AUserLocID As %String)
{
	s ret=0
	/*
	/// Descript: 【电子病历权限管理方案】
	为电子病历组提供是否到本科室的有效会诊的函数，入参就诊ID、登录科室，
	出参：1存在有效会诊，2无会诊 3会诊已完成 /// 
	InPut: 就诊ID、登录科室 /// 
	OutPut: 1:存在有效会诊，2:无会诊 3:会诊已完成 
	*/
	s validConfFlag = ##Class(web.DHCEMConsInterface).GetValidConFlag(AEpisodeID,AUserLocID)
	s ret=$case(validConfFlag,1:1,:0)
	q ret
}

/// /##class(EMRservice.BOPrivAssist).GetInsIdByChartID(50134216)
ClassMethod GetInsIdByChartID(argEpisodeID As %String, argChartItemID As %String = "380^381^1022")
{
  q:(argEpisodeID="") "ERROR"
  s len=$l(argChartItemID,"^")
  s insID=""
  for i=1:1:len {
    s ChartItemID=$p(argChartItemID,"^",i)
    s ecrecordId=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_argEpisodeID," "_ChartItemID,""))
    continue:(ecrecordId="") 
    s strInstancID=""
    s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
    s strInstancID = ""
    S key = ""
    s key = objECRecord.Instances.Count()+1 
    do
    {           
        s objInstanceData = objECRecord.Instances.GetPrevious(.key)
        if (objInstanceData '= "")
        { 
             continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
             s insID = objInstanceData.%Id()
             q:(insID'="")
        } 
    }while (key '="") 
    q:(insID'="")
  }
  q insID
}

/// 处理指定科室组相关用户，才放开相应的权限。
/// 需要设定相关科室后启用
ClassMethod IsSpecialLocGroup1(AUserLocID As %String) As %String
{
	s ret=0
	//设置指定科室组中的相关科室ID
	s SpecialLocGroup1=##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SpecialLocGroup1","")
	q:(SpecialLocGroup1="") ret
	
	s thisUserLocID = "^"_AUserLocID_"^"
	s:(SpecialLocGroup1[thisUserLocID) ret=1
	
	q ret
}

/// 处理指定科室组相关用户，才放开相应的权限。
/// 需要设定相关科室后启用
ClassMethod IsFinishFirstDispatchBed(AEpisodeID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="") ret
	s ret = ##class(Nur.Interface.OutSide.Patient).IfFinishFirstDispatchBed(AEpisodeID)
	q ret
}

/// Desc: 	病历最后一次有效操作(签名、保存)的科室是否与当前登录科室一致
/// create: lifengbo
/// Input: 	AEpisodeID 就诊号
/// 		AInstanceID 实例ID
/// 		AUserLocID 科室ID
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).IsSameLocLogUserAndInstance(7932,"2438||1",221)
ClassMethod IsSameLocLogUserAndInstance(AEpisodeID As %String, AInstanceID As %String, AUserLocID As %String) As %String
{
	s ret=0
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s emrdocid = objInstance.TheECRecord.RealChartItemID
	//从log表获取
	s emrnum = $p(AInstanceID,"||",2)
    s emrlogsid = $o(^DHCEMRI.EMRLogsI("IdxMain",objInstance.EpisodeID.%Id(),emrdocid,emrnum,""))
    
	s objEmrLogs = ##Class(EMRinstance.EMRLogs).%OpenId(emrlogsid)
	s instancelogs = objEmrLogs.InstanceLog
	S key = ""
	s key = instancelogs.Count()+1		
	do
	{ 			
		s objInstanceLog = instancelogs.GetPrevious(.key)
		if (objInstanceLog '= "")
		{ 
			//依据最后一次
			
			 continue:'(($zcvt(objInstanceLog.Action,"U")["CHECK")||($zcvt(objInstanceLog.Action,"U")="SAVE"))
			 s:(objInstanceLog.UserLoginLocID'=AUserLocID) ret = -1
			 q:(ret = -1)
		} 
		
	} 
	while (key '="")
	s:(ret'=-1) ret= 1
	q ret
}

/// /// Desc: 	当前在院就诊是否术语(IsCurAdmBelongToLocForBrowse)
/// /// Modify: lifengbo
/// /// Input: 	AEpisodeID 就诊号
/// /// 		AUserLocID 科室ID
/// /// OutPut: 1是,0否
/// /// Debug: 	w ##Class(EMRservice.BOPrivAssist).IsCurAdmBelongToLocForBrowse(7667,221)
ClassMethod IsCurAdmBelongToLocForBrowse(AEpisodeID As %String, AUserLocID As %String = "") As %String
{
	q:(AEpisodeID="")||(AUserLocID="") 0
	
	s PatientID= +$g(^PAADM(AEpisodeID))
	s tmpEpisodeID = ""
	
	s admType = ""
	for
	{
		s admType = $o(^PAPERdr(PatientID,"ADM",admType))
		q:(admType = "")
		s tmpEpisodeID = ""
		for
		{
			s tmpEpisodeID = $o(^PAPERdr(PatientID,"ADM",admType,tmpEpisodeID),-1)
			q:(tmpEpisodeID="")
			
			s VisitStatus = $p(^PAADM(tmpEpisodeID),"^",20)
			continue:(VisitStatus'="A")
			
			s AdmDate = $p(^PAADM(tmpEpisodeID),"^",6)
			
			if (admType'="I")
			{
				continue:((+$h-AdmDate)>1)
			}
			
			s TempSeqEpisodeID(AdmDate)=tmpEpisodeID
		}
	}
	
	//按照就诊时间进行排序，取最后就诊日期的就诊号
	s lastdate = $o(TempSeqEpisodeID(""),-1)
	q:(lastdate="") 0

	s EpisodeID = TempSeqEpisodeID(lastdate)
	q:(EpisodeID="") 0
	s currentLoc = ""
	s currentLoc = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(EpisodeID)
	q:(currentLoc = "") "0"
	q:($p(currentLoc,"^",1)=AUserLocID) "1"
	
	//病历转移科室应该也是当前科室
	s getappointdept = ""
	s getappointdept = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(EpisodeID)
	q:(getappointdept=AUserLocID) "1"	
	q "0"
}

/// Desc: 	最近一次科室会诊时间
/// lifengbo
/// Modify: 
/// Input: 	argPatEpisodeID 就诊号
/// 			argLocID 科室ID
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).GetLastConHoursc(76,6)
ClassMethod GetLastConHours(EpisodeID As %String, UserLocID As %String = "") As %String
{
	s ret=""
	q:(EpisodeID="")||(UserLocID="") ret
	s isExist =##Class(EMRservice.BOPrivAssist).IsExistMethod("web.DHCEMConsInterface","GetHoursSinceLast")
	q:(isExist=0) ret
	s hours=""
	s hours = ##Class(web.DHCEMConsInterface).GetHoursSinceLast(EpisodeID,UserLocID)
	q hours
}

/// Desc: 	门诊是否在有效期内
/// lifengbo
/// Modify: 
/// Input: 	AEpisodeID 就诊号
/// 	
/// OutPut: 1有效中,0忽略配置,-1不在有效期内
/// Debug: 	w ##Class(EMRservice.BOPrivAssist).GetOPInValidityPeriod(76)
ClassMethod GetOPInValidityPeriod(AEpisodeID As %String) As %String
{
	s ret=0
	s admType = $p(^PAADM(AEpisodeID),"^",2)
	q:(admType '= "O") ret
	// -1/0/1^描述:异常/没有超出/超出^描述
	s ifret = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.opadm.CheckAdmLimitDay", AEpisodeID)
	s ret=$case(+ifret,0:"1",1:"-1",-1:"0",:"0")
	q ret
}

/// Desc:       是否为知情同意书
/// Creator:　  lifengbo
/// CreateDate: 2020-05-13
/// Input:      ADocID  
/// Output:     result 0 非知情同意书 1 知情同意书
/// Debug:      w ##Class(EMRservice.BOPrivAssist).IsInformedConsentForm(874)	
ClassMethod IsInformedConsentForm(ADocID As %String = "") As %String
{
	s result = "0"
	q:(ADocID="") result
	s objEMRTemplateCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEMRTemplateCate="") result
	s parentID = objEMRTemplateCate.ParentCategoryID
	
	
	s objGrandpaEMRTemplateCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(parentID)
	q:(objGrandpaEMRTemplateCate="") result
	s InternalID = objGrandpaEMRTemplateCate.InternalID
	
	
	//知情同意书的目录
	s:((InternalID="EMR070001")||(InternalID="EMR070002")||(InternalID="EMR070003")) result="1"
	
	q result
}

/// Desc:		病历是否存在已签或者已推送、未签的病历PDF
/// Creator:	yb
/// CreateDate:	2023-03-21
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).IsPushOrSignedPDF("716||2")
ClassMethod IsPushOrSignedPDF(argInstanceID As %String) As %String
{
	s result = 0
	s objInst = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID,0)
	q:(objInst = "") result
	
	s episodeID = objInst.RealEpisodeID
	
	s id = ""
	for {
		s id = $O(^DHCEMRCA.AuditSignLogI("IdxInstance"," "_episodeID, " "_argInstanceID, 1, id),-1)
		q:(id = "")
		
		s obj = ##class(EMRinstance.PDF.AuditSignLog).%OpenId(id)
		continue:(obj = "")
		continue:(obj.IsValid '= "1")
		
		s:(obj.SignStatus = "TOSIGN")||(obj.SignStatus = "SIGNED") result = 1
		q:(result = 1)
		
	}
	
	q result
}

/// Desc:		获取诊断证明书状态
/// Creator:	lifengbo
/// CreateDate:	2023-04-25
/// Input:		argInstanceID 病历实例ID
/// OutPut: 	门诊诊断证明书当前状态  0，未返回状态
/// Debug: 		w ##Class(EMRservice.BOPrivAssist).GetOPDiagRecordStatus("716||2")
ClassMethod GetOPDiagRecordStatus(argInstanceID As %String) As %String
{
	s result = ""
	q:(argInstanceID="") result
	//诊断证明书
	s extAuditLogId = ""
	for 
	{
		
		s extAuditLogId = $o(^DHCEMRI.ExtAuditLogI("IdxInsId"," "_argInstanceID,extAuditLogId))
		q:(extAuditLogId = "") 
		s objExtAuditLog = ##class(EMRinstance.ExtAuditLog).%OpenId(extAuditLogId,0)
		s action = objExtAuditLog.Action
		s status =objExtAuditLog.Status
		s:(action="checked")&&(status=1) result="checked"
		s:(action="refused")&&(status=1) result="refused"
		
	}
	q result
}

}
