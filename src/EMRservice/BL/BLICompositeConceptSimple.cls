/// Desc:       打散数据-保存ConceptSimpleData
/// Creator:    Candyxu
/// CreateDate: 2015-8-14
Class EMRservice.BL.BLICompositeConceptSimple Extends (%RegisteredObject, %XML.Adaptor)
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
	s reUpdate = ..UpdateCompositeConceptSimpleData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeConceptSimpleData(AInstanceID,AKey)
	q:(reInsert = -1) result
	s reDelete = ..DeleteCompositeConceptSimpleData(AInstanceID,AKey)
	q:(reDelete = -1) result	
    s result = 1
	q result
SaveHandler
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
	
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertConceptSimple",AInstanceID)
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.RealTemplateID
	k objInstance
	s scode = ""
	for
	{
		s scode = $o(^DHCEMRI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ccode = ""
		for
		{
			s ccode = $o(^DHCEMRI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode))
			q:(ccode = "")
			s tmpccode = $tr(ccode," ","")
			s cecode = ""
			for
			{
				s cecode = $o(^DHCEMRI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,cecode))
				q:(cecode = "")
				s tmpcecode = $tr(cecode," ","")
				s code = ""
				for
				{
					s code = $o(^DHCEMRI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s rowId = $o(^DHCEMRI.IConceptSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,cecode,code,""))
					s tmpcode = $tr(code," ","")
					if ($d(^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode))>0)
					{
						s objIConceptSimple = ##Class(EMRinstance.ICompositeConceptSimple).%OpenId(rowId)
						continue:(objIConceptSimple = "")
						if (objIConceptSimple.TemplateID '= TemplateID)
						{
							s ^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode) = rowId	
						}
						else
						{
							s ^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode) = rowId
						}
						k objIConceptSimple
					}
					else
					{
						s ^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID,tmpscode,tmpccode,tmpcecode,tmpcode) = rowId	
					}
				}				
			} 
		}
	}
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode))
				q:(cecode = "")
				s code = ""
				for
				{
					s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s:($d(^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID,scode,ccode,cecode,code))<=0) ^CacheTempEMRScatterData(AKey,"tmpInsertConceptSimple",AInstanceID,scode,ccode,cecode,code)=""
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
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID,scode,ccode,cecode))
				q:(cecode = "")
				s code = ""
				for
				{
					s code = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s rowId = ^CacheTempEMRScatterData(AKey,"tmpUpdateConceptSimple",AInstanceID,scode,ccode,cecode,code)
					s objIConceptSimple = ##Class(EMRinstance.ICompositeConceptSimple).%OpenId(rowId)
					continue:(objIConceptSimple = "")
					s objIConceptSimple.SectionCode = scode
					s objIConceptSimple.CompositeCode = ccode
					s objIConceptSimple.ConceptCode = cecode
					s objIConceptSimple.BindKBCode = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"BindKBCode")				
					s objIConceptSimple.KBNodeID = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"KBNodeID")
					s objIConceptSimple.DataRef = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"DataRef")
					s objIConceptSimple.DataValue = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"DataValue")
					s objIConceptSimple.Separator = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"Separator")
					s objIConceptSimple.ValueCode = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"ValueCode")
					s objIConceptSimple.Type = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"Type")
		
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
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertConceptSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertConceptSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertConceptSimple",AInstanceID,scode,ccode,cecode))	
				q:(cecode = "")	
				s code = ""
				for
				{
					s code = $o(^CacheTempEMRScatterData(AKey,"tmpInsertConceptSimple",AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s objIConceptSimple = ##Class(EMRinstance.ICompositeConceptSimple).%New()
					s objIConceptSimple.ChartItemID = objEcrecord.RealChartItemID
					s objIConceptSimple.EpisodeID = objEcrecord.RealEpisodeID
					s objIConceptSimple.InstanceDataID = AInstanceID
					s objIConceptSimple.PatientID = objEcrecord.PatientID
					s objIConceptSimple.SimpleItemCode = code
					s objIConceptSimple.TemplateID = objInstance.RealTemplateID
					s objIConceptSimple.TemplateVersion = objInstance.TemplateVersion
					s objIConceptSimple.SectionCode = scode
					s objIConceptSimple.CompositeCode = ccode
					s objIConceptSimple.ConceptCode = cecode
					s objIConceptSimple.BindKBCode = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"BindKBCode")
					s objIConceptSimple.DataRef = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"DataRef")
					s objIConceptSimple.DataValue = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"DataValue") 
					s objIConceptSimple.KBNodeID = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"KBNodeID")
					s objIConceptSimple.Separator = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"Separator") 
					s objIConceptSimple.ValueCode = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"ValueCode")
					s objIConceptSimple.Type = ^CacheTempEMRScatterData(AKey,"tmpNewConceptSimple",AInstanceID,scode,ccode,cecode,code,"Type")
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
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s cecode = ""
			for
			{
				s cecode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID,scode,ccode,cecode))
				q:(cecode = "")	
				s code = ""
				for
				{
					s code = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID,scode,ccode,cecode,code))
					q:(code = "")
					s rowId = ^CacheTempEMRScatterData(AKey,"tmpDeleteConceptSimple",AInstanceID,scode,ccode,cecode,code)
					continue:(rowId = "")
					s sc = ##Class(EMRinstance.ICompositeConceptSimple).%DeleteId(rowId)
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
