Class EPRservice.BLL.BLPrintPageNumber Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:	获取页码
/// Input：	
/// Output: 页码
ClassMethod GetPageNumber(APageInfoID As %String) As %String
{
	s pageNumber = ""	
	
	s pageInfo = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%OpenId(APageInfoID)
	q:(pageInfo = "") "1"
		
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
	
	s pageInfo = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%OpenId(APageInfoID)
	q:(pageInfo = "") "-1"
	
	s pageInfo.PageNumber = APageNumber + 1
	
	s sc = pageInfo.%Save()
	d pageInfo.%Close()
	
	q:($$$ISOK(sc)) "1"
	
	q "-1"
}

}
