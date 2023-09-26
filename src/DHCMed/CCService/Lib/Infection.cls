/// 名称: DHCMed.CCService.Lib.Infection
/// 描述: 与院感相关的函数库
/// 编写者：zhufei
/// 编写日期: 2011-03-18
Class DHCMed.CCService.Lib.Infection Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.Infection).Test()
ClassMethod Test()
{
	New
	Set %EpisodeID=43104
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..IsInfPatient(1)
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过就诊号判断是否院感患者(旧版本)
/// Table：       DHC_MedInfectionRep
/// Input：       Type : 院感类型
/// Return：      ret=0:非院感患者  ret=1:院感患者  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Infection).IsInfPatient("1")
ClassMethod IsInfPatient(argType As %String) As %String
{
	New (argType,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	Quit:argType="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="IsInfPatientErr"
	Set RepID=0,Count=0
	For {
		Set RepID=$o(^DHCMedIR(0,"PAADM",%EpisodeID,RepID))
		Quit:RepID=""
		Set RepStatus=$p($g(^DHCMedIR(RepID)),"^",11)
		Continue:RepStatus["0"  //删除和被订报告过滤掉
		Set Count=Count+1
		Set RepDate=$p($g(^DHCMedIR(RepID)),"^",8)
		Set RepTime=$p($g(^DHCMedIR(RepID)),"^",9)
		Set RepUser=$p($g(^DHCMedIR(RepID)),"^",10)
		Set:RepDate'="" RepDate=$zd(RepDate,3)
		Set:RepTime'="" RepTime=$zt(RepTime,2)
		Set:RepUser'="" RepUser=$p($g(^SSU("SSUSR",RepUser)),"^",2)
		Set Rst=RepDate_" "_RepTime_" "_RepUser
		Set Rst=$$BuildIsInfPatientResult(1) //格式化输出
		Set %ExtraData=%ExtraData_$lb(Rst)
	}
	
	Set:Count>0 return=1
	Quit return
	
IsInfPatientErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildIsInfPatientResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=Rst
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(1),1)=tmpDesc
	Set $p(tmp,$c(1),2)=+$p($g(^DHCMedIR(RepID)),"^",8)
	Set $p(tmp,$c(1),3)=+$p($g(^DHCMedIR(RepID)),"^",9)
	Set $p(tmp,$c(1),4)=""
	Set $p(tmp,$c(1),5)=+RepID
	Set $p(tmp,$c(1),6)=+$p($g(^DHCMedIR(RepID)),"^",10)
	Set $p(tmp,$c(1),7)="argType"_argType
	Quit tmp
}

}
