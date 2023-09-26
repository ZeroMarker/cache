/// Desc:       打散数据-保存ConceptData
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
Class EMRservice.BL.BLICompositeConcept Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存医学概念打散数据
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod Save(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "SaveHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s reFilter = ..FilterCompositeConceptData(AInstanceID,AKey)
	q:(reFilter = -1) result
	s reUpdate = ..UpdateCompositeConceptData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeConceptData(AInstanceID,AKey)
	q:(reInsert = -1) result
	s reDelete= ..DeleteCompositeConceptData(AInstanceID,AKey)
	q:(reDelete = -1) result
    s result = 1
	q result 
SaveHandler
    q -1
}

/// Desc:       分析插入、修改和删除数据
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod FilterCompositeConceptData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result

	
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertCompositeConcept",AInstanceID)
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.RealTemplateID
	k objInstance
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^DHCEMRI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ccode = ""
		for
		{
			s ccode = $o(^DHCEMRI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode,ccode))
			q:(ccode = "")
			s tmpccode = $tr(ccode," ","")
			s code = ""
			for
			{
				s code = $o(^DHCEMRI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = $o(^DHCEMRI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode,ccode,code,""))
				s tmpcode = $tr(code," ","")
				if ($d(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,tmpscode,tmpccode,tmpcode))>0)
				{
					s objICompositeConcept = ##Class(EMRinstance.ICompositeConcept).%OpenId(rowId)
					continue:(objICompositeConcept = "")
					if (objICompositeConcept.TemplateID '= TemplateID)
					{
						s ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
					}
					else
					{
						s ^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId
					}
					k objICompositeConcept
				}
				else
				{
					s ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
				}				
			}

		}
	}
	
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,scode,ccode,code))
				q:(code = "")
				s:($d(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID,scode,ccode,code))<=0) ^CacheTempEMRScatterData(AKey,"tmpInsertCompositeConcept",AInstanceID,scode,ccode,code)=""
			}			
		}
	}
	q result
ErrorHandler
   q -1
}

/// Desc:       更新数据
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod UpdateCompositeConceptData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID,scode)) 
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID,scode,ccode)) 
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeConcept",AInstanceID,scode,ccode,code)
				s objICompositeConcept = ##Class(EMRinstance.ICompositeConcept).%OpenId(rowId)
				continue:(objICompositeConcept = "")
				d objICompositeConcept.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,scode,ccode,code))
				d objICompositeConcept.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,scode,ccode,code,"StyleText"))
				s sc = objICompositeConcept.%Save()
				if ($$$ISERR(sc))
				{
					s result = -1
					q
				}
			}			
		}
	}
	q result
}

/// Desc:       插入数据
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod InsertCompositeConceptData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s ecrecordId = $p(AInstanceID,"||",1)
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertCompositeConcept",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertCompositeConcept",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpInsertCompositeConcept",AInstanceID,scode,ccode,code))
				q:(code = "")
				s objICompositeConcept = ##Class(EMRinstance.ICompositeConcept).%New()
				s objICompositeConcept.ChartItemID = objEcrecord.RealChartItemID
				s objICompositeConcept.EpisodeID = objEcrecord.RealEpisodeID
				s objICompositeConcept.InstanceDataID = AInstanceID
				s objICompositeConcept.PatientID = objEcrecord.PatientID
				s objICompositeConcept.SectionCode = scode
				s objICompositeConcept.CompositeCode = ccode
				s objICompositeConcept.ConceptCode = code
				s objICompositeConcept.TemplateID = objInstance.RealTemplateID
				s objICompositeConcept.TemplateVersion = objInstance.TemplateVersion
				d objICompositeConcept.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,scode,ccode,code))
				d objICompositeConcept.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeConcept",AInstanceID,scode,ccode,code,"StyleText"))
				s sc = objICompositeConcept.%Save()
				if ($$$ISERR(sc))
				{
					s result = -1
					q
				}
			}			
		}
	}
	k objEcrecord,objInstance,objICompositeConcept
	q result
}

/// Desc:       删除多余数据
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod DeleteCompositeConceptData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeConcept",AInstanceID,scode,ccode,code)
				continue:(rowId = "")
				s sc = ##Class(EMRinstance.ICompositeConcept).%DeleteId(rowId)
				if ($$$ISERR(sc))
				{
					s result = -1
					q
				}
			}			
		}
	}
	q result
}

}
