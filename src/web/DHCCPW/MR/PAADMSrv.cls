/// 名称: web.DHCCPW.MR.PAADMSrv
/// 描述: 就诊信息
/// 编写者：zhufei
/// 编写日期: 2010-05-17
Class web.DHCCPW.MR.PAADMSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-17
/// Description:  根据EpisodeID取就诊信息
/// Table：       User.PAADM
/// Input：       ID:    User.PAADM.ID
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(web.DHCCPW.MR.PAADMSrv).GetAdmInfoByID(1)
ClassMethod GetAdmInfoByID(argEpisodeID As %String, argSeparete As %String) As %String
{
	New (argEpisodeID,argSeparete)
	Set return=""
	Set:$g(argSeparete)="" argSeparete=..#SEPARATE
	Set objPAADM=##Class(User.PAAdm).%OpenId(argEpisodeID)
	Do:objPAADM'="" objPAADM.%Close()
	If $IsObject(objPAADM)
	{
		Set EpisodeID=objPAADM.%Id()
		Set AdmType=objPAADM.PAADMType
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(argEpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmTime=$p(AdmDateTime,"^",2)
		//Set AdmDate=objPAADM.PAADMAdmDate
		;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		//Set AdmTime=objPAADM.PAADMAdmTime
		Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
		If $IsObject(objPAADM.PAADMAdmDocCodeDR)
		{
			Set AdmDoc=objPAADM.PAADMAdmDocCodeDR.CTPCPDesc
		}
		If $IsObject(objPAADM.PAADMDepCodeDR)
		{
			Set AdmLocID=objPAADM.PAADMDepCodeDR.%Id()
			Set AdmLoc=objPAADM.PAADMDepCodeDR.CTLOCDesc
			Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
		}
		If $IsObject(objPAADM.PAADMCurrentWardDR)
		{
			Set AdmPACWardID=objPAADM.PAADMCurrentWardDR.%Id()
			Set AdmPACWard=objPAADM.PAADMCurrentWardDR.WARDDesc
			Set:$p(AdmPACWard,"-",2)'="" AdmPACWard=$p(AdmPACWard,"-",2)
			If $IsObject(objPAADM.PAADMCurrentWardDR.WARDLocationDR)
			{
				Set AdmWardID=objPAADM.PAADMCurrentWardDR.WARDLocationDR.%Id()
				Set AdmWard=objPAADM.PAADMCurrentWardDR.WARDLocationDR.CTLOCDesc
				Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
			}
		}
		If $IsObject(objPAADM.PAADMCurrentRoomDR)
		{
			Set AdmRoom=objPAADM.PAADMCurrentRoomDR.ROOMDesc
		}
		If $IsObject(objPAADM.PAADMCurrentBedDR)
		{
			Set AdmBed=objPAADM.PAADMCurrentBedDR.BEDCode
		}
		Set AdmStatus=objPAADM.PAADMVisitStatus
		Set AdmStatus=$s(AdmStatus="A":"在院",AdmStatus="C":"取消",AdmStatus="D":"出院",AdmStatus="P":"预约",1:"")
		
		//Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(argEpisodeID)
		Set DischDate=$p(DischDateTime,"^",1)
		Set DischTime=$p(DischDateTime,"^",2)
		//Set DischDate=objPAADM.PAADMDischgDate
		;Set:DischDate'="" DischDate=$zd(DischDate,3)
		Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
		//Set DischTime=objPAADM.PAADMDischgTime
		Set:DischTime'="" DischTime=$zt(DischTime,2)
		
		If $IsObject(objPAADM.PAADMMainMRADMDR)
		{
			Set MRAdm=objPAADM.PAADMMainMRADMDR.%Id()
		}
	} Else {
		Quit return
	}
	Set PatientID=objPAADM.PAADMPAPMIDR.%Id()
	Do:objPAADM'="" objPAADM.%Close()
	Set return=$g(EpisodeID)
	Set return=return_argSeparete_$g(AdmType)
	Set return=return_argSeparete_$g(AdmDate)
	Set return=return_argSeparete_$g(AdmTime)
	Set return=return_argSeparete_$g(AdmDoc)
	Set return=return_argSeparete_$g(AdmLoc)
	Set return=return_argSeparete_$g(AdmWard)
	Set return=return_argSeparete_$g(AdmRoom)
	Set return=return_argSeparete_$g(AdmBed)
	Set return=return_argSeparete_$g(AdmStatus)
	Set return=return_argSeparete_$g(DischDate)
	Set return=return_argSeparete_$g(DischTime)
	Set return=return_argSeparete_$g(MRAdm)
	Set return=return_argSeparete_$g(PatientID)
	Set return=return_argSeparete_$g(AdmLocID)
	Set return=return_argSeparete_$g(AdmWardID)
	Set return=return_argSeparete_$g(AdmPACWardID)
	Set return=return_argSeparete_$g(AdmPACWard)
	Quit return
}

/// w ##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(4939742)
ClassMethod GetEpisodeID(argMRAdm As %String) As %String
{
	New (argMRAdm)
	Set return=$p($g(^MR(+argMRAdm,"PRO",1)),"^",9)
	Quit return
}

/// w ##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(4939148)
ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=$p($g(^PAADM(+argEpisodeID)),"^",61)
	Quit return
}

/// w ##class(web.DHCCPW.MR.PAADMSrv).GetAdmDays(4939742)
ClassMethod GetAdmDays(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=0
	Quit:argEpisodeID="" return
	
	Set objPaadm=##Class(User.PAAdm).%OpenId(argEpisodeID)
    If $IsObject(objPaadm)
    {
		//Set AdmitDate=objPaadm.PAADMAdmDate
	    //Set AdmitTime=objPaadm.PAADMAdmTime
	    //upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(argEpisodeID)
		Set AdmitDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
	    //Set DischDate=objPaadm.PAADMDischgDate
	   // Set DischTime=objPaadm.PAADMDischgTime
	   //Update by pylian 2016-01-21 修改出院时间取值方式
		Set DischDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateTime(argEpisodeID)
		Set DischDate=$p(DischDateTime,"^",1)
		Set DischTime=$p(DischDateTime,"^",2)
	    If DischDate'="" {
		    Set return=DischDate-AdmitDate
	    } Else {
			Set return=+$h-AdmitDate
		}
    }
	
	Quit return
}

Storage Default
{
<Data name="PAADMSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MR.PAADMSrvD</DataLocation>
<DefaultData>PAADMSrvDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MR.PAADMSrvD</IdLocation>
<IndexLocation>^web.DHCCPW.MR.PAADMSrvI</IndexLocation>
<StreamLocation>^web.DHCCPW.MR.PAADMSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
