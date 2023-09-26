/// Desc:       打散数据-保存ConceptData
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
Class web.DHCCM.EMRservice.BL.BLICompositeConcept Extends (%RegisteredObject, %XML.Adaptor)
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
	Tstart
	s reUpdate = ..UpdateCompositeConceptData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeConceptData(AInstanceID,AKey)
	if (reInsert = -1)
	{
		Trollback
		q result	
	}
	s reDelete= ..DeleteCompositeConceptData(AInstanceID,AKey)
	if (reDelete = -1)
	{
		Trollback
		q result	
	}
    TCOMMIT	
    s result = 1
	q result 
SaveHandler
    Trollback
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

	
	k ^tmpDeleteCompositeConcept(AKey,AInstanceID)
	k ^tmpUpdateCompositeConcept(AKey,AInstanceID)
	k ^tmpInsertCompositeConcept(AKey,AInstanceID)
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.TemplateID
	k objInstance
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^DHCPHI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ccode = ""
		for
		{
			s ccode = $o(^DHCPHI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode,ccode))
			q:(ccode = "")
			s tmpccode = $tr(ccode," ","")
			s code = ""
			for
			{
				s code = $o(^DHCPHI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = $o(^DHCPHI.ICompositeConceptI("IdxForUpdate"," "_AInstanceID,scode,ccode,code,""))
				s tmpcode = $tr(code," ","")
				if ($d(^tmpNewCompositeConcept(AKey,AInstanceID,tmpscode,tmpccode,tmpcode))>0)
				{
					s objICompositeConcept = ##Class(User.DHCPHICompositeConcept).%OpenId(rowId)
					continue:(objICompositeConcept = "")
					if (objICompositeConcept.TemplateID '= TemplateID)
					{
						s ^tmpDeleteCompositeConcept(AKey,AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
					}
					else
					{
						s ^tmpUpdateCompositeConcept(AKey,AInstanceID,tmpscode,tmpccode,tmpcode) = rowId
					}
					k objICompositeConcept
				}
				else
				{
					s ^tmpDeleteCompositeConcept(AKey,AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
				}				
			}

		}
	}
	
	s scode = ""
	for
	{
		s scode = $o(^tmpNewCompositeConcept(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpNewCompositeConcept(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpNewCompositeConcept(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s:($d(^tmpUpdateCompositeConcept(AKey,AInstanceID,scode,ccode,code))<=0) ^tmpInsertCompositeConcept(AKey,AInstanceID,scode,ccode,code)=""
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
		s scode = $o(^tmpUpdateCompositeConcept(AKey,AInstanceID,scode)) 
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpUpdateCompositeConcept(AKey,AInstanceID,scode,ccode)) 
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpUpdateCompositeConcept(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^tmpUpdateCompositeConcept(AKey,AInstanceID,scode,ccode,code)
				s objICompositeConcept = ##Class(User.DHCPHICompositeConcept).%OpenId(rowId)
				continue:(objICompositeConcept = "")
				d objICompositeConcept.Text.Write(^tmpNewCompositeConcept(AKey,AInstanceID,scode,ccode,code))
				d objICompositeConcept.StyleText.Write(^tmpNewCompositeConcept(AKey,AInstanceID,scode,ccode,code,"StyleText"))
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
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^tmpInsertCompositeConcept(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpInsertCompositeConcept(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpInsertCompositeConcept(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s objICompositeConcept = ##Class(User.DHCPHICompositeConcept).%New()
				s objICompositeConcept.ChartItemID = objEcrecord.ChartItemID
				s objICompositeConcept.EpisodeID = objEcrecord.EpisodeID
				s objICompositeConcept.InstanceDataID = AInstanceID
				s objICompositeConcept.PatientID = objEcrecord.PatientID
				s objICompositeConcept.SectionCode = scode
				s objICompositeConcept.CompositeCode = ccode
				s objICompositeConcept.ConceptCode = code
				s objICompositeConcept.TemplateID = objInstance.TemplateID
				s objICompositeConcept.TemplateVersion = objInstance.TemplateVersion
				d objICompositeConcept.Text.Write(^tmpNewCompositeConcept(AKey,AInstanceID,scode,ccode,code))
				d objICompositeConcept.StyleText.Write(^tmpNewCompositeConcept(AKey,AInstanceID,scode,ccode,code,"StyleText"))
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
		s scode = $o(^tmpDeleteCompositeConcept(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpDeleteCompositeConcept(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpDeleteCompositeConcept(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^tmpDeleteCompositeConcept(AKey,AInstanceID,scode,ccode,code)
				continue:(rowId = "")
				s sc = ##Class(User.DHCPHICompositeConcept).%DeleteId(rowId)
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
