Class EMRservice.BL.BLCommonEleCategory Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,InternalID:%String,Description:%String,Name:%String,ParentID:%String,ResChildCount:%String,TemCode:%String,TemDisplayName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CommonEleC_SELECTALL, SqlProc ]
{
	SELECT ID,InternalID,Description,Name,ParentID,ResChildCount,TemCode,TemDisplayName
	FROM EMRmeta.CommonEleCategory
}

Query SELECTALLByTemCode(aTemCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,InternalID:%String,Description:%String,Name:%String,ParentID:%String,ResChildCount:%String,TemCode:%String,TemDisplayName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CommonEleC_SELECTALLByTemCode, SqlProc ]
{
	SELECT ID,InternalID,Description,Name,ParentID,ResChildCount,TemCode,TemDisplayName
	FROM EMRmeta.CommonEleCategory
	where TemCode = :aTemCode
}

Query SelectByParentID(aParentID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,InternalID:%String,Description:%String,Name:%String,ParentID:%String,ResChildCount:%String,TemCode:%String,TemDisplayName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CommonEleC_SELECTBYID, SqlProc ]
{
	SELECT ID,InternalID,Description,Name,ParentID,ResChildCount,TemCode,TemDisplayName
	FROM EMRmeta.CommonEleCategory
	WHERE ParentID =:aParentID
}

/// 创建一个数据元范畴
ClassMethod CreateCategory(aCommonEleCategory As EMRservice.entity.ECommonEleCategory) As %String [ WebMethod ]
{
	set objCommonEleCategory=##class(EMRmeta.CommonEleCategory).%New()
	quit:(objCommonEleCategory="") ""
	
	set objCommonEleCategory.InternalID=aCommonEleCategory.InternalID
	set objCommonEleCategory.Description=aCommonEleCategory.Description
	set objCommonEleCategory.Name=aCommonEleCategory.Name
	set objCommonEleCategory.ParentID=aCommonEleCategory.ParentID
	set objCommonEleCategory.ResChildCount=aCommonEleCategory.ResChildCount
	set objCommonEleCategory.TemCode = aCommonEleCategory.TemCode
	set objCommonEleCategory.TemDisplayName = aCommonEleCategory.TemDisplayName
	s sc = objCommonEleCategory.%Save()
	if ($$$ISOK(sc))
	{
		quit objCommonEleCategory.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个数据元范畴
ClassMethod DeleteCategoryByID(aTitleId As %String) As %String [ WebMethod ]
{
	q:(aTitleId ="") "-1"
	s objTemStructure = ##Class(EMRmeta.CommonEleCategory).%OpenId(aTitleId)
	q:(objTemStructure="") "-1"
	s sc = ##class(EMRmeta.CommonEleCategory).%DeleteId(aTitleId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个数据元范畴
ClassMethod UpdateCategory(aCommonEleCategory As EMRservice.entity.ECommonEleCategory) As %String [ WebMethod ]
{
	set objCommonEleCategory=##class(EMRmeta.CommonEleCategory).%OpenId(aCommonEleCategory.ID)
	quit:(objCommonEleCategory="") "0"

	
	set objCommonEleCategory.InternalID=aCommonEleCategory.InternalID
	set objCommonEleCategory.Description=aCommonEleCategory.Description
	set objCommonEleCategory.Name=aCommonEleCategory.Name
	set objCommonEleCategory.ParentID=aCommonEleCategory.ParentID
	set objCommonEleCategory.ResChildCount=aCommonEleCategory.ResChildCount
	set objCommonEleCategory.TemCode = aCommonEleCategory.TemCode
	set objCommonEleCategory.TemDisplayName = aCommonEleCategory.TemDisplayName
	s sc = objCommonEleCategory.%Save()
	if ($$$ISOK(sc))
	{

		q (objCommonEleCategory.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// 更新一个ID获取范畴
ClassMethod SelectCategoryByID(aComID As %String) As EMRservice.entity.ECommonEleCategory [ WebMethod ]
{
	s CommonEleCategory = ##Class(EMRservice.entity.ECommonEleCategory).%New()
	set objCommonEleCategory=##class(EMRmeta.CommonEleCategory).%OpenId(aComID)
	quit:(objCommonEleCategory="") CommonEleCategory

	set CommonEleCategory.ID=aComID
	set CommonEleCategory.InternalID=objCommonEleCategory.InternalID
	set CommonEleCategory.Description=objCommonEleCategory.Description
	set CommonEleCategory.Name=objCommonEleCategory.Name
	set CommonEleCategory.ParentID=objCommonEleCategory.ParentID
	set CommonEleCategory.ResChildCount=objCommonEleCategory.ResChildCount
	set CommonEleCategory.TemCode = objCommonEleCategory.TemCode
	set CommonEleCategory.TemDisplayName = objCommonEleCategory.TemDisplayName

	q CommonEleCategory
}

}
