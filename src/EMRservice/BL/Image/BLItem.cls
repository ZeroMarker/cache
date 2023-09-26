Class EMRservice.BL.Image.BLItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Create(AEImageItem As EMRservice.entity.Image.EItem) As %String
{
	TStart
	s ret = 1
	
	s objImageItem = ##Class(EMRmeta.Image.Item).%New()
	q:(objImageItem = "") retImageItemID
	
	s objImageItem.Code = AEImageItem.Code
	s objImageItem.Name = AEImageItem.Name
	s objImageItem.Description = AEImageItem.Description
	s objImageItem.CategoryID = AEImageItem.CategoryID
	s objImageItem.IsPublish = AEImageItem.IsPublish
	s objImageItem.ImageType = AEImageItem.ImageType
	d objImageItem.ImageData.CopyFrom(AEImageItem.ImageData)
	//d objImageItem.HotSpotData.CopyFrom(AEImageItem.HotSpotData)
	//d objImageItem.IconData.CopyFrom(AEImageItem.IconData)
	
	if (objImageItem.%Save())
	{		
		s ret=objImageItem.%Id()
		s objImageItem.Sequence=ret
		if (objImageItem.%Save())
		{
			 TCommit
		}
		else
		{
			TRollback
			s ret=-1
		}
	}
	else
	{
		TRollback
		s ret=-1
	}
	d objImageItem.%Close()	
	k objImageItem
	q ret
}

ClassMethod GetEntity(AImageItemID As %String) As EMRservice.entity.Image.EItem
{
	s objIamgeItem = ##Class(EMRmeta.Image.Item).%OpenId(AImageItemID)
	q:(objIamgeItem = "") ""
	
	s eImageItem = ##Class(EMRservice.entity.Image.EItem).%New()
	s eImageItem.ID = objIamgeItem.%Id()
	s eImageItem.Code = objIamgeItem.Code
	s eImageItem.Name = objIamgeItem.Name
	s eImageItem.Description = objIamgeItem.Description
	s eImageItem.CategoryID = objIamgeItem.CategoryID
	s eImageItem.ImageType = objIamgeItem.ImageType
	s eImageItem.IsPublish = objIamgeItem.IsPublish
	s eImageItem.Sequence = objIamgeItem.Sequence
	d eImageItem.ImageData.CopyFrom(objIamgeItem.ImageData)
	//d eImageItem.HotSpotData.CopyFrom(objIamgeItem.HotSpotData)
	//d eImageItem.IconData.CopyFrom(objIamgeItem.IconData)
	
	//销毁对象
	s objIamgeItem = ""
	
	q eImageItem
}

ClassMethod Update(AEImageItem As EMRservice.entity.Image.EItem) As %Boolean
{
	s updateFlag = "0"
	
	q:(AEImageItem.ID = "") updateFlag
	
	s objImageItem = ##Class(EMRmeta.Image.Item).%OpenId(AEImageItem.ID)
	q:(objImageItem = "") updateFlag
	s objImageItem.Code = AEImageItem.Code
	s objImageItem.Name = AEImageItem.Name
	s objImageItem.Description = AEImageItem.Description
	s objImageItem.CategoryID = AEImageItem.CategoryID
	s objImageItem.ImageType = AEImageItem.ImageType
	s objImageItem.IsPublish = AEImageItem.IsPublish
	d objImageItem.ImageData.CopyFrom(AEImageItem.ImageData)
	//d objImageItem.HotSpotData.CopyFrom(AEImageItem.HotSpotData)
	//d objImageItem.IconData.CopyFrom(AEImageItem.IconData)
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
	
	if (##Class(EMRmeta.Image.Item).%ExistsId(AImageItemID))
	{
		if $$$ISOK(##Class(EMRmeta.Image.Item).%DeleteId(AImageItemID))
		{
			s deleteFlag = "1"
		}
	}
	
	q deleteFlag
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.DAL.DAImageItem","GetByImageTreeID","3")
Query GetByImageTreeID(AImageCatID As %String) As %Query(CONTAINID = 0, ROWSPEC = "ID:%String,Code:%String,Name:%String,Description:%String,CategoryID:%String,Sequence:%String,ImageType:%String,IsPublish:%String")
{
}

ClassMethod GetByImageTreeIDExecute(ByRef qHandle As %Binary, AImageCatID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.Image.ItemI("IdxCategoryID"," "_AImageCatID, rowID))		
		q:(rowID = "")		
		s objItem = ##Class(EMRmeta.Image.Item).%OpenId(rowID)
		continue:(objItem = "")	
		s Code = objItem.Code	
		s name = objItem.Name
		s desc = objItem.Description
		s CategoryID = objItem.CategoryID
		s Sequence = objItem.Sequence
		s ImageType = objItem.ImageType 
		s isPublish = objItem.IsPublish
		
		
		s Data = $lb(rowID,Code,name,desc,CategoryID,Sequence,ImageType,isPublish)
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

/// Debug:	w ##Class(EMRservice.BOImageItem).GetChildCountByTreeID()
ClassMethod GetItemsByTreeID(AImageCatID As %String) As EMRservice.entity.Image.Items
{
	s objItems = ##Class(EMRservice.entity.Image.Items).%New()
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.Image.ItemI("IdxCategoryID"," "_AImageCatID, rowID))		
		q:(rowID = "")		
		s objItem = ##Class(EMRmeta.Image.Item).%OpenId(rowID)
		s objEItem = ##Class(EMRservice.entity.Image.EItem).%New()
		continue:(objItem = "")		
		s objEItem.ID = rowID
		s objEItem.Code = objItem.Code
		s objEItem.Name = objItem.Name
		s objEItem.Description = objItem.Description
		s objEItem.CategoryID = objItem.CategoryID
		s objEItem.Sequence = objItem.Sequence
		s objEItem.ImageType = objItem.ImageType 
		s objEItem.IsPublish = objItem.IsPublish
		d objEItem.ImageData.CopyFrom(objItem.ImageData)
		d objItems.Item.Insert(objEItem)
		
	}
	
	q objItems
}

/// Debug:	w ##Class(EMRservice.BOImageItem).GetChildCountByTreeID()
ClassMethod GetChildCountByTreeID(AImageCatID As %String) As %String
{
	s count = 0
	&sql(SELECT COUNT(*) INTO :count FROM EMRmeta_Image.Item WHERE CategoryID = :AImageCatID)
	q count
}

/// Debug:	w ##Class(EMRservice.BL.Image.BLItem).CheckImageItemPublished(8,"ci")
ClassMethod CheckImageItemPublished(AFigureID As %String, AFigureType As %String) As %String
{
	s ret = 0
	q:($g(AFigureID) = "")||($g(AFigureType) = "") ret
	
	s isPublished = 0
	if ($zcvt(AFigureType,"U") = "CI")
	{
		&sql(SELECT IsPublish INTO :isPublished FROM EMRmeta_Image.Item WHERE ID = :AFigureID)
	}
	else
	{
		//&sql(SELECT IsPublish INTO :isPublished FROM EMRinstance.AdmImageItem WHERE ID = :AFigureID)	
	}
	s:(isPublished = "") isPublished = 0
	q isPublished
}

/// 更新一个数据元范畴
ClassMethod UpdateSequences(argStr As %String) As %String
{
	
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		B
		S argstrItem= $P(argStr,",",I)
		S argCateID = $P(argstrItem,"^",1)
		S argCateSeq = $P(argstrItem,"^",2)
		if ($d(argCateID)=0)||($d(argCateSeq)=0)||(argCateID="")||(argCateSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objCate="",result=""
		s objCate=##class(EMRmeta.Image.Item).%OpenId(argCateID)
		if (objCate ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objCate.Sequence=argCateSeq
		s result=""
		if '(objCate.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 判断code编号是否存在
ClassMethod CheckCodeExist(Acode As %String) As %String
{
	
	&sql(select id into :IdexCode   from EMRmeta_Image.Item where Code=:Acode)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// Desc:        批量更新图片状态
/// Creator:     yejian
/// Createdate:  2022-7-26
/// Input:       ACategoryID 图片目录ID，AStatue 发布状态(0:未发布;1:已发布)
/// Return:      1 成功，-1 失败
/// Others:   
ClassMethod UpPublish(ACategoryID As %String, AStatue As %String) As %String
{
	s strRes = "1"
	&sql(update EMRmeta_Image.Item set IsPublish =:AStatue where CategoryID=:ACategoryID)
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		s strRes ="-1"
	}
	q strRes
}

}
