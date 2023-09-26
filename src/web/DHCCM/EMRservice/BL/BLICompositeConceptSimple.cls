/// Desc:       打散数据-保存ConceptSimpleData
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
Class web.DHCCM.EMRservice.BL.BLICompositeConceptSimple Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存复合元素打散数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod Save(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "SaveHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s reFilte = ..FilterCompositeConceptSimpleData(AInstanceID,AKey)
	q:(reFilte = -1) result
	Tstart
	s reUpdate = ..UpdateCompositeConceptSimpleData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeConceptSimpleData(AInstanceID,AKey)
	if (reInsert = -1)
	{
		Trollback
		q result	
	}
	s reDelete = ..DeleteCompositeConceptSimpleData(AInstanceID,AKey)
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
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod FilterCompositeConceptSimpleData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	
	k ^tmpDeleteConceptSimple(AKey,AInstanceID)
	k ^tmpUpdateConceptSimple(AKey,AInstanceID)
	k ^tmpInsertConceptSimple(AKey,AInstanceID)
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.TemplateID
	k objInstance
	s scode = ""
	for
	{
		s scode = $o(^DHCPHI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ccode = ""
		for
		{
			s ccode = $o(^DHCPHI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode))
			q:(ccode = "")
			s tmpccode = $tr(ccode," ","")
			s cecode = ""
			for
			{
				s cecode = $o(^DHCPHI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,cecode))
				q:(cecode = "")
				s tmpcecode = $tr(cecode," ","")
				s code = ""
				for
				{
					s code = $o(^DHCPHI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s rowId = $o(^DHCPHI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,cecode,code,""))
					s tmpcode = $tr(code," ","")
					if ($d(^tmpNewConceptSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode))>0)
					{
						s objIConceptSimple = ##Class(User.DHCPHICompositeConceptSimple).%OpenId(rowId)
						continue:(objIConceptSimple = "")
						if (objIConceptSimple.TemplateID '= TemplateID)
						{
							s ^tmpDeleteConceptSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode) = rowId	
						}
						else
						{
							s ^tmpUpdateConceptSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode) = rowId
						}
						k objIConceptSimple
					}
					else
					{
						s ^tmpDeleteConceptSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode) = rowId	
					}
				}				
			} 
		}
	}
	s scode = ""
	for
	{
		s scode = $o(^tmpNewConceptSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode))
				q:(cecode = "")
				s code = ""
				for
				{
					s code = $o(^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s:($d(^tmpUpdateConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code))<=0) ^tmpInsertConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code)=""
				}			
			}
		}
	}
	s result = 1
	q result
ErrorHandler
   q -1
}

/// Desc:       更新数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod UpdateCompositeConceptSimpleData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^tmpUpdateConceptSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpUpdateConceptSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^tmpUpdateConceptSimple(AKey,AInstanceID,scode,ccode,cecode))
				q:(cecode = "")
				s code = ""
				for
				{
					s code = $o(^tmpUpdateConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s rowId = ^tmpUpdateConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code)
					s objIConceptSimple = ##Class(User.DHCPHICompositeConceptSimple).%OpenId(rowId)
					continue:(objIConceptSimple = "")
					s objIConceptSimple.SectionCode = scode
					s objIConceptSimple.CompositeCode = ccode
					s objIConceptSimple.ConceptCode = cecode
					s objIConceptSimple.BindKBCode = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"BindKBCode")				
					s objIConceptSimple.KBNodeID = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"KBNodeID")
					s objIConceptSimple.DataRef = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"DataRef")
					s objIConceptSimple.DataValue = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"DataValue")
					s objIConceptSimple.Separator = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"Separator")
					s objIConceptSimple.ValueCode = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"ValueCode")
					s objIConceptSimple.Type = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"Type")
		
					s sc = objIConceptSimple.%Save()
					if ($$$ISERR(sc))
					{
						s result = -1
						q
					}
				}				
			}
		}
	}
	q result
}

/// Desc:       插入数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod InsertCompositeConceptSimpleData(AInstanceID As %String, AKey As %String) As %String
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
		s scode = $o(^tmpInsertConceptSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpInsertConceptSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^tmpInsertConceptSimple(AKey,AInstanceID,scode,ccode,cecode))	
				q:(cecode = "")	
				s code = ""
				for
				{
					s code = $o(^tmpInsertConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s objIConceptSimple = ##Class(User.DHCPHICompositeConceptSimple).%New()
					s objIConceptSimple.ChartItemID = objEcrecord.ChartItemID
					s objIConceptSimple.EpisodeID = objEcrecord.EpisodeID
					s objIConceptSimple.InstanceDataID = AInstanceID
					s objIConceptSimple.PatientID = objEcrecord.PatientID
					s objIConceptSimple.SimpleItemCode = code
					s objIConceptSimple.TemplateID = objInstance.TemplateID
					s objIConceptSimple.TemplateVersion = objInstance.TemplateVersion
					s objIConceptSimple.SectionCode = scode
					s objIConceptSimple.CompositeCode = ccode
					s objIConceptSimple.ConceptCode = cecode
					s objIConceptSimple.BindKBCode = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"BindKBCode")
					s objIConceptSimple.DataRef = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"DataRef")
					s objIConceptSimple.DataValue = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"DataValue") 
					s objIConceptSimple.KBNodeID = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"KBNodeID")
					s objIConceptSimple.Separator = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"Separator") 
					s objIConceptSimple.ValueCode = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"ValueCode")
					s objIConceptSimple.Type = ^tmpNewConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code,"Type")
					s sc = objIConceptSimple.%Save()
					if ($$$ISERR(sc))
					{
						s result = -1
						q
					}
				}						
			}
		}
	}
	k objEcrecord,objInstance,objIConceptSimple
	q result
}

/// Desc:       删除多余数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod DeleteCompositeConceptSimpleData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^tmpDeleteConceptSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpDeleteConceptSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^tmpDeleteConceptSimple(AKey,AInstanceID,scode,ccode,cecode))
				q:(cecode = "")	
				s code = ""
				for
				{
					s code = $o(^tmpDeleteConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s rowId = ^tmpDeleteConceptSimple(AKey,AInstanceID,scode,ccode,cecode,code)
					continue:(rowId = "")
					s sc = ##Class(User.DHCPHICompositeConceptSimple).%DeleteId(rowId)
					if ($$$ISERR(sc))
					{
						s result = -1
						q
					}
				}					
			}

		}
	}
	q result
}

}
