Class DHCEPRRBAC.BL.HISInfo.PatientInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc：	取患者指针(PatientID)，not different from hospitals
/// Table:	PA_Adm.PAADM_PAPMI_DR
/// Others：被下列模板引用
/// 		[病案质控]EPRmeta.Quality.QualityExamSet
/// 		[模板控制]EPRservice.TPrivLogic.PatientInfoAssist
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR()
ClassMethod GetPapmiDR(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s retValue = ""
	s retValue = $P($g(^PAADM(argAdmId)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :argAdmId)
	q retValue
}

/// Desc：	取患者登记号
ClassMethod GetRegNo(APapmiDR As %String, AHospital As %String = "") As %String
{
	q:(($d(APapmiDR)=0)||(APapmiDR="")) ""
	q $P($g(^PAPER(APapmiDR,"PAT",1)),"^",1)
	//q "5"
}

/// Desc：	取患者病案号
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo("5000")
ClassMethod GetMedRecordNo(APapmiDR As %String, AEpisodeID As %String = "", AHospital As %String = "") As %String
{
	s:(APapmiDR = $c(0)) APapmiDR = ""
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s recordNo = ""
	
	//取电子病历系统参数医院标示
	s hospital = ##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	
	if (hospital = "BJFCYY")
	{
		s recordNo = ##class(EPRservice.HISInterface.PatientInfoAssist).IPRecordNoByMR(AEpisodeID,	AHospital)
		s:(+recordNo < 0) recordNo = ""
		q recordNo	
	}
	else
	{
		// Add by Liaowp 2013-12-16 当HIS中病案号为空时取医政管理中病案号方法
		//s recordNo = ##Class(web.DHCWMRService).IGetMrNoByPatientID(APapmiDR,AHospital,"")
		s recordNo = ##Class(web.DHCWMRService).IGetMrNoByPatientID(APapmiDR,.AErr)
		q:(recordNo '= "") recordNo
	
		// 其它医院使用默认字段
		s recordNo = $P($g(^PAPER(APapmiDR,"PAT",1)),"^",22)
		q recordNo
	}	
	
	q recordNo
}

}
