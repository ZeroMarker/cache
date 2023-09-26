/// 名称: DHCMed.DPCustom.Data.EmrDiagnos
/// 描述: 与病历诊断相关的数据接口
/// 编写者：zhufei
/// 编写日期: 2014-04-13
Class DHCMed.DPCustom.Data.EmrDiagnos Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// ICD10
Property ICD10 As %String(TRUNCATE = 1);

/// 诊断名称
Property ICDDesc As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 诊断备注
Property Comments As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 诊断类型代码
Property ICDType As %String(TRUNCATE = 1);

/// 诊断类型名称
Property ICDTypeDesc As %String(TRUNCATE = 1);

/// 诊断日期
Property ICDDate As %String(TRUNCATE = 1);

/// 诊断时间
Property ICDTime As %String(TRUNCATE = 1);

/// 诊断医生代码
Property ICDDoc As %String(TRUNCATE = 1);

/// 诊断医生姓名
Property ICDDocDesc As %String(TRUNCATE = 1);

/// 诊断日期
Property ActDate As %String(TRUNCATE = 1);

/// 诊断时间
Property ActTime As %String(TRUNCATE = 1);

/// 诊断医生代码
Property ActUser As %String(TRUNCATE = 1);

/// 诊断医生姓名
Property ActUserDesc As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.DPCustom.Data.EmrDiagnos).GetDataByAdm("66")
ClassMethod GetDataByAdm(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aDateFrom,aDateTo)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set ElCodes=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-EmrDiagElCode","")
	For indElCode=1:1:$l(ElCodes,",") {
		Set ElCode=$p(ElCodes,",",indElCode)
		Continue:ElCode=""
		
		Set RecordID=aEpisodeID_"||"_ElCode
		Set obj=..GetObjById0(RecordID)
		Continue:'$IsObject(obj)
    	
		Set ActDate=obj.ActDate
		Continue:ActDate=""
		Set tmpDate=ActDate
		Set:tmpDate["-" tmpDate=$zdh(tmpDate,3)
		Set:tmpDate["/" tmpDate=$zdh(tmpDate,4)
		Continue:(aDateFrom'="")&&(tmpDate<aDateFrom)
		Continue:(aDateTo'="")&&(tmpDate>aDateTo)
		
    	//Do $system.OBJ.Dump(obj)
		Do return.Insert(obj)
	}
}

/// w ##Class(DHCMed.DPCustom.Data.EmrDiagnos).GetDataByID("309655||")
ClassMethod GetDataByID(aRecordID As %String) As DHCMed.DPCustom.Data.EmrDiagnos
{
	New (aRecordID)
	Set return=""
	Quit:(aRecordID="") return
	
	Set DataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("DPIO-MRDiagnos","")
	Set DataType=+DataType
	
	If DataType=1 {
		//
	} Else {
		//DataType=0 默认取值HIS诊断信息
		Set obj=..GetObjById0(aRecordID)
		//Do $system.OBJ.Dump(obj)
	}
	Set return=obj
	
	Quit return
}

ClassMethod GetObjById0(aId As %String) As DHCMed.DPCustom.Data.EmrDiagnos
{
	New (aId)
	Set return=""
	Quit:aId="" return
	
	Set EpisodeID=$p(aId,"||",1)
	Set ElCode=$p(aId,"||",2)
	Set ElCode2=$p(aId,"||",3)
	Quit:(EpisodeID="")||(ElCode="") return
	
	Set ICDType=$p(ElCode,"#",1)
	Set TemplateID=$p($p(ElCode,"#TID:",2),"#",1)
	Quit:TemplateID="" return
	Set tmpTemplate=$g(^DHCEPRM.TemplateD(TemplateID))
	Quit:tmpTemplate="" return
	Set CategoryID=$list(tmpTemplate,7)
	Quit:CategoryID="" return
	
	Set InstanceData=##class(EPRservice.BOInstanceData).GetSingleDataInfoByCateID(EpisodeID,CategoryID,CategoryID)
	Quit:InstanceData="" return
	Set HappenDate=$p(InstanceData,$c(1),2)
	Set HappenTime=$p(InstanceData,$c(1),3)
	Set HappenUser=$p(InstanceData,$c(1),4)
	Set UpdateDate=$p(InstanceData,$c(1),5)
	Set UpdateTime=$p(InstanceData,$c(1),6)
	Set UpdateUser=$p(InstanceData,$c(1),7)
	Quit:(UpdateDate="")||(UpdateTime="") return
	
	Set:HappenDate'="" HappenDate=$zd(HappenDate,3)
	Set:HappenTime'="" HappenTime=$zt(HappenTime,1)
	Set HappenUserDesc=""
	Set:HappenUser'="" HappenUserDesc=$p($g(^SSU("SSUSR",HappenUser)),"^",2)
	Set:UpdateDate'="" UpdateDate=$zd(UpdateDate,3)
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime,1)
	Set UpdateUserDesc=""
	Set:UpdateUser'="" UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUser)),"^",2)
	
	Set EPRData=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,ElCode)
	Set EPRData2=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,ElCode2)
	Quit:EPRData="" return
	
	//记录ID、记录日期、记录时间、记录人
	Set ActDate=UpdateDate                    //发生日期
	Set ActTime=UpdateTime                    //发生时间
	Set ActUser=UpdateUser                    //修改人
	Set ActUserDesc=UpdateUserDesc
	
	Set obj=##Class(DHCMed.DPCustom.Data.EmrDiagnos).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RecordID       = aId
	Set obj.ICD10          = EPRData2
	Set obj.ICDDesc        = EPRData
	Set obj.Comments       = ""
	Set obj.ICDType        = ICDType
	Set obj.ICDTypeDesc    = ICDType
	Set obj.ICDDate        = UpdateDate
	Set obj.ICDTime        = UpdateTime
	Set obj.ICDDoc         = UpdateUser
	Set obj.ICDDocDesc     = UpdateUserDesc
	Set obj.ActDate        = ActDate
	Set obj.ActTime        = ActTime
	Set obj.ActUser        = ActUser
	Set obj.ActUserDesc    = ActUserDesc
	
	Set return=obj
	Quit return
}

}
