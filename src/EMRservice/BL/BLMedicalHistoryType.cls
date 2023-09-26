/// Desc: 		病史类型Bl层 
/// Creator:	Donglulu
/// CreatDate:	2020-12-9
Class EMRservice.BL.BLMedicalHistoryType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLMedicalHistoryType).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.MedicalHistoryType).%BuildIndices()
	
	s code = "HDSD00.13.300"
	s alias = "MedicalHistory"
	s desc = "Medical History 既往史"
	s seq = "1"
	d ..InsertRule(code, desc, alias, seq)
	
	s code = "HDSD00.13.028"
	s alias = "InfectionDiseaseHistory"
	s desc = "Infection Disease History 传染病史"
	s seq = "2"
	d ..InsertRule(code, desc, alias, seq)
	
	s code = "HDSD00.13.065"
	s alias = "SurgicalHistory"
	s desc = "Surgical History 手术史"
	s seq = "3"
	d ..InsertRule(code, desc, alias, seq)
	
	s code = "undefined1"
	s alias = "Hospitalization"
	s desc = "Hospitalization 住院史"
	s seq = "4"
	d ..InsertRule(code, desc, alias, seq)
	
	s code = "HDSD00.13.041"
	s alias = "MarriageHistory"
	s desc = "Marriage History 婚育史"
	s seq = "5"
	d ..InsertRule(code, desc, alias, seq)
	
	s code = "HDSD00.13.043"
	s alias = "FamilyMedicalHistory"
	s desc = "Family Medical History 家族史"
	s seq = "6"
	d ..InsertRule(code, desc, alias, seq)
	
	/*s code = "HDSD00.13.036"
	s alias = "SocialHistory"
	s desc = "Social History 个人史"
	s seq = "7"
	d ..InsertRule(code, desc, alias, seq)
	
	s code = "HDSD00.13.037"
	s alias = "AllergyHistory"
	s desc = "Allergy History 过敏史"
	s seq = "8"
	d ..InsertRule(code, desc, alias, seq)*/
}

/// Debug: d ##Class(EMRservice.BL.BLMedicalHistoryType).InsertRule("","","","")
ClassMethod InsertRule(ACode As %String, ADesc As %String, AAlias As %String, ASeq As %String) As %String
{
	s id=$O(^DHCEMRM.MedHistoryTypeI("IdxCode"," "_$zcvt(ACode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.MedicalHistoryType).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.MedicalHistoryType).%OpenId(id)
	}
	
	s obj.Code = ACode
	s obj.Description = ADesc
	s obj.Alias = AAlias
	s obj.Seq = ASeq
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

/// Desc:       取诊前问诊题库病史类型
/// Creator:    Donglulu
/// CreateDate: 2020-12-3
/// Input:      
/// OutPut:     json 诊前问诊题库病史类型数据集
/// Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryType).GetTypeList()
ClassMethod GetTypeList() As %String
{
	s json = ""
	s count = 0
	
	s code = ""
	for
	{
		s code = $O(^DHCEMRM.MedHistoryTypeI("IdxCode",code))
		q:(code = "")
		s rowID = $O(^DHCEMRM.MedHistoryTypeI("IdxCode",code,""))
		q:(rowID = "")
		
		s obj = ##Class(EMRmeta.MedicalHistoryType).%OpenId(rowID)
		
		s json = json_"{"
		s json = json_"""Code"":"""_obj.Code_""","
		s json = json_"""Alias"":"""_obj.Alias_""","
		s json = json_"""Desc"":"""_obj.Description_""""
		s json = json_"}"
		s json = json_","
		
		s count = count + 1
	}
	
	
	s json = $e(json,1,$l(json)-1)
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       取诊前问诊题库病史目录
/// Creator:    Donglulu
/// CreateDate: 2020-12-3
/// Input:      
/// OutPut:     json 诊前问诊题库病史目录
/// Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryType).GetTypeCategory()
ClassMethod GetTypeCategory() As %String
{
	
	s json = ""
	s count = 0
	s ret = ##Class(%GlobalCharacterStream).%New()
	s seq = ""
	for
	{
		s seq = $O(^DHCEMRM.MedHistoryTypeI("IdxSeqCode",seq))
		q:(seq = "")
		s code = ""
		for
		{
			s code = $O(^DHCEMRM.MedHistoryTypeI("IdxSeqCode",seq,code))
			q:(code = "")
			s rowID = $O(^DHCEMRM.MedHistoryTypeI("IdxSeqCode",seq,code,""))
			q:(rowID = "")
			
			s obj = ##Class(EMRmeta.MedicalHistoryType).%OpenId(rowID)
			
			s json = json_"{"
			s json = json_"""id"":"""_obj.Code_""","
			s json = json_"""Alias"":"""_obj.Alias_""","
			s json = json_"""rowid"":"""_rowID_""","
			s json = json_"""text"":"""_obj.Description_""""
			s json = json_"}"
			s json = json_","
			
			s count = count + 1
		}
	}
	
	s json = $e(json,1,$l(json)-1)
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
