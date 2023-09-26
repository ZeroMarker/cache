Class EMRservice.BL.BLIToothItems Extends (%RegisteredObject, %XML.Adaptor)
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
		s ToothImageCode = $o(^DHCEMRI.IToothItemsI("IdxForDelete"," "_AInstanceID,ToothImageCode))
		q:(ToothImageCode = "")
		s num = ""
		for
		{
			s num = $o(^DHCEMRI.IToothItemsI("IdxForDelete"," "_AInstanceID,ToothImageCode,num))
			q:(num = "")
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRI.IToothItemsI("IdxForDelete"," "_AInstanceID,ToothImageCode,num,rowId))
				q:(rowId = "")
				s sc = ##Class(EMRinstance.IToothItems).%DeleteId(rowId)
				s:($$$ISERR(sc)) result = -1
				q:(result = -1)
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
		s sctionCode = $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode))
		q:(sctionCode = "")
		s compsiteCode = ""
		for
		{
			s compsiteCode = $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode))
			q:(compsiteCode = "")
			s CrossToothImageCode = ""
			for
			{
				s CrossToothImageCode = $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode))
				q:(CrossToothImageCode = "")
				s num = ""
				for
				{
					s num =  $o(^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num))
					q:(num = "")
					s obj = ##Class(EMRinstance.IToothItems).%New()
					s obj.ChartItemID = objEcrecord.RealChartItemID
					s obj.EpisodeID = objEcrecord.RealEpisodeID
					s obj.InstanceDataID = AInstanceID
					s obj.PatientID = objEcrecord.PatientID
					s obj.TemplateID = objInstance.RealTemplateID
					s obj.TemplateVersion = objInstance.TemplateVersion
					s obj.SectionCode = sctionCode
					s obj.CompositeCode = compsiteCode
					s obj.ToothImageCode = CrossToothImageCode
					s obj.Num = num
					s obj.DisplayName = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"DisplayName")
					s obj.QuadrantType = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"QuadrantType")
					s obj.InCode = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"InCode")
					s obj.AreaType = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"AreaType")
					s obj.Code = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"Code")
					s obj.PDisplayName = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"PDisplayName")
					s obj.CodeSystem = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"CodeSystem")
					s obj.CodeSystemName = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"CodeSystemName")
					s obj.Position = ^CacheTempEMRScatterData(AKey,"tmpNewToothItems",AInstanceID,sctionCode,compsiteCode,CrossToothImageCode,num,"Position")
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
	k objEcrecord,objInstance,obj
	q result
}

/// w ##class(EMRservice.BL.BLIToothItems).getToothScatterData("7","AUR.1","C","")
ClassMethod getToothScatterData(AEpisodeID As %String, AToothInCode As %String, AValueType As %String, AInstanceID As %String) As %GlobalCharacterStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "")||(AToothInCode = "") result
	
	s:(AValueType = "") AValueType = "V"
	
	if (AToothInCode = "ALL")
	{
		s count = 0
		s ToothInCode = ""
		for
		{
			s ToothInCode = $O(^DHCEMRI.IToothItemsI("IdxEpisodeIDInCode"," "_AEpisodeID,ToothInCode))
			q:(ToothInCode = "")
			s TInCode = $e(ToothInCode,2,$l(ToothInCode))
			s ToothData = ..getToothItemData(AEpisodeID,TInCode,AValueType,AInstanceID)
			continue:(ToothData.Size = 0)
			if (count > 0)
			{
				d result.Write("###")
				d result.CopyFrom(ToothData)
			}
			else
			{
				d result.CopyFrom(ToothData)
			}
			s count = count + 1
		}
	}
	else
	{
		s ToothData = ..getToothItemData(AEpisodeID,AToothInCode,AValueType,AInstanceID)
		d result.CopyFrom(ToothData)
	}
	q result
}

ClassMethod getToothItemData(AEpisodeID As %String, AToothInCode As %String, AValueType As %String, AInstanceID As %String) As %GlobalCharacterStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "")||(AToothInCode = "") result
	
	s count = 0
	s ToothItemRowID = ""
	for
	{
		s ToothItemRowID = $O(^DHCEMRI.IToothItemsI("IdxEpisodeIDInCode"," "_AEpisodeID," "_AToothInCode,ToothItemRowID))
		q:(ToothItemRowID = "")
		
		s ToothItemObj = ##class(EMRinstance.IToothItems).%OpenId(ToothItemRowID)
		continue:(AInstanceID '= "")&&(ToothItemObj.InstanceDataID '= AInstanceID)
		
		if (count > 0)
		{
			d result.Write("&&&")
		}
		if (AValueType = "V")
		{
			d result.Write(ToothItemObj.DisplayName)
		}
		else
		{
			s ToothAreaData = ..getToothAreaData(ToothItemObj.Code,AEpisodeID,ToothItemObj.InstanceDataID,ToothItemObj.ToothImageCode,ToothItemObj.InCode)
			if (AValueType = "C")
			{
				d result.Write(ToothAreaData)
			}
			elseif (AValueType = "CV")
			{
				d result.Write(ToothAreaData_"^"_ToothItemObj.DisplayName)
			}
			elseif (AValueType = "QC")
			{
				d result.Write(ToothItemObj.AreaType_"-"_ToothAreaData)
			}
			elseif (AValueType = "QCV")
			{
				d result.Write(ToothItemObj.AreaType_"-"_ToothAreaData_"^"_ToothItemObj.DisplayName)
			}
		}
		s count = count + 1
	}
	q result
}

ClassMethod getToothAreaData(AToothCode As %String, AEpisodeID As %String, AInstanceDataID As %String, AToothImageCode As %String, AToothInCode As %String) As %String
{
	s ret = AToothCode
	q:(AEpisodeID = "")||(AInstanceDataID = "")||(AToothImageCode = "")||(AToothInCode = "") ret
	
	s anum = ""
	for
	{
		s anum = $O(^DHCEMRI.IToothAreaI("IdxUniqueAnum"," "_AEpisodeID," "_AInstanceDataID," "_AToothImageCode," "_AToothInCode,anum))
		q:(anum = "")
		
		s ToothAreaRowID = ""
		for
		{
			s ToothAreaRowID = $O(^DHCEMRI.IToothAreaI("IdxUniqueAnum"," "_AEpisodeID," "_AInstanceDataID," "_AToothImageCode," "_AToothInCode,anum,ToothAreaRowID))
			q:(ToothAreaRowID = "")
			
			s ToothAreaObj = ##class(EMRinstance.IToothArea).%OpenId(ToothAreaRowID)
			s ret = ret_ToothAreaObj.Code
		}
	}
	q ret
}

}
