Class DHCEPRSearch.BL.BLFavorites Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRSearch.BL.BLFavorites).Create(3,6,159,"","","")
ClassMethod Create(AMREpisodeID As %String, AMRVerItemID As %String, AUserID As %String, ADocName As %String, ANotes As %String, ATags As %String) As %String
{
	s obj = ##Class(DHCEPRSearch.INST.Favorites).%New()
	s obj.MREpisodeID = AMREpisodeID
	s obj.MRVerItemID = AMRVerItemID
	s obj.UserID = AUserID
	s obj.DocName = ADocName
	s obj.Notes = ANotes
	s obj.Tags = ATags
	s obj.CategoryID = ""
	s obj.AddDate = $p($h,",",1)
	s obj.AddTime = $p($h,",",2)
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod DeleteFavorites(AFavoritesID As %String)
{
	s ret = "0"
	q:(AFavoritesID = "") ret
	s sc = ##class(DHCEPRSearch.INST.Favorites).%DeleteId(AFavoritesID)
	if ($$$ISOK(sc))
	{
		s ret = "1"
	}
	q ret
}

ClassMethod Check(AMREpisodeID As %String, AMRVerItemID As %String, AUserID As %String)
{
	s count = 0
	&sql(select count(*) into :count from DHCEPRSearch_INST.Favorites where UserID=:AUserID AND MREpisodeID=:AMREpisodeID AND MRVerItemID=:AMRVerItemID)
	q count
}

}
