/// Desc:       打散数据-保存MacroItemData
/// Creator:    Candyxu
/// CreateDate: 2017-12-04
Class EMRservice.BL.BLICompositeMacroItems Extends (%RegisteredObject, %XML.Adaptor)
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
	s redelete = ..DeleteData(AInstanceID)
	q:(redelete = -1) result

	s reInsert = ..InsertData(AInstanceID,AKey)
	q:(reInsert = -1) result
    s result = 1
	q result
SaveHandler
    q -1
}

/// Desc:       删除原来打散数据
/// Creator:    Candyxu
/// CreateDate: 2017-12-4
/// Input:      AInstanceID 实例数据ID
ClassMethod DeleteData(AInstanceID)
{
	s result = 1
	q:(AInstanceID = "") result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.IMacroObjectItemsI("IdxInstanceData"," "_AInstanceID,rowId))
		q:(rowId = "")
		s sc = ##Class(EMRinstance.IMacroObjectItems).%DeleteId(rowId)
		s:($$$ISERR(sc)) result = -1
		q:(result = -1)
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
		s scode = $o(^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,scode))
		q:(scode = "")
		s ccode = ""
		for
		{
			s ccode = $o(^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,scode,ccode))
			q:(ccode = "")
			s code = ""
			for
			{
				s code = $o(^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,scode,ccode,code))
				q:(code = "")
				s item = ""
				for
				{
					s item =  $o(^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,scode,ccode,code,item))
					q:(item = "")
					s property = ""
					for
					{
						s property = $o(^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,scode,ccode,code,item,property))
						q:(property = "")
						s obj = ##Class(EMRinstance.IMacroObjectItems).%New()
						s obj.ChartItemID = objEcrecord.RealChartItemID
						s obj.EpisodeID = objEcrecord.RealEpisodeID
						s obj.InstanceDataID = AInstanceID
						s obj.PatientID = objEcrecord.PatientID
						s obj.SectionCode = scode
						s obj.CompositeCode = ccode
						s obj.MacroCode = code
						s obj.TemplateID = objInstance.TemplateID.%Id()
						s obj.TemplateVersion = objInstance.TemplateVersion
						s obj.MacroID =  ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code,"MacroID")
						s obj.Type = ^CacheTempEMRScatterData(AKey,"tmpNewCompositeMacro",AInstanceID,scode,ccode,code,"Type")
						s obj.Name = ^CacheTempEMRScatterData(AKey,"tmpNewMacroItems",AInstanceID,scode,ccode,code,item,"Name") 
						s obj.Property = ^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,scode,ccode,code,item,property,"PropertyName") 
						s obj.Value = ^CacheTempEMRScatterData(AKey,"tmpNewMacroItemsProperty",AInstanceID,scode,ccode,code,item,property,"PropertyValue") 
						s sc = obj.%Save()
						if ($$$ISERR(sc))
						{
							s result = -1
							q
						}
					}					
				}
			}			
		}
	}
	k objEcrecord,objInstance,obj
	q result
}

}
