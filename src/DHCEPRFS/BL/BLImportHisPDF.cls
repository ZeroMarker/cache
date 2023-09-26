Class DHCEPRFS.BL.BLImportHisPDF Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	校验准备导入的患者就诊信息等
/// Input：	AMedRecordNo 病案号、APatientName 患者姓名、ASex 性别、
/// 		AAdmDate 	入院日期、AAdmLocDesc 入院科室、ADisDate 出院日期、ADisLocDesc 出院科室
/// Debug：	w ##class(DHCEPRFS.BL.BLImportHisPDF).CheckInfo("500218","安然","女","2010-01-01","产科","2010-01-11","妇科")
ClassMethod CheckInfo(AMedRecordNo As %String, APatientName As %String, ASex As %String, AAdmDate As %String, AAdmLocDesc As %String, ADisDate As %String, ADisLocDesc As %String, AItemDescs As %String) As %String
{
	//判断基本信息
	s PAPMI=""
	s PAPMI = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetPAPMIByMedRecord(AMedRecordNo)
	//s PAPMI = $o(^PAPERi("Medicare1",AMedRecordNo,""))
	q:(PAPMI="") "0|未查询到病案号对应的患者信息"
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s arrFiles = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientInfoByPAPMI(PAPMI)
	s PatientName = arrFiles.GetAt("PAPMIName")
	//s PatientName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
	q:(APatientName'=PatientName) "0|姓名不符系统中姓名为:"_PatientName
	
	s Sex = arrFiles.GetAt("PAPMISex")
	s:(Sex '="") Sex = $p(Sex,"^",3)
	//s SexDR=$p($g(^PAPER(PAPMI,"ALL")),"^",7)
	//s Sex=$p($g(^CT("SEX",SexDR)),"^",2)
	q:(ASex'=Sex) "0|性别不符系统中性别为:"_Sex
	
	//校验科室 遍历科室
	/*s AdmLocExists="0"
	s DisLocExists="0"
	s CTLOCRowID="0"
	for
	{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID))
		q:(CTLOCRowID="")
		s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)
		if (AAdmLocDesc=CTLOCDesc){	s AdmLocExists="1"	}
		if (ADisLocDesc=CTLOCDesc){	s DisLocExists="1"	}
		s CTLOCDescRight=$p(CTLOCDesc,"-",2)
		if (AAdmLocDesc=CTLOCDescRight){	s AdmLocExists="1"	}
		if (ADisLocDesc=CTLOCDescRight){	s DisLocExists="1"	}
		q:((AdmLocExists="1")&&(DisLocExists="1"))
	}
	q:(AdmLocExists="0") "1|系统中未找到入院科室"
	q:(DisLocExists="0") "1|系统中未找到出院科室"
	*/
	//检验导入项目是否存在AItemDescs

	s allItemInSysOption="1"
	s sysOptionItemType=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("ImportItemType")
	s arrSysItemDesc=##class(%ArrayOfDataTypes).%New() //将系统配置中导入的病历类型加入集合
	for i=1:1:$l(sysOptionItemType,"|")
	{
		s sysItem=$p(sysOptionItemType,"|",i)
		s sysItemDesc=$p(sysItem,"^",1)
		d arrSysItemDesc.SetAt(sysItemDesc,sysItemDesc)
	}

	for i=1:1:$l(AItemDescs,"|")
	{
		s itemDesc=$p(AItemDescs,"|",i)
		if (arrSysItemDesc.IsDefined(itemDesc)="0")	//未找到
		{
			s allItemInSysOption="0"
			q
		}
	}
	
	q:(allItemInSysOption="0") "0|有导入病历项目未在系统配置中配置"
	
	//校验是否已经存在MREpisode
	s EpisodeExists="0"
	s admDate=$zdh(AAdmDate,3)
	s disDate=$zdh(ADisDate,3)
	s MREpisodeID=""
	for {
		s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordNo,MREpisodeID))
		q:(MREpisodeID="")
		
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		if ((objMREpisode.AdmDate=admDate)&&(objMREpisode.DisDate=disDate))	//入院日期和出院日期相等,判定为已存在
		{
			s EpisodeExists="1"
			q
		}
	}
	q:(EpisodeExists="1") "2|"_MREpisodeID_"|归档系统中已经存在此入出院日期的就诊记录" 
	
	q "1"
}

/// Desc:	校验准备导入的患者就诊信息等
/// Input：	AMedRecordNo 病案号、APatientName 患者姓名、ASex 性别、
/// 		AAdmDate 	入院日期、AAdmLocDesc 入院科室、ADisDate 出院日期、ADisLocDesc 出院科室
/// Debug：	w ##class(DHCEPRFS.BL.BLImportHisPDF).ImportEpisode("128","500218","2010-01-01","心内科","2010-01-11","心内科")
ClassMethod ImportEpisode(AUserID As %String, AMedRecordNo As %String, AAdmDate As %String, AAdmLocDesc As %String, ADisDate As %String, ADisLocDesc As %String, ADirName As %String) As %String
{
	//判断基本信息
	s PAPMI=""
	s PAPMI = $o(^PAPERi("Medicare1",AMedRecordNo,""))
	q:(PAPMI="") "0|未查询到病案号对应的患者信息"
	
	s objPatMas=##class(User.PAPatMas).%OpenId(PAPMI)
	q:(objPatMas="") "0|患者信息不存在"
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s arrFiles = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientInfoByPAPMI(PAPMI)
	s PatiSex = arrFiles.GetAt("PAPMISex")
	s:(PatiSex '="") PatiSex = $p(PatiSex,"^",3)
	//s SexDR=$p($g(^PAPER(PAPMI,"ALL")),"^",7)
	//s PatiSex=$p($g(^CT("SEX",SexDR)),"^",2)
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	
	TSTART
	s $zt = "OnImportEpisodeErrHandler"
	////×××××处理MRPatient
	s MRPatientID=""
	s MRPatientID=$o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_PAPMI,MRPatientID))
	if (MRPatientID="")	//未找到PAPMI对应的MRPatient则 新建
	{
		s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%New()
		s objMRPatient.SysCode="DHC"
		s objMRPatient.PatientID=PAPMI
		s objMRPatient.Name=objPatMas.PAPMIName
		s objMRPatient.Gender=PatiSex
		s objMRPatient.MedRecordNo=AMedRecordNo
		s objMRPatient.CreateDate=nowDate
		s objMRPatient.CreateTime=nowTime
		s objMRPatient.LastModifyDate=nowDate
		s objMRPatient.LastModifyTime=nowTime
		s objMRPatient.Birthday=objPatMas.PAPMIDOB
		s objMRPatient.Company="HISImport|"_$zd(nowDate,3)
		s status = objMRPatient.%Save()
		if ($$$ISERR(status))
		{
			TROLLBACK
			q "0|保存MRPatient出错!"
		}
		else
		{
			s MRPatientID=objMRPatient.%Id()
		}
	}
	
	////×××××处理MRMedRecord
	s MRMedRecordID=""
	s MRMedRecordID=$o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," "_AMedRecordNo,MRMedRecordID))
	
	if (MRMedRecordID="")
	{
		s objMRMedRecord=##class(DHCEPRFS.INST.MRMedRecord).%New()
		s objMRMedRecord.MedRecordNo=AMedRecordNo
		s objMRMedRecord.MRPatientID=MRPatientID
		s objMRMedRecord.SysCode="DHC"
		s objMRMedRecord.CreateDate=nowDate
		s objMRMedRecord.CreateTime=nowTime
		s objMRMedRecord.LastModifyDate=nowDate
		s objMRMedRecord.LastModifyTime=nowTime
		s objMRMedRecord.IsHISMedRecord="N"
		s status = objMRMedRecord.%Save()
		if ($$$ISERR(status))
		{
			TROLLBACK
			q "0|保存MRMedRecord出错!"
		}
		else
		{
			s MRMedRecordID=objMRMedRecord.%Id()
		}
	}
	
	////×××××处理MREpisode
	s MREpisodeID=""
	s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxDisDate",$zdh(ADisDate,3)," "_MRPatientID,MREpisodeID))
	if (MREpisodeID="")
	{
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%New()
		s objMREpisode.SysCode = "DHC"
		s objMREpisode.CreateDate = nowDate
		s objMREpisode.CreateTime = nowTime
		s objMREpisode.LastModifyDate = nowDate
		s objMREpisode.LastModifyTime = nowTime
		s ret=..GetLocIDByDesc(AAdmLocDesc,ADisLocDesc)	//取科室ID
		s AdmLocID=$p(ret,"^",1)
		s DisLocID=$p(ret,"^",2)
		s objMREpisode.AdmLocID = AdmLocID
		s objMREpisode.AdmLoc = AAdmLocDesc
		s objMREpisode.DisLocID = DisLocID
		s objMREpisode.DisLoc = ADisLocDesc
		s objMREpisode.AdmDate = $zdh(AAdmDate,3)
		s objMREpisode.DisDate = $zdh(ADisDate,3)
		s objMREpisode.MedRecordNo = AMedRecordNo
		s objMREpisode.MRMedRecordID = MRMedRecordID
		s objMREpisode.MRPatientID = MRPatientID
		s status = objMREpisode.%Save()
		if ($$$ISERR(status))
		{
			TROLLBACK
			q "0|保存MREpisode出错!"
		}
		else
		{
			s MREpisodeID=objMREpisode.%Id()
		}
		
		s objMREpisodeNew = ##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)	//处理EpisodeID
		s objMREpisodeNew.EpisodeID="VE"_MREpisodeID
		s status = objMREpisodeNew.%Save()
		if ($$$ISERR(status))
		{
			TROLLBACK
			q "0|保存MREpisode_EpisodeID出错!"
		}
		
		//处理	MREpisodePat
		s objMREpiosodePat=##class(DHCEPRFS.INST.MREpisodePat).%New()
		s objMREpiosodePat.SysCode="DHC"
		s objMREpiosodePat.PatientID=PAPMI
		s objMREpiosodePat.CompanyCode=""
		s objMREpiosodePat.CreateDate=nowDate
		s objMREpiosodePat.CreateTime=nowTime
		s objMREpiosodePat.LastModifyDate=nowDate
		s objMREpiosodePat.LastModifyTime=nowTime
		s objMREpiosodePat.AdmCount=1
		s objMREpiosodePat.InCount=1
		s objMREpiosodePat.MedRecordNo=AMedRecordNo
		s objMREpiosodePat.Name=objPatMas.PAPMIName
		s objMREpiosodePat.Gender=PatiSex
		s objMREpiosodePat.Birthday=objPatMas.PAPMIDOB
		s objMREpiosodePat.EpisodeID="VE"_MREpisodeID
		s objMREpiosodePat.MREpisodeID=MREpisodeID
		s objMREpiosodePat.MRPatientID=MRPatientID
		s objMREpiosodePat.MRMedRecordID=MRMedRecordID
		s status = objMREpiosodePat.%Save()
		if ($$$ISERR(status))
		{
			TROLLBACK
			q "0|保存MREpiosodePat出错!"
		}
		else
		{
			d ..InsertImportLog(AUserID,AMedRecordNo,MREpisodeID,objPatMas.PAPMIName,ADirName,"Info","ImportEpisode 成功!")
			TCOMMIT			//成功 提交
			q "1|"_MREpisodeID
		}
	}
	else		//如果找到MREpisode说明已经存在
	{
		TROLLBACK
		q "0|已经存在MREpisodeID("_MREpisodeID_"),不允许重新导入!"
	}
	
OnImportEpisodeErrHandler
	TROLLBACK
	q "0|ImportEpisode方法执行出错!"
}

/// Debug：w ##class(DHCEPRFS.BL.BLImportHisPDF).GetLocIDByDesc("CK-产科","CK-产科")
ClassMethod GetLocIDByDesc(AAdmLocDesc As %String, ADisLocDesc As %String) As %String
{
	//校验科室 遍历科室
	s AAdmLocID=""
	s ADisLocID=""
	
	s result = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetCTLocID")
	d result.Execute()
	
	while(result.Next())
	{
		s CTLOCRowID = $g(result.Data("CTLocID"))
		s arrFiles = ##class(%ArrayOfDataTypes).%New()
		s arrFiles = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetCTLocInfoByCTLocID(CTLOCRowID)
		s CTLOCDesc = arrFiles.GetAt("CTLocDesc")
		//b "s"
		if (AAdmLocDesc=CTLOCDesc){	s AAdmLocID=CTLOCRowID	}
		if (ADisLocDesc=CTLOCDesc){	s ADisLocID=CTLOCRowID	}
		s CTLOCDescRight=$p(CTLOCDesc,"-",2)
		if (AAdmLocDesc=CTLOCDescRight){	s AAdmLocID=CTLOCRowID	}
		if (ADisLocDesc=CTLOCDescRight){	s ADisLocID=CTLOCRowID	}
		q:((AAdmLocID'="")&&(ADisLocID'=""))
	}
	/*
	s CTLOCRowID="0"
	for {
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID))
		q:(CTLOCRowID="")
		s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)
		if (AAdmLocDesc=CTLOCDesc){	s AAdmLocID=CTLOCRowID	}
		if (ADisLocDesc=CTLOCDesc){	s ADisLocID=CTLOCRowID	}
		s CTLOCDescRight=$p(CTLOCDesc,"-",2)
		if (AAdmLocDesc=CTLOCDescRight){	s AAdmLocID=CTLOCRowID	}
		if (ADisLocDesc=CTLOCDescRight){	s ADisLocID=CTLOCRowID	}
		q:((AAdmLocID'="")&&(ADisLocID'="")) 
	}
	*/
	q AAdmLocID_"^"_ADisLocID
}

/// Debug：w ##class(DHCEPRFS.BL.BLImportHisPDF).InsertImportLog("128","500218","","安然","Info","个人信息处理成功")
ClassMethod InsertImportLog(AUserID As %String, AMedRecordNo As %String, AMREpisodeID As %String, APatientName As %String, ADirName As %String, AInfoType As %String, AInfo As %String) As %String
{
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	s objImportLog=##class(DHCEPRFS.INST.MRImportLog).%New()
	s objImportLog.CreateDate=nowDate
	s objImportLog.CreateTime=nowTime
	s objImportLog.UserID=AUserID
	s objImportLog.MedRecordNo=AMedRecordNo
	s objImportLog.MREpisodeID=AMREpisodeID
	s objImportLog.PatientName=APatientName
	s objImportLog.DirName=ADirName
	s objImportLog.InfoType=AInfoType
	s objImportLog.Info=AInfo
	s status = objImportLog.%Save()
	if ($$$ISERR(status))
	{
		q "0"
	}
	else
	{
		q "1"
	}
}

/// Debug：w ##class(DHCEPRFS.BL.BLImportHisPDF).GetFilePathByMREpisode(57)
ClassMethod GetFilePathByMREpisode(AMREpisodeID As %String) As %String
{
	s ret=""
	s MRVersionID=""
	s MRVersionID=$o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_AMREpisodeID,0,""))
	q:(MRVersionID="") ""
	
	s MRItemID=""
	for {
		s MRItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,MRItemID))
		q:(MRItemID="")
		s MRVerItemID=""
		for {
			s MRVerItemID=$o(^DHCEPRFS.INST.MRVerItemI("IdxMain"," "_MRVersionID,MRItemID,MRVerItemID))
			q:(MRVerItemID="")
			s objMRVerItem=##class(DHCEPRFS.INST.MRVerItem).%OpenId(MRVerItemID)
			s key=""
			do 
			{
				s objMRVerItemDetail=objMRVerItem.TheMRVerItemDetail.GetNext(.key)
				q:(objMRVerItemDetail="")
				if (ret="")
				{
					s ret=##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(objMRVerItemDetail.FileMasterID)
				}
				else
				{
					s ret=ret_"^"_##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(objMRVerItemDetail.FileMasterID)
				}
			}
			while (key '="")
		}
	}
	q ret
}

}
