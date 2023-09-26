/// 描述：抓取手术信息
Class DHCMed.NINFService.Sta.InfStatOperInfo Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 描述：提供从院感抓取数据
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatOperInfo).ProcessOperData(277)
ClassMethod ProcessOperData(Paadm As %String)
{
     New (Paadm)
 	 Set Rtn=##Class(DHCMed.NINF.Srv.InfStatOperInfo).DeleteByPaadm(Paadm) ;删除已经存的记录
 	 Set OprDataSource=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFOprStatDataSource","")
 	 Set OprDataSource=+OprDataSource
 	 If (OprDataSource=0){
	 	 Set Rtn=..GetDataFromHis(Paadm)     ;按照院感报告提取手术信息的方式取数据
 	 }ElseIf(OprDataSource=1){
 	 	Set Rtn=..GetDataFromEPR(Paadm)   ;从目标性监测电子病历模板取数据
 	 }ElseIf(OprDataSource=2){
 	 	Set Rtn=..GetDataFromInterface(Paadm) ;从手术接口取数据
 	 }
 	 Quit Rtn
}

/// 描述：根据EpisodeID取该病人最近一次填写的手术报告
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatOperInfo).GetDataFromEPR(277)
ClassMethod GetDataFromEPR(Paadm As %String)
{
	New (Paadm)
	Set ReportID="",InstaceID="",NPaadm=" "_Paadm,Count=0
	;取临床上报配置
	Set ProjID=##class(DHCMed.CR.Project).GetIdByCode("SSI","Y")
	For {
	     Set ReportID=$O(^DHCMed.CR.ReportI("EpisodeID",NPaadm,ReportID),-1)
	     Quit:ReportID=""
	     Set Obj=##Class(DHCMed.CR.Report).%OpenId(ReportID)
	     Set InstaceID=Obj.InstanceID
	     Set TID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFOPEREPORTTIDValue","")
	     Quit:TID=""
	     Set ProjectID=Obj.ProjectID
	     Continue:ProjectID'=ProjID  ;不是手术报告
	     Set OperationName =..GetEPRData(Paadm,"手术名称#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:I0075#VTYPE:V",InstaceID)
	     Set OperationType=..GetEPRData(Paadm,"手术类型#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0073#VTYPE:V",InstaceID)
	     Set Operator=..GetEPRData(Paadm,"主刀医师#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:S0023#VTYPE:V",InstaceID)
	     Set OperDate=..GetEPRData(Paadm,"手术日期#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:D0024#VTYPE:V",InstaceID)
	     Set:OperDate["-" OperDate=$zdh(OperDate,3)
	     Set:OperDate["/" OperDate=$zdh(OperDate,4)
	     Set OperDate=+OperDate
	     Set Duration=..GetEPRData(Paadm,"持续时间#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:S0025#VTYPE:V",InstaceID)
	     Set ASARank=..GetEPRData(Paadm,"ASA分级#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0026#VTYPE:V",InstaceID)
	     Set CutType=..GetEPRData(Paadm,"切口等级#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0027#VTYPE:V",InstaceID)
	     Set OperRank=..GetOperRank(Duration,CutType,ASARank)
	     Set NarcosisType=..GetEPRData(Paadm,"麻醉类型#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:O0029#VTYPE:V",InstaceID)
	     Set OperPosition="" ;..GetDataFromEPR(EpisodeID,"术中出血#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:S0030#VTYPE:V",InstaceID)
	     Set OperOfHaemorrhage=..GetEPRData(Paadm,"术中出血#TYPE:Simple#TID:"_TID_"#TVER:0#SCODE:S0030#VTYPE:V",InstaceID)
	     Set DataSource="ReportID:"_ReportID
	     Set TMP="^"_Paadm_"^"_OperationName_"^"_OperationType_"^"_Operator_"^"_OperDate_"^"_Duration_"^"_ASARank_"^"_CutType_"^"_OperRank_"^"_NarcosisType_"^"_OperPosition_"^"_OperOfHaemorrhage_"^"_DataSource
	     Set Rtn=##Class(DHCMed.NINF.Srv.InfStatOperInfo).Update(TMP,"^")
	     Set:Rtn=1 Count=$i(Count)
	}
	 Quit Count
}

/// 描述：获取手术信息
/// 择期手术次数、急诊手术次数、手术次数
ClassMethod GetDataFromHis(Paadm As %String)
{
	New (Paadm)
	Set (OperCount,SeleOperTimes,EmeOperTimes,Count)=0
	Set ResultSet=##Class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportOpr:QrySubRec"),IsOperPosiPat="N",IsSeleOper="N"
	Do ResultSet.Execute("",Paadm)	
	While(ResultSet.Next()){
		Set OperationName=ResultSet.Data("OperationDesc")
		Set OperationType=ResultSet.Data("OperationTypeDesc")
		Set Operator=ResultSet.Data("OperDocDesc")
		Set OperDate=ResultSet.Data("OperStartDate")
		Set OperDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OperDate)
		Set StaTime=ResultSet.Data("OperStartTime")
		Set:StaTime[":" StaTime=$zth(StaTime,3)
		Set EndTime=ResultSet.Data("OperEndTime")
		Set:EndTime[":" EndTime=$zth(EndTime,3)
		Set Duration=0
		Set:EndTime-StaTime>0 Duration=(EndTime-StaTime)\60
		Set ASARank=""
		Set CutType=ResultSet.Data("CuteTypeDesc")
		Set NarcosisType=ResultSet.Data("AnesthesiaDesc")
		Set DataSource=ResultSet.Data("DataSource")
		Set OperRank=-1
		Set OperPosition=""
		Set OperOfHaemorrhage=""
		Set TMP="^"_Paadm_"^"_OperationName_"^"_OperationType_"^"_Operator_"^"_OperDate_"^"_Duration_"^"_ASARank_"^"_CutType_"^"_OperRank_"^"_NarcosisType_"^"_OperPosition_"^"_OperOfHaemorrhage_"^"_DataSource
	    Set Rtn=##Class(DHCMed.NINF.Srv.InfStatOperInfo).Update(TMP,"^")
	    Set:Rtn>0 Count=$i(Count)
	}
	Quit Count
}

/// 描述：从电子病历取数据接口
ClassMethod GetEPRData(aEpisodeID As %String, aItemPara As %String, aInstanceID As %String) As %String
{
	New (aEpisodeID,aItemPara,aInstanceID)
	Set Rtn=##class(EPRservice.BOScatterData).GetEPRMultipleData(aEpisodeID,aItemPara,aInstanceID)
	Quit Rtn
}

/// 描述：获取手术分级
ClassMethod GetOperRank(Duration As %String, CuteRank As %String, ASARank As %String)
{
	New (Duration,CuteRank,ASARank)
	Set OperRank=-1,(DurationPoint,CuteRankPoint,ASARankPoint)=0
	Set:Duration>75 DurationPoint=1 
	Set:Duration<=75 DurationPoint=0
	Set:(CuteRank["I")||(CuteRank["II") CuteRankPoint=0
	Set:(CuteRank["III") CuteRankPoint=1
	Set:(ASARank["I")||(ASARank["II") ASARankPoint=0
	Set:(ASARank["III")||(ASARank["IV")||(ASARank["V") ASARankPoint=1
	Set:(DurationPoint>=0)&&(CuteRankPoint>=0)&&(ASARankPoint>=0) OperRank=DurationPoint+CuteRankPoint+ASARankPoint  ;手术分级=手术持续时间(打分)+ASA(打分)+切口等级(打分)	
	Quit OperRank
}

/// 描述：从手术接口获取手术数据
ClassMethod GetDataFromInterface(Paadm As %String)
{
	New (Paadm)
	;^DHCMed.NINFSi("OperationInfo",0,"IndexOfEpisodeID"," 20270714",190)
	Set OperationID=0,Count=0
	For {
		Set OperationID=$O(^DHCMed.NINFSi("OperationInfo",0,"IndexOfEpisodeID"," "_Paadm,OperationID))	
		Quit:OperationID=""
		
		Set OprObj=##Class(DHCMed.NINF.Srv.OperationInfo).GetObjectByID(OperationID)
		Continue:'$IsObject(OprObj)
		Set OperationName=OprObj.OperationName
		Set OperationType=OprObj.OperationType
		Set:(OperationType="B")||(OperationType="") OperationType="择期"
		Set:(OperationType="E") OperationType="急诊"
		Set Operator=OprObj.OperatorName
		Set OperDate=+OprObj.StartDate
		Set OperStaTime=+OprObj.StartTime
		Set OperEndDate=+OprObj.EndDate
		Set OperEndTime=+OprObj.EndTime
		;Set:OperDate=OperEndDate DurationH=(OperEndTime-OperStaTime)\60 ;持续分钟
		Set Duration=0
		Set:OperEndDate>=OperDate Duration=((OperEndDate-OperDate)*24*60*60+OperEndTime-OperStaTime)\60 ;持续分钟
		Set ASARank="I"
		Set:OprObj.NarcosisFraction'="" ASARank=OprObj.NarcosisFraction
		Set CutType="I"
		Set:OprObj.CutGradeCode'="" CutType=OprObj.CutGradeCode
		Set OperRank=..GetOperRank(Duration,CutType,ASARank)
		Set NarcosisType=OprObj.NarcosisModeDesc
		Set OperPosition=""
		Set OperOfHaemorrhage=OprObj.LoseBlood
		Set DataSource="OprInterface:"_OperationID
		Set TMP="^"_Paadm_"^"_OperationName_"^"_OperationType_"^"_Operator_"^"_OperDate_"^"_Duration_"^"_ASARank_"^"_CutType_"^"_OperRank_"^"_NarcosisType_"^"_OperPosition_"^"_OperOfHaemorrhage_"^"_DataSource
	    Set Rtn=##Class(DHCMed.NINF.Srv.InfStatOperInfo).Update(TMP,"^")
	    Set:Rtn=1 Count=$i(Count)
	}
	Quit Count
}

}
