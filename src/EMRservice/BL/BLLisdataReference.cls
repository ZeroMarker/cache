Class EMRservice.BL.BLLisdataReference Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2018-01-08
///  Desc:       添加检验数据引用表数据
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLLisdataReference).AddLisdataReferenceData("230","","","")
ClassMethod AddLisdataReferenceData(AEpisodeID As %String, AUserID As %String, AOEordItemID As %String, AOEordItemDesc As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AUserID = "")||(AOEordItemID = "")) result
    //插入新数据
    s LisdataReferenceData = ##Class(EMRinstance.LisDataReference).%New()
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
///  CreateDate: 2018-01-08
///  Desc:       获取该次就诊某位医生有哪些检验项没有引用
///  Input:      AEpisodeID:就诊号   AUserID：用户ID
///  return:     result 未引用过的检验项ID   
///  Debug:      w ##Class(EMRservice.BL.BLLisdataReference).GetNotReferenceLisID("230","")
ClassMethod GetNotReferenceLisID(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(AUserID = "")) result
	s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByDate")
	d ds.Execute(AEpisodeID,"0","0")
	While (ds.Next())
	{
		s OEordItemRowID = ds.Data("OEordItemRowID")
		s LisdataReferenceDataID = $o(^DHCEMRI.LisDataReferenceI("IdxEpisodeIDUserIDOEordItemID"," "_AEpisodeID," "_AUserID," "_OEordItemRowID,""))		
    	if (LisdataReferenceDataID = "")
    	{
	    	s:(result '= "") result = result_"^"
	    	s result = result_OEordItemRowID
    	}
	}
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2022-09-06
///  Desc:       获取该次就诊检验项有没有引用
///  Input:      AEpisodeID:就诊号   AOEordItemRowID：医嘱项ID
///  return:     1：引用过 0：未引用过   
///  Debug:      w ##Class(EMRservice.BL.BLLisdataReference).GetIsReferenceOEord("7","3||8")
ClassMethod GetIsReferenceOEord(AEpisodeID As %String, AOEordItemRowID As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AOEordItemRowID = "")) result
	s LisdataReferenceDataID = $o(^DHCEMRI.LisDataReferenceI("IdxEpisodeIDOEordItemID"," "_AEpisodeID," "_AOEordItemRowID,""))		
	if (LisdataReferenceDataID '= "")
	{
    	s result = "1"
	}
	
	q result
}

}
