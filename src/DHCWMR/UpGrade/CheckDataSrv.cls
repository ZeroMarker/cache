/// 名称: DHCWMR.UpGrade.CheckDataSrv
/// 描述: 系统升级 数据检查
/// 编写者：zhufei
/// 编写日期: 2014-11-20
Class DHCWMR.UpGrade.CheckDataSrv Extends DHCWMR.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCWMR.UpGrade.CheckDataSrv).CheckWorkData()
ClassMethod CheckWorkData(aFlag As %String = 0)
{
	New (aFlag)
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRVOL(xID))
		Quit:xID=""
		
		Set tmpInfo=$g(^DHCWMRVOL(xID))
		Continue:tmpInfo=""
		Set Paadm=$p(tmpInfo,"^",2)
		Set HisAdm=$p(tmpInfo,"^",3)
		Set AdmInfo="",HisAdmInfo=""
		Set:Paadm'="" AdmInfo=$g(^PAADM(Paadm))
		Set:HisAdm'="" HisAdmInfo=$g(^DHCWMRHISADM(HisAdm))
		Continue:(AdmInfo="")&&(HisAdmInfo="")  //卷无就诊信息退出
		Set SVMainDr=$p(tmpInfo,"^",1)
		Continue:SVMainDr=""
		Set MainInfo=$g(^DHCWMRMAIN(SVMainDr))
		Continue:MainInfo=""  //卷无主表信息退出
		
		Set Count=Count+1
		Write:(Count#1000)=0 "卷表数据检查：已处理 "_Count_" 条!",!
		
		Set VolumeID=xID
		//历史信息：卷是否有效、病案类型、病案号、病案是否有效、姓名、就诊日期、就诊时间、出院日期、出院时间
		Set VIsActive=$p(tmpInfo,"^",7)
		Set VIsActive=$s(VIsActive="Y":1,1:0)
		Set MainID=SVMainDr
		Set MrTypeID=+$p($g(^DHCWMRMAIN(MainID)),"^",1)  //病案类型
		Set MrNo=$p($g(^DHCWMRMAIN(MainID)),"^",2)  //病案号
		Set VolMrNo=$p($g(^DHCWMRVOL(VolumeID)),"^",10)
		Set:aFlag=1 MrNo=VolMrNo
		Set MIsActive=$p($g(^DHCWMRMAIN(MainID)),"^",6)  //病案是否有效
		Set MIsActive=$s(MIsActive="Y":1,1:0)
		Set PatName=""  //患者姓名
		Set PatientID=$p($g(^DHCWMRMAIN(MainID)),"^",3)
		Set HisPatID=$p($g(^DHCWMRMAIN(MainID)),"^",4)
		Set:PatientID'="" PatName=PatName_","_$p($g(^PAPER(PatientID,"ALL")),"^",1)
		Set:HisPatID'="" PatName=PatName_","_$p($g(^DHCWMRHISTORY(HisPatID)),"^",1)
		Set PatName=$e(PatName,2,$l(PatName))
		
		//当前信息：卷是否有效、病案类型、病案号、病案是否有效、姓名、就诊日期、就诊时间、出院日期、出院时间
		Set objVol=##class(DHCWMR.SS.Volume).GetObjById(VolumeID)
		If '$IsObject(objVol){
			Write "错误提示-1：卷("_VolumeID_")病案卷不一致",!
			Continue
		}
		
		Set cVIsActive=objVol.SVIsActive
		Write:cVIsActive'=VIsActive "错误提示-2：卷("_VolumeID_")是否有效不一致,VIsActive="_VIsActive_","_cVIsActive,!
		
		Set objMain=objVol.SVMainDr
		If '$IsObject(objMain){
			Write "错误提示-3：卷("_VolumeID_")无主表信息",!
		} Else {
			Set cMrNo=objMain.SMMrNo
			Write:cMrNo'=MrNo "错误提示-4：卷("_VolumeID_")病案号不一致,MrNo="_MrNo_","_cMrNo,!
			
			Set cMIsActive=objMain.SMIsActive
			Write:cMIsActive'=MIsActive "错误提示-5：卷("_VolumeID_")病案是否有效不一致,MIsActive="_MIsActive_","_cMIsActive,!
		}
		
		Set VolIsError=0
		For indAdm=1:1:objVol.ChildPaadm.Count() {
			Set objVolAdm=objVol.ChildPaadm.GetAt(indAdm)
			Continue:'$IsObject(objVolAdm)
			Set cPatName=objVolAdm.VPPatName
			Write:PatName'[cPatName "错误提示-6：卷("_VolumeID_")患者姓名不一致,PatName="_PatName_","_cPatName,!
			Set:PatName'[cPatName VolIsError=1
		}
		
		//错误数据特殊处理
		If VolIsError=1 {
			Set objXVol=##class(DHCWMR.SS.Volume).%OpenId(VolumeID)
			Set objXVol.SVIsActive=0
			Set sc=objXVol.%Save()
			If $System.Status.IsError(sc) {
		   		Do $System.OBJ.DisplayError(sc)
			} Else {
				Do objXVol.%Close()
			}
		}
	}
	
	Quit "OK"
}

}
