Class EMRservice.BL.BLICompositeToothImage Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存牙位图打散数据
/// Creator:    niucaicai
/// CreateDate: 2020-07-10
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod Save(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "SaveHandler"
	s result = -1
	q:((AInstanceID = "")||(AKey = "")) result
	s reDelete= ..DeleteData(AInstanceID,AKey)
	q:(reDelete = -1) result
	s reInsert = ..InsertData(AInstanceID,AKey)
	q:(reInsert = -1) result
    s result = 1
	q result 
SaveHandler
    q -1
}

/// Desc:       插入数据
/// Creator:    niucaicai
/// CreateDate: 2020-07-10
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
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode,code))
				q:(code = "")
				s obj = ##Class(EMRinstance.ICompositeTooth).%New()
				s obj.ChartItemID = objEcrecord.ChartItemID.%Id()
				s obj.EpisodeID = objEcrecord.RealEpisodeID
				s obj.InstanceDataID = AInstanceID
				s obj.PatientID = objEcrecord.PatientID
				s obj.TemplateID = objInstance.RealTemplateID
				s obj.TemplateVersion = objInstance.TemplateVersion
				s obj.SectionCode = scode
				s obj.CompositeCode = ccode
				s obj.ToothImageCode = code
				s obj.SourceCode = ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode,code,"SourceCode")
				s obj.SourceCCode = ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode,code,"SourceCCode")
				s obj.KBNodeID = ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode,code,"KBNodeID")
				s obj.DisplayName = ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode,code,"DisplayName")
				s obj.Text = ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode,code,"Text")
				s obj.ShowMode = ^CacheTempEMRScatterData(AKey,"tmpNewCrossToothImage",AInstanceID,scode,ccode,code,"ShowMode")
				s sc = obj.%Save()
				if ($$$ISERR(sc))
				{
					s result = -1
					q
				}
				k obj
			}			
		}
	}
	k objEcrecord,objInstance
	q result
}

/// Desc:       删除多余数据
/// Creator:    niucaicai
/// CreateDate: 2020-07-10
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod DeleteData(AInstanceID As %String, AKey As %String) As %String
{
	s result = 1
	q:(AInstanceID = "") result
	s ToothImageCode = ""
	for
	{
		s ToothImageCode = $o(^DHCEMRI.ICompositeToothI("IdxForDelete"," "_AInstanceID,ToothImageCode))
		q:(ToothImageCode = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRI.ICompositeToothI("IdxForDelete"," "_AInstanceID,ToothImageCode,rowId))
			q:(rowId = "")
			s sc = ##Class(EMRinstance.ICompositeTooth).%DeleteId(rowId)
			s:($$$ISERR(sc)) result = -1
			q:(result = -1)
		}
	}
	q result
}

}
