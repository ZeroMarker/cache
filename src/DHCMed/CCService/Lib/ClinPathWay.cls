/// 名称: DHCMed.CCService.Lib.ClinPathWay
/// 描述: 与临床路径相关的函数库
/// 编写者：zhufei
/// 编写日期: 2012-03-29
Class DHCMed.CCService.Lib.ClinPathWay Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.ClinPathWay).Test()
ClassMethod Test()
{
	New
	
	Set %EpisodeID=71657
	Set %AutoRunFlag=1
	Set %CurrentDate=+$h
	Set %ExtraData=$lb("")
	Set %ErrorData=$lb("")
	Set return=..CheckByMainDiag("")
	b
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,$c(13)),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,$c(13)),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2011-03-29
/// Description:  通过就诊号判断是否主诊断符合,未入径患者
/// Table：       User.DHCMRCClinPathWays
/// Input：       EpisodeID:    User.PAADM
/// Return：      ret=0:非未入径患者  ret=1:未入径患者  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.ClinPathWay).CheckByMainDiag("M")
ClassMethod CheckByMainDiag(argTypeCode As %String = "") As %String
{
	New (argTypeCode,%EpisodeID,%ExtraData,%ErrorData)
	Set return=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckByMainDiagErr"
	
	Set MRAdm=$p($g(^PAADM(+%EpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set ID=0,isInPathWay="N"
	For {
		Set ID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,ID))
		Quit:ID=""
		Set Status=$listget($g(^DHCMR("CPW",ID)),5)
		Set:Status'="" isInPathWay="Y"
	}
	Quit:isInPathWay="Y" return
	
	//通过临床诊断的主要诊断来判断是否入径
	Set MRDiagnos=0,Count=0
	For {
		Set MRDiagnos=$o(^MR(MRAdm,"DIA",MRDiagnos))
		Quit:MRDiagnos=""
		
		Set TypeDicCode=""
		Set MRDiagType=$o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",0))
		If MRDiagType'="" {
			Set TypeDicID=$p($g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",MRDiagType)),"^",1)
			Set TypeDicCode=$p($g(^MRC("DTYP",+TypeDicID)),"^",1)
		}
		Continue:(argTypeCode="M")&&(TypeDicCode'="M") //Main(M)为主要诊断类型
		
		Set MRCICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
		Set tmpICDDx=$g(^MRC("ID",+MRCICDDxID))
		Set MRICDCode=$p(tmpICDDx,"^",1)
		Set MRICDDesc=$p(tmpICDDx,"^",2)
    	Set MRICD10=$p(tmpICDDx,"^",4)    //MRC_ICDDx.MRCID_ICD9CM_Code  对应维护界面：ICD10
    	Set MRICD9=$p(tmpICDDx,"^",35)    //MRC_ICDDx.MRCID_ICD9_Map     对应维护界面：ICD9
		Set MRICDDoc=$p(tmpICDDx,"^",4)
		Set:MRICDDoc'="" MRICDDoc=$p($g(^CTPCP(+MRICDDoc)),"^",2)
		Set MRICDDate=$p(tmpICDDx,"^",7)
		Set MRICDTime=$p(tmpICDDx,"^",8)
		Set:MRICDDate'="" MRICDDate=$zd(MRICDDate,3)
		Set:MRICDTime'="" MRICDTime=$zt(MRICDTime,2)
		Continue:(MRICDDesc="")||(MRICD10="")
		
		Set DiagnoseID=MRAdm_"||"_MRDiagnos
		Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(DiagnoseID)
		Do objDia.%Close()
		//判断此诊断符合哪条路径的准入标准,根据准入ICD来判断
		Set CPWID=0
		For {
			Set CPWID=$o(^DHCMRC("CPWD",CPWID))
			Quit:CPWID=""
			Set (CPWDesc,CPWICD,CurrCPWDID,CurrVersion)=""
			Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
			Continue:'$IsObject(objCPW)
			Continue:'$IsObject(objCPW.CPWCPWDicDR)
			Set CPWDesc=objCPW.CPWDesc
			Set CPWICD=objCPW.CPWICD
			Set CurrCPWDID=objCPW.CPWCPWDicDR.%Id()
			Set CurrVersion=objCPW.CPWCPWDicDR.CPWDVersion
			Continue:CurrVersion'=CPWID
			Continue:CPWICD=""
			Set flg=##Class(web.DHCCPW.MR.SysBaseSrv).CheckICDArea(MRICD10,CPWICD)
			Continue:flg<=0
			
			Set Count=Count+1
			Set Rst=$$BuildCheckByMainDiagResult(1)
			Set %ExtraData=%ExtraData_$lb(Rst)
		}
	}
	
	Set:Count>0 return=1
	Quit return
	
CheckByMainDiagErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildCheckByMainDiagResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=CPWICD_" "_CPWDesc_"("_MRICD10_" "_MRICDDesc_" "_objDia.CTPCPDesc_" "_$zd(+objDia.DiaDate,3)_" "_$zt(+objDia.DiaTime,1)_")"
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+objDia.DocCodeDr)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=objDia.DiaDate
	Set $p(tmp,$c(3),3)=objDia.DiaTime
	Set $p(tmp,$c(3),4)=CPWICD_" "_CPWDesc
	Set $p(tmp,$c(3),5)=+CPWID
	Set $p(tmp,$c(3),6)=+objUser.Rowid
	Set $p(tmp,$c(3),7)="argTypeCode="_argTypeCode
	Quit tmp
}

/// Creator：     liuyh
/// CreatDate：   2013-03-27
/// Description:  通过就诊号判断患者是否为中途出径患者
/// Table：       User.DHCMRCClinPathWays
/// Input：       EpisodeID:    User.PAADM
/// Return：      ret=0:否  ret=1:中途出径患者  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.ClinPathWay).CheckOutWayByEpisodeID()
ClassMethod CheckOutWayByEpisodeID() As %String
{
	New (%EpisodeID,%ExtraData,%ErrorData)
	
	Set return=0
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set MRAdm=$p($g(^PAADM(+%EpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm)) return
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,CPWID))
		Quit:CPWID=""
		
		Set tmp=^DHCMR("CPW",CPWID)
		Set CPWStatus=$li(tmp,5)
		Continue:CPWStatus'="O"
		
		Set CPWOutDoctorDR=$li(tmp,8)	//出径人
		Set CPWOutDate=$li(tmp,9)
		Set CPWOutTime=$li(tmp,10)
		Set CPWPathwayDR=$li(tmp,3)
		Set CPWOutReasonDR=$li(tmp,12)
		Set CPWInLoc=$li(tmp,18)
		
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWPathwayDR)
		Continue:'$IsObject(objCPW)
		Continue:'$IsObject(objCPW.CPWCPWDicDR)
		Set CPWDesc=objCPW.CPWDesc	//路径名称
		
		Set CPWOutDoctorDesc=""
		Set:CPWOutDoctorDR'="" CPWOutDoctorDesc=$p($g(^CTPCP(CPWOutDoctorDR,1)),"^",2)
		
		Set CPWOutReasonDesc=""
		Set:CPWOutReasonDR'="" CPWOutReasonDesc=$li($g(^DHCMRC("VR",CPWOutReasonDR)),3)
		
		Set CPWInLocDesc=""
		Set:CPWInLoc'="" CPWInLocDesc=$p($g(^CTLOC(CPWInLoc)),"^",2)
		
		Set return=1
		
		Set Rst=$$BuildOutWayResult(1)
		
		Set %ExtraData=%ExtraData_$lb(Rst)
		
	}
	
	Quit return
	
BuildOutWayResult(arg0)
	Set tmpDesc="科室："_CPWInLocDesc_" 路径名称："_CPWDesc_" 出径医生："_CPWOutDoctorDesc_" 出径日期："_$zd(+CPWOutDate,3)_" 时间："_$zt(+CPWOutTime,2)_" 原因："_CPWOutReasonDR

	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=CPWOutDate
	Set $p(tmp,$c(3),3)=CPWOutTime
	Set $p(tmp,$c(3),4)=CPWDesc
	Set $p(tmp,$c(3),5)=CPWID
	Set $p(tmp,$c(3),6)=""
	Set $p(tmp,$c(3),7)=""
	Quit tmp
}

}
