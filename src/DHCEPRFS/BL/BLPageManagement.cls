Class DHCEPRFS.BL.BLPageManagement Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取页码
/// Input：	
/// Output: 页码
ClassMethod GetPageNumber(APageInfoID As %String) As %String
{
	s pageNumber = ""	
	
	s pageInfo = ##Class(DHCEPRFS.INST.CreatePageInfo).%OpenId(APageInfoID)
	q:(pageInfo = "")
		
	s pageNumber = pageInfo.PageNumber
	s isPageQueue = pageInfo.IsQueue
	
	if (isPageQueue = "true"){
		q pageNumber	
	}
	else{
		q "1"	
	}
}

/// Desc:	设置页码
/// Input：	页码
/// Output: 1-成功
/// 		-1-失败
ClassMethod SetPageNumber(APageNumber As %String, APageInfoID As %String) As %String
{
	
	s pageInfo = ##Class(DHCEPRFS.INST.CreatePageInfo).%OpenId(APageInfoID)
	q:(pageInfo = "")
	
	s pageInfo.PageNumber = APageNumber + 1
	
	s sc = pageInfo.%Save()
	d pageInfo.%Close()
	
	q:($$$ISOK(sc)) "1"
	
	q "-1"
}

}
