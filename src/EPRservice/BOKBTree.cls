Class EPRservice.BOKBTree Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBTreeInfo";

ClassMethod CreateKBTree(AEKBTree As EPRservice.entity.EKBTree) As %String [ WebMethod ]
{
 set objKBTree = ##class(EPRmeta.KBTree).%New()
 Quit:(objKBTree ="") "" 
 set objKBTree.Name = AEKBTree.Name
 set objKBTree.ParentID = AEKBTree.ParentID
 set objKBTree.Description = AEKBTree.Description
 set objKBTree.KnowledgeBaseID = AEKBTree.KnowledgeBaseID
 set objKBTree.ResChildCount = 0
 set objKBTree.PersonalKBUserID=AEKBTree.PersonalKBUserID
 Do objKBTree.%Save()
 Do ..SaveSequence(objKBTree.%Id())
	Quit objKBTree.%Id()
}

ClassMethod DeleteKBTree(AID As %String) As %Boolean [ WebMethod ]
{
	set objKBTree = ##class(EPRmeta.KBTree).%OpenId(AID)
	if (objKBTree="")
	{Quit ""}
	Quit objKBTree.%DeleteId(AID)
}

ClassMethod SelectALLKBTree(AKnowlodgeBase As %String) As EPRservice.dataset.EKBTreeAllDataset [ WebMethod ]
{
 New result	
 Set result=##class(EPRservice.dataset.EKBTreeAllDataset).%New()
 Do result.SetArgs(AKnowlodgeBase)
 Quit result
}

ClassMethod SelectKBTreeBYID(AID As %String) As EPRservice.entity.EKBTree [ WebMethod ]
{
	set objKBTree = ##class(EPRmeta.KBTree).%OpenId(AID)
	q:(objKBTree="") "" 
 set Result = ##class(EPRservice.entity.EKBTree).%New()
 set Result.ID = objKBTree.%Id()
 set Result.Name = objKBTree.Name
 set Result.ParentID = objKBTree.ParentID
 set Result.Description = objKBTree.Description
 set Result.KnowledgeBaseID = objKBTree.KnowledgeBaseID
 set Result.ResChildCount = objKBTree.ResChildCount
 set Result.PersonalKBUserID=objKBTree.PersonalKBUserID
 Quit Result
}

ClassMethod SelectKBTreeBYPARENTID(APARENTID As %String) As EPRservice.dataset.EKBTreeDataset [ WebMethod ]
{
 New result	
 Set result=##class(EPRservice.dataset.EKBTreeDataset).%New()
 Do result.SetArgs(APARENTID)
 Quit result
}

ClassMethod UpdateKBTree(AEKBTree As EPRservice.entity.EKBTree) As %Boolean [ WebMethod ]
{
	set objKBTree = ##class(EPRmeta.KBTree).%OpenId(AEKBTree.ID)
 set objKBTree.Name = AEKBTree.Name
 set objKBTree.Description = AEKBTree.Description
 set objKBTree.ParentID = AEKBTree.ParentID
 set objKBTree.KnowledgeBaseID = AEKBTree.KnowledgeBaseID
 set objKBTree.PersonalKBUserID = AEKBTree.PersonalKBUserID
 Quit objKBTree.%Save()
}

/// creator:Candy xu 
/// CreatDate:2011-05-25
/// Description:存储顺序号
/// Table:EPRservice.BOKBTree
/// Input:树结点ID
/// do ##class(EPRservice.BOKBTree).SaveSequence("56")")
ClassMethod SaveSequence(RowID As %String)
{
	 set objTree= ##class(EPRmeta.KBTree).%OpenId(RowID)
	 if (objTree '="")
	 {
	    set objTree.Sequence=objTree.%Id()
	    do objTree.%Save()
	    do objTree.%Close()	

	 }
     set objTree=""
}

/// creator:Candy xu 
/// CreatDate:2011-05-24
/// Description:修改树节点排序顺序号
/// Table:EPRservice.BOKBTree
/// Input:KBTreeID1树节点1，KBTreeID2树节点2
/// Output:无
/// Return: result是否操作成功
/// do ##class(EPRservice.BOKBTree).SwapSequence("1","2")
ClassMethod SwapSequence(KBtreeID1 As %String, KBtreeID2 As %String) As %Boolean [ WebMethod ]
{
	set result = 0
	set objNextTree = ##class(EPRmeta.KBTree).%OpenId(KBtreeID1)
	set objSelectTree = ##class(EPRmeta.KBTree).%OpenId(KBtreeID2)
	quit:((objNextTree = "")||(objSelectTree = "")) result
	
	set TempSequence = objNextTree.Sequence
	set objNextTree.Sequence = objSelectTree.Sequence
	set objSelectTree.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	Tstart
	set scResult=objNextTree.%Save() 
	if $$$ISERR(scResult)
	{
		Trollback
		quit result
	}
	set scResultSele=objSelectTree.%Save() 
	if $$$ISERR(objSelectTree)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 do objSelectTree.%Close()
	 do objNextTree.%Close()
	 set objSelectTree = ""
	 set objNextTree = ""
	 set result = 1
	 quit result
	 
SwapErrorHandler
    quit:0
}

/// Creator:Candy xu
/// CreatDate:2013-03-23
/// Description:删除节点
/// Return: result是否操作成功
/// Desc: d ##class(EPRservice.BOKBTree).DeleteTreeNode("54","1")
ClassMethod DeleteTreeNode(AID As %String, AType As %String) As %String [ WebMethod ]
{
	s Result = "0"
	if ($d(^DHCEPRM.KBNodeI("IdxKBTreeID"," "_AID)) || $d(^DHCEPRM.KBTreeI("IdxParentID"," "_AID)))
	{
        s Result = "2"
	}
	elseif $d(^DHCEPRM.KBTreeD(AID))
	{
		if ..DeleteKBTree(AID) s Result = "1"
	}
	q Result
}

}
