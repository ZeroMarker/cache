/// 病人基本信息
Class DHCMed.SMD.ReportPat Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 姓名
Property RPPatName As %String;

/// 性别
Property RPSex As %String;

/// 出生日期
Property RPBirthday As %Date;

/// 身份证号
Property RPPersonalID As %String;

/// 联系电话
Property RPTelPhone As %String;

/// 民族
Property RPNation As %String;

/// 门诊病案号
Property RPOPNo As %String;

/// 住院病案号
Property RPIPNo As %String;

/// 医保号/新农合号
Property RPInsurNo As %String;

/// 就诊类型
Property RPAdmType As %String;

/// Creator：     zhouruimeng
/// CreatDate：   2015-01-14
/// Description:  取病人基本信息定义
/// Table：       DHCMed.SMD.ReportPat
/// Input：       DHCMed.SMD.ReportPat.ID
/// Return：      返回obj
/// w ##class(DHCMed.SMD.ReportPat).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.SMD.ReportPat
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCMed.SMD.ReportPat).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RPPatName=$p(aInput,aSeparate,1)
	Set obj.RPSex=$p(aInput,aSeparate,2)
	Set Birthday=$p(aInput,aSeparate,3)
	Set:Birthday'="" Birthday=##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Birthday)
	Set obj.RPBirthday=Birthday
	Set obj.RPPersonalID=$p(aInput,aSeparate,4)
	Set obj.RPNation=$p(aInput,aSeparate,5)
	Set obj.RPOPNo=$p(aInput,aSeparate,6)
	Set obj.RPIPNo=$p(aInput,aSeparate,7)
	Set obj.RPTelPhone=$p(aInput,aSeparate,8)
	Set obj.RPInsurNo=$p(aInput,aSeparate,9)
	Set obj.RPAdmType=$p(aInput,aSeparate,10)
	Set return=obj
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-15
/// Description:  取病人基本信息
/// Table：       DHCMed.SMD.ReportPat
/// Input：       ReportID ：报告ID
///               EpisodeID : 就诊号
/// Return：      返回Object
/// w ##class(DHCMed.SMD.ReportPat).GetPatObj("","189")
ClassMethod GetPatObj(aReportID As %String, aEpisodeID As %String) As DHCMed.SMD.ReportPat
{
	New (aReportID,aEpisodeID)
	Set return=""
	Quit:(aReportID="")&&(aEpisodeID="") return
	
	Set obj=##Class(DHCMed.SMD.ReportPat).%New()
	If obj'="" Do obj.%Close()
	//取病人ID
	set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set PersonalIDTypeID = $p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	//Set PersonalIDType = $p($g(^PAC("CARD",+PersonalIDTypeID)),"^",2)
	
	If aReportID'="" {
		Set objRep=##class(DHCMed.SMD.Report).GetObjById(aReportID)
		Quit:'$IsObject(objRep) return
		Set EpisodeID=objRep.SREpisodeID
		If $IsObject(objRep.SRPatientObj) {
			Set obj.RPPatName     = objRep.SRPatientObj.RPPatName
			Set obj.RPSex         = objRep.SRPatientObj.RPSex
			Set obj.RPBirthday    = objRep.SRPatientObj.RPBirthday
			Set obj.RPPersonalID  = objRep.SRPatientObj.RPPersonalID
			Set obj.RPNation      = objRep.SRPatientObj.RPNation
			Set obj.RPOPNo        = objRep.SRPatientObj.RPOPNo
			Set obj.RPIPNo        = objRep.SRPatientObj.RPIPNo
			Set obj.RPTelPhone    = objRep.SRPatientObj.RPTelPhone
			Set obj.RPInsurNo     = objRep.SRPatientObj.RPInsurNo
			Set obj.RPAdmType     = objRep.SRPatientObj.RPAdmType
		}
	} Else {
		Set EpisodeID=aEpisodeID
	}
	Quit:EpisodeID="" return
	
	Set PatientID = $p($g(^PAADM(EpisodeID)),"^",1)
	Set objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPat) return
	Set InsurNo   = $p(^PAPER(+PatientID,"ALL"),"^",19)
	Set AdmType   = $p($g(^PAADM(EpisodeID)),"^",2)
	
	Set:obj.RPPatName="" obj.RPPatName=objPat.PatientName
	Set:obj.RPSex="" obj.RPSex=objPat.Sex
	Set:obj.RPBirthday="" obj.RPBirthday=objPat.Birthday
	Set:obj.RPPersonalID="" obj.RPPersonalID=PersonalIDTypeID
	Set NationID=""
	//Set objNation=##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc("Nation",objPat.Nation)
	Set objNation=##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc("SMDMZ",objPat.Nation)
	Set:$IsObject(objNation) NationID=objNation.%Id()
	Set:(obj.RPNation="")&&(+NationID'=0) obj.RPNation=NationID
	/*
	Set:obj.RPOPNo="" obj.RPOPNo=objPat.OutPatientMrNo
	Set:obj.RPOPNo'="" obj.RPOPNo=$p(obj.RPOPNo,"-",1)	//修改门诊病案号取值
	Set:obj.RPIPNo="" obj.RPIPNo=objPat.InPatientMrNo
	*/	
	Set:(AdmType="I")&&(obj.RPIPNo="") obj.RPIPNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(EpisodeID,"I")
	Set:(AdmType="O")&&(obj.RPOPNo="") obj.RPOPNo=##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(EpisodeID,"O")

	Set:obj.RPTelPhone="" obj.RPTelPhone=objPat.Telephone
	Set:obj.RPInsurNo="" obj.RPInsurNo=InsurNo
	Set:obj.RPAdmType="" obj.RPAdmType=AdmType
	Set return=obj
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-15
/// Description:  取病人基本信息
/// Table：       DHCMed.SMD.ReportPat
/// Input：       ReportID ：报告ID
///               EpisodeID : 就诊号
/// Return：      返回String，$c(2)分隔
/// w ##class(DHCMed.SMD.ReportPat).GetPatStr("","189")
ClassMethod GetPatStr(aReportID As %String, aEpisodeID As %String) As %String
{
	New (aReportID,aEpisodeID,%session)
	Set return=""
	Quit:(aReportID="")&&(aEpisodeID="") return
	
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	
	Set obj=..GetPatObj(aReportID,aEpisodeID)
	Quit:'$IsObject(obj) return
	
	Set $p(return,$c(2),1)=obj.RPPatName
	Set Sex=obj.RPSex
	Set:Sex'="" Sex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc",Languages,Sex)
	Set $p(return,$c(2),2)=Sex
	Set RPBirthday=obj.RPBirthday
	Set:RPBirthday'="" RPBirthday=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RPBirthday)
	Set $p(return,$c(2),3)=RPBirthday
	Set $p(return,$c(2),4)=obj.RPPersonalID
	Set $p(return,$c(2),5)=obj.RPTelPhone
	;Set $p(return,$c(2),6)=obj.RPNation
	Set $p(return,$c(2),6)=##class(DHCMed.SS.Dictionary).GetStringById(obj.RPNation,$c(3))
	Set $p(return,$c(2),7)=obj.RPOPNo
	Set $p(return,$c(2),8)=obj.RPIPNo
	Set $p(return,$c(2),9)=obj.RPInsurNo
	Set $p(return,$c(2),10)=obj.RPAdmType
	Quit return
}

Storage Default
{
<Data name="ReportPatState">
<Value name="1">
<Value>RPPatName</Value>
</Value>
<Value name="2">
<Value>RPSex</Value>
</Value>
<Value name="3">
<Value>RPBirthday</Value>
</Value>
<Value name="4">
<Value>RPPersonalID</Value>
</Value>
<Value name="5">
<Value>RPTelPhone</Value>
</Value>
<Value name="6">
<Value>RPNation</Value>
</Value>
<Value name="7">
<Value>RPOPNo</Value>
</Value>
<Value name="8">
<Value>RPIPNo</Value>
</Value>
<Value name="9">
<Value>RPAdmType</Value>
</Value>
<Value name="10">
<Value>RPInsurNo</Value>
</Value>
</Data>
<State>ReportPatState</State>
<StreamLocation>^DHCMed.SMD.ReportPatS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
