/// 名称:手术列表
/// 描述:Portal医生角色 D05 查询医生今日手术，明日手术，术后三日
/// 编写者：程鹏
/// 编写日期: 2018-11-09
Class DtPortal.Doctor.D05OperationList Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 查询医生主诊组或个人的手术信息
/// Input：  QueryType      P个人，PG 主诊组；UserCode；      
/// 		 UserCode		用户工号
/// 		 Dateype        1-今日 2-明日 3-术后三日 
/// 服务代码 D05.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D05OperationList","D050101OperaPat","P","4829","1")
Query D050101OperaPat(QueryType As %String, UserCode As %String, Dateype As %String) As DtPortal.Query(ROWSPEC = "bedCode,name,sex,age,medicareNo,admReason,showType,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPAOpRoom,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,OpLevelDesc,opDate,opTime,patLoc,OPstatisDesc,OpType,EpisodeID,PatientID,EMRDocID,EMRInstanceID,locID,UserId,RejectReason")
{
}

ClassMethod D050101OperaPatExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String, Dateype As %String) As %Status
{
	New (qHandle,QueryType,UserCode,Dateype)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	set UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	q:(UserId = "") $$$OK
	set DocId=""
	if UserId'=""  set DocId=$p(^SSU("SSUSR",UserId),"^",14) 
	q:(DocId = "") $$$OK
	
	if QueryType="P" {//个人
		set MUDocIDs="^"_DocId_"^"
	}elseif QueryType="PG" {//主诊组
		//获取医生ID集合
		set MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)
	}else{
		set MUDocIDs="^"_DocId_"^"
	}	    

	
	//"A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室(术毕)，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
	s opStatType="R"   
	
	i Dateype=1 d
	.s StartDate=+$h
	.s EndDate=+$h
	
	.s opStatType=""
	e  i Dateype=2 d
	.s StartDate=+$h+1
	.s EndDate=+$h+1
	.s opStatType=""
	e  i Dateype=3 d   //查询的是术后3日内的数据
	.s StartDate=+$h-3
	.s EndDate=+$h
	.s opStatType="PLF"
	
	
	
	Set Num=0
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	
	Do object.Execute(StartDate,EndDate,"","",opStatType)
	
	While (object.Next()) {
		
		s aNAOPSurgeonId=object.Data("ANAOPSurgeonDR") 			//主刀医生
		s assistant1=object.Data("AssistantFirstCtcpId") 		//1助
		s assistant2=object.Data("AssistantSecondCtcpId") 		//2助
		s assistant3=object.Data("AssistantThirdCtcpId") 		//3助
		s assistantOther=object.Data("AssOtherCtcpStrId") 		//其他助手
		s EpisodeId=object.Data("EpisodeID")
		Set AdmDocID=$p($g(^PAADM(EpisodeId)),"^",9)     //主管医生
		Set AdmDocIDS="^"_AdmDocID_"^"
		Set opDocID="^"_aNAOPSurgeonId_"^"
		
		//主刀和助手集合,如果不是本主诊组患者 但是医生是主刀或者助手也会显示
		set assids="^"_aNAOPSurgeonId_"^"_assistant1_"^"_assistant2_"^"_assistant3_"^"_assistantOther
	
		set tempDocId="^"_DocId_"^"
		continue:(MUDocIDs'[AdmDocIDS)&&(assids'[tempDocId)
		
		set showType=""
		//主诊组患者
		if ((MUDocIDs[AdmDocIDS)&&(AdmDocID'=DocId))
		{
			set:showType'="" showType=showType_"/"_"主诊组"
			set:showType="" showType="主诊组"
		}
		if AdmDocID=DocId
		{
			set:showType'="" showType=showType_"/"_"主管"
			set:showType="" showType="主管"
		}
		
		if aNAOPSurgeonId=DocId
		{
			set:showType'="" showType=showType_"/"_"主刀"
			set:showType="" showType="主刀"
		}
		
		if assistant1=DocId
		{
			set:showType'="" showType=showType_"/"_"一助"
			set:showType="" showType="一助"
		}
		
		if assistant2=DocId
		{
			set:showType'="" showType=showType_"/"_"二助"
			set:showType="" showType="二助"
		}
		
		if assistant3=DocId
		{
			set:showType'="" showType=showType_"/"_"三助"
			set:showType="" showType="三助"
		}
		
		if assistantOther[DocId
		{
			set:showType'="" showType=showType_"/"_"其他助手"
			set:showType="" showType="其他助手"
		}
		
		s OpLevelDesc=object.Data("opLevelDesc")
		s OpLevelId=object.Data("opLevelId")
		if EpisodeId="" Continue
		s patWardId=$p(^PAADM(EpisodeId),"^",70)
		set OPstatisDesc=object.Data("OPstatisDesc")
		if Dateype=2
		{
			continue:((object.Data("OPAStatus")="I"))
			continue:((object.Data("OPAStatus")="P"))
			continue:((object.Data("OPAStatus")="L"))
			continue:((object.Data("OPAStatus")="F"))
		}
		
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
 		s bedCode=$p(patInfoStr,"^",1)
 		s name=$p(patInfoStr,"^",2)
 		s sex=$p(patInfoStr,"^",3)
 		s age=$p(patInfoStr,"^",4)
 		s medicareNo=$p(patInfoStr,"^",5)   //病案号
 		s admReason=$p(patInfoStr,"^",6)    //费用类型
 		s regNo=$p(patInfoStr,"^",7)    //登记号
 		s docDesc=$p(patInfoStr,"^",11)
		s nurseDesc=$p(patInfoStr,"^",12)
		
		s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    	
    	s diagnoseDesc=object.Data("ANAOPPreopDiag")			//术前诊断
    	set:diagnoseDesc="" diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
    	
    	//手术间
    	s oPAOpRoom=object.Data("OPAOpRoom")
    	
    	//手术台次
    	s oPASeq=object.Data("OPASeq")
    	//主刀医生
    	s aNAOPSurgeon=object.Data("ANAOPSurgeon")
    	//b ;2
    	//手术名称
    	s opName=object.Data("OpName")
    	//预计手术开始时间
    	s planOpDate=object.Data("planOpDate")
    	s planOpTime=object.Data("planOpTime")
    	s planOPAStartDateTime=planOpDate_"&nbsp;"_planOpTime
    	
    
    	
    	//手术日期--术后查询用
    	s opDate=""    ;,opTime=""
    	s opDate=object.Data("OpDate")  //修改手术日期
    	//手术时间
    	s opTime=object.Data("OpTime")		
    	set opDate=opDate_""
    	//科室名称--病人所在科室,术后查询用---申请科室
    	s patLoc=""
    	s patLoc=object.Data("OPAAppLocDr")  //申请科室
   
    	s OpType=object.Data("ANASourceTypeDesc") //手术类型
    	s RejectReason=object.Data("RejectReason") //拒绝原因
    	s OpRowID=object.Data("OpaId")  //手术ID
    	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeId)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)
    	d operaInfo
	
	}
  	q $$$OK
operaInfo
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,showType,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPAOpRoom,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,OpLevelDesc,opDate,opTime,patLoc,OPstatisDesc,OpType,EpisodeID,PatientID,EMRDocID,EMRInstanceID,locID,UserId,RejectReason)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Description: 查询医生主诊组或个人的更多手术信息
/// Input：  QueryType      P个人，PG 主诊组；UserCode；      
/// 		 StartDate		查询开始时间
/// 		 EndDate		查询结束时间
/// 		 UserCode		用户工号
/// 		 opStat			手术状态
/// 		 opRoomID		手术间ID
/// 		 opType			手术类型
/// 服务代码 D05.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D05OperationList","D050102OperaPat","P","2018-12-13","2018-12-13",601,"","","","")
Query D050102OperaPat(QueryType As %String, StartDate As %String, EndDate As %String, UserCode As %String, opStat As %String, opRoomID As %String, opType As %String, OpRiJian As %String = "") As DtPortal.Query(ROWSPEC = "bedCode,name,sex,age,medicareNo,admReason,showType,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPAOpRoom,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,OpLevelDesc,opDate,opTime,patLoc,OpType,EpisodeID,PatientID,EMRDocID,EMRInstanceID,locID,UserId,RejectReason,AnaDoctor,DayOperFlag,OPstatisDesc,OpEndDateAndTime")
{
}

ClassMethod D050102OperaPatExecute(ByRef qHandle As %Binary, QueryType As %String, StartDate As %String, EndDate As %String, UserCode As %String, opStat As %String, opRoomID As %String, opType As %String, OpRiJian As %String = "") As %Status
{
	New (qHandle,QueryType,StartDate,EndDate,UserCode,opStat,opRoomID,opType,OpRiJian)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	set UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	q:(UserId = "") $$$OK
	set DocId=""
	if UserId'=""  set DocId=$p(^SSU("SSUSR",UserId),"^",14) 
	q:(DocId = "") $$$OK
	
	if QueryType="P" {//个人
		set MUDocIDs="^"_DocId_"^"
	}elseif QueryType="PG" {//主诊组
		//获取医生ID集合
		set MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)
	}else{
		set MUDocIDs="^"_DocId_"^"
	}	

	s opTypeDesc=""
	if (opType="JiZhen"){
		s opTypeDesc="急诊"
	} elseif (opType="ZeQi") {
		s opTypeDesc="择期"
	} elseif (opType="RiJian") {
		s opTypeDesc="日间"
	}
		
	Set Num=0
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	
	Do object.Execute(StartDate,EndDate,"","",opStat,"","")
	
	While (object.Next()) {
		set OPstatisDesc=object.Data("OPstatisDesc")
		s DayOperFlag=object.Data("DayOperFlag")				//日间手术
		
		continue:((OpRiJian="Y")&&(OpRiJian'=DayOperFlag))
		continue:((OpRiJian="N")&&(""'=DayOperFlag))
		s aNAOPSurgeonId=object.Data("ANAOPSurgeonDR") 			//主刀医生
		s assistant1=object.Data("AssistantFirstCtcpId") 		//1助
		s assistant2=object.Data("AssistantSecondCtcpId") 		//2助
		s assistant3=object.Data("AssistantThirdCtcpId") 		//3助
		s assistantOther=object.Data("AssOtherCtcpStrId") 		//其他助手
		s OpEndDateAndTime=""
		s OpEndDate=object.Data("OpEndDate") 		//手术结束日期
		s OpEndTime=object.Data("OpEndTime") 		//手术结束时间
		s OpEndDateAndTime=OpEndDate_"&nbsp;"_OpEndTime  //手术结束具体时间
		s EpisodeId=object.Data("EpisodeID")
		Set AdmDocID=$p($g(^PAADM(EpisodeId)),"^",9)     //主管医生
		Set AdmDocIDS="^"_AdmDocID_"^"
		Set opDocID="^"_aNAOPSurgeonId_"^"
		
		//主刀和助手集合,如果不是本主诊组患者 但是医生是主刀或者助手也会显示
		set assids="^"_aNAOPSurgeonId_"^"_assistant1_"^"_assistant2_"^"_assistant3_"^"_assistantOther
	
		set tempDocId="^"_DocId_"^"
		continue:(MUDocIDs'[AdmDocIDS)&&(assids'[tempDocId)
		
		set showType=""
		//主诊组患者
		if ((MUDocIDs[AdmDocIDS)&&(AdmDocID'=DocId))
		{
			set:showType'="" showType=showType_"/"_"主诊组"
			set:showType="" showType="主诊组"
		}
		if AdmDocID=DocId
		{
			set:showType'="" showType=showType_"/"_"主管"
			set:showType="" showType="主管"
		}
		
		if aNAOPSurgeonId=DocId
		{
			set:showType'="" showType=showType_"/"_"主刀"
			set:showType="" showType="主刀"
		}
		
		if assistant1=DocId
		{
			set:showType'="" showType=showType_"/"_"一助"
			set:showType="" showType="一助"
		}
		
		if assistant2=DocId
		{
			set:showType'="" showType=showType_"/"_"二助"
			set:showType="" showType="二助"
		}
		
		if assistant3=DocId
		{
			set:showType'="" showType=showType_"/"_"三助"
			set:showType="" showType="三助"
		}
		
		if assistantOther[DocId
		{
			set:showType'="" showType=showType_"/"_"其他助手"
			set:showType="" showType="其他助手"
		}
		
		s OpLevelDesc=object.Data("opLevelDesc")
		
		s OpLevelId=object.Data("opLevelId")
		if EpisodeId="" Continue
		s patWardId=$p(^PAADM(EpisodeId),"^",70)

		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
 		s bedCode=$p(patInfoStr,"^",1)
 		s name=$p(patInfoStr,"^",2)
 		s sex=$p(patInfoStr,"^",3)
 		s age=$p(patInfoStr,"^",4)
 		s medicareNo=$p(patInfoStr,"^",5)   //病案号
 		s admReason=$p(patInfoStr,"^",6)    //费用类型
 		s regNo=$p(patInfoStr,"^",7)    //登记号
 		s docDesc=$p(patInfoStr,"^",11)
		s nurseDesc=$p(patInfoStr,"^",12)
		
		s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    	
    	s diagnoseDesc=object.Data("ANAOPPreopDiag")			//术前诊断
    	set:diagnoseDesc="" diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
    	//手术间
    	s oPAOpRoom=object.Data("OPAOpRoom")
    	s OPAOpRoomDr=object.Data("OPAOpRoomDr")
    	continue:((opRoomID'="")&&(opRoomID'=OPAOpRoomDr))
    	
    	//手术台次
    	s oPASeq=object.Data("OPASeq")
    	//主刀医生
    	s aNAOPSurgeon=object.Data("ANAOPSurgeon")
    	//麻醉医生
    	s AnaDoctor=object.Data("AnaDoctor")
    	//b ;2
    	//手术名称
    	s opName=object.Data("OpName")
    	//预计手术开始时间
   		s planOpDate=object.Data("planOpDate")
    	s planOpTime=object.Data("planOpTime")
    	s planOPAStartDateTime=planOpDate_"&nbsp;"_planOpTime
    	
    	//手术日期--术后查询用
    	s opDate=""    ;,opTime=""
    	s opDate=object.Data("OpDate")  //修改手术日期
    	//手术时间
    	s OpTime=object.Data("OpDate")		
    	set opDate=opDate_""
    	//科室名称--病人所在科室,术后查询用---申请科室
    	s patLoc=""
    	s patLoc=object.Data("OPAAppLocDr")  //申请科室
   
    	s OpType=object.Data("ANASourceTypeDesc") //手术类型
    	
    	continue:((opTypeDesc'="")&&(opTypeDesc'=OpType))
    	s RejectReason=object.Data("RejectReason") //拒绝原因
    	s OpRowID=object.Data("OpaId")  //手术ID
    	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeId)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)
    	d operaInfo1
	
	}
  	q $$$OK
operaInfo1
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,showType,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPAOpRoom,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,OpLevelDesc,opDate,opTime,patLoc,OpType,EpisodeID,PatientID,EMRDocID,EMRInstanceID,locID,UserId,RejectReason,AnaDoctor,DayOperFlag,OPstatisDesc,OpEndDateAndTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
