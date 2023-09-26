Class EPRservice.DAL.DAImageLib Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.DAL.DAImageLib","GetImageLibsByCateID","6")
Query GetImageLibsByCateID(ACategoryID As %String) As %Query(CONTAINID = 0, ROWSPEC = "ID,Name,Description,Sequence")
{
}

ClassMethod GetImageLibsByCateIDExecute(ByRef qHandle As %Binary, ACategoryID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(ACategoryID) = "") $$$OK
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRM.ImageLibI("IdxCategoryID",$g(ACategoryID),rowID))
		q:(rowID = "")
		
		s objImageLib = ##Class(EPRmeta.ImageLib).%OpenId(rowID)
		continue:(objImageLib = "")
		
		s name = objImageLib.Name
		s desc = objImageLib.Description
		s sequence = objImageLib.Sequence
		
		s Data = $lb(rowID,name,desc,sequence)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetImageLibsByCateIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetImageLibsByCateIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetImageLibsByCateIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetImageLibsByCateIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
