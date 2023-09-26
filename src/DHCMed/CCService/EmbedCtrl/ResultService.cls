/// 按主题配置查询结果
Class DHCMed.CCService.EmbedCtrl.ResultService Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

ClassMethod GetResultByEpisodeID(ConfigCode As %String, EpisodeID) As %Library.ArrayOfObjects
{
	n (ConfigCode,EpisodeID)
	Set objArry=##class(%ListOfObjects).%New()
	Do objArry.%Close()
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ConfigCode)
	Quit:'$IsObject(objConfig) objArry
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(objConfig.SubjectCode)
	Quit:'$IsObject(objSubject) objArry
	
	Set ItemStoreID=$I(^CacheTemp)
	Set SubCatID=""
	For {
		Set SubCatID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",objConfig.%Id(),SubCatID))
		Quit:SubCatID=""
		Set ItemDic=""
		For {
			Set ItemDic=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",SubCatID,ItemDic))
			Quit:ItemDic=""
			Set SubjectItemID=""
			For {
				Set SubjectItemID=$o(^DHCMed.CCi("SItem",0,"IndexItemDic",objSubject.%Id(),ItemDic,SubjectItemID))
				Quit:SubjectItemID=""
				Set ^CacheTemp(ItemStoreID,"SubjectItem",SubjectItemID)=""
			}
		}
	}
	Set ItmID=""
	For {
		Set ItmID=$o(^CacheTemp(ItemStoreID,"SubjectItem",ItmID))
		Quit:ItmID=""
		Set ResultID=""
		For {
			Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectItemID",EpisodeID,ItmID,ResultID))
			Quit:ResultID=""
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
			Continue:'$IsObject(objResult)
			Do objArry.Insert(objResult)
		}
	}
	Kill ^CacheTemp(ItemStoreID,"SubjectItem")
	Quit objArry
}

/// w ##class(DHCMed.CCService.EmbedCtrl.ResultService).GetResultSubCatByEpisodeID("EPDCC",242)
ClassMethod GetResultSubCatByEpisodeID(ConfigCode As %String, EpisodeID As %String) As %String
{
	n (ConfigCode,EpisodeID)
	Set ret=""
	Set repid=$I(^CacheTemp)
	Set arry=..GetResultByEpisodeID(ConfigCode,EpisodeID)
	For i=1:1:arry.Count() {
		Set objResult=arry.GetAt(i)
		Continue:$IsObject(objResult)=0
		Set objItm=##class(DHCMed.CC.SubjectItm).GetObjById(objResult.ItemId)
		Continue:$IsObject(objItm)=0
		Set objItmDic=##class(DHCMed.CC.ItemDic).GetObjById(objItm.ItemDic)
		Continue:$IsObject(objItmDic)=0
		Set ^CacheTemp(repid,"SubCatID",+objItmDic.IDSubCatDr)=""
	}
	Set SubCatID=""
	For {
		Set SubCatID=$o(^CacheTemp(repid,"SubCatID",SubCatID))
		Quit:SubCatID=""
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatID)
		Continue:$IsObject(objSubCat)=0
		Set:ret'="" ret=ret_"^"
		Set ret=ret_objSubCat.ISCCode
	}
	Quit ret
}

}
