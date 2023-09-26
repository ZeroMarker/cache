/// get info from Trak for privilege management
Class EMRservice.Privilege.BOPrivAssist Extends (%RegisteredObject, %SOAP.WebService) [ ClassType = "", Inheritance = right, ProcedureBlock ]
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
/// Test:          d ##Class(EMRservice.Privilege.BOPrivAssist).GetCTLoc("S07","",0,12,0,"","","")
ClassMethod GetCTLocDS(ADicCode As %String, AItem As %String, AStartRow As %Integer, ARowCount As %Integer, ByRef AResultCount As %String, ByRef ASessionId As %String, AConditionCode As %String, ACondition As %String) As EMRservice.dataset.Privilege.EPrivCTLocDataset [ WebMethod ]
{
    //q ##Class(EMRservice.Privilege.BLPrivCTLoc).GetCTLocList("S07","",0,12,0,"","","")
    q ##Class(EMRservice.Privilege.BLPrivCTLoc).GetCTLocList(ADicCode,AItem,AStartRow,ARowCount,AResultCount,ASessionId,AConditionCode,ACondition)
}

/// added by Jiangew on 2012-11-16
ClassMethod GetCTLoc(CTLocName As %String) As %XML.DataSet [ WebMethod ]
{
   s result=##Class(%XML.DataSet).%New()
   
   if ($D(CTLocName)=0)||(CTLocName="")
  	{
	  	Set result=##class(%XML.DataSet).%New("EMRservice.dao.DPrivCTLoc:GetAllCTLoc")
	  	Do result.SetArgs()
	}
	else {
		Set result=##class(%XML.DataSet).%New("EMRservice.dao.DPrivCTLoc:GetCTLocByName")
		Do result.SetArgs(CTLocName)
	}
	
	Quit result
}

ClassMethod getSSGroup(argGroupName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	
	//注：Select出这两个字段的顺序不允许修改
	if ($d(argGroupName)=0)||(argGroupName="") {
		Set result=##class(%XML.DataSet).%New("EMRservice.Privilege.BOPrivAssist:GetAllSSGroup")
		//Do result.Prepare("select SSGRP_RowId,SSGRP_Desc from SS_Group")
		Do result.SetArgs()
	}
	else {
		//modified by houj
		//Do result.Prepare("select SSGRP_RowId,SSGRP_Desc from SS_Group where SSGRP_Desc like ?")
		Set result=##class(%XML.DataSet).%New("EMRservice.Privilege.BOPrivAssist:GetSSGroupByName")
		Do result.SetArgs(argGroupName)
	}
	
	Quit result
}

Query GetAllSSGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId,SSGRP_Desc", SELECTMODE = "RUNTIME") [ SqlName = GetAllSSGroup, SqlProc ]
{
	select SSGRP_RowId,SSGRP_Desc from SQLUser.SS_Group order by SSGRP_Desc
}

Query GetSSGroupByName(argGroupName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId,SSGRP_Desc", SELECTMODE = "RUNTIME") [ SqlName = GetSSGroupByName, SqlProc ]
{
	select SSGRP_RowId,SSGRP_Desc from SQLUser.SS_Group where SSGRP_Desc like :argGroupName
}

/// get locations of Trak to config privilege
/// Trak table: CT_Loc. Pay attention to the CTLOC_DateActiveFrom and CTLOC_DateActiveTo
ClassMethod GetLocations(argLocationName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	Set nowDate=$zd($p($h,",",1),1)
	
	if ($d(argLocationName)=0)||(argLocationName="") {
		//modified by houj
		//Do result.Prepare("select CTLOC_RowID,CTLOC_Desc,CTLOC_Code from CT_Loc where CTLOC_DateActiveFrom<=? and (CTLOC_DateActiveTo is null or CTLOC_DateActiveTo>=?)")
		//Do result.SetArgs(nowDate,nowDate)
		Set result=##class(%XML.DataSet).%New("EMRservice.Privilege.BOPrivAssist:SelectLoctations")
		Do result.SetArgs(nowDate)
	}
	else {
		//modified by houj
		//Do result.Prepare("select CTLOC_RowID,CTLOC_Desc from CT_Loc where CTLOC_Desc like ? and CTLOC_DateActiveFrom<=? and (CTLOC_DateActiveTo is null or CTLOC_DateActiveTo>=?)")
		//Do result.SetArgs(argLocationName,nowDate,nowDate)
		Set result=##class(%XML.DataSet).%New("EMRservice.Privilege.BOPrivAssist:SelectLoctationsByName")
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
	
	//modified by houj
	//Do result.Prepare("select CTSEX_Code,CTSEX_Desc from CT_Sex")
	Set result=##class(%XML.DataSet).%New("EMRservice.Privilege.BOPrivAssist:SelectSexDic")
	Do result.SetArgs()
	
	Quit result
}

Query SelectSexDic() As %SQLQuery(CONTAINID = 0, ROWSPEC = "CTSEX_Code,CTSEX_Desc", SELECTMODE = "RUNTIME") [ SqlName = SelectSexDic, SqlProc ]
{
	select CTSEX_Code,CTSEX_Desc from SQLUser.CT_Sex
}

/// get a user's ssgroup name and user's name by it's id
/// return: groupname^username
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

/// if the patient whose episodeid is argPatEpisodeID belongs to the doctor whose ID is argDocID
/// arguments: argDocID -- SSUSR_Initials
/// return value: 1--true, 0--false
ClassMethod IsPatBelongDoc(argPatEpisodeID As %String, argDocID As %String) As %String
{
	q:($d(argPatEpisodeID)=0)||($d(argDocID)=0)||(argPatEpisodeID="")||(argDocID="") "0"
	s maindoc=""
	s maindoc=##class(EMRservice.HISInterface.PatientInfoAssist).SSUsrInCharge(argPatEpisodeID)
	q:(maindoc="") "0"
	q:(argDocID=maindoc) "1"
	q "0"
}

/// if the writer of a patient record instance is the doctor whose ID is argDocID
/// return value: 1--true, 0--false
ClassMethod IsRecBelongDoc(argInstanceID As %String, argDocID As %String) As %String
{
	q:($d(argInstanceID)=0)||($d(argDocID)=0)||(argInstanceID="")||(argDocID="") "0"
	
	s instance="",log=""
	s instance=##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(instance="") "0"
	
	s log=instance.GetFirstLogByFinalStatus("Save")
	
	q:(log="") "0"
	q:(log.RealOperateUserID=argDocID) "1"
	q "0"
}

/// if the writer of a patient record instance is the doctor whose ID is argDocID
/// 病历作者是否是指定用户，处理三种情况：
/// 1)病历创建者是指定用户，返回1
/// 2)病历创建者不是指定用户，返回0
/// 3)病历未保存，创建者为空，返回0
/// return value: 1--true, 0--false
ClassMethod IsRecBelongDocNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	s authorId=""
	s authorId=##class(EMRinstance.EMRLogs).GetRecAuthor(argEpisodeID,argDocID,argEMRNum)
	
	//q:(authorId="") "1"
  	q:(authorId="") "0"
  	
	q:(authorId=argUserID) "1"
	q "0"
  
errhandle
	q "0"
}

/// if the patient whose episodeid is argPatEpisodeID belongs to the doctor's sub-doctors whose ID is argDocID
/// return value: 1--true, 0--false
ClassMethod IsPatBelongSubDocs(argPatEpisodeID As %String, argDocID As %String) As %String
{
	q:($d(argPatEpisodeID)=0)||($d(argDocID)=0)||(argPatEpisodeID="")||(argDocID="") "0"
	
	s doc="",maindoc=""
		
	;s argDocID=$o(^SSU("SSUSR",0,"SSUSR_Initials",argDocID,""))
	s doc=##class(EMRservice.Privilege.BOPowerUser).GetById(argDocID)
	q:(doc="") "0"
	
	s maindoc=##class(EMRservice.HISInterface.PatientInfoAssist).SSUsrInCharge(argPatEpisodeID)
	q:(maindoc="") "0"
	
	///s maindoc=$o(^SSU("SSUSR",0,"SSUSR_Initials",maindoc,""))
	///subdocs sample: 9772^aaa!8918^bbb!10157^ccc
	q:($f("^"_doc.ChildUsers_"^","^"_maindoc_"^")>1) "1"
	///q:($p(subdocs.ChildUsers,"^",1)=maindoc) "1"
	q "0"
}

/// used for the judgement of whether a patient belong to the loged user's location
ClassMethod IsPatBelongToLoc(argPatEpisodeID As %String, argLocID As %String) As %String
{
	///get the current loc of the patient
	s currentLoc=""
	s currentLoc=##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
	q:(currentLoc="") "0"
	
	///s locCode=$p($g(^CTLOC(argLocID)),"^",1)
	q:($p(currentLoc,"^",1)=argLocID) "1"
	
	//20110624 WANGWENTAO UPDATE : 病历转移科室应该也是当前科室
	s getappointdept = ""
	s getappointdept = ##Class(EMRservice.DocRestLogic.PrivLogic).GetAppointDept(argPatEpisodeID)
	q:(getappointdept=argLocID) "1"
	//20110624 WANGWENTAO UPDATE END
	
	q "0"
}

ClassMethod IsPatBelongToLinkLoc(argPatEpisodeID As %String, argLocID As %String) As %String
{
	// get the current loc type of the patient
	s locType=""
	s locType=$p($g(^CTLOC(argLocID)),"^",13)
	
	// Modify by Wangwt 2008-09-02 Add ||(locType="E")
	if (locType="W")||(locType="E")
	{
		s currentLinkLocString=""
		s currentLinkLocString=##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDeptLinkLoc(argPatEpisodeID)
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
	s currentLoc=""
	s currentLoc=##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
	q:(currentLoc="") "0"
	q:($p(currentLoc,"^",1)=argLocID) "1"
	q "0"
	}
}

/// Desc: 检查病人是否已被病历转移到指定科室
/// Input：argPatEpisodeID：病人就诊rowid，argLocID：病历转移的科室
/// Output：1--是, 0--否
/// Return：0：住院病人，1：门诊或急诊病人
/// CreateUser：gaojb
/// CreateTime：2009-12-09
/// Debug: w ##class(EMRservice.Privilege.BOPrivAssist).IsPatBelongTransLoc(50729,6) 
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

/// if the record instance has been archieved
/// return value: 1--true, 0--false
ClassMethod IsRecordInstanceArchieved(argInstanceID As %String) As %String
{
}

/// this function should be moved to the class BOInstanceData
ClassMethod IsRecordInstanceSaved(argInstanceID As %String) As %String
{
	s instance="",status=""
	q:(argInstanceID="") "0"
	s instance=##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(instance="") "0"
	
	//if the instance's status is 'UnSave', return false(0), else return true(1)
	s status=instance.Status
	q:(status="UnSave") "0"
	q "1"
}

/// is the record FINISHED for new framework
/// 病历是否已经完成（新框架）
/// return: 1--finished, 0--unfinished
/// gaojb 2009-12-01
/// debug: w ##class(EMRservice.Privilege.BOPrivAssist).IsRecordFinishedNew(59,45,1)
ClassMethod IsRecordFinishedNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	s logs="", log=""
	s logs=##class(EMRinstance.EMRLogs).GetCurrLog(argEpisodeID,argDocID,argEMRNum)
	q:(logs="") "0"
	
	s log=logs.GetFinalLog()
	q:(log="") "0"
	
	q:(log.FinalStatus="unfinished") "0"
	q "1"
}

/// gjb 2008-8-6
ClassMethod IsRecordPrinted(argInstanceID As %String) As %String
{
	s instance="",log=""
	q:(argInstanceID="") "0"
	s instance=##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(instance="") "0"
	
	s log=instance.GetFirstLogByAction("Print")
	s instance=""
	q:(log="") "0"
	q "1"
}

/// gjb 2008-8-6
/// return: 1--printed, 0--not printed
/// gaojb 2009-12-01
/// debug: w ##class(EMRservice.Privilege.BOPrivAssist).IsRecordPrintedNew(59,45,1)
ClassMethod IsRecordPrintedNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	q ##class(EMRinstance.EMRLogs).RecHasAction(argEpisodeID,argDocID,argEMRNum,"print")
}

/// msx 2013-06-21
/// input:argEpisodeID,就诊号;argDocID,病历展现结构模板ID,argEMRNumarg可重复模板的列表顺序号（唯一模板1）
/// return: 1--printed by loc, 0--not printed by loc
/// debug: w ##class(EMRservice.Privilege.BOPrivAssist)IsRecordPrintedByLocNew(67,212,1,6)
ClassMethod IsRecordPrintedByLocNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	q ##class(EMRinstance.EMRLogs).RecHasActionNew(argEpisodeID,argDocID,argEMRNum,"print")
}

/// Modify by EMRWangwt 2008-10-15
ClassMethod IsRecordInstanceCommited(argInstanceID As %String) As %String
{
	s instance="",log=""
	q:(argInstanceID="") "0"
	s instance=##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(instance="") "0"
	
	s log=instance.GetFirstLogByFinalStatus("Commit")
	
	q:(log="") "0"
	q "1"
}

/// is the record commited for new framework
/// 病历是否已经提交（新框架）
/// return: 1--commited, 0--not commited
/// gaojb 2009-12-01
/// debug: w ##class(EMRservice.Privilege.BOPrivAssist).IsRecordCommitedNew(59,45,1)
ClassMethod IsRecordCommitedNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	s logs="", log=""
	s logs=##class(EMRinstance.EMRLogs).GetCurrLog(argEpisodeID,argDocID,argEMRNum)
	q:(logs="") "0"
	
	s log=logs.GetFinalLog()
	q:(log="") "0"
	
	q:(log.FinalStatus="unfinished") "0"
	q:(log.FinalStatus="finished") "0"
	q "1"
}

/// 病历提交据现在时间段（小时）（新框架）
/// return: -1 没有提交过，数字-提交至今的时间段（小时）
/// debug: w ##class(EMRservice.Privilege.BOPrivAssist).RecordCommitedSpanHourNew(201868,34,1)
ClassMethod RecordCommitedSpanHourNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	s dateTime = ##class(EMRservice.BOEMRLogs).GetOperationDateTimeByAction(argEpisodeID, argDocID, argEMRNum, "commit")
	if (dateTime = ",")
	{
		q "-1"	
	}
	s commitDate = $p(dateTime,",",1)
	s commitTime = $p(dateTime,",",2)
	s commitSecond = (commitDate * 24 * 3600) + commitTime	
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	s nowSecond = (nowDate * 24 * 3600) + nowTime
	s spanHour = $fn(((nowSecond - commitSecond)/ 3600),"+",2)	
	q spanHour
}

/// Desc:将病历完成的日期与当前日期进行比较,确定完成病历到目前的时间
/// Creator：hanxf 
/// CreatDate:2013-08-02
/// Return：返回病历完成时间距当前时间,argFlag=0,返回小时数，argFlag=1返回天数(完成当天返回1)
/// Debug： w ##class(EMRservice.Privilege.BOPrivAssist).RecordCmpSpanHoursNew(1008,586,1)
ClassMethod RecordCmpSpanHoursNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argFlag As %String = "0") As %String
{
	s CmpDateTime=##class(EMRservice.BOEMRLogs).GetOperationDateTimeByAction(argEpisodeID, argDocID, argEMRNum, "complete")
	q:((CmpDateTime = ",")||(CmpDateTime = "")) "0"
	s CmpDate=$p($g(CmpDateTime),",",1)
	s CmpTime=$p($g(CmpDateTime),",",2)
	s CmpSecond=(CmpDate * 24 * 3600) + CmpTime
	s CurDateTime=$h
	s CurentDate=$p(CurDateTime,",",1)
	s CurentTime=$p(CurDateTime,",",2)
	s NowSecond=(CurentDate * 24 * 3600) + CurentTime
	if (argFlag="0")
	{
	  s spanHour = $fn((NowSecond - CmpSecond)/ 3600,"",0)	
	}
	if (argFlag="1")
	{
	  s spanHour = CurentDate-CmpDate+1 
	}
	q spanHour
}

/// get the doctor's privilege of operation
/// return value: oper1^priv1!oper2^priv2...
/// operation: view, save, print, commit
ClassMethod DocOperPriv(argDocID As %String) As %String
{
	q "view^save^print^commit"
}

/// added on 2008-12-24 by houj sugguested by xuefl
ClassMethod IsPatBelongToWard(argPatEpisodeID As %String, argLocID As %String) As %String
{
 ///get the current loc of the patient
 s currentWard=""
 s currentWard=##class(EMRservice.HISInterface.PatientInfoAssist).CareUnit(argPatEpisodeID)
 q:(currentWard="") "0"
 
 // 这里不能直接比较rowid，护士登陆时其argLocID是CT_Loc中的科室rowid
 // 需要比较病区的code
 // q:($p(currentWard,"^",1)=argLocID) "1"
 s locCode=$p($g(^CTLOC(argLocID)),"^",1)
 q:($p(currentWard,"^",2)=locCode) "1"
 q "0"
}

/// Desc: 是否门诊病人, 用于门诊医生权限
/// Input：argPatEpisodeID：病人就诊rowid
/// Output：无
/// Return：0：住院病人，1：门诊或急诊病人
/// CreateUser：HouJ， suggested by XueFL for HuaXiYiYuan
/// CreateTime：2009-08-03 
ClassMethod IsOutPatient(argPatEpisodeID As %String) As %String
{
 s RetType = ""
 s PatientType=$p($g(^PAADM(argPatEpisodeID)),"^",2) 
 if PatientType="I" 
 {	set RetType="0"}
 elseif PatientType'="I" 
 {	set RetType="1"}
 q RetType
}

/// Add by Liaowp 2009-07-10
/// if the Template belong use is a doctor or a nurse
/// return value: 1--true, 0--false
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

/// Add by Liaowp 2010-07-07
/// if the PatientRecord has be Retrieved forbid modify
/// return value: 1--true, 0--false
/// Debug: w ##Class(EMRservice.Privilege.BOPrivAssist).GetMrRetrieveStatus(argEpisodeID)
ClassMethod GetMrRetrieveStatus(argEpisodeID As %String) As %String
{
	 q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	 s RetStatus=0
	 s RetStatus=##Class(web.DHCWMRService).IGetMrRetrieveStatus(argEpisodeID)
	 q:(RetStatus=1) "0"
	 q "1"
}

ClassMethod test() As %String
{
	s a=##class(EMRservice.Privilege.BOPrivAssist).getSSUser("中药")
	q a
}

/// CreateTime: 2009-09-21
/// CreateUser: gaojb
/// Desc: 根据打印模版DocID取父节点ID（即“章”的ID）
/// Input: parPrnDocID：打印模版DocID或其父节点ID（即要取的章ID本身）
/// Return：父节点ID，如果没有父节点或者参数错误等返回空串
ClassMethod EMRChapterID(parPrnDocID As %String) As %String
{
	q:(($d(parPrnDocID)=0)||(parPrnDocID="")) "0"
	
	s result="",parentID=""
	s result=##class(EMRmeta.EMRTemplateCategory).GetParentIDByDocID(parPrnDocID)
	///如果没有上级节点，返回空串
	q:(result="") ""
	///如果有上级节点，取上级节点的上级节点
	if result'="" {
		s parentID=##class(EMRmeta.EMRTemplateCategory).GetParentIDByDocID(result)
	}
	///如果上级节点为空，说明参数节点就是Chapter，直接返回
	q:(parentID="") parPrnDocID
	q result
}

/// CreateTime: 2009-09-21
/// CreateUser: gaojb
/// Desc: 根据打印模版DocID取病历目录ID
/// Input: parPrnDocID：打印模版DocID或章节点ID或目录节点ID（即要取的ID本身）
/// Return：病历目录节点ID，如果没有父节点或者参数错误等返回空串
ClassMethod EMRCategoryID(parPrnDocID As %String) As %String
{
	q:(($d(parPrnDocID)=0)||(parPrnDocID="")) "0"
	
	s id="",result=""
	s id=##class(EMRmeta.EMRTemplateCategory).GetParentIDByDocID(parPrnDocID)
	q:(id="") parPrnDocID
	
	s result=##class(EMRmeta.EMRTemplateCategory).GetParentIDByDocID(id)
	q:(result="") id
	q result
}

/// CreateDate: 2009-08-04
/// CreateUser: xuefl
/// Desc: 是否为病历创建人的上级医生,用于分组式医生权限
ClassMethod ISUpUser(admid As %String, userid As %String, userloc As %String, instanceid As %String) As %String
{
    //在这里判断是否是上级医生和是否是本人,
    //首先判断本模板是否保存，如保存了取到保存的人ID来判断是否是自己的病历，是则可以修改保存不是则按医生分组，否则就直接返回1
    //另外两参数计划以后把科室和这个合起来
 	s CreateUser="",orgUserId="",orgUserLeve="",UserLeve=""
 	s InID=instanceid
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InID)
	if objInstance '= ""
	{
		s orgUserId = objInstance.CreateUser
		if orgUserId'="" 
		{
		if orgUserId'=userid 
			{
				s orgUserLeve=##class(EMRmeta.Privilege.PowerUser).GetUserLevelNew(orgUserId)
				s UserLeve=##class(EMRmeta.Privilege.PowerUser).GetUserLevelNew(userid)
				if UserLeve > orgUserLeve { s LeveTypea=1 } 
		   		else {s LeveTypea=0 }
			 }
			else { s LeveTypea=1  }
		}
	   else {s LeveTypea=1}
	}
	else 
	{	
		s LeveTypea=1
	}
	
 	q LeveTypea
}

/// CreateDate: 2009-12-1
/// CreateUser: gaojb
/// Desc: 指定用户是否为病历创建人的上级医生
/// 
ClassMethod ISUpUserNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	s authorId=""
	//s authorId=##class(EMRinstance.EMRLogs).GetRecAuthor(argEpisodeID,argDocID,argEMRNum)
	s authorId = ##class(EMRinstance.EMRLogs).GetCreateUserID(argEpisodeID,argDocID,argEMRNum)
	q:(authorId="") "0"

	s doc=##class(EMRservice.Privilege.BOPowerUser).GetById(argUserID)
	q:(doc="") "0"

	q:($f("^"_doc.ChildUsers_"^","^"_authorId_"^")>1) "1"
	q "0"
}

/// CreateDate: 2010-08-28
/// CreateUser: houj
/// Desc: 指定用户是否为某病历状态操作者的上级医生
ClassMethod ISUpLevelUser(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	//没有维护医生级别，则没有上级医生
	s doc = ##class(EMRservice.Privilege.BOPowerUser).GetById(argUserID)
	q:(doc="") "0"
	s docLevel = doc.UserLevel
	
	//日志不存在，说明是新建病历，所有医生都是"空"医生的上级医生
	s eprLogs = ##class(EMRinstance.EMRLogs).GetCurrLog(argEpisodeID,argDocID,argEMRNum)
	q:(eprLogs="") "1"
	
	s status = eprLogs.EMRStatus
	
	if status = "attendingChecked"
	{
		//主治审核过，只有主任医师是其上级医师
		q:(docLevel="Chief") "1"
	}
	elseif status = "chiefChecked"
	{
		//主任审核过，只有其本人才是其上级医师
		s log = eprLogs.GetFirstLogByFinalStatus(status)
		q:(log="") "0"
		q:(docLevel="Chief")&&(log.RealOperateUserID=argUserID) "1"
	}
	elseif status = "archieved"
	{
		//已归档，谁也不能修改
		q "0"
	}
	else
	{
		//其他情况取创建者，比较创建者与当前用户的级别关系
		s authorId = eprLogs.CreateUserID
		s author = ##class(EMRservice.Privilege.BOPowerUser).GetById(authorId)
		q:(author="") "0"
		s authorLevel = author.UserLevel
		
		//当前用户级别高于创建者级别
		q:(authorLevel="Resident")&&((docLevel="Attending")||(docLevel="Chief")) "1"
		q:(authorLevel="Attending")&&(docLevel="Chief") "1"
		//创建者为主任，只有其自己为其上级医师
		q:(authorLevel="Chief")&&(authorId=argUserID) "1"
	}
	
	q "0"
}

/// CreateDate: 2010-07-22
/// CreateUser: houj
/// Desc: 判断指定用户是否为主治审核医师的上级医生	
ClassMethod ISUpUserOfAttending(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	//日志不存在，不会有主治医师审核操作
	s logId = ##class(EMRinstance.EMRLogs).GetLogID(argEpisodeID,argDocID,argEMRNum)
	q:(logId="") "0"
	s eprLog = ##class(EMRinstance.EMRLogs).%OpenId(logId)
	q:(eprLog="") "0"
	
	s instanceLog = log.GetFirstLogByAction("attendingCheck")
	
	//日志中没有主治医师审核操作
	q:(instanceLog="") "0"
	
	s attendingCheckUserID = instanceLog.RealOperateUserID
	
	//取指定医师信息
	s doc=##class(EMRservice.Privilege.BOPowerUser).GetById(argUserID)
	q:(doc="") "0"
	
	if (attendingCheckUserID="") 
	{
		//有主治医师审核操作，但未取到审核医师
		//这是日志错误，为了容错，指定用户若为主任医师，则认为指定用户就是上级医师
		q:($zcvt(doc.UserLevel,"U")="CHIEF") "1"
		q "0"
	}
	else
	{
		q:($f("^"_doc.ChildUsers_"^","^"_attendingCheckUserID_"^")>1) "1"
		q "0"
	}
}

/// CreateUser: liaowp
/// ModifyUser: houj
ClassMethod IsDisCharge(argAdmID As %String) As %String
{
	s disDate = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDatePriv(argAdmID)
	Q:(disDate'="") "1"
	Q "0"
	
	/*
	s DisDate="",DisDateTime="",DeathDateTime="",DisDateTimeMR=""
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argPatEpisodeID)
	s Hospital=##class(EMRmeta.SysOption).GetOptionValueByName("HospitalName")
	q:(argPatEpisodeID="")||(Hospital="") "0"
	s DisDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(argPatEpisodeID,Hospital)
	s DeathDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(PapmiDR,Hospital)
	s DisDateTimeMR=##Class(EMRservice.HISInterface.PatientInfoAssist).DisDateTimeMR(argPatEpisodeID,Hospital)
 
	i DisDateTime'="" 
	{ 
		s DisDate = $ZD($P($G(DisDateTime)," ",1),3)
	} 
 	
 	// 统计组[袁旭] 日期时间
	i DisDateTimeMR'="" 
	{ 
		s DisDate = $ZD($P($G(DisDateTimeMR)," ",1),3)
	} 
 	
 	// 死亡日期时间
	i DeathDateTime'="" 
	{ 
		s DisDate = $ZD($P($G(DeathDateTime)," ",1),3)
	} 
	Q:(DisDate'="") "1"
	Q "0"
	*/
}

/// CreateUser: liaowp
/// 返回值是0或1，用于判断这个患者是否需要写病历，
/// 如果是住院患者返回1，如果是门诊患者或退院患者返回0(不可以写病历)。
/// 这个需求是给沈阳做的，因为他们有的时候把患者门诊的记录写了首页，而住院的记录没有写。
ClassMethod PatNeedDoc(argAdmID As %String) As %String
{
	Q:(argAdmID="") "0"
	
	s PatType="",VisistStatus=""
	s PatType=$P($G(^PAADM(argAdmID)),"^",2)
	s VisistStatus=$P($G(^PAADM(argAdmID)),"^",20)
	if ((PatType="I")&&((VisistStatus="A")||(VisistStatus="D")))
	{
		Q "1"
	}
	Q "0"
}

/// Creator：      guozongtao
/// CreatDate：    2010-04-21
/// Description:   依据传入PatientID,查询患者性别,女：1;非女性全部为:0
/// Table：        
/// Input：        PatientID: Pa_PatMas.PAPMI_RowID
/// Output：       对输出参数的说明
/// Return：       查询患者性别,女：1;非女性全部为:0
/// Others：       调用标准数据接口程序进行取性别
ClassMethod Gender(argPatientID As %String) As %String
{
	s rtn="0"
	s val=##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(argPatientID)
	//20120905 HJ 兼容CT_SEX表代码为'F'or'2'
	if ($p(val,"^",2)="F")||($p(val,"^",2)="2"){s rtn="1"}
	q rtn
}

/// *****************************************************
/// 说明       : 出院三天后不能在修改打印病历,取病人已出院时间(单位:小时)
///            : 计算的是出院时间到当前时间的差值
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(EMRservice.Privilege.BOPrivAssist).IsDisThreeDay(EpisodeID)
/// *****************************************************
ClassMethod IsDisThreeDay(EpisodeID)
{
 s ret=1
 s DischDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
 q:DischDateTime="" ret
 s DisDate=$p(DischDateTime,",",1),DisTime=$p(DischDateTime,",",2)
 q:(DisDate="")||(DisTime="") ret
 ;s DisDate=$zdh(DisDate,3),DisTime=$zth(DisTime,2)
 s CurrDate=+$h,CurrTime=$p($h,",",2)
 s cDay=0,cSecond=0
 s cDay=CurrDate-DisDate
 s cSecond=(CurrTime-DisTime)\3600
 s retd=cDay*24+cSecond
 if retd>72 {s ret="0"}
 q ret
}

/// CreateDate: 2010-07-22
/// CreateUser: houj
/// Desc: 是否进行过主治医师审核操作	
ClassMethod HasAttendingChecked(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	s logId = ##class(EMRinstance.EMRLogs).GetLogID(argEpisodeID,argDocID,argEMRNum)
	
	//日志不存在，不会有主治医师审核操作
	q:(logId="") "0"
	
	s eprLog = ##class(EMRinstance.EMRLogs).%OpenId(logId)
	
	//日志不存在，不会有主治医师审核操作
	q:(eprLog="") "0"
	
	s instanceLog = log.GetFirstLogByAction("attendingCheck")
	
	//日志中没有主治医师审核操作
	q:(instanceLog="") "0"
	
	q "1"
}

/// CreateDate: 2010-07-22
/// CreateUser: houj
/// Desc: 是否进行过主任医师审核操作	
ClassMethod HasChiefChecked(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	s logId = ##class(EMRinstance.EMRLogs).GetLogID(argEpisodeID,argDocID,argEMRNum)
	
	//日志不存在，不会有主任医师审核操作
	q:(logId="") "0"
	
	s eprLog = ##class(EMRinstance.EMRLogs).%OpenId(logId)
	
	//日志不存在，不会有主任医师审核操作
	q:(eprLog="") "0"
	
	s instanceLog = log.GetFirstLogByAction("chiefCheck")
	
	//日志中没有主任医师审核操作
	q:(instanceLog="") "0"
	
	q "1"
}

/// Creator:loo
/// CreatDate:2010-09-13
/// Description:根据病人的任一就诊号,判断当前病人是否已出院
/// Table:
/// Input:APatientID-病人号
/// Output:
/// Return:1-已经出院 0-目前在院
/// Others:返回值根据episodeID取得的多个cateCharpter之间用@区分,最后加上!
/// Debug:d ##class(EMRservice.Privilege.BOPrivAssist).IsPatDis(APatientID)
ClassMethod IsPatDis(APatientID As %String) As %String
{
	s Ret = "1"
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
			if (episodeID < tmpEpisodeID)
				s episodeID = tmpEpisodeID	
		}
	}
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
	if (disDateTime = "")
	{
		s Ret = "0"
	}
	q Ret
}

/// Creator:loo
/// CreatDate:2010-09-13
/// Description:获得授权
/// Table:
/// Input:AEpisodeID-病人就诊号,AUserID-用户ID,AUserLoc-用户所在部门,ADocID-PrintDocID(打印模板ID)
/// Output:
/// Return:
/// Others:返回一个字符串,格式如:"set browse=1,print=1"
/// Debug:w ##class(EMRservice.Privilege.BOPrivAssist).GetAppiont(AEpisodeID,AUserID,AUserLoc,ADocID)
ClassMethod GetAppiont(AEpisodeID As %String, AUserID As %String, AUserLoc As %String, ADocID As %String) As %String
{
	s str = ##class(web.eprajax.EMRAction).GetAllActiveAppoint(AEpisodeID,AUserID,AUserLoc,ADocID)
	q str
}

/// Creator:houj
/// CreatDate:2010-10-25
/// Desc:入院时间间隔, 时间单位为小时
/// Table:无
/// Input:AEpisodeID:病人就诊rowid
/// Output:无
/// Return:时间间隔，时间单位为小时
/// Debug:w ##(EMRservice.Privilege.BOPrivAssist).GetAdmTimeSpan("89")
ClassMethod GetAdmTimeSpan(AEpisodeID As %String) As %Integer
{
	s span = 0
	
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
 	q:((admDateTime) = "") span
 	
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) span
 
 	s span = ..TimeSpanToNow(admDate, admTime)
 	 	
 	q span
}

/// Creator:houj
/// CreatDate:2010-10-25
/// Desc:出院时间间隔, 时间单位为小时
/// Table:无
/// Input:AEpisodeID:病人就诊rowid
/// Output:无
/// Return:时间间隔，时间单位为小时
/// Debug:w ##(EMRservice.Privilege.BOPrivAssist).GetDisTimeSpan("89")
ClassMethod GetDisTimeSpan(AEpisodeID As %String) As %Integer
{
	s span = 0
	
	s dischDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
 	q:((dischDateTime) = "") span
 	
 	s disDate = $p(dischDateTime,",",1)
 	s disTime = $p(dischDateTime,",",2)
 	q:((disDate = "")||(disTime = "")) span
 
 	s span = ..TimeSpanToNow(disDate, disTime)
 	
 	q span
}

/// Creator:houj
/// CreatDate:2010-10-25
/// Desc:入院时间间隔, 时间单位为小时
/// Table:无
/// Input:AEpisodeID:病人就诊rowid
/// Output:无
/// Return:时间间隔，时间单位为小时
/// Debug:w ##class(EMRservice.Privilege.BOPrivAssist).GetAdmTimeInBedSpan("89")
ClassMethod GetAdmTimeInBedSpan(AEpisodeID As %String) As %Integer
{
	s span = 0
	
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(AEpisodeID)
 	q:((admDateTime) = "") span
 	
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) span
 
 	s span = ..TimeSpanToNow(admDate, admTime)
 	 	
 	q span
}

/// Creator:houj
/// CreatDate:2010-10-25
/// Desc:入院时间间隔, 时间单位为小时
/// Table:无
/// Input:AEpisodeID:病人就诊rowid
/// Output:无
/// Return:时间间隔，时间单位为小时
/// Debug:w ##class(EMRservice.Privilege.BOPrivAssist).GetInshAdmTimeSpan("89")
ClassMethod GetInhsAdmTimeSpan(AEpisodeID As %String) As %Integer
{
	s span = 0
	
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).InhsAdmDateTime(AEpisodeID)
 	q:((admDateTime) = "") span
 	
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) span
 
 	s span = ..TimeSpanToNow(admDate, admTime)
 	 	
 	q span
}

ClassMethod TimeSpanToNow(date As %String, time As %String) As %String
{
	s now = $h
 	s currDate = $p(now,",",1)
 	s currTime = $p(now,",",2)
 	
 	s dayToHour = (currDate - date ) * 24
 	s secondToHour = (currTime - time)\3600
 	s span = dayToHour + secondToHour
 	
 	q span
}

/// CreateDate: 2010-10-29
/// CreateUser: wangwentao
/// Desc: 是否进行过主治医师审核操作
ClassMethod IsRecordAttendingCheckedNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	//s ^CacheTempDHCEMRDebugWWT($ZNAME,"IsRecordAttendingCheckedNew")=argEpisodeID_"++"_argDocID_"++"_argEMRNum
	s logs="", log=""
	s logs=##class(EMRinstance.EMRLogs).GetCurrLog(argEpisodeID,argDocID,argEMRNum)
	q:(logs="") "0"
	
	s log=logs.GetFinalLog()
	q:(log="") "0"
	

	q:(log.FinalStatus="unfinished") "0"
	q:(log.FinalStatus="finished") "0"
	q:(log.FinalStatus="commited") "0"
	
	q 1
}

/// CreateDate: 2010-10-29
/// CreateUser: wangwentao
/// Desc: 是否进行过主任医师审核操作	
ClassMethod IsRecordChiefCheckedNew(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
	//s ^CacheTempDHCEMRDebugWWT($ZNAME,"IsRecordChiefCheckedNew")=argEpisodeID_"++"_argDocID_"++"_argEMRNum
	s logs="", log=""
	s logs=##class(EMRinstance.EMRLogs).GetCurrLog(argEpisodeID,argDocID,argEMRNum)
	q:(logs="") "0"
	
	s log=logs.GetFinalLog()
	q:(log="") "0"
	
	q:(log.FinalStatus="unfinished") "0"
	q:(log.FinalStatus="finished") "0"
	q:(log.FinalStatus="commited") "0"
	q:(log.FinalStatus="attendingChecked") "0"
	
	q 1
}

/// 取病历最后一次保存者的安全组ID
/// LingChen
ClassMethod GetLastSaverGrpID(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
    s logs="", log="", grp ="", modifyUser = ""
	s logs=##class(EMRinstance.EMRLogs).GetCurrLog(argEpisodeID,argDocID,argEMRNum)
	q:(logs="") ""
	
	s log=logs.GetFinalLog()
	q:(log="") ""
	
	s modifyUser = log.OperateUserID
	if (modifyUser '= "")
	{
	  s grp = $p($g(^SSU("SSUSR",modifyUser)), "^",5)
	}
	  
	q grp
}

/// 取病历创建者的安全组ID
/// LingChen
ClassMethod GetCreaterGrpID(argEpisodeID As %String, argDocID As %String, argEMRNum As %String) As %String
{
    s logs="", log="", grp ="", createUser = ""
	s logs=##class(EMRinstance.EMRLogs).GetCurrLog(argEpisodeID,argDocID,argEMRNum)
	q:(logs="") ""

	s createUser = logs.CreateUserID
	if (createUser '= "")
	{
	  s grp = $p($g(^SSU("SSUSR",createUser)), "^",5)
	}
	  
	q grp
}

/// 取当前病历类型ID
/// wangwentao 20110315 add
/// 返回-1说明未选择病历类型
ClassMethod GetPatTpyeID(argEpisodeID As %String) As %String
{
    s Ret=""
	
	&SQL(select PatType into :Ret from EMRinstance.AdmPatType where EpisodeID=:argEpisodeID)
	s:(SQLCODE'=0) Ret="-1"    
	q Ret
}

/// Desc:病案是否已经归档
/// return value: 1--归档, 0--未归档
/// Debug: w ##Class(EMRservice.Privilege.BOPrivAssist).HasMRArchived(argEpisodeID)
ClassMethod HasMRArchived(argEpisodeID As %String) As %String
{
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s RetStatus = 0
	s RetStatus = ##Class(web.DHCWMRService).IGetMrArchiveStatus(argEpisodeID)
	q:(RetStatus=1) "1"
	q "0"
}

/// Desc: 	出院日期(护士结算)
/// Output：标准格式 Cache内部格式
/// Others：not different from hospitals
/// Debug: w ##Class(EMRservice.Privilege.BOPrivAssist).GetDisDate(2)
ClassMethod GetDisDate(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s ret=0,dischgdate="",dischgtime=""
		
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) 0
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",17)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",18)
	
	s:((dischgdate'="")&&(dischgtime'="")) ret=dischgdate

	q ret
}

/// Desc: 	出院日期(医生结算)
/// Output：标准格式 Cache内部格式
/// Others：not different from hospitals
/// Debug: w ##Class(EMRservice.Privilege.BOPrivAssist).GetDisDate(2)
ClassMethod GetDisDateDoctor(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s ret=0,dischgdate="",dischgtime=""
		
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) 0
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",59)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",60)
	
	s:((dischgdate'="")&&(dischgtime'="")) ret=dischgdate

	q ret
}

/// *****************************************************
/// 说明       : 出院五天后不能在修改打印病历,取病人已出院时间(单位:小时)
///            : 计算的是出院时间到当前时间的差值
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(EMRservice.Privilege.BOPrivAssist).IsDisThreeDay(EpisodeID)
/// *****************************************************
ClassMethod IsDisFiveDay(EpisodeID)
{
 s ret=1
 s DischDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
 q:DischDateTime="" ret
 s DisDate=$p(DischDateTime,",",1),DisTime=$p(DischDateTime,",",2)
 q:(DisDate="")||(DisTime="") ret
 ;s DisDate=$zdh(DisDate,3),DisTime=$zth(DisTime,2)
 s CurrDate=+$h,CurrTime=$p($h,",",2)
 s cDay=0,cSecond=0
 s cDay=CurrDate-DisDate
 s cSecond=(CurrTime-DisTime)\3600
 s retd=cDay*24+cSecond
 if retd>120 {s ret="0"}
 q ret
}

/// *****************************************************
/// 说明       : 出院七天后不能在修改打印病历,取病人已出院时间(单位:小时)
///            : 计算的是出院时间到当前时间的差值
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(EMRservice.Privilege.BOPrivAssist).IsDisSevenDay(EpisodeID)
/// *****************************************************
ClassMethod IsDisSevenDay(EpisodeID)
{
 s ret=1
 s DischDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
 q:DischDateTime="" ret
 s DisDate=$p(DischDateTime,",",1),DisTime=$p(DischDateTime,",",2)
 q:(DisDate="")||(DisTime="") ret
 ;s DisDate=$zdh(DisDate,3),DisTime=$zth(DisTime,2)
 s CurrDate=+$h,CurrTime=$p($h,",",2)
 s cDay=0,cSecond=0
 s cDay=CurrDate-DisDate
 s cSecond=(CurrTime-DisTime)\3600
 s retd=cDay*24+cSecond
 if retd>168 {s ret="0"}
 q ret
}

/// *****************************************************
/// 说明       : 出院三工作日后不能在修改打印病历,取病人已出院时间(单位:小时)
///            : 计算的是出院时间到当前时间的差值
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(EMRservice.Privilege.BOPrivAssist).IsDisThreeWorkingDay("8128386")
///              w ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime("7926173")
/// *****************************************************
ClassMethod IsDisThreeWorkingDay(EpisodeID)
{
 s ret=0
 s DischDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
 q:DischDateTime="" ret
 s DisDate=$p(DischDateTime,",",1),DisTime=$p(DischDateTime,",",2)
 q:(DisDate="")||(DisTime="") ret
 s CurrDate=+$h,CurrTime=$p($h,",",2)
 s cDay=0,cSecond=0
 s cDay=..GetWorkDays(DisDate,CurrDate)
 s cSecond=(CurrTime-DisTime)\3600
 s retd=cDay*24+cSecond
 if retd>72 {s ret="1"}
 q ret
}

/// d ##Class(EMRservice.Privilege.BOPrivAssist).GetWorkDays(62557,62580)
ClassMethod GetWorkDays(argStartDate As %Date, argEndDate As %Date) As %String
{
	s count=0,TheLastTowDays=0
	For Today=argStartDate:1:argEndDate
	{
		
		s IsWorkingDay=..IsWorkingDay(Today)
		if (IsWorkingDay="1")
		{
			s count=count+1
		}
        
        //计算月末最后天2天的工作日数量，备用，在最终的总工作日中减去。
		if (($e($zd(Today),1,2))=$e($zd(argStartDate),1,2)&&(IsWorkingDay="1"))
		{
			s TheLastTowDays=TheLastTowDays+1
		}	
	}
	//月末最后两个工作日出院的病历下个月第3个工作日完成提交
	//总工作日数，减去月末最后2天的工作日数量
	if (TheLastTowDays<3)
	{
		s count=count-TheLastTowDays
	}
	quit count
}

/// Desc:	指定日期是否为工作日
/// 		判断过程使用了自定义字典的日历相关定义：EMRmeta.CustomDictionary
/// 				CtmDictType：	字典类型，	如 DHCEMRCalendar
/// 				CtmDictID：	    字典标识号，如 Holiday 和 Working
/// 				CtmDictCode：	字典代码，	如 2012-04-19 （也可考虑日期为Cache内部格式）
/// 				CtmDictDesc：	字典描述，	如 调休休息日 或 调休工作日 或 法定节假日 等。、
/// 	Input：	指定日期，Cache内部格式
/// 	Return：1 工作日，0 非工作日
/// Debug：	w ##Class(EMRservice.Privilege.BOPrivAssist).IsWorkingDay(62557)
ClassMethod IsWorkingDay(argdate As %String) As %Boolean
{

	s id=""
	s mdate=$zd(argdate,3)
	&SQL(SELECT TOP 1 ID INTO :id FROM EMRmeta.CustomDictionary WHERE CtmDictType='DHCEMRCalendar' AND CtmDictCode=:mdate)
	//&SQL(SELECT TOP 1 CtmDictId INTO :ctid FROM EMRmeta.CustomDictionary WHERE CtmDictType='DHCEMRCalendar' AND CtmDictCode=:mdate)
	if (id'="")
	{
		s obj=##Class(EMRmeta.CustomDictionary).%OpenId(id)
		
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

/// Desc:	是否已出院5个工作日（死亡患者为10个工作日）
/// Input:	AEpisodeID : 就诊指针
/// Return:	1 ：是， 0 ：否
/// Debug:	w ##Class(EMRservice.Privilege.BOPrivAssist).IsDisFiveWorkingDay("201764")
ClassMethod IsDisFiveWorkingDay(AEpisodeID As %String) As %Boolean
{
	s isOverSpan = "0"
	
	s dateTime = ..GetDeathDateTimeInAdm(AEpisodeID)
 	if (dateTime = "")
 	{
	 	s dateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
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

/// Desc:	死亡日期时间或者出院日期时间
/// Input:	AEpisodeID : 就诊指针
/// Return:	死亡日期时间或者出院日期时间，格式为  日期,时间
/// Debug:	w ##Class(EMRservice.Privilege.BOPrivAssist).GetDeathDateTimeInAdm("201764")
ClassMethod GetDeathDateTimeInAdm(AEpisodeID As %String) As %String
{
	s deathDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DeathDateTime(AEpisodeID)
 	s deathDate = $p(deathDateTime,",",1)
 	s deathTime = $p(deathDateTime,",",2)
 	q:(deathDate="")||(deathTime="") ""
 	
 	s isDisOK = "0"
 	s dischDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
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
 	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	if (deathDate > admDate)||((deathDate = admDate)&&(deathTime > admTime))
 	{	s isAdmOK = "1"	}
 	q:(isAdmOK = "0") ""
 	
 	q deathDateTime
}

/// 登录科室是否为开启了CA服务的科室
/// 1：CA服务开启，0：CA服务关闭
/// Debug: w ##Class(EMRservice.Privilege.BOPrivAssist).IsCACTLoc(ctloc)
ClassMethod IsCACTLoc(ctloc As %String) As %String
{
	q ##Class(CA.DigitalSignatureService).IsCACTLoc(ctloc)
}

/// 当前病历是否有有效签名
/// Debug: w ##Class(EMRservice.Privilege.BOPrivAssist).HasValidSign("3017845","235","1")
ClassMethod HasValidSign(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
	//s ^CacheTemp("HasValidSign")=episodeID_"^"_printDocID_"^"_eprNum
	s sign=##Class(EMRinstance.DigitalSignLog).GetValidSign(episodeID,printDocID,eprNum)
    q:""=sign "0"
    
    q "1"
}

/// **************************************************************************
/// Creator:	wangwt
/// CreatDate:	20111005
/// Description:获取病历书写操作权限通过医嘱项字串
/// Table:		/
/// Input:		argAdmId是病人就诊ID[PA_Adm表RowID]// argItemString是医嘱项ID[ARC_ItmMast表RowID]// argHospital是医院标识
/// 			特殊说明： argItemString字串结构是 12132||1^12133||1 即 开启病历书写权限的医嘱项ID^关闭病历书写权限的医嘱项ID
/// Output:		/
/// Return:		Privilege 值域 1为开启,0为关闭
/// Others:		&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
/// 			select * from ARC_ItemCat where arcic_ordcat_dr =''
/// 			OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
/// 			OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
/// 			[ARC_ItmMast]OEORIItmMastDR->[ARC_ItemCat]ARCIM_ItemCat_DR				
/// 			[ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[ARCIM_Desc	1	2]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
/// 			[OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
/// 			南通大学附属医院 12132||1血液透析开始 , 12133||1血液透析结束	
/// Example:	w ##Class(EMRservice.Privilege.BOPrivAssist).GetPrivilegeByOrdItem(123,"12132||1^12133||1")
/// **************************************************************************
ClassMethod GetPrivilegeByOrdItem(argAdmId As %String) As %String
{
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s argItmMastDRStr=##class(EMRmeta.SysOption).GetOptionValueByName("PrivOrdItemConfig")
	q:($d(argItmMastDRStr)=0)||(argItmMastDRStr="") ""
	q:($zcvt(argItmMastDRStr,"U")="NULL") ""
	
	s Privilege=""
	s (ItmMastDRString,OEORDRowId,OEORIChdsub,OEORIItmMastDR,OEORIItmMastDRsub,ARCIMItemCatDR,OEORIItemStatDR,ARCIMDesc,OrdItem)=""
	
	
	//各个辅助科室控制病历书写的医嘱格式串(叹号之前是开启之后是关闭) LITEM11^ITEM21^ITEM31!ITEM12^ITEM22^ITEM32
	s ItmMastDRString = $tr(argItmMastDRStr,"!","^!^")
	s ItmMastDRString = "^"_ItmMastDRString_"^"

	
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(Privilege'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(Privilege'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. //过滤医嘱状态 2作废 4停止 10未激活
	  .. q:(OEORIItemStatDR=2)||(OEORIItemStatDR=4)||(OEORIItemStatDR=10)
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. //Check OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. q:($f(ItmMastDRString,"^"_OEORIItmMastDR_"^")=0)
	  .. //b 
	  .. s:($f($p(ItmMastDRString,"!",1),"^"_OEORIItmMastDR_"^")'=0) Privilege=1
	  .. s:($f($p(ItmMastDRString,"!",2),"^"_OEORIItmMastDR_"^")'=0) Privilege=0
	  .. //返回值拼医嘱项DR 从而区别不同科室的医嘱
	  .. s:(Privilege=1) OrdItem = $p(OEORIItmMastDR,"||")
	  
	  //默认关闭权限
	  if (Privilege="")
	  {
		  s Privilege=0
	  }
	  else
	  {
		  s Privilege=OrdItem
	  }
	  
	  
	q Privilege
}

///  当前病历是否有科主任审核
ClassMethod HasChairmanCheck(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"ChairmanCheck")
    q:""=ret "0"
    
    q "1"
}

///  当前病历是否包括全部签名 大同三院需求 
ClassMethod HasAllSign(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
	//科主任
	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"ChairmanCheck")
    q:""=ret "0"
    //主任医师 chiefCheck
	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"chiefCheck")
    q:""=ret "0"   
    //主治医师 attendingCheck
	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"attendingCheck")
    q:""=ret "0"
    //质控医师 QCDocCheck
	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"QCDocCheck")
    q:""=ret "0"  
    //质控护士 QCNurseCheck
 	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"QCNurseCheck")
    q:""=ret "0"
    //责任护士 ChargeNurseCheck
 	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"ChargeNurseCheck")
    q:""=ret "0"    
    //作者   
    s ret=##Class(EMRservice.BODataGateway).GetSingleUser(episodeID,printDocID,eprNum)
    q:""=ret "0"
    
    q "1"
}

///  当前病历是否完成三级医师审核
ClassMethod Has3LvlsAudit(episodeID As %String, printDocID As %String, eprNum As %String) As %String
{
    //主任医师 chiefCheck
	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"chiefCheck")
    q:""=ret "0"   
    //主治医师 attendingCheck
	s ret=##Class(EMRservice.BOEMRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"attendingCheck")
    q:""=ret "0"
    //作者   
    s ret=##Class(EMRservice.BODataGateway).GetSingleUser(episodeID,printDocID,eprNum)
    q:""=ret "0"
    
    q "1"
}

///  当前病历是否在集中打印处打印过
/// debug: w ##class(EMRservice.Privilege.BOPrivAssist).HasCentralizePrinted(201868, 27)
ClassMethod HasCentralizePrinted(episodeID As %String, printDocID As %String) As %String
{
	s ret=##Class(EMRservice.BLL.BLCentralizedPrintRecord).GetRecord(episodeID,printDocID)
    q:"0"=ret "0"
    
    q "1"
}

///  当前病历是否被病案室在一键打印处打印过
/// debug: w ##class(EMRservice.Privilege.BOPrivAssist).HasMROneStepPrinted(201868, 512)
ClassMethod HasMROneStepPrinted(episodeID As %String, printDocID As %String) As %String
{
	s ret=##Class(EMRservice.BLL.BLOneStepPrintRecord).GetMRPrintRecord(episodeID,printDocID)
    q:"0"=ret "0"
    
    q "1"
}

/// Desc:根据唯一模板单元的值判断可重复模板是否可以操作
/// Creator:Candyxu
/// Createdate:2013-01-17
/// Input:episodeID 就诊号,printDocID 打印模板ID
/// Output:ret为0 否，1 是
/// Debuge:w ##Class(EMRservice.Privilege.BOPrivAssist).GetFlagByItemValue(2462001,62)
ClassMethod GetFlagByItemValue(episodeID As %String, printDocID As %String) As %String
{
	s ret = 1
	//根据系统参数取模板单元值
	s ItemPara = ##class(EMRmeta.SysOption).GetOptionValueByName("ItemCode")
	q:((ItemPara = "") || ($zcvt(ItemPara,"U") = "NULL")) ret
	s ItemCell = $p(ItemPara,"^",1)
	s DocID = $p(ItemPara,"^",2)
	q:(printDocID '= DocID) ret
	s ret = 0
	//查实例数据
	s Count = ##Class(EMRservice.BOScatterData).GetEMRData(episodeID,ItemCell)
	s RecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_episodeID," ML"_printDocID,""))
	if (RecordID '= "")
	{ 
	   s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(RecordID)
	   q:(objRecord = "") ret
	   s InstanceCount = objRecord.InstanceCount
	   q:(InstanceCount = "") ret
	}else
	{
	   s InstanceCount = 0
	}
	s:(+InstanceCount < +Count ) ret = 1
	q ret
}

/// Desc:取当前操作人职称Rowid Add by Liaowp 2011-09-17
/// return value: 操作人职称Rowid
/// Debug: w ##Class(EMRservice.Privilege.BOPrivAssist).CurUserCareer(argDocID)
ClassMethod CurUserCareer(argDocID As %String) As %String
{
	q:($d(argDocID)=0)||(argDocID="") "-1"
	//获取医护人员表Rowid:ct_careprov
	s CareprovDr=""
	s CareprovDr=$p($g(^SSU("SSUSR",argDocID)),"^",14)
	q:($d(CareprovDr)=0)||(CareprovDr="") "-1"
	
	//获取职务表Rowid
	s CtpcpCarprvtpDr=""
	s CtpcpCarprvtpDr=$p($g(^CTPCP(CareprovDr,1)),"^",4)
	q:($d(CtpcpCarprvtpDr)=0)||(CtpcpCarprvtpDr="") "-1"
	//查看医师职称Rowid: select * from ct_carprvtp
	q CtpcpCarprvtpDr
}

/// Desc:	返回无纸化病历全部提交状态
/// Input：	AEpisodeID : 就诊号
/// Return：已提交:1 未提交:0
/// Debug: w ##class(EMRservice.Privilege.BOPrivAssist).IsMRCommit("4943646")
ClassMethod IsMRCommit(AEpisodeID As %String) As %String
{
	s MRstatus = 0	
	q:(AEpisodeID = "") 0
    s MRstatus = ##Class(DHCEMRFS.BI.BIAdmMRStatus).GetMRCompletionFlag(AEpisodeID)
	q MRstatus
}

/// CreateDate: 2013-09-24
/// CreateUser: zengweishan
/// Desc: 指定用户是否为病历提交者
ClassMethod IsFirstCommitUser(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	s authorId=""
	s authorId=##class(EMRinstance.EMRLogs).GetFirstCommitUserID(argEpisodeID,argDocID,argEMRNum)
	q:(authorId="") "0"

	q:($f("^"_argUserID_"^","^"_authorId_"^")>1) "1"
	q "0"
}

/// CreateDate: 2013-09-24
/// CreateUser: zengweishan
/// Desc: 指定用户是否为"最后一次"病历提交者 
ClassMethod IsLastCommitUser(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	s authorId=""
	s authorId=##class(EMRinstance.EMRLogs).GetLastCommitUserID(argEpisodeID,argDocID,argEMRNum)
	q:(authorId="") "0"

	q:($f("^"_argUserID_"^","^"_authorId_"^")>1) "1"
	q "0"
}

/// CreateDate: 2013-09-27
/// CreateUser: zengweishan
/// Desc: 指定用户是否为"最后一次"病历提交者的上级医师
ClassMethod IsLastCommitUpUser(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	s authorId=""
	s authorId=##class(EMRinstance.EMRLogs).GetLastCommitUserID(argEpisodeID,argDocID,argEMRNum)
	q:(authorId="") "0"

	s doc=##class(EMRservice.Privilege.BOPowerUser).GetById(argUserID)
	q:(doc="") "0"

	q:($f("^"_doc.ChildUsers_"^","^"_authorId_"^")>1) "1"
	q "0"
}

/// CreateUser: zengweishan
/// Desc: 指定用户是否为病历"最后一次"主治医师审核者
ClassMethod IsLastAttendingCheckUser(argEpisodeID As %String, argDocID As %String, argEMRNum As %String, argUserID As %String) As %String
{
	s authorId=""
	s authorId=##class(EMRinstance.EMRLogs).GetLastAttendingCheckUserID(argEpisodeID,argDocID,argEMRNum)
	q:(authorId="") "0"

	q:($f("^"_argUserID_"^","^"_authorId_"^")>1) "1"
	q "0"
}

}
