/// Desc:       打散数据-保存ScetionData
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
Class EMRservice.BL.BLIScetionDesc Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存章节打散数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod Save(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "SaveHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s reFilter = ..FilterSectionData(AInstanceID,AKey)
	q:(reFilter = -1) result
	s reUpdate = ..UpdateSectionData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertSectionData(AInstanceID,AKey)
	q:(reInsert = -1) result
	s reDelete = ..DeleteSectionData(AInstanceID,AKey)
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
ClassMethod FilterSectionData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	
	k ^CacheTempEMRScatterData(AKey,"tmpDeleteSection",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpUpdateSection",AInstanceID)
	k ^CacheTempEMRScatterData(AKey,"tmpInsertSection",AInstanceID)
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.RealTemplateID
	k objInstance
	s result = 1
	s code = ""
	for
	{
		s code = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_AInstanceID,code))
		q:(code = "")
		s rowId = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_AInstanceID,code,""))
		s tmpcode = $tr(code," ","")
		if ($d(^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,tmpcode))>0)
		{
			s objIScetion = ##Class(EMRinstance.ISectionDesc).%OpenId(rowId)
			continue:(objIScetion = "")
			if (objIScetion.TemplateID '= TemplateID)
			{
				s ^CacheTempEMRScatterData(AKey,"tmpDeleteSection",AInstanceID,tmpcode) = rowId	
			}
			else
			{
				s ^CacheTempEMRScatterData(AKey,"tmpUpdateSection",AInstanceID,tmpcode) = rowId
			}
			k objIScetion
		}
		else
		{
			s ^CacheTempEMRScatterData(AKey,"tmpDeleteSection",AInstanceID,tmpcode) = rowId	
		}
	}
	
	s code = ""
	for
	{
		s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,code))
		q:(code = "")
		s:($d(^CacheTempEMRScatterData(AKey,"tmpUpdateSection",AInstanceID,code))<=0) ^CacheTempEMRScatterData(AKey,"tmpInsertSection",AInstanceID,code)=""
	}
	
	q result
ErrorHandler
   q result
}

/// Desc:       更新数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod UpdateSectionData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s code = ""
	for
	{
		s code = $o(^CacheTempEMRScatterData(AKey,"tmpUpdateSection",AInstanceID,code))
		q:(code = "")
		s rowId = ^CacheTempEMRScatterData(AKey,"tmpUpdateSection",AInstanceID,code)
		s objIScetion = ##Class(EMRinstance.ISectionDesc).%OpenId(rowId)
		continue:(objIScetion = "")
		d objIScetion.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,code))
		d objIScetion.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,code,"StyleText"))
		s sc = objIScetion.%Save()
		if ($$$ISERR(sc))
		{
			s result = -1
			q
		}
	}
	q result
}

/// Desc:       插入数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod InsertSectionData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result

	s ecrecordId = $p(AInstanceID,"||",1)
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = 1
	s code = ""
	for
	{
		s code = $o(^CacheTempEMRScatterData(AKey,"tmpInsertSection",AInstanceID,code))
		q:(code = "")
		s objIScetion = ##Class(EMRinstance.ISectionDesc).%New()
		s objIScetion.ChartItemID = objEcrecord.RealChartItemID
		s objIScetion.EpisodeID = objEcrecord.RealEpisodeID
		s objIScetion.InstanceDataID = AInstanceID
		s objIScetion.PatientID = objEcrecord.PatientID
		s objIScetion.SectionCode = code
		s objIScetion.TemplateID = objInstance.RealTemplateID
		s objIScetion.TemplateVersion = objInstance.TemplateVersion
		d objIScetion.Text.Write(^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,code))
		d objIScetion.StyleText.Write(^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,code,"StyleText"))
		s sc = objIScetion.%Save()
		if ($$$ISERR(sc))
		{
			s result = -1
			q
		}
	}
	k objEcrecord,objInstance,objIScetion
	q result
}

/// Desc:       删除多余数据
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod DeleteSectionData(AInstanceID As %String, AKey As %String) As %String
{
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s result = 1
	s code = ""
	for
	{
		s code = $o(^CacheTempEMRScatterData(AKey,"tmpDeleteSection",AInstanceID,code))
		q:(code = "")
		s rowId = ^CacheTempEMRScatterData(AKey,"tmpDeleteSection",AInstanceID,code)
		continue:(rowId = "")
		s sc = ##Class(EMRinstance.ISectionDesc).%DeleteId(rowId)
		if ($$$ISERR(sc))
		{
			s result = -1
			q
		}
	}
	q result
}

}
