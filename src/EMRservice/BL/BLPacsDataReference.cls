Class EMRservice.BL.BLPacsDataReference Extends %RegisteredObject
{

///  Creator:    Donglulu
///  CreateDate: 2022-09-06
///  Desc:       添加检查数据引用表数据
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLPacsDataReference).AddPacsdataReferenceData("230","","","")
ClassMethod AddPacsdataReferenceData(AEpisodeID As %String, AUserID As %String, AOEordItemID As %String, AOEordItemDesc As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AUserID = "")||(AOEordItemID = "")) result
    //插入新数据
    s LisdataReferenceData = ##Class(EMRinstance.PacsDataReference).%New()
	s LisdataReferenceData.EpisodeID = AEpisodeID
	s LisdataReferenceData.OEordItemID = AOEordItemID 
	s LisdataReferenceData.OEordItemDesc = AOEordItemDesc 
    s LisdataReferenceData.ReferenceDate = $p($h,",",1)
    s LisdataReferenceData.ReferenceTime = $p($h,",",2)
    s LisdataReferenceData.UserID = AUserID
    s sc = LisdataReferenceData.%Save()
    s:($$$ISOK(sc)) result = "1"
    d LisdataReferenceData.%Close()	
	k LisdataReferenceData
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2022-09-06
///  Desc:       获取该次就诊检查项有没有引用
///  Input:      AEpisodeID:就诊号   AOEordItemRowID：医嘱项ID
///  return:     1：引用过 0：未引用过   
///  Debug:      w ##Class(EMRservice.BL.BLPacsDataReference).GetIsReferenceOEord("7","3||8")
ClassMethod GetIsReferenceOEord(AEpisodeID As %String, AOEordItemRowID As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AOEordItemRowID = "")) result
	s LisdataReferenceDataID = $o(^DHCEMRI.PacsDataReferenceI("IdxEpisodeIDOEordItemID"," "_AEpisodeID," "_AOEordItemRowID,""))		
	if (LisdataReferenceDataID '= "")
	{
    	s result = "1"
	}
	
	q result
}

}
