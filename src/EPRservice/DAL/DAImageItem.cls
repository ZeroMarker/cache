Class EPRservice.DAL.DAImageItem Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod Create(AEImageItem As EPRservice.entity.EImageItem) As %String
{
	s retImageItemID = "0"
	
	s objImageItem = ##Class(EPRmeta.ImageItem).%New()
	q:(objImageItem = "") retImageItemID
	
	s objImageItem.Name = AEImageItem.Name
	s objImageItem.Description = AEImageItem.Description
	s objImageItem.ImageTreeID = AEImageItem.ImageTreeID
	s objImageItem.ImageLibID = AEImageItem.ImageLibID
	s objImageItem.Status = AEImageItem.Status
	s objImageItem.IsPublish = AEImageItem.IsPublish
	d objImageItem.ImageData.CopyFrom(AEImageItem.ImageData)
	d objImageItem.HotSpotData.CopyFrom(AEImageItem.HotSpotData)
	d objImageItem.IconData.CopyFrom(AEImageItem.IconData)
	if (objImageItem.%Save() = "1")
	{
		s retImageItemID = objImageItem.%Id()
	}
	
	//销毁对象
	s objImageItem = ""
	
	q retImageItemID
}

ClassMethod GetEntity(AImageItemID As %String) As EPRservice.entity.EImageItem
{
	s objIamgeItem = ##Class(EPRmeta.ImageItem).%OpenId(AImageItemID)
	q:(objIamgeItem = "") ""
	
	s eImageItem = ##Class(EPRservice.entity.EImageItem).%New()
	s eImageItem.ID = objIamgeItem.%Id()
	s eImageItem.Name = objIamgeItem.Name
	s eImageItem.Description = objIamgeItem.Description
	s eImageItem.ImageTreeID = objIamgeItem.ImageTreeID
	s eImageItem.Status = objIamgeItem.Status
	s eImageItem.IsPublish = objIamgeItem.IsPublish
	d eImageItem.ImageData.CopyFrom(objIamgeItem.ImageData)
	d eImageItem.HotSpotData.CopyFrom(objIamgeItem.HotSpotData)
	d eImageItem.IconData.CopyFrom(objIamgeItem.IconData)
	
	//销毁对象
	s objIamgeItem = ""
	
	q eImageItem
}

ClassMethod Update(AEImageItem As EPRservice.entity.EImageItem) As %Boolean
{
	s updateFlag = "0"
	
	q:(AEImageItem.ID = "") updateFlag
	
	s objImageItem = ##Class(EPRmeta.ImageItem).%OpenId(AEImageItem.ID)
	q:(objImageItem = "") updateFlag
	
	s objImageItem.Name = AEImageItem.Name
	s objImageItem.Description = AEImageItem.Description
	s objImageItem.ImageTreeID = AEImageItem.ImageTreeID
	s objImageItem.Status = AEImageItem.Status
	s objImageItem.IsPublish = AEImageItem.IsPublish
	d objImageItem.ImageData.CopyFrom(AEImageItem.ImageData)
	d objImageItem.HotSpotData.CopyFrom(AEImageItem.HotSpotData)
	d objImageItem.IconData.CopyFrom(AEImageItem.IconData)
	if (objImageItem.%Save() = "1")
	{
		s updateFlag = "1"
	}
	
	//销毁对象
	s objImageItem = ""
	
	q updateFlag
}

ClassMethod DeleteByID(AImageItemID As %String) As %Boolean
{
	s deleteFlag = "0"
	
	q:(AImageItemID = "") deleteFlag
	
	if (##Class(EPRmeta.ImageItem).%ExistsId(AImageItemID))
	{
		if $$$ISOK(##Class(EPRmeta.ImageItem).%DeleteId(AImageLibID))
		{
			s deleteFlag = "1"
		}
	}
	
	q deleteFlag
}

/*
Query GetByImageTreeID(AImageTreeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ImageLibID:%String,ImageTreeID:%String,Status:%String")
{
	select ID, Name, Description, ImageLibID, ImageTreeID, Status
		FROM EPRmeta.ImageItem
		where ImageTreeID = :AImageTreeID
		ORDER BY ID
}
*/
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.DAL.DAImageItem","GetByImageTreeID","3")
Query GetByImageTreeID(AImageTreeID As %String) As %Query(CONTAINID = 0, ROWSPEC = "ID:%String,Name:%String,Description:%String,ImageLibID:%String,ImageTreeID:%String,Status:%String,IsPublish:%String")
{
}

ClassMethod GetByImageTreeIDExecute(ByRef qHandle As %Binary, AImageTreeID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRM.ImageItemI("IdxImageTreeID", AImageTreeID, rowID))
		q:(rowID = "")
		
		s objItem = ##Class(EPRmeta.ImageItem).%OpenId(rowID)
		continue:(objItem = "")
		
		s name = objItem.Name
		s desc = objItem.Description
		s imageLibID = objItem.ImageLibID 
		s imageTreeID = objItem.ImageTreeID
		s status = objItem.Status
		s isPublish = objItem.IsPublish
		
		s Data = $lb(rowID,name,desc,imageLibID,imageTreeID,status,isPublish)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetByImageTreeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetByImageTreeIDExecute ]
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

ClassMethod GetByImageTreeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetByImageTreeIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
