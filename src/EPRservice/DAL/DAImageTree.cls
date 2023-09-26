Class EPRservice.DAL.DAImageTree Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod Create(AEImageTree As EPRservice.entity.EImageTree) As %String
{
	s retImageTreeID = "0"

	s objImageTree = ##Class(EPRmeta.ImageTree).%New()
	s objImageTree.Name = AEImageTree.Name
	s objImageTree.Description = AEImageTree.Description
	s objImageTree.ImageLibID = AEImageTree.ImageLibID
	s objImageTree.ParentID = AEImageTree.ParentID
	s objImageTree.UserID = AEImageTree.UserID

	if $$$ISOK(objImageTree.%Save())
	{
		s retImageTreeID = objImageTree.%Id()
	}
	
	q retImageTreeID
}

ClassMethod GetEntity(AImageTreeID As %String) As EPRservice.entity.EImageTree
{
	s retEImageTree = ""
	
	q:(AImageTreeID = "") retEImageTree
	
	s objImageTree = ##Class(EPRmeta.ImageTree).%OpenId(AImageTreeID)
	q:(objImageTree = "") retEImageTree
	
	s retEImageTree = ##Class(EPRservice.entity.EImageTree).%New()
	s retEImageTree.ID = objImageTree.%Id()
	s retEImageTree.Name = objImageTree.Name
	s retEImageTree.Description = objImageTree.Description
	s retEImageTree.ImageLibID = objImageTree.ImageLibID
	s retEImageTree.ParentID = objImageTree.ParentID
	s retEImageTree.UserID = objImageTree.UserID
	
	//销毁对象
	s objImageTree = ""
	
	q retEImageTree
}

ClassMethod Update(AEImageTree As EPRservice.entity.EImageTree) As %String
{
	s updateFlag = "0"
	
	q:(AEImageTree.ID = "") updateFlag
	
	s objImageTree = ##Class(EPRmeta.ImageTree).%OpenId(AEImageTree.ID)
	q:(objImageTree = "") updateFlag
	
	s objImageTree.Name = AEImageTree.Name
	s objImageTree.Description = AEImageTree.Description
	s objImageTree.ImageLibID = AEImageTree.ImageLibID
	s objImageTree.ParentID = AEImageTree.ParentID
	s objImageTree.UserID = AEImageTree.UserID
	if $$$ISOK(objImageTree.%Save())
	{
		s updateFlag = "1"
	}
	
	s objImageTree = ""
	
	q updateFlag
}

ClassMethod Delete(AImageTreeID As %String) As %Boolean
{
	s deleteFlag = "0"
	
	q:(AImageTreeID = "") deleteFlag
	
	if (##Class(EPRmeta.ImageTree).%ExistsId(AImageTreeID))
	{
		if $$$ISOK(##Class(EPRmeta.ImageTree).%DeleteId(AImageTreeID))
		{
			s deleteFlag = "1"
		}
	}
	
	q deleteFlag
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.DAL.DAImageTree","GetByImageLibID","1")
Query GetByImageLibID(AImageLibID As %String) As %Query(CONTAINID = 0, ROWSPEC = "ID:%String,Name:%String,Description:%String,ImageLibID:%String,ParentID:%String,UserID:%String,Sequence:%String,ChildCount:%String")
{
}

ClassMethod GetByImageLibIDExecute(ByRef qHandle As %Binary, AImageLibID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	for {
		//IdxImageLibID
		s rowID = $o(^DHCEPRM.ImageTreeI("IdxImageLibID", AImageLibID, rowID))
		q:(rowID = "")
		
		s objTree = ##Class(EPRmeta.ImageTree).%OpenId(rowID)
		continue:(objTree = "")
		
		s id =  objTree.%Id()
		s name = objTree.Name
		s desc = objTree.Description
		s imageLibID = objTree.ImageLibID 
		s parentID = objTree.ParentID
		s userID = objTree.UserID
		s sequence = objTree.Sequence
		s childCount = ##Class(EPRservice.BOImageItem).GetChildCountByTreeID(rowID)
		
		s Data = $lb(rowID,name,desc,imageLibID,parentID,userID,sequence,childCount)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetByImageLibIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetByImageLibIDExecute ]
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

ClassMethod GetByImageLibIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetByImageLibIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
