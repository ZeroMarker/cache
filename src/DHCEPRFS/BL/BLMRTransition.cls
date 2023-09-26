Class DHCEPRFS.BL.BLMRTransition Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取操作后的状态(如果从初始状态经过某一操作后在状态转表中没有装换记录，返回初始状态)
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRTransition).GetPostStatus("INITIALIZED","CREATERECORD")
ClassMethod GetPostStatus(APrevStatusCode, AMRActionCode) As %String
{
	s postStatusCode = $O(^DHCEPRFS.META.MRTransitionI("IdxTrans"," 1"," "_APrevStatusCode," "_AMRActionCode,""))
	q:(postStatusCode="") APrevStatusCode
	s postStatusCode = $E(postStatusCode,2,$L(postStatusCode))
	q postStatusCode
}

/// Desc:	获取操作后的状态(如果从初始状态经过某一操作后在状态转表中没有装换记录，返回空值)
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRTransition).GetPostStatus("INITIALIZED","CREATERECORD")
ClassMethod GetStdPostStatus(APrevStatusCode, AMRActionCode) As %String
{
}

/// Desc:	获取操作后的状态(如果从初始状态经过某一操作后在状态转表中没有装换记录，返回初始状态)
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRTransition).GetPagePostStatus("INITIALIZED","CREATE","1")
ClassMethod GetPagePostStatus(APrevStatusCode, AMRActionCode, AMREpisodeID) As %String
{
	//b "s"
	if (APrevStatusCode="")||(APrevStatusCode=$c(0)) 
	{	s tmpPrevStatusCode = "INITIALIZED"}
	else
	{	s tmpPrevStatusCode = APrevStatusCode}
	
	s postStatusCode = $O(^DHCEPRFS.META.MRTransPageI("IdxTrans"," 1"," "_tmpPrevStatusCode," "_AMRActionCode,""))
	q:(postStatusCode="") APrevStatusCode
	
	s rowID = $O(^DHCEPRFS.META.MRTransPageI("IdxTrans"," 1"," "_tmpPrevStatusCode," "_AMRActionCode,postStatusCode,""))
	s indexData = $g(^DHCEPRFS.META.MRTransPageI("IdxTrans"," 1"," "_tmpPrevStatusCode," "_AMRActionCode,postStatusCode,rowID))
	s isExecConditionOK = ..IsExecConditionOK($lg(indexData,2),AMREpisodeID)
	q:(isExecConditionOK = "0") APrevStatusCode
	
	s postStatusCode = $E(postStatusCode,2,$L(postStatusCode))
	q postStatusCode
}

ClassMethod IsPageAction(AMRActionCode As %String, APageStatus As %String = "") As %String
{
	s:(APageStatus="")||(APageStatus=$c(0)) APageStatus = "INITIALIZED"
	
	q:(AMRActionCode="REVIEW")&&(APageStatus="INITIALIZED") "1"
	q:(AMRActionCode="SCAN") "1"
	q:(AMRActionCode="ARRANGE") "1"
	q:(AMRActionCode="REPLACE") "1"
	q:(AMRActionCode="CONFIRMSCAN") "1"
	q "0"
}

/// w ##Class(DHCEPRFS.BL.BLMRTransition).IsExecConditionOK("1","1")
ClassMethod IsExecConditionOK(AExecCondition As %String, AMREpisodeID As %String) As %Boolean
{
	q:(AExecCondition = "") "1"
	
	if (AExecCondition = "1")
	{
		//要求：未分类的扫描项目张数 > 0
		s hasUnArranged = ..HasUnArrangedItem(AMREpisodeID)
		q hasUnArranged
	}
	else
	{
		q "1"
	}
}

/// w ##Class(DHCEPRFS.BL.BLMRTransition).HasUnArrangedItem("1")
ClassMethod HasUnArrangedItem(AMREpisodeID As %String) As %Boolean
{
	q:(AMREpisodeID="") "0"
	
	s ret = ##class(DHCEPRFS.BL.BLFileTemporary).HasScanFile(AMREpisodeID)
	q:(ret = "1") "1"
	
	s psItemID = ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType("PS","0")
	q:(psItemID="") "0"
	
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(AMREpisodeID,"0","")
	q:(mrVersionID="") "0"
		
	s mrVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetMRVerItemID(mrVersionID,psItemID)
	q:(mrVerItemID="") "0"
	
	s obj = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
	q:(obj="") "0"
	
	q obj.TotCount > 0
}

}
