/// Desc:       打散数据-保存SimpleData
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
Class EMRservice.BL.BLICompositeSimple Extends (%RegisteredObject, %XML.Adaptor)
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
	s reFilte = ..FilterCompositeSimpleData(AInstanceID,AKey)
	q:(reFilte = -1) result
	s reUpdate = ..UpdateCompositeSimpleData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeSimpleData(AInstanceID,AKey)
	q:(reInsert = -1) result
	s reDelete = ..DeleteCompositeSimpleData(AInstanceID,AKey)
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
ClassMethod FilterCompositeSimpleData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertSimple",AInstanceID)
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.RealTemplateID
	k objInstance
	s scode = ""
	for
	{
		s scode = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ccode = ""
		for
		{
			s ccode = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode))
			q:(ccode = "")
			s tmpccode = $tr(ccode," ","") 
			s code = ""
			for
			{
				s code = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = $o(^DHCEMRI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,code,""))
				s tmpcode = $tr(code," ","")
				if ($d(^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,tmpscode,tmpccode,tmpcode))>0)
				{
					s objICompositeSimple = ##Class(EMRinstance.ICompositeSimple).%OpenId(rowId)
					continue:(objICompositeSimple = "")
					if (objICompositeSimple.TemplateID '= TemplateID)
					{
						s ^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
					}
					else
					{
						s ^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId
					}
					k objICompositeSimple
				}
				else
				{
					s ^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
				}
			}
		}
	}
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code))
				q:(code = "")
				s:($d(^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID,scode,ccode,code))<=0) ^CacheTempEMRScatterData(AKey,"tmpInsertSimple",AInstanceID,scode,ccode,code)=""
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
ClassMethod UpdateCompositeSimpleData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^CacheTempEMRScatterData(AKey,"tmpUpdateSimple",AInstanceID,scode,ccode,code)
				s objICompositeSimple = ##Class(EMRinstance.ICompositeSimple).%OpenId(rowId)
				continue:(objICompositeSimple = "")
				s objICompositeSimple.SectionCode = scode
				s objICompositeSimple.CompositeCode = ccode
				s objICompositeSimple.BindKBCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"BindKBCode")				
				s objICompositeSimple.KBNodeID = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"KBNodeID")
				s objICompositeSimple.DataRef = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"DataRef")
				s objICompositeSimple.DataValue = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"DataValue")
				s objICompositeSimple.Separator = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"Separator")
				s objICompositeSimple.ValueCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"ValueCode")
				s objICompositeSimple.Type = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"Type")
		
				s sc = objICompositeSimple.%Save()
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
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod InsertCompositeSimpleData(AInstanceID As %String, AKey As %String) As %String
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
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpInsertSimple",AInstanceID,scode,ccode,code))
				q:(code = "")
				s objICompositeSimple = ##Class(EMRinstance.ICompositeSimple).%New()
				s objICompositeSimple.ChartItemID = objEcrecord.RealChartItemID
				s objICompositeSimple.EpisodeID = objEcrecord.RealEpisodeID
				s objICompositeSimple.InstanceDataID = AInstanceID
				s objICompositeSimple.PatientID = objEcrecord.PatientID
				s objICompositeSimple.SimpleItemCode = code
				s objICompositeSimple.TemplateID = objInstance.RealTemplateID
				s objICompositeSimple.TemplateVersion = objInstance.TemplateVersion
				s objICompositeSimple.SectionCode = scode
				s objICompositeSimple.CompositeCode = ccode
				s objICompositeSimple.BindKBCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"BindKBCode")
				s objICompositeSimple.DataRef = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"DataRef")
				s objICompositeSimple.DataValue = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"DataValue") 
				s objICompositeSimple.KBNodeID = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"KBNodeID")
				s objICompositeSimple.Separator = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"Separator") 
				s objICompositeSimple.ValueCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"ValueCode")
				s objICompositeSimple.Type = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"Type")
				s sc = objICompositeSimple.%Save()
				if ($$$ISERR(sc))
				{
					s result = -1
					q
				}
				else
				{
					s sourceCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"SourceCode")
					s sourceCCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"SourceCCode")
					if ((sourceCode '= code)||(sourceCCode '= ccode))
					{
						s ICompositeSimpleID = objICompositeSimple.%Id()
						
						s objICompSimpExpand = ##Class(EMRinstance.ICompSimpExpand).%New()
						s objICompSimpExpand.EpisodeID = objEcrecord.RealEpisodeID
						s objICompSimpExpand.ChartItemID = objEcrecord.RealChartItemID
						s objICompSimpExpand.TemplateID = objInstance.RealTemplateID
						s objICompSimpExpand.InstanceDataID = AInstanceID
						s objICompSimpExpand.ICompositeSimpleID = ICompositeSimpleID
						s objICompSimpExpand.KBNodeID = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"KBNodeID")
						s objICompSimpExpand.SectionCode = scode
						s objICompSimpExpand.SourceCompositeCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"SourceCode")
						s objICompSimpExpand.SourceSimpleItemCode = ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,scode,ccode,code,"SourceCCode")
						
						s scExpand = objICompSimpExpand.%Save()
						if ($$$ISERR(scExpand))
						{
							s result = -1
							q
						}
						else
						{
							k objICompSimpExpand
						}
					}
				}
			}
		}
	}
	k objEcrecord,objInstance,objICompositeSimple
	q result
}

/// Desc:       删除多余数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod DeleteCompositeSimpleData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^CacheTempEMRScatterData(AKey,"tmpDeleteSimple",AInstanceID,scode,ccode,code)
				continue:(rowId = "")
				s ICompSimpExpandID = $O(^DHCEMRI.ICompSimpExpandI("IdxICompositeSimpleID",rowId,""))
				if (ICompSimpExpandID '= "")
				{
					s ExpandSc = ##Class(EMRinstance.ICompSimpExpand).%DeleteId(ICompSimpExpandID)
					if ($$$ISERR(ExpandSc))
					{
						s result = -1
						q
					}
				}
				
				s sc = ##Class(EMRinstance.ICompositeSimple).%DeleteId(rowId)
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
