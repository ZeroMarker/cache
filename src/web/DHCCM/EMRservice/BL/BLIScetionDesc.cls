/// Desc:       打散数据-保存ScetionData
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
Class web.DHCCM.EMRservice.BL.BLIScetionDesc Extends (%RegisteredObject, %XML.Adaptor)
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
	Tstart
	s reUpdate = ..UpdateSectionData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertSectionData(AInstanceID,AKey)
	if (reInsert = -1)
	{
		Trollback
		q result	
	}
	s reDelete = ..DeleteSectionData(AInstanceID,AKey)
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
ClassMethod FilterSectionData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	
	k ^tmpDeleteSection(AKey,AInstanceID)
	k ^tmpUpdateSection(AKey,AInstanceID)
	k ^tmpInsertSection(AKey,AInstanceID)
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.TemplateID
	k objInstance
	s result = 1
	s code = ""
	for
	{
		s code = $o(^DHCPHI.ISectionDescI("IdxForUpdate"," "_AInstanceID,code))
		q:(code = "")
		s rowId = $o(^DHCPHI.ISectionDescI("IdxForUpdate"," "_AInstanceID,code,""))
		s tmpcode = $tr(code," ","")
		if ($d(^tmpNewSection(AKey,AInstanceID,tmpcode))>0)
		{
			s objIScetion = ##Class(User.DHCPHISectionDesc).%OpenId(rowId)
			continue:(objIScetion = "")
			if (objIScetion.TemplateID '= TemplateID)
			{
				s ^tmpDeleteSection(AKey,AInstanceID,tmpcode) = rowId	
			}
			else
			{
				s ^tmpUpdateSection(AKey,AInstanceID,tmpcode) = rowId
			}
			k objIScetion
		}
		else
		{
			s ^tmpDeleteSection(AKey,AInstanceID,tmpcode) = rowId	
		}
	}
	
	s code = ""
	for
	{
		s code = $o(^tmpNewSection(AKey,AInstanceID,code))
		q:(code = "")
		s:($d(^tmpUpdateSection(AKey,AInstanceID,code))<=0) ^tmpInsertSection(AKey,AInstanceID,code)=""
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
		s code = $o(^tmpUpdateSection(AKey,AInstanceID,code))
		q:(code = "")
		s rowId = ^tmpUpdateSection(AKey,AInstanceID,code)
		s objIScetion = ##Class(User.DHCPHISectionDesc).%OpenId(rowId)
		continue:(objIScetion = "")
		d objIScetion.Text.Write(^tmpNewSection(AKey,AInstanceID,code))
		d objIScetion.StyleText.Write(^tmpNewSection(AKey,AInstanceID,code,"StyleText"))
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
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = 1
	s code = ""
	for
	{
		s code = $o(^tmpInsertSection(AKey,AInstanceID,code))
		q:(code = "")
		s objIScetion = ##Class(User.DHCPHISectionDesc).%New()
		s objIScetion.ChartItemID = objEcrecord.ChartItemID
		s objIScetion.EpisodeID = objEcrecord.EpisodeID
		s objIScetion.InstanceDataID = AInstanceID
		s objIScetion.PatientID = objEcrecord.PatientID
		s objIScetion.SectionCode = code
		s objIScetion.TemplateID = objInstance.TemplateID
		s objIScetion.TemplateVersion = objInstance.TemplateVersion
		d objIScetion.Text.Write(^tmpNewSection(AKey,AInstanceID,code))
		d objIScetion.Text.Write(^tmpNewSection(AKey,AInstanceID,code,"StyleText"))
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
		s code = $o(^tmpDeleteSection(AKey,AInstanceID,code))
		q:(code = "")
		s rowId = ^tmpDeleteSection(AKey,AInstanceID,code)
		continue:(rowId = "")
		s sc = ##Class(User.DHCPHISectionDesc).%DeleteId(rowId)
		if ($$$ISERR(sc))
		{
			s result = -1
			q
		}
	}
	q result
}

}
