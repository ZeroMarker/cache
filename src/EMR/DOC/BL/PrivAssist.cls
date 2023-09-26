/// 名称:	EMR.DOC.BL.PrivAssist
/// 描述:	权限规则脚本函数实现
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PrivAssist Extends (%RegisteredObject, %SOAP.WebService) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PrivAssist";

/// Creator：      
/// CreatDate：    2017-07-21
/// Description:   获取授权权限规则
/// Table：        
/// Input：        userid
/// Output：      医护人员类型code
/// Return：      
/// Others
/// Debug:w ##Class(EMR.DOC.BL.PrivAssist).GetCTCPT(4133)
ClassMethod GetCTCPT(userid As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	q:(userid="") ""
	s SSUSRCTPCP=$p($g(^SSU("SSUSR",userid)),"^",14)
	q:(SSUSRCTPCP="") ""
	s CarPrvTp=$p($g(^CTPCP(SSUSRCTPCP,1)),"^",4)
	q CarPrvTp
}

/// Desc: 	用户是否为患者主管医生(BelongToMe)
/// Modify: yejian
/// Input: 	argPatEpisodeID 就诊号
/// 			argDocID 用户UerID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).IsPatBelongDoc(76,105)
ClassMethod IsPatBelongDoc(argPatEpisodeID As %String, argDocID As %String) As %String
{
	q:($d(argPatEpisodeID)=0)||($d(argDocID)=0)||(argPatEpisodeID="")||(argDocID="") "0"
	s maindoc = ""
	s maindoc = ##class(EMR.DOC.HISInterface.PatientInfoAssist).SSUsrInCharge(argPatEpisodeID)
	q:(maindoc="") "0"
	q:(argDocID = maindoc) "1"
	q "0"
}

/// Desc:	用户是否为指定患者主管医生的上级医生(BelongToSubdoc)
/// Modify: yejian
/// Input 	argPatEpisodeID 就诊号
/// 			argDocID 用户ID
/// OutPut: 1是,0否
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).IsPatBelongSubDocs(76,105)
ClassMethod IsPatBelongSubDocs(argPatEpisodeID As %String, argUserID As %String) As %String
{
	q "1"
	q:($d(argPatEpisodeID)=0)||($d(argUserID)=0)||(argPatEpisodeID="")||(argUserID="") "0"
	s doc = "",maindoc = ""		
	/*
	s doc = ##class(EMR.DOC.BL.PowerUser).GetById(argUserID)
	q:(doc = "") "0"
	s maindoc = ##class(EMR.DOC.HISInterface.PatientInfoAssist).SSUsrInCharge(argPatEpisodeID)
	q:(maindoc = "") "0"
	q:($f("^"_doc.ChildUsers_"^","^"_maindoc_"^")>1) "1"
	*/
	q "0"
}

/// Desc: 	病人是否属于某科室(BelongToLoc)
/// Modify: yejian
/// Input: 	argPatEpisodeID 就诊号
/// 			argLocID 科室ID
/// 			argProductcode 项目标识
/// OutPut: 1是,0否
/// Debug: 	w ##Class(EMR.DOC.BL.PrivAssist).IsPatBelongToLoc(1095,60)
ClassMethod IsPatBelongToLoc(argPatEpisodeID As %String, argLocID As %String, argProductcode As %String = "") As %String
{
	s currentLoc = ""
	s currentLoc = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
	q:(currentLoc = "") "0"
	q:($p(currentLoc,"^",1)=argLocID) "1"
	s locType = ""
	s locType = $p($g(^CTLOC(argLocID)),"^",13)
	if (locType = "W")||(locType = "E")
	{
		s getappointdept = ""
		s getappointdept = ##Class(EMR.DOC.BL.PrivLogic).GetAppointDept(argPatEpisodeID,argProductcode)
		q:(getappointdept=argLocID) "1"	
	}
	q "0"
}

/// Desc: 	病人属于相关科室(BelongToLinkLoc)
/// Modify: yejian
/// Input: 	argPatEpisodeID 就诊号
/// 	    argLocID 科室ID
/// 			argProductcode 项目标识
/// OutPut: 1是,0否
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).IsPatBelongToLinkLoc(201871,34)
ClassMethod IsPatBelongToLinkLoc(argPatEpisodeID As %String, argLocID As %String, argProductcode As %String = "") As %String
{
	q:(argPatEpisodeID = "")||(argLocID = "") "0"
	s locType = ""
	s locType = $p($g(^CTLOC(argLocID)),"^",13)
	if (locType = "W")||(locType = "E")
	{
		s currentLinkLocString = ""
		s currentLinkLocString = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDeptLinkLoc(argPatEpisodeID)
		q:(currentLinkLocString="") "0"
		q:($f(currentLinkLocString,"^"_argLocID_"^")'=0) "1"
		
		//20110624 WANGWENTAO UPDATE - 病历转移科室应该也是当前科室
		s getappointdept = ""
		s getappointdept = ##Class(EMR.DOC.BL.PrivLogic).GetAppointDept(argPatEpisodeID,argProductcode)
		q:(getappointdept = argLocID) "1"
		//20110624 WANGWENTAO UPDATE END
		q "0"
	}
	else
	{
		s currentLoc = ""
		s currentLoc = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(argPatEpisodeID)
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
/// Debug: 		w ##class(EMR.DOC.BL.PrivAssist).IsPatBelongTransLoc(50729,6) 
ClassMethod IsPatBelongTransLoc(argPatEpisodeID As %String, argLocID As %String, argProductcode As %String = "") As %String
{
	q "0"
	s $zt="errhandle"
	q:(($d(argPatEpisodeID)=0)||(argPatEpisodeID="")||($d(argLocID)=0)||(argLocID="")) "0"
	s transLoc=""
	s transLoc=##class(EMR.DOC.BL.PrivLogic).GetAppointDept(argPatEpisodeID,argProductcode)
	q:(transLoc="") "0"
	q:(transLoc=argLocID) "1"
	q "0"
errhandle
	q "0"
}

/// Desc: 	用户是否属于病区[BelongToWard]
/// Modify: yejian
/// Input: 	argPatEpisodeID 就诊号
/// 			argLocID 科室ID
/// OutPut: 1是,0否
ClassMethod IsPatBelongToWard(argPatEpisodeID As %String, argLocID As %String) As %String
{
	s currentWard = ""
	s currentWard = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CareUnit(argPatEpisodeID)
	q:(currentWard = "") "0"

	// 这里不能直接比较rowid，护士登陆时其argLocID是CT_Loc中的科室rowid
	// 需要比较病区的code
	s locCode = $p($g(^CTLOC(argLocID)),"^",1)
	q:($p(currentWard,"^",2) = locCode) "1"
	q "0"
}

/// Desc: 	病人是否已出院 [IsDisCharge]
/// Modify: yejian
/// Input: 	argEpisodeID 就诊号,argProductcode 项目标识
/// OutPut: 1是,0否
ClassMethod IsDisCharge(argEpisodeID As %String, argProductcode As %String = "") As %String
{
	s disDate = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDatePriv(argEpisodeID,argProductcode)
	Q:(disDate'="") "1"
	Q "0"
}

/// Desc: 		用于判断这个患者是否需要写病历,如果是住院患者返回1，如果是门诊患者或退院患者返回0(不可以写病历)
/// 			这个需求是给沈阳做的，因为他们有的时候把患者门诊的记录写了首页，而住院的记录没有写[PatNeedDoc]
/// CreateUser：liaowanpeng
/// Modify: 	yejian
/// Input: 		argEpisodeID 就诊号
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).PatNeedDoc("76")
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
/// Modify: 	yejian
/// Input: 		argDocID 用户ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).UserIsDoc("76")
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
/// CreateUser：yejian， suggested by XueFL for HuaXiYiYuan
/// CreateTime：2009-08-03 
ClassMethod IsOutPatient(argPatEpisodeID As %String) As %String
{
	s RetType = ""
	s PatientType = $p($g(^PAADM(argPatEpisodeID)),"^",2) 
	s RetType = $case(PatientType="I",1:0,:1)
	q RetType
}

/// Desc:		病历作者是否是指定用户，处理三种情况
/// 			1)病历创建者是指定用户，返回1
/// 			2)病历创建者不是指定用户，返回0
/// Creator:	yejian
/// CreateDate: 2014-10-13
/// Input:		argEpisodeID 就诊ID
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsRecBelongDoc(76,"1||1",105)
ClassMethod IsRecBelongDoc(argEpisodeID As %String, ADocumentID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s:(objDocument.CreateUser.%Id() = argUserID) result = 1
	q result
errhandle
	q "0"
}

/// Desc:		病历是否保存(HasSaved)
/// Creator:	yejian
/// CreateDate:	2014-10-13
/// Input:		ADocumentID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).IsRecordInstanceSaved("1||1")
ClassMethod IsRecordInstanceSaved(ADocumentID As %String) As %String
{
	s result = 0
	q:(ADocumentID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s status = objDocument.Status
	s:(status = "Save") result = 1
	q result
}

/// Desc: 		病历是否完成某操作 
/// Creator: 	yejian
/// CreateDate: 2014-10-14
/// Input:		argEpisodeID 就诊ID
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
ClassMethod IsRecordActioned(argEpisodeID As %String, ADocumentID As %String, argAction As %String) As %String
{
	q ##class(EMR.DOC.BL.DocLog).RecHasAction(argEpisodeID,ADocumentID,argAction)
}

/// Desc:		病历是否是提交状态
/// Creator:	yejian
/// CreateDate:	2021-1-11
/// Input:		AEpisodeID 就诊号
/// OutPut: 	1是提交状态,0非提交状态（包括撤销、退回、未提交等）
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).IsRecordCompleted("")
ClassMethod IsRecordCompleted(AEpisodeID As %String) As %String
{
	q "0"
	s result = "0"
	q:(AEpisodeID = "") result
	s outData = ##class(%GlobalBinaryStream).%New()
	s ret = ##Class(EMR.DOC.BL.AdmRecordStatus).GetAdmRecordStatus(AEpisodeID,.outData)
	s ret = outData.Read()
	s:(ret = "1") result = "1" 
	q result
}

/// Desc:       是否住院医师审核
/// Creator:　  yejian
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
///             ADocumentID 病历号
/// Output:     result 0 未审核 1 审核
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsResidentChecked(76,"1||1")
ClassMethod IsResidentChecked(argEpisodeID As %String, ADocumentID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	
	q:(objDocument.EMRStatus = "unfinished") result
	q:(objDocument.EMRStatus.Code = "saved") result
	s result = "1"
	q result
}

/// Desc:       是否主治医师审核
/// Creator:　  yejian
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
///             ADocumentID 病历号
/// Output:     result 0 未审核 1 审核
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsAttendingChecked(76,"1||1")
ClassMethod IsAttendingChecked(argEpisodeID As %String, ADocumentID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	q:(objDocument.EMRStatus = "unfinished") result
	q:(objDocument.EMRStatus.Code = "saved") result
	q:(objDocument.EMRStatus.Code = "residentChecked") result
	s result = "1"
	q result
}

/// Desc:       是否主任医师审核
/// Creator:　  yejian
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
///             ADocumentID 病历号
/// Output:     result 0 未审核 1 审核
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsChiefChecked(76,"1||1")	
ClassMethod IsChiefChecked(argEpisodeID As %String, ADocumentID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	
	q:(objDocument.EMRStatus = "unfinished") result
	q:(objDocument.EMRStatus.Code = "saved") result
	q:(objDocument.EMRStatus.Code = "residentChecked") result
	q:(objDocument.EMRStatus.Code = "attendingChecked") result
	s result = "1"
	q result
}

/// Desc: 		指定用户是否为病历创建人的上级医生
/// Createor: 	yejian
/// CreateDate: 2014-10-14
/// Input:		argEpisodeID 就诊ID
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID	
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsUpUser(76,"1||1",105)
ClassMethod IsUpUser(argEpisodeID As %String, ADocumentID As %String, argUserID As %String) As %String
{
	q "1"
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s authorId = objDocument.CreateUser.%Id()
	/*
	s docInfo = ##class(EMR.DOC.BL.PowerUser).GetById(argUserID)
	q:(docInfo = "") "0"
	s:($f("^"_docInfo.ChildUsers_"^","^"_authorId_"^")>1) result = "1"
	*/
	q result
}

/// Desc: 		指定用户是否为病历状态操作者的上级医生
/// Createor:	yejian
/// CreateDate: 2014-10-14
/// Input:		argEpisodeID 就诊ID
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsUpLevelUser(76,"1||1",105)
ClassMethod IsUpLevelUser(argEpisodeID As %String, ADocumentID As %String, argUserID As %String) As %String
{
	q "1"
	/*
	//没有维护医生级别，则没有上级医生
	s docInfo = ##class(EMR.DOC.BL.PowerUser).GetById(argUserID)
	q:(docInfo = "") "0"
	s docLevel = docInfo.UserLevel
	
	//日志不存在，说明是新建病历，所有医生都是"空"医生的上级医生
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") "0"
	
	s status = objDocument.EMRStatus
	
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
		
		s objDocumentLog = ##Class(EMR.DOC.BL.DocLog).GetFirstLogByFinalStatus(argEpisodeID,ADocumentID,status)
		q:(objDocumentLog = "") "0"
		q:(docLevel = "Chief")&&(objDocumentLog.OperateUserID = argUserID) "1"
	}
	elseif (status = "archieved")
	{
		//已归档，谁也不能修改
		q "0"
	}
	else
	{
		//其他情况取创建者，比较创建者与当前用户的级别关系
		s authorId = objLogs.CreateUserID.%Id()
		s author = ##class(EMR.DOC.BL.PowerUser).GetById(authorId)
		q:(author = "") "0"
		s authorLevel = author.UserLevel
		
		//当前用户级别高于创建者级别
		q:(authorLevel = "intern")&&((docLevel = "Resident")||(docLevel = "Attending")||(docLevel = "Chief")) "1"
		q:(authorLevel = "Resident")&&((docLevel = "Attending")||(docLevel = "Chief")) "1"
		q:(authorLevel = "Attending")&&(docLevel = "Chief") "1"
		//创建者为主任，只有其自己为其上级医师
		q:(authorLevel = "Chief")&&(authorId = argUserID) "1"
	}
	*/
	q "0"
}

/// Desc:		用户是否为病历创建者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
/// Creator: 	yejian
/// CreateDate:	2014-10-31
/// Input:		argEpisodeID 就诊ID
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Deubg:      w ##Class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByGroup(76,"1||1",105)
ClassMethod IsCreatorUpUserByGroup(argEpisodeID As %String, ADocumentID As %String, argUserID As %String) As %String
{
	q "1"
	/*
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s authorId = objDocument.CreateUser.%Id()
	s authorGroupID = $p($g(^SSU("SSUSR",authorId)), "^",5)
	s userGroupID = $p($g(^SSU("SSUSR",argUserID)), "^",5)
	q:(authorGroupID '= userGroupID) result
	s authorLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(authorId)
	s userLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(argUserID)
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
	*/
}

/// Desc:		用户是否为病历操作者的上级医生（判断医生的上下级，根据医生所在医疗组的高级别的医生为他的上级医师)
/// Creator: 	yejian
/// CreateDate:	2014-11-04
/// Input:		argEpisodeID 就诊ID
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsOperateorUpUserByGroup(76,"1||1",105)
ClassMethod IsOperateorUpUserByGroup(argEpisodeID As %String, ADocumentID As %String, argUserID As %String) As %String
{
	q "1"
	/*
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
    s objCurrentInstanLog = ##Class(EMR.DOC.BL.DocLog).GetCurrentInstanceLog(argEpisodeID,ADocumentID)
	q:(objCurrentInstanLog = "") result
	s operaterId = objCurrentInstanLog.OperateUserID
	s operaterGroupID = $p($g(^SSU("SSUSR",operaterId)), "^",5)
	s userGroupID = $p($g(^SSU("SSUSR",argUserID)), "^",5)
	q:(operaterGroupID '= userGroupID) result
	s operaterLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(operaterId)
	s userLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(argUserID)
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
	*/
}

/// Desc:       是否为创建者的上级医师（取his的维护程序）
/// Creaotr:    yejian
/// CreateDate: 2016-8-15 
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByHISGroup("1||1",105)
ClassMethod IsCreatorUpUserByHISGroup(ADocumentID As %String, argUserID As %String) As %String
{
	q "1"
	/*
	s result = "0"
	q:(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s creatorId = objDocument.CreateUser.%Id()
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
	s creatorLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(creatorPvId)
	s userLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(userPvId)
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
	*/
}

/// Desc:       是否为操作者的上级医师（取his的维护程序）
/// Creaotr:    yejian
/// CreateDate: 2016-8-15 
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsOperaterUpUserByHISGroup("1||2",105)
ClassMethod IsOperaterUpUserByHISGroup(ADocumentID As %String, argUserID As %String) As %String
{
	q "1"
	/*
	s result = "0"
	q:(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s operatorId = objDocument.ModifyUser.%Id()
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
	s creatorLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(operatorPvId)
	s userLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(userPvId)
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
	*/
}

/// Desc:		是否出院超过N小时
/// Creator: 	yejian
/// CreateDate:	2022-8-11
/// Input:		argEpisodeID 就诊ID
///             argHours 小时
/// OutPut: 	1 超过 ， 0 没超过
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsDischargedNHours(76,72)
ClassMethod IsDischargedNHours(argEpisodeID As %String, argHours As %Integer) As %String
{
	s result = "0"
	s dischDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
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

/// Desc:	是否已出院5个工作日（死亡患者为10个工作日）
/// Input:	argEpisodeID : 就诊指针
/// Return:	1 ：是， 0 ：否
/// Debug:	w ##Class(EMR.DOC.BL.PrivAssist).IsDisFiveWorkingDay("76")
ClassMethod IsDisFiveWorkingDay(argEpisodeID As %String) As %Boolean
{
	s isOverSpan = "0"
	
	s dateTime = ..GetDeathDateTimeInAdm(argEpisodeID)
 	if (dateTime = "")
 	{
	 	s dateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
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
/// Debug:	w ##Class(EMR.DOC.BL.PrivAssist).IsDisFiveWorkingDay("76")
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
/// Debug：	w ##Class(EMR.DOC.BL.PrivAssist).IsWorkingDay(62557)
ClassMethod IsWorkingDay(argdate As %String) As %Boolean
{
	s ret = 0
	//修改为统一接口
	s dayType=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(argdate,"","")
	//dayType 0工作日 1 假日 2 节日
	s:(dayType=0) ret = 1
	
	q ret
}

/// Desc:	死亡日期时间或者出院日期时间
/// Input:	argEpisodeID : 就诊指针
/// Return:	死亡日期时间或者出院日期时间，格式为  日期,时间
/// Debug:	w ##Class(EMR.DOC.BL.PrivAssist).GetDeathDateTimeInAdm("201764")
ClassMethod GetDeathDateTimeInAdm(argEpisodeID As %String) As %String
{
	s deathDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DeathDateTime(argEpisodeID)
 	s deathDate = $p(deathDateTime,",",1)
 	s deathTime = $p(deathDateTime,",",2)
 	q:(deathDate="")||(deathTime="") ""
 	
 	s isDisOK = "0"
 	s dischDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
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
 	s admDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID)
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	if (deathDate > admDate)||((deathDate = admDate)&&(deathTime > admTime))
 	{	s isAdmOK = "1"	}
 	q:(isAdmOK = "0") ""
 	
 	q deathDateTime
}

/// Desc:       病案室是否病历回收
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// InPut:      argEpisodeID 就诊号
/// OutPut:     1已回收, 0未回收
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsRecordRetrieve(76)
ClassMethod IsRecordRetrieve(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") result
	s status = ##Class(web.DHCWMRService).IGetMrRetrieveStatus(argEpisodeID)
	s:(status = "1") result = 1
	q result
}

/// Desc:       病案室是否已经归档
/// Creator:    yejian
/// CreateDate: 2015-3-12
/// Input:      argEpisodeID 就诊号
/// Output:     result: 1--归档, 0--未归档
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsRecordArchived(76)
ClassMethod IsRecordArchived(argEpisodeID As %String) As %String
{
	s result = "0"
	q:($d(argEpisodeID)=0)||(argEpisodeID="") "0"
	s status = ##Class(web.DHCWMRService).IGetMrArchiveStatus(argEpisodeID)
	s:(status = 1) result = "1"
	q result
}

/// Desc:       病案室是否复印病历
/// Creator:    
/// CreateDate: 2016-11-8
/// Input:      argEpisodeID 就诊号
/// Output:     result: 1--已复印, 0--未复印
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsCopy(76)
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
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).GetDisDate(2)
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
/// Creator:   yejian
/// CreatDate: 2022-8-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##Class(EMR.DOC.BL.PrivAssist).GetAdmTimeSpan("89")
ClassMethod GetAdmTimeGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s admDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID)
 	q:((admDateTime) = "") result
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) result
 	s result = ..GetGapNow(admDate, admTime)	
 	q result
}

/// Desc:      出院时间间隔, 时间单位为小时
/// Creator:   yejian
/// CreatDate: 2022-8-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##(EMR.DOC.BL.PrivAssist).GetDisTimeSpan("89")
ClassMethod GetDisTimeGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s dischDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
 	q:((dischDateTime) = "") result
 	s disDate = $p(dischDateTime,",",1)
 	s disTime = $p(dischDateTime,",",2)
 	q:((disDate = "")||(disTime = "")) result
  	s result = ..GetGapNow(disDate, disTime)	
 	q result
}

/// Desc:      入院时间间隔, 时间单位为小时
/// Creator:   yejian
/// CreatDate: 2022-8-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##class(EMR.DOC.BL.PrivAssist).GetAdmTimeInBedSpan("89")
ClassMethod GetAdmTimeInBedGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s admDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTimeInBed(argEpisodeID)
 	q:((admDateTime) = "") result
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) result
 	s result = ..GetGapNow(admDate, admTime) 	
 	q result
}

/// Desc:      入院时间间隔, 时间单位为小时
/// Creator:   yejian
/// CreatDate: 2022-8-11
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##class(EMR.DOC.BL.PrivAssist).GetInshAdmTimeSpan("89")
ClassMethod GetInhsAdmTimeGap(argEpisodeID As %String) As %Integer
{
	s result = 0
	s admDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).InhsAdmDateTime(argEpisodeID)
 	q:((admDateTime) = "") result
 	s admDate = $p(admDateTime,",",1)
 	s admTime = $p(admDateTime,",",2)
 	q:((admDate = "")||(admTime = "")) result
  	s result = ..GetGapNow(admDate, admTime)
  	q result
}

/// Desc:      取时间和当前间隔
/// Creator:   yejian
/// CreatDate: 2022-8-11
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
/// Creator:   yejian
/// CreatDate: 2022-8-11
/// Input:     APatientID 病人号
/// Output:    1-已经出院 0-目前在院
/// Others:    返回值根据episodeID取得的多个cateCharpter之间用@区分,最后加上!
/// Debug:     d ##class(EMR.DOC.BL.PrivAssist).IsPatientDischarge(48)
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
	s disDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
	s:(disDateTime = "") result = "0"
	q result
}

/// Desc:       取创建者的ssgroupID
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:      ADocumentID
/// Output:     result ssgroupID
ClassMethod GetCreaterGroupID(ADocumentID As %String) As %String
{
    s result = ""
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s createUser = objDocument.CreateUser.%Id()
	s:(createUser '= "") result = $p($g(^SSU("SSUSR",createUser)), "^",5)
	q result
}

/// Desc:       取最后修改者的ssgroupID
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:      ADocumentID
/// Output:     result ssgroupID 空为未取到
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).GetLastModifierGroupID("1||1")
ClassMethod GetLastModifierGroupID(ADocumentID As %String) As %String
{
    s result = ""
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s user = objDocument.ModifyUser.%Id()
	s:(user '= "") result = $p($g(^SSU("SSUSR",user)), "^",5)
	q result
}

/// Description:获得病历授权功能赋予的操作授权
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:AEpisodeID-病人就诊号,AUserID-用户ID,AUserLoc-用户所在部门,ADocumentID(病历id)
/// Others:返回一个字符串,格式如:"set browse=1,print=1"
/// Debug:w ##class(EMR.DOC.BL.PrivAssist).GetAppiont("51","105","6","12||1")
/// 		  w ##class(EMR.DOC.BL.PrivAssist).GetAppiont("1","154","9","210||44","")
/// Modify LIUZHONGWAN 增加一个入参DocID
ClassMethod GetAppiont(AEpisodeID As %String, AUserID As %String, AUserLoc As %String, ADocumentID As %String, ADocID As %String) As %String
{
	q "1"
	s str = ##class(EMR.DOC.BL.AuthAppoint).GetAllActiveAppoint(AEpisodeID,AUserID,AUserLoc,ADocumentID,ADocID)
	q str
}

/// Desc:取患者当前就诊科室id
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:		argEpisodeID 就诊号
/// 		  	argProductcode 项目标识
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).GetCurrentDept("53")
ClassMethod GetCurrentDept(argEpisodeID As %String, argProductcode As %String = "")
{
	
	s currentLocID = ""
	s currentLoc = ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(argEpisodeID)
	if (currentLoc '= "")
	{
		s currentLocID = $p(currentLoc,"^",1)
	}
	else
	{
		s currentLocID = ##Class(EMR.DOC.BL.PrivLogic).GetAppointDept(argEpisodeID,argProductcode)
	}
	q currentLocID
}

/// Desc:取患登录用户的医疗单元信息
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:		argEpisodeID 就诊号
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).GetUserUnit("6","180")
ClassMethod GetUserUnit(argUserLoc As %String, argUserID As %String)
{
	s DocId=$p($g(^SSU("SSUSR",argUserID)),"^",14)
	s UserUnit = ""
	s UserUnit = ..GetUintByDocCode(argUserLoc,DocId)
	q UserUnit
}

/// Desc:取（ICU患者转入ICU之前科室的主管医生）医疗小组（医疗单元）信息
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:		argEpisodeID 就诊号
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).GetBefTransToICUMainDocUnit("44")
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
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:		DepID 科室ID，DocID 用户ID
/// Debug:  w ##class(EMR.DOC.BL.PrivAssist).GetUintByDocCode("6","180") 
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
/// Creator:    yejian
/// CreateDate: 2022-8-11
/// Input:		argEpisodeID 就诊号
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).GetLocBefTransToICU("53")
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

/// Desc:       获取术者ID
/// Creator:    yejian
/// CreateDate: 2016-8-15
/// Input:      ADocumentID 病历ID
/// Output:     1 是 0 否
ClassMethod GetOperationUser(ADocumentID As %String) As %String
{
	q ""
	s result = ""
	q:(ADocumentID = "") result
	s rowId = $o(^EMR.OP.LinkDocumnentsI("IdxDocumentType"," OPERATION"," "_ADocumentID,""))
	s objDoc = ##Class(EMR.OP.LinkDocumnents).%OpenId(rowId)
    q:(objDoc = "")
    s eventId = objDoc.EventsID
    s objOpeation = ##Class(EMR.OP.Operation).%OpenId(eventId)
    q:(objOpeation = "") result
    s result = objOpeation.OperDocID
    q result
}

/// Desc:       获取一助ID
/// Creator:    yejian
/// CreateDate: 2016-8-15
/// Input:      ADocumentID 病历ID
///            argUserID 用户
/// Output:     1 是 0 否
ClassMethod GetOperationAssistFirst(ADocumentID As %String) As %String
{
	q ""
	s result = ""
	q:(ADocumentID = "") result
	s rowId = $o(^EMR.OP.LinkDocumnentsI("IdxDocumentType"," OPERATION"," "_ADocumentID,""))
	s objDoc = ##Class(EMR.OP.LinkDocumnents).%OpenId(rowId)
    q:(objDoc = "")
    s eventId = objDoc.EventsID
    s objOpeation = ##Class(EMR.OP.Operation).%OpenId(eventId)
    q:(objOpeation = "") result
    s result = objOpeation.OperAssistFirstID
    q result
}

/// Desc:	医嘱是否被锁定
/// Creator:    yejian
/// CreateDate: 2016-8-15
/// Input:      AdmID 就诊号
///            	UserID 用户
/// 			LocID 锁ID
/// 			sessionID sessionID
/// Output:		ret=1,被锁定。ret=0,未被锁定。
/// Debug:		w ##class(EMR.DOC.BL.PrivAssist).IsOrdHasLocked("2178",1796,425,"3ptz6TRf00")
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
/// Input:		ADocumentID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).IsRecordOverRan("3")
ClassMethod IsRecordOverRan(ADocumentID As %String) As %String
{
	s result = 0
	q:(ADocumentID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s status = objDocument.Status
	q:(status = "Save") result
	
	s EpisodeID = objDocument.EpisodeID.%Id()
	s TemplateID = objDocument.TemplateID.%Id()
	s DOCCode = objDocument.DOCCode
	s PapmiDR = $P($g(^PAADM(EpisodeID)),"^",1)
	
	s SavedInfo = ..GetSavedInfo(EpisodeID,TemplateID,DOCCode)
	s SavedTimes = $p(SavedInfo,",",1)
	q:(SavedTimes '= 0) result
	
	s Systemdatetime = $HOROLOG
	s Systemdateint = $p(Systemdatetime,",",1)
	s Systemtimeint = $p(Systemdatetime,",",2)
	
	if (TemplateID = "16")  //此处需要维护“入院记录”的模板ID，判断“入院记录”是否超时——入院记录，应在患者入院24小时内完成
	{
		s AdmDateTime = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
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
		s DisDateTime = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
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
		s DeathDateTime = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DeathDateTime(PapmiDR)
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
		s DeathDateTime = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DeathDateTime(PapmiDR)
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
		s AdmDateTime = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
		s AdmDate = $p(AdmDateTime,",",1)
		s AdmTime = $p(AdmDateTime,",",2)
		
		if (DOCCode = "1")   //此处需要维护“首次病程记录”的标题Code，判断“首次病程记录”是否超时——首次病程记录，应在患者入院8小时内完成
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
		
		elseif (DOCCode = "4")   //此处需要维护“首次主治(中)医师查房记录”的标题Code，判断“首次主治(中)医师查房记录”是否超时——首次主治(中)医师查房记录，应在患者入院48小时内完成
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
		elseif (DOCCode = "5")   //此处需要维护“首次主任(副主任以上)医师查房记录”的标题Code，判断“首次主任(副主任以上)医师查房记录”是否超时——首次主任(副主任以上)医师查房记录，应在患者入院72小时内完成
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
		elseif (DOCCode = "8")   //此处需要维护“转入记录”的标题Code，判断“转入记录”是否超时——转入记录，应在患者转科记录书写后24小时内完成
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
/// input: EpisodeID:就诊指针; TemplateID:模板ID; DOCCode:标题Code
/// output: "书写次数,最后一次的创建日期,最后一次的创建时间"
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).GetSavedInfo("52","20","4")
ClassMethod GetSavedInfo(argEpisodeID As %String, argTemplateID As %String, argDocCode As %String) As %String
{
	s count = 0
	s DateTime = ","
	s TILInstaneData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(argEpisodeID)
	s HappenDate = 0
	for
	{
		s HappenDate = $O(@TILInstaneData@("IdxEpisodeStatusHDT",argEpisodeID," SAVE",HappenDate))
		q:(HappenDate = "")
		
		s HappenTime = ""
		for
		{
			s HappenTime = $O(@TILInstaneData@("IdxEpisodeStatusHDT",argEpisodeID," SAVE",HappenDate,HappenTime))
			q:(HappenTime = "")
			
			s rowID = ""
			for
			{
				s rowID = $O(@TILInstaneData@("IdxEpisodeStatusHDT",argEpisodeID," SAVE",HappenDate,HappenTime,rowID))
				q:(rowID = "")
				s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(rowID)
				s TemplateID = objDocument.TemplateID.%Id()
				s DocCode = objDocument.DOCCode
				s CreateDate = objDocument.CreateDate
				s CreateTime = objDocument.CreateTime
				if (argDocCode = "")
				{
					if (TemplateID=argTemplateID)
					{
						s count = count+1
						s DateTime = CreateDate_","_CreateTime
					}
				}
				else
				{
					if ((TemplateID=argTemplateID)&&(DocCode=argDocCode))
					{
						s count = count+1
						s DateTime = CreateDate_","_CreateTime
					}
				}
			}
		}
	}
	q count_","_DateTime
}

/// Desc:       青医判断是否可确认病历全部完成，即“送病案室”
/// Creator:　  Donglulu
/// CreateDate: 2017-3-29
/// Input:      argEpisodeID 就诊号
/// Output:     result 0 未结算 1 已结算
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsDocCommit(76)
ClassMethod IsDocCommit(argEpisodeID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "") result
	s result = ##class(DHCEPRFS.BL.BLPrivilege).CheckDocCommitPrivilege(argEpisodeID)
	q result
}

/// Desc:       病历是否有有效签名(任何级别都可以)
/// Creator:　  yejian
/// CreateDate: 2022-8-5
/// Input:      ADocumentID 病历实例ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).HasValidSign("1||1")
ClassMethod HasValidSign(ADocumentID As %String) As %String
{
	s strRes = "0"
	q:(ADocumentID = "") strRes
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(ADocumentID,0)
	q:(objDoc = "") strRes
	s AEpisodeID = objDoc.EpisodeID.%Id()
	s TILEMRSign = ##class(EMR.DAO.EMRSign).GetTureIndexLocation(AEpisodeID)
	s signID=""
	for {
	    s signID=$O(@TILEMRSign@("IdxDocument", ADocumentID, signID),-1)
	    q:(signID="")
	    s sign=##Class(EMR.DAO.EMRSign).doOpenByID(AEpisodeID,signID)
	    s:(sign.isValid="1") strRes = "1"
	    q:(strRes = "1")
	}
	q strRes
}

/// Desc:      转科时间间隔, 时间单位为小时
/// Creator:   Donglulu
/// CreatDate: 2017-11-21
/// Input:     argEpisodeID:病人就诊rowid
/// Output:    时间间隔，时间单位为小时(返回-1说明没有转过科)
/// Debug:     w ##(EMR.DOC.BL.PrivAssist).GetTransCTLOCGap("89")
ClassMethod GetTransCTLOCGap(argEpisodeID As %String) As %Integer
{
	s result = -1
	s transMessage = ##class(Nur.DoctorOrderSheet).GetPreviousLoc(argEpisodeID)
 	q:(transMessage = "") result
 	s transDate = $p(transMessage,"^",2)
 	s transTime = $p(transMessage,"^",3)
 	q:((transDate = "")||(transTime = "")) result
  	s result = ..GetGapNow(transDate, transTime)	
 	q result
}

/// Desc:       该科室是否为转科前科室
/// Creator:　  Donglulu
/// CreateDate: 2017-7-31
/// Input:      argEpisodeID:病人就诊rowid   argLocID 当前用户科室ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsTransPreviousCTLOC("","")
ClassMethod IsTransPreviousCTLOC(argEpisodeID As %String, argLocID As %String) As %String
{
	s result = "0"
	q:((argEpisodeID = "")||(argLocID = "")) result
	s transMessage = ##class(Nur.DoctorOrderSheet).GetPreviousLoc(argEpisodeID)
 	q:(transMessage = "") result
 	s transLoc = $p(transMessage,"^",1)
 	s:(transLoc = argLocID) result = "1"
	q result
}

/// Desc:		用户是否为病历最后操作者
/// Creator: 	Donglulu
/// CreateDate:	2018-1-10
/// Input:		argEpisodeID 就诊ID
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsOperateor(76,"1||1",105)
ClassMethod IsOperateor(argEpisodeID As %String, ADocumentID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
    s objCurrentInstanLog = ##Class(EMR.DOC.BL.DocLog).GetCurrentInstanceLog(argEpisodeID,ADocumentID)
	q:(objCurrentInstanLog = "") result
	s operaterId = objCurrentInstanLog.OperateUserID
	q:(operaterId = "") result
	s:(operaterId = argUserID) result = 1
	q result
}

/// Desc:       用户是否为病历操作者的HIS医疗组组长
/// Creaotr:    Donglulu
/// CreateDate: 2018-1-11 
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsOperaterHISGroupLeader("1||2",105)
ClassMethod IsOperaterHISGroupLeader(ADocumentID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s operatorId = objDocument.ModifyUser.%Id()
	q:(operatorId = "") result
	
	s operatorPvId = $p($g(^SSU("SSUSR",operatorId)),"^",14)
	q:(operatorPvId="") result
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(userPvId="") result
	s result = ##class(EMR.DOC.BL.PrivAssist).IsCTLOCLederFlag(userPvId,operatorPvId)
	q result
}

/// 判断ctcareOneDr是不是ctcareTwoDr的医疗组组长
/// Input:医护人员表ID
/// Output:1是,0否
/// w ##class(EMR.DOC.BL.PrivAssist).IsCTLOCLederFlag("1076","1069")
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
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsAdmRecDep(76,445)
ClassMethod IsAdmRecDep(argEpisodeID As %String, argUserLoc As %String, argProductcode As %String = "") As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argUserLoc = "") result
	s admRecDep = ##Class(EMR.DOC.BL.PrivAssist).GetAdmRecDep(argEpisodeID)
	q:(admRecDep = "") result
	k ^TempEMRAdmRecDep("EMR")
	s count = 0
	s appointTime = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("appointBrowseTime",argProductcode,"86400")
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
	s appointEndDateTime = ##class(EMR.DOC.COM.DateTimeFormat).GetEndDateTime(ordDate,ordTime,appointTime)
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
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).GetAdmRecDep(76)
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

/// Desc:	判断是否会诊医生 		
/// 		w ##class(EMR.DOC.BL.PrivAssist).IscoustUser("2178",1796,425,"3ptz6TRf00")	
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
/// Debug:         w ##Class(EMR.DOC.BL.PrivAssist).IsEpdReport(7053)
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
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).GetConsultDateTime(10313803,99)
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
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsAdmConsultDep(76,445)
ClassMethod IsAdmConsultDep(argEpisodeID As %String, argUserLoc As %String) As %String
{
	s result = "0"
	q:(argEpisodeID = "")||(argUserLoc = "") result
	s admConsultDep = ##Class(EMR.DOC.BL.PrivAssist).GetConsultDateTime(argEpisodeID)
	q:(admConsultDep = "") result
	k ^TempEMRAdmConsultDep("EMR")
	s count = 0
	s appointTime = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("AppointEditTime",argProductcode,"86400")
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s admConsultDepCount=$l(admConsultDep, "@@")
	f i=1:1:admConsultDepCount 
	{
		s locInfo = $p(admConsultDep, "@@", i)
		q:(locInfo = "")
		s locID = $p(locInfo, "^", 1)
		continue:(locID = "")
		s tmpordDate = $p(locInfo, "^", 2)
		continue:(tmpordDate = "")
		s tmpordTime = $p(locInfo, "^", 3)
		continue:(tmpordTime = "")
		s ^TempEMRAdmConsultDep("EMR",locID,tmpordDate,tmpordTime,count) = locInfo
		s count = count + 1	
		
	}
	s ordDate = $o(^TempEMRAdmConsultDep("EMR",argUserLoc,""),-1)
	q:(ordDate = "") result
	s ordTime = $o(^TempEMRAdmConsultDep("EMR",argUserLoc,ordDate,""),-1)
	q:(ordTime = "") result
	s appointEndDateTime = ##class(EMR.DOC.COM.DateTimeFormat).GetEndDateTime(ordDate,ordTime,appointTime)
	q:(appointEndDateTime = "") result
	s ordEndDate = $p(appointEndDateTime, ",", 1)
	s ordEndTime = $p(appointEndDateTime, ",", 2)

	///授权截止日期小于当前日期,授权已过期
	q:(ordEndDate < date) result
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(ordEndDate = date)&&(ordEndTime < time) result
	s result = "1"
	k ^TempEMRAdmConsultDep("EMR")
	q result
}

/// Desc:		根据就诊号和用户ID判断登陆者是否主刀医师（根据手麻接口反正值第四个为主刀医师，以#分隔）
/// Input:		Adm 就诊ID
/// OutPut: 	主刀医师ID       
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).isAdmOperInfoForEMR(10313803)
ClassMethod IsAdmOperInfoForEMR(AdmId, UserID As %String) As %String
{
	s isoperInfo="0"
	q:(AdmId="") isoperInfo
	s stroperInfo=""
	s isExist =##Class(EMR.DOC.COM.ClassDefine).CheckMethodExist("web.DHCANAdaptor||GetAdmDayOperInfoForEMR")
	if (isExist="1")
	{
		s reslut =##ClASS(web.DHCANAdaptor).GetAdmDayOperInfoForEMR(AdmId)
	    q:(reslut="") stroperInfo
	    s strUserID = "#"_UserID_"#"
	    if (reslut [ strUserID)
	    {
		    s isoperInfo = "1"
	    }
    }
	q isoperInfo
}

/// Desc:		护士确认病历是否完成
/// Input:		Adm 就诊ID
/// OutPut: 	完成标示：0：未完成；1：完成      
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).isFinalNurseFlag(10313803)
ClassMethod IsFinalNurseFlag(AdmId) As %String
{
	s isFinalFlag="0"
	q:(AdmId="") isFinalFlag
	s isExist =##Class(EMR.DOC.COM.ClassDefine).CheckMethodExist("DHCEPRFS.BI.BIAdmMRStatus||GetFinalAccountFlag")
	if (isExist="1")
	{
		s isFinalFlag =##Class(DHCEPRFS.BI.BIAdmMRStatus).GetFinalAccountFlag(AdmId)
    }
	q isFinalFlag
}

/// 是否当前用户为患者历次就诊中门诊就诊的接诊医师
/// lifb
/// 20190118
/// 通过判定当前用户是否为患者所有就诊中，门诊就诊接诊医生。
/// ##Class(EMR.DOC.BL.PrivAssist).IsOPVisitDoctor(217,863,4634)
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

/// Desc:      门诊病历历史就诊界面，要引用的病历模板版本是否为当前最新版本
/// Creator:   
/// CreatDate: 2019-3-27
/// Input:     ADocumentID:注意此实例ID为要引用的病历实例ID，非当前正在书写的病历实例ID
/// Output:    1是，0否
/// Debug:     w ##Class(EMR.DOC.BL.PrivAssist).IsLatestVersion("1465||45")
ClassMethod IsLatestVersion(ADocumentID As %String) As %String
{
	s result = 0
	q:(ADocumentID = "") result	
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s TemplateVersion = objDocument.TemplateVersion
	q:(TemplateVersion = "") result
	
	s TemplateObj = objDocument.TemplateID
	q:(TemplateObj = "") result
	s PublishVersion = TemplateObj.TempPublishVersion   //2022/5/16做过修改PublishVersion替换为TempPublishVersion
	s:(PublishVersion = TemplateVersion) result = 1
	q result
}

/// Desc:      门诊病历历史就诊界面，要引用的病历所属就诊，与当前时间间隔，时间单位为小时
/// Creator:   
/// CreatDate: 2019-3-27
/// Input:     ADocumentID:注意此实例ID为要引用的病历实例ID，非当前正在书写的病历实例ID
/// Output:    时间间隔，时间单位为小时
/// Debug:     w ##Class(EMR.DOC.BL.PrivAssist).GetOpHistoryAdmTimeGap("1465||45")
ClassMethod GetOpHistoryAdmTimeGap(ADocumentID As %String) As %Integer
{
	s result = 0
	q:(ADocumentID = "") result	
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s EpisodeID = objDocument.EpisodeID.%Id()
	q:(EpisodeID = "") result
	
	s result = ..GetAdmTimeGap(EpisodeID)
	q result
}

/// Desc:		当前模板是否可以创建
/// Creator: 	yejian
/// CreateDate:	2022-8-11
/// Input:		argEpisodeID 就诊号     
/// 			argDocCode 业务活动记录编码
/// 			argProductcode 项目标识
/// OutPut: 	1是,0否
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).CanCreateByFisrtRecord(4,68)
ClassMethod CanCreateByFisrtRecord(argEpisodeID As %String, argDocCode As %String, argProductcode As %String = "") As %String
{
	s ret = 1
	q:(argEpisodeID = "")||(argDocCode = "") ret
	//s recordConfig = "FirstDocCode^EMR010201!DocCode^EMR010202|FirstDocCode^EMR010201!DocCode^EMR010202"
	s recordConfig = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("recordCreationConfig",argProductcode,"")
	q:(recordConfig = "") ret
	s count = $l(recordConfig,"|")
	for i=1:1:count
	{
		s recordName = "",recordData = ""
		s recordList = ##class(EMR.DOC.BL.PrivRuleRun).ParseEnvInfo($p(recordConfig,"|",i),.recordName,.recordData)
		s fisrtDocid = $lg(recordData,$lf(recordName,"FirstDocCode"))
		s docid = $lg(recordData,$lf(recordName,"DocCode"))
		continue:(argDocCode '= docid)
		s tmpresult = ##Class(EMR.DOC.BL.DocumentData).IsHasInstanceByBDMCode(argEpisodeID,"",argDocCode)
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
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).GetCreateDocQualityList(4,68,1)
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
/// Debug: 	w ##Class(EMR.DOC.BL.PrivAssist).IsPatRecentAdmBelongToLoc(32,4)
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
			
			s result = ##Class(EMR.DOC.BL.PrivAssist).IsPatBelongToLoc(episodeID,argLocID)
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
/// Debug: 	w ##Class(EMR.DOC.BL.PrivAssist).GetMessageFlagByEpisodeID(32)
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
/// Input:		ADocumentID 病历ID
/// OutPut: 	病历创建者userid
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).GetRecCreator("1||1")
ClassMethod GetRecCreator(ADocumentID As %String) As %String
{
	s result = ""
	q:(ADocumentID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s result = objDocument.CreateUser.%Id()
	q result
}

/// Desc:		登录用户是否为病历的签名医师
/// Creator:	yejian
/// CreateDate: 2022-8-11
/// Input:		argEpisodeID 就诊号
/// 			ADocumentID 病历ID
/// 			argUserID 用户ID
/// OutPut: 	1 是  0 不是
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsRecSignUser("1||1",105)
ClassMethod IsRecSignUser(argEpisodeID As %String, ADocumentID As %String, argUserID As %String) As %String
{
	s result = "0"
	q:(argEpisodeID="")||(ADocumentID = "")||(argUserID = "") result
	s signID = ""
	s TILEmrSign = ##class(EMR.DAO.EMRSign).GetTureIndexLocation(argEpisodeID)
	for
	{
		s signID = $o(@TILEmrSign@("IdxDocument",ADocumentID,signID))
		q:(signID = "")
		s objSign = ##Class(EMR.DAO.EMRSign).doOpenByID(argEpisodeID,signID)
		q:(objSign = "")
		if (argUserID = objSign.UsrID)
		{
			s result = "1"
			q
		}
	}
	q result
}

/// Desc:       是否为创建者的上级医师（取his的维护程序,安医附院，不分医疗组）
/// Creaotr:    董璐璐
/// CreateDate: 2019-10-30
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByHISAY("1||1",105)
ClassMethod IsCreatorUpUserByHISAY(ADocumentID As %String, argUserID As %String) As %String
{
	q "0"
	s result = "0"
	q:(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s creatorId = objDocument.CreateUser.%Id()
	s creatorPvId = $p($g(^SSU("SSUSR",creatorId)),"^",14)
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(creatorPvId = "")||(userPvId = "") result
	s creatorLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(creatorPvId)
	s userLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(userPvId)
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
/// Input:     ADocumentID 实例ID,argUserID 用户ID
/// Output:    0/1/2/3...
/// Debug:     w ##Class(EMR.DOC.BL.PrivAssist).GetAutoApplyCount("235||4","10209")
/// 
ClassMethod GetAutoApplyCount(ADocumentID As %String, argUserID As %String) As %String
{
	q "0"
	s result = 0
	q:((ADocumentID = "")||(argUserID = "")) result
	
	s result = ##Class(EMR.DOC.BL.ApplyEdit).GetApplyCount(ADocumentID,argUserID)
	q result
}

/// Desc:      返回当前病历，当前医生门诊自动审批次数
/// Creator:   
/// CreatDate: 2020-01-06
/// Input:     AUserLocID 当前登录科室ID, ASelEpisodeID 选中数据就诊号
/// Output:    0/1
/// Debug:     w ##Class(EMR.DOC.BL.PrivAssist).IsSameUserLocTypeWithSelEpisode(95,8)
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
///  			ADocumentID 
///  			AAction(需要判断的病历操作)
///  return:		"^id^id^id^id^id^"
///  debug: 		w ##class(EMR.DOC.BL.PrivAssist).GetActionOperUserSSGroupID(76,"1||1","print")
/// 
ClassMethod GetActionOperUserSSGroupID(AEpisodeID As %String, ADocumentID As %String, AAction As %String) As %String
{
	
	s $zt="errhandle"
	s result = ""
	q:(AEpisodeID = "")||(ADocumentID = "")||(AAction = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	s TILdocLogs = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(AEpisodeID)
	s EMRLogsId = $o(@TILdocLogs@("IdxDoc",ADocumentID,""))
	q:(EMRLogsId = "") result
	s tmpDate="",resultList=""
	for
	{
		s tmpDate =$o(@TILdocLogs@("IdxDocActionDateTime",ADocumentID," "_$zcvt(AAction,"U"),tmpDate))
		q:(tmpDate="")
		
		s tmpTime=""
		for
		{
			s tmpTime =$o(@TILdocLogs@("IdxDocActionDateTime",ADocumentID," "_$zcvt(AAction,"U"),tmpDate,tmpTime))
			q:(tmpTime="")
			
			s instanceLogID=""
			for
			{
				s instanceLogID =$o(@TILdocLogs@("IdxDocActionDateTime",ADocumentID," "_$zcvt(AAction,"U"),tmpDate,tmpTime,instanceLogID))
				q:(instanceLogID="")
				s objDocumentLog = ##class(EMR.DAO.DocLog).doOpenByID(AEpisodeID,instanceLogID)
				continue:(objDocumentLog="")
				
				s operUserID = objDocumentLog.OperateUserID.%Id()
				
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
/// Input:		ADocumentID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: w ##Class(EMR.DOC.BL.PrivAssist).IsRecordInstanceSealed("5","225||1")
ClassMethod IsRecordInstanceSealed(AEpisodeID As %String, ADocumentID As %String) As %String
{
	s result = 0
	q:(ADocumentID = "")||(AEpisodeID = "") result
	if (##class(%Dictionary.CompiledMethod).%ExistsId("DHCWMR.MO.SealRecordEpr||CheckByAdmInstance") = 1)
	{
		s Sealed = ##class(DHCWMR.MO.SealRecordEpr).CheckByAdmInstance(AEpisodeID,ADocumentID)
		s:(Sealed = 1) result = 1
	}
	q result
}

/// Desc:      门诊历史病历，要引用的病历是否为当前就诊类型
/// Creator:   Lina
/// CreatDate: 2020-3-20
/// Input:     argEpisodeID:当前就诊号
///            ADocumentID:注意此实例ID为要引用的病历实例ID，非当前正在书写的病历实例ID
/// Output:    1是,0否
/// Debug:     w ##Class(EMR.DOC.BL.PrivAssist).IsBelongToCurrentAdmType("5","1465||45")
ClassMethod IsBelongToCurrentAdmType(argEpisodeID As %String, ADocumentID As %String) As %String
{
    s result = 0
    q:(argEpisodeID = "")||(ADocumentID = "") result
    s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
    q:(objDocument = "") result
    s admType = $p($g(^PAADM(objDocument.EpisodeID.%Id())),"^",2)
    s currentAdmType = $p($g(^PAADM(argEpisodeID)),"^",2)
    s:(admType = currentAdmType) result = 1
    q result
}

/// Desc:		病历是否与输血申请单关联
/// Creator:	donglulu
/// CreateDate:	2020-4-9
/// Input:		ADocumentID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).IsLinkBlood("289||1")
ClassMethod IsLinkBlood(ADocumentID As %String) As %String
{
	q "0"
	s result = 0
	q:(ADocumentID = "") result
	s rowid = $o(^EMR.OP.InstanceLinkProductI("IdxDocumentID"," "_ADocumentID,""))
	s objDocument = ##class(EMR.OP.InstanceLinkProduct).%OpenId(rowid)
	q:(objDocument = "") result
	s fromType = objDocument.FromType
	s:(fromType = "BLOODTRANS") result = 1
	q result
}

/// Desc:		病历是否有住院及以上级别签名（EMRmeta.SignRole的RoleLevel大于0）
/// Creator:	donglulu
/// CreateDate:	2020-8-11
/// Input:		ADocumentID 病历实例ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).HasAboveResidentLevelSign("118||23")
ClassMethod HasAboveResidentLevelSign(pEpisodeID As %String, ADocumentID As %String) As %String
{
	s result = 0
	q:(pEpisodeID="")||(ADocumentID = "") result
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(pEpisodeID)
	s rowID = ""
	for
	{
		s rowID = $o(@TILEMRSign@("IdxDocument",ADocumentID,rowID))
		q:(rowID = "")
		s objSign = ##class(EMR.DAO.EMRSign).doOpenByID(pEpisodeID,rowID)
		continue:(objSign = "")
		continue:(objSign.isValid = "0")
		s action = objSign.Action
		continue:(action = "")
		
		s id = $o(^CF.EMR.DOC.SignRoleI("IdxActionCode"," "_$zcvt(action,"U"),""))
		continue:(id = "")
		s roleObj = ##Class(CF.EMR.DOC.SignRole).%OpenId(id)
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
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).IsCreatorUpUserByHIS("1||1",105)
ClassMethod IsCreatorUpUserByHIS(ADocumentID As %String, argUserID As %String) As %String
{
	q "0"
	s result = "0"
	q:(ADocumentID = "")||(argUserID = "") result
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument = "") result
	q:(objDocument.Status = "UnSave") "1" 
	s creatorId = objDocument.CreateUser.%Id()
    q:(creatorId = "") "1"   //创建者为空时应默认为创建者上级
	s creatorPvId = $p($g(^SSU("SSUSR",creatorId)),"^",14)
	s userPvId = $p($g(^SSU("SSUSR",argUserID)),"^",14)
	q:(creatorPvId = "")||(userPvId = "") result
	
	s creatorLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(creatorPvId)
	s userLevel = ##class(EMR.DOC.BL.PowerUser).GetHisUserLevel(userPvId)
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

/// Desc:       病历是否有有效的患者签名
/// CreateDate: 2020-11-11
/// Input:      pEpisodeID 就诊号
/// 			ADocumentID 病历实例ID
/// Output:     result 0 无(无签名以及有失效签名) 1 有
/// Debug:      w ##Class(EMR.DOC.BL.PrivAssist).HasValidAnySign("1||1")
ClassMethod HasValidAnySign(pEpisodeID As %String, ADocumentID As %String) As %String
{
	s result = "0"
	s TILEMRSign = ##Class(EMR.DAO.EMRSign).GetTureIndexLocation(pEpisodeID)
	q:(pEpisodeID="")||(ADocumentID = "") result
	s signID=""
	for {
	    s signID=$O(@TILEMRSign@("IdxDocument", ADocumentID, signID),-1)
	    q:(signID="")
	    s sign=##Class(EMR.DAO.EMRSign).doOpenByID(pEpisodeID,signID)
	    s:((sign.isValid="1")&&(sign.Type="AnySign")) result = "1"
	    q:(result = "1")
	}
	q result
}

/// Desc:		转科患者，病历HappenDateTime时刻科室与当前登录科室是否一致。
/// Creator:	lifengbo
/// CreateDate:	2021-2-4
/// Input:		ADocumentID 病历实例ID;AUserLocID 当前登录科室
/// OutPut: 	1 一致,0不一致
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).IsLinkBlood("289||1")
ClassMethod IsSameLocInstanceWithUser(ADocumentID As %String, AUserLocID As %String) As %String
{
	s result=1
	
	s objDocument=##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument="") result
	q:(objDocument.Status'="Save") result
	
	s happenDate= objDocument.HappenDate
	s happenTime = objDocument.HappenTime
	s episodeId = objDocument.EpisodeID.%Id()
	
	s InstanceFinishLocID = ..GetTransLocIDByDateTime(episodeId,happenDate,happenTime)
	
	s:((InstanceFinishLocID'="")&&(InstanceFinishLocID'=AUserLocID)) result=0

	q result
}

ClassMethod GetTransLocIDByDateTime(AEpisodeID As %String, ADate As %String, ATime As %String) As %String
{
	s result=""
	
	s TransLocInfo = ##class(EMR.DOC.HISInterface.PatientInfoAssist).TransDeptDetail(AEpisodeID,"")
	q:((TransLocInfo="")||(TransLocInfo="无")) result
	
	//创建转科相关的时间Global
	s repid=$i(^CacheTemp)
	k ^CacheTemp(repid,"EMRTrans")
	
	for i=1:1:$l(TransLocInfo,"->")
	{
		s tmpLocInfo = $p(TransLocInfo,"->",i)
		
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
/// Input:		ADocumentID 病历实例ID;AUserLocID 当前登录科室
/// OutPut: 	"" 未找到实例； 非空 科室ID
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).GetLocIDAtInstanceFinish("289||1")
ClassMethod GetLocIDAtInstanceFinish(ADocumentID As %String) As %String
{
	s result=""
	
	s objDocument=##Class(EMR.DAO.DocumentData).doOpenByID(ADocumentID)
	q:(objDocument="") result
	q:(objDocument.Status'="Save") result
	s happenDate= objDocument.HappenDate
	s happenTime = objDocument.HappenTime
	s episodeId = objDocument.EpisodeID.%Id()
	
	s InstanceFinishLocID = ..GetTransLocIDByDateTime(episodeId,happenDate,happenTime)
	
	//非转科患者，取当前科室ID
	s:(InstanceFinishLocID ="") InstanceFinishLocID=$p(##class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDept(episodeId,""),"^",1)

	s result = InstanceFinishLocID
	
	q result
}

/// Desc:		用户是否为护士[UserIsNur]
/// Modify: 	yejian
/// Input: 		argDocID 用户ID
/// OutPut: 	1是,0否
/// Debug: 		w ##Class(EMR.DOC.BL.PrivAssist).UserIsNur("76")
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

}
