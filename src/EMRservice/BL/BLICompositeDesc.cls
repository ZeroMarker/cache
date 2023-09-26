/// Desc:       打散数据-保存CompositeData
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
Class EMRservice.BL.BLICompositeDesc Extends (%RegisteredObject, %XML.Adaptor)
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
	s reFilter = ..FilterCompositeData(AInstanceID,AKey)
	q:(reFilter = -1) result
	s reUpdate = ..UpdateCompositeData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeData(AInstanceID,AKey)
	q:(reInsert = -1) result
	s reDelete= ..DeleteCompositeData(AInstanceID,AKey)
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
ClassMethod FilterCompositeData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result

	
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteComposite",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateComposite",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertComposite",AInstanceID)
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.RealTemplateID
	k objInstance
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^DHCEMRI.ICompositeDescI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s code = ""
		for
		{
			s code = $o(^DHCEMRI.ICompositeDescI("IdxForUpdate"," "_AInstanceID,scode,code))
			q:(code = "")
			s rowId = $o(^DHCEMRI.ICompositeDescI("IdxForUpdate"," "_AInstanceID,scode,code,""))
			s tmpcode = $tr(code," ","")
			if ($d(^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,tmpscode,tmpcode))>0)
			{
				s objIComposite = ##Class(EMRinstance.ICompositeDesc).%OpenId(rowId)
				continue:(objIComposite = "")
				if (objIComposite.TemplateID '= TemplateID)
				{
					s ^CacheTempEMRScatterData(AKey,"tmpDeleteComposite",AInstanceID,tmpscode,tmpcode) = rowId	
				}
				else
				{
					s ^CacheTempEMRScatterData(AKey,"tmpUpdateComposite",AInstanceID,tmpscode,tmpcode) = rowId
				}
				k objIComposite
			}
			else
			{
				s ^CacheTempEMRScatterData(AKey,"tmpDeleteComposite",AInstanceID,tmpscode,tmpcode) = rowId	
			}
		}
	}
	
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,scode))
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,scode,code))
			q:(code = "")
			s:($d(^CacheTempEMRScatterData(AKey,"tmpUpdateComposite",AInstanceID,scode,code))<=0) ^CacheTempEMRScatterData(AKey,"tmpInsertComposite",AInstanceID,scode,code)=""
		}
	}
	q result
ErrorHandler
   q -1
}

/// Desc:       更新数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod UpdateCompositeData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateComposite",AInstanceID,scode)) 
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateComposite",AInstanceID,scode,code))
			q:(code = "")
			s rowId = ^CacheTempEMRScatterData(AKey,"tmpUpdateComposite",AInstanceID,scode,code)
			s objIComposite = ##Class(EMRinstance.ICompositeDesc).%OpenId(rowId)
			continue:(objIComposite = "")
			d objIComposite.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,scode,code))
			d objIComposite.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,scode,code,"StyleText"))
			s sc = objIComposite.%Save()
			if ($$$ISERR(sc))
			{
				s result = -1
				q
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
ClassMethod InsertCompositeData(AInstanceID As %String, AKey As %String) As %String
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
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpInsertComposite",AInstanceID,scode))
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^CacheTempEMRScatterData(AKey,"tmpInsertComposite",AInstanceID,scode,code))
			q:(code = "")
			s objIComposite = ##Class(EMRinstance.ICompositeDesc).%New()
			s objIComposite.ChartItemID = objEcrecord.RealChartItemID
			s objIComposite.EpisodeID = objEcrecord.RealEpisodeID
			s objIComposite.InstanceDataID = AInstanceID
			s objIComposite.PatientID = objEcrecord.PatientID
			s objIComposite.SectionCode = scode
			s objIComposite.CompositeCode = code
			s objIComposite.TemplateID = objInstance.RealTemplateID
			s objIComposite.TemplateVersion = objInstance.TemplateVersion
			d objIComposite.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,scode,code))
			d objIComposite.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewComposite",AInstanceID,scode,code,"StyleText"))
			s sc = objIComposite.%Save()
			if ($$$ISERR(sc))
			{
				s result = -1
				q
			}
		}
	}
	k objEcrecord,objInstance,objIComposite
	q result
}

/// Desc:       删除多余数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod DeleteCompositeData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteComposite",AInstanceID,scode))
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteComposite",AInstanceID,scode,code))
			q:(code = "")
			s rowId = ^CacheTempEMRScatterData(AKey,"tmpDeleteComposite",AInstanceID,scode,code)
			continue:(rowId = "")
			s sc = ##Class(EMRinstance.ICompositeDesc).%DeleteId(rowId)
			if ($$$ISERR(sc))
			{
				s result = -1
				q
			}
		}
	}
	q result
}

}
