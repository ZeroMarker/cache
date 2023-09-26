/// 名称: DHCMed.IMPService.Interface
/// 描述: 重点患者的接口
/// 编写者：zhufei
/// 编写日期: 2010-07-29
Class DHCMed.IMPService.Interface Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  同步临床上报与重点患者数据
/// Table：       
/// Input：       
/// Return：      return<0 : 失败 , return>0 : 成功
/// w ##Class(DHCMed.IMPService.Interface).SyncDataCRToIMP("","")
ClassMethod SyncDataCRToIMP(argIMPType As %String, argIMPTypeSub As %String) As %String
{
	New (argIMPType,argIMPTypeSub)
	Set return=0
	Set $ZT="SyncDataCRToIMPErr"
	
	Set TypeID=0
	For {
		Set TypeID=$o(^DHCMed.IMP.PatientTypeD(TypeID))
		Quit:TypeID=""
		Continue:(argIMPType'="")&&(TypeID'=argIMPType)
		Set IsActive=""
		Set objType=##Class(DHCMed.IMP.PatientType).%OpenId(TypeID)
		If $IsObject(objType){
			Set IsActive=objType.IsActive
		}
		If objType'="" Do objType.%Close()
		Continue:IsActive'=1  //重点患者大类 无效
		
		Set TypeSubID=0
		For {
			Set TypeSubID=$o(^DHCMed.IMP.PatientTypeSubI("ParentIDIndex",TypeID,TypeSubID))
			Quit:TypeSubID=""
			Continue:(argIMPTypeSub'="")&&(TypeSubID'=argIMPTypeSub)
			Set IsActive="",NeedCheck=""
			Set objTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(TypeSubID)
			If $IsObject(objTypeSub){
				Set IsActive=objTypeSub.IsActive    //重点患者子类 无效
				Set NeedCheck=objTypeSub.NeedCheck  //是否需要审核
			}
			If objTypeSub'="" Do objTypeSub.%Close()
			Continue:IsActive'=1
			
			Set RelCRID=0
			For {
				Set RelCRID=$o(^DHCMed.IMP.ImpRelationCRI("SubTypeIDIndex",TypeSubID,RelCRID))
				Quit:RelCRID=""
				Set IsActive="",ProjectID=""
				Set objRelCR=##Class(DHCMed.IMP.ImpRelationCR).%OpenId(RelCRID)
				If $IsObject(objRelCR){
					Set IsActive=objRelCR.IsActive  //重点患者子类关联临床上报 无效
					Set ProjectID=objRelCR.ProjectID
				}
				If objRelCR'="" Do objRelCR.%Close()
				Continue:IsActive'=1
				Continue:ProjectID=""
				
				Set ReportID=""
				Set CRID=+$g(^DHCMed.IMP.ImpPatientC("TypeSubCRID",TypeSubID))
				Set rset = ##Class(%ResultSet).%New()
				Set rset.ClassName = "DHCMed.CRService.Interface"
				Set rset.QueryName = "GetRepListByID"
				Set sc = rset.Execute(ProjectID,CRID)
				While (rset.Next(.sc))
				{
					If ($SYSTEM.Status.IsOK(sc))
					{
						Set ReportID=rset.Data("ReportID")
						
						Set (EpisodeID,PatientID,PatName)=""
						Set (RepDate,RepTime,RepDoc,RepResume,RepStatus)=""
						Set (CheckUser,CheckDate,CheckTime)=""
						Set objReport=##Class(DHCMed.CR.Report).%OpenId(ReportID)
						If $IsObject(objReport){
							Set EpisodeID=objReport.EpisodeID
							Set RepDate=objReport.RepDate
							Set:RepDate'="" RepDate=$zd(RepDate,3)
							Set RepTime=objReport.RepTime
							Set:RepTime'="" RepTime=$zt(RepTime,1)
							//Set RepDoc=##Class(DHCMed.Base.SSUser).GetIdByName(objReport.RepDoc)
							Set RepDoc=objReport.RepDoc
							Set RepResume=objReport.Resume
							Set RepStatus=objReport.RepStatus
							Set CheckUser=objReport.CheckUser
							Set CheckDate=objReport.CheckDate
							Set CheckTime=objReport.CheckTime
							Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
							If $IsObject(objPaadm){
								Set PatientID=objPaadm.PatientID
								Set AdmLoc=objPaadm.DepartmentID
								Set AdmDoc=objPaadm.DoctorID
								Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
								If $IsObject(objPatient) {
									Set PatName=objPatient.PatientName
								}
								If objPatient'="" Do objPatient.%Close()
							}
							If objPaadm'="" Do objPaadm.%Close()
						}
						If objReport'="" Do objReport.%Close()
						Continue:EpisodeID=""
						
						Set IMPID=$d(^DHCMed.IMP.ImpPatientI("IndexTypeSubClinRepID"," "_TypeSubID," "_ReportID,0))
						Set objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(IMPID)
						If $IsObject(objIMP) {
							//存在同步数据,检查状态
							Set IMPStatus=..GetStatusByIMPID(IMPID)
						} Else {
							Set IMPStatus=$s(RepStatus="D":"1",RepStatus="Y":"1",RepStatus="R":"0",RepStatus="S":"0",1:"0")
							Set objIMPStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("重点病人状态",IMPStatus,"")
							Set IMPStatusID=objIMPStatus.%Id()
							//不存在同步数据,增加数据
							Set IMPInput=""
							Set $p(IMPInput,$c(1),1)=""
							Set $p(IMPInput,$c(1),2)=EpisodeID
							Set $p(IMPInput,$c(1),3)=PatientID
							Set $p(IMPInput,$c(1),4)=PatName
							Set $p(IMPInput,$c(1),5)=RepDate
							Set $p(IMPInput,$c(1),6)=RepTime
							Set $p(IMPInput,$c(1),7)=TypeSubID
							Set $p(IMPInput,$c(1),8)=IMPStatusID
							Set $p(IMPInput,$c(1),9)=RepDoc
							Set $p(IMPInput,$c(1),10)=RepDate
							Set $p(IMPInput,$c(1),11)=RepTime
							Set $p(IMPInput,$c(1),12)=RepResume
							Set $p(IMPInput,$c(1),13)=RepDoc
							Set $p(IMPInput,$c(1),14)=""
							Set $p(IMPInput,$c(1),15)=""
							Set $p(IMPInput,$c(1),16)=ReportID
							Set $p(IMPInput,$c(1),17)=AdmLoc
							Set IMPID=##Class(DHCMed.IMP.ImpPatient).Update(IMPInput,$c(1))
							
							/*
							//增加状态日志记录
							Set StatusString=""
							Set $p(StatusString,"^",2)=IMPID
							Set $p(StatusString,"^",3)=IMPStatus
							Set $p(StatusString,"^",4)=+$h
							Set $p(StatusString,"^",5)=$p($h,",",2)
							Set $p(StatusString,"^",6)=RepDoc
							Set $p(StatusString,"^",7)=""
							Set flg=##class(DHCMed.IMP.ImpPatStatus).Update(StatusString,"^")
							*/
						}
						If objIMP'="" Do objIMP.%Close()
					} Else {
						Quit
					}
				}
				If $SYSTEM.Status.IsError(sc)
				{
					Set return=-1
					Do $system.OBJ.DisplayError(sc)
				} Else {
					Set return=1
					Set:ReportID'="" ^DHCMed.IMP.ImpPatientC("TypeSubCRID",TypeSubID)=ReportID
					Do rset.Close()
				}
			}
		}
	}
	
	Quit return
	
SyncDataCRToIMPErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  同步临床上报与重点患者状态数据
/// Table：       
/// Input：       
/// Return：      return="重点患者状态"
/// w ##class(DHCMed.IMPService.Interface).GetStatusByIMPID()
ClassMethod GetStatusByIMPID(argIMPID As %String) As %String
{
	New (argIMPID)
	Set return=""
	Set $ZT="GetStatusByIMPIDErr"
	
	Set objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(argIMPID)
	If $IsObject(objIMP) {
		Set ReportID=objIMP.ClinRepID
		Set IMPStatus=objIMP.Status
		Set return=IMPStatus
		Quit:ReportID="" return  //如果没关联临床上报,返回当前状态
		
		//如果有关联临床上报,进行状态同步,进行状态检查
		//Quit:(IMPStatus'="0")&&(IMPStatus'="1") return  //作废和初始状态
		Quit:IMPStatus'="0" return  //作废状态
		
		Set IMPDate="",IMPTime=""
		Set IMPStatusID=$o(^DHCMed.IMP.ImpPatStatusI("IndexParent"," "_IMPID,""),-1)
		Quit:IMPStatusID="" return
		Set objIMPStatus=##Class(DHCMed.IMP.ImpPatStatus).%OpenId(IMPStatusID)
		If $IsObject(objIMPStatus) {
			Set IMPDate=objIMPStatus.OperationDate
			Set IMPTime=objIMPStatus.OperationTime
		}
		If objIMPStatus'="" Do objIMPStatus.%Close()
		Quit:(IMPDate="")||(IMPTime="") return  //如果最后一次的操作日期和时间为空,返回当前状态
		
		Set TypeSubID=objIMP.ImpType
		Set IsActve="",NeedCheck=""
		Set objTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(TypeSubID)
		If $IsObject(objTypeSub){
			Set IsActive=objTypeSub.IsActive    //重点患者子类 无效
			//Set NeedCheck=objTypeSub.NeedCheck  //是否需要审核
		}
		If objTypeSub'="" Do objTypeSub.%Close()
		
		//同步临床上报与电子病历的状态
		Set RepStatus=##class(DHCMed.CRService.Interface).GetStatusByRepID(ReportID)
		
		//同步临床上报与重点患者的状态
		Set objReport=##Class(DHCMed.CR.Report).%OpenId(ReportID)
		If $IsObject(objReport){
			Set RepStatus=objReport.RepStatus
			Set RepDate="",RepTime="",RepUser=""
			Set ChildID=$o(^DHCMed.CR.RepStatusD(ReportID,""),-1)
			Quit:ChildID="" return
			Set RepStatusID=ReportID_"||"_ChildID
			Set objRepStatus=##Class(DHCMed.CR.RepStatus).%OpenId(RepStatusID)
			If $IsObject(objRepStatus) {
				Set RepDate=objRepStatus.UpdateDate
				Set RepTime=objRepStatus.UpdateTime
				Set RepUser=objRepStatus.UserID
			}
			If objRepStatus'="" Do objRepStatus.%Close()
			Quit:(RepDate="")||(RepTime="") return
			
			Quit:IMPDate>RepDate return
			Quit:(IMPDate=RepDate)&&(IMPTime>RepTime) return  //如果重点患者比临床上报操作时间晚,返回当前状态
			
			Set Status=""
			Set tmpStatus=$s(RepStatus="D":"1",RepStatus="Y":"1",RepStatus="R":"0",RepStatus="S":"0",1:"0")
			If tmpStatus="0" {
				Set:IMPStatus'="0" Status="0"  //临床上报删除,同步重点患者删除
			} Else {
				Set:IMPStatus="0" Status="1"  //作废状态的报告同步为初始状态
				Set:IMPStatus="5" Status="1"  //审核退回的报告同步为初始状态
			}
			Quit:Status="" return  //状态没改变 退出
			
			Set objStatus=##Class(DHCMed.SS.Dictionary).GetByTypeCode("重点病人状态",Status,"")
			Set StatusID=objStatus.%Id()				
			Set objIMP.Status=StatusID
			Set sc=objIMP.%Save()
			If $$$ISERR(sc) {
				Do $System.Status.DisplayError(sc)
			} Else {
				//增加状态日志记录
				Set StatusString=""
				Set $p(StatusString,"^",2)=IMPID
				Set $p(StatusString,"^",3)=Status
				Set $p(StatusString,"^",4)=RepDate
				Set $p(StatusString,"^",5)=RepTime
				Set $p(StatusString,"^",6)=RepUser
				Set $p(StatusString,"^",7)=""
				Set flg=##class(DHCMed.IMP.ImpPatStatus).Update(StatusString,"^")
			}
		}
		If objIMP'="" Do objIMP.%Close()
		
		Set return=objIMP.Status
	}
	Quit return
	
GetStatusByIMPIDErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-08-19
/// Description:  重点患者图标接口
/// Table：       
/// Input：       argEpisodeID 就诊号
///               argFormat    返回数据格式
/// Return：      argFormat=0 return=0或1 ; argFormat=0 return=描述
/// w ##class(DHCMed.IMPService.Interface).IsIMPPatient(argEpisodeID,argFormat)
ClassMethod IsIMPPatient(argEpisodeID As %String, argFormat As %String) As %String
{
	New (argEpisodeID,argFormat)
	Set return=$s(argFormat=0:0,1:"")
	Quit:argEpisodeID="" return
	Set $ZT="IsIMPPatientErr"
	
	Set IMPID=0
	For {
		Set IMPID=$o(^DHCMed.IMP.ImpPatientI("PaadmIndex",argEpisodeID,IMPID))
		Quit:IMPID=""
		Set objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(IMPID)
		If $IsObject(objIMP)
		{
			Set Status=objIMP.Status
			Set objStatus=##Class(DHCMed.SS.Dictionary).%OpenId(Status)
			If $IsObject(objStatus)
			{
				Set StatusCode=objStatus.Code
				Set StatusDesc=objStatus.Description
			}
			If objStatus'="" Do objStatus.%Close()
			Set FromDate=objIMP.FromDate
			Set FromTime=objIMP.FromTime
			Set ToDate=objIMP.ToDate
			Set ToTime=objIMP.ToDate
			Continue:($g(StatusCode)'="1")&&($g(StatusCode)'="2")
			Continue:(FromDate'="")&&(FromDate>+$h)
			Continue:(FromTime'="")&&(FromDate=+$h)&&(FromTime>$p($h,",",2))
			Continue:(ToDate'="")&&(ToDate<+$h)
			Continue:(ToTime'="")&&(ToTime=+$h)&&(ToTime<$p($h,",",2))
			
			If argFormat="0"
			{
				Set return=1
			} Else {
				Set IMPTypeSub=objIMP.ImpType
				Set objIMPTypeSub=##Class(DHCMed.IMP.PatientTypeSub).%OpenId(IMPTypeSub)
				If $IsObject(objIMPTypeSub)
				{
					Set IMPTypeSubDesc=objIMPTypeSub.Description
					Set IMPType=objIMPTypeSub.ParentID
					Set objIMPType=##Class(DHCMed.IMP.PatientType).%OpenId(IMPType)
					If $IsObject(objIMPType)
					{
						Set IMPTypeDesc=objIMPType.Description
					}
				}
				Set return=return_";"_$g(IMPTypeDesc)_" "_$g(IMPTypeSubDesc)
			}
		}
		If objIMP'="" Do objIMP.%Close()
	}
	
	Set:return'="" return=$s(argFormat=0:return,1:$e(return,2,$l(return)))
	Quit return
	
IsIMPPatientErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-08-19
/// Description:  取正常未终结的重点患者记录数量(出院结算时检查)
///               有Count条重点患者标记未终结
/// Table：       
/// Input：       argEpisodeID 就诊号
/// Return：      return=Count
/// Test:         w ##class(DHCMed.IMPService.Interface).CheckIMP(argEpisodeID)
/// ToInterface:  web.DHCADTDischarge.GetAbnormalOrder()  //BS新版最终结算检查医嘱接口
///               web.UDHCCLDischarge.GetAbnormalOrder()  //BS旧版最终结算检查医嘱接口
ClassMethod CheckIMP(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=0
	Quit:argEpisodeID="" return
	Set $ZT="CheckIMPErr"
	
	Set IMPID=0,Count=0
	For {
		Set IMPID=$o(^DHCMed.IMP.ImpPatientI("PaadmIndex",argEpisodeID,IMPID))
		Quit:IMPID=""
		Set objIMP=##Class(DHCMed.IMP.ImpPatient).%OpenId(IMPID)
		If $IsObject(objIMP)
		{
			Set Status=objIMP.Status
			Set objStatus=##Class(DHCMed.SS.Dictionary).%OpenId(Status)
			If $IsObject(objStatus)
			{
				Set StatusCode=objStatus.Code
				Set StatusDesc=objStatus.Description
			}
			If objStatus'="" Do objStatus.%Close()
			Continue:$g(StatusCode)'="1"
			Set Count=Count+1
		}
		If objIMP'="" Do objIMP.%Close()
	}
	
	Set return=Count
	Quit return
	
CheckIMPErr
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-09-10
/// Description:  通过paadm判断该患者是否该次就诊是否为重点患者，
/// 				  如果是，判断是否做了转归操作
/// Table：       
/// Input：       paadm
/// Return：      return>0 做了转归操作 return=0 未做转归操作
/// Test:         w ##class(DHCMed.IMPService.Interface).GetImpPatStatusByPaadm(paadm)
ClassMethod GetImpPatStatusByPaadm(paadm As %String) As %String
{
	New (paadm)
	
	Set ret=1
	Quit:$g(paadm)="" ret
	Quit:'$d(^DHCMed.IMP.ImpPatientI("PaadmIndex",paadm)) ret	//该次就诊不是重点患者
	
	Set rowid=""
	For  Set rowid=$o(^DHCMed.IMP.ImpPatientI("PaadmIndex",paadm,rowid)) Quit:rowid=""  Do
	.Set StatusID=""
	.For StatusID=$o(^DHCMed.IMP.ImpPatStatusI("IndexParent"," "_rowid,StatusID),-1) Quit:StatusID=""  Do  //取该次重点患者标记的最后状态
	..Set objStatus=##Class(DHCMed.IMP.ImpPatStatus).%OpenId(StatusID)
	..Quit:'$IsObject(objStatus)
	..Set DicID=objStatus.StatusID
	..Quit:+DicID=0
	..Set objDic=##Class(DHCMed.SS.Dictionary).%OpenId(DicID)
	..Quit:'$IsObject(objDic)
	..Set DicCode=objDic.Code
	..Set:DicCode=1 ret=0	//DicCode=1表示该次就诊有重点患者状态为“初始状态”
	..Do objStatus.%Close()
	..Do objDic.%Close()
	Quit ret
}

}
