/// 名称: DHCMA.Util.IO.FromEmrSrv
/// 描述: 电子病历提供接口服务
/// 编写者：zhufei
/// 编写日期: 2018-07-11
Class DHCMA.Util.IO.FromEmrSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 取病案首页数据集
/// w ##class(DHCMA.Util.IO.FromEmrSrv).GetFPDataByGlossaryCategory()
ClassMethod GetFPDataByGlossaryCategory(aEpisodeID As %String) As %ArrayOfDataTypes
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=##class(%ArrayOfDataTypes).%New()
	Quit:aEpisodeID="" return
	
	Set IOEmrHDSDCode=##class(DHCMA.Util.BT.Config).GetValueByCode("HISIOEmrHDSDCode")
	Set:IOEmrHDSDCode="" IOEmrHDSDCode="HDSD00.11"  //北京协和 "HDSB05.10"
	Set IOGetEmrVer=##class(DHCMA.Util.BT.Config).GetValueByCode("HISIOGetEmrVer")
	If IOGetEmrVer="V2" {
		Set return=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(aEpisodeID,IOEmrHDSDCode)
	} Else {
		Set return=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,IOEmrHDSDCode)
	}
	Quit return
}

/// 获取一条待执行的任务队列，将其放入当前执行队列
/// w ##class(DHCMA.Util.IO.FromEmrSrv).FetchTask()
ClassMethod FetchTask(aTaskType As %String = "") As %String
{
	New (aTaskType)
	Set return=""
	
	Set:aTaskType="" aTaskType="FP"  //首页提交队列类型
	Set IOGetEmrVer=##class(DHCMA.Util.BT.Config).GetValueByCode("HISIOGetEmrVer")
	If IOGetEmrVer="V2" {
		Set entity=##Class(EPRservice.BLL.BLAdmTaskExec).FetchTask(aTaskType)
	} Else {
		Set entity=##Class(EMRservice.BL.BLAdmTaskExec).FetchTask(aTaskType)
	}
	Quit:'$IsObject(entity) return
	
	Set $p(return,"^",1)=entity.ID             //执行记录ID
	Set $p(return,"^",2)=entity.EpisodeID      //就诊号
	Set $p(return,"^",3)=entity.CandidateDate  //申请日期
	Set $p(return,"^",4)=entity.CandidateTime  //申请时间
	Set $p(return,"^",5)=entity.TaskDate       //执行日期
	Set $p(return,"^",6)=entity.TaskTime       //执行时间
	Quit return
}

/// 完成一条待执行的任务，将其放入任务完成队列
/// w ##class(DHCMA.Util.IO.FromEmrSrv).CompleteTask()
ClassMethod CompleteTask(aTaskExecID As %String) As %String
{
	New (aTaskExecID)
	Set return=""
	Quit:aTaskExecID="" return
	
	Set IOGetEmrVer=##class(DHCMA.Util.BT.Config).GetValueByCode("HISIOGetEmrVer")
	If IOGetEmrVer="V2" {
		Set return=##Class(EPRservice.BLL.BLAdmTaskExec).CompleteTask(aTaskExecID)
	} Else {
		Set return=##Class(EMRservice.BL.BLAdmTaskExec).CompleteTask(aTaskExecID)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-12
/// Description:  取预出院日期时间接口
/// Table：       无
/// Input：       aEpisodeID : 就诊号
/// Return：      return=PreDischDate_"^"_PreDischTime
/// w ##Class(DHCMA.Util.IO.FromEmrSrv).GetPreDischDateTime(8061170)
ClassMethod GetPreDischDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	Quit:aEpisodeID="" return
	/*
	Set arr=..GetFPDataByGlossaryCategory(aEpisodeID)
	Set PreDischDate=arr.GetAt("HDSD00.11.3390")  //预出院日期
	Set PreDischTime=arr.GetAt("HDSD00.11.3391")  //预出院时间
	Set return=PreDischDate_"^"_PreDischTime
	*/
	Set return=##class(web.GetFeeInfo).GetPAADMVisitStatus(aEpisodeID)
	Quit return
}

/// 取首页保存日期时间接口
/// w ##Class(DHCMA.Util.IO.FromEmrSrv).GetEmrLastSaveDateTime(8061170)
ClassMethod GetEmrLastSaveDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set return=##class(EPRservice.HISInterface.PatientInfoAssist).GetEPRLogsLastActionTime(aEpisodeID)
	Quit return
}

/// 取电子病历首页术语集接口
/// w ##Class(DHCMA.Util.IO.FromEmrSrv).GetXMLDataByAdm(8228531)
ClassMethod GetXMLDataByAdm(aEpisodeID As %String) As %GlobalCharacterStream
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	Quit:aEpisodeID="" return
	
	//取东华首页信息
	Set arr=##class(DHCMA.Util.IO.FromEmrSrv).GetFPDataByGlossaryCategory(aEpisodeID)
	Quit:'$IsObject(arr) return
	Quit:arr.Count()<1 return
	
	//计费组接口
	Set CostInfo=##class(DHCMA.Util.IO.FromFeeSrv).IGetTarCateFeeByAdm(aEpisodeID)
	
	Set objStream=##class(%GlobalCharacterStream).%New()
    Do objStream.Rewind()
	Do objStream.Write("<AdmFirstPage>")
	Do objStream.Write("<EpisodeID>"_aEpisodeID_"</EpisodeID>")
	Set xKey="",Count=0
	For {
		Do arr.GetNext(.xKey)
		Quit:xKey=""
		Set tValue=arr.GetAt(xKey)
		Continue:tValue=""
		
		Set tValue=$tr(tValue,"&gt")
		Set tValue=$tr(tValue,"<","(")
		Set tValue=$tr(tValue,">",")")
		Set tValue=$tr(tValue,"“")
		Set tValue=$tr(tValue,"”")
		Set tValue=$tr(tValue,"""")
		
		Set Count=Count+1
		Set tValue = ##Class(DHCMRQ.RS.Util.XML).Escape(tValue)
		Do objStream.Write("<"_xKey_">"_tValue_"</"_xKey_">")
	}
	
	Do:CostInfo'="" objStream.Write(CostInfo)
	Do objStream.Write("</AdmFirstPage>")
	Do objStream.%Close()
	Quit:Count<20 return //检查至少非空项目20项
	
	Quit objStream
}

/// Creator：     pylian
/// CreatDate：   2019-02-01
/// Description:  术语集取东华电子病历首页数据接口
/// Input：       EpisodeID:就诊号
///               ElCode:术语集
/// Return：      返回String
/// Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
/// w ##class(DHCMA.Util.IO.FromEmrSrv).GetEPRData(21,"HDSD00.11.023")
ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,ArrGlossary)
	Set return=##class(%ArrayOfDataTypes).%New()

	Quit:(aEpisodeID="")||(aElCode="") return
	
	Set $ZT="GetEPRDataErr"
		
	Set IOGetEmrVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIOGetEmrVer")   //电子病历版本由系统管理配置判断
	If IOGetEmrVer="V2" {
		Set return=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(aEpisodeID,aElCode)
	} Else {
		Set Category=$e(aElCode,1,9)
		Quit:Category="" return
		
		If ArrGlossary.GetAt(Category)'=aEpisodeID {
			Set ArrGlossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,Category)
			Do ArrGlossary.SetAt(aEpisodeID,Category)
		}
		Set return=ArrGlossary.GetAt(aElCode)
	}
	Quit return
	
GetEPRDataErr
	Quit ""
}

}
