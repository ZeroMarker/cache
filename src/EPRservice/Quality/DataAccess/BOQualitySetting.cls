/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualitySetting
/// * Description:	质控启动开关设置服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualitySetting Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualitySettingInfo";

///  *****************************************************
///  功能：获取所有质控启动开关
///  *****************************************************
ClassMethod GetQualitySettings() As EPRservice.dataset.Quality.EQualitySettingDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.Quality.EQualitySettingDataset).%New()
	q result
}

///  *****************************************************
///  功能：创建启动开关设置
///  *****************************************************
ClassMethod CreateQualitySetting(ASetting As EPRservice.entity.Quality.EQualitySetting) As %String [ WebMethod ]
{
	TSTART
	s objQuaSetting = ##class(EPRmeta.Quality.QualitySetting).%New()
	
	s objQuaSetting.HospitalDR = ASetting.HospitalDR
	s objQuaSetting.SSGroupDR = ASetting.SSGroupDR
	s objQuaSetting.EventTypeDR = ASetting.EventTypeDR
	s objQuaSetting.ControlTypeDR = ASetting.ControlTypeDR
	s objQuaSetting.QualityRuleDR = ASetting.QualityRuleDR
	s objQuaSetting.StructDR = ASetting.StructDR
	s objQuaSetting.IsActive = ASetting.IsActive
	s objQuaSetting.ResumeText = ASetting.ResumeText
	
	s isExist = $O(^DHCEPRM.QualitySettingI("IdxComposite",ASetting.HospitalDR,ASetting.SSGroupDR," "_ASetting.EventTypeDR," "_ASetting.ControlTypeDR," "_ASetting.QualityRuleDR,""))
	if (isExist'="")
	{
		TROLLBACK
		q "-1"	
	}
	
	if '(objQuaSetting.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objQuaSetting.%Id()
}

///  *****************************************************
///  功能：更新质控启动开关
///  *****************************************************
ClassMethod UpdateQualitySetting(ASetting As EPRservice.entity.Quality.EQualitySetting) As %String [ WebMethod ]
{
	TSTART
	s objQuaSetting = ##class(EPRmeta.Quality.QualitySetting).%OpenId(ASetting.ID)
	q:(objQuaSetting = "") "ERROR"
	
	s objQuaSetting.HospitalDR = ASetting.HospitalDR
	s objQuaSetting.SSGroupDR = ASetting.SSGroupDR
	s objQuaSetting.EventTypeDR = ASetting.EventTypeDR
	s objQuaSetting.ControlTypeDR = ASetting.ControlTypeDR
	s objQuaSetting.QualityRuleDR = ASetting.QualityRuleDR
	s objQuaSetting.StructDR = ASetting.StructDR
	s objQuaSetting.IsActive = ASetting.IsActive
	s objQuaSetting.ResumeText = ASetting.ResumeText
	
	if '(objQuaSetting.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

///  *****************************************************
///  功能：根据ID删除质控启动开关
///  入参：AId为质控启动开关表QualitySetting的ID
///  *****************************************************
ClassMethod DeleteQualitySettingById(AId As %String) As %Boolean [ WebMethod ]
{
	TSTART
 	s objQualitySetting = ##class(EPRmeta.Quality.QualitySetting).%OpenId(AId)
	q:(objQualitySetting ="") 0 

 	if '(objQualitySetting.%DeleteId(AId))
 	{
 		TROLLBACK
 		q 0
 	} 
 	TCOMMIT
 	q 1
}

/// Desc:		取质控启动根节点
/// Creator:		Candy
/// CreateDate:	2014-9-25
/// Input: 		ALocID 科室ID
/// 				ARuleID 质控标准ID
/// Output:		StructID 质控结构ID
/// Debug:		w ##Class(EPRservice.Quality.DataAccess.BOQualitySetting).GetRootStructID(6,6)	
ClassMethod GetRootStructID(ALocID As %String, ARuleID As %String) As %String
{
	s StructID = ""
	q:(ALocID = "")||(ARuleID = "") StructID
	s HospitalID = $p($g(^CTLOC(ALocID)),"^",22)
	s IsBSQualityEnable=##Class(EPRservice.Quality.CommonHelper).IsBSQualityEnable()  //BS版本质控维护程序是否启用
	s:(IsBSQualityEnable'="Y") IsGroupHospital = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetIsGroupHosp")
	s:(IsBSQualityEnable="Y") IsGroupHospital = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("QuaSetIsGroupHosp")
	s:($zcvt(IsGroupHospital,"U") '= "Y")&&(IsBSQualityEnable'="Y") HospitalID = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("QuaSetHospital")
	s:($zcvt(IsGroupHospital,"U") '= "Y")&&(IsBSQualityEnable="Y") HospitalID = ##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCodeNew("QuaSetHospital")
	s:(IsBSQualityEnable'="Y") StructID = $o(^DHCEPRM.QualitySettingI("IdxHospitalStruct"," "_"Y"," "_ARuleID,HospitalID,""))
	s:(IsBSQualityEnable="Y") StructID = $o(^CT.MA.QC.QualitySettingI("IdxHospitalStruct"," "_"Y"," "_ARuleID,HospitalID,""))
	q StructID
}

}
