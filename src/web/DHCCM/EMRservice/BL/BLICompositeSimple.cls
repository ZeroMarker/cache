/// Desc:       打散数据-保存SimpleData
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
Class web.DHCCM.EMRservice.BL.BLICompositeSimple Extends (%RegisteredObject, %XML.Adaptor)
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
	Tstart
	s reUpdate = ..UpdateCompositeSimpleData(AInstanceID,AKey)
	q:(reUpdate = -1) result
	s reInsert = ..InsertCompositeSimpleData(AInstanceID,AKey)
	if (reInsert = -1)
	{
		Trollback
		q result	
	}
	s reDelete = ..DeleteCompositeSimpleData(AInstanceID,AKey)
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
ClassMethod FilterCompositeSimpleData(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "ErrorHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	
	k ^tmpDeleteSimple(AKey,AInstanceID)
	k ^tmpUpdateSimple(AKey,AInstanceID)
	k ^tmpInsertSimple(AKey,AInstanceID)
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s TemplateID = objInstance.TemplateID
	k objInstance
	s scode = ""
	for
	{
		s scode = $o(^DHCPHI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ccode = ""
		for
		{
			s ccode = $o(^DHCPHI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode))
			q:(ccode = "")
			s tmpccode = $tr(ccode," ","") 
			s code = ""
			for
			{
				s code = $o(^DHCPHI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = $o(^DHCPHI.ICompositeSimpleI("IdxForUpdate"," "_AInstanceID,scode,ccode,code,""))
				s tmpcode = $tr(code," ","")
				if ($d(^tmpNewSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcode))>0)
				{
					s objICompositeSimple = ##Class(User.DHCPHICompositeSimple).%OpenId(rowId)
					continue:(objICompositeSimple = "")
					if (objICompositeSimple.TemplateID '= TemplateID)
					{
						s ^tmpDeleteSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
					}
					else
					{
						s ^tmpUpdateSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcode) = rowId
					}
					k objICompositeSimple
				}
				else
				{
					s ^tmpDeleteSimple(AKey,AInstanceID,tmpscode,tmpccode,tmpcode) = rowId	
				}
			}
		}
	}
	s scode = ""
	for
	{
		s scode = $o(^tmpNewSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpNewSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpNewSimple(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s:($d(^tmpUpdateSimple(AKey,AInstanceID,scode,ccode,code))<=0) ^tmpInsertSimple(AKey,AInstanceID,scode,ccode,code)=""
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
		s scode = $o(^tmpUpdateSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpUpdateSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpUpdateSimple(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^tmpUpdateSimple(AKey,AInstanceID,scode,ccode,code)
				s objICompositeSimple = ##Class(User.DHCPHICompositeSimple).%OpenId(rowId)
				continue:(objICompositeSimple = "")
				s objICompositeSimple.SectionCode = scode
				s objICompositeSimple.CompositeCode = ccode
				s objICompositeSimple.BindKBCode = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"BindKBCode")				
				s objICompositeSimple.KBNodeID = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"KBNodeID")
				s objICompositeSimple.DataRef = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"DataRef")
				s objICompositeSimple.DataValue = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"DataValue")
				s objICompositeSimple.Separator = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"Separator")
				s objICompositeSimple.ValueCode = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"ValueCode")
				s objICompositeSimple.Type = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"Type")
		
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
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = 1
	s scode = ""
	for
	{
		s scode = $o(^tmpInsertSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpInsertSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpInsertSimple(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s objICompositeSimple = ##Class(User.DHCPHICompositeSimple).%New()
				s objICompositeSimple.ChartItemID = objEcrecord.ChartItemID
				s objICompositeSimple.EpisodeID = objEcrecord.EpisodeID
				s objICompositeSimple.InstanceDataID = AInstanceID
				s objICompositeSimple.PatientID = objEcrecord.PatientID
				s objICompositeSimple.SimpleItemCode = code
				s objICompositeSimple.TemplateID = objInstance.TemplateID
				s objICompositeSimple.TemplateVersion = objInstance.TemplateVersion
				s objICompositeSimple.SectionCode = scode
				s objICompositeSimple.CompositeCode = ccode
				s objICompositeSimple.BindKBCode = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"BindKBCode")
				s objICompositeSimple.DataRef = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"DataRef")
				s objICompositeSimple.DataValue = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"DataValue") 
				s objICompositeSimple.KBNodeID = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"KBNodeID")
				s objICompositeSimple.Separator = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"Separator") 
				s objICompositeSimple.ValueCode = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"ValueCode")
				s objICompositeSimple.Type = ^tmpNewSimple(AKey,AInstanceID,scode,ccode,code,"Type")
				s sc = objICompositeSimple.%Save()
				if ($$$ISERR(sc))
				{
					s result = -1
					q
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
		s scode = $o(^tmpDeleteSimple(AKey,AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^tmpDeleteSimple(AKey,AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^tmpDeleteSimple(AKey,AInstanceID,scode,ccode,code))
				q:(code = "")
				s rowId = ^tmpDeleteSimple(AKey,AInstanceID,scode,ccode,code)
				continue:(rowId = "")
				s sc = ##Class(User.DHCPHICompositeSimple).%DeleteId(rowId)
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
