/// 名称:DtPortal.NH.NH01WardSummar
/// 描述:查询病区的手术信息
/// 编写者：bmz
/// 编写日期: 2014-12-03
Class DtPortal.NH.NH04OperationInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2014-12-03
/// Description: 查询病区的手术信息
/// Input：  UserCode,type 1-今日 2-明日 3-术后三日       
/// Return：
/// 服务代码 NH04.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH04OperationInfo","NH040101","411","2",10)
Query NH040101(UserCode As %String, Type As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,oPAOpRoom:%String,oPASeq:%String,aNAOPSurgeon:%String,planOPAStartDateTime:%String,opName:%String,aOpLevelDesc:%String,opDate:%String,opTime:%String,patLoc:%String,anaSourceTypeDesc:%String,appLoc:%String")
{
}

ClassMethod NH040101Execute(ByRef qHandle As %Binary, UserCode As %String, Type As %String, WardId As %String) As %Status
{
	New (qHandle,UserCode,Type,WardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	
	//默认测试用
	s StartDate=+$h
	s EndDate=+$h
	
	//"A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室(术毕)，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
	s opStatType="R"   //手术状态类型，今日、明日的手术类型为R，术后的手术类型为PLF
	
	i Type=1 d
	.s StartDate=+$h
	.s EndDate=+$h
	e  i Type=2 d
	.s StartDate=+$h+1
	.s EndDate=+$h+1
	e  i Type=3 d   //查询的是术后3日内的数据
	.s StartDate=+$h-3
	.s EndDate=+$h
	.s opStatType="PLF"
	
	Set Num=0
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	Do object.Execute(StartDate,EndDate,"",WardId,opStatType)
	
	While (object.Next()) {
		s OPstatis=object.Data("OPAStatus")
		s EpisodeId=object.Data("EpisodeID")
		s OpLevelDesc=object.Data("opLevelDesc")
		s OpLevelId=object.Data("opLevelId")
		;s PatWardDesc=object.Ward
		if EpisodeId="" Continue
		s patWardId=$p(^PAADM(EpisodeId),"^",70)
		
		s OpLevelDesc=object.Data("opLevelDesc")
		s WardDesc=$p(^PAWARD(WardId),"^",2)
		i WardDesc["-" s WardDesc=$p(WardDesc,"-",2)
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
		s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
		s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    	
    	//手术间
    	;s oPAOpRoom=object.OPAOpRoom
    	s OPAOpRoomDr=object.Data("OPAOpRoomDr")
    	s oPAOpRoom=object.Data("OPAOpRoom")
		;取手术间
		s:((oPAOpRoom="")&&(OPAOpRoomDr'="")) oPAOpRoom=$p($g(^DHCANC("OPRoom",OPAOpRoomDr)),"^",2)
		

    	//手术台次
    	s oPASeq=object.Data("OPASeq")
    	//主刀医生
    	s aNAOPSurgeon=object.Data("ANAOPSurgeon")
    	//b ;2
    	//手术名称
    	s opName=object.Data("OpName")
    	//预计手术开始时间
   		s planOPAStartDateTime=""
    	set planOpDate=object.Data("planOpDate")
    	set planOpTime=object.Data("planOpTime")
    	set planOPAStartDateTime=planOpDate_"&nbsp;"_planOpTime
    	
    	//b ;3
    	//手术级别
    	s opLevelId=object.Data("opLevelId")
    	s aOpLevelDesc=object.Data("opLevelDesc")
    	;i opLevelId'="" s aOpLevelDesc=$p($g(^DHCANC("OPLevel",opLevelId)),"^",2)
    	//手术日期--术后查询用
    	s opDate=""    ;,opTime=""
    	s opDate=object.Data("OpDate")  //修改手术日期
    	s OpTime=object.Data("OpTime")  //修改手术日期
    	set opDateTime=opDate_"&nbsp;"_OpTime
    	//手术时间
    	;s opTime=object.OpTime --这个字段为手术时间的字段了
    	//科室名称--病人所在科室,术后查询用---申请科室
    	s patLoc=$p(patInfoStr,"^",9)  						//病人科室
    	
    	s appLoc=""
    	s OPAAppLocDr=object.Data("OPAAppLocDr")  //申请科室
   		
   		i OPAAppLocDr '= "" s appLoc=$p(^CTLOC(OPAAppLocDr),"^",2)
   		
		i appLoc["-" s appLoc=$p(appLoc,"-",2)
		
    	s anaSourceTypeDesc=""
    	s OpRowID=object.Data("OpaId")  //手术ID
    	continue:+OpRowID=0
    	s anaId=$P(^DHCANOPArrange(OpRowID),"^",2) ;手术麻醉Id
    	s anaSub=$P(anaId,"||",2)
    	s anaSourceType=$P(^OR(EpisodeId,"ANA",anaSub),"^",32)   						;ANA_SourceType 急诊(E)/择期(B)
		i anaSourceType="E" s anaSourceTypeDesc="急诊"
		e  i anaSourceType="B" s anaSourceTypeDesc="择期"
    	
    	d operaInfo
	
	}
	
 
  	q $$$OK
operaInfo
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPAOpRoom,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,aOpLevelDesc,opDate,opTime,patLoc,anaSourceTypeDesc,appLoc)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： yupeng
/// CreatDate： 2018-09-14
/// Description: 查询更多手术患者列表
/// Input：  开始日期，结束日期，工号，病区ID，手术状态，手术间ID，手术类型Code       
/// Return：
/// 服务代码 NH04.02.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH04OperationInfo","NH040201","2018-12-12","2018-12-29","411","10","ARDF","","","")
Query NH040201(StartDate As %String, EndDate As %String, UserCode As %String, WardId As %String, OpState As %String, OproomId As %String, OpTypeCode As %String, OpRiJian As %String = "") As DtPortal.Query(ROWSPEC = "opaOpRoom:%String,bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,oPASeq:%String,aNAOPSurgeon:%String,planOPAStartDateTime:%String,opName:%String,aOpLevelDesc:%String,opDate:%String,opTime:%String,patLoc:%String,opType:%String,anaDoctor:%String,DayOperFlag:%String,OPstatisDesc:%String,OpEndDateAndTime:%String")
{
}

ClassMethod NH040201Execute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, UserCode As %String, WardId As %String, OpState As %String, OproomId As %String, OpTypeCode As %String, OpRiJian As %String = "") As %Status
{
	New (qHandle,StartDate,EndDate,UserCode,WardId,OpState,OproomId,OpTypeCode,OpRiJian)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	s opTypeDesc=""
	if (OpTypeCode="JiZhen"){
		s opTypeDesc="急诊"
	} elseif (OpTypeCode="ZeQi") {
		s opTypeDesc="择期"
	} elseif (OpTypeCode="RiJian") {
		s opTypeDesc="日间"
	}
	
	Set object = ##class(%ResultSet).%New("DtPortal.Common.Interface.Operation:QueryOpPatInfo")
	
	Do object.Execute(StartDate,EndDate,"",WardId,OpState,"","")
	While (object.Next()) {
		s OPstatisDesc=object.Data("OPstatisDesc")	
		s DayOperFlag=object.Data("DayOperFlag")				//日间手术
		continue:(OPstatisDesc="未审核")

		continue:((OpRiJian="Y")&&(OpRiJian'=DayOperFlag))
		s OpEndDateAndTime=""
		s OpEndDate=object.Data("OpEndDate") 		//手术结束日期
		s OpEndTime=object.Data("OpEndTime") 		//手术结束时间
		s OpEndDateAndTime=OpEndDate_"&nbsp;"_OpEndTime  //手术结束具体时间
		s episodeID=object.Data("EpisodeID")	//就诊号
		s OpDate=object.Data("OpDate")   		//手术日期
		s oPASeq=object.Data("OPASeq")         //手术台次
		s aNAOPSurgeon=object.Data("ANAOPSurgeon")         //主刀医生
		set planOpDate=object.Data("planOpDate")
    	set planOpTime=object.Data("planOpTime")
    	set planOPAStartDateTime=planOpDate_"&nbsp;"_planOpTime
		s aOpLevelDesc=object.Data("opLevelDesc")     //手术级别
		s anaDoctor=object.Data("AnaDoctor")        //麻醉医师
		s opType=object.Data("ANASourceTypeDesc")     //手术类型
		s anaDoctor=object.Data("AnaDoctor")         //麻醉医师
		s opaId=object.Data("OpaId")                //手术Id
		;s opName=$p($g(^ORC("OPER",opaId)),"^",2) //手术名称
		s opName=object.Data("OpName")				//手术名称
	 	s opaOpRoom=object.Data("OPAOpRoom")		//手术间描述
	 	s oproomdr=object.Data("OPAOpRoomDr")
	 	
	 	if OproomId'="" continue:oproomdr'=OproomId							//手术间筛选
	 	if OpTypeCode'="" continue:opType'=opTypeDesc							//手术类型筛选
	 	
	 	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(episodeID)
 		s bedCode=$p(patInfoStr,"^",1)   //床位
 		s medicareNo=$p(patInfoStr,"^",5)   //病案号
 		s admReason=$p(patInfoStr,"^",6)    //费用类型
	 	s name=$p(patInfoStr,"^",2)			//姓名
		s sex=$p(patInfoStr,"^",3)				//性别
		s age=$p(patInfoStr,"^",4)					//年龄
		s regNo=$p(patInfoStr,"^",7)               //登记号
		s patLoc=$p(patInfoStr,"^",9)          	//病人所在科室
		s docDesc=$p(patInfoStr,"^",11)   //主管医生
		s nurseDesc=$p(patInfoStr,"^",12)    //主管护士
		
		s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(episodeID)  //诊断
		s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(episodeID)  //住院天数
    	d operaInfoDetail
	
	}
  	q $$$OK
operaInfoDetail
    s Data=$lb(opaOpRoom,bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,oPASeq,aNAOPSurgeon,planOPAStartDateTime,opName,aOpLevelDesc,opDate,opTime,patLoc,opType,anaDoctor,DayOperFlag,OPstatisDesc,OpEndDateAndTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
