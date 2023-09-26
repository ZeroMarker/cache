Class EMRservice.BL.BLIToothArea Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存牙位图牙面打散数据
/// Creator:    niucaicai
/// CreateDate: 2020-07-13
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
/// Creator:    niucaicai
/// CreateDate: 2020-07-10
/// Input:      AInstanceID 实例数据ID
ClassMethod DeleteData(AInstanceID)
{
	s result = 1
	q:(AInstanceID = "") result
	s ToothImageCode = ""
	for
	{
		s ToothImageCode = $o(^DHCEMRI.IToothAreaI("IdxForDelete"," "_AInstanceID,ToothImageCode))
		q:(ToothImageCode = "")
		s ToothInCode = ""
		for
		{
			s ToothInCode = $o(^DHCEMRI.IToothAreaI("IdxForDelete"," "_AInstanceID,ToothImageCode,ToothInCode))
			q:(ToothInCode = "")
			s InCode = ""
			for
			{
				s InCode = $o(^DHCEMRI.IToothAreaI("IdxForDelete"," "_AInstanceID,ToothImageCode,ToothInCode,InCode))
				q:(InCode = "")
				s rowId = ""
				for
				{
					s rowId = $o(^DHCEMRI.IToothAreaI("IdxForDelete"," "_AInstanceID,ToothImageCode,ToothInCode,InCode,rowId))
					q:(rowId = "")
					s sc = ##Class(EMRinstance.IToothArea).%DeleteId(rowId)
					s:($$$ISERR(sc)) result = -1
					q:(result = -1)
				}
			}
		}
	}
	q result
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
	s sctionCode = ""
	for
	{
		s sctionCode = $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode))
		q:(sctionCode = "")
		s compsiteCode = ""
		for
		{
			s compsiteCode = $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode))
			q:(compsiteCode = "")
			s CrossToothImageCode = ""
			for
			{
				s CrossToothImageCode = $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode))
				q:(CrossToothImageCode = "")
				s tnum = ""
				for
				{
					s tnum =  $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum))
					q:(tnum = "")
					s anum = ""
					for
					{
						s anum =  $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum))
						q:(anum = "")
						s obj = ##Class(EMRinstance.IToothArea).%New()
						s obj.ChartItemID = objEcrecord.RealChartItemID
						s obj.EpisodeID = objEcrecord.RealEpisodeID
						s obj.InstanceDataID = AInstanceID
						s obj.PatientID = objEcrecord.PatientID
						s obj.TemplateID = objInstance.RealTemplateID
						s obj.TemplateVersion = objInstance.TemplateVersion
						s obj.SectionCode = sctionCode
						s obj.CompositeCode = compsiteCode
						s obj.ToothImageCode = CrossToothImageCode
						s obj.Tnum = tnum
						s obj.Anum = anum
						s obj.ToothInCode = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,"InCode")
						s obj.InCode = ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum,"InCode")
						s obj.Code = ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum,"Code")
						s obj.DisplayName = ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum,"DisplayName")
						s obj.ScriptMode = ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum,"ScriptMode")
						s obj.CodeSystem = ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum,"CodeSystem")
						s obj.CodeSystemName = ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum,"CodeSystemName")
						s obj.Area = ^CacheTempEMRScatterData(AKey,"tmpNewToothItemAreas",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,tnum,anum,"Area")
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
