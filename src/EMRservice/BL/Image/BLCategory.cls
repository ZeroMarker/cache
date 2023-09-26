Class EMRservice.BL.Image.BLCategory Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.Image.BLCategory","GetAllImageCategories")
Query GetAllImageCategories() As %Query(CONTAINID = 0, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,ParentID:%String,Sequence:%String,ChildCount:%Integer")
{
}

ClassMethod GetAllImageCategoriesExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.Image.CategoryD(rowID))
		q:(rowID = "")
		
		s objCategory = ##Class(EMRmeta.Image.Category).%OpenId(rowID)
		s Code = objCategory.Code
		s name = objCategory.Name
		s desc = objCategory.Description
		s parentID = objCategory.ParentID
		s Sequence = objCategory.Sequence
		s childCount = 0 //##Class(EMRservice.BOImageLib).GetLibCountByCateID(rowID)
		
		s Data = $lb(rowID,Code,name,desc,parentID,Sequence,childCount)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetAllImageCategoriesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllImageCategoriesExecute ]
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

ClassMethod GetAllImageCategoriesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllImageCategoriesExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:	yejian
/// CreatDate:	2011-09-16
/// Desc:		创建图库目录
/// Table：		EMRservice.entity.Image.ECategory
/// Input：		AECategory为图库目录实体对象
/// Return：	图库目录RowID	
ClassMethod CreateImageCategory(AECategory As EMRservice.entity.Image.ECategory) As %String
{
	TStart
	s ret = 1
	s objCategory = ##Class(EMRmeta.Image.Category).%New()
	s objCategory.Code = AECategory.Code
	s objCategory.Name = AECategory.Name
	s objCategory.Description = AECategory.Description
	s objCategory.ParentID = AECategory.ParentID
	if (objCategory.%Save())
	{		
		s ret=objCategory.%Id()
		s objCategory.Sequence=ret
		if (objCategory.%Save())
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
	d objCategory.%Close()	
	k objCategory
	q ret
}

/// Creator:	yejian
/// CreatDate:	2011-10-14
/// Desc:		删除图库目录
/// Table：		EMRservice.entity.Image.ECategory
/// Input：		ACategoryID为图库目录RowID
/// Return：	删除成功返回1，否则返回0
ClassMethod DeleteImageCategory(ACategoryID As %String) As %Boolean
{
	s objCategory = ##Class(EMRmeta.Image.Category).%OpenId(ACategoryID)
	if '(objCategory.%DeleteId(ACategoryID))
	{
 		q 0
	}
 	q 1
}

/// Creator:	yejian
/// CreatDate:	2011-10-14
/// Desc:		修改图库目录
/// Table：		EMRservice.entity.Image.ECategory
/// Input：		AECategory为图库目录实体对象
/// Return：	修改成功返回1，否则返回0
ClassMethod UpdateImageCategory(AECategory As EMRservice.entity.Image.ECategory) As %Boolean
{
	s objCategory = ##Class(EMRmeta.Image.Category).%OpenId(AECategory.ID)
	q:(objCategory = "") 0
	s objCategory.Code = AECategory.Code
	s objCategory.Name = AECategory.Name
	s objCategory.ParentID=  AECategory.ParentID
	s objCategory.Description = AECategory.Description

	 if '(objCategory.%Save()) {
		q 0
	 } 
	 q 1
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
		s objCate=##class(EMRmeta.Image.Category).%OpenId(argCateID)
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
	
	&sql(select id into :IdexCode   from EMRmeta_Image.Category where Code=:Acode)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

}
