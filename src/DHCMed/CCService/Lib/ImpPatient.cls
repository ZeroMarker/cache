/// 名称: DHCMed.CCService.Lib.ImpPatient
/// 描述: 与重点患者相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-05-25
Class DHCMed.CCService.Lib.ImpPatient Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.ImpPatient).Test()
ClassMethod Test()
{
	New
	Set %EpisodeID=77017
	
	Set %ExtraData=""
	Set %ErrorData=""
	Set %AutoRunFlag=1
	Set %CurrentDate=+$h	
	Set return=..CheckImpPatType(2)
	b
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-05-25
/// Description:  通过就诊号判断是否传染病患者
/// Table：       DHC_MedEpidemic
/// Input：       
/// Return：      ret=0:非传染病患者  ret=1:传染病患者  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.ImpPatient).CheckImpPatType(1)
ClassMethod CheckImpPatType(argImpTypeID As %String) As %String
{
	New (argImpTypeID,%EpisodeID,%ExtraData,%ErrorData)
	Set return=""
	Quit:argImpTypeID="" return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckImpPatTypeErr"
	Set ImpPatID=0
	For {
		Set ImpPatID=$o(^DHCMed.IMP.ImpPatientI("TypePaadmIndex",argImpTypeID,%EpisodeID,ImpPatID))
		Quit:ImpPatID=""
		Set objIMP=##Class(DHCMed.IMP.ImpPatient).GetObjById(ImpPatID)
		If $IsObject(objIMP){
			Set Status=objIMP.Status
			Set objSSDic=##class(DHCMed.SS.Dictionary).GetObjById(Status)
			If $IsObject(objSSDic){
				Set Status=objSSDic.Description
			}
			Set FromDate=objIMP.FromDate
			Set:FromDate'="" FromDate=$zd(FromDate,3)
			Set FromTime=objIMP.FromTime
			Set:FromTime'="" FromTime=$zt(FromTime,2)
			Set ToDate=objIMP.ToDate
			Set:ToDate'="" ToDate=$zd(ToDate,3)
			Set ToTime=objIMP.ToTime
			Set:ToTime'="" ToTime=$zt(ToTime,2)
			Set DutyUser=objIMP.DutyUser,DutyUserDesc=""
			Set:DutyUser'="" DutyUserDesc=$p($g(^SSU("SSUSR",DutyUser)),"^",2)
			Set ResumeText=objIMP.ResumeText
			//Set Prognosis=objIMP.Prognosis
			//Set objSSDic=##class(DHCMed.SS.Dictionary).GetObjById(Prognosis)
			//If $IsObject(objSSDic){
			//	Set Prognosis=objSSDic.Description
			//}
			Set Rst=Status_"("_FromDate_" "_FromTime_"-"_ToDate_" "_ToTime_" "_DutyUserDesc_")"
			Set Rst=$$BuildCheckImpPatTypeResult(1) //格式化输出
			Set %ExtraData=%ExtraData_$lb(Rst)
			
			Set return=return_","_Status
		}
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
CheckImpPatTypeErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckImpPatTypeResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=Rst
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objPatType=##class(DHCMed.IMP.PatientTypeSub).GetObjById(objIMP.ImpType)
	Set:$IsObject(objPatType)=0 objPatType=##class(DHCMed.IMP.PatientTypeSub).%New()
	Do objPatType.%Close()
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=objIMP.FromDate
	Set $p(tmp,$c(3),3)=objIMP.FromTime
	Set $p(tmp,$c(3),4)=objPatType.Description
	Set $p(tmp,$c(3),5)=+objIMP.%Id()
	Set $p(tmp,$c(3),6)=+objIMP.DutyUser
	Set $p(tmp,$c(3),7)="argImpTypeID"_argImpTypeID
	Quit tmp
}

}
