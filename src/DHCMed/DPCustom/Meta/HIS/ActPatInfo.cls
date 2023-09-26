/// 创建者：李阳
/// 创建日期：2013-12-04
/// 功能：对就诊记录进行抽取
Class DHCMed.DPCustom.Meta.HIS.ActPatInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ExtractData(FromDate As %Date, ToDate As %Date) As %Integer
{
	n (FromDate, ToDate)
	
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()      //update by pylian 2016-02-18取入院时间索引
	For tmpDate=FromDate:1:ToDate {
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^PAADMi(AdmDateIndex,tmpDate,EpisodeID))
			Quit:EpisodeID=""
			Continue:$d(^PAADMi("PAADM_Type","I",EpisodeID))=0
			Set tmpRet=$$ExtractAdmitInfo(EpisodeID)
		}
		For {
			Set EpisodeID=$o(^PAADMi(DischDateIndex,tmpDate,EpisodeID))
			Quit:EpisodeID=""
			Continue:$d(^PAADMi("PAADM_Type","I",EpisodeID))=0
			Set tmpRet=$$ExtractDischargeInfo(EpisodeID)
		}		
	}
	Quit 1
ExtractAdmitInfo(EpisodeID)
	n (EpisodeID)
	Set tmpEpisodeID=" "_EpisodeID
	Set RowID=$o(^DHCMed.DP.Meta.ActPatInfoI("IndexEpisodeID",tmpEpisodeID,""))
	Set obj=""
	Set:##class(DHCMed.DP.Meta.ActPatInfo).%ExistsId(RowID) obj=##class(DHCMed.DP.Meta.ActPatInfo).%OpenId(RowID)
	Set:'$IsObject(obj) obj=##class(DHCMed.DP.Meta.ActPatInfo).%New()
	Set strArg=""
	Set objEpisode=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objEpisode).Papmi
	
	Set $p(strArg,"^",1)=RowID
	Set $p(strArg,"^",2)=EpisodeID
	Set $p(strArg,"^",3)=objPatient.PatientName
	Set $p(strArg,"^",4)=objPatient.PapmiNo
	Set $p(strArg,"^",5)=objPatient.InPatientMrNo
	Set $p(strArg,"^",6)=objPatient.Sex
	Set $p(strArg,"^",7)=objPatient.Age
	Set $p(strArg,"^",8)=objPatient.PersonalID
	Set $p(strArg,"^",9)=$zdh(objEpisode.AdmitDate,3)
	Set $p(strArg,"^",10)=$zth(objEpisode.AdmitTime,1)
	Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(objEpisode.DepartmentID)
	Do objCtloc.%Close()
	Set objWard=##class(DHCMed.Base.PacWard).GetObjById(objEpisode.WardID)
	Do objWard.%Close()	
	Set $p(strArg,"^",11)=##class(DHCMed.DPCustom.Meta.HIS.DIC).GetDicMapping("SYS-Dept",objCtloc.Code)
	Set $p(strArg,"^",12)=##class(DHCMed.DPCustom.Meta.HIS.DIC).GetDicMapping("SYS-Ward",objWard.Code)
	Set $p(strArg,"^",13)=objEpisode.Bed
	Set $p(strArg,"^",14)="" //Diagnose
	Set Year=objPatient.Age
	Set Day=objPatient.AgeDay
	Set $p(strArg,"^",21)=((Year=0)&&(Day'>28)) //是否是新生儿
	Set tmp=##class(DHCMed.DP.Meta.ActPatInfo).Update(strArg,"^")
	Quit tmp
	
ExtractDischargeInfo(EpisodeID)
	n (EpisodeID)
	Set objEpisode=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objEpisode).Papmi
	Set objMrAdm=##class(DHCMed.Base.MRAdm).GetByPaadm(EpisodeID)
	Set RowID=$o(^DHCMed.DP.Meta.ActPatInfoI("IndexEpisodeID",tmpEpisodeID,""))
	Quit:RowID="" -1
	Set obj=""
	Set:##class(DHCMed.DP.Meta.ActPatInfo).%ExistsId(RowID) obj=##class(DHCMed.DP.Meta.ActPatInfo).GetObjById(RowID)
	Quit:'$IsObject(obj) -1
	Set Paadm=$g(^PAADM(EpisodeID))
	Set obj.APIDischDate=$s(objEpisode.DisDate'="":$zdh(objEpisode.DisDate,3),1:"")
	Set obj.APIDischTime=$s(objEpisode.DisTime'="":$zth(objEpisode.DisTime,3),1:"")
	Set obj.APIDischCond=objMrAdm.DISCONDesc //出院情况
	Set obj.APIIsDeath=(objMrAdm.DISCONCode="04") //是否死亡
	if (obj.APIIsDeath) {
		Set obj.APIDeathDate=obj.APIDischDate
		Set obj.APIDeathTime=obj.APIDischTime
	}
	Set tmp=""
	Quit tmp
}

}
