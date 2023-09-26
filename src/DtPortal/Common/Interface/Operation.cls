Class DtPortal.Common.Interface.Operation Extends %RegisteredObject [ ClassType = "" ]
{

/// Creator： 程鹏
/// CreatDate： 2015-9-23  //重写日期 2018-11-16
/// Description: 查询手术申请信息
/// Input： StartDate		查询开始日期(按照手术开始日期查询)格式为 2018-11-13
///    		EndDate			查询结束日期(按照手术开始日期查询)格式为 2018-11-13
/// 			LocId			病人科室id CT_LOC表ID
/// 			WardId			病人病区id pac_ward表id
/// 			OpState			手术状态 可传ADR
/// 			OpLevel			手术级别ID
/// 			OpRowID			手术申请表ID DHC_AN_OPArrange表ID
/// Return： 病人信息
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.Interface.Operation","QueryOpPatInfo","2018-12-12","2018-12-25","","","","","")
Query QueryOpPatInfo(StartDate As %String, EndDate As %String, LocId As %String = "", WardId As %String = "", OpState As %String = "", OpLevel As %String = "", OpRowID As %String = "") As DtPortal.Query(ROWSPEC = "OpaId,AnaesthesiaID,OPAStatus,RejectReason,OpName,ANASourceTypeDesc,opLevelId,opLevelDesc,AnaMethod,ASA,ANAOPPreopDiag,OPASeq,OPAOpRoomDr,OPAOpRoom,OPAOperLocDr,OPAAppLocDr,OPAAppDate,planOpDate,planOpTime,OpTimeStr,OpDate,OpTime,OpEndDate,OpEndTime,OpShichang,InRoomTime,ANAOPSurgeonDR,ANAOPSurgeon,AssistantFirstCtcpId,AssistantFirstCtcp,AssistantSecondCtcpId,AssistantSecondCtcp,AssistantThirdCtcpId,AssistantThirdCtcp,AssOtherCtcpStrId,AssOtherCtcpStr,EpisodeID,PaAdmType,OPstatisDesc,patLocId,patLocDesc,patWardId,patWardDesc,bedCode,name,sex,age,medicareNo,admReason,regNo,AnaDoctor,DayOperFlag,returnOpe,mainOperLevelDr,mainOperLevel")
{
}

ClassMethod QueryOpPatInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String = "", WardId As %String = "", OpState As %String = "", OpLevel As %String = "", OpRowID As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	quit:(StartDate="")&&(EndDate="") $$$OK
	
	
		
	s ret=##class(web.DHCANAdaptor).GetANOperation(StartDate,EndDate,"","",OpState)
	Set reader = ##class(%XML.Reader).%New()
	Do reader.OpenStream(ret)
	Do reader.Correlate("PatInfo","web.DHCANInterface")
	While (reader.Next(.object,.sc)) {
		s OpaId=object.OpaId                					//手术排班表Id
		s AnaesthesiaID=object.AnaesthesiaID					//麻醉表Id
		s OPAStatus=object.OPAStatus							//手术状态         下有手术状态描述
		s RejectReason=object.RejectReason						//拒绝原因
		s OpName=object.OpName 									//手术名称
		s ANASourceTypeDesc=object.ANASourceTypeDesc			//手术类型（择期，急诊）
		s opLevelId=object.opLevelId							//手术级别ID 
		s opLevelDesc=object.opLevelDesc     					//手术级别
		s opLevelId=object.opLevelId							//手术级别ID 
		s opLevelDesc=object.opLevelDesc     					//手术级别
		s mainOperLevelDr=object.MainOperLevelDr					;主手术级别Id
		s mainOperLevel=object.MainOperLevel						;主手术几倍
		s AnaMethod=object.AnaMethod							//麻醉方法
		s AnaDoctor=object.AnaDoctor							//麻醉医生
		s ASA=object.ASA										//ASA分级
		s ANAOPPreopDiag=object.ANAOPPreopDiag					//术前诊断
		s OPASeq=object.OPASeq         							//手术台次
		s OPAOpRoomDr=object.OPAOpRoomDr						//手术间Id
		s OPAOpRoom=object.OPAOpRoom							//手术间描述
		s:((OPAOpRoom="")&&(OPAOpRoomDr'="")) OPAOpRoom=$p($g(^DHCANC("OPRoom",OPAOpRoomDr)),"^",2)
		s OPAOperLocDr=object.OPAOperLocDr						//手术科室Id
	 	s OPAAppLocDr=object.OPAAppLocDr						//手术申请科室
	 	s OPAAppDate=object.OPAAppDate							//手术申请日期
		s PlanOPAStartDateTime=object.PlanOPAStartDateTime		//计划手术开始日期时间 格式如 2018-04-09 16:30
		s OpDate=object.OpDate									//手术开始日期
		s OpTimeStr=object.OpTime								//手术时间字符串(返回的是字符串 如2018-04-08 09:00~2018-04-08 10:00)
		s InRoomTime=object.InRoomTime							//入室时间
		s:InRoomTime'="" InRoomTime=$zt(InRoomTime,2)
		set OpTime="",OpEndDate="",OpEndTime="",OpShichang="",planOpDate="",planOpTime=""
		set:((OpDate="")&&(OpTimeStr["~")) OpDate=$p($p(OpTimeStr,"~",1)," ",1)		//手术开始时间
		set:OpTimeStr["~" OpTime=$p($p(OpTimeStr,"~",1)," ",2)		//手术开始时间
		set:OpTimeStr["~" OpEndDate=$p($p(OpTimeStr,"~",2)," ",1)	//手术结束日期
		set:OpTimeStr["~" OpEndTime=$p($p(OpTimeStr,"~",2)," ",2)	//手术结束时间
		set:PlanOPAStartDateTime[" " planOpDate=$p(PlanOPAStartDateTime," ",1)	//预计开始日期
		set:PlanOPAStartDateTime[" " planOpTime=$p(PlanOPAStartDateTime," ",2)	//预计开始时间
		set:planOpDate="" planOpDate=OpDate
		set:planOpTime="" planOpTime=OpTime
		set:((OpTime'="")&&(OpEndTime'="")) OpShichang=(+$zth(OpEndTime)-+$zth(OpTime))/60	//手术时长 单位:分
		s ANAOPSurgeonDR=object.ANAOPSurgeonDR					//手术医师Id
		s ANAOPSurgeon=object.ANAOPSurgeon						//手术医师姓名
		s AssistantFirstCtcpId=object.AssistantFirstCtcpId		//一助Id
		s AssistantFirstCtcp=object.AssistantFirstCtcp			//一助
		s AssistantSecondCtcpId=object.AssistantSecondCtcpId	//二助Id
		s AssistantSecondCtcp=object.AssistantSecondCtcp		//二助
		s AssistantThirdCtcpId=object.AssistantThirdCtcpId		//三助Id
		s AssistantThirdCtcp=object.AssistantThirdCtcp			//三助
		s AssOtherCtcpStrId=object.AssOtherCtcpStrId			//other助手Id
		s AssOtherCtcpStr=object.AssOtherCtcpStr				//other助手
		s EpisodeID=object.EpisodeID							//病人就诊号
		s PaAdmType=object.PaAdmType							//病人就诊类型
		s returnOpe=object.returnOpe							//重返手术,Y为重返
		s:EpisodeID="" EpisodeID=object.OPAAdmDr
		continue:EpisodeID=""
		
		set OPstatisDesc="",patLocDesc="",patWardDesc=""
		set:OPAStatus="A" OPstatisDesc="申请"
		set:OPAStatus="S" OPstatisDesc="拟日间"
		set:OPAStatus="D" OPstatisDesc="拒绝"
		set:OPAStatus="C" OPstatisDesc="撤销"
		set:OPAStatus="R" OPstatisDesc="安排"
		set:OPAStatus="N" OPstatisDesc="非预约"
		set:OPAStatus="I" OPstatisDesc="术中"
		set:OPAStatus="P" OPstatisDesc="恢复室"
		set:OPAStatus="L" OPstatisDesc="术毕"
		set:OPAStatus="F" OPstatisDesc="完成"
		set:OPAStatus="" OPstatisDesc="未审核"					
		set:OPstatisDesc="" OPstatisDesc=OPAStatus				//手术状态描述
		set patLocId=$p($g(^PAADM(EpisodeID)),"^",4)			//病人科室id
		set:patLocId'="" patLocDesc=$p(^CTLOC(patLocId),"^",2)					
		set:patLocDesc["-" patLocDesc=$p(patLocDesc,"-",2)		//病人科室描述
		set patWardId=$p($g(^PAADM(EpisodeID)),"^",70)			//病人病区id
		set:patWardId'="" patWardDesc=$p(^PAWARD(patWardId),"^",2)					
		set:patWardDesc["-" patWardDesc=$p(patWardDesc,"-",2)	//病人病区描述
		
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
 		s bedCode=$p(patInfoStr,"^",1)							//病人床号
 		s name=$p(patInfoStr,"^",2)								//病人姓名
 		s sex=$p(patInfoStr,"^",3)								//病人性别
 		s age=$p(patInfoStr,"^",4)								//病人年龄
 		s medicareNo=$p(patInfoStr,"^",5)  			 			//病人病案号
 		s admReason=$p(patInfoStr,"^",6)    					//病人费用类型
 		s regNo=$p(patInfoStr,"^",7)    						//病人登记号
 		
 		//参数过滤
 		continue:((LocId'="")&&(patLocId'=LocId))
		continue:((WardId'="")&&(patWardId'=WardId))
		//continue:((OpLevel'="")&&(opLevelId'=OpLevel))
		continue:((OpLevel'="")&&(mainOperLevelDr'=OpLevel))   //使用主手术级别过滤
		continue:((OpRowID'="")&&(OpaId'=OpRowID))
 		
 		set DayOperFlag=""
 		try
		{
			s DayOperFlag=object.DayOperFlag						//日间手术
		}catch exp{
			s anaId=$P(^DHCANOPArrange(OpaId),"^",2) ;手术麻醉Id
			s anaSub=$P(anaId,"||",2)
			s dayOperFlag=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",1)),"^",22)
		}
 		
 		s Data=$lb(OpaId,AnaesthesiaID,OPAStatus,RejectReason,OpName,ANASourceTypeDesc,opLevelId,opLevelDesc,AnaMethod,ASA,ANAOPPreopDiag,OPASeq,OPAOpRoomDr,OPAOpRoom,OPAOperLocDr,OPAAppLocDr,OPAAppDate,planOpDate,planOpTime,OpTimeStr,OpDate,OpTime,OpEndDate,OpEndTime,OpShichang,InRoomTime,ANAOPSurgeonDR,ANAOPSurgeon,AssistantFirstCtcpId,AssistantFirstCtcp,AssistantSecondCtcpId,AssistantSecondCtcp,AssistantThirdCtcpId,AssistantThirdCtcp,AssOtherCtcpStrId,AssOtherCtcpStr,EpisodeID,PaAdmType,OPstatisDesc,patLocId,patLocDesc,patWardId,patWardDesc,bedCode,name,sex,age,medicareNo,admReason,regNo,AnaDoctor,DayOperFlag,returnOpe,mainOperLevelDr,mainOperLevel)
 		s ^||CacheTemp(repid,ind)=Data	
 		s ind=ind+1
	}	

	
  	q $$$OK
}

/// Creator：     yupeng
/// CreatDate：   2018-09-13
/// Description:  C00.00.13查询手术间
/// Table：       
/// Input：       无
/// Return：      
///  do ##class(%Library.ResultSet).RunQuery("DtPortal.Common.Interface.Operation","QueryFindOPRoom")
Query QueryFindOPRoom() As DtPortal.Query(ROWSPEC = "OPAOpRoomID,OPAOpRoomDesc")
{
}

ClassMethod QueryFindOPRoomExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s OpRowID=0
	f  s OpRowID=$o(^DHCANC("OPRoom",OpRowID)) q:OpRowID=""  d
	.s OPAOpRoomID=$p($g(^DHCANC("OPRoom",OpRowID)),"^",1)	//手术间ID
	.s OPAOpRoomDesc=$p($g(^DHCANC("OPRoom",OpRowID)),"^",2)	//手术间描述
	.s ^||CacheTemp(repid,ind)=$lb(OpRowID,OPAOpRoomDesc)
 	.s ind=ind+1
	
	Quit $$$OK
}

// 获取手术信息

// input 手术排班表 ID

// w ##class(DtPortal.Common.Interface.Operation).GetOPInfo(27)

ClassMethod GetOPInfo(opID)
{
	//Set $ZT="GetOPInfoErr"
	set opName="",opDate="",opTime="",opDateTime=""
	set EpisodeID=$P(^DHCANOPArrange(opID),"^",1) ;就诊号
	quit:EpisodeID="" ""
	set anaId=$P(^DHCANOPArrange(opID),"^",2) ;手术麻醉Id
	quit:anaId="" ""
 	set anaSub=$P(anaId,"||",2)
 	quit:anaSub="" ""
 	quit:'$d(^OR(EpisodeID,"ANA",anaSub)) ""
 	set opDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",2)		//取麻醉开始日期
 	set opTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",3)		//取麻醉开始时间
 	set:opDate="" opTime=$P(^DHCANOPArrange(opID),"^",14) 	//麻醉开始日期为空 取手术申请开始日期
 	set:opTime="" opTime=$P(^DHCANOPArrange(opID),"^",15) 	//麻醉开始时间为空 取手术申请开始时间
	
	set anaopSub=0 
	for
	{
		set anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) 
		quit:anaopSub=""
		
		set curOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
		
		if curOperId=""
		{
			set name=$G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)) 
			set:opName'="" opName=opName_"/"_name
			set:opName="" opName=name
		}else
		{
			set name=$P(^ORC("OPER",curOperId),"^",2)
			set:opName'="" opName=opName_"/"_name
			set:opName="" opName=name
		}
	} 
	q opName_"^"_opDate_"^"_opTime
///GetOPInfoErr
	q -1
}

}
