/// Desc:       打散数据-保存CompositeData
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
Class web.DHCCM.EMRservice.BL.BLICompositeDesc Extends (%RegisteredObject, %XML.Adaptor)
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
	Tstart
	s reUpdate = ..UpdateCompositeData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeData(AInstanceID,AKey)
	if (reInsert = -1)
	{
		Trollback
		q result	
	}
	s reDelete= ..DeleteCompositeData(AInstanceID,AKey)
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
ClassMethod FilterCompositeData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result

	
	k ^tmpDeleteComposite(AKey,AInstanceID)
	k ^tmpUpdateComposite(AKey,AInstanceID)
	k ^tmpInsertComposite(AKey,AInstanceID)
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.TemplateID
	k objInstance
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^DHCPHI.ICompositeDescI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s code = ""
		for
		{
			s code = $o(^DHCPHI.ICompositeDescI("IdxForUpdate"," "_AInstanceID,scode,code))
			q:(code = "")
			s rowId = $o(^DHCPHI.ICompositeDescI("IdxForUpdate"," "_AInstanceID,scode,code,""))
			s tmpcode = $tr(code," ","")
			if ($d(^tmpNewComposite(AKey,AInstanceID,tmpscode,tmpcode))>0)
			{
				s objIComposite = ##Class(User.DHCPHICompositeDesc).%OpenId(rowId)
				continue:(objIComposite = "")
				if (objIComposite.TemplateID '= TemplateID)
				{
					s ^tmpDeleteComposite(AKey,AInstanceID,tmpscode,tmpcode) = rowId	
				}
				else
				{
					s ^tmpUpdateComposite(AKey,AInstanceID,tmpscode,tmpcode) = rowId
				}
				k objIComposite
			}
			else
			{
				s ^tmpDeleteComposite(AKey,AInstanceID,tmpscode,tmpcode) = rowId	
			}
		}
	}
	
	s scode = ""
	for
	{
		s scode = $o(^tmpNewComposite(AKey,AInstanceID,scode))
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^tmpNewComposite(AKey,AInstanceID,scode,code))
			q:(code = "")
			s:($d(^tmpUpdateComposite(AKey,AInstanceID,scode,code))<=0) ^tmpInsertComposite(AKey,AInstanceID,scode,code)=""
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
		s scode = $o(^tmpUpdateComposite(AKey,AInstanceID,scode)) 
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^tmpUpdateComposite(AKey,AInstanceID,scode,code))
			q:(code = "")
			s rowId = ^tmpUpdateComposite(AKey,AInstanceID,scode,code)
			s objIComposite = ##Class(User.DHCPHICompositeDesc).%OpenId(rowId)
			continue:(objIComposite = "")
			d objIComposite.Text.Write(^tmpNewComposite(AKey,AInstanceID,scode,code))
			d objIComposite.StyleText.Write(^tmpNewComposite(AKey,AInstanceID,scode,code,"StyleText"))
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
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^tmpInsertComposite(AKey,AInstanceID,scode))
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^tmpInsertComposite(AKey,AInstanceID,scode,code))
			q:(code = "")
			s objIComposite = ##Class(User.DHCPHICompositeDesc).%New()
			s objIComposite.ChartItemID = objEcrecord.ChartItemID
			s objIComposite.EpisodeID = objEcrecord.EpisodeID
			s objIComposite.InstanceDataID = AInstanceID
			s objIComposite.PatientID = objEcrecord.PatientID
			s objIComposite.SectionCode = scode
			s objIComposite.CompositeCode = code
			s objIComposite.TemplateID = objInstance.TemplateID
			s objIComposite.TemplateVersion = objInstance.TemplateVersion
			d objIComposite.Text.Write(^tmpNewComposite(AKey,AInstanceID,scode,code))
			d objIComposite.StyleText.Write(^tmpNewComposite(AKey,AInstanceID,scode,code,"StyleText"))
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
		s scode = $o(^tmpDeleteComposite(AKey,AInstanceID,scode))
		q:(scode = "")
		s code = ""
		for
		{
			s code = $o(^tmpDeleteComposite(AKey,AInstanceID,scode,code))
			q:(code = "")
			s rowId = ^tmpDeleteComposite(AKey,AInstanceID,scode,code)
			continue:(rowId = "")
			s sc = ##Class(User.DHCPHICompositeDesc).%DeleteId(rowId)
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
