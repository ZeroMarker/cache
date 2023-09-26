Class EMRservice.BOKBTree Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBTreeInfo";

ClassMethod CreateKBTree(AEKBTree As EMRservice.entity.EKBTree) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBTree).CreateKBTree(AEKBTree)
}

ClassMethod DeleteKBTree(AID As %String) As %Boolean [ WebMethod ]
{
	set objKBTree = ##class(EMRmeta.KBTree).%OpenId(AID)
	if (objKBTree="")
	{Quit ""}
	Quit objKBTree.%DeleteId(AID)
}

ClassMethod SelectALLKBTree(AKnowlodgeBase As %String) As EMRservice.dataset.EKBTreeAllDataset [ WebMethod ]
{
 New result	
 Set result=##class(EMRservice.dataset.EKBTreeAllDataset).%New()
 Do result.SetArgs(AKnowlodgeBase)
 Quit result
}

ClassMethod SelectKBTreeBYID(AID As %String) As EMRservice.entity.EKBTree [ WebMethod ]
{
	set objKBTree = ##class(EMRmeta.KBTree).%OpenId(AID)
	q:(objKBTree="") "" 
 set Result = ##class(EMRservice.entity.EKBTree).%New()
 set Result.ID = objKBTree.%Id()
 set Result.Name = objKBTree.Name
 set Result.ParentID = objKBTree.ParentID
 set Result.Description = objKBTree.Description
 set Result.KnowledgeBaseID = objKBTree.KnowledgeBaseID
 set Result.ResChildCount = objKBTree.ResChildCount
 set Result.PersonalKBUserID=objKBTree.PersonalKBUserID
 Quit Result
}

ClassMethod SelectKBTreeBYPARENTID(APARENTID As %String) As EMRservice.dataset.EKBTreeDataset [ WebMethod ]
{
 New result	
 Set result=##class(EMRservice.dataset.EKBTreeDataset).%New()
 Do result.SetArgs(APARENTID)
 Quit result
}

ClassMethod UpdateKBTree(AEKBTree As EMRservice.entity.EKBTree) As %Boolean [ WebMethod ]
{
	set objKBTree = ##class(EMRmeta.KBTree).%OpenId(AEKBTree.ID)
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
/// Table:EMRservice.BOKBTree
/// Input:树结点ID
/// do ##class(EMRservice.BOKBTree).SaveSequence("56")")
ClassMethod SaveSequence(RowID As %String)
{
	 set objTree= ##class(EMRmeta.KBTree).%OpenId(RowID)
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
/// Table:EMRservice.BOKBTree
/// Input:KBTreeID1树节点1，KBTreeID2树节点2
/// Output:无
/// Return: result是否操作成功
/// do ##class(EMRservice.BOKBTree).SwapSequence("1","2")
ClassMethod SwapSequence(KBtreeID1 As %String, KBtreeID2 As %String) As %Boolean [ WebMethod ]
{
	set result = 0
	set objNextTree = ##class(EMRmeta.KBTree).%OpenId(KBtreeID1)
	set objSelectTree = ##class(EMRmeta.KBTree).%OpenId(KBtreeID2)
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
    quit 0
}

/// Creator:Candy xu
/// CreatDate:2013-03-23
/// Description:删除节点
/// Return: result是否操作成功
/// Desc: d ##class(EMRservice.BOKBTree).DeleteTreeNode("54","1")
ClassMethod DeleteTreeNode(AID As %String, AType As %String) As %String [ WebMethod ]
{
	s Result = "0"
	//标识符号（1 可以删除，-1 不可删除）
	s flag = "1"
	s kbTreeID="",kbNodeID = ""
	for
	{
		s kbTreeID =$o(^DHCEMRM.KBTreeI("IdxParentID"," "_AID,kbTreeID))
		q:(kbTreeID="")
		s objKBTree = ##class(EMRmeta.KBTree).%OpenId(kbTreeID)
		s:(objKBTree'="")&&(objKBTree.IsActive="Y") flag = "-1"
		q:(flag="-1")
	}
	for
	{
		s kbNodeID =$o(^DHCEMRM.KBNodeI("IdxParentID"," "_AID,kbNodeID))
		q:(kbNodeID="")
		s objKBNode = ##class(EMRmeta.KBNode).%OpenId(kbNodeID)
		s:(objKBNode'="")&&(objKBNode.IsInUse="Y") flag = "-1"
		q:(flag="-1")
	}
	if (flag="-1")
	{
        s Result = "2"
	}
	elseif $d(^DHCEMRM.KBTreeD(AID))
	{
		if ..DeleteKBTree(AID) s Result = "1"
	}
	q Result
}

}
