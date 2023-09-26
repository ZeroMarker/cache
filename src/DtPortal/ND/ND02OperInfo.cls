/// creator:        bmz
/// date:           2014.9.11
/// description:    手术患者服务定义
Class DtPortal.ND.ND02OperInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 白明哲
/// CreatDate： 2014-9-10
/// Description: 查询各病区各类别的手术人数
/// Input：  DateType----1、今天 2、明天        
/// Return： 手术级别名称、手术级别ID、手术级别Code、手术量
/// 服务编码：ND02.01.01  
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND02OperInfo","ND020101FindOpTypeNum","2")
Query ND020101FindOpTypeNum(DateType As %String = "") As DtPortal.Query(ROWSPEC = "opLevelDesc:%String,opLevelId:%String,opLevelCode:%String,opNum:%String")
{
}

ClassMethod ND020101FindOpTypeNumExecute(ByRef qHandle As %Binary, DateType As %String = "") As %Status
{
	n (qHandle,DateType)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	if DateType=1 d
	.Set StartDate=$zd(+$h,3)   //
	.Set EndDate=$zd(+$h,3)
	
	if DateType=2 d
	.Set StartDate=$zd(+$h+1,3)   //
	.Set EndDate=$zd(+$h+1,3)
	
	i DateType="" q $$$OK
	k WardNum($j,"opLevel")
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	Do object.Execute(StartDate,EndDate,"","","R")
	
	While (object.Next()) {
		
		s PAAdm=object.Data("EpisodeID")
		if PAAdm="" Continue
		s PaAdmType=$p($g(^PAADM(PAAdm)),"^",2)
		continue:PaAdmType'="I"
		s OPAPatDeptDr=object.Data("patLocId")
		s WardId=$p(^PAADM(PAAdm),"^",70)
		continue:WardId=""
		
		//s OpLevelId=object.Data("opLevelId")
		
		s OpLevelId=object.Data("mainOperLevelDr")
		continue:OpLevelId=""
		

		
		s WardNum($j,"opLevel",OpLevelId)=$g(WardNum($j,"opLevel",OpLevelId))+1
		
	}
	
	
	//手术级别拼一起输出
	s opLevelId=0
	for{
		s opLevelId=$o(WardNum($j,"opLevel",opLevelId))
		q:opLevelId=""
		s opLevelDesc=$p(^ORC("CATEG",opLevelId),"^",2)
		s opLevelCode=$p(^ORC("CATEG",opLevelId),"^",1)
		s opNum=WardNum($j,"opLevel",opLevelId)
	    d ND020101FindOpTypeNum
		    
	}

	
  	q $$$OK
ND020101FindOpTypeNum 
    s Data=$lb(opLevelDesc,opLevelId,opLevelCode,opNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2014-9-10
/// Description: 查询各病区各类别的手术人数
/// Input：  DateType----1、今天 2、明天        
/// Return： 病区名称、病区Id、手术量
/// 服务编码：ND02.01.02  //{"wardDesc":"内分泌科护理单元","wardId":"5","opNum":"1"}
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND02OperInfo","ND020102FindOpNumByType","2")
Query ND020102FindOpNumByType(DateType As %String = "", opLevelId As %String = "") As DtPortal.Query(ROWSPEC = "wardDesc:%String,wardId:%String,opNum:%String")
{
}

ClassMethod ND020102FindOpNumByTypeExecute(ByRef qHandle As %Binary, DateType As %String = "", opLevelId As %String = "") As %Status
{
	n (qHandle,DateType,opLevelId)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	if DateType=1 d
	.Set StartDate=$zd(+$h,3)   //
	.Set EndDate=$zd(+$h,3)
	
	if DateType=2 d
	.Set StartDate=$zd(+$h+1,3)   //
	.Set EndDate=$zd(+$h+1,3)
	
	i DateType="" q $$$OK
	
	k WardNum($j,"opWard")
	
	Set Num=0
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	Do object.Execute(StartDate,EndDate,"","","R",opLevelId)
	
	While (object.Next()) {
		
		s PAAdm=object.Data("EpisodeID")
		if PAAdm="" Continue
		s OPAPatDeptDr=object.Data("patLocId")
		s WardId=$p(^PAADM(PAAdm),"^",70)
		continue:WardId=""
		s PaAdmType=$p($g(^PAADM(PAAdm)),"^",2)
		continue:PaAdmType'="I"
		
		s WardNum($j,"opWard",WardId)=$g(WardNum($j,"opWard",WardId))+1
		
	}
	
	
	//手术级别拼一起输出
	s wardId=0
	for{
		s wardId=$o(WardNum($j,"opWard",wardId))
		q:wardId=""
		s wardDesc=$p($g(^PAWARD(wardId)),"^",2)
		i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
		s opNum=WardNum($j,"opWard",wardId)
	    d ND020102FindOpNumByType
		    
	}

	
  	q $$$OK
ND020102FindOpNumByType 
    s Data=$lb(wardDesc,wardId,opNum)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2014-9-15
/// Description: 按CT_Loc表ＩＤ、手术级别查询患者列表的信息
/// Input：  DateType、LocId、OpLevel   
/// Return： 病人信息
/// 服务编码：ND02.01.03
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND02OperInfo","ND020103FindOpPatInfo","1","22","1")
Query ND020103FindOpPatInfo(DateType As %String, WardId As %String, OpLevel As %String) As DtPortal.Query(ROWSPEC = "BedCode:%String,Name:%String,Sex:%String,Age:%String,MedicareNo:%String,AdmReason:%String,Diag:%String,OpLevelDesc:%String,OPAOpRoom:%String,ANAOPSurgeon:%String,OpName:%String,OpType:%String")
{
}

ClassMethod ND020103FindOpPatInfoExecute(ByRef qHandle As %Binary, DateType As %String, WardId As %String, OpLevel As %String) As %Status
{
	n (qHandle,DateType,WardId,OpLevel)
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	;Set StartDate=$zd(+$h-20,3)   //-----当天的数据----测试用
	;Set EndDate=$zd(+$h,3)
	;s ^chengpeng("FindOpPatInfo")=DateType_"^"_LocId_"^"_OpLevel
	
	if DateType=1 d
	.Set StartDate=$zd(+$h,3)  //
	.Set EndDate=$zd(+$h,3)
	
	if DateType=2 d
	.Set StartDate=$zd(+$h+1,3)   //
	.Set EndDate=$zd(+$h+1,3)
	
	i DateType="" q $$$OK
	i WardId="" q $$$OK
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	Do object.Execute(StartDate,EndDate,"",WardId,"R",OpLevel)
	While (object.Next()) {
		s PAAdm=object.Data("EpisodeID") 
		if PAAdm="" Continue
		s OpLevelDesc=object.Data("opLevelDesc")
		s OpLevelId=object.Data("opLevelId")
		s OPAPatDeptDr=object.Data("patLocId")
		s WardId=$p(^PAADM(PAAdm),"^",70)
		continue:WardId=""
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
 		s BedCode=$p(patInfoStr,"^",1)
 		s Name=$p(patInfoStr,"^",2)
 		s Sex=$p(patInfoStr,"^",3)
 		s Age=$p(patInfoStr,"^",4)
 		s MedicareNo=$p(patInfoStr,"^",5)   //病案号
 		s AdmReason=$p(patInfoStr,"^",6)    //费用类型
 		s Diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm) //取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
    	//手术间
    	;s OPAOpRoom=object.OPAOpRoom
    	s OPAOpRoomDr=object.Data("OPAOpRoomDr")
		;s OPAOpRoom=object.OPAOpRoom
		;取手术间
		i OPAOpRoomDr'="" s OPAOpRoom=$p($g(^DHCANC("OPRoom",OPAOpRoomDr)),"^",2)
		e  s OPAOpRoom=""
    	//主刀医生
    	s ANAOPSurgeon=object.Data("ANAOPSurgeon")
    	//手术名称
    	s OpName=object.Data("OpName")
    	s OpType=""
    	s OpRowID=object.Data("OpaId")  //手术ID
    	continue:+OpRowID=0
    	s anaId=$P(^DHCANOPArrange(OpRowID),"^",2) ;手术麻醉Id
    	s anaSub=$P(anaId,"||",2)
    	s anaSourceType=$P(^OR(PAAdm,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
		i anaSourceType="E" s OpType="急诊"
		e  i anaSourceType="B" s OpType="择期"
    	d FindOpPatInfo
	
	}

  	q $$$OK
FindOpPatInfo
    s Data=$lb(BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,OpLevelDesc,OPAOpRoom,ANAOPSurgeon,OpName,OpType)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： yupeng
/// CreatDate： 2018-09-14
/// Description: 查询手术信息统一接口
/// Input：  开始日期，结束日期，工号，病区ID，手术状态，手术间ID，手术类型Code，是否日间手术  
/// Return：
/// 服务代码 ND02.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND02OperInfo","ND020201OperaInfoDetail","2019-10-01","2019-10-14","","","","","")
Query ND020201OperaInfoDetail(startDate As %String, endDate As %String, wardId As %String, opState As %String, oproomId As %String, opTypeCode As %String, OpRiJian As %String = "") As DtPortal.Query(ROWSPEC = "bedCode,name,sex,age,medicareNo,admReason,showType,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPAOpRoom,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,OpLevelDesc,opDate,opTime,patLoc,OpType,EpisodeID,PatientID,EMRDocID,EMRInstanceID,locID,UserId,RejectReason,AnaDoctor,DayOperFlag,patWardDesc,OPstatisDesc,OpEndDateAndTime")
{
}

ClassMethod ND020201OperaInfoDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, wardId As %String, opState As %String, oproomId As %String, opTypeCode As %String, OpRiJian As %String = "") As %Status
{
	New (qHandle,startDate,endDate,wardId,opState,oproomId,opTypeCode,OpRiJian)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s opTypeDesc=""
	if (opTypeCode="JiZhen"){
		s opTypeDesc="急诊"
	} elseif (opTypeCode="ZeQi") {
		s opTypeDesc="择期"
	}
	
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	
	Do object.Execute(startDate,endDate,"",wardId,opState,"","")
	
	While (object.Next()) {
		set OPstatisDesc=""  //手术状态描述
		s OPstatisDesc=object.Data("OPstatisDesc")
		continue:(OPstatisDesc="未审核")
			
		s DayOperFlag=object.Data("DayOperFlag")				//日间手术
		continue:(OpRiJian="Y")&&(DayOperFlag'=OpRiJian)
		//b ;001
		s OPAOpRoomDr=object.Data("OPAOpRoomDr")  //手术间ID
		continue:(oproomId'="")&&(oproomId'=OPAOpRoomDr)							//手术间筛选
		s OpType=object.Data("ANASourceTypeDesc") //手术类型
    	continue:((opTypeDesc'="")&&(opTypeDesc'=OpType))
		
		s aNAOPSurgeonId=object.Data("ANAOPSurgeonDR") 			//主刀医生
		s assistant1=object.Data("AssistantFirstCtcpId") 		//1助
		s assistant2=object.Data("AssistantSecondCtcpId") 		//2助
		s assistant3=object.Data("AssistantThirdCtcpId") 		//3助
		s assistantOther=object.Data("AssOtherCtcpStrId") 		//其他助手
		s EpisodeId=object.Data("EpisodeID")
		Set AdmDocID=$p($g(^PAADM(EpisodeId)),"^",9)     //主管医生
		s OpEndDateAndTime=""
		s OpEndDate=object.Data("OpEndDate") 		//手术结束日期
		s OpEndTime=object.Data("OpEndTime") 		//手术结束时间
		s OpEndDateAndTime=OpEndDate_"&nbsp;"_OpEndTime  //手术结束具体时间
		
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
    	s RejectReason=object.Data("RejectReason") //拒绝原因
    	s OpRowID=object.Data("OpaId")  //手术ID
    	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeId)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)
		set patWardDesc=object.Data("patWardDesc")
		d ND020201OperaInfoDetail
		
	}
	
	
  	q $$$OK
ND020201OperaInfoDetail
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,showType,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPAOpRoom,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,OpLevelDesc,opDate,opTime,patLoc,OpType,EpisodeID,PatientID,EMRDocID,EMRInstanceID,locID,UserId,RejectReason,AnaDoctor,DayOperFlag,patWardDesc,OPstatisDesc,OpEndDateAndTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
