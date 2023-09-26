/// Desc:       打散数据-保存ConceptData
/// Creator:    Candyxu
/// CreateDate: 2017-12-04
Class EMRservice.BL.BLCompositeMacro Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存宏打散数据
/// Creator:    Candyxu
/// CreateDate: 2017-12-4
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod Save(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "SaveHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s reFilter = ..FilterData(AInstanceID,AKey)
	q:(reFilter = -1) result
	s reUpdate = ..UpdateData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertData(AInstanceID,AKey)
	q:(reInsert = -1) result
	s reDelete= ..DeleteData(AInstanceID,AKey)
	q:(reDelete = -1) result	
    s result = 1
	q result 
SaveHandler
    q -1
}

/// Desc:       分析插入、修改和删除数据
/// Creator:    Candyxu
/// CreateDate: 2017-12-4
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod FilterData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result

	
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeMacro",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeMacro",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertCompositeMacro",AInstanceID)
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.RealTemplateID
	k objInstance
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^DHCEMRI.ICompositeMacroI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ccode = ""
		for
		{
			s ccode = $o(^DHCEMRI.ICompositeMacroI("IdxForUpdate"," "_AInstanceID,scode,ccode))
			q:(ccode = "")
			s tmpccode = $tr(ccode," ","")
			s code = ""
			for
			{
				s code = $o(^DHCEMRI.ICompositeMacroI("IdxForUpdate"," "_AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = $o(^DHCEMRI.ICompositeMacroI("IdxForUpdate"," "_AInstanceID,scode,ccode,code,""))
				s tmpcode = $tr(code," ","")
				if ($d(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,tmpscode,tmpccode,tmpcode))>0)
				{
					s objICompositeMacro = ##Class(EMRinstance.ICompositeMacro).%OpenId(rowId)
					continue:(objICompositeMacro = "")
					if (objICompositeMacro.TemplateID '= TemplateID)
					{
						s ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeMacro",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
					}
					else
					{
						s ^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeMacro",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId
					}
					k objICompositeMacro
				}
				else
				{
					s ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeMacro",AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
				}				
			}

		}
	}
	
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code))
				q:(code = "")
				s:($d(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeMacro",AInstanceID,scode,ccode,code))<=0) ^CacheTempEMRScatterData(AKey,"tmpInsertCompositeMacro",AInstanceID,scode,ccode,code)=""
			}			
		}
	}
	q result
ErrorHandler
   q -1
}

/// Desc:       更新数据
/// Creator:    Candyxu
/// CreateDate: 2017-12-4
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod UpdateData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeMacro",AInstanceID,scode)) 
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeMacro",AInstanceID,scode,ccode)) 
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeMacro",AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^CacheTempEMRScatterData(AKey,"tmpUpdateCompositeMacro",AInstanceID,scode,ccode,code)
				s objICompositeMacro = ##Class(EMRinstance.ICompositeMacro).%OpenId(rowId)
				continue:(objICompositeMacro = "")
				s objICompositeMacro.DisplayName = ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code,"DisplayName")
				d objICompositeMacro.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code))
				d objICompositeMacro.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code,"StyleText"))
				s sc = objICompositeMacro.%Save()
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
/// CreateDate: 2017-12-4
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod InsertData(AInstanceID As %String, AKey As %String) As %String
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
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertCompositeMacro",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertCompositeMacro",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpInsertCompositeMacro",AInstanceID,scode,ccode,code))
				q:(code = "")
				s obj = ##Class(EMRinstance.ICompositeMacro).%New()
				s obj.ChartItemID = objEcrecord.RealChartItemID
				s obj.EpisodeID = objEcrecord.RealEpisodeID
				s obj.InstanceDataID = AInstanceID
				s obj.PatientID = objEcrecord.PatientID
				s obj.SectionCode = scode
				s obj.CompositeCode = ccode
				s obj.MacroCode = code
				s obj.TemplateID = objInstance.RealTemplateID
				s obj.TemplateVersion = objInstance.TemplateVersion
				s obj.DisplayName = ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code,"DisplayName")
				d obj.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code))
				d obj.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code,"StyleText"))
				s sc = obj.%Save()
				if ($$$ISERR(sc))
				{
					s result = -1
					q
				}
			}			
		}
	}
	k objEcrecord,objInstance,obj
	q result
}

/// Desc:       删除多余数据
/// Creator:    Candyxu
/// CreateDate: 2017-12-4
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod DeleteData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeMacro",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeMacro",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeMacro",AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^CacheTempEMRScatterData(AKey,"tmpDeleteCompositeMacro",AInstanceID,scode,ccode,code)
				continue:(rowId = "")
				s sc = ##Class(EMRinstance.ICompositeMacro).%DeleteId(rowId)
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
