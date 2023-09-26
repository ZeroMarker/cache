/// 名称: DHCWMR.UpGrade.ErrorDataSrv
/// 描述: 系统升级 错误数据处理
/// 编写者：zhufei
/// 编写日期: 2014-12-22
Class DHCWMR.UpGrade.ErrorDataSrv Extends DHCWMR.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 青医附院门诊建成了住院病案，卷作废
/// w ##Class(DHCWMR.UpGrade.ErrorDataSrv).CheckErrVolume()
ClassMethod CheckErrVolume()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMR.SS.VolumeD(xID))
		Quit:xID=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "检查错误病案卷：已处理 "_Count_" 条!",!
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		Continue:'$IsObject(objVol.SVMainDr)
		Continue:'$IsObject(objVol.SVMainDr.SMMrType)
		Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
		If MrTypeID=7 {
			Set IsActive=1
			Set:objVol.SVMainDr.SMIsActive'=1 IsActive=0
			Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xID)
			If EpisodeID="" {
				Set IsActive=0
			} Else {
				Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
				Set:AdmType'="I" IsActive=0
			}
			Continue:IsActive>0
			
			Set obj=##class(DHCWMR.SS.Volume).%OpenId(xID)
			Continue:'$IsObject(obj)
			Set obj.SVIsActive=0
			Set obj.SVOrdStep="C"
			Set obj.SVResume="手工作废卷:门诊就诊接诊住院病案"
			Set sc=obj.%Save()
			If $System.Status.IsError(sc) {  //检查Save是否成功
		   		Do $System.OBJ.DisplayError(sc)
		   		w "卷ID="_xID,!
			}
		}
	}
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMR.SS.MainD(xID))
		Quit:xID=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "检查错误病案：已处理 "_Count_" 条!",!
		
		Set objMain=##Class(DHCWMR.SS.Main).GetObjById(xID)
		Continue:'$IsObject(objMain)
		Continue:objMain.SMIsActive'=1
		Continue:$d(^DHCWMR.SS.VolumeI("IndexMainDrAct",xID,1))
		
		Set obj=##class(DHCWMR.SS.Main).%OpenId(xID)
		Continue:'$IsObject(obj)
		Set obj.SMIsActive=0
		Set obj.SMResume="手工作废病案:此病案无有效卷"
		Set sc=obj.%Save()
		If $System.Status.IsError(sc) {  //检查Save是否成功
	   		Do $System.OBJ.DisplayError(sc)
	   		w "病案ID="_xID,!
		}
	}
	
	Quit "OK"
}

/// 检查卷步骤不一致情况
/// w ##Class(DHCWMR.UpGrade.ErrorDataSrv).CheckErrVolStep()
ClassMethod CheckErrVolStep()
{
	New
	
	Set xID=0,Count=0
	For {
		Set xID=$o(^DHCWMRVOL(xID))
		Quit:xID=""
		
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xID)
		Continue:'$IsObject(objVol)
		Continue:objVol.SVIsActive'=1
		
		Set Count=Count+1
		Write:(Count#1000)=0 "卷错误步骤处理：已处理 "_Count_" 条!",!
		
		Set tmpVolStep=##Class(DHCWMR.UpGrade.WorkDataSrv).GetVolStepInfo(xID)
		Continue:tmpVolStep=""
		
		Set SVOrdStep=$p(tmpVolStep,"^",1)
		Set SVIsLend=+$p(tmpVolStep,"^",2)
		Set SVIsCopy=+$p(tmpVolStep,"^",3)
		Set SVIsStore=+$p(tmpVolStep,"^",4)
		Set SVQCLock=+$p(tmpVolStep,"^",5)
		Set SVDischDate=$p(tmpVolStep,"^",6)
		Set SVBackDate=$p(tmpVolStep,"^",7)
		
		Set obj=##class(DHCWMR.SS.Volume).%OpenId(xID)
		Set obj.SVOrdStep=SVOrdStep
		Set obj.SVIsLend=SVIsLend
		Set obj.SVIsCopy=SVIsCopy
		Set obj.SVIsStore=SVIsStore
		Set obj.SVQCLock=SVQCLock
		Set obj.SVDischDate=SVDischDate
		Set obj.SVBackDate=SVBackDate
		Set sc=obj.%Save()
		If $System.Status.IsError(sc) {  //检查Save是否成功
	   		Do $System.OBJ.DisplayError(sc)
		}
	}
	
	Quit Count
}

/// w ##Class(DHCWMR.UpGrade.ErrorDataSrv).ExportData()
ClassMethod ExportData()
{
	new
	
	//d $system.OBJ.Export("DHCWMR.SS.BatchNumber.GBL","/tmp/dhcmed20150324/DHCWMR.SS.BatchNumber.xml")
	//d $system.OBJ.Export("DHCWMR.SS.MainD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.MainD.xml")
	//d $system.OBJ.Export("DHCWMR.SS.MainI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.MainI.xml")
	//d $system.OBJ.Export("DHCWMR.SS.VolumeD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.VolumeD.xml")
	//d $system.OBJ.Export("DHCWMR.SS.VolumeI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.VolumeI.xml")
	//d $system.OBJ.Export("DHCWMR.SS.MrNoD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.MrNoD.xml")
	//d $system.OBJ.Export("DHCWMR.SS.MrNoI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.MrNoI.xml")
	//d $system.OBJ.Export("DHCWMR.SS.OperationD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.OperationD.xml")
	//d $system.OBJ.Export("DHCWMR.SS.OperationI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.OperationI.xml")
	
	d $system.OBJ.Export("DHCWMR.SS.DictionaryD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.DictionaryD.xml")
	d $system.OBJ.Export("DHCWMR.SS.DictionaryI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.DictionaryI.xml")
	d $system.OBJ.Export("DHCWMR.SS.HolidaysD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.HolidaysD.xml")
	d $system.OBJ.Export("DHCWMR.SS.HolidaysI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.HolidaysI.xml")
	d $system.OBJ.Export("DHCWMR.SS.HospitalD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.HospitalD.xml")
	d $system.OBJ.Export("DHCWMR.SS.HospitalI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.HospitalI.xml")
	d $system.OBJ.Export("DHCWMR.SS.MrClassD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.MrClassD.xml")
	d $system.OBJ.Export("DHCWMR.SS.MrClassI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.MrClassI.xml")
	d $system.OBJ.Export("DHCWMR.SS.MrTypeD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.MrTypeD.xml")
	d $system.OBJ.Export("DHCWMR.SS.WorkFlowD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.WorkFlowD.xml")
	d $system.OBJ.Export("DHCWMR.SS.WorkFlowI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.WorkFlowI.xml")
	d $system.OBJ.Export("DHCWMR.SS.WorkItemD.GBL","/tmp/dhcmed20150324/DHCWMR.SS.WorkItemD.xml")
	d $system.OBJ.Export("DHCWMR.SS.WorkItemI.GBL","/tmp/dhcmed20150324/DHCWMR.SS.WorkItemI.xml")
	d $system.OBJ.Export("DHCWMR.UG.Config.GBL","/tmp/dhcmed20150324/DHCWMR.UG.Config.xml")
	
	quit "OK"
}

/// w ##Class(DHCWMR.UpGrade.ErrorDataSrv).ChangeHisAdm0()
ClassMethod ChangeHisAdm0()
{
	New
	
	Set xVolId=0,Count=0
	For {
		Set xVolId=$o(^DHCWMR.SS.VolumeD(xVolId))
		Quit:xVolId=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "切库数据转换：已处理 "_Count_" 条!",!
		
		Set xAdm=0
		For {
			Set xAdm=$o(^DHCWMR.SS.VolumeD(xVolId,"P",xAdm))
			Quit:xAdm=""
			
			Set objAdm=##Class(DHCWMR.SS.VolPaadm).GetObjById(xVolId_"||"_xAdm)
			Continue:'$IsObject(objAdm)
			Set EpisodeID=objAdm.VPEpisodeID
			Continue:EpisodeID=""
			
			Set AdmNo=$p($g(^PAADM(EpisodeID)),"^",81)
			Set PatientID=objAdm.VPPatientID
			If PatientID'="" {
				Set RegNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
			} Else {
				Set RegNo=""
			}
			Write:RegNo="" PatientID,!
			Continue:RegNo=""
			
			Set AdmitDept=objAdm.VPAdmitDept
			Set AdmitDeptDesc=""
			Set:AdmitDept'="" AdmitDeptDesc=$p($g(^CTLOC(+AdmitDept)),"^",2)
			
			Set AdmitWard=objAdm.VPAdmitWard
			Set AdmitWardDesc=""
			Set:AdmitWard'="" AdmitWardDesc=$p($g(^CTLOC(+AdmitWard)),"^",2)
			
			Set DischDept=objAdm.VPDischDept
			Set DischDeptDesc=""
			Set:DischDept'="" DischDeptDesc=$p($g(^CTLOC(+DischDept)),"^",2)
			
			Set DischWard=objAdm.VPDischWard
			Set DischWardDesc=""
			Set:DischWard'="" DischWardDesc=$p($g(^CTLOC(+DischWard)),"^",2)
			
			Set DischBed=objAdm.VPDischBed
			Set DischBedDesc=""
			Set:DischBed'="" DischBedDesc=$p($g(^PAWARD(+DischBed,"BED",+$p(DischBed,"||",2))),"^",1)
			
			Set obj=##Class(DHCWMR.SS.VolPaadm).%OpenId(xVolId_"||"_xAdm)
			Continue:'$IsObject(obj)
			Set obj.VPPatientID=PatientID
			Set obj.VPEpisodeID=EpisodeID
			Set obj.VPAdmNo=AdmNo_","_RegNo
			Set obj.VPAdmitDept=AdmitDept
			Set obj.VPAdmitDeptDesc=AdmitDeptDesc
			Set obj.VPAdmitWard=AdmitWard
			Set obj.VPAdmitWardDesc=AdmitWardDesc
			Set obj.VPDischDept=DischDept
			Set obj.VPDischDeptDesc=DischDeptDesc
			Set obj.VPDischWard=DischWard
			Set obj.VPDischWardDesc=DischWardDesc
			Set obj.VPDischBed=DischBed
			Set obj.VPDischBedDesc=DischBedDesc
			Set sc=obj.%Save()
			If $System.Status.IsError(sc) {  //检查Save是否成功
		   		Do $System.OBJ.DisplayError(sc)
			}
		}
	}
	
	Quit "OK"
}

/// w ##Class(DHCWMR.UpGrade.ErrorDataSrv).ChangeHisAdm1()
ClassMethod ChangeHisAdm1()
{
	New
	
	Set xVolId=0,Count=0
	For {
		Set xVolId=$o(^DHCWMR.SS.VolumeD(xVolId))
		Quit:xVolId=""
		
		Set Count=Count+1
		Write:(Count#1000)=0 "切库数据转换：已处理 "_Count_" 条!",!
		
		Set xAdm=0
		For {
			Set xAdm=$o(^DHCWMR.SS.VolumeD(xVolId,"P",xAdm))
			Quit:xAdm=""
			
			Set objAdm=##Class(DHCWMR.SS.VolPaadm).GetObjById(xVolId_"||"_xAdm)
			Continue:'$IsObject(objAdm)
			
			Set EpisodeID=""
			Set AdmNo=objAdm.VPAdmNo
			Set RegNo=$p(AdmNo,",",2)
			If RegNo'="" {
				Set PatientID=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
			} Else {
				Set PatientID=""
			}
			Set:AdmNo'="" AdmNo="H"_AdmNo
			
			Set (AdmitDept,AdmitWard,DischDept,DischWard,DischBed)=""
			Set AdmitDeptDesc=objAdm.VPAdmitDeptDesc
			Set tmpDesc=##class(DHCWMR.IO.FromHisSrv).ALPHAUP(AdmitDeptDesc)
			Set:tmpDesc'="" AdmitDept=$o(^CTLOC(0,"Desc",tmpDesc,0))
			Set AdmitWardDesc=objAdm.VPAdmitWardDesc
			Set tmpDesc=##class(DHCWMR.IO.FromHisSrv).ALPHAUP(AdmitWardDesc)
			Set:tmpDesc'="" AdmitWard=$o(^CTLOC(0,"Desc",tmpDesc,0))
			Set DischDeptDesc=objAdm.VPDischDeptDesc
			Set tmpDesc=##class(DHCWMR.IO.FromHisSrv).ALPHAUP(DischDeptDesc)
			Set:tmpDesc'="" DischDept=$o(^CTLOC(0,"Desc",tmpDesc,0))
			Set DischWardDesc=objAdm.VPDischWardDesc
			Set tmpDesc=##class(DHCWMR.IO.FromHisSrv).ALPHAUP(DischWardDesc)
			Set:tmpDesc'="" DischWard=$o(^CTLOC(0,"Desc",tmpDesc,0))
			
			Set obj=##Class(DHCWMR.SS.VolPaadm).%OpenId(xVolId_"||"_xAdm)
			Continue:'$IsObject(obj)
			Set obj.VPPatientID=PatientID
			Set obj.VPEpisodeID=EpisodeID
			Set obj.VPAdmNo=AdmNo
			Set obj.VPAdmitDept=AdmitDept
			Set obj.VPAdmitWard=AdmitWard
			Set obj.VPDischDept=DischDept
			Set obj.VPDischWard=DischWard
			Set obj.VPDischBed=DischBed
			Set sc=obj.%Save()
			If $System.Status.IsError(sc) {  //检查Save是否成功
		   		Do $System.OBJ.DisplayError(sc)
			}
		}
	}
	
	Quit "OK"
}

}
